# Structure Module

This module contains 9 symbols from p5.js.

## disableFriendlyErrors

**Type:** Property

Turns off the parts of the Friendly Error System (FES) that impact performance. The <a href="https://github.com/processing/p5.js/blob/main/contributor_docs/friendly_error_system.md" target="_blank">FES</a> can cause sketches to draw slowly because it does extra work behind the scenes. For example, the FES checks the arguments passed to functions, which takes time to process. Disabling the FES can significantly improve performance by turning off these checks.

---

## isLooping

**Type:** Function

Returns `true` if the draw loop is running and `false` if not. By default, <a href="#/p5/draw">draw()</a> tries to run 60 times per second. Calling <a href="#/p5/noLoop">noLoop()</a> stops <a href="#/p5/draw">draw()</a> from repeating. The draw loop can be restarted by calling <a href="#/p5/loop">loop()</a>. The `isLooping()` function can be used to check whether a sketch is looping, as in `isLooping() === true`.

### Returns

any - No description

---

## loop

**Type:** Function

Resumes the draw loop after <a href="#/p5/noLoop">noLoop()</a> has been called. By default, <a href="#/p5/draw">draw()</a> tries to run 60 times per second. Calling <a href="#/p5/noLoop">noLoop()</a> stops <a href="#/p5/draw">draw()</a> from repeating. The draw loop can be restarted by calling `loop()`. The <a href="#/p5/isLooping">isLooping()</a> function can be used to check whether a sketch is looping, as in `isLooping() === true`.

---

## noLoop

**Type:** Function

Stops the code in <a href="#/p5/draw">draw()</a> from running repeatedly. By default, <a href="#/p5/draw">draw()</a> tries to run 60 times per second. Calling `noLoop()` stops <a href="#/p5/draw">draw()</a> from repeating. The draw loop can be restarted by calling <a href="#/p5/loop">loop()</a>. <a href="#/p5/draw">draw()</a> can be run once by calling <a href="#/p5/redraw">redraw()</a>. The <a href="#/p5/isLooping">isLooping()</a> function can be used to check whether a sketch is looping, as in `isLooping() === true`.

---

## p5

**Type:** Class

This is the p5 instance constructor. A p5 instance holds all the properties and methods related to a p5 sketch.  It expects an incoming sketch closure and it can also take an optional node parameter for attaching the generated p5 canvas to a node.  The sketch closure takes the newly created p5 instance as its sole argument and may optionally set <a href="#/p5/preload">preload()</a>, <a href="#/p5/setup">setup()</a>, and/or <a href="#/p5/draw">draw()</a> properties on it for running a sketch. A p5 sketch can run in "global" or "instance" mode: "global"   - all properties and methods are attached to the window "instance" - all properties and methods are bound to this p5 object

### Parameters

- `sketch`: function(p5) - a closure that can set optional <a href="#/p5/preload">preload()</a>,
- `{HTMLElement}        [node] element to attach canvas to`: unknown - No description

---

## pop

**Type:** Function

Ends a drawing group that contains its own styles and transformations. By default, styles such as <a href="#/p5/fill">fill()</a> and transformations such as <a href="#/p5/rotate">rotate()</a> are applied to all drawing that follows. The <a href="#/p5/push">push()</a> and `pop()` functions can limit the effect of styles and transformations to a specific group of shapes, images, and text. For example, a group of shapes could be translated to follow the mouse without affecting the rest of the sketch: ```js // Begin the drawing group. push(); // Translate the origin to the mouse's position. translate(mouseX, mouseY); // Style the face. noStroke(); fill('green'); // Draw the face. circle(0, 0, 60); // Style the eyes. fill('white'); // Draw the left eye. ellipse(-20, -20, 30, 20); // Draw the right eye. ellipse(20, -20, 30, 20); // End the drawing group. pop(); // Draw a bug. let x = random(0, 100); let y = random(0, 100); text('🦟', x, y); ``` In the code snippet above, the bug's position isn't affected by `translate(mouseX, mouseY)` because that transformation is contained between <a href="#/p5/push">push()</a> and `pop()`. The bug moves around the entire canvas as expected. Note: <a href="#/p5/push">push()</a> and `pop()` are always called as a pair. Both functions are required to begin and end a drawing group. <a href="#/p5/push">push()</a> and `pop()` can also be nested to create subgroups. For example, the code snippet above could be changed to give more detail to the frog’s eyes: ```js // Begin the drawing group. push(); // Translate the origin to the mouse's position. translate(mouseX, mouseY); // Style the face. noStroke(); fill('green'); // Draw a face. circle(0, 0, 60); // Style the eyes. fill('white'); // Draw the left eye. push(); translate(-20, -20); ellipse(0, 0, 30, 20); fill('black'); circle(0, 0, 8); pop(); // Draw the right eye. push(); translate(20, -20); ellipse(0, 0, 30, 20); fill('black'); circle(0, 0, 8); pop(); // End the drawing group. pop(); // Draw a bug. let x = random(0, 100); let y = random(0, 100); text('🦟', x, y); ``` In this version, the code to draw each eye is contained between its own <a href="#/p5/push">push()</a> and `pop()` functions. Doing so makes it easier to add details in the correct part of a drawing. <a href="#/p5/push">push()</a> and `pop()` contain the effects of the following functions: - <a href="#/p5/fill">fill()</a> - <a href="#/p5/noFill">noFill()</a> - <a href="#/p5/noStroke">noStroke()</a> - <a href="#/p5/stroke">stroke()</a> - <a href="#/p5/tint">tint()</a> - <a href="#/p5/noTint">noTint()</a> - <a href="#/p5/strokeWeight">strokeWeight()</a> - <a href="#/p5/strokeCap">strokeCap()</a> - <a href="#/p5/strokeJoin">strokeJoin()</a> - <a href="#/p5/imageMode">imageMode()</a> - <a href="#/p5/rectMode">rectMode()</a> - <a href="#/p5/ellipseMode">ellipseMode()</a> - <a href="#/p5/colorMode">colorMode()</a> - <a href="#/p5/textAlign">textAlign()</a> - <a href="#/p5/textFont">textFont()</a> - <a href="#/p5/textSize">textSize()</a> - <a href="#/p5/textLeading">textLeading()</a> - <a href="#/p5/applyMatrix">applyMatrix()</a> - <a href="#/p5/resetMatrix">resetMatrix()</a> - <a href="#/p5/rotate">rotate()</a> - <a href="#/p5/scale">scale()</a> - <a href="#/p5/shearX">shearX()</a> - <a href="#/p5/shearY">shearY()</a> - <a href="#/p5/translate">translate()</a> In WebGL mode, <a href="#/p5/push">push()</a> and `pop()` contain the effects of a few additional styles: - <a href="#/p5/setCamera">setCamera()</a> - <a href="#/p5/ambientLight">ambientLight()</a> - <a href="#/p5/directionalLight">directionalLight()</a> - <a href="#/p5/pointLight">pointLight()</a> <a href="#/p5/texture">texture()</a> - <a href="#/p5/specularMaterial">specularMaterial()</a> - <a href="#/p5/shininess">shininess()</a> - <a href="#/p5/normalMaterial">normalMaterial()</a> - <a href="#/p5/shader">shader()</a>

---

## push

**Type:** Function

Begins a drawing group that contains its own styles and transformations. By default, styles such as <a href="#/p5/fill">fill()</a> and transformations such as <a href="#/p5/rotate">rotate()</a> are applied to all drawing that follows. The `push()` and <a href="#/p5/pop">pop()</a> functions can limit the effect of styles and transformations to a specific group of shapes, images, and text. For example, a group of shapes could be translated to follow the mouse without affecting the rest of the sketch: ```js // Begin the drawing group. push(); // Translate the origin to the mouse's position. translate(mouseX, mouseY); // Style the face. noStroke(); fill('green'); // Draw the face. circle(0, 0, 60); // Style the eyes. fill('white'); // Draw the left eye. ellipse(-20, -20, 30, 20); // Draw the right eye. ellipse(20, -20, 30, 20); // End the drawing group. pop(); // Draw a bug. let x = random(0, 100); let y = random(0, 100); text('🦟', x, y); ``` In the code snippet above, the bug's position isn't affected by `translate(mouseX, mouseY)` because that transformation is contained between `push()` and <a href="#/p5/pop">pop()</a>. The bug moves around the entire canvas as expected. Note: `push()` and <a href="#/p5/pop">pop()</a> are always called as a pair. Both functions are required to begin and end a drawing group. `push()` and <a href="#/p5/pop">pop()</a> can also be nested to create subgroups. For example, the code snippet above could be changed to give more detail to the frog’s eyes: ```js // Begin the drawing group. push(); // Translate the origin to the mouse's position. translate(mouseX, mouseY); // Style the face. noStroke(); fill('green'); // Draw a face. circle(0, 0, 60); // Style the eyes. fill('white'); // Draw the left eye. push(); translate(-20, -20); ellipse(0, 0, 30, 20); fill('black'); circle(0, 0, 8); pop(); // Draw the right eye. push(); translate(20, -20); ellipse(0, 0, 30, 20); fill('black'); circle(0, 0, 8); pop(); // End the drawing group. pop(); // Draw a bug. let x = random(0, 100); let y = random(0, 100); text('🦟', x, y); ``` In this version, the code to draw each eye is contained between its own `push()` and <a href="#/p5/pop">pop()</a> functions. Doing so makes it easier to add details in the correct part of a drawing. `push()` and <a href="#/p5/pop">pop()</a> contain the effects of the following functions: - <a href="#/p5/fill">fill()</a> - <a href="#/p5/noFill">noFill()</a> - <a href="#/p5/noStroke">noStroke()</a> - <a href="#/p5/stroke">stroke()</a> - <a href="#/p5/tint">tint()</a> - <a href="#/p5/noTint">noTint()</a> - <a href="#/p5/strokeWeight">strokeWeight()</a> - <a href="#/p5/strokeCap">strokeCap()</a> - <a href="#/p5/strokeJoin">strokeJoin()</a> - <a href="#/p5/imageMode">imageMode()</a> - <a href="#/p5/rectMode">rectMode()</a> - <a href="#/p5/ellipseMode">ellipseMode()</a> - <a href="#/p5/colorMode">colorMode()</a> - <a href="#/p5/textAlign">textAlign()</a> - <a href="#/p5/textFont">textFont()</a> - <a href="#/p5/textSize">textSize()</a> - <a href="#/p5/textLeading">textLeading()</a> - <a href="#/p5/applyMatrix">applyMatrix()</a> - <a href="#/p5/resetMatrix">resetMatrix()</a> - <a href="#/p5/rotate">rotate()</a> - <a href="#/p5/scale">scale()</a> - <a href="#/p5/shearX">shearX()</a> - <a href="#/p5/shearY">shearY()</a> - <a href="#/p5/translate">translate()</a> In WebGL mode, `push()` and <a href="#/p5/pop">pop()</a> contain the effects of a few additional styles: - <a href="#/p5/setCamera">setCamera()</a> - <a href="#/p5/ambientLight">ambientLight()</a> - <a href="#/p5/directionalLight">directionalLight()</a> - <a href="#/p5/pointLight">pointLight()</a> <a href="#/p5/texture">texture()</a> - <a href="#/p5/specularMaterial">specularMaterial()</a> - <a href="#/p5/shininess">shininess()</a> - <a href="#/p5/normalMaterial">normalMaterial()</a> - <a href="#/p5/shader">shader()</a>

---

## redraw

**Type:** Function

Runs the code in <a href="#/p5/draw">draw()</a> once. By default, <a href="#/p5/draw">draw()</a> tries to run 60 times per second. Calling <a href="#/p5/noLoop">noLoop()</a> stops <a href="#/p5/draw">draw()</a> from repeating. Calling `redraw()` will execute the code in the <a href="#/p5/draw">draw()</a> function a set number of times. The parameter, `n`, is optional. If a number is passed, as in `redraw(5)`, then the draw loop will run the given number of times. By default, `n` is 1.

### Parameters

- `{Integer} [n] number of times to run <a href="#/p5/draw">draw()</a>. Defaults to 1.`: unknown - No description

---

## remove

**Type:** Function

Removes the sketch from the web page. Calling `remove()` stops the draw loop and removes any HTML elements created by the sketch, including the canvas. A new sketch can be created by using the <a href="#/p5/p5">p5()</a> constructor, as in `new p5()`.

---

