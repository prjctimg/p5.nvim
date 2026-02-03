📄 *p5.Structure*📄
Structure module functions and properties

==============================================================================
Tags p5.Structure Structure module functions and properties
==============================================================================



CONTENTS                                                           *${this.getCurrentModuleName()}-contents*

🔍 NAVIGATION:~
   Use | to jump to sections, :help p5-[symbol] to jump to symbols~

🏛️ CLASSES:
  |p5                       |

⚡ FUNCTIONS:
  |isLooping                |
  |loop                     |
  |noLoop                   |
  |pop                      |
  |push                     |
  |redraw                   |
  |remove                   |

🔧 PROPERTIES:
  |disableFriendlyErrors    |

📌 VARIABLES:
  |style                    |



🔗 RELATED SYMBOLS:~
   See |p5| for complete p5.js API reference~



⚡ QUICK REFERENCE:~
   :help p5-[symbolname] - Jump directly to any function~



CLASSES                                                   *p5-Structure-classes*

p5-Structure_p5() 📄 🏛️
|p5|() 🏛️ Class

This is the p5 instance constructor.
A p5 instance holds all the properties and methods related to a p5 sketch.
It expects an incoming sketch closure and it can also take an optional node parameter for attaching the generated p5 canvas to a node.
The sketch closure takes the newly created p5 instance as its sole argument and may optionally `set` <a href="#/p5/preload">preload()</a>, <a href="#/p5/`setup`">`setup`()</a>, and/or <a href="#/p5/`draw`">`draw`()</a> properties on it for running a sketch.
A p5 sketch can run in "global" or "instance" mode: "global" - all properties and methods are attached to the window "instance" - all properties and methods are bound to this p5 object

Parameters: ~
                🔢 `sketch` (function(p5)) - a closure that can set optional <a href="#/p5/preload">preload()</a>,
                🔢 `{HTMLElement}        [node] element to attach canvas to` (unknown)
~

See also: ~
   |help p5-p5| for detailed help on this symbol~

Source: ~
                ../temp/src/core/main.js:35
~


FUNCTIONS                                                   *p5-Structure-functions*

p5-Structure_isLooping() 📄 ⚡
|isLooping|() ⚡ Function

Returns `true` if the `draw` `loop` is running and `false` if not.
By default, <a href="#/p5/`draw`">`draw`()</a> tries to run 60 times per second.
Calling <a href="#/p5/`noLoop`">`noLoop`()</a> stops <a href="#/p5/`draw`">`draw`()</a> from repeating.
The `draw` `loop` can be restarted by calling <a href="#/p5/`loop`">`loop`()</a>.
The `isLooping()` function can be used to check whether a sketch is looping, as in `isLooping() === true`.

Returns: ~
                🔢 Returns undefined
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> describe('A white circle drawn against a gray background. When the user double-clicks, the circle stops or resumes following the mouse.');
> }
>
> function draw() {
> background(200);
>
> // Draw the circle at the mouse's position.
> circle(mouseX, mouseY, 20);
> }
>
> // Toggle the draw loop when the user double-clicks.
> function doubleClicked() {
> if (isLooping() === true) {
> noLoop();
> } else {
> loop();
> }
> }
> </code>
>
<

See also: ~
   |help p5-isLooping| for detailed help on this symbol~

Source: ~
                ../temp/src/core/structure.js:265
~


p5-Structure_loop() 📄 ⚡
|loop|() ⚡ Function

Resumes the `draw` `loop` after <a href="#/p5/`noLoop`">`noLoop`()</a> has been called.
By default, <a href="#/p5/`draw`">`draw`()</a> tries to run 60 times per second.
Calling <a href="#/p5/`noLoop`">`noLoop`()</a> stops <a href="#/p5/`draw`">`draw`()</a> from repeating.
The `draw` `loop` can be restarted by calling ``loop`()`.
The <a href="#/p5/isLooping">isLooping()</a> function can be used to check whether a sketch is looping, as in `isLooping() === true`.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> // Turn off the draw loop.
> noLoop();
>
> describe(
> 'A white half-circle on the left edge of a gray square. The circle starts moving to the right when the user double-clicks.'
> );
> }
>
> function draw() {
> background(200);
>
> // Calculate the circle's x-coordinate.
> let x = frameCount;
>
> // Draw the circle.
> circle(x, 50, 20);
> }
>
> // Resume the draw loop when the user double-clicks.
> function doubleClicked() {
> loop();
> }
> </code>
> </div>
>
> <div>
> <code>
> let startButton;
> let stopButton;
>
> function setup() {
> createCanvas(100, 100);
>
> // Create the button elements and place them
> // beneath the canvas.
> startButton = createButton('▶');
> startButton.position(0, 100);
> startButton.size(50, 20);
> stopButton = createButton('◾');
> stopButton.position(50, 100);
> stopButton.size(50, 20);
>
> // Set functions to call when the buttons are pressed.
> startButton.mousePressed(loop);
> stopButton.mousePressed(noLoop);
>
> // Slow the frame rate.
> frameRate(5);
>
> describe(
> 'A white circle moves randomly on a gray background. Play and stop buttons are shown beneath the canvas. The circle stops or starts moving when the user presses a button.'
> );
> }
>
> function draw() {
> background(200);
>
> // Calculate the circle's coordinates.
> let x = random(0, 100);
> let y = random(0, 100);
>
> // Draw the circle.
> // Normally, the circle would move from left to right.
> circle(x, y, 20);
> }
> </code>
>
<

See also: ~
   |help p5-loop| for detailed help on this symbol~

Source: ~
                ../temp/src/core/structure.js:215
~


p5-Structure_noLoop() 📄 ⚡
|noLoop|() ⚡ Function

Stops the code in <a href="#/p5/`draw`">`draw`()</a> from running repeatedly.
By default, <a href="#/p5/`draw`">`draw`()</a> tries to run 60 times per second.
Calling ``noLoop`()` stops <a href="#/p5/`draw`">`draw`()</a> from repeating.
The `draw` `loop` can be restarted by calling <a href="#/p5/`loop`">`loop`()</a>.
<a href="#/p5/`draw`">`draw`()</a> can be run once by calling <a href="#/p5/`redraw`">`redraw`()</a>.
The <a href="#/p5/isLooping">isLooping()</a> function can be used to check whether a sketch is looping, as in `isLooping() === true`.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> // Turn off the draw loop.
> noLoop();
>
> describe('A white half-circle on the left edge of a gray square.');
> }
>
> function draw() {
> background(200);
>
> // Calculate the circle's x-coordinate.
> let x = frameCount;
>
> // Draw the circle.
> // Normally, the circle would move from left to right.
> circle(x, 50, 20);
> }
> </code>
> </div>
>
> <div>
> <code>
> // Double-click to stop the draw loop.
>
> function setup() {
> createCanvas(100, 100);
>
> // Slow the frame rate.
> frameRate(5);
>
> describe('A white circle moves randomly on a gray background. It stops moving when the user double-clicks.');
> }
>
> function draw() {
> background(200);
>
> // Calculate the circle's coordinates.
> let x = random(0, 100);
> let y = random(0, 100);
>
> // Draw the circle.
> // Normally, the circle would move from left to right.
> circle(x, y, 20);
> }
>
> // Stop the draw loop when the user double-clicks.
> function doubleClicked() {
> noLoop();
> }
> </code>
> </div>
>
> <div>
> <code>
> let startButton;
> let stopButton;
>
> function setup() {
> createCanvas(100, 100);
>
> // Create the button elements and place them
> // beneath the canvas.
> startButton = createButton('▶');
> startButton.position(0, 100);
> startButton.size(50, 20);
> stopButton = createButton('◾');
> stopButton.position(50, 100);
> stopButton.size(50, 20);
>
> // Set functions to call when the buttons are pressed.
> startButton.mousePressed(loop);
> stopButton.mousePressed(noLoop);
>
> // Slow the frame rate.
> frameRate(5);
>
> describe(
> 'A white circle moves randomly on a gray background. Play and stop buttons are shown beneath the canvas. The circle stops or starts moving when the user presses a button.'
> );
> }
>
> function draw() {
> background(200);
>
> // Calculate the circle's coordinates.
> let x = random(0, 100);
> let y = random(0, 100);
>
> // Draw the circle.
> // Normally, the circle would move from left to right.
> circle(x, y, 20);
> }
> </code>
>
<

See also: ~
   |help p5-noLoop| for detailed help on this symbol~

Source: ~
                ../temp/src/core/structure.js:123
~


p5-Structure_pop() 📄 ⚡
|pop|() ⚡ Function

Ends a drawing group that contains its own styles and transformations.
By default, styles such as <a href="#/p5/`fill`">`fill`()</a> and transformations such as <a href="#/p5/`rotate`">`rotate`()</a> are applied to all drawing that follows.
The <a href="#/p5/`push`">`push`()</a> and ``pop`()` functions can limit the effect of styles and transformations to a specific group of shapes, images, and `text`.
For example, a group of shapes could be translated to follow the mouse without affecting the rest of the sketch: ```js // Begin the drawing group.
`push`(); // Translate the origin to the mouse's position.
`translate`(`mouseX`, `mouseY`); // Style the face.
noStroke(); `fill`('`green`'); // Draw the face.
`circle`(0, 0, 60); // Style the eyes.
`fill`('white'); // Draw the left eye.
`ellipse`(-20, -20, 30, 20); // Draw the right eye.
`ellipse`(20, -20, 30, 20); // End the drawing group.
`pop`(); // Draw a bug.
let x = `random`(0, 100); let y = `random`(0, 100); `text`('🦟', x, y); ``` In the code snippet above, the bug's position isn't affected by ``translate`(`mouseX`, `mouseY`)` because that transformation is contained between <a href="#/p5/`push`">`push`()</a> and ``pop`()`.
The bug moves around the entire canvas as expected.
Note: <a href="#/p5/`push`">`push`()</a> and ``pop`()` are always called as a pair.
Both functions are required to begin and end a drawing group.
<a href="#/p5/`push`">`push`()</a> and ``pop`()` can also be nested to create subgroups.
For example, the code snippet above could be changed to give more detail to the frog’s eyes: ```js // Begin the drawing group.
`push`(); // Translate the origin to the mouse's position.
`translate`(`mouseX`, `mouseY`); // Style the face.
noStroke(); `fill`('`green`'); // Draw a face.
`circle`(0, 0, 60); // Style the eyes.
`fill`('white'); // Draw the left eye.
`push`(); `translate`(-20, -20); `ellipse`(0, 0, 30, 20); `fill`('black'); `circle`(0, 0, 8); `pop`(); // Draw the right eye.
`push`(); `translate`(20, -20); `ellipse`(0, 0, 30, 20); `fill`('black'); `circle`(0, 0, 8); `pop`(); // End the drawing group.
`pop`(); // Draw a bug.
let x = `random`(0, 100); let y = `random`(0, 100); `text`('🦟', x, y); ``` In this version, the code to `draw` each eye is contained between its own <a href="#/p5/`push`">`push`()</a> and ``pop`()` functions.
Doing so makes it easier to add details in the correct part of a drawing.
<a href="#/p5/`push`">`push`()</a> and ``pop`()` contain the effects of the following functions: - <a href="#/p5/`fill`">`fill`()</a> - <a href="#/p5/`noFill`">`noFill`()</a> - <a href="#/p5/noStroke">noStroke()</a> - <a href="#/p5/`stroke`">`stroke`()</a> - <a href="#/p5/tint">tint()</a> - <a href="#/p5/noTint">noTint()</a> - <a href="#/p5/strokeWeight">strokeWeight()</a> - <a href="#/p5/strokeCap">strokeCap()</a> - <a href="#/p5/strokeJoin">strokeJoin()</a> - <a href="#/p5/imageMode">imageMode()</a> - <a href="#/p5/rectMode">rectMode()</a> - <a href="#/p5/ellipseMode">ellipseMode()</a> - <a href="#/p5/`colorMode`">`colorMode`()</a> - <a href="#/p5/`textAlign`">`textAlign`()</a> - <a href="#/p5/`textFont`">`textFont`()</a> - <a href="#/p5/`textSize`">`textSize`()</a> - <a href="#/p5/textLeading">textLeading()</a> - <a href="#/p5/`applyMatrix`">`applyMatrix`()</a> - <a href="#/p5/`resetMatrix`">`resetMatrix`()</a> - <a href="#/p5/`rotate`">`rotate`()</a> - <a href="#/p5/`scale`">`scale`()</a> - <a href="#/p5/`shearX`">`shearX`()</a> - <a href="#/p5/`shearY`">`shearY`()</a> - <a href="#/p5/`translate`">`translate`()</a> In WebGL mode, <a href="#/p5/`push`">`push`()</a> and ``pop`()` contain the effects of a few additional styles: - <a href="#/p5/setCamera">setCamera()</a> - <a href="#/p5/ambientLight">ambientLight()</a> - <a href="#/p5/directionalLight">directionalLight()</a> - <a href="#/p5/pointLight">pointLight()</a> <a href="#/p5/texture">texture()</a> - <a href="#/p5/specularMaterial">specularMaterial()</a> - <a href="#/p5/shininess">shininess()</a> - <a href="#/p5/normalMaterial">normalMaterial()</a> - <a href="#/p5/shader">shader()</a>

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Draw the left circle.
> circle(25, 50, 20);
>
> // Begin the drawing group.
> push();
>
> // Translate the origin to the center.
> translate(50, 50);
>
> // Style the circle.
> strokeWeight(5);
> stroke('royalblue');
> fill('orange');
>
> // Draw the circle.
> circle(0, 0, 20);
>
> // End the drawing group.
> pop();
>
> // Draw the right circle.
> circle(75, 50, 20);
>
> describe(
> 'Three circles drawn in a row on a gray background. The left and right circles are white with thin, black borders. The middle circle is orange with a thick, blue border.'
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
> // Slow the frame rate.
> frameRate(24);
>
> describe('A mosquito buzzes in front of a green frog. The frog follows the mouse as the user moves.');
> }
>
> function draw() {
> background(200);
>
> // Begin the drawing group.
> push();
>
> // Translate the origin to the mouse's position.
> translate(mouseX, mouseY);
>
> // Style the face.
> noStroke();
> fill('green');
>
> // Draw a face.
> circle(0, 0, 60);
>
> // Style the eyes.
> fill('white');
>
> // Draw the left eye.
> push();
> translate(-20, -20);
> ellipse(0, 0, 30, 20);
> fill('black');
> circle(0, 0, 8);
> pop();
>
> // Draw the right eye.
> push();
> translate(20, -20);
> ellipse(0, 0, 30, 20);
> fill('black');
> circle(0, 0, 8);
> pop();
>
> // End the drawing group.
> pop();
>
> // Draw a bug.
> let x = random(0, 100);
> let y = random(0, 100);
> text('🦟', x, y);
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
> describe(
> 'Two spheres drawn on a gray background. The sphere on the left is red and lit from the front. The sphere on the right is a blue wireframe.'
> );
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the red sphere.
> push();
> translate(-25, 0, 0);
> noStroke();
> directionalLight(255, 0, 0, 0, 0, -1);
> sphere(20);
> pop();
>
> // Draw the blue sphere.
> push();
> translate(25, 0, 0);
> strokeWeight(0.3);
> stroke(0, 0, 255);
> noFill();
> sphere(20);
> pop();
> }
> </code>
>
<

See also: ~
   |help p5-pop| for detailed help on this symbol~

Source: ~
                ../temp/src/core/structure.js:828
~


p5-Structure_push() 📄 ⚡
|push|() ⚡ Function

Begins a drawing group that contains its own styles and transformations.
By default, styles such as <a href="#/p5/`fill`">`fill`()</a> and transformations such as <a href="#/p5/`rotate`">`rotate`()</a> are applied to all drawing that follows.
The ``push`()` and <a href="#/p5/`pop`">`pop`()</a> functions can limit the effect of styles and transformations to a specific group of shapes, images, and `text`.
For example, a group of shapes could be translated to follow the mouse without affecting the rest of the sketch: ```js // Begin the drawing group.
`push`(); // Translate the origin to the mouse's position.
`translate`(`mouseX`, `mouseY`); // Style the face.
noStroke(); `fill`('`green`'); // Draw the face.
`circle`(0, 0, 60); // Style the eyes.
`fill`('white'); // Draw the left eye.
`ellipse`(-20, -20, 30, 20); // Draw the right eye.
`ellipse`(20, -20, 30, 20); // End the drawing group.
`pop`(); // Draw a bug.
let x = `random`(0, 100); let y = `random`(0, 100); `text`('🦟', x, y); ``` In the code snippet above, the bug's position isn't affected by ``translate`(`mouseX`, `mouseY`)` because that transformation is contained between ``push`()` and <a href="#/p5/`pop`">`pop`()</a>.
The bug moves around the entire canvas as expected.
Note: ``push`()` and <a href="#/p5/`pop`">`pop`()</a> are always called as a pair.
Both functions are required to begin and end a drawing group.
``push`()` and <a href="#/p5/`pop`">`pop`()</a> can also be nested to create subgroups.
For example, the code snippet above could be changed to give more detail to the frog’s eyes: ```js // Begin the drawing group.
`push`(); // Translate the origin to the mouse's position.
`translate`(`mouseX`, `mouseY`); // Style the face.
noStroke(); `fill`('`green`'); // Draw a face.
`circle`(0, 0, 60); // Style the eyes.
`fill`('white'); // Draw the left eye.
`push`(); `translate`(-20, -20); `ellipse`(0, 0, 30, 20); `fill`('black'); `circle`(0, 0, 8); `pop`(); // Draw the right eye.
`push`(); `translate`(20, -20); `ellipse`(0, 0, 30, 20); `fill`('black'); `circle`(0, 0, 8); `pop`(); // End the drawing group.
`pop`(); // Draw a bug.
let x = `random`(0, 100); let y = `random`(0, 100); `text`('🦟', x, y); ``` In this version, the code to `draw` each eye is contained between its own ``push`()` and <a href="#/p5/`pop`">`pop`()</a> functions.
Doing so makes it easier to add details in the correct part of a drawing.
``push`()` and <a href="#/p5/`pop`">`pop`()</a> contain the effects of the following functions: - <a href="#/p5/`fill`">`fill`()</a> - <a href="#/p5/`noFill`">`noFill`()</a> - <a href="#/p5/noStroke">noStroke()</a> - <a href="#/p5/`stroke`">`stroke`()</a> - <a href="#/p5/tint">tint()</a> - <a href="#/p5/noTint">noTint()</a> - <a href="#/p5/strokeWeight">strokeWeight()</a> - <a href="#/p5/strokeCap">strokeCap()</a> - <a href="#/p5/strokeJoin">strokeJoin()</a> - <a href="#/p5/imageMode">imageMode()</a> - <a href="#/p5/rectMode">rectMode()</a> - <a href="#/p5/ellipseMode">ellipseMode()</a> - <a href="#/p5/`colorMode`">`colorMode`()</a> - <a href="#/p5/`textAlign`">`textAlign`()</a> - <a href="#/p5/`textFont`">`textFont`()</a> - <a href="#/p5/`textSize`">`textSize`()</a> - <a href="#/p5/textLeading">textLeading()</a> - <a href="#/p5/`applyMatrix`">`applyMatrix`()</a> - <a href="#/p5/`resetMatrix`">`resetMatrix`()</a> - <a href="#/p5/`rotate`">`rotate`()</a> - <a href="#/p5/`scale`">`scale`()</a> - <a href="#/p5/`shearX`">`shearX`()</a> - <a href="#/p5/`shearY`">`shearY`()</a> - <a href="#/p5/`translate`">`translate`()</a> In WebGL mode, ``push`()` and <a href="#/p5/`pop`">`pop`()</a> contain the effects of a few additional styles: - <a href="#/p5/setCamera">setCamera()</a> - <a href="#/p5/ambientLight">ambientLight()</a> - <a href="#/p5/directionalLight">directionalLight()</a> - <a href="#/p5/pointLight">pointLight()</a> <a href="#/p5/texture">texture()</a> - <a href="#/p5/specularMaterial">specularMaterial()</a> - <a href="#/p5/shininess">shininess()</a> - <a href="#/p5/normalMaterial">normalMaterial()</a> - <a href="#/p5/shader">shader()</a>

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Draw the left circle.
> circle(25, 50, 20);
>
> // Begin the drawing group.
> push();
>
> // Translate the origin to the center.
> translate(50, 50);
>
> // Style the circle.
> strokeWeight(5);
> stroke('royalblue');
> fill('orange');
>
> // Draw the circle.
> circle(0, 0, 20);
>
> // End the drawing group.
> pop();
>
> // Draw the right circle.
> circle(75, 50, 20);
>
> describe(
> 'Three circles drawn in a row on a gray background. The left and right circles are white with thin, black borders. The middle circle is orange with a thick, blue border.'
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
> // Slow the frame rate.
> frameRate(24);
>
> describe('A mosquito buzzes in front of a green frog. The frog follows the mouse as the user moves.');
> }
>
> function draw() {
> background(200);
>
> // Begin the drawing group.
> push();
>
> // Translate the origin to the mouse's position.
> translate(mouseX, mouseY);
>
> // Style the face.
> noStroke();
> fill('green');
>
> // Draw a face.
> circle(0, 0, 60);
>
> // Style the eyes.
> fill('white');
>
> // Draw the left eye.
> push();
> translate(-20, -20);
> ellipse(0, 0, 30, 20);
> fill('black');
> circle(0, 0, 8);
> pop();
>
> // Draw the right eye.
> push();
> translate(20, -20);
> ellipse(0, 0, 30, 20);
> fill('black');
> circle(0, 0, 8);
> pop();
>
> // End the drawing group.
> pop();
>
> // Draw a bug.
> let x = random(0, 100);
> let y = random(0, 100);
> text('🦟', x, y);
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
> describe(
> 'Two spheres drawn on a gray background. The sphere on the left is red and lit from the front. The sphere on the right is a blue wireframe.'
> );
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the red sphere.
> push();
> translate(-25, 0, 0);
> noStroke();
> directionalLight(255, 0, 0, 0, 0, -1);
> sphere(20);
> pop();
>
> // Draw the blue sphere.
> push();
> translate(25, 0, 0);
> strokeWeight(0.3);
> stroke(0, 0, 255);
> noFill();
> sphere(20);
> pop();
> }
> </code>
>
<

See also: ~
   |help p5-push| for detailed help on this symbol~

Source: ~
                ../temp/src/core/structure.js:544
~


p5-Structure_redraw() 📄 ⚡
|redraw|({Integer} [n] number of times to run <a href="#/p5/draw">draw()</a>. Defaults to 1.) ⚡ Function

Runs the code in <a href="#/p5/`draw`">`draw`()</a> once.
By default, <a href="#/p5/`draw`">`draw`()</a> tries to run 60 times per second.
Calling <a href="#/p5/`noLoop`">`noLoop`()</a> stops <a href="#/p5/`draw`">`draw`()</a> from repeating.
Calling ``redraw`()` will execute the code in the <a href="#/p5/`draw`">`draw`()</a> function a `set` number of times.
The parameter, `n`, is optional.
If a number is passed, as in ``redraw`(5)`, then the `draw` `loop` will run the given number of times.
By default, `n` is 1.

Parameters: ~
                🔢 `{Integer} [n] number of times to run <a href="#/p5/draw">draw()</a>. Defaults to 1.` (unknown)
~

Examples: >
>
> <code>
> // Double-click the canvas to move the circle.
>
> let x = 0;
>
> function setup() {
> createCanvas(100, 100);
>
> // Turn off the draw loop.
> noLoop();
>
> describe(
> 'A white half-circle on the left edge of a gray square. The circle moves a little to the right when the user double-clicks.'
> );
> }
>
> function draw() {
> background(200);
>
> // Draw the circle.
> circle(x, 50, 20);
>
> // Increment x.
> x += 5;
> }
>
> // Run the draw loop when the user double-clicks.
> function doubleClicked() {
> redraw();
> }
> </code>
> </div>
>
> <div>
> <code>
> // Double-click the canvas to move the circle.
>
> let x = 0;
>
> function setup() {
> createCanvas(100, 100);
>
> // Turn off the draw loop.
> noLoop();
>
> describe(
> 'A white half-circle on the left edge of a gray square. The circle hops to the right when the user double-clicks.'
> );
> }
>
> function draw() {
> background(200);
>
> // Draw the circle.
> circle(x, 50, 20);
>
> // Increment x.
> x += 5;
> }
>
> // Run the draw loop three times when the user double-clicks.
> function doubleClicked() {
> redraw(3);
> }
> </code>
>
<

See also: ~
   |help p5-redraw| for detailed help on this symbol~

Source: ~
                ../temp/src/core/structure.js:923
~


p5-Structure_remove() 📄 ⚡
|remove|() ⚡ Function

Removes the sketch from the web page.
Calling `remove()` stops the `draw` `loop` and removes any HTML elements created by the sketch, including the canvas.
A new sketch can be created by using the <a href="#/p5/p5">p5()</a> constructor, as in `new p5()`.

Examples: >
>
> <code>
> // Double-click to remove the canvas.
>
> function setup() {
> createCanvas(100, 100);
>
> describe(
> 'A white circle on a gray background. The circle follows the mouse as the user moves. The sketch disappears when the user double-clicks.'
> );
> }
>
> function draw() {
> // Paint the background repeatedly.
> background(200);
>
> // Draw circles repeatedly.
> circle(mouseX, mouseY, 40);
> }
>
> // Remove the sketch when the user double-clicks.
> function doubleClicked() {
> remove();
> }
> </code>
>
<

See also: ~
   |help p5-remove| for detailed help on this symbol~

Source: ~
                ../temp/src/core/main.js:597
~


PROPERTIES                                                   *p5-Structure-properties*

p5-Structure_disableFriendlyErrors() 📄 🔧
|disableFriendlyErrors| ⚡ Function

Turns off the parts of the Friendly Error System (FES) that impact performance.
The <a href="https://github.com/processing/p5.js/blob/main/contributor_docs/friendly_error_system.md" target="_blank">FES</a> can cause sketches to `draw` slowly because it does extra work behind the scenes.
For example, the FES checks the arguments passed to functions, which takes time to process.
Disabling the FES can significantly improve performance by turning off these checks.

Examples: >
>
> <code>
> // Disable the FES.
> p5.disableFriendlyErrors = true;
>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // The circle() function requires three arguments. The
> // next line would normally display a friendly error that
> // points this out. Instead, nothing happens and it fails
> // silently.
> circle(50, 50);
>
> describe('A gray square.');
> }
> </code>
>
<

See also: ~
   |help p5-disableFriendlyErrors| for detailed help on this symbol~

Source: ~
                ../temp/src/core/main.js:905
~


VARIABLES                                                   *p5-Structure-variables*

p5-Structure_style() 📄 📌
|style| ⚡ Function

Ends a drawing group that contains its own styles and transformations.
By default, styles such as <a href="#/p5/`fill`">`fill`()</a> and transformations such as <a href="#/p5/`rotate`">`rotate`()</a> are applied to all drawing that follows.
The <a href="#/p5/`push`">`push`()</a> and ``pop`()` functions can limit the effect of styles and transformations to a specific group of shapes, images, and `text`.
For example, a group of shapes could be translated to follow the mouse without affecting the rest of the sketch: ```js // Begin the drawing group.
`push`(); // Translate the origin to the mouse's position.
`translate`(`mouseX`, `mouseY`); // Style the face.
noStroke(); `fill`('`green`'); // Draw the face.
`circle`(0, 0, 60); // Style the eyes.
`fill`('white'); // Draw the left eye.
`ellipse`(-20, -20, 30, 20); // Draw the right eye.
`ellipse`(20, -20, 30, 20); // End the drawing group.
`pop`(); // Draw a bug.
let x = `random`(0, 100); let y = `random`(0, 100); `text`('🦟', x, y); ``` In the code snippet above, the bug's position isn't affected by ``translate`(`mouseX`, `mouseY`)` because that transformation is contained between <a href="#/p5/`push`">`push`()</a> and ``pop`()`.
The bug moves around the entire canvas as expected.
Note: <a href="#/p5/`push`">`push`()</a> and ``pop`()` are always called as a pair.
Both functions are required to begin and end a drawing group.
<a href="#/p5/`push`">`push`()</a> and ``pop`()` can also be nested to create subgroups.
For example, the code snippet above could be changed to give more detail to the frog’s eyes: ```js // Begin the drawing group.
`push`(); // Translate the origin to the mouse's position.
`translate`(`mouseX`, `mouseY`); // Style the face.
noStroke(); `fill`('`green`'); // Draw a face.
`circle`(0, 0, 60); // Style the eyes.
`fill`('white'); // Draw the left eye.
`push`(); `translate`(-20, -20); `ellipse`(0, 0, 30, 20); `fill`('black'); `circle`(0, 0, 8); `pop`(); // Draw the right eye.
`push`(); `translate`(20, -20); `ellipse`(0, 0, 30, 20); `fill`('black'); `circle`(0, 0, 8); `pop`(); // End the drawing group.
`pop`(); // Draw a bug.
let x = `random`(0, 100); let y = `random`(0, 100); `text`('🦟', x, y); ``` In this version, the code to `draw` each eye is contained between its own <a href="#/p5/`push`">`push`()</a> and ``pop`()` functions.
Doing so makes it easier to add details in the correct part of a drawing.
<a href="#/p5/`push`">`push`()</a> and ``pop`()` contain the effects of the following functions: - <a href="#/p5/`fill`">`fill`()</a> - <a href="#/p5/`noFill`">`noFill`()</a> - <a href="#/p5/noStroke">noStroke()</a> - <a href="#/p5/`stroke`">`stroke`()</a> - <a href="#/p5/tint">tint()</a> - <a href="#/p5/noTint">noTint()</a> - <a href="#/p5/strokeWeight">strokeWeight()</a> - <a href="#/p5/strokeCap">strokeCap()</a> - <a href="#/p5/strokeJoin">strokeJoin()</a> - <a href="#/p5/imageMode">imageMode()</a> - <a href="#/p5/rectMode">rectMode()</a> - <a href="#/p5/ellipseMode">ellipseMode()</a> - <a href="#/p5/`colorMode`">`colorMode`()</a> - <a href="#/p5/`textAlign`">`textAlign`()</a> - <a href="#/p5/`textFont`">`textFont`()</a> - <a href="#/p5/`textSize`">`textSize`()</a> - <a href="#/p5/textLeading">textLeading()</a> - <a href="#/p5/`applyMatrix`">`applyMatrix`()</a> - <a href="#/p5/`resetMatrix`">`resetMatrix`()</a> - <a href="#/p5/`rotate`">`rotate`()</a> - <a href="#/p5/`scale`">`scale`()</a> - <a href="#/p5/`shearX`">`shearX`()</a> - <a href="#/p5/`shearY`">`shearY`()</a> - <a href="#/p5/`translate`">`translate`()</a> In WebGL mode, <a href="#/p5/`push`">`push`()</a> and ``pop`()` contain the effects of a few additional styles: - <a href="#/p5/setCamera">setCamera()</a> - <a href="#/p5/ambientLight">ambientLight()</a> - <a href="#/p5/directionalLight">directionalLight()</a> - <a href="#/p5/pointLight">pointLight()</a> <a href="#/p5/texture">texture()</a> - <a href="#/p5/specularMaterial">specularMaterial()</a> - <a href="#/p5/shininess">shininess()</a> - <a href="#/p5/normalMaterial">normalMaterial()</a> - <a href="#/p5/shader">shader()</a>

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Draw the left circle.
> circle(25, 50, 20);
>
> // Begin the drawing group.
> push();
>
> // Translate the origin to the center.
> translate(50, 50);
>
> // Style the circle.
> strokeWeight(5);
> stroke('royalblue');
> fill('orange');
>
> // Draw the circle.
> circle(0, 0, 20);
>
> // End the drawing group.
> pop();
>
> // Draw the right circle.
> circle(75, 50, 20);
>
> describe(
> 'Three circles drawn in a row on a gray background. The left and right circles are white with thin, black borders. The middle circle is orange with a thick, blue border.'
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
> // Slow the frame rate.
> frameRate(24);
>
> describe('A mosquito buzzes in front of a green frog. The frog follows the mouse as the user moves.');
> }
>
> function draw() {
> background(200);
>
> // Begin the drawing group.
> push();
>
> // Translate the origin to the mouse's position.
> translate(mouseX, mouseY);
>
> // Style the face.
> noStroke();
> fill('green');
>
> // Draw a face.
> circle(0, 0, 60);
>
> // Style the eyes.
> fill('white');
>
> // Draw the left eye.
> push();
> translate(-20, -20);
> ellipse(0, 0, 30, 20);
> fill('black');
> circle(0, 0, 8);
> pop();
>
> // Draw the right eye.
> push();
> translate(20, -20);
> ellipse(0, 0, 30, 20);
> fill('black');
> circle(0, 0, 8);
> pop();
>
> // End the drawing group.
> pop();
>
> // Draw a bug.
> let x = random(0, 100);
> let y = random(0, 100);
> text('🦟', x, y);
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
> describe(
> 'Two spheres drawn on a gray background. The sphere on the left is red and lit from the front. The sphere on the right is a blue wireframe.'
> );
> }
>
> function draw() {
> background(200);
>
> // Enable orbiting with the mouse.
> orbitControl();
>
> // Draw the red sphere.
> push();
> translate(-25, 0, 0);
> noStroke();
> directionalLight(255, 0, 0, 0, 0, -1);
> sphere(20);
> pop();
>
> // Draw the blue sphere.
> push();
> translate(25, 0, 0);
> strokeWeight(0.3);
> stroke(0, 0, 255);
> noFill();
> sphere(20);
> pop();
> }
> </code>
>
<

See also: ~
   |help p5-style| for detailed help on this symbol~

Source: ~
                ../temp/src/core/structure.js:829
~




==============================================================================
Generated by p5.js Documentation Automation
See: https://github.com/prjctimg/automata
Last updated: 2026-02-03
📄 End of Structure documentation 📄
==============================================================================