# Math Module

This module contains 44 symbols from p5.js.

## abs

**Type:** Function

Calculates the absolute value of a number. A number's absolute value is its distance from zero on the number line. -5 and 5 are both five units away from zero, so calling `abs(-5)` and `abs(5)` both return 5. The absolute value of a number is always positive.

### Parameters

- `n`: Number - number to compute.

### Returns

Number - absolute value of given number.

---

## acos

**Type:** Function

Calculates the arc cosine of a number. `acos()` is the inverse of <a href="#/p5/cos">cos()</a>. It expects arguments in the range -1 to 1. By default, `acos()` returns values in the range 0 to &pi; (about 3.14). If the <a href="#/p5/angleMode">angleMode()</a> is `DEGREES`, then values are returned in the range 0 to 180.

### Parameters

- `value`: Number - value whose arc cosine is to be returned.

### Returns

Number - arc cosine of the given value.

---

## Anonymous

**Type:** Class

A class to describe a Quaternion for vector rotations in the p5js webgl renderer. Please refer the following link for details on the implementation https://danceswithcode.net/engineeringnotes/quaternions/quaternions.html

### Parameters

- `{Number} [w] Scalar part of the quaternion`: unknown - No description
- `{Number} [x] x component of imaginary part of quaternion`: unknown - No description
- `{Number} [y] y component of imaginary part of quaternion`: unknown - No description
- `{Number} [z] z component of imaginary part of quaternion`: unknown - No description

---

## asin

**Type:** Function

Calculates the arc sine of a number. `asin()` is the inverse of <a href="#/p5/sin">sin()</a>. It expects input values in the range of -1 to 1. By default, `asin()` returns values in the range -&pi; &divide; 2 (about -1.57) to &pi; &divide; 2 (about 1.57). If the <a href="#/p5/angleMode">angleMode()</a> is `DEGREES` then values are returned in the range -90 to 90.

### Parameters

- `value`: Number - value whose arc sine is to be returned.

### Returns

Number - arc sine of the given value.

---

## atan

**Type:** Function

Calculates the arc tangent of a number. `atan()` is the inverse of <a href="#/p5/tan">tan()</a>. It expects input values in the range of -Infinity to Infinity. By default, `atan()` returns values in the range -&pi; &divide; 2 (about -1.57) to &pi; &divide; 2 (about 1.57). If the <a href="#/p5/angleMode">angleMode()</a> is `DEGREES` then values are returned in the range -90 to 90.

### Parameters

- `value`: Number - value whose arc tangent is to be returned.

### Returns

Number - arc tangent of the given value.

---

## atan2

**Type:** Function

Calculates the angle formed by a point, the origin, and the positive x-axis. `atan2()` is most often used for orienting geometry to the mouse's position, as in `atan2(mouseY, mouseX)`. The first parameter is the point's y-coordinate and the second parameter is its x-coordinate. By default, `atan2()` returns values in the range -&pi; (about -3.14) to &pi; (3.14). If the <a href="#/p5/angleMode">angleMode()</a> is `DEGREES`, then values are returned in the range -180 to 180.

### Parameters

- `y`: Number - y-coordinate of the point.
- `x`: Number - x-coordinate of the point.

### Returns

Number - arc tangent of the given point.

---

## beginShape

**Type:** Function

Begin shape drawing.  This is a helpful way of generating custom shapes quickly.  However in WEBGL mode, application performance will likely drop as a result of too many calls to <a href="#/p5/beginShape">beginShape()</a> / <a href="#/p5/endShape">endShape()</a>.  As a high performance alternative, please use p5.js geometry primitives.

### Parameters

- `mode`: Number - webgl primitives mode.  beginShape supports the

---

## ceil

**Type:** Function

Calculates the closest integer value that is greater than or equal to a number. For example, calling `ceil(9.03)` and `ceil(9.97)` both return the value 10.

### Parameters

- `n`: Number - number to round up.

### Returns

Integer - rounded up number.

---

## constrain

**Type:** Function

Constrains a number between a minimum and maximum value.

### Parameters

- `n`: Number - number to constrain.
- `low`: Number - minimum limit.
- `high`: Number - maximum limit.

### Returns

Number - constrained number.

---

## cos

**Type:** Function

Calculates the cosine of an angle. `cos()` is useful for many geometric tasks in creative coding. The values returned oscillate between -1 and 1 as the input angle increases. `cos()` calculates the cosine of an angle, using radians by default, or according to if <a href="#/p5/angleMode">angleMode()</a> setting (RADIANS or DEGREES).

### Parameters

- `angle`: Number - the angle, in radians by default, or according to

### Returns

Number - cosine of the angle.

---

## createBuffers

**Type:** Property

creates a buffers object that holds the WebGL render buffers for a geometry.

### Parameters

- `gId`: String - key of the geometry object
- `model`: p5.Geometry - contains geometry data

---

## createVector

**Type:** Function

Creates a new <a href="#/p5.Vector">p5.Vector</a> object. A vector can be thought of in different ways. In one view, a vector is like an arrow pointing in space. Vectors have both magnitude (length) and direction. This view is helpful for programming motion. A vector's components determine its magnitude and direction. For example, calling `createVector(3, 4)` creates a new <a href="#/p5.Vector">p5.Vector</a> object with an x-component of 3 and a y-component of 4. From the origin, this vector's tip is 3 units to the right and 4 units down. <a href="#/p5.Vector">p5.Vector</a> objects are often used to program motion because they simplify the math. For example, a moving ball has a position and a velocity. Position describes where the ball is in space. The ball's position vector extends from the origin to the ball's center. Velocity describes the ball's speed and the direction it's moving. If the ball is moving straight up, its velocity vector points straight up. Adding the ball's velocity vector to its position vector moves it, as in `pos.add(vel)`. Vector math relies on methods inside the <a href="#/p5.Vector">p5.Vector</a> class.

### Parameters

- `{Number} [x] x component of the vector.`: unknown - No description
- `{Number} [y] y component of the vector.`: unknown - No description
- `{Number} [z] z component of the vector.`: unknown - No description

### Returns

p5.Vector - new <a href="#/p5.Vector">p5.Vector</a> object.

---

## degrees

**Type:** Function

Converts an angle measured in radians to its value in degrees. Degrees and radians are both units for measuring angles. There are 360˚ in one full rotation. A full rotation is 2 &times; &pi; (about 6.28) radians. The same angle can be expressed in with either unit. For example, 90° is a quarter of a full rotation. The same angle is 2 &times; &pi; &divide; 4 (about 1.57) radians.

### Parameters

- `radians`: Number - radians value to convert to degrees.

### Returns

Number - converted angle.

---

## drawBuffers

**Type:** Property

Draws buffers given a geometry key ID

### Parameters

- `gId`: String - ID in our geom hash

---

## drawBuffersScaled

**Type:** Function

Calls drawBuffers() with a scaled model/view matrix. This is used by various 3d primitive methods (in primitives.js, eg. plane, box, torus, etc...) to allow caching of un-scaled geometries. Those geometries are generally created with unit-length dimensions, cached as such, and then scaled appropriately in this method prior to rendering.

### Parameters

- `gId`: String - ID in our geom hash
- `scaleX`: Number - the amount to scale in the X direction
- `scaleY`: Number - the amount to scale in the Y direction
- `scaleZ`: Number - the amount to scale in the Z direction

---

## endShape

**Type:** Property

End shape drawing and render vertices to screen.

---

## exp

**Type:** Function

Calculates the value of Euler's number e (2.71828...) raised to the power of a number.

### Parameters

- `n`: Number - exponent to raise.

### Returns

Number - e^n

---

## floor

**Type:** Function

Calculates the closest integer value that is less than or equal to the value of a number.

### Parameters

- `n`: Number - number to round down.

### Returns

Integer - rounded down number.

---

## fract

**Type:** Function

Calculates the fractional part of a number. A number's fractional part includes its decimal values. For example, `fract(12.34)` returns 0.34.

### Parameters

- `n`: Number - number whose fractional part will be found.

### Returns

any - No description

---

## lerp

**Type:** Function

Calculates a number between two numbers at a specific increment. The `amt` parameter is the amount to interpolate between the two numbers. 0.0 is equal to the first number, 0.1 is very near the first number, 0.5 is half-way in between, and 1.0 is equal to the second number. The `lerp()` function is convenient for creating motion along a straight path and for drawing dotted lines. If the value of `amt` is less than 0 or more than 1, `lerp()` will return a number outside of the original interval. For example, calling `lerp(0, 10, 1.5)` will return 15.

### Parameters

- `start`: Number - first value.
- `stop`: Number - second value.
- `amt`: Number - number.

### Returns

Number - lerped value.

---

## log

**Type:** Function

Calculates the natural logarithm (the base-e logarithm) of a number. `log()` expects the `n` parameter to be a value greater than 0 because the natural logarithm is defined that way.

### Parameters

- `n`: Number - number greater than 0.

### Returns

Number - natural logarithm of n.

---

## mag

**Type:** Function

Calculates the magnitude, or length, of a vector. A vector can be thought of in different ways. In one view, a vector is a point in space. The vector's components, `x` and `y`, are the point's coordinates `(x, y)`. A vector's magnitude is the distance from the origin `(0, 0)` to `(x, y)`. `mag(x, y)` is a shortcut for calling `dist(0, 0, x, y)`. A vector can also be thought of as an arrow pointing in space. This view is helpful for programming motion. See <a href="#/p5.Vector">p5.Vector</a> for more details. Use <a href="#/p5.Vector/mag">p5.Vector.mag()</a> to calculate the magnitude of a <a href="#/p5.Vector">p5.Vector</a> object.

### Parameters

- `x`: Number - first component.
- `y`: Number - second component.

### Returns

Number - magnitude of vector.

---

## map

**Type:** Function

Re-maps a number from one range to another. For example, calling `map(2, 0, 10, 0, 100)` returns 20. The first three arguments set the original value to 2 and the original range from 0 to 10. The last two arguments set the target range from 0 to 100. 20's position in the target range [0, 100] is proportional to 2's position in the original range [0, 10]. The sixth parameter, `withinBounds`, is optional. By default, `map()` can return values outside of the target range. For example, `map(11, 0, 10, 0, 100)` returns 110. Passing `true` as the sixth parameter constrains the remapped value to the target range. For example, `map(11, 0, 10, 0, 100, true)` returns 100.

### Parameters

- `value`: Number - the value to be remapped.
- `start1`: Number - lower bound of the value's current range.
- `stop1`: Number - upper bound of the value's current range.
- `start2`: Number - lower bound of the value's target range.
- `stop2`: Number - upper bound of the value's target range.
- `{Boolean} [withinBounds] constrain the value to the newly mapped range.`: unknown - No description

### Returns

Number - remapped number.

---

## noise

**Type:** Function

Returns random numbers that can be tuned to feel organic. Values returned by <a href="#/p5/random">random()</a> and <a href="#/p5/randomGaussian">randomGaussian()</a> can change by large amounts between function calls. By contrast, values returned by `noise()` can be made "smooth". Calls to `noise()` with similar inputs will produce similar outputs. `noise()` is used to create textures, motion, shapes, terrains, and so on. Ken Perlin invented `noise()` while animating the original <em>Tron</em> film in the 1980s. `noise()` always returns values between 0 and 1. It returns the same value for a given input while a sketch is running. `noise()` produces different results each time a sketch runs. The <a href="#/p5/noiseSeed">noiseSeed()</a> function can be used to generate the same sequence of Perlin noise values each time a sketch runs. The character of the noise can be adjusted in two ways. The first way is to scale the inputs. `noise()` interprets inputs as coordinates. The sequence of noise values will be smoother when the input coordinates are closer. The second way is to use the <a href="#/p5/noiseDetail">noiseDetail()</a> function. The version of `noise()` with one parameter computes noise values in one dimension. This dimension can be thought of as space, as in `noise(x)`, or time, as in `noise(t)`. The version of `noise()` with two parameters computes noise values in two dimensions. These dimensions can be thought of as space, as in `noise(x, y)`, or space and time, as in `noise(x, t)`. The version of `noise()` with three parameters computes noise values in three dimensions. These dimensions can be thought of as space, as in `noise(x, y, z)`, or space and time, as in `noise(x, y, t)`.

### Parameters

- `x`: Number - x-coordinate in noise space.
- `{Number} [y] y-coordinate in noise space.`: unknown - No description
- `{Number} [z] z-coordinate in noise space.`: unknown - No description

### Returns

Number - Perlin noise value at specified coordinates.

---

## noiseDetail

**Type:** Function

Adjusts the character of the noise produced by the <a href="#/p5/noise">noise()</a> function. Perlin noise values are created by adding layers of noise together. The noise layers, called octaves, are similar to harmonics in music. Lower octaves contribute more to the output signal. They define the overall intensity of the noise. Higher octaves create finer-grained details. By default, noise values are created by combining four octaves. Each higher octave contributes half as much (50% less) compared to its predecessor. `noiseDetail()` changes the number of octaves and the falloff amount. For example, calling `noiseDetail(6, 0.25)` ensures that <a href="#/p5/noise">noise()</a> will use six octaves. Each higher octave will contribute 25% as much (75% less) compared to its predecessor. Falloff values between 0 and 1 are valid. However, falloff values greater than 0.5 might result in noise values greater than 1.

### Parameters

- `lod`: Number - number of octaves to be used by the noise.
- `falloff`: Number - falloff factor for each octave.

---

## noiseSeed

**Type:** Function

Sets the seed value for the <a href="#/p5/noise">noise()</a> function. By default, <a href="#/p5/noise">noise()</a> produces different results each time a sketch is run. Calling `noiseSeed()` with a constant argument, such as `noiseSeed(99)`, makes <a href="#/p5/noise">noise()</a> produce the same results each time a sketch is run.

### Parameters

- `seed`: Number - seed value.

---

## norm

**Type:** Function

Maps a number from one range to a value between 0 and 1. For example, `norm(2, 0, 10)` returns 0.2. 2's position in the original range [0, 10] is proportional to 0.2's position in the range [0, 1]. This is the same as calling `map(2, 0, 10, 0, 1)`. Numbers outside of the original range are not constrained between 0 and 1. Out-of-range values are often intentional and useful.

### Parameters

- `value`: Number - incoming value to be normalized.
- `start`: Number - lower bound of the value's current range.
- `stop`: Number - upper bound of the value's current range.

### Returns

Number - normalized number.

---

## normal

**Type:** Function

Sets the normal to use for subsequent vertices.

### Parameters

- `x`: Number - No description
- `y`: Number - No description
- `z`: Number - No description
- `v`: Vector - No description

---

## pow

**Type:** Function

Calculates exponential expressions such as <var>2<sup>3</sup></var>. For example, `pow(2, 3)` evaluates the expression 2 &times; 2 &times; 2. `pow(2, -3)` evaluates 1 &#247; (2 &times; 2 &times; 2).

### Parameters

- `n`: Number - base of the exponential expression.
- `e`: Number - power by which to raise the base.

### Returns

Number - n^e.

---

## Quat

**Type:** Class

A class to describe a Quaternion for vector rotations in the p5js webgl renderer. Please refer the following link for details on the implementation https://danceswithcode.net/engineeringnotes/quaternions/quaternions.html

### Parameters

- `{Number} [w] Scalar part of the quaternion`: unknown - No description
- `{Number} [x] x component of imaginary part of quaternion`: unknown - No description
- `{Number} [y] y component of imaginary part of quaternion`: unknown - No description
- `{Number} [z] z component of imaginary part of quaternion`: unknown - No description

---

## radians

**Type:** Function

Converts an angle measured in degrees to its value in radians. Degrees and radians are both units for measuring angles. There are 360˚ in one full rotation. A full rotation is 2 &times; &pi; (about 6.28) radians. The same angle can be expressed in with either unit. For example, 90° is a quarter of a full rotation. The same angle is 2 &times; &pi; &divide; 4 (about 1.57) radians.

### Parameters

- `degrees`: Number - degree value to convert to radians.

### Returns

Number - converted angle.

---

## randomGaussian

**Type:** Function

Returns a random number fitting a Gaussian, or normal, distribution. Normal distributions look like bell curves when plotted. Values from a normal distribution cluster around a central value called the mean. The cluster's standard deviation describes its spread. By default, `randomGaussian()` produces different results each time a sketch runs. The <a href="#/p5/randomSeed">randomSeed()</a> function can be used to generate the same sequence of numbers each time a sketch runs. There's no minimum or maximum value that `randomGaussian()` might return. Values far from the mean are very unlikely and values near the mean are very likely. The version of `randomGaussian()` with no parameters returns values with a mean of 0 and standard deviation of 1. The version of `randomGaussian()` with one parameter interprets the argument passed as the mean. The standard deviation is 1. The version of `randomGaussian()` with two parameters interprets the first argument passed as the mean and the second as the standard deviation.

### Parameters

- `{Number} [mean]  mean.`: unknown - No description
- `{Number} [sd]    standard deviation.`: unknown - No description

### Returns

Number - random number.

---

## randomSeed

**Type:** Function

Sets the seed value for the <a href="#/p5/random">random()</a> and <a href="#/p5/randomGaussian">randomGaussian()</a> functions. By default, <a href="#/p5/random">random()</a> and <a href="#/p5/randomGaussian">randomGaussian()</a> produce different results each time a sketch is run. Calling `randomSeed()` with a constant argument, such as `randomSeed(99)`, makes these functions produce the same results each time a sketch is run.

### Parameters

- `seed`: Number - seed value.

---

## round

**Type:** Function

Calculates the integer closest to a number. For example, `round(133.8)` returns the value 134. The second parameter, `decimals`, is optional. It sets the number of decimal places to use when rounding. For example, `round(12.34, 1)` returns 12.3. `decimals` is 0 by default.

### Parameters

- `n`: Number - number to round.
- `{Number} [decimals] number of decimal places to round to, default is 0.`: unknown - No description

### Returns

Integer - rounded number.

---

## shapeMode

**Type:** Function

Begin shape drawing.  This is a helpful way of generating custom shapes quickly.  However in WEBGL mode, application performance will likely drop as a result of too many calls to <a href="#/p5/beginShape">beginShape()</a> / <a href="#/p5/endShape">endShape()</a>.  As a high performance alternative, please use p5.js geometry primitives.

### Parameters

- `mode`: Number - webgl primitives mode.  beginShape supports the

---

## sin

**Type:** Function

Calculates the sine of an angle. `sin()` is useful for many geometric tasks in creative coding. The values returned oscillate between -1 and 1 as the input angle increases. `sin()` calculates the sine of an angle, using radians by default, or according to if <a href="#/p5/angleMode">angleMode()</a> setting (RADIANS or DEGREES).

### Parameters

- `angle`: Number - the angle, in radians by default, or according to

### Returns

Number - sine of the angle.

---

## sq

**Type:** Function

Calculates the square of a number. Squaring a number means multiplying the number by itself. For example, `sq(3)` evaluates 3 &times; 3 which is 9. `sq(-3)` evaluates -3 &times; -3 which is also 9. Multiplying two negative numbers produces a positive number. The value returned by `sq()` is always positive.

### Parameters

- `n`: Number - number to square.

### Returns

Number - squared number.

---

## sqrt

**Type:** Function

Calculates the square root of a number. A number's square root can be multiplied by itself to produce the original number. For example, `sqrt(9)` returns 3 because 3 &times; 3 = 9. `sqrt()` always returns a positive value. `sqrt()` doesn't work with negative arguments such as `sqrt(-9)`.

### Parameters

- `n`: Number - non-negative number to square root.

### Returns

Number - square root of number.

---

## tan

**Type:** Function

Calculates the tangent of an angle. `tan()` is useful for many geometric tasks in creative coding. The values returned range from -Infinity to Infinity and repeat periodically as the input angle increases. `tan()` calculates the tan of an angle, using radians by default, or according to if <a href="#/p5/angleMode">angleMode()</a> setting (RADIANS or DEGREES).

### Parameters

- `angle`: Number - the angle, in radians by default, or according to

### Returns

Number - tangent of the angle.

---

## Vector

**Type:** Class

A class to describe a two or three-dimensional vector. A vector can be thought of in different ways. In one view, a vector is like an arrow pointing in space. Vectors have both magnitude (length) and direction. `p5.Vector` objects are often used to program motion because they simplify the math. For example, a moving ball has a position and a velocity. Position describes where the ball is in space. The ball's position vector extends from the origin to the ball's center. Velocity describes the ball's speed and the direction it's moving. If the ball is moving straight up, its velocity vector points straight up. Adding the ball's velocity vector to its position vector moves it, as in `pos.add(vel)`. Vector math relies on methods inside the `p5.Vector` class. Note: <a href="#/p5/createVector">createVector()</a> is the recommended way to make an instance of this class.

### Parameters

- `{Number} [x] x component of the vector.`: unknown - No description
- `{Number} [y] y component of the vector.`: unknown - No description
- `{Number} [z] z component of the vector.`: unknown - No description

---

## vertex

**Type:** Function

adds a vertex to be drawn in a custom Shape.

### Parameters

- `x`: Number - x-coordinate of vertex
- `y`: Number - y-coordinate of vertex
- `z`: Number - z-coordinate of vertex

---

## x

**Type:** Function

Replaces the components of a <a href="#/p5.Vector">p5.Vector</a> that are very close to zero with zero. In computers, handling numbers with decimals can give slightly imprecise answers due to the way those numbers are represented. This can make it hard to check if a number is zero, as it may be close but not exactly zero. This method rounds very close numbers to zero to make those checks easier https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/EPSILON

### Returns

p5.Vector - with components very close to zero replaced with zero.

---

## y

**Type:** Property

The y component of the vector

---

## z

**Type:** Property

The z component of the vector

---

