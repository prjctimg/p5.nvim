// Node.js live server script with live reload
const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const port = process.argv[2] || 8000;
const LIVE_RELOAD_PORT = 12002;
const DEBOUNCE_TIME = 300; // ms

// Live reload tracking
let lastReloadTime = 0;

const MIME_TYPES = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.wav': 'audio/wav',
  '.mp4': 'video/mp4',
  '.woff': 'application/font-woff',
  '.ttf': 'application/font-ttf',
  '.eot': 'application/vnd.ms-fontobject',
  '.otf': 'application/font-otf',
  '.wasm': 'application/wasm'
};

function injectConsoleScript(htmlContent) {
  const consoleScript = `
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
  </script>`;
  
  return htmlContent.replace('</body>', consoleScript + '</body>');
}

function injectLiveReloadScript(htmlContent) {
  const liveReloadScript = `
  <script>
    (function() {
      let ws;
      let reconnectAttempts = 0;
      
      function connectWebSocket() {
        ws = new WebSocket('ws://localhost:${LIVE_RELOAD_PORT}');
        
        ws.onopen = function() {
          console.log('Live reload connected');
          reconnectAttempts = 0;
        };
        
        ws.onclose = function() {
          console.log('Live reload disconnected');
          // Try to reconnect after 1 second
          if (reconnectAttempts < 5) {
            setTimeout(connectWebSocket, 1000);
            reconnectAttempts++;
          } else {
            console.log('Max reconnection attempts reached');
          }
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
      }
      
      connectWebSocket();
    })();
  </script>`;
  
  // Insert live reload script after console script
  const withConsole = injectConsoleScript(htmlContent);
  return withConsole.replace('</body>', liveReloadScript + '</body>');
}

function triggerReload(filePath) {
  const currentTime = Date.now();
  
  // Debounce (avoid multiple reloads for same save)
  if (currentTime - lastReloadTime < DEBOUNCE_TIME) {
    return;
  }
  
  lastReloadTime = currentTime;
  
  console.log(`File changed: ${filePath}`);
}

function startFileWatcher() {
  console.log('Starting file watcher...');
  
  // Simple file watching using fs.watch
  const watchOptions = {
    recursive: true,
    ignored: /(^|[\/\\]\.)(?:git|node_modules|dist|build)(?:$|[\/\\])/g
  };
  
  fs.watch(process.cwd(), watchOptions, (eventType, filename) => {
    // Only watch for relevant file types
    if (filename && /\.(js|css|html|json)$/i.test(filename)) {
      triggerReload(filename);
    }
  });
  
  return null;
}

const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url);
  let pathname = parsedUrl.pathname;

  // Default to index.html
  if (pathname === '/') {
    pathname = '/index.html';
  }

  const filePath = path.join(process.cwd(), pathname);
  const ext = path.parse(filePath).ext;
  const mimeType = MIME_TYPES[ext] || 'application/octet-stream';

  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end('File not found');
      return;
    }

    // Inject WebSocket console script for HTML files
    let content = data;
    if (ext === '.html') {
      content = injectConsoleScript(data.toString());
    }
    
    // Inject live reload script for HTML files
    if (ext === '.html') {
      content = injectLiveReloadScript(content);
    }

    res.writeHead(200, { 'Content-Type': mimeType });
    res.end(content);
  });
});

// Start file watcher
startFileWatcher();

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
  console.log(`Live reload enabled on port ${LIVE_RELOAD_PORT}`);
});

process.on('SIGTERM', () => {
  server.close();
  process.exit(0);
});

process.on('SIGINT', () => {
  server.close();
  process.exit(0);
});