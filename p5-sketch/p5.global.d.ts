/// <reference types="./lib/types/index" />

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

export {};
