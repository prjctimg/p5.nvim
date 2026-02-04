📄 *p5.Environment*📄
Environment module functions and properties

==============================================================================
Tags p5.Environment Environment module functions and properties
==============================================================================



CONTENTS                                                           *${this.getCurrentModuleName()}-contents*

🔍 NAVIGATION:~
   Use | to jump to sections, :help p5-[symbol] to jump to symbols~

🏛️ CLASSES:
  |err                      |
  |FetchResources           |

⚡ FUNCTIONS:
  |anonymous                |
  |cursor                   |
  |defineMisusedAtTopLevelCode|
  |describe                 |
  |describeElement          |
  |displayDensity           |
  |ErrorStackParser$$parse  |
  |frameRate                |
  |fullscreen               |
  |getTargetFrameRate       |
  |getURL                   |
  |getURLParams             |
  |getURLPath               |
  |gridOutput               |
  |noCursor                 |
  |pixelDensity             |
  |print                    |
  |textOutput               |
  |ValidationError          |

🔧 PROPERTIES:
  |deltaTime                |
  |displayHeight            |
  |displayWidth             |
  |focused                  |
  |frameCount               |
  |getFrameRate             |
  |height                   |
  |setFrameRate             |
  |webglVersion             |
  |width                    |
  |windowHeight             |
  |windowWidth              |

📌 VARIABLES:
  |addType                  |
  |availableTranslatorLanguages|
  |buildArgTypeCache        |
  |checkForConstsAndFuncs   |
  |checkForUserDefinedFunctions|
  |codeToLines              |
  |computeEditDistance      |
  |currentTranslatorLanguage|
  |extractFuncVariables     |
  |extractVariables         |
  |fesCodeReader            |
  |fesErrorMonitor          |
  |formats                  |
  |getOverloadErrors        |
  |globalConstFuncCheck     |
  |handleMisspelling        |
  |helpForMisusedAtTopLevelCode|
  |i                        |
  |i18init                  |
  |initialize               |
  |isArray                  |
  |isNumber                 |
  |key                      |
  |l1                       |
  |log                      |
  |lookupParamDoc           |
  |mapToReference           |
  |matches                  |
  |message                  |
  |minScore                 |
  |msgWithReference         |
  |printFriendlyStack       |
  |processStack             |
  |re                       |
  |removeMultilineComments  |
  |score                    |
  |scoreOverload            |
  |setTranslatorLanguage    |
  |start                    |
  |translator               |
  |type                     |
  |uniqueNamesFound         |



🔗 RELATED SYMBOLS:~
   See |p5| for complete p5.js API reference~



⚡ QUICK REFERENCE:~
   :help p5-[symbolname] - Jump directly to any function~



CLASSES                                                   *p5-Environment-classes*

p5-Environment_err() 📄 🏛️
|err|() 🏛️ Class

a custom error type, used by the mocha tests when expecting validation errors

See also: ~
   |help p5-err| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:518
~


p5-Environment_FetchResources() 📄 🏛️
|FetchResources|() 🏛️ Class

This is our i18next "backend" plugin.
It tries to fetch languages from a CDN.

See also: ~
   |help p5-FetchResources| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:36
~


FUNCTIONS                                                   *p5-Environment-functions*

p5-Environment_anonymous() 📄 ⚡
|anonymous|() ⚡ Function

Sets the current language for translation Returns a promise that resolved when loading is finished, or rejects if it fails.

See also: ~
   |help p5-anonymous| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:197
~


p5-Environment_cursor() 📄 ⚡
|cursor|() ⚡ Function

Hides the cursor from view.

Examples: >
>
> <code>
> function setup() {
> // Hide the cursor.
> noCursor();
> }
>
> function draw() {
> background(200);
>
> circle(mouseX, mouseY, 10);
>
> describe('A white circle on a gray background. The circle follows the mouse as it moves. The cursor is hidden.');
> }
> </code>
>
<

See also: ~
   |help p5-cursor| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:505
~


p5-Environment_defineMisusedAtTopLevelCode() 📄 ⚡
|defineMisusedAtTopLevelCode|() ⚡ Function

A helper function for populating misusedAtTopLevel list.

See also: ~
   |help p5-defineMisusedAtTopLevelCode| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:973
~


p5-Environment_describe() 📄 ⚡
|describe|(text, {Constant} [display] either LABEL or FALLBACK.) ⚡ Function

Creates a screen reader-accessible description of the canvas.
The first parameter, ``text``, is the description of the canvas.
The second parameter, `display`, is optional.
It determines how the description is displayed.
If `LABEL` is passed, as in `describe('A description.', LABEL)`, the description will be visible in a div element next to the canvas.
If `FALLBACK` is passed, as in `describe('A description.', FALLBACK)`, the description will only be visible to screen readers.
This is the default mode.
Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible.

Parameters: ~
                📝 `text` (String) - description of the canvas.
                🔢 `{Constant} [display] either LABEL or FALLBACK.` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> background('pink');
>
> // Draw a heart.
> fill('red');
> noStroke();
> circle(67, 67, 20);
> circle(83, 67, 20);
> triangle(91, 73, 75, 95, 59, 73);
>
> // Add a general description of the canvas.
> describe('A pink square with a red heart in the bottom-right corner.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> background('pink');
>
> // Draw a heart.
> fill('red');
> noStroke();
> circle(67, 67, 20);
> circle(83, 67, 20);
> triangle(91, 73, 75, 95, 59, 73);
>
> // Add a general description of the canvas
> // and display it for debugging.
> describe('A pink square with a red heart in the bottom-right corner.', LABEL);
> }
> </code>
> </div>
>
> <div>
> <code>
> function draw() {
> background(200);
>
> // The expression
> // frameCount % 100
> // causes x to increase from 0
> // to 99, then restart from 0.
> let x = frameCount % 100;
>
> // Draw the circle.
> fill(0, 255, 0);
> circle(x, 50, 40);
>
> // Add a general description of the canvas.
> describe(`A green circle at (${x}, 50) moves from left to right on a gray square.`);
> }
> </code>
> </div>
>
> <div>
> <code>
> function draw() {
> background(200);
>
> // The expression
> // frameCount % 100
> // causes x to increase from 0
> // to 99, then restart from 0.
> let x = frameCount % 100;
>
> // Draw the circle.
> fill(0, 255, 0);
> circle(x, 50, 40);
>
> // Add a general description of the canvas
> // and display it for debugging.
> describe(`A green circle at (${x}, 50) moves from left to right on a gray square.`, LABEL);
> }
> </code>
>
<

See also: ~
   |help p5-describe| for detailed help on this symbol~

Source: ~
                ../temp/src/accessibility/describe.js:120
~


p5-Environment_describeElement() 📄 ⚡
|describeElement|(name, text, {Constant} [display] either LABEL or FALLBACK.) ⚡ Function

Creates a screen reader-accessible description of elements in the canvas.
Elements are shapes or groups of shapes that create meaning together.
For example, a few overlapping circles could make an "eye" element.
The first parameter, `name`, is the name of the element.
The second parameter, ``text``, is the description of the element.
The third parameter, `display`, is optional.
It determines how the description is displayed.
If `LABEL` is passed, as in `describe('A description.', LABEL)`, the description will be visible in a div element next to the canvas.
Using `LABEL` creates unhelpful duplicates for screen readers.
Only use `LABEL` during development.
If `FALLBACK` is passed, as in `describe('A description.', FALLBACK)`, the description will only be visible to screen readers.
This is the default mode.
Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible.

Parameters: ~
                📝 `name` (String) - name of the element.
                📝 `text` (String) - description of the element.
                🔢 `{Constant} [display] either LABEL or FALLBACK.` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> background('pink');
>
> // Describe the first element
> // and draw it.
> describeElement('Circle', 'A yellow circle in the top-left corner.');
> noStroke();
> fill('yellow');
> circle(25, 25, 40);
>
> // Describe the second element
> // and draw it.
> describeElement('Heart', 'A red heart in the bottom-right corner.');
> fill('red');
> circle(66.6, 66.6, 20);
> circle(83.2, 66.6, 20);
> triangle(91.2, 72.6, 75, 95, 58.6, 72.6);
>
> // Add a general description of the canvas.
> describe('A red heart and yellow circle over a pink background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> background('pink');
>
> // Describe the first element
> // and draw it. Display the
> // description for debugging.
> describeElement('Circle', 'A yellow circle in the top-left corner.', LABEL);
> noStroke();
> fill('yellow');
> circle(25, 25, 40);
>
> // Describe the second element
> // and draw it. Display the
> // description for debugging.
> describeElement('Heart', 'A red heart in the bottom-right corner.', LABEL);
> fill('red');
> circle(66.6, 66.6, 20);
> circle(83.2, 66.6, 20);
> triangle(91.2, 72.6, 75, 95, 58.6, 72.6);
>
> // Add a general description of the canvas.
> describe('A red heart and yellow circle over a pink background.');
> }
> </code>
>
<

See also: ~
   |help p5-describeElement| for detailed help on this symbol~

Source: ~
                ../temp/src/accessibility/describe.js:246
~


p5-Environment_displayDensity() 📄 ⚡
|displayDensity|() ⚡ Function

Returns the display's current pixel density.

Returns: ~
                🔢 Returns undefined
~

Examples: >
>
> <code>
> function setup() {
> // Set the pixel density to 1.
> pixelDensity(1);
>
> // Create a canvas and draw
> // a circle.
> createCanvas(100, 100);
> background(200);
> circle(50, 50, 70);
>
> describe('A fuzzy white circle drawn on a gray background. The circle becomes sharper when the mouse is pressed.');
> }
>
> function mousePressed() {
> // Get the current display density.
> let d = displayDensity();
>
> // Use the display density to set
> // the sketch's pixel density.
> pixelDensity(d);
>
> // Paint the background and
> // draw a circle.
> background(200);
> circle(50, 50, 70);
> }
> </code>
>
<

See also: ~
   |help p5-displayDensity| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:1115
~


p5-Environment_ErrorStackParser$$parse() 📄 ⚡
|ErrorStackParser$$parse|(error) ⚡ Function

Given an Error object, extract the most information from it.

Parameters: ~
                🔢 `error` (Error) - object
~

Returns: ~
                📚 Returns Array: of stack frames
~

See also: ~
   |help p5-ErrorStackParser$$parse| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/stacktrace.js:38
~


p5-Environment_frameRate() 📄 ⚡
|frameRate|() ⚡ Function

Returns: ~
                🔢 Returns Number: current frame rate.
~

See also: ~
   |help p5-frameRate| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:408
~


p5-Environment_fullscreen() 📄 ⚡
|fullscreen|({Boolean} [val] whether the sketch should be in fullscreen mode.) ⚡ Function

Toggles full-screen mode or returns the current mode.
Calling ``fullscreen`(true)` makes the sketch full-screen.
Calling ``fullscreen`(false)` makes the sketch its original size.
Calling ``fullscreen`()` without an argument returns `true` if the sketch is in full-screen mode and `false` if not.
Note: Due to browser restrictions, ``fullscreen`()` can only be called with user input such as a mouse press.

Parameters: ~
                🔢 `{Boolean} [val] whether the sketch should be in fullscreen mode.` (unknown)
~

Returns: ~
                ☑️ Returns Boolean: current fullscreen state.
~

Examples: >
>
> <code>
> function setup() {
> background(200);
>
> describe('A gray canvas that switches between default and full-screen display when clicked.');
> }
>
> // If the mouse is pressed,
> // toggle full-screen mode.
> function mousePressed() {
> if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
> let fs = fullscreen();
> fullscreen(!fs);
> }
> }
> </code>
>
<

See also: ~
   |help p5-fullscreen| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:985
~


p5-Environment_getTargetFrameRate() 📄 ⚡
|getTargetFrameRate|() ⚡ Function

Returns the target frame rate.
The value is either the system frame rate or the last value passed to <a href="#/p5/`frameRate`">`frameRate`()</a>.

Returns: ~
                🔢 Returns Number: _targetFrameRate
~

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> describe('The number 20 written in black on a gray background.');
> }
>
> function draw() {
> background(200);
>
> // Set the frame rate to 20.
> frameRate(20);
>
> // Get the target frame rate and
> // display it.
> let fps = getTargetFrameRate();
> text(fps, 43, 54);
> }
> </code>
>
<

See also: ~
   |help p5-getTargetFrameRate| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:478
~


p5-Environment_getURL() 📄 ⚡
|getURL|() ⚡ Function

Returns the sketch's current <a href="https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL" target="_blank">URL</a> as a `String`.

Returns: ~
                📝 Returns String: url
~

Examples: >
>
> <code>
> function setup() {
> background(200);
>
> // Get the sketch's URL
> // and display it.
> let url = getURL();
> textWrap(CHAR);
> text(url, 0, 40, 100);
>
> describe('The URL "https://p5js.org/reference/p5/getURL" written in black on a gray background.');
> }
> </code>
>
<

See also: ~
   |help p5-getURL| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:1173
~


p5-Environment_getURLParams() 📄 ⚡
|getURLParams|() ⚡ Function

Returns the current <a href="https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL#parameters" target="_blank">URL parameters</a> in an `Object`.
For example, calling `getURLParams()` in a sketch hosted at the URL `https://p5js.org?year=2014&month=May&day=15` returns `{ year: 2014, month: 'May', day: 15 }`.

Returns: ~
                📦 Returns Object: URL params
~

Examples: >
>
> <code>
> // Imagine this sketch is hosted at the following URL:
> // https://p5js.org?year=2014&month=May&day=15
>
> function setup() {
> background(200);
>
> // Get the sketch's URL
> // parameters and display
> // them.
> let params = getURLParams();
> text(params.day, 10, 20);
> text(params.month, 10, 40);
> text(params.year, 10, 60);
>
> describe('The text "15", "May", and "2014" written in black on separate lines.');
> }
> </code>
>
<

See also: ~
   |help p5-getURLParams| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:1244
~


p5-Environment_getURLPath() 📄 ⚡
|getURLPath|() ⚡ Function

Returns the current <a href="https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL#path_to_resource" target="_blank">URL</a> path as an `Array` of `String`s.
For example, consider a sketch hosted at the URL `https://example.com/sketchbook`.
Calling `getURLPath()` returns `['sketchbook']`.
For a sketch hosted at the URL `https://example.com/sketchbook/monday`, `getURLPath()` returns `['sketchbook', 'monday']`.

Returns: ~
                🔢 Returns String[]: path components.
~

Examples: >
>
> <code>
> function setup() {
> background(200);
>
> // Get the sketch's URL path
> // and display the first
> // part.
> let path = getURLPath();
> text(path[0], 25, 54);
>
> describe('The word "reference" written in black on a gray background.');
> }
> </code>
>
<

See also: ~
   |help p5-getURLPath| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:1205
~


p5-Environment_gridOutput() 📄 ⚡
|gridOutput|({Constant} [display] either FALLBACK or LABEL.) ⚡ Function

Creates a screen reader-accessible description of shapes on the canvas.
`gridOutput()` adds a general description, table of shapes, and list of shapes to the web page.
The general description includes the canvas size, canvas `color`, and number of shapes.
For example, `gray canvas, 100 by 100 `pixels`, contains 2 shapes: 1 `circle` 1 square`.
`gridOutput()` uses its table of shapes as a grid.
Each shape in the grid is placed in a cell whose row and column correspond to the shape's location on the canvas.
The grid cells describe the `color` and type of shape at that location.
For example, ``red` `circle``.
These descriptions can be selected individually to `get` more details.
This is different from <a href="#/p5/textOutput">textOutput()</a>, which uses its table as a list.
A list of shapes follows the table.
The list describes the `color`, type, location, and area of each shape.
For example, ``red` `circle`, location = middle, area = 3 %`.
The `display` parameter is optional.
It determines how the description is displayed.
If `LABEL` is passed, as in `gridOutput(LABEL)`, the description will be visible in a div element next to the canvas.
Using `LABEL` creates unhelpful duplicates for screen readers.
Only use `LABEL` during development.
If `FALLBACK` is passed, as in `gridOutput(FALLBACK)`, the description will only be visible to screen readers.
This is the default mode.
Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible.
`gridOutput()` generates descriptions in English only.
Text drawn with <a href="#/p5/`text`">`text`()</a> is not described.
Shapes created with <a href="#/p5/`beginShape`">`beginShape`()</a> are not described.
WEBGL mode and 3D shapes are not supported.
Use <a href="#/p5/describe">describe()</a> and <a href="#/p5/describeElement">describeElement()</a> for more control over canvas descriptions.

Parameters: ~
                🔢 `{Constant} [display] either FALLBACK or LABEL.` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> // Add the grid description.
> gridOutput();
>
> // Draw a couple of shapes.
> background(200);
> fill(255, 0, 0);
> circle(20, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle and a blue square on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> // Add the grid description and
> // display it for debugging.
> gridOutput(LABEL);
>
> // Draw a couple of shapes.
> background(200);
> fill(255, 0, 0);
> circle(20, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle and a blue square on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
> }
>
> function draw() {
> // Add the grid description.
> gridOutput();
>
> // Draw a moving circle.
> background(200);
> let x = frameCount * 0.1;
> fill(255, 0, 0);
> circle(x, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle moves from left to right above a blue square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
> }
>
> function draw() {
> // Add the grid description and
> // display it for debugging.
> gridOutput(LABEL);
>
> // Draw a moving circle.
> background(200);
> let x = frameCount * 0.1;
> fill(255, 0, 0);
> circle(x, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle moves from left to right above a blue square.');
> }
> </code>
>
<

See also: ~
   |help p5-gridOutput| for detailed help on this symbol~

Source: ~
                ../temp/src/accessibility/outputs.js:294
~


p5-Environment_noCursor() 📄 ⚡
|noCursor|() ⚡ Function

Hides the cursor from view.

Examples: >
>
> <code>
> function setup() {
> // Hide the cursor.
> noCursor();
> }
>
> function draw() {
> background(200);
>
> circle(mouseX, mouseY, 10);
>
> describe('A white circle on a gray background. The circle follows the mouse as it moves. The cursor is hidden.');
> }
> </code>
>
<

See also: ~
   |help p5-noCursor| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:504
~


p5-Environment_pixelDensity() 📄 ⚡
|pixelDensity|() ⚡ Function

Returns: ~
                🔢 Returns undefined
~

See also: ~
   |help p5-pixelDensity| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:1063
~


p5-Environment_print() 📄 ⚡
|print|(contents) ⚡ Function

Displays `text` in the web browser's console.
``print`()` is helpful for printing values while debugging.
Each call to ``print`()` creates a new `line` of `text`.
Note: Call ``print`('\n')` to `print` a blank `line`.
Calling ``print`()` without an argument opens the browser's dialog for printing documents.

Parameters: ~
                🔢 `contents` (Any) - content to print to the console.
~

Examples: >
>
> <code>
> function setup() {
> // Prints "hello, world" to the console.
> print('hello, world');
> }
> </code>
> </div>
>
> <div class="norender">
> <code>
> function setup() {
> let name = 'ada';
> // Prints "hello, ada" to the console.
> print(`hello, ${name}`);
> }
> </code>
>
<

See also: ~
   |help p5-print| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:52
~


p5-Environment_textOutput() 📄 ⚡
|textOutput|({Constant} [display] either FALLBACK or LABEL.) ⚡ Function

Creates a screen reader-accessible description of shapes on the canvas.
`textOutput()` adds a general description, list of shapes, and table of shapes to the web page.
The general description includes the canvas size, canvas `color`, and number of shapes.
For example, `Your output is a, 100 by 100 `pixels`, gray canvas containing the following 2 shapes:`.
A list of shapes follows the general description.
The list describes the `color`, location, and area of each shape.
For example, `a `red` `circle` at middle covering 3% of the canvas`.
Each shape can be selected to `get` more details.
`textOutput()` uses its table of shapes as a list.
The table describes the shape, `color`, location, coordinates and area.
For example, ``red` `circle` location = middle area = 3%`.
This is different from <a href="#/p5/gridOutput">gridOutput()</a>, which uses its table as a grid.
The `display` parameter is optional.
It determines how the description is displayed.
If `LABEL` is passed, as in `textOutput(LABEL)`, the description will be visible in a div element next to the canvas.
Using `LABEL` creates unhelpful duplicates for screen readers.
Only use `LABEL` during development.
If `FALLBACK` is passed, as in `textOutput(FALLBACK)`, the description will only be visible to screen readers.
This is the default mode.
Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible.
`textOutput()` generates descriptions in English only.
Text drawn with <a href="#/p5/`text`">`text`()</a> is not described.
Shapes created with <a href="#/p5/`beginShape`">`beginShape`()</a> are not described.
WEBGL mode and 3D shapes are not supported.
Use <a href="#/p5/describe">describe()</a> and <a href="#/p5/describeElement">describeElement()</a> for more control over canvas descriptions.

Parameters: ~
                🔢 `{Constant} [display] either FALLBACK or LABEL.` (unknown)
~

Examples: >
>
> <code>
> function setup() {
> // Add the text description.
> textOutput();
>
> // Draw a couple of shapes.
> background(200);
> fill(255, 0, 0);
> circle(20, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle and a blue square on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> // Add the text description and
> // display it for debugging.
> textOutput(LABEL);
>
> // Draw a couple of shapes.
> background(200);
> fill(255, 0, 0);
> circle(20, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle and a blue square on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
> }
>
> function draw() {
> // Add the text description.
> textOutput();
>
> // Draw a moving circle.
> background(200);
> let x = frameCount * 0.1;
> fill(255, 0, 0);
> circle(x, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle moves from left to right above a blue square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
> }
>
> function draw() {
> // Add the text description and
> // display it for debugging.
> textOutput(LABEL);
>
> // Draw a moving circle.
> background(200);
> let x = frameCount * 0.1;
> fill(255, 0, 0);
> circle(x, 20, 20);
> fill(0, 0, 255);
> square(50, 50, 50);
>
> // Add a general description of the canvas.
> describe('A red circle moves from left to right above a blue square.');
> }
> </code>
>
<

See also: ~
   |help p5-textOutput| for detailed help on this symbol~

Source: ~
                ../temp/src/accessibility/outputs.js:142
~


p5-Environment_ValidationError() 📄 ⚡
|ValidationError|() ⚡ Function

a custom error type, used by the mocha tests when expecting validation errors

See also: ~
   |help p5-ValidationError| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:517
~


PROPERTIES                                                   *p5-Environment-properties*

p5-Environment_deltaTime() 📄 🔧
|deltaTime| ⚡ Function

A `Number` variable that tracks the number of milliseconds it took to `draw` the last frame.
`deltaTime` contains the amount of time it took <a href="#/p5/`draw`">`draw`()</a> to execute during the previous frame.
It's useful for simulating physics.

Examples: >
>
> <code>
> let x = 0;
> let speed = 0.05;
>
> function setup()  {
> createCanvas(100, 100);
>
> // Set the frameRate to 30.
> frameRate(30);
>
> describe('A white circle moves from left to right on a gray background. It reappears on the left side when it reaches the right side.');
> }
>
> function draw() {
> background(200);
>
> // Use deltaTime to calculate
> // a change in position.
> let deltaX = speed * deltaTime;
>
> // Update the x variable.
> x += deltaX;
>
> // Reset x to 0 if it's
> // greater than 100.
> if (x > 100)  {
> x = 0;
> }
>
> // Use x to set the circle's
> // position.
> circle(x, 50, 20);
> }
> </code>
>
<

See also: ~
   |help p5-deltaTime| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:172
~


p5-Environment_displayHeight() 📄 🔧
|displayHeight| ⚡ Function

A `Number` variable that stores the `height` of the screen display.
`displayHeight` is useful for running full-screen programs.
Its value depends on the current <a href="#/p5/`pixelDensity`">`pixelDensity`()</a>.
Note: The actual screen `height` can be computed as `displayHeight * `pixelDensity`()`.

Examples: >
>
> <code>
> function setup() {
> // Set the canvas' width and height
> // using the display's dimensions.
> createCanvas(displayWidth, displayHeight);
>
> background(200);
>
> describe('A gray canvas that is the same size as the display.');
> }
> </code>
>
<

See also: ~
   |help p5-displayHeight| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:650
~


p5-Environment_displayWidth() 📄 🔧
|displayWidth| ⚡ Function

A `Number` variable that stores the `width` of the screen display.
`displayWidth` is useful for running full-screen programs.
Its value depends on the current <a href="#/p5/`pixelDensity`">`pixelDensity`()</a>.
Note: The actual screen `width` can be computed as `displayWidth * `pixelDensity`()`.

Examples: >
>
> <code>
> function setup() {
> // Set the canvas' width and height
> // using the display's dimensions.
> createCanvas(displayWidth, displayHeight);
>
> background(200);
>
> describe('A gray canvas that is the same size as the display.');
> }
> </code>
>
<

See also: ~
   |help p5-displayWidth| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:619
~


p5-Environment_focused() 📄 🔧
|focused| ⚡ Function

A `Boolean` variable that's `true` if the browser is focused and `false` if not.
Note: The browser window can only receive input if it's focused.

Examples: >
>
> <code>
> // Open this example in two separate browser
> // windows placed side-by-side to demonstrate.
>
> function setup() {
> createCanvas(100, 100);
>
> describe('A square changes color from green to red when the browser window is out of focus.');
> }
>
> function draw() {
> // Change the background color
> // when the browser window
> // goes in/out of focus.
> if (focused === true) {
> background(0, 255, 0);
> } else {
> background(255, 0, 0);
> }
> }
> </code>
>
<

See also: ~
   |help p5-focused| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:207
~


p5-Environment_frameCount() 📄 🔧
|frameCount| ⚡ Function

A `Number` variable that tracks the number of frames drawn since the sketch started.
``frameCount``'s value is 0 inside <a href="#/p5/`setup`">`setup`()</a>.
It increments by 1 each time the code in <a href="#/p5/`draw`">`draw`()</a> finishes executing.

Examples: >
>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> background(200);
>
> // Display the value of
> // frameCount.
> textSize(30);
> textAlign(CENTER, CENTER);
> text(frameCount, 50, 50);
>
> describe('The number 0 written in black in the middle of a gray square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 100);
>
> // Set the frameRate to 30.
> frameRate(30);
>
> textSize(30);
> textAlign(CENTER, CENTER);
>
> describe('A number written in black in the middle of a gray square. Its value increases rapidly.');
> }
>
> function draw() {
> background(200);
>
> // Display the value of
> // frameCount.
> text(frameCount, 50, 50);
> }
> </code>
>
<

See also: ~
   |help p5-frameCount| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:122
~


p5-Environment_getFrameRate() 📄 🔧
|getFrameRate| ⚡ Function

Returns the current framerate.

Returns: ~
                🔢 Returns Number: current frameRate
~

See also: ~
   |help p5-getFrameRate| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:427
~


p5-Environment_height() 📄 🔧
|height| ⚡ Function

A `Number` variable that stores the `height` of the canvas in `pixels`.
``height``'s default value is 100.
Calling <a href="#/p5/`createCanvas`">`createCanvas`()</a> or <a href="#/p5/`resizeCanvas`">`resizeCanvas`()</a> changes the value of ``height``.
Calling <a href="#/p5/noCanvas">noCanvas()</a> sets its value to 0.

Examples: >
>
> <code>
> function setup() {
> background(200);
>
> // Display the canvas' height.
> text(height, 42, 54);
>
> describe('The number 100 written in black on a gray square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(100, 50);
>
> background(200);
>
> // Display the canvas' height.
> text(height, 42, 27);
>
> describe('The number 50 written in black on a gray rectangle.');
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
> // Display the canvas' height.
> text(height, 42, 54);
>
> describe('The number 100 written in black on a gray square. When the mouse is pressed, the square becomes a rectangle and the number becomes 50.');
> }
>
> // If the mouse is pressed, reisze
> // the canvas and display its new
> // height.
> function mousePressed() {
> if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
> resizeCanvas(100, 50);
> background(200);
> text(height, 42, 27);
> }
> }
> </code>
>
<

See also: ~
   |help p5-height| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:948
~


p5-Environment_setFrameRate() 📄 🔧
|setFrameRate| ⚡ Function

Specifies the number of frames to be displayed every second.
For example, the function call `frameRate`(30) will attempt to refresh 30 times a second.
If the processor is not fast enough to maintain the specified rate, the frame rate will not be achieved.
Setting the frame rate within <a href="#/p5/`setup`">`setup`()</a> is recommended.
The default rate is 60 frames per second.
Calling ``frameRate`()` with no arguments returns the current frame rate.

Parameters: ~
                🔢 `{Number} [fps] number of frames to be displayed every second` (unknown)
~

See also: ~
   |help p5-setFrameRate| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:443
~


p5-Environment_webglVersion() 📄 🔧
|webglVersion| ⚡ Function

A `String` variable with the WebGL version in use.
`webglVersion`'s value equals one of the following string constants: - `WEBGL2` whose value is `'webgl2'`, - `WEBGL` whose value is `'webgl'`, or - `P2D` whose value is `'p2d'`.
This is the default for 2D sketches.
See <a href="#/p5/setAttributes">setAttributes()</a> for ways to `set` the WebGL version.

Examples: >
>
> <code>
> function setup() {
> background(200);
>
> // Display the current WebGL version.
> text(webglVersion, 42, 54);
>
> describe('The text "p2d" written in black on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> let font;
>
> function preload() {
> // Load a font to use.
> font = loadFont('assets/inconsolata.otf');
> }
>
> function setup() {
> // Create a canvas using WEBGL mode.
> createCanvas(100, 50, WEBGL);
> background(200);
>
> // Display the current WebGL version.
> fill(0);
> textFont(font);
> text(webglVersion, -15, 5);
>
> describe('The text "webgl2" written in black on a gray background.');
> }
> </code>
> </div>
>
> <div>
> <code>
> let font;
>
> function preload() {
> // Load a font to use.
> font = loadFont('assets/inconsolata.otf');
> }
>
> function setup() {
> // Create a canvas using WEBGL mode.
> createCanvas(100, 50, WEBGL);
>
> // Set WebGL to version 1.
> setAttributes({ version: 1 });
>
> background(200);
>
> // Display the current WebGL version.
> fill(0);
> textFont(font);
> text(webglVersion, -14, 5);
>
> describe('The text "webgl" written in black on a gray background.');
> }
> </code>
>
<

See also: ~
   |help p5-webglVersion| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:588
~


p5-Environment_width() 📄 🔧
|width| ⚡ Function

A `Number` variable that stores the `width` of the canvas in `pixels`.
``width``'s default value is 100.
Calling <a href="#/p5/`createCanvas`">`createCanvas`()</a> or <a href="#/p5/`resizeCanvas`">`resizeCanvas`()</a> changes the value of ``width``.
Calling <a href="#/p5/noCanvas">noCanvas()</a> sets its value to 0.

Examples: >
>
> <code>
> function setup() {
> background(200);
>
> // Display the canvas' width.
> text(width, 42, 54);
>
> describe('The number 100 written in black on a gray square.');
> }
> </code>
> </div>
>
> <div>
> <code>
> function setup() {
> createCanvas(50, 100);
>
> background(200);
>
> // Display the canvas' width.
> text(width, 21, 54);
>
> describe('The number 50 written in black on a gray rectangle.');
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
> // Display the canvas' width.
> text(width, 42, 54);
>
> describe('The number 100 written in black on a gray square. When the mouse is pressed, the square becomes a rectangle and the number becomes 50.');
> }
>
> // If the mouse is pressed, reisze
> // the canvas and display its new
> // width.
> function mousePressed() {
> if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height) {
> resizeCanvas(50, 100);
> background(200);
> text(width, 21, 54);
> }
> }
> </code>
>
<

See also: ~
   |help p5-width| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:879
~


p5-Environment_windowHeight() 📄 🔧
|windowHeight| ⚡ Function

A `Number` variable that stores the `height` of the browser's viewport.
The <a href="https://developer.mozilla.org/en-US/docs/Glossary/Layout_viewport" target="_blank">layout viewport</a> is the area within the browser that's available for drawing.

Examples: >
>
> <code>
> function setup() {
> // Set the canvas' width and height
> // using the browser's dimensions.
> createCanvas(windowWidth, windowHeight);
>
> background(200);
>
> describe('A gray canvas that takes up the entire browser window.');
> }
> </code>
>
<

See also: ~
   |help p5-windowHeight| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:706
~


p5-Environment_windowWidth() 📄 🔧
|windowWidth| ⚡ Function

A `Number` variable that stores the `width` of the browser's viewport.
The <a href="https://developer.mozilla.org/en-US/docs/Glossary/Layout_viewport" target="_blank">layout viewport</a> is the area within the browser that's available for drawing.

Examples: >
>
> <code>
> function setup() {
> // Set the canvas' width and height
> // using the browser's dimensions.
> createCanvas(windowWidth, windowHeight);
>
> background(200);
>
> describe('A gray canvas that takes up the entire browser window.');
> }
> </code>
>
<

See also: ~
   |help p5-windowWidth| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:678
~


VARIABLES                                                   *p5-Environment-variables*

p5-Environment_addType() 📄 📌
|addType| ⚡ Function

Query type and return the result as an object This would be called repeatedly over and over again, so it needs to be as optimized for performance as possible

See also: ~
   |help p5-addType| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:101
~


p5-Environment_availableTranslatorLanguages() 📄 📌
|availableTranslatorLanguages| ⚡ Function

Returns a list of languages we have translations loaded for

See also: ~
   |help p5-availableTranslatorLanguages| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:180
~


p5-Environment_buildArgTypeCache() 📄 📌
|buildArgTypeCache| ⚡ Function

Build the argument type tree, argumentTree This would be called repeatedly over and over again, so it needs to be as optimized for performance as possible

See also: ~
   |help p5-buildArgTypeCache| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:171
~


p5-Environment_checkForConstsAndFuncs() 📄 📌
|checkForConstsAndFuncs| ⚡ Function

Takes a list of variables defined by the user in the code as an array and checks if the list contains p5.js constants and functions.

See also: ~
   |help p5-checkForConstsAndFuncs| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:65
~


p5-Environment_checkForUserDefinedFunctions() 📄 📌
|checkForUserDefinedFunctions| ⚡ Function

Checks capitalization for user defined functions.
Generates and prints a friendly error message using `key`: "fes.checkUserDefinedFns".

See also: ~
   |help p5-checkForUserDefinedFunctions| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:287
~


p5-Environment_codeToLines() 📄 📌
|codeToLines| ⚡ Function

Converts code written by the user to an array every element of which is a separate `line` of code.

See also: ~
   |help p5-codeToLines| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:211
~


p5-Environment_computeEditDistance() 📄 📌
|computeEditDistance| ⚡ Function

Measures dissimilarity between two strings by calculating the Levenshtein distance.
If the "distance" between them is small enough, it is reasonable to think that one is the misspelled version of the other.
Specifically, this uses the Wagner–Fischer algorithm.

See also: ~
   |help p5-computeEditDistance| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:239
~


p5-Environment_currentTranslatorLanguage() 📄 📌
|currentTranslatorLanguage| ⚡ Function

Returns the current language selected for translation

See also: ~
   |help p5-currentTranslatorLanguage| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:187
~


p5-Environment_extractFuncVariables() 📄 📌
|extractFuncVariables| ⚡ Function

Takes an array in which each element is a `line` of code containing a function definition(array=['let x = () => {...}']) and extracts the functions defined.

See also: ~
   |help p5-extractFuncVariables| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:191
~


p5-Environment_extractVariables() 📄 📌
|extractVariables| ⚡ Function

Takes an array in which each element is a `line` of code containing a variable definition(Eg: arr=['let x = 100', 'const y = 200']) and extracts the variables defined.

See also: ~
   |help p5-extractVariables| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:167
~


p5-Environment_fesCodeReader() 📄 📌
|fesCodeReader| ⚡ Function

Initiates the sketch_reader's processes.
Obtains the code in `setup` and `draw` function and forwards it for further processing and evaluation.

See also: ~
   |help p5-fesCodeReader| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:380
~


p5-Environment_fesErrorMonitor() 📄 📌
|fesErrorMonitor| ⚡ Function

Handles "global" errors that the browser catches.
Called when an error event happens and detects the type of error.
Generates and prints a friendly error message using `key`: "fes.globalErrors.syntax.[*]", "fes.globalErrors.reference.[*]", "fes.globalErrors.type.[*]".

See also: ~
   |help p5-fesErrorMonitor| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:629
~


p5-Environment_formats() 📄 📌
|formats| ⚡ Function

Gets a list of errors for this overload

See also: ~
   |help p5-formats| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:462
~


p5-Environment_getOverloadErrors() 📄 📌
|getOverloadErrors| ⚡ Function

Gets a list of errors for this overload

See also: ~
   |help p5-getOverloadErrors| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:461
~


p5-Environment_globalConstFuncCheck() 📄 📌
|globalConstFuncCheck| ⚡ Function

Checks if any p5.js constant or function is declared outside a function and reports it if found.

See also: ~
   |help p5-globalConstFuncCheck| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:277
~


p5-Environment_handleMisspelling() 📄 📌
|handleMisspelling| ⚡ Function

Compares the symbol caught in the ReferenceError to everything in misusedAtTopLevel ( all public p5 properties ).
Generates and prints a friendly error message using `key`: "fes.misspelling".

See also: ~
   |help p5-handleMisspelling| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:336
~


p5-Environment_helpForMisusedAtTopLevelCode() 📄 📌
|helpForMisusedAtTopLevelCode| ⚡ Function

Detects browser level error event for p5 constants/functions used outside of `setup`() and `draw`().
Generates and prints a friendly error message using `key`: "fes.misusedTopLevel".

See also: ~
   |help p5-helpForMisusedAtTopLevelCode| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:1032
~


p5-Environment_i() 📄 📌
|i| ⚡ Function

Takes a list of variables defined by the user in the code as an array and checks if the list contains p5.js constants and functions.

See also: ~
   |help p5-i| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:66
~


p5-Environment_i18init() 📄 📌
|i18init| ⚡ Function

Set up our translation function, with loaded languages

See also: ~
   |help p5-i18init| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:132
~


p5-Environment_initialize() 📄 📌
|initialize| ⚡ Function

Set up our translation function, with loaded languages

See also: ~
   |help p5-initialize| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:131
~


p5-Environment_isArray() 📄 📌
|isArray| ⚡ Function

Test type for non-object type parameter validation

See also: ~
   |help p5-isArray| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:362
~


p5-Environment_isNumber() 📄 📌
|isNumber| ⚡ Function

Checks whether input type is Number This is a helper function for validateParameters()

See also: ~
   |help p5-isNumber| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:344
~


p5-Environment_key() 📄 📌
|key| ⚡ Function

Clears cache to avoid having multiple FES messages for the same `set` of parameters.
If a function is called with some `set` of wrong arguments, and then called again with the same `set` of arguments, the messages due to the second call will be supressed.
If two tests test on the same wrong arguments, the second test won't see the validationError.
clearing argumentTree solves it

See also: ~
   |help p5-key| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:673
~


p5-Environment_l1() 📄 📌
|l1| ⚡ Function

Measures dissimilarity between two strings by calculating the Levenshtein distance.
If the "distance" between them is small enough, it is reasonable to think that one is the misspelled version of the other.
Specifically, this uses the Wagner–Fischer algorithm.

See also: ~
   |help p5-l1| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:240
~


p5-Environment_log() 📄 📌
|log| ⚡ Function

Prints a friendly stacktrace for user-written functions for "global" errors Generates and prints a friendly error message using `key`: "fes.globalErrors.stackTop", "fes.globalErrors.stackSubseq".

See also: ~
   |help p5-log| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:436
~


p5-Environment_lookupParamDoc() 📄 📌
|lookupParamDoc| ⚡ Function

Query data.json This is a helper function for validateParameters()

See also: ~
   |help p5-lookupParamDoc| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:203
~


p5-Environment_mapToReference() 📄 📌
|mapToReference| ⚡ Function

Takes a message and a p5 function func, and adds a link pointing to the reference documentation of func at the end of the message

See also: ~
   |help p5-mapToReference| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:134
~


p5-Environment_matches() 📄 📌
|matches| ⚡ Function

Takes an array in which each element is a `line` of code containing a function definition(array=['let x = () => {...}']) and extracts the functions defined.

See also: ~
   |help p5-matches| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:192
~


p5-Environment_message() 📄 📌
|message| ⚡ Function

Prints a friendly msg after parameter validation

See also: ~
   |help p5-message| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:539
~


p5-Environment_minScore() 📄 📌
|minScore| ⚡ Function

Test type for multiple parameters

See also: ~
   |help p5-minScore| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:411
~


p5-Environment_msgWithReference() 📄 📌
|msgWithReference| ⚡ Function

Takes a message and a p5 function func, and adds a link pointing to the reference documentation of func at the end of the message

See also: ~
   |help p5-msgWithReference| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:135
~


p5-Environment_printFriendlyStack() 📄 📌
|printFriendlyStack| ⚡ Function

Prints a friendly stacktrace for user-written functions for "global" errors Generates and prints a friendly error message using `key`: "fes.globalErrors.stackTop", "fes.globalErrors.stackSubseq".

See also: ~
   |help p5-printFriendlyStack| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:435
~


p5-Environment_processStack() 📄 📌
|processStack| ⚡ Function

Takes a stacktrace array and filters out all frames that show internal p5 details.
Generates and prints a friendly error message using `key`: "fes.wrongPreload", "fes.libraryError".
The processed stack is used to find whether the error happened internally within the library, and if the error was due to a non-loadX() method being used in preload.
"Internally" here means that the exact location of the error (the top of the stack) is a piece of code written in the p5.js library (which may or may not have been called from the user's sketch).

See also: ~
   |help p5-processStack| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:489
~


p5-Environment_re() 📄 📌
|re| ⚡ Function

Returns the current <a href="https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL#parameters" target="_blank">URL parameters</a> in an `Object`.
For example, calling `getURLParams()` in a sketch hosted at the URL `https://p5js.org?year=2014&month=May&day=15` returns `{ year: 2014, month: 'May', day: 15 }`.

Examples: >
>
> <code>
> // Imagine this sketch is hosted at the following URL:
> // https://p5js.org?year=2014&month=May&day=15
>
> function setup() {
> background(200);
>
> // Get the sketch's URL
> // parameters and display
> // them.
> let params = getURLParams();
> text(params.day, 10, 20);
> text(params.month, 10, 40);
> text(params.year, 10, 60);
>
> describe('The text "15", "May", and "2014" written in black on separate lines.');
> }
> </code>
>
<

See also: ~
   |help p5-re| for detailed help on this symbol~

Source: ~
                ../temp/src/core/environment.js:1245
~


p5-Environment_removeMultilineComments() 📄 📌
|removeMultilineComments| ⚡ Function

Remove multiline comments and the content inside it.

See also: ~
   |help p5-removeMultilineComments| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:251
~


p5-Environment_score() 📄 📌
|score| ⚡ Function

generate a score (higher is worse) for applying these args to this overload.

See also: ~
   |help p5-score| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:426
~


p5-Environment_scoreOverload() 📄 📌
|scoreOverload| ⚡ Function

generate a score (higher is worse) for applying these args to this overload.

See also: ~
   |help p5-scoreOverload| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:425
~


p5-Environment_setTranslatorLanguage() 📄 📌
|setTranslatorLanguage| ⚡ Function

Sets the current language for translation Returns a promise that resolved when loading is finished, or rejects if it fails.

See also: ~
   |help p5-setTranslatorLanguage| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:196
~


p5-Environment_start() 📄 📌
|start| ⚡ Function

Remove multiline comments and the content inside it.

See also: ~
   |help p5-start| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/sketch_reader.js:252
~


p5-Environment_translator() 📄 📌
|translator| ⚡ Function

This is our translation function.
Give it a `key` and it will retrieve the appropriate string (within supported languages) according to the user's browser's language settings.

See also: ~
   |help p5-translator| for detailed help on this symbol~

Source: ~
                ../temp/src/core/internationalization.js:118
~


p5-Environment_type() 📄 📌
|type| ⚡ Function

Query type and return the result as an object This would be called repeatedly over and over again, so it needs to be as optimized for performance as possible

See also: ~
   |help p5-type| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/validate_params.js:102
~


p5-Environment_uniqueNamesFound() 📄 📌
|uniqueNamesFound| ⚡ Function

A helper function for populating misusedAtTopLevel list.

See also: ~
   |help p5-uniqueNamesFound| for detailed help on this symbol~

Source: ~
                ../temp/src/core/friendly_errors/fes_core.js:974
~




==============================================================================
Generated by p5.js Documentation Automation
See: https://github.com/prjctimg/automata
Last updated: 2026-02-03
📄 End of Environment documentation 📄
==============================================================================