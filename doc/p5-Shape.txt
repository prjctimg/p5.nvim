📄 *p5.Shape*📄
Shape module functions and properties

==============================================================================
Tags p5.Shape Shape module functions and properties
==============================================================================



CONTENTS                                                           *${this.getCurrentModuleName()}-contents*

🔍 NAVIGATION:~
   Use | to jump to sections, :help p5-[symbol] to jump to symbols~

🏛️ CLASSES:
  |Anonymous                |
  |Geometry                 |
  |GeometryBuilder          |
  |Matrix                   |

⚡ FUNCTIONS:
  |anonymous                |
  |arc                      |
  |beginContour             |
  |beginGeometry            |
  |beginShape               |
  |bezier                   |
  |bezierDetail             |
  |bezierPoint              |
  |bezierTangent            |
  |bezierVertex             |
  |box                      |
  |buildGeometry            |
  |circle                   |
  |cone                     |
  |createModel              |
  |curve                    |
  |curveDetail              |
  |curvePoint               |
  |curveTangent             |
  |curveTightness           |
  |curveVertex              |
  |cylinder                 |
  |ellipse                  |
  |ellipseMode              |
  |ellipsoid                |
  |endContour               |
  |endGeometry              |
  |endShape                 |
  |freeGeometry             |
  |isBinary                 |
  |loadModel                |
  |matchDataViewAt          |
  |model                    |
  |normal                   |
  |noSmooth                 |
  |parseASCIISTL            |
  |parseBinarySTL           |
  |parseObj                 |
  |parseSTL                 |
  |plane                    |
  |quad                     |
  |quadraticVertex          |
  |rect                     |
  |rectMode                 |
  |smooth                   |
  |sphere                   |
  |square                   |
  |strokeCap                |
  |strokeJoin               |
  |strokeWeight             |
  |torus                    |
  |triangle                 |
  |uvs                      |
  |vertex                   |
  |vertexColors             |

🔧 PROPERTIES:
  |faces                    |
  |length                   |
  |line                     |
  |nextGeometryId           |
  |point                    |
  |vertices                 |

📌 VARIABLES:
  |a00                      |
  |a01                      |
  |a02                      |
  |a03                      |
  |a10                      |
  |a11                      |
  |a12                      |
  |a13                      |
  |a23                      |
  |array                    |
  |d00                      |
  |f                        |
  |geometry                 |
  |i                        |
  |lr                       |
  |modelOutput              |
  |objStr                   |
  |ptArray                  |
  |reader                   |
  |result                   |
  |state                    |
  |vertexNormals            |



🔗 RELATED SYMBOLS:~
   See |p5| for complete p5.js API reference~



⚡ QUICK REFERENCE:~
   :help p5-[symbolname] - Jump directly to any function~



CLASSES                                                   *p5-Shape-classes*

p5-Shape_Anonymous() 📄 🏛️
|Anonymous|() 🏛️ Class

A class to describe a 4×4 matrix for model and view matrix manipulation in the p5js webgl renderer.

Parameters: ~
                🔢 `{Array} [mat4] column-major array literal of our 4×4 matrix` (unknown)
~

See also: ~
   |help p5-Anonymous| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:27
~


p5-Shape_Geometry() 📄 🏛️
|Geometry|() 🏛️ Class

A class to describe a 3D shape.
Each `p5.Geometry` object represents a 3D shape as a `set` of connected points called *vertices*.
All 3D shapes are made by connecting vertices to form triangles that are stitched together.
Each triangular patch on the geometry's surface is called a *face*.
The geometry stores information about its vertices and faces for use with effects such as lighting and texture mapping.
The first parameter, `detailX`, is optional.
If a number is passed, as in `new p5.Geometry(24)`, it sets the number of `triangle` subdivisions to use along the geometry's x-axis.
By default, `detailX` is 1.
The second parameter, `detailY`, is also optional.
If a number is passed, as in `new p5.Geometry(24, 16)`, it sets the number of `triangle` subdivisions to use along the geometry's y-axis.
By default, `detailX` is 1.
The third parameter, `callback`, is also optional.
If a function is passed, as in `new p5.Geometry(24, 16, createShape)`, it will be called once to add vertices to the new 3D shape.

Parameters: ~
                🔢 `{Integer} [detailX] number of vertices along the x-axis.` (unknown)
                🔢 `{Integer} [detailY] number of vertices along the y-axis.` (unknown)
                🔢 `{function} [callback] function to call once the geometry is created.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> myGeometry = new p5.Geometry();
>
> // Create p5.Vector objects to position the vertices.
> let v0 = createVector(-40, 0, 0);
> let v1 = createVector(0, -40, 0);
> let v2 = createVector(40, 0, 0);
>
> // Add the vertices to the p5.Geometry object's vertices array.
> myGeometry.vertices.push(v0, v1, v2);
>
> describe('A white triangle drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the p5.Geometry object.
> model(myGeometry);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object using a callback function.
> myGeometry = new p5.Geometry(1, 1, createShape);
>
> describe('A white triangle drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the p5.Geometry object.
> model(myGeometry);
> }
>
> function createShape() {
> // Create p5.Vector objects to position the vertices.
> let v0 = createVector(-40, 0, 0);
> let v1 = createVector(0, -40, 0);
> let v2 = createVector(40, 0, 0);
>
> // "this" refers to the p5.Geometry object being created.
>
> // Add the vertices to the p5.Geometry object's vertices array.
> this.vertices.push(v0, v1, v2);
>
> // Add an array to list which vertices belong to the face.
> // Vertices are listed in clockwise "winding" order from
> // left to top to right.
> this.faces.push([0, 1, 2]);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object using a callback function.
> myGeometry = new p5.Geometry(1, 1, createShape);
>
> describe('A white triangle drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the p5.Geometry object.
> model(myGeometry);
> }
>
> function createShape() {
> // Create p5.Vector objects to position the vertices.
> let v0 = createVector(-40, 0, 0);
> let v1 = createVector(0, -40, 0);
> let v2 = createVector(40, 0, 0);
>
> // "this" refers to the p5.Geometry object being created.
>
> // Add the vertices to the p5.Geometry object's vertices array.
> this.vertices.push(v0, v1, v2);
>
> // Add an array to list which vertices belong to the face.
> // Vertices are listed in clockwise "winding" order from
> // left to top to right.
> this.faces.push([0, 1, 2]);
>
> // Compute the surface normals to help with lighting.
> this.computeNormals();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> // Adapted from Paul Wheeler's wonderful p5.Geometry tutorial.
> // https://www.paulwheeler.us/articles/custom-3d-geometry-in-p5js/
> // CC-BY-SA 4.0
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the p5.Geometry object.
> // Set detailX to 48 and detailY to 2.
> // >>> try changing them.
> myGeometry = new p5.Geometry(48, 2, createShape);
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the p5.Geometry object.
> strokeWeight(0.2);
>
> // Draw the p5.Geometry object.
> model(myGeometry);
> }
>
> function createShape() {
> // "this" refers to the p5.Geometry object being created.
>
> // Define the Möbius strip with a few parameters.
> let spread = 0.1;
> let radius = 30;
> let stripWidth = 15;
> let xInterval = 4 * PI / this.detailX;
> let yOffset = -stripWidth / 2;
> let yInterval = stripWidth / this.detailY;
>
> for (let j = 0; j <= this.detailY; j += 1) {
> // Calculate the "vertical" point along the strip.
> let v = yOffset + yInterval * j;
>
> for (let i = 0; i <= this.detailX; i += 1) {
> // Calculate the angle of rotation around the strip.
> let u = i * xInterval;
>
> // Calculate the coordinates of the vertex.
> let x = (radius + v * cos(u / 2)) * cos(u) - sin(u / 2) * 2 * spread;
> let y = (radius + v * cos(u / 2)) * sin(u);
> if (u < TWO_PI) {
> y += sin(u) * spread;
> } else {
> y -= sin(u) * spread;
> }
> let z = v * sin(u / 2) + sin(u / 4) * 4 * spread;
>
> // Create a p5.Vector object to position the vertex.
> let vert = createVector(x, y, z);
>
> // Add the vertex to the p5.Geometry object's vertices array.
> this.vertices.push(vert);
> }
> }
>
> // Compute the faces array.
> this.computeFaces();
>
> // Compute the surface normals to help with lighting.
> this.computeNormals();
> }
> </code>
>
<

See also: ~
   |help p5-Geometry| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:250
~


p5-Shape_GeometryBuilder() 📄 🏛️
|GeometryBuilder|() 🏛️ Class

See also: ~
   |help p5-GeometryBuilder| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/GeometryBuilder.js:9
~


p5-Shape_Matrix() 📄 🏛️
|Matrix|() 🏛️ Class

A class to describe a 4×4 matrix for model and view matrix manipulation in the p5js webgl renderer.

Parameters: ~
                🔢 `{Array} [mat4] column-major array literal of our 4×4 matrix` (unknown)
~

See also: ~
   |help p5-Matrix| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:27
~


FUNCTIONS                                                   *p5-Shape-functions*

p5-Shape_anonymous() 📄 ⚡
|anonymous|() ⚡ Function

Flips the geometry’s texture v-coordinates.
In order for <a href="#/p5/texture">texture()</a> to work, the geometry needs a way to `map` the points on its surface to the `pixels` in a rectangular `image` that's used as a texture.
The geometry's `vertex` at coordinates `(x, y, z)` maps to the texture `image`'s pixel at coordinates `(u, v)`.
The <a href="#/p5.Geometry/uvs">myGeometry.uvs</a> array stores the `(u, v)` coordinates for each `vertex` in the order it was added to the geometry.
Calling `myGeometry.flipV()` flips a geometry's v-coordinates so that the texture appears mirrored vertically.
For example, a plane's four vertices are added clockwise starting from the top-left corner.
Here's how calling `myGeometry.flipV()` would change a plane's texture coordinates: ```js // Print the original texture coordinates.
// Output: [0, 0, 1, 0, 0, 1, 1, 1] console.log(myGeometry.uvs); // Flip the v-coordinates.
myGeometry.flipV(); // Print the flipped texture coordinates.
// Output: [0, 1, 1, 1, 0, 0, 1, 0] console.log(myGeometry.uvs); // Notice the swaps: // Left vertices: [0, 0] &lt;--&gt; [1, 0] // Right vertices: [1, 0] &lt;--&gt; [1, 1] ```

Examples: >
>
> <code>
> let img;
>
> function preload() {
> img = loadImage('assets/laDefense.jpg');
> }
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // Create p5.Geometry objects.
> let geom1 = buildGeometry(createShape);
> let geom2 = buildGeometry(createShape);
>
> // Flip geom2's V texture coordinates.
> geom2.flipV();
>
> // Left (original).
> push();
> translate(-25, 0, 0);
> texture(img);
> noStroke();
> model(geom1);
> pop();
>
> // Right (flipped).
> push();
> translate(25, 0, 0);
> texture(img);
> noStroke();
> model(geom2);
> pop();
>
> describe(
> 'Two photos of a ceiling on a gray background. The photos are mirror images of each other.'
> );
> }
>
> function createShape() {
> plane(40);
> }
> </code>
>
<

See also: ~
   |help p5-anonymous| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:1331
~


p5-Shape_arc() 📄 ⚡
|arc|(x, y, w, h, start, stop, {Constant} [mode] optional parameter to determine the way of drawing, {Integer} [detail] optional parameter for WebGL mode only. This is to) ⚡ Function

Draws an `arc`.
An `arc` is a section of an `ellipse` defined by the `x`, `y`, `w`, and `h` parameters.
`x` and `y` `set` the location of the `arc`'s center.
`w` and `h` `set` the `arc`'s `width` and `height`.
See <a href="#/p5/`ellipse`">`ellipse`()</a> and <a href="#/p5/ellipseMode">ellipseMode()</a> for more details.
The fifth and sixth parameters, `start` and `stop`, `set` the angles between which to `draw` the `arc`.
Arcs are always drawn clockwise from `start` to `stop`.
The fifth and sixth parameters, start and stop, `set` the angles between which to `draw` the `arc`.
By default, angles are given in radians, but if angleMode (DEGREES) is `set`, the function interprets the values in degrees.
The seventh parameter, `mode`, is optional.
It determines the `arc`'s `fill` style.
The `fill` modes are a semi-`circle` (`OPEN`), a closed semi-`circle` (`CHORD`), or a closed pie segment (`PIE`).
The eighth parameter, `detail`, is also optional.
It determines how many vertices are used to `draw` the `arc` in WebGL mode.
The default value is 25.

Parameters: ~
                🔢 `x` (Number) - x-coordinate of the arc's ellipse.
                🔢 `y` (Number) - y-coordinate of the arc's ellipse.
                🔢 `w` (Number) - width of the arc's ellipse by default.
                🔢 `h` (Number) - height of the arc's ellipse by default.
                🔢 `start` (Number) - angle to start the arc, specified in radians.
                🔢 `stop` (Number) - angle to stop the arc, specified in radians.
                🔢 `{Constant} [mode] optional parameter to determine the way of drawing` (unknown)
                🔢 `{Integer} [detail] optional parameter for WebGL mode only. This is to` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Bottom-right.
> arc(50, 55, 50, 50, 0, HALF_PI);
>
> noFill();
>
> // Bottom-left.
> arc(50, 55, 60, 60, HALF_PI, PI);
>
> // Top-left.
> arc(50, 55, 70, 70, PI, PI + QUARTER_PI);
>
> // Top-right.
> arc(50, 55, 80, 80, PI + QUARTER_PI, TWO_PI);
>
> describe(
> 'A shattered outline of an circle with a quarter of a white circle at the bottom-right.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Default fill mode.
> arc(50, 50, 80, 80, 0, PI + QUARTER_PI);
>
> describe('A white circle with the top-right third missing. The bottom is outlined in black.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // OPEN fill mode.
> arc(50, 50, 80, 80, 0, PI + QUARTER_PI, OPEN);
>
> describe(
> 'A white circle missing a section from the top-right. The bottom is outlined in black.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // CHORD fill mode.
> arc(50, 50, 80, 80, 0, PI + QUARTER_PI, CHORD);
>
> describe('A white circle with a black outline missing a section from the top-right.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // PIE fill mode.
> arc(50, 50, 80, 80, 0, PI + QUARTER_PI, PIE);
>
> describe('A white circle with a black outline. The top-right third is missing.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // PIE fill mode.
> arc(0, 0, 80, 80, 0, PI + QUARTER_PI, PIE);
>
> describe('A white circle with a black outline. The top-right third is missing.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // PIE fill mode with 5 vertices.
> arc(0, 0, 80, 80, 0, PI + QUARTER_PI, PIE, 5);
>
> describe('A white circle with a black outline. The top-right third is missing.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> describe('A yellow circle on a black background. The circle opens and closes its mouth.');
> }
>
> function draw() {
> background(0);
>
> // Style the arc.
> noStroke();
> fill(255, 255, 0);
>
> // Update start and stop angles.
> let biteSize = PI / 16;
> let startAngle = biteSize * sin(frameCount * 0.1) + biteSize;
> let endAngle = TWO_PI - startAngle;
>
> // Draw the arc.
> arc(50, 50, 80, 80, startAngle, endAngle, PIE);
> }
> </code>
>
<

See also: ~
   |help p5-arc| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/2d_primitives.js:316
~


p5-Shape_beginContour() 📄 ⚡
|beginContour|() ⚡ Function

Begins creating a hole within a flat shape.
The `beginContour()` and <a href="#/p5/endContour">endContour()</a> functions allow for creating negative space within custom shapes that are flat.
`beginContour()` begins adding vertices to a negative space and <a href="#/p5/endContour">endContour()</a> stops adding them.
`beginContour()` and <a href="#/p5/endContour">endContour()</a> must be called between <a href="#/p5/`beginShape`">`beginShape`()</a> and <a href="#/p5/`endShape`">`endShape`()</a>.
Transformations such as <a href="#/p5/`translate`">`translate`()</a>, <a href="#/p5/`rotate`">`rotate`()</a>, and <a href="#/p5/`scale`">`scale`()</a> don't work between `beginContour()` and <a href="#/p5/endContour">endContour()</a>.
It's also not possible to use other shapes, such as <a href="#/p5/`ellipse`">`ellipse`()</a> or <a href="#/p5/`rect`">`rect`()</a>, between `beginContour()` and <a href="#/p5/endContour">endContour()</a>.
Note: The vertices that define a negative space must "wind" in the opposite direction from the outer shape.
First, `draw` vertices for the outer shape clockwise order.
Then, `draw` vertices for the negative space in counter-clockwise order.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> beginShape();
>
> // Exterior vertices, clockwise winding.
> vertex(10, 10);
> vertex(90, 10);
> vertex(90, 90);
> vertex(10, 90);
>
> // Interior vertices, counter-clockwise winding.
> beginContour();
> vertex(30, 30);
> vertex(30, 70);
> vertex(70, 70);
> vertex(70, 30);
> endContour();
>
> // Stop drawing the shape.
> endShape(CLOSE);
>
> describe('A white square with a square hole in its center drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white square with a square hole in its center drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Start drawing the shape.
> beginShape();
>
> // Exterior vertices, clockwise winding.
> vertex(-40, -40);
> vertex(40, -40);
> vertex(40, 40);
> vertex(-40, 40);
>
> // Interior vertices, counter-clockwise winding.
> beginContour();
> vertex(-20, -20);
> vertex(-20, 20);
> vertex(20, 20);
> vertex(20, -20);
> endContour();
>
> // Stop drawing the shape.
> endShape(CLOSE);
> }
> </code>
>
<

See also: ~
   |help p5-beginContour| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:119
~


p5-Shape_beginGeometry() 📄 ⚡
|beginGeometry|() ⚡ Function

Begins adding shapes to a new <a href="#/p5.Geometry">p5.Geometry</a> object.
The `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> functions help with creating complex 3D shapes from simpler ones such as <a href="#/p5/sphere">sphere()</a>.
`beginGeometry()` begins adding shapes to a custom <a href="#/p5.Geometry">p5.Geometry</a> object and <a href="#/p5/endGeometry">endGeometry()</a> stops adding them.
`beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> can help to make sketches more performant.
For example, if a complex 3D shape doesn’t change while a sketch runs, then it can be created with `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a>.
Creating a <a href="#/p5.Geometry">p5.Geometry</a> object once and then drawing it will run faster than repeatedly drawing the individual pieces.
See <a href="#/p5/buildGeometry">buildGeometry()</a> for another way to build 3D shapes.
Note: `beginGeometry()` can only be used in WebGL mode.

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Start building the p5.Geometry object.
> beginGeometry();
>
> // Add a cone.
> cone();
>
> // Stop building the p5.Geometry object.
> shape = endGeometry();
>
> describe('A white cone drawn on a gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the p5.Geometry object.
> noStroke();
>
> // Draw the p5.Geometry object.
> model(shape);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the p5.Geometry object.
> createArrow();
>
> describe('A white arrow drawn on a gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the p5.Geometry object.
> noStroke();
>
> // Draw the p5.Geometry object.
> model(shape);
> }
>
> function createArrow() {
> // Start building the p5.Geometry object.
> beginGeometry();
>
> // Add shapes.
> push();
> rotateX(PI);
> cone(10);
> translate(0, -10, 0);
> cylinder(3, 20);
> pop();
>
> // Stop building the p5.Geometry object.
> shape = endGeometry();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let blueArrow;
> let redArrow;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the arrows.
> redArrow = createArrow('red');
> blueArrow = createArrow('blue');
>
> describe('A red arrow and a blue arrow drawn on a gray background. The blue arrow rotates slowly.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the arrows.
> noStroke();
>
> // Draw the red arrow.
> model(redArrow);
>
> // Translate and rotate the coordinate system.
> translate(30, 0, 0);
> rotateZ(frameCount * 0.01);
>
> // Draw the blue arrow.
> model(blueArrow);
> }
>
> function createArrow(fillColor) {
> // Start building the p5.Geometry object.
> beginGeometry();
>
> fill(fillColor);
>
> // Add shapes to the p5.Geometry object.
> push();
> rotateX(PI);
> cone(10);
> translate(0, -10, 0);
> cylinder(3, 20);
> pop();
>
> // Stop building the p5.Geometry object.
> let shape = endGeometry();
>
> return shape;
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let button;
> let particles;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a button to reset the particle system.
> button = createButton('Reset');
>
> // Call resetModel() when the user presses the button.
> button.mousePressed(resetModel);
>
> // Add the original set of particles.
> resetModel();
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the particles.
> noStroke();
>
> // Draw the particles.
> model(particles);
> }
>
> function resetModel() {
> // If the p5.Geometry object has already been created,
> // free those resources.
> if (particles) {
> freeGeometry(particles);
> }
>
> // Create a new p5.Geometry object with random spheres.
> particles = createParticles();
> }
>
> function createParticles() {
> // Start building the p5.Geometry object.
> beginGeometry();
>
> // Add shapes.
> for (let i = 0; i < 60; i += 1) {
> // Calculate random coordinates.
> let x = randomGaussian(0, 20);
> let y = randomGaussian(0, 20);
> let z = randomGaussian(0, 20);
>
> push();
> // Translate to the particle's coordinates.
> translate(x, y, z);
> // Draw the particle.
> sphere(5);
> pop();
> }
>
> // Stop building the p5.Geometry object.
> let shape = endGeometry();
>
> return shape;
> }
> </code>
>
<

See also: ~
   |help p5-beginGeometry| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:262
~


p5-Shape_beginShape() 📄 ⚡
|beginShape|({Constant} [kind] either POINTS, LINES, TRIANGLES, TRIANGLE_FAN) ⚡ Function

Begins adding vertices to a custom shape.
The ``beginShape`()` and <a href="#/p5/`endShape`">`endShape`()</a> functions allow for creating custom shapes in 2D or 3D.
``beginShape`()` begins adding vertices to a custom shape and <a href="#/p5/`endShape`">`endShape`()</a> stops adding them.
The parameter, `kind`, sets the kind of shape to make.
By default, any irregular polygon can be drawn.
The available modes for kind are: - `POINTS` to `draw` a series of points.
- `LINES` to `draw` a series of unconnected `line` segments.
- `TRIANGLES` to `draw` a series of separate triangles.
- `TRIANGLE_FAN` to `draw` a series of connected triangles sharing the first `vertex` in a fan-like fashion.
- `TRIANGLE_STRIP` to `draw` a series of connected triangles in strip fashion.
- `QUADS` to `draw` a series of separate quadrilaterals (quads).
- `QUAD_STRIP` to `draw` `quad` strip using adjacent edges to form the next `quad`.
- `TESS` to create a filling curve by explicit tessellation (WebGL only).
After calling ``beginShape`()`, shapes can be built by calling <a href="#/p5/`vertex`">`vertex`()</a>, <a href="#/p5/`bezierVertex`">`bezierVertex`()</a>, <a href="#/p5/quadraticVertex">quadraticVertex()</a>, and/or <a href="#/p5/`curveVertex`">`curveVertex`()</a>.
Calling <a href="#/p5/`endShape`">`endShape`()</a> will stop adding vertices to the shape.
Each shape will be outlined with the current `stroke` `color` and filled with the current `fill` `color`.
Transformations such as <a href="#/p5/`translate`">`translate`()</a>, <a href="#/p5/`rotate`">`rotate`()</a>, and <a href="#/p5/`scale`">`scale`()</a> don't work between ``beginShape`()` and <a href="#/p5/`endShape`">`endShape`()</a>.
It's also not possible to use other shapes, such as <a href="#/p5/`ellipse`">`ellipse`()</a> or <a href="#/p5/`rect`">`rect`()</a>, between ``beginShape`()` and <a href="#/p5/`endShape`">`endShape`()</a>.

Parameters: ~
                🔢 `{Constant} [kind] either POINTS, LINES, TRIANGLES, TRIANGLE_FAN` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> beginShape();
>
> // Add vertices.
> vertex(30, 20);
> vertex(85, 20);
> vertex(85, 75);
> vertex(30, 75);
>
> // Stop drawing the shape.
> endShape(CLOSE);
>
> describe('A white square on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> // Only draw the vertices (points).
> beginShape(POINTS);
>
> // Add vertices.
> vertex(30, 20);
> vertex(85, 20);
> vertex(85, 75);
> vertex(30, 75);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Four black dots that form a square are drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> // Only draw lines between alternating pairs of vertices.
> beginShape(LINES);
>
> // Add vertices.
> vertex(30, 20);
> vertex(85, 20);
> vertex(85, 75);
> vertex(30, 75);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Two horizontal black lines on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the shape.
> noFill();
>
> // Start drawing the shape.
> beginShape();
>
> // Add vertices.
> vertex(30, 20);
> vertex(85, 20);
> vertex(85, 75);
> vertex(30, 75);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Three black lines form a sideways U shape on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the shape.
> noFill();
>
> // Start drawing the shape.
> beginShape();
>
> // Add vertices.
> vertex(30, 20);
> vertex(85, 20);
> vertex(85, 75);
> vertex(30, 75);
>
> // Stop drawing the shape.
> // Connect the first and last vertices.
> endShape(CLOSE);
>
> describe('A black outline of a square drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> // Draw a series of triangles.
> beginShape(TRIANGLES);
>
> // Left triangle.
> vertex(30, 75);
> vertex(40, 20);
> vertex(50, 75);
>
> // Right triangle.
> vertex(60, 20);
> vertex(70, 75);
> vertex(80, 20);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Two white triangles drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> // Draw a series of triangles.
> beginShape(TRIANGLE_STRIP);
>
> // Add vertices.
> vertex(30, 75);
> vertex(40, 20);
> vertex(50, 75);
> vertex(60, 20);
> vertex(70, 75);
> vertex(80, 20);
> vertex(90, 75);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Five white triangles that are interleaved drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> // Draw a series of triangles that share their first vertex.
> beginShape(TRIANGLE_FAN);
>
> // Add vertices.
> vertex(57.5, 50);
> vertex(57.5, 15);
> vertex(92, 50);
> vertex(57.5, 85);
> vertex(22, 50);
> vertex(57.5, 15);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Four white triangles form a square are drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> // Draw a series of quadrilaterals.
> beginShape(QUADS);
>
> // Left rectangle.
> vertex(30, 20);
> vertex(30, 75);
> vertex(50, 75);
> vertex(50, 20);
>
> // Right rectangle.
> vertex(65, 20);
> vertex(65, 75);
> vertex(85, 75);
> vertex(85, 20);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Two white rectangles drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> // Draw a series of quadrilaterals.
> beginShape(QUAD_STRIP);
>
> // Add vertices.
> vertex(30, 20);
> vertex(30, 75);
> vertex(50, 20);
> vertex(50, 75);
> vertex(65, 20);
> vertex(65, 75);
> vertex(85, 20);
> vertex(85, 75);
>
> // Stop drawing the shape.
> endShape();
>
> describe('Three white rectangles that share edges are drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // Start drawing the shape.
> // Draw a series of quadrilaterals.
> beginShape(TESS);
>
> // Add the vertices.
> vertex(-30, -30, 0);
> vertex(30, -30, 0);
> vertex(30, -10, 0);
> vertex(-10, -10, 0);
> vertex(-10, 10, 0);
> vertex(30, 10, 0);
> vertex(30, 30, 0);
> vertex(-30, 30, 0);
>
> // Stop drawing the shape.
> // Connect the first and last vertices.
> endShape(CLOSE);
>
> describe('A blocky C shape drawn in white on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag with the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A blocky C shape drawn in red, blue, and green on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Start drawing the shape.
> // Draw a series of quadrilaterals.
> beginShape(TESS);
>
> // Add the vertices.
> fill('red');
> stroke('red');
> vertex(-30, -30, 0);
> vertex(30, -30, 0);
> vertex(30, -10, 0);
> fill('green');
> stroke('green');
> vertex(-10, -10, 0);
> vertex(-10, 10, 0);
> vertex(30, 10, 0);
> fill('blue');
> stroke('blue');
> vertex(30, 30, 0);
> vertex(-30, 30, 0);
>
> // Stop drawing the shape.
> // Connect the first and last vertices.
> endShape(CLOSE);
> }
> </code>
>
<

See also: ~
   |help p5-beginShape| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:518
~


p5-Shape_bezier() 📄 ⚡
|bezier|(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4) ⚡ Function

Parameters: ~
                🔢 `x1` (Number)
                🔢 `y1` (Number)
                🔢 `z1` (Number) - z-coordinate of the first anchor point.
                🔢 `x2` (Number)
                🔢 `y2` (Number)
                🔢 `z2` (Number) - z-coordinate of the first control point.
                🔢 `x3` (Number)
                🔢 `y3` (Number)
                🔢 `z3` (Number) - z-coordinate of the second control point.
                🔢 `x4` (Number)
                🔢 `y4` (Number)
                🔢 `z4` (Number) - z-coordinate of the second anchor point.
~

See also: ~
   |help p5-bezier| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:207
~


p5-Shape_bezierDetail() 📄 ⚡
|bezierDetail|(detail) ⚡ Function

Sets the number of segments used to `draw` Bézier curves in WebGL mode.
In WebGL mode, smooth shapes are drawn using many flat segments.
Adding more flat segments makes shapes appear smoother.
The parameter, `detail`, is the number of segments to use while drawing a Bézier curve.
For example, calling `bezierDetail(5)` will use 5 segments to `draw` curves with the <a href="#/p5/bezier">bezier()</a> function.
By default,`detail` is 20.
Note: `bezierDetail()` has no effect in 2D mode.

Parameters: ~
                🔢 `detail` (Number) - number of segments to use. Defaults to 20.
~

Examples: >
>
> <code>
> // Draw the original curve.
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Draw the anchor points in black.
> stroke(0);
> strokeWeight(5);
> point(85, 20);
> point(15, 80);
>
> // Draw the control points in red.
> stroke(255, 0, 0);
> point(10, 10);
> point(90, 90);
>
> // Draw a black bezier curve.
> noFill();
> stroke(0);
> strokeWeight(1);
> bezier(85, 20, 10, 10, 90, 90, 15, 80);
>
> // Draw red lines from the anchor points to the control points.
> stroke(255, 0, 0);
> line(85, 20, 10, 10);
> line(15, 80, 90, 90);
>
> describe(
> 'A gray square with three curves. A black s-curve has two straight, red lines that extend from its ends. The endpoints of all the curves are marked with dots.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> // Draw the curve with less detail.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // Set the curveDetail() to 5.
> bezierDetail(5);
>
> // Draw the anchor points in black.
> stroke(0);
> strokeWeight(5);
> point(35, -30, 0);
> point(-35, 30, 0);
>
> // Draw the control points in red.
> stroke(255, 0, 0);
> point(-40, -40, 0);
> point(40, 40, 0);
>
> // Draw a black bezier curve.
> noFill();
> stroke(0);
> strokeWeight(1);
> bezier(35, -30, 0, -40, -40, 0, 40, 40, 0, -35, 30, 0);
>
> // Draw red lines from the anchor points to the control points.
> stroke(255, 0, 0);
> line(35, -30, -40, -40);
> line(-35, 30, 40, 40);
>
> describe(
> 'A gray square with three curves. A black s-curve is drawn with jagged segments. Two straight, red lines that extend from its ends. The endpoints of all the curves are marked with dots.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-bezierDetail| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:318
~


p5-Shape_bezierPoint() 📄 ⚡
|bezierPoint|(a, b, c, d, t) ⚡ Function

Calculates coordinates along a Bézier curve using interpolation.
`bezierPoint()` calculates coordinates along a Bézier curve using the anchor and control points.
It expects points in the same order as the <a href="#/p5/bezier">bezier()</a> function.
`bezierPoint()` works one axis at a time.
Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a `point` on the curve.
Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a `point` on the curve.
The first parameter, `a`, is the coordinate of the first anchor `point`.
The second and third parameters, `b` and `c`, are the coordinates of the control points.
The fourth parameter, `d`, is the coordinate of the last anchor `point`.
The fifth parameter, `t`, is the amount to interpolate along the curve.
0 is the first anchor `point`, 1 is the second anchor `point`, and 0.5 is halfway between them.

Parameters: ~
                🔢 `a` (Number) - coordinate of first anchor point.
                🔢 `b` (Number) - coordinate of first control point.
                🔢 `c` (Number) - coordinate of second control point.
                🔢 `d` (Number) - coordinate of second anchor point.
                🔢 `t` (Number) - amount to interpolate between 0 and 1.
~

Returns: ~
                🔢 Returns Number: coordinate of the point on the curve.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Set the coordinates for the curve's anchor and control points.
> let x1 = 85;
> let x2 = 10;
> let x3 = 90;
> let x4 = 15;
> let y1 = 20;
> let y2 = 10;
> let y3 = 90;
> let y4 = 80;
>
> // Style the curve.
> noFill();
>
> // Draw the curve.
> bezier(x1, y1, x2, y2, x3, y3, x4, y4);
>
> // Draw circles along the curve's path.
> fill(255);
>
> // Top-right.
> let x = bezierPoint(x1, x2, x3, x4, 0);
> let y = bezierPoint(y1, y2, y3, y4, 0);
> circle(x, y, 5);
>
> // Center.
> x = bezierPoint(x1, x2, x3, x4, 0.5);
> y = bezierPoint(y1, y2, y3, y4, 0.5);
> circle(x, y, 5);
>
> // Bottom-left.
> x = bezierPoint(x1, x2, x3, x4, 1);
> y = bezierPoint(y1, y2, y3, y4, 1);
> circle(x, y, 5);
>
> describe('A black s-curve on a gray square. The endpoints and center of the curve are marked with white circles.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> describe('A black s-curve on a gray square. A white circle moves back and forth along the curve.');
> }
>
> function draw() {
> background(200);
>
> // Set the coordinates for the curve's anchor and control points.
> let x1 = 85;
> let x2 = 10;
> let x3 = 90;
> let x4 = 15;
> let y1 = 20;
> let y2 = 10;
> let y3 = 90;
> let y4 = 80;
>
> // Draw the curve.
> noFill();
> bezier(x1, y1, x2, y2, x3, y3, x4, y4);
>
> // Calculate the circle's coordinates.
> let t = 0.5 * sin(frameCount * 0.01) + 0.5;
> let x = bezierPoint(x1, x2, x3, x4, t);
> let y = bezierPoint(y1, y2, y3, y4, t);
>
> // Draw the circle.
> fill(255);
> circle(x, y, 5);
> }
> </code>
>
<

See also: ~
   |help p5-bezierPoint| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:438
~


p5-Shape_bezierTangent() 📄 ⚡
|bezierTangent|(a, b, c, d, t) ⚡ Function

Calculates coordinates along a `line` that's tangent to a Bézier curve.
Tangent lines skim the surface of a curve.
A tangent `line`'s slope equals the curve's slope at the `point` where it intersects.
`bezierTangent()` calculates coordinates along a tangent `line` using the Bézier curve's anchor and control points.
It expects points in the same order as the <a href="#/p5/bezier">bezier()</a> function.
`bezierTangent()` works one axis at a time.
Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a `point` on the tangent `line`.
Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a `point` on the tangent `line`.
The first parameter, `a`, is the coordinate of the first anchor `point`.
The second and third parameters, `b` and `c`, are the coordinates of the control points.
The fourth parameter, `d`, is the coordinate of the last anchor `point`.
The fifth parameter, `t`, is the amount to interpolate along the curve.
0 is the first anchor `point`, 1 is the second anchor `point`, and 0.5 is halfway between them.

Parameters: ~
                🔢 `a` (Number) - coordinate of first anchor point.
                🔢 `b` (Number) - coordinate of first control point.
                🔢 `c` (Number) - coordinate of second control point.
                🔢 `d` (Number) - coordinate of second anchor point.
                🔢 `t` (Number) - amount to interpolate between 0 and 1.
~

Returns: ~
                🔢 Returns Number: coordinate of a point on the tangent line.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Set the coordinates for the curve's anchor and control points.
> let x1 = 85;
> let x2 = 10;
> let x3 = 90;
> let x4 = 15;
> let y1 = 20;
> let y2 = 10;
> let y3 = 90;
> let y4 = 80;
>
> // Style the curve.
> noFill();
>
> // Draw the curve.
> bezier(x1, y1, x2, y2, x3, y3, x4, y4);
>
> // Draw tangents along the curve's path.
> fill(255);
>
> // Top-right circle.
> stroke(0);
> let x = bezierPoint(x1, x2, x3, x4, 0);
> let y = bezierPoint(y1, y2, y3, y4, 0);
> circle(x, y, 5);
>
> // Top-right tangent line.
> // Scale the tangent point to draw a shorter line.
> stroke(255, 0, 0);
> let tx = 0.1 * bezierTangent(x1, x2, x3, x4, 0);
> let ty = 0.1 * bezierTangent(y1, y2, y3, y4, 0);
> line(x + tx, y + ty, x - tx, y - ty);
>
> // Center circle.
> stroke(0);
> x = bezierPoint(x1, x2, x3, x4, 0.5);
> y = bezierPoint(y1, y2, y3, y4, 0.5);
> circle(x, y, 5);
>
> // Center tangent line.
> // Scale the tangent point to draw a shorter line.
> stroke(255, 0, 0);
> tx = 0.1 * bezierTangent(x1, x2, x3, x4, 0.5);
> ty = 0.1 * bezierTangent(y1, y2, y3, y4, 0.5);
> line(x + tx, y + ty, x - tx, y - ty);
>
> // Bottom-left circle.
> stroke(0);
> x = bezierPoint(x1, x2, x3, x4, 1);
> y = bezierPoint(y1, y2, y3, y4, 1);
> circle(x, y, 5);
>
> // Bottom-left tangent.
> // Scale the tangent point to draw a shorter line.
> stroke(255, 0, 0);
> tx = 0.1 * bezierTangent(x1, x2, x3, x4, 1);
> ty = 0.1 * bezierTangent(y1, y2, y3, y4, 1);
> line(x + tx, y + ty, x - tx, y - ty);
>
> describe(
> 'A black s-curve on a gray square. The endpoints and center of the curve are marked with white circles. Red tangent lines extend from the white circles.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-bezierTangent| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:556
~


p5-Shape_bezierVertex() 📄 ⚡
|bezierVertex|(x2, y2, z2, x3, y3, z3, x4, y4, z4) ⚡ Function

Parameters: ~
                🔢 `x2` (Number)
                🔢 `y2` (Number)
                🔢 `z2` (Number) - z-coordinate of the first control point.
                🔢 `x3` (Number)
                🔢 `y3` (Number)
                🔢 `z3` (Number) - z-coordinate of the second control point.
                🔢 `x4` (Number)
                🔢 `y4` (Number)
                🔢 `z4` (Number) - z-coordinate of the anchor point.
~

See also: ~
   |help p5-bezierVertex| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:805
~


p5-Shape_box() 📄 ⚡
|box|({Number} [width]     width of the box., {Number} [height]    height of the box., {Number} [depth]     depth of the box., {Integer} [detailX]   number of triangle subdivisions along the x-axis., {Integer} [detailY]   number of triangle subdivisions along the y-axis.) ⚡ Function

Draws a box (rectangular prism).
A box is a 3D shape with six faces.
Each face makes a 90˚ with four neighboring faces.
The first parameter, ``width``, is optional.
If a `Number` is passed, as in `box(20)`, it sets the box’s `width` and `height`.
By default, ``width`` is 50.
The second parameter, ``height``, is also optional.
If a `Number` is passed, as in `box(20, 30)`, it sets the box’s `height`.
By default, ``height`` is `set` to the box’s ``width``.
The third parameter, `depth`, is also optional.
If a `Number` is passed, as in `box(20, 30, 40)`, it sets the box’s depth.
By default, `depth` is `set` to the box’s ``height``.
The fourth parameter, `detailX`, is also optional.
If a `Number` is passed, as in `box(20, 30, 40, 5)`, it sets the number of `triangle` subdivisions to use along the x-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailX` is 1.
The fifth parameter, `detailY`, is also optional.
If a number is passed, as in `box(20, 30, 40, 5, 7)`, it sets the number of `triangle` subdivisions to use along the y-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailY` is 1.
Note: `box()` can only be used in WebGL mode.

Parameters: ~
                🔢 `{Number} [width]     width of the box.` (unknown)
                🔢 `{Number} [height]    height of the box.` (unknown)
                🔢 `{Number} [depth]     depth of the box.` (unknown)
                🔢 `{Integer} [detailX]   number of triangle subdivisions along the x-axis.` (unknown)
                🔢 `{Integer} [detailY]   number of triangle subdivisions along the y-axis.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white box on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the box.
> box();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white box on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the box.
> // Set its width and height to 30.
> box(30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white box on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the box.
> // Set its width to 30 and height to 50.
> box(30, 50);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white box on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the box.
> // Set its width to 30, height to 50, and depth to 10.
> box(30, 50, 10);
> }
> </code>
>
<

See also: ~
   |help p5-box| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:1138
~


p5-Shape_buildGeometry() 📄 ⚡
|buildGeometry|(callback) ⚡ Function

Creates a custom <a href="#/p5.Geometry">p5.Geometry</a> object from simpler 3D shapes.
`buildGeometry()` helps with creating complex 3D shapes from simpler ones such as <a href="#/p5/sphere">sphere()</a>.
It can help to make sketches more performant.
For example, if a complex 3D shape doesn’t change while a sketch runs, then it can be created with `buildGeometry()`.
Creating a <a href="#/p5.Geometry">p5.Geometry</a> object once and then drawing it will run faster than repeatedly drawing the individual pieces.
The parameter, `callback`, is a function with the drawing instructions for the new <a href="#/p5.Geometry">p5.Geometry</a> object.
It will be called once to create the new 3D shape.
See <a href="#/p5/beginGeometry">beginGeometry()</a> and <a href="#/p5/endGeometry">endGeometry()</a> for another way to build 3D shapes.
Note: `buildGeometry()` can only be used in WebGL mode.

Parameters: ~
                ⚡ `callback` (Function) - function that draws the shape.
~

Returns: ~
                🔢 Returns undefined
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the p5.Geometry object.
> shape = buildGeometry(createShape);
>
> describe('A white cone drawn on a gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the p5.Geometry object.
> noStroke();
>
> // Draw the p5.Geometry object.
> model(shape);
> }
>
> // Create p5.Geometry object from a single cone.
> function createShape() {
> cone();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the arrow.
> shape = buildGeometry(createArrow);
>
> describe('A white arrow drawn on a gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the arrow.
> noStroke();
>
> // Draw the arrow.
> model(shape);
> }
>
> function createArrow() {
> // Add shapes to the p5.Geometry object.
> push();
> rotateX(PI);
> cone(10);
> translate(0, -10, 0);
> cylinder(3, 20);
> pop();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the p5.Geometry object.
> shape = buildGeometry(createArrow);
>
> describe('Two white arrows drawn on a gray background. The arrow on the right rotates slowly.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the arrows.
> noStroke();
>
> // Draw the p5.Geometry object.
> model(shape);
>
> // Translate and rotate the coordinate system.
> translate(30, 0, 0);
> rotateZ(frameCount * 0.01);
>
> // Draw the p5.Geometry object again.
> model(shape);
> }
>
> function createArrow() {
> // Add shapes to the p5.Geometry object.
> push();
> rotateX(PI);
> cone(10);
> translate(0, -10, 0);
> cylinder(3, 20);
> pop();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let button;
> let particles;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a button to reset the particle system.
> button = createButton('Reset');
>
> // Call resetModel() when the user presses the button.
> button.mousePressed(resetModel);
>
> // Add the original set of particles.
> resetModel();
>
> describe('A set of white spheres on a gray background. The spheres are positioned randomly. Their positions reset when the user presses the Reset button.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the particles.
> noStroke();
>
> // Draw the particles.
> model(particles);
> }
>
> function resetModel() {
> // If the p5.Geometry object has already been created,
> // free those resources.
> if (particles) {
> freeGeometry(particles);
> }
>
> // Create a new p5.Geometry object with random spheres.
> particles = buildGeometry(createParticles);
> }
>
> function createParticles() {
> for (let i = 0; i < 60; i += 1) {
> // Calculate random coordinates.
> let x = randomGaussian(0, 20);
> let y = randomGaussian(0, 20);
> let z = randomGaussian(0, 20);
>
> push();
> // Translate to the particle's coordinates.
> translate(x, y, z);
> // Draw the particle.
> sphere(5);
> pop();
> }
> }
> </code>
>
<

See also: ~
   |help p5-buildGeometry| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:744
~


p5-Shape_circle() 📄 ⚡
|circle|(x, y, d) ⚡ Function

Draws a `circle`.
A `circle` is a round shape defined by the `x`, `y`, and `d` parameters.
`x` and `y` `set` the location of its center.
`d` sets its `width` and `height` (diameter).
Every `point` on the `circle`'s edge is the same distance, `0.5 * d`, from its center.
`0.5 * d` (half the diameter) is the `circle`'s radius.
See <a href="#/p5/ellipseMode">ellipseMode()</a> for other ways to `set` its position.

Parameters: ~
                🔢 `x` (Number) - x-coordinate of the center of the circle.
                🔢 `y` (Number) - y-coordinate of the center of the circle.
                🔢 `d` (Number) - diameter of the circle.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> circle(0, 0, 25);
>
> describe('A white circle with black outline in the middle of a gray canvas.');
> }
> </code>
>
<

See also: ~
   |help p5-circle| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/2d_primitives.js:533
~


p5-Shape_cone() 📄 ⚡
|cone|({Number}  [radius]  radius of the cone's base. Defaults to 50., {Number}  [height]  height of the cone. Defaults to the value of `radius`., {Integer} [detailX] number of edges used to draw the base. Defaults to 24., {Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 1., {Boolean} [cap]     whether to draw the cone's base.  Defaults to `true`.) ⚡ Function

Draws a cone.
A cone is a 3D shape with triangular faces that connect a flat bottom to a single `point`.
Cones with few faces look like pyramids.
Cones with many faces have smooth surfaces.
The first parameter, `radius`, is optional.
If a `Number` is passed, as in `cone(20)`, it sets the radius of the cone’s base.
By default, `radius` is 50.
The second parameter, ``height``, is also optional.
If a `Number` is passed, as in `cone(20, 30)`, it sets the cone’s `height`.
By default, ``height`` is `set` to the cone’s `radius`.
The third parameter, `detailX`, is also optional.
If a `Number` is passed, as in `cone(20, 30, 5)`, it sets the number of edges used to form the cone's base.
Using more edges makes the base look more like a `circle`.
By default, `detailX` is 24.
The fourth parameter, `detailY`, is also optional.
If a `Number` is passed, as in `cone(20, 30, 5, 7)`, it sets the number of `triangle` subdivisions to use along the y-axis connecting the base to the tip.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailY` is 1.
The fifth parameter, `cap`, is also optional.
If a `false` is passed, as in `cone(20, 30, 5, 7, false)` the cone’s base won’t be drawn.
By default, `cap` is `true`.
Note: `cone()` can only be used in WebGL mode.

Parameters: ~
                🔢 `{Number}  [radius]  radius of the cone's base. Defaults to 50.` (unknown)
                🔢 `{Number}  [height]  height of the cone. Defaults to the value of `radius`.` (unknown)
                🔢 `{Integer} [detailX] number of edges used to draw the base. Defaults to 24.` (unknown)
                🔢 `{Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 1.` (unknown)
                🔢 `{Boolean} [cap]     whether to draw the cone's base.  Defaults to `true`.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cone on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cone.
> cone();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cone on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cone.
> // Set its radius and height to 30.
> cone(30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cone on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cone.
> // Set its radius to 30 and height to 50.
> cone(30, 50);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cone on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cone.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 5.
> cone(30, 50, 5);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white pyramid on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cone.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 5.
> cone(30, 50, 5);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cone on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cone.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 24 and detailY to 2.
> cone(30, 50, 24, 2);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cone on a gray background. Its base is missing.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cone.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 24 and detailY to 1.
> // Don't draw its base.
> cone(30, 50, 24, 1, false);
> }
> </code>
>
<

See also: ~
   |help p5-cone| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:1935
~


p5-Shape_createModel() 📄 ⚡
|createModel|(modelString, {String} [fileType], {Object} [options], {function(p5.Geometry)} [options.successCallback], {function(Event)} [options.failureCallback], {boolean} [options.normalize], {boolean} [options.flipU], {boolean} [options.flipV]) ⚡ Function

Parameters: ~
                📝 `modelString` (String)
                🔢 `{String} [fileType]` (unknown)
                🔢 `{Object} [options]` (unknown)
                🔢 `{function(p5.Geometry)} [options.successCallback]` (unknown)
                🔢 `{function(Event)} [options.failureCallback]` (unknown)
                🔢 `{boolean} [options.normalize]` (unknown)
                🔢 `{boolean} [options.flipU]` (unknown)
                🔢 `{boolean} [options.flipV]` (unknown)
~

Returns: ~
                🔢 Returns p5.Geometry: the <a href="#/p5.Geometry">p5.Geometry</a> object
~

See also: ~
   |help p5-createModel| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:1225
~


p5-Shape_curve() 📄 ⚡
|curve|(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4) ⚡ Function

Parameters: ~
                🔢 `x1` (Number)
                🔢 `y1` (Number)
                🔢 `z1` (Number) - z-coordinate of the first control point.
                🔢 `x2` (Number)
                🔢 `y2` (Number)
                🔢 `z2` (Number) - z-coordinate of the first anchor point.
                🔢 `x3` (Number)
                🔢 `y3` (Number)
                🔢 `z3` (Number) - z-coordinate of the second anchor point.
                🔢 `x4` (Number)
                🔢 `y4` (Number)
                🔢 `z4` (Number) - z-coordinate of the second control point.
~

See also: ~
   |help p5-curve| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:762
~


p5-Shape_curveDetail() 📄 ⚡
|curveDetail|(resolution) ⚡ Function

Sets the number of segments used to `draw` spline curves in WebGL mode.
In WebGL mode, smooth shapes are drawn using many flat segments.
Adding more flat segments makes shapes appear smoother.
The parameter, `detail`, is the number of segments to use while drawing a spline curve.
For example, calling `curveDetail(5)` will use 5 segments to `draw` curves with the <a href="#/p5/curve">curve()</a> function.
By default,`detail` is 20.
Note: `curveDetail()` has no effect in 2D mode.

Parameters: ~
                🔢 `resolution` (Number) - number of segments to use. Defaults to 20.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Draw a black spline curve.
> noFill();
> strokeWeight(1);
> stroke(0);
> curve(5, 26, 73, 24, 73, 61, 15, 65);
>
> // Draw red spline curves from the anchor points to the control points.
> stroke(255, 0, 0);
> curve(5, 26, 5, 26, 73, 24, 73, 61);
> curve(73, 24, 73, 61, 15, 65, 15, 65);
>
> // Draw the anchor points in black.
> strokeWeight(5);
> stroke(0);
> point(73, 24);
> point(73, 61);
>
> // Draw the control points in red.
> stroke(255, 0, 0);
> point(5, 26);
> point(15, 65);
>
> describe(
> 'A gray square with a curve drawn in three segments. The curve is a sideways U shape with red segments on top and bottom, and a black segment on the right. The endpoints of all the segments are marked with dots.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // Set the curveDetail() to 3.
> curveDetail(3);
>
> // Draw a black spline curve.
> noFill();
> strokeWeight(1);
> stroke(0);
> curve(-45, -24, 0, 23, -26, 0, 23, 11, 0, -35, 15, 0);
>
> // Draw red spline curves from the anchor points to the control points.
> stroke(255, 0, 0);
> curve(-45, -24, 0, -45, -24, 0, 23, -26, 0, 23, 11, 0);
> curve(23, -26, 0, 23, 11, 0, -35, 15, 0, -35, 15, 0);
>
> // Draw the anchor points in black.
> strokeWeight(5);
> stroke(0);
> point(23, -26);
> point(23, 11);
>
> // Draw the control points in red.
> stroke(255, 0, 0);
> point(-45, -24);
> point(-35, 15);
>
> describe(
> 'A gray square with a jagged curve drawn in three segments. The curve is a sideways U shape with red segments on top and bottom, and a black segment on the right. The endpoints of all the segments are marked with dots.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-curveDetail| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:865
~


p5-Shape_curvePoint() 📄 ⚡
|curvePoint|(a, b, c, d, t) ⚡ Function

Calculates coordinates along a spline curve using interpolation.
`curvePoint()` calculates coordinates along a spline curve using the anchor and control points.
It expects points in the same order as the <a href="#/p5/curve">curve()</a> function.
`curvePoint()` works one axis at a time.
Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a `point` on the curve.
Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a `point` on the curve.
The first parameter, `a`, is the coordinate of the first control `point`.
The second and third parameters, `b` and `c`, are the coordinates of the anchor points.
The fourth parameter, `d`, is the coordinate of the last control `point`.
The fifth parameter, `t`, is the amount to interpolate along the curve.
0 is the first anchor `point`, 1 is the second anchor `point`, and 0.5 is halfway between them.

Parameters: ~
                🔢 `a` (Number) - coordinate of first control point.
                🔢 `b` (Number) - coordinate of first anchor point.
                🔢 `c` (Number) - coordinate of second anchor point.
                🔢 `d` (Number) - coordinate of second control point.
                🔢 `t` (Number) - amount to interpolate between 0 and 1.
~

Returns: ~
                🔢 Returns Number: coordinate of a point on the curve.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Set the coordinates for the curve's anchor and control points.
> let x1 = 5;
> let y1 = 26;
> let x2 = 73;
> let y2 = 24;
> let x3 = 73;
> let y3 = 61;
> let x4 = 15;
> let y4 = 65;
>
> // Draw the curve.
> noFill();
> curve(x1, y1, x2, y2, x3, y3, x4, y4);
>
> // Draw circles along the curve's path.
> fill(255);
>
> // Top.
> let x = curvePoint(x1, x2, x3, x4, 0);
> let y = curvePoint(y1, y2, y3, y4, 0);
> circle(x, y, 5);
>
> // Center.
> x = curvePoint(x1, x2, x3, x4, 0.5);
> y = curvePoint(y1, y2, y3, y4, 0.5);
> circle(x, y, 5);
>
> // Bottom.
> x = curvePoint(x1, x2, x3, x4, 1);
> y = curvePoint(y1, y2, y3, y4, 1);
> circle(x, y, 5);
>
> describe('A black curve on a gray square. The endpoints and center of the curve are marked with white circles.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> describe('A black curve on a gray square. A white circle moves back and forth along the curve.');
> }
>
> function draw() {
> background(200);
>
> // Set the coordinates for the curve's anchor and control points.
> let x1 = 5;
> let y1 = 26;
> let x2 = 73;
> let y2 = 24;
> let x3 = 73;
> let y3 = 61;
> let x4 = 15;
> let y4 = 65;
>
> // Draw the curve.
> noFill();
> curve(x1, y1, x2, y2, x3, y3, x4, y4);
>
> // Calculate the circle's coordinates.
> let t = 0.5 * sin(frameCount * 0.01) + 0.5;
> let x = curvePoint(x1, x2, x3, x4, t);
> let y = curvePoint(y1, y2, y3, y4, t);
>
> // Draw the circle.
> fill(255);
> circle(x, y, 5);
> }
> </code>
>
<

See also: ~
   |help p5-curvePoint| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:1042
~


p5-Shape_curveTangent() 📄 ⚡
|curveTangent|(a, b, c, d, t) ⚡ Function

Calculates coordinates along a `line` that's tangent to a spline curve.
Tangent lines skim the surface of a curve.
A tangent `line`'s slope equals the curve's slope at the `point` where it intersects.
`curveTangent()` calculates coordinates along a tangent `line` using the spline curve's anchor and control points.
It expects points in the same order as the <a href="#/p5/curve">curve()</a> function.
`curveTangent()` works one axis at a time.
Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a `point` on the tangent `line`.
Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a `point` on the tangent `line`.
The first parameter, `a`, is the coordinate of the first control `point`.
The second and third parameters, `b` and `c`, are the coordinates of the anchor points.
The fourth parameter, `d`, is the coordinate of the last control `point`.
The fifth parameter, `t`, is the amount to interpolate along the curve.
0 is the first anchor `point`, 1 is the second anchor `point`, and 0.5 is halfway between them.

Parameters: ~
                🔢 `a` (Number) - coordinate of first control point.
                🔢 `b` (Number) - coordinate of first anchor point.
                🔢 `c` (Number) - coordinate of second anchor point.
                🔢 `d` (Number) - coordinate of second control point.
                🔢 `t` (Number) - amount to interpolate between 0 and 1.
~

Returns: ~
                🔢 Returns Number: coordinate of a point on the tangent line.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Set the coordinates for the curve's anchor and control points.
> let x1 = 5;
> let y1 = 26;
> let x2 = 73;
> let y2 = 24;
> let x3 = 73;
> let y3 = 61;
> let x4 = 15;
> let y4 = 65;
>
> // Draw the curve.
> noFill();
> curve(x1, y1, x2, y2, x3, y3, x4, y4);
>
> // Draw tangents along the curve's path.
> fill(255);
>
> // Top circle.
> stroke(0);
> let x = curvePoint(x1, x2, x3, x4, 0);
> let y = curvePoint(y1, y2, y3, y4, 0);
> circle(x, y, 5);
>
> // Top tangent line.
> // Scale the tangent point to draw a shorter line.
> stroke(255, 0, 0);
> let tx = 0.2 * curveTangent(x1, x2, x3, x4, 0);
> let ty = 0.2 * curveTangent(y1, y2, y3, y4, 0);
> line(x + tx, y + ty, x - tx, y - ty);
>
> // Center circle.
> stroke(0);
> x = curvePoint(x1, x2, x3, x4, 0.5);
> y = curvePoint(y1, y2, y3, y4, 0.5);
> circle(x, y, 5);
>
> // Center tangent line.
> // Scale the tangent point to draw a shorter line.
> stroke(255, 0, 0);
> tx = 0.2 * curveTangent(x1, x2, x3, x4, 0.5);
> ty = 0.2 * curveTangent(y1, y2, y3, y4, 0.5);
> line(x + tx, y + ty, x - tx, y - ty);
>
> // Bottom circle.
> stroke(0);
> x = curvePoint(x1, x2, x3, x4, 1);
> y = curvePoint(y1, y2, y3, y4, 1);
> circle(x, y, 5);
>
> // Bottom tangent line.
> // Scale the tangent point to draw a shorter line.
> stroke(255, 0, 0);
> tx = 0.2 * curveTangent(x1, x2, x3, x4, 1);
> ty = 0.2 * curveTangent(y1, y2, y3, y4, 1);
> line(x + tx, y + ty, x - tx, y - ty);
>
> describe(
> 'A black curve on a gray square. A white circle moves back and forth along the curve.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-curveTangent| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:1158
~


p5-Shape_curveTightness() 📄 ⚡
|curveTightness|(amount) ⚡ Function

Adjusts the way <a href="#/p5/curve">curve()</a> and <a href="#/p5/`curveVertex`">`curveVertex`()</a> `draw`.
Spline curves are like cables that are attached to a `set` of points.
`curveTightness()` adjusts how tightly the cable is attached to the points.
The parameter, `tightness`, determines how the curve fits to the `vertex` points.
By default, `tightness` is `set` to 0.
Setting tightness to 1, as in `curveTightness(1)`, connects the curve's points using straight lines.
Values in the range from –5 to 5 deform curves while leaving them recognizable.

Parameters: ~
                🔢 `amount` (Number) - amount of tightness.
~

Examples: >
>
> <code>
> // Move the mouse left and right to see the curve change.
>
> function setup() {
> createCanvas(100, 100);
>
> describe('A black curve forms a sideways U shape. The curve deforms as the user moves the mouse from left to right');
> }
>
> function draw() {
> background(200);
>
> // Set the curve's tightness using the mouse.
> let t = map(mouseX, 0, 100, -5, 5, true);
> curveTightness(t);
>
> // Draw the curve.
> noFill();
> beginShape();
> curveVertex(10, 26);
> curveVertex(10, 26);
> curveVertex(83, 24);
> curveVertex(83, 61);
> curveVertex(25, 65);
> curveVertex(25, 65);
> endShape();
> }
> </code>
>
<

See also: ~
   |help p5-curveTightness| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/curves.js:924
~


p5-Shape_curveVertex() 📄 ⚡
|curveVertex|(x, y, {Number} [z] z-coordinate of the vertex.) ⚡ Function

Parameters: ~
                🔢 `x` (Number)
                🔢 `y` (Number)
                🔢 `{Number} [z] z-coordinate of the vertex.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A ghost shape drawn in white on a blue background. When the user drags the mouse, the scene rotates to reveal the outline of a second ghost.');
> }
>
> function draw() {
> background('midnightblue');
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the first ghost.
> noStroke();
> fill('ghostwhite');
>
> beginShape();
> curveVertex(-28, 41, 0);
> curveVertex(-28, 41, 0);
> curveVertex(-29, -33, 0);
> curveVertex(18, -31, 0);
> curveVertex(34, 41, 0);
> curveVertex(34, 41, 0);
> endShape();
>
> // Draw the second ghost.
> noFill();
> stroke('ghostwhite');
>
> beginShape();
> curveVertex(-28, 41, -20);
> curveVertex(-28, 41, -20);
> curveVertex(-29, -33, -20);
> curveVertex(18, -31, -20);
> curveVertex(34, 41, -20);
> curveVertex(34, 41, -20);
> endShape();
> }
> </code>
>
<

See also: ~
   |help p5-curveVertex| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:1213
~


p5-Shape_cylinder() 📄 ⚡
|cylinder|({Number}  [radius]    radius of the cylinder. Defaults to 50., {Number}  [height]    height of the cylinder. Defaults to the value of `radius`., {Integer} [detailX]   number of edges along the top and bottom. Defaults to 24., {Integer} [detailY]   number of triangle subdivisions along the y-axis. Defaults to 1., {Boolean} [bottomCap] whether to draw the cylinder's bottom. Defaults to `true`., {Boolean} [topCap]    whether to draw the cylinder's top. Defaults to `true`.) ⚡ Function

Draws a cylinder.
A cylinder is a 3D shape with triangular faces that connect a flat bottom to a flat top.
Cylinders with few faces look like boxes.
Cylinders with many faces have smooth surfaces.
The first parameter, `radius`, is optional.
If a `Number` is passed, as in `cylinder(20)`, it sets the radius of the cylinder’s base.
By default, `radius` is 50.
The second parameter, ``height``, is also optional.
If a `Number` is passed, as in `cylinder(20, 30)`, it sets the cylinder’s `height`.
By default, ``height`` is `set` to the cylinder’s `radius`.
The third parameter, `detailX`, is also optional.
If a `Number` is passed, as in `cylinder(20, 30, 5)`, it sets the number of edges used to form the cylinder's top and bottom.
Using more edges makes the top and bottom look more like circles.
By default, `detailX` is 24.
The fourth parameter, `detailY`, is also optional.
If a `Number` is passed, as in `cylinder(20, 30, 5, 2)`, it sets the number of `triangle` subdivisions to use along the y-axis, between cylinder's the top and bottom.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailY` is 1.
The fifth parameter, `bottomCap`, is also optional.
If a `false` is passed, as in `cylinder(20, 30, 5, 2, false)` the cylinder’s bottom won’t be drawn.
By default, `bottomCap` is `true`.
The sixth parameter, `topCap`, is also optional.
If a `false` is passed, as in `cylinder(20, 30, 5, 2, false, false)` the cylinder’s top won’t be drawn.
By default, `topCap` is `true`.
Note: `cylinder()` can only be used in WebGL mode.

Parameters: ~
                🔢 `{Number}  [radius]    radius of the cylinder. Defaults to 50.` (unknown)
                🔢 `{Number}  [height]    height of the cylinder. Defaults to the value of `radius`.` (unknown)
                🔢 `{Integer} [detailX]   number of edges along the top and bottom. Defaults to 24.` (unknown)
                🔢 `{Integer} [detailY]   number of triangle subdivisions along the y-axis. Defaults to 1.` (unknown)
                🔢 `{Boolean} [bottomCap] whether to draw the cylinder's bottom. Defaults to `true`.` (unknown)
                🔢 `{Boolean} [topCap]    whether to draw the cylinder's top. Defaults to `true`.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cylinder on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cylinder.
> cylinder();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cylinder on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cylinder.
> // Set its radius and height to 30.
> cylinder(30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cylinder on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cylinder.
> // Set its radius to 30 and height to 50.
> cylinder(30, 50);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white box on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cylinder.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 5.
> cylinder(30, 50, 5);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cylinder on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cylinder.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 24 and detailY to 2.
> cylinder(30, 50, 24, 2);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cylinder on a gray background. Its top is missing.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cylinder.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 24 and detailY to 1.
> // Don't draw its bottom.
> cylinder(30, 50, 24, 1, false);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white cylinder on a gray background. Its top and bottom are missing.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the cylinder.
> // Set its radius to 30 and height to 50.
> // Set its detailX to 24 and detailY to 1.
> // Don't draw its bottom or top.
> cylinder(30, 50, 24, 1, false, false);
> }
> </code>
>
<

See also: ~
   |help p5-cylinder| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:1689
~


p5-Shape_ellipse() 📄 ⚡
|ellipse|(x, y, w, h, {Integer} [detail] optional parameter for WebGL mode only. This is to) ⚡ Function

Parameters: ~
                🔢 `x` (Number)
                🔢 `y` (Number)
                🔢 `w` (Number)
                🔢 `h` (Number)
                🔢 `{Integer} [detail] optional parameter for WebGL mode only. This is to` (unknown)
~

See also: ~
   |help p5-ellipse| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/2d_primitives.js:483
~


p5-Shape_ellipseMode() 📄 ⚡
|ellipseMode|(mode) ⚡ Function

Changes where ellipses, circles, and arcs are drawn.
By default, the first two parameters of <a href="#/p5/`ellipse`">`ellipse`()</a>, <a href="#/p5/`circle`">`circle`()</a>, and <a href="#/p5/`arc`">`arc`()</a> are the x- and y-coordinates of the shape's center.
The next parameters `set` the shape's `width` and `height`.
This is the same as calling `ellipseMode(CENTER)`.
`ellipseMode(RADIUS)` also uses the first two parameters to `set` the x- and y-coordinates of the shape's center.
The next parameters are half of the shapes's `width` and `height`.
Calling ``ellipse`(0, 0, 10, 15)` draws a shape with a `width` of 20 and `height` of 30.
`ellipseMode(CORNER)` uses the first two parameters as the upper-left corner of the shape.
The next parameters are its `width` and `height`.
`ellipseMode(CORNERS)` uses the first two parameters as the location of one corner of the `ellipse`'s bounding box.
The next parameters are the location of the opposite corner.
The argument passed to `ellipseMode()` must be written in ALL CAPS because the constants `CENTER`, `RADIUS`, `CORNER`, and `CORNERS` are defined this way.
JavaScript is a case-sensitive language.

Parameters: ~
                📋 `mode` (Constant) - either CENTER, RADIUS, CORNER, or CORNERS
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // White ellipse.
> ellipseMode(RADIUS);
> fill(255);
> ellipse(50, 50, 30, 30);
>
> // Gray ellipse.
> ellipseMode(CENTER);
> fill(100);
> ellipse(50, 50, 30, 30);
>
> describe('A white circle with a gray circle at its center. Both circles have black outlines.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // White ellipse.
> ellipseMode(CORNER);
> fill(255);
> ellipse(25, 25, 50, 50);
>
> // Gray ellipse.
> ellipseMode(CORNERS);
> fill(100);
> ellipse(25, 25, 50, 50);
>
> describe('A white circle with a gray circle at its top-left corner. Both circles have black outlines.');
> }
> </code>
>
<

See also: ~
   |help p5-ellipseMode| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/attributes.js:87
~


p5-Shape_ellipsoid() 📄 ⚡
|ellipsoid|({Number} [radiusX]  radius of the ellipsoid along the x-axis. Defaults to 50., {Number} [radiusY]  radius of the ellipsoid along the y-axis. Defaults to `radiusX`., {Number} [radiusZ]  radius of the ellipsoid along the z-axis. Defaults to `radiusY`., {Integer} [detailX] number of triangle subdivisions along the x-axis. Defaults to 24., {Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 16.) ⚡ Function

Draws an ellipsoid.
An ellipsoid is a 3D shape with triangular faces that connect to form a round surface.
Ellipsoids with few faces look like crystals.
Ellipsoids with many faces have smooth surfaces and look like eggs.
`ellipsoid()` defines a shape by its radii.
This is different from <a href="#/p5/`ellipse`">`ellipse`()</a> which uses diameters (`width` and `height`).
The first parameter, `radiusX`, is optional.
If a `Number` is passed, as in `ellipsoid(20)`, it sets the radius of the ellipsoid along the x-axis.
By default, `radiusX` is 50.
The second parameter, `radiusY`, is also optional.
If a `Number` is passed, as in `ellipsoid(20, 30)`, it sets the ellipsoid’s radius along the y-axis.
By default, `radiusY` is `set` to the ellipsoid’s `radiusX`.
The third parameter, `radiusZ`, is also optional.
If a `Number` is passed, as in `ellipsoid(20, 30, 40)`, it sets the ellipsoid’s radius along the z-axis.
By default, `radiusZ` is `set` to the ellipsoid’s `radiusY`.
The fourth parameter, `detailX`, is also optional.
If a `Number` is passed, as in `ellipsoid(20, 30, 40, 5)`, it sets the number of `triangle` subdivisions to use along the x-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailX` is 24.
The fifth parameter, `detailY`, is also optional.
If a `Number` is passed, as in `ellipsoid(20, 30, 40, 5, 7)`, it sets the number of `triangle` subdivisions to use along the y-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailY` is 16.
Note: `ellipsoid()` can only be used in WebGL mode.

Parameters: ~
                🔢 `{Number} [radiusX]  radius of the ellipsoid along the x-axis. Defaults to 50.` (unknown)
                🔢 `{Number} [radiusY]  radius of the ellipsoid along the y-axis. Defaults to `radiusX`.` (unknown)
                🔢 `{Number} [radiusZ]  radius of the ellipsoid along the z-axis. Defaults to `radiusY`.` (unknown)
                🔢 `{Integer} [detailX] number of triangle subdivisions along the x-axis. Defaults to 24.` (unknown)
                🔢 `{Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 16.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white sphere on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the ellipsoid.
> // Set its radiusX to 30.
> ellipsoid(30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white ellipsoid on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the ellipsoid.
> // Set its radiusX to 30.
> // Set its radiusY to 40.
> ellipsoid(30, 40);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white ellipsoid on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the ellipsoid.
> // Set its radiusX to 30.
> // Set its radiusY to 40.
> // Set its radiusZ to 50.
> ellipsoid(30, 40, 50);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white ellipsoid on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the ellipsoid.
> // Set its radiusX to 30.
> // Set its radiusY to 40.
> // Set its radiusZ to 50.
> // Set its detailX to 4.
> ellipsoid(30, 40, 50, 4);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white ellipsoid on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the ellipsoid.
> // Set its radiusX to 30.
> // Set its radiusY to 40.
> // Set its radiusZ to 50.
> // Set its detailX to 4.
> // Set its detailY to 3.
> ellipsoid(30, 40, 50, 4, 3);
> }
> </code>
>
<

See also: ~
   |help p5-ellipsoid| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:2133
~


p5-Shape_endContour() 📄 ⚡
|endContour|() ⚡ Function

Stops creating a hole within a flat shape.
The <a href="#/p5/beginContour">beginContour()</a> and `endContour()` functions allow for creating negative space within custom shapes that are flat.
<a href="#/p5/beginContour">beginContour()</a> begins adding vertices to a negative space and `endContour()` stops adding them.
<a href="#/p5/beginContour">beginContour()</a> and `endContour()` must be called between <a href="#/p5/`beginShape`">`beginShape`()</a> and <a href="#/p5/`endShape`">`endShape`()</a>.
Transformations such as <a href="#/p5/`translate`">`translate`()</a>, <a href="#/p5/`rotate`">`rotate`()</a>, and <a href="#/p5/`scale`">`scale`()</a> don't work between <a href="#/p5/beginContour">beginContour()</a> and `endContour()`.
It's also not possible to use other shapes, such as <a href="#/p5/`ellipse`">`ellipse`()</a> or <a href="#/p5/`rect`">`rect`()</a>, between <a href="#/p5/beginContour">beginContour()</a> and `endContour()`.
Note: The vertices that define a negative space must "wind" in the opposite direction from the outer shape.
First, `draw` vertices for the outer shape clockwise order.
Then, `draw` vertices for the negative space in counter-clockwise order.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Start drawing the shape.
> beginShape();
>
> // Exterior vertices, clockwise winding.
> vertex(10, 10);
> vertex(90, 10);
> vertex(90, 90);
> vertex(10, 90);
>
> // Interior vertices, counter-clockwise winding.
> beginContour();
> vertex(30, 30);
> vertex(30, 70);
> vertex(70, 70);
> vertex(70, 30);
> endContour();
>
> // Stop drawing the shape.
> endShape(CLOSE);
>
> describe('A white square with a square hole in its center drawn on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white square with a square hole in its center drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Start drawing the shape.
> beginShape();
>
> // Exterior vertices, clockwise winding.
> vertex(-40, -40);
> vertex(40, -40);
> vertex(40, 40);
> vertex(-40, 40);
>
> // Interior vertices, counter-clockwise winding.
> beginContour();
> vertex(-20, -20);
> vertex(-20, 20);
> vertex(20, 20);
> vertex(20, -20);
> endContour();
>
> // Stop drawing the shape.
> endShape(CLOSE);
> }
> </code>
>
<

See also: ~
   |help p5-endContour| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:1322
~


p5-Shape_endGeometry() 📄 ⚡
|endGeometry|() ⚡ Function

Stops adding shapes to a new <a href="#/p5.Geometry">p5.Geometry</a> object and returns the object.
The `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> functions help with creating complex 3D shapes from simpler ones such as <a href="#/p5/sphere">sphere()</a>.
`beginGeometry()` begins adding shapes to a custom <a href="#/p5.Geometry">p5.Geometry</a> object and <a href="#/p5/endGeometry">endGeometry()</a> stops adding them.
`beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> can help to make sketches more performant.
For example, if a complex 3D shape doesn’t change while a sketch runs, then it can be created with `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a>.
Creating a <a href="#/p5.Geometry">p5.Geometry</a> object once and then drawing it will run faster than repeatedly drawing the individual pieces.
See <a href="#/p5/buildGeometry">buildGeometry()</a> for another way to build 3D shapes.
Note: `endGeometry()` can only be used in WebGL mode.

Returns: ~
                🔢 Returns undefined
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Start building the p5.Geometry object.
> beginGeometry();
>
> // Add a cone.
> cone();
>
> // Stop building the p5.Geometry object.
> shape = endGeometry();
>
> describe('A white cone drawn on a gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the p5.Geometry object.
> noStroke();
>
> // Draw the p5.Geometry object.
> model(shape);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the p5.Geometry object.
> createArrow();
>
> describe('A white arrow drawn on a gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the p5.Geometry object.
> noStroke();
>
> // Draw the p5.Geometry object.
> model(shape);
> }
>
> function createArrow() {
> // Start building the p5.Geometry object.
> beginGeometry();
>
> // Add shapes.
> push();
> rotateX(PI);
> cone(10);
> translate(0, -10, 0);
> cylinder(3, 20);
> pop();
>
> // Stop building the p5.Geometry object.
> shape = endGeometry();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let blueArrow;
> let redArrow;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the arrows.
> redArrow = createArrow('red');
> blueArrow = createArrow('blue');
>
> describe('A red arrow and a blue arrow drawn on a gray background. The blue arrow rotates slowly.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the arrows.
> noStroke();
>
> // Draw the red arrow.
> model(redArrow);
>
> // Translate and rotate the coordinate system.
> translate(30, 0, 0);
> rotateZ(frameCount * 0.01);
>
> // Draw the blue arrow.
> model(blueArrow);
> }
>
> function createArrow(fillColor) {
> // Start building the p5.Geometry object.
> beginGeometry();
>
> fill(fillColor);
>
> // Add shapes to the p5.Geometry object.
> push();
> rotateX(PI);
> cone(10);
> translate(0, -10, 0);
> cylinder(3, 20);
> pop();
>
> // Stop building the p5.Geometry object.
> let shape = endGeometry();
>
> return shape;
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let button;
> let particles;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a button to reset the particle system.
> button = createButton('Reset');
>
> // Call resetModel() when the user presses the button.
> button.mousePressed(resetModel);
>
> // Add the original set of particles.
> resetModel();
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the particles.
> noStroke();
>
> // Draw the particles.
> model(particles);
> }
>
> function resetModel() {
> // If the p5.Geometry object has already been created,
> // free those resources.
> if (particles) {
> freeGeometry(particles);
> }
>
> // Create a new p5.Geometry object with random spheres.
> particles = createParticles();
> }
>
> function createParticles() {
> // Start building the p5.Geometry object.
> beginGeometry();
>
> // Add shapes.
> for (let i = 0; i < 60; i += 1) {
> // Calculate random coordinates.
> let x = randomGaussian(0, 20);
> let y = randomGaussian(0, 20);
> let z = randomGaussian(0, 20);
>
> push();
> // Translate to the particle's coordinates.
> translate(x, y, z);
> // Draw the particle.
> sphere(5);
> pop();
> }
>
> // Stop building the p5.Geometry object.
> let shape = endGeometry();
>
> return shape;
> }
> </code>
>
<

See also: ~
   |help p5-endGeometry| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:516
~


p5-Shape_endShape() 📄 ⚡
|endShape|({Constant} [mode] use CLOSE to close the shape, {Integer} [count] number of times you want to draw/instance the shape (for WebGL mode).) ⚡ Function

Stops adding vertices to a custom shape.
The <a href="#/p5/`beginShape`">`beginShape`()</a> and ``endShape`()` functions allow for creating custom shapes in 2D or 3D.
<a href="#/p5/`beginShape`">`beginShape`()</a> begins adding vertices to a custom shape and ``endShape`()` stops adding them.
The first parameter, `mode`, is optional.
By default, the first and last vertices of a shape aren't connected.
If the constant `CLOSE` is passed, as in ``endShape`(CLOSE)`, then the first and last vertices will be connected.
The second parameter, `count`, is also optional.
In WebGL mode, it’s more efficient to `draw` many copies of the same shape using a technique called <a href="https://webglfundamentals.org/webgl/lessons/webgl-instanced-drawing.html" target="_blank">instancing</a>.
The `count` parameter tells WebGL mode how many copies to `draw`.
For example, calling ``endShape`(CLOSE, 400)` after drawing a custom shape will make it efficient to `draw` 400 copies.
This feature requires <a href="https://p5js.org/tutorials/intro-to-shaders/" target="_blank">writing a custom shader</a>.
After calling <a href="#/p5/`beginShape`">`beginShape`()</a>, shapes can be built by calling <a href="#/p5/`vertex`">`vertex`()</a>, <a href="#/p5/`bezierVertex`">`bezierVertex`()</a>, <a href="#/p5/quadraticVertex">quadraticVertex()</a>, and/or <a href="#/p5/`curveVertex`">`curveVertex`()</a>.
Calling ``endShape`()` will stop adding vertices to the shape.
Each shape will be outlined with the current `stroke` `color` and filled with the current `fill` `color`.
Transformations such as <a href="#/p5/`translate`">`translate`()</a>, <a href="#/p5/`rotate`">`rotate`()</a>, and <a href="#/p5/`scale`">`scale`()</a> don't work between <a href="#/p5/`beginShape`">`beginShape`()</a> and ``endShape`()`.
It's also not possible to use other shapes, such as <a href="#/p5/`ellipse`">`ellipse`()</a> or <a href="#/p5/`rect`">`rect`()</a>, between <a href="#/p5/`beginShape`">`beginShape`()</a> and ``endShape`()`.

Parameters: ~
                🔢 `{Constant} [mode] use CLOSE to close the shape` (unknown)
                🔢 `{Integer} [count] number of times you want to draw/instance the shape (for WebGL mode).` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the shapes.
> noFill();
>
> // Left triangle.
> beginShape();
> vertex(20, 20);
> vertex(45, 20);
> vertex(45, 80);
> endShape(CLOSE);
>
> // Right triangle.
> beginShape();
> vertex(50, 20);
> vertex(75, 20);
> vertex(75, 80);
> endShape();
>
> describe(
> 'Two sets of black lines drawn on a gray background. The three lines on the left form a right triangle. The two lines on the right form a right angle.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(200, 100);
>
> background(240);
>
> noFill();
> stroke(0);
>
> // Open shape (left)
> beginShape();
> vertex(20, 20);
> vertex(80, 20);
> vertex(80, 80);
> endShape();  // Not closed
>
> // Closed shape (right)
> beginShape();
> vertex(120, 20);
> vertex(180, 20);
> vertex(180, 80);
> endShape(CLOSE);  // Closed
>
> describe(
> 'Two right-angled shapes on a light gray background. The left shape is open with three lines. The right shape is closed, forming a triangle.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> // Note: A "uniform" is a global variable within a shader program.
>
> // Create a string with the vertex shader program.
> // The vertex shader is called for each vertex.
> let vertSrc = `#version 300 es
>
> precision mediump float;
>
> in vec3 aPosition;
> flat out int instanceID;
>
> uniform mat4 uModelViewMatrix;
> uniform mat4 uProjectionMatrix;
>
> void main() {
>
> // Copy the instance ID to the fragment shader.
> instanceID = gl_InstanceID;
> vec4 positionVec4 = vec4(aPosition, 1.0);
>
> // gl_InstanceID represents a numeric value for each instance.
> // Using gl_InstanceID allows us to move each instance separately.
> // Here we move each instance horizontally by ID * 23.
> float xOffset = float(gl_InstanceID) * 23.0;
>
> // Apply the offset to the final position.
> gl_Position = uProjectionMatrix * uModelViewMatrix * (positionVec4 -
> vec4(xOffset, 0.0, 0.0, 0.0));
> }
> `;
>
> // Create a string with the fragment shader program.
> // The fragment shader is called for each pixel.
> let fragSrc = `#version 300 es
>
> precision mediump float;
>
> out vec4 outColor;
> flat in int instanceID;
> uniform float numInstances;
>
> void main() {
> vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
> vec4 blue = vec4(0.0, 0.0, 1.0, 1.0);
>
> // Normalize the instance ID.
> float normId = float(instanceID) / numInstances;
>
> // Mix between two colors using the normalized instance ID.
> outColor = mix(red, blue, normId);
> }
> `;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Shader object.
> let myShader = createShader(vertSrc, fragSrc);
>
> background(220);
>
> // Compile and apply the p5.Shader.
> shader(myShader);
>
> // Set the numInstances uniform.
> myShader.setUniform('numInstances', 4);
>
> // Translate the origin to help align the drawing.
> translate(25, -10);
>
> // Style the shapes.
> noStroke();
>
> // Draw the shapes.
> beginShape();
> vertex(0, 0);
> vertex(0, 20);
> vertex(20, 20);
> vertex(20, 0);
> vertex(0, 0);
> endShape(CLOSE, 4);
>
> describe('A row of four squares. Their colors transition from purple on the left to red on the right');
> }
> </code>
>
<

See also: ~
   |help p5-endShape| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:1538
~


p5-Shape_freeGeometry() 📄 ⚡
|freeGeometry|(geometry) ⚡ Function

Clears a <a href="#/p5.Geometry">p5.Geometry</a> object from the graphics processing unit (GPU) memory.
<a href="#/p5.Geometry">p5.Geometry</a> objects can contain lots of data about their vertices, surface normals, colors, and so on.
Complex 3D shapes can use lots of memory which is a limited resource in many GPUs.
Calling `freeGeometry()` can improve performance by freeing a <a href="#/p5.Geometry">p5.Geometry</a> object’s resources from GPU memory.
`freeGeometry()` works with <a href="#/p5.Geometry">p5.Geometry</a> objects created with <a href="#/p5/beginGeometry">beginGeometry()</a> and <a href="#/p5/endGeometry">endGeometry()</a>, <a href="#/p5/buildGeometry">buildGeometry()</a>, and <a href="#/p5/loadModel">loadModel()</a>.
The parameter, `geometry`, is the <a href="#/p5.Geometry">p5.Geometry</a> object to be freed.
Note: A <a href="#/p5.Geometry">p5.Geometry</a> object can still be drawn after its resources are cleared from GPU memory.
It may take longer to `draw` the first time it’s redrawn.
Note: `freeGeometry()` can only be used in WebGL mode.

Parameters: ~
                🔢 `geometry` (p5.Geometry) - 3D shape whose resources should be freed.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // Create a p5.Geometry object.
> beginGeometry();
> cone();
> let shape = endGeometry();
>
> // Draw the shape.
> model(shape);
>
> // Free the shape's resources.
> freeGeometry(shape);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let button;
> let particles;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a button to reset the particle system.
> button = createButton('Reset');
>
> // Call resetModel() when the user presses the button.
> button.mousePressed(resetModel);
>
> // Add the original set of particles.
> resetModel();
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the particles.
> noStroke();
>
> // Draw the particles.
> model(particles);
> }
>
> function resetModel() {
> // If the p5.Geometry object has already been created,
> // free those resources.
> if (particles) {
> freeGeometry(particles);
> }
>
> // Create a new p5.Geometry object with random spheres.
> particles = buildGeometry(createParticles);
> }
>
> function createParticles() {
> for (let i = 0; i < 60; i += 1) {
> // Calculate random coordinates.
> let x = randomGaussian(0, 20);
> let y = randomGaussian(0, 20);
> let z = randomGaussian(0, 20);
>
> push();
> // Translate to the particle's coordinates.
> translate(x, y, z);
> // Draw the particle.
> sphere(5);
> pop();
> }
> }
> </code>
>
<

See also: ~
   |help p5-freeGeometry| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:862
~


p5-Shape_isBinary() 📄 ⚡
|isBinary|() ⚡ Function

This function checks if the file is in ASCII format or in Binary format It is done by searching keyword `solid` at the start of the file.
An ASCII STL data must begin with `solid` as the first six bytes.
However, ASCII STLs lacking the SPACE after the `d` are known to be plentiful.
So, check the first 5 bytes for `solid`.
Several encodings, such as UTF-8, precede the `text` with up to 5 bytes: https://en.wikipedia.org/wiki/Byte_order_mark#Byte_order_marks_by_encoding Search for `solid` to start anywhere after those prefixes.

See also: ~
   |help p5-isBinary| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:735
~


p5-Shape_loadModel() 📄 ⚡
|loadModel|(path, {Object} [options] loading options., {function(p5.Geometry)} [options.successCallback], {function(Event)} [options.failureCallback], {String} [options.fileType], {boolean} [options.normalize], {boolean} [options.flipU], {boolean} [options.flipV]) ⚡ Function

Parameters: ~
                📝 `path` (String)
                🔢 `{Object} [options] loading options.` (unknown)
                🔢 `{function(p5.Geometry)} [options.successCallback]` (unknown)
                🔢 `{function(Event)} [options.failureCallback]` (unknown)
                🔢 `{String} [options.fileType]` (unknown)
                🔢 `{boolean} [options.normalize]` (unknown)
                🔢 `{boolean} [options.flipU]` (unknown)
                🔢 `{boolean} [options.flipV]` (unknown)
~

Returns: ~
                🔢 Returns p5.Geometry: new <a href="#/p5.Geometry">p5.Geometry</a> object.
~

See also: ~
   |help p5-loadModel| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:344
~


p5-Shape_matchDataViewAt() 📄 ⚡
|matchDataViewAt|() ⚡ Function

This function matches the `query` at the provided `offset`

See also: ~
   |help p5-matchDataViewAt| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:752
~


p5-Shape_model() 📄 ⚡
|model|(model) ⚡ Function

Draws a <a href="#/p5.Geometry">p5.Geometry</a> object to the canvas.
The parameter, `model`, is the <a href="#/p5.Geometry">p5.Geometry</a> object to `draw`.
<a href="#/p5.Geometry">p5.Geometry</a> objects can be built with <a href="#/p5/buildGeometry">buildGeometry()</a>, or <a href="#/p5/beginGeometry">beginGeometry()</a> and <a href="#/p5/endGeometry">endGeometry()</a>.
They can also be loaded from a file with <a href="#/p5/loadGeometry">loadGeometry()</a>.
Note: `model()` can only be used in WebGL mode.

Parameters: ~
                🔢 `model` (p5.Geometry) - 3D shape to be drawn.
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the p5.Geometry object.
> shape = buildGeometry(createShape);
>
> describe('A white cone drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the p5.Geometry object.
> model(shape);
> }
>
> // Create p5.Geometry object from a single cone.
> function createShape() {
> cone();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create the p5.Geometry object.
> shape = buildGeometry(createArrow);
>
> describe('Two white arrows drawn on a gray background. The arrow on the right rotates slowly.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the arrows.
> noStroke();
>
> // Draw the p5.Geometry object.
> model(shape);
>
> // Translate and rotate the coordinate system.
> translate(30, 0, 0);
> rotateZ(frameCount * 0.01);
>
> // Draw the p5.Geometry object again.
> model(shape);
> }
>
> function createArrow() {
> // Add shapes to the p5.Geometry object.
> push();
> rotateX(PI);
> cone(10);
> translate(0, -10, 0);
> cylinder(3, 20);
> pop();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let shape;
>
> // Load the file and create a p5.Geometry object.
> function preload() {
> shape = loadModel('assets/octahedron.obj');
> }
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white octahedron drawn against a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the shape.
> model(shape);
> }
> </code>
>
<

See also: ~
   |help p5-model| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:1121
~


p5-Shape_normal() 📄 ⚡
|normal|(x, y, z) ⚡ Function

Parameters: ~
                🔢 `x` (Number) - x-component of the vertex normal.
                🔢 `y` (Number) - y-component of the vertex normal.
                🔢 `z` (Number) - z-component of the vertex normal.
~

See also: ~
   |help p5-normal| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:2279
~


p5-Shape_noSmooth() 📄 ⚡
|noSmooth|() ⚡ Function

Draws certain features with jagged (aliased) edges.
<a href="#/p5/smooth">smooth()</a> is active by default.
In 2D mode, `noSmooth()` is helpful for scaling up images without blurring.
The functions don't affect shapes or fonts.
In WebGL mode, `noSmooth()` causes all shapes to be drawn with jagged (aliased) edges.
The functions don't affect images or fonts.

Examples: >
>
> <code>
> let heart;
>
> // Load a pixelated heart image from an image data string.
> function preload() {
> heart = loadImage('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAAEZJREFUGFd9jcsNACAIQ9tB2MeR3YdBMBBq8CIXPi2vBICIiOwkOedatllqWO6Y8yOWoyuNf1GZwgmf+RRG2YXr+xVFmA8HZ9Mx/KGPMtcAAAAASUVORK5CYII=');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(50);
>
> // Antialiased hearts.
> image(heart, 10, 10);
> image(heart, 20, 10, 16, 16);
> image(heart, 40, 10, 32, 32);
>
> // Aliased hearts.
> noSmooth();
> image(heart, 10, 60);
> image(heart, 20, 60, 16, 16);
> image(heart, 40, 60, 32, 32);
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> circle(0, 0, 80);
>
> describe('A white circle on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Disable smoothing.
> noSmooth();
>
> background(200);
>
> circle(0, 0, 80);
>
> describe('A pixelated white circle on a gray background.');
> }
> </code>
>
<

See also: ~
   |help p5-noSmooth| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/attributes.js:173
~


p5-Shape_parseASCIISTL() 📄 ⚡
|parseASCIISTL|() ⚡ Function

ASCII STL file starts with `solid 'nameOfFile'` Then contain the normal of the face, starting with `facet normal` Next contain a keyword indicating the start of face `vertex`, `outer `loop`` Next comes the three `vertex`, starting with ``vertex` x y z` Vertices ends with `endloop` Face ends with `endfacet` Next face starts with `facet normal` The end of the file is indicated by `endsolid`

See also: ~
   |help p5-parseASCIISTL| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:859
~


p5-Shape_parseBinarySTL() 📄 ⚡
|parseBinarySTL|() ⚡ Function

This function parses the Binary STL files.
https://en.wikipedia.org/wiki/STL_%28file_format%29#Binary_STL Currently there is no support for the colors provided in STL files.

See also: ~
   |help p5-parseBinarySTL| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:767
~


p5-Shape_parseObj() 📄 ⚡
|parseObj|() ⚡ Function

Parse OBJ lines into model.
For reference, this is what a simple model of a square might look like: v -0.5 -0.5 0.5 v -0.5 -0.5 -0.5 v -0.5 0.5 -0.5 v -0.5 0.5 0.5 f 4 3 2 1

See also: ~
   |help p5-parseObj| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:562
~


p5-Shape_parseSTL() 📄 ⚡
|parseSTL|() ⚡ Function

STL files can be of two types, ASCII and Binary, We need to convert the arrayBuffer to an array of strings, to parse it as an ASCII file.

See also: ~
   |help p5-parseSTL| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:701
~


p5-Shape_plane() 📄 ⚡
|plane|({Number} [width]    width of the plane., {Number} [height]   height of the plane., {Integer} [detailX] number of triangle subdivisions along the x-axis., {Integer} [detailY]  number of triangle subdivisions along the y-axis.) ⚡ Function

Draws a plane.
A plane is a four-sided, flat shape with every angle measuring 90˚.
It’s similar to a rectangle and offers advanced drawing features in WebGL mode.
The first parameter, ``width``, is optional.
If a `Number` is passed, as in `plane(20)`, it sets the plane’s `width` and `height`.
By default, ``width`` is 50.
The second parameter, ``height``, is also optional.
If a `Number` is passed, as in `plane(20, 30)`, it sets the plane’s `height`.
By default, ``height`` is `set` to the plane’s ``width``.
The third parameter, `detailX`, is also optional.
If a `Number` is passed, as in `plane(20, 30, 5)` it sets the number of `triangle` subdivisions to use along the x-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailX` is 1.
The fourth parameter, `detailY`, is also optional.
If a `Number` is passed, as in `plane(20, 30, 5, 7)` it sets the number of `triangle` subdivisions to use along the y-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailY` is 1.
Note: `plane()` can only be used in WebGL mode.

Parameters: ~
                🔢 `{Number} [width]    width of the plane.` (unknown)
                🔢 `{Number} [height]   height of the plane.` (unknown)
                🔢 `{Integer} [detailX] number of triangle subdivisions along the x-axis.` (unknown)
                🔢 `{Integer} [detailY]  number of triangle subdivisions along the y-axis.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white plane on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the plane.
> plane();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white plane on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the plane.
> // Set its width and height to 30.
> plane(30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white plane on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the plane.
> // Set its width to 30 and height to 50.
> plane(30, 50);
> }
> </code>
>
<

See also: ~
   |help p5-plane| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:968
~


p5-Shape_quad() 📄 ⚡
|quad|(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, {Integer} [detailX], {Integer} [detailY]) ⚡ Function

Parameters: ~
                🔢 `x1` (Number)
                🔢 `y1` (Number)
                🔢 `z1` (Number) - the z-coordinate of the first point.
                🔢 `x2` (Number)
                🔢 `y2` (Number)
                🔢 `z2` (Number) - the z-coordinate of the second point.
                🔢 `x3` (Number)
                🔢 `y3` (Number)
                🔢 `z3` (Number) - the z-coordinate of the third point.
                🔢 `x4` (Number)
                🔢 `y4` (Number)
                🔢 `z4` (Number) - the z-coordinate of the fourth point.
                🔢 `{Integer} [detailX]` (unknown)
                🔢 `{Integer} [detailY]` (unknown)
~

See also: ~
   |help p5-quad| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/2d_primitives.js:1066
~


p5-Shape_quadraticVertex() 📄 ⚡
|quadraticVertex|(cx, cy, cz, x3, y3, z3) ⚡ Function

Parameters: ~
                🔢 `cx` (Number)
                🔢 `cy` (Number)
                🔢 `cz` (Number) - z-coordinate of the control point.
                🔢 `x3` (Number)
                🔢 `y3` (Number)
                🔢 `z3` (Number) - z-coordinate of the anchor point.
~

See also: ~
   |help p5-quadraticVertex| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:1841
~


p5-Shape_rect() 📄 ⚡
|rect|(x, y, w, h, {Integer} [detailX] number of segments in the x-direction (for WebGL mode)., {Integer} [detailY] number of segments in the y-direction (for WebGL mode).) ⚡ Function

Parameters: ~
                🔢 `x` (Number)
                🔢 `y` (Number)
                🔢 `w` (Number)
                🔢 `h` (Number)
                🔢 `{Integer} [detailX] number of segments in the x-direction (for WebGL mode).` (unknown)
                🔢 `{Integer} [detailY] number of segments in the y-direction (for WebGL mode).` (unknown)
~

See also: ~
   |help p5-rect| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/2d_primitives.js:1224
~


p5-Shape_rectMode() 📄 ⚡
|rectMode|(mode) ⚡ Function

Changes where rectangles and squares are drawn.
By default, the first two parameters of <a href="#/p5/`rect`">`rect`()</a> and <a href="#/p5/square">square()</a>, are the x- and y-coordinates of the shape's upper left corner.
The next parameters `set` the shape's `width` and `height`.
This is the same as calling `rectMode(CORNER)`.
`rectMode(CORNERS)` also uses the first two parameters as the location of one of the corners.
The next parameters are the location of the opposite corner.
This mode only works for <a href="#/p5/`rect`">`rect`()</a>.
`rectMode(CENTER)` uses the first two parameters as the x- and y-coordinates of the shape's center.
The next parameters are its `width` and `height`.
`rectMode(RADIUS)` also uses the first two parameters as the x- and y-coordinates of the shape's center.
The next parameters are half of the shape's `width` and `height`.
The argument passed to `rectMode()` must be written in ALL CAPS because the constants `CENTER`, `RADIUS`, `CORNER`, and `CORNERS` are defined this way.
JavaScript is a case-sensitive language.

Parameters: ~
                📋 `mode` (Constant) - either CORNER, CORNERS, CENTER, or RADIUS
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> rectMode(CORNER);
> fill(255);
> rect(25, 25, 50, 50);
>
> rectMode(CORNERS);
> fill(100);
> rect(25, 25, 50, 50);
>
> describe('A small gray square drawn at the top-left corner of a white square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> rectMode(RADIUS);
> fill(255);
> rect(50, 50, 30, 30);
>
> rectMode(CENTER);
> fill(100);
> rect(50, 50, 30, 30);
>
> describe('A small gray square drawn at the center of a white square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> rectMode(CORNER);
> fill(255);
> square(25, 25, 50);
>
> describe('A white square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> rectMode(RADIUS);
> fill(255);
> square(50, 50, 30);
>
> rectMode(CENTER);
> fill(100);
> square(50, 50, 30);
>
> describe('A small gray square drawn at the center of a white square.');
> }
> </code>
>
<

See also: ~
   |help p5-rectMode| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/attributes.js:290
~


p5-Shape_smooth() 📄 ⚡
|smooth|() ⚡ Function

Draws certain features with smooth (antialiased) edges.
`smooth()` is active by default.
In 2D mode, <a href="#/p5/noSmooth">noSmooth()</a> is helpful for scaling up images without blurring.
The functions don't affect shapes or fonts.
In WebGL mode, <a href="#/p5/noSmooth">noSmooth()</a> causes all shapes to be drawn with jagged (aliased) edges.
The functions don't affect images or fonts.

Examples: >
>
> <code>
> let heart;
>
> // Load a pixelated heart image from an image data string.
> function preload() {
> heart = loadImage('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAAXNSR0IArs4c6QAAAEZJREFUGFd9jcsNACAIQ9tB2MeR3YdBMBBq8CIXPi2vBICIiOwkOedatllqWO6Y8yOWoyuNf1GZwgmf+RRG2YXr+xVFmA8HZ9Mx/KGPMtcAAAAASUVORK5CYII=');
> }
>
> function setup() {
> createCanvas(100, 100);
>
> background(50);
>
> // Antialiased hearts.
> image(heart, 10, 10);
> image(heart, 20, 10, 16, 16);
> image(heart, 40, 10, 32, 32);
>
> // Aliased hearts.
> noSmooth();
> image(heart, 10, 60);
> image(heart, 20, 60, 16, 16);
> image(heart, 40, 60, 32, 32);
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> circle(0, 0, 80);
>
> describe('A white circle on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Disable smoothing.
> noSmooth();
>
> background(200);
>
> circle(0, 0, 80);
>
> describe('A pixelated white circle on a gray background.');
> }
> </code>
>
<

See also: ~
   |help p5-smooth| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/attributes.js:377
~


p5-Shape_sphere() 📄 ⚡
|sphere|({Number} [radius]   radius of the sphere. Defaults to 50., {Integer} [detailX] number of triangle subdivisions along the x-axis. Defaults to 24., {Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 16.) ⚡ Function

Draws a sphere.
A sphere is a 3D shape with triangular faces that connect to form a round surface.
Spheres with few faces look like crystals.
Spheres with many faces have smooth surfaces and look like balls.
The first parameter, `radius`, is optional.
If a `Number` is passed, as in `sphere(20)`, it sets the radius of the sphere.
By default, `radius` is 50.
The second parameter, `detailX`, is also optional.
If a `Number` is passed, as in `sphere(20, 5)`, it sets the number of `triangle` subdivisions to use along the x-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailX` is 24.
The third parameter, `detailY`, is also optional.
If a `Number` is passed, as in `sphere(20, 5, 2)`, it sets the number of `triangle` subdivisions to use along the y-axis.
All 3D shapes are made by connecting triangles to form their surfaces.
By default, `detailY` is 16.
Note: `sphere()` can only be used in WebGL mode.

Parameters: ~
                🔢 `{Number} [radius]   radius of the sphere. Defaults to 50.` (unknown)
                🔢 `{Integer} [detailX] number of triangle subdivisions along the x-axis. Defaults to 24.` (unknown)
                🔢 `{Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 16.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white sphere on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the sphere.
> sphere();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white sphere on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the sphere.
> // Set its radius to 30.
> sphere(30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white sphere on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the sphere.
> // Set its radius to 30.
> // Set its detailX to 6.
> sphere(30, 6);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white sphere on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the sphere.
> // Set its radius to 30.
> // Set its detailX to 24.
> // Set its detailY to 4.
> sphere(30, 24, 4);
> }
> </code>
>
<

See also: ~
   |help p5-sphere| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:1350
~


p5-Shape_square() 📄 ⚡
|square|(x, y, s, {Number} [tl] optional radius of top-left corner., {Number} [tr] optional radius of top-right corner., {Number} [br] optional radius of bottom-right corner., {Number} [bl] optional radius of bottom-left corner.) ⚡ Function

Draws a square.
A square is a four-sided shape defined by the `x`, `y`, and `s` parameters.
`x` and `y` `set` the location of its top-left corner.
`s` sets its `width` and `height`.
Every angle in the square measures 90˚ and all its sides are the same length.
See <a href="#/p5/rectMode">rectMode()</a> for other ways to define squares.
The version of `square()` with four parameters creates a rounded square.
The fourth parameter sets the radius for all four corners.
The version of `square()` with seven parameters also creates a rounded square.
Each of the last four parameters `set` the radius of a corner.
The radii start with the top-left corner and `move` clockwise around the square.
If any of these parameters are omitted, they are `set` to the value of the last radius that was `set`.

Parameters: ~
                🔢 `x` (Number) - x-coordinate of the square.
                🔢 `y` (Number) - y-coordinate of the square.
                🔢 `s` (Number) - side size of the square.
                🔢 `{Number} [tl] optional radius of top-left corner.` (unknown)
                🔢 `{Number} [tr] optional radius of top-right corner.` (unknown)
                🔢 `{Number} [br] optional radius of bottom-right corner.` (unknown)
                🔢 `{Number} [bl] optional radius of bottom-left corner.` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> square(30, 20, 55);
>
> describe('A white square with a black outline in on a gray canvas.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Give all corners a radius of 20.
> square(30, 20, 55, 20);
>
> describe(
> 'A white square with a black outline and round edges on a gray canvas.'
> );
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Give each corner a unique radius.
> square(30, 20, 55, 20, 15, 10, 5);
>
> describe('A white square with a black outline and round edges of different radii.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> square(-20, -30, 55);
>
> describe('A white square with a black outline in on a gray canvas.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white square spins around on gray canvas.');
> }
>
> function draw() {
> background(200);
>
> // Rotate around the y-axis.
> rotateY(frameCount * 0.01);
>
> // Draw the square.
> square(-20, -30, 55);
> }
> </code>
>
<

See also: ~
   |help p5-square| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/2d_primitives.js:1338
~


p5-Shape_strokeCap() 📄 ⚡
|strokeCap|(cap) ⚡ Function

Sets the style for rendering the ends of lines.
The caps for `line` endings are either rounded (`ROUND`), squared (`SQUARE`), or extended (`PROJECT`).
The default cap is `ROUND`.
The argument passed to `strokeCap()` must be written in ALL CAPS because the constants `ROUND`, `SQUARE`, and `PROJECT` are defined this way.
JavaScript is a case-sensitive language.

Parameters: ~
                📋 `cap` (Constant) - either ROUND, SQUARE, or PROJECT
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> strokeWeight(12);
>
> // Top.
> strokeCap(ROUND);
> line(20, 30, 80, 30);
>
> // Middle.
> strokeCap(SQUARE);
> line(20, 50, 80, 50);
>
> // Bottom.
> strokeCap(PROJECT);
> line(20, 70, 80, 70);
>
> describe(
> 'Three horizontal lines. The top line has rounded ends, the middle line has squared ends, and the bottom line has longer, squared ends.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-strokeCap| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/attributes.js:430
~


p5-Shape_strokeJoin() 📄 ⚡
|strokeJoin|(join) ⚡ Function

Sets the style of the joints that connect `line` segments.
Joints are either mitered (`MITER`), beveled (`BEVEL`), or rounded (`ROUND`).
The default joint is `MITER` in 2D mode and `ROUND` in WebGL mode.
The argument passed to `strokeJoin()` must be written in ALL CAPS because the constants `MITER`, `BEVEL`, and `ROUND` are defined this way.
JavaScript is a case-sensitive language.

Parameters: ~
                📋 `join` (Constant) - either MITER, BEVEL, or ROUND
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the line.
> noFill();
> strokeWeight(10);
> strokeJoin(MITER);
>
> // Draw the line.
> beginShape();
> vertex(35, 20);
> vertex(65, 50);
> vertex(35, 80);
> endShape();
>
> describe('A right-facing arrowhead shape with a pointed tip in center of canvas.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the line.
> noFill();
> strokeWeight(10);
> strokeJoin(BEVEL);
>
> // Draw the line.
> beginShape();
> vertex(35, 20);
> vertex(65, 50);
> vertex(35, 80);
> endShape();
>
> describe('A right-facing arrowhead shape with a flat tip in center of canvas.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Style the line.
> noFill();
> strokeWeight(10);
> strokeJoin(ROUND);
>
> // Draw the line.
> beginShape();
> vertex(35, 20);
> vertex(65, 50);
> vertex(35, 80);
> endShape();
>
> describe('A right-facing arrowhead shape with a rounded tip in center of canvas.');
> }
> </code>
>
<

See also: ~
   |help p5-strokeJoin| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/attributes.js:529
~


p5-Shape_strokeWeight() 📄 ⚡
|strokeWeight|(weight) ⚡ Function

Sets the `width` of the `stroke` used for points, lines, and the outlines of shapes.
Note: `strokeWeight()` is affected by transformations, especially calls to <a href="#/p5/`scale`">`scale`()</a>.

Parameters: ~
                🔢 `weight` (Number) - the weight of the stroke (in pixels).
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Top.
> line(20, 20, 80, 20);
>
> // Middle.
> strokeWeight(4);
> line(20, 40, 80, 40);
>
> // Bottom.
> strokeWeight(10);
> line(20, 70, 80, 70);
>
> describe('Three horizontal black lines. The top line is thin, the middle is medium, and the bottom is thick.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Top.
> line(20, 20, 80, 20);
>
> // Scale by a factor of 5.
> scale(5);
>
> // Bottom. Coordinates are adjusted for scaling.
> line(4, 8, 16, 8);
>
> describe('Two horizontal black lines. The top line is thin and the bottom is five times thicker than the top.');
> }
> </code>
>
<

See also: ~
   |help p5-strokeWeight| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/attributes.js:596
~


p5-Shape_torus() 📄 ⚡
|torus|({Number} [radius]      radius of the torus. Defaults to 50., {Number} [tubeRadius]  radius of the tube. Defaults to 10., {Integer} [detailX]    number of edges that form the hole. Defaults to 24., {Integer} [detailY]    number of triangle subdivisions along the y-axis. Defaults to 16.) ⚡ Function

Draws a torus.
A torus is a 3D shape with triangular faces that connect to form a ring.
Toruses with few faces look flattened.
Toruses with many faces have smooth surfaces.
The first parameter, `radius`, is optional.
If a `Number` is passed, as in `torus(30)`, it sets the radius of the ring.
By default, `radius` is 50.
The second parameter, `tubeRadius`, is also optional.
If a `Number` is passed, as in `torus(30, 15)`, it sets the radius of the tube.
By default, `tubeRadius` is 10.
The third parameter, `detailX`, is also optional.
If a `Number` is passed, as in `torus(30, 15, 5)`, it sets the number of edges used to `draw` the hole of the torus.
Using more edges makes the hole look more like a `circle`.
By default, `detailX` is 24.
The fourth parameter, `detailY`, is also optional.
If a `Number` is passed, as in `torus(30, 15, 5, 7)`, it sets the number of `triangle` subdivisions to use while filling in the torus’ `height`.
By default, `detailY` is 16.
Note: `torus()` can only be used in WebGL mode.

Parameters: ~
                🔢 `{Number} [radius]      radius of the torus. Defaults to 50.` (unknown)
                🔢 `{Number} [tubeRadius]  radius of the tube. Defaults to 10.` (unknown)
                🔢 `{Integer} [detailX]    number of edges that form the hole. Defaults to 24.` (unknown)
                🔢 `{Integer} [detailY]    number of triangle subdivisions along the y-axis. Defaults to 16.` (unknown)
~

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white torus on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the torus.
> torus();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white torus on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the torus.
> // Set its radius to 30.
> torus(30);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white torus on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the torus.
> // Set its radius to 30 and tubeRadius to 15.
> torus(30, 15);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white torus on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the torus.
> // Set its radius to 30 and tubeRadius to 15.
> // Set its detailX to 5.
> torus(30, 15, 5);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white torus on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the torus.
> // Set its radius to 30 and tubeRadius to 15.
> // Set its detailX to 5.
> // Set its detailY to 3.
> torus(30, 15, 5, 3);
> }
> </code>
>
<

See also: ~
   |help p5-torus| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:2333
~


p5-Shape_triangle() 📄 ⚡
|triangle|(x1, y1, x2, y2, x3, y3) ⚡ Function

Draws a `triangle`.
A `triangle` is a three-sided shape defined by three points.
The first two parameters specify the `triangle`'s first `point` `(x1, y1)`.
The middle two parameters specify its second `point` `(x2, y2)`.
And the last two parameters specify its third `point` `(x3, y3)`.

Parameters: ~
                🔢 `x1` (Number) - x-coordinate of the first point.
                🔢 `y1` (Number) - y-coordinate of the first point.
                🔢 `x2` (Number) - x-coordinate of the second point.
                🔢 `y2` (Number) - y-coordinate of the second point.
                🔢 `x3` (Number) - x-coordinate of the third point.
                🔢 `y3` (Number) - y-coordinate of the third point.
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> triangle(30, 75, 58, 20, 86, 75);
>
> describe('A white triangle with a black outline on a gray canvas.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> triangle(-20, 25, 8, -30, 36, 25);
>
> describe('A white triangle with a black outline on a gray canvas.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> describe('A white triangle spins around on a gray canvas.');
> }
>
> function draw() {
> background(200);
>
> // Rotate around the y-axis.
> rotateY(frameCount * 0.01);
>
> // Draw the triangle.
> triangle(-20, 25, 8, -30, 36, 25);
> }
> </code>
>
<

See also: ~
   |help p5-triangle| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/2d_primitives.js:1451
~


p5-Shape_uvs() 📄 ⚡
|uvs|() ⚡ Function

Flips the geometry’s texture v-coordinates.
In order for <a href="#/p5/texture">texture()</a> to work, the geometry needs a way to `map` the points on its surface to the `pixels` in a rectangular `image` that's used as a texture.
The geometry's `vertex` at coordinates `(x, y, z)` maps to the texture `image`'s pixel at coordinates `(u, v)`.
The <a href="#/p5.Geometry/uvs">myGeometry.uvs</a> array stores the `(u, v)` coordinates for each `vertex` in the order it was added to the geometry.
Calling `myGeometry.flipV()` flips a geometry's v-coordinates so that the texture appears mirrored vertically.
For example, a plane's four vertices are added clockwise starting from the top-left corner.
Here's how calling `myGeometry.flipV()` would change a plane's texture coordinates: ```js // Print the original texture coordinates.
// Output: [0, 0, 1, 0, 0, 1, 1, 1] console.log(myGeometry.uvs); // Flip the v-coordinates.
myGeometry.flipV(); // Print the flipped texture coordinates.
// Output: [0, 1, 1, 1, 0, 0, 1, 0] console.log(myGeometry.uvs); // Notice the swaps: // Left vertices: [0, 0] &lt;--&gt; [1, 0] // Right vertices: [1, 0] &lt;--&gt; [1, 1] ```

Examples: >
>
> <code>
> let img;
>
> function preload() {
> img = loadImage('assets/laDefense.jpg');
> }
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // Create p5.Geometry objects.
> let geom1 = buildGeometry(createShape);
> let geom2 = buildGeometry(createShape);
>
> // Flip geom2's V texture coordinates.
> geom2.flipV();
>
> // Left (original).
> push();
> translate(-25, 0, 0);
> texture(img);
> noStroke();
> model(geom1);
> pop();
>
> // Right (flipped).
> push();
> translate(25, 0, 0);
> texture(img);
> noStroke();
> model(geom2);
> pop();
>
> describe(
> 'Two photos of a ceiling on a gray background. The photos are mirror images of each other.'
> );
> }
>
> function createShape() {
> plane(40);
> }
> </code>
>
<

See also: ~
   |help p5-uvs| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:1331
~


p5-Shape_vertex() 📄 ⚡
|vertex|(x, y, {Number} [z], {Number} [u]   u-coordinate of the vertex's texture. Defaults to 0., {Number} [v]   v-coordinate of the vertex's texture. Defaults to 0.) ⚡ Function

Parameters: ~
                🔢 `x` (Number)
                🔢 `y` (Number)
                🔢 `{Number} [z]` (unknown)
                🔢 `{Number} [u]   u-coordinate of the vertex's texture. Defaults to 0.` (unknown)
                🔢 `{Number} [v]   v-coordinate of the vertex's texture. Defaults to 0.` (unknown)
~

See also: ~
   |help p5-vertex| for detailed help on this symbol~

Source: ~
                ../temp/src/core/shape/vertex.js:2068
~


p5-Shape_vertexColors() 📄 ⚡
|vertexColors|() ⚡ Function

Removes the geometry’s internal colors.
`p5.Geometry` objects can be created with "internal colors" assigned to vertices or the entire shape.
When a geometry has internal colors, <a href="#/p5/`fill`">`fill`()</a> has no effect.
Calling `myGeometry.clearColors()` allows the <a href="#/p5/`fill`">`fill`()</a> function to apply `color` to the geometry.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> background(200);
>
> // Create a p5.Geometry object.
> // Set its internal color to red.
> beginGeometry();
> fill(255, 0, 0);
> plane(20);
> let myGeometry = endGeometry();
>
> // Style the shape.
> noStroke();
>
> // Draw the p5.Geometry object (center).
> model(myGeometry);
>
> // Translate the origin to the bottom-right.
> translate(25, 25, 0);
>
> // Try to fill the geometry with green.
> fill(0, 255, 0);
>
> // Draw the geometry again (bottom-right).
> model(myGeometry);
>
> // Clear the geometry's colors.
> myGeometry.clearColors();
>
> // Fill the geometry with blue.
> fill(0, 0, 255);
>
> // Translate the origin up.
> translate(0, -50, 0);
>
> // Draw the geometry again (top-right).
> model(myGeometry);
>
> describe(
> 'Three squares drawn against a gray background. Red squares are at the center and the bottom-right. A blue square is at the top-right.'
> );
> }
> </code>
>
<

See also: ~
   |help p5-vertexColors| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:924
~


PROPERTIES                                                   *p5-Shape-properties*

p5-Shape_faces() 📄 🔧
|faces| ⚡ Function

An array that lists which of the geometry's vertices form each of its faces.
All 3D shapes are made by connecting sets of points called *vertices*.
A geometry's surface is formed by connecting vertices to form triangles that are stitched together.
Each triangular patch on the geometry's surface is called a *face*.
The geometry's vertices are stored as <a href="#/p5.Vector">p5.Vector</a> objects in the <a href="#/p5.Geometry/vertices">myGeometry.vertices</a> array.
The geometry's first `vertex` is the <a href="#/p5.Vector">p5.Vector</a> object at `myGeometry.vertices[0]`, its second `vertex` is `myGeometry.vertices[1]`, its third `vertex` is `myGeometry.vertices[2]`, and so on.
For example, a geometry made from a rectangle has two faces because a rectangle is made by joining two triangles.
`myGeometry.faces` for a rectangle would be the two-dimensional array `[[0, 1, 2], [2, 1, 3]]`.
The first face, `myGeometry.faces[0]`, is the array `[0, 1, 2]` because it's formed by connecting `myGeometry.vertices[0]`, `myGeometry.vertices[1]`,and `myGeometry.vertices[2]`.
The second face, `myGeometry.faces[1]`, is the array `[2, 1, 3]` because it's formed by connecting `myGeometry.vertices[2]`, `myGeometry.vertices[1]`,and `myGeometry.vertices[3]`.

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> beginGeometry();
> sphere();
> myGeometry = endGeometry();
>
> describe("A sphere drawn on a gray background. The sphere's surface is a grayscale patchwork of triangles.");
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Style the p5.Geometry object.
> noStroke();
>
> // Set a random seed.
> randomSeed(1234);
>
> // Iterate over the faces array.
> for (let face of myGeometry.faces) {
>
> // Style the face.
> let g = random(0, 255);
> fill(g);
>
> // Draw the face.
> beginShape();
> // Iterate over the vertices that form the face.
> for (let f of face) {
> // Get the vertex's p5.Vector object.
> let v = myGeometry.vertices[f];
> vertex(v.x, v.y, v.z);
> }
> endShape();
>
> }
> }
> </code>
>
<

See also: ~
   |help p5-faces| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:590
~


p5-Shape_length() 📄 🔧
|length| ⚡ Function

Create a 2D array for establishing `stroke` connections

See also: ~
   |help p5-length| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:1956
~


p5-Shape_line() 📄 🔧
|line| ⚡ Function

Draw a `line` given two points

Parameters: ~
                🔢 `x0` (Number) - x-coordinate of first vertex
                🔢 `y0` (Number) - y-coordinate of first vertex
                🔢 `z0` (Number) - z-coordinate of first vertex
                🔢 `x1` (Number) - x-coordinate of second vertex
                🔢 `y1` (Number) - y-coordinate of second vertex
                🔢 `z1` (Number) - z-coordinate of second vertex
~

Examples: >
>
> <code>
> //draw a line
> function setup() {
> createCanvas(100, 100, WEBGL);
> }
>
> function draw() {
> background(200);
> rotateX(frameCount * 0.01);
> rotateY(frameCount * 0.01);
> // Use fill instead of stroke to change the color of shape.
> fill(255, 0, 0);
> line(10, 10, 0, 60, 60, 20);
> }
> </code>
>
<

See also: ~
   |help p5-line| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:2952
~


p5-Shape_nextGeometryId() 📄 🔧
|nextGeometryId| ⚡ Function

Keeps track of how many custom geometry objects have been made so that each can be assigned a unique ID.

See also: ~
   |help p5-nextGeometryId| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/GeometryBuilder.js:137
~


p5-Shape_point() 📄 🔧
|point| ⚡ Function

Draws a `point`, a coordinate in space at the dimension of one pixel, given x, y and z coordinates.
The `color` of the `point` is determined by the current `stroke`, while the `point` size is determined by current `stroke` weight.

Parameters: ~
                🔢 `x` (Number) - x-coordinate of point
                🔢 `y` (Number) - y-coordinate of point
                🔢 `z` (Number) - z-coordinate of point
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100, WEBGL);
> }
>
> function draw() {
> background(50);
> stroke(255);
> strokeWeight(4);
> point(25, 0);
> strokeWeight(3);
> point(-25, 0);
> strokeWeight(2);
> point(0, 25);
> strokeWeight(1);
> point(0, -25);
> }
> </code>
>
<

See also: ~
   |help p5-point| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/3d_primitives.js:2443
~


p5-Shape_vertices() 📄 🔧
|vertices| ⚡ Function

An array with the geometry's vertices.
The geometry's vertices are stored as <a href="#/p5.Vector">p5.Vector</a> objects in the `myGeometry.vertices` array.
The geometry's first `vertex` is the <a href="#/p5.Vector">p5.Vector</a> object at `myGeometry.vertices[0]`, its second `vertex` is `myGeometry.vertices[1]`, its third `vertex` is `myGeometry.vertices[2]`, and so on.

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> myGeometry = new p5.Geometry();
>
> // Create p5.Vector objects to position the vertices.
> let v0 = createVector(-40, 0, 0);
> let v1 = createVector(0, -40, 0);
> let v2 = createVector(40, 0, 0);
>
> // Add the vertices to the p5.Geometry object's vertices array.
> myGeometry.vertices.push(v0, v1, v2);
>
> describe('A white triangle drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the p5.Geometry object.
> model(myGeometry);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> beginGeometry();
> torus(30, 15, 10, 8);
> myGeometry = endGeometry();
>
> describe('A white torus rotates slowly against a dark gray background. Red spheres mark its vertices.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Rotate the coordinate system.
> rotateY(frameCount * 0.01);
>
> // Style the p5.Geometry object.
> fill(255);
> stroke(0);
>
> // Display the p5.Geometry object.
> model(myGeometry);
>
> // Style the vertices.
> fill(255, 0, 0);
> noStroke();
>
> // Iterate over the vertices array.
> for (let v of myGeometry.vertices) {
> // Draw a sphere to mark the vertex.
> push();
> translate(v);
> sphere(2.5);
> pop();
> }
> }
> </code>
>
<

See also: ~
   |help p5-vertices| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:353
~


VARIABLES                                                   *p5-Shape-variables*

p5-Shape_a00() 📄 📌
|a00| ⚡ Function

Inverts a 3×3 matrix

See also: ~
   |help p5-a00| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:311
~


p5-Shape_a01() 📄 📌
|a01| ⚡ Function

invert matrix according to a give matrix

See also: ~
   |help p5-a01| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:226
~


p5-Shape_a02() 📄 📌
|a02| ⚡ Function

invert matrix according to a give matrix

See also: ~
   |help p5-a02| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:226
~


p5-Shape_a03() 📄 📌
|a03| ⚡ Function

invert matrix according to a give matrix

See also: ~
   |help p5-a03| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:226
~


p5-Shape_a10() 📄 📌
|a10| ⚡ Function

invert matrix according to a give matrix

See also: ~
   |help p5-a10| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:226
~


p5-Shape_a11() 📄 📌
|a11| ⚡ Function

invert matrix according to a give matrix

See also: ~
   |help p5-a11| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:226
~


p5-Shape_a12() 📄 📌
|a12| ⚡ Function

invert matrix according to a give matrix

See also: ~
   |help p5-a12| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:226
~


p5-Shape_a13() 📄 📌
|a13| ⚡ Function

invert matrix according to a give matrix

See also: ~
   |help p5-a13| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:226
~


p5-Shape_a23() 📄 📌
|a23| ⚡ Function

transpose according to a given matrix

See also: ~
   |help p5-a23| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:165
~


p5-Shape_array() 📄 📌
|array| ⚡ Function

Applies a matrix to a vector.
The fourth component is `set` to 0.
Returns a vector consisting of the first through third components of the result.

See also: ~
   |help p5-array| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:817
~


p5-Shape_d00() 📄 📌
|d00| ⚡ Function

inspired by Toji's mat4 determinant

See also: ~
   |help p5-d00| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:416
~


p5-Shape_f() 📄 📌
|f| ⚡ Function

sets the perspective matrix

See also: ~
   |help p5-f| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:696
~


p5-Shape_geometry() 📄 📌
|geometry| ⚡ Function

Adds geometry from the renderer's immediate mode into the builder's combined geometry.

See also: ~
   |help p5-geometry| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/GeometryBuilder.js:85
~


p5-Shape_i() 📄 📌
|i| ⚡ Function

Averages the `vertex` normals.
Used in curved surfaces

See also: ~
   |help p5-i| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:1898
~


p5-Shape_lr() 📄 📌
|lr| ⚡ Function

sets the ortho matrix

See also: ~
   |help p5-lr| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:731
~


p5-Shape_modelOutput() 📄 📌
|modelOutput| ⚡ Function

The `saveStl()` function exports `p5.Geometry` objects as 3D models in the STL stereolithography file format.
This way, you can use the 3D shapes you create in p5.js in other software for rendering, animation, 3D printing, or more.
The exported .stl file will include the faces, vertices, and normals of the `p5.Geometry`.
By default, this method saves a `text`-based .stl file.
Alternatively, you can `save` a more compact but less human-readable binary .stl file by passing `{ binary: true }` as a second parameter.

Examples: >
>
> <code>
> let myModel;
> let saveBtn1;
> let saveBtn2;
> function setup() {
> createCanvas(200, 200, WEBGL);
> myModel = buildGeometry(() => {
> for (let i = 0; i < 5; i++) {
> push();
> translate(
> random(-75, 75),
> random(-75, 75),
> random(-75, 75)
> );
> sphere(random(5, 50));
> pop();
> }
> });
>
> saveBtn1 = createButton('Save .stl');
> saveBtn1.mousePressed(function() {
> myModel.saveStl();
> });
> saveBtn2 = createButton('Save binary .stl');
> saveBtn2.mousePressed(function() {
> myModel.saveStl('model.stl', { binary: true });
> });
>
> describe('A few spheres rotating in space');
> }
>
> function draw() {
> background(0);
> noStroke();
> lights();
> rotateX(millis() * 0.001);
> rotateY(millis() * 0.002);
> model(myModel);
> }
> </code>
>
<

See also: ~
   |help p5-modelOutput| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:1089
~


p5-Shape_objStr() 📄 📌
|objStr| ⚡ Function

The `saveObj()` function exports `p5.Geometry` objects as 3D models in the Wavefront .obj file format.
This way, you can use the 3D shapes you create in p5.js in other software for rendering, animation, 3D printing, or more.
The exported .obj file will include the faces and vertices of the `p5.Geometry`, as well as its texture coordinates and normals, if it has them.

Examples: >
>
> <code>
> let myModel;
> let saveBtn;
> function setup() {
> createCanvas(200, 200, WEBGL);
> myModel = buildGeometry(() => {
> for (let i = 0; i < 5; i++) {
> push();
> translate(
> random(-75, 75),
> random(-75, 75),
> random(-75, 75)
> );
> sphere(random(5, 50));
> pop();
> }
> });
>
> saveBtn = createButton('Save .obj');
> saveBtn.mousePressed(() => myModel.saveObj());
>
> describe('A few spheres rotating in space');
> }
>
> function draw() {
> background(0);
> noStroke();
> lights();
> rotateX(millis() * 0.001);
> rotateY(millis() * 0.002);
> model(myModel);
> }
> </code>
>
<

See also: ~
   |help p5-objStr| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:978
~


p5-Shape_ptArray() 📄 📌
|ptArray| ⚡ Function

Adds the vertices and `vertex` attributes for two triangles representing the `stroke` cap of a `line`.
A fragment shader is responsible for displaying the appropriate cap style within the rectangle they make.
The lineSides buffer will include the following values for the points on the cap rectangle: -1 -2 -----------o---o | | -----------o---o 1 2

See also: ~
   |help p5-ptArray| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:2172
~


p5-Shape_reader() 📄 📌
|reader| ⚡ Function

This function parses the Binary STL files.
https://en.wikipedia.org/wiki/STL_%28file_format%29#Binary_STL Currently there is no support for the colors provided in STL files.

See also: ~
   |help p5-reader| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:768
~


p5-Shape_result() 📄 📌
|result| ⚡ Function

This function is only for 4x4 matrices.
Creates a 3x3 matrix whose entries are the top left 3x3 part and returns it.

See also: ~
   |help p5-result| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Matrix.js:949
~


p5-Shape_state() 📄 📌
|state| ⚡ Function

ASCII STL file starts with `solid 'nameOfFile'` Then contain the normal of the face, starting with `facet normal` Next contain a keyword indicating the start of face `vertex`, `outer `loop`` Next comes the three `vertex`, starting with ``vertex` x y z` Vertices ends with `endloop` Face ends with `endfacet` Next face starts with `facet normal` The end of the file is indicated by `endsolid`

See also: ~
   |help p5-state| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/loading.js:860
~


p5-Shape_vertexNormals() 📄 📌
|vertexNormals| ⚡ Function

Calculates the normal vector for each `vertex` on the geometry.
All 3D shapes are made by connecting sets of points called *vertices*.
A geometry's surface is formed by connecting vertices to create triangles that are stitched together.
Each triangular patch on the geometry's surface is called a *face*.
`myGeometry.computeNormals()` performs the math needed to orient each face.
Orientation is important for lighting and other effects.
A face's orientation is defined by its *normal vector* which points out of the face and is normal (perpendicular) to the surface.
Calling `myGeometry.computeNormals()` first calculates each face's normal vector.
Then it calculates the normal vector for each `vertex` by averaging the normal vectors of the faces surrounding the `vertex`.
The `vertex` normals are stored as <a href="#/p5.Vector">p5.Vector</a> objects in the <a href="#/p5.Geometry/vertexNormals">myGeometry.vertexNormals</a> array.
The first parameter, `shadingType`, is optional.
Passing the constant `FLAT`, as in `myGeometry.computeNormals(FLAT)`, provides neighboring faces with their own copies of the vertices they share.
Surfaces appear tiled with flat shading.
Passing the constant `SMOOTH`, as in `myGeometry.computeNormals(SMOOTH)`, makes neighboring faces reuse their shared vertices.
Surfaces appear smoother with smooth shading.
By default, `shadingType` is `FLAT`.
The second parameter, `options`, is also optional.
If an object with a `roundToPrecision` property is passed, as in `myGeometry.computeNormals(SMOOTH, { roundToPrecision: 5 })`, it sets the number of decimal places to use for calculations.
By default, `roundToPrecision` uses 3 decimal places.

Examples: >
>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> beginGeometry();
> torus();
> myGeometry = endGeometry();
>
> // Compute the vertex normals.
> myGeometry.computeNormals();
>
> describe(
> "A white torus drawn on a dark gray background. Red lines extend outward from the torus' vertices."
> );
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Rotate the coordinate system.
> rotateX(1);
>
> // Style the helix.
> stroke(0);
>
> // Display the helix.
> model(myGeometry);
>
> // Style the normal vectors.
> stroke(255, 0, 0);
>
> // Iterate over the vertices and vertexNormals arrays.
> for (let i = 0; i < myGeometry.vertices.length; i += 1) {
>
> // Get the vertex p5.Vector object.
> let v = myGeometry.vertices[i];
>
> // Get the vertex normal p5.Vector object.
> let n = myGeometry.vertexNormals[i];
>
> // Calculate a point along the vertex normal.
> let p = p5.Vector.mult(n, 5);
>
> // Draw the vertex normal as a red line.
> push();
> translate(v);
> line(0, 0, 0, p.x, p.y, p.z);
> pop();
> }
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object using a callback function.
> myGeometry = new p5.Geometry();
>
> // Create p5.Vector objects to position the vertices.
> let v0 = createVector(-40, 0, 0);
> let v1 = createVector(0, -40, 0);
> let v2 = createVector(0, 40, 0);
> let v3 = createVector(40, 0, 0);
>
> // Add the vertices to the p5.Geometry object's vertices array.
> myGeometry.vertices.push(v0, v1, v2, v3);
>
> // Compute the faces array.
> myGeometry.computeFaces();
>
> // Compute the surface normals.
> myGeometry.computeNormals();
>
> describe('A red square drawn on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Add a white point light.
> pointLight(255, 255, 255, 0, 0, 10);
>
> // Style the p5.Geometry object.
> noStroke();
> fill(255, 0, 0);
>
> // Draw the p5.Geometry object.
> model(myGeometry);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> myGeometry = buildGeometry(createShape);
>
> // Compute normals using default (FLAT) shading.
> myGeometry.computeNormals(FLAT);
>
> describe('A white, helical structure drawn on a dark gray background. Its faces appear faceted.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Rotate the coordinate system.
> rotateX(1);
>
> // Style the helix.
> noStroke();
>
> // Display the helix.
> model(myGeometry);
> }
>
> function createShape() {
> // Create a helical shape.
> beginShape();
> for (let i = 0; i < TWO_PI * 3; i += 0.5) {
> let x = 30 * cos(i);
> let y = 30 * sin(i);
> let z = map(i, 0, TWO_PI * 3, -40, 40);
> vertex(x, y, z);
> }
> endShape();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> myGeometry = buildGeometry(createShape);
>
> // Compute normals using smooth shading.
> myGeometry.computeNormals(SMOOTH);
>
> describe('A white, helical structure drawn on a dark gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Rotate the coordinate system.
> rotateX(1);
>
> // Style the helix.
> noStroke();
>
> // Display the helix.
> model(myGeometry);
> }
>
> function createShape() {
> // Create a helical shape.
> beginShape();
> for (let i = 0; i < TWO_PI * 3; i += 0.5) {
> let x = 30 * cos(i);
> let y = 30 * sin(i);
> let z = map(i, 0, TWO_PI * 3, -40, 40);
> vertex(x, y, z);
> }
> endShape();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Click and drag the mouse to view the scene from different angles.
>
> let myGeometry;
>
> function setup() {
> createCanvas(100, 100, WEBGL);
>
> // Create a p5.Geometry object.
> myGeometry = buildGeometry(createShape);
>
> // Create an options object.
> let options = { roundToPrecision: 5 };
>
> // Compute normals using smooth shading.
> myGeometry.computeNormals(SMOOTH, options);
>
> describe('A white, helical structure drawn on a dark gray background.');
> }
>
> function draw() {
> background(50);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Turn on the lights.
> lights();
>
> // Rotate the coordinate system.
> rotateX(1);
>
> // Style the helix.
> noStroke();
>
> // Display the helix.
> model(myGeometry);
> }
>
> function createShape() {
> // Create a helical shape.
> beginShape();
> for (let i = 0; i < TWO_PI * 3; i += 0.5) {
> let x = 30 * cos(i);
> let y = 30 * sin(i);
> let z = map(i, 0, TWO_PI * 3, -40, 40);
> vertex(x, y, z);
> }
> endShape();
> }
> </code>
>
<

See also: ~
   |help p5-vertexNormals| for detailed help on this symbol~

Source: ~
                ../temp/src/webgl/p5.Geometry.js:1817
~




==============================================================================
Generated by p5.js Documentation Automation
See: https://github.com/prjctimg/automata
Last updated: 2026-02-03
📄 End of Shape documentation 📄
==============================================================================