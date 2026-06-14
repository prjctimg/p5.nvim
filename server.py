#!/usr/bin/env python3
"""
asyncio-based live server with SSE console streaming.
"""
import asyncio
import os
import re
import json
import signal
import sys
from collections import deque
from datetime import datetime
from pathlib import Path
from typing import Optional
import websockets
import websockets.exceptions

# Configuration
def _parse_config(args=None):
    """Parse CLI args into CONFIG dict."""
    if args is None:
        args = sys.argv[1:]
    cfg = {
        "port": 8000,
        "live_reload": {
            "enabled": True,
            "port": 12002,
            "debounce_ms": 300,
            "watch_extensions": [".js", ".css", ".html", ".json"],
            "exclude_dirs": [".git", "node_modules", "dist", "build"],
        },
        "console": {
            "buffer_size": 1000,
            "heartbeat_interval": 15,
        },
        "cdp": {
            "enabled": False,
            "remote_debugging_port": 9222,
        }
    }
    i = 0
    while i < len(args):
        if args[i] == "--lr-port" and i + 1 < len(args):
            cfg['live_reload']['port'] = int(args[i + 1])
            i += 2
        elif args[i] == "--lr-debounce" and i + 1 < len(args):
            cfg['live_reload']['debounce_ms'] = int(args[i + 1])
            i += 2
        elif args[i] == "--lr-extensions" and i + 1 < len(args):
            cfg['live_reload']['watch_extensions'] = args[i + 1].split(',')
            i += 2
        elif args[i] == "--lr-exclude" and i + 1 < len(args):
            cfg['live_reload']['exclude_dirs'] = args[i + 1].split(',')
            i += 2
        elif args[i] == "--lr-disabled":
            cfg['live_reload']['enabled'] = False
            i += 1
        elif args[i].startswith('--'):
            i += 1
        else:
            cfg['port'] = int(args[i])
            i += 1
    return cfg

CONFIG = _parse_config()

# ANSI color codes for log formatting
ANSI_COLORS = {
    'reset': '\033[0m',
    'error': '\033[1;31m',
    'warn': '\033[1;33m',
    'info': '\033[1;36m',
    'log': '\033[0;37m',
    'timestamp': '\033[0;90m',
    'source': '\033[0;90m',
}

EMOJI_MAP = {
    'ERROR': '❌',
    'WARN': '⚠️ ',
    'INFO': 'ℹ️ ',
    'LOG': '📝',
    'HEARTBEAT': '💓',
}


def format_log_entry(level: str, message: str, source: str = "browser") -> str:
    """Format a log entry with ANSI colors and emojis for terminal display."""
    timestamp = datetime.now().strftime("%H:%M:%S")
    level = level.lower()
    
    emoji = EMOJI_MAP.get(level, '📝')
    level_color = ANSI_COLORS.get(level.lower(), ANSI_COLORS['log'])
    time_color = ANSI_COLORS['timestamp']
    source_color = ANSI_COLORS['source']
    reset = ANSI_COLORS['reset']
    
    return (
        f"{time_color}[{timestamp}]{reset} "
        f"{emoji} "
        f"{level_color}{level:5}{reset} "
        f"{source_color}[{source}]{reset}: {message}"
    )


async def try_start_server(handler, host, port, max_attempts=10):
    for offset in range(max_attempts):
        try:
            server = await asyncio.start_server(handler, host, port + offset)
            return server, port + offset
        except OSError:
            continue
    raise OSError(f"No available port near {port}")


def read_inject_script(name):
    path = Path(__file__).parent / "assets" / "inject" / name
    if path.is_file():
        return path.read_text()
    return ""


INJECT_CONSOLE = read_inject_script("console.js")
INJECT_LIVERELOAD = read_inject_script("livereload.js")


class ConsoleBuffer:
    """Ring buffer for console logs with configurable size."""
    
    def __init__(self, max_size: int = 1000):
        self.buffer = deque(maxlen=max_size)
        self.max_size = max_size
    
    def append(self, entry: dict):
        """Add entry to buffer."""
        self.buffer.append(entry)
    
    def get_all(self) -> list:
        """Get all entries and clear buffer."""
        entries = list(self.buffer)
        self.buffer.clear()
        return entries
    
    def __len__(self):
        return len(self.buffer)


async def http_get(host, port, path):
    """Simple async HTTP GET for CDP page discovery."""
    try:
        reader, writer = await asyncio.open_connection(host, port)
    except (OSError, ConnectionRefusedError):
        return None
    request = f'GET {path} HTTP/1.1\r\nHost: {host}:{port}\r\nConnection: close\r\n\r\n'
    writer.write(request.encode())
    await writer.drain()
    while True:
        line = await reader.readline()
        if line == b'\r\n' or not line:
            break
    body = await reader.read()
    writer.close()
    await writer.wait_closed()
    return body.decode()


class CDPClient:
    """Chrome DevTools Protocol client via WebSocket."""

    def __init__(self, cdp_port: int):
        self.cdp_port = cdp_port
        self.ws = None
        self.page_url = ''
        self.connected = False
        self._msg_id = 0
        self._pending = {}
        self._recv_task: Optional[asyncio.Task] = None
        self.event_buffer = deque(maxlen=2000)
        self.pending_requests = {}
        self.completed_requests = deque(maxlen=500)
        self._scripts = {}
        self._perf_task: Optional[asyncio.Task] = None
        self._perf_metrics = deque(maxlen=300)

    def _next_id(self):
        self._msg_id += 1
        return self._msg_id

    def _emit(self, event_type: str, data: dict):
        self.event_buffer.append((event_type, data))

    def drain_events(self):
        events = list(self.event_buffer)
        self.event_buffer.clear()
        return events

    def get_network_log(self):
        return list(self.completed_requests)

    def clear_network_log(self):
        self.completed_requests.clear()

    async def connect(self):
        body = await http_get('localhost', self.cdp_port, '/json')
        if body is None:
            raise ConnectionError(f"No CDP endpoint at localhost:{self.cdp_port}")
        pages = json.loads(body)
        pages = [p for p in pages if p.get('type') == 'page']
        if not pages:
            raise ConnectionError("No debuggable pages found")
        page = pages[0]
        ws_url = page['webSocketDebuggerUrl']
        self.page_url = page.get('url', '')
        self.ws = await websockets.connect(ws_url, max_size=2 ** 24)
        self.connected = True
        self._recv_task = asyncio.create_task(self._message_loop())
        await self.send_command('Runtime.enable')
        await self.send_command('Network.enable')
        await self.send_command('Debugger.enable')
        await self.send_command('Performance.enable')
        self._perf_task = asyncio.create_task(self._perf_loop())
        self._emit('status', {'state': 'connected', 'url': self.page_url})

    async def _perf_loop(self):
        """Sample performance metrics every second via CDP."""
        try:
            while self.connected:
                await asyncio.sleep(1)
                if not self.connected:
                    break
                try:
                    result = await self.send_command('Runtime.evaluate', {
                        'expression': 'Math.round(performance.now())',
                        'returnByValue': True,
                    })
                    perf_data = {'fps': 60}
                    mem_result = await self.send_command('Runtime.evaluate', {
                        'expression': '(performance.memory && performance.memory.usedJSHeapSize) || 0',
                        'returnByValue': True,
                    })
                    if mem_result and 'result' in mem_result:
                        val = mem_result['result'].get('value', 0)
                        perf_data['heap'] = val
                    nodes_result = await self.send_command('Runtime.evaluate', {
                        'expression': 'document.querySelectorAll("*").length',
                        'returnByValue': True,
                    })
                    if nodes_result and 'result' in nodes_result:
                        perf_data['nodes'] = nodes_result['result'].get('value', 0)
                    self._emit('perf', perf_data)
                except Exception:
                    pass
        except asyncio.CancelledError:
            pass

    async def disconnect(self):
        self.connected = False
        if self._perf_task:
            self._perf_task.cancel()
            try:
                await self._perf_task
            except asyncio.CancelledError:
                pass
        if self._recv_task:
            self._recv_task.cancel()
            try:
                await self._recv_task
            except asyncio.CancelledError:
                pass
        if self.ws:
            await self.ws.close()
        self.ws = None
        self._pending.clear()
        self._emit('status', {'state': 'disconnected'})

    async def send_command(self, method: str, params: Optional[dict] = None):
        if not self.connected or not self.ws:
            raise RuntimeError("CDP not connected")
        msg_id = self._next_id()
        msg = {'id': msg_id, 'method': method}
        if params:
            msg['params'] = params
        future = asyncio.get_event_loop().create_future()
        self._pending[msg_id] = future
        await self.ws.send(json.dumps(msg))
        try:
            return await asyncio.wait_for(future, timeout=30)
        except asyncio.TimeoutError:
            self._pending.pop(msg_id, None)
            raise TimeoutError(f"CDP command {method} timed out")

    async def evaluate(self, expression: str):
        result = await self.send_command('Runtime.evaluate', {
            'expression': expression,
            'returnByValue': True,
            'includeCommandLineAPI': True,
        })
        return result

    async def set_breakpoint(self, location: str):
        parts = location.rsplit(':', 1)
        if len(parts) != 2:
            raise ValueError("Use format: file.js:line")
        url, line = parts[0], int(parts[1])
        try:
            return await self.send_command('Debugger.setBreakpointByUrl', {
                'url': url,
                'lineNumber': line - 1,
            })
        except Exception:
            sid = self._scripts.get(url)
            if sid:
                return await self.send_command('Debugger.setBreakpoint', {
                    'location': {'scriptId': sid, 'lineNumber': line - 1},
                })
            raise

    async def resume(self):
        await self.send_command('Debugger.resume')

    async def step_over(self):
        await self.send_command('Debugger.stepOver')

    async def step_into(self):
        await self.send_command('Debugger.stepInto')

    async def step_out(self):
        await self.send_command('Debugger.stepOut')

    async def _message_loop(self):
        assert self.ws is not None
        try:
            async for message in self.ws:
                try:
                    data = json.loads(message)
                    await self._handle_message(data)
                except json.JSONDecodeError:
                    continue
        except websockets.exceptions.ConnectionClosed:
            self.connected = False
            self._emit('status', {'state': 'disconnected'})
        except asyncio.CancelledError:
            pass

    async def _handle_message(self, data: dict):
        if 'id' in data:
            future = self._pending.pop(data['id'], None)
            if future and not future.done():
                if 'error' in data:
                    future.set_exception(
                        Exception(data['error'].get('message', 'CDP error'))
                    )
                else:
                    future.set_result(data.get('result', {}))
            return
        method = data.get('method', '')
        params = data.get('params', {})
        if method == 'Runtime.consoleAPICalled':
            await self._handle_console_api(params)
        elif method == 'Runtime.exceptionThrown':
            await self._handle_exception(params)
        elif method == 'Network.requestWillBeSent':
            self._handle_request_sent(params)
        elif method == 'Network.responseReceived':
            self._handle_response(params)
        elif method == 'Network.loadingFailed':
            self._handle_load_failed(params)
        elif method == 'Debugger.scriptParsed':
            self._scripts[params.get('url', '')] = params.get('scriptId', '')
        elif method == 'Debugger.paused':
            await self._handle_paused(params)
        elif method == 'Debugger.resumed':
            self._emit('debugger', {'event': 'resumed'})
        elif method == 'Performance.metrics':
            self._handle_perf(params)
        elif method == 'Timeline.eventRecorded':
            pass

    async def _handle_console_api(self, params: dict):
        level_map = {
            'warning': 'warn', 'error': 'error',
            'debug': 'log', 'info': 'info', 'log': 'log',
        }
        level = level_map.get(params.get('level', 'log'), 'log')
        args = params.get('args', [])
        messages = []
        for a in args:
            t = a.get('type', '')
            if t == 'string':
                messages.append(a.get('value', ''))
            elif t == 'object':
                messages.append(a.get('description', ''))
            elif t == 'number' or t == 'boolean':
                messages.append(str(a.get('value', '')))
            else:
                messages.append(a.get('description', str(a.get('value', ''))))
        message = ' '.join(messages)
        stack = []
        if 'stackTrace' in params:
            for f in params['stackTrace'].get('callFrames', []):
                stack.append({
                    'function': f.get('functionName', '<anon>'),
                    'url': f.get('url', ''),
                    'line': f.get('lineNumber', 0) + 1,
                    'column': f.get('columnNumber', 0) + 1,
                })
        self._emit('console', {
            'level': level, 'message': message,
            'timestamp': datetime.now().strftime('%H:%M:%S'),
            'stack': stack,
        })

    async def _handle_exception(self, params: dict):
        ed = params.get('exceptionDetails', {})
        exc = ed.get('exception', {})
        msg = exc.get('description', exc.get('value', 'Unknown error'))
        stack = []
        for f in ed.get('stackTrace', {}).get('callFrames', []):
            stack.append({
                'function': f.get('functionName', '<anon>'),
                'url': f.get('url', ''),
                'line': f.get('lineNumber', 0) + 1,
                'column': f.get('columnNumber', 0) + 1,
            })
        self._emit('console', {
            'level': 'error', 'message': msg,
            'timestamp': datetime.now().strftime('%H:%M:%S'),
            'stack': stack,
        })

    def _handle_request_sent(self, params: dict):
        req_id = params.get('requestId', '')
        req = params.get('request', {})
        self.pending_requests[req_id] = {
            'method': req.get('method', 'GET'),
            'url': req.get('url', ''),
            'start_time': datetime.now().timestamp(),
            'status': None, 'status_text': None,
            'size': None, 'error': None,
        }

    def _handle_response(self, params: dict):
        req_id = params.get('requestId', '')
        resp = params.get('response', {})
        p = self.pending_requests.pop(req_id, None)
        if not p:
            return
        p['status'] = resp.get('status', 0)
        p['status_text'] = resp.get('statusText', '')
        p['size'] = resp.get('transferSize', 0)
        p['end_time'] = datetime.now().timestamp()
        p['duration_ms'] = round((p['end_time'] - p['start_time']) * 1000, 1)
        self.completed_requests.append(dict(p))
        self._emit('network', {
            'method': p['method'], 'url': p['url'],
            'status': p['status'], 'duration': p['duration_ms'],
            'size': p['size'],
        })

    def _handle_load_failed(self, params: dict):
        req_id = params.get('requestId', '')
        p = self.pending_requests.pop(req_id, None)
        if not p:
            return
        p['status'] = 0
        p['error'] = params.get('errorText', 'Failed')
        p['end_time'] = datetime.now().timestamp()
        p['duration_ms'] = round((p['end_time'] - p['start_time']) * 1000, 1)
        self.completed_requests.append(dict(p))
        self._emit('network', {
            'method': p['method'], 'url': p['url'],
            'status': 0, 'error': p['error'],
            'duration': p['duration_ms'],
        })

    def _handle_perf(self, params: dict):
        metrics = params.get('metrics', [])
        data = {'fps': 60, 'heap': 0, 'nodes': 0, 'listeners': 0}
        for m in metrics:
            name = m.get('name', '')
            value = m.get('value', 0)
            if name == 'JSHeapUsedSize':
                data['heap'] = int(value)
            elif name == 'JSHeapTotalSize':
                data['heap'] = max(data.get('heap', 0), int(value))
            elif name == 'DOMNodes':
                data['nodes'] = int(value)
            elif name == 'EventListeners':
                data['listeners'] = int(value)
            elif name == 'FPS':
                data['fps'] = int(round(value))
        self._perf_metrics.append(data)
        self._emit('perf', data)

    async def _handle_paused(self, params: dict):
        frames = []
        for f in params.get('callFrames', []):
            loc = f.get('location', {})
            frames.append({
                'function': f.get('functionName', '<anon>'),
                'url': f.get('url', ''),
                'line': loc.get('lineNumber', 0) + 1,
                'column': loc.get('columnNumber', 0) + 1,
            })
        self._emit('debugger', {
            'event': 'paused',
            'reason': params.get('reason', 'other'),
            'callFrames': frames,
        })


class LiveReloadServer:
    """WebSocket server for live reload using asyncio."""
    
    def __init__(self, port: int, directory: str, file_watcher):
        self.port = port
        self.directory = directory
        self.file_watcher = file_watcher
        self.clients = set()
        self.server = None
    
    async def handler(self, websocket):
        """Handle WebSocket client connection."""
        self.clients.add(websocket)
        try:
            await websocket.send(json.dumps({"type": "connected", "message": "Live reload connected"}))
            await websocket.wait_closed()
        except (websockets.exceptions.ConnectionClosedOK, websockets.exceptions.ConnectionClosedError):
            pass
        finally:
            self.clients.discard(websocket)
    
    async def start(self):
        """Start the WebSocket server."""
        for offset in range(10):
            try:
                self.server = await websockets.serve(
                    self.handler, 'localhost', self.port + offset
                )
                if self.server.sockets:
                    self.port = self.server.sockets[0].getsockname()[1]
                print(f"Live reload WebSocket running on ws://localhost:{self.port}")
                return
            except OSError:
                continue
        print("Warning: Could not start live reload server")
    
    async def broadcast(self, message: dict):
        """Broadcast message to all connected clients."""
        data = json.dumps(message)
        
        # Take a snapshot to avoid concurrent modification during iteration
        clients_snapshot = set(self.clients)
        disconnected = set()
        
        for client in clients_snapshot:
            try:
                await client.send(data)
            except (websockets.exceptions.ConnectionClosedOK, websockets.exceptions.ConnectionClosedError, websockets.exceptions.InvalidState):
                disconnected.add(client)
            except Exception:
                disconnected.add(client)
        
        for client in disconnected:
            self.clients.discard(client)
            try:
                await client.close()
            except Exception:
                pass
    
    async def close(self):
        """Close the server and all connections."""
        for client in list(self.clients):
            try:
                await client.close()
            except Exception:
                pass
        self.clients.clear()
        if self.server:
            self.server.close()
            await self.server.wait_closed()


class FileWatcher:
    """Async file watcher using asyncio."""
    
    def __init__(self, directory: str, extensions: list, exclude_dirs: list, debounce_ms: int):
        self.directory = directory
        self.extensions = extensions
        self.exclude_dirs = exclude_dirs
        self.debounce_ms = debounce_ms / 1000
        self.last_trigger = 0
        self.running = False
        self._task: Optional[asyncio.Task] = None
    
    def should_watch(self, path: str) -> bool:
        """Check if file should be watched."""
        path_obj = Path(path)
        
        # Check exclusion dirs
        for part in path_obj.parts:
            if part in self.exclude_dirs:
                return False
        
        # Check extensions
        return any(str(path).endswith(ext) for ext in self.extensions)
    
    async def watch(self):
        """Watch for file changes - only trigger on actual file saves."""
        self.running = True
        last_mtimes = {}
        pending_changes = {}  # Track files that have changed but not yet stable
        
        while self.running:
            try:
                current_mtimes = {}
                for root, dirs, files in os.walk(self.directory):
                    dirs[:] = [d for d in dirs if d not in self.exclude_dirs]
                    
                    for file in files:
                        path = os.path.join(root, file)
                        if self.should_watch(path):
                            try:
                                current_mtimes[path] = os.path.getmtime(path)
                            except OSError:
                                continue
                
                now = datetime.now().timestamp()
                
                # Check for actual file changes (mtime differs from last known)
                for path, mtime in current_mtimes.items():
                    last_mtime = last_mtimes.get(path)
                    
                    if last_mtime is None:
                        # First time seeing this file - skip
                        continue
                    
                    if mtime != last_mtime:
                        # File has changed - mark as pending
                        if path not in pending_changes:
                            pending_changes[path] = now
                
                # Check pending changes for stability
                for path, change_time in list(pending_changes.items()):
                    current_mtime = current_mtimes.get(path)
                    last_mtime = last_mtimes.get(path)
                    
                    if current_mtime is None:
                        # File was deleted
                        del pending_changes[path]
                        continue
                    
                    if current_mtime == last_mtime and (now - change_time) >= self.debounce_ms:
                        # File is stable (not changing) and has been stable long enough
                        del pending_changes[path]
                        if now - self.last_trigger > self.debounce_ms:
                            self.last_trigger = now
                            yield path
                
                last_mtimes = current_mtimes
                await asyncio.sleep(0.3)
                
            except Exception as e:
                print(f"File watcher error: {e}")
                await asyncio.sleep(1)
    
    def start(self, callback):
        """Start the file watcher."""
        self._task = asyncio.create_task(self._run_watcher(callback))
    
    async def _run_watcher(self, callback):
        """Run the watcher loop."""
        async for path in self.watch():
            await callback(path)
    
    async def stop(self):
        """Stop the file watcher."""
        self.running = False
        if self._task:
            self._task.cancel()
            try:
                await self._task
            except asyncio.CancelledError:
                pass


class HTTPServer:
    """Async HTTP server with SSE console streaming."""
    
    def __init__(self, port: int, directory: str, console_buffer: ConsoleBuffer, live_reload_server: LiveReloadServer):
        self.port = port
        self.directory = directory
        self.console_buffer = console_buffer
        self.live_reload_server = live_reload_server
        self.server: Optional[asyncio.Server] = None
        self.running = True
        self.cdp_client: Optional[CDPClient] = None
    
    async def handle_client(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
        """Handle incoming HTTP client request."""
        try:
            # Read request line
            request_line = await reader.readline()
            if not request_line:
                writer.close()
                await writer.wait_closed()
                return
            
            request_line = request_line.decode().strip()
            
            # Parse request
            parts = request_line.split()
            if len(parts) < 2:
                writer.close()
                await writer.wait_closed()
                return
            
            method = parts[0]
            path = parts[1]
            
            # Read headers
            headers = {}
            while True:
                line = await reader.readline()
                if not line or line == b'\r\n':
                    break
                header = line.decode().strip()
                if ':' in header:
                    key, value = header.split(':', 1)
                    headers[key.strip().lower()] = value.strip()
            
            # Route request
            if method == 'POST' and path == '/api/console/log':
                await self.handle_console_log(reader, writer, headers)
            elif method == 'GET' and path == '/api/console/stream':
                await self.handle_console_stream(reader, writer, headers)
            elif method == 'GET' and path == '/api/health':
                await self.handle_health(writer)
            elif path.startswith('/api/cdp/'):
                await self.handle_cdp(method, path, reader, writer, headers)
            else:
                await self.handle_static(method, path, reader, writer, headers)
                
        except Exception as e:
            print(f"Error handling client: {e}")
        finally:
            try:
                writer.close()
                await writer.wait_closed()
            except Exception:
                pass
    
    async def handle_console_log(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, headers: dict):
        """Handle POST /api/console/log - receive logs from browser."""
        content_length = int(headers.get('content-length', 0))
        body = await reader.read(content_length)
        
        try:
            log_data = json.loads(body.decode('utf-8'))
            
            # Handle batch logs
            if log_data.get('type') == 'console_batch' and 'logs' in log_data:
                for entry in log_data['logs']:
                    if 'timestamp' not in entry:
                        entry['timestamp'] = datetime.now().isoformat()
                    self.console_buffer.append(entry)
            else:
                # Individual log
                if 'timestamp' not in log_data:
                    log_data['timestamp'] = datetime.now().isoformat()
                self.console_buffer.append(log_data)
            
            # Send response
            writer.write(b'HTTP/1.1 200 OK\r\n')
            writer.write(b'Content-Type: application/json\r\n')
            writer.write(b'Access-Control-Allow-Origin: *\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            writer.write(json.dumps({"status": "received"}).encode())
            await writer.drain()
            
        except Exception as e:
            writer.write(b'HTTP/1.1 400 Bad Request\r\n')
            writer.write(b'Content-Type: application/json\r\n')
            writer.write(b'Access-Control-Allow-Origin: *\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            writer.write(json.dumps({"error": "Invalid request"}).encode())
            await writer.drain()
    
    async def handle_console_stream(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, headers: dict):
        """Handle GET /api/console/stream - SSE streaming endpoint."""
        # Send SSE headers
        writer.write(b'HTTP/1.1 200 OK\r\n')
        writer.write(b'Content-Type: text/plain; charset=utf-8\r\n')
        writer.write(b'Cache-Control: no-cache\r\n')
        writer.write(b'Access-Control-Allow-Origin: *\r\n')
        writer.write(b'Connection: keep-alive\r\n')
        writer.write(b'X-Accel-Buffering: no\r\n')
        writer.write(b'\r\n')
        await writer.drain()
        
        # Exponential backoff: 15s → 30s → 60s → 120s → max 300s
        base_interval = 15
        current_interval = base_interval
        max_interval = 300
        heartbeat_count = 0
        
        try:
            while self.running:
                # Get buffered logs
                logs = self.console_buffer.get_all()
                
                # Send buffered logs and reset exponential backoff
                if logs:
                    current_interval = base_interval  # Reset to 15s
                    heartbeat_count = 0
                    
                    for log_entry in logs:
                        level = log_entry.get('level', 'log')
                        message = log_entry.get('message', '')
                        source = log_entry.get('source', 'browser')
                        formatted = format_log_entry(level, message, source)
                        writer.write(f"data: {formatted}\n\n".encode())
                        await writer.drain()
                
                # Send silent keepalive (SSE comment) to prevent connection timeout
                heartbeat_count += 1
                if heartbeat_count >= current_interval:
                    heartbeat_count = 0
                    writer.write(b': heartbeat\n\n')
                    await writer.drain()
                    # Exponential backoff
                    current_interval = min(current_interval * 2, max_interval)
                
                # Wait before next check
                await asyncio.sleep(1)
                
        except (BrokenPipeError, ConnectionResetError, asyncio.CancelledError):
            pass
        finally:
            try:
                writer.close()
                await writer.wait_closed()
            except Exception:
                pass
    
    async def handle_health(self, writer: asyncio.StreamWriter):
        """Handle GET /api/health - health check endpoint."""
        writer.write(b'HTTP/1.1 200 OK\r\n')
        writer.write(b'Content-Type: application/json\r\n')
        writer.write(b'Access-Control-Allow-Origin: *\r\n')
        writer.write(b'Connection: close\r\n')
        writer.write(b'\r\n')
        writer.write(json.dumps({
            "status": "ok",
            "server": "p5.nvim asyncio",
            "console_buffer_size": len(self.console_buffer),
        }).encode())
        await writer.drain()

    # --- CDP endpoint dispatcher ---

    async def handle_cdp(self, method: str, path: str, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, headers: dict):
        if method == 'POST' and path == '/api/cdp/connect':
            await self.handle_cdp_connect(writer)
        elif method == 'DELETE' and path == '/api/cdp/connect':
            await self.handle_cdp_disconnect(writer)
        elif method == 'GET' and path == '/api/cdp/status':
            await self.handle_cdp_status(writer)
        elif method == 'GET' and path == '/api/cdp/stream':
            await self.handle_cdp_stream(reader, writer, headers)
        elif method == 'POST' and path == '/api/cdp/evaluate':
            await self.handle_cdp_evaluate(reader, writer, headers)
        elif method == 'POST' and path == '/api/cdp/debug/break':
            await self.handle_cdp_debug_break(reader, writer, headers)
        elif method == 'POST' and path == '/api/cdp/debug/continue':
            await self.handle_cdp_debug_continue(writer)
        elif method == 'POST' and path == '/api/cdp/debug/step':
            await self.handle_cdp_debug_step(writer)
        elif method == 'POST' and path == '/api/cdp/debug/stepIn':
            await self.handle_cdp_debug_step_in(writer)
        elif method == 'POST' and path == '/api/cdp/debug/stepOut':
            await self.handle_cdp_debug_step_out(writer)
        else:
            await self._json_error(writer, 404, 'Unknown CDP endpoint')

    async def _json_response(self, writer: asyncio.StreamWriter, data: dict, status: int = 200):
        body = json.dumps(data).encode()
        writer.write(f'HTTP/1.1 {status} {"OK" if status == 200 else "Error"}\r\n'.encode())
        writer.write(b'Content-Type: application/json\r\n')
        writer.write(b'Access-Control-Allow-Origin: *\r\n')
        writer.write(b'Connection: close\r\n')
        writer.write(b'\r\n')
        writer.write(body)
        await writer.drain()

    async def _json_error(self, writer: asyncio.StreamWriter, status: int, message: str):
        await self._json_response(writer, {'error': message}, status)

    async def handle_cdp_connect(self, writer: asyncio.StreamWriter):
        if self.cdp_client and self.cdp_client.connected:
            await self._json_response(writer, {'status': 'already_connected', 'url': self.cdp_client.page_url})
            return
        if self.cdp_client:
            await self.cdp_client.disconnect()
        port = CONFIG['cdp']['remote_debugging_port']
        self.cdp_client = CDPClient(port)
        try:
            await self.cdp_client.connect()
            await self._json_response(writer, {
                'status': 'connected',
                'url': self.cdp_client.page_url,
                'port': port,
            })
        except (ConnectionError, OSError, websockets.exceptions.InvalidURI) as e:
            if self.cdp_client:
                await self.cdp_client.disconnect()
            self.cdp_client = None
            await self._json_response(writer, {'status': 'error', 'message': str(e)}, 503)

    async def handle_cdp_disconnect(self, writer: asyncio.StreamWriter):
        if self.cdp_client and self.cdp_client.connected:
            await self.cdp_client.disconnect()
            await self._json_response(writer, {'status': 'disconnected'})
        else:
            await self._json_response(writer, {'status': 'not_connected'})

    async def handle_cdp_status(self, writer: asyncio.StreamWriter):
        if self.cdp_client and self.cdp_client.connected:
            await self._json_response(writer, {
                'connected': True,
                'url': self.cdp_client.page_url,
            })
        else:
            await self._json_response(writer, {'connected': False})

    async def handle_cdp_stream(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, headers: dict):
        writer.write(b'HTTP/1.1 200 OK\r\n')
        writer.write(b'Content-Type: application/x-ndjson\r\n')
        writer.write(b'Cache-Control: no-cache\r\n')
        writer.write(b'Access-Control-Allow-Origin: *\r\n')
        writer.write(b'Connection: keep-alive\r\n')
        writer.write(b'X-Accel-Buffering: no\r\n')
        writer.write(b'\r\n')
        await writer.drain()
        heartbeat = 0
        try:
            while self.running:
                if self.cdp_client and self.cdp_client.connected:
                    events = self.cdp_client.drain_events()
                    for etype, edata in events:
                        line = json.dumps(edata) + '\n'
                        writer.write(line.encode())
                        await writer.drain()
                    if not events:
                        heartbeat += 1
                        if heartbeat >= 15:
                            writer.write(b'{"type":"hb"}\n')
                            await writer.drain()
                            heartbeat = 0
                else:
                    if heartbeat == 0:
                        writer.write(b'{"type":"status","state":"disconnected"}\n')
                        await writer.drain()
                    heartbeat += 1
                    if heartbeat >= 15:
                        writer.write(b'{"type":"hb"}\n')
                        await writer.drain()
                        heartbeat = 0
                await asyncio.sleep(1)
        except (BrokenPipeError, ConnectionResetError, asyncio.CancelledError):
            pass
        finally:
            try:
                writer.close()
                await writer.wait_closed()
            except Exception:
                pass

    async def handle_cdp_evaluate(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, headers: dict):
        if not self.cdp_client or not self.cdp_client.connected:
            await self._json_error(writer, 503, 'CDP not connected')
            return
        content_length = int(headers.get('content-length', 0))
        body = await reader.read(content_length)
        try:
            data = json.loads(body.decode())
            expr = data.get('expression', '')
            dangerous = ['file://', ' require(', "require('", 'require("', 'process.env', 'global.', '__dirname']
            for pat in dangerous:
                if pat in expr:
                    await self._json_error(writer, 400, f'Rejected: expression contains forbidden pattern "{pat}"')
                    return
            result = await self.cdp_client.evaluate(expr)
            await self._json_response(writer, result)
        except Exception as e:
            await self._json_error(writer, 400, str(e))

    async def handle_cdp_debug_break(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, headers: dict):
        if not self.cdp_client or not self.cdp_client.connected:
            await self._json_error(writer, 503, 'CDP not connected')
            return
        content_length = int(headers.get('content-length', 0))
        body = await reader.read(content_length)
        try:
            data = json.loads(body.decode())
            loc = data.get('location', '')
            result = await self.cdp_client.set_breakpoint(loc)
            await self._json_response(writer, result)
        except Exception as e:
            await self._json_error(writer, 400, str(e))

    async def handle_cdp_debug_continue(self, writer: asyncio.StreamWriter):
        if not self.cdp_client or not self.cdp_client.connected:
            await self._json_error(writer, 503, 'CDP not connected')
            return
        try:
            await self.cdp_client.resume()
            await self._json_response(writer, {'status': 'resumed'})
        except Exception as e:
            await self._json_error(writer, 400, str(e))

    async def handle_cdp_debug_step(self, writer: asyncio.StreamWriter):
        if not self.cdp_client or not self.cdp_client.connected:
            await self._json_error(writer, 503, 'CDP not connected')
            return
        try:
            await self.cdp_client.step_over()
            await self._json_response(writer, {'status': 'stepped'})
        except Exception as e:
            await self._json_error(writer, 400, str(e))

    async def handle_cdp_debug_step_in(self, writer: asyncio.StreamWriter):
        if not self.cdp_client or not self.cdp_client.connected:
            await self._json_error(writer, 503, 'CDP not connected')
            return
        try:
            await self.cdp_client.step_into()
            await self._json_response(writer, {'status': 'stepped_in'})
        except Exception as e:
            await self._json_error(writer, 400, str(e))

    async def handle_cdp_debug_step_out(self, writer: asyncio.StreamWriter):
        if not self.cdp_client or not self.cdp_client.connected:
            await self._json_error(writer, 503, 'CDP not connected')
            return
        try:
            await self.cdp_client.step_out()
            await self._json_response(writer, {'status': 'stepped_out'})
        except Exception as e:
            await self._json_error(writer, 400, str(e))

    async def handle_cdp_network_clear(self, writer: asyncio.StreamWriter):
        if self.cdp_client:
            self.cdp_client.clear_network_log()
        await self._json_response(writer, {'status': 'cleared'})

    async def handle_static(self, method: str, path: str, reader: asyncio.StreamReader, writer: asyncio.StreamWriter, headers: dict):
        """Handle static file serving."""
        if method != 'GET':
            writer.write(b'HTTP/1.1 405 Method Not Allowed\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            await writer.drain()
            return
        
        # Handle root path
        if path == '/':
            path = '/index.html'
        
        # Prevent directory traversal - check resolved path stays within allowed directory
        try:
            resolved = Path(self.directory, path.lstrip('/')).resolve()
            base_resolved = Path(self.directory).resolve()
            if not resolved.is_relative_to(base_resolved):
                writer.write(b'HTTP/1.1 403 Forbidden\r\n')
                writer.write(b'Connection: close\r\n')
                writer.write(b'\r\n')
                await writer.drain()
                return
        except (ValueError, OSError):
            writer.write(b'HTTP/1.1 400 Bad Request\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            await writer.drain()
            return
        
        # Build file path
        file_path = os.path.join(self.directory, path.lstrip('/'))
        
        # Generate index.html on-the-fly if it doesn't exist
        if path == '/index.html' and not os.path.isfile(file_path):
            content = self.generate_index_html()
            content = self.inject_scripts(content.encode('utf-8'))
            writer.write(b'HTTP/1.1 200 OK\r\n')
            writer.write(b'Content-Type: text/html\r\n')
            writer.write(f'Content-Length: {len(content)}\r\n'.encode())
            writer.write(b'Access-Control-Allow-Origin: *\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            writer.write(content)
            await writer.drain()
            return
        
        if not os.path.isfile(file_path):
            writer.write(b'HTTP/1.1 404 Not Found\r\n')
            writer.write(b'Content-Type: text/plain\r\n')
            writer.write(b'Access-Control-Allow-Origin: *\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            writer.write(b'File not found')
            await writer.drain()
            return
        
        # Determine content type
        ext = os.path.splitext(file_path)[1].lower()
        mime_types = {
            '.html': 'text/html',
            '.js': 'text/javascript',
            '.css': 'text/css',
            '.json': 'application/json',
            '.png': 'image/png',
            '.jpg': 'image/jpeg',
            '.gif': 'image/gif',
            '.svg': 'image/svg+xml',
            '.woff': 'application/font-woff',
            '.ttf': 'application/font-ttf',
        }
        content_type = mime_types.get(ext, 'application/octet-stream')
        
        # Read file
        try:
            with open(file_path, 'rb') as f:
                content = f.read()
            
            # Inject scripts for HTML files
            if ext == '.html':
                content = self.inject_scripts(content)
            
            # Send response
            writer.write(b'HTTP/1.1 200 OK\r\n')
            writer.write(f'Content-Type: {content_type}\r\n'.encode())
            writer.write(f'Content-Length: {len(content)}\r\n'.encode())
            writer.write(b'Access-Control-Allow-Origin: *\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            writer.write(content)
            await writer.drain()
            
        except Exception as e:
            writer.write(b'HTTP/1.1 500 Internal Server Error\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            writer.write(b'An error occurred while processing your request')
            await writer.drain()
    
    def generate_index_html(self) -> str:
        """Generate index.html on-the-fly based on p5.json libs."""
        p5_json_path = os.path.join(self.directory, 'p5.json')
        config = {}
        if os.path.isfile(p5_json_path):
            try:
                with open(p5_json_path, 'r') as f:
                    config = json.load(f)
            except:
                pass
        
        libs = config.get('libs', {})
        version = config.get('version', '2.0.0')
        title = config.get('gist', {}).get('title', 'p5.js Sketch')
        
        # Auto-create sketch.js if missing
        sketch_js_path = os.path.join(self.directory, 'sketch.js')
        if not os.path.isfile(sketch_js_path):
            default_sketch = '''function setup() {
  createCanvas(400, 400);
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 50);
}'''
            with open(sketch_js_path, 'w') as f:
                f.write(default_sketch)
        
        # Build script tags for core and contrib libs
        scripts = []
        scripts.append('  <script src="assets/libs/p5.js"></script>')
        
        for lib_name in libs.keys():
            lib_version = libs[lib_name]
            scripts.append(f'  <script src="assets/libs/{lib_name}.js"></script>')
        
        scripts.append('  <script src="assets/libs/libs.js"></script>')
        
        html = f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{title}</title>
  <link rel="icon" type="image/x-icon" href="assets/favicon.ico">
{chr(10).join(scripts)}
</head>
<body>
  <main>
  </main>
  <script src="sketch.js"></script>
</body>
</html>'''
        return html
    
    def inject_scripts(self, html_content: bytes) -> bytes:
        """Inject console and live reload scripts into HTML."""
        content = html_content.decode('utf-8', errors='ignore')

        # Inject title from p5.json gist.title
        p5_json_path = os.path.join(self.directory, 'p5.json')
        if os.path.isfile(p5_json_path):
            try:
                with open(p5_json_path, 'r') as f:
                    config = json.load(f)
                gist_title = config.get('gist', {}).get('title', '')
                if gist_title:
                    content = re.sub(r'<title>[^<]*</title>', f'<title>{gist_title}</title>', content, flags=re.IGNORECASE)
            except Exception:
                pass

        cs = "<script>" + INJECT_CONSOLE + "</script>"
        scripts = cs
        if CONFIG['live_reload']['enabled'] and INJECT_LIVERELOAD:
            lr = "<script>" + INJECT_LIVERELOAD.replace("__LR_PORT__", str(self.live_reload_server.port)) + "</script>"
            scripts += lr

        if '</body>' in content.lower():
            content = re.sub(r'</body>', scripts + '</body>', content, flags=re.IGNORECASE)
        else:
            content += scripts

        return content.encode('utf-8')
    
    async def start(self):
        """Start the HTTP server."""
        try:
            self.server, self.port = await try_start_server(
                self.handle_client, 'localhost', self.port
            )
            print(f"Server running at http://localhost:{self.port}/")
        except OSError:
            print(f"Error starting server on port {self.port}")
            raise
    
    async def close(self):
        """Close the HTTP server."""
        self.running = False
        if self.server:
            self.server.close()
            await self.server.wait_closed()


async def main():
    """Main entry point."""
    directory = os.getcwd()
    
    # Create components
    console_buffer = ConsoleBuffer(max_size=CONFIG['console']['buffer_size'])
    
    lr_config = CONFIG['live_reload']
    
    live_reload_server = LiveReloadServer(
        port=lr_config['port'],
        directory=directory,
        file_watcher=None,
    )
    
    file_watcher = None
    if lr_config['enabled']:
        file_watcher = FileWatcher(
            directory=directory,
            extensions=lr_config['watch_extensions'],
            exclude_dirs=lr_config['exclude_dirs'],
            debounce_ms=lr_config['debounce_ms']
        )
        live_reload_server.file_watcher = file_watcher
    
    http_server = HTTPServer(
        port=CONFIG['port'],
        directory=directory,
        console_buffer=console_buffer,
        live_reload_server=live_reload_server
    )
    
    # Start servers
    if lr_config['enabled']:
        await live_reload_server.start()
    await http_server.start()
    
    # Update live reload port in config if it changed
    if live_reload_server.server:
        lr_config['port'] = live_reload_server.port
    
    # Start file watcher
    if file_watcher and lr_config['enabled']:
        async def on_file_change(path: str):
            message = {
                "type": "reload",
                "file": path,
                "timestamp": datetime.now().isoformat()
            }
            try:
                await live_reload_server.broadcast(message)
                print(f"Reload triggered for: {path}")
            except Exception:
                pass
        
        file_watcher.start(on_file_change)
    
    # Handle shutdown
    shutdown_event = asyncio.Event()
    
    def signal_handler():
        print("\nShutting down server...")
        shutdown_event.set()
    
    loop = asyncio.get_event_loop()
    for sig in (signal.SIGTERM, signal.SIGINT):
        try:
            loop.add_signal_handler(sig, signal_handler)
        except NotImplementedError:
            pass
    
    # Wait for shutdown
    await shutdown_event.wait()
    
    # Cleanup
    print("Closing connections...")
    if file_watcher:
        await file_watcher.stop()
    await live_reload_server.close()
    await http_server.close()
    print("Server stopped")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nServer stopped by user")
