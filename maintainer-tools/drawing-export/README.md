# Drawing export (for toolkit maintainers)

Turns an Excalidraw drawing into the SVG the README shows, with Excalidraw's own export code, so the SVG looks the
same as the drawing: hand-drawn shapes, and Excalidraw's font built into the file. GitHub can't show a `.excalidraw`
file itself.

Once per clone, install Excalidraw's export library (Node.js and npm needed):

```bash
npm install --prefix maintainer-tools/drawing-export
```

After changing a drawing, export it:

```bash
node maintainer-tools/drawing-export/export-drawing.mjs docs/design/repo-journey.excalidraw docs/design/repo-journey.svg
```

Then open <http://127.0.0.1:8765/> in a browser. The page exports the drawing, sends the SVG back, and shows
"Saved"; the script writes the SVG and stops. Commit the drawing and its SVG together. A third argument chooses
another port.

The export runs in an ordinary browser tab because Excalidraw's export code needs one to measure text. The script
listens only on the local address and serves nothing but that code and the one drawing.
