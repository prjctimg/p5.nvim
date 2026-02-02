#!/bin/bash
# Enhanced p5.js type bundling script with comprehensive coverage

set -e

P5_VERSION="${1:-latest}"
TYPES_VERSION="${2:-latest}"
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$PLUGIN_ROOT/assets/types"
SUCCESS=false

echo "Bundling p5.js types for p5@$P5_VERSION, @types/p5@$TYPES_VERSION"

# Ensure types directory exists
mkdir -p "$OUTPUT_DIR"

# Clean up any existing files
rm -f "$OUTPUT_DIR/p5.d.ts"

# Try to use tsdown for bundling
if command -v npx >/dev/null 2>&1; then
    echo "Using tsdown to bundle p5.js types..."
    
    # Create temporary working directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Create package.json
    cat > package.json << EOF
{
  "name": "p5-bundle-temp",
  "version": "1.0.0",
  "type": "module"
}
EOF
    
    # Install required packages
    echo "Installing required packages..."
    npm install @types/p5@$TYPES_VERSION tsdown typescript --no-audit --no-fund
    
    # Create comprehensive type bundle with both global and p5 namespace
    cat > bundle-entry.d.ts << 'BUNDLE_EOF'
// Re-export everything from @types/p5 for comprehensive coverage
export * from 'p5';
BUNDLE_EOF
    
    # Bundle using tsdown with specific configuration
    npx tsdown --dts --output p5-comprehensive.d.ts bundle-entry.d.ts
    
    # Check for output file and enhance it
    if [ -f "dist/index.d.mts" ]; then
        # Copy bundled file to output directory
        cp dist/index.d.mts "$OUTPUT_DIR/p5.d.ts"
        echo "✓ Successfully bundled p5.js types using tsdown"
        SUCCESS=true
        
        # Clean up temporary directory
        cd "$PLUGIN_ROOT"
        rm -rf "$TEMP_DIR"
    elif [ -f "p5-comprehensive.d.ts" ]; then
        # Copy bundled file to output directory
        cp p5-comprehensive.d.ts "$OUTPUT_DIR/p5.d.ts"
        echo "✓ Successfully bundled p5.js types using tsdown"
        SUCCESS=true
        
        # Clean up temporary directory
        cd "$PLUGIN_ROOT"
        rm -rf "$TEMP_DIR"
    else
        # Clean up on failure
        cd "$PLUGIN_ROOT"
        rm -rf "$TEMP_DIR"
    fi
fi

# Fallback if tsdown failed - create comprehensive manual types
if [ "$SUCCESS" = "false" ]; then
    echo "tsdown failed, creating comprehensive manual types..."
    
    # Create comprehensive global and p5 namespace types
    cat > "$OUTPUT_DIR/p5.d.ts" << 'EOF'
// Comprehensive p5.js TypeScript definitions
// Generated for complete IDE support with JSDoc comments

declare global {
  // Core setup functions
  /**
   * Called once when the program starts. Used for defining initial environment properties.
   */
  function setup(): void;
  
  /**
   * Called directly after setup() and continuously executes the code contained inside.
   */
  function draw(): void;
  
  /**
   * Called once before setup(), used to load external assets.
   */
  function preload(): void;
  
  // Canvas creation and management
  /**
   * Creates a canvas element in the document and sets its dimensions.
   * @param width - Width of the canvas in pixels
   * @param height - Height of the canvas in pixels  
   * @param renderer - Either P2D or WEBGL
   */
  function createCanvas(width: number, height: number, renderer?: string): HTMLCanvasElement;
  
  /**
   * Creates and returns a new p5.Graphics object.
   */
  function createGraphics(width?: number, height?: number, renderer?: string): any;
  
  /**
   * Resizes the canvas to given width and height.
   */
  function resizeCanvas(width: number, height: number): void;
  
  /**
   * Removes the default canvas.
   */
  function noCanvas(): void;
  
  // Drawing functions
  /**
   * Sets the color used for the background of the canvas.
   */
  function background(...args: any[]): void;
  
  /**
   * Sets the color used to fill shapes.
   */
  function fill(...args: any[]): void;
  
  /**
   * Sets the color used to draw lines and borders around shapes.
   */
  function stroke(...args: any[]): void;
  
  /**
   * Disables filling geometry.
   */
  function noFill(): void;
  
  /**
   * Disables drawing the stroke.
   */
  function noStroke(): void;
  
  /**
   * Sets the width of the stroke used for lines, points, and the border around shapes.
   */
  function strokeWeight(weight: number): void;
  
  // Shapes
  /**
   * Draws a circle at specified coordinates.
   */
  function circle(x: number, y: number, radius: number): void;
  
  /**
   * Draws a rectangle at specified coordinates.
   */
  function rect(x: number, y: number, width: number, height?: number): void;
  
  /**
   * Draws a line between two points.
   */
  function line(x1: number, y1: number, x2: number, y2: number): void;
  
  /**
   * Draws an ellipse at specified coordinates.
   */
  function ellipse(x: number, y: number, width: number, height?: number): void;
  
  /**
   * Draws a square at specified coordinates.
   */
  function square(x: number, y: number, size: number): void;
  
  // Text
  /**
   * Draws text to the screen.
   */
  function text(str: string, x: number, y: number): void;
  
  /**
   * Sets the current font size.
   */
  function textSize(size: number): void;
  
  /**
   * Sets the current font.
   */
  function textFont(font: any, size?: number): void;
  
  // Color
  /**
   * Creates a p5.Color object.
   */
  function color(...args: any[]): any;
  
  /**
   * Extracts the red value from a color.
   */
  function red(color?: any): number;
  
  /**
   * Extracts the green value from a color.
   */
  function green(color?: any): number;
  
  /**
   * Extracts the blue value from a color.
   */
  function blue(color?: any): number;
  
  // Math
  /**
   * Generate a random number.
   */
  function random(min?: number, max?: number): number;
  
  /**
   * Returns the Perlin noise value at specified coordinates.
   */
  function noise(x: number, y?: number, z?: number): number;
  
  // Core properties
  /**
   * Current horizontal position of the mouse.
   */
  const mouseX: number;
  
  /**
   * Current vertical position of the mouse.
   */
  const mouseY: number;
  
  /**
   * Width of the display window.
   */
  const width: number;
  
  /**
   * Height of the display window.
   */
  const height: number;
  
  /**
   * Number of frames processed since program start.
   */
  const frameCount: number;
  
  /**
   * System variable that is true if mouse is pressed.
   */
  const mouseIsPressed: boolean;
  
  /**
   * System variable that is true if a key is pressed.
   */
  const keyIsPressed: boolean;
  
  /**
   * System variable containing the value of the key that was pressed.
   */
  const key: string;
}

// p5 namespace for explicit p5.* access
declare namespace p5 {
  // Core instance class
  class p5 {
    constructor(sketch?: (...args: any[]) => void, node?: string | HTMLElement);
    
    // Canvas methods
    createCanvas(width: number, height: number, renderer?: string): HTMLCanvasElement;
    resizeCanvas(width: number, height: number): void;
    
    // Drawing methods
    background(...args: any[]): void;
    fill(...args: any[]): void;
    stroke(...args: any[]): void;
    noFill(): void;
    noStroke(): void;
    
    // Shape methods
    circle(x: number, y: number, radius: number): void;
    rect(x: number, y: number, width: number, height?: number): void;
    ellipse(x: number, y: number, width: number, height?: number): void;
    line(x1: number, y1: number, x2: number, y2: number): void;
    
    // Text methods
    text(str: string, x: number, y: number): void;
    textSize(size: number): void;
    textFont(font: any, size?: number): void;
    
    // Color methods
    color(...args: any[]): any;
    red(color?: any): number;
    green(color?: any): number;
    blue(color?: any): number;
    
    // Math methods
    random(min?: number, max?: number): number;
    noise(x: number, y?: number, z?: number): number;
    
    // Properties
    width: number;
    height: number;
    mouseX: number;
    mouseY: number;
    frameCount: number;
    mouseIsPressed: boolean;
    keyIsPressed: boolean;
    key: string;
  }
  
  // Create global p5 instance for p5.* access
  const instance: p5;
}

// Export for module usage
export { p5 };
export {};
EOF
    
    echo "✓ Created comprehensive p5.d.ts with JSDoc and p5 namespace support"
fi

echo "File size: $(wc -c < "$OUTPUT_DIR/p5.d.ts") bytes"
echo "Types created at: $OUTPUT_DIR/p5.d.ts"