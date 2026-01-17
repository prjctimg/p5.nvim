-- Templates for p5.nvim
-- Contains HTML, CSS, JS templates and URL generation
local T = {}
-- URL templates for jsDelivr CDN
T.urls = {
	jsdelivr_base = "https://cdn.jsdelivr.net/npm",
	unpkg_base = "https://unpkg.com",
	libraries = {
		-- Official p5.js libraries
		core_template = "p5@{version}/lib/p5.js",
		sound = "p5@{version}/lib/addons/p5.sound.js",
		dom = "p5@{version}/lib/addons/p5.dom.js",

		-- Popular community libraries
		ml5 = "ml5@0.12.2/dist/ml5.min.js",
		collide2d = "p5.collide2d@0.6.8/p5.collide2d.min.js",
		p5play = "p5play@latest/dist/p5play.js",

		-- Drawing and graphics libraries
		p5_brush = "p5.brush@latest/dist/p5.brush.js",
		p5_fillgradient = "p5.fillgradient@latest/dist/p5.fillGradient.js",
		p5_grain = "p5.grain@latest/dist/p5.grain.js",
		p5_pattern = "p5.pattern@latest/dist/p5.pattern.js",
		p5_polar = "p5.polar@latest/dist/p5.Polar.js",
		p5_sprite = "p5.Sprite@latest/dist/p5.Sprite.js",
		p5grid = "p5grid@latest/dist/p5grid.js",
		svg_shapes = "svg-shapes-p5js@latest/dist/svg-shapes-p5js.js",
		tilemap = "tilemapp5js@latest/dist/Tilemapp5js.js",

		-- Color libraries
		p5_cmyk = "p5.cmyk@latest/dist/p5.cmyk.js",
		p5_colorgenerator = "p5.colorgenerator@latest/dist/p5.colorGenerator.js",
		p5_palette = "p5.palette@latest/dist/p5.palette.js",

		-- Animation libraries
		p5_createloop = "p5.createloop@latest/dist/p5.createLoop.js",
		p5_tween = "p5.tween@latest/dist/p5.tween.js",
		p5_glitch = "p5.glitch@latest/dist/p5.glitch.js",

		-- 3D libraries
		p5_csg = "p5.csg@latest/dist/p5.csg.js",
		p5_transparency = "p5.transparency@latest/dist/p5.transparency.js",
		p5_warp = "p5.warp@latest/dist/p5.warp.js",

		-- Utility libraries
		p5_fps = "p5.fps@latest/dist/p5.fps.js",
		p5_scaler = "p5.scaler@latest/dist/p5.scaler.js",
		p5_scenemanager = "p5.scenemanager@latest/dist/p5.SceneManager.js",

		-- Export libraries
		p5_capture = "p5.capture@latest/dist/p5.capture.js",
		p5_record = "p5.record.js@latest/dist/p5.record.js",
		p5_riso = "p5.riso@latest/dist/p5.Riso.js",
	},
	types = {
		base = "https://cdn.jsdelivr.net/npm/@types",
		p5 = "p5/index.d.ts",
		p5_sound = "p5/lib/addons/p5.sound.d.ts",
		p5_dom = "p5/lib/addons/p5.dom.d.ts",
		ml5 = "ml5/index.d.ts",
		-- Note: Most community libraries don't have official TypeScript definitions
	},
}
-- Library catalog with descriptions
T.library_catalog = {
	-- Official p5.js addon libraries
	{
		name = "sound",
		description = "Audio synthesis and analysis",
		url_key = "sound",
		types_key = "p5_sound",
		filename = "p5.sound.js",
		types_filename = "p5.sound.d.ts",
		category = "official",
	},
	{
		name = "dom",
		description = "DOM manipulation",
		url_key = "dom",
		types_key = "p5_dom",
		filename = "p5.dom.js",
		types_filename = "p5.dom.d.ts",
		category = "official",
	},

	-- Popular community libraries with CDN access
	{
		name = "ml5",
		description = "Friendly machine learning for the web",
		url_key = "ml5",
		types_key = "ml5",
		filename = "ml5.min.js",
		types_filename = "ml5.d.ts",
		category = "ai-ml",
	},
	{
		name = "collide2d",
		description = "2D collision detection",
		url_key = "collide2d",
		types_key = nil,
		filename = "p5.collide2d.min.js",
		types_filename = nil,
		category = "math",
	},
	{
		name = "p5play",
		description = "Game engine with physics (Box2D)",
		url_key = "p5play",
		types_key = nil,
		filename = "p5play.js",
		types_filename = nil,
		category = "physics",
	},

	-- Drawing and graphics libraries
	{
		name = "p5.brush",
		description = "Custom brushes and natural fill effects",
		url_key = "p5_brush",
		types_key = nil,
		filename = "p5.brush.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "p5.fillGradient",
		description = "Linear, radial and conic gradients",
		url_key = "p5_fillgradient",
		types_key = nil,
		filename = "p5.fillGradient.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "p5.grain",
		description = "Film grain and texture overlays",
		url_key = "p5_grain",
		types_key = nil,
		filename = "p5.grain.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "p5.pattern",
		description = "Pattern drawing library",
		url_key = "p5_pattern",
		types_key = nil,
		filename = "p5.pattern.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "p5.Polar",
		description = "Radial patterns and kaleidoscopic designs",
		url_key = "p5_polar",
		types_key = nil,
		filename = "p5.Polar.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "p5.Sprite",
		description = "Animated and static sprites",
		url_key = "p5_sprite",
		types_key = nil,
		filename = "p5.Sprite.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "p5grid",
		description = "Hexagonal tiling library",
		url_key = "p5grid",
		types_key = nil,
		filename = "p5grid.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "svg-shapes-p5js",
		description = "SVG drawing library",
		url_key = "svg_shapes",
		types_key = nil,
		filename = "svg-shapes-p5js.js",
		types_filename = nil,
		category = "drawing",
	},
	{
		name = "Tilemapp5js",
		description = "Simple tilemap library",
		url_key = "tilemap",
		types_key = nil,
		filename = "Tilemapp5js.js",
		types_filename = nil,
		category = "drawing",
	},

	-- Color libraries
	{
		name = "p5.cmyk",
		description = "CMYK color support",
		url_key = "p5_cmyk",
		types_key = nil,
		filename = "p5.cmyk.js",
		types_filename = nil,
		category = "color",
	},
	{
		name = "p5.colorGenerator",
		description = "Harmonious color schemes generator",
		url_key = "p5_colorgenerator",
		types_key = nil,
		filename = "p5.colorGenerator.js",
		types_filename = nil,
		category = "color",
	},
	{
		name = "p5.palette",
		description = "Color palette management",
		url_key = "p5_palette",
		types_key = nil,
		filename = "p5.palette.js",
		types_filename = nil,
		category = "color",
	},

	-- Animation libraries
	{
		name = "p5.createLoop",
		description = "Animation loops with GIF export",
		url_key = "p5_createloop",
		types_key = nil,
		filename = "p5.createLoop.js",
		types_filename = nil,
		category = "animation",
	},
	{
		name = "p5.tween",
		description = "Animation tweens and transitions",
		url_key = "p5_tween",
		types_key = nil,
		filename = "p5.tween.js",
		types_filename = nil,
		category = "animation",
	},
	{
		name = "p5.glitch",
		description = "Image and binary glitching effects",
		url_key = "p5_glitch",
		types_key = nil,
		filename = "p5.glitch.js",
		types_filename = nil,
		category = "animation",
	},

	-- 3D libraries
	{
		name = "p5.csg",
		description = "Constructive solid geometry",
		url_key = "p5_csg",
		types_key = nil,
		filename = "p5.csg.js",
		types_filename = nil,
		category = "3d",
	},
	{
		name = "p5.transparency",
		description = "Transparency for WebGL mode",
		url_key = "p5_transparency",
		types_key = nil,
		filename = "p5.transparency.js",
		types_filename = nil,
		category = "3d",
	},
	{
		name = "p5.warp",
		description = "Fast 3D domain warping",
		url_key = "p5_warp",
		types_key = nil,
		filename = "p5.warp.js",
		types_filename = nil,
		category = "3d",
	},

	-- Utility libraries
	{
		name = "p5.fps",
		description = "Simple FPS counter",
		url_key = "p5_fps",
		types_key = nil,
		filename = "p5.fps.js",
		types_filename = nil,
		category = "utility",
	},
	{
		name = "p5.scaler",
		description = "Smart sketch scaling",
		url_key = "p5_scaler",
		types_key = nil,
		filename = "p5.scaler.js",
		types_filename = nil,
		category = "utility",
	},
	{
		name = "p5.SceneManager",
		description = "Multi-scene sketches",
		url_key = "p5_scenemanager",
		types_key = nil,
		filename = "p5.SceneManager.js",
		types_filename = nil,
		category = "utility",
	},

	-- Export libraries
	{
		name = "p5.capture",
		description = "Sketch recording tool",
		url_key = "p5_capture",
		types_key = nil,
		filename = "p5.capture.js",
		types_filename = nil,
		category = "export",
	},
	{
		name = "p5.record.js",
		description = "Canvas recording with audio",
		url_key = "p5_record",
		types_key = nil,
		filename = "p5.record.js",
		types_filename = nil,
		category = "export",
	},
	{
		name = "p5.Riso",
		description = "Risograph printing files",
		url_key = "p5_riso",
		types_key = nil,
		filename = "p5.Riso.js",
		types_filename = nil,
		category = "export",
	},
}
-- HTML template
function T.get_html_template(version, libraries)
	local lib_tags = ""
	-- Add core library
	lib_tags = lib_tags .. '    <script src="lib/p5.js"></script>\n'
	-- Add selected libraries
	for _, lib in ipairs(libraries) do
		if lib.filename then
			lib_tags = lib_tags .. string.format('    <script src="lib/%s"></script>\n', lib.filename)
		end
	end
	-- Add auto-reload script
	local reload_script = [[
    <script>
      let lastModified = {};
      async function checkForChanges() {
        try {
          const response = await fetch('./check-changes');
          const changed = await response.text();
          if (changed === 'true') {
            location.reload();
          }
        } catch (e) {
          console.log('Waiting for server...');
        }
      }
      setInterval(checkForChanges, 1000);
    </script>]]
	return [[<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>p5.js Sketch</title>
    <link rel="stylesheet" href="style.css">
]] .. (version:find("2%.") and [[
    <script src="https://cdn.jsdelivr.net/npm/p5@latest/lib/addons/p5.strands.js"></script>
]] or "") .. [[
</head>
<body>
    <main id="canvas-container"></main>
]] .. lib_tags .. [[
    <script src="sketch.js"></script>
]] .. reload_script .. [[
</body>
</html>]]
end
-- CSS template
T.css_template = [[
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: #f5f5f5;
  overflow: hidden;
}
#canvas-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  width: 100%;
}
canvas {
  display: block;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  max-width: 100%;
  max-height: 100vh;
}
@media (max-width: 768px) {
  #canvas-container {
    padding: 10px;
  }
  canvas {
    border-radius: 4px;
  }
}]]
-- JavaScript template
T.js_template = [[
// Auto-generated by p5.nvim
function setup() {
  createCanvas(800, 600);
  background(220);
  // Your setup code here
}
function draw() {
  // Your draw code here
  // Example: Draw a circle that follows the mouse
  fill(255, 100, 100, 50);
  noStroke();
  circle(mouseX, mouseY, 50);
}
// Example interaction
function mousePressed() {
  console.log('Mouse pressed at:', mouseX, mouseY);
  background(random(100, 255), random(100, 255), random(100, 255));
}]]
-- Auto-reload script template for Python server
T.python_reload_script = "server.py"
-- URL generation functions
function T.build_library_url(version, url_key)
	local template = T.urls.libraries[url_key]
	if not template then
		return nil
	end
	return T.urls.jsdelivr_base .. "/" .. template:gsub("{version}", version)
end
function T.type_url(type_key)
	if not type_key or type_key == "" then
		return nil
	end
	local type_path = T.urls.types[type_key]
	if not type_path then
		return nil
	end
	return T.urls.types.base .. "/" .. type_path
end
-- jsconfig.json template
function T.get_jsconfig_template()
	return [[{
  "compilerOptions": {
    "target": "ES6",
    "module": "esm",
    "checkJs": true,
    "baseUrl": ".",
    "typeRoots": ["./lib/types"],
    "paths": {
      "p5": ["./lib/types/p5.d.ts"],
      "p5/*": ["./lib/types/*"]
    }
  },
  "include": [
    "**/*.js",
    "**/*.ts",
    "./p5.global.d.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}]]
end

-- Global p5 type declarations template
function T.get_global_types_template()
	return [[/// <reference types="./lib/types/index" />

// Import p5 types and make them available globally
import p5 = require('./lib/types/index');

declare global {
  // p5 lifecycle functions
  function setup(): void;
  function draw(): void;
  function preload(): void;
  
  // Make all p5 instance methods available globally
  // This will provide type hints for all p5.js functions
  const background: typeof p5.prototype.background;
  const fill: typeof p5.prototype.fill;
  const stroke: typeof p5.prototype.stroke;
  const noFill: typeof p5.prototype.noFill;
  const noStroke: typeof p5.prototype.noStroke;
  const strokeWeight: typeof p5.prototype.strokeWeight;
  const clear: typeof p5.prototype.clear;
  
  // Shape functions
  const rect: typeof p5.prototype.rect;
  const ellipse: typeof p5.prototype.ellipse;
  const circle: typeof p5.prototype.circle;
  const line: typeof p5.prototype.line;
  const point: typeof p5.prototype.point;
  const triangle: typeof p5.prototype.triangle;
  const quad: typeof p5.prototype.quad;
  const arc: typeof p5.prototype.arc;
  const beginShape: typeof p5.prototype.beginShape;
  const endShape: typeof p5.prototype.endShape;
  const vertex: typeof p5.prototype.vertex;
  const curveVertex: typeof p5.prototype.curveVertex;
  
  // Transform functions
  const push: typeof p5.prototype.push;
  const pop: typeof p5.prototype.pop;
  const translate: typeof p5.prototype.translate;
  const rotate: typeof p5.prototype.rotate;
  const rotateX: typeof p5.prototype.rotateX;
  const rotateY: typeof p5.prototype.rotateY;
  const rotateZ: typeof p5.prototype.rotateZ;
  const scale: typeof p5.prototype.scale;
  const resetMatrix: typeof p5.prototype.resetMatrix;
  
  // Math functions
  const random: typeof p5.prototype.random;
  const noise: typeof p5.prototype.noise;
  const noiseSeed: typeof p5.prototype.noiseSeed;
  const noiseDetail: typeof p5.prototype.noiseDetail;
  const map: typeof p5.prototype.map;
  const constrain: typeof p5.prototype.constrain;
  const dist: typeof p5.prototype.dist;
  const lerp: typeof p5.prototype.lerp;
  const lerpColor: typeof p5.prototype.lerpColor;
  const mag: typeof p5.prototype.mag;
  const sq: typeof p5.prototype.sq;
  const sqrt: typeof p5.prototype.sqrt;
  const pow: typeof p5.prototype.pow;
  const exp: typeof p5.prototype.exp;
  const log: typeof p5.prototype.log;
  const round: typeof p5.prototype.round;
  const floor: typeof p5.prototype.floor;
  const ceil: typeof p5.prototype.ceil;
  const min: typeof p5.prototype.min;
  const max: typeof p5.prototype.max;
  const abs: typeof p5.prototype.abs;
  const sin: typeof p5.prototype.sin;
  const cos: typeof p5.prototype.cos;
  const tan: typeof p5.prototype.tan;
  const asin: typeof p5.prototype.asin;
  const acos: typeof p5.prototype.acos;
  const atan: typeof p5.prototype.atan;
  const atan2: typeof p5.prototype.atan2;
  const degrees: typeof p5.prototype.degrees;
  const radians: typeof p5.prototype.radians;
  const angleMode: typeof p5.prototype.angleMode;
  
  // Vector
  const createVector: typeof p5.prototype.createVector;
  
  // Color
  const color: typeof p5.prototype.color;
  const colorMode: typeof p5.prototype.colorMode;
  const red: typeof p5.prototype.red;
  const green: typeof p5.prototype.green;
  const blue: typeof p5.prototype.blue;
  const alpha: typeof p5.prototype.alpha;
  const hue: typeof p5.prototype.hue;
  const saturation: typeof p5.prototype.saturation;
  const brightness: typeof p5.prototype.brightness;
  const lightness: typeof p5.prototype.lightness;
  
  // Canvas and environment
  const createCanvas: typeof p5.prototype.createCanvas;
  const resizeCanvas: typeof p5.prototype.resizeCanvas;
  const width: number;
  const height: number;
  const windowWidth: number;
  const windowHeight: number;
  const windowResized: typeof p5.prototype.windowResized;
  const fullscreen: typeof p5.prototype.fullscreen;
  const pixelDensity: typeof p5.prototype.pixelDensity;
  const displayDensity: typeof p5.prototype.displayDensity;
  const getURL: typeof p5.prototype.getURL;
  const getURLParams: typeof p5.prototype.getURLParams;
  const getURLPath: typeof p5.prototype.getURLPath;
  
  // Time and date
  const millis: typeof p5.prototype.millis;
  const second: typeof p5.prototype.second;
  const minute: typeof p5.prototype.minute;
  const hour: typeof p5.prototype.hour;
  const day: typeof p5.prototype.day;
  const month: typeof p5.prototype.month;
  const year: typeof p5.prototype.year;
  const frameCount: number;
  const frameRate: typeof p5.prototype.frameRate;
  const deltaTime: number;
  const cursor: typeof p5.prototype.cursor;
  const noCursor: typeof p5.prototype.noCursor;
  
  // Constants - these are available globally
  const PI: number;
  const TWO_PI: number;
  const HALF_PI: number;
  const QUARTER_PI: number;
  const TAU: number;
  const DEGREES: 'degrees';
  const RADIANS: 'radians';
  
  // Color constants
  const RGB: 'rgb';
  const HSB: 'hsb';
  const HSL: 'hsl';
  
  // Shape constants
  const CORNER: 'corner';
  const CORNERS: 'corners';
  const RADIUS: 'radius';
  const CENTER: 'center';
  
  // Add more global constants and functions as needed
  const P2D: string;
  const WEBGL: string;
  const ARROW: string;
  const CROSS: string;
  const HAND: string;
  const MOVE: string;
  const TEXT: string;
  const WAIT: string;
  
  // Events
  const mouseIsPressed: boolean;
  const mouseButton: number;
  const mouseX: number;
  const mouseY: number;
  const pmouseX: number;
  const pmouseY: number;
  const winMouseX: number;
  const winMouseY: number;
  const pwinMouseX: number;
  const pwinMouseY: number;
  const keyIsPressed: boolean;
  const key: string;
  const keyCode: number;
  
  // Event handler functions
  function mousePressed(): void;
  function mouseReleased(): void;
  function mouseMoved(): void;
  function mouseDragged(): void;
  function mouseWheel(): void;
  function doubleClicked(): void;
  function keyPressed(): void;
  function keyReleased(): void;
  function keyTyped(): void;
  function touchStarted(): void;
  function touchMoved(): void;
  function touchEnded(): void;
}

export {};]]
end
return T
