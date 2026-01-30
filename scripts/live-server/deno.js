// Deno live server script
import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { dirname, join, extname, basename } from "https://deno.land/std@0.208.0/path/mod.ts";
import { exists, readFile } from "https://deno.land/std@0.208.0/fs/mod.ts";

const port = parseInt(Deno.args[0]) || 8000;
const __dirname = dirname(Deno.cwd());

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

async function handler(req: Request): Promise<Response> {
  const url = new URL(req.url);
  let pathname = url.pathname;

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
    let content = data;

    if (ext === ".html") {
      const htmlContent = new TextDecoder().decode(data);
      const modifiedHtml = htmlContent.replace("</body>", consoleScript + "</body>");
      content = new TextEncoder().encode(modifiedHtml);
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

await serve(handler, {
  port: port,
});