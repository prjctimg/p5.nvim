// Complete global p5.js TypeScript definitions
// This file provides comprehensive global scope for all p5.js functions

declare global {
  // Core setup functions
  function setup(): void;
  function draw(): void;
  function preload(): void;
  
  // Canvas creation and management
  function createCanvas(width: number, height: number, renderer?: string): HTMLCanvasElement;
  function createGraphics(width?: number, height?: number, renderer?: string): any;
  function resizeCanvas(width: number, height: number): void;
  function noCanvas(): void;
  
  // Drawing functions
  function background(...args: any[]): void;
  function fill(...args: any[]): void;
  function stroke(...args: any[]): void;
  function noFill(): void;
  function noStroke(): void;
  function strokeWeight(weight: number): void;
  function strokeCap(cap: string): void;
  function strokeJoin(join: string): void;
  
  // Shapes
  function point(x: number, y: number, z?: number): void;
  function line(x1: number, y1: number, x2: number, y2: number): void;
  function line(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): void;
  function triangle(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): void;
  function rect(x: number, y: number, width: number, height?: number, detailX?: number, detailY?: number): void;
  function ellipse(x: number, y: number, width: number, height?: number): void;
  function circle(x: number, y: number, radius: number): void;
  function square(x: number, y: number, size: number): void;
  
  // Curves
  function bezier(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): void;
  function curve(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): void;
  function bezierPoint(a: number, b: number, c: number, d: number, t: number): number;
  function curvePoint(a: number, b: number, c: number, d: number, t: number): number;
  
  // Text
  function text(str: string, x: number, y: number, x2?: number, y2?: number): void;
  function textSize(size: number): void;
  function textFont(font: any, size?: number): void;
  function textAlign(align: string, align2?: string): void;
  function textLeading(leading: number): void;
  function textStyle(style: string): void;
  
  // Color
  function color(mode?: any, ...args: any[]): any;
  function red(color?: any): number;
  function green(color?: any): number;
  function blue(color?: any): number;
  function alpha(color?: any): number;
  function hue(color?: any): number;
  function saturation(color?: any): number;
  function brightness(color?: any): number;
  
  // Math
  function random(min?: number, max?: number): number;
  function randomGaussian(mean?: number, sd?: number): number;
  function noise(x: number, y?: number, z?: number): number;
  function noiseDetail(lod: number, falloff?: number): void;
  function noiseSeed(seed: number): void;
  
  // Time and date
  function year(): number;
  function month(): number;
  function day(): number;
  function hour(): number;
  function minute(): number;
  function second(): number;
  function millis(): number;
  
  // Core properties
  const mouseX: number;
  const mouseY: number;
  const pmouseX: number;
  const pmouseY: number;
  const winMouseX: number;
  const winMouseY: number;
  const width: number;
  const height: number;
  const frameCount: number;
  const focused: boolean;
  
  // Event properties
  const keyIsPressed: boolean;
  const mouseIsPressed: boolean;
  const key: string;
  const keyCode: number;
  const touches: any[];
  
  // Core functions
  function print(...args: any[]): void;
  function println(...args: any[]): void;
  function loop(): void;
  function noLoop(): void;
  function push(): void;
  function pop(): void;
  function redraw(): void;
  function clear(): void;
  
  // Image
  function loadImage(path: string, successCallback?: (p5Image: any) => void, failureCallback?: (event: any) => void): any;
  function image(img: any, x: number, y: number, width?: number, height?: number): void;
  function tint(...args: any[]): void;
  function noTint(): void;
  function imageMode(mode: string): void;
  
  // Events
  function mousePressed(event?: any): void;
  function mouseReleased(event?: any): void;
  function mouseMoved(event?: any): void;
  function mouseDragged(event?: any): void;
  function mouseWheel(event?: any): void;
  function keyPressed(event?: any): void;
  function keyReleased(event?: any): void;
  function keyTyped(event?: any): void;
  
  // Transform
  function pushMatrix(): void;
  function popMatrix(): void;
  function translate(x: number, y: number, z?: number): void;
  function rotate(angle: number): void;
  function rotateX(angle: number): void;
  function rotateY(angle: number): void;
  function rotateZ(angle: number): void;
  function scale(x: number, y?: number, z?: number): void;
  function resetMatrix(): void;
  
  // Constants
  const HALF_PI: number;
  const PI: number;
  const QUARTER_PI: number;
  const TAU: number;
  const TWO_PI: number;
  const DEGREES: number;
  const RADIANS: number;
}

export {};