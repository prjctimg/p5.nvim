# Image Module

This module contains 16 symbols from p5.js.

## Anonymous

**Type:** Class

A class to describe an image. Images are rectangular grids of pixels that can be displayed and modified. Existing images can be loaded by calling <a href="#/p5/loadImage">loadImage()</a>. Blank images can be created by calling <a href="#/p5/createImage">createImage()</a>. `p5.Image` objects have methods for common tasks such as applying filters and modifying pixel values.

### Parameters

- `width`: Number - No description
- `height`: Number - No description

---

## canvas

**Type:** Property

The image's height in pixels.

---

## createImage

**Type:** Function

Creates a new <a href="#/p5.Image">p5.Image</a> object. `createImage()` uses the `width` and `height` parameters to set the new <a href="#/p5.Image">p5.Image</a> object's dimensions in pixels. The new <a href="#/p5.Image">p5.Image</a> can be modified by updating its <a href="#/p5.Image/pixels">pixels</a> array or by calling its <a href="#/p5.Image/get">get()</a> and <a href="#/p5.Image/set">set()</a> methods. The <a href="#/p5.Image/loadPixels">loadPixels()</a> method must be called before reading or modifying pixel values. The <a href="#/p5.Image/updatePixels">updatePixels()</a> method must be called for updates to take effect. Note: The new <a href="#/p5.Image">p5.Image</a> object is transparent by default.

### Parameters

- `width`: Integer - width in pixels.
- `height`: Integer - height in pixels.

### Returns

p5.Image - new <a href="#/p5.Image">p5.Image</a> object.

---

## height

**Type:** Property

The image's height in pixels.

---

## Image

**Type:** Class

A class to describe an image. Images are rectangular grids of pixels that can be displayed and modified. Existing images can be loaded by calling <a href="#/p5/loadImage">loadImage()</a>. Blank images can be created by calling <a href="#/p5/createImage">createImage()</a>. `p5.Image` objects have methods for common tasks such as applying filters and modifying pixel values.

### Parameters

- `width`: Number - No description
- `height`: Number - No description

---

## imageMode

**Type:** Function

Changes the location from which images are drawn when <a href="#/p5/image">image()</a> is called. By default, the first two parameters of <a href="#/p5/image">image()</a> are the x- and y-coordinates of the image's upper-left corner. The next parameters are its width and height. This is the same as calling `imageMode(CORNER)`. `imageMode(CORNERS)` also uses the first two parameters of <a href="#/p5/image">image()</a> as the x- and y-coordinates of the image's top-left corner. The third and fourth parameters are the coordinates of its bottom-right corner. `imageMode(CENTER)` uses the first two parameters of <a href="#/p5/image">image()</a> as the x- and y-coordinates of the image's center. The next parameters are its width and height.

### Parameters

- `mode`: Constant - either CORNER, CORNERS, or CENTER.

---

## loadImage

**Type:** Function

Loads an image to create a <a href="#/p5.Image">p5.Image</a> object. `loadImage()` interprets the first parameter one of three ways. If the path to an image file is provided, `loadImage()` will load it. Paths to local files should be relative, such as `'assets/thundercat.jpg'`. URLs such as `'https://example.com/thundercat.jpg'` may be blocked due to browser security. Raw image data can also be passed as a base64 encoded image in the form `'data:image/png;base64,arandomsequenceofcharacters'`. The second parameter is optional. If a function is passed, it will be called once the image has loaded. The callback function can optionally use the new <a href="#/p5.Image">p5.Image</a> object. The third parameter is also optional. If a function is passed, it will be called if the image fails to load. The callback function can optionally use the event error. Images can take time to load. Calling `loadImage()` in <a href="#/p5/preload">preload()</a> ensures images load before they're used in <a href="#/p5/setup">setup()</a> or <a href="#/p5/draw">draw()</a>.

### Parameters

- `path`: String - path of the image to be loaded or base64 encoded image.
- `{function(p5.Image)} [successCallback] function called with`: unknown - No description
- `{function(Event)}    [failureCallback] function called with event`: unknown - No description

### Returns

p5.Image - the <a href="#/p5.Image">p5.Image</a> object.

---

## loadPixels

**Type:** Function

Loads the current value of each pixel on the canvas into the <a href="#/p5/pixels">pixels</a> array. `loadPixels()` must be called before reading from or writing to <a href="#/p5/pixels">pixels</a>.

---

## noTint

**Type:** Function

Removes the current tint set by <a href="#/p5/tint">tint()</a>. `noTint()` restores images to their original colors.

---

## pixels

**Type:** Property

An array containing the color of each pixel on the canvas. Colors are stored as numbers representing red, green, blue, and alpha (RGBA) values. `pixels` is a one-dimensional array for performance reasons. Each pixel occupies four elements in the `pixels` array, one for each RGBA value. For example, the pixel at coordinates (0, 0) stores its RGBA values at `pixels[0]`, `pixels[1]`, `pixels[2]`, and `pixels[3]`, respectively. The next pixel at coordinates (1, 0) stores its RGBA values at `pixels[4]`, `pixels[5]`, `pixels[6]`, and `pixels[7]`. And so on. The `pixels` array for a 100&times;100 canvas has 100 &times; 100 &times; 4 = 40,000 elements. Some displays use several smaller pixels to set the color at a single point. The <a href="#/p5/pixelDensity">pixelDensity()</a> function returns the pixel density of the canvas. High density displays often have a <a href="#/p5/pixelDensity">pixelDensity()</a> of 2. On such a display, the `pixels` array for a 100&times;100 canvas has 200 &times; 200 &times; 4 = 160,000 elements. Accessing the RGBA values for a point on the canvas requires a little math as shown below. The <a href="#/p5/loadPixels">loadPixels()</a> function must be called before accessing the `pixels` array. The <a href="#/p5/updatePixels">updatePixels()</a> function must be called after any changes are made.

---

## prop

**Type:** Property

Helper fxn for sharing pixel methods

---

## saveFrames

**Type:** Function

Captures a sequence of frames from the canvas that can be saved as images. `saveFrames()` creates an array of frame objects. Each frame is stored as an object with its file type, file name, and image data as a string. For example, the first saved frame might have the following properties: `{ ext: 'png', filename: 'frame0', imageData: 'data:image/octet-stream;base64, abc123' }`. The first parameter, `filename`, sets the prefix for the file names. For example, setting the prefix to `'frame'` would generate the image files `frame0.png`, `frame1.png`, and so on. The second parameter, `extension`, sets the file type to either `'png'` or `'jpg'`. The third parameter, `duration`, sets the duration to record in seconds. The maximum duration is 15 seconds. The fourth parameter, `framerate`, sets the number of frames to record per second. The maximum frame rate value is 22. Limits are placed on `duration` and `framerate` to avoid using too much memory. Recording large canvases can easily crash sketches or even web browsers. The fifth parameter, `callback`, is optional. If a function is passed, image files won't be saved by default. The callback function can be used to process an array containing the data for each captured frame. The array of image data contains a sequence of objects with three properties for each frame: `imageData`, `filename`, and `extension`. Note: Frames are downloaded as individual image files by default.

### Parameters

- `filename`: String - prefix of file name.
- `extension`: String - file extension, either 'jpg' or 'png'.
- `duration`: Number - duration in seconds to record. This parameter will be constrained to be less or equal to 15.
- `framerate`: Number - number of frames to save per second. This parameter will be constrained to be less or equal to 22.
- `{function(Array)} [callback] callback function that will be executed`: unknown - No description

---

## saveGif

**Type:** Function

Generates a gif from a sketch and saves it to a file. `saveGif()` may be called in <a href="#/p5/setup">setup()</a> or at any point while a sketch is running. The first parameter, `fileName`, sets the gif's file name. The second parameter, `duration`, sets the gif's duration in seconds. The third parameter, `options`, is optional. If an object is passed, `saveGif()` will use its properties to customize the gif. `saveGif()` recognizes the properties `delay`, `units`, `silent`, `notificationDuration`, and `notificationID`.

### Parameters

- `filename`: String - file name of gif.
- `duration`: Number - duration in seconds to capture from the sketch.
- `{Object} [options] an object that can contain five more properties:`: unknown - No description

---

## set

**Type:** Function

Sets the color of a pixel or draws an image to the canvas. `set()` is easy to use but it's not as fast as <a href="#/p5/pixels">pixels</a>. Use <a href="#/p5/pixels">pixels</a> to set many pixel values. `set()` interprets the first two parameters as x- and y-coordinates. It interprets the last parameter as a grayscale value, a `[R, G, B, A]` pixel array, a <a href="#/p5.Color">p5.Color</a> object, or a <a href="#/p5.Image">p5.Image</a> object. If an image is passed, the first two parameters set the coordinates for the image's upper-left corner, regardless of the current <a href="#/p5/imageMode">imageMode()</a>. <a href="#/p5/updatePixels">updatePixels()</a> must be called after using `set()` for changes to appear.

### Parameters

- `x`: Number - x-coordinate of the pixel.
- `y`: Number - y-coordinate of the pixel.
- `c`: Number|Number[]|Object - grayscale value | pixel array |

---

## updatePixels

**Type:** Function

Updates the canvas with the RGBA values in the <a href="#/p5/pixels">pixels</a> array. `updatePixels()` only needs to be called after changing values in the <a href="#/p5/pixels">pixels</a> array. Such changes can be made directly after calling <a href="#/p5/loadPixels">loadPixels()</a> or by calling <a href="#/p5/set">set()</a>.

### Parameters

- `{Number} [x]    x-coordinate of the upper-left corner of region`: unknown - No description
- `{Number} [y]    y-coordinate of the upper-left corner of region`: unknown - No description
- `{Number} [w]    width of region to update.`: unknown - No description
- `{Number} [h]    height of region to update.`: unknown - No description

---

## width

**Type:** Property

The image's width in pixels.

---

