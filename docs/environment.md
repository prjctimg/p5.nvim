# Environment Module

This module contains 31 symbols from p5.js.

## anonymous

**Type:** Function

Sets the current language for translation Returns a promise that resolved when loading is finished, or rejects if it fails.

---

## cursor

**Type:** Function

Hides the cursor from view.

---

## defineMisusedAtTopLevelCode

**Type:** Function

A helper function for populating misusedAtTopLevel list.

---

## deltaTime

**Type:** Property

A `Number` variable that tracks the number of milliseconds it took to draw the last frame. `deltaTime` contains the amount of time it took <a href="#/p5/draw">draw()</a> to execute during the previous frame. It's useful for simulating physics.

---

## describe

**Type:** Function

Creates a screen reader-accessible description of the canvas. The first parameter, `text`, is the description of the canvas. The second parameter, `display`, is optional. It determines how the description is displayed. If `LABEL` is passed, as in `describe('A description.', LABEL)`, the description will be visible in a div element next to the canvas. If `FALLBACK` is passed, as in `describe('A description.', FALLBACK)`, the description will only be visible to screen readers. This is the default mode. Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible.

### Parameters

- `text`: String - description of the canvas.
- `{Constant} [display] either LABEL or FALLBACK.`: unknown - No description

---

## describeElement

**Type:** Function

Creates a screen reader-accessible description of elements in the canvas. Elements are shapes or groups of shapes that create meaning together. For example, a few overlapping circles could make an "eye" element. The first parameter, `name`, is the name of the element. The second parameter, `text`, is the description of the element. The third parameter, `display`, is optional. It determines how the description is displayed. If `LABEL` is passed, as in `describe('A description.', LABEL)`, the description will be visible in a div element next to the canvas. Using `LABEL` creates unhelpful duplicates for screen readers. Only use `LABEL` during development. If `FALLBACK` is passed, as in `describe('A description.', FALLBACK)`, the description will only be visible to screen readers. This is the default mode. Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible.

### Parameters

- `name`: String - name of the element.
- `text`: String - description of the element.
- `{Constant} [display] either LABEL or FALLBACK.`: unknown - No description

---

## displayDensity

**Type:** Function

Returns the display's current pixel density.

### Returns

any - No description

---

## displayHeight

**Type:** Property

A `Number` variable that stores the height of the screen display. `displayHeight` is useful for running full-screen programs. Its value depends on the current <a href="#/p5/pixelDensity">pixelDensity()</a>. Note: The actual screen height can be computed as `displayHeight * pixelDensity()`.

---

## displayWidth

**Type:** Property

A `Number` variable that stores the width of the screen display. `displayWidth` is useful for running full-screen programs. Its value depends on the current <a href="#/p5/pixelDensity">pixelDensity()</a>. Note: The actual screen width can be computed as `displayWidth * pixelDensity()`.

---

## err

**Type:** Class

a custom error type, used by the mocha tests when expecting validation errors

---

## ErrorStackParser$$parse

**Type:** Function

Given an Error object, extract the most information from it.

### Parameters

- `error`: Error - object

### Returns

Array - of stack frames

---

## FetchResources

**Type:** Class

This is our i18next "backend" plugin. It tries to fetch languages from a CDN.

---

## focused

**Type:** Property

A `Boolean` variable that's `true` if the browser is focused and `false` if not. Note: The browser window can only receive input if it's focused.

---

## frameCount

**Type:** Property

A `Number` variable that tracks the number of frames drawn since the sketch started. `frameCount`'s value is 0 inside <a href="#/p5/setup">setup()</a>. It increments by 1 each time the code in <a href="#/p5/draw">draw()</a> finishes executing.

---

## fullscreen

**Type:** Function

Toggles full-screen mode or returns the current mode. Calling `fullscreen(true)` makes the sketch full-screen. Calling `fullscreen(false)` makes the sketch its original size. Calling `fullscreen()` without an argument returns `true` if the sketch is in full-screen mode and `false` if not. Note: Due to browser restrictions, `fullscreen()` can only be called with user input such as a mouse press.

### Parameters

- `{Boolean} [val] whether the sketch should be in fullscreen mode.`: unknown - No description

### Returns

Boolean - current fullscreen state.

---

## getFrameRate

**Type:** Property

Returns the current framerate.

### Returns

Number - current frameRate

---

## getTargetFrameRate

**Type:** Function

Returns the target frame rate. The value is either the system frame rate or the last value passed to <a href="#/p5/frameRate">frameRate()</a>.

### Returns

Number - _targetFrameRate

---

## getURL

**Type:** Function

Returns the sketch's current <a href="https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL" target="_blank">URL</a> as a `String`.

### Returns

String - url

---

## getURLParams

**Type:** Function

Returns the current <a href="https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL#parameters" target="_blank">URL parameters</a> in an `Object`. For example, calling `getURLParams()` in a sketch hosted at the URL `https://p5js.org?year=2014&month=May&day=15` returns `{ year: 2014, month: 'May', day: 15 }`.

### Returns

Object - URL params

---

## getURLPath

**Type:** Function

Returns the current <a href="https://developer.mozilla.org/en-US/docs/Learn/Common_questions/Web_mechanics/What_is_a_URL#path_to_resource" target="_blank">URL</a> path as an `Array` of `String`s. For example, consider a sketch hosted at the URL `https://example.com/sketchbook`. Calling `getURLPath()` returns `['sketchbook']`. For a sketch hosted at the URL `https://example.com/sketchbook/monday`, `getURLPath()` returns `['sketchbook', 'monday']`.

### Returns

String[] - path components.

---

## gridOutput

**Type:** Function

Creates a screen reader-accessible description of shapes on the canvas. `gridOutput()` adds a general description, table of shapes, and list of shapes to the web page. The general description includes the canvas size, canvas color, and number of shapes. For example, `gray canvas, 100 by 100 pixels, contains 2 shapes:  1 circle 1 square`. `gridOutput()` uses its table of shapes as a grid. Each shape in the grid is placed in a cell whose row and column correspond to the shape's location on the canvas. The grid cells describe the color and type of shape at that location. For example, `red circle`. These descriptions can be selected individually to get more details. This is different from <a href="#/p5/textOutput">textOutput()</a>, which uses its table as a list. A list of shapes follows the table. The list describes the color, type, location, and area of each shape. For example, `red circle, location = middle, area = 3 %`. The `display` parameter is optional. It determines how the description is displayed. If `LABEL` is passed, as in `gridOutput(LABEL)`, the description will be visible in a div element next to the canvas. Using `LABEL` creates unhelpful duplicates for screen readers. Only use `LABEL` during development. If `FALLBACK` is passed, as in `gridOutput(FALLBACK)`, the description will only be visible to screen readers. This is the default mode. Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible. `gridOutput()` generates descriptions in English only. Text drawn with <a href="#/p5/text">text()</a> is not described. Shapes created with <a href="#/p5/beginShape">beginShape()</a> are not described. WEBGL mode and 3D shapes are not supported. Use <a href="#/p5/describe">describe()</a> and <a href="#/p5/describeElement">describeElement()</a> for more control over canvas descriptions.

### Parameters

- `{Constant} [display] either FALLBACK or LABEL.`: unknown - No description

---

## height

**Type:** Property

A `Number` variable that stores the height of the canvas in pixels. `height`'s default value is 100. Calling <a href="#/p5/createCanvas">createCanvas()</a> or <a href="#/p5/resizeCanvas">resizeCanvas()</a> changes the value of `height`. Calling <a href="#/p5/noCanvas">noCanvas()</a> sets its value to 0.

---

## noCursor

**Type:** Function

Hides the cursor from view.

---

## print

**Type:** Function

Displays text in the web browser's console. `print()` is helpful for printing values while debugging. Each call to `print()` creates a new line of text. Note: Call `print('\n')` to print a blank line. Calling `print()` without an argument opens the browser's dialog for printing documents.

### Parameters

- `contents`: Any - content to print to the console.

---

## setFrameRate

**Type:** Property

Specifies the number of frames to be displayed every second. For example, the function call frameRate(30) will attempt to refresh 30 times a second. If the processor is not fast enough to maintain the specified rate, the frame rate will not be achieved. Setting the frame rate within <a href="#/p5/setup">setup()</a> is recommended. The default rate is 60 frames per second. Calling `frameRate()` with no arguments returns the current frame rate.

### Parameters

- `{Number} [fps] number of frames to be displayed every second`: unknown - No description

---

## textOutput

**Type:** Function

Creates a screen reader-accessible description of shapes on the canvas. `textOutput()` adds a general description, list of shapes, and table of shapes to the web page. The general description includes the canvas size, canvas color, and number of shapes. For example, `Your output is a, 100 by 100 pixels, gray canvas containing the following 2 shapes:`. A list of shapes follows the general description. The list describes the color, location, and area of each shape. For example, `a red circle at middle covering 3% of the canvas`. Each shape can be selected to get more details. `textOutput()` uses its table of shapes as a list. The table describes the shape, color, location, coordinates and area. For example, `red circle location = middle area = 3%`. This is different from <a href="#/p5/gridOutput">gridOutput()</a>, which uses its table as a grid. The `display` parameter is optional. It determines how the description is displayed. If `LABEL` is passed, as in `textOutput(LABEL)`, the description will be visible in a div element next to the canvas. Using `LABEL` creates unhelpful duplicates for screen readers. Only use `LABEL` during development. If `FALLBACK` is passed, as in `textOutput(FALLBACK)`, the description will only be visible to screen readers. This is the default mode. Read <a href="https://p5js.org/tutorials/writing-accessible-canvas-descriptions/">Writing accessible canvas descriptions</a> to learn more about making sketches accessible. `textOutput()` generates descriptions in English only. Text drawn with <a href="#/p5/text">text()</a> is not described. Shapes created with <a href="#/p5/beginShape">beginShape()</a> are not described. WEBGL mode and 3D shapes are not supported. Use <a href="#/p5/describe">describe()</a> and <a href="#/p5/describeElement">describeElement()</a> for more control over canvas descriptions.

### Parameters

- `{Constant} [display] either FALLBACK or LABEL.`: unknown - No description

---

## ValidationError

**Type:** Function

a custom error type, used by the mocha tests when expecting validation errors

---

## webglVersion

**Type:** Property

A `String` variable with the WebGL version in use. `webglVersion`'s value equals one of the following string constants: - `WEBGL2` whose value is `'webgl2'`, - `WEBGL` whose value is `'webgl'`, or - `P2D` whose value is `'p2d'`. This is the default for 2D sketches. See <a href="#/p5/setAttributes">setAttributes()</a> for ways to set the WebGL version.

---

## width

**Type:** Property

A `Number` variable that stores the width of the canvas in pixels. `width`'s default value is 100. Calling <a href="#/p5/createCanvas">createCanvas()</a> or <a href="#/p5/resizeCanvas">resizeCanvas()</a> changes the value of `width`. Calling <a href="#/p5/noCanvas">noCanvas()</a> sets its value to 0.

---

## windowHeight

**Type:** Property

A `Number` variable that stores the height of the browser's viewport. The <a href="https://developer.mozilla.org/en-US/docs/Glossary/Layout_viewport" target="_blank">layout viewport</a> is the area within the browser that's available for drawing.

---

## windowWidth

**Type:** Property

A `Number` variable that stores the width of the browser's viewport. The <a href="https://developer.mozilla.org/en-US/docs/Glossary/Layout_viewport" target="_blank">layout viewport</a> is the area within the browser that's available for drawing.

---

