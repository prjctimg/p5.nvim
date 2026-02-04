# Rendering Module

This module contains 16 symbols from p5.js.

## anonymous

**Type:** Function

turn a p5.Vector Array into a one dimensional number array

### Parameters

- `arr`: p5.Vector[] - an array of p5.Vector

### Returns

Number[] - a one dimensional array of numbers

---

## Anonymous

**Type:** Class

A class to describe a drawing surface that's separate from the main canvas. Each `p5.Graphics` object provides a dedicated drawing surface called a *graphics buffer*. Graphics buffers are helpful when drawing should happen offscreen. For example, separate scenes can be drawn offscreen and displayed only when needed. `p5.Graphics` objects have nearly all the drawing features of the main canvas. For example, calling the method `myGraphics.circle(50, 50, 20)` draws to the graphics buffer. The resulting image can be displayed on the main canvas by passing the `p5.Graphics` object to the <a href="#/p5/image">image()</a> function, as in `image(myGraphics, 0, 0)`. Note: <a href="#/p5/createGraphics">createGraphics()</a> is the recommended way to create an instance of this class.

### Parameters

- `width`: Number - width of the graphics buffer in pixels.
- `height`: Number - height of the graphics buffer in pixels.
- `renderer`: Constant - renderer to use, either P2D or WEBGL.
- `{p5} [pInst] sketch instance.`: unknown - No description
- `{HTMLCanvasElement} [canvas] existing `&lt;canvas&gt;` element to use.`: unknown - No description

---

## calculateOffset

**Type:** Function

Helper fxn to measure ascent and descent. Adapted from http://stackoverflow.com/a/25355178

---

## framebuffer

**Type:** Class

A <a href="#/p5.Texture">p5.Texture</a> corresponding to a property of a <a href="#/p5.Framebuffer">p5.Framebuffer</a>.

### Parameters

- `framebuffer`: p5.Framebuffer - The framebuffer represented by this
- `property`: String - The property of the framebuffer represented by

---

## Framebuffer

**Type:** Property

An object that stores the framebuffer's depth data. Each framebuffer uses a <a href="https://developer.mozilla.org/en-US/docs/Web/API/WebGLTexture" target="_blank">WebGLTexture</a> object internally to store its depth data. The `myBuffer.depth` property makes it possible to pass this data directly to other functions. For example, calling `texture(myBuffer.depth)` or `myShader.setUniform('depthTexture', myBuffer.depth)`  may be helpful for advanced use cases. Note: By default, a framebuffer's y-coordinates are flipped compared to images and videos. It's easy to flip a framebuffer's y-coordinates as needed when applying it as a texture. For example, calling `plane(myBuffer.width, -myBuffer.height)` will flip the framebuffer.

---

## Graphics

**Type:** Class

A class to describe a drawing surface that's separate from the main canvas. Each `p5.Graphics` object provides a dedicated drawing surface called a *graphics buffer*. Graphics buffers are helpful when drawing should happen offscreen. For example, separate scenes can be drawn offscreen and displayed only when needed. `p5.Graphics` objects have nearly all the drawing features of the main canvas. For example, calling the method `myGraphics.circle(50, 50, 20)` draws to the graphics buffer. The resulting image can be displayed on the main canvas by passing the `p5.Graphics` object to the <a href="#/p5/image">image()</a> function, as in `image(myGraphics, 0, 0)`. Note: <a href="#/p5/createGraphics">createGraphics()</a> is the recommended way to create an instance of this class.

### Parameters

- `width`: Number - width of the graphics buffer in pixels.
- `height`: Number - height of the graphics buffer in pixels.
- `renderer`: Constant - renderer to use, either P2D or WEBGL.
- `{p5} [pInst] sketch instance.`: unknown - No description
- `{HTMLCanvasElement} [canvas] existing `&lt;canvas&gt;` element to use.`: unknown - No description

---

## noCanvas

**Type:** Function

Removes the default canvas. By default, a 100×100 pixels canvas is created without needing to call <a href="#/p5/createCanvas">createCanvas()</a>. `noCanvas()` removes the default canvas for sketches that don't need it.

---

## pixels

**Type:** Property

An array containing the color of each pixel in the framebuffer. <a href="#/p5.Framebuffer/loadPixels">myBuffer.loadPixels()</a> must be called before accessing the `myBuffer.pixels` array. <a href="#/p5.Framebuffer/updatePixels">myBuffer.updatePixels()</a> must be called after any changes are made. Note: Updating pixels via this property is slower than drawing to the framebuffer directly. Consider using a <a href="#/p5.Shader">p5.Shader</a> object instead of looping over `myBuffer.pixels`.

---

## prevFramebuffer

**Type:** Function

Begins drawing shapes to the framebuffer. `myBuffer.begin()` and <a href="#/p5.Framebuffer/end">myBuffer.end()</a> allow shapes to be drawn to the framebuffer. `myBuffer.begin()` begins drawing to the framebuffer and <a href="#/p5.Framebuffer/end">myBuffer.end()</a> stops drawing to the framebuffer. Changes won't be visible until the framebuffer is displayed as an image or texture.

---

## Renderer

**Type:** Class

Main graphics and rendering context, as well as the base API implementation for p5.js "core". To be used as the superclass for Renderer2D and Renderer3D classes, respectively.

### Parameters

- `elt`: HTMLElement - DOM node that is wrapped
- `{p5} [pInst] pointer to p5 instance`: unknown - No description
- `{Boolean} [isMainCanvas] whether we're using it as main canvas`: unknown - No description

---

## RendererGL

**Type:** Class

3D graphics class

---

## resizeCanvas

**Type:** Function

Resizes the canvas to a given width and height. `resizeCanvas()` immediately clears the canvas and calls <a href="#/p5/redraw">redraw()</a>. It's common to call `resizeCanvas()` within the body of <a href="#/p5/windowResized">windowResized()</a> like so: ```js function windowResized() { resizeCanvas(windowWidth, windowHeight); } ``` The first two parameters, `width` and `height`, set the dimensions of the canvas. They also the values of the <a href="#/p5/width">width</a> and <a href="#/p5/height">height</a> system variables. For example, calling `resizeCanvas(300, 500)` resizes the canvas to 300×500 pixels, then sets <a href="#/p5/width">width</a> to 300 and <a href="#/p5/height">height</a> 500. The third parameter, `noRedraw`, is optional. If `true` is passed, as in `resizeCanvas(300, 500, true)`, then the canvas will be canvas to 300×500 pixels but the <a href="#/p5/redraw">redraw()</a> function won't be called immediately. By default, <a href="#/p5/redraw">redraw()</a> is called immediately when `resizeCanvas()` finishes executing.

### Parameters

- `width`: Number - width of the canvas.
- `height`: Number - height of the canvas.
- `{Boolean} [noRedraw] whether to delay calling`: unknown - No description

---

## target

**Type:** Class

A class to describe a high-performance drawing surface for textures. Each `p5.Framebuffer` object provides a dedicated drawing surface called a *framebuffer*. They're similar to <a href="#/p5.Graphics">p5.Graphics</a> objects but can run much faster. Performance is improved because the framebuffer shares the same WebGL context as the canvas used to create it. `p5.Framebuffer` objects have all the drawing features of the main canvas. Drawing instructions meant for the framebuffer must be placed between calls to <a href="#/p5.Framebuffer/begin">myBuffer.begin()</a> and <a href="#/p5.Framebuffer/end">myBuffer.end()</a>. The resulting image can be applied as a texture by passing the `p5.Framebuffer` object to the <a href="#/p5/texture">texture()</a> function, as in `texture(myBuffer)`. It can also be displayed on the main canvas by passing it to the <a href="#/p5/image">image()</a> function, as in `image(myBuffer, 0, 0)`. Note: <a href="#/p5/createFramebuffer">createFramebuffer()</a> is the recommended way to create an instance of this class.

### Parameters

- `target`: p5.Graphics|p5 - sketch instance or
- `{Object} [settings] configuration options.`: unknown - No description

---

## uModelMatrix

**Type:** Property

model view, projection, & normal matrices

---

## uViewMatrix

**Type:** Property

model view, projection, & normal matrices

---

## width

**Type:** Property

Resize our canvas element.

---

