// p5.js TypeScript Definitions
// Generated for p5.nvim Neovim plugin
// Includes global p5 functions and p5.someSymbol namespace support

declare global {
  // Core functions and variables
  function rect(x: number, y: number, width: number, height?: number, detailX?: number, detailY?: number): void;
  function circle(x: number, y: number, diameter: number): void;
  function ellipse(x: number, y: number, width: number, height?: number): void;
  function line(x1: number, y1: number, x2: number, y2: number): void;
  function triangle(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): void;
  function quad(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): void;
  function point(x: number, y: number, z?: number): void;
  function arc(x: number, y: number, width: number, height: number, start: number, stop: number, mode?: number, detail?: number): void;
  function beginShape(mode?: number): void;
  function vertex(x: number, y: number, z?: number): void;
  function endShape(mode?: number): void;
  function bezierVertex(x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): void;
  function curveVertex(x: number, y: number, z?: number): void;
  
  // Color functions
  function background(value: number | string): void;
  function background(gray: number, alpha: number): void;
  function background(v1: number, v2: number, v3: number, alpha?: number): void;
  function fill(value: number | string): void;
  function fill(gray: number, alpha: number): void;
  function fill(v1: number, v2: number, v3: number, alpha?: number): void;
  function noFill(): void;
  function stroke(value: number | string): void;
  function stroke(gray: number, alpha: number): void;
  function stroke(v1: number, v2: number, v3: number, alpha?: number): void;
  function noStroke(): void;
  function colorMode(mode: string | number, max1?: number, max2?: number, max3?: number, maxA?: number): void;
  
  // Typography functions
  function text(theText: string, x: number, y: number, x2?: number, y2?: number): void;
  function textFont(theFont: any, size?: number): void;
  function textSize(size: number): void;
  function textLeading(leading: number): void;
  
  // Image functions
  function image(img: any, x: number, y: number, width?: number, height?: number): void;
  function loadImage(path: string, successCallback?: Function, failureCallback?: Function): any;
  function createImage(width: number, height: number, mode?: string): any;
  
  // Transform functions
  function push(): void;
  function pop(): void;
  function translate(x: number, y: number, z?: number): void;
  function rotate(angle: number): void;
  function rotateX(angle: number): void;
  function rotateY(angle: number): void;
  function rotateZ(angle: number): void;
  function scale(x: number, y?: number, z?: number): void;
  function resetMatrix(): void;
  
  // Math functions
  function random(min?: number, max?: number): number;
  function noise(x: number, y?: number, z?: number): number;
  function dist(x1: number, y1: number, x2: number, y2: number, z1?: number, z2?: number): number;
  function lerp(start: number, stop: number, amt: number): number;
  function map(value: number, start1: number, stop1: number, start2: number, stop2: number, withinBounds?: number): number;
  function constrain(n: number, low: number, high: number): number;
  function abs(n: number): number;
  function sqrt(n: number): number;
  function pow(n: number, e: number): number;
  function round(n: number): number;
  function floor(n: number): number;
  function ceil(n: number): number;
  function sin(angle: number): number;
  function cos(angle: number): number;
  function tan(angle: number): number;
  function asin(value: number): number;
  function acos(value: number): number;
  function atan(value: number): number;
  function atan2(y: number, x: number): number;
  function degrees(radians: number): number;
  function radians(degrees: number): number;
  function createVector(x?: number, y?: number, z?: number): any;
  
  // Event handlers
  function setup(): void;
  function draw(): void;
  function preload(): void;
  function mousePressed(): void;
  function mouseReleased(): void;
  function mouseMoved(): void;
  function mouseDragged(): void;
  function mouseWheel(event: any): void;
  function keyPressed(): void;
  function keyReleased(): void;
  function keyTyped(): void;
  function touchStarted(): void;
  function touchMoved(): void;
  function touchEnded(): void;
  function windowResized(): void;
  
  // Core functions
  function createCanvas(width: number, height: number, renderer?: string): any;
  function resizeCanvas(width: number, height: number, noRedraw?: boolean): void;
  function noCanvas(): void;
  function pixelDensity(density?: number): number;
  function getURL(): string;
  function getURLParams(): any;
  function frameRate(fps?: number): number;
  function getTargetFrameRate(): number;
  function getFrameRate(): number;
  let deltaTime: number;
  function cursor(type?: any): void;
  function noCursor(): void;
  function requestFullscreen(): void;
  function exitFullscreen(): void;
  function fullscreen(boolean?: number): boolean;
  function devicePixelDensity(density?: number): number;
  function displayDensity(density?: number): number;
  function getURLPath(): string[];
  function getURL(): string;
  function getURLParams(): any;
  
  // Properties
  let width: number;
  let height: number;
  let frameCount: number;
  let focused: boolean;
  let mouseX: number;
  let mouseY: number;
  let pmouseX: number;
  let pmouseY: number;
  let winMouseX: number;
  let winMouseY: number;
  let pixelDensity: number;
  let displayWidth: number;
  let displayHeight: number;
  let deviceOrientation: string;
  let accelerationX: number;
  let accelerationY: number;
  let accelerationZ: number;
  let pAccelerationX: number;
  let pAccelerationY: number;
  let pAccelerationZ: number;
  let rotationX: number;
  let rotationY: number;
  let rotationZ: number;
  let pRotationX: number;
  let pRotationY: number;
  let pRotationZ: number;
  let keyIsPressed: boolean;
  let key: string;
  let keyCode: number;
}

// p5 namespace for p5.someSymbol syntax
declare namespace p5 {
  // Core p5 class
  export class p5 {
    constructor(sketch?: (...args: any[]) => void, node?: HTMLElement, sync?: boolean);
    
    // Same functions as global but as methods
    rect(x: number, y: number, width: number, height?: number, detailX?: number, detailY?: number): void;
    circle(x: number, y: number, diameter: number): void;
    ellipse(x: number, y: number, width: number, height?: number): void;
    line(x1: number, y1: number, x2: number, y2: number): void;
    triangle(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): void;
    quad(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): void;
    point(x: number, y: number, z?: number): void;
    arc(x: number, y: number, width: number, height: number, start: number, stop: number, mode?: number, detail?: number): void;
    beginShape(mode?: number): void;
    vertex(x: number, y: number, z?: number): void;
    endShape(mode?: number): void;
    bezierVertex(x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): void;
    curveVertex(x: number, y: number, z?: number): void;
    
    background(value: number | string): void;
    background(gray: number, alpha: number): void;
    background(v1: number, v2: number, v3: number, alpha?: number): void;
    fill(value: number | string): void;
    fill(gray: number, alpha: number): void;
    fill(v1: number, v2: number, v3: number, alpha?: number): void;
    noFill(): void;
    stroke(value: number | string): void;
    stroke(gray: number, alpha: number): void;
    stroke(v1: number, v2: number, v3: number, alpha?: number): void;
    noStroke(): void;
    colorMode(mode: string | number, max1?: number, max2?: number, max3?: number, maxA?: number): void;
    
    text(theText: string, x: number, y: number, x2?: number, y2?: number): void;
    textFont(theFont: any, size?: number): void;
    textSize(size: number): void;
    textLeading(leading: number): void;
    
    image(img: any, x: number, y: number, width?: number, height?: number): void;
    loadImage(path: string, successCallback?: Function, failureCallback?: Function): any;
    createImage(width: number, height: number, mode?: string): any;
    
    push(): void;
    pop(): void;
    translate(x: number, y: number, z?: number): void;
    rotate(angle: number): void;
    rotateX(angle: number): void;
    rotateY(angle: number): void;
    rotateZ(angle: number): void;
    scale(x: number, y?: number, z?: number): void;
    resetMatrix(): void;
    
    random(min?: number, max?: number): number;
    noise(x: number, y?: number, z?: number): number;
    dist(x1: number, y1: number, x2: number, y2: number, z1?: number, z2?: number): number;
    lerp(start: number, stop: number, amt: number): number;
    map(value: number, start1: number, stop1: number, start2: number, stop2: number, withinBounds?: number): number;
    constrain(n: number, low: number, high: number): number;
    abs(n: number): number;
    sqrt(n: number): number;
    pow(n: number, e: number): number;
    round(n: number): number;
    floor(n: number): number;
    ceil(n: number): number;
    sin(angle: number): number;
    cos(angle: number): number;
    tan(angle: number): number;
    asin(value: number): number;
    acos(value: number): number;
    atan(value: number): number;
    atan2(y: number, x: number): number;
    degrees(radians: number): number;
    radians(degrees: number): number;
    createVector(x?: number, y?: number, z?: number): any;
    
    createCanvas(width: number, height: number, renderer?: string): any;
    resizeCanvas(width: number, height: number, noRedraw?: boolean): void;
    noCanvas(): void;
    pixelDensity(density?: number): number;
    getURL(): string;
    getURLParams(): any;
    frameRate(fps?: number): number;
    getTargetFrameRate(): number;
    getFrameRate(): number;
    deltaTime: number;
    cursor(type?: any): void;
    noCursor(): void;
    requestFullscreen(): void;
    exitFullscreen(): void;
    fullscreen(boolean?: number): boolean;
    devicePixelDensity(density?: number): number;
    displayDensity(density?: number): number;
    getURLPath(): string[];
    getURL(): string;
    getURLParams(): any;
    
    // Properties
    width: number;
    height: number;
    frameCount: number;
    focused: boolean;
    mouseX: number;
    mouseY: number;
    pmouseX: number;
    pmouseY: number;
    winMouseX: number;
    winMouseY: number;
    pixelDensity: number;
    displayWidth: number;
    displayHeight: number;
    deviceOrientation: string;
    accelerationX: number;
    accelerationY: number;
    accelerationZ: number;
    pAccelerationX: number;
    pAccelerationY: number;
    pAccelerationZ: number;
    rotationX: number;
    rotationY: number;
    rotationZ: number;
    pRotationX: number;
    pRotationY: number;
    pRotationZ: number;
    keyIsPressed: boolean;
    key: string;
    keyCode: number;
  }
}

// Module declarations for compatibility
declare module 'p5' {
  export = p5;
}

declare module '@types/p5' {
  export = p5;
}

// Global augmentation
declare global {
  const p5: typeof p5;
}

export = p5;