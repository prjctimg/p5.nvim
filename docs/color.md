# Color Module

This module contains 19 symbols from p5.js.

## alpha

**Type:** Function

Gets the alpha (transparency) value of a color. `alpha()` extracts the alpha value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the alpha value.

---

## beginClip

**Type:** Function

Starts defining a shape that will mask any shapes drawn afterward. Any shapes drawn between `beginClip()` and <a href="#/p5/endClip">endClip()</a> will add to the mask shape. The mask will apply to anything drawn after <a href="#/p5/endClip">endClip()</a>. The parameter, `options`, is optional. If an object with an `invert` property is passed, as in `beginClip({ invert: true })`, it will be used to set the masking mode. `{ invert: true }` inverts the mask, creating holes in shapes that are masked. `invert` is `false` by default. Masks can be contained between the <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions. Doing so allows unmasked shapes to be drawn after masked shapes. Masks can also be defined in a callback function that's passed to <a href="#/p5/clip">clip()</a>.

### Parameters

- `{Object} [options] an object containing clip settings.`: unknown - No description

---

## blue

**Type:** Function

Gets the blue value of a color. `blue()` extracts the blue value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string. By default, `blue()` returns a color's blue value in the range 0 to 255. If the <a href="#/colorMode">colorMode()</a> is set to RGB, it returns the blue value in the given range.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the blue value.

---

## brightness

**Type:** Function

Gets the brightness value of a color. `brightness()` extracts the HSB brightness value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string. By default, `brightness()` returns a color's HSB brightness in the range 0 to 100. If the <a href="#/colorMode">colorMode()</a> is set to HSB, it returns the brightness value in the given range.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the brightness value.

---

## clear

**Type:** Function

Clears the pixels on the canvas. `clear()` makes every pixel 100% transparent. Calling `clear()` doesn't clear objects created by `createX()` functions such as <a href="#/p5/createGraphics">createGraphics()</a>, <a href="#/p5/createVideo">createVideo()</a>, and <a href="#/p5/createImg">createImg()</a>. These objects will remain unchanged after calling `clear()` and can be redrawn. In WebGL mode, this function can clear the screen to a specific color. It interprets four numeric parameters as normalized RGBA color values. It also clears the depth buffer. If you are not using the WebGL renderer, these parameters will have no effect.

### Parameters

- `{Number} [r] normalized red value.`: unknown - No description
- `{Number} [g] normalized green value.`: unknown - No description
- `{Number} [b] normalized blue value.`: unknown - No description
- `{Number} [a] normalized alpha value.`: unknown - No description

---

## clip

**Type:** Function

Defines a shape that will mask any shapes drawn afterward. The first parameter, `callback`, is a function that defines the mask. Any shapes drawn in  `callback` will add to the mask shape. The mask will apply to anything drawn after `clip()` is called. The second parameter, `options`, is optional. If an object with an `invert` property is passed, as in `beginClip({ invert: true })`, it will be used to set the masking mode. `{ invert: true }` inverts the mask, creating holes in shapes that are masked. `invert` is `false` by default. Masks can be contained between the <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions. Doing so allows unmasked shapes to be drawn after masked shapes. Masks can also be defined with <a href="#/p5/beginClip">beginClip()</a> and <a href="#/p5/endClip">endClip()</a>.

### Parameters

- `callback`: Function - a function that draws the mask shape.
- `{Object} [options] an object containing clip settings.`: unknown - No description

---

## Color

**Type:** Class

A class to describe a color. Each `p5.Color` object stores the color mode and level maxes that were active during its construction. These values are used to interpret the arguments passed to the object's constructor. They also determine output formatting such as when <a href="#/p5/saturation">saturation()</a> is called. Color is stored internally as an array of ideal RGBA values in floating point form, normalized from 0 to 1. These values are used to calculate the closest screen colors, which are RGBA levels from 0 to 255. Screen colors are sent to the renderer. When different color representations are calculated, the results are cached for performance. These values are normalized, floating-point numbers. Note: <a href="#/p5/color">color()</a> is the recommended way to create an instance of this class.

### Parameters

- `{p5} [pInst]                      pointer to p5 instance.`: unknown - No description
- `vals`: Number[]|String - an array containing the color values

---

## endClip

**Type:** Function

Ends defining a mask that was started with <a href="#/p5/beginClip">beginClip()</a>.

---

## erase

**Type:** Function

Starts using shapes to erase parts of the canvas. All drawing that follows `erase()` will subtract from the canvas, revealing the web page underneath. The erased areas will become transparent, allowing the content behind the canvas to show through. The <a href="#/p5/fill">fill()</a>, <a href="#/p5/stroke">stroke()</a>, and <a href="#/p5/blendMode">blendMode()</a> have no effect once `erase()` is called. The `erase()` function has two optional parameters. The first parameter sets the strength of erasing by the shape's interior. A value of 0 means that no erasing will occur. A value of 255 means that the shape's interior will fully erase the content underneath. The default value is 255 (full strength). The second parameter sets the strength of erasing by the shape's edge. A value of 0 means that no erasing will occur. A value of 255 means that the shape's edge will fully erase the content underneath. The default value is 255 (full strength). To cancel the erasing effect, use the <a href="#/p5/noErase">noErase()</a> function. `erase()` has no effect on drawing done with the <a href="#/p5/image">image()</a> and <a href="#/p5/background">background()</a> functions.

### Parameters

- `{Number}   [strengthFill]      a number (0-255) for the strength of erasing under a shape's interior.`: unknown - No description
- `{Number}   [strengthStroke]    a number (0-255) for the strength of erasing under a shape's edge.`: unknown - No description

---

## green

**Type:** Function

Gets the green value of a color. `green()` extracts the green value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string. By default, `green()` returns a color's green value in the range 0 to 255. If the <a href="#/colorMode">colorMode()</a> is set to RGB, it returns the green value in the given range.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the green value.

---

## hue

**Type:** Function

Gets the hue value of a color. `hue()` extracts the hue value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string. Hue describes a color's position on the color wheel. By default, `hue()` returns a color's HSL hue in the range 0 to 360. If the <a href="#/colorMode">colorMode()</a> is set to HSB or HSL, it returns the hue value in the given mode.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the hue value.

---

## lerpColor

**Type:** Function

Blends two colors to find a third color between them. The `amt` parameter specifies the amount to interpolate between the two values. 0 is equal to the first color, 0.1 is very near the first color, 0.5 is halfway between the two colors, and so on. Negative numbers are set to 0. Numbers greater than 1 are set to 1. This differs from the behavior of <a href="#/p5/lerp">lerp</a>. It's necessary because numbers outside of the interval [0, 1] will produce strange and unexpected colors. The way that colors are interpolated depends on the current <a href="#/p5/colorMode">colorMode()</a>.

### Parameters

- `c1`: p5.Color - interpolate from this color (any value created by the color() function).
- `c2`: p5.Color - interpolate to this color (any value created by the color() function).
- `amt`: Number - number between 0 and 1.

### Returns

p5.Color - interpolated color.

---

## lightness

**Type:** Function

Gets the lightness value of a color. `lightness()` extracts the HSL lightness value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string. By default, `lightness()` returns a color's HSL lightness in the range 0 to 100. If the <a href="#/colorMode">colorMode()</a> is set to HSL, it returns the lightness value in the given range.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the lightness value.

---

## noErase

**Type:** Function

Ends erasing that was started with <a href="#/p5/erase">erase()</a>. The <a href="#/p5/fill">fill()</a>, <a href="#/p5/stroke">stroke()</a>, and <a href="#/p5/blendMode">blendMode()</a> settings will return to what they were prior to calling <a href="#/p5/erase">erase()</a>.

---

## noFill

**Type:** Function

Disables setting the fill color for shapes. Calling `noFill()` is the same as making the fill completely transparent, as in `fill(0, 0)`. If both <a href="#/p5/noStroke">noStroke()</a> and `noFill()` are called, nothing will be drawn to the screen.

---

## noStroke

**Type:** Function

Disables drawing points, lines, and the outlines of shapes. Calling `noStroke()` is the same as making the stroke completely transparent, as in `stroke(0, 0)`. If both `noStroke()` and <a href="#/p5/noFill">noFill()</a> are called, nothing will be drawn to the screen.

---

## paletteLerp

**Type:** Function

Blends multiple colors to find a color between them. The `amt` parameter specifies the amount to interpolate between the color stops which are colors at each `amt` value "location" with `amt` values that are between 2 color stops interpolating between them based on its relative distance to both. The way that colors are interpolated depends on the current <a href="#/colorMode">colorMode()</a>.

### Parameters

- `colors_stops`: [p5.Color, Number][] - color stops to interpolate from
- `amt`: Number - number to use to interpolate relative to color stops

### Returns

p5.Color - interpolated color.

---

## red

**Type:** Function

Gets the red value of a color. `red()` extracts the red value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string. By default, `red()` returns a color's red value in the range 0 to 255. If the <a href="#/colorMode">colorMode()</a> is set to RGB, it returns the red value in the given range.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the red value.

---

## saturation

**Type:** Function

Gets the saturation value of a color. `saturation()` extracts the saturation value from a <a href="#/p5.Color">p5.Color</a> object, an array of color components, or a CSS color string. Saturation is scaled differently in HSB and HSL. By default, `saturation()` returns a color's HSL saturation in the range 0 to 100. If the <a href="#/colorMode">colorMode()</a> is set to HSB or HSL, it returns the saturation value in the given mode.

### Parameters

- `color`: p5.Color|Number[]|String - <a href="#/p5.Color">p5.Color</a> object, array of

### Returns

Number - the saturation value

---

