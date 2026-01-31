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
    
    def do_GET(self):
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
    
    def translate_path(self, path):
        path = unquote(path)
        if path.startswith('/'):
            path = path[1:]
        return os.path.join(DIRECTORY, path)
    
    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()
    
    def log_message(self, format, *args):
        # Suppress default logging
        pass
    
    def inject_console_script(self, html_content):
        """Inject WebSocket console script into HTML content."""
        console_script = '''
  <script>
    (function() {
      const ws = new WebSocket('ws://localhost:12001');
      
      ws.onopen = function() {
        console.log('Connected to p5.nvim console');
      };
      
      ws.onclose = function() {
        console.log('Disconnected from p5.nvim console');
      };
      
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
        
        ws.send(JSON.stringify({
          type: 'console',
          level: level,
          message: message,
          source: 'javascript',
          timestamp: new Date().toISOString()
        }));
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
        ws.send(JSON.stringify({
          type: 'console',
          level: 'error',
          message: msg + ' at ' + source + ':' + lineno + ':' + colno,
          source: 'javascript',
          timestamp: new Date().toISOString()
        }));
        return false;
      };
    })();
  </script>'''
        
        # Replace </body> with console script + </body>
        return re.sub(r'</body\s*>', console_script + '</body>', html_content, flags=re.IGNORECASE)
    
    def inject_live_reload_script(self, html_content):
        """Inject live reload script into HTML content."""
        live_reload_script = '''
  <script>
    (function() {
      const ws = new WebSocket('ws://localhost:12002');
      
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
    
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(('localhost', LIVE_RELOAD_PORT))
    server_socket.listen(5)
    
    print(f"Live reload WebSocket server running on ws://localhost:{LIVE_RELOAD_PORT}")
    
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
        """Simple file watching using os.listdir polling."""
        last_files = set()
        
        while True:
            try:
                current_files = set()
                for root, dirs, files in os.walk(DIRECTORY):
                    # Skip ignored directories
                    dirs[:] = [d for d in dirs if not any(ignore in d for ignore in ['.git', 'node_modules', 'dist', 'build'])]
                    
                    for file in files:
                        if any(file.endswith(ext) for ext in ['.js', '.css', '.html', '.json']):
                            file_path = os.path.join(root, file)
                            current_files.add(file_path)
                            
                            # Check if file is new or modified
                            if file_path not in last_files:
                                trigger_reload(file_path)
                
                last_files = current_files
                time.sleep(1)  # Check every second
                
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
        ws_server = start_websocket_server()
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