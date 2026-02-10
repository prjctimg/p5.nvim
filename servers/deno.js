// Deno live server script with live reload
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { dirname, join, extname, basename } from "https://deno.land/std@0.208.0/path/mod.ts";
import { exists, readFile } from "https://deno.land/std@0.208.0/fs/mod.ts";

const port = parseInt(Deno.args[0]) || 8000;
const LIVE_RELOAD_PORT = 12002;
const DEBOUNCE_TIME = 300; // ms

// Live reload tracking
let lastReloadTime = 0;

// Console log buffer for HTTP-based log streaming
let consoleLogBuffer: any[] = [];

const MIME_TYPES: Record<string, string> = {
  ".html": "text/html",
  ".js": "text/javascript",
  ".css": "text/css",
  ".json": "application/json",
  ".png": "image/png",
  ".jpg": "image/jpg",
  ".gif": "image/gif",
  ".svg": "image/svg+xml",
  ".wav": "audio/wav",
  ".mp4": "video/mp4",
  ".woff": "application/font-woff",
  ".ttf": "application/font-ttf",
  ".eot": "application/vnd.ms-fontobject",
  ".otf": "application/font-otf",
  ".wasm": "application/wasm"
};

function injectConsoleScript(htmlContent: string): string {
  const consoleScript = `
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
      
      function sendToConsole(level: string, args: any[]) {
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
        
        // Send via HTTP POST to server endpoint
        fetch('/api/console/log', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            type: 'console',
            level: level,
            message: message,
            source: 'javascript',
            timestamp: new Date().toISOString()
          })
        }).catch(err => {
          // Silently fail if server is unavailable
        });
      }
      
      console.log = function(...args: any[]) {
        originalConsole.log.apply(console, args);
        sendToConsole('log', args);
      };
      
      console.error = function(...args: any[]) {
        originalConsole.error.apply(console, args);
        sendToConsole('error', args);
      };
      
      console.warn = function(...args: any[]) {
        originalConsole.warn.apply(console, args);
        sendToConsole('warn', args);
      };
      
      console.info = function(...args: any[]) {
        originalConsole.info.apply(console, args);
        sendToConsole('info', args);
      };
      
      // Handle uncaught errors
      window.onerror = function(msg: string | Event, source: string, lineno: number, colno: number, error: Error) {
        fetch('/api/console/log', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            type: 'console',
            level: 'error',
            message: msg + ' at ' + source + ':' + lineno + ':' + colno,
            source: 'javascript',
            timestamp: new Date().toISOString()
          })
        }).catch(err => {
          // Silently fail if server is unavailable
        });
        return false;
      };
    })();
  </script>`;
  
  return htmlContent.replace('</body>', consoleScript + '</body>');
}

function injectLiveReloadScript(htmlContent: string): string {
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

function triggerReload(filePath: string) {
  const currentTime = Date.now();
  
  // Debounce (avoid multiple reloads for same save)
  if (currentTime - lastReloadTime < DEBOUNCE_TIME) {
    return;
  }
  
  lastReloadTime = currentTime;
  
  console.log(`File changed: ${filePath}`);
  
  // Store change for WebSocket to detect
  // In a real implementation, this would send a message to WebSocket clients
  // For now, we'll rely on client-side polling
}

async function startFileWatcher(): Promise<void> {
  console.log('Starting file watcher...');
  
  // Simple file watching using Deno.watchFs
  const watcher = Deno.watchFs(process.cwd(), {
    recursive: true
  });
  
  for await (const event of watcher) {
    // Only watch for relevant file types
    if (event.kind === 'modify' && /\.(js|css|html|json)$/i.test(event.paths[0])) {
      triggerReload(event.paths[0]);
    }
  }
}

async function handler(req: Request): Promise<Response> {
  const url = new URL(req.url);
  let pathname = url.pathname;

  // Handle console log POST requests
  if (req.method === "POST" && pathname === "/api/console/log") {
    try {
      const body = await req.text();
      const logEntry = JSON.parse(body);
      if (!logEntry.timestamp) {
        logEntry.timestamp = new Date().toISOString();
      }
      consoleLogBuffer.push(logEntry);
      
      return new Response(JSON.stringify({ status: "received" }), {
        status: 200,
        headers: {
          "Content-Type": "application/json",
        },
      });
    } catch (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 400,
        headers: {
          "Content-Type": "application/json",
        },
      });
    }
  }

  // Handle console poll GET requests
  if (req.method === "GET" && pathname === "/api/console/poll") {
    const logs: any[] = [];
    while (consoleLogBuffer.length > 0) {
      logs.push(consoleLogBuffer.shift());
    }
    
    return new Response(JSON.stringify(logs), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
      },
    });
  }

  if (pathname === "/") {
    pathname = "/index.html";
  }

  const filePath = join(Deno.cwd(), pathname);
  const ext = extname(filePath);
  const mimeType = MIME_TYPES[ext] || "application/octet-stream";

  try {
    const fileExists = await exists(filePath);
    if (!fileExists) {
      return new Response("File not found", { status: 404 });
    }

    const data = await readFile(filePath);
    let content = new TextDecoder().decode(data);

    // Inject HTTP console script for HTML files
    if (ext === ".html") {
      content = injectConsoleScript(content);
    }
    
    // Inject live reload script for HTML files
    if (ext === ".html") {
      content = injectLiveReloadScript(content);
    }

    return new Response(content, {
      status: 200,
      headers: {
        "Content-Type": mimeType,
      },
    });
  } catch (error) {
    console.error("Error serving file:", error);
    return new Response("Internal server error", { status: 500 });
  }
}

console.log(`Server running at http://localhost:${port}/`);
console.log(`Live reload enabled on port ${LIVE_RELOAD_PORT}`);

// Start file watcher
startFileWatcher().catch(error => {
  console.error("File watcher error:", error);
});

await serve(handler, {
  port: port,
});