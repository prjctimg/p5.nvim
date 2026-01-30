// Bun live server script
const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const port = process.argv[2] || 8000;

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
    if (ext === '.html') {
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

      data = data.toString().replace('</body>', consoleScript + '</body>');
    }

    res.writeHead(200, { 'Content-Type': mimeType });
    res.end(data);
  });
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});

process.on('SIGTERM', () => {
  server.close();
  process.exit(0);
});

process.on('SIGINT', () => {
  server.close();
  process.exit(0);
});