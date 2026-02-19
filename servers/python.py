#!/usr/bin/env python3
"""
p5.nvim asyncio-based live server with SSE console streaming.
Replaces blocking http.server with asyncio for better performance.
"""
import asyncio
import os
import re
import json
import signal
import sys
import webbrowser
from collections import deque
from datetime import datetime
from pathlib import Path
from typing import Optional

# Configuration
CONFIG = {
    "port": int(sys.argv[1]) if len(sys.argv) > 1 else 8000,
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
    }
}

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


def format_log_entry(level: str, message: str, source: str = "browser") -> str:
    """Format a log entry with ANSI colors for terminal display."""
    timestamp = datetime.now().strftime("%H:%M:%S")
    level = level.upper()
    
    level_color = ANSI_COLORS.get(level.lower(), ANSI_COLORS['log'])
    time_color = ANSI_COLORS['timestamp']
    source_color = ANSI_COLORS['source']
    reset = ANSI_COLORS['reset']
    
    return (
        f"{time_color}[{timestamp}]{reset} "
        f"{level_color}{level:5}{reset} "
        f"{source_color}[{source}]{reset}: {message}"
    )


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


class LiveReloadServer:
    """WebSocket server for live reload using asyncio."""
    
    def __init__(self, port: int, directory: str, file_watcher):
        self.port = port
        self.directory = directory
        self.file_watcher = file_watcher
        self.clients = set()
        self.server: Optional[asyncio.Server] = None
    
    async def handle_client(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
        """Handle WebSocket client connection."""
        addr = writer.get_extra_info('peername')
        self.clients.add(writer)
        
        try:
            # Send welcome message
            response = json.dumps({"type": "connected", "message": "Live reload connected"})
            writer.write(response.encode())
            await writer.drain()
            
            # Keep connection alive
            while True:
                data = await reader.read(1024)
                if not data:
                    break
        except Exception:
            pass
        finally:
            self.clients.discard(writer)
            writer.close()
            await writer.wait_closed()
    
    async def start(self):
        """Start the WebSocket server."""
        try:
            self.server = await asyncio.start_server(
                self.handle_client, 'localhost', self.port
            )
            print(f"Live reload WebSocket running on ws://localhost:{self.port}")
        except OSError as e:
            # Try alternate ports
            for offset in range(1, 10):
                try:
                    alt_port = self.port + offset
                    self.server = await asyncio.start_server(
                        self.handle_client, 'localhost', alt_port
                    )
                    self.port = alt_port
                    print(f"Live reload WebSocket running on ws://localhost:{self.port}")
                    return
                except OSError:
                    continue
            print(f"Warning: Could not start live reload server: {e}")
    
    async def broadcast(self, message: dict):
        """Broadcast message to all connected clients."""
        data = json.dumps(message).encode()
        disconnected = set()
        
        for client in self.clients:
            try:
                client.write(data)
                await client.drain()
            except Exception:
                disconnected.add(client)
        
        for client in disconnected:
            self.clients.discard(client)
            try:
                client.close()
            except Exception:
                pass
    
    async def close(self):
        """Close the server and all connections."""
        for client in list(self.clients):
            try:
                client.close()
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
        """Watch for file changes."""
        self.running = True
        last_mtimes = {}
        
        while self.running:
            try:
                current_mtimes = {}
                for root, dirs, files in os.walk(self.directory):
                    # Filter excluded dirs
                    dirs[:] = [d for d in dirs if d not in self.exclude_dirs]
                    
                    for file in files:
                        path = os.path.join(root, file)
                        if self.should_watch(path):
                            try:
                                current_mtimes[path] = os.path.getmtime(path)
                            except OSError:
                                continue
                
                # Check for changes
                for path, mtime in current_mtimes.items():
                    if path not in last_mtimes or last_mtimes[path] != mtime:
                        now = datetime.now().timestamp()
                        if now - self.last_trigger > self.debounce_ms:
                            self.last_trigger = now
                            yield path
                
                last_mtimes = current_mtimes
                await asyncio.sleep(0.5)
                
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
            writer.write(json.dumps({"error": str(e)}).encode())
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
        
        heartbeat_interval = CONFIG['console']['heartbeat_interval']
        heartbeat_count = 0
        
        try:
            while self.running:
                # Get buffered logs
                logs = self.console_buffer.get_all()
                
                # Send buffered logs
                for log_entry in logs:
                    level = log_entry.get('level', 'log')
                    message = log_entry.get('message', '')
                    source = log_entry.get('source', 'browser')
                    formatted = format_log_entry(level, message, source)
                    writer.write(f"data: {formatted}\n\n".encode())
                    await writer.drain()
                
                # Send heartbeat every N iterations
                heartbeat_count += 1
                if heartbeat_count >= heartbeat_interval:
                    heartbeat_count = 0
                    writer.write(b': heartbeat\n\n')
                    await writer.drain()
                
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
        
        # Prevent directory traversal
        if '..' in path:
            writer.write(b'HTTP/1.1 403 Forbidden\r\n')
            writer.write(b'Connection: close\r\n')
            writer.write(b'\r\n')
            await writer.drain()
            return
        
        # Build file path
        file_path = os.path.join(self.directory, path.lstrip('/'))
        
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
            writer.write(str(e).encode())
            await writer.drain()
    
    def inject_scripts(self, html_content: bytes) -> bytes:
        """Inject console and live reload scripts into HTML."""
        content = html_content.decode('utf-8', errors='ignore')
        
        # Console injection script
        console_script = '''
    <script>
      (function() {
        console.log('p5.nvim console integration enabled');
        
        const originalConsole = {
          log: console.log,
          error: console.error,
          warn: console.warn,
          info: console.info
        };
        
        function sendToConsole(level, args) {
          const message = args.map(arg => {
            if (typeof arg === 'object') {
              try {
                return JSON.stringify(arg);
              } catch (e) {
                return String(arg);
              }
            }
            return String(arg);
          }).join(' ');
          
          fetch('/api/console/log', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              type: 'console',
              level: level,
              message: message,
              source: 'javascript',
              timestamp: new Date().toISOString()
            })
          }).catch(() => {});
        }
        
        console.log = function(...args) {
          originalConsole.log.apply(console, args);
          sendToConsole('log', args);
        };
        
        console.error = function(...args) {
          originalConsole.error.apply(console, args);
          sendToConsole('error', args);
        };
        
        console.warn = function(...args) {
          originalConsole.warn.apply(console, args);
          sendToConsole('warn', args);
        };
        
        console.info = function(...args) {
          originalConsole.info.apply(console, args);
          sendToConsole('info', args);
        };
        
        window.onerror = function(msg, source, lineno, colno, error) {
          sendToConsole('error', [msg + ' at ' + source + ':' + lineno + ':' + colno]);
          return false;
        };
      })();
    </script>'''
        
        # Live reload script
        live_reload_script = f'''
    <script>
      (function() {{
        const ws = new WebSocket('ws://localhost:{self.live_reload_server.port}');
        
        ws.onopen = function() {{
          console.log('Live reload connected');
        }};
        
        ws.onclose = function() {{
          setTimeout(function() {{
            window.location.reload();
          }}, 1000);
        }};
        
        ws.onmessage = function(event) {{
          const data = JSON.parse(event.data);
          if (data.type === 'reload') {{
            window.location.reload();
          }}
        }};
      }})();
    </script>'''
        
        # Inject scripts before </body>
        if '</body>' in content.lower():
            content = re.sub(r'</body>', console_script + live_reload_script + '</body>', content, flags=re.IGNORECASE)
        else:
            content += console_script + live_reload_script
        
        return content.encode('utf-8')
    
    async def start(self):
        """Start the HTTP server."""
        try:
            self.server = await asyncio.start_server(
                self.handle_client, 'localhost', self.port
            )
            print(f"Server running at http://localhost:{self.port}/")
        except OSError as e:
            print(f"Error starting server on port {self.port}: {e}")
            # Try alternate ports
            for offset in range(1, 10):
                try:
                    alt_port = self.port + offset
                    self.server = await asyncio.start_server(
                        self.handle_client, 'localhost', alt_port
                    )
                    self.port = alt_port
                    print(f"Server running at http://localhost:{self.port}/")
                    return
                except OSError:
                    continue
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
    file_watcher = FileWatcher(
        directory=directory,
        extensions=lr_config['watch_extensions'],
        exclude_dirs=lr_config['exclude_dirs'],
        debounce_ms=lr_config['debounce_ms']
    )
    
    live_reload_server = LiveReloadServer(
        port=lr_config['port'],
        directory=directory,
        file_watcher=file_watcher
    )
    
    http_server = HTTPServer(
        port=CONFIG['port'],
        directory=directory,
        console_buffer=console_buffer,
        live_reload_server=live_reload_server
    )
    
    # Start servers
    await live_reload_server.start()
    await http_server.start()
    
    # Update live reload port in HTTP server if it changed
    lr_config['port'] = live_reload_server.port
    
    # Start file watcher
    async def on_file_change(path: str):
        message = {
            "type": "reload",
            "file": path,
            "timestamp": datetime.now().isoformat()
        }
        await live_reload_server.broadcast(message)
        print(f"Reload triggered for: {path}")
    
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
            # Windows doesn't support add_signal_handler
            pass
    
    # Wait for shutdown
    await shutdown_event.wait()
    
    # Cleanup
    print("Closing connections...")
    await file_watcher.stop()
    await live_reload_server.close()
    await http_server.close()
    print("Server stopped")


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nServer stopped by user")
