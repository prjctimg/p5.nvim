# Shape Module

This module contains 52 symbols from p5.js.

## anonymous

**Type:** Function

Flips the geometry’s texture v-coordinates. In order for <a href="#/p5/texture">texture()</a> to work, the geometry needs a way to map the points on its surface to the pixels in a rectangular image that's used as a texture. The geometry's vertex at coordinates `(x, y, z)` maps to the texture image's pixel at coordinates `(u, v)`. The <a href="#/p5.Geometry/uvs">myGeometry.uvs</a> array stores the `(u, v)` coordinates for each vertex in the order it was added to the geometry. Calling `myGeometry.flipV()` flips a geometry's v-coordinates so that the texture appears mirrored vertically. For example, a plane's four vertices are added clockwise starting from the top-left corner. Here's how calling `myGeometry.flipV()` would change a plane's texture coordinates: ```js // Print the original texture coordinates. // Output: [0, 0, 1, 0, 0, 1, 1, 1] console.log(myGeometry.uvs); // Flip the v-coordinates. myGeometry.flipV(); // Print the flipped texture coordinates. // Output: [0, 1, 1, 1, 0, 0, 1, 0] console.log(myGeometry.uvs); // Notice the swaps: // Left vertices: [0, 0] &lt;--&gt; [1, 0] // Right vertices: [1, 0] &lt;--&gt; [1, 1] ```

---

## Anonymous

**Type:** Class

A class to describe a 4×4 matrix for model and view matrix manipulation in the p5js webgl renderer.

### Parameters

- `{Array} [mat4] column-major array literal of our 4×4 matrix`: unknown - No description

---

## arc

**Type:** Function

Draws an arc. An arc is a section of an ellipse defined by the `x`, `y`, `w`, and `h` parameters. `x` and `y` set the location of the arc's center. `w` and `h` set the arc's width and height. See <a href="#/p5/ellipse">ellipse()</a> and <a href="#/p5/ellipseMode">ellipseMode()</a> for more details. The fifth and sixth parameters, `start` and `stop`, set the angles between which to draw the arc. Arcs are always drawn clockwise from `start` to `stop`. The fifth and sixth parameters, start and stop, set the angles between which to draw the arc. By default, angles are given in radians, but if angleMode (DEGREES) is set, the function interprets the values in degrees. The seventh parameter, `mode`, is optional. It determines the arc's fill style. The fill modes are a semi-circle (`OPEN`), a closed semi-circle (`CHORD`), or a closed pie segment (`PIE`). The eighth parameter, `detail`, is also optional. It determines how many vertices are used to draw the arc in WebGL mode. The default value is 25.

### Parameters

- `x`: Number - x-coordinate of the arc's ellipse.
- `y`: Number - y-coordinate of the arc's ellipse.
- `w`: Number - width of the arc's ellipse by default.
- `h`: Number - height of the arc's ellipse by default.
- `start`: Number - angle to start the arc, specified in radians.
- `stop`: Number - angle to stop the arc, specified in radians.
- `{Constant} [mode] optional parameter to determine the way of drawing`: unknown - No description
- `{Integer} [detail] optional parameter for WebGL mode only. This is to`: unknown - No description

---

## beginContour

**Type:** Function

Begins creating a hole within a flat shape. The `beginContour()` and <a href="#/p5/endContour">endContour()</a> functions allow for creating negative space within custom shapes that are flat. `beginContour()` begins adding vertices to a negative space and <a href="#/p5/endContour">endContour()</a> stops adding them. `beginContour()` and <a href="#/p5/endContour">endContour()</a> must be called between <a href="#/p5/beginShape">beginShape()</a> and <a href="#/p5/endShape">endShape()</a>. Transformations such as <a href="#/p5/translate">translate()</a>, <a href="#/p5/rotate">rotate()</a>, and <a href="#/p5/scale">scale()</a> don't work between `beginContour()` and <a href="#/p5/endContour">endContour()</a>. It's also not possible to use other shapes, such as <a href="#/p5/ellipse">ellipse()</a> or <a href="#/p5/rect">rect()</a>, between `beginContour()` and <a href="#/p5/endContour">endContour()</a>. Note: The vertices that define a negative space must "wind" in the opposite direction from the outer shape. First, draw vertices for the outer shape clockwise order. Then, draw vertices for the negative space in counter-clockwise order.

---

## beginGeometry

**Type:** Function

Begins adding shapes to a new <a href="#/p5.Geometry">p5.Geometry</a> object. The `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> functions help with creating complex 3D shapes from simpler ones such as <a href="#/p5/sphere">sphere()</a>. `beginGeometry()` begins adding shapes to a custom <a href="#/p5.Geometry">p5.Geometry</a> object and <a href="#/p5/endGeometry">endGeometry()</a> stops adding them. `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> can help to make sketches more performant. For example, if a complex 3D shape doesn’t change while a sketch runs, then it can be created with `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a>. Creating a <a href="#/p5.Geometry">p5.Geometry</a> object once and then drawing it will run faster than repeatedly drawing the individual pieces. See <a href="#/p5/buildGeometry">buildGeometry()</a> for another way to build 3D shapes. Note: `beginGeometry()` can only be used in WebGL mode.

---

## beginShape

**Type:** Function

Begins adding vertices to a custom shape. The `beginShape()` and <a href="#/p5/endShape">endShape()</a> functions allow for creating custom shapes in 2D or 3D. `beginShape()` begins adding vertices to a custom shape and <a href="#/p5/endShape">endShape()</a> stops adding them. The parameter, `kind`, sets the kind of shape to make. By default, any irregular polygon can be drawn. The available modes for kind are: - `POINTS` to draw a series of points. - `LINES` to draw a series of unconnected line segments. - `TRIANGLES` to draw a series of separate triangles. - `TRIANGLE_FAN` to draw a series of connected triangles sharing the first vertex in a fan-like fashion. - `TRIANGLE_STRIP` to draw a series of connected triangles in strip fashion. - `QUADS` to draw a series of separate quadrilaterals (quads). - `QUAD_STRIP` to draw quad strip using adjacent edges to form the next quad. - `TESS` to create a filling curve by explicit tessellation (WebGL only). After calling `beginShape()`, shapes can be built by calling <a href="#/p5/vertex">vertex()</a>, <a href="#/p5/bezierVertex">bezierVertex()</a>, <a href="#/p5/quadraticVertex">quadraticVertex()</a>, and/or <a href="#/p5/curveVertex">curveVertex()</a>. Calling <a href="#/p5/endShape">endShape()</a> will stop adding vertices to the shape. Each shape will be outlined with the current stroke color and filled with the current fill color. Transformations such as <a href="#/p5/translate">translate()</a>, <a href="#/p5/rotate">rotate()</a>, and <a href="#/p5/scale">scale()</a> don't work between `beginShape()` and <a href="#/p5/endShape">endShape()</a>. It's also not possible to use other shapes, such as <a href="#/p5/ellipse">ellipse()</a> or <a href="#/p5/rect">rect()</a>, between `beginShape()` and <a href="#/p5/endShape">endShape()</a>.

### Parameters

- `{Constant} [kind] either POINTS, LINES, TRIANGLES, TRIANGLE_FAN`: unknown - No description

---

## bezierDetail

**Type:** Function

Sets the number of segments used to draw Bézier curves in WebGL mode. In WebGL mode, smooth shapes are drawn using many flat segments. Adding more flat segments makes shapes appear smoother. The parameter, `detail`, is the number of segments to use while drawing a Bézier curve. For example, calling `bezierDetail(5)` will use 5 segments to draw curves with the <a href="#/p5/bezier">bezier()</a> function. By default,`detail` is 20. Note: `bezierDetail()` has no effect in 2D mode.

### Parameters

- `detail`: Number - number of segments to use. Defaults to 20.

---

## bezierPoint

**Type:** Function

Calculates coordinates along a Bézier curve using interpolation. `bezierPoint()` calculates coordinates along a Bézier curve using the anchor and control points. It expects points in the same order as the <a href="#/p5/bezier">bezier()</a> function. `bezierPoint()` works one axis at a time. Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a point on the curve. Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a point on the curve. The first parameter, `a`, is the coordinate of the first anchor point. The second and third parameters, `b` and `c`, are the coordinates of the control points. The fourth parameter, `d`, is the coordinate of the last anchor point. The fifth parameter, `t`, is the amount to interpolate along the curve. 0 is the first anchor point, 1 is the second anchor point, and 0.5 is halfway between them.

### Parameters

- `a`: Number - coordinate of first anchor point.
- `b`: Number - coordinate of first control point.
- `c`: Number - coordinate of second control point.
- `d`: Number - coordinate of second anchor point.
- `t`: Number - amount to interpolate between 0 and 1.

### Returns

Number - coordinate of the point on the curve.

---

## bezierTangent

**Type:** Function

Calculates coordinates along a line that's tangent to a Bézier curve. Tangent lines skim the surface of a curve. A tangent line's slope equals the curve's slope at the point where it intersects. `bezierTangent()` calculates coordinates along a tangent line using the Bézier curve's anchor and control points. It expects points in the same order as the <a href="#/p5/bezier">bezier()</a> function. `bezierTangent()` works one axis at a time. Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a point on the tangent line. Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a point on the tangent line. The first parameter, `a`, is the coordinate of the first anchor point. The second and third parameters, `b` and `c`, are the coordinates of the control points. The fourth parameter, `d`, is the coordinate of the last anchor point. The fifth parameter, `t`, is the amount to interpolate along the curve. 0 is the first anchor point, 1 is the second anchor point, and 0.5 is halfway between them.

### Parameters

- `a`: Number - coordinate of first anchor point.
- `b`: Number - coordinate of first control point.
- `c`: Number - coordinate of second control point.
- `d`: Number - coordinate of second anchor point.
- `t`: Number - amount to interpolate between 0 and 1.

### Returns

Number - coordinate of a point on the tangent line.

---

## box

**Type:** Function

Draws a box (rectangular prism). A box is a 3D shape with six faces. Each face makes a 90˚ with four neighboring faces. The first parameter, `width`, is optional. If a `Number` is passed, as in `box(20)`, it sets the box’s width and height. By default, `width` is 50. The second parameter, `height`, is also optional. If a `Number` is passed, as in `box(20, 30)`, it sets the box’s height. By default, `height` is set to the box’s `width`. The third parameter, `depth`, is also optional. If a `Number` is passed, as in `box(20, 30, 40)`, it sets the box’s depth. By default, `depth` is set to the box’s `height`. The fourth parameter, `detailX`, is also optional. If a `Number` is passed, as in `box(20, 30, 40, 5)`, it sets the number of triangle subdivisions to use along the x-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailX` is 1. The fifth parameter, `detailY`, is also optional. If a number is passed, as in `box(20, 30, 40, 5, 7)`, it sets the number of triangle subdivisions to use along the y-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailY` is 1. Note: `box()` can only be used in WebGL mode.

### Parameters

- `{Number} [width]     width of the box.`: unknown - No description
- `{Number} [height]    height of the box.`: unknown - No description
- `{Number} [depth]     depth of the box.`: unknown - No description
- `{Integer} [detailX]   number of triangle subdivisions along the x-axis.`: unknown - No description
- `{Integer} [detailY]   number of triangle subdivisions along the y-axis.`: unknown - No description

---

## buildGeometry

**Type:** Function

Creates a custom <a href="#/p5.Geometry">p5.Geometry</a> object from simpler 3D shapes. `buildGeometry()` helps with creating complex 3D shapes from simpler ones such as <a href="#/p5/sphere">sphere()</a>. It can help to make sketches more performant. For example, if a complex 3D shape doesn’t change while a sketch runs, then it can be created with `buildGeometry()`. Creating a <a href="#/p5.Geometry">p5.Geometry</a> object once and then drawing it will run faster than repeatedly drawing the individual pieces. The parameter, `callback`, is a function with the drawing instructions for the new <a href="#/p5.Geometry">p5.Geometry</a> object. It will be called once to create the new 3D shape. See <a href="#/p5/beginGeometry">beginGeometry()</a> and <a href="#/p5/endGeometry">endGeometry()</a> for another way to build 3D shapes. Note: `buildGeometry()` can only be used in WebGL mode.

### Parameters

- `callback`: Function - function that draws the shape.

### Returns

any - No description

---

## circle

**Type:** Function

Draws a circle. A circle is a round shape defined by the `x`, `y`, and `d` parameters. `x` and `y` set the location of its center. `d` sets its width and height (diameter). Every point on the circle's edge is the same distance, `0.5 * d`, from its center. `0.5 * d` (half the diameter) is the circle's radius. See <a href="#/p5/ellipseMode">ellipseMode()</a> for other ways to set its position.

### Parameters

- `x`: Number - x-coordinate of the center of the circle.
- `y`: Number - y-coordinate of the center of the circle.
- `d`: Number - diameter of the circle.

---

## cone

**Type:** Function

Draws a cone. A cone is a 3D shape with triangular faces that connect a flat bottom to a single point. Cones with few faces look like pyramids. Cones with many faces have smooth surfaces. The first parameter, `radius`, is optional. If a `Number` is passed, as in `cone(20)`, it sets the radius of the cone’s base. By default, `radius` is 50. The second parameter, `height`, is also optional. If a `Number` is passed, as in `cone(20, 30)`, it sets the cone’s height. By default, `height` is set to the cone’s `radius`. The third parameter, `detailX`, is also optional. If a `Number` is passed, as in `cone(20, 30, 5)`, it sets the number of edges used to form the cone's base. Using more edges makes the base look more like a circle. By default, `detailX` is 24. The fourth parameter, `detailY`, is also optional. If a `Number` is passed, as in `cone(20, 30, 5, 7)`, it sets the number of triangle subdivisions to use along the y-axis connecting the base to the tip. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailY` is 1. The fifth parameter, `cap`, is also optional. If a `false` is passed, as in `cone(20, 30, 5, 7, false)` the cone’s base won’t be drawn. By default, `cap` is `true`. Note: `cone()` can only be used in WebGL mode.

### Parameters

- `{Number}  [radius]  radius of the cone's base. Defaults to 50.`: unknown - No description
- `{Number}  [height]  height of the cone. Defaults to the value of `radius`.`: unknown - No description
- `{Integer} [detailX] number of edges used to draw the base. Defaults to 24.`: unknown - No description
- `{Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 1.`: unknown - No description
- `{Boolean} [cap]     whether to draw the cone's base.  Defaults to `true`.`: unknown - No description

---

## curveDetail

**Type:** Function

Sets the number of segments used to draw spline curves in WebGL mode. In WebGL mode, smooth shapes are drawn using many flat segments. Adding more flat segments makes shapes appear smoother. The parameter, `detail`, is the number of segments to use while drawing a spline curve. For example, calling `curveDetail(5)` will use 5 segments to draw curves with the <a href="#/p5/curve">curve()</a> function. By default,`detail` is 20. Note: `curveDetail()` has no effect in 2D mode.

### Parameters

- `resolution`: Number - number of segments to use. Defaults to 20.

---

## curvePoint

**Type:** Function

Calculates coordinates along a spline curve using interpolation. `curvePoint()` calculates coordinates along a spline curve using the anchor and control points. It expects points in the same order as the <a href="#/p5/curve">curve()</a> function. `curvePoint()` works one axis at a time. Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a point on the curve. Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a point on the curve. The first parameter, `a`, is the coordinate of the first control point. The second and third parameters, `b` and `c`, are the coordinates of the anchor points. The fourth parameter, `d`, is the coordinate of the last control point. The fifth parameter, `t`, is the amount to interpolate along the curve. 0 is the first anchor point, 1 is the second anchor point, and 0.5 is halfway between them.

### Parameters

- `a`: Number - coordinate of first control point.
- `b`: Number - coordinate of first anchor point.
- `c`: Number - coordinate of second anchor point.
- `d`: Number - coordinate of second control point.
- `t`: Number - amount to interpolate between 0 and 1.

### Returns

Number - coordinate of a point on the curve.

---

## curveTangent

**Type:** Function

Calculates coordinates along a line that's tangent to a spline curve. Tangent lines skim the surface of a curve. A tangent line's slope equals the curve's slope at the point where it intersects. `curveTangent()` calculates coordinates along a tangent line using the spline curve's anchor and control points. It expects points in the same order as the <a href="#/p5/curve">curve()</a> function. `curveTangent()` works one axis at a time. Passing the anchor and control points' x-coordinates will calculate the x-coordinate of a point on the tangent line. Passing the anchor and control points' y-coordinates will calculate the y-coordinate of a point on the tangent line. The first parameter, `a`, is the coordinate of the first control point. The second and third parameters, `b` and `c`, are the coordinates of the anchor points. The fourth parameter, `d`, is the coordinate of the last control point. The fifth parameter, `t`, is the amount to interpolate along the curve. 0 is the first anchor point, 1 is the second anchor point, and 0.5 is halfway between them.

### Parameters

- `a`: Number - coordinate of first control point.
- `b`: Number - coordinate of first anchor point.
- `c`: Number - coordinate of second anchor point.
- `d`: Number - coordinate of second control point.
- `t`: Number - amount to interpolate between 0 and 1.

### Returns

Number - coordinate of a point on the tangent line.

---

## curveTightness

**Type:** Function

Adjusts the way <a href="#/p5/curve">curve()</a> and <a href="#/p5/curveVertex">curveVertex()</a> draw. Spline curves are like cables that are attached to a set of points. `curveTightness()` adjusts how tightly the cable is attached to the points. The parameter, `tightness`, determines how the curve fits to the vertex points. By default, `tightness` is set to 0. Setting tightness to 1, as in `curveTightness(1)`, connects the curve's points using straight lines. Values in the range from –5 to  5 deform curves while leaving them recognizable.

### Parameters

- `amount`: Number - amount of tightness.

---

## cylinder

**Type:** Function

Draws a cylinder. A cylinder is a 3D shape with triangular faces that connect a flat bottom to a flat top. Cylinders with few faces look like boxes. Cylinders with many faces have smooth surfaces. The first parameter, `radius`, is optional. If a `Number` is passed, as in `cylinder(20)`, it sets the radius of the cylinder’s base. By default, `radius` is 50. The second parameter, `height`, is also optional. If a `Number` is passed, as in `cylinder(20, 30)`, it sets the cylinder’s height. By default, `height` is set to the cylinder’s `radius`. The third parameter, `detailX`, is also optional. If a `Number` is passed, as in `cylinder(20, 30, 5)`, it sets the number of edges used to form the cylinder's top and bottom. Using more edges makes the top and bottom look more like circles. By default, `detailX` is 24. The fourth parameter, `detailY`, is also optional. If a `Number` is passed, as in `cylinder(20, 30, 5, 2)`, it sets the number of triangle subdivisions to use along the y-axis, between cylinder's the top and bottom. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailY` is 1. The fifth parameter, `bottomCap`, is also optional. If a `false` is passed, as in `cylinder(20, 30, 5, 2, false)` the cylinder’s bottom won’t be drawn. By default, `bottomCap` is `true`. The sixth parameter, `topCap`, is also optional. If a `false` is passed, as in `cylinder(20, 30, 5, 2, false, false)` the cylinder’s top won’t be drawn. By default, `topCap` is `true`. Note: `cylinder()` can only be used in WebGL mode.

### Parameters

- `{Number}  [radius]    radius of the cylinder. Defaults to 50.`: unknown - No description
- `{Number}  [height]    height of the cylinder. Defaults to the value of `radius`.`: unknown - No description
- `{Integer} [detailX]   number of edges along the top and bottom. Defaults to 24.`: unknown - No description
- `{Integer} [detailY]   number of triangle subdivisions along the y-axis. Defaults to 1.`: unknown - No description
- `{Boolean} [bottomCap] whether to draw the cylinder's bottom. Defaults to `true`.`: unknown - No description
- `{Boolean} [topCap]    whether to draw the cylinder's top. Defaults to `true`.`: unknown - No description

---

## ellipseMode

**Type:** Function

Changes where ellipses, circles, and arcs are drawn. By default, the first two parameters of <a href="#/p5/ellipse">ellipse()</a>, <a href="#/p5/circle">circle()</a>, and <a href="#/p5/arc">arc()</a> are the x- and y-coordinates of the shape's center. The next parameters set the shape's width and height. This is the same as calling `ellipseMode(CENTER)`. `ellipseMode(RADIUS)` also uses the first two parameters to set the x- and y-coordinates of the shape's center. The next parameters are half of the shapes's width and height. Calling `ellipse(0, 0, 10, 15)` draws a shape with a width of 20 and height of 30. `ellipseMode(CORNER)` uses the first two parameters as the upper-left corner of the shape. The next parameters are its width and height. `ellipseMode(CORNERS)` uses the first two parameters as the location of one corner of the ellipse's bounding box. The next parameters are the location of the opposite corner. The argument passed to `ellipseMode()` must be written in ALL CAPS because the constants `CENTER`, `RADIUS`, `CORNER`, and `CORNERS` are defined this way. JavaScript is a case-sensitive language.

### Parameters

- `mode`: Constant - either CENTER, RADIUS, CORNER, or CORNERS

---

## ellipsoid

**Type:** Function

Draws an ellipsoid. An ellipsoid is a 3D shape with triangular faces that connect to form a round surface. Ellipsoids with few faces look like crystals. Ellipsoids with many faces have smooth surfaces and look like eggs. `ellipsoid()` defines a shape by its radii. This is different from <a href="#/p5/ellipse">ellipse()</a> which uses diameters (width and height). The first parameter, `radiusX`, is optional. If a `Number` is passed, as in `ellipsoid(20)`, it sets the radius of the ellipsoid along the x-axis. By default, `radiusX` is 50. The second parameter, `radiusY`, is also optional. If a `Number` is passed, as in `ellipsoid(20, 30)`, it sets the ellipsoid’s radius along the y-axis. By default, `radiusY` is set to the ellipsoid’s `radiusX`. The third parameter, `radiusZ`, is also optional. If a `Number` is passed, as in `ellipsoid(20, 30, 40)`, it sets the ellipsoid’s radius along the z-axis. By default, `radiusZ` is set to the ellipsoid’s `radiusY`. The fourth parameter, `detailX`, is also optional. If a `Number` is passed, as in `ellipsoid(20, 30, 40, 5)`, it sets the number of triangle subdivisions to use along the x-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailX` is 24. The fifth parameter, `detailY`, is also optional. If a `Number` is passed, as in `ellipsoid(20, 30, 40, 5, 7)`, it sets the number of triangle subdivisions to use along the y-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailY` is 16. Note: `ellipsoid()` can only be used in WebGL mode.

### Parameters

- `{Number} [radiusX]  radius of the ellipsoid along the x-axis. Defaults to 50.`: unknown - No description
- `{Number} [radiusY]  radius of the ellipsoid along the y-axis. Defaults to `radiusX`.`: unknown - No description
- `{Number} [radiusZ]  radius of the ellipsoid along the z-axis. Defaults to `radiusY`.`: unknown - No description
- `{Integer} [detailX] number of triangle subdivisions along the x-axis. Defaults to 24.`: unknown - No description
- `{Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 16.`: unknown - No description

---

## endContour

**Type:** Function

Stops creating a hole within a flat shape. The <a href="#/p5/beginContour">beginContour()</a> and `endContour()` functions allow for creating negative space within custom shapes that are flat. <a href="#/p5/beginContour">beginContour()</a> begins adding vertices to a negative space and `endContour()` stops adding them. <a href="#/p5/beginContour">beginContour()</a> and `endContour()` must be called between <a href="#/p5/beginShape">beginShape()</a> and <a href="#/p5/endShape">endShape()</a>. Transformations such as <a href="#/p5/translate">translate()</a>, <a href="#/p5/rotate">rotate()</a>, and <a href="#/p5/scale">scale()</a> don't work between <a href="#/p5/beginContour">beginContour()</a> and `endContour()`. It's also not possible to use other shapes, such as <a href="#/p5/ellipse">ellipse()</a> or <a href="#/p5/rect">rect()</a>, between <a href="#/p5/beginContour">beginContour()</a> and `endContour()`. Note: The vertices that define a negative space must "wind" in the opposite direction from the outer shape. First, draw vertices for the outer shape clockwise order. Then, draw vertices for the negative space in counter-clockwise order.

---

## endGeometry

**Type:** Function

Stops adding shapes to a new <a href="#/p5.Geometry">p5.Geometry</a> object and returns the object. The `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> functions help with creating complex 3D shapes from simpler ones such as <a href="#/p5/sphere">sphere()</a>. `beginGeometry()` begins adding shapes to a custom <a href="#/p5.Geometry">p5.Geometry</a> object and <a href="#/p5/endGeometry">endGeometry()</a> stops adding them. `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a> can help to make sketches more performant. For example, if a complex 3D shape doesn’t change while a sketch runs, then it can be created with `beginGeometry()` and <a href="#/p5/endGeometry">endGeometry()</a>. Creating a <a href="#/p5.Geometry">p5.Geometry</a> object once and then drawing it will run faster than repeatedly drawing the individual pieces. See <a href="#/p5/buildGeometry">buildGeometry()</a> for another way to build 3D shapes. Note: `endGeometry()` can only be used in WebGL mode.

### Returns

any - No description

---

## endShape

**Type:** Function

Stops adding vertices to a custom shape. The <a href="#/p5/beginShape">beginShape()</a> and `endShape()` functions allow for creating custom shapes in 2D or 3D. <a href="#/p5/beginShape">beginShape()</a> begins adding vertices to a custom shape and `endShape()` stops adding them. The first parameter, `mode`, is optional. By default, the first and last vertices of a shape aren't connected. If the constant `CLOSE` is passed, as in `endShape(CLOSE)`, then the first and last vertices will be connected. The second parameter, `count`, is also optional. In WebGL mode, it’s more efficient to draw many copies of the same shape using a technique called <a href="https://webglfundamentals.org/webgl/lessons/webgl-instanced-drawing.html" target="_blank">instancing</a>. The `count` parameter tells WebGL mode how many copies to draw. For example, calling `endShape(CLOSE, 400)` after drawing a custom shape will make it efficient to draw 400 copies. This feature requires <a href="https://p5js.org/tutorials/intro-to-shaders/" target="_blank">writing a custom shader</a>. After calling <a href="#/p5/beginShape">beginShape()</a>, shapes can be built by calling <a href="#/p5/vertex">vertex()</a>, <a href="#/p5/bezierVertex">bezierVertex()</a>, <a href="#/p5/quadraticVertex">quadraticVertex()</a>, and/or <a href="#/p5/curveVertex">curveVertex()</a>. Calling `endShape()` will stop adding vertices to the shape. Each shape will be outlined with the current stroke color and filled with the current fill color. Transformations such as <a href="#/p5/translate">translate()</a>, <a href="#/p5/rotate">rotate()</a>, and <a href="#/p5/scale">scale()</a> don't work between <a href="#/p5/beginShape">beginShape()</a> and `endShape()`. It's also not possible to use other shapes, such as <a href="#/p5/ellipse">ellipse()</a> or <a href="#/p5/rect">rect()</a>, between <a href="#/p5/beginShape">beginShape()</a> and `endShape()`.

### Parameters

- `{Constant} [mode] use CLOSE to close the shape`: unknown - No description
- `{Integer} [count] number of times you want to draw/instance the shape (for WebGL mode).`: unknown - No description

---

## faces

**Type:** Property

An array that lists which of the geometry's vertices form each of its faces. All 3D shapes are made by connecting sets of points called *vertices*. A geometry's surface is formed by connecting vertices to form triangles that are stitched together. Each triangular patch on the geometry's surface is called a *face*. The geometry's vertices are stored as <a href="#/p5.Vector">p5.Vector</a> objects in the <a href="#/p5.Geometry/vertices">myGeometry.vertices</a> array. The geometry's first vertex is the <a href="#/p5.Vector">p5.Vector</a> object at `myGeometry.vertices[0]`, its second vertex is `myGeometry.vertices[1]`, its third vertex is `myGeometry.vertices[2]`, and so on. For example, a geometry made from a rectangle has two faces because a rectangle is made by joining two triangles. `myGeometry.faces` for a rectangle would be the two-dimensional array `[[0, 1, 2], [2, 1, 3]]`. The first face, `myGeometry.faces[0]`, is the array `[0, 1, 2]` because it's formed by connecting `myGeometry.vertices[0]`, `myGeometry.vertices[1]`,and `myGeometry.vertices[2]`. The second face, `myGeometry.faces[1]`, is the array `[2, 1, 3]` because it's formed by connecting `myGeometry.vertices[2]`, `myGeometry.vertices[1]`,and `myGeometry.vertices[3]`.

---

## freeGeometry

**Type:** Function

Clears a <a href="#/p5.Geometry">p5.Geometry</a> object from the graphics processing unit (GPU) memory. <a href="#/p5.Geometry">p5.Geometry</a> objects can contain lots of data about their vertices, surface normals, colors, and so on. Complex 3D shapes can use lots of memory which is a limited resource in many GPUs. Calling `freeGeometry()` can improve performance by freeing a <a href="#/p5.Geometry">p5.Geometry</a> object’s resources from GPU memory. `freeGeometry()` works with <a href="#/p5.Geometry">p5.Geometry</a> objects created with <a href="#/p5/beginGeometry">beginGeometry()</a> and <a href="#/p5/endGeometry">endGeometry()</a>, <a href="#/p5/buildGeometry">buildGeometry()</a>, and <a href="#/p5/loadModel">loadModel()</a>. The parameter, `geometry`, is the <a href="#/p5.Geometry">p5.Geometry</a> object to be freed. Note: A <a href="#/p5.Geometry">p5.Geometry</a> object can still be drawn after its resources are cleared from GPU memory. It may take longer to draw the first time it’s redrawn. Note: `freeGeometry()` can only be used in WebGL mode.

### Parameters

- `geometry`: p5.Geometry - 3D shape whose resources should be freed.

---

## Geometry

**Type:** Class

A class to describe a 3D shape. Each `p5.Geometry` object represents a 3D shape as a set of connected points called *vertices*. All 3D shapes are made by connecting vertices to form triangles that are stitched together. Each triangular patch on the geometry's surface is called a *face*. The geometry stores information about its vertices and faces for use with effects such as lighting and texture mapping. The first parameter, `detailX`, is optional. If a number is passed, as in `new p5.Geometry(24)`, it sets the number of triangle subdivisions to use along the geometry's x-axis. By default, `detailX` is 1. The second parameter, `detailY`, is also optional. If a number is passed, as in `new p5.Geometry(24, 16)`, it sets the number of triangle subdivisions to use along the geometry's y-axis. By default, `detailX` is 1. The third parameter, `callback`, is also optional. If a function is passed, as in `new p5.Geometry(24, 16, createShape)`, it will be called once to add vertices to the new 3D shape.

### Parameters

- `{Integer} [detailX] number of vertices along the x-axis.`: unknown - No description
- `{Integer} [detailY] number of vertices along the y-axis.`: unknown - No description
- `{function} [callback] function to call once the geometry is created.`: unknown - No description

---

## isBinary

**Type:** Function

This function checks if the file is in ASCII format or in Binary format It is done by searching keyword `solid` at the start of the file. An ASCII STL data must begin with `solid` as the first six bytes. However, ASCII STLs lacking the SPACE after the `d` are known to be plentiful. So, check the first 5 bytes for `solid`. Several encodings, such as UTF-8, precede the text with up to 5 bytes: https://en.wikipedia.org/wiki/Byte_order_mark#Byte_order_marks_by_encoding Search for `solid` to start anywhere after those prefixes.

---

## length

**Type:** Property

Create a 2D array for establishing stroke connections

---

## line

**Type:** Property

Draw a line given two points

### Parameters

- `x0`: Number - x-coordinate of first vertex
- `y0`: Number - y-coordinate of first vertex
- `z0`: Number - z-coordinate of first vertex
- `x1`: Number - x-coordinate of second vertex
- `y1`: Number - y-coordinate of second vertex
- `z1`: Number - z-coordinate of second vertex

---

## matchDataViewAt

**Type:** Function

This function matches the `query` at the provided `offset`

---

## Matrix

**Type:** Class

A class to describe a 4×4 matrix for model and view matrix manipulation in the p5js webgl renderer.

### Parameters

- `{Array} [mat4] column-major array literal of our 4×4 matrix`: unknown - No description

---

## model

**Type:** Function

Draws a <a href="#/p5.Geometry">p5.Geometry</a> object to the canvas. The parameter, `model`, is the <a href="#/p5.Geometry">p5.Geometry</a> object to draw. <a href="#/p5.Geometry">p5.Geometry</a> objects can be built with <a href="#/p5/buildGeometry">buildGeometry()</a>, or <a href="#/p5/beginGeometry">beginGeometry()</a> and <a href="#/p5/endGeometry">endGeometry()</a>. They can also be loaded from a file with <a href="#/p5/loadGeometry">loadGeometry()</a>. Note: `model()` can only be used in WebGL mode.

### Parameters

- `model`: p5.Geometry - 3D shape to be drawn.

---

## nextGeometryId

**Type:** Property

Keeps track of how many custom geometry objects have been made so that each can be assigned a unique ID.

---

## noSmooth

**Type:** Function

Draws certain features with jagged (aliased) edges. <a href="#/p5/smooth">smooth()</a> is active by default. In 2D mode, `noSmooth()` is helpful for scaling up images without blurring. The functions don't affect shapes or fonts. In WebGL mode, `noSmooth()` causes all shapes to be drawn with jagged (aliased) edges. The functions don't affect images or fonts.

---

## parseASCIISTL

**Type:** Function

ASCII STL file starts with `solid 'nameOfFile'` Then contain the normal of the face, starting with `facet normal` Next contain a keyword indicating the start of face vertex, `outer loop` Next comes the three vertex, starting with `vertex x y z` Vertices ends with `endloop` Face ends with `endfacet` Next face starts with `facet normal` The end of the file is indicated by `endsolid`

---

## parseBinarySTL

**Type:** Function

This function parses the Binary STL files. https://en.wikipedia.org/wiki/STL_%28file_format%29#Binary_STL Currently there is no support for the colors provided in STL files.

---

## parseObj

**Type:** Function

Parse OBJ lines into model. For reference, this is what a simple model of a square might look like: v -0.5 -0.5 0.5 v -0.5 -0.5 -0.5 v -0.5 0.5 -0.5 v -0.5 0.5 0.5 f 4 3 2 1

---

## parseSTL

**Type:** Function

STL files can be of two types, ASCII and Binary, We need to convert the arrayBuffer to an array of strings, to parse it as an ASCII file.

---

## plane

**Type:** Function

Draws a plane. A plane is a four-sided, flat shape with every angle measuring 90˚. It’s similar to a rectangle and offers advanced drawing features in WebGL mode. The first parameter, `width`, is optional. If a `Number` is passed, as in `plane(20)`, it sets the plane’s width and height. By default, `width` is 50. The second parameter, `height`, is also optional. If a `Number` is passed, as in `plane(20, 30)`, it sets the plane’s height. By default, `height` is set to the plane’s `width`. The third parameter, `detailX`, is also optional. If a `Number` is passed, as in `plane(20, 30, 5)` it sets the number of triangle subdivisions to use along the x-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailX` is 1. The fourth parameter, `detailY`, is also optional. If a `Number` is passed, as in `plane(20, 30, 5, 7)` it sets the number of triangle subdivisions to use along the y-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailY` is 1. Note: `plane()` can only be used in WebGL mode.

### Parameters

- `{Number} [width]    width of the plane.`: unknown - No description
- `{Number} [height]   height of the plane.`: unknown - No description
- `{Integer} [detailX] number of triangle subdivisions along the x-axis.`: unknown - No description
- `{Integer} [detailY]  number of triangle subdivisions along the y-axis.`: unknown - No description

---

## point

**Type:** Property

Draws a point, a coordinate in space at the dimension of one pixel, given x, y and z coordinates. The color of the point is determined by the current stroke, while the point size is determined by current stroke weight.

### Parameters

- `x`: Number - x-coordinate of point
- `y`: Number - y-coordinate of point
- `z`: Number - z-coordinate of point

---

## rectMode

**Type:** Function

Changes where rectangles and squares are drawn. By default, the first two parameters of <a href="#/p5/rect">rect()</a> and <a href="#/p5/square">square()</a>, are the x- and y-coordinates of the shape's upper left corner. The next parameters set the shape's width and height. This is the same as calling `rectMode(CORNER)`. `rectMode(CORNERS)` also uses the first two parameters as the location of one of the corners. The next parameters are the location of the opposite corner. This mode only works for <a href="#/p5/rect">rect()</a>. `rectMode(CENTER)` uses the first two parameters as the x- and y-coordinates of the shape's center. The next parameters are its width and height. `rectMode(RADIUS)` also uses the first two parameters as the x- and y-coordinates of the shape's center. The next parameters are half of the shape's width and height. The argument passed to `rectMode()` must be written in ALL CAPS because the constants `CENTER`, `RADIUS`, `CORNER`, and `CORNERS` are defined this way. JavaScript is a case-sensitive language.

### Parameters

- `mode`: Constant - either CORNER, CORNERS, CENTER, or RADIUS

---

## smooth

**Type:** Function

Draws certain features with smooth (antialiased) edges. `smooth()` is active by default. In 2D mode, <a href="#/p5/noSmooth">noSmooth()</a> is helpful for scaling up images without blurring. The functions don't affect shapes or fonts. In WebGL mode, <a href="#/p5/noSmooth">noSmooth()</a> causes all shapes to be drawn with jagged (aliased) edges. The functions don't affect images or fonts.

---

## sphere

**Type:** Function

Draws a sphere. A sphere is a 3D shape with triangular faces that connect to form a round surface. Spheres with few faces look like crystals. Spheres with many faces have smooth surfaces and look like balls. The first parameter, `radius`, is optional. If a `Number` is passed, as in `sphere(20)`, it sets the radius of the sphere. By default, `radius` is 50. The second parameter, `detailX`, is also optional. If a `Number` is passed, as in `sphere(20, 5)`, it sets the number of triangle subdivisions to use along the x-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailX` is 24. The third parameter, `detailY`, is also optional. If a `Number` is passed, as in `sphere(20, 5, 2)`, it sets the number of triangle subdivisions to use along the y-axis. All 3D shapes are made by connecting triangles to form their surfaces. By default, `detailY` is 16. Note: `sphere()` can only be used in WebGL mode.

### Parameters

- `{Number} [radius]   radius of the sphere. Defaults to 50.`: unknown - No description
- `{Integer} [detailX] number of triangle subdivisions along the x-axis. Defaults to 24.`: unknown - No description
- `{Integer} [detailY] number of triangle subdivisions along the y-axis. Defaults to 16.`: unknown - No description

---

## square

**Type:** Function

Draws a square. A square is a four-sided shape defined by the `x`, `y`, and `s` parameters. `x` and `y` set the location of its top-left corner. `s` sets its width and height. Every angle in the square measures 90˚ and all its sides are the same length. See <a href="#/p5/rectMode">rectMode()</a> for other ways to define squares. The version of `square()` with four parameters creates a rounded square. The fourth parameter sets the radius for all four corners. The version of `square()` with seven parameters also creates a rounded square. Each of the last four parameters set the radius of a corner. The radii start with the top-left corner and move clockwise around the square. If any of these parameters are omitted, they are set to the value of the last radius that was set.

### Parameters

- `x`: Number - x-coordinate of the square.
- `y`: Number - y-coordinate of the square.
- `s`: Number - side size of the square.
- `{Number} [tl] optional radius of top-left corner.`: unknown - No description
- `{Number} [tr] optional radius of top-right corner.`: unknown - No description
- `{Number} [br] optional radius of bottom-right corner.`: unknown - No description
- `{Number} [bl] optional radius of bottom-left corner.`: unknown - No description

---

## strokeCap

**Type:** Function

Sets the style for rendering the ends of lines. The caps for line endings are either rounded (`ROUND`), squared (`SQUARE`), or extended (`PROJECT`). The default cap is `ROUND`. The argument passed to `strokeCap()` must be written in ALL CAPS because the constants `ROUND`, `SQUARE`, and `PROJECT` are defined this way. JavaScript is a case-sensitive language.

### Parameters

- `cap`: Constant - either ROUND, SQUARE, or PROJECT

---

## strokeJoin

**Type:** Function

Sets the style of the joints that connect line segments. Joints are either mitered (`MITER`), beveled (`BEVEL`), or rounded (`ROUND`). The default joint is `MITER` in 2D mode and `ROUND` in WebGL mode. The argument passed to `strokeJoin()` must be written in ALL CAPS because the constants `MITER`, `BEVEL`, and `ROUND` are defined this way. JavaScript is a case-sensitive language.

### Parameters

- `join`: Constant - either MITER, BEVEL, or ROUND

---

## strokeWeight

**Type:** Function

Sets the width of the stroke used for points, lines, and the outlines of shapes. Note: `strokeWeight()` is affected by transformations, especially calls to <a href="#/p5/scale">scale()</a>.

### Parameters

- `weight`: Number - the weight of the stroke (in pixels).

---

## torus

**Type:** Function

Draws a torus. A torus is a 3D shape with triangular faces that connect to form a ring. Toruses with few faces look flattened. Toruses with many faces have smooth surfaces. The first parameter, `radius`, is optional. If a `Number` is passed, as in `torus(30)`, it sets the radius of the ring. By default, `radius` is 50. The second parameter, `tubeRadius`, is also optional. If a `Number` is passed, as in `torus(30, 15)`, it sets the radius of the tube. By default, `tubeRadius` is 10. The third parameter, `detailX`, is also optional. If a `Number` is passed, as in `torus(30, 15, 5)`, it sets the number of edges used to draw the hole of the torus. Using more edges makes the hole look more like a circle. By default, `detailX` is 24. The fourth parameter, `detailY`, is also optional. If a `Number` is passed, as in `torus(30, 15, 5, 7)`, it sets the number of triangle subdivisions to use while filling in the torus’ height. By default, `detailY` is 16. Note: `torus()` can only be used in WebGL mode.

### Parameters

- `{Number} [radius]      radius of the torus. Defaults to 50.`: unknown - No description
- `{Number} [tubeRadius]  radius of the tube. Defaults to 10.`: unknown - No description
- `{Integer} [detailX]    number of edges that form the hole. Defaults to 24.`: unknown - No description
- `{Integer} [detailY]    number of triangle subdivisions along the y-axis. Defaults to 16.`: unknown - No description

---

## triangle

**Type:** Function

Draws a triangle. A triangle is a three-sided shape defined by three points. The first two parameters specify the triangle's first point `(x1, y1)`. The middle two parameters specify its second point `(x2, y2)`. And the last two parameters specify its third point `(x3, y3)`.

### Parameters

- `x1`: Number - x-coordinate of the first point.
- `y1`: Number - y-coordinate of the first point.
- `x2`: Number - x-coordinate of the second point.
- `y2`: Number - y-coordinate of the second point.
- `x3`: Number - x-coordinate of the third point.
- `y3`: Number - y-coordinate of the third point.

---

## uvs

**Type:** Function

Flips the geometry’s texture v-coordinates. In order for <a href="#/p5/texture">texture()</a> to work, the geometry needs a way to map the points on its surface to the pixels in a rectangular image that's used as a texture. The geometry's vertex at coordinates `(x, y, z)` maps to the texture image's pixel at coordinates `(u, v)`. The <a href="#/p5.Geometry/uvs">myGeometry.uvs</a> array stores the `(u, v)` coordinates for each vertex in the order it was added to the geometry. Calling `myGeometry.flipV()` flips a geometry's v-coordinates so that the texture appears mirrored vertically. For example, a plane's four vertices are added clockwise starting from the top-left corner. Here's how calling `myGeometry.flipV()` would change a plane's texture coordinates: ```js // Print the original texture coordinates. // Output: [0, 0, 1, 0, 0, 1, 1, 1] console.log(myGeometry.uvs); // Flip the v-coordinates. myGeometry.flipV(); // Print the flipped texture coordinates. // Output: [0, 1, 1, 1, 0, 0, 1, 0] console.log(myGeometry.uvs); // Notice the swaps: // Left vertices: [0, 0] &lt;--&gt; [1, 0] // Right vertices: [1, 0] &lt;--&gt; [1, 1] ```

---

## vertexColors

**Type:** Function

Removes the geometry’s internal colors. `p5.Geometry` objects can be created with "internal colors" assigned to vertices or the entire shape. When a geometry has internal colors, <a href="#/p5/fill">fill()</a> has no effect. Calling `myGeometry.clearColors()` allows the <a href="#/p5/fill">fill()</a> function to apply color to the geometry.

---

## vertices

**Type:** Property

An array with the geometry's vertices. The geometry's vertices are stored as <a href="#/p5.Vector">p5.Vector</a> objects in the `myGeometry.vertices` array. The geometry's first vertex is the <a href="#/p5.Vector">p5.Vector</a> object at `myGeometry.vertices[0]`, its second vertex is `myGeometry.vertices[1]`, its third vertex is `myGeometry.vertices[2]`, and so on.

---

