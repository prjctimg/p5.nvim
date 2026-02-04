# Transform Module

This module contains 7 symbols from p5.js.

## resetMatrix

**Type:** Function

Clears all transformations applied to the coordinate system.

---

## rotate

**Type:** Function

Rotates the coordinate system. By default, the positive x-axis points to the right and the positive y-axis points downward. The `rotate()` function changes this orientation by rotating the coordinate system about the origin. Everything drawn after `rotate()` is called will appear to be rotated. The first parameter, `angle`, is the amount to rotate. For example, calling `rotate(1)` rotates the coordinate system clockwise 1 radian which is nearly 57˚. `rotate()` interprets angle values using the current <a href="#/p5/angleMode">angleMode()</a>. The second parameter, `axis`, is optional. It's used to orient 3D rotations in WebGL mode. If a <a href="#/p5.Vector">p5.Vector</a> is passed, as in `rotate(QUARTER_PI, myVector)`, then the coordinate system will rotate `QUARTER_PI` radians about `myVector`. If an array of vector components is passed, as in `rotate(QUARTER_PI, [1, 0, 0])`, then the coordinate system will rotate `QUARTER_PI` radians about a vector with the components `[1, 0, 0]`. By default, transformations accumulate. For example, calling `rotate(1)` twice has the same effect as calling `rotate(2)` once. The <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions can be used to isolate transformations within distinct drawing groups. Note: Transformations are reset at the beginning of the draw loop. Calling `rotate(1)` inside the <a href="#/p5/draw">draw()</a> function won't cause shapes to spin.

### Parameters

- `angle`: Number - angle of rotation in the current <a href="#/p5/angleMode">angleMode()</a>.
- `{p5.Vector|Number[]} [axis] axis to rotate about in 3D.`: unknown - No description

---

## rotateX

**Type:** Function

Rotates the coordinate system about the x-axis in WebGL mode. The parameter, `angle`, is the amount to rotate. For example, calling `rotateX(1)` rotates the coordinate system about the x-axis by 1 radian. `rotateX()` interprets angle values using the current <a href="#/p5/angleMode">angleMode()</a>. By default, transformations accumulate. For example, calling `rotateX(1)` twice has the same effect as calling `rotateX(2)` once. The <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions can be used to isolate transformations within distinct drawing groups. Note: Transformations are reset at the beginning of the draw loop. Calling `rotateX(1)` inside the <a href="#/p5/draw">draw()</a> function won't cause shapes to spin.

### Parameters

- `angle`: Number - angle of rotation in the current <a href="#/p5/angleMode">angleMode()</a>.

---

## rotateY

**Type:** Function

Rotates the coordinate system about the y-axis in WebGL mode. The parameter, `angle`, is the amount to rotate. For example, calling `rotateY(1)` rotates the coordinate system about the y-axis by 1 radian. `rotateY()` interprets angle values using the current <a href="#/p5/angleMode">angleMode()</a>. By default, transformations accumulate. For example, calling `rotateY(1)` twice has the same effect as calling `rotateY(2)` once. The <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions can be used to isolate transformations within distinct drawing groups. Note: Transformations are reset at the beginning of the draw loop. Calling `rotateY(1)` inside the <a href="#/p5/draw">draw()</a> function won't cause shapes to spin.

### Parameters

- `angle`: Number - angle of rotation in the current <a href="#/p5/angleMode">angleMode()</a>.

---

## rotateZ

**Type:** Function

Rotates the coordinate system about the z-axis in WebGL mode. The parameter, `angle`, is the amount to rotate. For example, calling `rotateZ(1)` rotates the coordinate system about the z-axis by 1 radian. `rotateZ()` interprets angle values using the current <a href="#/p5/angleMode">angleMode()</a>. By default, transformations accumulate. For example, calling `rotateZ(1)` twice has the same effect as calling `rotateZ(2)` once. The <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions can be used to isolate transformations within distinct drawing groups. Note: Transformations are reset at the beginning of the draw loop. Calling `rotateZ(1)` inside the <a href="#/p5/draw">draw()</a> function won't cause shapes to spin.

### Parameters

- `angle`: Number - angle of rotation in the current <a href="#/p5/angleMode">angleMode()</a>.

---

## shearX

**Type:** Function

Shears the x-axis so that shapes appear skewed. By default, the x- and y-axes are perpendicular. The `shearX()` function transforms the coordinate system so that x-coordinates are translated while y-coordinates are fixed. The first parameter, `angle`, is the amount to shear. For example, calling `shearX(1)` transforms all x-coordinates using the formula `x = x + y * tan(angle)`. `shearX()` interprets angle values using the current <a href="#/p5/angleMode">angleMode()</a>. By default, transformations accumulate. For example, calling `shearX(1)` twice has the same effect as calling `shearX(2)` once. The <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions can be used to isolate transformations within distinct drawing groups. Note: Transformations are reset at the beginning of the draw loop. Calling `shearX(1)` inside the <a href="#/p5/draw">draw()</a> function won't cause shapes to shear continuously.

### Parameters

- `angle`: Number - angle to shear by in the current <a href="#/p5/angleMode">angleMode()</a>.

---

## shearY

**Type:** Function

Shears the y-axis so that shapes appear skewed. By default, the x- and y-axes are perpendicular. The `shearY()` function transforms the coordinate system so that y-coordinates are translated while x-coordinates are fixed. The first parameter, `angle`, is the amount to shear. For example, calling `shearY(1)` transforms all y-coordinates using the formula `y = y + x * tan(angle)`. `shearY()` interprets angle values using the current <a href="#/p5/angleMode">angleMode()</a>. By default, transformations accumulate. For example, calling `shearY(1)` twice has the same effect as calling `shearY(2)` once. The <a href="#/p5/push">push()</a> and <a href="#/p5/pop">pop()</a> functions can be used to isolate transformations within distinct drawing groups. Note: Transformations are reset at the beginning of the draw loop. Calling `shearY(1)` inside the <a href="#/p5/draw">draw()</a> function won't cause shapes to shear continuously.

### Parameters

- `angle`: Number - angle to shear by in the current <a href="#/p5/angleMode">angleMode()</a>.

---

