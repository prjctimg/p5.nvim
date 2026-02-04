# DOM Module

This module contains 49 symbols from p5.js.

## addClass

**Type:** Function

Adds a class to the element.

### Parameters

- `class`: String - name of class to add.

---

## addElement

**Type:** Function

Helpers for create methods.

---

## anonymous

**Type:** Function

Sets up logic to check that autoplay succeeded.

---

## Anonymous

**Type:** Class

A class to describe an <a href="https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Getting_started" target="_blank">HTML element</a>. Sketches can use many elements. Common elements include the drawing canvas, buttons, sliders, webcam feeds, and so on. All elements share the methods of the `p5.Element` class. They're created with functions such as <a href="#/p5/createCanvas">createCanvas()</a> and <a href="#/p5/createButton">createButton()</a>.

### Parameters

- `elt`: HTMLElement - wrapped DOM element.
- `{p5} [pInst] pointer to p5 instance.`: unknown - No description

---

## center

**Type:** Function

Centers the element either vertically, horizontally, or both. `center()` will center the element relative to its parent or according to the page's body if the element has no parent. If no argument is passed, as in `myElement.center()` the element is aligned both vertically and horizontally.

### Parameters

- `{String} [align] passing 'vertical', 'horizontal' aligns element accordingly`: unknown - No description

---

## changed

**Type:** Function

Calls a function when the element changes. Calling `myElement.changed(false)` disables the function.

### Parameters

- `fxn`: Function|Boolean - function to call when the element changes.

---

## controls

**Type:** Function

Hide the default <a href="https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement" target="_blank">HTMLMediaElement</a> controls.

---

## createA

**Type:** Function

Creates an `&lt;a&gt;&lt;/a&gt;` element that links to another web page. The first parmeter, `href`, is a string that sets the URL of the linked page. The second parameter, `html`, is a string that sets the inner HTML of the link. It's common to use text, images, or buttons as links. The third parameter, `target`, is optional. It's a string that tells the web browser where to open the link. By default, links open in the current browser tab. Passing `'_blank'` will cause the link to open in a new browser tab. MDN describes a few <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a#target" target="_blank">other options</a>.

### Parameters

- `href`: String - URL of linked page.
- `html`: String - inner HTML of link element to display.
- `{String} [target]   target where the new link should open,`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createAudio

**Type:** Function

Creates a hidden `&lt;audio&gt;` element for simple audio playback. `createAudio()` returns a new <a href="#/p5.MediaElement">p5.MediaElement</a> object. The first parameter, `src`, is the path the video. If a single string is passed, as in `'assets/video.mp4'`, a single video is loaded. An array of strings can be used to load the same video in different formats. For example, `['assets/video.mp4', 'assets/video.ogv', 'assets/video.webm']`. This is useful for ensuring that the video can play across different browsers with different capabilities. See <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Supported_media_formats" target="_blank">MDN</a> for more information about supported formats. The second parameter, `callback`, is optional. It's a function to call once the audio is ready to play.

### Parameters

- `{String|String[]} [src] path to an audio file, or an array of paths`: unknown - No description
- `{Function} [callback]   function to call once the audio is ready to play.`: unknown - No description

### Returns

p5.MediaElement - new <a href="#/p5.MediaElement">p5.MediaElement</a> object.

---

## createButton

**Type:** Function

Creates a `&lt;button&gt;&lt;/button&gt;` element. The first parameter, `label`, is a string that sets the label displayed on the button. The second parameter, `value`, is optional. It's a string that sets the button's value. See <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button#value" target="_blank">MDN</a> for more details.

### Parameters

- `label`: String - label displayed on the button.
- `{String} [value] value of the button.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createCapture

**Type:** Function

Creates a `&lt;video&gt;` element that "captures" the audio/video stream from the webcam and microphone. `createCapture()` returns a new <a href="#/p5.MediaElement">p5.MediaElement</a> object. Videos are shown by default. They can be hidden by calling `capture.hide()` and drawn to the canvas using <a href="#/p5/image">image()</a>. The first parameter, `type`, is optional. It sets the type of capture to use. By default, `createCapture()` captures both audio and video. If `VIDEO` is passed, as in `createCapture(VIDEO)`, only video will be captured. If `AUDIO` is passed, as in `createCapture(AUDIO)`, only audio will be captured. A constraints object can also be passed to customize the stream. See the <a href="http://w3c.github.io/mediacapture-main/getusermedia.html#media-track-constraints" target="_blank"> W3C documentation</a> for possible properties. Different browsers support different properties. The 'flipped' property is an optional property which can be set to `{flipped:true}` to mirror the video output.If it is true then it means that video will be mirrored or flipped and if nothing is mentioned then by default it will be `false`. The second parameter,`callback`, is optional. It's a function to call once the capture is ready for use. The callback function should have one parameter, `stream`, that's a <a href="https://developer.mozilla.org/en-US/docs/Web/API/MediaStream" target="_blank">MediaStream</a> object. Note: `createCapture()` only works when running a sketch locally or using HTTPS. Learn more <a href="http://stackoverflow.com/questions/34197653/getusermedia-in-chrome-47-without-using-https" target="_blank">here</a> and <a href="https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia" target="_blank">here</a>.

### Parameters

- `{String|Constant|Object}  [type] type of capture, either AUDIO or VIDEO,`: unknown - No description
- `{Object}                  [flipped] flip the capturing video and mirror the output with `{flipped:true}`. By`: unknown - No description
- `{Function}                [callback] function to call once the stream`: unknown - No description

### Returns

p5.MediaElement - new <a href="#/p5.MediaElement">p5.MediaElement</a> object.

---

## createCheckbox

**Type:** Function

Creates a checkbox `&lt;input&gt;&lt;/input&gt;` element. Checkboxes extend the <a href="#/p5.Element">p5.Element</a> class with a `checked()` method. Calling `myBox.checked()` returns `true` if it the box is checked and `false` if not. The first parameter, `label`, is optional. It's a string that sets the label to display next to the checkbox. The second parameter, `value`, is also optional. It's a boolean that sets the checkbox's value.

### Parameters

- `{String} [label] label displayed after the checkbox.`: unknown - No description
- `{boolean} [value] value of the checkbox. Checked is `true` and unchecked is `false`.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createColorPicker

**Type:** Function

Creates a color picker element. The parameter, `value`, is optional. If a color string or <a href="#/p5.Color">p5.Color</a> object is passed, it will set the default color. Color pickers extend the <a href="#/p5.Element">p5.Element</a> class with a couple of helpful methods for managing colors: - `myPicker.value()` returns the current color as a hex string in the format `'#rrggbb'`. - `myPicker.color()` returns the current color as a <a href="#/p5.Color">p5.Color</a> object.

### Parameters

- `{String|p5.Color} [value] default color as a <a href="https://developer.mozilla.org/en-US/docs/Web/CSS/color" target="_blank">CSS color string</a>.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createDiv

**Type:** Function

Creates a `&lt;div&gt;&lt;/div&gt;` element. `&lt;div&gt;&lt;/div&gt;` elements are commonly used as containers for other elements. The parameter `html` is optional. It accepts a string that sets the inner HTML of the new `&lt;div&gt;&lt;/div&gt;`.

### Parameters

- `{String} [html] inner HTML for the new `&lt;div&gt;&lt;/div&gt;` element.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createElement

**Type:** Function

Creates a new <a href="#/p5.Element">p5.Element</a> object. The first parameter, `tag`, is a string an HTML tag such as `'h5'`. The second parameter, `content`, is optional. It's a string that sets the HTML content to insert into the new element. New elements have no content by default.

### Parameters

- `tag`: String - tag for the new element.
- `{String} [content] HTML content to insert into the element.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createFileInput

**Type:** Function

Creates an `&lt;input&gt;&lt;/input&gt;` element of type `'file'`. `createFileInput()` allows users to select local files for use in a sketch. It returns a <a href="#/p5.File">p5.File</a> object. The first parameter, `callback`, is a function that's called when the file loads. The callback function should have one parameter, `file`, that's a <a href="#/p5.File">p5.File</a> object. The second parameter, `multiple`, is optional. It's a boolean value that allows loading multiple files if set to `true`. If `true`, `callback` will be called once per file.

### Parameters

- `callback`: Function - function to call once the file loads.
- `{Boolean} [multiple] allow multiple files to be selected.`: unknown - No description

### Returns

p5.File - new <a href="#/p5.File">p5.File</a> object.

---

## createMedia

**Type:** Function

VIDEO STUFF *

---

## createP

**Type:** Function

Creates a paragraph element. `&lt;p&gt;&lt;/p&gt;` elements are commonly used for paragraph-length text. The parameter `html` is optional. It accepts a string that sets the inner HTML of the new `&lt;p&gt;&lt;/p&gt;`.

### Parameters

- `{String} [html] inner HTML for the new `&lt;p&gt;&lt;/p&gt;` element.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createSlider

**Type:** Function

Creates a slider `&lt;input&gt;&lt;/input&gt;` element. Range sliders are useful for quickly selecting numbers from a given range. The first two parameters, `min` and `max`, are numbers that set the slider's minimum and maximum. The third parameter, `value`, is optional. It's a number that sets the slider's default value. The fourth parameter, `step`, is also optional. It's a number that sets the spacing between each value in the slider's range. Setting `step` to 0 allows the slider to move smoothly from `min` to `max`.

### Parameters

- `min`: Number - minimum value of the slider.
- `max`: Number - maximum value of the slider.
- `{Number} [value] default value of the slider.`: unknown - No description
- `{Number} [step] size for each step in the slider's range.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createSpan

**Type:** Function

Creates a `&lt;span&gt;&lt;/span&gt;` element. `&lt;span&gt;&lt;/span&gt;` elements are commonly used as containers for inline elements. For example, a `&lt;span&gt;&lt;/span&gt;` can hold part of a sentence that's a <span style="color: deeppink;">different</span> style. The parameter `html` is optional. It accepts a string that sets the inner HTML of the new `&lt;span&gt;&lt;/span&gt;`.

### Parameters

- `{String} [html] inner HTML for the new `&lt;span&gt;&lt;/span&gt;` element.`: unknown - No description

### Returns

p5.Element - new <a href="#/p5.Element">p5.Element</a> object.

---

## createVideo

**Type:** Function

Creates a `&lt;video&gt;` element for simple audio/video playback. `createVideo()` returns a new <a href="#/p5.MediaElement">p5.MediaElement</a> object. Videos are shown by default. They can be hidden by calling `video.hide()` and drawn to the canvas using <a href="#/p5/image">image()</a>. The first parameter, `src`, is the path the video. If a single string is passed, as in `'assets/topsecret.mp4'`, a single video is loaded. An array of strings can be used to load the same video in different formats. For example, `['assets/topsecret.mp4', 'assets/topsecret.ogv', 'assets/topsecret.webm']`. This is useful for ensuring that the video can play across different browsers with different capabilities. See <a href='https://developer.mozilla.org/en-US/docs/Web/HTML/Supported_media_formats'>MDN</a> for more information about supported formats. The second parameter, `callback`, is optional. It's a function to call once the video is ready to play.

### Parameters

- `src`: String|String[] - path to a video file, or an array of paths for
- `{Function} [callback] function to call once the video is ready to play.`: unknown - No description

### Returns

p5.MediaElement - new <a href="#/p5.MediaElement">p5.MediaElement</a> object.

---

## Cue

**Type:** Class

* SCHEDULE EVENTS **

---

## data

**Type:** Property

A string containing the file's data. Data can be either image data, text contents, or a parsed object in the case of JSON and <a href="#/p5.XML">p5.XML</a> objects.

---

## display

**Type:** Function

Hides the current element.

---

## draggable

**Type:** Function

Makes the element draggable. The parameter, `elmnt`, is optional. If another <a href="#/p5.Element">p5.Element</a> object is passed, as in `myElement.draggable(otherElement)`, the other element will become draggable.

### Parameters

- `{p5.Element} [elmnt]  another <a href="#/p5.Element">p5.Element</a>.`: unknown - No description

---

## drop

**Type:** Function

Calls a function when the user drops a file on the element. The first parameter, `callback`, is a function to call once the file loads. The callback function should have one parameter, `file`, that's a <a href="#/p5.File">p5.File</a> object. If the user drops multiple files on the element, `callback`, is called once for each file. The second parameter, `fxn`, is a function to call when the browser detects one or more dropped files. The callback function should have one parameter, `event`, that's a <a href="https://developer.mozilla.org/en-US/docs/Web/API/DragEvent">DragEvent</a>.

### Parameters

- `callback`: Function - called when a file loads. Called once for each file dropped.
- `{Function} [fxn]     called once when any files are dropped.`: unknown - No description

---

## Element

**Type:** Class

A class to describe an <a href="https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Getting_started" target="_blank">HTML element</a>. Sketches can use many elements. Common elements include the drawing canvas, buttons, sliders, webcam feeds, and so on. All elements share the methods of the `p5.Element` class. They're created with functions such as <a href="#/p5/createCanvas">createCanvas()</a> and <a href="#/p5/createButton">createButton()</a>.

### Parameters

- `elt`: HTMLElement - wrapped DOM element.
- `{p5} [pInst] pointer to p5 instance.`: unknown - No description

---

## elt

**Type:** Property

The element's underlying `HTMLElement` object. The <a href="https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement" target="_blank">HTMLElement</a> object's properties and methods can be used directly.

---

## file

**Type:** Property

Underlying <a href="https://developer.mozilla.org/en-US/docs/Web/API/File" target="_blank">File</a> object. All `File` properties and methods are accessible.

---

## File

**Type:** Class

A class to describe a file. `p5.File` objects are used by <a href="#/p5.Element/drop">myElement.drop()</a> and created by <a href="#/p5/createFileInput">createFileInput</a>.

### Parameters

- `file`: File - wrapped file.

---

## hasClass

**Type:** Function

Checks if a class is already applied to element.

### Parameters

- `c {String} name of class to check.`: unknown - No description

### Returns

any - No description

---

## height

**Type:** Property

A `Number` property that stores the element's height.

---

## hide

**Type:** Function

Hides the current element.

---

## input

**Type:** Function

Calls a function when the element receives input. `myElement.input()` is often used to with text inputs and sliders. Calling `myElement.input(false)` disables the function.

### Parameters

- `fxn`: Function|Boolean - function to call when input is detected within

---

## name

**Type:** Property

The file name as a string.

---

## prop

**Type:** Property

Helper fxn for sharing pixel methods

---

## remove

**Type:** Function

Removes the element, stops all audio/video streams, and removes all callback functions.

---

## removeAttribute

**Type:** Function

Removes an attribute from the element. The parameter `attr` is the attribute's name as a string. For example, calling `myElement.removeAttribute('align')` removes its `align` attribute if it's been set.

### Parameters

- `attr`: String - attribute to remove.

---

## removeClass

**Type:** Function

Removes a class from the element.

### Parameters

- `class`: String - name of class to remove.

---

## removeElements

**Type:** Function

Removes all elements created by p5.js, including any event handlers. There are two exceptions: canvas elements created by <a href="#/p5/createCanvas">createCanvas()</a> and <a href="#/p5.Renderer">p5.Render</a> objects created by <a href="#/p5/createGraphics">createGraphics()</a>.

---

## select

**Type:** Function

Searches the page for the first element that matches the given <a href="https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/CSS_basics#different_types_of_selectors" target="_blank">CSS selector string</a>. The selector string can be an ID, class, tag name, or a combination. `select()` returns a <a href="#/p5.Element">p5.Element</a> object if it finds a match and `null` if not. The second parameter, `container`, is optional. It specifies a container to search within. `container` can be CSS selector string, a <a href="#/p5.Element">p5.Element</a> object, or an <a href="https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement" target="_blank">HTMLElement</a> object.

### Parameters

- `selectors`: String - CSS selector string of element to search for.
- `{String|p5.Element|HTMLElement} [container] CSS selector string, <a href="#/p5.Element">p5.Element</a>, or`: unknown - No description

### Returns

p5.Element|null - <a href="#/p5.Element">p5.Element</a> containing the element.

---

## selectAll

**Type:** Function

Searches the page for all elements that matches the given <a href="https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/CSS_basics#different_types_of_selectors" target="_blank">CSS selector string</a>. The selector string can be an ID, class, tag name, or a combination. `selectAll()` returns an array of <a href="#/p5.Element">p5.Element</a> objects if it finds any matches and an empty array if none are found. The second parameter, `container`, is optional. It specifies a container to search within. `container` can be CSS selector string, a <a href="#/p5.Element">p5.Element</a> object, or an <a href="https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement" target="_blank">HTMLElement</a> object.

### Parameters

- `selectors`: String - CSS selector string of element to search for.
- `{String|p5.Element|HTMLElement} [container] CSS selector string, <a href="#/p5.Element">p5.Element</a>, or`: unknown - No description

### Returns

p5.Element[] - array of <a href="#/p5.Element">p5.Element</a>s containing any elements found.

---

## show

**Type:** Function

Shows the current element.

---

## size

**Type:** Property

The number of bytes in the file.

---

## subtype

**Type:** Property

The file subtype as a string. For example, a file with an `'image'` <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types" target="_blank">MIME type</a> may have a subtype such as ``png`` or ``jpeg``.

---

## toggleClass

**Type:** Function

Toggles whether a class is applied to the element.

### Parameters

- `c {String} class name to toggle.`: unknown - No description

---

## type

**Type:** Property

The file <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types" target="_blank">MIME type</a> as a string. For example, `'image'` and `'text'` are both MIME types.

---

## VIDEO

**Type:** Property

CAMERA STUFF *

---

## width

**Type:** Property

A `Number` property that stores the element's width.

---

