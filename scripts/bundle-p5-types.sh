#!/bin/bash
# Enhanced p5.js type bundling script with tsdown support

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
    
    # Bundle using tsdown with specific inlineOnly configuration
    npx tsdown --dts --inlineOnly @types/p5 --output p5-bundled.d.ts node_modules/@types/p5/index.d.ts
    
    # Check for output file (tsdown outputs to dist/index.d.mts by default)
    if [ -f "dist/index.d.mts" ]; then
        # Copy the bundled file to output directory
        cp dist/index.d.mts "$OUTPUT_DIR/p5.d.ts"
        echo "✓ Successfully bundled p5.js types using tsdown"
        SUCCESS=true
        
        # Clean up temporary directory
        cd "$PLUGIN_ROOT"
        rm -rf "$TEMP_DIR"
    elif [ -f "p5-bundled.d.ts" ]; then
        # Copy the bundled file to output directory
        cp p5-bundled.d.ts "$OUTPUT_DIR/p5.d.ts"
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

# Fallback if tsdown failed
if [ "$SUCCESS" = "false" ]; then
    echo "tsdown failed, creating fallback types..."
    
    # Create essential global types as fallback
    cat > "$OUTPUT_DIR/p5.d.ts" << 'EOF'
// Fallback p5.js TypeScript definitions
// Generated when bundling failed or tsdown unavailable

declare global {
  // Core setup functions
  function setup(): void;
  function draw(): void;
  function preload(): void;
  
  // Canvas creation
  function createCanvas(width: number, height: number): HTMLCanvasElement;
  function createGraphics(width?: number, height?: number): any;
  function resizeCanvas(width: number, height: number): void;
  
  // Drawing functions
  function background(color: any): void;
  function fill(color: any): void;
  function stroke(color: any): void;
  function noFill(): void;
  function noStroke(): void;
  
  // Shapes
  function circle(x: number, y: number, radius: number): void;
  function rect(x: number, y: number, width: number, height: number): void;
  function line(x1: number, y1: number, x2: number, y2: number): void;
  function ellipse(x: number, y: number, w: number, h: number): void;
  function triangle(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): void;
  
  // Text
  function text(txt: string, x: number, y: number): void;
  function textSize(size: number): void;
  
  // Core properties
  const mouseX: number;
  const mouseY: number;
  const width: number;
  const height: number;
  const frameCount: number;
  
  // Event properties
  const keyIsPressed: boolean;
  const mouseIsPressed: boolean;
  const keyIsDown: any;
  
  // Color
  function color(mode?: any, ...args: any[]): any;
  function red(color?: any): any;
  function green(color?: any): any;
  function blue(color?: any): any;
  function alpha(alpha: number): any;
}

export {};
EOF
    
    echo "✓ Created fallback p5.d.ts"
fi

echo "File size: $(wc -c < "$OUTPUT_DIR/p5.d.ts") bytes"
echo "Types created at: $OUTPUT_DIR/p5.d.ts"