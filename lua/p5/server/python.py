import sys
import os
import threading
import time
import json
import subprocess
from http.server import HTTPServer, SimpleHTTPRequestHandler
from websocket_server import WebsocketServer
import argparse

class P5HTTPHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.getcwd(), **kwargs)
    
    def end_headers(self):
        # Enable CORS for development
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()
    
    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()
    
    def log_message(self, format, *args):
        # Suppress default logging for cleaner output
        pass

class P5DevServer:
    def __init__(self, port=8000, websocket_port=8001):
        self.port = port
        self.websocket_port = websocket_port
        self.http_server = None
        self.websocket_server = None
        self.running = False
        self.clients = []
        
    def start_http_server(self):
        try:
            self.http_server = HTTPServer(('localhost', self.port), P5HTTPHandler)
            print(f"📡 HTTP server started on http://localhost:{self.port}")
            self.http_server.serve_forever()
        except Exception as e:
            print(f"❌ Failed to start HTTP server: {e}")
            sys.exit(1)
    
    def start_websocket_server(self):
        def new_client(client, server):
            print(f"🔗 New WebSocket connection from {client['id']}")
            self.clients.append(client)
            
            # Send welcome message with console capture script
            welcome_script = self.get_console_capture_script()
            self.send_to_client(client, {
                'type': 'console_capture',
                'script': welcome_script
            })
        
        def client_left(client, server):
            print(f"🔌 WebSocket connection closed: {client['id']}")
            if client in self.clients:
                self.clients.remove(client)
        
        def message_received(client, server, message):
            try:
                data = json.loads(message)
                if data['type'] == 'console_log':
                    # Forward console logs to Neovim
                    self.handle_console_log(data)
            except json.JSONDecodeError:
                print(f"⚠️  Invalid JSON received from client")
        
        try:
            self.websocket_server = WebsocketServer(self.websocket_port, host='localhost')
            self.websocket_server.set_fn_new_client(new_client)
            self.websocket_server.set_fn_client_left(client_left)
            self.websocket_server.set_fn_message_received(message_received)
            print(f"🔌 WebSocket server started on ws://localhost:{self.websocket_port}")
            self.websocket_server.run_forever()
        except Exception as e:
            print(f"❌ Failed to start WebSocket server: {e}")
            print("💡 Install websocket-server: pip install websocket-server")
    
    def get_console_capture_script(self):
        return """
<script>
// Console capture script injected by p5.nvim
(function() {
    const originalLog = console.log;
    const originalWarn = console.warn;
    const originalError = console.error;
    const originalInfo = console.info;
    
    const socket = new WebSocket('ws://localhost:%d');
    
    function sendLog(type, args) {
        try {
            socket.send(JSON.stringify({
                type: 'console_log',
                level: type,
                args: Array.from(args).map(arg => {
                    if (typeof arg === 'object') {
                        try {
                            return JSON.stringify(arg);
                        } catch (e) {
                            return String(arg);
                        }
                    }
                    return String(arg);
                }),
                timestamp: Date.now()
            }));
        } catch (e) {
            // WebSocket might not be ready yet
        }
    }
    
    console.log = function(...args) {
        originalLog.apply(console, args);
        sendLog('log', args);
    };
    
    console.warn = function(...args) {
        originalWarn.apply(console, args);
        sendLog('warn', args);
    };
    
    console.error = function(...args) {
        originalError.apply(console, args);
        sendLog('error', args);
    };
    
    console.info = function(...args) {
        originalInfo.apply(console, args);
        sendLog('info', args);
    };
    
    socket.onopen = function() {
        console.log('[p5.nvim] Console capture enabled');
    };
    
    socket.onerror = function(error) {
        console.error('[p5.nvim] WebSocket error:', error);
    };
    
    socket.onclose = function() {
        console.log('[p5.nvim] Console capture disabled');
    };
})();
</script>
""" % self.websocket_port
    
    def send_to_client(self, client, data):
        try:
            if isinstance(data, dict):
                message = json.dumps(data)
            else:
                message = str(data)
            self.websocket_server.send_message(client, message)
        except Exception as e:
            print(f"⚠️  Failed to send message to client {client['id']}: {e}")
    
    def handle_console_log(self, data):
        # This will be handled by Neovim through stdout/stderr communication
        log_entry = {
            'type': 'console_log',
            'level': data['level'],
            'args': data['args'],
            'timestamp': data['timestamp']
        }
        
        # Send to stdout for Neovim to capture
        print(f"P5_CONSOLE_LOG:{json.dumps(log_entry)}")
        sys.stdout.flush()
    
    def start(self):
        print(f"🚀 Starting p5.nvim development server...")
        print(f"📁 Serving directory: {os.getcwd()}")
        print(f"🌐 HTTP server: http://localhost:{self.port}")
        print(f"🔌 WebSocket server: ws://localhost:{self.websocket_port}")
        print(f"📊 Browser console will be captured and forwarded to Neovim")
        print("Press Ctrl+C to stop the server")
        print("-" * 50)
        
        self.running = True
        
        # Start WebSocket server in a separate thread
        ws_thread = threading.Thread(target=self.start_websocket_server, daemon=True)
        ws_thread.start()
        
        # Give WebSocket server time to start
        time.sleep(0.5)
        
        # Start HTTP server in main thread
        try:
            self.start_http_server()
        except KeyboardInterrupt:
            print("\n🛑 Shutting down servers...")
            self.stop()
    
    def stop(self):
        self.running = False
        
        if self.http_server:
            self.http_server.shutdown()
            print("📡 HTTP server stopped")
        
        if self.websocket_server:
            self.websocket_server.shutdown()
            print("🔌 WebSocket server stopped")
        
        print("✅ All servers stopped")

def check_dependencies():
    """Check if required dependencies are installed"""
    try:
        import websocket_server
        return True
    except ImportError:
        print("❌ Missing dependency: websocket-server")
        print("💡 Install with: pip install websocket-server")
        return False

def main():
    parser = argparse.ArgumentParser(description='Enhanced p5.js development server with WebSocket support')
    parser.add_argument('--port', type=int, default=8000, help='HTTP server port (default: 8000)')
    parser.add_argument('--websocket-port', type=int, default=8001, help='WebSocket server port (default: 8001)')
    
    args = parser.parse_args()
    
    if not check_dependencies():
        sys.exit(1)
    
    server = P5DevServer(args.port, args.websocket_port)
    
    try:
        server.start()
    except KeyboardInterrupt:
        server.stop()

if __name__ == '__main__':
    main()