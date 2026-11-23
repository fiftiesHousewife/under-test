// Exports an Excalidraw drawing to SVG with Excalidraw's own export code, run in a browser. It serves that code and the
// drawing on a local address, saves the SVG the page posts back, then exits. See README.md.
import { createServer } from 'node:http';
import { readFileSync, writeFileSync } from 'node:fs';
import { join, extname } from 'node:path';

const [input, output, port = '8765'] = process.argv.slice(2);
if (!input || !output) {
  console.error('usage: node export-drawing.mjs <drawing.excalidraw> <drawing.svg> [port]');
  process.exit(1);
}
const root = new URL('./node_modules/@excalidraw/utils/dist/prod/', import.meta.url).pathname;
const types = { '.js': 'text/javascript', '.woff2': 'font/woff2', '.json': 'application/json' };
const page = `<!doctype html><html><body><p id="status">Exporting...</p><script type="module">
window.EXCALIDRAW_ASSET_PATH = location.origin + '/';
const status = document.getElementById('status');
try {
  const scene = await (await fetch('/scene.json')).json();
  const { exportScene } = await import('/index.js');
  const el = await exportScene({
    data: { elements: scene.elements.filter(e => !e.isDeleted), appState: scene.appState, files: scene.files || {} },
    type: 'svg',
    config: { canvasBackgroundColor: scene.appState?.viewBackgroundColor || '#ffffff', padding: 30 },
  });
  const r = await fetch('/result', { method: 'POST', body: el.outerHTML });
  status.textContent = r.ok ? 'Saved' : 'Save failed';
} catch (e) {
  status.textContent = 'Failed: ' + e;
  await fetch('/result?error=1', { method: 'POST', body: String(e.stack || e) });
}
</script></body></html>`;

const server = createServer((req, res) => {
  const path = req.url.split('?')[0];
  if (path === '/') {
    res.setHeader('content-type', 'text/html');
    return res.end(page);
  }
  if (path === '/scene.json') {
    res.setHeader('content-type', 'application/json');
    return res.end(readFileSync(input));
  }
  if (path === '/result' && req.method === 'POST') {
    const chunks = [];
    req.on('data', c => chunks.push(c));
    req.on('end', () => {
      const body = Buffer.concat(chunks).toString('utf8');
      if (req.url.includes('error')) {
        console.log('Export failed in the browser:\n' + body);
      } else {
        writeFileSync(output, body);
        console.log(`Wrote ${output}, ${body.length} bytes`);
      }
      res.end('ok');
      server.close();
    });
    return;
  }
  try {
    const p = join(root, decodeURIComponent(path));
    res.setHeader('content-type', types[extname(p)] || 'application/octet-stream');
    res.end(readFileSync(p));
  } catch {
    res.statusCode = 404;
    res.end();
  }
}).listen(Number(port), '127.0.0.1', () => console.log(`Serving on http://127.0.0.1:${port}/`));
