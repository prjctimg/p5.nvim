#!/usr/bin/env python3
import http.server
import socketserver
import sys
import os
import re
from urllib.parse import unquote

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
DIRECTORY = os.getcwd()

class P5HTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
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
                
                # Inject console script
                modified_content = self.inject_console_script(content)
                
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
        
        # Replace </body> with script + </body>
        return re.sub(r'</body\s*>', console_script + '</body>', html_content, flags=re.IGNORECASE)

def run_server():
    with socketserver.TCPServer(("", PORT), P5HTTPRequestHandler) as httpd:
        print(f"Server running at http://localhost:{PORT}/")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\\nServer stopped")

if __name__ == "__main__":
    run_server()