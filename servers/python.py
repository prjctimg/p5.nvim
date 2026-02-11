#!/usr/bin/env python3
import http.server
import socketserver
import sys
import os
import re
import json
import threading
import time
from urllib.parse import unquote

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
LIVE_RELOAD_PORT = 12002
DIRECTORY = os.getcwd()
DEBOUNCE_TIME = 0.3  # seconds

# Live reload WebSocket clients
reload_clients = set()
last_reload_time = 0

# Console log buffer for HTTP-based log streaming
console_log_buffer = []

# ANSI color codes for log formatting
ANSI_COLORS = {
    'reset': '\033[0m',
    'error': '\033[1;31m',    # Bold red
    'warn': '\033[1;33m',     # Bold yellow  
    'info': '\033[1;36m',     # Bold cyan
    'log': '\033[0;37m',      # White
    'timestamp': '\033[0;90m'  # Dim gray
}

def format_log_entry(log_entry):
    """Format a log entry with ANSI colors for better readability."""
    level = log_entry.get('level', 'log').upper()
    message = log_entry.get('message', '')
    source = log_entry.get('source', 'browser')
    
    # Get timestamp in readable format
    import time
    timestamp = time.strftime('%H:%M:%S')
    
    # Get color for level
    level_color = ANSI_COLORS.get(level.lower(), ANSI_COLORS['log'])
    time_color = ANSI_COLORS['timestamp']
    reset = ANSI_COLORS['reset']
    
    # Format: [TIME] LEVEL source: message
    formatted = f"{time_color}[{timestamp}]{reset} {level_color}{level}{reset} {source}: {message}"
    
    return formatted

class P5HTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
        self.last_reload_time = 0
    
    def end_headers(self):
        # Add CORS headers
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()
    
    
    
    def translate_path(self, path):
        path = unquote(path)
        if path.startswith('/'):
            path = path[1:]
        return os.path.join(DIRECTORY, path)
    
    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()
    
    def do_POST(self):
        """Handle POST requests for console logs."""
        if self.path == '/api/console/log':
            try:
                content_length = int(self.headers['Content-Length'])
                post_data = self.rfile.read(content_length)
                log_data = json.loads(post_data.decode('utf-8'))
                
                # Handle both individual logs and batch logs
                if log_data.get('type') == 'console_batch' and 'logs' in log_data:
                    # Batch processing
                    for log_entry in log_data['logs']:
                        if 'timestamp' not in log_entry:
                            log_entry['timestamp'] = time.time()
                        console_log_buffer.append(log_entry)
                else:
                    # Individual log entry
                    if 'timestamp' not in log_data:
                        log_data['timestamp'] = time.time()
                    console_log_buffer.append(log_data)
                
                # Send response
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"status": "received"}).encode('utf-8'))
                
            except Exception as e:
                self.send_response(400)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"error": str(e)}).encode('utf-8'))
        else:
            self.send_response(404)
            self.end_headers()
    
    def do_GET(self):
        """Handle GET requests for console log streaming."""
        if self.path == '/api/console/stream':
            # Server-Sent Events endpoint for real-time log streaming
            try:
                self.send_response(200)
                self.send_header('Content-type', 'text/plain; charset=utf-8')
                self.send_header('Cache-Control', 'no-cache')
                self.send_header('Connection', 'keep-alive')
                self.end_headers()
                
                # Stream any buffered logs first
                logs = []
                while console_log_buffer:
                    logs.append(console_log_buffer.pop(0))
                
                for log_entry in logs:
                    formatted = format_log_entry(log_entry)
                    self.wfile.write((formatted + '\n').encode('utf-8'))
                    self.wfile.flush()
                
            except Exception as e:
                # If client disconnects, that's expected
                pass
                
        elif self.path == '/api/console/poll':
            try:
                # Get buffered logs and clear buffer
                logs = []
                while console_log_buffer:
                    logs.append(console_log_buffer.pop(0))
                
                # Send response
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps(logs).encode('utf-8'))
                
            except Exception as e:
                self.send_response(500)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"error": str(e)}).encode('utf-8'))
        else:
            # Handle regular GET requests
            self.handle_regular_get()
    
    def handle_regular_get(self):
        """Handle regular file GET requests."""
        # Handle root path
        if self.path == '/':
            self.path = '/index.html'
        
        # Translate path to file system
        translated_path = self.translate_path(self.path)
        
        # Check if file exists and is HTML
        if os.path.exists(translated_path) and translated_path.endswith('.html'):
            try:
                with open(translated_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Inject console and live reload scripts
                modified_content = self.inject_scripts(content)
                
                # Send response with modified content
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.send_header('Content-Length', str(len(modified_content.encode('utf-8'))))
                self.end_headers()
                self.wfile.write(modified_content.encode('utf-8'))
                return
            except Exception as e:
                # Fallback to normal file serving if injection fails
                pass
        
        # Fallback to normal file serving
        super().do_GET()
    
    def log_message(self, format, *args):
        # Suppress default logging
        pass
    
    def inject_console_script(self, html_content):
        """Inject modern console script into HTML content."""
        # This should match the script from lua/p5/console.lua
        console_script = '''
    <script>
      (function() {
        console.log('p5.nvim console integration enabled');
        
        // Override console methods
        const originalConsole = {
          log: console.log,
          error: console.error,
          warn: console.warn,
          info: console.info
        };
        
        // Debounce function to reduce browser load
        function debounce(func, wait) {
          let timeout;
          return function executedFunction(...args) {
            const later = () => {
              clearTimeout(timeout);
              func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
          };
        }
        
        // Buffer for batching logs
        let logBuffer = [];
        let flushTimeout;
        
        function flushLogBuffer() {
          if (logBuffer.length === 0) return;
          
          const logs = [...logBuffer];
          logBuffer = [];
          
          // Send logs asynchronously
          fetch('/api/console/log', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              type: 'console_batch',
              logs: logs,
              timestamp: new Date().toISOString()
            })
          }).catch(err => {
            // If batch fails, try individual logs
            logs.forEach(log => {
              fetch('/api/console/log', {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json'
                },
                body: JSON.stringify(log)
              }).catch(() => {}); // Silently fail individual logs
            });
          });
        }
        
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
          
          const logEntry = {
            type: 'console',
            level: level,
            message: message,
            source: 'javascript',
            timestamp: new Date().toISOString()
          };
          
          // Add to buffer
          logBuffer.push(logEntry);
          
          // Flush buffer with debounce (100ms for better performance)
          clearTimeout(flushTimeout);
          flushTimeout = setTimeout(flushLogBuffer, 100);
        }
        
        // Debounced console methods to reduce frequency
        console.log = debounce(function(...args) {
          originalConsole.log.apply(console, args);
          sendToConsole('log', args);
        }, 50);
        
        console.error = function(...args) {
          originalConsole.error.apply(console, args);
          sendToConsole('error', args); // No debounce for errors
        };
        
        console.warn = debounce(function(...args) {
          originalConsole.warn.apply(console, args);
          sendToConsole('warn', args);
        }, 100);
        
        console.info = debounce(function(...args) {
          originalConsole.info.apply(console, args);
          sendToConsole('info', args);
        }, 150);
        
        // Handle uncaught errors
        window.onerror = function(msg, source, lineno, colno, error) {
          sendToConsole('error', [msg + ' at ' + source + ':' + lineno + ':' + colno]);
          return false;
        };
        
        // Flush buffer on page unload
        window.addEventListener('beforeunload', flushLogBuffer);
      })();
    </script>'''
        
        # Replace </body> with console script + </body>
        return re.sub(r'</body\s*>', console_script + '</body>', html_content, flags=re.IGNORECASE)
    
    def inject_live_reload_script(self, html_content):
        """Inject live reload script into HTML content."""
        # Get the actual WebSocket port (might be different from default)
        actual_ws_port = globals().get('LIVE_RELOAD_PORT', 12002)
        
        live_reload_script = '''<script>
    (function() {
      const ws = new WebSocket('ws://localhost:''' + str(actual_ws_port) + '''');
      
      ws.onopen = function() {
        console.log('Live reload connected');
      };
      
      ws.onclose = function() {
        console.log('Live reload disconnected');
        // Try to reconnect after 1 second
        setTimeout(function() {
          window.location.reload();
        }, 1000);
      };
      
      ws.onmessage = function(event) {
        const data = JSON.parse(event.data);
        if (data.type === 'reload') {
          console.log('File changed, reloading page...');
          window.location.reload();
        } else if (data.type === 'connected') {
          console.log(data.message);
        }
      };
      
      ws.onerror = function(error) {
        console.log('Live reload error:', error);
      };
    })();
  </script>'''
        
        # Insert live reload script after console script
        return html_content.replace('</body>', live_reload_script + '</body>')
    
    def inject_scripts(self, html_content):
        """Inject both console and live reload scripts."""
        content = self.inject_console_script(html_content)
        return self.inject_live_reload_script(content)

def start_websocket_server():
    """Start simple WebSocket server for live reload."""
    import socket
    
    # Try to find an available port for WebSocket
    ws_port = LIVE_RELOAD_PORT
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    
    # Try binding to the default port first, then alternatives
    for attempt in range(10):
        try:
            server_socket.bind(('localhost', ws_port))
            server_socket.listen(5)
            print(f"Live reload WebSocket server running on ws://localhost:{ws_port}")
            break
        except OSError as e:
            if e.errno == 98:  # Address already in use
                ws_port += 1
                continue
            else:
                raise e
    
    return server_socket, ws_port
    
    def handle_client(client_socket, address):
        reload_clients.add(client_socket)
        try:
            # Send connected message
            message = json.dumps({
                'type': 'connected',
                'message': 'Live reload connected'
            })
            client_socket.send(message.encode())
            
            # Keep connection alive
            while True:
                try:
                    data = client_socket.recv(1024)
                    if not data:
                        break
                except:
                    break
        except:
            pass
        finally:
            reload_clients.discard(client_socket)
            client_socket.close()
    
    def accept_connections():
        while True:
            try:
                client_socket, address = server_socket.accept()
                client_thread = threading.Thread(target=handle_client, args=(client_socket, address))
                client_thread.daemon = True
                client_thread.start()
            except:
                break
    
    # Start accepting connections in separate thread
    accept_thread = threading.Thread(target=accept_connections)
    accept_thread.daemon = True
    accept_thread.start()
    
    return server_socket

def start_file_watcher():
    """Start simple file watcher for live reload."""
    import os
    import time
    
    print("Starting simple file watcher...")
    
    def watch_directory():
        """Improved file watching using modification time tracking."""
        last_files = {}  # Store file paths with their modification times
        
        while True:
            try:
                current_files = {}
                for root, dirs, files in os.walk(DIRECTORY):
                    # Skip ignored directories
                    dirs[:] = [d for d in dirs if not any(ignore in d for ignore in ['.git', 'node_modules', 'dist', 'build'])]
                    
                    for file in files:
                        if any(file.endswith(ext) for ext in ['.js', '.css', '.html', '.json']):
                            file_path = os.path.join(root, file)
                            try:
                                mod_time = os.path.getmtime(file_path)
                                current_files[file_path] = mod_time
                                
                                # Check if file is new or modified
                                if file_path not in last_files or last_files[file_path] != mod_time:
                                    trigger_reload(file_path)
                            except OSError:
                                # File might be deleted or inaccessible
                                continue
                
                last_files = current_files
                time.sleep(0.5)  # Check every 0.5 seconds for better responsiveness
                
            except Exception as e:
                print(f"File watcher error: {e}")
                time.sleep(1)
    
    def trigger_reload(file_path):
        """Send reload signal to all connected clients."""
        global last_reload_time
        current_time = time.time()
            
        # Debounce (avoid multiple reloads for same save)
        if current_time - last_reload_time < DEBOUNCE_TIME:
            return
            
        last_reload_time = current_time
        
        if reload_clients:
            message = json.dumps({
                'type': 'reload',
                'file': file_path,
                'timestamp': current_time
            })
            
            disconnected_clients = set()
            for client in list(reload_clients):
                try:
                    client.send(message.encode())
                except:
                    disconnected_clients.add(client)
            
            # Remove disconnected clients
            reload_clients.difference_update(disconnected_clients)
            print(f"Reload triggered for: {file_path}")
    
    # Start file watcher in separate thread
    watcher_thread = threading.Thread(target=watch_directory)
    watcher_thread.daemon = True
    watcher_thread.start()
    
    return watcher_thread

def run_server():
    # Start file watcher
    watcher = start_file_watcher()
    
    # Start WebSocket server
    ws_server = None
    try:
        ws_server, ws_port = start_websocket_server()
        # Update LIVE_RELOAD_PORT for JavaScript injection
        globals()['LIVE_RELOAD_PORT'] = ws_port
    except Exception as e:
        print(f"Failed to start WebSocket server: {e}")
    
    # Start HTTP server
    try:
        with socketserver.TCPServer(("", PORT), P5HTTPRequestHandler) as httpd:
            print(f"Server running at http://localhost:{PORT}/")
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\\nServer stopped")
    finally:
        if ws_server:
            ws_server.close()

if __name__ == "__main__":
    run_server()