# Typography Module

This module contains 9 symbols from p5.js.

## Anonymous

**Type:** Class

A class to describe fonts.

### Parameters

- `{p5} [pInst] pointer to p5 instance.`: unknown - No description

---

## font

**Type:** Property

The font's underlying <a href="https://opentype.js.org/" target="_blank">opentype.js</a> font object.

---

## Font

**Type:** Class

A class to describe fonts.

### Parameters

- `{p5} [pInst] pointer to p5 instance.`: unknown - No description

---

## loadFont

**Type:** Function

Loads a font and creates a <a href="#/p5.Font">p5.Font</a> object. `loadFont()` can load fonts in either .otf or .ttf format. Loaded fonts can be used to style text on the canvas and in HTML elements. The first parameter, `path`, is the path to a font file. Paths to local files should be relative. For example, `'assets/inconsolata.otf'`. The Inconsolata font used in the following examples can be downloaded for free <a href="https://www.fontsquirrel.com/fonts/inconsolata" target="_blank">here</a>. Paths to remote files should be URLs. For example, `'https://example.com/inconsolata.otf'`. URLs may be blocked due to browser security. The second parameter, `successCallback`, is optional. If a function is passed, it will be called once the font has loaded. The callback function may use the new <a href="#/p5.Font">p5.Font</a> object if needed. The third parameter, `failureCallback`, is also optional. If a function is passed, it will be called if the font fails to load. The callback function may use the error <a href="https://developer.mozilla.org/en-US/docs/Web/API/Event" target="_blank">Event</a> object if needed. Fonts can take time to load. Calling `loadFont()` in <a href="#/p5/preload">preload()</a> ensures fonts load before they're used in <a href="#/p5/setup">setup()</a> or <a href="#/p5/draw">draw()</a>.

### Parameters

- `path`: String - path of the font to be loaded.
- `{Function}      [successCallback] function called with the`: unknown - No description
- `{Function}      [failureCallback] function called with the error`: unknown - No description

### Returns

p5.Font - <a href="#/p5.Font">p5.Font</a> object.

---

## text

**Type:** Function

Draws text to the canvas. The first parameter, `str`, is the text to be drawn. The second and third parameters, `x` and `y`, set the coordinates of the text's bottom-left corner. See <a href="#/p5/textAlign">textAlign()</a> for other ways to align text. The fourth and fifth parameters, `maxWidth` and `maxHeight`, are optional. They set the dimensions of the invisible rectangle containing the text. By default, they set its  maximum width and height. See <a href="#/p5/rectMode">rectMode()</a> for other ways to define the rectangular text box. Text will wrap to fit within the text box. Text outside of the box won't be drawn. Text can be styled a few ways. Call the <a href="#/p5/fill">fill()</a> function to set the text's fill color. Call <a href="#/p5/stroke">stroke()</a> and <a href="#/p5/strokeWeight">strokeWeight()</a> to set the text's outline. Call <a href="#/p5/textSize">textSize()</a> and <a href="#/p5/textFont">textFont()</a> to set the text's size and font, respectively. Note: `WEBGL` mode only supports fonts loaded with <a href="#/p5/loadFont">loadFont()</a>. Calling <a href="#/p5/stroke">stroke()</a> has no effect in `WEBGL` mode.

### Parameters

- `str`: String|Object|Array|Number|Boolean - text to be displayed.
- `x`: Number - x-coordinate of the text box.
- `y`: Number - y-coordinate of the text box.
- `{Number} [maxWidth] maximum width of the text box. See`: unknown - No description
- `{Number} [maxHeight] maximum height of the text box. See`: unknown - No description

---

## textAscent

**Type:** Function

Calculates the ascent of the current font at its current size. The ascent represents the distance, in pixels, of the tallest character above the baseline.

### Returns

Number - ascent measured in units of pixels.

---

## textDescent

**Type:** Function

Calculates the descent of the current font at its current size. The descent represents the distance, in pixels, of the character with the longest descender below the baseline.

### Returns

Number - descent measured in units of pixels.

---

## textWidth

**Type:** Function

Calculates the maximum width of a string of text drawn when <a href="#/p5/text">text()</a> is called.

### Parameters

- `str`: String - string of text to measure.

### Returns

Number - width measured in units of pixels.

---

## textWrap

**Type:** Function

Sets the style for wrapping text when <a href="#/p5/text">text()</a> is called. The parameter, `style`, can be one of the following values: `WORD` starts new lines of text at spaces. If a string of text doesn't have spaces, it may overflow the text box and the canvas. This is the default style. `CHAR` starts new lines as needed to stay within the text box. `textWrap()` only works when the maximum width is set for a text box. For example, calling `text('Have a wonderful day', 0, 10, 100)` sets the maximum width to 100 pixels. Calling `textWrap()` without an argument returns the current style.

### Parameters

- `style`: Constant - text wrapping style, either WORD or CHAR.

### Returns

String - style

---

