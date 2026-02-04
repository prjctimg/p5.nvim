# Events Module

This module contains 35 symbols from p5.js.

## accelerationX

**Type:** Property

The system variable accelerationX always contains the acceleration of the device along the x axis. Value is represented as meters per second squared.

---

## accelerationY

**Type:** Property

The system variable accelerationY always contains the acceleration of the device along the y axis. Value is represented as meters per second squared.

---

## accelerationZ

**Type:** Property

The system variable accelerationZ always contains the acceleration of the device along the z axis. Value is represented as meters per second squared.

---

## deviceOrientation

**Type:** Property

The system variable deviceOrientation always contains the orientation of the device. The value of this variable will either be set 'landscape' or 'portrait'. If no data is available it will be set to 'undefined'. either LANDSCAPE or PORTRAIT.

---

## exitPointerLock

**Type:** Function

Exits a pointer lock started with <a href="#/p5/requestPointerLock">requestPointerLock</a>. Calling `requestPointerLock()` locks the values of <a href="#/p5/mouseX">mouseX</a>, <a href="#/p5/mouseY">mouseY</a>, <a href="#/p5/pmouseX">pmouseX</a>, and <a href="#/p5/pmouseY">pmouseY</a>. Calling `exitPointerLock()` resumes updating the mouse system variables. Note: Most browsers require an input, such as a click, before calling `requestPointerLock()`. It’s recommended to call `requestPointerLock()` in an event function such as <a href="#/p5/doubleClicked">doubleClicked()</a>.

---

## isKeyPressed

**Type:** Property

A `Boolean` system variable that's `true` if any key is currently pressed and `false` if not.

---

## keyCode

**Type:** Property

A `Number` system variable that contains the code of the last key typed. All keys have a `keyCode`. For example, the `a` key has the `keyCode` 65. The `keyCode` variable is helpful for checking whether a special key has been typed. For example, the following conditional checks whether the enter key has been typed: ```js if (keyCode === 13) { // Code to run if the enter key was pressed. } ``` The same code can be written more clearly using the system variable `ENTER` which has a value of 13: ```js if (keyCode === ENTER) { // Code to run if the enter key was pressed. } ``` The system variables `BACKSPACE`, `DELETE`, `ENTER`, `RETURN`, `TAB`, `ESCAPE`, `SHIFT`, `CONTROL`, `OPTION`, `ALT`, `UP_ARROW`, `DOWN_ARROW`, `LEFT_ARROW`, and `RIGHT_ARROW` are all helpful shorthands the key codes of special keys. Key codes can be found on websites such as <a href="http://keycode.info/">keycode.info</a>.

---

## keyIsDown

**Type:** Function

Returns `true` if the key it’s checking is pressed and `false` if not. `keyIsDown()` is helpful when checking for multiple different key presses. For example, `keyIsDown()` can be used to check if both `LEFT_ARROW` and `UP_ARROW` are pressed: ```js if (keyIsDown(LEFT_ARROW) && keyIsDown(UP_ARROW)) { // Move diagonally. } ``` `keyIsDown()` can check for key presses using <a href="#/p5/keyCode">keyCode</a> values, as in `keyIsDown(37)` or `keyIsDown(LEFT_ARROW)`. Key codes can be found on websites such as <a href="https://keycode.info" target="_blank">keycode.info</a>.

### Parameters

- `code`: Number - key to check.

### Returns

Boolean - whether the key is down or not.

---

## keyIsPressed

**Type:** Property

A `Boolean` system variable that's `true` if any key is currently pressed and `false` if not.

---

## mouseButton

**Type:** Property

A String system variable that contains the value of the last mouse button pressed. The `mouseButton` variable is either `LEFT`, `RIGHT`, or `CENTER`, depending on which button was pressed last. Note: Different browsers may track `mouseButton` differently. See <a href="https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/buttons" target="_blank">MDN</a> for more information.

---

## mouseIsPressed

**Type:** Property

A `Boolean` system variable that's `true` if the mouse is pressed and `false` if not.

---

## mouseX

**Type:** Property

A `Number` system variable that tracks the mouse's horizontal position. `mouseX` keeps track of the mouse's position relative to the top-left corner of the canvas. For example, if the mouse is 50 pixels from the left edge of the canvas, then `mouseX` will be 50. If touch is used instead of the mouse, then `mouseX` will hold the x-coordinate of the most recent touch point.

---

## mouseY

**Type:** Property

A `Number` system variable that tracks the mouse's vertical position. `mouseY` keeps track of the mouse's position relative to the top-left corner of the canvas. For example, if the mouse is 50 pixels from the top edge of the canvas, then `mouseY` will be 50. If touch is used instead of the mouse, then `mouseY` will hold the y-coordinate of the most recent touch point.

---

## movedX

**Type:** Property

A `Number` system variable that tracks the mouse's horizontal movement. `movedX` tracks how many pixels the mouse moves left or right between frames. `movedX` will have a negative value if the mouse moves left between frames and a positive value if it moves right. `movedX` can be calculated as `mouseX - pmouseX`. Note: `movedX` continues updating even when <a href="#/p5/requestPointerLock">requestPointerLock()</a> is active. But keep in mind that during an active pointer lock, mouseX and pmouseX are locked, so `movedX` is based on <a href="https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/movementX">the MouseEvent's movementX value</a> (which may behave differently in different browsers when the user is zoomed in or out).

---

## movedY

**Type:** Property

A `Number` system variable that tracks the mouse's vertical movement. `movedY` tracks how many pixels the mouse moves up or down between frames. `movedY` will have a negative value if the mouse moves up between frames and a positive value if it moves down. `movedY` can be calculated as `mouseY - pmouseY`. Note: `movedY` continues updating even when <a href="#/p5/requestPointerLock">requestPointerLock()</a> is active. But keep in mind that during an active pointer lock, mouseX and pmouseX are locked, so `movedX` is based on <a href="https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/movementX">the MouseEvent's movementX value</a> (which may behave differently in different browsers when the user is zoomed in or out).

---

## pAccelerationX

**Type:** Property

The system variable pAccelerationX always contains the acceleration of the device along the x axis in the frame previous to the current frame. Value is represented as meters per second squared.

---

## pAccelerationY

**Type:** Property

The system variable pAccelerationY always contains the acceleration of the device along the y axis in the frame previous to the current frame. Value is represented as meters per second squared.

---

## pAccelerationZ

**Type:** Property

The system variable pAccelerationZ always contains the acceleration of the device along the z axis in the frame previous to the current frame. Value is represented as meters per second squared.

---

## pmouseX

**Type:** Property

A `Number` system variable that tracks the mouse's previous horizontal position. `pmouseX` keeps track of the mouse's position relative to the top-left corner of the canvas. Its value is <a href="#/p5/mouseX">mouseX</a> from the previous frame. For example, if the mouse was 50 pixels from the left edge of the canvas during the last frame, then `pmouseX` will be 50. If touch is used instead of the mouse, then `pmouseX` will hold the x-coordinate of the last touch point. Note: `pmouseX` is reset to the current <a href="#/p5/mouseX">mouseX</a> value at the start of each touch event.

---

## pmouseY

**Type:** Property

A `Number` system variable that tracks the mouse's previous vertical position. `pmouseY` keeps track of the mouse's position relative to the top-left corner of the canvas. Its value is <a href="#/p5/mouseY">mouseY</a> from the previous frame. For example, if the mouse was 50 pixels from the top edge of the canvas during the last frame, then `pmouseY` will be 50. If touch is used instead of the mouse, then `pmouseY` will hold the y-coordinate of the last touch point. Note: `pmouseY` is reset to the current <a href="#/p5/mouseY">mouseY</a> value at the start of each touch event.

---

## pRotationX

**Type:** Property

The system variable pRotationX always contains the rotation of the device along the x axis in the frame previous to the current frame. If the sketch <a href="#/p5/angleMode"> angleMode()</a> is set to DEGREES, the value will be -180 to 180. If it is set to RADIANS, the value will be -PI to PI. pRotationX can also be used with rotationX to determine the rotate direction of the device along the X-axis.

---

## pRotationY

**Type:** Property

The system variable pRotationY always contains the rotation of the device along the y axis in the frame previous to the current frame. If the sketch <a href="#/p5/angleMode"> angleMode()</a> is set to DEGREES, the value will be -90 to 90. If it is set to RADIANS, the value will be -PI/2 to PI/2. pRotationY can also be used with rotationY to determine the rotate direction of the device along the Y-axis.

---

## pRotationZ

**Type:** Property

The system variable pRotationZ always contains the rotation of the device along the z axis in the frame previous to the current frame. If the sketch <a href="#/p5/angleMode"> angleMode()</a> is set to DEGREES, the value will be 0 to 360. If it is set to RADIANS, the value will be 0 to 2*PI. pRotationZ can also be used with rotationZ to determine the rotate direction of the device along the Z-axis.

---

## pwinMouseX

**Type:** Property

A `Number` variable that tracks the mouse's previous horizontal position within the browser. `pwinMouseX` keeps track of the mouse's position relative to the top-left corner of the browser window. Its value is <a href="#/p5/winMouseX">winMouseX</a> from the previous frame. For example, if the mouse was 50 pixels from the left edge of the browser during the last frame, then `pwinMouseX` will be 50. On a touchscreen device, `pwinMouseX` will hold the x-coordinate of the most recent touch point. `pwinMouseX` is reset to the current <a href="#/p5/winMouseX">winMouseX</a> value at the start of each touch event. Note: Use <a href="#/p5/pmouseX">pmouseX</a> to track the mouse’s previous x-coordinate within the canvas.

---

## pwinMouseY

**Type:** Property

A `Number` variable that tracks the mouse's previous vertical position within the browser. `pwinMouseY` keeps track of the mouse's position relative to the top-left corner of the browser window. Its value is <a href="#/p5/winMouseY">winMouseY</a> from the previous frame. For example, if the mouse was 50 pixels from the top edge of the browser during the last frame, then `pwinMouseY` will be 50. On a touchscreen device, `pwinMouseY` will hold the y-coordinate of the most recent touch point. `pwinMouseY` is reset to the current <a href="#/p5/winMouseY">winMouseY</a> value at the start of each touch event. Note: Use <a href="#/p5/pmouseY">pmouseY</a> to track the mouse’s previous y-coordinate within the canvas.

---

## requestPointerLock

**Type:** Function

Locks the mouse pointer to its current position and makes it invisible. `requestPointerLock()` allows the mouse to move forever without leaving the screen. Calling `requestPointerLock()` locks the values of <a href="#/p5/mouseX">mouseX</a>, <a href="#/p5/mouseY">mouseY</a>, <a href="#/p5/pmouseX">pmouseX</a>, and <a href="#/p5/pmouseY">pmouseY</a>. <a href="#/p5/movedX">movedX</a> and <a href="#/p5/movedY">movedY</a> continue updating and can be used to get the distance the mouse moved since the last frame was drawn. Calling <a href="#/p5/exitPointerLock">exitPointerLock()</a> resumes updating the mouse system variables. Note: Most browsers require an input, such as a click, before calling `requestPointerLock()`. It’s recommended to call `requestPointerLock()` in an event function such as <a href="#/p5/doubleClicked">doubleClicked()</a>.

---

## rotationX

**Type:** Property

The system variable rotationX always contains the rotation of the device along the x axis. If the sketch <a href="#/p5/angleMode"> angleMode()</a> is set to DEGREES, the value will be -180 to 180. If it is set to RADIANS, the value will be -PI to PI. Note: The order the rotations are called is important, ie. if used together, it must be called in the order Z-X-Y or there might be unexpected behaviour.

---

## rotationY

**Type:** Property

The system variable rotationY always contains the rotation of the device along the y axis. If the sketch <a href="#/p5/angleMode"> angleMode()</a> is set to DEGREES, the value will be -90 to 90. If it is set to RADIANS, the value will be -PI/2 to PI/2. Note: The order the rotations are called is important, ie. if used together, it must be called in the order Z-X-Y or there might be unexpected behaviour.

---

## rotationZ

**Type:** Property

The system variable rotationZ always contains the rotation of the device along the z axis. If the sketch <a href="#/p5/angleMode"> angleMode()</a> is set to DEGREES, the value will be 0 to 360. If it is set to RADIANS, the value will be 0 to 2*PI. Unlike rotationX and rotationY, this variable is available for devices with a built-in compass only. Note: The order the rotations are called is important, ie. if used together, it must be called in the order Z-X-Y or there might be unexpected behaviour.

---

## setMoveThreshold

**Type:** Function

The <a href="#/p5/setMoveThreshold">setMoveThreshold()</a> function is used to set the movement threshold for the <a href="#/p5/deviceMoved">deviceMoved()</a> function. The default threshold is set to 0.5.

### Parameters

- `value`: number - The threshold value

---

## setShakeThreshold

**Type:** Function

The <a href="#/p5/setShakeThreshold">setShakeThreshold()</a> function is used to set the movement threshold for the <a href="#/p5/deviceShaken">deviceShaken()</a> function. The default threshold is set to 30.

### Parameters

- `value`: number - The threshold value

---

## touches

**Type:** Property

An `Array` of all the current touch points on a touchscreen device. The `touches` array is empty by default. When the user touches their screen, a new touch point is tracked and added to the array. Touch points are `Objects` with the following properties: ```js // Iterate over the touches array. for (let touch of touches) { // x-coordinate relative to the top-left // corner of the canvas. console.log(touch.x); // y-coordinate relative to the top-left // corner of the canvas. console.log(touch.y); // x-coordinate relative to the top-left // corner of the browser. console.log(touch.winX); // y-coordinate relative to the top-left // corner of the browser. console.log(touch.winY); // ID number console.log(touch.id); } ```

---

## turnAxis

**Type:** Property

When a device is rotated, the axis that triggers the <a href="#/p5/deviceTurned">deviceTurned()</a> method is stored in the turnAxis variable. The turnAxis variable is only defined within the scope of deviceTurned().

---

## winMouseX

**Type:** Property

A `Number` variable that tracks the mouse's horizontal position within the browser. `winMouseX` keeps track of the mouse's position relative to the top-left corner of the browser window. For example, if the mouse is 50 pixels from the left edge of the browser, then `winMouseX` will be 50. On a touchscreen device, `winMouseX` will hold the x-coordinate of the most recent touch point. Note: Use <a href="#/p5/mouseX">mouseX</a> to track the mouse’s x-coordinate within the canvas.

---

## winMouseY

**Type:** Property

A `Number` variable that tracks the mouse's vertical position within the browser. `winMouseY` keeps track of the mouse's position relative to the top-left corner of the browser window. For example, if the mouse is 50 pixels from the top edge of the browser, then `winMouseY` will be 50. On a touchscreen device, `winMouseY` will hold the y-coordinate of the most recent touch point. Note: Use <a href="#/p5/mouseY">mouseY</a> to track the mouse’s y-coordinate within the canvas.

---

