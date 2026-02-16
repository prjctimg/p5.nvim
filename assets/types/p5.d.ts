// Generated p5.js Type Definitions
// This file provides both global and p5 namespace support
// Generated: 2026-02-16T04:10:50.884Z
// Original source: @types/p5 package

// ============================================================================
// BASIC TYPE DEFINITIONS
// Ensure all fundamental types are available globally
// ============================================================================
type DEGREES = 'degrees';
type RADIANS = 'radians';
type LABEL = 'label';
type FALLBACK = 'fallback';
type ANGLE_MODE = RADIANS | DEGREES;
type DESCRIBE_DISPLAY = LABEL | FALLBACK;
type GRID_DISPLAY = FALLBACK | LABEL;
type TEXT_DISPLAY = FALLBACK | LABEL;

// ============================================================================
// P5 NAMESPACE SUPPORT
// Use: import p5 from 'p5'; const instance = new p5();
// ============================================================================
// This file was auto-generated. Please do not edit it.
// Inlined from: ./src/accessibility/describe.d.ts

    interface p5InstanceExtensions {
        /**
         *   Creates a screen reader accessible description for
         *   the canvas. The first parameter should be a string
         *   with a description of the canvas. The second
         *   parameter is optional. If specified, it determines
         *   how the description is displayed. describe(text,
         *   LABEL) displays the description to all users as a
         *   tombstone or exhibit label/caption in a div
         *   adjacent to the canvas. You can style it as you
         *   wish in your CSS.
         *
         *   describe(text, FALLBACK) makes the description
         *   accessible to screen-reader users only, in  a sub
         *   DOM inside the canvas element. If a second
         *   parameter is not specified, by default, the
         *   description will only be available to
         *   screen-reader users.
         *   @param text description of the canvas
         *   @param [display] either LABEL or FALLBACK
         */
        describe(text: string, display?: DESCRIBE_DISPLAY): void;

        /**
         *   This function creates a screen-reader accessible
         *   description for elements —shapes or groups of
         *   shapes that create meaning together— in the
         *   canvas. The first paramater should be the name of
         *   the element. The second parameter should be a
         *   string with a description of the element. The
         *   third parameter is optional. If specified, it
         *   determines how the element description is
         *   displayed. describeElement(name, text, LABEL)
         *   displays the element description to all users as a
         *   tombstone or exhibit label/caption in a div
         *   adjacent to the canvas. You can style it as you
         *   wish in your CSS.
         *
         *   describeElement(name, text, FALLBACK) makes the
         *   element description accessible to screen-reader
         *   users only, in  a sub DOM inside the canvas
         *   element. If a second parameter is not specified,
         *   by default, the element description will only be
         *   available to screen-reader users.
         *   @param name name of the element
         *   @param text description of the element
         *   @param [display] either LABEL or FALLBACK
         */
        describeElement(name: string, text: string, display?: DESCRIBE_DISPLAY): void;
    }

// Inlined from: ./src/accessibility/outputs.d.ts

    interface p5InstanceExtensions {
        /**
         *   textOutput() creates a screenreader accessible
         *   output that describes the shapes present on the
         *   canvas. The general description of the canvas
         *   includes canvas size, canvas color, and number of
         *   elements in the canvas (example: 'Your output is
         *   a, 400 by 400 pixels, lavender blue canvas
         *   containing the following 4 shapes:'). This
         *   description is followed by a list of shapes where
         *   the color, position, and area of each shape are
         *   described (example: "orange ellipse at top left
         *   covering 1% of the canvas"). Each element can be
         *   selected to get more details. A table of elements
         *   is also provided. In this table, shape, color,
         *   location, coordinates and area are described
         *   (example: "orange ellipse location=top left
         *   area=2"). textOutput() and textOutput(FALLBACK)
         *   make the output available in  a sub DOM inside the
         *   canvas element which is accessible to screen
         *   readers. textOutput(LABEL) creates an additional
         *   div with the output adjacent to the canvas, this
         *   is useful for non-screen reader users that might
         *   want to display the output outside of the canvas'
         *   sub DOM as they code. However, using LABEL will
         *   create unnecessary redundancy for screen reader
         *   users. We recommend using LABEL only as part of
         *   the development process of a sketch and removing
         *   it before publishing or sharing with screen reader
         *   users.
         *   @param [display] either FALLBACK or LABEL
         */
        textOutput(display?: TEXT_DISPLAY): void;

        /**
         *   gridOutput() lays out the content of the canvas in
         *   the form of a grid (html table) based on the
         *   spatial location of each shape. A brief
         *   description of the canvas is available before the
         *   table output. This description includes: color of
         *   the background, size of the canvas, number of
         *   objects, and object types (example: "lavender blue
         *   canvas is 200 by 200 and contains 4 objects - 3
         *   ellipses 1 rectangle"). The grid describes the
         *   content spatially, each element is placed on a
         *   cell of the table depending on its position.
         *   Within each cell an element the color and type of
         *   shape of that element are available (example:
         *   "orange ellipse"). These descriptions can be
         *   selected individually to get more details. A list
         *   of elements where shape, color, location, and area
         *   are described (example: "orange ellipse
         *   location=top left area=1%") is also available.
         *   gridOutput() and gridOutput(FALLBACK) make the
         *   output available in  a sub DOM inside the canvas
         *   element which is accessible to screen readers.
         *   gridOutput(LABEL) creates an additional div with
         *   the output adjacent to the canvas, this is useful
         *   for non-screen reader users that might want to
         *   display the output outside of the canvas' sub DOM
         *   as they code. However, using LABEL will create
         *   unnecessary redundancy for screen reader users. We
         *   recommend using LABEL only as part of the
         *   development process of a sketch and removing it
         *   before publishing or sharing with screen reader
         *   users.
         *   @param [display] either FALLBACK or LABEL
         */
        gridOutput(display?: GRID_DISPLAY): void;
    }

// Inlined from: ./src/color/creating_reading.d.ts

    interface p5InstanceExtensions {
        /**
         *   Extracts the alpha (transparency) value from a
         *   p5.Color object, array of color components, or CSS
         *   color string.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the alpha value.
         */
        alpha(color: Color | number[] | string): number;

        /**
         *   Extracts the blue value from a p5.Color object,
         *   array of color components, or CSS color string.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the blue value.
         */
        blue(color: Color | number[] | string): number;

        /**
         *   Extracts the HSB brightness value from a p5.Color
         *   object, array of color components, or CSS color
         *   string.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the brightness value.
         */
        brightness(color: Color | number[] | string): number;

        /**
         *   Creates a p5.Color object. By default, the
         *   parameters are interpreted as RGB values. Calling
         *   color(255, 204, 0) will return a bright yellow
         *   color. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of color() with one parameter interprets
         *   the value one of two ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string.
         *
         *   The version of color() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of color() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of color() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param gray number specifying value between white
         *   and black.
         *   @param [alpha] alpha value relative to current
         *   color range (default is 0-255).
         *   @return resulting color.
         */
        color(gray: number, alpha?: number): Color;

        /**
         *   Creates a p5.Color object. By default, the
         *   parameters are interpreted as RGB values. Calling
         *   color(255, 204, 0) will return a bright yellow
         *   color. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of color() with one parameter interprets
         *   the value one of two ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string.
         *
         *   The version of color() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of color() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of color() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param v1 red or hue value relative to the current
         *   color range.
         *   @param v2 green or saturation value relative to
         *   the current color range.
         *   @param v3 blue or brightness value relative to the
         *   current color range.
         *   @param [alpha] alpha value relative to current
         *   color range (default is 0-255).
         */
        color(v1: number, v2: number, v3: number, alpha?: number): Color;

        /**
         *   Creates a p5.Color object. By default, the
         *   parameters are interpreted as RGB values. Calling
         *   color(255, 204, 0) will return a bright yellow
         *   color. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of color() with one parameter interprets
         *   the value one of two ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string.
         *
         *   The version of color() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of color() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of color() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param value a color string.
         */
        color(value: string): Color;

        /**
         *   Creates a p5.Color object. By default, the
         *   parameters are interpreted as RGB values. Calling
         *   color(255, 204, 0) will return a bright yellow
         *   color. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of color() with one parameter interprets
         *   the value one of two ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string.
         *
         *   The version of color() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of color() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of color() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param values an array containing the red, green,
         *   blue, and alpha components of the color.
         */
        color(values: number[]): Color;

        /**
         *   Creates a p5.Color object. By default, the
         *   parameters are interpreted as RGB values. Calling
         *   color(255, 204, 0) will return a bright yellow
         *   color. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of color() with one parameter interprets
         *   the value one of two ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string.
         *
         *   The version of color() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of color() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of color() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         */
        color(color: Color): Color;

        /**
         *   Extracts the green value from a p5.Color object,
         *   array of color components, or CSS color string.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the green value.
         */
        green(color: Color | number[] | string): number;

        /**
         *   Extracts the hue value from a p5.Color object,
         *   array of color components, or CSS color string.
         *   Hue exists in both HSB and HSL. It describes a
         *   color's position on the color wheel. By default,
         *   this function returns the HSL-normalized hue. If
         *   the colorMode() is set to HSB, it returns the
         *   HSB-normalized hue.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the hue
         */
        hue(color: Color | number[] | string): number;

        /**
         *   Blends two colors to find a third color between
         *   them. The amt parameter specifies the amount to
         *   interpolate between the two values. 0 is equal to
         *   the first color, 0.1 is very near the first color,
         *   0.5 is halfway between the two colors, and so on.
         *   Negative numbers are set to 0. Numbers greater
         *   than 1 are set to 1. This differs from the
         *   behavior of lerp. It's necessary because numbers
         *   outside of the interval [0, 1] will produce
         *   strange and unexpected colors. The way that colors
         *   are interpolated depends on the current
         *   colorMode().
         *   @param c1 interpolate from this color.
         *   @param c2 interpolate to this color.
         *   @param amt number between 0 and 1.
         *   @return interpolated color.
         */
        lerpColor(c1: Color, c2: Color, amt: number): Color;

        /**
         *   Extracts the HSL lightness value from a p5.Color
         *   object, array of color components, or CSS color
         *   string.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the lightness
         */
        lightness(color: Color | number[] | string): number;

        /**
         *   Extracts the red value from a p5.Color object,
         *   array of color components, or CSS color string.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the red value.
         */
        red(color: Color | number[] | string): number;

        /**
         *   Extracts the saturation value from a p5.Color
         *   object, array of color components, or CSS color
         *   string. Saturation is scaled differently in HSB
         *   and HSL. By default, this function returns the HSL
         *   saturation. If the colorMode() is set to HSB, it
         *   returns the HSB saturation.
         *   @param color p5.Color object, array of color
         *   components, or CSS color string.
         *   @return the saturation value
         */
        saturation(color: Color | number[] | string): number;
    }

// Inlined from: ./src/color/setting.d.ts

    interface p5InstanceExtensions {
        /**
         *   Sets the color used for the background of the
         *   canvas. By default, the background is transparent.
         *   This function is typically used within draw() to
         *   clear the display window at the beginning of each
         *   frame. It can also be used inside setup() to set
         *   the background on the first frame of animation.
         *   The version of background() with one parameter
         *   interprets the value one of four ways. If the
         *   parameter is a number, it's interpreted as a
         *   grayscale value. If the parameter is a string,
         *   it's interpreted as a CSS color string. RGB, RGBA,
         *   HSL, HSLA, hex, and named color strings are
         *   supported. If the parameter is a p5.Color object,
         *   it will be used as the background color. If the
         *   parameter is a p5.Image object, it will be used as
         *   the background image.
         *
         *   The version of background() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of background() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). By default,
         *   colors are specified in RGB values. Calling
         *   background(255, 204, 0) sets the background a
         *   bright yellow color.
         *   @param color any value created by the color()
         *   function
         *   @chainable
         */
        background(color: Color): p5;

        /**
         *   Sets the color used for the background of the
         *   canvas. By default, the background is transparent.
         *   This function is typically used within draw() to
         *   clear the display window at the beginning of each
         *   frame. It can also be used inside setup() to set
         *   the background on the first frame of animation.
         *   The version of background() with one parameter
         *   interprets the value one of four ways. If the
         *   parameter is a number, it's interpreted as a
         *   grayscale value. If the parameter is a string,
         *   it's interpreted as a CSS color string. RGB, RGBA,
         *   HSL, HSLA, hex, and named color strings are
         *   supported. If the parameter is a p5.Color object,
         *   it will be used as the background color. If the
         *   parameter is a p5.Image object, it will be used as
         *   the background image.
         *
         *   The version of background() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of background() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). By default,
         *   colors are specified in RGB values. Calling
         *   background(255, 204, 0) sets the background a
         *   bright yellow color.
         *   @param colorstring color string, possible formats
         *   include: integer rgb() or rgba(), percentage rgb()
         *   or rgba(), 3-digit hex, 6-digit hex.
         *   @param [a] opacity of the background relative to
         *   current color range (default is 0-255).
         *   @chainable
         */
        background(colorstring: string, a?: number): p5;

        /**
         *   Sets the color used for the background of the
         *   canvas. By default, the background is transparent.
         *   This function is typically used within draw() to
         *   clear the display window at the beginning of each
         *   frame. It can also be used inside setup() to set
         *   the background on the first frame of animation.
         *   The version of background() with one parameter
         *   interprets the value one of four ways. If the
         *   parameter is a number, it's interpreted as a
         *   grayscale value. If the parameter is a string,
         *   it's interpreted as a CSS color string. RGB, RGBA,
         *   HSL, HSLA, hex, and named color strings are
         *   supported. If the parameter is a p5.Color object,
         *   it will be used as the background color. If the
         *   parameter is a p5.Image object, it will be used as
         *   the background image.
         *
         *   The version of background() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of background() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). By default,
         *   colors are specified in RGB values. Calling
         *   background(255, 204, 0) sets the background a
         *   bright yellow color.
         *   @param gray specifies a value between white and
         *   black.
         *   @param [a] opacity of the background relative to
         *   current color range (default is 0-255).
         *   @chainable
         */
        background(gray: number, a?: number): p5;

        /**
         *   Sets the color used for the background of the
         *   canvas. By default, the background is transparent.
         *   This function is typically used within draw() to
         *   clear the display window at the beginning of each
         *   frame. It can also be used inside setup() to set
         *   the background on the first frame of animation.
         *   The version of background() with one parameter
         *   interprets the value one of four ways. If the
         *   parameter is a number, it's interpreted as a
         *   grayscale value. If the parameter is a string,
         *   it's interpreted as a CSS color string. RGB, RGBA,
         *   HSL, HSLA, hex, and named color strings are
         *   supported. If the parameter is a p5.Color object,
         *   it will be used as the background color. If the
         *   parameter is a p5.Image object, it will be used as
         *   the background image.
         *
         *   The version of background() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of background() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). By default,
         *   colors are specified in RGB values. Calling
         *   background(255, 204, 0) sets the background a
         *   bright yellow color.
         *   @param v1 red value if color mode is RGB, or hue
         *   value if color mode is HSB.
         *   @param v2 green value if color mode is RGB, or
         *   saturation value if color mode is HSB.
         *   @param v3 blue value if color mode is RGB, or
         *   brightness value if color mode is HSB.
         *   @param [a] opacity of the background relative to
         *   current color range (default is 0-255).
         *   @chainable
         */
        background(v1: number, v2: number, v3: number, a?: number): p5;

        /**
         *   Sets the color used for the background of the
         *   canvas. By default, the background is transparent.
         *   This function is typically used within draw() to
         *   clear the display window at the beginning of each
         *   frame. It can also be used inside setup() to set
         *   the background on the first frame of animation.
         *   The version of background() with one parameter
         *   interprets the value one of four ways. If the
         *   parameter is a number, it's interpreted as a
         *   grayscale value. If the parameter is a string,
         *   it's interpreted as a CSS color string. RGB, RGBA,
         *   HSL, HSLA, hex, and named color strings are
         *   supported. If the parameter is a p5.Color object,
         *   it will be used as the background color. If the
         *   parameter is a p5.Image object, it will be used as
         *   the background image.
         *
         *   The version of background() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of background() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). By default,
         *   colors are specified in RGB values. Calling
         *   background(255, 204, 0) sets the background a
         *   bright yellow color.
         *   @param values an array containing the red, green,
         *   blue and alpha components of the color.
         *   @chainable
         */
        background(values: number[]): p5;

        /**
         *   Sets the color used for the background of the
         *   canvas. By default, the background is transparent.
         *   This function is typically used within draw() to
         *   clear the display window at the beginning of each
         *   frame. It can also be used inside setup() to set
         *   the background on the first frame of animation.
         *   The version of background() with one parameter
         *   interprets the value one of four ways. If the
         *   parameter is a number, it's interpreted as a
         *   grayscale value. If the parameter is a string,
         *   it's interpreted as a CSS color string. RGB, RGBA,
         *   HSL, HSLA, hex, and named color strings are
         *   supported. If the parameter is a p5.Color object,
         *   it will be used as the background color. If the
         *   parameter is a p5.Image object, it will be used as
         *   the background image.
         *
         *   The version of background() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of background() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). By default,
         *   colors are specified in RGB values. Calling
         *   background(255, 204, 0) sets the background a
         *   bright yellow color.
         *   @param image image created with loadImage() or
         *   createImage(), to set as background. (must be same
         *   size as the sketch window).
         *   @param [a] opacity of the background relative to
         *   current color range (default is 0-255).
         *   @chainable
         */
        background(image: Image, a?: number): p5;

        /**
         *   Clears the pixels on the canvas. This function
         *   makes every pixel 100% transparent. Calling
         *   clear() doesn't clear objects created by createX()
         *   functions such as createGraphics(), createVideo(),
         *   and createImg(). These objects will remain
         *   unchanged after calling clear() and can be
         *   redrawn. In WebGL mode, this function can clear
         *   the screen to a specific color. It interprets four
         *   numeric parameters as normalized RGBA color
         *   values. It also clears the depth buffer. If you
         *   are not using the WebGL renderer, these parameters
         *   will have no effect.
         *   @param r normalized red value.
         *   @param g normalized green value.
         *   @param b normalized blue value.
         *   @param a normalized alpha value.
         *   @chainable
         */
        clear(r: number, g: number, b: number, a: number): p5;

        /**
         *   Clears the pixels on the canvas. This function
         *   makes every pixel 100% transparent. Calling
         *   clear() doesn't clear objects created by createX()
         *   functions such as createGraphics(), createVideo(),
         *   and createImg(). These objects will remain
         *   unchanged after calling clear() and can be
         *   redrawn. In WebGL mode, this function can clear
         *   the screen to a specific color. It interprets four
         *   numeric parameters as normalized RGBA color
         *   values. It also clears the depth buffer. If you
         *   are not using the WebGL renderer, these parameters
         *   will have no effect.
         *   @chainable
         */
        clear(): p5;

        /**
         *   Changes the way p5.js interprets color data. By
         *   default, the numeric parameters for fill(),
         *   stroke(), background(), and color() are defined by
         *   values between 0 and 255 using the RGB color
         *   model. This is equivalent to calling
         *   colorMode(RGB, 255). Pure red is color(255, 0, 0)
         *   in this model. Calling colorMode(RGB, 100) sets
         *   colors to be interpreted as RGB color values
         *   between 0 and 100. Pure red is color(100, 0, 0) in
         *   this model.
         *
         *   Calling colorMode(HSB) or colorMode(HSL) changes
         *   to HSB or HSL system instead of RGB.
         *
         *   p5.Color objects remember the mode that they were
         *   created in. Changing modes doesn't affect their
         *   appearance.
         *   @param mode either RGB, HSB or HSL, corresponding
         *   to Red/Green/Blue and Hue/Saturation/Brightness
         *   (or Lightness).
         *   @param [max] range for all values.
         *   @chainable
         */
        colorMode(mode: COLOR_MODE, max?: number): p5;

        /**
         *   Changes the way p5.js interprets color data. By
         *   default, the numeric parameters for fill(),
         *   stroke(), background(), and color() are defined by
         *   values between 0 and 255 using the RGB color
         *   model. This is equivalent to calling
         *   colorMode(RGB, 255). Pure red is color(255, 0, 0)
         *   in this model. Calling colorMode(RGB, 100) sets
         *   colors to be interpreted as RGB color values
         *   between 0 and 100. Pure red is color(100, 0, 0) in
         *   this model.
         *
         *   Calling colorMode(HSB) or colorMode(HSL) changes
         *   to HSB or HSL system instead of RGB.
         *
         *   p5.Color objects remember the mode that they were
         *   created in. Changing modes doesn't affect their
         *   appearance.
         *   @param mode either RGB, HSB or HSL, corresponding
         *   to Red/Green/Blue and Hue/Saturation/Brightness
         *   (or Lightness).
         *   @param max1 range for the red or hue depending on
         *   the current color mode.
         *   @param max2 range for the green or saturation
         *   depending on the current color mode.
         *   @param max3 range for the blue or
         *   brightness/lightness depending on the current
         *   color mode.
         *   @param [maxA] range for the alpha.
         *   @chainable
         */
        colorMode(mode: UNKNOWN_P5_CONSTANT, max1: number, max2: number, max3: number, maxA?: number): p5;

        /**
         *   Sets the color used to fill shapes. Calling
         *   fill(255, 165, 0) or fill('orange') means all
         *   shapes drawn after the fill command will be filled
         *   with the color orange. The version of fill() with
         *   one parameter interprets the value one of three
         *   ways. If the parameter is a number, it's
         *   interpreted as a grayscale value. If the parameter
         *   is a string, it's interpreted as a CSS color
         *   string. A p5.Color object can also be provided to
         *   set the fill color.
         *
         *   The version of fill() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). The default
         *   color space is RGB, with each value in the range
         *   from 0 to 255.
         *   @param v1 red value if color mode is RGB or hue
         *   value if color mode is HSB.
         *   @param v2 green value if color mode is RGB or
         *   saturation value if color mode is HSB.
         *   @param v3 blue value if color mode is RGB or
         *   brightness value if color mode is HSB.
         *   @chainable
         */
        fill(v1: number, v2: number, v3: number, alpha?: number): p5;

        /**
         *   Sets the color used to fill shapes. Calling
         *   fill(255, 165, 0) or fill('orange') means all
         *   shapes drawn after the fill command will be filled
         *   with the color orange. The version of fill() with
         *   one parameter interprets the value one of three
         *   ways. If the parameter is a number, it's
         *   interpreted as a grayscale value. If the parameter
         *   is a string, it's interpreted as a CSS color
         *   string. A p5.Color object can also be provided to
         *   set the fill color.
         *
         *   The version of fill() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). The default
         *   color space is RGB, with each value in the range
         *   from 0 to 255.
         *   @param value a color string.
         *   @chainable
         */
        fill(value: string): p5;

        /**
         *   Sets the color used to fill shapes. Calling
         *   fill(255, 165, 0) or fill('orange') means all
         *   shapes drawn after the fill command will be filled
         *   with the color orange. The version of fill() with
         *   one parameter interprets the value one of three
         *   ways. If the parameter is a number, it's
         *   interpreted as a grayscale value. If the parameter
         *   is a string, it's interpreted as a CSS color
         *   string. A p5.Color object can also be provided to
         *   set the fill color.
         *
         *   The version of fill() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). The default
         *   color space is RGB, with each value in the range
         *   from 0 to 255.
         *   @param gray a grayscale value.
         *   @chainable
         */
        fill(gray: number, alpha?: number): p5;

        /**
         *   Sets the color used to fill shapes. Calling
         *   fill(255, 165, 0) or fill('orange') means all
         *   shapes drawn after the fill command will be filled
         *   with the color orange. The version of fill() with
         *   one parameter interprets the value one of three
         *   ways. If the parameter is a number, it's
         *   interpreted as a grayscale value. If the parameter
         *   is a string, it's interpreted as a CSS color
         *   string. A p5.Color object can also be provided to
         *   set the fill color.
         *
         *   The version of fill() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). The default
         *   color space is RGB, with each value in the range
         *   from 0 to 255.
         *   @param values an array containing the red, green,
         *   blue & and alpha components of the color.
         *   @chainable
         */
        fill(values: number[]): p5;

        /**
         *   Sets the color used to fill shapes. Calling
         *   fill(255, 165, 0) or fill('orange') means all
         *   shapes drawn after the fill command will be filled
         *   with the color orange. The version of fill() with
         *   one parameter interprets the value one of three
         *   ways. If the parameter is a number, it's
         *   interpreted as a grayscale value. If the parameter
         *   is a string, it's interpreted as a CSS color
         *   string. A p5.Color object can also be provided to
         *   set the fill color.
         *
         *   The version of fill() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode(). The default
         *   color space is RGB, with each value in the range
         *   from 0 to 255.
         *   @param color the fill color.
         *   @chainable
         */
        fill(color: Color): p5;

        /**
         *   Disables setting the interior color of shapes.
         *   This is the same as making the fill completely
         *   transparent. If both noStroke() and noFill() are
         *   called, nothing will be drawn to the screen.
         *   @chainable
         */
        noFill(): p5;

        /**
         *   Disables drawing the stroke (outline). If both
         *   noStroke() and noFill() are called, nothing will
         *   be drawn to the screen.
         *   @chainable
         */
        noStroke(): p5;

        /**
         *   Sets the color used to draw lines and borders
         *   around shapes. Calling stroke(255, 165, 0) or
         *   stroke('orange') means all shapes drawn after the
         *   stroke() command will be filled with the color
         *   orange. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of stroke() with one parameter interprets
         *   the value one of three ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string. A p5.Color object can also be
         *   provided to set the stroke color.
         *
         *   The version of stroke() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of stroke() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of stroke() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param v1 red value if color mode is RGB or hue
         *   value if color mode is HSB.
         *   @param v2 green value if color mode is RGB or
         *   saturation value if color mode is HSB.
         *   @param v3 blue value if color mode is RGB or
         *   brightness value if color mode is HSB.
         *   @chainable
         */
        stroke(v1: number, v2: number, v3: number, alpha?: number): p5;

        /**
         *   Sets the color used to draw lines and borders
         *   around shapes. Calling stroke(255, 165, 0) or
         *   stroke('orange') means all shapes drawn after the
         *   stroke() command will be filled with the color
         *   orange. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of stroke() with one parameter interprets
         *   the value one of three ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string. A p5.Color object can also be
         *   provided to set the stroke color.
         *
         *   The version of stroke() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of stroke() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of stroke() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param value a color string.
         *   @chainable
         */
        stroke(value: string): p5;

        /**
         *   Sets the color used to draw lines and borders
         *   around shapes. Calling stroke(255, 165, 0) or
         *   stroke('orange') means all shapes drawn after the
         *   stroke() command will be filled with the color
         *   orange. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of stroke() with one parameter interprets
         *   the value one of three ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string. A p5.Color object can also be
         *   provided to set the stroke color.
         *
         *   The version of stroke() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of stroke() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of stroke() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param gray a grayscale value.
         *   @chainable
         */
        stroke(gray: number, alpha?: number): p5;

        /**
         *   Sets the color used to draw lines and borders
         *   around shapes. Calling stroke(255, 165, 0) or
         *   stroke('orange') means all shapes drawn after the
         *   stroke() command will be filled with the color
         *   orange. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of stroke() with one parameter interprets
         *   the value one of three ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string. A p5.Color object can also be
         *   provided to set the stroke color.
         *
         *   The version of stroke() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of stroke() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of stroke() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param values an array containing the red, green,
         *   blue, and alpha components of the color.
         *   @chainable
         */
        stroke(values: number[]): p5;

        /**
         *   Sets the color used to draw lines and borders
         *   around shapes. Calling stroke(255, 165, 0) or
         *   stroke('orange') means all shapes drawn after the
         *   stroke() command will be filled with the color
         *   orange. The way these parameters are interpreted
         *   may be changed with the colorMode() function. The
         *   version of stroke() with one parameter interprets
         *   the value one of three ways. If the parameter is a
         *   number, it's interpreted as a grayscale value. If
         *   the parameter is a string, it's interpreted as a
         *   CSS color string. A p5.Color object can also be
         *   provided to set the stroke color.
         *
         *   The version of stroke() with two parameters
         *   interprets the first one as a grayscale value. The
         *   second parameter sets the alpha (transparency)
         *   value.
         *
         *   The version of stroke() with three parameters
         *   interprets them as RGB, HSB, or HSL colors,
         *   depending on the current colorMode().
         *
         *   The version of stroke() with four parameters
         *   interprets them as RGBA, HSBA, or HSLA colors,
         *   depending on the current colorMode(). The last
         *   parameter sets the alpha (transparency) value.
         *   @param color the stroke color.
         *   @chainable
         */
        stroke(color: Color): p5;

        /**
         *   All drawing that follows erase() will subtract
         *   from the canvas, revealing the web page
         *   underneath. The erased areas will become
         *   transparent, allowing the content behind the
         *   canvas to show through. The fill(), stroke(), and
         *   blendMode() have no effect once erase() is called.
         *   The erase() function has two optional parameters.
         *   The first parameter sets the strength of erasing
         *   by the shape's interior. A value of 0 means that
         *   no erasing will occur. A value of 255 means that
         *   the shape's interior will fully erase the content
         *   underneath. The default value is 255 (full
         *   strength).
         *
         *   The second parameter sets the strength of erasing
         *   by the shape's edge. A value of 0 means that no
         *   erasing will occur. A value of 255 means that the
         *   shape's edge will fully erase the content
         *   underneath. The default value is 255 (full
         *   strength).
         *
         *   To cancel the erasing effect, use the noErase()
         *   function.
         *
         *   erase() has no effect on drawing done with the
         *   image() and background() functions.
         *   @param [strengthFill] a number (0-255) for the
         *   strength of erasing under a shape's interior.
         *   Defaults to 255, which is full strength.
         *   @param [strengthStroke] a number (0-255) for the
         *   strength of erasing under a shape's edge. Defaults
         *   to 255, which is full strength.
         *   @chainable
         */
        erase(strengthFill?: number, strengthStroke?: number): p5;

        /**
         *   Ends erasing that was started with erase(). The
         *   fill(), stroke(), and blendMode() settings will
         *   return to what they were prior to calling erase().
         *   @chainable
         */
        noErase(): p5;
    }

// Inlined from: ./src/core/shape/2d_primitives.d.ts

    interface p5InstanceExtensions {
        /**
         *   Draws an arc to the canvas. Arcs are drawn along
         *   the outer edge of an ellipse (oval) defined by the
         *   x, y, w, and h parameters. Use the start and stop
         *   parameters to specify the angles (in radians) at
         *   which to draw the arc. Arcs are always drawn
         *   clockwise from start to stop. The origin of the
         *   arc's ellipse may be changed with the
         *   ellipseMode() function. The optional mode
         *   parameter determines the arc's fill style. The
         *   fill modes are a semi-circle (OPEN), a closed
         *   semi-circle (CHORD), or a closed pie segment
         *   (PIE).
         *   @param x x-coordinate of the arc's ellipse.
         *   @param y y-coordinate of the arc's ellipse.
         *   @param w width of the arc's ellipse by default.
         *   @param h height of the arc's ellipse by default.
         *   @param start angle to start the arc, specified in
         *   radians.
         *   @param stop angle to stop the arc, specified in
         *   radians.
         *   @param [mode] optional parameter to determine the
         *   way of drawing the arc. either CHORD, PIE, or
         *   OPEN.
         *   @param [detail] optional parameter for WebGL mode
         *   only. This is to specify the number of vertices
         *   that makes up the perimeter of the arc. Default
         *   value is 25. Won't draw a stroke for a detail of
         *   more than 50.
         *   @chainable
         */
        arc(
            x: number,
            y: number,
            w: number,
            h: number,
            start: number,
            stop: number,
            mode?: ARC_MODE,
            detail?: number
        ): p5;

        /**
         *   Draws an ellipse (oval) to the canvas. An ellipse
         *   with equal width and height is a circle. By
         *   default, the first two parameters set the location
         *   of the center of the ellipse. The third and fourth
         *   parameters set the shape's width and height,
         *   respectively. The origin may be changed with the
         *   ellipseMode() function. If no height is specified,
         *   the value of width is used for both the width and
         *   height. If a negative height or width is
         *   specified, the absolute value is taken.
         *   @param x x-coordinate of the center of the
         *   ellipse.
         *   @param y y-coordinate of the center of the
         *   ellipse.
         *   @param w width of the ellipse.
         *   @param [h] height of the ellipse.
         *   @chainable
         */
        ellipse(x: number, y: number, w: number, h?: number): p5;

        /**
         *   Draws an ellipse (oval) to the canvas. An ellipse
         *   with equal width and height is a circle. By
         *   default, the first two parameters set the location
         *   of the center of the ellipse. The third and fourth
         *   parameters set the shape's width and height,
         *   respectively. The origin may be changed with the
         *   ellipseMode() function. If no height is specified,
         *   the value of width is used for both the width and
         *   height. If a negative height or width is
         *   specified, the absolute value is taken.
         *   @param x x-coordinate of the center of the
         *   ellipse.
         *   @param y y-coordinate of the center of the
         *   ellipse.
         *   @param w width of the ellipse.
         *   @param h height of the ellipse.
         *   @param [detail] optional parameter for WebGL mode
         *   only. This is to specify the number of vertices
         *   that makes up the perimeter of the ellipse.
         *   Default value is 25. Won't draw a stroke for a
         *   detail of more than 50.
         */
        ellipse(x: number, y: number, w: number, h: number, detail?: number): void;

        /**
         *   Draws a circle to the canvas. A circle is a round
         *   shape. Every point on the edge of a circle is the
         *   same distance from its center. By default, the
         *   first two parameters set the location of the
         *   center of the circle. The third parameter sets the
         *   shape's width and height (diameter). The origin
         *   may be changed with the ellipseMode() function.
         *   @param x x-coordinate of the center of the circle.
         *   @param y y-coordinate of the center of the circle.
         *   @param d diameter of the circle.
         *   @chainable
         */
        circle(x: number, y: number, d: number): p5;

        /**
         *   Draws a line, a straight path between two points.
         *   Its default width is one pixel. The version of
         *   line() with four parameters draws the line in 2D.
         *   To color a line, use the stroke() function. To
         *   change its width, use the strokeWeight() function.
         *   A line can't be filled, so the fill() function
         *   won't affect the color of a line. The version of
         *   line() with six parameters allows the line to be
         *   drawn in 3D space. Doing so requires adding the
         *   WEBGL argument to createCanvas().
         *   @param x1 the x-coordinate of the first point.
         *   @param y1 the y-coordinate of the first point.
         *   @param x2 the x-coordinate of the second point.
         *   @param y2 the y-coordinate of the second point.
         *   @chainable
         */
        line(x1: number, y1: number, x2: number, y2: number): p5;

        /**
         *   Draws a line, a straight path between two points.
         *   Its default width is one pixel. The version of
         *   line() with four parameters draws the line in 2D.
         *   To color a line, use the stroke() function. To
         *   change its width, use the strokeWeight() function.
         *   A line can't be filled, so the fill() function
         *   won't affect the color of a line. The version of
         *   line() with six parameters allows the line to be
         *   drawn in 3D space. Doing so requires adding the
         *   WEBGL argument to createCanvas().
         *   @param x1 the x-coordinate of the first point.
         *   @param y1 the y-coordinate of the first point.
         *   @param z1 the z-coordinate of the first point.
         *   @param x2 the x-coordinate of the second point.
         *   @param y2 the y-coordinate of the second point.
         *   @param z2 the z-coordinate of the second point.
         *   @chainable
         */
        line(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): p5;

        /**
         *   Draws a point, a single coordinate in space. Its
         *   default size is one pixel. The first two
         *   parameters are the point's x- and y-coordinates,
         *   respectively. To color a point, use the stroke()
         *   function. To change its size, use the
         *   strokeWeight() function. The version of point()
         *   with three parameters allows the point to be drawn
         *   in 3D space. Doing so requires adding the WEBGL
         *   argument to createCanvas().
         *
         *   The version of point() with one parameter allows
         *   the point's location to be set with a p5.Vector
         *   object.
         *   @param x the x-coordinate.
         *   @param y the y-coordinate.
         *   @param [z] the z-coordinate (for WebGL mode).
         *   @chainable
         */
        point(x: number, y: number, z?: number): p5;

        /**
         *   Draws a point, a single coordinate in space. Its
         *   default size is one pixel. The first two
         *   parameters are the point's x- and y-coordinates,
         *   respectively. To color a point, use the stroke()
         *   function. To change its size, use the
         *   strokeWeight() function. The version of point()
         *   with three parameters allows the point to be drawn
         *   in 3D space. Doing so requires adding the WEBGL
         *   argument to createCanvas().
         *
         *   The version of point() with one parameter allows
         *   the point's location to be set with a p5.Vector
         *   object.
         *   @param coordinateVector the coordinate vector.
         *   @chainable
         */
        point(coordinateVector: Vector): p5;

        /**
         *   Draws a quad to the canvas. A quad is a
         *   quadrilateral, a four-sided polygon. Some examples
         *   of quads include rectangles, squares, rhombuses,
         *   and trapezoids. The first pair of parameters
         *   (x1,y1) sets the quad's first point. The following
         *   pairs of parameters set the coordinates for its
         *   next three points. Parameters should proceed
         *   clockwise or counter-clockwise around the shape.
         *   The version of quad() with twelve parameters
         *   allows the quad to be drawn in 3D space. Doing so
         *   requires adding the WEBGL argument to
         *   createCanvas().
         *   @param x1 the x-coordinate of the first point.
         *   @param y1 the y-coordinate of the first point.
         *   @param x2 the x-coordinate of the second point.
         *   @param y2 the y-coordinate of the second point.
         *   @param x3 the x-coordinate of the third point.
         *   @param y3 the y-coordinate of the third point.
         *   @param x4 the x-coordinate of the fourth point.
         *   @param y4 the y-coordinate of the fourth point.
         *   @param [detailX] number of segments in the
         *   x-direction.
         *   @param [detailY] number of segments in the
         *   y-direction.
         *   @chainable
         */
        quad(
            x1: number,
            y1: number,
            x2: number,
            y2: number,
            x3: number,
            y3: number,
            x4: number,
            y4: number,
            detailX?: number,
            detailY?: number
        ): p5;

        /**
         *   Draws a quad to the canvas. A quad is a
         *   quadrilateral, a four-sided polygon. Some examples
         *   of quads include rectangles, squares, rhombuses,
         *   and trapezoids. The first pair of parameters
         *   (x1,y1) sets the quad's first point. The following
         *   pairs of parameters set the coordinates for its
         *   next three points. Parameters should proceed
         *   clockwise or counter-clockwise around the shape.
         *   The version of quad() with twelve parameters
         *   allows the quad to be drawn in 3D space. Doing so
         *   requires adding the WEBGL argument to
         *   createCanvas().
         *   @param x1 the x-coordinate of the first point.
         *   @param y1 the y-coordinate of the first point.
         *   @param z1 the z-coordinate of the first point.
         *   @param x2 the x-coordinate of the second point.
         *   @param y2 the y-coordinate of the second point.
         *   @param z2 the z-coordinate of the second point.
         *   @param x3 the x-coordinate of the third point.
         *   @param y3 the y-coordinate of the third point.
         *   @param z3 the z-coordinate of the third point.
         *   @param x4 the x-coordinate of the fourth point.
         *   @param y4 the y-coordinate of the fourth point.
         *   @param z4 the z-coordinate of the fourth point.
         *   @param [detailX] number of segments in the
         *   x-direction.
         *   @param [detailY] number of segments in the
         *   y-direction.
         *   @chainable
         */
        quad(
            x1: number,
            y1: number,
            z1: number,
            x2: number,
            y2: number,
            z2: number,
            x3: number,
            y3: number,
            z3: number,
            x4: number,
            y4: number,
            z4: number,
            detailX?: number,
            detailY?: number
        ): p5;

        /**
         *   Draws a rectangle to the canvas. A rectangle is a
         *   four-sided polygon with every angle at ninety
         *   degrees. By default, the first two parameters set
         *   the location of the rectangle's upper-left corner.
         *   The third and fourth set the shape's the width and
         *   height, respectively. The way these parameters are
         *   interpreted may be changed with the rectMode()
         *   function. The version of rect() with five
         *   parameters creates a rounded rectangle. The fifth
         *   parameter is used as the radius value for all four
         *   corners.
         *
         *   The version of rect() with eight parameters also
         *   creates a rounded rectangle. When using eight
         *   parameters, the latter four set the radius of the
         *   arc at each corner separately. The radii start
         *   with the top-left corner and move clockwise around
         *   the rectangle. If any of these parameters are
         *   omitted, they are set to the value of the last
         *   specified corner radius.
         *   @param x x-coordinate of the rectangle.
         *   @param y y-coordinate of the rectangle.
         *   @param w width of the rectangle.
         *   @param [h] height of the rectangle.
         *   @param [tl] optional radius of top-left corner.
         *   @param [tr] optional radius of top-right corner.
         *   @param [br] optional radius of bottom-right
         *   corner.
         *   @param [bl] optional radius of bottom-left corner.
         *   @chainable
         */
        rect(x: number, y: number, w: number, h?: number, tl?: number, tr?: number, br?: number, bl?: number): p5;

        /**
         *   Draws a rectangle to the canvas. A rectangle is a
         *   four-sided polygon with every angle at ninety
         *   degrees. By default, the first two parameters set
         *   the location of the rectangle's upper-left corner.
         *   The third and fourth set the shape's the width and
         *   height, respectively. The way these parameters are
         *   interpreted may be changed with the rectMode()
         *   function. The version of rect() with five
         *   parameters creates a rounded rectangle. The fifth
         *   parameter is used as the radius value for all four
         *   corners.
         *
         *   The version of rect() with eight parameters also
         *   creates a rounded rectangle. When using eight
         *   parameters, the latter four set the radius of the
         *   arc at each corner separately. The radii start
         *   with the top-left corner and move clockwise around
         *   the rectangle. If any of these parameters are
         *   omitted, they are set to the value of the last
         *   specified corner radius.
         *   @param x x-coordinate of the rectangle.
         *   @param y y-coordinate of the rectangle.
         *   @param w width of the rectangle.
         *   @param h height of the rectangle.
         *   @param [detailX] number of segments in the
         *   x-direction (for WebGL mode).
         *   @param [detailY] number of segments in the
         *   y-direction (for WebGL mode).
         *   @chainable
         */
        rect(x: number, y: number, w: number, h: number, detailX?: number, detailY?: number): p5;

        /**
         *   Draws a square to the canvas. A square is a
         *   four-sided polygon with every angle at ninety
         *   degrees and equal side lengths. By default, the
         *   first two parameters set the location of the
         *   square's upper-left corner. The third parameter
         *   sets its side size. The way these parameters are
         *   interpreted may be changed with the rectMode()
         *   function. The version of square() with four
         *   parameters creates a rounded square. The fourth
         *   parameter is used as the radius value for all four
         *   corners.
         *
         *   The version of square() with seven parameters also
         *   creates a rounded square. When using seven
         *   parameters, the latter four set the radius of the
         *   arc at each corner separately. The radii start
         *   with the top-left corner and move clockwise around
         *   the square. If any of these parameters are
         *   omitted, they are set to the value of the last
         *   specified corner radius.
         *   @param x x-coordinate of the square.
         *   @param y y-coordinate of the square.
         *   @param s side size of the square.
         *   @param [tl] optional radius of top-left corner.
         *   @param [tr] optional radius of top-right corner.
         *   @param [br] optional radius of bottom-right
         *   corner.
         *   @param [bl] optional radius of bottom-left corner.
         *   @chainable
         */
        square(x: number, y: number, s: number, tl?: number, tr?: number, br?: number, bl?: number): p5;

        /**
         *   Draws a triangle to the canvas. A triangle is a
         *   three-sided polygon. The first two parameters
         *   specify the triangle's first point (x1,y1). The
         *   middle two parameters specify its second point
         *   (x2,y2). And the last two parameters specify its
         *   third point (x3, y3).
         *   @param x1 x-coordinate of the first point.
         *   @param y1 y-coordinate of the first point.
         *   @param x2 x-coordinate of the second point.
         *   @param y2 y-coordinate of the second point.
         *   @param x3 x-coordinate of the third point.
         *   @param y3 y-coordinate of the third point.
         *   @chainable
         */
        triangle(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): p5;
    }

// Inlined from: ./src/core/shape/attributes.d.ts

    interface p5InstanceExtensions {
        /**
         *   Modifies the location from which ellipses,
         *   circles, and arcs are drawn. By default, the first
         *   two parameters are the x- and y-coordinates of the
         *   shape's center. The next parameters are its width
         *   and height. This is equivalent to calling
         *   ellipseMode(CENTER). ellipseMode(RADIUS) also uses
         *   the first two parameters to set the x- and
         *   y-coordinates of the shape's center. The next
         *   parameters are half of the shapes's width and
         *   height. Calling ellipse(0, 0, 10, 15) draws a
         *   shape with a width of 20 and height of 30.
         *
         *   ellipseMode(CORNER) uses the first two parameters
         *   as the upper-left corner of the shape. The next
         *   parameters are its width and height.
         *
         *   ellipseMode(CORNERS) uses the first two parameters
         *   as the location of one corner of the ellipse's
         *   bounding box. The third and fourth parameters are
         *   the location of the opposite corner.
         *
         *   The argument passed to ellipseMode() must be
         *   written in ALL CAPS because the constants CENTER,
         *   RADIUS, CORNER, and CORNERS are defined this way.
         *   JavaScript is a case-sensitive language.
         *   @param mode either CENTER, RADIUS, CORNER, or
         *   CORNERS
         *   @chainable
         */
        ellipseMode(mode: ELLIPSE_MODE): p5;

        /**
         *   Draws all geometry with jagged (aliased) edges.
         *   smooth() is active by default in 2D mode. It's
         *   necessary to call noSmooth() to disable smoothing
         *   of geometry, images, and fonts.
         *
         *   In WebGL mode, noSmooth() is active by default.
         *   It's necessary to call smooth() to draw smooth
         *   (antialiased) edges.
         *   @chainable
         */
        noSmooth(): p5;

        /**
         *   Modifies the location from which rectangles and
         *   squares are drawn. By default, the first two
         *   parameters are the x- and y-coordinates of the
         *   shape's upper-left corner. The next parameters are
         *   its width and height. This is equivalent to
         *   calling rectMode(CORNER). rectMode(CORNERS) also
         *   uses the first two parameters as the location of
         *   one of the corners. The third and fourth
         *   parameters are the location of the opposite
         *   corner.
         *
         *   rectMode(CENTER) uses the first two parameters as
         *   the x- and y-coordinates of the shape's center.
         *   The next parameters are its width and height.
         *
         *   rectMode(RADIUS) also uses the first two
         *   parameters as the x- and y-coordinates of the
         *   shape's center. The next parameters are half of
         *   the shape's width and height.
         *
         *   The argument passed to rectMode() must be written
         *   in ALL CAPS because the constants CENTER, RADIUS,
         *   CORNER, and CORNERS are defined this way.
         *   JavaScript is a case-sensitive language.
         *   @param mode either CORNER, CORNERS, CENTER, or
         *   RADIUS
         *   @chainable
         */
        rectMode(mode: RECT_MODE): p5;

        /**
         *   Draws all geometry with smooth (anti-aliased)
         *   edges. smooth() will also improve image quality of
         *   resized images. smooth() is active by default in
         *   2D mode. It's necessary to call noSmooth() to
         *   disable smoothing of geometry, images, and fonts.
         *
         *   In WebGL mode, noSmooth() is active by default.
         *   It's necessary to call smooth() to draw smooth
         *   (antialiased) edges.
         *   @chainable
         */
        smooth(): p5;

        /**
         *   Sets the style for rendering line endings. These
         *   ends are either rounded (ROUND), squared (SQUARE),
         *   or extended (PROJECT). The default cap is ROUND.
         *   The argument passed to strokeCap() must be written
         *   in ALL CAPS because the constants ROUND, SQUARE,
         *   and PROJECT are defined this way. JavaScript is a
         *   case-sensitive language.
         *   @param cap either ROUND, SQUARE, or PROJECT
         *   @chainable
         */
        strokeCap(cap: STROKE_CAP): p5;

        /**
         *   Sets the style of the joints which connect line
         *   segments. These joints are either mitered (MITER),
         *   beveled (BEVEL), or rounded (ROUND). The default
         *   joint is MITER in 2D mode and ROUND in WebGL mode.
         *   The argument passed to strokeJoin() must be
         *   written in ALL CAPS because the constants MITER,
         *   BEVEL, and ROUND are defined this way. JavaScript
         *   is a case-sensitive language.
         *   @param join either MITER, BEVEL, or ROUND
         *   @chainable
         */
        strokeJoin(join: STROKE_JOIN): p5;

        /**
         *   Sets the width of the stroke used for lines,
         *   points, and the border around shapes. All widths
         *   are set in units of pixels. Note that
         *   strokeWeight() is affected by any transformation
         *   or scaling that has been applied previously.
         *   @param weight the weight of the stroke (in
         *   pixels).
         *   @chainable
         */
        strokeWeight(weight: number): p5;
    }

// Inlined from: ./src/core/shape/curves.d.ts

    interface p5InstanceExtensions {
        /**
         *   Draws a cubic Bezier curve on the screen. These
         *   curves are defined by a series of anchor and
         *   control points. The first two parameters specify
         *   the first anchor point and the last two parameters
         *   specify the other anchor point, which become the
         *   first and last points on the curve. The middle
         *   parameters specify the two control points which
         *   define the shape of the curve. Approximately
         *   speaking, control points "pull" the curve towards
         *   them. Bezier curves were developed by French
         *   automotive engineer Pierre Bezier, and are
         *   commonly used in computer graphics to define
         *   gently sloping curves. See also curve().
         *   @param x1 x-coordinate for the first anchor point
         *   @param y1 y-coordinate for the first anchor point
         *   @param x2 x-coordinate for the first control point
         *   @param y2 y-coordinate for the first control point
         *   @param x3 x-coordinate for the second control
         *   point
         *   @param y3 y-coordinate for the second control
         *   point
         *   @param x4 x-coordinate for the second anchor point
         *   @param y4 y-coordinate for the second anchor point
         *   @chainable
         */
        bezier(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): p5;

        /**
         *   Draws a cubic Bezier curve on the screen. These
         *   curves are defined by a series of anchor and
         *   control points. The first two parameters specify
         *   the first anchor point and the last two parameters
         *   specify the other anchor point, which become the
         *   first and last points on the curve. The middle
         *   parameters specify the two control points which
         *   define the shape of the curve. Approximately
         *   speaking, control points "pull" the curve towards
         *   them. Bezier curves were developed by French
         *   automotive engineer Pierre Bezier, and are
         *   commonly used in computer graphics to define
         *   gently sloping curves. See also curve().
         *   @param x1 x-coordinate for the first anchor point
         *   @param y1 y-coordinate for the first anchor point
         *   @param z1 z-coordinate for the first anchor point
         *   @param x2 x-coordinate for the first control point
         *   @param y2 y-coordinate for the first control point
         *   @param z2 z-coordinate for the first control point
         *   @param x3 x-coordinate for the second control
         *   point
         *   @param y3 y-coordinate for the second control
         *   point
         *   @param z3 z-coordinate for the second control
         *   point
         *   @param x4 x-coordinate for the second anchor point
         *   @param y4 y-coordinate for the second anchor point
         *   @param z4 z-coordinate for the second anchor point
         *   @chainable
         */
        bezier(
            x1: number,
            y1: number,
            z1: number,
            x2: number,
            y2: number,
            z2: number,
            x3: number,
            y3: number,
            z3: number,
            x4: number,
            y4: number,
            z4: number
        ): p5;

        /**
         *   Sets the resolution at which Bezier's curve is
         *   displayed. The default value is 20. Note, This
         *   function is only useful when using the WEBGL
         *   renderer as the default canvas renderer does not
         *   use this information.
         *   @param detail resolution of the curves
         *   @chainable
         */
        bezierDetail(detail: number): p5;

        /**
         *   Given the x or y co-ordinate values of control and
         *   anchor points of a bezier curve, it evaluates the
         *   x or y coordinate of the bezier at position t. The
         *   parameters a and d are the x or y coordinates of
         *   first and last points on the curve while b and c
         *   are of the control points.The final parameter t is
         *   the position of the resultant point which is given
         *   between 0 and 1. This can be done once with the x
         *   coordinates and a second time with the y
         *   coordinates to get the location of a bezier curve
         *   at t.
         *   @param a coordinate of first point on the curve
         *   @param b coordinate of first control point
         *   @param c coordinate of second control point
         *   @param d coordinate of second point on the curve
         *   @param t value between 0 and 1
         *   @return the value of the Bezier at position t
         */
        bezierPoint(a: number, b: number, c: number, d: number, t: number): number;

        /**
         *   Evaluates the tangent to the Bezier at position t
         *   for points a, b, c, d. The parameters a and d are
         *   the first and last points on the curve, and b and
         *   c are the control points. The final parameter t
         *   varies between 0 and 1.
         *   @param a coordinate of first point on the curve
         *   @param b coordinate of first control point
         *   @param c coordinate of second control point
         *   @param d coordinate of second point on the curve
         *   @param t value between 0 and 1
         *   @return the tangent at position t
         */
        bezierTangent(a: number, b: number, c: number, d: number, t: number): number;

        /**
         *   Draws a curved line on the screen between two
         *   points, given as the middle four parameters. The
         *   first two parameters are a control point, as if
         *   the curve came from this point even though it's
         *   not drawn. The last two parameters similarly
         *   describe the other control point.  Longer curves
         *   can be created by putting a series of curve()
         *   functions together or using curveVertex(). An
         *   additional function called curveTightness()
         *   provides control for the visual quality of the
         *   curve. The curve() function is an implementation
         *   of Catmull-Rom splines.
         *   @param x1 x-coordinate for the beginning control
         *   point
         *   @param y1 y-coordinate for the beginning control
         *   point
         *   @param x2 x-coordinate for the first point
         *   @param y2 y-coordinate for the first point
         *   @param x3 x-coordinate for the second point
         *   @param y3 y-coordinate for the second point
         *   @param x4 x-coordinate for the ending control
         *   point
         *   @param y4 y-coordinate for the ending control
         *   point
         *   @chainable
         */
        curve(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): p5;

        /**
         *   Draws a curved line on the screen between two
         *   points, given as the middle four parameters. The
         *   first two parameters are a control point, as if
         *   the curve came from this point even though it's
         *   not drawn. The last two parameters similarly
         *   describe the other control point.  Longer curves
         *   can be created by putting a series of curve()
         *   functions together or using curveVertex(). An
         *   additional function called curveTightness()
         *   provides control for the visual quality of the
         *   curve. The curve() function is an implementation
         *   of Catmull-Rom splines.
         *   @param x1 x-coordinate for the beginning control
         *   point
         *   @param y1 y-coordinate for the beginning control
         *   point
         *   @param z1 z-coordinate for the beginning control
         *   point
         *   @param x2 x-coordinate for the first point
         *   @param y2 y-coordinate for the first point
         *   @param z2 z-coordinate for the first point
         *   @param x3 x-coordinate for the second point
         *   @param y3 y-coordinate for the second point
         *   @param z3 z-coordinate for the second point
         *   @param x4 x-coordinate for the ending control
         *   point
         *   @param y4 y-coordinate for the ending control
         *   point
         *   @param z4 z-coordinate for the ending control
         *   point
         *   @chainable
         */
        curve(
            x1: number,
            y1: number,
            z1: number,
            x2: number,
            y2: number,
            z2: number,
            x3: number,
            y3: number,
            z3: number,
            x4: number,
            y4: number,
            z4: number
        ): p5;

        /**
         *   Sets the resolution at which curves display. The
         *   default value is 20 while the minimum value is 3.
         *   This function is only useful when using the WEBGL
         *   renderer as the default canvas renderer does not
         *   use this information.
         *   @param resolution resolution of the curves
         *   @chainable
         */
        curveDetail(resolution: number): p5;

        /**
         *   Modifies the quality of forms created with curve()
         *   and curveVertex().The parameter tightness
         *   determines how the curve fits to the vertex
         *   points. The value 0.0 is the default value for
         *   tightness (this value defines the curves to be
         *   Catmull-Rom splines) and the value 1.0 connects
         *   all the points with straight lines. Values within
         *   the range -5.0 and 5.0 will deform the curves but
         *   will leave them recognizable and as values
         *   increase in magnitude, they will continue to
         *   deform.
         *   @param amount amount of deformation from the
         *   original vertices
         *   @chainable
         */
        curveTightness(amount: number): p5;

        /**
         *   Evaluates the curve at position t for points a, b,
         *   c, d. The parameter t varies between 0 and 1, a
         *   and d are control points of the curve, and b and c
         *   are the start and end points of the curve. This
         *   can be done once with the x coordinates and a
         *   second time with the y coordinates to get the
         *   location of a curve at t.
         *   @param a coordinate of first control point of the
         *   curve
         *   @param b coordinate of first point
         *   @param c coordinate of second point
         *   @param d coordinate of second control point
         *   @param t value between 0 and 1
         *   @return Curve value at position t
         */
        curvePoint(a: number, b: number, c: number, d: number, t: number): number;

        /**
         *   Evaluates the tangent to the curve at position t
         *   for points a, b, c, d. The parameter t varies
         *   between 0 and 1, a and d are points on the curve,
         *   and b and c are the control points.
         *   @param a coordinate of first control point
         *   @param b coordinate of first point on the curve
         *   @param c coordinate of second point on the curve
         *   @param d coordinate of second conrol point
         *   @param t value between 0 and 1
         *   @return the tangent at position t
         */
        curveTangent(a: number, b: number, c: number, d: number, t: number): number;
    }

// Inlined from: ./src/core/shape/vertex.d.ts

    interface p5InstanceExtensions {
        /**
         *   Use the beginContour() and endContour() functions
         *   to create negative shapes within shapes such as
         *   the center of the letter 'O'. beginContour()
         *   begins recording vertices for the shape and
         *   endContour() stops recording. The vertices that
         *   define a negative shape must "wind" in the
         *   opposite direction from the exterior shape. First
         *   draw vertices for the exterior clockwise order,
         *   then for internal shapes, draw vertices shape in
         *   counter-clockwise. These functions can only be
         *   used within a beginShape()/endShape() pair and
         *   transformations such as translate(), rotate(), and
         *   scale() do not work within a
         *   beginContour()/endContour() pair. It is also not
         *   possible to use other shapes, such as ellipse() or
         *   rect() within.
         *   @chainable
         */
        beginContour(): p5;

        /**
         *   Using the beginShape() and endShape() functions
         *   allow creating more complex forms. beginShape()
         *   begins recording vertices for a shape and
         *   endShape() stops recording. The value of the kind
         *   parameter tells it which types of shapes to create
         *   from the provided vertices. With no mode
         *   specified, the shape can be any irregular polygon.
         *   The parameters available for beginShape() are:
         *
         *   POINTS Draw a series of points
         *
         *   LINES Draw a series of unconnected line segments
         *   (individual lines)
         *
         *   TRIANGLES Draw a series of separate triangles
         *
         *   TRIANGLE_FAN Draw a series of connected triangles
         *   sharing the first vertex in a fan-like fashion
         *
         *   TRIANGLE_STRIP Draw a series of connected
         *   triangles in strip fashion
         *
         *   QUADS Draw a series of separate quads
         *
         *   QUAD_STRIP Draw quad strip using adjacent edges to
         *   form the next quad
         *
         *   TESS (WEBGL only) Handle irregular polygon for
         *   filling curve by explicit tessellation
         *
         *   After calling the beginShape() function, a series
         *   of vertex() commands must follow. To stop drawing
         *   the shape, call endShape(). Each shape will be
         *   outlined with the current stroke color and filled
         *   with the fill color.
         *
         *   Transformations such as translate(), rotate(), and
         *   scale() do not work within beginShape(). It is
         *   also not possible to use other shapes, such as
         *   ellipse() or rect() within beginShape().
         *   @param [kind] either POINTS, LINES, TRIANGLES,
         *   TRIANGLE_FAN TRIANGLE_STRIP, QUADS, QUAD_STRIP or
         *   TESS
         *   @chainable
         */
        beginShape(kind?: BEGIN_KIND): p5;

        /**
         *   Specifies vertex coordinates for Bezier curves.
         *   Each call to bezierVertex() defines the position
         *   of two control points and one anchor point of a
         *   Bezier curve, adding a new segment to a line or
         *   shape. For WebGL mode bezierVertex() can be used
         *   in 2D as well as 3D mode. 2D mode expects 6
         *   parameters, while 3D mode expects 9 parameters
         *   (including z coordinates). The first time
         *   bezierVertex() is used within a beginShape() call,
         *   it must be prefaced with a call to vertex() to set
         *   the first anchor point. This function must be used
         *   between beginShape() and endShape() and only when
         *   there is no MODE or POINTS parameter specified to
         *   beginShape().
         *   @param x2 x-coordinate for the first control point
         *   @param y2 y-coordinate for the first control point
         *   @param x3 x-coordinate for the second control
         *   point
         *   @param y3 y-coordinate for the second control
         *   point
         *   @param x4 x-coordinate for the anchor point
         *   @param y4 y-coordinate for the anchor point
         *   @chainable
         */
        bezierVertex(x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): p5;

        /**
         *   Specifies vertex coordinates for Bezier curves.
         *   Each call to bezierVertex() defines the position
         *   of two control points and one anchor point of a
         *   Bezier curve, adding a new segment to a line or
         *   shape. For WebGL mode bezierVertex() can be used
         *   in 2D as well as 3D mode. 2D mode expects 6
         *   parameters, while 3D mode expects 9 parameters
         *   (including z coordinates). The first time
         *   bezierVertex() is used within a beginShape() call,
         *   it must be prefaced with a call to vertex() to set
         *   the first anchor point. This function must be used
         *   between beginShape() and endShape() and only when
         *   there is no MODE or POINTS parameter specified to
         *   beginShape().
         *   @param x2 x-coordinate for the first control point
         *   @param y2 y-coordinate for the first control point
         *   @param z2 z-coordinate for the first control point
         *   (for WebGL mode)
         *   @param x3 x-coordinate for the second control
         *   point
         *   @param y3 y-coordinate for the second control
         *   point
         *   @param z3 z-coordinate for the second control
         *   point (for WebGL mode)
         *   @param x4 x-coordinate for the anchor point
         *   @param y4 y-coordinate for the anchor point
         *   @param z4 z-coordinate for the anchor point (for
         *   WebGL mode)
         *   @chainable
         */
        bezierVertex(
            x2: number,
            y2: number,
            z2: number,
            x3: number,
            y3: number,
            z3: number,
            x4: number,
            y4: number,
            z4: number
        ): p5;

        /**
         *   Specifies vertex coordinates for curves. This
         *   function may only be used between beginShape() and
         *   endShape() and only when there is no MODE
         *   parameter specified to beginShape(). For WebGL
         *   mode curveVertex() can be used in 2D as well as 3D
         *   mode. 2D mode expects 2 parameters, while 3D mode
         *   expects 3 parameters. The first and last points in
         *   a series of curveVertex() lines will be used to
         *   guide the beginning and end of the curve. A
         *   minimum of four points is required to draw a tiny
         *   curve between the second and third points. Adding
         *   a fifth point with curveVertex() will draw the
         *   curve between the second, third, and fourth
         *   points. The curveVertex() function is an
         *   implementation of Catmull-Rom splines.
         *   @param x x-coordinate of the vertex
         *   @param y y-coordinate of the vertex
         *   @chainable
         */
        curveVertex(x: number, y: number): p5;

        /**
         *   Specifies vertex coordinates for curves. This
         *   function may only be used between beginShape() and
         *   endShape() and only when there is no MODE
         *   parameter specified to beginShape(). For WebGL
         *   mode curveVertex() can be used in 2D as well as 3D
         *   mode. 2D mode expects 2 parameters, while 3D mode
         *   expects 3 parameters. The first and last points in
         *   a series of curveVertex() lines will be used to
         *   guide the beginning and end of the curve. A
         *   minimum of four points is required to draw a tiny
         *   curve between the second and third points. Adding
         *   a fifth point with curveVertex() will draw the
         *   curve between the second, third, and fourth
         *   points. The curveVertex() function is an
         *   implementation of Catmull-Rom splines.
         *   @param x x-coordinate of the vertex
         *   @param y y-coordinate of the vertex
         *   @param [z] z-coordinate of the vertex (for WebGL
         *   mode)
         *   @chainable
         */
        curveVertex(x: number, y: number, z?: number): p5;

        /**
         *   Use the beginContour() and endContour() functions
         *   to create negative shapes within shapes such as
         *   the center of the letter 'O'. beginContour()
         *   begins recording vertices for the shape and
         *   endContour() stops recording. The vertices that
         *   define a negative shape must "wind" in the
         *   opposite direction from the exterior shape. First
         *   draw vertices for the exterior clockwise order,
         *   then for internal shapes, draw vertices shape in
         *   counter-clockwise. These functions can only be
         *   used within a beginShape()/endShape() pair and
         *   transformations such as translate(), rotate(), and
         *   scale() do not work within a
         *   beginContour()/endContour() pair. It is also not
         *   possible to use other shapes, such as ellipse() or
         *   rect() within.
         *   @chainable
         */
        endContour(): p5;

        /**
         *   The endShape() function is the companion to
         *   beginShape() and may only be called after
         *   beginShape(). When endShape() is called, all of
         *   the image data defined since the previous call to
         *   beginShape() is written into the image buffer. The
         *   constant CLOSE as the value for the mode parameter
         *   to close the shape (to connect the beginning and
         *   the end).
         *   @param [mode] use CLOSE to close the shape
         *   @chainable
         */
        endShape(mode?: END_MODE): p5;

        /**
         *   Specifies vertex coordinates for quadratic Bezier
         *   curves. Each call to quadraticVertex() defines the
         *   position of one control points and one anchor
         *   point of a Bezier curve, adding a new segment to a
         *   line or shape. The first time quadraticVertex() is
         *   used within a beginShape() call, it must be
         *   prefaced with a call to vertex() to set the first
         *   anchor point. For WebGL mode quadraticVertex() can
         *   be used in 2D as well as 3D mode. 2D mode expects
         *   4 parameters, while 3D mode expects 6 parameters
         *   (including z coordinates). This function must be
         *   used between beginShape() and endShape() and only
         *   when there is no MODE or POINTS parameter
         *   specified to beginShape().
         *   @param cx x-coordinate for the control point
         *   @param cy y-coordinate for the control point
         *   @param x3 x-coordinate for the anchor point
         *   @param y3 y-coordinate for the anchor point
         *   @chainable
         */
        quadraticVertex(cx: number, cy: number, x3: number, y3: number): p5;

        /**
         *   Specifies vertex coordinates for quadratic Bezier
         *   curves. Each call to quadraticVertex() defines the
         *   position of one control points and one anchor
         *   point of a Bezier curve, adding a new segment to a
         *   line or shape. The first time quadraticVertex() is
         *   used within a beginShape() call, it must be
         *   prefaced with a call to vertex() to set the first
         *   anchor point. For WebGL mode quadraticVertex() can
         *   be used in 2D as well as 3D mode. 2D mode expects
         *   4 parameters, while 3D mode expects 6 parameters
         *   (including z coordinates). This function must be
         *   used between beginShape() and endShape() and only
         *   when there is no MODE or POINTS parameter
         *   specified to beginShape().
         *   @param cx x-coordinate for the control point
         *   @param cy y-coordinate for the control point
         *   @param cz z-coordinate for the control point (for
         *   WebGL mode)
         *   @param x3 x-coordinate for the anchor point
         *   @param y3 y-coordinate for the anchor point
         *   @param z3 z-coordinate for the anchor point (for
         *   WebGL mode)
         *   @chainable
         */
        quadraticVertex(cx: number, cy: number, cz: number, x3: number, y3: number, z3: number): p5;

        /**
         *   All shapes are constructed by connecting a series
         *   of vertices. vertex() is used to specify the
         *   vertex coordinates for points, lines, triangles,
         *   quads, and polygons. It is used exclusively within
         *   the beginShape() and endShape() functions.
         *   @param x x-coordinate of the vertex
         *   @param y y-coordinate of the vertex
         *   @chainable
         */
        vertex(x: number, y: number): p5;

        /**
         *   All shapes are constructed by connecting a series
         *   of vertices. vertex() is used to specify the
         *   vertex coordinates for points, lines, triangles,
         *   quads, and polygons. It is used exclusively within
         *   the beginShape() and endShape() functions.
         *   @param x x-coordinate of the vertex
         *   @param y y-coordinate of the vertex
         *   @param [z] z-coordinate of the vertex. Defaults to
         *   0 if not specified.
         *   @chainable
         */
        vertex(x: number, y: number, z?: number): p5;

        /**
         *   All shapes are constructed by connecting a series
         *   of vertices. vertex() is used to specify the
         *   vertex coordinates for points, lines, triangles,
         *   quads, and polygons. It is used exclusively within
         *   the beginShape() and endShape() functions.
         *   @param x x-coordinate of the vertex
         *   @param y y-coordinate of the vertex
         *   @param [z] z-coordinate of the vertex. Defaults to
         *   0 if not specified.
         *   @param [u] the vertex's texture u-coordinate
         *   @param [v] the vertex's texture v-coordinate
         *   @chainable
         */
        vertex(x: number, y: number, z?: number, u?: number, v?: number): p5;

        /**
         *   Sets the 3d vertex normal to use for subsequent
         *   vertices drawn with vertex(). A normal is a vector
         *   that is generally nearly perpendicular to a
         *   shape's surface which controls how much light will
         *   be reflected from that part of the surface.
         *   @param vector A p5.Vector representing the vertex
         *   normal.
         *   @chainable
         */
        normal(vector: Vector): p5;

        /**
         *   Sets the 3d vertex normal to use for subsequent
         *   vertices drawn with vertex(). A normal is a vector
         *   that is generally nearly perpendicular to a
         *   shape's surface which controls how much light will
         *   be reflected from that part of the surface.
         *   @param x The x component of the vertex normal.
         *   @param y The y component of the vertex normal.
         *   @param z The z component of the vertex normal.
         *   @chainable
         */
        normal(x: number, y: number, z: number): p5;
    }

// Inlined from: ./src/core/constants.d.ts

    interface p5InstanceExtensions {
        /**
         *   Version of this p5.js.
         */
        readonly VERSION: VERSION;

        /**
         *   The default, two-dimensional renderer.
         */
        readonly P2D: P2D;

        /**
         *   One of the two render modes in p5.js, used for
         *   computationally intensive tasks like 3D rendering
         *   and shaders. WEBGL differs from the default P2D
         *   renderer in the following ways:
         *
         *   - Coordinate System - When drawing in WEBGL mode,
         *   the origin point (0,0,0) is located at the center
         *   of the screen, not the top-left corner. See the
         *   learn page about coordinates and transformations.
         *   - 3D Shapes - WEBGL mode can be used to draw
         *   3-dimensional shapes like box(), sphere(), cone(),
         *   and more. See the learn page about custom geometry
         *   to make more complex objects.
         *   - Shape Detail - When drawing in WEBGL mode, you
         *   can specify how smooth curves should be drawn by
         *   using a detail parameter. See the wiki section
         *   about shapes for a more information and an
         *   example.
         *   - Textures - A texture is like a skin that wraps
         *   onto a shape. See the wiki section about textures
         *   for examples of mapping images onto surfaces with
         *   textures.
         *   - Materials and Lighting - WEBGL offers different
         *   types of lights like ambientLight() to place
         *   around a scene. Materials like specularMaterial()
         *   reflect the lighting to convey shape and depth.
         *   See the learn page for styling and appearance to
         *   experiment with different combinations.
         *   - Camera - The viewport of a WEBGL sketch can be
         *   adjusted by changing camera attributes. See the
         *   learn page section about cameras for an
         *   explanation of camera controls.
         *   - Text - WEBGL requires opentype/truetype font
         *   files to be preloaded using loadFont(). See the
         *   wiki section about text for details, along with a
         *   workaround.
         *   - Shaders - Shaders are hardware accelerated
         *   programs that can be used for a variety of effects
         *   and graphics. See the introduction to shaders to
         *   get started with shaders in p5.js.
         *   - Graphics Acceleration - WEBGL mode uses the
         *   graphics card instead of the CPU, so it may help
         *   boost the performance of your sketch (example:
         *   drawing more shapes on the screen at once).
         *
         *   To learn more about WEBGL mode, check out all the
         *   interactive WEBGL tutorials in the "Learn" section
         *   of this website, or read the wiki article "Getting
         *   started with WebGL in p5".
         */
        readonly WEBGL: WEBGL;

        /**
         *   One of the two possible values of a WebGL canvas
         *   (either WEBGL or WEBGL2), which can be used to
         *   determine what capabilities the rendering
         *   environment has.
         */
        readonly WEBGL2: WEBGL2;
        readonly ARROW: ARROW;
        readonly CROSS: CROSS;
        readonly HAND: HAND;
        readonly MOVE: MOVE;
        readonly TEXT: TEXT;
        readonly WAIT: WAIT;

        /**
         *   HALF_PI is a mathematical constant with the value
         *   1.57079632679489661923. It is half the ratio of
         *   the circumference of a circle to its diameter. It
         *   is useful in combination with the trigonometric
         *   functions sin() and cos().
         */
        readonly HALF_PI: number;

        /**
         *   PI is a mathematical constant with the value
         *   3.14159265358979323846. It is the ratio of the
         *   circumference of a circle to its diameter. It is
         *   useful in combination with the trigonometric
         *   functions sin() and cos().
         */
        readonly PI: number;

        /**
         *   QUARTER_PI is a mathematical constant with the
         *   value 0.7853982. It is one quarter the ratio of
         *   the circumference of a circle to its diameter. It
         *   is useful in combination with the trigonometric
         *   functions sin() and cos().
         */
        readonly QUARTER_PI: number;

        /**
         *   TAU is an alias for TWO_PI, a mathematical
         *   constant with the value 6.28318530717958647693. It
         *   is twice the ratio of the circumference of a
         *   circle to its diameter. It is useful in
         *   combination with the trigonometric functions sin()
         *   and cos().
         */
        readonly TAU: number;

        /**
         *   TWO_PI is a mathematical constant with the value
         *   6.28318530717958647693. It is twice the ratio of
         *   the circumference of a circle to its diameter. It
         *   is useful in combination with the trigonometric
         *   functions sin() and cos().
         */
        readonly TWO_PI: number;

        /**
         *   Constant to be used with the angleMode() function,
         *   to set the mode in which p5.js interprets and
         *   calculates angles (either DEGREES or RADIANS).
         */
        readonly DEGREES: DEGREES;

        /**
         *   Constant to be used with the angleMode() function,
         *   to set the mode in which p5.js interprets and
         *   calculates angles (either RADIANS or DEGREES).
         */
        readonly RADIANS: RADIANS;
        readonly CORNER: CORNER;
        readonly CORNERS: CORNERS;
        readonly RADIUS: RADIUS;
        readonly RIGHT: RIGHT;
        readonly LEFT: LEFT;
        readonly CENTER: CENTER;
        readonly TOP: TOP;
        readonly BOTTOM: BOTTOM;
        readonly BASELINE: BASELINE;
        readonly POINTS: POINTS;
        readonly LINES: LINES;
        readonly LINE_STRIP: LINE_STRIP;
        readonly LINE_LOOP: LINE_LOOP;
        readonly TRIANGLES: TRIANGLES;
        readonly TRIANGLE_FAN: TRIANGLE_FAN;
        readonly TRIANGLE_STRIP: TRIANGLE_STRIP;
        readonly QUADS: QUADS;
        readonly QUAD_STRIP: QUAD_STRIP;
        readonly TESS: TESS;
        readonly CLOSE: CLOSE;
        readonly OPEN: OPEN;
        readonly CHORD: CHORD;
        readonly PIE: PIE;
        readonly PROJECT: PROJECT;
        readonly SQUARE: SQUARE;
        readonly ROUND: ROUND;
        readonly BEVEL: BEVEL;
        readonly MITER: MITER;
        readonly RGB: RGB;

        /**
         *   HSB (hue, saturation, brightness) is a type of
         *   color model. You can learn more about it at HSB.
         */
        readonly HSB: HSB;
        readonly HSL: HSL;

        /**
         *   AUTO allows us to automatically set the width or
         *   height of an element (but not both), based on the
         *   current height and width of the element. Only one
         *   parameter can be passed to the size function as
         *   AUTO, at a time.
         */
        readonly AUTO: AUTO;
        readonly ALT: number;
        readonly BACKSPACE: number;
        readonly CONTROL: number;
        readonly DELETE: number;
        readonly DOWN_ARROW: number;
        readonly ENTER: number;
        readonly ESCAPE: number;
        readonly LEFT_ARROW: number;
        readonly OPTION: number;
        readonly RETURN: number;
        readonly RIGHT_ARROW: number;
        readonly SHIFT: number;
        readonly TAB: number;
        readonly UP_ARROW: number;
        readonly BLEND: BLEND;
        readonly REMOVE: REMOVE;
        readonly ADD: ADD;
        readonly DARKEST: DARKEST;
        readonly LIGHTEST: LIGHTEST;
        readonly DIFFERENCE: DIFFERENCE;
        readonly SUBTRACT: SUBTRACT;
        readonly EXCLUSION: EXCLUSION;
        readonly MULTIPLY: MULTIPLY;
        readonly SCREEN: SCREEN;
        readonly REPLACE: REPLACE;
        readonly OVERLAY: OVERLAY;
        readonly HARD_LIGHT: HARD_LIGHT;
        readonly SOFT_LIGHT: SOFT_LIGHT;
        readonly DODGE: DODGE;
        readonly BURN: BURN;
        readonly THRESHOLD: THRESHOLD;
        readonly GRAY: GRAY;
        readonly OPAQUE: OPAQUE;
        readonly INVERT: INVERT;
        readonly POSTERIZE: POSTERIZE;
        readonly DILATE: DILATE;
        readonly ERODE: ERODE;
        readonly BLUR: BLUR;
        readonly NORMAL: NORMAL;
        readonly ITALIC: ITALIC;
        readonly BOLD: BOLD;
        readonly BOLDITALIC: BOLDITALIC;
        readonly CHAR: CHAR;
        readonly WORD: WORD;
        readonly LINEAR: LINEAR;
        readonly QUADRATIC: QUADRATIC;
        readonly BEZIER: BEZIER;
        readonly CURVE: CURVE;
        readonly STROKE: STROKE;
        readonly FILL: FILL;
        readonly TEXTURE: TEXTURE;
        readonly IMMEDIATE: IMMEDIATE;
        readonly IMAGE: IMAGE;
        readonly NEAREST: NEAREST;
        readonly REPEAT: REPEAT;
        readonly CLAMP: CLAMP;
        readonly MIRROR: MIRROR;
        readonly LANDSCAPE: LANDSCAPE;
        readonly PORTRAIT: PORTRAIT;
        readonly GRID: GRID;
        readonly AXES: AXES;
        readonly LABEL: LABEL;
        readonly FALLBACK: FALLBACK;
        readonly CONTAIN: CONTAIN;
        readonly COVER: COVER;
        readonly UNSIGNED_BYTE: UNSIGNED_BYTE;
        readonly UNSIGNED_INT: UNSIGNED_INT;
        readonly HALF_FLOAT: HALF_FLOAT;
        readonly FLOAT: FLOAT;
        readonly RGBA: RGBA;
    }

// Inlined from: ./src/core/environment.d.ts

    interface p5InstanceExtensions {
        /**
         *   The print() function writes to the console area of
         *   your browser. This function is often helpful for
         *   looking at the data a program is producing. This
         *   function creates a new line of text for each call
         *   to the function. Individual elements can be
         *   separated with quotes ("") and joined with the
         *   addition operator (+). Note that calling print()
         *   without any arguments invokes the window.print()
         *   function which opens the browser's print dialog.
         *   To print a blank line to console you can write
         *   print('\n').
         *   @param contents any combination of Number, String,
         *   Object, Boolean, Array to print
         */
        print(contents: any): void;

        /**
         *   Sets the cursor to a predefined symbol or an
         *   image, or makes it visible if already hidden. If
         *   you are trying to set an image as the cursor, the
         *   recommended size is 16×16 or 32×32 pixels. The
         *   values for parameters x and y must be less than
         *   the dimensions of the image.
         *   @param type Built-In: either ARROW, CROSS, HAND,
         *   MOVE, TEXT and WAIT Native CSS properties: 'grab',
         *   'progress', 'cell' etc. External: path for
         *   cursor's images (Allowed File extensions: .cur,
         *   .gif, .jpg, .jpeg, .png) For more information on
         *   Native CSS cursors and url visit:
         *   https://developer.mozilla.org/en-US/docs/Web/CSS/cursor
         *   @param [x] the horizontal active spot of the
         *   cursor (must be less than 32)
         *   @param [y] the vertical active spot of the cursor
         *   (must be less than 32)
         */
        cursor(type: string | CURSOR_TYPE, x?: number, y?: number): void;

        /**
         *   Specifies the number of frames to be displayed
         *   every second. For example, the function call
         *   frameRate(30) will attempt to refresh 30 times a
         *   second. If the processor is not fast enough to
         *   maintain the specified rate, the frame rate will
         *   not be achieved. Setting the frame rate within
         *   setup() is recommended. The default frame rate is
         *   based on the frame rate of the display (here also
         *   called "refresh rate"), which is set to 60 frames
         *   per second on most computers. A frame rate of 24
         *   frames per second (usual for movies) or above will
         *   be enough for smooth animations. This is the same
         *   as setFrameRate(val). Calling frameRate() with no
         *   arguments returns the current framerate. The draw
         *   function must run at least once before it will
         *   return a value. This is the same as
         *   getFrameRate().
         *
         *   Calling frameRate() with arguments that are not of
         *   the type Number or are non-positive also returns
         *   current framerate.
         *   @param fps number of frames to be displayed every
         *   second
         *   @chainable
         */
        frameRate(fps: number): p5;

        /**
         *   Specifies the number of frames to be displayed
         *   every second. For example, the function call
         *   frameRate(30) will attempt to refresh 30 times a
         *   second. If the processor is not fast enough to
         *   maintain the specified rate, the frame rate will
         *   not be achieved. Setting the frame rate within
         *   setup() is recommended. The default frame rate is
         *   based on the frame rate of the display (here also
         *   called "refresh rate"), which is set to 60 frames
         *   per second on most computers. A frame rate of 24
         *   frames per second (usual for movies) or above will
         *   be enough for smooth animations. This is the same
         *   as setFrameRate(val). Calling frameRate() with no
         *   arguments returns the current framerate. The draw
         *   function must run at least once before it will
         *   return a value. This is the same as
         *   getFrameRate().
         *
         *   Calling frameRate() with arguments that are not of
         *   the type Number or are non-positive also returns
         *   current framerate.
         *   @return current frameRate
         */
        frameRate(): number;

        /**
         *   Returns _targetFrameRate variable. The default
         *   _targetFrameRate is set to 60. This could be
         *   changed by calling frameRate() and setting it to
         *   the desired value. When getTargetFrameRate() is
         *   called, it should return the value that was set.
         *   @return _targetFrameRate
         */
        getTargetFrameRate(): number;

        /**
         *   Hides the cursor from view.
         */
        noCursor(): void;

        /**
         *   The windowResized() function is called once every
         *   time the browser window is resized. This is a good
         *   place to resize the canvas or do any other
         *   adjustments to accommodate the new window size.
         *   @param [event] optional Event callback argument.
         */
        windowResized(event?: object): void;

        /**
         *   If argument is given, sets the sketch to
         *   fullscreen or not based on the value of the
         *   argument. If no argument is given, returns the
         *   current fullscreen state. Note that due to browser
         *   restrictions this can only be called on user
         *   input, for example, on mouse press like the
         *   example below.
         *   @param [val] whether the sketch should be in
         *   fullscreen mode or not
         *   @return current fullscreen state
         */
        fullscreen(val?: boolean): boolean;

        /**
         *   Sets the pixel scaling for high pixel density
         *   displays. By default pixel density is set to match
         *   display density, call pixelDensity(1) to turn this
         *   off. Calling pixelDensity() with no arguments
         *   returns the current pixel density of the sketch.
         *   @param val whether or how much the sketch should
         *   scale
         *   @chainable
         */
        pixelDensity(val: number): p5;

        /**
         *   Sets the pixel scaling for high pixel density
         *   displays. By default pixel density is set to match
         *   display density, call pixelDensity(1) to turn this
         *   off. Calling pixelDensity() with no arguments
         *   returns the current pixel density of the sketch.
         *   @return current pixel density of the sketch
         */
        pixelDensity(): number;

        /**
         *   Returns the pixel density of the current display
         *   the sketch is running on.
         *   @return current pixel density of the display
         */
        displayDensity(): number;

        /**
         *   Gets the current URL. Note: when using the p5
         *   Editor, this will return an empty object because
         *   the sketch is embedded in an iframe. It will work
         *   correctly if you view the sketch using the
         *   editor's present or share URLs.
         *   @return url
         */
        getURL(): string;

        /**
         *   Gets the current URL path as an array. Note: when
         *   using the p5 Editor, this will return an empty
         *   object because the sketch is embedded in an
         *   iframe. It will work correctly if you view the
         *   sketch using the editor's present or share URLs.
         *   @return path components
         */
        getURLPath(): string[];

        /**
         *   Gets the current URL params as an Object. Note:
         *   when using the p5 Editor, this will return an
         *   empty object because the sketch is embedded in an
         *   iframe. It will work correctly if you view the
         *   sketch using the editor's present or share URLs.
         *   @return URL params
         */
        getURLParams(): object;

        /**
         *   The system variable frameCount contains the number
         *   of frames that have been displayed since the
         *   program started. Inside setup() the value is 0,
         *   after the first iteration of draw() it is 1, etc.
         */
        frameCount: number;

        /**
         *   The system variable deltaTime contains the time
         *   difference between the beginning of the previous
         *   frame and the beginning of the current frame in
         *   milliseconds. This variable is useful for creating
         *   time sensitive animation or physics calculation
         *   that should stay constant regardless of frame
         *   rate.
         */
        deltaTime: number;

        /**
         *   Confirms if the window a p5.js program is in is
         *   "focused," meaning that the sketch will accept
         *   mouse or keyboard input. This variable is "true"
         *   if the window is focused and "false" if not.
         */
        focused: boolean;

        /**
         *   If the sketch was created in WebGL mode, then
         *   weglVersion will indicate which version of WebGL
         *   it is using. It will try to create a WebGL2 canvas
         *   unless you have requested WebGL1 via
         *   setAttributes({ version: 1 }), and will fall back
         *   to WebGL1 if WebGL2 is not available. webglVersion
         *   will always be either WEBGL2, WEBGL, or P2D if not
         *   in WebGL mode.
         */
        webglVersion: string;

        /**
         *   System variable that stores the width of the
         *   screen display according to The default
         *   pixelDensity. This is used to run a full-screen
         *   program on any display size. To return actual
         *   screen size, multiply this by pixelDensity.
         */
        displayWidth: number;

        /**
         *   System variable that stores the height of the
         *   screen display according to The default
         *   pixelDensity. This is used to run a full-screen
         *   program on any display size. To return actual
         *   screen size, multiply this by pixelDensity.
         */
        displayHeight: number;

        /**
         *   System variable that stores the width of the inner
         *   window, it maps to window.innerWidth.
         */
        windowWidth: number;

        /**
         *   System variable that stores the height of the
         *   inner window, it maps to window.innerHeight.
         */
        windowHeight: number;

        /**
         *   System variable that stores the width of the
         *   drawing canvas. This value is set by the first
         *   parameter of the createCanvas() function. For
         *   example, the function call createCanvas(320, 240)
         *   sets the width variable to the value 320. The
         *   value of width defaults to 100 if createCanvas()
         *   is not used in a program.
         */
        width: number;

        /**
         *   System variable that stores the height of the
         *   drawing canvas. This value is set by the second
         *   parameter of the createCanvas() function. For
         *   example, the function call createCanvas(320, 240)
         *   sets the height variable to the value 240. The
         *   value of height defaults to 100 if createCanvas()
         *   is not used in a program.
         */
        height: number;
    }

// Inlined from: ./src/core/rendering.d.ts

    interface p5InstanceExtensions {
        /**
         *   Creates a canvas element in the document and sets
         *   its dimensions in pixels. This method should be
         *   called only once at the start of setup(). Calling
         *   createCanvas more than once in a sketch will
         *   result in very unpredictable behavior. If you want
         *   more than one drawing canvas you could use
         *   createGraphics() (hidden by default but it can be
         *   shown). Important note: in 2D mode (i.e. when
         *   p5.Renderer is not set) the origin (0,0) is
         *   positioned at the top left of the screen. In 3D
         *   mode (i.e. when p5.Renderer is set to WEBGL), the
         *   origin is positioned at the center of the canvas.
         *   See this issue for more information.
         *
         *   A WebGL canvas will use a WebGL2 context if it is
         *   supported by the browser. Check the webglVersion
         *   property to check what version is being used, or
         *   call setAttributes({ version: 1 }) to create a
         *   WebGL1 context.
         *
         *   The system variables width and height are set by
         *   the parameters passed to this function. If
         *   createCanvas() is not used, the window will be
         *   given a default size of 100×100 pixels.
         *
         *   Optionally, an existing canvas can be passed using
         *   a selector, ie. document.getElementById(''). If
         *   specified, avoid using setAttributes() afterwards,
         *   as this will remove and recreate the existing
         *   canvas.
         *
         *   For more ways to position the canvas, see the
         *   positioning the canvas wiki page.
         *   @param w width of the canvas
         *   @param h height of the canvas
         *   @param [renderer] either P2D or WEBGL
         *   @param [canvas] existing html canvas element
         *   @return pointer to p5.Renderer holding canvas
         */
        createCanvas(w: number, h: number, renderer?: RENDERER, canvas?: object): Renderer;

        /**
         *   Creates a canvas element in the document and sets
         *   its dimensions in pixels. This method should be
         *   called only once at the start of setup(). Calling
         *   createCanvas more than once in a sketch will
         *   result in very unpredictable behavior. If you want
         *   more than one drawing canvas you could use
         *   createGraphics() (hidden by default but it can be
         *   shown). Important note: in 2D mode (i.e. when
         *   p5.Renderer is not set) the origin (0,0) is
         *   positioned at the top left of the screen. In 3D
         *   mode (i.e. when p5.Renderer is set to WEBGL), the
         *   origin is positioned at the center of the canvas.
         *   See this issue for more information.
         *
         *   A WebGL canvas will use a WebGL2 context if it is
         *   supported by the browser. Check the webglVersion
         *   property to check what version is being used, or
         *   call setAttributes({ version: 1 }) to create a
         *   WebGL1 context.
         *
         *   The system variables width and height are set by
         *   the parameters passed to this function. If
         *   createCanvas() is not used, the window will be
         *   given a default size of 100×100 pixels.
         *
         *   Optionally, an existing canvas can be passed using
         *   a selector, ie. document.getElementById(''). If
         *   specified, avoid using setAttributes() afterwards,
         *   as this will remove and recreate the existing
         *   canvas.
         *
         *   For more ways to position the canvas, see the
         *   positioning the canvas wiki page.
         *   @param w width of the canvas
         *   @param h height of the canvas
         *   @param [canvas] existing html canvas element
         *   @return pointer to p5.Renderer holding canvas
         */
        createCanvas(w: number, h: number, canvas?: object): Renderer;

        /**
         *   Resizes the canvas to given width and height. The
         *   canvas will be cleared and draw will be called
         *   immediately, allowing the sketch to re-render
         *   itself in the resized canvas.
         *   @param w width of the canvas
         *   @param h height of the canvas
         *   @param [noRedraw] don't redraw the canvas
         *   immediately
         */
        resizeCanvas(w: number, h: number, noRedraw?: boolean): void;

        /**
         *   Removes the default canvas for a p5 sketch that
         *   doesn't require a canvas
         */
        noCanvas(): void;

        /**
         *   Creates and returns a new p5.Graphics object. Use
         *   this class if you need to draw into an off-screen
         *   graphics buffer. The two parameters define the
         *   width and height in pixels. A WebGL p5.Graphics
         *   will use a WebGL2 context if it is supported by
         *   the browser. Check the pg.webglVersion property of
         *   the renderer to check what version is being used,
         *   or call pg.setAttributes({ version: 1 }) to create
         *   a WebGL1 context.
         *
         *   Optionally, an existing canvas can be passed using
         *   a selector, ie. document.getElementById(''). By
         *   default this canvas will be hidden (offscreen
         *   buffer), to make visible, set element's style to
         *   display:block;
         *   @param w width of the offscreen graphics buffer
         *   @param h height of the offscreen graphics buffer
         *   @param [renderer] either P2D or WEBGL undefined
         *   defaults to p2d
         *   @param [canvas] existing html canvas element
         *   @return offscreen graphics buffer
         */
        createGraphics(w: number, h: number, renderer?: RENDERER, canvas?: object): Graphics;

        /**
         *   Creates and returns a new p5.Graphics object. Use
         *   this class if you need to draw into an off-screen
         *   graphics buffer. The two parameters define the
         *   width and height in pixels. A WebGL p5.Graphics
         *   will use a WebGL2 context if it is supported by
         *   the browser. Check the pg.webglVersion property of
         *   the renderer to check what version is being used,
         *   or call pg.setAttributes({ version: 1 }) to create
         *   a WebGL1 context.
         *
         *   Optionally, an existing canvas can be passed using
         *   a selector, ie. document.getElementById(''). By
         *   default this canvas will be hidden (offscreen
         *   buffer), to make visible, set element's style to
         *   display:block;
         *   @param w width of the offscreen graphics buffer
         *   @param h height of the offscreen graphics buffer
         *   @param [canvas] existing html canvas element
         *   @return offscreen graphics buffer
         */
        createGraphics(w: number, h: number, canvas?: object): Graphics;

        /**
         *   Creates and returns a new p5.Framebuffer, a
         *   high-performance WebGL object that you can draw to
         *   and then use as a texture. Options can include:
         *
         *   - format: The data format of the texture, either
         *   UNSIGNED_BYTE, FLOAT, or HALF_FLOAT. The default
         *   is UNSIGNED_BYTE.
         *   - channels: What color channels to store, either
         *   RGB or RGBA. The default is to match the channels
         *   in the main canvas (with alpha unless disabled
         *   with setAttributes.)
         *   - depth: A boolean, whether or not to include a
         *   depth buffer. Defaults to true.
         *   - depthFormat: The data format for depth
         *   information, either UNSIGNED_INT or FLOAT. The
         *   default is FLOAT if available, or UNSIGNED_INT
         *   otherwise.
         *   - antialias: Boolean or Number, whether or not to
         *   render with antialiased edges, and if so,
         *   optionally the number of samples to use. Defaults
         *   to whether or not the main canvas is antialiased,
         *   using a default of 2 samples if so. Antialiasing
         *   is only supported when WebGL 2 is available.
         *   - width: The width of the texture. Defaults to
         *   matching the main canvas.
         *   - height: The height of the texture. Defaults to
         *   matching the main canvas.
         *   - density: The pixel density of the texture.
         *   Defaults to the pixel density of the main canvas.
         *   - textureFiltering: Either LINEAR (nearby pixels
         *   will be interpolated when reading values from the
         *   color texture) or NEAREST (no interpolation.)
         *   Generally, use LINEAR when using the texture as an
         *   image, and use NEAREST if reading the texture as
         *   data. Defaults to LINEAR.
         *
         *   If width, height, or density are specified, then
         *   the framebuffer will keep that size until manually
         *   changed. Otherwise, it will be autosized, and it
         *   will update to match the main canvas's size and
         *   density when the main canvas changes.
         *   @param [options] An optional object with
         *   configuration
         */
        createFramebuffer(options?: object): void;

        /**
         *   Blends the pixels in the display window according
         *   to the defined mode. There is a choice of the
         *   following modes to blend the source pixels (A)
         *   with the ones of pixels already in the display
         *   window (B): - BLEND - linear interpolation of
         *   colours: C = A*factor + B. This is the default
         *   blending mode.
         *   - ADD - sum of A and B
         *   - DARKEST - only the darkest colour succeeds: C =
         *   min(A*factor, B).
         *   - LIGHTEST - only the lightest colour succeeds: C
         *   = max(A*factor, B).
         *   - DIFFERENCE - subtract colors from underlying
         *   image. (2D)
         *   - EXCLUSION - similar to DIFFERENCE, but less
         *   extreme.
         *   - MULTIPLY - multiply the colors, result will
         *   always be darker.
         *   - SCREEN - opposite multiply, uses inverse values
         *   of the colors.
         *   - REPLACE - the pixels entirely replace the others
         *   and don't utilize alpha (transparency) values.
         *   - REMOVE - removes pixels from B with the alpha
         *   strength of A.
         *   - OVERLAY - mix of MULTIPLY and SCREEN .
         *   Multiplies dark values, and screens light values.
         *   (2D)
         *   - HARD_LIGHT - SCREEN when greater than 50% gray,
         *   MULTIPLY when lower. (2D)
         *   - SOFT_LIGHT - mix of DARKEST and LIGHTEST. Works
         *   like OVERLAY, but not as harsh. (2D)
         *   - DODGE - lightens light tones and increases
         *   contrast, ignores darks. (2D)
         *   - BURN - darker areas are applied, increasing
         *   contrast, ignores lights. (2D)
         *   - SUBTRACT - remainder of A and B (3D)
         *
         *   (2D) indicates that this blend mode only works in
         *   the 2D renderer.
         *
         *   (3D) indicates that this blend mode only works in
         *   the WEBGL renderer.
         *   @param mode blend mode to set for canvas. either
         *   BLEND, DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
         *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
         *   SOFT_LIGHT, DODGE, BURN, ADD, REMOVE or SUBTRACT
         */
        blendMode(mode: BLEND_MODE): void;

        /**
         *   The p5.js API provides a lot of functionality for
         *   creating graphics, but there is some native HTML5
         *   Canvas functionality that is not exposed by p5.
         *   You can still call it directly using the variable
         *   drawingContext, as in the example shown. This is
         *   the equivalent of calling canvas.getContext('2d');
         *   or canvas.getContext('webgl');. See this
         *   reference for the native canvas API for possible
         *   drawing functions you can call.
         */
        drawingContext: any;
    }

// Inlined from: ./src/core/structure.d.ts

    interface p5InstanceExtensions {
        /**
         *   Stops p5.js from continuously executing the code
         *   within draw(). If loop() is called, the code in
         *   draw() begins to run continuously again. If using
         *   noLoop() in setup(), it should be the last line
         *   inside the block. When noLoop() is used, it's not
         *   possible to manipulate or access the screen inside
         *   event handling functions such as mousePressed() or
         *   keyPressed(). Instead, use those functions to call
         *   redraw() or loop(), which will run draw(), which
         *   can update the screen properly. This means that
         *   when noLoop() has been called, no drawing can
         *   happen, and functions like saveFrames() or
         *   loadPixels() may not be used.
         *
         *   Note that if the sketch is resized, redraw() will
         *   be called to update the sketch, even after
         *   noLoop() has been specified. Otherwise, the sketch
         *   would enter an odd state until loop() was called.
         *
         *   Use isLooping() to check the current state of
         *   loop().
         */
        noLoop(): void;

        /**
         *   By default, p5.js loops through draw()
         *   continuously, executing the code within it.
         *   However, the draw() loop may be stopped by calling
         *   noLoop(). In that case, the draw() loop can be
         *   resumed with loop(). Avoid calling loop() from
         *   inside setup().
         *
         *   Use isLooping() to check the current state of
         *   loop().
         */
        loop(): void;

        /**
         *   By default, p5.js loops through draw()
         *   continuously, executing the code within it. If the
         *   sketch is stopped with noLoop() or resumed with
         *   loop(), isLooping() returns the current state for
         *   use within custom event handlers.
         */
        isLooping(): boolean;

        /**
         *   The push() function saves the current drawing
         *   style settings and transformations, while pop()
         *   restores these settings. Note that these functions
         *   are always used together. They allow you to change
         *   the style and transformation settings and later
         *   return to what you had. When a new state is
         *   started with push(), it builds on the current
         *   style and transform information. The push() and
         *   pop() functions can be embedded to provide more
         *   control. (See the second example for a
         *   demonstration.) push() stores information related
         *   to the current transformation state and style
         *   settings controlled by the following functions:
         *   fill(), noFill(), noStroke(), stroke(), tint(),
         *   noTint(), strokeWeight(), strokeCap(),
         *   strokeJoin(), imageMode(), rectMode(),
         *   ellipseMode(), colorMode(), textAlign(),
         *   textFont(), textSize(), textLeading(),
         *   applyMatrix(), resetMatrix(), rotate(), scale(),
         *   shearX(), shearY(), translate(), noiseSeed().
         *
         *   In WEBGL mode additional style settings are
         *   stored. These are controlled by the following
         *   functions: setCamera(), ambientLight(),
         *   directionalLight(), pointLight(), texture(),
         *   specularMaterial(), shininess(), normalMaterial()
         *   and shader().
         */
        push(): void;

        /**
         *   The push() function saves the current drawing
         *   style settings and transformations, while pop()
         *   restores these settings. Note that these functions
         *   are always used together. They allow you to change
         *   the style and transformation settings and later
         *   return to what you had. When a new state is
         *   started with push(), it builds on the current
         *   style and transform information. The push() and
         *   pop() functions can be embedded to provide more
         *   control. (See the second example for a
         *   demonstration.) push() stores information related
         *   to the current transformation state and style
         *   settings controlled by the following functions:
         *   fill(), noFill(), noStroke(), stroke(), tint(),
         *   noTint(), strokeWeight(), strokeCap(),
         *   strokeJoin(), imageMode(), rectMode(),
         *   ellipseMode(), colorMode(), textAlign(),
         *   textFont(), textSize(), textLeading(),
         *   applyMatrix(), resetMatrix(), rotate(), scale(),
         *   shearX(), shearY(), translate(), noiseSeed().
         *
         *   In WEBGL mode additional style settings are
         *   stored. These are controlled by the following
         *   functions: setCamera(), ambientLight(),
         *   directionalLight(), pointLight(), texture(),
         *   specularMaterial(), shininess(), normalMaterial()
         *   and shader().
         */
        pop(): void;

        /**
         *   Executes the code within draw() one time. This
         *   function allows the program to update the display
         *   window only when necessary, for example when an
         *   event registered by mousePressed() or keyPressed()
         *   occurs. In structuring a program, it only makes
         *   sense to call redraw() within events such as
         *   mousePressed(). This is because redraw() does not
         *   run draw() immediately (it only sets a flag that
         *   indicates an update is needed).
         *
         *   The redraw() function does not work properly when
         *   called inside draw().To enable/disable animations,
         *   use loop() and noLoop().
         *
         *   In addition you can set the number of redraws per
         *   method call. Just add an integer as single
         *   parameter for the number of redraws.
         *   @param [n] Redraw for n-times. The default value
         *   is 1.
         */
        redraw(n?: number): void;

        /**
         *   The p5() constructor enables you to activate
         *   "instance mode" instead of normal "global mode".
         *   This is an advanced topic. A short description and
         *   example is included below. Please see  Dan
         *   Shiffman's Coding Train video tutorial or this
         *   tutorial page for more info. By default, all p5.js
         *   functions are in the global namespace (i.e. bound
         *   to the window object), meaning you can call them
         *   simply ellipse(), fill(), etc. However, this might
         *   be inconvenient if you are mixing with other JS
         *   libraries (synchronously or asynchronously) or
         *   writing long programs of your own. p5.js currently
         *   supports a way around this problem called
         *   "instance mode". In instance mode, all p5
         *   functions are bound up in a single variable
         *   instead of polluting your global namespace.
         *
         *   Optionally, you can specify a default container
         *   for the canvas and any other elements to append to
         *   with a second argument. You can give the ID of an
         *   element in your html, or an html node itself.
         *
         *   Note that creating instances like this also allows
         *   you to have more than one p5 sketch on a single
         *   web page, as they will each be wrapped up with
         *   their own set up variables. Of course, you could
         *   also use iframes to have multiple sketches in
         *   global mode.
         *   @param sketch a function containing a p5.js sketch
         *   @param node ID or pointer to HTML DOM node to
         *   contain sketch in
         */
        p5(sketch: object, node: string | object): void;
    }

// Inlined from: ./src/core/transform.d.ts

    interface p5InstanceExtensions {
        /**
         *   Multiplies the current matrix by the one specified
         *   through the parameters. This is a powerful
         *   operation that can perform the equivalent of
         *   translate, scale, shear and rotate all at once.
         *   You can learn more about transformation matrices
         *   on  Wikipedia. The naming of the arguments here
         *   follows the naming of the  WHATWG specification
         *   and corresponds to a transformation matrix of the
         *   form:
         *   @param arr an array of numbers - should be 6 or 16
         *   length (2×3 or 4×4 matrix values)
         *   @chainable
         */
        applyMatrix(arr: any[]): p5;

        /**
         *   Multiplies the current matrix by the one specified
         *   through the parameters. This is a powerful
         *   operation that can perform the equivalent of
         *   translate, scale, shear and rotate all at once.
         *   You can learn more about transformation matrices
         *   on  Wikipedia. The naming of the arguments here
         *   follows the naming of the  WHATWG specification
         *   and corresponds to a transformation matrix of the
         *   form:
         *   @param a numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param b numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param c numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param d numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param e numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param f numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @chainable
         */
        applyMatrix(a: number, b: number, c: number, d: number, e: number, f: number): p5;

        /**
         *   Multiplies the current matrix by the one specified
         *   through the parameters. This is a powerful
         *   operation that can perform the equivalent of
         *   translate, scale, shear and rotate all at once.
         *   You can learn more about transformation matrices
         *   on  Wikipedia. The naming of the arguments here
         *   follows the naming of the  WHATWG specification
         *   and corresponds to a transformation matrix of the
         *   form:
         *   @param a numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param b numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param c numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param d numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param e numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param f numbers which define the 2×3 or 4×4
         *   matrix to be multiplied
         *   @param g numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param h numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param i numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param j numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param k numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param l numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param m numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param n numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param o numbers which define the 4×4 matrix to be
         *   multiplied
         *   @param p numbers which define the 4×4 matrix to be
         *   multiplied
         *   @chainable
         */
        applyMatrix(
            a: number,
            b: number,
            c: number,
            d: number,
            e: number,
            f: number,
            g: number,
            h: number,
            i: number,
            j: number,
            k: number,
            l: number,
            m: number,
            n: number,
            o: number,
            p: number
        ): p5;

        /**
         *   Replaces the current matrix with the identity
         *   matrix.
         *   @chainable
         */
        resetMatrix(): p5;

        /**
         *   Rotates a shape by the amount specified by the
         *   angle parameter. This function accounts for
         *   angleMode, so angles can be entered in either
         *   RADIANS or DEGREES. Objects are always rotated
         *   around their relative position to the origin and
         *   positive numbers rotate objects in a clockwise
         *   direction. Transformations apply to everything
         *   that happens after and subsequent calls to the
         *   function accumulate the effect. For example,
         *   calling rotate(HALF_PI) and then rotate(HALF_PI)
         *   is the same as rotate(PI). All transformations are
         *   reset when draw() begins again.
         *
         *   Technically, rotate() multiplies the current
         *   transformation matrix by a rotation matrix. This
         *   function can be further controlled by push() and
         *   pop().
         *   @param angle the angle of rotation, specified in
         *   radians or degrees, depending on current angleMode
         *   @param [axis] (in 3d) the axis to rotate around
         *   @chainable
         */
        rotate(angle: number, axis?: Vector | number[]): p5;

        /**
         *   Rotates a shape around X axis by the amount
         *   specified in angle parameter. The angles can be
         *   entered in either RADIANS or DEGREES. Objects are
         *   always rotated around their relative position to
         *   the origin and positive numbers rotate objects in
         *   a clockwise direction. All transformations are
         *   reset when draw() begins again.
         *   @param angle the angle of rotation, specified in
         *   radians or degrees, depending on current angleMode
         *   @chainable
         */
        rotateX(angle: number): p5;

        /**
         *   Rotates a shape around Y axis by the amount
         *   specified in angle parameter. The angles can be
         *   entered in either RADIANS or DEGREES. Objects are
         *   always rotated around their relative position to
         *   the origin and positive numbers rotate objects in
         *   a clockwise direction. All transformations are
         *   reset when draw() begins again.
         *   @param angle the angle of rotation, specified in
         *   radians or degrees, depending on current angleMode
         *   @chainable
         */
        rotateY(angle: number): p5;

        /**
         *   Rotates a shape around Z axis by the amount
         *   specified in angle parameter. The angles can be
         *   entered in either RADIANS or DEGREES. This method
         *   works in WEBGL mode only.
         *
         *   Objects are always rotated around their relative
         *   position to the origin and positive numbers rotate
         *   objects in a clockwise direction. All
         *   transformations are reset when draw() begins
         *   again.
         *   @param angle the angle of rotation, specified in
         *   radians or degrees, depending on current angleMode
         *   @chainable
         */
        rotateZ(angle: number): p5;

        /**
         *   Increases or decreases the size of a shape by
         *   expanding or contracting vertices. Objects always
         *   scale from their relative origin to the coordinate
         *   system. Scale values are specified as decimal
         *   percentages. For example, the function call
         *   scale(2.0) increases the dimension of a shape by
         *   200%. Transformations apply to everything that
         *   happens after and subsequent calls to the function
         *   multiply the effect. For example, calling
         *   scale(2.0) and then scale(1.5) is the same as
         *   scale(3.0). If scale() is called within draw(),
         *   the transformation is reset when the loop begins
         *   again.
         *
         *   Using this function with the z parameter is only
         *   available in WEBGL mode. This function can be
         *   further controlled with push() and pop().
         *   @param s percent to scale the object, or
         *   percentage to scale the object in the x-axis if
         *   multiple arguments are given
         *   @param [y] percent to scale the object in the
         *   y-axis
         *   @param [z] percent to scale the object in the
         *   z-axis (webgl only)
         *   @chainable
         */
        scale(s: number | Vector | number[], y?: number, z?: number): p5;

        /**
         *   Increases or decreases the size of a shape by
         *   expanding or contracting vertices. Objects always
         *   scale from their relative origin to the coordinate
         *   system. Scale values are specified as decimal
         *   percentages. For example, the function call
         *   scale(2.0) increases the dimension of a shape by
         *   200%. Transformations apply to everything that
         *   happens after and subsequent calls to the function
         *   multiply the effect. For example, calling
         *   scale(2.0) and then scale(1.5) is the same as
         *   scale(3.0). If scale() is called within draw(),
         *   the transformation is reset when the loop begins
         *   again.
         *
         *   Using this function with the z parameter is only
         *   available in WEBGL mode. This function can be
         *   further controlled with push() and pop().
         *   @param scales per-axis percents to scale the
         *   object
         *   @chainable
         */
        scale(scales: Vector | number[]): p5;

        /**
         *   Shears a shape around the x-axis by the amount
         *   specified by the angle parameter. Angles should be
         *   specified in the current angleMode. Objects are
         *   always sheared around their relative position to
         *   the origin and positive numbers shear objects in a
         *   clockwise direction. Transformations apply to
         *   everything that happens after and subsequent calls
         *   to the function accumulates the effect. For
         *   example, calling shearX(PI/2) and then
         *   shearX(PI/2) is the same as shearX(PI). If
         *   shearX() is called within the draw(), the
         *   transformation is reset when the loop begins
         *   again.
         *
         *   Technically, shearX() multiplies the current
         *   transformation matrix by a rotation matrix. This
         *   function can be further controlled by the push()
         *   and pop() functions.
         *   @param angle angle of shear specified in radians
         *   or degrees, depending on current angleMode
         *   @chainable
         */
        shearX(angle: number): p5;

        /**
         *   Shears a shape around the y-axis the amount
         *   specified by the angle parameter. Angles should be
         *   specified in the current angleMode. Objects are
         *   always sheared around their relative position to
         *   the origin and positive numbers shear objects in a
         *   clockwise direction. Transformations apply to
         *   everything that happens after and subsequent calls
         *   to the function accumulates the effect. For
         *   example, calling shearY(PI/2) and then
         *   shearY(PI/2) is the same as shearY(PI). If
         *   shearY() is called within the draw(), the
         *   transformation is reset when the loop begins
         *   again.
         *
         *   Technically, shearY() multiplies the current
         *   transformation matrix by a rotation matrix. This
         *   function can be further controlled by the push()
         *   and pop() functions.
         *   @param angle angle of shear specified in radians
         *   or degrees, depending on current angleMode
         *   @chainable
         */
        shearY(angle: number): p5;

        /**
         *   Specifies an amount to displace objects within the
         *   display window. The x parameter specifies
         *   left/right translation, the y parameter specifies
         *   up/down translation. Transformations are
         *   cumulative and apply to everything that happens
         *   after and subsequent calls to the function
         *   accumulates the effect. For example, calling
         *   translate(50, 0) and then translate(20, 0) is the
         *   same as translate(70, 0). If translate() is called
         *   within draw(), the transformation is reset when
         *   the loop begins again. This function can be
         *   further controlled by using push() and pop().
         *   @param x left/right translation
         *   @param y up/down translation
         *   @param [z] forward/backward translation (WEBGL
         *   only)
         *   @chainable
         */
        translate(x: number, y: number, z?: number): p5;

        /**
         *   Specifies an amount to displace objects within the
         *   display window. The x parameter specifies
         *   left/right translation, the y parameter specifies
         *   up/down translation. Transformations are
         *   cumulative and apply to everything that happens
         *   after and subsequent calls to the function
         *   accumulates the effect. For example, calling
         *   translate(50, 0) and then translate(20, 0) is the
         *   same as translate(70, 0). If translate() is called
         *   within draw(), the transformation is reset when
         *   the loop begins again. This function can be
         *   further controlled by using push() and pop().
         *   @param vector the vector to translate by
         *   @chainable
         */
        translate(vector: Vector): p5;
    }

// Inlined from: ./src/data/local_storage.d.ts

    interface p5InstanceExtensions {
        /**
         *   Stores a value in local storage under the key
         *   name. Local storage is saved in the browser and
         *   persists between browsing sessions and page
         *   reloads. The key can be the name of the variable
         *   but doesn't have to be. To retrieve stored items
         *   see getItem. Sensitive data such as passwords or
         *   personal information should not be stored in local
         *   storage.
         */
        storeItem(key: string, value: string | number | object | boolean | Color | Vector): void;

        /**
         *   Returns the value of an item that was stored in
         *   local storage using storeItem()
         *   @param key name that you wish to use to store in
         *   local storage
         *   @return Value of stored item
         */
        getItem(key: string): number | object | string | boolean | Color | Vector;

        /**
         *   Clears all local storage items set with
         *   storeItem() for the current domain.
         */
        clearStorage(): void;

        /**
         *   Removes an item that was stored with storeItem()
         */
        removeItem(key: string): void;
    }

// Inlined from: ./src/data/p5.TypedDict.d.ts

    class TypedDict {
        /**
         *   Base class for all p5.Dictionary types.
         *   Specifically typed Dictionary classes inherit from
         *   this class.
         *
         */
        constructor();

        /**
         *   Returns the number of key-value pairs currently
         *   stored in the Dictionary.
         *   @return the number of key-value pairs in the
         *   Dictionary
         */
        size(): number;

        /**
         *   Returns true if the given key exists in the
         *   Dictionary, otherwise returns false.
         *   @param key that you want to look up
         *   @return whether that key exists in Dictionary
         */
        hasKey(key: number | string): boolean;

        /**
         *   Returns the value stored at the given key.
         *   @param the key you want to access
         *   @return the value stored at that key
         */
        get(the: number | string): number | string;

        /**
         *   Updates the value associated with the given key in
         *   case it already exists in the Dictionary.
         *   Otherwise a new key-value pair is added.
         */
        set(key: number | string, value: number | string): void;

        /**
         *   Creates a new key-value pair in the Dictionary.
         */
        create(key: number | string, value: number | string): void;

        /**
         *   Creates a new key-value pair in the Dictionary.
         *   @param obj key/value pair
         */
        create(obj: object): void;

        /**
         *   Removes all previously stored key-value pairs from
         *   the Dictionary.
         */
        clear(): void;

        /**
         *   Removes the key-value pair stored at the given key
         *   from the Dictionary.
         *   @param key for the pair to remove
         */
        remove(key: number | string): void;

        /**
         *   Logs the set of items currently stored in the
         *   Dictionary to the console.
         */
        print(): void;

        /**
         *   Converts the Dictionary into a CSV file for local
         *   download.
         */
        saveTable(): void;

        /**
         *   Converts the Dictionary into a JSON file for local
         *   download.
         */
        saveJSON(): void;
    }
    class NumberDict extends TypedDict {
        /**
         *   A simple Dictionary class for Numbers.
         *
         */
        constructor();

        /**
         *   Add the given number to the value currently stored
         *   at the given key. The sum then replaces the value
         *   previously stored in the Dictionary.
         *   @param Key for the value you wish to add to
         *   @param Number to add to the value
         */
        add(Key: number, Number: number): void;

        /**
         *   Subtract the given number from the value currently
         *   stored at the given key. The difference then
         *   replaces the value previously stored in the
         *   Dictionary.
         *   @param Key for the value you wish to subtract from
         *   @param Number to subtract from the value
         */
        sub(Key: number, Number: number): void;

        /**
         *   Multiply the given number with the value currently
         *   stored at the given key. The product then replaces
         *   the value previously stored in the Dictionary.
         *   @param Key for value you wish to multiply
         *   @param Amount to multiply the value by
         */
        mult(Key: number, Amount: number): void;

        /**
         *   Divide the given number with the value currently
         *   stored at the given key. The quotient then
         *   replaces the value previously stored in the
         *   Dictionary.
         *   @param Key for value you wish to divide
         *   @param Amount to divide the value by
         */
        div(Key: number, Amount: number): void;

        /**
         *   Return the lowest number currently stored in the
         *   Dictionary.
         */
        minValue(): number;

        /**
         *   Return the highest number currently stored in the
         *   Dictionary.
         */
        maxValue(): number;

        /**
         *   Return the lowest key currently used in the
         *   Dictionary.
         */
        minKey(): number;

        /**
         *   Return the highest key currently used in the
         *   Dictionary.
         */
        maxKey(): number;
    }
    class StringDict extends TypedDict {}
    interface p5InstanceExtensions {
        /**
         *   Creates a new instance of p5.StringDict using the
         *   key-value pair or the object you provide.
         */
        createStringDict(key: string, value: string): StringDict;

        /**
         *   Creates a new instance of p5.StringDict using the
         *   key-value pair or the object you provide.
         *   @param object object
         */
        createStringDict(object: object): StringDict;

        /**
         *   Creates a new instance of p5.NumberDict using the
         *   key-value pair or object you provide.
         */
        createNumberDict(key: number, value: number): NumberDict;

        /**
         *   Creates a new instance of p5.NumberDict using the
         *   key-value pair or object you provide.
         *   @param object object
         */
        createNumberDict(object: object): NumberDict;
    }

// Inlined from: ./src/dom/dom.d.ts

    class MediaElement extends Element {
        /**
         *   Extends p5.Element to handle audio and video. In
         *   addition to the methods of p5.Element, it also
         *   contains methods for controlling media. It is not
         *   called directly, but p5.MediaElements are created
         *   by calling createVideo, createAudio, and
         *   createCapture.
         *
         *   @param elt DOM node that is wrapped
         */
        constructor(elt: string);

        /**
         *   Play an HTML5 media element.
         *   @chainable
         */
        play(): MediaElement;

        /**
         *   Stops an HTML5 media element (sets current time to
         *   zero).
         *   @chainable
         */
        stop(): MediaElement;

        /**
         *   Pauses an HTML5 media element.
         *   @chainable
         */
        pause(): MediaElement;

        /**
         *   Set 'loop' to true for an HTML5 media element, and
         *   starts playing.
         *   @chainable
         */
        loop(): MediaElement;

        /**
         *   Set 'loop' to false for an HTML5 media element.
         *   Element will stop when it reaches the end.
         *   @chainable
         */
        noLoop(): MediaElement;

        /**
         *   Set HTML5 media element to autoplay or not. If no
         *   argument is specified, by default it will
         *   autoplay.
         *   @param shouldAutoplay whether the element should
         *   autoplay
         *   @chainable
         */
        autoplay(shouldAutoplay: boolean): MediaElement;

        /**
         *   Sets volume for this HTML5 media element. If no
         *   argument is given, returns the current volume.
         *   @return current volume
         */
        volume(): number;

        /**
         *   Sets volume for this HTML5 media element. If no
         *   argument is given, returns the current volume.
         *   @param val volume between 0.0 and 1.0
         *   @chainable
         */
        volume(val: number): MediaElement;

        /**
         *   If no arguments are given, returns the current
         *   playback speed of the element. The speed parameter
         *   sets the speed where 2.0 will play the element
         *   twice as fast, 0.5 will play at half the speed,
         *   and -1 will play the element in normal speed in
         *   reverse.(Note that not all browsers support
         *   backward playback and even if they do, playback
         *   might not be smooth.)
         *   @return current playback speed of the element
         */
        speed(): number;

        /**
         *   If no arguments are given, returns the current
         *   playback speed of the element. The speed parameter
         *   sets the speed where 2.0 will play the element
         *   twice as fast, 0.5 will play at half the speed,
         *   and -1 will play the element in normal speed in
         *   reverse.(Note that not all browsers support
         *   backward playback and even if they do, playback
         *   might not be smooth.)
         *   @param speed speed multiplier for element playback
         *   @chainable
         */
        speed(speed: number): MediaElement;

        /**
         *   If no arguments are given, returns the current
         *   time of the element. If an argument is given the
         *   current time of the element is set to it.
         *   @return current time (in seconds)
         */
        time(): number;

        /**
         *   If no arguments are given, returns the current
         *   time of the element. If an argument is given the
         *   current time of the element is set to it.
         *   @param time time to jump to (in seconds)
         *   @chainable
         */
        time(time: number): MediaElement;

        /**
         *   Returns the duration of the HTML5 media element.
         *   @return duration
         */
        duration(): number;

        /**
         *   Schedule an event to be called when the audio or
         *   video element reaches the end. If the element is
         *   looping, this will not be called. The element is
         *   passed in as the argument to the onended callback.
         *   @param callback function to call when the
         *   soundfile has ended. The media element will be
         *   passed in as the argument to the callback.
         *   @chainable
         */
        onended(callback: (...args: any[]) => any): MediaElement;

        /**
         *   Send the audio output of this element to a
         *   specified audioNode or p5.sound object. If no
         *   element is provided, connects to p5's main output.
         *   That connection is established when this method is
         *   first called. All connections are removed by the
         *   .disconnect() method. This method is meant to be
         *   used with the p5.sound.js addon library.
         *   @param audioNode AudioNode from the Web Audio API,
         *   or an object from the p5.sound library
         */
        connect(audioNode: AudioNode | object): void;

        /**
         *   Disconnect all Web Audio routing, including to
         *   main output. This is useful if you want to
         *   re-route the output through audio effects, for
         *   example.
         */
        disconnect(): void;

        /**
         *   Show the default MediaElement controls, as
         *   determined by the web browser.
         */
        showControls(): void;

        /**
         *   Hide the default mediaElement controls.
         */
        hideControls(): void;

        /**
         *   Schedule events to trigger every time a
         *   MediaElement (audio/video) reaches a playback cue
         *   point. Accepts a callback function, a time (in
         *   seconds) at which to trigger the callback, and an
         *   optional parameter for the callback.
         *
         *   Time will be passed as the first parameter to the
         *   callback function, and param will be the second
         *   parameter.
         *   @param time Time in seconds, relative to this
         *   media element's playback. For example, to trigger
         *   an event every time playback reaches two seconds,
         *   pass in the number 2. This will be passed as the
         *   first parameter to the callback function.
         *   @param callback Name of a function that will be
         *   called at the given time. The callback will
         *   receive time and (optionally) param as its two
         *   parameters.
         *   @param [value] An object to be passed as the
         *   second parameter to the callback function.
         *   @return id ID of this cue, useful for
         *   removeCue(id)
         */
        addCue(time: number, callback: (...args: any[]) => any, value?: object): number;

        /**
         *   Remove a callback based on its ID. The ID is
         *   returned by the addCue method.
         *   @param id ID of the cue, as returned by addCue
         */
        removeCue(id: number): void;

        /**
         *   Remove all of the callbacks that had originally
         *   been scheduled via the addCue method.
         *   @param id ID of the cue, as returned by addCue
         */
        clearCues(id: number): void;

        /**
         *   Path to the media element source.
         */
        src: any;
    }
    class File {
        /**
         *   Base class for a file. Used for Element.drop and
         *   createFileInput.
         *
         *   @param file File that is wrapped
         */
        constructor(file: File);

        /**
         *   Underlying File object. All normal File methods
         *   can be called on this.
         */
        file: any;

        /**
         *   File type (image, text, etc.)
         */
        type: any;

        /**
         *   File subtype (usually the file extension jpg, png,
         *   xml, etc.)
         */
        subtype: any;

        /**
         *   File name
         */
        name: any;

        /**
         *   File size
         */
        size: any;

        /**
         *   URL string containing either image data, the text
         *   contents of the file or a parsed object if file is
         *   JSON and p5.XML if XML
         */
        data: any;
    }
    interface p5InstanceExtensions {
        /**
         *   Searches the page for the first element that
         *   matches the given CSS selector string (can be an
         *   ID, class, tag name or a combination) and returns
         *   it as a p5.Element. The DOM node itself can be
         *   accessed with .elt. Returns null if none found.
         *   You can also specify a container to search within.
         *   @param selectors CSS selector string of element to
         *   search for
         *   @param [container] CSS selector string,
         *   p5.Element, or HTML element to search within
         *   @return p5.Element containing node found
         */
        select(selectors: string, container?: string | Element | HTMLElement): Element | null;

        /**
         *   Searches the page for elements that match the
         *   given CSS selector string (can be an ID a class,
         *   tag name or a combination) and returns them as
         *   p5.Elements in an array. The DOM node itself can
         *   be accessed with .elt. Returns an empty array if
         *   none found. You can also specify a container to
         *   search within.
         *   @param selectors CSS selector string of elements
         *   to search for
         *   @param [container] CSS selector string, p5.Element
         *   , or HTML element to search within
         *   @return Array of p5.Elements containing nodes
         *   found
         */
        selectAll(selectors: string, container?: string | Element | HTMLElement): Element[];

        /**
         *   Removes all elements created by p5, except any
         *   canvas / graphics elements created by createCanvas
         *   or createGraphics. Event handlers are removed, and
         *   element is removed from the DOM.
         */
        removeElements(): void;

        /**
         *   The .changed() function is called when the value
         *   of an element changes. This can be used to attach
         *   an element specific event listener.
         *   @param fxn function to be fired when the value of
         *   an element changes. if false is passed instead,
         *   the previously firing function will no longer
         *   fire.
         *   @chainable
         */
        changed(fxn: ((...args: any[]) => any) | boolean): p5;

        /**
         *   The .input() function is called when any user
         *   input is detected with an element. The input event
         *   is often used to detect keystrokes in a input
         *   element, or changes on a slider element. This can
         *   be used to attach an element specific event
         *   listener.
         *   @param fxn function to be fired when any user
         *   input is detected within the element. if false is
         *   passed instead, the previously firing function
         *   will no longer fire.
         *   @chainable
         */
        input(fxn: ((...args: any[]) => any) | boolean): p5;

        /**
         *   Creates a <div></div> element in the DOM with
         *   given inner HTML.
         *   @param [html] inner HTML for element created
         *   @return pointer to p5.Element holding created node
         */
        createDiv(html?: string): Element;

        /**
         *   Creates a <p></p> element in the DOM with given
         *   inner HTML. Used for paragraph length text.
         *   @param [html] inner HTML for element created
         *   @return pointer to p5.Element holding created node
         */
        createP(html?: string): Element;

        /**
         *   Creates a <span></span> element in the DOM with
         *   given inner HTML.
         *   @param [html] inner HTML for element created
         *   @return pointer to p5.Element holding created node
         */
        createSpan(html?: string): Element;

        /**
         *   Creates an <img> element in the DOM with given src
         *   and alternate text.
         *   @param src src path or url for image
         *   @param alt alternate text to be used if image does
         *   not load. You can use also an empty string ("") if
         *   that an image is not intended to be viewed.
         *   @return pointer to p5.Element holding created node
         */
        createImg(src: string, alt: string): Element;

        /**
         *   Creates an <img> element in the DOM with given src
         *   and alternate text.
         *   @param src src path or url for image
         *   @param alt alternate text to be used if image does
         *   not load. You can use also an empty string ("") if
         *   that an image is not intended to be viewed.
         *   @param crossOrigin crossOrigin property of the img
         *   element; use either 'anonymous' or
         *   'use-credentials' to retrieve the image with
         *   cross-origin access (for later use with canvas. if
         *   an empty string("") is passed, CORS is not used
         *   @param [successCallback] callback to be called
         *   once image data is loaded with the p5.Element as
         *   argument
         *   @return pointer to p5.Element holding created node
         */
        createImg(src: string, alt: string, crossOrigin: string, successCallback?: (...args: any[]) => any): Element;

        /**
         *   Creates an <a></a> element in the DOM for
         *   including a hyperlink.
         *   @param href url of page to link to
         *   @param html inner html of link element to display
         *   @param [target] target where new link should open,
         *   could be _blank, _self, _parent, _top.
         *   @return pointer to p5.Element holding created node
         */
        createA(href: string, html: string, target?: string): Element;

        /**
         *   Creates a slider <input></input> element in the
         *   DOM. Use .size() to set the display length of the
         *   slider.
         *   @param min minimum value of the slider
         *   @param max maximum value of the slider
         *   @param [value] default value of the slider
         *   @param [step] step size for each tick of the
         *   slider (if step is set to 0, the slider will move
         *   continuously from the minimum to the maximum
         *   value)
         *   @return pointer to p5.Element holding the created
         *   node
         */
        createSlider(min: number, max: number, value?: number, step?: number): Element;

        /**
         *   Creates a <button></button> element in the DOM.
         *   Use .size() to set the display size of the button.
         *   Use .mousePressed() to specify behavior on press.
         *   @param label label displayed on the button
         *   @param [value] value of the button
         *   @return pointer to p5.Element holding created node
         */
        createButton(label: string, value?: string): Element;

        /**
         *   Creates a checkbox <input></input> element in the
         *   DOM. Calling .checked() on a checkbox returns a
         *   boolean indicating whether it is checked or not.
         *   @param [label] label displayed after checkbox
         *   @param [value] value of the checkbox; checked is
         *   true, unchecked is false
         *   @return pointer to p5.Element holding created node
         */
        createCheckbox(label?: string, value?: boolean): Element;

        /**
         *   Creates a dropdown menu <select></select> element
         *   in the DOM. It also assigns select-related methods
         *   to p5.Element when selecting an existing select
         *   box. Options in the menu are unique by name (the
         *   display text). - .option(name, [value]) can be
         *   used to add an option with name (the display text)
         *   and value to the select element. If an option with
         *   name already exists within the select element,
         *   this method will change its value to value.
         *   - .value() will return the currently selected
         *   option.
         *   - .selected() will return the current dropdown
         *   element which is an instance of p5.Element.
         *   - .selected(value) can be used to make given
         *   option selected by default when the page first
         *   loads.
         *   - .disable() marks the whole dropdown element as
         *   disabled.
         *   - .disable(value) marks a given option as
         *   disabled.
         *   - .enable() marks the whole dropdown element as
         *   enabled if whole dropdown element is disabled
         *   intially.
         *   - .enable(value) marks a given option as enable if
         *   the initial option is disabled.
         *   @param [multiple] true if dropdown should support
         *   multiple selections
         *   @return pointer to p5.Element holding created node
         */
        createSelect(multiple?: boolean): Element;

        /**
         *   Creates a dropdown menu <select></select> element
         *   in the DOM. It also assigns select-related methods
         *   to p5.Element when selecting an existing select
         *   box. Options in the menu are unique by name (the
         *   display text). - .option(name, [value]) can be
         *   used to add an option with name (the display text)
         *   and value to the select element. If an option with
         *   name already exists within the select element,
         *   this method will change its value to value.
         *   - .value() will return the currently selected
         *   option.
         *   - .selected() will return the current dropdown
         *   element which is an instance of p5.Element.
         *   - .selected(value) can be used to make given
         *   option selected by default when the page first
         *   loads.
         *   - .disable() marks the whole dropdown element as
         *   disabled.
         *   - .disable(value) marks a given option as
         *   disabled.
         *   - .enable() marks the whole dropdown element as
         *   enabled if whole dropdown element is disabled
         *   intially.
         *   - .enable(value) marks a given option as enable if
         *   the initial option is disabled.
         *   @param existing DOM select element
         */
        createSelect(existing: object): Element;

        /**
         *   Creates a radio button element in the DOM. It also
         *   helps existing radio buttons assign methods of
         *   p5.Element. - .option(value, [label]) can be used
         *   to create a new option for the element. If an
         *   option with a value already exists, it will be
         *   returned. It is recommended to use string values
         *   as input for value. Optionally, a label can be
         *   provided as second argument for the option.
         *   - .remove(value) can be used to remove an option
         *   for the element. String values recommended as
         *   input for value.
         *   - .value() method will return the currently
         *   selected value.
         *   - .selected() method will return the currently
         *   selected input element.
         *   - .selected(value) method will select the option
         *   and return it. String values recommended as input
         *   for value.
         *   - .disable(Boolean) method will enable/disable the
         *   whole radio button element.
         *   @param containerElement A container HTML Element,
         *   either a div or span, inside which all existing
         *   radio inputs will be considered as options.
         *   @param [name] A name parameter for each Input
         *   Element.
         *   @return pointer to p5.Element holding created node
         */
        createRadio(containerElement: object, name?: string): Element;

        /**
         *   Creates a radio button element in the DOM. It also
         *   helps existing radio buttons assign methods of
         *   p5.Element. - .option(value, [label]) can be used
         *   to create a new option for the element. If an
         *   option with a value already exists, it will be
         *   returned. It is recommended to use string values
         *   as input for value. Optionally, a label can be
         *   provided as second argument for the option.
         *   - .remove(value) can be used to remove an option
         *   for the element. String values recommended as
         *   input for value.
         *   - .value() method will return the currently
         *   selected value.
         *   - .selected() method will return the currently
         *   selected input element.
         *   - .selected(value) method will select the option
         *   and return it. String values recommended as input
         *   for value.
         *   - .disable(Boolean) method will enable/disable the
         *   whole radio button element.
         *   @param name A name parameter for each Input
         *   Element.
         *   @return pointer to p5.Element holding created node
         */
        createRadio(name: string): Element;

        /**
         *   Creates a radio button element in the DOM. It also
         *   helps existing radio buttons assign methods of
         *   p5.Element. - .option(value, [label]) can be used
         *   to create a new option for the element. If an
         *   option with a value already exists, it will be
         *   returned. It is recommended to use string values
         *   as input for value. Optionally, a label can be
         *   provided as second argument for the option.
         *   - .remove(value) can be used to remove an option
         *   for the element. String values recommended as
         *   input for value.
         *   - .value() method will return the currently
         *   selected value.
         *   - .selected() method will return the currently
         *   selected input element.
         *   - .selected(value) method will select the option
         *   and return it. String values recommended as input
         *   for value.
         *   - .disable(Boolean) method will enable/disable the
         *   whole radio button element.
         *   @return pointer to p5.Element holding created node
         */
        createRadio(): Element;

        /**
         *   Creates a colorPicker element in the DOM for color
         *   input. The .value() method will return a hex
         *   string (#rrggbb) of the color. The .color() method
         *   will return a p5.Color object with the current
         *   chosen color.
         *   @param [value] default color of element
         *   @return pointer to p5.Element holding created node
         */
        createColorPicker(value?: string | Color): Element;

        /**
         *   Creates an <input></input> element in the DOM for
         *   text input. Use .size() to set the display length
         *   of the box.
         *   @param value default value of the input box
         *   @param [type] type of text, ie text, password etc.
         *   Defaults to text. Needs a value to be specified
         *   first.
         *   @return pointer to p5.Element holding created node
         */
        createInput(value: string, type?: string): Element;

        /**
         *   Creates an <input></input> element in the DOM for
         *   text input. Use .size() to set the display length
         *   of the box.
         *   @param [value] default value of the input box
         */
        createInput(value?: string): Element;

        /**
         *   Creates an <input></input> element in the DOM of
         *   type 'file'. This allows users to select local
         *   files for use in a sketch.
         *   @param callback callback function for when a file
         *   is loaded
         *   @param [multiple] optional, to allow multiple
         *   files to be selected
         *   @return pointer to p5.Element holding created DOM
         *   element
         */
        createFileInput(callback: (...args: any[]) => any, multiple?: boolean): Element;

        /**
         *   Creates an HTML5 <video> element in the DOM for
         *   simple playback of audio/video. Shown by default,
         *   can be hidden with .hide() and drawn into canvas
         *   using image(). The first parameter can be either a
         *   single string path to a video file, or an array of
         *   string paths to different formats of the same
         *   video. This is useful for ensuring that your video
         *   can play across different browsers, as each
         *   supports different formats. See this page for
         *   further information about supported formats.
         *   @param src path to a video file, or array of paths
         *   for supporting different browsers
         *   @param [callback] callback function to be called
         *   upon 'canplaythrough' event fire, that is, when
         *   the browser can play the media, and estimates that
         *   enough data has been loaded to play the media up
         *   to its end without having to stop for further
         *   buffering of content
         *   @return pointer to video p5.MediaElement
         */
        createVideo(src: string | string[], callback?: (...args: any[]) => any): MediaElement;

        /**
         *   Creates a hidden HTML5 <audio> element in the DOM
         *   for simple audio playback. The first parameter can
         *   be either a single string path to a audio file, or
         *   an array of string paths to different formats of
         *   the same audio. This is useful for ensuring that
         *   your audio can play across different browsers, as
         *   each supports different formats. See this page for
         *   further information about supported formats.
         *   @param [src] path to an audio file, or array of
         *   paths for supporting different browsers
         *   @param [callback] callback function to be called
         *   upon 'canplaythrough' event fire, that is, when
         *   the browser can play the media, and estimates that
         *   enough data has been loaded to play the media up
         *   to its end without having to stop for further
         *   buffering of content
         *   @return pointer to audio p5.MediaElement
         */
        createAudio(src?: string | string[], callback?: (...args: any[]) => any): MediaElement;

        /**
         *   Creates a new HTML5 <video> element that contains
         *   the audio/video feed from a webcam. The element is
         *   separate from the canvas and is displayed by
         *   default. The element can be hidden using .hide().
         *   The feed can be drawn onto the canvas using
         *   image(). The loadedmetadata property can be used
         *   to detect when the element has fully loaded (see
         *   second example). More specific properties of the
         *   feed can be passing in a Constraints object. See
         *   the  W3C spec for possible properties. Note that
         *   not all of these are supported by all browsers.
         *
         *   Security note: A new browser security
         *   specification requires that getUserMedia, which is
         *   behind createCapture(), only works when you're
         *   running the code locally, or on HTTPS. Learn more
         *   here and here.
         *   @param type type of capture, either VIDEO or AUDIO
         *   if none specified, default both, or a Constraints
         *   object
         *   @param [callback] function to be called once
         *   stream has loaded
         *   @return capture video p5.Element
         */
        createCapture(type: string | TYPE | object, callback?: (...args: any[]) => any): Element;

        /**
         *   Creates element with given tag in the DOM with
         *   given content.
         *   @param tag tag for the new element
         *   @param [content] html content to be inserted into
         *   the element
         *   @return pointer to p5.Element holding created node
         */
        createElement(tag: string, content?: string): Element;
    }
    interface Element {
        /**
         *   Adds specified class to the element.
         *   @param class name of class to add
         *   @chainable
         */
        addClass(theClass: string): Element;

        /**
         *   Removes specified class from the element.
         *   @param class name of class to remove
         *   @chainable
         */
        removeClass(theClass: string): Element;

        /**
         *   Checks if specified class is already applied to
         *   element.
         *   @param c class name of class to check
         *   @return a boolean value if element has specified
         *   class
         */
        hasClass(c: string): boolean;

        /**
         *   Toggles element class.
         *   @param c class name to toggle
         *   @chainable
         */
        toggleClass(c: string): Element;

        /**
         *   Attaches the element as a child to the parent
         *   specified. Accepts either a string ID, DOM node,
         *   or p5.Element. If no argument is specified, an
         *   array of children DOM nodes is returned.
         *   @return an array of child nodes
         */
        child(): Node[];

        /**
         *   Attaches the element as a child to the parent
         *   specified. Accepts either a string ID, DOM node,
         *   or p5.Element. If no argument is specified, an
         *   array of children DOM nodes is returned.
         *   @param [child] the ID, DOM node, or p5.Element to
         *   add to the current element
         *   @chainable
         */
        child(child?: string | Element): Element;

        /**
         *   Centers a p5.Element either vertically,
         *   horizontally, or both, relative to its parent or
         *   according to the body if the p5.Element has no
         *   parent. If no argument is passed the p5.Element is
         *   aligned both vertically and horizontally.
         *   @param [align] passing 'vertical', 'horizontal'
         *   aligns element accordingly
         *   @chainable
         */
        center(align?: string): Element;

        /**
         *   If an argument is given, sets the inner HTML of
         *   the element, replacing any existing HTML. If true
         *   is included as a second argument, HTML is appended
         *   instead of replacing existing HTML. If no
         *   arguments are given, returns the inner HTML of the
         *   element.
         *   @return the inner HTML of the element
         */
        html(): string;

        /**
         *   If an argument is given, sets the inner HTML of
         *   the element, replacing any existing HTML. If true
         *   is included as a second argument, HTML is appended
         *   instead of replacing existing HTML. If no
         *   arguments are given, returns the inner HTML of the
         *   element.
         *   @param [html] the HTML to be placed inside the
         *   element
         *   @param [append] whether to append HTML to existing
         *   @chainable
         */
        html(html?: string, append?: boolean): Element;

        /**
         *   Sets the position of the element. If no position
         *   type argument is given, the position will be
         *   relative to (0, 0) of the window. Essentially,
         *   this sets position:absolute and left and top
         *   properties of style. If an optional third argument
         *   specifying position type is given, the x and
         *   y-coordinates will be interpreted based on the
         *   positioning scheme. If no arguments given, the
         *   function returns the x and y position of the
         *   element. found documentation on how to be more
         *   specific with object type
         *   https://stackoverflow.com/questions/14714314/how-do-i-comment-object-literals-in-yuidoc
         *   @return object of form { x: 0, y: 0 } containing
         *   the position of the element in an object
         */
        position(): object;

        /**
         *   Sets the position of the element. If no position
         *   type argument is given, the position will be
         *   relative to (0, 0) of the window. Essentially,
         *   this sets position:absolute and left and top
         *   properties of style. If an optional third argument
         *   specifying position type is given, the x and
         *   y-coordinates will be interpreted based on the
         *   positioning scheme. If no arguments given, the
         *   function returns the x and y position of the
         *   element. found documentation on how to be more
         *   specific with object type
         *   https://stackoverflow.com/questions/14714314/how-do-i-comment-object-literals-in-yuidoc
         *   @param [x] x-position relative to upper left of
         *   window (optional)
         *   @param [y] y-position relative to upper left of
         *   window (optional)
         *   @param [positionType] it can be static, fixed,
         *   relative, sticky, initial or inherit (optional)
         *   @chainable
         */
        position(x?: number, y?: number, positionType?: string): Element;

        /**
         *   Sets the given style (CSS) property (1st arg) of
         *   the element with the given value (2nd arg). If a
         *   single argument is given, .style() returns the
         *   value of the given property; however, if a single
         *   argument is given in CSS syntax
         *   ('text-align:center'), .style() sets the CSS
         *   appropriately.
         *   @param property property to be set
         *   @return value of property
         */
        style(property: string): string;

        /**
         *   Sets the given style (CSS) property (1st arg) of
         *   the element with the given value (2nd arg). If a
         *   single argument is given, .style() returns the
         *   value of the given property; however, if a single
         *   argument is given in CSS syntax
         *   ('text-align:center'), .style() sets the CSS
         *   appropriately.
         *   @param property property to be set
         *   @param value value to assign to property
         *   @chainable
         */
        style(property: string, value: string | Color): Element;

        /**
         *   Adds a new attribute or changes the value of an
         *   existing attribute on the specified element. If no
         *   value is specified, returns the value of the given
         *   attribute, or null if the attribute is not set.
         *   @return value of attribute
         */
        attribute(): string;

        /**
         *   Adds a new attribute or changes the value of an
         *   existing attribute on the specified element. If no
         *   value is specified, returns the value of the given
         *   attribute, or null if the attribute is not set.
         *   @param attr attribute to set
         *   @param value value to assign to attribute
         *   @chainable
         */
        attribute(attr: string, value: string): Element;

        /**
         *   Removes an attribute on the specified element.
         *   @param attr attribute to remove
         *   @chainable
         */
        removeAttribute(attr: string): Element;

        /**
         *   Either returns the value of the element if no
         *   arguments given, or sets the value of the element.
         *   @return value of the element
         */
        value(): string | number;

        /**
         *   Either returns the value of the element if no
         *   arguments given, or sets the value of the element.
         *   @chainable
         */
        value(value: string | number): Element;

        /**
         *   Shows the current element. Essentially, setting
         *   display:block for the style.
         *   @chainable
         */
        show(): Element;

        /**
         *   Hides the current element. Essentially, setting
         *   display:none for the style.
         *   @chainable
         */
        hide(): Element;

        /**
         *   Sets the width and height of the element. AUTO can
         *   be used to only adjust one dimension at a time. If
         *   no arguments are given, it returns the width and
         *   height of the element in an Object. In the case of
         *   elements that need to be loaded, such as images,
         *   it is recommended to call the function after the
         *   element has finished loading.
         *   @return the width and height of the element in an
         *   object
         */
        size(): object;

        /**
         *   Sets the width and height of the element. AUTO can
         *   be used to only adjust one dimension at a time. If
         *   no arguments are given, it returns the width and
         *   height of the element in an Object. In the case of
         *   elements that need to be loaded, such as images,
         *   it is recommended to call the function after the
         *   element has finished loading.
         *   @param w width of the element, either AUTO, or a
         *   number
         *   @param [h] height of the element, either AUTO, or
         *   a number
         *   @chainable
         */
        size(w: number | SIZE_W, h?: number | SIZE_H): Element;

        /**
         *   Removes the element, stops all media streams, and
         *   deregisters all listeners.
         */
        remove(): void;

        /**
         *   Registers a callback that gets called every time a
         *   file that is dropped on the element has been
         *   loaded. p5 will load every dropped file into
         *   memory and pass it as a p5.File object to the
         *   callback. Multiple files dropped at the same time
         *   will result in multiple calls to the callback. You
         *   can optionally pass a second callback which will
         *   be registered to the raw drop event. The callback
         *   will thus be provided the original DragEvent.
         *   Dropping multiple files at the same time will
         *   trigger the second callback once per drop, whereas
         *   the first callback will trigger for each loaded
         *   file.
         *   @param callback callback to receive loaded file,
         *   called for each file dropped.
         *   @param [fxn] callback triggered once when files
         *   are dropped with the drop event.
         *   @chainable
         */
        drop(callback: (...args: any[]) => any, fxn?: (...args: any[]) => any): Element;
    }

// Inlined from: ./src/events/acceleration.d.ts

    interface p5InstanceExtensions {
        /**
         *   The setMoveThreshold() function is used to set the
         *   movement threshold for the deviceMoved() function.
         *   The default threshold is set to 0.5.
         *   @param value The threshold value
         */
        setMoveThreshold(value: number): void;

        /**
         *   The setShakeThreshold() function is used to set
         *   the movement threshold for the deviceShaken()
         *   function. The default threshold is set to 30.
         *   @param value The threshold value
         */
        setShakeThreshold(value: number): void;

        /**
         *   The deviceMoved() function is called when the
         *   device is moved by more than the threshold value
         *   along X, Y or Z axis. The default threshold is set
         *   to 0.5. The threshold value can be changed using
         *   setMoveThreshold().
         */
        deviceMoved(): void;

        /**
         *   The deviceTurned() function is called when the
         *   device rotates by more than 90 degrees
         *   continuously. The axis that triggers the
         *   deviceTurned() method is stored in the turnAxis
         *   variable. The deviceTurned() method can be locked
         *   to trigger on any axis: X, Y or Z by comparing the
         *   turnAxis variable to 'X', 'Y' or 'Z'.
         */
        deviceTurned(): void;

        /**
         *   The deviceShaken() function is called when the
         *   device total acceleration changes of accelerationX
         *   and accelerationY values is more than the
         *   threshold value. The default threshold is set to
         *   30. The threshold value can be changed using
         *   setShakeThreshold().
         */
        deviceShaken(): void;

        /**
         *   The system variable deviceOrientation always
         *   contains the orientation of the device. The value
         *   of this variable will either be set 'landscape' or
         *   'portrait'. If no data is available it will be set
         *   to 'undefined'. either LANDSCAPE or PORTRAIT.
         */
        deviceOrientation: UNKNOWN_P5_CONSTANT;

        /**
         *   The system variable accelerationX always contains
         *   the acceleration of the device along the x axis.
         *   Value is represented as meters per second squared.
         */
        accelerationX: number;

        /**
         *   The system variable accelerationY always contains
         *   the acceleration of the device along the y axis.
         *   Value is represented as meters per second squared.
         */
        accelerationY: number;

        /**
         *   The system variable accelerationZ always contains
         *   the acceleration of the device along the z axis.
         *   Value is represented as meters per second squared.
         */
        accelerationZ: number;

        /**
         *   The system variable pAccelerationX always contains
         *   the acceleration of the device along the x axis in
         *   the frame previous to the current frame. Value is
         *   represented as meters per second squared.
         */
        pAccelerationX: number;

        /**
         *   The system variable pAccelerationY always contains
         *   the acceleration of the device along the y axis in
         *   the frame previous to the current frame. Value is
         *   represented as meters per second squared.
         */
        pAccelerationY: number;

        /**
         *   The system variable pAccelerationZ always contains
         *   the acceleration of the device along the z axis in
         *   the frame previous to the current frame. Value is
         *   represented as meters per second squared.
         */
        pAccelerationZ: number;

        /**
         *   The system variable rotationX always contains the
         *   rotation of the device along the x axis. If the
         *   sketch  angleMode() is set to DEGREES, the value
         *   will be -180 to 180. If it is set to RADIANS, the
         *   value will be -PI to PI. Note: The order the
         *   rotations are called is important, ie. if used
         *   together, it must be called in the order Z-X-Y or
         *   there might be unexpected behaviour.
         */
        rotationX: number;

        /**
         *   The system variable rotationY always contains the
         *   rotation of the device along the y axis. If the
         *   sketch  angleMode() is set to DEGREES, the value
         *   will be -90 to 90. If it is set to RADIANS, the
         *   value will be -PI/2 to PI/2. Note: The order the
         *   rotations are called is important, ie. if used
         *   together, it must be called in the order Z-X-Y or
         *   there might be unexpected behaviour.
         */
        rotationY: number;

        /**
         *   The system variable rotationZ always contains the
         *   rotation of the device along the z axis. If the
         *   sketch  angleMode() is set to DEGREES, the value
         *   will be 0 to 360. If it is set to RADIANS, the
         *   value will be 0 to 2*PI. Unlike rotationX and
         *   rotationY, this variable is available for devices
         *   with a built-in compass only.
         *
         *   Note: The order the rotations are called is
         *   important, ie. if used together, it must be called
         *   in the order Z-X-Y or there might be unexpected
         *   behaviour.
         */
        rotationZ: number;

        /**
         *   The system variable pRotationX always contains the
         *   rotation of the device along the x axis in the
         *   frame previous to the current frame. If the sketch
         *   angleMode() is set to DEGREES, the value will be
         *   -180 to 180. If it is set to RADIANS, the value
         *   will be -PI to PI. pRotationX can also be used
         *   with rotationX to determine the rotate direction
         *   of the device along the X-axis.
         */
        pRotationX: number;

        /**
         *   The system variable pRotationY always contains the
         *   rotation of the device along the y axis in the
         *   frame previous to the current frame. If the sketch
         *   angleMode() is set to DEGREES, the value will be
         *   -90 to 90. If it is set to RADIANS, the value will
         *   be -PI/2 to PI/2. pRotationY can also be used with
         *   rotationY to determine the rotate direction of the
         *   device along the Y-axis.
         */
        pRotationY: number;

        /**
         *   The system variable pRotationZ always contains the
         *   rotation of the device along the z axis in the
         *   frame previous to the current frame. If the sketch
         *   angleMode() is set to DEGREES, the value will be 0
         *   to 360. If it is set to RADIANS, the value will be
         *   0 to 2*PI. pRotationZ can also be used with
         *   rotationZ to determine the rotate direction of the
         *   device along the Z-axis.
         */
        pRotationZ: number;

        /**
         *   When a device is rotated, the axis that triggers
         *   the deviceTurned() method is stored in the
         *   turnAxis variable. The turnAxis variable is only
         *   defined within the scope of deviceTurned().
         */
        turnAxis: string;
    }

// Inlined from: ./src/events/keyboard.d.ts

    interface p5InstanceExtensions {
        /**
         *   The keyPressed() function is called once every
         *   time a key is pressed. The keyCode for the key
         *   that was pressed is stored in the keyCode
         *   variable. For non-ASCII keys, use the keyCode
         *   variable. You can check if the keyCode equals
         *   BACKSPACE, DELETE, ENTER, RETURN, TAB, ESCAPE,
         *   SHIFT, CONTROL, OPTION, ALT, UP_ARROW, DOWN_ARROW,
         *   LEFT_ARROW, RIGHT_ARROW.
         *
         *   For ASCII keys, the key that was pressed is stored
         *   in the key variable. However, it does not
         *   distinguish between uppercase and lowercase. For
         *   this reason, it is recommended to use keyTyped()
         *   to read the key variable, in which the case of the
         *   variable will be distinguished.
         *
         *   Because of how operating systems handle key
         *   repeats, holding down a key may cause multiple
         *   calls to keyTyped() (and keyReleased() as well).
         *   The rate of repeat is set by the operating system
         *   and how each computer is configured.
         *
         *
         *   Browsers may have different default behaviors
         *   attached to various key events. To prevent any
         *   default behavior for this event, add "return
         *   false" to the end of the method.
         *   @param [event] optional KeyboardEvent callback
         *   argument.
         */
        keyPressed(event?: object): void;

        /**
         *   The keyReleased() function is called once every
         *   time a key is released. See key and keyCode for
         *   more information. Browsers may have different
         *   default behaviors attached to various key events.
         *   To prevent any default behavior for this event,
         *   add "return false" to the end of the function.
         *   @param [event] optional KeyboardEvent callback
         *   argument.
         */
        keyReleased(event?: object): void;

        /**
         *   The keyTyped() function is called once every time
         *   a key is pressed, but action keys such as
         *   Backspace, Delete, Ctrl, Shift, and Alt are
         *   ignored. If you are trying to detect a keyCode for
         *   one of these keys, use the keyPressed() function
         *   instead. The most recent key typed will be stored
         *   in the key variable. Because of how operating
         *   systems handle key repeats, holding down a key
         *   will cause multiple calls to keyTyped() (and
         *   keyReleased() as well). The rate of repeat is set
         *   by the operating system and how each computer is
         *   configured.
         *
         *
         *   Browsers may have different default behaviors
         *   attached to various key events. To prevent any
         *   default behavior for this event, add "return
         *   false" to the end of the function.
         *   @param [event] optional KeyboardEvent callback
         *   argument.
         */
        keyTyped(event?: object): void;

        /**
         *   The keyIsDown() function checks if the key is
         *   currently down, i.e. pressed. It can be used if
         *   you have an object that moves, and you want
         *   several keys to be able to affect its behaviour
         *   simultaneously, such as moving a sprite
         *   diagonally. You can put in any number representing
         *   the keyCode of the key, or use any of the variable
         *   keyCode names listed here.
         *   @param code The key to check for.
         *   @return whether key is down or not
         */
        keyIsDown(code: number): boolean;

        /**
         *   The boolean system variable keyIsPressed is true
         *   if any key is pressed and false if no keys are
         *   pressed.
         */
        keyIsPressed: boolean;

        /**
         *   The system variable key always contains the value
         *   of the most recent key on the keyboard that was
         *   typed. To get the proper capitalization, it is
         *   best to use it within keyTyped(). For non-ASCII
         *   keys, use the keyCode variable.
         */
        key: string;

        /**
         *   The variable keyCode is used to detect special
         *   keys such as BACKSPACE, DELETE, ENTER, RETURN,
         *   TAB, ESCAPE, SHIFT, CONTROL, OPTION, ALT,
         *   UP_ARROW, DOWN_ARROW, LEFT_ARROW, RIGHT_ARROW. You
         *   can also check for custom keys by looking up the
         *   keyCode of any key on a site like this:
         *   keycode.info.
         */
        keyCode: number;
    }

// Inlined from: ./src/events/mouse.d.ts

    interface p5InstanceExtensions {
        /**
         *   The mouseMoved() function is called every time the
         *   mouse moves and a mouse button is not pressed.
         *   Browsers may have different default behaviors
         *   attached to various mouse events. To prevent any
         *   default behavior for this event, add "return
         *   false" to the end of the method.
         *   @param [event] optional MouseEvent callback
         *   argument.
         */
        mouseMoved(event?: object): void;

        /**
         *   The mouseDragged() function is called once every
         *   time the mouse moves and a mouse button is
         *   pressed. If no mouseDragged() function is defined,
         *   the touchMoved() function will be called instead
         *   if it is defined. Browsers may have different
         *   default behaviors attached to various mouse
         *   events. To prevent any default behavior for this
         *   event, add "return false" to the end of the
         *   function.
         *   @param [event] optional MouseEvent callback
         *   argument.
         */
        mouseDragged(event?: object): void;

        /**
         *   The mousePressed() function is called once after
         *   every time a mouse button is pressed. The
         *   mouseButton variable (see the related reference
         *   entry) can be used to determine which button has
         *   been pressed. If no mousePressed() function is
         *   defined, the touchStarted() function will be
         *   called instead if it is defined. Browsers may have
         *   different default behaviors attached to various
         *   mouse events. To prevent any default behavior for
         *   this event, add "return false" to the end of the
         *   function.
         *   @param [event] optional MouseEvent callback
         *   argument.
         */
        mousePressed(event?: object): void;

        /**
         *   The mouseReleased() function is called every time
         *   a mouse button is released. If no mouseReleased()
         *   function is defined, the touchEnded() function
         *   will be called instead if it is defined. Browsers
         *   may have different default behaviors attached to
         *   various mouse events. To prevent any default
         *   behavior for this event, add "return false" to the
         *   end of the function.
         *   @param [event] optional MouseEvent callback
         *   argument.
         */
        mouseReleased(event?: object): void;

        /**
         *   The mouseClicked() function is called once after a
         *   mouse button has been pressed and then released.
         *   Browsers handle clicks differently, so this
         *   function is only guaranteed to be run when the
         *   left mouse button is clicked. To handle other
         *   mouse buttons being pressed or released, see
         *   mousePressed() or mouseReleased().
         *
         *
         *   Browsers may have different default behaviors
         *   attached to various mouse events. To prevent any
         *   default behavior for this event, add "return
         *   false" to the end of the function.
         *   @param [event] optional MouseEvent callback
         *   argument.
         */
        mouseClicked(event?: object): void;

        /**
         *   The doubleClicked() function is executed every
         *   time a event listener has detected a dblclick
         *   event which is a part of the DOM L3 specification.
         *   The doubleClicked event is fired when a pointing
         *   device button (usually a mouse's primary button)
         *   is clicked twice on a single element. For more
         *   info on the dblclick event refer to mozilla's
         *   documentation here:
         *   https://developer.mozilla.org/en-US/docs/Web/Events/dblclick
         *   @param [event] optional MouseEvent callback
         *   argument.
         */
        doubleClicked(event?: object): void;

        /**
         *   The function mouseWheel() is executed every time a
         *   vertical mouse wheel event is detected either
         *   triggered by an actual mouse wheel or by a
         *   touchpad. The event.delta property returns the
         *   amount the mouse wheel have scrolled. The values
         *   can be positive or negative depending on the
         *   scroll direction (on macOS with "natural"
         *   scrolling enabled, the signs are inverted).
         *
         *
         *   Browsers may have different default behaviors
         *   attached to various mouse events. To prevent any
         *   default behavior for this event, add "return
         *   false" to the end of the method.
         *
         *
         *   Due to the current support of the "wheel" event on
         *   Safari, the function may only work as expected if
         *   "return false" is included while using Safari.
         *   @param [event] optional WheelEvent callback
         *   argument.
         */
        mouseWheel(event?: object): void;

        /**
         *   The function requestPointerLock() locks the
         *   pointer to its current position and makes it
         *   invisible. Use movedX and movedY to get the
         *   difference the mouse was moved since the last call
         *   of draw. Note that not all browsers support this
         *   feature. This enables you to create experiences
         *   that aren't limited by the mouse moving out of the
         *   screen even if it is repeatedly moved into one
         *   direction. For example, a first person perspective
         *   experience.
         */
        requestPointerLock(): void;

        /**
         *   The function exitPointerLock() exits a previously
         *   triggered pointer Lock for example to make ui
         *   elements usable etc
         */
        exitPointerLock(): void;

        /**
         *   The variable movedX contains the horizontal
         *   movement of the mouse since the last frame
         */
        movedX: number;

        /**
         *   The variable movedY contains the vertical movement
         *   of the mouse since the last frame
         */
        movedY: number;

        /**
         *   The system variable mouseX always contains the
         *   current horizontal position of the mouse, relative
         *   to (0, 0) of the canvas. The value at the top-left
         *   corner is (0, 0) for 2-D and (-width/2, -height/2)
         *   for WebGL. If touch is used instead of mouse
         *   input, mouseX will hold the x value of the most
         *   recent touch point.
         */
        mouseX: number;

        /**
         *   The system variable mouseY always contains the
         *   current vertical position of the mouse, relative
         *   to (0, 0) of the canvas. The value at the top-left
         *   corner is (0, 0) for 2-D and (-width/2, -height/2)
         *   for WebGL. If touch is used instead of mouse
         *   input, mouseY will hold the y value of the most
         *   recent touch point.
         */
        mouseY: number;

        /**
         *   The system variable pmouseX always contains the
         *   horizontal position of the mouse or finger in the
         *   frame previous to the current frame, relative to
         *   (0, 0) of the canvas. The value at the top-left
         *   corner is (0, 0) for 2-D and (-width/2, -height/2)
         *   for WebGL. Note: pmouseX will be reset to the
         *   current mouseX value at the start of each touch
         *   event.
         */
        pmouseX: number;

        /**
         *   The system variable pmouseY always contains the
         *   vertical position of the mouse or finger in the
         *   frame previous to the current frame, relative to
         *   (0, 0) of the canvas. The value at the top-left
         *   corner is (0, 0) for 2-D and (-width/2, -height/2)
         *   for WebGL. Note: pmouseY will be reset to the
         *   current mouseY value at the start of each touch
         *   event.
         */
        pmouseY: number;

        /**
         *   The system variable winMouseX always contains the
         *   current horizontal position of the mouse, relative
         *   to (0, 0) of the window.
         */
        winMouseX: number;

        /**
         *   The system variable winMouseY always contains the
         *   current vertical position of the mouse, relative
         *   to (0, 0) of the window.
         */
        winMouseY: number;

        /**
         *   The system variable pwinMouseX always contains the
         *   horizontal position of the mouse in the frame
         *   previous to the current frame, relative to (0, 0)
         *   of the window. Note: pwinMouseX will be reset to
         *   the current winMouseX value at the start of each
         *   touch event.
         */
        pwinMouseX: number;

        /**
         *   The system variable pwinMouseY always contains the
         *   vertical position of the mouse in the frame
         *   previous to the current frame, relative to (0, 0)
         *   of the window. Note: pwinMouseY will be reset to
         *   the current winMouseY value at the start of each
         *   touch event.
         */
        pwinMouseY: number;

        /**
         *   p5 automatically tracks if the mouse button is
         *   pressed and which button is pressed. The value of
         *   the system variable mouseButton is either LEFT,
         *   RIGHT, or CENTER depending on which button was
         *   pressed last. Warning: different browsers may
         *   track mouseButton differently.
         */
        mouseButton: UNKNOWN_P5_CONSTANT;

        /**
         *   The boolean system variable mouseIsPressed is true
         *   if the mouse is pressed and false if not.
         */
        mouseIsPressed: boolean;
    }

// Inlined from: ./src/events/touch.d.ts

    interface p5InstanceExtensions {
        /**
         *   The touchStarted() function is called once after
         *   every time a touch is registered. If no
         *   touchStarted() function is defined, the
         *   mousePressed() function will be called instead if
         *   it is defined. Browsers may have different default
         *   behaviors attached to various touch events. To
         *   prevent any default behavior for this event, add
         *   "return false" to the end of the method.
         *   @param [event] optional TouchEvent callback
         *   argument.
         */
        touchStarted(event?: object): void;

        /**
         *   The touchMoved() function is called every time a
         *   touch move is registered. If no touchMoved()
         *   function is defined, the mouseDragged() function
         *   will be called instead if it is defined. Browsers
         *   may have different default behaviors attached to
         *   various touch events. To prevent any default
         *   behavior for this event, add "return false" to the
         *   end of the method.
         *   @param [event] optional TouchEvent callback
         *   argument.
         */
        touchMoved(event?: object): void;

        /**
         *   The touchEnded() function is called every time a
         *   touch ends. If no touchEnded() function is
         *   defined, the mouseReleased() function will be
         *   called instead if it is defined. Browsers may have
         *   different default behaviors attached to various
         *   touch events. To prevent any default behavior for
         *   this event, add "return false" to the end of the
         *   method.
         *   @param [event] optional TouchEvent callback
         *   argument.
         */
        touchEnded(event?: object): void;

        /**
         *   The system variable touches[] contains an array of
         *   the positions of all current touch points,
         *   relative to (0, 0) of the canvas, and IDs
         *   identifying a unique touch as it moves. Each
         *   element in the array is an object with x, y, and
         *   id properties. The touches[] array is not
         *   supported on Safari and IE on touch-based desktops
         *   (laptops).
         */
        touches: object[];
    }

// Inlined from: ./src/image/image.d.ts

    interface p5InstanceExtensions {
        /**
         *   Creates a new p5.Image (the datatype for storing
         *   images). This provides a fresh buffer of pixels to
         *   play with. Set the size of the buffer with the
         *   width and height parameters. .pixels gives access
         *   to an array containing the values for all the
         *   pixels in the display window. These values are
         *   numbers. This array is the size (including an
         *   appropriate factor for the pixelDensity) of the
         *   display window x4, representing the R, G, B, A
         *   values in order for each pixel, moving from left
         *   to right across each row, then down each column.
         *   See .pixels for more info. It may also be simpler
         *   to use set() or get().
         *
         *   Before accessing the pixels of an image, the data
         *   must loaded with the loadPixels() function. After
         *   the array data has been modified, the
         *   updatePixels() function must be run to update the
         *   changes.
         *   @param width width in pixels
         *   @param height height in pixels
         *   @return the p5.Image object
         */
        createImage(width: number, height: number): Image;

        /**
         *   Save the current canvas as an image. The browser
         *   will either save the file immediately, or prompt
         *   the user with a dialogue window.
         *   @param selectedCanvas a variable representing a
         *   specific html5 canvas (optional)
         *   @param [extension] 'jpg' or 'png'
         */
        saveCanvas(selectedCanvas: Element | HTMLCanvasElement, filename?: string, extension?: string): void;

        /**
         *   Save the current canvas as an image. The browser
         *   will either save the file immediately, or prompt
         *   the user with a dialogue window.
         *   @param [extension] 'jpg' or 'png'
         */
        saveCanvas(filename?: string, extension?: string): void;

        /**
         *   Capture a sequence of frames that can be used to
         *   create a movie. Accepts a callback. For example,
         *   you may wish to send the frames to a server where
         *   they can be stored or converted into a movie. If
         *   no callback is provided, the browser will pop up
         *   save dialogues in an attempt to download all of
         *   the images that have just been created. With the
         *   callback provided the image data isn't saved by
         *   default but instead passed as an argument to the
         *   callback function as an array of objects, with the
         *   size of array equal to the total number of frames.
         *   The arguments duration and framerate are
         *   constrained to be less or equal to 15 and 22,
         *   respectively, which means you can only download a
         *   maximum of 15 seconds worth of frames at 22 frames
         *   per second, adding up to 330 frames. This is done
         *   in order to avoid memory problems since a large
         *   enough canvas can fill up the memory in your
         *   computer very easily and crash your program or
         *   even your browser.
         *
         *   To export longer animations, you might look into a
         *   library like ccapture.js.
         *   @param extension 'jpg' or 'png'
         *   @param duration Duration in seconds to save the
         *   frames for. This parameter will be constrained to
         *   be less or equal to 15.
         *   @param framerate Framerate to save the frames in.
         *   This parameter will be constrained to be less or
         *   equal to 22.
         *   @param [callback] A callback function that will be
         *   executed to handle the image data. This function
         *   should accept an array as argument. The array will
         *   contain the specified number of frames of objects.
         *   Each object has three properties: imageData - an
         *   image/octet-stream, filename and extension.
         */
        saveFrames(
            filename: string,
            extension: string,
            duration: number,
            framerate: number,
            callback?: (p1: any[]) => any
        ): void;
    }

// Inlined from: ./src/image/loading_displaying.d.ts

    interface p5InstanceExtensions {
        /**
         *   Loads an image from a path and creates a p5.Image
         *   from it. The image may not be immediately
         *   available for rendering. If you want to ensure
         *   that the image is ready before doing anything with
         *   it, place the loadImage() call in preload(). You
         *   may also supply a callback function to handle the
         *   image when it's ready.
         *
         *   The path to the image should be relative to the
         *   HTML file that links in your sketch. Loading an
         *   image from a URL or other remote location may be
         *   blocked due to your browser's built-in security.
         *
         *   You can also pass in a string of a base64 encoded
         *   image as an alternative to the file path. Remember
         *   to add "data:image/png;base64," in front of the
         *   string.
         *   @param path Path of the image to be loaded
         *   @param [successCallback] Function to be called
         *   once the image is loaded. Will be passed the
         *   p5.Image.
         *   @param [failureCallback] called with event error
         *   if the image fails to load.
         *   @return the p5.Image object
         */
        loadImage(path: string, successCallback?: (p1: Image) => any, failureCallback?: (p1: Event) => any): Image;

        /**
         *   Generates a gif of your current animation and
         *   downloads it to your computer! The duration
         *   argument specifies how many seconds you want to
         *   record from your animation. This value is then
         *   converted to the necessary number of frames to
         *   generate it, depending on the value of units. More
         *   on that on the next paragraph.
         *
         *   An optional object that can contain two more
         *   arguments: delay (number) and units (string).
         *
         *   delay, specifying how much time we should wait
         *   before recording
         *
         *   units, a string that can be either 'seconds' or
         *   'frames'. By default it's 'seconds'.
         *
         *   units specifies how the duration and delay
         *   arguments will behave. If 'seconds', these
         *   arguments will correspond to seconds, meaning that
         *   3 seconds worth of animation will be created. If
         *   'frames', the arguments now correspond to the
         *   number of frames you want your animation to be, if
         *   you are very sure of this number.
         *
         *   This may be called in setup, or, like in the
         *   example below, inside an event function, like
         *   keyPressed or mousePressed.
         *   @param filename File name of your gif
         *   @param duration Duration in seconds that you wish
         *   to capture from your sketch
         *   @param options An optional object that can contain
         *   five more arguments: delay, specifying how much
         *   time we should wait before recording; units, a
         *   string that can be either 'seconds' or 'frames'.
         *   By default it's 'seconds’; silent, a boolean that
         *   defines presence of progress notifications. By
         *   default it’s false; notificationDuration, a number
         *   that defines how long in seconds the final
         *   notification will live. 0, the default value,
         *   means that the notification will never be removed;
         *   notificationID, a string that specifies the
         *   notification DOM element id. By default it’s
         *   'progressBar’.
         */
        saveGif(filename: string, duration: number, options: object): void;

        /**
         *   Draw an image to the p5.js canvas. This function
         *   can be used with different numbers of parameters.
         *   The simplest use requires only three parameters:
         *   img, x, and y—where (x, y) is the position of the
         *   image. Two more parameters can optionally be added
         *   to specify the width and height of the image.
         *
         *   This function can also be used with eight Number
         *   parameters. To differentiate between all these
         *   parameters, p5.js uses the language of
         *   "destination rectangle" (which corresponds to
         *   "dx", "dy", etc.) and "source image" (which
         *   corresponds to "sx", "sy", etc.) below. Specifying
         *   the "source image" dimensions can be useful when
         *   you want to display a subsection of the source
         *   image instead of the whole thing. Here's a diagram
         *   to explain further:
         *
         *   This function can also be used to draw images
         *   without distorting the orginal aspect ratio, by
         *   adding 9th parameter, fit, which can either be
         *   COVER or CONTAIN. CONTAIN, as the name suggests,
         *   contains the whole image within the specified
         *   destination box without distorting the image
         *   ratio. COVER covers the entire destination box.
         *   @param img the image to display
         *   @param x the x-coordinate of the top-left corner
         *   of the image
         *   @param y the y-coordinate of the top-left corner
         *   of the image
         *   @param [width] the width to draw the image
         *   @param [height] the height to draw the image
         */
        image(img: Image | Element | Framebuffer, x: number, y: number, width?: number, height?: number): void;

        /**
         *   Draw an image to the p5.js canvas. This function
         *   can be used with different numbers of parameters.
         *   The simplest use requires only three parameters:
         *   img, x, and y—where (x, y) is the position of the
         *   image. Two more parameters can optionally be added
         *   to specify the width and height of the image.
         *
         *   This function can also be used with eight Number
         *   parameters. To differentiate between all these
         *   parameters, p5.js uses the language of
         *   "destination rectangle" (which corresponds to
         *   "dx", "dy", etc.) and "source image" (which
         *   corresponds to "sx", "sy", etc.) below. Specifying
         *   the "source image" dimensions can be useful when
         *   you want to display a subsection of the source
         *   image instead of the whole thing. Here's a diagram
         *   to explain further:
         *
         *   This function can also be used to draw images
         *   without distorting the orginal aspect ratio, by
         *   adding 9th parameter, fit, which can either be
         *   COVER or CONTAIN. CONTAIN, as the name suggests,
         *   contains the whole image within the specified
         *   destination box without distorting the image
         *   ratio. COVER covers the entire destination box.
         *   @param img the image to display
         *   @param dx the x-coordinate of the destination
         *   rectangle in which to draw the source image
         *   @param dy the y-coordinate of the destination
         *   rectangle in which to draw the source image
         *   @param dWidth the width of the destination
         *   rectangle
         *   @param dHeight the height of the destination
         *   rectangle
         *   @param sx the x-coordinate of the subsection of
         *   the source image to draw into the destination
         *   rectangle
         *   @param sy the y-coordinate of the subsection of
         *   the source image to draw into the destination
         *   rectangle
         *   @param [sWidth] the width of the subsection of the
         *   source image to draw into the destination
         *   rectangle
         *   @param [sHeight] the height of the subsection of
         *   the source image to draw into the destination
         *   rectangle
         *   @param [fit] either CONTAIN or COVER
         *   @param [xAlign] either LEFT, RIGHT or CENTER
         *   default is CENTER
         *   @param [yAlign] either TOP, BOTTOM or CENTER
         *   default is CENTER
         */
        image(
            img: Image | Element | Framebuffer,
            dx: number,
            dy: number,
            dWidth: number,
            dHeight: number,
            sx: number,
            sy: number,
            sWidth?: number,
            sHeight?: number,
            fit?: IMAGE_FIT,
            xAlign?: X_ALIGN,
            yAlign?: Y_ALIGN
        ): void;

        /**
         *   Sets the fill value for displaying images. Images
         *   can be tinted to specified colors or made
         *   transparent by including an alpha value. To apply
         *   transparency to an image without affecting its
         *   color, use white as the tint color and specify an
         *   alpha value. For instance, tint(255, 128) will
         *   make an image 50% transparent (assuming the
         *   default alpha range of 0-255, which can be changed
         *   with colorMode()).
         *
         *   The value for the gray parameter must be less than
         *   or equal to the current maximum value as specified
         *   by colorMode(). The default maximum value is 255.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         */
        tint(v1: number, v2: number, v3: number, alpha?: number): void;

        /**
         *   Sets the fill value for displaying images. Images
         *   can be tinted to specified colors or made
         *   transparent by including an alpha value. To apply
         *   transparency to an image without affecting its
         *   color, use white as the tint color and specify an
         *   alpha value. For instance, tint(255, 128) will
         *   make an image 50% transparent (assuming the
         *   default alpha range of 0-255, which can be changed
         *   with colorMode()).
         *
         *   The value for the gray parameter must be less than
         *   or equal to the current maximum value as specified
         *   by colorMode(). The default maximum value is 255.
         *   @param value a color string
         */
        tint(value: string): void;

        /**
         *   Sets the fill value for displaying images. Images
         *   can be tinted to specified colors or made
         *   transparent by including an alpha value. To apply
         *   transparency to an image without affecting its
         *   color, use white as the tint color and specify an
         *   alpha value. For instance, tint(255, 128) will
         *   make an image 50% transparent (assuming the
         *   default alpha range of 0-255, which can be changed
         *   with colorMode()).
         *
         *   The value for the gray parameter must be less than
         *   or equal to the current maximum value as specified
         *   by colorMode(). The default maximum value is 255.
         *   @param gray a gray value
         */
        tint(gray: number, alpha?: number): void;

        /**
         *   Sets the fill value for displaying images. Images
         *   can be tinted to specified colors or made
         *   transparent by including an alpha value. To apply
         *   transparency to an image without affecting its
         *   color, use white as the tint color and specify an
         *   alpha value. For instance, tint(255, 128) will
         *   make an image 50% transparent (assuming the
         *   default alpha range of 0-255, which can be changed
         *   with colorMode()).
         *
         *   The value for the gray parameter must be less than
         *   or equal to the current maximum value as specified
         *   by colorMode(). The default maximum value is 255.
         *   @param values an array containing the
         *   red,green,blue & and alpha components of the color
         */
        tint(values: number[]): void;

        /**
         *   Sets the fill value for displaying images. Images
         *   can be tinted to specified colors or made
         *   transparent by including an alpha value. To apply
         *   transparency to an image without affecting its
         *   color, use white as the tint color and specify an
         *   alpha value. For instance, tint(255, 128) will
         *   make an image 50% transparent (assuming the
         *   default alpha range of 0-255, which can be changed
         *   with colorMode()).
         *
         *   The value for the gray parameter must be less than
         *   or equal to the current maximum value as specified
         *   by colorMode(). The default maximum value is 255.
         *   @param color the tint color
         */
        tint(color: Color): void;

        /**
         *   Removes the current fill value for displaying
         *   images and reverts to displaying images with their
         *   original hues.
         */
        noTint(): void;

        /**
         *   Set image mode. Modifies the location from which
         *   images are drawn by changing the way in which
         *   parameters given to image() are interpreted. The
         *   default mode is imageMode(CORNER), which
         *   interprets the second and third parameters of
         *   image() as the upper-left corner of the image. If
         *   two additional parameters are specified, they are
         *   used to set the image's width and height.
         *   imageMode(CORNERS) interprets the second and third
         *   parameters of image() as the location of one
         *   corner, and the fourth and fifth parameters as the
         *   opposite corner.
         *
         *   imageMode(CENTER) interprets the second and third
         *   parameters of image() as the image's center point.
         *   If two additional parameters are specified, they
         *   are used to set the image's width and height.
         *   @param mode either CORNER, CORNERS, or CENTER
         */
        imageMode(mode: IMAGE_MODE): void;
    }

// Inlined from: ./src/image/pixels.d.ts

    interface p5InstanceExtensions {
        /**
         *   Copies a region of pixels from one image to
         *   another, using a specified blend mode to do the
         *   operation.
         *   @param srcImage source image
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         *   @param blendMode the blend mode. either BLEND,
         *   DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
         *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
         *   SOFT_LIGHT, DODGE, BURN, ADD or NORMAL.
         */
        blend(
            srcImage: Image,
            sx: number,
            sy: number,
            sw: number,
            sh: number,
            dx: number,
            dy: number,
            dw: number,
            dh: number,
            blendMode: BLEND_MODE
        ): void;

        /**
         *   Copies a region of pixels from one image to
         *   another, using a specified blend mode to do the
         *   operation.
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         *   @param blendMode the blend mode. either BLEND,
         *   DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
         *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
         *   SOFT_LIGHT, DODGE, BURN, ADD or NORMAL.
         */
        blend(
            sx: number,
            sy: number,
            sw: number,
            sh: number,
            dx: number,
            dy: number,
            dw: number,
            dh: number,
            blendMode: UNKNOWN_P5_CONSTANT
        ): void;

        /**
         *   Copies a region of the canvas to another region of
         *   the canvas and copies a region of pixels from an
         *   image used as the srcImg parameter into the canvas
         *   srcImage is specified this is used as the source.
         *   If the source and destination regions aren't the
         *   same size, it will automatically resize source
         *   pixels to fit the specified target region.
         *   @param srcImage source image
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         */
        copy(
            srcImage: Image | Element,
            sx: number,
            sy: number,
            sw: number,
            sh: number,
            dx: number,
            dy: number,
            dw: number,
            dh: number
        ): void;

        /**
         *   Copies a region of the canvas to another region of
         *   the canvas and copies a region of pixels from an
         *   image used as the srcImg parameter into the canvas
         *   srcImage is specified this is used as the source.
         *   If the source and destination regions aren't the
         *   same size, it will automatically resize source
         *   pixels to fit the specified target region.
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         */
        copy(sx: number, sy: number, sw: number, sh: number, dx: number, dy: number, dw: number, dh: number): void;

        /**
         *   Applies a filter to the canvas. The presets
         *   options are: THRESHOLD Converts the image to black
         *   and white pixels depending if they are above or
         *   below the threshold defined by the level
         *   parameter. The parameter must be between 0.0
         *   (black) and 1.0 (white). If no level is specified,
         *   0.5 is used.
         *
         *   GRAY Converts any colors in the image to grayscale
         *   equivalents. No parameter is used.
         *
         *   OPAQUE Sets the alpha channel to entirely opaque.
         *   No parameter is used.
         *
         *   INVERT Sets each pixel to its inverse value. No
         *   parameter is used.
         *
         *   POSTERIZE Limits each channel of the image to the
         *   number of colors specified as the parameter. The
         *   parameter can be set to values between 2 and 255,
         *   but results are most noticeable in the lower
         *   ranges.
         *
         *   BLUR Executes a Gaussian blur with the level
         *   parameter specifying the extent of the blurring.
         *   If no parameter is used, the blur is equivalent to
         *   Gaussian blur of radius 1. Larger values increase
         *   the blur.
         *
         *   ERODE Reduces the light areas. No parameter is
         *   used.
         *
         *   DILATE Increases the light areas. No parameter is
         *   used.
         *
         *   filter() does not work in WEBGL mode. A similar
         *   effect can be achieved in WEBGL mode using custom
         *   shaders. Adam Ferriss has written a selection of
         *   shader examples that contains many of the effects
         *   present in the filter examples.
         *   @param filterType either THRESHOLD, GRAY, OPAQUE,
         *   INVERT, POSTERIZE, BLUR, ERODE, DILATE or BLUR.
         *   See Filters.js for docs on each available filter
         *   @param [filterParam] an optional parameter unique
         *   to each filter, see above
         */
        filter(filterType: FILTER_TYPE, filterParam?: number): void;

        /**
         *   Get a region of pixels, or a single pixel, from
         *   the canvas. Returns an array of [R,G,B,A] values
         *   for any pixel or grabs a section of an image. If
         *   no parameters are specified, the entire image is
         *   returned. Use the x and y parameters to get the
         *   value of one pixel. Get a section of the display
         *   window by specifying additional w and h
         *   parameters. When getting an image, the x and y
         *   parameters define the coordinates for the
         *   upper-left corner of the image, regardless of the
         *   current imageMode().
         *
         *   Getting the color of a single pixel with get(x, y)
         *   is easy, but not as fast as grabbing the data
         *   directly from pixels[]. The equivalent statement
         *   to get(x, y) using pixels[] with pixel density d
         *   is
         *
         *   let x, y, d; // set these to the coordinates let
         *   off = (y * width + x) * d * 4; let components = [
         *   pixels[off], pixels[off + 1], pixels[off + 2],
         *   pixels[off + 3] ]; print(components);
         *
         *   See the reference for pixels[] for more
         *   information.
         *
         *   If you want to extract an array of colors or a
         *   subimage from an p5.Image object, take a look at
         *   p5.Image.get()
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @param w width of the section to be returned
         *   @param h height of the section to be returned
         *   @return the rectangle p5.Image
         */
        get(x: number, y: number, w: number, h: number): Image;

        /**
         *   Get a region of pixels, or a single pixel, from
         *   the canvas. Returns an array of [R,G,B,A] values
         *   for any pixel or grabs a section of an image. If
         *   no parameters are specified, the entire image is
         *   returned. Use the x and y parameters to get the
         *   value of one pixel. Get a section of the display
         *   window by specifying additional w and h
         *   parameters. When getting an image, the x and y
         *   parameters define the coordinates for the
         *   upper-left corner of the image, regardless of the
         *   current imageMode().
         *
         *   Getting the color of a single pixel with get(x, y)
         *   is easy, but not as fast as grabbing the data
         *   directly from pixels[]. The equivalent statement
         *   to get(x, y) using pixels[] with pixel density d
         *   is
         *
         *   let x, y, d; // set these to the coordinates let
         *   off = (y * width + x) * d * 4; let components = [
         *   pixels[off], pixels[off + 1], pixels[off + 2],
         *   pixels[off + 3] ]; print(components);
         *
         *   See the reference for pixels[] for more
         *   information.
         *
         *   If you want to extract an array of colors or a
         *   subimage from an p5.Image object, take a look at
         *   p5.Image.get()
         *   @return the whole p5.Image
         */
        get(): Image;

        /**
         *   Get a region of pixels, or a single pixel, from
         *   the canvas. Returns an array of [R,G,B,A] values
         *   for any pixel or grabs a section of an image. If
         *   no parameters are specified, the entire image is
         *   returned. Use the x and y parameters to get the
         *   value of one pixel. Get a section of the display
         *   window by specifying additional w and h
         *   parameters. When getting an image, the x and y
         *   parameters define the coordinates for the
         *   upper-left corner of the image, regardless of the
         *   current imageMode().
         *
         *   Getting the color of a single pixel with get(x, y)
         *   is easy, but not as fast as grabbing the data
         *   directly from pixels[]. The equivalent statement
         *   to get(x, y) using pixels[] with pixel density d
         *   is
         *
         *   let x, y, d; // set these to the coordinates let
         *   off = (y * width + x) * d * 4; let components = [
         *   pixels[off], pixels[off + 1], pixels[off + 2],
         *   pixels[off + 3] ]; print(components);
         *
         *   See the reference for pixels[] for more
         *   information.
         *
         *   If you want to extract an array of colors or a
         *   subimage from an p5.Image object, take a look at
         *   p5.Image.get()
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @return color of pixel at x,y in array format [R,
         *   G, B, A]
         */
        get(x: number, y: number): number[];

        /**
         *   Loads the pixel data for the display window into
         *   the pixels[] array. This function must always be
         *   called before reading from or writing to pixels[].
         *   Note that only changes made with set() or direct
         *   manipulation of pixels[] will occur.
         */
        loadPixels(): void;

        /**
         *   Changes the color of any pixel, or writes an image
         *   directly to the display window. The x and y
         *   parameters specify the pixel to change and the c
         *   parameter specifies the color value. This can be a
         *   p5.Color object, or [R, G, B, A] pixel array. It
         *   can also be a single grayscale value. When setting
         *   an image, the x and y parameters define the
         *   coordinates for the upper-left corner of the
         *   image, regardless of the current imageMode().
         *   After using set(), you must call updatePixels()
         *   for your changes to appear. This should be called
         *   once all pixels have been set, and must be called
         *   before calling .get() or drawing the image.
         *
         *   Setting the color of a single pixel with set(x, y)
         *   is easy, but not as fast as putting the data
         *   directly into pixels[]. Setting the pixels[]
         *   values directly may be complicated when working
         *   with a retina display, but will perform better
         *   when lots of pixels need to be set directly on
         *   every loop. See the reference for pixels[] for
         *   more information.
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @param c insert a grayscale value | a pixel array
         *   | a p5.Color object | a p5.Image to copy
         */
        set(x: number, y: number, c: number | number[] | object): void;

        /**
         *   Updates the display window with the data in the
         *   pixels[] array. Use in conjunction with
         *   loadPixels(). If you're only reading pixels from
         *   the array, there's no need to call updatePixels()
         *   — updating is only necessary to apply changes.
         *   updatePixels() should be called anytime the pixels
         *   array is manipulated or set() is called, and only
         *   changes made with set() or direct changes to
         *   pixels[] will occur.
         *   @param [x] x-coordinate of the upper-left corner
         *   of region to update
         *   @param [y] y-coordinate of the upper-left corner
         *   of region to update
         *   @param [w] width of region to update
         *   @param [h] height of region to update
         */
        updatePixels(x?: number, y?: number, w?: number, h?: number): void;

        /**
         *   Uint8ClampedArray containing the values for all
         *   the pixels in the display window. These values are
         *   numbers. This array is the size (include an
         *   appropriate factor for pixelDensity) of the
         *   display window x4, representing the R, G, B, A
         *   values in order for each pixel, moving from left
         *   to right across each row, then down each column.
         *   Retina and other high density displays will have
         *   more pixels[] (by a factor of pixelDensity^2). For
         *   example, if the image is 100×100 pixels, there
         *   will be 40,000. On a retina display, there will be
         *   160,000. The first four values (indices 0-3) in
         *   the array will be the R, G, B, A values of the
         *   pixel at (0, 0). The second four values (indices
         *   4-7) will contain the R, G, B, A values of the
         *   pixel at (1, 0). More generally, to set values for
         *   a pixel at (x, y):
         *
         *   let d = pixelDensity(); for (let i = 0; i < d;
         *   i++) { for (let j = 0; j < d; j++) { // loop over
         *   index = 4 * ((y * d + j) * width * d + (x * d +
         *   i)); pixels[index] = r; pixels[index+1] = g;
         *   pixels[index+2] = b; pixels[index+3] = a; } }
         *
         *   While the above method is complex, it is flexible
         *   enough to work with any pixelDensity. Note that
         *   set() will automatically take care of setting all
         *   the appropriate values in pixels[] for a given (x,
         *   y) at any pixelDensity, but the performance may
         *   not be as fast when lots of modifications are made
         *   to the pixel array.
         *
         *   Before accessing this array, the data must loaded
         *   with the loadPixels() function. After the array
         *   data has been modified, the updatePixels()
         *   function must be run to update the changes.
         *
         *   Note that this is not a standard javascript array.
         *   This means that standard javascript functions such
         *   as slice() or arrayCopy() do not work.
         */
        pixels: number[];
    }

// Inlined from: ./src/io/files.d.ts

    class PrintWriter {
        /**
         *   Writes data to the PrintWriter stream
         *   @param data all data to be written by the
         *   PrintWriter
         */
        write(data: any[]): void;

        /**
         *   Writes data to the PrintWriter stream, and adds a
         *   new line at the end
         *   @param data all data to be printed by the
         *   PrintWriter
         */
        print(data: any[]): void;

        /**
         *   Clears the data already written to the PrintWriter
         *   object
         */
        clear(): void;

        /**
         *   Closes the PrintWriter
         */
        close(): void;
    }
    interface p5InstanceExtensions {
        /**
         *   Loads a JSON file from a file or a URL, and
         *   returns an Object. Note that even if the JSON file
         *   contains an Array, an Object will be returned with
         *   index numbers as keys. This method is
         *   asynchronous, meaning it may not finish before the
         *   next line in your sketch is executed. JSONP is
         *   supported via a polyfill and you can pass in as
         *   the second argument an object with definitions of
         *   the json callback following the syntax specified
         *   here.
         *
         *   This method is suitable for fetching files up to
         *   size of 64MB.
         *   @param path name of the file or url to load
         *   @param [jsonpOptions] options object for jsonp
         *   related settings
         *   @param [datatype] "json" or "jsonp"
         *   @param [callback] function to be executed after
         *   loadJSON() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         *   @return JSON data
         */
        loadJSON(
            path: string,
            jsonpOptions?: object,
            datatype?: string,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): object | any[];

        /**
         *   Loads a JSON file from a file or a URL, and
         *   returns an Object. Note that even if the JSON file
         *   contains an Array, an Object will be returned with
         *   index numbers as keys. This method is
         *   asynchronous, meaning it may not finish before the
         *   next line in your sketch is executed. JSONP is
         *   supported via a polyfill and you can pass in as
         *   the second argument an object with definitions of
         *   the json callback following the syntax specified
         *   here.
         *
         *   This method is suitable for fetching files up to
         *   size of 64MB.
         *   @param path name of the file or url to load
         *   @param datatype "json" or "jsonp"
         *   @param [callback] function to be executed after
         *   loadJSON() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         */
        loadJSON(
            path: string,
            datatype: string,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): object | any[];

        /**
         *   Loads a JSON file from a file or a URL, and
         *   returns an Object. Note that even if the JSON file
         *   contains an Array, an Object will be returned with
         *   index numbers as keys. This method is
         *   asynchronous, meaning it may not finish before the
         *   next line in your sketch is executed. JSONP is
         *   supported via a polyfill and you can pass in as
         *   the second argument an object with definitions of
         *   the json callback following the syntax specified
         *   here.
         *
         *   This method is suitable for fetching files up to
         *   size of 64MB.
         *   @param path name of the file or url to load
         *   @param callback function to be executed after
         *   loadJSON() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         */
        loadJSON(
            path: string,
            callback: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): object | any[];

        /**
         *   Reads the contents of a file and creates a String
         *   array of its individual lines. If the name of the
         *   file is used as the parameter, as in the above
         *   example, the file must be located in the sketch
         *   directory/folder. Alternatively, the file may be
         *   loaded from anywhere on the local computer using
         *   an absolute path (something that starts with / on
         *   Unix and Linux, or a drive letter on Windows), or
         *   the filename parameter can be a URL for a file
         *   found on a network.
         *
         *   This method is asynchronous, meaning it may not
         *   finish before the next line in your sketch is
         *   executed.
         *
         *   This method is suitable for fetching files up to
         *   size of 64MB.
         *   @param filename name of the file or url to load
         *   @param [callback] function to be executed after
         *   loadStrings() completes, Array is passed in as
         *   first argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         *   @return Array of Strings
         */
        loadStrings(
            filename: string,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): string[];

        /**
         *   Reads the contents of a file or URL and creates a
         *   p5.Table object with its values. If a file is
         *   specified, it must be located in the sketch's
         *   "data" folder. The filename parameter can also be
         *   a URL to a file found online. By default, the file
         *   is assumed to be comma-separated (in CSV format).
         *   Table only looks for a header row if the 'header'
         *   option is included. This method is asynchronous,
         *   meaning it may not finish before the next line in
         *   your sketch is executed. Calling loadTable()
         *   inside preload() guarantees to complete the
         *   operation before setup() and draw() are called.
         *   Outside of preload(), you may supply a callback
         *   function to handle the object:
         *
         *   All files loaded and saved use UTF-8 encoding.
         *   This method is suitable for fetching files up to
         *   size of 64MB.
         *   @param filename name of the file or URL to load
         *   @param [extension] parse the table by
         *   comma-separated values "csv", semicolon-separated
         *   values "ssv", or tab-separated values "tsv"
         *   @param [header] "header" to indicate table has
         *   header row
         *   @param [callback] function to be executed after
         *   loadTable() completes. On success, the Table
         *   object is passed in as the first argument.
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         *   @return Table object containing data
         */
        loadTable(
            filename: string,
            extension?: string,
            header?: string,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): object;

        /**
         *   Reads the contents of a file and creates an XML
         *   object with its values. If the name of the file is
         *   used as the parameter, as in the above example,
         *   the file must be located in the sketch
         *   directory/folder. Alternatively, the file maybe be
         *   loaded from anywhere on the local computer using
         *   an absolute path (something that starts with / on
         *   Unix and Linux, or a drive letter on Windows), or
         *   the filename parameter can be a URL for a file
         *   found on a network.
         *
         *   This method is asynchronous, meaning it may not
         *   finish before the next line in your sketch is
         *   executed. Calling loadXML() inside preload()
         *   guarantees to complete the operation before
         *   setup() and draw() are called.
         *
         *   Outside of preload(), you may supply a callback
         *   function to handle the object.
         *
         *   This method is suitable for fetching files up to
         *   size of 64MB.
         *   @param filename name of the file or URL to load
         *   @param [callback] function to be executed after
         *   loadXML() completes, XML object is passed in as
         *   first argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         *   @return XML object containing data
         */
        loadXML(filename: string, callback?: (...args: any[]) => any, errorCallback?: (...args: any[]) => any): object;

        /**
         *   This method is suitable for fetching files up to
         *   size of 64MB.
         *   @param file name of the file or URL to load
         *   @param [callback] function to be executed after
         *   loadBytes() completes
         *   @param [errorCallback] function to be executed if
         *   there is an error
         *   @return an object whose 'bytes' property will be
         *   the loaded buffer
         */
        loadBytes(file: string, callback?: (...args: any[]) => any, errorCallback?: (...args: any[]) => any): object;

        /**
         *   Method for executing an HTTP GET request. If data
         *   type is not specified, p5 will try to guess based
         *   on the URL, defaulting to text. This is equivalent
         *   to calling httpDo(path, 'GET'). The 'binary'
         *   datatype will return a Blob object, and the
         *   'arrayBuffer' datatype will return an ArrayBuffer
         *   which can be used to initialize typed arrays (such
         *   as Uint8Array).
         *   @param path name of the file or url to load
         *   @param [datatype] "json", "jsonp", "binary",
         *   "arrayBuffer", "xml", or "text"
         *   @param [data] param data passed sent with request
         *   @param [callback] function to be executed after
         *   httpGet() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         *   @return A promise that resolves with the data when
         *   the operation completes successfully or rejects
         *   with the error after one occurs.
         */
        httpGet(
            path: string,
            datatype?: string,
            data?: object | boolean,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Promise<any>;

        /**
         *   Method for executing an HTTP GET request. If data
         *   type is not specified, p5 will try to guess based
         *   on the URL, defaulting to text. This is equivalent
         *   to calling httpDo(path, 'GET'). The 'binary'
         *   datatype will return a Blob object, and the
         *   'arrayBuffer' datatype will return an ArrayBuffer
         *   which can be used to initialize typed arrays (such
         *   as Uint8Array).
         *   @param path name of the file or url to load
         *   @param data param data passed sent with request
         *   @param [callback] function to be executed after
         *   httpGet() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         */
        httpGet(
            path: string,
            data: object | boolean,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Promise<any>;

        /**
         *   Method for executing an HTTP GET request. If data
         *   type is not specified, p5 will try to guess based
         *   on the URL, defaulting to text. This is equivalent
         *   to calling httpDo(path, 'GET'). The 'binary'
         *   datatype will return a Blob object, and the
         *   'arrayBuffer' datatype will return an ArrayBuffer
         *   which can be used to initialize typed arrays (such
         *   as Uint8Array).
         *   @param path name of the file or url to load
         *   @param callback function to be executed after
         *   httpGet() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         */
        httpGet(path: string, callback: (...args: any[]) => any, errorCallback?: (...args: any[]) => any): Promise<any>;

        /**
         *   Method for executing an HTTP POST request. If data
         *   type is not specified, p5 will try to guess based
         *   on the URL, defaulting to text. This is equivalent
         *   to calling httpDo(path, 'POST').
         *   @param path name of the file or url to load
         *   @param [datatype] "json", "jsonp", "xml", or
         *   "text". If omitted, httpPost() will guess.
         *   @param [data] param data passed sent with request
         *   @param [callback] function to be executed after
         *   httpPost() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         *   @return A promise that resolves with the data when
         *   the operation completes successfully or rejects
         *   with the error after one occurs.
         */
        httpPost(
            path: string,
            datatype?: string,
            data?: object | boolean,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Promise<any>;

        /**
         *   Method for executing an HTTP POST request. If data
         *   type is not specified, p5 will try to guess based
         *   on the URL, defaulting to text. This is equivalent
         *   to calling httpDo(path, 'POST').
         *   @param path name of the file or url to load
         *   @param data param data passed sent with request
         *   @param [callback] function to be executed after
         *   httpPost() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         */
        httpPost(
            path: string,
            data: object | boolean,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Promise<any>;

        /**
         *   Method for executing an HTTP POST request. If data
         *   type is not specified, p5 will try to guess based
         *   on the URL, defaulting to text. This is equivalent
         *   to calling httpDo(path, 'POST').
         *   @param path name of the file or url to load
         *   @param callback function to be executed after
         *   httpPost() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         */
        httpPost(
            path: string,
            callback: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Promise<any>;

        /**
         *   Method for executing an HTTP request. If data type
         *   is not specified, p5 will try to guess based on
         *   the URL, defaulting to text. For more advanced
         *   use, you may also pass in the path as the first
         *   argument and a object as the second argument, the
         *   signature follows the one specified in the Fetch
         *   API specification. This method is suitable for
         *   fetching files up to size of 64MB when "GET" is
         *   used.
         *   @param path name of the file or url to load
         *   @param [method] either "GET", "POST", or "PUT",
         *   defaults to "GET"
         *   @param [datatype] "json", "jsonp", "xml", or
         *   "text"
         *   @param [data] param data passed sent with request
         *   @param [callback] function to be executed after
         *   httpGet() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         *   @return A promise that resolves with the data when
         *   the operation completes successfully or rejects
         *   with the error after one occurs.
         */
        httpDo(
            path: string,
            method?: string,
            datatype?: string,
            data?: object,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Promise<any>;

        /**
         *   Method for executing an HTTP request. If data type
         *   is not specified, p5 will try to guess based on
         *   the URL, defaulting to text. For more advanced
         *   use, you may also pass in the path as the first
         *   argument and a object as the second argument, the
         *   signature follows the one specified in the Fetch
         *   API specification. This method is suitable for
         *   fetching files up to size of 64MB when "GET" is
         *   used.
         *   @param path name of the file or url to load
         *   @param options Request object options as
         *   documented in the "fetch" API reference
         *   @param [callback] function to be executed after
         *   httpGet() completes, data is passed in as first
         *   argument
         *   @param [errorCallback] function to be executed if
         *   there is an error, response is passed in as first
         *   argument
         */
        httpDo(
            path: string,
            options: object,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Promise<any>;
        createWriter(name: string, extension?: string): PrintWriter;

        /**
         *   Saves a given element(image, text, json, csv, wav,
         *   or html) to the client's computer. The first
         *   parameter can be a pointer to element we want to
         *   save. The element can be one of p5.Element,an
         *   Array of Strings, an Array of JSON, a JSON object,
         *   a p5.Table , a p5.Image, or a p5.SoundFile
         *   (requires p5.sound). The second parameter is a
         *   filename (including extension).The third parameter
         *   is for options specific to this type of object.
         *   This method will save a file that fits the given
         *   parameters. If it is called without specifying an
         *   element, by default it will save the whole canvas
         *   as an image file. You can optionally specify a
         *   filename as the first parameter in such a case.
         *   Note that it is not recommended to call this
         *   method within draw, as it will open a new save
         *   dialog on every render.
         *   @param [objectOrFilename] If filename is provided,
         *   will save canvas as an image with either png or
         *   jpg extension depending on the filename. If object
         *   is provided, will save depending on the object and
         *   filename (see examples above).
         *   @param [filename] If an object is provided as the
         *   first parameter, then the second parameter
         *   indicates the filename, and should include an
         *   appropriate file extension (see examples above).
         *   @param [options] Additional options depend on
         *   filetype. For example, when saving JSON, true
         *   indicates that the output will be optimized for
         *   filesize, rather than readability.
         */
        save(objectOrFilename?: object | string, filename?: string, options?: boolean | string): void;

        /**
         *   Writes the contents of an Array or a JSON object
         *   to a .json file. The file saving process and
         *   location of the saved file will vary between web
         *   browsers.
         *   @param [optimize] If true, removes line breaks and
         *   spaces from the output file to optimize filesize
         *   (but not readability).
         */
        saveJSON(json: any[] | object, filename: string, optimize?: boolean): void;

        /**
         *   Writes an array of Strings to a text file, one
         *   line per String. The file saving process and
         *   location of the saved file will vary between web
         *   browsers.
         *   @param list string array to be written
         *   @param filename filename for output
         *   @param [extension] the filename's extension
         *   @param [isCRLF] if true, change line-break to CRLF
         */
        saveStrings(list: string[], filename: string, extension?: string, isCRLF?: boolean): void;

        /**
         *   Writes the contents of a Table object to a file.
         *   Defaults to a text file with
         *   comma-separated-values ('csv') but can also use
         *   tab separation ('tsv'), or generate an HTML table
         *   ('html'). The file saving process and location of
         *   the saved file will vary between web browsers.
         *   @param Table the Table object to save to a file
         *   @param filename the filename to which the Table
         *   should be saved
         *   @param [options] can be one of "tsv", "csv", or
         *   "html"
         */
        saveTable(Table: Table, filename: string, options?: string): void;
    }

// Inlined from: ./src/math/calculation.d.ts

    interface p5InstanceExtensions {
        /**
         *   Calculates the absolute value (magnitude) of a
         *   number. Maps to Math.abs(). The absolute value of
         *   a number is always positive.
         *   @param n number to compute
         *   @return absolute value of given number
         */
        abs(n: number): number;

        /**
         *   Calculates the closest int value that is greater
         *   than or equal to the value of the parameter. Maps
         *   to Math.ceil(). For example, ceil(9.03) returns
         *   the value 10.
         *   @param n number to round up
         *   @return rounded up number
         */
        ceil(n: number): number;

        /**
         *   Constrains a value between a minimum and maximum
         *   value.
         *   @param n number to constrain
         *   @param low minimum limit
         *   @param high maximum limit
         *   @return constrained number
         */
        constrain(n: number, low: number, high: number): number;

        /**
         *   Calculates the distance between two points, in
         *   either two or three dimensions. If you looking for
         *   distance between two vectors see p5.Vector.dist()
         *   @param x1 x-coordinate of the first point
         *   @param y1 y-coordinate of the first point
         *   @param x2 x-coordinate of the second point
         *   @param y2 y-coordinate of the second point
         *   @return distance between the two points
         */
        dist(x1: number, y1: number, x2: number, y2: number): number;

        /**
         *   Calculates the distance between two points, in
         *   either two or three dimensions. If you looking for
         *   distance between two vectors see p5.Vector.dist()
         *   @param x1 x-coordinate of the first point
         *   @param y1 y-coordinate of the first point
         *   @param z1 z-coordinate of the first point
         *   @param x2 x-coordinate of the second point
         *   @param y2 y-coordinate of the second point
         *   @param z2 z-coordinate of the second point
         *   @return distance between the two points
         */
        dist(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): number;

        /**
         *   Returns Euler's number e (2.71828...) raised to
         *   the power of the n parameter. Maps to Math.exp().
         *   @param n exponent to raise
         *   @return e^n
         */
        exp(n: number): number;

        /**
         *   Calculates the closest int value that is less than
         *   or equal to the value of the parameter. Maps to
         *   Math.floor().
         *   @param n number to round down
         *   @return rounded down number
         */
        floor(n: number): number;

        /**
         *   Calculates a number between two numbers at a
         *   specific increment. The amt parameter is the
         *   amount to interpolate between the two values where
         *   0.0 is equal to the first point, 0.1 is very near
         *   the first point, 0.5 is half-way in between, and
         *   1.0 is equal to the second point. If the value of
         *   amt is more than 1.0 or less than 0.0, the number
         *   will be calculated accordingly in the ratio of the
         *   two given numbers. The lerp() function is
         *   convenient for creating motion along a straight
         *   path and for drawing dotted lines.
         *   @param start first value
         *   @param stop second value
         *   @param amt number
         *   @return lerped value
         */
        lerp(start: number, stop: number, amt: number): number;

        /**
         *   Calculates the natural logarithm (the base-e
         *   logarithm) of a number. This function expects the
         *   n parameter to be a value greater than 0.0. Maps
         *   to Math.log().
         *   @param n number greater than 0
         *   @return natural logarithm of n
         */
        log(n: number): number;

        /**
         *   Calculates the magnitude (or length) of a vector.
         *   A vector is a direction in space commonly used in
         *   computer graphics and linear algebra. Because it
         *   has no "start" position, the magnitude of a vector
         *   can be thought of as the distance from the
         *   coordinate 0,0 to its x,y value. Therefore, mag()
         *   is a shortcut for writing dist(0, 0, x, y).
         *   @param a first value
         *   @param b second value
         *   @return magnitude of vector from (0,0) to (a,b)
         */
        mag(a: number, b: number): number;

        /**
         *   Re-maps a number from one range to another. In the
         *   first example above, the number 25 is converted
         *   from a value in the range of 0 to 100 into a value
         *   that ranges from the left edge of the window (0)
         *   to the right edge (width).
         *   @param value the incoming value to be converted
         *   @param start1 lower bound of the value's current
         *   range
         *   @param stop1 upper bound of the value's current
         *   range
         *   @param start2 lower bound of the value's target
         *   range
         *   @param stop2 upper bound of the value's target
         *   range
         *   @param [withinBounds] constrain the value to the
         *   newly mapped range
         *   @return remapped number
         */
        map(
            value: number,
            start1: number,
            stop1: number,
            start2: number,
            stop2: number,
            withinBounds?: boolean
        ): number;

        /**
         *   Determines the largest value in a sequence of
         *   numbers, and then returns that value. max()
         *   accepts any number of Number parameters, or an
         *   Array of any length.
         *   @param n0 Number to compare
         *   @param n1 Number to compare
         *   @return maximum Number
         */
        max(n0: number, n1: number): number;

        /**
         *   Determines the largest value in a sequence of
         *   numbers, and then returns that value. max()
         *   accepts any number of Number parameters, or an
         *   Array of any length.
         *   @param nums Numbers to compare
         */
        max(nums: number[]): number;

        /**
         *   Determines the smallest value in a sequence of
         *   numbers, and then returns that value. min()
         *   accepts any number of Number parameters, or an
         *   Array of any length.
         *   @param n0 Number to compare
         *   @param n1 Number to compare
         *   @return minimum Number
         */
        min(n0: number, n1: number): number;

        /**
         *   Determines the smallest value in a sequence of
         *   numbers, and then returns that value. min()
         *   accepts any number of Number parameters, or an
         *   Array of any length.
         *   @param nums Numbers to compare
         */
        min(nums: number[]): number;

        /**
         *   Normalizes a number from another range into a
         *   value between 0 and 1. Identical to map(value,
         *   low, high, 0, 1). Numbers outside of the range are
         *   not clamped to 0 and 1, because out-of-range
         *   values are often intentional and useful. (See the
         *   example above.)
         *   @param value incoming value to be normalized
         *   @param start lower bound of the value's current
         *   range
         *   @param stop upper bound of the value's current
         *   range
         *   @return normalized number
         */
        norm(value: number, start: number, stop: number): number;

        /**
         *   Facilitates exponential expressions. The pow()
         *   function is an efficient way of multiplying
         *   numbers by themselves (or their reciprocals) in
         *   large quantities. For example, pow(3, 5) is
         *   equivalent to the expression 3 × 3 × 3 × 3 × 3 and
         *   pow(3, -5) is equivalent to 1 / 3 × 3 × 3 × 3 × 3.
         *   Maps to Math.pow().
         *   @param n base of the exponential expression
         *   @param e power by which to raise the base
         *   @return n^e
         */
        pow(n: number, e: number): number;

        /**
         *   Calculates the integer closest to the n parameter.
         *   For example, round(133.8) returns the value 134.
         *   Maps to Math.round().
         *   @param n number to round
         *   @param [decimals] number of decimal places to
         *   round to, default is 0
         *   @return rounded number
         */
        round(n: number, decimals?: number): number;

        /**
         *   Squares a number (multiplies a number by itself).
         *   The result is always a positive number, as
         *   multiplying two negative numbers always yields a
         *   positive result. For example, -1 * -1 = 1.
         *   @param n number to square
         *   @return squared number
         */
        sq(n: number): number;

        /**
         *   Calculates the square root of a number. The square
         *   root of a number is always positive, even though
         *   there may be a valid negative root. The square
         *   root s of number a is such that s*s = a. It is the
         *   opposite of squaring. Maps to Math.sqrt().
         *   @param n non-negative number to square root
         *   @return square root of number
         */
        sqrt(n: number): number;

        /**
         *   Calculates the fractional part of a number.
         *   @param num Number whose fractional part needs to
         *   be found out
         *   @return fractional part of x, i.e, {x}
         */
        fract(num: number): number;
    }

// Inlined from: ./src/math/math.d.ts

    interface p5InstanceExtensions {
        /**
         *   Creates a new p5.Vector (the datatype for storing
         *   vectors). This provides a two or three-dimensional
         *   vector, specifically a Euclidean (also known as
         *   geometric) vector. A vector is an entity that has
         *   both magnitude and direction.
         *   @param [x] x component of the vector
         *   @param [y] y component of the vector
         *   @param [z] z component of the vector
         */
        createVector(x?: number, y?: number, z?: number): Vector;
    }

// Inlined from: ./src/math/noise.d.ts

    interface p5InstanceExtensions {
        /**
         *   Returns the Perlin noise value at specified
         *   coordinates. Perlin noise is a random sequence
         *   generator producing a more naturally ordered,
         *   harmonic succession of numbers compared to the
         *   standard random() function. It was invented by Ken
         *   Perlin in the 1980s and been used since in
         *   graphical applications to produce procedural
         *   textures, natural motion, shapes, terrains etc.
         *   The main difference to the random() function is
         *   that Perlin noise is defined in an infinite
         *   n-dimensional space where each pair of coordinates
         *   corresponds to a fixed semi-random value (fixed
         *   only for the lifespan of the program; see the
         *   noiseSeed() function). p5.js can compute 1D, 2D
         *   and 3D noise, depending on the number of
         *   coordinates given. The resulting value will always
         *   be between 0.0 and 1.0. The noise value can be
         *   animated by moving through the noise space as
         *   demonstrated in the example above. The 2nd and 3rd
         *   dimensions can also be interpreted as time.
         *
         *   The actual noise is structured similar to an audio
         *   signal, in respect to the function's use of
         *   frequencies. Similar to the concept of harmonics
         *   in physics, Perlin noise is computed over several
         *   octaves which are added together for the final
         *   result.
         *
         *   Another way to adjust the character of the
         *   resulting sequence is the scale of the input
         *   coordinates. As the function works within an
         *   infinite space the value of the coordinates
         *   doesn't matter as such, only the distance between
         *   successive coordinates does (eg. when using
         *   noise() within a loop). As a general rule the
         *   smaller the difference between coordinates, the
         *   smoother the resulting noise sequence will be.
         *   Steps of 0.005-0.03 work best for most
         *   applications, but this will differ depending on
         *   use.
         *   @param x x-coordinate in noise space
         *   @param [y] y-coordinate in noise space
         *   @param [z] z-coordinate in noise space
         *   @return Perlin noise value (between 0 and 1) at
         *   specified coordinates
         */
        noise(x: number, y?: number, z?: number): number;

        /**
         *   Adjusts the character and level of detail produced
         *   by the Perlin noise function. Similar to harmonics
         *   in physics, noise is computed over several
         *   octaves. Lower octaves contribute more to the
         *   output signal and as such define the overall
         *   intensity of the noise, whereas higher octaves
         *   create finer-grained details in the noise
         *   sequence. By default, noise is computed over 4
         *   octaves with each octave contributing exactly half
         *   as much as its predecessor, starting at 50%
         *   strength for the 1st octave. This falloff amount
         *   can be changed by adding an additional function
         *   parameter. Eg. a falloff factor of 0.75 means each
         *   octave will now have 75% impact (25% less) of the
         *   previous lower octave. Any value between 0.0 and
         *   1.0 is valid, however, note that values greater
         *   than 0.5 might result in greater than 1.0 values
         *   returned by noise(). By changing these parameters,
         *   the signal created by the noise() function can be
         *   adapted to fit very specific needs and
         *   characteristics.
         *   @param lod number of octaves to be used by the
         *   noise
         *   @param falloff falloff factor for each octave
         */
        noiseDetail(lod: number, falloff: number): void;

        /**
         *   Sets the seed value for noise(). By default,
         *   noise() produces different results each time the
         *   program is run. Set the seed parameter to a
         *   constant to return the same pseudo-random numbers
         *   each time the software is run.
         *   @param seed the seed value
         */
        noiseSeed(seed: number): void;
    }

// Inlined from: ./src/math/random.d.ts

    interface p5InstanceExtensions {
        /**
         *   Sets the seed value for random(). By default,
         *   random() produces different results each time the
         *   program is run. Set the seed parameter to a
         *   constant to return the same pseudo-random numbers
         *   each time the software is run.
         *   @param seed the seed value
         */
        randomSeed(seed: number): void;

        /**
         *   Return a random floating-point number. Takes
         *   either 0, 1 or 2 arguments.
         *
         *   If no argument is given, returns a random number
         *   from 0 up to (but not including) 1.
         *
         *   If one argument is given and it is a number,
         *   returns a random number from 0 up to (but not
         *   including) the number.
         *
         *   If one argument is given and it is an array,
         *   returns a random element from that array.
         *
         *   If two arguments are given, returns a random
         *   number from the first argument up to (but not
         *   including) the second argument.
         *   @param [min] the lower bound (inclusive)
         *   @param [max] the upper bound (exclusive)
         *   @return the random number
         */
        random(min?: number, max?: number): number;

        /**
         *   Return a random floating-point number. Takes
         *   either 0, 1 or 2 arguments.
         *
         *   If no argument is given, returns a random number
         *   from 0 up to (but not including) 1.
         *
         *   If one argument is given and it is a number,
         *   returns a random number from 0 up to (but not
         *   including) the number.
         *
         *   If one argument is given and it is an array,
         *   returns a random element from that array.
         *
         *   If two arguments are given, returns a random
         *   number from the first argument up to (but not
         *   including) the second argument.
         *   @param choices the array to choose from
         *   @return the random element from the array
         */
        random(choices: any[]): any;

        /**
         *   Returns a random number fitting a Gaussian, or
         *   normal, distribution. There is theoretically no
         *   minimum or maximum value that randomGaussian()
         *   might return. Rather, there is just a very low
         *   probability that values far from the mean will be
         *   returned; and a higher probability that numbers
         *   near the mean will be returned. Takes either 0, 1
         *   or 2 arguments. If no args, the mean is 0 and the
         *   standard deviation is 1.
         *
         *   If one arg, that arg is the mean and the standard
         *   deviation is 1.
         *
         *   If two args, the first arg is the mean and the
         *   second is the standard deviation.
         *   @param [mean] the mean
         *   @param [sd] the standard deviation
         *   @return the random number
         */
        randomGaussian(mean?: number, sd?: number): number;
    }

// Inlined from: ./src/math/trigonometry.d.ts

    interface p5InstanceExtensions {
        /**
         *   The inverse of cos(), returns the arc cosine of a
         *   value. This function expects the values in the
         *   range of -1 to 1 and values are returned in the
         *   range 0 to PI (3.1415927) if the angleMode() is
         *   RADIANS or 0 to 180 if the angleMode() is DEGREES.
         *   @param value the value whose arc cosine is to be
         *   returned
         *   @return the arc cosine of the given value
         */
        acos(value: number): number;

        /**
         *   The inverse of sin(), returns the arc sine of a
         *   value. This function expects the values in the
         *   range of -1 to 1 and values are returned in the
         *   range -PI/2 to PI/2 if the angleMode is RADIANS or
         *   -90 to 90 if the angle mode is DEGREES.
         *   @param value the value whose arc sine is to be
         *   returned
         *   @return the arc sine of the given value
         */
        asin(value: number): number;

        /**
         *   The inverse of tan(), returns the arc tangent of a
         *   value. This function expects the values in the
         *   range of -Infinity to Infinity (exclusive) and
         *   values are returned in the range -PI/2 to PI/2 if
         *   the angleMode is RADIANS or -90 to 90 if the angle
         *   mode is DEGREES.
         *   @param value the value whose arc tangent is to be
         *   returned
         *   @return the arc tangent of the given value
         */
        atan(value: number): number;

        /**
         *   Calculates the angle (in radians) from a specified
         *   point to the coordinate origin as measured from
         *   the positive x-axis. Values are returned as a
         *   float in the range from PI to -PI if the
         *   angleMode() is RADIANS or 180 to -180 if the
         *   angleMode() is DEGREES. The atan2() function is
         *   most often used for orienting geometry to the
         *   position of the cursor. Note: The y-coordinate of
         *   the point is the first parameter, and the
         *   x-coordinate is the second parameter, due to the
         *   structure of calculating the tangent.
         *   @param y y-coordinate of the point
         *   @param x x-coordinate of the point
         *   @return the arc tangent of the given point
         */
        atan2(y: number, x: number): number;

        /**
         *   Calculates the cosine of an angle. This function
         *   takes into account the current angleMode. Values
         *   are returned in the range -1 to 1.
         *   @param angle the angle
         *   @return the cosine of the angle
         */
        cos(angle: number): number;

        /**
         *   Calculates the sine of an angle. This function
         *   takes into account the current angleMode. Values
         *   are returned in the range -1 to 1.
         *   @param angle the angle
         *   @return the sine of the angle
         */
        sin(angle: number): number;

        /**
         *   Calculates the tangent of an angle. This function
         *   takes into account the current angleMode. Values
         *   are returned in the range of all real numbers.
         *   @param angle the angle
         *   @return the tangent of the angle
         */
        tan(angle: number): number;

        /**
         *   Converts a radian measurement to its corresponding
         *   value in degrees. Radians and degrees are two ways
         *   of measuring the same thing. There are 360 degrees
         *   in a circle and 2*PI radians in a circle. For
         *   example, 90° = PI/2 = 1.5707964. This function
         *   does not take into account the current
         *   angleMode().
         *   @param radians the radians value to convert to
         *   degrees
         *   @return the converted angle
         */
        degrees(radians: number): number;

        /**
         *   Converts a degree measurement to its corresponding
         *   value in radians. Radians and degrees are two ways
         *   of measuring the same thing. There are 360 degrees
         *   in a circle and 2*PI radians in a circle. For
         *   example, 90° = PI/2 = 1.5707964. This function
         *   does not take into account the current angleMode.
         *   @param degrees the degree value to convert to
         *   radians
         *   @return the converted angle
         */
        radians(degrees: number): number;

        /**
         *   Sets the current mode of p5 to the given mode.
         *   Default mode is RADIANS. Calling angleMode() with
         *   no arguments returns current anglemode.
         *   @param mode either RADIANS or DEGREES
         */
        angleMode(mode: ANGLE_MODE): void;

        /**
         *   Sets the current mode of p5 to the given mode.
         *   Default mode is RADIANS. Calling angleMode() with
         *   no arguments returns current anglemode.
         *   @return mode either RADIANS or DEGREES
         */
        angleMode(): UNKNOWN_P5_CONSTANT;
    }

// Inlined from: ./src/typography/attributes.d.ts

    interface p5InstanceExtensions {
        /**
         *   Sets the current alignment for drawing text.
         *   Accepts two arguments: horizAlign (LEFT, CENTER,
         *   or RIGHT) and vertAlign (TOP, BOTTOM, CENTER, or
         *   BASELINE). The horizAlign parameter is in
         *   reference to the x value of the text() function,
         *   while the vertAlign parameter is in reference to
         *   the y value.
         *
         *   So if you write textAlign(LEFT), you are aligning
         *   the left edge of your text to the x value you give
         *   in text(). If you write textAlign(RIGHT, TOP), you
         *   are aligning the right edge of your text to the x
         *   value and the top edge of the text to the y value.
         *   @param horizAlign horizontal alignment, either
         *   LEFT, CENTER, or RIGHT
         *   @param [vertAlign] vertical alignment, either TOP,
         *   BOTTOM, CENTER, or BASELINE
         *   @chainable
         */
        textAlign(horizAlign: HORIZ_ALIGN, vertAlign?: VERT_ALIGN): p5;

        /**
         *   Sets the current alignment for drawing text.
         *   Accepts two arguments: horizAlign (LEFT, CENTER,
         *   or RIGHT) and vertAlign (TOP, BOTTOM, CENTER, or
         *   BASELINE). The horizAlign parameter is in
         *   reference to the x value of the text() function,
         *   while the vertAlign parameter is in reference to
         *   the y value.
         *
         *   So if you write textAlign(LEFT), you are aligning
         *   the left edge of your text to the x value you give
         *   in text(). If you write textAlign(RIGHT, TOP), you
         *   are aligning the right edge of your text to the x
         *   value and the top edge of the text to the y value.
         */
        textAlign(): object;

        /**
         *   Sets/gets the spacing, in pixels, between lines of
         *   text. This setting will be used in all subsequent
         *   calls to the text() function.
         *   @param leading the size in pixels for spacing
         *   between lines
         *   @chainable
         */
        textLeading(leading: number): p5;

        /**
         *   Sets/gets the spacing, in pixels, between lines of
         *   text. This setting will be used in all subsequent
         *   calls to the text() function.
         */
        textLeading(): number;

        /**
         *   Sets/gets the current font size. This size will be
         *   used in all subsequent calls to the text()
         *   function. Font size is measured in pixels.
         *   @param theSize the size of the letters in units of
         *   pixels
         *   @chainable
         */
        textSize(theSize: number): p5;

        /**
         *   Sets/gets the current font size. This size will be
         *   used in all subsequent calls to the text()
         *   function. Font size is measured in pixels.
         */
        textSize(): number;

        /**
         *   Sets/gets the style of the text for system fonts
         *   to NORMAL, ITALIC, BOLD or BOLDITALIC. Note: this
         *   may be is overridden by CSS styling. For
         *   non-system fonts (opentype, truetype, etc.) please
         *   load styled fonts instead.
         *   @param theStyle styling for text, either NORMAL,
         *   ITALIC, BOLD or BOLDITALIC
         *   @chainable
         */
        textStyle(theStyle: THE_STYLE): p5;

        /**
         *   Sets/gets the style of the text for system fonts
         *   to NORMAL, ITALIC, BOLD or BOLDITALIC. Note: this
         *   may be is overridden by CSS styling. For
         *   non-system fonts (opentype, truetype, etc.) please
         *   load styled fonts instead.
         */
        textStyle(): string;

        /**
         *   Calculates and returns the width of any character
         *   or text string.
         *   @param theText the String of characters to measure
         *   @return the calculated width
         */
        textWidth(theText: string): number;

        /**
         *   Returns the ascent of the current font at its
         *   current size. The ascent represents the distance,
         *   in pixels, of the tallest character above the
         *   baseline.
         */
        textAscent(): number;

        /**
         *   Returns the descent of the current font at its
         *   current size. The descent represents the distance,
         *   in pixels, of the character with the longest
         *   descender below the baseline.
         */
        textDescent(): number;

        /**
         *   Specifies how lines of text are wrapped within a
         *   text box. This requires a max-width set on the
         *   text area, specified in text() as parameter x2.
         *   WORD wrap style only breaks lines at spaces. A
         *   single string without spaces that exceeds the
         *   boundaries of the canvas or text area is not
         *   truncated, and will overflow the desired area,
         *   disappearing at the canvas edge.
         *
         *   CHAR wrap style breaks lines wherever needed to
         *   stay within the text box.
         *
         *   WORD is the default wrap style, and both styles
         *   will still break lines at any line breaks (\n)
         *   specified in the original text. The text area
         *   max-height parameter (y2) also still applies to
         *   wrapped text in both styles, lines of text that do
         *   not fit within the text area will not be drawn to
         *   the screen.
         *   @param wrapStyle text wrapping style, either WORD
         *   or CHAR
         *   @return wrapStyle
         */
        textWrap(wrapStyle: WRAP_STYLE): string;
    }

// Inlined from: ./src/typography/loading_displaying.d.ts

    interface p5InstanceExtensions {
        /**
         *   Loads an opentype font file (.otf, .ttf) from a
         *   file or a URL, and returns a p5.Font object. This
         *   function is asynchronous, meaning it may not
         *   finish before the next line in your sketch is
         *   executed. The path to the font should be relative
         *   to the HTML file that links in your sketch.
         *   Loading fonts from a URL or other remote location
         *   may be blocked due to your browser's built-in
         *   security.
         *   @param path name of the file or url to load
         *   @param [callback] function to be executed after
         *   loadFont() completes
         *   @param [onError] function to be executed if an
         *   error occurs
         *   @return p5.Font object
         */
        loadFont(path: string, callback?: (...args: any[]) => any, onError?: (...args: any[]) => any): Font;

        /**
         *   Draws text to the screen. Displays the information
         *   specified in the first parameter on the screen in
         *   the position specified by the additional
         *   parameters. A default font will be used unless a
         *   font is set with the textFont() function and a
         *   default size will be used unless a font is set
         *   with textSize(). Change the color of the text with
         *   the fill() function. Change the outline of the
         *   text with the stroke() and strokeWeight()
         *   functions. The text displays in relation to the
         *   textAlign() function, which gives the option to
         *   draw to the left, right, and center of the
         *   coordinates.
         *
         *   The x2 and y2 parameters define a rectangular area
         *   to display within and may only be used with string
         *   data. When these parameters are specified, they
         *   are interpreted based on the current rectMode()
         *   setting. Text that does not fit completely within
         *   the rectangle specified will not be drawn to the
         *   screen. If x2 and y2 are not specified, the
         *   baseline alignment is the default, which means
         *   that the text will be drawn upwards from x and y.
         *
         *   WEBGL: Only opentype/truetype fonts are supported.
         *   You must load a font using the loadFont() method
         *   (see the example above). stroke() currently has no
         *   effect in webgl mode. Learn more about working
         *   with text in webgl mode on the wiki.
         *   @param str the alphanumeric symbols to be
         *   displayed
         *   @param x x-coordinate of text
         *   @param y y-coordinate of text
         *   @param [x2] by default, the width of the text box,
         *   see rectMode() for more info
         *   @param [y2] by default, the height of the text
         *   box, see rectMode() for more info
         *   @chainable
         */
        text(str: string | object | any[] | number | boolean, x: number, y: number, x2?: number, y2?: number): p5;

        /**
         *   Sets the current font that will be drawn with the
         *   text() function. If textFont() is called without
         *   any argument, it will return the current font if
         *   one has been set already. If not, it will return
         *   the name of the default font as a string. If
         *   textFont() is called with a font to use, it will
         *   return the p5 object. WEBGL: Only fonts loaded via
         *   loadFont() are supported.
         *   @return the current font / p5 Object
         */
        textFont(): object;

        /**
         *   Sets the current font that will be drawn with the
         *   text() function. If textFont() is called without
         *   any argument, it will return the current font if
         *   one has been set already. If not, it will return
         *   the name of the default font as a string. If
         *   textFont() is called with a font to use, it will
         *   return the p5 object. WEBGL: Only fonts loaded via
         *   loadFont() are supported.
         *   @param font a font loaded via loadFont(), or a
         *   String representing a web safe font (a font that
         *   is generally available across all systems)
         *   @param [size] the font size to use
         *   @chainable
         */
        textFont(font: object | string, size?: number): p5;
    }

// Inlined from: ./src/utilities/array_functions.d.ts

    interface p5InstanceExtensions {
        /**
         *   Adds a value to the end of an array. Extends the
         *   length of the array by one. Maps to Array.push().
         *   @param array Array to append
         *   @param value to be added to the Array
         *   @return the array that was appended to
         */
        append(array: any[], value: any): any[];

        /**
         *   Copies an array (or part of an array) to another
         *   array. The src array is copied to the dst array,
         *   beginning at the position specified by srcPosition
         *   and into the position specified by dstPosition.
         *   The number of elements to copy is determined by
         *   length. Note that copying values overwrites
         *   existing values in the destination array. To
         *   append values instead of overwriting them, use
         *   concat(). The simplified version with only two
         *   arguments, arrayCopy(src, dst), copies an entire
         *   array to another of the same size. It is
         *   equivalent to arrayCopy(src, 0, dst, 0,
         *   src.length).
         *
         *   Using this function is far more efficient for
         *   copying array data than iterating through a for()
         *   loop and copying each element individually.
         *   @param src the source Array
         *   @param srcPosition starting position in the source
         *   Array
         *   @param dst the destination Array
         *   @param dstPosition starting position in the
         *   destination Array
         *   @param length number of Array elements to be
         *   copied
         */
        arrayCopy(src: any[], srcPosition: number, dst: any[], dstPosition: number, length: number): void;

        /**
         *   Copies an array (or part of an array) to another
         *   array. The src array is copied to the dst array,
         *   beginning at the position specified by srcPosition
         *   and into the position specified by dstPosition.
         *   The number of elements to copy is determined by
         *   length. Note that copying values overwrites
         *   existing values in the destination array. To
         *   append values instead of overwriting them, use
         *   concat(). The simplified version with only two
         *   arguments, arrayCopy(src, dst), copies an entire
         *   array to another of the same size. It is
         *   equivalent to arrayCopy(src, 0, dst, 0,
         *   src.length).
         *
         *   Using this function is far more efficient for
         *   copying array data than iterating through a for()
         *   loop and copying each element individually.
         *   @param src the source Array
         *   @param dst the destination Array
         *   @param [length] number of Array elements to be
         *   copied
         */
        arrayCopy(src: any[], dst: any[], length?: number): void;

        /**
         *   Concatenates two arrays, maps to Array.concat().
         *   Does not modify the input arrays.
         *   @param a first Array to concatenate
         *   @param b second Array to concatenate
         *   @return concatenated array
         */
        concat(a: any[], b: any[]): any[];

        /**
         *   Reverses the order of an array, maps to
         *   Array.reverse()
         *   @param list Array to reverse
         *   @return the reversed list
         */
        reverse(list: any[]): any[];

        /**
         *   Decreases an array by one element and returns the
         *   shortened array, maps to Array.pop().
         *   @param list Array to shorten
         *   @return shortened Array
         */
        shorten(list: any[]): any[];

        /**
         *   Randomizes the order of the elements of an array.
         *   Implements  Fisher-Yates Shuffle Algorithm.
         *   @param array Array to shuffle
         *   @param [bool] modify passed array
         *   @return shuffled Array
         */
        shuffle(array: any[], bool?: boolean): any[];

        /**
         *   Sorts an array of numbers from smallest to
         *   largest, or puts an array of words in alphabetical
         *   order. The original array is not modified; a
         *   re-ordered array is returned. The count parameter
         *   states the number of elements to sort. For
         *   example, if there are 12 elements in an array and
         *   count is set to 5, only the first 5 elements in
         *   the array will be sorted.
         *   @param list Array to sort
         *   @param [count] number of elements to sort,
         *   starting from 0
         *   @return the sorted list
         */
        sort(list: any[], count?: number): any[];

        /**
         *   Inserts a value or an array of values into an
         *   existing array. The first parameter specifies the
         *   initial array to be modified, and the second
         *   parameter defines the data to be inserted. The
         *   third parameter is an index value which specifies
         *   the array position from which to insert data.
         *   (Remember that array index numbering starts at
         *   zero, so the first position is 0, the second
         *   position is 1, and so on.)
         *   @param list Array to splice into
         *   @param value value to be spliced in
         *   @param position in the array from which to insert
         *   data
         *   @return the list
         */
        splice(list: any[], value: any, position: number): any[];

        /**
         *   Extracts an array of elements from an existing
         *   array. The list parameter defines the array from
         *   which the elements will be copied, and the start
         *   and count parameters specify which elements to
         *   extract. If no count is given, elements will be
         *   extracted from the start to the end of the array.
         *   When specifying the start, remember that the first
         *   array element is 0. This function does not change
         *   the source array.
         *   @param list Array to extract from
         *   @param start position to begin
         *   @param [count] number of values to extract
         *   @return Array of extracted elements
         */
        subset(list: any[], start: number, count?: number): any[];
    }

// Inlined from: ./src/utilities/conversion.d.ts

    interface p5InstanceExtensions {
        /**
         *   Converts a string to its floating point
         *   representation. The contents of a string must
         *   resemble a number, or NaN (not a number) will be
         *   returned. For example, float("1234.56") evaluates
         *   to 1234.56, but float("giraffe") will return NaN.
         *   When an array of values is passed in, then an
         *   array of floats of the same length is returned.
         *   @param str float string to parse
         *   @return floating point representation of string
         */
        float(str: string): number;

        /**
         *   Converts a boolean, string, or float to its
         *   integer representation. When an array of values is
         *   passed in, then an int array of the same length is
         *   returned.
         *   @param n value to parse
         *   @param [radix] the radix to convert to (default:
         *   10)
         *   @return integer representation of value
         */
        int(n: string | boolean | number, radix?: number): number;

        /**
         *   Converts a boolean, string, or float to its
         *   integer representation. When an array of values is
         *   passed in, then an int array of the same length is
         *   returned.
         *   @param ns values to parse
         *   @param [radix] the radix to convert to (default:
         *   10)
         *   @return integer representation of values
         */
        int(ns: any[], radix?: number): number[];

        /**
         *   Converts a boolean, string or number to its string
         *   representation. When an array of values is passed
         *   in, then an array of strings of the same length is
         *   returned.
         *   @param n value to parse
         *   @return string representation of value
         */
        str(n: string | boolean | number | any[]): string;

        /**
         *   Converts a number or string to its boolean
         *   representation. For a number, any non-zero value
         *   (positive or negative) evaluates to true, while
         *   zero evaluates to false. For a string, the value
         *   "true" evaluates to true, while any other value
         *   evaluates to false. When an array of number or
         *   string values is passed in, then a array of
         *   booleans of the same length is returned.
         *   @param n value to parse
         *   @return boolean representation of value
         */
        boolean(n: string | boolean | number | any[]): boolean;

        /**
         *   Converts a number, string representation of a
         *   number, or boolean to its byte representation. A
         *   byte can be only a whole number between -128 and
         *   127, so when a value outside of this range is
         *   converted, it wraps around to the corresponding
         *   byte representation. When an array of number,
         *   string or boolean values is passed in, then an
         *   array of bytes the same length is returned.
         *   @param n value to parse
         *   @return byte representation of value
         */
        byte(n: string | boolean | number): number;

        /**
         *   Converts a number, string representation of a
         *   number, or boolean to its byte representation. A
         *   byte can be only a whole number between -128 and
         *   127, so when a value outside of this range is
         *   converted, it wraps around to the corresponding
         *   byte representation. When an array of number,
         *   string or boolean values is passed in, then an
         *   array of bytes the same length is returned.
         *   @param ns values to parse
         *   @return array of byte representation of values
         */
        byte(ns: any[]): number[];

        /**
         *   Converts a number or string to its corresponding
         *   single-character string representation. If a
         *   string parameter is provided, it is first parsed
         *   as an integer and then translated into a
         *   single-character string. When an array of number
         *   or string values is passed in, then an array of
         *   single-character strings of the same length is
         *   returned.
         *   @param n value to parse
         *   @return string representation of value
         */
        char(n: string | number): string;

        /**
         *   Converts a number or string to its corresponding
         *   single-character string representation. If a
         *   string parameter is provided, it is first parsed
         *   as an integer and then translated into a
         *   single-character string. When an array of number
         *   or string values is passed in, then an array of
         *   single-character strings of the same length is
         *   returned.
         *   @param ns values to parse
         *   @return array of string representation of values
         */
        char(ns: any[]): string[];

        /**
         *   Converts a single-character string to its
         *   corresponding integer representation. When an
         *   array of single-character string values is passed
         *   in, then an array of integers of the same length
         *   is returned.
         *   @param n value to parse
         *   @return integer representation of value
         */
        unchar(n: string): number;

        /**
         *   Converts a single-character string to its
         *   corresponding integer representation. When an
         *   array of single-character string values is passed
         *   in, then an array of integers of the same length
         *   is returned.
         *   @param ns values to parse
         *   @return integer representation of values
         */
        unchar(ns: any[]): number[];

        /**
         *   Converts a number to a string in its equivalent
         *   hexadecimal notation. If a second parameter is
         *   passed, it is used to set the number of characters
         *   to generate in the hexadecimal notation. When an
         *   array is passed in, an array of strings in
         *   hexadecimal notation of the same length is
         *   returned.
         *   @param n value to parse
         *   @return hexadecimal string representation of value
         */
        hex(n: number, digits?: number): string;

        /**
         *   Converts a number to a string in its equivalent
         *   hexadecimal notation. If a second parameter is
         *   passed, it is used to set the number of characters
         *   to generate in the hexadecimal notation. When an
         *   array is passed in, an array of strings in
         *   hexadecimal notation of the same length is
         *   returned.
         *   @param ns array of values to parse
         *   @return hexadecimal string representation of
         *   values
         */
        hex(ns: number[], digits?: number): string[];

        /**
         *   Converts a string representation of a hexadecimal
         *   number to its equivalent integer value. When an
         *   array of strings in hexadecimal notation is passed
         *   in, an array of integers of the same length is
         *   returned.
         *   @param n value to parse
         *   @return integer representation of hexadecimal
         *   value
         */
        unhex(n: string): number;

        /**
         *   Converts a string representation of a hexadecimal
         *   number to its equivalent integer value. When an
         *   array of strings in hexadecimal notation is passed
         *   in, an array of integers of the same length is
         *   returned.
         *   @param ns values to parse
         *   @return integer representations of hexadecimal
         *   value
         */
        unhex(ns: any[]): number[];
    }

// Inlined from: ./src/utilities/string_functions.d.ts

    interface p5InstanceExtensions {
        /**
         *   Combines an array of Strings into one String, each
         *   separated by the character(s) used for the
         *   separator parameter. To join arrays of ints or
         *   floats, it's necessary to first convert them to
         *   Strings using nf() or nfs().
         *   @param list array of Strings to be joined
         *   @param separator String to be placed between each
         *   item
         *   @return joined String
         */
        join(list: any[], separator: string): string;

        /**
         *   This function is used to apply a regular
         *   expression to a piece of text, and return matching
         *   groups (elements found inside parentheses) as a
         *   String array. If there are no matches, a null
         *   value will be returned. If no groups are specified
         *   in the regular expression, but the sequence
         *   matches, an array of length 1 (with the matched
         *   text as the first element of the array) will be
         *   returned. To use the function, first check to see
         *   if the result is null. If the result is null, then
         *   the sequence did not match at all. If the sequence
         *   did match, an array is returned.
         *
         *   If there are groups (specified by sets of
         *   parentheses) in the regular expression, then the
         *   contents of each will be returned in the array.
         *   Element [0] of a regular expression match returns
         *   the entire matching string, and the match groups
         *   start at element [1] (the first group is [1], the
         *   second [2], and so on).
         *   @param str the String to be searched
         *   @param regexp the regexp to be used for matching
         *   @return Array of Strings found
         */
        match(str: string, regexp: string): string[];

        /**
         *   This function is used to apply a regular
         *   expression to a piece of text, and return a list
         *   of matching groups (elements found inside
         *   parentheses) as a two-dimensional String array. If
         *   there are no matches, a null value will be
         *   returned. If no groups are specified in the
         *   regular expression, but the sequence matches, a
         *   two dimensional array is still returned, but the
         *   second dimension is only of length one. To use the
         *   function, first check to see if the result is
         *   null. If the result is null, then the sequence did
         *   not match at all. If the sequence did match, a 2D
         *   array is returned.
         *
         *   If there are groups (specified by sets of
         *   parentheses) in the regular expression, then the
         *   contents of each will be returned in the array.
         *   Assuming a loop with counter variable i, element
         *   [i][0] of a regular expression match returns the
         *   entire matching string, and the match groups start
         *   at element [i][1] (the first group is [i][1], the
         *   second [i][2], and so on).
         *   @param str the String to be searched
         *   @param regexp the regexp to be used for matching
         *   @return 2d Array of Strings found
         */
        matchAll(str: string, regexp: string): string[];

        /**
         *   Utility function for formatting numbers into
         *   strings. There are two versions: one for
         *   formatting floats, and one for formatting ints.
         *   The values for the digits, left, and right
         *   parameters should always be positive integers.
         *
         *   (NOTE): Be cautious when using left and right
         *   parameters as it prepends numbers of 0's if the
         *   parameter if greater than the current length of
         *   the number.
         *
         *   For example if number is 123.2 and left parameter
         *   passed is 4 which is greater than length of 123
         *   (integer part) i.e 3 than result will be 0123.2.
         *   Same case for right parameter i.e. if right is 3
         *   than the result will be 123.200.
         *   @param num the Number to format
         *   @param [left] number of digits to the left of the
         *   decimal point
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted String
         */
        nf(num: number | string, left?: number | string, right?: number | string): string;

        /**
         *   Utility function for formatting numbers into
         *   strings. There are two versions: one for
         *   formatting floats, and one for formatting ints.
         *   The values for the digits, left, and right
         *   parameters should always be positive integers.
         *
         *   (NOTE): Be cautious when using left and right
         *   parameters as it prepends numbers of 0's if the
         *   parameter if greater than the current length of
         *   the number.
         *
         *   For example if number is 123.2 and left parameter
         *   passed is 4 which is greater than length of 123
         *   (integer part) i.e 3 than result will be 0123.2.
         *   Same case for right parameter i.e. if right is 3
         *   than the result will be 123.200.
         *   @param nums the Numbers to format
         *   @param [left] number of digits to the left of the
         *   decimal point
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted Strings
         */
        nf(nums: any[], left?: number | string, right?: number | string): string[];

        /**
         *   Utility function for formatting numbers into
         *   strings and placing appropriate commas to mark
         *   units of 1000. There are two versions: one for
         *   formatting ints, and one for formatting an array
         *   of ints. The value for the right parameter should
         *   always be a positive integer.
         *   @param num the Number to format
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted String
         */
        nfc(num: number | string, right?: number | string): string;

        /**
         *   Utility function for formatting numbers into
         *   strings and placing appropriate commas to mark
         *   units of 1000. There are two versions: one for
         *   formatting ints, and one for formatting an array
         *   of ints. The value for the right parameter should
         *   always be a positive integer.
         *   @param nums the Numbers to format
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted Strings
         */
        nfc(nums: any[], right?: number | string): string[];

        /**
         *   Utility function for formatting numbers into
         *   strings. Similar to nf() but puts a "+" in front
         *   of positive numbers and a "-" in front of negative
         *   numbers. There are two versions: one for
         *   formatting floats, and one for formatting ints.
         *   The values for left, and right parameters should
         *   always be positive integers.
         *   @param num the Number to format
         *   @param [left] number of digits to the left of the
         *   decimal point
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted String
         */
        nfp(num: number, left?: number, right?: number): string;

        /**
         *   Utility function for formatting numbers into
         *   strings. Similar to nf() but puts a "+" in front
         *   of positive numbers and a "-" in front of negative
         *   numbers. There are two versions: one for
         *   formatting floats, and one for formatting ints.
         *   The values for left, and right parameters should
         *   always be positive integers.
         *   @param nums the Numbers to format
         *   @param [left] number of digits to the left of the
         *   decimal point
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted Strings
         */
        nfp(nums: number[], left?: number, right?: number): string[];

        /**
         *   Utility function for formatting numbers into
         *   strings. Similar to nf() but puts an additional
         *   "_" (space) in front of positive numbers just in
         *   case to align it with negative numbers which
         *   includes "-" (minus) sign. The main usecase of
         *   nfs() can be seen when one wants to align the
         *   digits (place values) of a non-negative number
         *   with some negative number (See the example to get
         *   a clear picture). There are two versions: one for
         *   formatting float, and one for formatting int.
         *
         *   The values for the digits, left, and right
         *   parameters should always be positive integers.
         *
         *   (IMP): The result on the canvas basically the
         *   expected alignment can vary based on the typeface
         *   you are using.
         *
         *   (NOTE): Be cautious when using left and right
         *   parameters as it prepends numbers of 0's if the
         *   parameter if greater than the current length of
         *   the number.
         *
         *   For example if number is 123.2 and left parameter
         *   passed is 4 which is greater than length of 123
         *   (integer part) i.e 3 than result will be 0123.2.
         *   Same case for right parameter i.e. if right is 3
         *   than the result will be 123.200.
         *   @param num the Number to format
         *   @param [left] number of digits to the left of the
         *   decimal point
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted String
         */
        nfs(num: number, left?: number, right?: number): string;

        /**
         *   Utility function for formatting numbers into
         *   strings. Similar to nf() but puts an additional
         *   "_" (space) in front of positive numbers just in
         *   case to align it with negative numbers which
         *   includes "-" (minus) sign. The main usecase of
         *   nfs() can be seen when one wants to align the
         *   digits (place values) of a non-negative number
         *   with some negative number (See the example to get
         *   a clear picture). There are two versions: one for
         *   formatting float, and one for formatting int.
         *
         *   The values for the digits, left, and right
         *   parameters should always be positive integers.
         *
         *   (IMP): The result on the canvas basically the
         *   expected alignment can vary based on the typeface
         *   you are using.
         *
         *   (NOTE): Be cautious when using left and right
         *   parameters as it prepends numbers of 0's if the
         *   parameter if greater than the current length of
         *   the number.
         *
         *   For example if number is 123.2 and left parameter
         *   passed is 4 which is greater than length of 123
         *   (integer part) i.e 3 than result will be 0123.2.
         *   Same case for right parameter i.e. if right is 3
         *   than the result will be 123.200.
         *   @param nums the Numbers to format
         *   @param [left] number of digits to the left of the
         *   decimal point
         *   @param [right] number of digits to the right of
         *   the decimal point
         *   @return formatted Strings
         */
        nfs(nums: any[], left?: number, right?: number): string[];

        /**
         *   The split() function maps to String.split(), it
         *   breaks a String into pieces using a character or
         *   string as the delimiter. The delim parameter
         *   specifies the character or characters that mark
         *   the boundaries between each piece. A String[]
         *   array is returned that contains each of the
         *   pieces. The splitTokens() function works in a
         *   similar fashion, except that it splits using a
         *   range of characters instead of a specific
         *   character or sequence.
         *   @param value the String to be split
         *   @param delim the String used to separate the data
         *   @return Array of Strings
         */
        split(value: string, delim: string): string[];

        /**
         *   The splitTokens() function splits a String at one
         *   or many character delimiters or "tokens." The
         *   delim parameter specifies the character or
         *   characters to be used as a boundary. If no delim
         *   characters are specified, any whitespace character
         *   is used to split. Whitespace characters include
         *   tab (\t), line feed (\n), carriage return (\r),
         *   form feed (\f), and space.
         *   @param value the String to be split
         *   @param [delim] list of individual Strings that
         *   will be used as separators
         *   @return Array of Strings
         */
        splitTokens(value: string, delim?: string): string[];

        /**
         *   Removes whitespace characters from the beginning
         *   and end of a String. In addition to standard
         *   whitespace characters such as space, carriage
         *   return, and tab, this function also removes the
         *   Unicode "nbsp" character.
         *   @param str a String to be trimmed
         *   @return a trimmed String
         */
        trim(str: string): string;

        /**
         *   Removes whitespace characters from the beginning
         *   and end of a String. In addition to standard
         *   whitespace characters such as space, carriage
         *   return, and tab, this function also removes the
         *   Unicode "nbsp" character.
         *   @param strs an Array of Strings to be trimmed
         *   @return an Array of trimmed Strings
         */
        trim(strs: any[]): string[];
    }

// Inlined from: ./src/utilities/time_date.d.ts

    interface p5InstanceExtensions {
        /**
         *   p5.js communicates with the clock on your
         *   computer. The day() function returns the current
         *   day as a value from 1 - 31.
         *   @return the current day
         */
        day(): number;

        /**
         *   p5.js communicates with the clock on your
         *   computer. The hour() function returns the current
         *   hour as a value from 0 - 23.
         *   @return the current hour
         */
        hour(): number;

        /**
         *   p5.js communicates with the clock on your
         *   computer. The minute() function returns the
         *   current minute as a value from 0 - 59.
         *   @return the current minute
         */
        minute(): number;

        /**
         *   Returns the number of milliseconds (thousandths of
         *   a second) since starting the sketch (when setup()
         *   is called). This information is often used for
         *   timing events and animation sequences.
         *   @return the number of milliseconds since starting
         *   the sketch
         */
        millis(): number;

        /**
         *   p5.js communicates with the clock on your
         *   computer. The month() function returns the current
         *   month as a value from 1 - 12.
         *   @return the current month
         */
        month(): number;

        /**
         *   p5.js communicates with the clock on your
         *   computer. The second() function returns the
         *   current second as a value from 0 - 59.
         *   @return the current second
         */
        second(): number;

        /**
         *   p5.js communicates with the clock on your
         *   computer. The year() function returns the current
         *   year as an integer (2014, 2015, 2016, etc).
         *   @return the current year
         */
        year(): number;
    }

// Inlined from: ./src/webgl/3d_primitives.d.ts

    interface p5InstanceExtensions {
        /**
         *   Draw a plane with given a width and height
         *   @param [width] width of the plane
         *   @param [height] height of the plane
         *   @param [detailX] Optional number of triangle
         *   subdivisions in x-dimension
         *   @param [detailY] Optional number of triangle
         *   subdivisions in y-dimension
         *   @chainable
         */
        plane(width?: number, height?: number, detailX?: number, detailY?: number): p5;

        /**
         *   Draw a box with given width, height and depth
         *   @param [width] width of the box
         *   @param [height] height of the box
         *   @param [depth] depth of the box
         *   @param [detailX] Optional number of triangle
         *   subdivisions in x-dimension
         *   @param [detailY] Optional number of triangle
         *   subdivisions in y-dimension
         *   @chainable
         */
        box(width?: number, height?: number, depth?: number, detailX?: number, detailY?: number): p5;

        /**
         *   Draw a sphere with given radius. DetailX and
         *   detailY determines the number of subdivisions in
         *   the x-dimension and the y-dimension of a sphere.
         *   More subdivisions make the sphere seem smoother.
         *   The recommended maximum values are both 24. Using
         *   a value greater than 24 may cause a warning or
         *   slow down the browser.
         *   @param [radius] radius of circle
         *   @param [detailX] optional number of subdivisions
         *   in x-dimension
         *   @param [detailY] optional number of subdivisions
         *   in y-dimension
         *   @chainable
         */
        sphere(radius?: number, detailX?: number, detailY?: number): p5;

        /**
         *   Draw a cylinder with given radius and height
         *   DetailX and detailY determines the number of
         *   subdivisions in the x-dimension and the
         *   y-dimension of a cylinder. More subdivisions make
         *   the cylinder seem smoother. The recommended
         *   maximum value for detailX is 24. Using a value
         *   greater than 24 may cause a warning or slow down
         *   the browser.
         *   @param [radius] radius of the surface
         *   @param [height] height of the cylinder
         *   @param [detailX] number of subdivisions in
         *   x-dimension; default is 24
         *   @param [detailY] number of subdivisions in
         *   y-dimension; default is 1
         *   @param [bottomCap] whether to draw the bottom of
         *   the cylinder
         *   @param [topCap] whether to draw the top of the
         *   cylinder
         *   @chainable
         */
        cylinder(
            radius?: number,
            height?: number,
            detailX?: number,
            detailY?: number,
            bottomCap?: boolean,
            topCap?: boolean
        ): p5;

        /**
         *   Draw a cone with given radius and height DetailX
         *   and detailY determine the number of subdivisions
         *   in the x-dimension and the y-dimension of a cone.
         *   More subdivisions make the cone seem smoother. The
         *   recommended maximum value for detailX is 24. Using
         *   a value greater than 24 may cause a warning or
         *   slow down the browser.
         *   @param [radius] radius of the bottom surface
         *   @param [height] height of the cone
         *   @param [detailX] number of segments, the more
         *   segments the smoother geometry default is 24
         *   @param [detailY] number of segments, the more
         *   segments the smoother geometry default is 1
         *   @param [cap] whether to draw the base of the cone
         *   @chainable
         */
        cone(radius?: number, height?: number, detailX?: number, detailY?: number, cap?: boolean): p5;

        /**
         *   Draw an ellipsoid with given radius DetailX and
         *   detailY determine the number of subdivisions in
         *   the x-dimension and the y-dimension of a cone.
         *   More subdivisions make the ellipsoid appear to be
         *   smoother. Avoid detail number above 150, it may
         *   crash the browser.
         *   @param [radiusx] x-radius of ellipsoid
         *   @param [radiusy] y-radius of ellipsoid
         *   @param [radiusz] z-radius of ellipsoid
         *   @param [detailX] number of segments, the more
         *   segments the smoother geometry default is 24.
         *   Avoid detail number above 150, it may crash the
         *   browser.
         *   @param [detailY] number of segments, the more
         *   segments the smoother geometry default is 16.
         *   Avoid detail number above 150, it may crash the
         *   browser.
         *   @chainable
         */
        ellipsoid(radiusx?: number, radiusy?: number, radiusz?: number, detailX?: number, detailY?: number): p5;

        /**
         *   Draw a torus with given radius and tube radius
         *   DetailX and detailY determine the number of
         *   subdivisions in the x-dimension and the
         *   y-dimension of a torus. More subdivisions make the
         *   torus appear to be smoother. The default and
         *   maximum values for detailX and detailY are 24 and
         *   16, respectively. Setting them to relatively small
         *   values like 4 and 6 allows you to create new
         *   shapes other than a torus.
         *   @param [radius] radius of the whole ring
         *   @param [tubeRadius] radius of the tube
         *   @param [detailX] number of segments in
         *   x-dimension, the more segments the smoother
         *   geometry default is 24
         *   @param [detailY] number of segments in
         *   y-dimension, the more segments the smoother
         *   geometry default is 16
         *   @chainable
         */
        torus(radius?: number, tubeRadius?: number, detailX?: number, detailY?: number): p5;
    }

// Inlined from: ./src/webgl/interaction.d.ts

    interface p5InstanceExtensions {
        /**
         *   Allows movement around a 3D sketch using a mouse
         *   or trackpad or touch. Left-clicking and dragging
         *   or swipe motion will rotate the camera position
         *   about the center of the sketch, right-clicking and
         *   dragging or multi-swipe will pan the camera
         *   position without rotation, and using the mouse
         *   wheel (scrolling) or pinch in/out will move the
         *   camera further or closer from the center of the
         *   sketch. This function can be called with
         *   parameters dictating sensitivity to mouse/touch
         *   movement along the X and Y axes. Calling this
         *   function without parameters is equivalent to
         *   calling orbitControl(1,1). To reverse direction of
         *   movement in either axis, enter a negative number
         *   for sensitivity.
         *   @param [sensitivityX] sensitivity to mouse
         *   movement along X axis
         *   @param [sensitivityY] sensitivity to mouse
         *   movement along Y axis
         *   @param [sensitivityZ] sensitivity to scroll
         *   movement along Z axis
         *   @param [options] An optional object that can
         *   contain additional settings, disableTouchActions -
         *   Boolean, default value is true. Setting this to
         *   true makes mobile interactions smoother by
         *   preventing accidental interactions with the page
         *   while orbiting. But if you're already doing it via
         *   css or want the default touch actions, consider
         *   setting it to false. freeRotation - Boolean,
         *   default value is false. By default, horizontal
         *   movement of the mouse or touch pointer rotates the
         *   camera around the y-axis, and vertical movement
         *   rotates the camera around the x-axis. But if
         *   setting this option to true, the camera always
         *   rotates in the direction the pointer is moving.
         *   For zoom and move, the behavior is the same
         *   regardless of true/false.
         *   @chainable
         */
        orbitControl(sensitivityX?: number, sensitivityY?: number, sensitivityZ?: number, options?: object): p5;

        /**
         *   debugMode() helps visualize 3D space by adding a
         *   grid to indicate where the ‘ground’ is in a sketch
         *   and an axes icon which indicates the +X, +Y, and
         *   +Z directions. This function can be called without
         *   parameters to create a default grid and axes icon,
         *   or it can be called according to the examples
         *   above to customize the size and position of the
         *   grid and/or axes icon. The grid is drawn using the
         *   most recently set stroke color and weight. To
         *   specify these parameters, add a call to stroke()
         *   and strokeWeight() just before the end of the
         *   draw() loop. By default, the grid will run through
         *   the origin (0,0,0) of the sketch along the XZ
         *   plane and the axes icon will be offset from the
         *   origin. Both the grid and axes icon will be sized
         *   according to the current canvas size. Note that
         *   because the grid runs parallel to the default
         *   camera view, it is often helpful to use debugMode
         *   along with orbitControl to allow full view of the
         *   grid.
         */
        debugMode(): void;

        /**
         *   debugMode() helps visualize 3D space by adding a
         *   grid to indicate where the ‘ground’ is in a sketch
         *   and an axes icon which indicates the +X, +Y, and
         *   +Z directions. This function can be called without
         *   parameters to create a default grid and axes icon,
         *   or it can be called according to the examples
         *   above to customize the size and position of the
         *   grid and/or axes icon. The grid is drawn using the
         *   most recently set stroke color and weight. To
         *   specify these parameters, add a call to stroke()
         *   and strokeWeight() just before the end of the
         *   draw() loop. By default, the grid will run through
         *   the origin (0,0,0) of the sketch along the XZ
         *   plane and the axes icon will be offset from the
         *   origin. Both the grid and axes icon will be sized
         *   according to the current canvas size. Note that
         *   because the grid runs parallel to the default
         *   camera view, it is often helpful to use debugMode
         *   along with orbitControl to allow full view of the
         *   grid.
         *   @param mode either GRID or AXES
         */
        debugMode(mode: DEBUG_MODE): void;

        /**
         *   debugMode() helps visualize 3D space by adding a
         *   grid to indicate where the ‘ground’ is in a sketch
         *   and an axes icon which indicates the +X, +Y, and
         *   +Z directions. This function can be called without
         *   parameters to create a default grid and axes icon,
         *   or it can be called according to the examples
         *   above to customize the size and position of the
         *   grid and/or axes icon. The grid is drawn using the
         *   most recently set stroke color and weight. To
         *   specify these parameters, add a call to stroke()
         *   and strokeWeight() just before the end of the
         *   draw() loop. By default, the grid will run through
         *   the origin (0,0,0) of the sketch along the XZ
         *   plane and the axes icon will be offset from the
         *   origin. Both the grid and axes icon will be sized
         *   according to the current canvas size. Note that
         *   because the grid runs parallel to the default
         *   camera view, it is often helpful to use debugMode
         *   along with orbitControl to allow full view of the
         *   grid.
         *   @param mode either GRID or AXES
         *   @param [gridSize] size of one side of the grid
         *   @param [gridDivisions] number of divisions in the
         *   grid
         *   @param [xOff] X axis offset from origin (0,0,0)
         *   @param [yOff] Y axis offset from origin (0,0,0)
         *   @param [zOff] Z axis offset from origin (0,0,0)
         */
        debugMode(
            mode: UNKNOWN_P5_CONSTANT,
            gridSize?: number,
            gridDivisions?: number,
            xOff?: number,
            yOff?: number,
            zOff?: number
        ): void;

        /**
         *   debugMode() helps visualize 3D space by adding a
         *   grid to indicate where the ‘ground’ is in a sketch
         *   and an axes icon which indicates the +X, +Y, and
         *   +Z directions. This function can be called without
         *   parameters to create a default grid and axes icon,
         *   or it can be called according to the examples
         *   above to customize the size and position of the
         *   grid and/or axes icon. The grid is drawn using the
         *   most recently set stroke color and weight. To
         *   specify these parameters, add a call to stroke()
         *   and strokeWeight() just before the end of the
         *   draw() loop. By default, the grid will run through
         *   the origin (0,0,0) of the sketch along the XZ
         *   plane and the axes icon will be offset from the
         *   origin. Both the grid and axes icon will be sized
         *   according to the current canvas size. Note that
         *   because the grid runs parallel to the default
         *   camera view, it is often helpful to use debugMode
         *   along with orbitControl to allow full view of the
         *   grid.
         *   @param mode either GRID or AXES
         *   @param [axesSize] size of axes icon
         *   @param [xOff] X axis offset from origin (0,0,0)
         *   @param [yOff] Y axis offset from origin (0,0,0)
         *   @param [zOff] Z axis offset from origin (0,0,0)
         */
        debugMode(mode: UNKNOWN_P5_CONSTANT, axesSize?: number, xOff?: number, yOff?: number, zOff?: number): void;

        /**
         *   debugMode() helps visualize 3D space by adding a
         *   grid to indicate where the ‘ground’ is in a sketch
         *   and an axes icon which indicates the +X, +Y, and
         *   +Z directions. This function can be called without
         *   parameters to create a default grid and axes icon,
         *   or it can be called according to the examples
         *   above to customize the size and position of the
         *   grid and/or axes icon. The grid is drawn using the
         *   most recently set stroke color and weight. To
         *   specify these parameters, add a call to stroke()
         *   and strokeWeight() just before the end of the
         *   draw() loop. By default, the grid will run through
         *   the origin (0,0,0) of the sketch along the XZ
         *   plane and the axes icon will be offset from the
         *   origin. Both the grid and axes icon will be sized
         *   according to the current canvas size. Note that
         *   because the grid runs parallel to the default
         *   camera view, it is often helpful to use debugMode
         *   along with orbitControl to allow full view of the
         *   grid.
         *   @param [gridSize] size of one side of the grid
         *   @param [gridDivisions] number of divisions in the
         *   grid
         *   @param [axesSize] size of axes icon
         */
        debugMode(
            gridSize?: number,
            gridDivisions?: number,
            gridXOff?: number,
            gridYOff?: number,
            gridZOff?: number,
            axesSize?: number,
            axesXOff?: number,
            axesYOff?: number,
            axesZOff?: number
        ): void;

        /**
         *   Turns off debugMode() in a 3D sketch.
         */
        noDebugMode(): void;
    }

// Inlined from: ./src/webgl/light.d.ts

    interface p5InstanceExtensions {
        /**
         *   Creates an ambient light with the given color.
         *   Ambient light does not come from a specific
         *   direction. Objects are evenly lit from all sides.
         *   Ambient lights are almost always used in
         *   combination with other types of lights.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param [alpha] alpha value relative to current
         *   color range (default is 0-255)
         *   @chainable
         */
        ambientLight(v1: number, v2: number, v3: number, alpha?: number): p5;

        /**
         *   Creates an ambient light with the given color.
         *   Ambient light does not come from a specific
         *   direction. Objects are evenly lit from all sides.
         *   Ambient lights are almost always used in
         *   combination with other types of lights.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param gray number specifying value between white
         *   and black
         *   @param [alpha] alpha value relative to current
         *   color range (default is 0-255)
         *   @chainable
         */
        ambientLight(gray: number, alpha?: number): p5;

        /**
         *   Creates an ambient light with the given color.
         *   Ambient light does not come from a specific
         *   direction. Objects are evenly lit from all sides.
         *   Ambient lights are almost always used in
         *   combination with other types of lights.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param value a color string
         *   @chainable
         */
        ambientLight(value: string): p5;

        /**
         *   Creates an ambient light with the given color.
         *   Ambient light does not come from a specific
         *   direction. Objects are evenly lit from all sides.
         *   Ambient lights are almost always used in
         *   combination with other types of lights.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param values an array containing the
         *   red,green,blue & and alpha components of the color
         *   @chainable
         */
        ambientLight(values: number[]): p5;

        /**
         *   Creates an ambient light with the given color.
         *   Ambient light does not come from a specific
         *   direction. Objects are evenly lit from all sides.
         *   Ambient lights are almost always used in
         *   combination with other types of lights.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color
         *   @chainable
         */
        ambientLight(color: Color): p5;

        /**
         *   Sets the color of the specular highlight of a
         *   non-ambient light (i.e. all lights except
         *   ambientLight()). specularColor() affects only the
         *   lights which are created after it in the code.
         *
         *   This function is used in combination with
         *   specularMaterial(). If a geometry does not use
         *   specularMaterial(), this function will have no
         *   effect.
         *
         *   The default color is white (255, 255, 255), which
         *   is used if specularColor() is not explicitly
         *   called.
         *
         *   Note: specularColor is equivalent to the
         *   Processing function lightSpecular.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @chainable
         */
        specularColor(v1: number, v2: number, v3: number): p5;

        /**
         *   Sets the color of the specular highlight of a
         *   non-ambient light (i.e. all lights except
         *   ambientLight()). specularColor() affects only the
         *   lights which are created after it in the code.
         *
         *   This function is used in combination with
         *   specularMaterial(). If a geometry does not use
         *   specularMaterial(), this function will have no
         *   effect.
         *
         *   The default color is white (255, 255, 255), which
         *   is used if specularColor() is not explicitly
         *   called.
         *
         *   Note: specularColor is equivalent to the
         *   Processing function lightSpecular.
         *   @param gray number specifying value between white
         *   and black
         *   @chainable
         */
        specularColor(gray: number): p5;

        /**
         *   Sets the color of the specular highlight of a
         *   non-ambient light (i.e. all lights except
         *   ambientLight()). specularColor() affects only the
         *   lights which are created after it in the code.
         *
         *   This function is used in combination with
         *   specularMaterial(). If a geometry does not use
         *   specularMaterial(), this function will have no
         *   effect.
         *
         *   The default color is white (255, 255, 255), which
         *   is used if specularColor() is not explicitly
         *   called.
         *
         *   Note: specularColor is equivalent to the
         *   Processing function lightSpecular.
         *   @param value color as a CSS string
         *   @chainable
         */
        specularColor(value: string): p5;

        /**
         *   Sets the color of the specular highlight of a
         *   non-ambient light (i.e. all lights except
         *   ambientLight()). specularColor() affects only the
         *   lights which are created after it in the code.
         *
         *   This function is used in combination with
         *   specularMaterial(). If a geometry does not use
         *   specularMaterial(), this function will have no
         *   effect.
         *
         *   The default color is white (255, 255, 255), which
         *   is used if specularColor() is not explicitly
         *   called.
         *
         *   Note: specularColor is equivalent to the
         *   Processing function lightSpecular.
         *   @param values color as an array containing the
         *   red, green, and blue components
         *   @chainable
         */
        specularColor(values: number[]): p5;

        /**
         *   Sets the color of the specular highlight of a
         *   non-ambient light (i.e. all lights except
         *   ambientLight()). specularColor() affects only the
         *   lights which are created after it in the code.
         *
         *   This function is used in combination with
         *   specularMaterial(). If a geometry does not use
         *   specularMaterial(), this function will have no
         *   effect.
         *
         *   The default color is white (255, 255, 255), which
         *   is used if specularColor() is not explicitly
         *   called.
         *
         *   Note: specularColor is equivalent to the
         *   Processing function lightSpecular.
         *   @param color color as a p5.Color
         *   @chainable
         */
        specularColor(color: Color): p5;

        /**
         *   Creates a directional light with the given color
         *   and direction. Directional light comes from one
         *   direction. The direction is specified as numbers
         *   inclusively between -1 and 1. For example, setting
         *   the direction as (0, -1, 0) will cause the
         *   geometry to be lit from below (since the light
         *   will be facing directly upwards). Similarly,
         *   setting the direction as (1, 0, 0) will cause the
         *   geometry to be lit from the left (since the light
         *   will be facing directly rightwards).
         *
         *   Directional lights do not have a specific point of
         *   origin, and therefore cannot be positioned closer
         *   or farther away from a geometry.
         *
         *   A maximum of 5 directional lights can be active at
         *   once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param x x component of direction (inclusive range
         *   of -1 to 1)
         *   @param y y component of direction (inclusive range
         *   of -1 to 1)
         *   @param z z component of direction (inclusive range
         *   of -1 to 1)
         *   @chainable
         */
        directionalLight(v1: number, v2: number, v3: number, x: number, y: number, z: number): p5;

        /**
         *   Creates a directional light with the given color
         *   and direction. Directional light comes from one
         *   direction. The direction is specified as numbers
         *   inclusively between -1 and 1. For example, setting
         *   the direction as (0, -1, 0) will cause the
         *   geometry to be lit from below (since the light
         *   will be facing directly upwards). Similarly,
         *   setting the direction as (1, 0, 0) will cause the
         *   geometry to be lit from the left (since the light
         *   will be facing directly rightwards).
         *
         *   Directional lights do not have a specific point of
         *   origin, and therefore cannot be positioned closer
         *   or farther away from a geometry.
         *
         *   A maximum of 5 directional lights can be active at
         *   once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param direction direction of light as a p5.Vector
         *   @chainable
         */
        directionalLight(v1: number, v2: number, v3: number, direction: Vector): p5;

        /**
         *   Creates a directional light with the given color
         *   and direction. Directional light comes from one
         *   direction. The direction is specified as numbers
         *   inclusively between -1 and 1. For example, setting
         *   the direction as (0, -1, 0) will cause the
         *   geometry to be lit from below (since the light
         *   will be facing directly upwards). Similarly,
         *   setting the direction as (1, 0, 0) will cause the
         *   geometry to be lit from the left (since the light
         *   will be facing directly rightwards).
         *
         *   Directional lights do not have a specific point of
         *   origin, and therefore cannot be positioned closer
         *   or farther away from a geometry.
         *
         *   A maximum of 5 directional lights can be active at
         *   once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param x x component of direction (inclusive range
         *   of -1 to 1)
         *   @param y y component of direction (inclusive range
         *   of -1 to 1)
         *   @param z z component of direction (inclusive range
         *   of -1 to 1)
         *   @chainable
         */
        directionalLight(color: Color | number[] | string, x: number, y: number, z: number): p5;

        /**
         *   Creates a directional light with the given color
         *   and direction. Directional light comes from one
         *   direction. The direction is specified as numbers
         *   inclusively between -1 and 1. For example, setting
         *   the direction as (0, -1, 0) will cause the
         *   geometry to be lit from below (since the light
         *   will be facing directly upwards). Similarly,
         *   setting the direction as (1, 0, 0) will cause the
         *   geometry to be lit from the left (since the light
         *   will be facing directly rightwards).
         *
         *   Directional lights do not have a specific point of
         *   origin, and therefore cannot be positioned closer
         *   or farther away from a geometry.
         *
         *   A maximum of 5 directional lights can be active at
         *   once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param direction direction of light as a p5.Vector
         *   @chainable
         */
        directionalLight(color: Color | number[] | string, direction: Vector): p5;

        /**
         *   Creates a point light with the given color and
         *   position. A point light emits light from a single
         *   point in all directions. Because the light is
         *   emitted from a specific point (position), it has a
         *   different effect when it is positioned farther vs.
         *   nearer an object.
         *
         *   A maximum of 5 point lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param x x component of position
         *   @param y y component of position
         *   @param z z component of position
         *   @chainable
         */
        pointLight(v1: number, v2: number, v3: number, x: number, y: number, z: number): p5;

        /**
         *   Creates a point light with the given color and
         *   position. A point light emits light from a single
         *   point in all directions. Because the light is
         *   emitted from a specific point (position), it has a
         *   different effect when it is positioned farther vs.
         *   nearer an object.
         *
         *   A maximum of 5 point lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param position of light as a p5.Vector
         *   @chainable
         */
        pointLight(v1: number, v2: number, v3: number, position: Vector): p5;

        /**
         *   Creates a point light with the given color and
         *   position. A point light emits light from a single
         *   point in all directions. Because the light is
         *   emitted from a specific point (position), it has a
         *   different effect when it is positioned farther vs.
         *   nearer an object.
         *
         *   A maximum of 5 point lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param x x component of position
         *   @param y y component of position
         *   @param z z component of position
         *   @chainable
         */
        pointLight(color: Color | number[] | string, x: number, y: number, z: number): p5;

        /**
         *   Creates a point light with the given color and
         *   position. A point light emits light from a single
         *   point in all directions. Because the light is
         *   emitted from a specific point (position), it has a
         *   different effect when it is positioned farther vs.
         *   nearer an object.
         *
         *   A maximum of 5 point lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param position of light as a p5.Vector
         *   @chainable
         */
        pointLight(color: Color | number[] | string, position: Vector): p5;

        /**
         *   Places an ambient and directional light in the
         *   scene. The lights are set to ambientLight(128,
         *   128, 128) and directionalLight(128, 128, 128, 0,
         *   0, -1). Note: lights need to be called (whether
         *   directly or indirectly) within draw() to remain
         *   persistent in a looping program. Placing them in
         *   setup() will cause them to only have an effect the
         *   first time through the loop.
         *   @chainable
         */
        lights(): p5;

        /**
         *   Sets the falloff rate for pointLight() and
         *   spotLight(). lightFalloff() affects only the
         *   lights which are created after it in the code.
         *
         *   The constant, linear, an quadratic parameters are
         *   used to calculate falloff as follows:
         *
         *   d = distance from light position to vertex
         *   position
         *
         *   falloff = 1 / (CONSTANT + d * LINEAR + (d * d) *
         *   QUADRATIC)
         *   @param constant CONSTANT value for determining
         *   falloff
         *   @param linear LINEAR value for determining falloff
         *   @param quadratic QUADRATIC value for determining
         *   falloff
         *   @chainable
         */
        lightFalloff(constant: number, linear: number, quadratic: number): p5;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param x x component of position
         *   @param y y component of position
         *   @param z z component of position
         *   @param rx x component of light direction
         *   (inclusive range of -1 to 1)
         *   @param ry y component of light direction
         *   (inclusive range of -1 to 1)
         *   @param rz z component of light direction
         *   (inclusive range of -1 to 1)
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         *   @chainable
         */
        spotLight(
            v1: number,
            v2: number,
            v3: number,
            x: number,
            y: number,
            z: number,
            rx: number,
            ry: number,
            rz: number,
            angle?: number,
            concentration?: number
        ): p5;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param position position of light as a p5.Vector
         *   @param direction direction of light as a p5.Vector
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         */
        spotLight(
            color: Color | number[] | string,
            position: Vector,
            direction: Vector,
            angle?: number,
            concentration?: number
        ): void;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param position position of light as a p5.Vector
         *   @param direction direction of light as a p5.Vector
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         */
        spotLight(
            v1: number,
            v2: number,
            v3: number,
            position: Vector,
            direction: Vector,
            angle?: number,
            concentration?: number
        ): void;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param x x component of position
         *   @param y y component of position
         *   @param z z component of position
         *   @param direction direction of light as a p5.Vector
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         */
        spotLight(
            color: Color | number[] | string,
            x: number,
            y: number,
            z: number,
            direction: Vector,
            angle?: number,
            concentration?: number
        ): void;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param position position of light as a p5.Vector
         *   @param rx x component of light direction
         *   (inclusive range of -1 to 1)
         *   @param ry y component of light direction
         *   (inclusive range of -1 to 1)
         *   @param rz z component of light direction
         *   (inclusive range of -1 to 1)
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         */
        spotLight(
            color: Color | number[] | string,
            position: Vector,
            rx: number,
            ry: number,
            rz: number,
            angle?: number,
            concentration?: number
        ): void;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param x x component of position
         *   @param y y component of position
         *   @param z z component of position
         *   @param direction direction of light as a p5.Vector
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         */
        spotLight(
            v1: number,
            v2: number,
            v3: number,
            x: number,
            y: number,
            z: number,
            direction: Vector,
            angle?: number,
            concentration?: number
        ): void;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param position position of light as a p5.Vector
         *   @param rx x component of light direction
         *   (inclusive range of -1 to 1)
         *   @param ry y component of light direction
         *   (inclusive range of -1 to 1)
         *   @param rz z component of light direction
         *   (inclusive range of -1 to 1)
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         */
        spotLight(
            v1: number,
            v2: number,
            v3: number,
            position: Vector,
            rx: number,
            ry: number,
            rz: number,
            angle?: number,
            concentration?: number
        ): void;

        /**
         *   Creates a spot light with the given color,
         *   position, light direction, angle, and
         *   concentration. Like a pointLight(), a spotLight()
         *   emits light from a specific point (position). It
         *   has a different effect when it is positioned
         *   farther vs. nearer an object.
         *
         *   However, unlike a pointLight(), the light is
         *   emitted in one direction along a conical shape.
         *   The shape of the cone can be controlled using the
         *   angle and concentration parameters.
         *
         *   The angle parameter is used to determine the
         *   radius of the cone. And the concentration
         *   parameter is used to focus the light towards the
         *   center of the cone. Both parameters are optional,
         *   however if you want to specify concentration, you
         *   must also specify angle. The minimum concentration
         *   value is 1.
         *
         *   A maximum of 5 spot lights can be active at once.
         *
         *   Note: lights need to be called (whether directly
         *   or indirectly) within draw() to remain persistent
         *   in a looping program. Placing them in setup() will
         *   cause them to only have an effect the first time
         *   through the loop.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @param x x component of position
         *   @param y y component of position
         *   @param z z component of position
         *   @param rx x component of light direction
         *   (inclusive range of -1 to 1)
         *   @param ry y component of light direction
         *   (inclusive range of -1 to 1)
         *   @param rz z component of light direction
         *   (inclusive range of -1 to 1)
         *   @param [angle] angle of cone. Defaults to PI/3
         *   @param [concentration] concentration of cone.
         *   Defaults to 100
         */
        spotLight(
            color: Color | number[] | string,
            x: number,
            y: number,
            z: number,
            rx: number,
            ry: number,
            rz: number,
            angle?: number,
            concentration?: number
        ): void;

        /**
         *   Removes all lights present in a sketch. All
         *   subsequent geometry is rendered without lighting
         *   (until a new light is created with a call to one
         *   of the lighting functions (lights(),
         *   ambientLight(), directionalLight(), pointLight(),
         *   spotLight()).
         *   @chainable
         */
        noLights(): p5;
    }

// Inlined from: ./src/webgl/loading.d.ts

    interface p5InstanceExtensions {
        /**
         *   Load a 3d model from an OBJ or STL file.
         *   loadModel() should be placed inside of preload().
         *   This allows the model to load fully before the
         *   rest of your code is run.
         *
         *   One of the limitations of the OBJ and STL format
         *   is that it doesn't have a built-in sense of scale.
         *   This means that models exported from different
         *   programs might be very different sizes. If your
         *   model isn't displaying, try calling loadModel()
         *   with the normalized parameter set to true. This
         *   will resize the model to a scale appropriate for
         *   p5. You can also make additional changes to the
         *   final size of your model with the scale()
         *   function.
         *
         *   Also, the support for colored STL files is not
         *   present. STL files with color will be rendered
         *   without color properties.
         *   @param path Path of the model to be loaded
         *   @param normalize If true, scale the model to a
         *   standardized size when loading
         *   @param [successCallback] Function to be called
         *   once the model is loaded. Will be passed the 3D
         *   model object.
         *   @param [failureCallback] called with event error
         *   if the model fails to load.
         *   @param [fileType] The file extension of the model
         *   (.stl, .obj).
         *   @return the p5.Geometry object
         */
        loadModel(
            path: string,
            normalize: boolean,
            successCallback?: (p1: Geometry) => any,
            failureCallback?: (p1: Event) => any,
            fileType?: string
        ): Geometry;

        /**
         *   Load a 3d model from an OBJ or STL file.
         *   loadModel() should be placed inside of preload().
         *   This allows the model to load fully before the
         *   rest of your code is run.
         *
         *   One of the limitations of the OBJ and STL format
         *   is that it doesn't have a built-in sense of scale.
         *   This means that models exported from different
         *   programs might be very different sizes. If your
         *   model isn't displaying, try calling loadModel()
         *   with the normalized parameter set to true. This
         *   will resize the model to a scale appropriate for
         *   p5. You can also make additional changes to the
         *   final size of your model with the scale()
         *   function.
         *
         *   Also, the support for colored STL files is not
         *   present. STL files with color will be rendered
         *   without color properties.
         *   @param path Path of the model to be loaded
         *   @param [successCallback] Function to be called
         *   once the model is loaded. Will be passed the 3D
         *   model object.
         *   @param [failureCallback] called with event error
         *   if the model fails to load.
         *   @param [fileType] The file extension of the model
         *   (.stl, .obj).
         *   @return the p5.Geometry object
         */
        loadModel(
            path: string,
            successCallback?: (p1: Geometry) => any,
            failureCallback?: (p1: Event) => any,
            fileType?: string
        ): Geometry;

        /**
         *   Render a 3d model to the screen.
         *   @param model Loaded 3d model to be rendered
         */
        model(model: Geometry): void;
    }

// Inlined from: ./src/webgl/material.d.ts

    interface p5InstanceExtensions {
        /**
         *   Creates a new p5.Shader object from the provided
         *   vertex and fragment shader files. The shader files
         *   are loaded asynchronously in the background, so
         *   this method should be used in preload().
         *
         *   Note, shaders can only be used in WEBGL mode.
         *   @param vertFilename path to file containing vertex
         *   shader source code
         *   @param fragFilename path to file containing
         *   fragment shader source code
         *   @param [callback] callback to be executed after
         *   loadShader completes. On success, the p5.Shader
         *   object is passed as the first argument.
         *   @param [errorCallback] callback to be executed
         *   when an error occurs inside loadShader. On error,
         *   the error is passed as the first argument.
         *   @return a shader object created from the provided
         *   vertex and fragment shader files.
         */
        loadShader(
            vertFilename: string,
            fragFilename: string,
            callback?: (...args: any[]) => any,
            errorCallback?: (...args: any[]) => any
        ): Shader;

        /**
         *   Creates a new p5.Shader object from the provided
         *   vertex and fragment shader code. Note, shaders can
         *   only be used in WEBGL mode.
         *   @param vertSrc source code for the vertex shader
         *   @param fragSrc source code for the fragment shader
         *   @return a shader object created from the provided
         *   vertex and fragment shaders.
         */
        createShader(vertSrc: string, fragSrc: string): Shader;

        /**
         *   Sets the p5.Shader object to be used to render
         *   subsequent shapes. Custom shaders can be created
         *   using the createShader() and loadShader()
         *   functions.
         *
         *   Use resetShader() to restore the default shaders.
         *
         *   Note, shaders can only be used in WEBGL mode.
         *   @param s the p5.Shader object to use for rendering
         *   shapes.
         *   @chainable
         */
        shader(s: Shader): p5;

        /**
         *   Restores the default shaders. Code that runs after
         *   resetShader() will not be affected by the shader
         *   previously set by shader()
         *   @chainable
         */
        resetShader(): p5;

        /**
         *   Sets the texture that will be used to render
         *   subsequent shapes. A texture is like a "skin" that
         *   wraps around a 3D geometry. Currently supported
         *   textures are images, video, and offscreen renders.
         *
         *   To texture a geometry created with beginShape(),
         *   you will need to specify uv coordinates in
         *   vertex().
         *
         *   Note, texture() can only be used in WEBGL mode.
         *
         *   You can view more materials in this example.
         *   @param tex image to use as texture
         *   @chainable
         */
        texture(tex: Image | MediaElement | Graphics | Framebuffer): p5;

        /**
         *   Sets the coordinate space for texture mapping. The
         *   default mode is IMAGE which refers to the actual
         *   coordinates of the image. NORMAL refers to a
         *   normalized space of values ranging from 0 to 1.
         *   With IMAGE, if an image is 100×200 pixels, mapping
         *   the image onto the entire size of a quad would
         *   require the points (0,0) (100, 0) (100,200)
         *   (0,200). The same mapping in NORMAL is (0,0) (1,0)
         *   (1,1) (0,1).
         *   @param mode either IMAGE or NORMAL
         */
        textureMode(mode: TEXTURE_MODE): void;

        /**
         *   Sets the global texture wrapping mode. This
         *   controls how textures behave when their uv's go
         *   outside of the 0 to 1 range. There are three
         *   options: CLAMP, REPEAT, and MIRROR. CLAMP causes
         *   the pixels at the edge of the texture to extend to
         *   the bounds. REPEAT causes the texture to tile
         *   repeatedly until reaching the bounds. MIRROR works
         *   similarly to REPEAT but it flips the texture with
         *   every new tile.
         *
         *   REPEAT & MIRROR are only available if the texture
         *   is a power of two size (128, 256, 512, 1024,
         *   etc.).
         *
         *   This method will affect all textures in your
         *   sketch until a subsequent textureWrap() call is
         *   made.
         *
         *   If only one argument is provided, it will be
         *   applied to both the horizontal and vertical axes.
         *   @param wrapX either CLAMP, REPEAT, or MIRROR
         *   @param [wrapY] either CLAMP, REPEAT, or MIRROR
         */
        textureWrap(wrapX: WRAP_X, wrapY?: WRAP_Y): void;

        /**
         *   Sets the current material as a normal material. A
         *   normal material is not affected by light. It is
         *   often used as a placeholder material when
         *   debugging.
         *
         *   Surfaces facing the X-axis become red, those
         *   facing the Y-axis become green, and those facing
         *   the Z-axis become blue.
         *
         *   You can view more materials in this example.
         *   @chainable
         */
        normalMaterial(): p5;

        /**
         *   Sets the ambient color of the material. The
         *   ambientMaterial() color represents the components
         *   of the ambientLight() color that the object
         *   reflects.
         *
         *   Consider an ambientMaterial() with the color
         *   yellow (255, 255, 0). If the ambientLight() emits
         *   the color white (255, 255, 255), then the object
         *   will appear yellow as it will reflect the red and
         *   green components of the light. If the
         *   ambientLight() emits the color red (255, 0, 0),
         *   then the object will appear red as it will reflect
         *   the red component of the light. If the
         *   ambientLight() emits the color blue (0, 0, 255),
         *   then the object will appear black, as there is no
         *   component of the light that it can reflect.
         *
         *   You can view more materials in this example.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @chainable
         */
        ambientMaterial(v1: number, v2: number, v3: number): p5;

        /**
         *   Sets the ambient color of the material. The
         *   ambientMaterial() color represents the components
         *   of the ambientLight() color that the object
         *   reflects.
         *
         *   Consider an ambientMaterial() with the color
         *   yellow (255, 255, 0). If the ambientLight() emits
         *   the color white (255, 255, 255), then the object
         *   will appear yellow as it will reflect the red and
         *   green components of the light. If the
         *   ambientLight() emits the color red (255, 0, 0),
         *   then the object will appear red as it will reflect
         *   the red component of the light. If the
         *   ambientLight() emits the color blue (0, 0, 255),
         *   then the object will appear black, as there is no
         *   component of the light that it can reflect.
         *
         *   You can view more materials in this example.
         *   @param gray number specifying value between white
         *   and black
         *   @chainable
         */
        ambientMaterial(gray: number): p5;

        /**
         *   Sets the ambient color of the material. The
         *   ambientMaterial() color represents the components
         *   of the ambientLight() color that the object
         *   reflects.
         *
         *   Consider an ambientMaterial() with the color
         *   yellow (255, 255, 0). If the ambientLight() emits
         *   the color white (255, 255, 255), then the object
         *   will appear yellow as it will reflect the red and
         *   green components of the light. If the
         *   ambientLight() emits the color red (255, 0, 0),
         *   then the object will appear red as it will reflect
         *   the red component of the light. If the
         *   ambientLight() emits the color blue (0, 0, 255),
         *   then the object will appear black, as there is no
         *   component of the light that it can reflect.
         *
         *   You can view more materials in this example.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @chainable
         */
        ambientMaterial(color: Color | number[] | string): p5;

        /**
         *   Sets the emissive color of the material. An
         *   emissive material will display the emissive color
         *   at full strength regardless of lighting. This can
         *   give the appearance that the object is glowing.
         *
         *   Note, "emissive" is a misnomer in the sense that
         *   the material does not actually emit light that
         *   will affect surrounding objects.
         *
         *   You can view more materials in this example.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param [alpha] alpha value relative to current
         *   color range (default is 0-255)
         *   @chainable
         */
        emissiveMaterial(v1: number, v2: number, v3: number, alpha?: number): p5;

        /**
         *   Sets the emissive color of the material. An
         *   emissive material will display the emissive color
         *   at full strength regardless of lighting. This can
         *   give the appearance that the object is glowing.
         *
         *   Note, "emissive" is a misnomer in the sense that
         *   the material does not actually emit light that
         *   will affect surrounding objects.
         *
         *   You can view more materials in this example.
         *   @param gray number specifying value between white
         *   and black
         *   @chainable
         */
        emissiveMaterial(gray: number): p5;

        /**
         *   Sets the emissive color of the material. An
         *   emissive material will display the emissive color
         *   at full strength regardless of lighting. This can
         *   give the appearance that the object is glowing.
         *
         *   Note, "emissive" is a misnomer in the sense that
         *   the material does not actually emit light that
         *   will affect surrounding objects.
         *
         *   You can view more materials in this example.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @chainable
         */
        emissiveMaterial(color: Color | number[] | string): p5;

        /**
         *   Sets the specular color of the material. A
         *   specular material is reflective (shiny). The
         *   shininess can be controlled by the shininess()
         *   function.
         *
         *   Like ambientMaterial(), the specularMaterial()
         *   color is the color the object will reflect under
         *   ambientLight(). However unlike ambientMaterial(),
         *   for all other types of lights (directionalLight(),
         *   pointLight(), spotLight()), a specular material
         *   will reflect the color of the light source. This
         *   is what gives it its "shiny" appearance.
         *
         *   You can view more materials in this example.
         *   @param gray number specifying value between white
         *   and black.
         *   @param [alpha] alpha value relative to current
         *   color range (default is 0-255)
         *   @chainable
         */
        specularMaterial(gray: number, alpha?: number): p5;

        /**
         *   Sets the specular color of the material. A
         *   specular material is reflective (shiny). The
         *   shininess can be controlled by the shininess()
         *   function.
         *
         *   Like ambientMaterial(), the specularMaterial()
         *   color is the color the object will reflect under
         *   ambientLight(). However unlike ambientMaterial(),
         *   for all other types of lights (directionalLight(),
         *   pointLight(), spotLight()), a specular material
         *   will reflect the color of the light source. This
         *   is what gives it its "shiny" appearance.
         *
         *   You can view more materials in this example.
         *   @param v1 red or hue value relative to the current
         *   color range
         *   @param v2 green or saturation value relative to
         *   the current color range
         *   @param v3 blue or brightness value relative to the
         *   current color range
         *   @param [alpha] alpha value relative to current
         *   color range (default is 0-255)
         *   @chainable
         */
        specularMaterial(v1: number, v2: number, v3: number, alpha?: number): p5;

        /**
         *   Sets the specular color of the material. A
         *   specular material is reflective (shiny). The
         *   shininess can be controlled by the shininess()
         *   function.
         *
         *   Like ambientMaterial(), the specularMaterial()
         *   color is the color the object will reflect under
         *   ambientLight(). However unlike ambientMaterial(),
         *   for all other types of lights (directionalLight(),
         *   pointLight(), spotLight()), a specular material
         *   will reflect the color of the light source. This
         *   is what gives it its "shiny" appearance.
         *
         *   You can view more materials in this example.
         *   @param color color as a p5.Color, as an array, or
         *   as a CSS string
         *   @chainable
         */
        specularMaterial(color: Color | number[] | string): p5;

        /**
         *   Sets the amount of gloss ("shininess") of a
         *   specularMaterial(). The default and minimum value
         *   is 1.
         *   @param shine degree of shininess
         *   @chainable
         */
        shininess(shine: number): p5;
    }

// Inlined from: ./src/webgl/p5.Camera.d.ts

    class Camera {
        /**
         *   Sets a perspective projection. Accepts the same
         *   parameters as the global perspective(). More
         *   information on this function can be found there.
         */
        perspective(): void;

        /**
         *   Sets an orthographic projection. Accepts the same
         *   parameters as the global ortho(). More information
         *   on this function can be found there.
         */
        ortho(): void;

        /**
         *   Sets the camera's frustum. Accepts the same
         *   parameters as the global frustum(). More
         *   information on this function can be found there.
         */
        frustum(): void;

        /**
         *   Panning rotates the camera view to the left and
         *   right.
         *   @param angle amount to rotate camera in current
         *   angleMode units. Greater than 0 values rotate
         *   counterclockwise (to the left).
         */
        pan(angle: number): void;

        /**
         *   Tilting rotates the camera view up and down.
         *   @param angle amount to rotate camera in current
         *   angleMode units. Greater than 0 values rotate
         *   counterclockwise (to the left).
         */
        tilt(angle: number): void;

        /**
         *   Reorients the camera to look at a position in
         *   world space.
         *   @param x x position of a point in world space
         *   @param y y position of a point in world space
         *   @param z z position of a point in world space
         */
        lookAt(x: number, y: number, z: number): void;

        /**
         *   Sets the camera's position and orientation.
         *   Accepts the same parameters as the global
         *   camera(). More information on this function can be
         *   found there.
         */
        camera(): void;

        /**
         *   Move camera along its local axes while maintaining
         *   current camera orientation.
         *   @param x amount to move along camera's left-right
         *   axis
         *   @param y amount to move along camera's up-down
         *   axis
         *   @param z amount to move along camera's
         *   forward-backward axis
         */
        move(x: number, y: number, z: number): void;

        /**
         *   Set camera position in world-space while
         *   maintaining current camera orientation.
         *   @param x x position of a point in world space
         *   @param y y position of a point in world space
         *   @param z z position of a point in world space
         */
        setPosition(x: number, y: number, z: number): void;

        /**
         *   Copies information about the argument camera's
         *   view and projection to the target camera. If the
         *   target camera is active, it will be reflected on
         *   the screen.
         *   @param cam source camera
         */
        set(cam: Camera): void;

        /**
         *   For the cameras cam0 and cam1 with the given
         *   arguments, their view are combined with the
         *   parameter amt that represents the quantity, and
         *   the obtained view is applied. For example, if cam0
         *   is looking straight ahead and cam1 is looking
         *   straight to the right and amt is 0.5, the applied
         *   camera will look to the halfway between front and
         *   right. If the applied camera is active, the
         *   applied result will be reflected on the screen.
         *   When applying this function, all cameras involved
         *   must have exactly the same projection settings.
         *   For example, if one is perspective, ortho,
         *   frustum, the other two must also be perspective,
         *   ortho, frustum respectively. However, if all
         *   cameras have ortho settings, interpolation is
         *   possible if the ratios of left, right, top and
         *   bottom are equal to each other. For example, when
         *   it is changed by orbitControl().
         *   @param cam0 first p5.Camera
         *   @param cam1 second p5.Camera
         *   @param amt amount to use for interpolation during
         *   slerp
         */
        slerp(cam0: Camera, cam1: Camera, amt: number): void;

        /**
         *   camera position value on x axis
         */
        eyeX: number;

        /**
         *   camera position value on y axis
         */
        eyeY: number;

        /**
         *   camera position value on z axis
         */
        eyeZ: number;

        /**
         *   x coordinate representing center of the sketch
         */
        centerX: number;

        /**
         *   y coordinate representing center of the sketch
         */
        centerY: number;

        /**
         *   z coordinate representing center of the sketch
         */
        centerZ: number;

        /**
         *   x component of direction 'up' from camera
         */
        upX: number;

        /**
         *   y component of direction 'up' from camera
         */
        upY: number;

        /**
         *   z component of direction 'up' from camera
         */
        upZ: number;
    }
    interface p5InstanceExtensions {
        /**
         *   Sets the position of the current camera in a 3D
         *   sketch. Parameters for this function define the
         *   camera's position, the center of the sketch (where
         *   the camera is pointing), and an up direction (the
         *   orientation of the camera). This function
         *   simulates the movements of the camera, allowing
         *   objects to be viewed from various angles.
         *   Remember, it does not move the objects themselves
         *   but the camera instead. For example when the
         *   centerX value is positive, and the camera is
         *   rotating to the right side of the sketch, the
         *   object will seem like it's moving to the left.
         *
         *   See this example to view the position of your
         *   camera.
         *
         *   If no parameters are given, the following default
         *   is used: camera(0, 0, (height/2) / tan(PI/6), 0,
         *   0, 0, 0, 1, 0)
         *   @param [x] camera position value on x axis
         *   @param [y] camera position value on y axis
         *   @param [z] camera position value on z axis
         *   @param [centerX] x coordinate representing center
         *   of the sketch
         *   @param [centerY] y coordinate representing center
         *   of the sketch
         *   @param [centerZ] z coordinate representing center
         *   of the sketch
         *   @param [upX] x component of direction 'up' from
         *   camera
         *   @param [upY] y component of direction 'up' from
         *   camera
         *   @param [upZ] z component of direction 'up' from
         *   camera
         *   @chainable
         */
        camera(
            x?: number,
            y?: number,
            z?: number,
            centerX?: number,
            centerY?: number,
            centerZ?: number,
            upX?: number,
            upY?: number,
            upZ?: number
        ): p5;

        /**
         *   Sets a perspective projection for the current
         *   camera in a 3D sketch. This projection represents
         *   depth through foreshortening: objects that are
         *   close to the camera appear their actual size while
         *   those that are further away from the camera appear
         *   smaller. The parameters to this function define
         *   the viewing frustum (the truncated pyramid within
         *   which objects are seen by the camera) through
         *   vertical field of view, aspect ratio (usually
         *   width/height), and near and far clipping planes.
         *
         *   If no parameters are given, the following default
         *   is used: perspective(PI/3, width/height, eyeZ/10,
         *   eyeZ*10), where eyeZ is equal to ((height/2) /
         *   tan(PI/6)).
         *   @param [fovy] camera frustum vertical field of
         *   view, from bottom to top of view, in angleMode
         *   units
         *   @param [aspect] camera frustum aspect ratio
         *   @param [near] frustum near plane length
         *   @param [far] frustum far plane length
         *   @chainable
         */
        perspective(fovy?: number, aspect?: number, near?: number, far?: number): p5;

        /**
         *   Sets an orthographic projection for the current
         *   camera in a 3D sketch and defines a box-shaped
         *   viewing frustum within which objects are seen. In
         *   this projection, all objects with the same
         *   dimension appear the same size, regardless of
         *   whether they are near or far from the camera. The
         *   parameters to this function specify the viewing
         *   frustum where left and right are the minimum and
         *   maximum x values, top and bottom are the minimum
         *   and maximum y values, and near and far are the
         *   minimum and maximum z values.
         *
         *   If no parameters are given, the following default
         *   is used: ortho(-width/2, width/2, -height/2,
         *   height/2).
         *   @param [left] camera frustum left plane
         *   @param [right] camera frustum right plane
         *   @param [bottom] camera frustum bottom plane
         *   @param [top] camera frustum top plane
         *   @param [near] camera frustum near plane
         *   @param [far] camera frustum far plane
         *   @chainable
         */
        ortho(left?: number, right?: number, bottom?: number, top?: number, near?: number, far?: number): p5;

        /**
         *   Sets the frustum of the current camera as defined
         *   by the parameters. A frustum is a geometric form:
         *   a pyramid with its top cut off. With the viewer's
         *   eye at the imaginary top of the pyramid, the six
         *   planes of the frustum act as clipping planes when
         *   rendering a 3D view. Thus, any form inside the
         *   clipping planes is visible; anything outside those
         *   planes is not visible.
         *
         *   Setting the frustum changes the perspective of the
         *   scene being rendered. This can be achieved more
         *   simply in many cases by using perspective().
         *
         *   If no parameters are given, the following default
         *   is used: frustum(-width/20, width/20, height/20,
         *   -height/20, eyeZ/10, eyeZ*10), where eyeZ is equal
         *   to ((height/2) / tan(PI/6)).
         *   @param [left] camera frustum left plane
         *   @param [right] camera frustum right plane
         *   @param [bottom] camera frustum bottom plane
         *   @param [top] camera frustum top plane
         *   @param [near] camera frustum near plane
         *   @param [far] camera frustum far plane
         *   @chainable
         */
        frustum(left?: number, right?: number, bottom?: number, top?: number, near?: number, far?: number): p5;

        /**
         *   Creates a new p5.Camera object and sets it as the
         *   current (active) camera. The new camera is
         *   initialized with a default position (see camera())
         *   and a default perspective projection (see
         *   perspective()). Its properties can be controlled
         *   with the p5.Camera methods.
         *
         *   Note: Every 3D sketch starts with a default camera
         *   initialized. This camera can be controlled with
         *   the global methods camera(), perspective(),
         *   ortho(), and frustum() if it is the only camera in
         *   the scene.
         *   @return The newly created camera object.
         */
        createCamera(): Camera;

        /**
         *   Sets the current (active) camera of a 3D sketch.
         *   Allows for switching between multiple cameras.
         *   @param cam p5.Camera object
         */
        setCamera(cam: Camera): void;
    }

// Inlined from: ./src/webgl/p5.RendererGL.Immediate.d.ts

    interface p5InstanceExtensions {
        /**
         *   Sets the normal to use for subsequent vertices.
         *   @chainable
         */
        vertexNormal(x: number, y: number, z: number, v: Vector): p5;
    }

// Inlined from: ./src/webgl/p5.RendererGL.d.ts

    interface p5InstanceExtensions {
        /**
         *   Set attributes for the WebGL Drawing context. This
         *   is a way of adjusting how the WebGL renderer works
         *   to fine-tune the display and performance. Note
         *   that this will reinitialize the drawing context if
         *   called after the WebGL canvas is made.
         *
         *   If an object is passed as the parameter, all
         *   attributes not declared in the object will be set
         *   to defaults.
         *
         *   The available attributes are:
         *
         *   alpha - indicates if the canvas contains an alpha
         *   buffer default is true
         *
         *   depth - indicates whether the drawing buffer has a
         *   depth buffer of at least 16 bits - default is true
         *
         *   stencil - indicates whether the drawing buffer has
         *   a stencil buffer of at least 8 bits
         *
         *   antialias - indicates whether or not to perform
         *   anti-aliasing default is false (true in Safari)
         *
         *   premultipliedAlpha - indicates that the page
         *   compositor will assume the drawing buffer contains
         *   colors with pre-multiplied alpha default is true
         *
         *   preserveDrawingBuffer - if true the buffers will
         *   not be cleared and and will preserve their values
         *   until cleared or overwritten by author (note that
         *   p5 clears automatically on draw loop) default is
         *   true
         *
         *   perPixelLighting - if true, per-pixel lighting
         *   will be used in the lighting shader otherwise
         *   per-vertex lighting is used. default is true.
         *
         *   version - either 1 or 2, to specify which WebGL
         *   version to ask for. By default, WebGL 2 will be
         *   requested. If WebGL2 is not available, it will
         *   fall back to WebGL 1. You can check what version
         *   is used with by looking at the global webglVersion
         *   property.
         *   @param key Name of attribute
         *   @param value New value of named attribute
         */
        setAttributes(key: string, value: boolean): void;

        /**
         *   Set attributes for the WebGL Drawing context. This
         *   is a way of adjusting how the WebGL renderer works
         *   to fine-tune the display and performance. Note
         *   that this will reinitialize the drawing context if
         *   called after the WebGL canvas is made.
         *
         *   If an object is passed as the parameter, all
         *   attributes not declared in the object will be set
         *   to defaults.
         *
         *   The available attributes are:
         *
         *   alpha - indicates if the canvas contains an alpha
         *   buffer default is true
         *
         *   depth - indicates whether the drawing buffer has a
         *   depth buffer of at least 16 bits - default is true
         *
         *   stencil - indicates whether the drawing buffer has
         *   a stencil buffer of at least 8 bits
         *
         *   antialias - indicates whether or not to perform
         *   anti-aliasing default is false (true in Safari)
         *
         *   premultipliedAlpha - indicates that the page
         *   compositor will assume the drawing buffer contains
         *   colors with pre-multiplied alpha default is true
         *
         *   preserveDrawingBuffer - if true the buffers will
         *   not be cleared and and will preserve their values
         *   until cleared or overwritten by author (note that
         *   p5 clears automatically on draw loop) default is
         *   true
         *
         *   perPixelLighting - if true, per-pixel lighting
         *   will be used in the lighting shader otherwise
         *   per-vertex lighting is used. default is true.
         *
         *   version - either 1 or 2, to specify which WebGL
         *   version to ask for. By default, WebGL 2 will be
         *   requested. If WebGL2 is not available, it will
         *   fall back to WebGL 1. You can check what version
         *   is used with by looking at the global webglVersion
         *   property.
         *   @param obj object with key-value pairs
         */
        setAttributes(obj: object): void;
    }

// Inlined from: ./src/color/p5.Color.d.ts

    class Color {
        // TODO: Fix p5.Color() errors in src/color/p5.Color.js, line 318:
        //
        //    required param "vals" follows an optional param
        //
        // constructor(pInst?: p5, vals: number[]|string);

        /**
         *   Returns the color formatted as a string. Doing so
         *   can be useful for debugging, or for using p5.js
         *   with other libraries.
         *   @param [format] how the color string will be
         *   formatted. Leaving this empty formats the string
         *   as rgba(r, g, b, a). '#rgb' '#rgba' '#rrggbb' and
         *   '#rrggbbaa' format as hexadecimal color codes.
         *   'rgb' 'hsb' and 'hsl' return the color formatted
         *   in the specified color mode. 'rgba' 'hsba' and
         *   'hsla' are the same as above but with alpha
         *   channels. 'rgb%' 'hsb%' 'hsl%' 'rgba%' 'hsba%' and
         *   'hsla%' format as percentages.
         *   @return the formatted string.
         */
        toString(format?: string): string;

        /**
         *   Sets the red component of a color. The range
         *   depends on the colorMode(). In the default RGB
         *   mode it's between 0 and 255.
         *   @param red the new red value.
         */
        setRed(red: number): void;

        /**
         *   Sets the green component of a color. The range
         *   depends on the colorMode(). In the default RGB
         *   mode it's between 0 and 255.
         *   @param green the new green value.
         */
        setGreen(green: number): void;

        /**
         *   Sets the blue component of a color. The range
         *   depends on the colorMode(). In the default RGB
         *   mode it's between 0 and 255.
         *   @param blue the new blue value.
         */
        setBlue(blue: number): void;

        /**
         *   Sets the alpha (transparency) value of a color.
         *   The range depends on the colorMode(). In the
         *   default RGB mode it's between 0 and 255.
         *   @param alpha the new alpha value.
         */
        setAlpha(alpha: number): void;
    }

// Inlined from: ./src/core/p5.Element.d.ts

    class Element {
        /**
         *   Base class for all elements added to a sketch,
         *   including canvas, graphics buffers, and other HTML
         *   elements. It is not called directly, but
         *   p5.Element objects are created by calling
         *   createCanvas(), createGraphics(), createDiv(),
         *   createImg(), createInput(), etc.
         *
         *   @param elt DOM node that is wrapped
         *   @param [pInst] pointer to p5 instance
         */
        constructor(elt: HTMLElement, pInst?: p5);

        /**
         *   Attaches the element to the parent specified. A
         *   way of setting the container for the element.
         *   Accepts either a string ID, DOM node, or
         *   p5.Element. If no arguments are given, parent node
         *   is returned. For more ways to position the canvas,
         *   see the  positioning the canvas wiki page.
         *   @param parent the ID, DOM node, or p5.Element of
         *   desired parent element
         *   @chainable
         */
        parent(parent: string | Element | object): Element;

        /**
         *   Attaches the element to the parent specified. A
         *   way of setting the container for the element.
         *   Accepts either a string ID, DOM node, or
         *   p5.Element. If no arguments are given, parent node
         *   is returned. For more ways to position the canvas,
         *   see the  positioning the canvas wiki page.
         */
        parent(): Element;

        /**
         *   Sets the ID of the element. If no ID argument is
         *   passed in, it instead returns the current ID of
         *   the element. Note that only one element can have a
         *   particular id in a page. The class() method can be
         *   used to identify multiple elements with the same
         *   class name.
         *   @param id ID of the element
         *   @chainable
         */
        id(id: string): Element;

        /**
         *   Sets the ID of the element. If no ID argument is
         *   passed in, it instead returns the current ID of
         *   the element. Note that only one element can have a
         *   particular id in a page. The class() method can be
         *   used to identify multiple elements with the same
         *   class name.
         *   @return the id of the element
         */
        id(): string;

        /**
         *   Adds given class to the element. If no class
         *   argument is passed in, it instead returns a string
         *   containing the current class(es) of the element.
         *   @param class class to add
         *   @chainable
         */
        class(theClass: string): Element;

        /**
         *   Adds given class to the element. If no class
         *   argument is passed in, it instead returns a string
         *   containing the current class(es) of the element.
         *   @return the class of the element
         */
        class(): string;

        /**
         *   The mousePressed() method is called once after
         *   every time a mouse button is pressed over the
         *   element. Some mobile browsers may also trigger
         *   this event on a touch screen, if the user performs
         *   a quick tap. This can be used to attach
         *   element-specific event listeners.
         *   @param fxn function to be fired when mouse is
         *   pressed over the element. if false is passed
         *   instead, the previously firing function will no
         *   longer fire.
         *   @chainable
         */
        mousePressed(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The doubleClicked() method is called once after
         *   every time a mouse button is pressed twice over
         *   the element. This can be used to attach element
         *   and action-specific event listeners.
         *   @param fxn function to be fired when mouse is
         *   double clicked over the element. if false is
         *   passed instead, the previously firing function
         *   will no longer fire.
         *   @chainable
         */
        doubleClicked(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The mouseWheel() method is called once after every
         *   time a mouse wheel is scrolled over the element.
         *   This can be used to attach element-specific event
         *   listeners. The method accepts a callback function
         *   as argument which will be executed when the wheel
         *   event is triggered on the element, the callback
         *   function is passed one argument event. The
         *   event.deltaY property returns negative values if
         *   the mouse wheel is rotated up or away from the
         *   user and positive in the other direction. The
         *   event.deltaX does the same as event.deltaY except
         *   it reads the horizontal wheel scroll of the mouse
         *   wheel.
         *
         *   On macOS with "natural" scrolling enabled, the
         *   event.deltaY values are reversed.
         *   @param fxn function to be fired when mouse is
         *   scrolled over the element. if false is passed
         *   instead, the previously firing function will no
         *   longer fire.
         *   @chainable
         */
        mouseWheel(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The mouseReleased() method is called once after
         *   every time a mouse button is released over the
         *   element. Some mobile browsers may also trigger
         *   this event on a touch screen, if the user performs
         *   a quick tap. This can be used to attach
         *   element-specific event listeners.
         *   @param fxn function to be fired when mouse is
         *   released over the element. if false is passed
         *   instead, the previously firing function will no
         *   longer fire.
         *   @chainable
         */
        mouseReleased(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The mouseClicked() method is called once after a
         *   mouse button is pressed and released over the
         *   element. Some mobile browsers may also trigger
         *   this event on a touch screen, if the user performs
         *   a quick tap. This can be used to attach
         *   element-specific event listeners.
         *   @param fxn function to be fired when mouse is
         *   clicked over the element. if false is passed
         *   instead, the previously firing function will no
         *   longer fire.
         *   @chainable
         */
        mouseClicked(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The mouseMoved() method is called once every time
         *   a mouse moves over the element. This can be used
         *   to attach an element-specific event listener.
         *   @param fxn function to be fired when a mouse moves
         *   over the element. if false is passed instead, the
         *   previously firing function will no longer fire.
         *   @chainable
         */
        mouseMoved(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The mouseOver() method is called once after every
         *   time a mouse moves onto the element. This can be
         *   used to attach an element-specific event listener.
         *   @param fxn function to be fired when a mouse moves
         *   onto the element. if false is passed instead, the
         *   previously firing function will no longer fire.
         *   @chainable
         */
        mouseOver(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The mouseOut() method is called once after every
         *   time a mouse moves off the element. This can be
         *   used to attach an element-specific event listener.
         *   @param fxn function to be fired when a mouse moves
         *   off of an element. if false is passed instead, the
         *   previously firing function will no longer fire.
         *   @chainable
         */
        mouseOut(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The touchStarted() method is called once after
         *   every time a touch is registered. This can be used
         *   to attach element-specific event listeners.
         *   @param fxn function to be fired when a touch
         *   starts over the element. if false is passed
         *   instead, the previously firing function will no
         *   longer fire.
         *   @chainable
         */
        touchStarted(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The touchMoved() method is called once after every
         *   time a touch move is registered. This can be used
         *   to attach element-specific event listeners.
         *   @param fxn function to be fired when a touch moves
         *   over the element. if false is passed instead, the
         *   previously firing function will no longer fire.
         *   @chainable
         */
        touchMoved(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The touchEnded() method is called once after every
         *   time a touch is registered. This can be used to
         *   attach element-specific event listeners.
         *   @param fxn function to be fired when a touch ends
         *   over the element. if false is passed instead, the
         *   previously firing function will no longer fire.
         *   @chainable
         */
        touchEnded(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The dragOver() method is called once after every
         *   time a file is dragged over the element. This can
         *   be used to attach an element-specific event
         *   listener.
         *   @param fxn function to be fired when a file is
         *   dragged over the element. if false is passed
         *   instead, the previously firing function will no
         *   longer fire.
         *   @chainable
         */
        dragOver(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   The dragLeave() method is called once after every
         *   time a dragged file leaves the element area. This
         *   can be used to attach an element-specific event
         *   listener.
         *   @param fxn function to be fired when a file is
         *   dragged off the element. if false is passed
         *   instead, the previously firing function will no
         *   longer fire.
         *   @chainable
         */
        dragLeave(fxn: ((...args: any[]) => any) | boolean): Element;

        /**
         *   Underlying HTML element. All normal HTML methods
         *   can be called on this.
         */
        elt: any;
        width: any;
        height: any;
    }

// Inlined from: ./src/core/p5.Graphics.d.ts

    // Work-around for p5.Graphics inheriting from both p5 and p5.Element
    class __Graphics__ extends Element {
        /**
         *   Thin wrapper around a renderer, to be used for
         *   creating a graphics buffer object. Use this class
         *   if you need to draw into an off-screen graphics
         *   buffer. The two parameters define the width and
         *   height in pixels. The fields and methods for this
         *   class are extensive, but mirror the normal drawing
         *   API for p5.
         *
         *   @param w width
         *   @param h height
         *   @param renderer the renderer to use, either P2D or
         *   WEBGL
         *   @param [pInst] pointer to p5 instance
         *   @param [canvas] existing html canvas element
         */
        constructor(w: number, h: number, renderer: GRAPHICS_RENDERER, pInst?: p5, canvas?: object);

        /**
         *   Resets certain values such as those modified by
         *   functions in the Transform category and in the
         *   Lights category that are not automatically reset
         *   with graphics buffer objects. Calling this in
         *   draw() will copy the behavior of the standard
         *   canvas.
         */
        reset(): void;

        /**
         *   Removes a Graphics object from the page and frees
         *   any resources associated with it.
         */
        remove(): void;

        /**
         *   Creates and returns a new p5.Framebuffer inside a
         *   p5.Graphics WebGL context. This takes the same
         *   parameters as the global createFramebuffer
         *   function.
         */
        createFramebuffer(): void;
    }
    // Work-around for p5.Graphics inheriting from both p5 and p5.Element
    type Graphics = __Graphics__ & p5;

// Inlined from: ./src/image/p5.Image.d.ts

    class Image {
        /**
         *   Creates a new p5.Image. A p5.Image is a canvas
         *   backed representation of an image. p5 can display
         *   .gif, .jpg and .png images. Images may be
         *   displayed in 2D and 3D space. Before an image is
         *   used, it must be loaded with the loadImage()
         *   function. The p5.Image class contains fields for
         *   the width and height of the image, as well as an
         *   array called pixels[] that contains the values for
         *   every pixel in the image.
         *
         *   The methods described below allow easy access to
         *   the image's pixels and alpha channel and simplify
         *   the process of compositing.
         *
         *   Before using the pixels[] array, be sure to use
         *   the loadPixels() method on the image to make sure
         *   that the pixel data is properly loaded.
         *
         */
        constructor(width: number, height: number);

        /**
         *   Loads the pixels data for this image into the
         *   [pixels] attribute.
         */
        loadPixels(): void;

        /**
         *   Updates the backing canvas for this image with the
         *   contents of the [pixels] array. If this image is
         *   an animated GIF then the pixels will be updated in
         *   the frame that is currently displayed.
         *   @param x x-offset of the target update area for
         *   the underlying canvas
         *   @param y y-offset of the target update area for
         *   the underlying canvas
         *   @param w width of the target update area for the
         *   underlying canvas
         *   @param h height of the target update area for the
         *   underlying canvas
         */
        updatePixels(x: number, y: number, w: number, h: number): void;

        /**
         *   Updates the backing canvas for this image with the
         *   contents of the [pixels] array. If this image is
         *   an animated GIF then the pixels will be updated in
         *   the frame that is currently displayed.
         */
        updatePixels(): void;

        /**
         *   Get a region of pixels from an image. If no params
         *   are passed, the whole image is returned. If x and
         *   y are the only params passed a single pixel is
         *   extracted. If all params are passed a rectangle
         *   region is extracted and a p5.Image is returned.
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @param w width
         *   @param h height
         *   @return the rectangle p5.Image
         */
        get(x: number, y: number, w: number, h: number): Image;

        /**
         *   Get a region of pixels from an image. If no params
         *   are passed, the whole image is returned. If x and
         *   y are the only params passed a single pixel is
         *   extracted. If all params are passed a rectangle
         *   region is extracted and a p5.Image is returned.
         *   @return the whole p5.Image
         */
        get(): Image;

        /**
         *   Get a region of pixels from an image. If no params
         *   are passed, the whole image is returned. If x and
         *   y are the only params passed a single pixel is
         *   extracted. If all params are passed a rectangle
         *   region is extracted and a p5.Image is returned.
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @return color of pixel at x,y in array format [R,
         *   G, B, A]
         */
        get(x: number, y: number): number[];

        /**
         *   Set the color of a single pixel or write an image
         *   into this p5.Image. Note that for a large number
         *   of pixels this will be slower than directly
         *   manipulating the pixels array and then calling
         *   updatePixels().
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @param a grayscale value | pixel array | a
         *   p5.Color | image to copy
         */
        set(x: number, y: number, a: number | number[] | object): void;

        /**
         *   Resize the image to a new width and height. To
         *   make the image scale proportionally, use 0 as the
         *   value for the wide or high parameter. For
         *   instance, to make the width of an image 150
         *   pixels, and change the height using the same
         *   proportion, use resize(150, 0).
         *   @param width the resized image width
         *   @param height the resized image height
         */
        resize(width: number, height: number): void;

        /**
         *   Copies a region of pixels from one image to
         *   another. If no srcImage is specified this is used
         *   as the source. If the source and destination
         *   regions aren't the same size, it will
         *   automatically resize source pixels to fit the
         *   specified target region.
         *   @param srcImage source image
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         */
        copy(
            srcImage: Image | Element,
            sx: number,
            sy: number,
            sw: number,
            sh: number,
            dx: number,
            dy: number,
            dw: number,
            dh: number
        ): void;

        /**
         *   Copies a region of pixels from one image to
         *   another. If no srcImage is specified this is used
         *   as the source. If the source and destination
         *   regions aren't the same size, it will
         *   automatically resize source pixels to fit the
         *   specified target region.
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         */
        copy(sx: number, sy: number, sw: number, sh: number, dx: number, dy: number, dw: number, dh: number): void;

        /**
         *   Masks part of an image from displaying by loading
         *   another image and using its alpha channel as an
         *   alpha channel for this image. Masks are
         *   cumulative, once applied to an image object, they
         *   cannot be removed.
         *   @param srcImage source image
         */
        mask(srcImage: Image): void;

        /**
         *   Applies an image filter to a p5.Image THRESHOLD
         *   Converts the image to black and white pixels
         *   depending if they are above or below the threshold
         *   defined by the level parameter. The parameter must
         *   be between 0.0 (black) and 1.0 (white). If no
         *   level is specified, 0.5 is used.
         *
         *   GRAY Converts any colors in the image to grayscale
         *   equivalents. No parameter is used.
         *
         *   OPAQUE Sets the alpha channel to entirely opaque.
         *   No parameter is used.
         *
         *   INVERT Sets each pixel to its inverse value. No
         *   parameter is used.
         *
         *   POSTERIZE Limits each channel of the image to the
         *   number of colors specified as the parameter. The
         *   parameter can be set to values between 2 and 255,
         *   but results are most noticeable in the lower
         *   ranges.
         *
         *   BLUR Executes a Gaussian blur with the level
         *   parameter specifying the extent of the blurring.
         *   If no parameter is used, the blur is equivalent to
         *   Gaussian blur of radius 1. Larger values increase
         *   the blur.
         *
         *   ERODE Reduces the light areas. No parameter is
         *   used.
         *
         *   DILATE Increases the light areas. No parameter is
         *   used.
         *
         *   filter() does not work in WEBGL mode. A similar
         *   effect can be achieved in WEBGL mode using custom
         *   shaders. Adam Ferriss has written a selection of
         *   shader examples that contains many of the effects
         *   present in the filter examples.
         *   @param filterType either THRESHOLD, GRAY, OPAQUE,
         *   INVERT, POSTERIZE, ERODE, DILATE or BLUR. See
         *   Filters.js for docs on each available filter
         *   @param [filterParam] an optional parameter unique
         *   to each filter, see above
         */
        filter(filterType: FILTER_TYPE, filterParam?: number): void;

        /**
         *   Copies a region of pixels from one image to
         *   another, using a specified blend mode to do the
         *   operation.
         *   @param srcImage source image
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         *   @param blendMode the blend mode. either BLEND,
         *   DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
         *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
         *   SOFT_LIGHT, DODGE, BURN, ADD or NORMAL.
         *
         *   Available blend modes are: normal | multiply |
         *   screen | overlay | darken | lighten | color-dodge
         *   | color-burn | hard-light | soft-light |
         *   difference | exclusion | hue | saturation | color
         *   | luminosity
         *
         *   http://blogs.adobe.com/webplatform/2013/01/28/blending-features-in-canvas/
         */
        blend(
            srcImage: Image,
            sx: number,
            sy: number,
            sw: number,
            sh: number,
            dx: number,
            dy: number,
            dw: number,
            dh: number,
            blendMode: BLEND_MODE
        ): void;

        /**
         *   Copies a region of pixels from one image to
         *   another, using a specified blend mode to do the
         *   operation.
         *   @param sx X coordinate of the source's upper left
         *   corner
         *   @param sy Y coordinate of the source's upper left
         *   corner
         *   @param sw source image width
         *   @param sh source image height
         *   @param dx X coordinate of the destination's upper
         *   left corner
         *   @param dy Y coordinate of the destination's upper
         *   left corner
         *   @param dw destination image width
         *   @param dh destination image height
         *   @param blendMode the blend mode. either BLEND,
         *   DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
         *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
         *   SOFT_LIGHT, DODGE, BURN, ADD or NORMAL.
         *
         *   Available blend modes are: normal | multiply |
         *   screen | overlay | darken | lighten | color-dodge
         *   | color-burn | hard-light | soft-light |
         *   difference | exclusion | hue | saturation | color
         *   | luminosity
         *
         *   http://blogs.adobe.com/webplatform/2013/01/28/blending-features-in-canvas/
         */
        blend(
            sx: number,
            sy: number,
            sw: number,
            sh: number,
            dx: number,
            dy: number,
            dw: number,
            dh: number,
            blendMode: UNKNOWN_P5_CONSTANT
        ): void;

        /**
         *   Saves the image to a file and force the browser to
         *   download it. Accepts two strings for filename and
         *   file extension Supports png (default), jpg, and
         *   gif  Note that the file will only be downloaded as
         *   an animated GIF if the p5.Image was loaded from a
         *   GIF file.
         *   @param filename give your file a name
         *   @param extension 'png' or 'jpg'
         */
        save(filename: string, extension: string): void;

        /**
         *   Starts an animated GIF over at the beginning
         *   state.
         */
        reset(): void;

        /**
         *   Gets the index for the frame that is currently
         *   visible in an animated GIF.
         *   @return The index for the currently displaying
         *   frame in animated GIF
         */
        getCurrentFrame(): number;

        /**
         *   Sets the index of the frame that is currently
         *   visible in an animated GIF
         *   @param index the index for the frame that should
         *   be displayed
         */
        setFrame(index: number): void;

        /**
         *   Returns the number of frames in an animated GIF
         */
        numFrames(): number;

        /**
         *   Plays an animated GIF that was paused with pause()
         */
        play(): void;

        /**
         *   Pauses an animated GIF.
         */
        pause(): void;

        /**
         *   Changes the delay between frames in an animated
         *   GIF. There is an optional second parameter that
         *   indicates an index for a specific frame that
         *   should have its delay modified. If no index is
         *   given, all frames will have the new delay.
         *   @param d the amount in milliseconds to delay
         *   between switching frames
         *   @param [index] the index of the frame that should
         *   have the new delay value {optional}
         */
        delay(d: number, index?: number): void;

        /**
         *   Image width.
         */
        width: number;

        /**
         *   Image height.
         */
        height: number;

        /**
         *   Array containing the values for all the pixels in
         *   the display window. These values are numbers. This
         *   array is the size (include an appropriate factor
         *   for pixelDensity) of the display window x4,
         *   representing the R, G, B, A values in order for
         *   each pixel, moving from left to right across each
         *   row, then down each column. Retina and other high
         *   density displays may have more pixels (by a factor
         *   of pixelDensity^2). For example, if the image is
         *   100×100 pixels, there will be 40,000. With
         *   pixelDensity = 2, there will be 160,000. The first
         *   four values (indices 0-3) in the array will be the
         *   R, G, B, A values of the pixel at (0, 0). The
         *   second four values (indices 4-7) will contain the
         *   R, G, B, A values of the pixel at (1, 0). More
         *   generally, to set values for a pixel at (x, y):
         *   let d = pixelDensity(); for (let i = 0; i < d;
         *   i++) { for (let j = 0; j < d; j++) { // loop over
         *   index = 4 * ((y * d + j) * width * d + (x * d +
         *   i)); pixels[index] = r; pixels[index+1] = g;
         *   pixels[index+2] = b; pixels[index+3] = a; } }
         *
         *   Before accessing this array, the data must loaded
         *   with the loadPixels() function. After the array
         *   data has been modified, the updatePixels()
         *   function must be run to update the changes.
         */
        pixels: number[];
    }

// Inlined from: ./src/io/p5.Table.d.ts

    class Table {
        /**
         *   Table objects store data with multiple rows and
         *   columns, much like in a traditional spreadsheet.
         *   Tables can be generated from scratch, dynamically,
         *   or using data from an existing file.
         *
         *   @param [rows] An array of p5.TableRow objects
         */
        constructor(rows?: TableRow[]);

        /**
         *   Use addRow() to add a new row of data to a
         *   p5.Table object. By default, an empty row is
         *   created. Typically, you would store a reference to
         *   the new row in a TableRow object (see newRow in
         *   the example above), and then set individual values
         *   using set(). If a p5.TableRow object is included
         *   as a parameter, then that row is duplicated and
         *   added to the table.
         *   @param [row] row to be added to the table
         *   @return the row that was added
         */
        addRow(row?: TableRow): TableRow;

        /**
         *   Removes a row from the table object.
         *   @param id ID number of the row to remove
         */
        removeRow(id: number): void;

        /**
         *   Returns a reference to the specified p5.TableRow.
         *   The reference can then be used to get and set
         *   values of the selected row.
         *   @param rowID ID number of the row to get
         *   @return p5.TableRow object
         */
        getRow(rowID: number): TableRow;

        /**
         *   Gets all rows from the table. Returns an array of
         *   p5.TableRows.
         *   @return Array of p5.TableRows
         */
        getRows(): TableRow[];

        /**
         *   Finds the first row in the Table that contains the
         *   value provided, and returns a reference to that
         *   row. Even if multiple rows are possible matches,
         *   only the first matching row is returned. The
         *   column to search may be specified by either its ID
         *   or title.
         *   @param value The value to match
         *   @param column ID number or title of the column to
         *   search
         */
        findRow(value: string, column: number | string): TableRow;

        /**
         *   Finds the rows in the Table that contain the value
         *   provided, and returns references to those rows.
         *   Returns an Array, so for must be used to iterate
         *   through all the rows, as shown in the example
         *   above. The column to search may be specified by
         *   either its ID or title.
         *   @param value The value to match
         *   @param column ID number or title of the column to
         *   search
         *   @return An Array of TableRow objects
         */
        findRows(value: string, column: number | string): TableRow[];

        /**
         *   Finds the first row in the Table that matches the
         *   regular expression provided, and returns a
         *   reference to that row. Even if multiple rows are
         *   possible matches, only the first matching row is
         *   returned. The column to search may be specified by
         *   either its ID or title.
         *   @param regexp The regular expression to match
         *   @param column The column ID (number) or title
         *   (string)
         *   @return TableRow object
         */
        matchRow(regexp: string | RegExp, column: string | number): TableRow;

        /**
         *   Finds the rows in the Table that match the regular
         *   expression provided, and returns references to
         *   those rows. Returns an array, so for must be used
         *   to iterate through all the rows, as shown in the
         *   example. The column to search may be specified by
         *   either its ID or title.
         *   @param regexp The regular expression to match
         *   @param [column] The column ID (number) or title
         *   (string)
         *   @return An Array of TableRow objects
         */
        matchRows(regexp: string, column?: string | number): TableRow[];

        /**
         *   Retrieves all values in the specified column, and
         *   returns them as an array. The column may be
         *   specified by either its ID or title.
         *   @param column String or Number of the column to
         *   return
         *   @return Array of column values
         */
        getColumn(column: string | number): any[];

        /**
         *   Removes all rows from a Table. While all rows are
         *   removed, columns and column titles are maintained.
         */
        clearRows(): void;

        /**
         *   Use addColumn() to add a new column to a Table
         *   object. Typically, you will want to specify a
         *   title, so the column may be easily referenced
         *   later by name. (If no title is specified, the new
         *   column's title will be null.)
         *   @param [title] title of the given column
         */
        addColumn(title?: string): void;

        /**
         *   Returns the total number of columns in a Table.
         *   @return Number of columns in this table
         */
        getColumnCount(): number;

        /**
         *   Returns the total number of rows in a Table.
         *   @return Number of rows in this table
         */
        getRowCount(): number;

        /**
         *   Removes any of the specified characters (or
         *   "tokens"). If no column is specified, then the
         *   values in all columns and rows are processed. A
         *   specific column may be referenced by either its ID
         *   or title.
         *   @param chars String listing characters to be
         *   removed
         *   @param [column] Column ID (number) or name
         *   (string)
         */
        removeTokens(chars: string, column?: string | number): void;

        /**
         *   Trims leading and trailing whitespace, such as
         *   spaces and tabs, from String table values. If no
         *   column is specified, then the values in all
         *   columns and rows are trimmed. A specific column
         *   may be referenced by either its ID or title.
         *   @param [column] Column ID (number) or name
         *   (string)
         */
        trim(column?: string | number): void;

        /**
         *   Use removeColumn() to remove an existing column
         *   from a Table object. The column to be removed may
         *   be identified by either its title (a String) or
         *   its index value (an int). removeColumn(0) would
         *   remove the first column, removeColumn(1) would
         *   remove the second column, and so on.
         *   @param column columnName (string) or ID (number)
         */
        removeColumn(column: string | number): void;

        /**
         *   Stores a value in the Table's specified row and
         *   column. The row is specified by its ID, while the
         *   column may be specified by either its ID or title.
         *   @param row row ID
         *   @param column column ID (Number) or title (String)
         *   @param value value to assign
         */
        set(row: number, column: string | number, value: string | number): void;

        /**
         *   Stores a Float value in the Table's specified row
         *   and column. The row is specified by its ID, while
         *   the column may be specified by either its ID or
         *   title.
         *   @param row row ID
         *   @param column column ID (Number) or title (String)
         *   @param value value to assign
         */
        setNum(row: number, column: string | number, value: number): void;

        /**
         *   Stores a String value in the Table's specified row
         *   and column. The row is specified by its ID, while
         *   the column may be specified by either its ID or
         *   title.
         *   @param row row ID
         *   @param column column ID (Number) or title (String)
         *   @param value value to assign
         */
        setString(row: number, column: string | number, value: string): void;

        /**
         *   Retrieves a value from the Table's specified row
         *   and column. The row is specified by its ID, while
         *   the column may be specified by either its ID or
         *   title.
         *   @param row row ID
         *   @param column columnName (string) or ID (number)
         */
        get(row: number, column: string | number): string | number;

        /**
         *   Retrieves a Float value from the Table's specified
         *   row and column. The row is specified by its ID,
         *   while the column may be specified by either its ID
         *   or title.
         *   @param row row ID
         *   @param column columnName (string) or ID (number)
         */
        getNum(row: number, column: string | number): number;

        /**
         *   Retrieves a String value from the Table's
         *   specified row and column. The row is specified by
         *   its ID, while the column may be specified by
         *   either its ID or title.
         *   @param row row ID
         *   @param column columnName (string) or ID (number)
         */
        getString(row: number, column: string | number): string;

        /**
         *   Retrieves all table data and returns as an object.
         *   If a column name is passed in, each row object
         *   will be stored with that attribute as its title.
         *   @param [headerColumn] Name of the column which
         *   should be used to title each row object (optional)
         */
        getObject(headerColumn?: string): object;

        /**
         *   Retrieves all table data and returns it as a
         *   multidimensional array.
         */
        getArray(): any[];

        /**
         *   An array containing the names of the columns in
         *   the table, if the "header" the table is loaded
         *   with the "header" parameter.
         */
        columns: string[];

        /**
         *   An array containing the p5.TableRow objects that
         *   make up the rows of the table. The same result as
         *   calling getRows()
         */
        rows: TableRow[];
    }

// Inlined from: ./src/io/p5.TableRow.d.ts

    class TableRow {
        /**
         *   A TableRow object represents a single row of data
         *   values, stored in columns, from a table. A Table
         *   Row contains both an ordered array, and an
         *   unordered JSON object.
         *
         *   @param [str] optional: populate the row with a
         *   string of values, separated by the separator
         *   @param [separator] comma separated values (csv) by
         *   default
         */
        constructor(str?: string, separator?: string);

        /**
         *   Stores a value in the TableRow's specified column.
         *   The column may be specified by either its ID or
         *   title.
         *   @param column Column ID (Number) or Title (String)
         *   @param value The value to be stored
         */
        set(column: string | number, value: string | number): void;

        /**
         *   Stores a Float value in the TableRow's specified
         *   column. The column may be specified by either its
         *   ID or title.
         *   @param column Column ID (Number) or Title (String)
         *   @param value The value to be stored as a Float
         */
        setNum(column: string | number, value: number | string): void;

        /**
         *   Stores a String value in the TableRow's specified
         *   column. The column may be specified by either its
         *   ID or title.
         *   @param column Column ID (Number) or Title (String)
         *   @param value The value to be stored as a String
         */
        setString(column: string | number, value: string | number | boolean | object): void;

        /**
         *   Retrieves a value from the TableRow's specified
         *   column. The column may be specified by either its
         *   ID or title.
         *   @param column columnName (string) or ID (number)
         */
        get(column: string | number): string | number;

        /**
         *   Retrieves a Float value from the TableRow's
         *   specified column. The column may be specified by
         *   either its ID or title.
         *   @param column columnName (string) or ID (number)
         *   @return Float Floating point number
         */
        getNum(column: string | number): number;

        /**
         *   Retrieves an String value from the TableRow's
         *   specified column. The column may be specified by
         *   either its ID or title.
         *   @param column columnName (string) or ID (number)
         *   @return String
         */
        getString(column: string | number): string;
    }

// Inlined from: ./src/io/p5.XML.d.ts

    class XML {
        /**
         *   XML is a representation of an XML object, able to
         *   parse XML code. Use loadXML() to load external XML
         *   files and create XML objects.
         *
         */
        constructor();

        /**
         *   Gets a copy of the element's parent. Returns the
         *   parent as another p5.XML object.
         *   @return element parent
         */
        getParent(): XML;

        /**
         *   Gets the element's full name, which is returned as
         *   a String.
         *   @return the name of the node
         */
        getName(): string;

        /**
         *   Sets the element's name, which is specified as a
         *   String.
         *   @param the new name of the node
         */
        setName(the: string): void;

        /**
         *   Checks whether or not the element has any
         *   children, and returns the result as a boolean.
         */
        hasChildren(): boolean;

        /**
         *   Get the names of all of the element's children,
         *   and returns the names as an array of Strings. This
         *   is the same as looping through and calling
         *   getName() on each child element individually.
         *   @return names of the children of the element
         */
        listChildren(): string[];

        /**
         *   Returns all of the element's children as an array
         *   of p5.XML objects. When the name parameter is
         *   specified, then it will return all children that
         *   match that name.
         *   @param [name] element name
         *   @return children of the element
         */
        getChildren(name?: string): XML[];

        /**
         *   Returns the first of the element's children that
         *   matches the name parameter or the child of the
         *   given index.It returns undefined if no matching
         *   child is found.
         *   @param name element name or index
         */
        getChild(name: string | number): XML;

        /**
         *   Appends a new child to the element. The child can
         *   be specified with either a String, which will be
         *   used as the new tag's name, or as a reference to
         *   an existing p5.XML object. A reference to the
         *   newly created child is returned as an p5.XML
         *   object.
         *   @param node a p5.XML Object which will be the
         *   child to be added
         */
        addChild(node: XML): void;

        /**
         *   Removes the element specified by name or index.
         *   @param name element name or index
         */
        removeChild(name: string | number): void;

        /**
         *   Counts the specified element's number of
         *   attributes, returned as an Number.
         */
        getAttributeCount(): number;

        /**
         *   Gets all of the specified element's attributes,
         *   and returns them as an array of Strings.
         *   @return an array of strings containing the names
         *   of attributes
         */
        listAttributes(): string[];

        /**
         *   Checks whether or not an element has the specified
         *   attribute.
         *   @param the attribute to be checked
         *   @return true if attribute found else false
         */
        hasAttribute(the: string): boolean;

        /**
         *   Returns an attribute value of the element as an
         *   Number. If the defaultValue parameter is specified
         *   and the attribute doesn't exist, then defaultValue
         *   is returned. If no defaultValue is specified and
         *   the attribute doesn't exist, the value 0 is
         *   returned.
         *   @param name the non-null full name of the
         *   attribute
         *   @param [defaultValue] the default value of the
         *   attribute
         */
        getNum(name: string, defaultValue?: number): number;

        /**
         *   Returns an attribute value of the element as an
         *   String. If the defaultValue parameter is specified
         *   and the attribute doesn't exist, then defaultValue
         *   is returned. If no defaultValue is specified and
         *   the attribute doesn't exist, null is returned.
         *   @param name the non-null full name of the
         *   attribute
         *   @param [defaultValue] the default value of the
         *   attribute
         */
        getString(name: string, defaultValue?: number): string;

        /**
         *   Sets the content of an element's attribute. The
         *   first parameter specifies the attribute name,
         *   while the second specifies the new content.
         *   @param name the full name of the attribute
         *   @param value the value of the attribute
         */
        setAttribute(name: string, value: number | string | boolean): void;

        /**
         *   Returns the content of an element. If there is no
         *   such content, defaultValue is returned if
         *   specified, otherwise null is returned.
         *   @param [defaultValue] value returned if no content
         *   is found
         */
        getContent(defaultValue?: string): string;

        /**
         *   Sets the element's content.
         *   @param text the new content
         */
        setContent(text: string): void;

        /**
         *   Serializes the element into a string. This
         *   function is useful for preparing the content to be
         *   sent over a http request or saved to file.
         *   @return Serialized string of the element
         */
        serialize(): string;
    }

// Inlined from: ./src/math/p5.Vector.d.ts

    class Vector {
        /**
         *   A class to describe a two or three-dimensional
         *   vector, specifically a Euclidean (also known as
         *   geometric) vector. A vector is an entity that has
         *   both magnitude and direction. The datatype,
         *   however, stores the components of the vector (x, y
         *   for 2D; or x, y, z for 3D). The magnitude and
         *   direction can be accessed via the methods
         *   p5.Vector.mag() and heading(). In many of the
         *   p5.js examples, you will see p5.Vector used to
         *   describe a position, velocity, or acceleration.
         *   For example, if you consider a rectangle moving
         *   across the screen, at any given instant it has a
         *   position (a vector that points from the origin to
         *   its location), a velocity (the rate at which the
         *   object's position changes per time unit, expressed
         *   as a vector), and acceleration (the rate at which
         *   the object's velocity changes per time unit,
         *   expressed as a vector).
         *
         *   Since vectors represent groupings of values, we
         *   cannot simply use traditional
         *   addition/multiplication/etc. Instead, we'll need
         *   to do some "vector" math, which is made easy by
         *   the methods inside the p5.Vector class.
         *
         *   @param [x] x component of the vector
         *   @param [y] y component of the vector
         *   @param [z] z component of the vector
         */
        constructor(x?: number, y?: number, z?: number);

        /**
         *   Gets a copy of the vector, returns a p5.Vector
         *   object.
         *   @param v the p5.Vector to create a copy of
         *   @return the copy of the p5.Vector object
         */
        static copy(v: Vector): Vector;

        /**
         *   Adds x, y, and z components to a vector, adds one
         *   vector to another, or adds two independent vectors
         *   together. The version of the method that adds two
         *   vectors together is a static method and returns a
         *   p5.Vector, the others act directly on the vector.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param v1 A p5.Vector to add
         *   @param v2 A p5.Vector to add
         *   @param [target] The vector to receive the result
         *   @return The resulting p5.Vector
         */
        static add(v1: Vector, v2: Vector, target?: Vector): Vector;

        /**
         *   Gives the remainder of a vector when it is divided
         *   by another vector. See examples for more context.
         *   @param v1 The dividend p5.Vector
         *   @param v2 The divisor p5.Vector
         */
        static rem(v1: Vector, v2: Vector): void;

        /**
         *   Gives the remainder of a vector when it is divided
         *   by another vector. See examples for more context.
         *   @param v1 The dividend p5.Vector
         *   @param v2 The divisor p5.Vector
         *   @return The resulting p5.Vector
         */
        static rem(v1: Vector, v2: Vector): Vector;

        /**
         *   Subtracts x, y, and z components from a vector,
         *   subtracts one vector from another, or subtracts
         *   two independent vectors. The version of the method
         *   that subtracts two vectors is a static method and
         *   returns a p5.Vector, the others act directly on
         *   the vector. Additionally, you may provide
         *   arguments to this method as an array. See the
         *   examples for more context.
         *   @param v1 A p5.Vector to subtract from
         *   @param v2 A p5.Vector to subtract
         *   @param [target] The vector to receive the result
         *   @return The resulting p5.Vector
         */
        static sub(v1: Vector, v2: Vector, target?: Vector): Vector;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param x The number to multiply with the x
         *   component of the vector
         *   @param y The number to multiply with the y
         *   component of the vector
         *   @param [z] The number to multiply with the z
         *   component of the vector
         *   @return The resulting new p5.Vector
         */
        static mult(x: number, y: number, z?: number): Vector;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param v The vector to multiply with the
         *   components of the original vector
         *   @param n The number to multiply with the vector
         *   @param [target] the vector to receive the result
         */
        static mult(v: Vector, n: number, target?: Vector): void;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param [target] the vector to receive the result
         */
        static mult(v0: Vector, v1: Vector, target?: Vector): void;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param arr The array to multiply with the
         *   components of the vector
         *   @param [target] the vector to receive the result
         */
        static mult(v0: Vector, arr: number[], target?: Vector): void;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param x The number to divide with the x component
         *   of the vector
         *   @param y The number to divide with the y component
         *   of the vector
         *   @param [z] The number to divide with the z
         *   component of the vector
         *   @return The resulting new p5.Vector
         */
        static div(x: number, y: number, z?: number): Vector;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param v The vector to divide the components of
         *   the original vector by
         *   @param n The number to divide the vector by
         *   @param [target] The vector to receive the result
         */
        static div(v: Vector, n: number, target?: Vector): void;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param [target] The vector to receive the result
         */
        static div(v0: Vector, v1: Vector, target?: Vector): void;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param arr The array to divide the components of
         *   the vector by
         *   @param [target] The vector to receive the result
         */
        static div(v0: Vector, arr: number[], target?: Vector): void;

        /**
         *   Calculates the magnitude (length) of the vector
         *   and returns the result as a float. (This is simply
         *   the equation sqrt(x*x + y*y + z*z).)
         *   @param vecT The vector to return the magnitude of
         *   @return The magnitude of vecT
         */
        static mag(vecT: Vector): number;

        /**
         *   Calculates the squared magnitude of the vector and
         *   returns the result as a float. (This is simply the
         *   equation x*x + y*y + z*z.) Faster if the real
         *   length is not required in the case of comparing
         *   vectors, etc.
         *   @param vecT the vector to return the squared
         *   magnitude of
         *   @return the squared magnitude of vecT
         */
        static magSq(vecT: Vector): number;

        /**
         *   Calculates the dot product of two vectors. The
         *   version of the method that computes the dot
         *   product of two independent vectors is a static
         *   method. See the examples for more context.
         *   @param v1 The first p5.Vector
         *   @param v2 The second p5.Vector
         *   @return The dot product
         */
        static dot(v1: Vector, v2: Vector): number;

        /**
         *   Calculates and returns a vector composed of the
         *   cross product between two vectors. Both the static
         *   and non-static methods return a new p5.Vector. See
         *   the examples for more context.
         *   @param v1 The first p5.Vector
         *   @param v2 The second p5.Vector
         *   @return The cross product
         */
        static cross(v1: Vector, v2: Vector): number;

        /**
         *   Calculates the Euclidean distance between two
         *   points (considering a point as a vector object).
         *   If you are looking to calculate distance between 2
         *   points see dist()
         *   @param v1 The first p5.Vector
         *   @param v2 The second p5.Vector
         *   @return The distance
         */
        static dist(v1: Vector, v2: Vector): number;

        /**
         *   Normalize the vector to length 1 (make it a unit
         *   vector).
         *   @param v The vector to normalize
         *   @param [target] The vector to receive the result
         *   @return The vector v, normalized to a length of 1
         */
        static normalize(v: Vector, target?: Vector): Vector;

        /**
         *   Limit the magnitude of this vector to the value
         *   used for the max parameter.
         *   @param v the vector to limit
         *   @param max The maximum magnitude for the vector
         *   @param [target] the vector to receive the result
         *   (Optional)
         *   @return v with a magnitude limited to max
         */
        static limit(v: Vector, max: number, target?: Vector): Vector;

        /**
         *   Set the magnitude of this vector to the value used
         *   for the len parameter.
         *   @param v the vector to set the magnitude of
         *   @param len The new length for this vector
         *   @param [target] the vector to receive the result
         *   (Optional)
         *   @return v with a magnitude set to len
         */
        static setMag(v: Vector, len: number, target?: Vector): Vector;

        /**
         *   Calculate the angle of rotation for this vector
         *   (only 2D vectors). p5.Vectors created using
         *   createVector() will take the current angleMode()
         *   into consideration, and give the angle in radians
         *   or degrees accordingly.
         *   @param v the vector to find the angle of
         *   @return the angle of rotation
         */
        static heading(v: Vector): number;

        /**
         *   Rotate the vector by an angle (only 2D vectors);
         *   magnitude remains the same.
         *   @param angle The angle of rotation
         *   @param [target] The vector to receive the result
         */
        static rotate(v: Vector, angle: number, target?: Vector): void;

        /**
         *   Calculates and returns the angle between two
         *   vectors. This method will take the current
         *   angleMode into consideration, and give the angle
         *   in radians or degrees accordingly.
         *   @param v1 the first vector
         *   @param v2 the second vector
         *   @return the angle between the two vectors
         */
        static angleBetween(v1: Vector, v2: Vector): number;

        /**
         *   Linear interpolate the vector to another vector.
         *   @param amt The amount of interpolation; some value
         *   between 0.0 (old vector) and 1.0 (new vector). 0.9
         *   is very near the new vector. 0.5 is halfway in
         *   between.
         *   @param [target] The vector to receive the result
         *   @return The lerped value
         */
        static lerp(v1: Vector, v2: Vector, amt: number, target?: Vector): Vector;

        /**
         *   Performs spherical linear interpolation with the
         *   other vector and returns the resulting vector.
         *   This works in both 3D and 2D. As for 2D, the
         *   result of slerping between 2D vectors is always a
         *   2D vector.
         *   @param v1 old vector
         *   @param v2 new vectpr
         *   @param amt The amount of interpolation. some value
         *   between 0.0 (old vector) and 1.0 (new vector). 0.9
         *   is very near the new vector. 0.5 is halfway in
         *   between.
         *   @param [target] The vector to receive the result
         *   @return slerped vector between v1 and v2
         */
        static slerp(v1: Vector, v2: Vector, amt: number, target?: Vector): Vector;

        /**
         *   Reflect a vector about a normal to a line in 2D,
         *   or about a normal to a plane in 3D.
         *   @param incidentVector vector to be reflected
         *   @param surfaceNormal the p5.Vector to reflect
         *   about.
         *   @param [target] the vector to receive the result
         *   (Optional)
         *   @return the reflected vector
         */
        static reflect(incidentVector: Vector, surfaceNormal: Vector, target?: Vector): Vector;

        /**
         *   Return a representation of this vector as a float
         *   array. This is only for temporary use. If used in
         *   any other fashion, the contents should be copied
         *   by using the p5.Vector.copy() method to copy into
         *   your own vector.
         *   @param v the vector to convert to an array
         *   @return an Array with the 3 values
         */
        static array(v: Vector): number[];

        /**
         *   Equality check against a p5.Vector.
         *   @param v1 the first vector to compare
         *   @param v2 the second vector to compare
         */
        static equals(v1: Vector | any[], v2: Vector | any[]): boolean;

        /**
         *   Make a new 2D vector from an angle.
         *   @param angle The desired angle, in radians
         *   (unaffected by angleMode)
         *   @param [length] The length of the new vector
         *   (defaults to 1)
         *   @return The new p5.Vector object
         */
        static fromAngle(angle: number, length?: number): Vector;

        /**
         *   Make a new 3D vector from a pair of ISO spherical
         *   angles.
         *   @param theta The polar angle, in radians (zero is
         *   up)
         *   @param phi The azimuthal angle, in radians (zero
         *   is out of the screen)
         *   @param [length] The length of the new vector
         *   (defaults to 1)
         *   @return A new p5.Vector object
         */
        static fromAngles(theta: number, phi: number, length?: number): Vector;

        /**
         *   Make a new 2D unit vector from a random angle.
         *   @return A new p5.Vector object
         */
        static random2D(): Vector;

        /**
         *   Make a new random 3D unit vector.
         *   @return A new p5.Vector object
         */
        static random3D(): Vector;

        /**
         *   Returns a string representation of a vector v by
         *   calling String(v) or v.toString(). This method is
         *   useful for logging vectors in the console.
         */
        toString(): string;

        /**
         *   Sets the x, y, and z components of the vector
         *   using two or three separate variables, the data
         *   from a p5.Vector, or the values from a float
         *   array.
         *   @param [x] The x component of the vector
         *   @param [y] The y component of the vector
         *   @param [z] The z component of the vector
         *   @chainable
         */
        set(x?: number, y?: number, z?: number): Vector;

        /**
         *   Sets the x, y, and z components of the vector
         *   using two or three separate variables, the data
         *   from a p5.Vector, or the values from a float
         *   array.
         *   @param value The vector to set
         *   @chainable
         */
        set(value: Vector | number[]): Vector;

        /**
         *   Gets a copy of the vector, returns a p5.Vector
         *   object.
         *   @return A copy of the p5.Vector object
         */
        copy(): Vector;

        /**
         *   Adds x, y, and z components to a vector, adds one
         *   vector to another, or adds two independent vectors
         *   together. The version of the method that adds two
         *   vectors together is a static method and returns a
         *   p5.Vector, the others act directly on the vector.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param x The x component of the vector to be added
         *   @param [y] The y component of the vector to be
         *   added
         *   @param [z] The z component of the vector to be
         *   added
         *   @chainable
         */
        add(x: number, y?: number, z?: number): Vector;

        /**
         *   Adds x, y, and z components to a vector, adds one
         *   vector to another, or adds two independent vectors
         *   together. The version of the method that adds two
         *   vectors together is a static method and returns a
         *   p5.Vector, the others act directly on the vector.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param value The vector to add
         *   @chainable
         */
        add(value: Vector | number[]): Vector;

        /**
         *   Gives the remainder of a vector when it is divided
         *   by another vector. See examples for more context.
         *   @param x The x component of divisor vector
         *   @param y The y component of divisor vector
         *   @param z The z component of divisor vector
         *   @chainable
         */
        rem(x: number, y: number, z: number): Vector;

        /**
         *   Gives the remainder of a vector when it is divided
         *   by another vector. See examples for more context.
         *   @param value The divisor vector
         *   @chainable
         */
        rem(value: Vector | number[]): Vector;

        /**
         *   Subtracts x, y, and z components from a vector,
         *   subtracts one vector from another, or subtracts
         *   two independent vectors. The version of the method
         *   that subtracts two vectors is a static method and
         *   returns a p5.Vector, the others act directly on
         *   the vector. Additionally, you may provide
         *   arguments to this method as an array. See the
         *   examples for more context.
         *   @param x The x component of the vector to subtract
         *   @param [y] The y component of the vector to
         *   subtract
         *   @param [z] The z component of the vector to
         *   subtract
         *   @chainable
         */
        sub(x: number, y?: number, z?: number): Vector;

        /**
         *   Subtracts x, y, and z components from a vector,
         *   subtracts one vector from another, or subtracts
         *   two independent vectors. The version of the method
         *   that subtracts two vectors is a static method and
         *   returns a p5.Vector, the others act directly on
         *   the vector. Additionally, you may provide
         *   arguments to this method as an array. See the
         *   examples for more context.
         *   @param value the vector to subtract
         *   @chainable
         */
        sub(value: Vector | number[]): Vector;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param n The number to multiply with the vector
         *   @chainable
         */
        mult(n: number): Vector;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param x The number to multiply with the x
         *   component of the vector
         *   @param y The number to multiply with the y
         *   component of the vector
         *   @param [z] The number to multiply with the z
         *   component of the vector
         *   @chainable
         */
        mult(x: number, y: number, z?: number): Vector;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param arr The array to multiply with the
         *   components of the vector
         *   @chainable
         */
        mult(arr: number[]): Vector;

        /**
         *   Multiplies the vector by a scalar, multiplies the
         *   x, y, and z components from a vector, or
         *   multiplies the x, y, and z components of two
         *   independent vectors. When multiplying a vector by
         *   a scalar, the x, y, and z components of the vector
         *   are all multiplied by the scalar. When multiplying
         *   a vector by a vector, the x, y, z components of
         *   both vectors are multiplied by each other (for
         *   example, with two vectors a and b: a.x * b.x, a.y
         *   * b.y, a.z * b.z). The static version of this
         *   method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   function as an array. See the examples for more
         *   context.
         *   @param v The vector to multiply with the
         *   components of the original vector
         *   @chainable
         */
        mult(v: Vector): Vector;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param n The number to divide the vector by
         *   @chainable
         */
        div(n: number): Vector;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param x The number to divide with the x component
         *   of the vector
         *   @param y The number to divide with the y component
         *   of the vector
         *   @param [z] The number to divide with the z
         *   component of the vector
         *   @chainable
         */
        div(x: number, y: number, z?: number): Vector;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param arr The array to divide the components of
         *   the vector by
         *   @chainable
         */
        div(arr: number[]): Vector;

        /**
         *   Divides the vector by a scalar, divides a vector
         *   by the x, y, and z arguments, or divides the x, y,
         *   and z components of two vectors against each
         *   other. When dividing a vector by a scalar, the x,
         *   y, and z components of the vector are all divided
         *   by the scalar. When dividing a vector by a vector,
         *   the x, y, z components of the source vector are
         *   treated as the dividend, and the x, y, z
         *   components of the argument is treated as the
         *   divisor. (For example, with two vectors a and b:
         *   a.x / b.x, a.y / b.y, a.z / b.z.) If any component
         *   of the second vector is 0, a division by 0 error
         *   will be logged, unless both two vectors have 0 in
         *   their z components, in which case only the x and y
         *   components will be divided. The static version of
         *   this method creates a new p5.Vector while the
         *   non-static version acts on the vector directly.
         *   Additionally, you may provide arguments to this
         *   method as an array. See the examples for more
         *   context.
         *   @param v The vector to divide the components of
         *   the original vector by
         *   @chainable
         */
        div(v: Vector): Vector;

        /**
         *   Calculates the magnitude (length) of the vector
         *   and returns the result as a float. (This is simply
         *   the equation sqrt(x*x + y*y + z*z).)
         *   @return The magnitude of the vector
         */
        mag(): number;

        /**
         *   Calculates the squared magnitude of the vector and
         *   returns the result as a float. (This is simply the
         *   equation x*x + y*y + z*z.) Faster if the real
         *   length is not required in the case of comparing
         *   vectors, etc.
         *   @return The squared magnitude of the vector
         */
        magSq(): number;

        /**
         *   Calculates the dot product of two vectors. The
         *   version of the method that computes the dot
         *   product of two independent vectors is a static
         *   method. See the examples for more context.
         *   @param x The x component of the vector
         *   @param [y] The y component of the vector
         *   @param [z] The z component of the vector
         *   @return The dot product
         */
        dot(x: number, y?: number, z?: number): number;

        /**
         *   Calculates the dot product of two vectors. The
         *   version of the method that computes the dot
         *   product of two independent vectors is a static
         *   method. See the examples for more context.
         *   @param value value component of the vector or a
         *   p5.Vector
         */
        dot(value: Vector): number;

        /**
         *   Calculates and returns a vector composed of the
         *   cross product between two vectors. Both the static
         *   and non-static methods return a new p5.Vector. See
         *   the examples for more context.
         *   @param v p5.Vector to be crossed
         *   @return p5.Vector composed of cross product
         */
        cross(v: Vector): Vector;

        /**
         *   Calculates the Euclidean distance between two
         *   points (considering a point as a vector object).
         *   If you are looking to calculate distance between 2
         *   points see dist()
         *   @param v The x, y, and z coordinates of a
         *   p5.Vector
         *   @return The distance
         */
        dist(v: Vector): number;

        /**
         *   Normalize the vector to length 1 (make it a unit
         *   vector).
         *   @return The normalized p5.Vector
         */
        normalize(): Vector;

        /**
         *   Limit the magnitude of this vector to the value
         *   used for the max parameter.
         *   @param max The maximum magnitude for the vector
         *   @chainable
         */
        limit(max: number): Vector;

        /**
         *   Set the magnitude of this vector to the value used
         *   for the len parameter.
         *   @param len The new length for this vector
         *   @chainable
         */
        setMag(len: number): Vector;

        /**
         *   Calculate the angle of rotation for this vector
         *   (only 2D vectors). p5.Vectors created using
         *   createVector() will take the current angleMode()
         *   into consideration, and give the angle in radians
         *   or degrees accordingly.
         *   @return The angle of rotation
         */
        heading(): number;

        /**
         *   Rotate the vector to a specific angle (only 2D
         *   vectors); magnitude remains the same.
         *   @param angle The angle of rotation
         *   @chainable
         */
        setHeading(angle: number): Vector;

        /**
         *   Rotate the vector by an angle (only 2D vectors);
         *   magnitude remains the same.
         *   @param angle The angle of rotation
         *   @chainable
         */
        rotate(angle: number): Vector;

        /**
         *   Calculates and returns the angle between two
         *   vectors. This method will take the current
         *   angleMode into consideration, and give the angle
         *   in radians or degrees accordingly.
         *   @param value The x, y, and z components of a
         *   p5.Vector
         *   @return The angle between
         */
        angleBetween(value: Vector): number;

        /**
         *   Linear interpolate the vector to another vector.
         *   @param x The x component
         *   @param y The y component
         *   @param z The z component
         *   @param amt The amount of interpolation; some value
         *   between 0.0 (old vector) and 1.0 (new vector). 0.9
         *   is very near the new vector. 0.5 is halfway in
         *   between.
         *   @chainable
         */
        lerp(x: number, y: number, z: number, amt: number): Vector;

        /**
         *   Linear interpolate the vector to another vector.
         *   @param v The p5.Vector to lerp to
         *   @param amt The amount of interpolation; some value
         *   between 0.0 (old vector) and 1.0 (new vector). 0.9
         *   is very near the new vector. 0.5 is halfway in
         *   between.
         *   @chainable
         */
        lerp(v: Vector, amt: number): Vector;

        /**
         *   Performs spherical linear interpolation with the
         *   other vector and returns the resulting vector.
         *   This works in both 3D and 2D. As for 2D, the
         *   result of slerping between 2D vectors is always a
         *   2D vector.
         *   @param v the p5.Vector to slerp to
         *   @param amt The amount of interpolation. some value
         *   between 0.0 (old vector) and 1.0 (new vector). 0.9
         *   is very near the new vector. 0.5 is halfway in
         *   between.
         */
        slerp(v: Vector, amt: number): Vector;

        /**
         *   Reflect a vector about a normal to a line in 2D,
         *   or about a normal to a plane in 3D.
         *   @param surfaceNormal the p5.Vector to reflect
         *   about.
         *   @chainable
         */
        reflect(surfaceNormal: Vector): Vector;

        /**
         *   Return a representation of this vector as a float
         *   array. This is only for temporary use. If used in
         *   any other fashion, the contents should be copied
         *   by using the p5.Vector.copy() method to copy into
         *   your own vector.
         *   @return An Array with the 3 values
         */
        array(): number[];

        /**
         *   Equality check against a p5.Vector.
         *   @param [x] The x component of the vector
         *   @param [y] The y component of the vector
         *   @param [z] The z component of the vector
         *   @return Whether the vectors are equal
         */
        equals(x?: number, y?: number, z?: number): boolean;

        /**
         *   Equality check against a p5.Vector.
         *   @param value The vector to compare
         */
        equals(value: Vector | any[]): boolean;

        /**
         *   The x component of the vector
         */
        x: number;

        /**
         *   The y component of the vector
         */
        y: number;

        /**
         *   The z component of the vector
         */
        z: number;
    }

// Inlined from: ./src/typography/p5.Font.d.ts

    class Font {
        /**
         *   Base class for font handling
         *
         *   @param [pInst] pointer to p5 instance
         */
        constructor(pInst?: p5);

        /**
         *   Returns a tight bounding box for the given text
         *   string using this font
         *   @param line a line of text
         *   @param x x-position
         *   @param y y-position
         *   @param [fontSize] font size to use (optional)
         *   Default is 12.
         *   @param [options] opentype options (optional)
         *   opentype fonts contains alignment and baseline
         *   options. Default is 'LEFT' and 'alphabetic'
         *   @return a rectangle object with properties: x, y,
         *   w, h
         */
        textBounds(line: string, x: number, y: number, fontSize?: number, options?: object): object;

        /**
         *   Computes an array of points following the path for
         *   specified text
         *   @param txt a line of text
         *   @param x x-position
         *   @param y y-position
         *   @param fontSize font size to use (optional)
         *   @param [options] an (optional) object that can
         *   contain:
         *
         *
         *   sampleFactor - the ratio of path-length to number
         *   of samples (default=.1); higher values yield more
         *   points and are therefore more precise
         *
         *
         *   simplifyThreshold - if set to a non-zero value,
         *   collinear points will be be removed from the
         *   polygon; the value represents the threshold angle
         *   to use when determining whether two edges are
         *   collinear
         *   @return an array of points, each with x, y, alpha
         *   (the path angle)
         */
        textToPoints(txt: string, x: number, y: number, fontSize: number, options?: object): any[];

        /**
         *   Underlying opentype font implementation
         */
        font: any;
    }

// Inlined from: ./src/webgl/p5.Framebuffer.d.ts

    class Framebuffer {
        /**
         *   An object that one can draw to and then read as a
         *   texture. While similar to a p5.Graphics, using a
         *   p5.Framebuffer as a texture will generally run
         *   much faster, as it lives within the same WebGL
         *   context as the canvas it is created on. It only
         *   works in WebGL mode.
         *
         *   @param target A p5 global instance or p5.Graphics
         *   @param [settings] A settings object
         */
        constructor(target: Graphics, settings?: object);

        /**
         *   Resizes the framebuffer to the given width and
         *   height.
         */
        resize(width: number, height: number): void;

        /**
         *   Gets or sets the pixel scaling for high pixel
         *   density displays. By default, the density will
         *   match that of the canvas the framebuffer was
         *   created on, which will match the display density.
         *   Call this method with no arguments to get the
         *   current density, or pass in a number to set the
         *   density.
         *   @param [density] A scaling factor for the number
         *   of pixels per side of the framebuffer
         */
        pixelDensity(density?: number): void;

        /**
         *   Gets or sets whether or not this framebuffer will
         *   automatically resize along with the canvas it's
         *   attached to in order to match its size. Call this
         *   method with no arguments to see if it is currently
         *   auto-sized, or pass in a boolean to set this
         *   property.
         *   @param [autoSized] Whether or not the framebuffer
         *   should resize along with the canvas it's attached
         *   to
         */
        autoSized(autoSized?: boolean): void;

        /**
         *   Creates and returns a new p5.FramebufferCamera to
         *   be used while drawing to this framebuffer. The
         *   camera will be set as the currently active camera.
         *   @return A new camera
         */
        createCamera(): Camera;

        /**
         *   Removes the framebuffer and frees its resources.
         */
        remove(): void;

        /**
         *   Begin drawing to this framebuffer. Subsequent
         *   drawing functions to the canvas the framebuffer is
         *   attached to will not be immediately visible, and
         *   will instead be drawn to the framebuffer's
         *   texture. Call end() when finished to make draw
         *   functions go right to the canvas again and to be
         *   able to read the contents of the framebuffer's
         *   texture.
         */
        begin(): void;

        /**
         *   After having previously called begin(), this
         *   method stops drawing functions from going to the
         *   framebuffer's texture, allowing them to go right
         *   to the canvas again. After this, one can read from
         *   the framebuffer's texture.
         */
        end(): void;

        /**
         *   Run a function while drawing to the framebuffer
         *   rather than to its canvas. This is equivalent to
         *   calling framebuffer.begin(), running the function,
         *   and then calling framebuffer.end(), but ensures
         *   that one never accidentally forgets begin or end.
         *   @param callback A function to run that draws to
         *   the canvas. The function will immediately be run,
         *   but it will draw to the framebuffer instead of the
         *   canvas.
         */
        draw(callback: (...args: any[]) => any): void;

        /**
         *   Get a region of pixels from the canvas in the form
         *   of a p5.Image, or a single pixel as an array of
         *   numbers. Returns an array of [R,G,B,A] values for
         *   any pixel or grabs a section of an image. If the
         *   Framebuffer has been set up to not store alpha
         *   values, then only [R,G,B] will be returned. If no
         *   parameters are specified, the entire image is
         *   returned. Use the x and y parameters to get the
         *   value of one pixel. Get a section of the display
         *   window by specifying additional w and h
         *   parameters. When getting an image, the x and y
         *   parameters define the coordinates for the
         *   upper-left corner of the image, regardless of the
         *   current imageMode().
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @param w width of the section to be returned
         *   @param h height of the section to be returned
         *   @return the rectangle p5.Image
         */
        get(x: number, y: number, w: number, h: number): Image;

        /**
         *   Get a region of pixels from the canvas in the form
         *   of a p5.Image, or a single pixel as an array of
         *   numbers. Returns an array of [R,G,B,A] values for
         *   any pixel or grabs a section of an image. If the
         *   Framebuffer has been set up to not store alpha
         *   values, then only [R,G,B] will be returned. If no
         *   parameters are specified, the entire image is
         *   returned. Use the x and y parameters to get the
         *   value of one pixel. Get a section of the display
         *   window by specifying additional w and h
         *   parameters. When getting an image, the x and y
         *   parameters define the coordinates for the
         *   upper-left corner of the image, regardless of the
         *   current imageMode().
         *   @return the whole p5.Image
         */
        get(): Image;

        /**
         *   Get a region of pixels from the canvas in the form
         *   of a p5.Image, or a single pixel as an array of
         *   numbers. Returns an array of [R,G,B,A] values for
         *   any pixel or grabs a section of an image. If the
         *   Framebuffer has been set up to not store alpha
         *   values, then only [R,G,B] will be returned. If no
         *   parameters are specified, the entire image is
         *   returned. Use the x and y parameters to get the
         *   value of one pixel. Get a section of the display
         *   window by specifying additional w and h
         *   parameters. When getting an image, the x and y
         *   parameters define the coordinates for the
         *   upper-left corner of the image, regardless of the
         *   current imageMode().
         *   @param x x-coordinate of the pixel
         *   @param y y-coordinate of the pixel
         *   @return color of pixel at x,y in array format [R,
         *   G, B, A]
         */
        get(x: number, y: number): number[];

        /**
         *   A Uint8ClampedArray containing the values for all
         *   the pixels in the Framebuffer. Like the main
         *   canvas pixels property, call loadPixels() before
         *   reading it, and call updatePixels() afterwards to
         *   update its data.
         *
         *   Note that updating pixels via this property will
         *   be slower than drawing to the framebuffer
         *   directly. Consider using a shader instead of
         *   looping over pixels.
         */
        pixels: number[];

        /**
         *   A texture with the color information of the
         *   framebuffer. Pass this (or the framebuffer itself)
         *   to texture() to draw it to the canvas, or pass it
         *   to a shader with setUniform() to read its data.
         *   Since Framebuffers are controlled by WebGL, their
         *   y coordinates are stored flipped compared to
         *   images and videos. When texturing with a
         *   framebuffer texture, you may want to flip
         *   vertically, e.g. with plane(framebuffer.width,
         *   -framebuffer.height).
         */
        color: any;

        /**
         *   A texture with the depth information of the
         *   framebuffer. If the framebuffer was created with {
         *   depth: false } in its settings, then this property
         *   will be undefined. Pass this to texture() to draw
         *   it to the canvas, or pass it to a shader with
         *   setUniform() to read its data. Since Framebuffers
         *   are controlled by WebGL, their y coordinates are
         *   stored flipped compared to images and videos. When
         *   texturing with a framebuffer texture, you may want
         *   to flip vertically, e.g. with
         *   plane(framebuffer.width, -framebuffer.height).
         */
        depth: any;
    }

// Inlined from: ./src/webgl/p5.Geometry.d.ts

    class Geometry {
        /**
         *   p5 Geometry class
         *
         *   @param [detailX] number of vertices along the
         *   x-axis.
         *   @param [detailY] number of vertices along the
         *   y-axis.
         *   @param [callback] function to call upon object
         *   instantiation.
         */
        constructor(detailX?: number, detailY?: number, callback?: (...args: any[]) => any);

        /**
         *   computes faces for geometry objects based on the
         *   vertices.
         *   @chainable
         */
        computeFaces(): Geometry;

        /**
         *   computes smooth normals per vertex as an average
         *   of each face.
         *   @chainable
         */
        computeNormals(): Geometry;

        /**
         *   Averages the vertex normals. Used in curved
         *   surfaces
         *   @chainable
         */
        averageNormals(): Geometry;

        /**
         *   Averages pole normals. Used in spherical
         *   primitives
         *   @chainable
         */
        averagePoleNormals(): Geometry;

        /**
         *   Modifies all vertices to be centered within the
         *   range -100 to 100.
         *   @chainable
         */
        normalize(): Geometry;
    }

// Inlined from: ./src/webgl/p5.Shader.d.ts

    class Shader {
        // TODO: Fix p5.Shader() errors in src/webgl/p5.Shader.js, line 11:
        //
        //    param "renderer" has invalid type: p5.RendererGL
        //
        // constructor(renderer: RendererGL, vertSrc: string, fragSrc: string);

        /**
         *   Used to set the uniforms of a p5.Shader object.
         *   Uniforms are used as a way to provide shader
         *   programs (which run on the GPU) with values from a
         *   sketch (which runs on the CPU).
         *   @param uniformName the name of the uniform. Must
         *   correspond to the name used in the vertex and
         *   fragment shaders
         *   @param data the data to associate with the
         *   uniform. The type can be a boolean (true/false), a
         *   number, an array of numbers, or an image
         *   (p5.Image, p5.Graphics, p5.MediaElement,
         *   p5.Texture)
         *   @chainable
         */
        setUniform(uniformName: string, data: boolean | number | number[] | Image | Graphics | MediaElement): Shader;
    }

// Inlined from: ./src/core/p5.Renderer.d.ts

    class Renderer extends Element {
        /**
         *   Main graphics and rendering context, as well as
         *   the base API implementation for p5.js "core". To
         *   be used as the superclass for Renderer2D and
         *   Renderer3D classes, respectively.
         *
         *   @param elt DOM node that is wrapped
         *   @param [pInst] pointer to p5 instance
         *   @param [isMainCanvas] whether we're using it as
         *   main canvas
         */
        constructor(elt: HTMLElement, pInst?: p5, isMainCanvas?: boolean);
    }

// Inlined from: ./literals.d.ts

    type ADD = 'lighter';
    type ARROW = 'arrow';
    type AUTO = 'auto';
    type AXES = 'axes';
    type BASELINE = 'alphabetic';
    type BEVEL = 'bevel';
    type BEZIER = 'bezier';
    type BLEND = 'source-over';
    type BLUR = 'blur';
    type BOLD = 'bold';
    type BOLDITALIC = 'bolditalic';
    type BOTTOM = 'bottom';
    type BURN = 'color-burn';
    type CENTER = 'center';
    type CHAR = 'char';
    type CHORD = 'chord';
    type CLAMP = 'clamp';
    type CLOSE = 'close';
    type CONTAIN = 'contain';
    type CORNER = 'corner';
    type CORNERS = 'corners';
    type COVER = 'cover';
    type CROSS = 'cross';
    type CURVE = 'curve';
    type DARKEST = 'darkest';
    type DEGREES = 'degrees';
    type DIFFERENCE = 'difference';
    type DILATE = 'dilate';
    type DODGE = 'color-dodge';
    type ERODE = 'erode';
    type EXCLUSION = 'exclusion';
    type FALLBACK = 'fallback';
    type FILL = 'fill';
    type FLOAT = 'float';
    type GRAY = 'gray';
    type GRID = 'grid';
    type HALF_FLOAT = 'half-float';
    type HAND = 'hand';
    type HARD_LIGHT = 'hard-light';
    type HSB = 'hsb';
    type HSL = 'hsl';
    type IMAGE = 'image';
    type IMMEDIATE = 'immediate';
    type INVERT = 'invert';
    type ITALIC = 'italic';
    type LABEL = 'label';
    type LANDSCAPE = 'landscape';
    type LEFT = 'left';
    type LIGHTEST = 'lighten';
    type LINE_LOOP = 0x0002;
    type LINE_STRIP = 0x0003;
    type LINEAR = 'linear';
    type LINES = 0x0001;
    type MIRROR = 'mirror';
    type MITER = 'miter';
    type MOVE = 'move';
    type MULTIPLY = 'multiply';
    type NEAREST = 'nearest';
    type NORMAL = 'normal';
    type OPAQUE = 'opaque';
    type OPEN = 'open';
    type OVERLAY = 'overlay';
    type P2D = 'p2d';
    type PIE = 'pie';
    type POINTS = 0x0000;
    type PORTRAIT = 'portrait';
    type POSTERIZE = 'posterize';
    type PROJECT = 'square';
    type QUAD_STRIP = 'quad_strip';
    type QUADRATIC = 'quadratic';
    type QUADS = 'quads';
    type RADIANS = 'radians';
    type RADIUS = 'radius';
    type REMOVE = 'destination-out';
    type REPEAT = 'repeat';
    type REPLACE = 'copy';
    type RGB = 'rgb';
    type RGBA = 'rgba';
    type RIGHT = 'right';
    type ROUND = 'round';
    type SCREEN = 'screen';
    type SOFT_LIGHT = 'soft-light';
    type SQUARE = 'butt';
    type STROKE = 'stroke';
    type SUBTRACT = 'subtract';
    type TESS = 'tess';
    type TEXT = 'text';
    type TEXTURE = 'texture';
    type THRESHOLD = 'threshold';
    type TOP = 'top';
    type TRIANGLE_FAN = 0x0006;
    type TRIANGLE_STRIP = 0x0005;
    type TRIANGLES = 0x0004;
    type UNSIGNED_BYTE = 'unsigned-byte';
    type UNSIGNED_INT = 'unsigned-int';
    type VERSION = 'version';
    type WAIT = 'wait';
    type WEBGL = 'webgl';
    type WEBGL2 = 'webgl2';
    type WORD = 'word';
    type VIDEO = 'video';
    type AUDIO = 'audio';

// Inlined from: ./constants.d.ts

    type ANGLE_MODE = RADIANS | DEGREES;

    type ARC_MODE = CHORD | PIE | OPEN;

    type BEGIN_KIND = POINTS | LINES | TRIANGLES | TRIANGLE_FAN | TRIANGLE_STRIP | QUADS | QUAD_STRIP | TESS;

    type BLEND_MODE =
        | BLEND
        | DARKEST
        | LIGHTEST
        | DIFFERENCE
        | MULTIPLY
        | EXCLUSION
        | SCREEN
        | REPLACE
        | OVERLAY
        | HARD_LIGHT
        | SOFT_LIGHT
        | DODGE
        | BURN
        | ADD
        | NORMAL;

    type COLOR_MODE = RGB | HSB | HSL;

    type CURSOR_TYPE = ARROW | CROSS | HAND | MOVE | TEXT;

    type DEBUG_MODE = GRID | AXES;

    type DESCRIBE_DISPLAY = LABEL | FALLBACK;

    type ELLIPSE_MODE = CENTER | RADIUS | CORNER | CORNERS;

    type END_MODE = CLOSE;

    type FILTER_TYPE = THRESHOLD | GRAY | OPAQUE | INVERT | POSTERIZE | ERODE | DILATE | BLUR;

    type GRAPHICS_RENDERER = P2D | WEBGL;

    type GRID_DISPLAY = FALLBACK | LABEL;

    type HORIZ_ALIGN = LEFT | CENTER | RIGHT;

    type IMAGE_FIT = CONTAIN | COVER;

    type IMAGE_MODE = CORNER | CORNERS | CENTER;

    type RECT_MODE = CORNER | CORNERS | CENTER | RADIUS;

    type RENDERER = P2D | WEBGL;

    type SIZE_H = AUTO;

    type SIZE_W = AUTO;

    type STROKE_CAP = ROUND | SQUARE | PROJECT;

    type STROKE_JOIN = MITER | BEVEL | ROUND;

    type TEXT_DISPLAY = FALLBACK | LABEL;

    type TEXTURE_MODE = IMAGE | NORMAL;

    type THE_STYLE = NORMAL | ITALIC | BOLD | BOLDITALIC;

    type TYPE = VIDEO | AUDIO;

    type VERT_ALIGN = TOP | BOTTOM | CENTER | BASELINE;

    type WRAP_STYLE = WORD | CHAR;

    type WRAP_X = CLAMP | REPEAT | MIRROR;

    type WRAP_Y = CLAMP | REPEAT | MIRROR;

    type X_ALIGN = LEFT | RIGHT | CENTER;

    type Y_ALIGN = TOP | BOTTOM | CENTER;

export = p5;
declare class p5 {
    /**
     *   This is the p5 instance constructor. A p5 instance
     *   holds all the properties and methods related to a
     *   p5 sketch. It expects an incoming sketch closure
     *   and it can also take an optional node parameter
     *   for attaching the generated p5 canvas to a node.
     *   The sketch closure takes the newly created p5
     *   instance as its sole argument and may optionally
     *   set preload(), setup(), and/or draw() properties
     *   on it for running a sketch.
     *
     *   A p5 sketch can run in "global" or "instance"
     *   mode: "global" - all properties and methods are
     *   attached to the window "instance" - all properties
     *   and methods are bound to this p5 object
     *
     *   @param sketch a closure that can set optional
     *   preload(), setup(), and/or draw() properties on
     *   the given p5 instance
     *   @param [node] element to attach canvas to
     *   @return a p5 instance
     */
    constructor(sketch: (...args: any[]) => any, node?: HTMLElement);

    /**
     *   Called directly before setup(), the preload()
     *   function is used to handle asynchronous loading of
     *   external files in a blocking way. If a preload
     *   function is defined, setup() will wait until any
     *   load calls within have finished. Nothing besides
     *   load calls (loadImage, loadJSON, loadFont,
     *   loadStrings, etc.) should be inside the preload
     *   function. If asynchronous loading is preferred,
     *   the load methods can instead be called in setup()
     *   or anywhere else with the use of a callback
     *   parameter. By default the text "loading..." will
     *   be displayed. To make your own loading page,
     *   include an HTML element with id "p5_loading" in
     *   your page. More information here.
     */
    preload(): void;

    /**
     *   The setup() function is called once when the
     *   program starts. It's used to define initial
     *   environment properties such as screen size and
     *   background color and to load media such as images
     *   and fonts as the program starts. There can only be
     *   one setup() function for each program and it
     *   shouldn't be called again after its initial
     *   execution. Note: Variables declared within setup()
     *   are not accessible within other functions,
     *   including draw().
     */
    setup(): void;

    /**
     *   Called directly after setup(), the draw() function
     *   continuously executes the lines of code contained
     *   inside its block until the program is stopped or
     *   noLoop() is called. Note if noLoop() is called in
     *   setup(), draw() will still be executed once before
     *   stopping. draw() is called automatically and
     *   should never be called explicitly. It should
     *   always be controlled with noLoop(), redraw() and
     *   loop(). After noLoop() stops the code in draw()
     *   from executing, redraw() causes the code inside
     *   draw() to execute once, and loop() will cause the
     *   code inside draw() to resume executing
     *   continuously.
     *
     *   The number of times draw() executes in each second
     *   may be controlled with the frameRate() function.
     *
     *   There can only be one draw() function for each
     *   sketch, and draw() must exist if you want the code
     *   to run continuously, or to process events such as
     *   mousePressed(). Sometimes, you might have an empty
     *   call to draw() in your program, as shown in the
     *   above example.
     *
     *   It is important to note that the drawing
     *   coordinate system will be reset at the beginning
     *   of each draw() call. If any transformations are
     *   performed within draw() (ex: scale, rotate,
     *   translate), their effects will be undone at the
     *   beginning of draw(), so transformations will not
     *   accumulate over time. On the other hand, styling
     *   applied (ex: fill, stroke, etc) will remain in
     *   effect.
     */
    draw(): void;

    /**
     *   Removes the entire p5 sketch. This will remove the
     *   canvas and any elements created by p5.js. It will
     *   also stop the draw loop and unbind any properties
     *   or methods from the window global scope. It will
     *   leave a variable p5 in case you wanted to create a
     *   new p5 sketch. If you like, you can set p5 = null
     *   to erase it. While all functions and variables and
     *   objects created by the p5 library will be removed,
     *   any other global variables created by your code
     *   will remain.
     */
    remove(): void;

    /**
     *   Turn off some features of the friendly error
     *   system (FES), which can give a significant boost
     *   to performance when needed. Note that this will
     *   disable the parts of the FES that cause
     *   performance slowdown (like argument checking).
     *   Friendly errors that have no performance cost
     *   (like giving a descriptive error if a file load
     *   fails, or warning you if you try to override p5.js
     *   functions in the global space), will remain in
     *   place.
     *
     *   See  disabling the friendly error system.
     */
    disableFriendlyErrors: boolean;
}

// eslint-disable-next-line @typescript-eslint/no-empty-interface
interface p5 extends p5.p5InstanceExtensions {}

declare namespace p5 {
    type UNKNOWN_P5_CONSTANT = any;
    // eslint-disable-next-line @typescript-eslint/no-empty-interface
    interface p5InstanceExtensions {}
}


// ============================================================================
// GLOBAL SUPPORT  
// Use: createCanvas(400, 300); // directly available in global scope
// ============================================================================
// Global mode type definitions for p5

// This file was auto-generated. Please do not edit it.

// Reference directive removed

declare global {
    /**
     *   Creates a screen reader accessible description for
     *   the canvas. The first parameter should be a string
     *   with a description of the canvas. The second
     *   parameter is optional. If specified, it determines
     *   how the description is displayed. describe(text,
     *   LABEL) displays the description to all users as a
     *   tombstone or exhibit label/caption in a div
     *   adjacent to the canvas. You can style it as you
     *   wish in your CSS.
     *
     *   describe(text, FALLBACK) makes the description
     *   accessible to screen-reader users only, in  a sub
     *   DOM inside the canvas element. If a second
     *   parameter is not specified, by default, the
     *   description will only be available to
     *   screen-reader users.
     *   @param text description of the canvas
     *   @param [display] either LABEL or FALLBACK
     */
    function describe(text: string, display?: p5.DESCRIBE_DISPLAY): void;

    /**
     *   This function creates a screen-reader accessible
     *   description for elements —shapes or groups of
     *   shapes that create meaning together— in the
     *   canvas. The first paramater should be the name of
     *   the element. The second parameter should be a
     *   string with a description of the element. The
     *   third parameter is optional. If specified, it
     *   determines how the element description is
     *   displayed. describeElement(name, text, LABEL)
     *   displays the element description to all users as a
     *   tombstone or exhibit label/caption in a div
     *   adjacent to the canvas. You can style it as you
     *   wish in your CSS.
     *
     *   describeElement(name, text, FALLBACK) makes the
     *   element description accessible to screen-reader
     *   users only, in  a sub DOM inside the canvas
     *   element. If a second parameter is not specified,
     *   by default, the element description will only be
     *   available to screen-reader users.
     *   @param name name of the element
     *   @param text description of the element
     *   @param [display] either LABEL or FALLBACK
     */
    function describeElement(name: string, text: string, display?: p5.DESCRIBE_DISPLAY): void;

    /**
     *   textOutput() creates a screenreader accessible
     *   output that describes the shapes present on the
     *   canvas. The general description of the canvas
     *   includes canvas size, canvas color, and number of
     *   elements in the canvas (example: 'Your output is
     *   a, 400 by 400 pixels, lavender blue canvas
     *   containing the following 4 shapes:'). This
     *   description is followed by a list of shapes where
     *   the color, position, and area of each shape are
     *   described (example: "orange ellipse at top left
     *   covering 1% of the canvas"). Each element can be
     *   selected to get more details. A table of elements
     *   is also provided. In this table, shape, color,
     *   location, coordinates and area are described
     *   (example: "orange ellipse location=top left
     *   area=2"). textOutput() and textOutput(FALLBACK)
     *   make the output available in  a sub DOM inside the
     *   canvas element which is accessible to screen
     *   readers. textOutput(LABEL) creates an additional
     *   div with the output adjacent to the canvas, this
     *   is useful for non-screen reader users that might
     *   want to display the output outside of the canvas'
     *   sub DOM as they code. However, using LABEL will
     *   create unnecessary redundancy for screen reader
     *   users. We recommend using LABEL only as part of
     *   the development process of a sketch and removing
     *   it before publishing or sharing with screen reader
     *   users.
     *   @param [display] either FALLBACK or LABEL
     */
    function textOutput(display?: p5.TEXT_DISPLAY): void;

    /**
     *   gridOutput() lays out the content of the canvas in
     *   the form of a grid (html table) based on the
     *   spatial location of each shape. A brief
     *   description of the canvas is available before the
     *   table output. This description includes: color of
     *   the background, size of the canvas, number of
     *   objects, and object types (example: "lavender blue
     *   canvas is 200 by 200 and contains 4 objects - 3
     *   ellipses 1 rectangle"). The grid describes the
     *   content spatially, each element is placed on a
     *   cell of the table depending on its position.
     *   Within each cell an element the color and type of
     *   shape of that element are available (example:
     *   "orange ellipse"). These descriptions can be
     *   selected individually to get more details. A list
     *   of elements where shape, color, location, and area
     *   are described (example: "orange ellipse
     *   location=top left area=1%") is also available.
     *   gridOutput() and gridOutput(FALLBACK) make the
     *   output available in  a sub DOM inside the canvas
     *   element which is accessible to screen readers.
     *   gridOutput(LABEL) creates an additional div with
     *   the output adjacent to the canvas, this is useful
     *   for non-screen reader users that might want to
     *   display the output outside of the canvas' sub DOM
     *   as they code. However, using LABEL will create
     *   unnecessary redundancy for screen reader users. We
     *   recommend using LABEL only as part of the
     *   development process of a sketch and removing it
     *   before publishing or sharing with screen reader
     *   users.
     *   @param [display] either FALLBACK or LABEL
     */
    function gridOutput(display?: p5.GRID_DISPLAY): void;

    /**
     *   Extracts the alpha (transparency) value from a
     *   p5.Color object, array of color components, or CSS
     *   color string.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the alpha value.
     */
    function alpha(color: p5.Color | number[] | string): number;

    /**
     *   Extracts the blue value from a p5.Color object,
     *   array of color components, or CSS color string.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the blue value.
     */
    function blue(color: p5.Color | number[] | string): number;

    /**
     *   Extracts the HSB brightness value from a p5.Color
     *   object, array of color components, or CSS color
     *   string.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the brightness value.
     */
    function brightness(color: p5.Color | number[] | string): number;

    /**
     *   Creates a p5.Color object. By default, the
     *   parameters are interpreted as RGB values. Calling
     *   color(255, 204, 0) will return a bright yellow
     *   color. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of color() with one parameter interprets
     *   the value one of two ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string.
     *
     *   The version of color() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of color() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of color() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param gray number specifying value between white
     *   and black.
     *   @param [alpha] alpha value relative to current
     *   color range (default is 0-255).
     *   @return resulting color.
     */
    function color(gray: number, alpha?: number): p5.Color;

    /**
     *   Creates a p5.Color object. By default, the
     *   parameters are interpreted as RGB values. Calling
     *   color(255, 204, 0) will return a bright yellow
     *   color. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of color() with one parameter interprets
     *   the value one of two ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string.
     *
     *   The version of color() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of color() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of color() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param v1 red or hue value relative to the current
     *   color range.
     *   @param v2 green or saturation value relative to
     *   the current color range.
     *   @param v3 blue or brightness value relative to the
     *   current color range.
     *   @param [alpha] alpha value relative to current
     *   color range (default is 0-255).
     */
    function color(v1: number, v2: number, v3: number, alpha?: number): p5.Color;

    /**
     *   Creates a p5.Color object. By default, the
     *   parameters are interpreted as RGB values. Calling
     *   color(255, 204, 0) will return a bright yellow
     *   color. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of color() with one parameter interprets
     *   the value one of two ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string.
     *
     *   The version of color() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of color() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of color() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param value a color string.
     */
    function color(value: string): p5.Color;

    /**
     *   Creates a p5.Color object. By default, the
     *   parameters are interpreted as RGB values. Calling
     *   color(255, 204, 0) will return a bright yellow
     *   color. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of color() with one parameter interprets
     *   the value one of two ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string.
     *
     *   The version of color() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of color() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of color() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param values an array containing the red, green,
     *   blue, and alpha components of the color.
     */
    function color(values: number[]): p5.Color;

    /**
     *   Creates a p5.Color object. By default, the
     *   parameters are interpreted as RGB values. Calling
     *   color(255, 204, 0) will return a bright yellow
     *   color. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of color() with one parameter interprets
     *   the value one of two ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string.
     *
     *   The version of color() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of color() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of color() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     */
    function color(color: p5.Color): p5.Color;

    /**
     *   Extracts the green value from a p5.Color object,
     *   array of color components, or CSS color string.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the green value.
     */
    function green(color: p5.Color | number[] | string): number;

    /**
     *   Extracts the hue value from a p5.Color object,
     *   array of color components, or CSS color string.
     *   Hue exists in both HSB and HSL. It describes a
     *   color's position on the color wheel. By default,
     *   this function returns the HSL-normalized hue. If
     *   the colorMode() is set to HSB, it returns the
     *   HSB-normalized hue.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the hue
     */
    function hue(color: p5.Color | number[] | string): number;

    /**
     *   Blends two colors to find a third color between
     *   them. The amt parameter specifies the amount to
     *   interpolate between the two values. 0 is equal to
     *   the first color, 0.1 is very near the first color,
     *   0.5 is halfway between the two colors, and so on.
     *   Negative numbers are set to 0. Numbers greater
     *   than 1 are set to 1. This differs from the
     *   behavior of lerp. It's necessary because numbers
     *   outside of the interval [0, 1] will produce
     *   strange and unexpected colors. The way that colors
     *   are interpolated depends on the current
     *   colorMode().
     *   @param c1 interpolate from this color.
     *   @param c2 interpolate to this color.
     *   @param amt number between 0 and 1.
     *   @return interpolated color.
     */
    function lerpColor(c1: p5.Color, c2: p5.Color, amt: number): p5.Color;

    /**
     *   Extracts the HSL lightness value from a p5.Color
     *   object, array of color components, or CSS color
     *   string.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the lightness
     */
    function lightness(color: p5.Color | number[] | string): number;

    /**
     *   Extracts the red value from a p5.Color object,
     *   array of color components, or CSS color string.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the red value.
     */
    function red(color: p5.Color | number[] | string): number;

    /**
     *   Extracts the saturation value from a p5.Color
     *   object, array of color components, or CSS color
     *   string. Saturation is scaled differently in HSB
     *   and HSL. By default, this function returns the HSL
     *   saturation. If the colorMode() is set to HSB, it
     *   returns the HSB saturation.
     *   @param color p5.Color object, array of color
     *   components, or CSS color string.
     *   @return the saturation value
     */
    function saturation(color: p5.Color | number[] | string): number;

    /**
     *   Sets the color used for the background of the
     *   canvas. By default, the background is transparent.
     *   This function is typically used within draw() to
     *   clear the display window at the beginning of each
     *   frame. It can also be used inside setup() to set
     *   the background on the first frame of animation.
     *   The version of background() with one parameter
     *   interprets the value one of four ways. If the
     *   parameter is a number, it's interpreted as a
     *   grayscale value. If the parameter is a string,
     *   it's interpreted as a CSS color string. RGB, RGBA,
     *   HSL, HSLA, hex, and named color strings are
     *   supported. If the parameter is a p5.Color object,
     *   it will be used as the background color. If the
     *   parameter is a p5.Image object, it will be used as
     *   the background image.
     *
     *   The version of background() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of background() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). By default,
     *   colors are specified in RGB values. Calling
     *   background(255, 204, 0) sets the background a
     *   bright yellow color.
     *   @param color any value created by the color()
     *   function
     *   @chainable
     */
    function background(color: p5.Color): p5;

    /**
     *   Sets the color used for the background of the
     *   canvas. By default, the background is transparent.
     *   This function is typically used within draw() to
     *   clear the display window at the beginning of each
     *   frame. It can also be used inside setup() to set
     *   the background on the first frame of animation.
     *   The version of background() with one parameter
     *   interprets the value one of four ways. If the
     *   parameter is a number, it's interpreted as a
     *   grayscale value. If the parameter is a string,
     *   it's interpreted as a CSS color string. RGB, RGBA,
     *   HSL, HSLA, hex, and named color strings are
     *   supported. If the parameter is a p5.Color object,
     *   it will be used as the background color. If the
     *   parameter is a p5.Image object, it will be used as
     *   the background image.
     *
     *   The version of background() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of background() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). By default,
     *   colors are specified in RGB values. Calling
     *   background(255, 204, 0) sets the background a
     *   bright yellow color.
     *   @param colorstring color string, possible formats
     *   include: integer rgb() or rgba(), percentage rgb()
     *   or rgba(), 3-digit hex, 6-digit hex.
     *   @param [a] opacity of the background relative to
     *   current color range (default is 0-255).
     *   @chainable
     */
    function background(colorstring: string, a?: number): p5;

    /**
     *   Sets the color used for the background of the
     *   canvas. By default, the background is transparent.
     *   This function is typically used within draw() to
     *   clear the display window at the beginning of each
     *   frame. It can also be used inside setup() to set
     *   the background on the first frame of animation.
     *   The version of background() with one parameter
     *   interprets the value one of four ways. If the
     *   parameter is a number, it's interpreted as a
     *   grayscale value. If the parameter is a string,
     *   it's interpreted as a CSS color string. RGB, RGBA,
     *   HSL, HSLA, hex, and named color strings are
     *   supported. If the parameter is a p5.Color object,
     *   it will be used as the background color. If the
     *   parameter is a p5.Image object, it will be used as
     *   the background image.
     *
     *   The version of background() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of background() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). By default,
     *   colors are specified in RGB values. Calling
     *   background(255, 204, 0) sets the background a
     *   bright yellow color.
     *   @param gray specifies a value between white and
     *   black.
     *   @param [a] opacity of the background relative to
     *   current color range (default is 0-255).
     *   @chainable
     */
    function background(gray: number, a?: number): p5;

    /**
     *   Sets the color used for the background of the
     *   canvas. By default, the background is transparent.
     *   This function is typically used within draw() to
     *   clear the display window at the beginning of each
     *   frame. It can also be used inside setup() to set
     *   the background on the first frame of animation.
     *   The version of background() with one parameter
     *   interprets the value one of four ways. If the
     *   parameter is a number, it's interpreted as a
     *   grayscale value. If the parameter is a string,
     *   it's interpreted as a CSS color string. RGB, RGBA,
     *   HSL, HSLA, hex, and named color strings are
     *   supported. If the parameter is a p5.Color object,
     *   it will be used as the background color. If the
     *   parameter is a p5.Image object, it will be used as
     *   the background image.
     *
     *   The version of background() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of background() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). By default,
     *   colors are specified in RGB values. Calling
     *   background(255, 204, 0) sets the background a
     *   bright yellow color.
     *   @param v1 red value if color mode is RGB, or hue
     *   value if color mode is HSB.
     *   @param v2 green value if color mode is RGB, or
     *   saturation value if color mode is HSB.
     *   @param v3 blue value if color mode is RGB, or
     *   brightness value if color mode is HSB.
     *   @param [a] opacity of the background relative to
     *   current color range (default is 0-255).
     *   @chainable
     */
    function background(v1: number, v2: number, v3: number, a?: number): p5;

    /**
     *   Sets the color used for the background of the
     *   canvas. By default, the background is transparent.
     *   This function is typically used within draw() to
     *   clear the display window at the beginning of each
     *   frame. It can also be used inside setup() to set
     *   the background on the first frame of animation.
     *   The version of background() with one parameter
     *   interprets the value one of four ways. If the
     *   parameter is a number, it's interpreted as a
     *   grayscale value. If the parameter is a string,
     *   it's interpreted as a CSS color string. RGB, RGBA,
     *   HSL, HSLA, hex, and named color strings are
     *   supported. If the parameter is a p5.Color object,
     *   it will be used as the background color. If the
     *   parameter is a p5.Image object, it will be used as
     *   the background image.
     *
     *   The version of background() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of background() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). By default,
     *   colors are specified in RGB values. Calling
     *   background(255, 204, 0) sets the background a
     *   bright yellow color.
     *   @param values an array containing the red, green,
     *   blue and alpha components of the color.
     *   @chainable
     */
    function background(values: number[]): p5;

    /**
     *   Sets the color used for the background of the
     *   canvas. By default, the background is transparent.
     *   This function is typically used within draw() to
     *   clear the display window at the beginning of each
     *   frame. It can also be used inside setup() to set
     *   the background on the first frame of animation.
     *   The version of background() with one parameter
     *   interprets the value one of four ways. If the
     *   parameter is a number, it's interpreted as a
     *   grayscale value. If the parameter is a string,
     *   it's interpreted as a CSS color string. RGB, RGBA,
     *   HSL, HSLA, hex, and named color strings are
     *   supported. If the parameter is a p5.Color object,
     *   it will be used as the background color. If the
     *   parameter is a p5.Image object, it will be used as
     *   the background image.
     *
     *   The version of background() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of background() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). By default,
     *   colors are specified in RGB values. Calling
     *   background(255, 204, 0) sets the background a
     *   bright yellow color.
     *   @param image image created with loadImage() or
     *   createImage(), to set as background. (must be same
     *   size as the sketch window).
     *   @param [a] opacity of the background relative to
     *   current color range (default is 0-255).
     *   @chainable
     */
    function background(image: p5.Image, a?: number): p5;

    /**
     *   Clears the pixels on the canvas. This function
     *   makes every pixel 100% transparent. Calling
     *   clear() doesn't clear objects created by createX()
     *   functions such as createGraphics(), createVideo(),
     *   and createImg(). These objects will remain
     *   unchanged after calling clear() and can be
     *   redrawn. In WebGL mode, this function can clear
     *   the screen to a specific color. It interprets four
     *   numeric parameters as normalized RGBA color
     *   values. It also clears the depth buffer. If you
     *   are not using the WebGL renderer, these parameters
     *   will have no effect.
     *   @param r normalized red value.
     *   @param g normalized green value.
     *   @param b normalized blue value.
     *   @param a normalized alpha value.
     *   @chainable
     */
    function clear(r: number, g: number, b: number, a: number): p5;

    /**
     *   Clears the pixels on the canvas. This function
     *   makes every pixel 100% transparent. Calling
     *   clear() doesn't clear objects created by createX()
     *   functions such as createGraphics(), createVideo(),
     *   and createImg(). These objects will remain
     *   unchanged after calling clear() and can be
     *   redrawn. In WebGL mode, this function can clear
     *   the screen to a specific color. It interprets four
     *   numeric parameters as normalized RGBA color
     *   values. It also clears the depth buffer. If you
     *   are not using the WebGL renderer, these parameters
     *   will have no effect.
     *   @chainable
     */
    function clear(): p5;

    /**
     *   Changes the way p5.js interprets color data. By
     *   default, the numeric parameters for fill(),
     *   stroke(), background(), and color() are defined by
     *   values between 0 and 255 using the RGB color
     *   model. This is equivalent to calling
     *   colorMode(RGB, 255). Pure red is color(255, 0, 0)
     *   in this model. Calling colorMode(RGB, 100) sets
     *   colors to be interpreted as RGB color values
     *   between 0 and 100. Pure red is color(100, 0, 0) in
     *   this model.
     *
     *   Calling colorMode(HSB) or colorMode(HSL) changes
     *   to HSB or HSL system instead of RGB.
     *
     *   p5.Color objects remember the mode that they were
     *   created in. Changing modes doesn't affect their
     *   appearance.
     *   @param mode either RGB, HSB or HSL, corresponding
     *   to Red/Green/Blue and Hue/Saturation/Brightness
     *   (or Lightness).
     *   @param [max] range for all values.
     *   @chainable
     */
    function colorMode(mode: p5.COLOR_MODE, max?: number): p5;

    /**
     *   Changes the way p5.js interprets color data. By
     *   default, the numeric parameters for fill(),
     *   stroke(), background(), and color() are defined by
     *   values between 0 and 255 using the RGB color
     *   model. This is equivalent to calling
     *   colorMode(RGB, 255). Pure red is color(255, 0, 0)
     *   in this model. Calling colorMode(RGB, 100) sets
     *   colors to be interpreted as RGB color values
     *   between 0 and 100. Pure red is color(100, 0, 0) in
     *   this model.
     *
     *   Calling colorMode(HSB) or colorMode(HSL) changes
     *   to HSB or HSL system instead of RGB.
     *
     *   p5.Color objects remember the mode that they were
     *   created in. Changing modes doesn't affect their
     *   appearance.
     *   @param mode either RGB, HSB or HSL, corresponding
     *   to Red/Green/Blue and Hue/Saturation/Brightness
     *   (or Lightness).
     *   @param max1 range for the red or hue depending on
     *   the current color mode.
     *   @param max2 range for the green or saturation
     *   depending on the current color mode.
     *   @param max3 range for the blue or
     *   brightness/lightness depending on the current
     *   color mode.
     *   @param [maxA] range for the alpha.
     *   @chainable
     */
    function colorMode(mode: p5.UNKNOWN_P5_CONSTANT, max1: number, max2: number, max3: number, maxA?: number): p5;

    /**
     *   Sets the color used to fill shapes. Calling
     *   fill(255, 165, 0) or fill('orange') means all
     *   shapes drawn after the fill command will be filled
     *   with the color orange. The version of fill() with
     *   one parameter interprets the value one of three
     *   ways. If the parameter is a number, it's
     *   interpreted as a grayscale value. If the parameter
     *   is a string, it's interpreted as a CSS color
     *   string. A p5.Color object can also be provided to
     *   set the fill color.
     *
     *   The version of fill() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). The default
     *   color space is RGB, with each value in the range
     *   from 0 to 255.
     *   @param v1 red value if color mode is RGB or hue
     *   value if color mode is HSB.
     *   @param v2 green value if color mode is RGB or
     *   saturation value if color mode is HSB.
     *   @param v3 blue value if color mode is RGB or
     *   brightness value if color mode is HSB.
     *   @chainable
     */
    function fill(v1: number, v2: number, v3: number, alpha?: number): p5;

    /**
     *   Sets the color used to fill shapes. Calling
     *   fill(255, 165, 0) or fill('orange') means all
     *   shapes drawn after the fill command will be filled
     *   with the color orange. The version of fill() with
     *   one parameter interprets the value one of three
     *   ways. If the parameter is a number, it's
     *   interpreted as a grayscale value. If the parameter
     *   is a string, it's interpreted as a CSS color
     *   string. A p5.Color object can also be provided to
     *   set the fill color.
     *
     *   The version of fill() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). The default
     *   color space is RGB, with each value in the range
     *   from 0 to 255.
     *   @param value a color string.
     *   @chainable
     */
    function fill(value: string): p5;

    /**
     *   Sets the color used to fill shapes. Calling
     *   fill(255, 165, 0) or fill('orange') means all
     *   shapes drawn after the fill command will be filled
     *   with the color orange. The version of fill() with
     *   one parameter interprets the value one of three
     *   ways. If the parameter is a number, it's
     *   interpreted as a grayscale value. If the parameter
     *   is a string, it's interpreted as a CSS color
     *   string. A p5.Color object can also be provided to
     *   set the fill color.
     *
     *   The version of fill() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). The default
     *   color space is RGB, with each value in the range
     *   from 0 to 255.
     *   @param gray a grayscale value.
     *   @chainable
     */
    function fill(gray: number, alpha?: number): p5;

    /**
     *   Sets the color used to fill shapes. Calling
     *   fill(255, 165, 0) or fill('orange') means all
     *   shapes drawn after the fill command will be filled
     *   with the color orange. The version of fill() with
     *   one parameter interprets the value one of three
     *   ways. If the parameter is a number, it's
     *   interpreted as a grayscale value. If the parameter
     *   is a string, it's interpreted as a CSS color
     *   string. A p5.Color object can also be provided to
     *   set the fill color.
     *
     *   The version of fill() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). The default
     *   color space is RGB, with each value in the range
     *   from 0 to 255.
     *   @param values an array containing the red, green,
     *   blue & and alpha components of the color.
     *   @chainable
     */
    function fill(values: number[]): p5;

    /**
     *   Sets the color used to fill shapes. Calling
     *   fill(255, 165, 0) or fill('orange') means all
     *   shapes drawn after the fill command will be filled
     *   with the color orange. The version of fill() with
     *   one parameter interprets the value one of three
     *   ways. If the parameter is a number, it's
     *   interpreted as a grayscale value. If the parameter
     *   is a string, it's interpreted as a CSS color
     *   string. A p5.Color object can also be provided to
     *   set the fill color.
     *
     *   The version of fill() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode(). The default
     *   color space is RGB, with each value in the range
     *   from 0 to 255.
     *   @param color the fill color.
     *   @chainable
     */
    function fill(color: p5.Color): p5;

    /**
     *   Disables setting the interior color of shapes.
     *   This is the same as making the fill completely
     *   transparent. If both noStroke() and noFill() are
     *   called, nothing will be drawn to the screen.
     *   @chainable
     */
    function noFill(): p5;

    /**
     *   Disables drawing the stroke (outline). If both
     *   noStroke() and noFill() are called, nothing will
     *   be drawn to the screen.
     *   @chainable
     */
    function noStroke(): p5;

    /**
     *   Sets the color used to draw lines and borders
     *   around shapes. Calling stroke(255, 165, 0) or
     *   stroke('orange') means all shapes drawn after the
     *   stroke() command will be filled with the color
     *   orange. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of stroke() with one parameter interprets
     *   the value one of three ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string. A p5.Color object can also be
     *   provided to set the stroke color.
     *
     *   The version of stroke() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of stroke() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of stroke() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param v1 red value if color mode is RGB or hue
     *   value if color mode is HSB.
     *   @param v2 green value if color mode is RGB or
     *   saturation value if color mode is HSB.
     *   @param v3 blue value if color mode is RGB or
     *   brightness value if color mode is HSB.
     *   @chainable
     */
    function stroke(v1: number, v2: number, v3: number, alpha?: number): p5;

    /**
     *   Sets the color used to draw lines and borders
     *   around shapes. Calling stroke(255, 165, 0) or
     *   stroke('orange') means all shapes drawn after the
     *   stroke() command will be filled with the color
     *   orange. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of stroke() with one parameter interprets
     *   the value one of three ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string. A p5.Color object can also be
     *   provided to set the stroke color.
     *
     *   The version of stroke() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of stroke() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of stroke() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param value a color string.
     *   @chainable
     */
    function stroke(value: string): p5;

    /**
     *   Sets the color used to draw lines and borders
     *   around shapes. Calling stroke(255, 165, 0) or
     *   stroke('orange') means all shapes drawn after the
     *   stroke() command will be filled with the color
     *   orange. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of stroke() with one parameter interprets
     *   the value one of three ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string. A p5.Color object can also be
     *   provided to set the stroke color.
     *
     *   The version of stroke() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of stroke() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of stroke() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param gray a grayscale value.
     *   @chainable
     */
    function stroke(gray: number, alpha?: number): p5;

    /**
     *   Sets the color used to draw lines and borders
     *   around shapes. Calling stroke(255, 165, 0) or
     *   stroke('orange') means all shapes drawn after the
     *   stroke() command will be filled with the color
     *   orange. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of stroke() with one parameter interprets
     *   the value one of three ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string. A p5.Color object can also be
     *   provided to set the stroke color.
     *
     *   The version of stroke() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of stroke() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of stroke() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param values an array containing the red, green,
     *   blue, and alpha components of the color.
     *   @chainable
     */
    function stroke(values: number[]): p5;

    /**
     *   Sets the color used to draw lines and borders
     *   around shapes. Calling stroke(255, 165, 0) or
     *   stroke('orange') means all shapes drawn after the
     *   stroke() command will be filled with the color
     *   orange. The way these parameters are interpreted
     *   may be changed with the colorMode() function. The
     *   version of stroke() with one parameter interprets
     *   the value one of three ways. If the parameter is a
     *   number, it's interpreted as a grayscale value. If
     *   the parameter is a string, it's interpreted as a
     *   CSS color string. A p5.Color object can also be
     *   provided to set the stroke color.
     *
     *   The version of stroke() with two parameters
     *   interprets the first one as a grayscale value. The
     *   second parameter sets the alpha (transparency)
     *   value.
     *
     *   The version of stroke() with three parameters
     *   interprets them as RGB, HSB, or HSL colors,
     *   depending on the current colorMode().
     *
     *   The version of stroke() with four parameters
     *   interprets them as RGBA, HSBA, or HSLA colors,
     *   depending on the current colorMode(). The last
     *   parameter sets the alpha (transparency) value.
     *   @param color the stroke color.
     *   @chainable
     */
    function stroke(color: p5.Color): p5;

    /**
     *   All drawing that follows erase() will subtract
     *   from the canvas, revealing the web page
     *   underneath. The erased areas will become
     *   transparent, allowing the content behind the
     *   canvas to show through. The fill(), stroke(), and
     *   blendMode() have no effect once erase() is called.
     *   The erase() function has two optional parameters.
     *   The first parameter sets the strength of erasing
     *   by the shape's interior. A value of 0 means that
     *   no erasing will occur. A value of 255 means that
     *   the shape's interior will fully erase the content
     *   underneath. The default value is 255 (full
     *   strength).
     *
     *   The second parameter sets the strength of erasing
     *   by the shape's edge. A value of 0 means that no
     *   erasing will occur. A value of 255 means that the
     *   shape's edge will fully erase the content
     *   underneath. The default value is 255 (full
     *   strength).
     *
     *   To cancel the erasing effect, use the noErase()
     *   function.
     *
     *   erase() has no effect on drawing done with the
     *   image() and background() functions.
     *   @param [strengthFill] a number (0-255) for the
     *   strength of erasing under a shape's interior.
     *   Defaults to 255, which is full strength.
     *   @param [strengthStroke] a number (0-255) for the
     *   strength of erasing under a shape's edge. Defaults
     *   to 255, which is full strength.
     *   @chainable
     */
    function erase(strengthFill?: number, strengthStroke?: number): p5;

    /**
     *   Ends erasing that was started with erase(). The
     *   fill(), stroke(), and blendMode() settings will
     *   return to what they were prior to calling erase().
     *   @chainable
     */
    function noErase(): p5;

    /**
     *   Draws an arc to the canvas. Arcs are drawn along
     *   the outer edge of an ellipse (oval) defined by the
     *   x, y, w, and h parameters. Use the start and stop
     *   parameters to specify the angles (in radians) at
     *   which to draw the arc. Arcs are always drawn
     *   clockwise from start to stop. The origin of the
     *   arc's ellipse may be changed with the
     *   ellipseMode() function. The optional mode
     *   parameter determines the arc's fill style. The
     *   fill modes are a semi-circle (OPEN), a closed
     *   semi-circle (CHORD), or a closed pie segment
     *   (PIE).
     *   @param x x-coordinate of the arc's ellipse.
     *   @param y y-coordinate of the arc's ellipse.
     *   @param w width of the arc's ellipse by default.
     *   @param h height of the arc's ellipse by default.
     *   @param start angle to start the arc, specified in
     *   radians.
     *   @param stop angle to stop the arc, specified in
     *   radians.
     *   @param [mode] optional parameter to determine the
     *   way of drawing the arc. either CHORD, PIE, or
     *   OPEN.
     *   @param [detail] optional parameter for WebGL mode
     *   only. This is to specify the number of vertices
     *   that makes up the perimeter of the arc. Default
     *   value is 25. Won't draw a stroke for a detail of
     *   more than 50.
     *   @chainable
     */
    function arc(
        x: number,
        y: number,
        w: number,
        h: number,
        start: number,
        stop: number,
        mode?: p5.ARC_MODE,
        detail?: number
    ): p5;

    /**
     *   Draws an ellipse (oval) to the canvas. An ellipse
     *   with equal width and height is a circle. By
     *   default, the first two parameters set the location
     *   of the center of the ellipse. The third and fourth
     *   parameters set the shape's width and height,
     *   respectively. The origin may be changed with the
     *   ellipseMode() function. If no height is specified,
     *   the value of width is used for both the width and
     *   height. If a negative height or width is
     *   specified, the absolute value is taken.
     *   @param x x-coordinate of the center of the
     *   ellipse.
     *   @param y y-coordinate of the center of the
     *   ellipse.
     *   @param w width of the ellipse.
     *   @param [h] height of the ellipse.
     *   @chainable
     */
    function ellipse(x: number, y: number, w: number, h?: number): p5;

    /**
     *   Draws an ellipse (oval) to the canvas. An ellipse
     *   with equal width and height is a circle. By
     *   default, the first two parameters set the location
     *   of the center of the ellipse. The third and fourth
     *   parameters set the shape's width and height,
     *   respectively. The origin may be changed with the
     *   ellipseMode() function. If no height is specified,
     *   the value of width is used for both the width and
     *   height. If a negative height or width is
     *   specified, the absolute value is taken.
     *   @param x x-coordinate of the center of the
     *   ellipse.
     *   @param y y-coordinate of the center of the
     *   ellipse.
     *   @param w width of the ellipse.
     *   @param h height of the ellipse.
     *   @param [detail] optional parameter for WebGL mode
     *   only. This is to specify the number of vertices
     *   that makes up the perimeter of the ellipse.
     *   Default value is 25. Won't draw a stroke for a
     *   detail of more than 50.
     */
    function ellipse(x: number, y: number, w: number, h: number, detail?: number): void;

    /**
     *   Draws a circle to the canvas. A circle is a round
     *   shape. Every point on the edge of a circle is the
     *   same distance from its center. By default, the
     *   first two parameters set the location of the
     *   center of the circle. The third parameter sets the
     *   shape's width and height (diameter). The origin
     *   may be changed with the ellipseMode() function.
     *   @param x x-coordinate of the center of the circle.
     *   @param y y-coordinate of the center of the circle.
     *   @param d diameter of the circle.
     *   @chainable
     */
    function circle(x: number, y: number, d: number): p5;

    /**
     *   Draws a line, a straight path between two points.
     *   Its default width is one pixel. The version of
     *   line() with four parameters draws the line in 2D.
     *   To color a line, use the stroke() function. To
     *   change its width, use the strokeWeight() function.
     *   A line can't be filled, so the fill() function
     *   won't affect the color of a line. The version of
     *   line() with six parameters allows the line to be
     *   drawn in 3D space. Doing so requires adding the
     *   WEBGL argument to createCanvas().
     *   @param x1 the x-coordinate of the first point.
     *   @param y1 the y-coordinate of the first point.
     *   @param x2 the x-coordinate of the second point.
     *   @param y2 the y-coordinate of the second point.
     *   @chainable
     */
    function line(x1: number, y1: number, x2: number, y2: number): p5;

    /**
     *   Draws a line, a straight path between two points.
     *   Its default width is one pixel. The version of
     *   line() with four parameters draws the line in 2D.
     *   To color a line, use the stroke() function. To
     *   change its width, use the strokeWeight() function.
     *   A line can't be filled, so the fill() function
     *   won't affect the color of a line. The version of
     *   line() with six parameters allows the line to be
     *   drawn in 3D space. Doing so requires adding the
     *   WEBGL argument to createCanvas().
     *   @param x1 the x-coordinate of the first point.
     *   @param y1 the y-coordinate of the first point.
     *   @param z1 the z-coordinate of the first point.
     *   @param x2 the x-coordinate of the second point.
     *   @param y2 the y-coordinate of the second point.
     *   @param z2 the z-coordinate of the second point.
     *   @chainable
     */
    function line(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): p5;

    /**
     *   Draws a point, a single coordinate in space. Its
     *   default size is one pixel. The first two
     *   parameters are the point's x- and y-coordinates,
     *   respectively. To color a point, use the stroke()
     *   function. To change its size, use the
     *   strokeWeight() function. The version of point()
     *   with three parameters allows the point to be drawn
     *   in 3D space. Doing so requires adding the WEBGL
     *   argument to createCanvas().
     *
     *   The version of point() with one parameter allows
     *   the point's location to be set with a p5.Vector
     *   object.
     *   @param x the x-coordinate.
     *   @param y the y-coordinate.
     *   @param [z] the z-coordinate (for WebGL mode).
     *   @chainable
     */
    function point(x: number, y: number, z?: number): p5;

    /**
     *   Draws a point, a single coordinate in space. Its
     *   default size is one pixel. The first two
     *   parameters are the point's x- and y-coordinates,
     *   respectively. To color a point, use the stroke()
     *   function. To change its size, use the
     *   strokeWeight() function. The version of point()
     *   with three parameters allows the point to be drawn
     *   in 3D space. Doing so requires adding the WEBGL
     *   argument to createCanvas().
     *
     *   The version of point() with one parameter allows
     *   the point's location to be set with a p5.Vector
     *   object.
     *   @param coordinateVector the coordinate vector.
     *   @chainable
     */
    function point(coordinateVector: p5.Vector): p5;

    /**
     *   Draws a quad to the canvas. A quad is a
     *   quadrilateral, a four-sided polygon. Some examples
     *   of quads include rectangles, squares, rhombuses,
     *   and trapezoids. The first pair of parameters
     *   (x1,y1) sets the quad's first point. The following
     *   pairs of parameters set the coordinates for its
     *   next three points. Parameters should proceed
     *   clockwise or counter-clockwise around the shape.
     *   The version of quad() with twelve parameters
     *   allows the quad to be drawn in 3D space. Doing so
     *   requires adding the WEBGL argument to
     *   createCanvas().
     *   @param x1 the x-coordinate of the first point.
     *   @param y1 the y-coordinate of the first point.
     *   @param x2 the x-coordinate of the second point.
     *   @param y2 the y-coordinate of the second point.
     *   @param x3 the x-coordinate of the third point.
     *   @param y3 the y-coordinate of the third point.
     *   @param x4 the x-coordinate of the fourth point.
     *   @param y4 the y-coordinate of the fourth point.
     *   @param [detailX] number of segments in the
     *   x-direction.
     *   @param [detailY] number of segments in the
     *   y-direction.
     *   @chainable
     */
    function quad(
        x1: number,
        y1: number,
        x2: number,
        y2: number,
        x3: number,
        y3: number,
        x4: number,
        y4: number,
        detailX?: number,
        detailY?: number
    ): p5;

    /**
     *   Draws a quad to the canvas. A quad is a
     *   quadrilateral, a four-sided polygon. Some examples
     *   of quads include rectangles, squares, rhombuses,
     *   and trapezoids. The first pair of parameters
     *   (x1,y1) sets the quad's first point. The following
     *   pairs of parameters set the coordinates for its
     *   next three points. Parameters should proceed
     *   clockwise or counter-clockwise around the shape.
     *   The version of quad() with twelve parameters
     *   allows the quad to be drawn in 3D space. Doing so
     *   requires adding the WEBGL argument to
     *   createCanvas().
     *   @param x1 the x-coordinate of the first point.
     *   @param y1 the y-coordinate of the first point.
     *   @param z1 the z-coordinate of the first point.
     *   @param x2 the x-coordinate of the second point.
     *   @param y2 the y-coordinate of the second point.
     *   @param z2 the z-coordinate of the second point.
     *   @param x3 the x-coordinate of the third point.
     *   @param y3 the y-coordinate of the third point.
     *   @param z3 the z-coordinate of the third point.
     *   @param x4 the x-coordinate of the fourth point.
     *   @param y4 the y-coordinate of the fourth point.
     *   @param z4 the z-coordinate of the fourth point.
     *   @param [detailX] number of segments in the
     *   x-direction.
     *   @param [detailY] number of segments in the
     *   y-direction.
     *   @chainable
     */
    function quad(
        x1: number,
        y1: number,
        z1: number,
        x2: number,
        y2: number,
        z2: number,
        x3: number,
        y3: number,
        z3: number,
        x4: number,
        y4: number,
        z4: number,
        detailX?: number,
        detailY?: number
    ): p5;

    /**
     *   Draws a rectangle to the canvas. A rectangle is a
     *   four-sided polygon with every angle at ninety
     *   degrees. By default, the first two parameters set
     *   the location of the rectangle's upper-left corner.
     *   The third and fourth set the shape's the width and
     *   height, respectively. The way these parameters are
     *   interpreted may be changed with the rectMode()
     *   function. The version of rect() with five
     *   parameters creates a rounded rectangle. The fifth
     *   parameter is used as the radius value for all four
     *   corners.
     *
     *   The version of rect() with eight parameters also
     *   creates a rounded rectangle. When using eight
     *   parameters, the latter four set the radius of the
     *   arc at each corner separately. The radii start
     *   with the top-left corner and move clockwise around
     *   the rectangle. If any of these parameters are
     *   omitted, they are set to the value of the last
     *   specified corner radius.
     *   @param x x-coordinate of the rectangle.
     *   @param y y-coordinate of the rectangle.
     *   @param w width of the rectangle.
     *   @param [h] height of the rectangle.
     *   @param [tl] optional radius of top-left corner.
     *   @param [tr] optional radius of top-right corner.
     *   @param [br] optional radius of bottom-right
     *   corner.
     *   @param [bl] optional radius of bottom-left corner.
     *   @chainable
     */
    function rect(x: number, y: number, w: number, h?: number, tl?: number, tr?: number, br?: number, bl?: number): p5;

    /**
     *   Draws a rectangle to the canvas. A rectangle is a
     *   four-sided polygon with every angle at ninety
     *   degrees. By default, the first two parameters set
     *   the location of the rectangle's upper-left corner.
     *   The third and fourth set the shape's the width and
     *   height, respectively. The way these parameters are
     *   interpreted may be changed with the rectMode()
     *   function. The version of rect() with five
     *   parameters creates a rounded rectangle. The fifth
     *   parameter is used as the radius value for all four
     *   corners.
     *
     *   The version of rect() with eight parameters also
     *   creates a rounded rectangle. When using eight
     *   parameters, the latter four set the radius of the
     *   arc at each corner separately. The radii start
     *   with the top-left corner and move clockwise around
     *   the rectangle. If any of these parameters are
     *   omitted, they are set to the value of the last
     *   specified corner radius.
     *   @param x x-coordinate of the rectangle.
     *   @param y y-coordinate of the rectangle.
     *   @param w width of the rectangle.
     *   @param h height of the rectangle.
     *   @param [detailX] number of segments in the
     *   x-direction (for WebGL mode).
     *   @param [detailY] number of segments in the
     *   y-direction (for WebGL mode).
     *   @chainable
     */
    function rect(x: number, y: number, w: number, h: number, detailX?: number, detailY?: number): p5;

    /**
     *   Draws a square to the canvas. A square is a
     *   four-sided polygon with every angle at ninety
     *   degrees and equal side lengths. By default, the
     *   first two parameters set the location of the
     *   square's upper-left corner. The third parameter
     *   sets its side size. The way these parameters are
     *   interpreted may be changed with the rectMode()
     *   function. The version of square() with four
     *   parameters creates a rounded square. The fourth
     *   parameter is used as the radius value for all four
     *   corners.
     *
     *   The version of square() with seven parameters also
     *   creates a rounded square. When using seven
     *   parameters, the latter four set the radius of the
     *   arc at each corner separately. The radii start
     *   with the top-left corner and move clockwise around
     *   the square. If any of these parameters are
     *   omitted, they are set to the value of the last
     *   specified corner radius.
     *   @param x x-coordinate of the square.
     *   @param y y-coordinate of the square.
     *   @param s side size of the square.
     *   @param [tl] optional radius of top-left corner.
     *   @param [tr] optional radius of top-right corner.
     *   @param [br] optional radius of bottom-right
     *   corner.
     *   @param [bl] optional radius of bottom-left corner.
     *   @chainable
     */
    function square(x: number, y: number, s: number, tl?: number, tr?: number, br?: number, bl?: number): p5;

    /**
     *   Draws a triangle to the canvas. A triangle is a
     *   three-sided polygon. The first two parameters
     *   specify the triangle's first point (x1,y1). The
     *   middle two parameters specify its second point
     *   (x2,y2). And the last two parameters specify its
     *   third point (x3, y3).
     *   @param x1 x-coordinate of the first point.
     *   @param y1 y-coordinate of the first point.
     *   @param x2 x-coordinate of the second point.
     *   @param y2 y-coordinate of the second point.
     *   @param x3 x-coordinate of the third point.
     *   @param y3 y-coordinate of the third point.
     *   @chainable
     */
    function triangle(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number): p5;

    /**
     *   Modifies the location from which ellipses,
     *   circles, and arcs are drawn. By default, the first
     *   two parameters are the x- and y-coordinates of the
     *   shape's center. The next parameters are its width
     *   and height. This is equivalent to calling
     *   ellipseMode(CENTER). ellipseMode(RADIUS) also uses
     *   the first two parameters to set the x- and
     *   y-coordinates of the shape's center. The next
     *   parameters are half of the shapes's width and
     *   height. Calling ellipse(0, 0, 10, 15) draws a
     *   shape with a width of 20 and height of 30.
     *
     *   ellipseMode(CORNER) uses the first two parameters
     *   as the upper-left corner of the shape. The next
     *   parameters are its width and height.
     *
     *   ellipseMode(CORNERS) uses the first two parameters
     *   as the location of one corner of the ellipse's
     *   bounding box. The third and fourth parameters are
     *   the location of the opposite corner.
     *
     *   The argument passed to ellipseMode() must be
     *   written in ALL CAPS because the constants CENTER,
     *   RADIUS, CORNER, and CORNERS are defined this way.
     *   JavaScript is a case-sensitive language.
     *   @param mode either CENTER, RADIUS, CORNER, or
     *   CORNERS
     *   @chainable
     */
    function ellipseMode(mode: p5.ELLIPSE_MODE): p5;

    /**
     *   Draws all geometry with jagged (aliased) edges.
     *   smooth() is active by default in 2D mode. It's
     *   necessary to call noSmooth() to disable smoothing
     *   of geometry, images, and fonts.
     *
     *   In WebGL mode, noSmooth() is active by default.
     *   It's necessary to call smooth() to draw smooth
     *   (antialiased) edges.
     *   @chainable
     */
    function noSmooth(): p5;

    /**
     *   Modifies the location from which rectangles and
     *   squares are drawn. By default, the first two
     *   parameters are the x- and y-coordinates of the
     *   shape's upper-left corner. The next parameters are
     *   its width and height. This is equivalent to
     *   calling rectMode(CORNER). rectMode(CORNERS) also
     *   uses the first two parameters as the location of
     *   one of the corners. The third and fourth
     *   parameters are the location of the opposite
     *   corner.
     *
     *   rectMode(CENTER) uses the first two parameters as
     *   the x- and y-coordinates of the shape's center.
     *   The next parameters are its width and height.
     *
     *   rectMode(RADIUS) also uses the first two
     *   parameters as the x- and y-coordinates of the
     *   shape's center. The next parameters are half of
     *   the shape's width and height.
     *
     *   The argument passed to rectMode() must be written
     *   in ALL CAPS because the constants CENTER, RADIUS,
     *   CORNER, and CORNERS are defined this way.
     *   JavaScript is a case-sensitive language.
     *   @param mode either CORNER, CORNERS, CENTER, or
     *   RADIUS
     *   @chainable
     */
    function rectMode(mode: p5.RECT_MODE): p5;

    /**
     *   Draws all geometry with smooth (anti-aliased)
     *   edges. smooth() will also improve image quality of
     *   resized images. smooth() is active by default in
     *   2D mode. It's necessary to call noSmooth() to
     *   disable smoothing of geometry, images, and fonts.
     *
     *   In WebGL mode, noSmooth() is active by default.
     *   It's necessary to call smooth() to draw smooth
     *   (antialiased) edges.
     *   @chainable
     */
    function smooth(): p5;

    /**
     *   Sets the style for rendering line endings. These
     *   ends are either rounded (ROUND), squared (SQUARE),
     *   or extended (PROJECT). The default cap is ROUND.
     *   The argument passed to strokeCap() must be written
     *   in ALL CAPS because the constants ROUND, SQUARE,
     *   and PROJECT are defined this way. JavaScript is a
     *   case-sensitive language.
     *   @param cap either ROUND, SQUARE, or PROJECT
     *   @chainable
     */
    function strokeCap(cap: p5.STROKE_CAP): p5;

    /**
     *   Sets the style of the joints which connect line
     *   segments. These joints are either mitered (MITER),
     *   beveled (BEVEL), or rounded (ROUND). The default
     *   joint is MITER in 2D mode and ROUND in WebGL mode.
     *   The argument passed to strokeJoin() must be
     *   written in ALL CAPS because the constants MITER,
     *   BEVEL, and ROUND are defined this way. JavaScript
     *   is a case-sensitive language.
     *   @param join either MITER, BEVEL, or ROUND
     *   @chainable
     */
    function strokeJoin(join: p5.STROKE_JOIN): p5;

    /**
     *   Sets the width of the stroke used for lines,
     *   points, and the border around shapes. All widths
     *   are set in units of pixels. Note that
     *   strokeWeight() is affected by any transformation
     *   or scaling that has been applied previously.
     *   @param weight the weight of the stroke (in
     *   pixels).
     *   @chainable
     */
    function strokeWeight(weight: number): p5;

    /**
     *   Draws a cubic Bezier curve on the screen. These
     *   curves are defined by a series of anchor and
     *   control points. The first two parameters specify
     *   the first anchor point and the last two parameters
     *   specify the other anchor point, which become the
     *   first and last points on the curve. The middle
     *   parameters specify the two control points which
     *   define the shape of the curve. Approximately
     *   speaking, control points "pull" the curve towards
     *   them. Bezier curves were developed by French
     *   automotive engineer Pierre Bezier, and are
     *   commonly used in computer graphics to define
     *   gently sloping curves. See also curve().
     *   @param x1 x-coordinate for the first anchor point
     *   @param y1 y-coordinate for the first anchor point
     *   @param x2 x-coordinate for the first control point
     *   @param y2 y-coordinate for the first control point
     *   @param x3 x-coordinate for the second control
     *   point
     *   @param y3 y-coordinate for the second control
     *   point
     *   @param x4 x-coordinate for the second anchor point
     *   @param y4 y-coordinate for the second anchor point
     *   @chainable
     */
    function bezier(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): p5;

    /**
     *   Draws a cubic Bezier curve on the screen. These
     *   curves are defined by a series of anchor and
     *   control points. The first two parameters specify
     *   the first anchor point and the last two parameters
     *   specify the other anchor point, which become the
     *   first and last points on the curve. The middle
     *   parameters specify the two control points which
     *   define the shape of the curve. Approximately
     *   speaking, control points "pull" the curve towards
     *   them. Bezier curves were developed by French
     *   automotive engineer Pierre Bezier, and are
     *   commonly used in computer graphics to define
     *   gently sloping curves. See also curve().
     *   @param x1 x-coordinate for the first anchor point
     *   @param y1 y-coordinate for the first anchor point
     *   @param z1 z-coordinate for the first anchor point
     *   @param x2 x-coordinate for the first control point
     *   @param y2 y-coordinate for the first control point
     *   @param z2 z-coordinate for the first control point
     *   @param x3 x-coordinate for the second control
     *   point
     *   @param y3 y-coordinate for the second control
     *   point
     *   @param z3 z-coordinate for the second control
     *   point
     *   @param x4 x-coordinate for the second anchor point
     *   @param y4 y-coordinate for the second anchor point
     *   @param z4 z-coordinate for the second anchor point
     *   @chainable
     */
    function bezier(
        x1: number,
        y1: number,
        z1: number,
        x2: number,
        y2: number,
        z2: number,
        x3: number,
        y3: number,
        z3: number,
        x4: number,
        y4: number,
        z4: number
    ): p5;

    /**
     *   Sets the resolution at which Bezier's curve is
     *   displayed. The default value is 20. Note, This
     *   function is only useful when using the WEBGL
     *   renderer as the default canvas renderer does not
     *   use this information.
     *   @param detail resolution of the curves
     *   @chainable
     */
    function bezierDetail(detail: number): p5;

    /**
     *   Given the x or y co-ordinate values of control and
     *   anchor points of a bezier curve, it evaluates the
     *   x or y coordinate of the bezier at position t. The
     *   parameters a and d are the x or y coordinates of
     *   first and last points on the curve while b and c
     *   are of the control points.The final parameter t is
     *   the position of the resultant point which is given
     *   between 0 and 1. This can be done once with the x
     *   coordinates and a second time with the y
     *   coordinates to get the location of a bezier curve
     *   at t.
     *   @param a coordinate of first point on the curve
     *   @param b coordinate of first control point
     *   @param c coordinate of second control point
     *   @param d coordinate of second point on the curve
     *   @param t value between 0 and 1
     *   @return the value of the Bezier at position t
     */
    function bezierPoint(a: number, b: number, c: number, d: number, t: number): number;

    /**
     *   Evaluates the tangent to the Bezier at position t
     *   for points a, b, c, d. The parameters a and d are
     *   the first and last points on the curve, and b and
     *   c are the control points. The final parameter t
     *   varies between 0 and 1.
     *   @param a coordinate of first point on the curve
     *   @param b coordinate of first control point
     *   @param c coordinate of second control point
     *   @param d coordinate of second point on the curve
     *   @param t value between 0 and 1
     *   @return the tangent at position t
     */
    function bezierTangent(a: number, b: number, c: number, d: number, t: number): number;

    /**
     *   Draws a curved line on the screen between two
     *   points, given as the middle four parameters. The
     *   first two parameters are a control point, as if
     *   the curve came from this point even though it's
     *   not drawn. The last two parameters similarly
     *   describe the other control point.  Longer curves
     *   can be created by putting a series of curve()
     *   functions together or using curveVertex(). An
     *   additional function called curveTightness()
     *   provides control for the visual quality of the
     *   curve. The curve() function is an implementation
     *   of Catmull-Rom splines.
     *   @param x1 x-coordinate for the beginning control
     *   point
     *   @param y1 y-coordinate for the beginning control
     *   point
     *   @param x2 x-coordinate for the first point
     *   @param y2 y-coordinate for the first point
     *   @param x3 x-coordinate for the second point
     *   @param y3 y-coordinate for the second point
     *   @param x4 x-coordinate for the ending control
     *   point
     *   @param y4 y-coordinate for the ending control
     *   point
     *   @chainable
     */
    function curve(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): p5;

    /**
     *   Draws a curved line on the screen between two
     *   points, given as the middle four parameters. The
     *   first two parameters are a control point, as if
     *   the curve came from this point even though it's
     *   not drawn. The last two parameters similarly
     *   describe the other control point.  Longer curves
     *   can be created by putting a series of curve()
     *   functions together or using curveVertex(). An
     *   additional function called curveTightness()
     *   provides control for the visual quality of the
     *   curve. The curve() function is an implementation
     *   of Catmull-Rom splines.
     *   @param x1 x-coordinate for the beginning control
     *   point
     *   @param y1 y-coordinate for the beginning control
     *   point
     *   @param z1 z-coordinate for the beginning control
     *   point
     *   @param x2 x-coordinate for the first point
     *   @param y2 y-coordinate for the first point
     *   @param z2 z-coordinate for the first point
     *   @param x3 x-coordinate for the second point
     *   @param y3 y-coordinate for the second point
     *   @param z3 z-coordinate for the second point
     *   @param x4 x-coordinate for the ending control
     *   point
     *   @param y4 y-coordinate for the ending control
     *   point
     *   @param z4 z-coordinate for the ending control
     *   point
     *   @chainable
     */
    function curve(
        x1: number,
        y1: number,
        z1: number,
        x2: number,
        y2: number,
        z2: number,
        x3: number,
        y3: number,
        z3: number,
        x4: number,
        y4: number,
        z4: number
    ): p5;

    /**
     *   Sets the resolution at which curves display. The
     *   default value is 20 while the minimum value is 3.
     *   This function is only useful when using the WEBGL
     *   renderer as the default canvas renderer does not
     *   use this information.
     *   @param resolution resolution of the curves
     *   @chainable
     */
    function curveDetail(resolution: number): p5;

    /**
     *   Modifies the quality of forms created with curve()
     *   and curveVertex().The parameter tightness
     *   determines how the curve fits to the vertex
     *   points. The value 0.0 is the default value for
     *   tightness (this value defines the curves to be
     *   Catmull-Rom splines) and the value 1.0 connects
     *   all the points with straight lines. Values within
     *   the range -5.0 and 5.0 will deform the curves but
     *   will leave them recognizable and as values
     *   increase in magnitude, they will continue to
     *   deform.
     *   @param amount amount of deformation from the
     *   original vertices
     *   @chainable
     */
    function curveTightness(amount: number): p5;

    /**
     *   Evaluates the curve at position t for points a, b,
     *   c, d. The parameter t varies between 0 and 1, a
     *   and d are control points of the curve, and b and c
     *   are the start and end points of the curve. This
     *   can be done once with the x coordinates and a
     *   second time with the y coordinates to get the
     *   location of a curve at t.
     *   @param a coordinate of first control point of the
     *   curve
     *   @param b coordinate of first point
     *   @param c coordinate of second point
     *   @param d coordinate of second control point
     *   @param t value between 0 and 1
     *   @return Curve value at position t
     */
    function curvePoint(a: number, b: number, c: number, d: number, t: number): number;

    /**
     *   Evaluates the tangent to the curve at position t
     *   for points a, b, c, d. The parameter t varies
     *   between 0 and 1, a and d are points on the curve,
     *   and b and c are the control points.
     *   @param a coordinate of first control point
     *   @param b coordinate of first point on the curve
     *   @param c coordinate of second point on the curve
     *   @param d coordinate of second conrol point
     *   @param t value between 0 and 1
     *   @return the tangent at position t
     */
    function curveTangent(a: number, b: number, c: number, d: number, t: number): number;

    /**
     *   Use the beginContour() and endContour() functions
     *   to create negative shapes within shapes such as
     *   the center of the letter 'O'. beginContour()
     *   begins recording vertices for the shape and
     *   endContour() stops recording. The vertices that
     *   define a negative shape must "wind" in the
     *   opposite direction from the exterior shape. First
     *   draw vertices for the exterior clockwise order,
     *   then for internal shapes, draw vertices shape in
     *   counter-clockwise. These functions can only be
     *   used within a beginShape()/endShape() pair and
     *   transformations such as translate(), rotate(), and
     *   scale() do not work within a
     *   beginContour()/endContour() pair. It is also not
     *   possible to use other shapes, such as ellipse() or
     *   rect() within.
     *   @chainable
     */
    function beginContour(): p5;

    /**
     *   Using the beginShape() and endShape() functions
     *   allow creating more complex forms. beginShape()
     *   begins recording vertices for a shape and
     *   endShape() stops recording. The value of the kind
     *   parameter tells it which types of shapes to create
     *   from the provided vertices. With no mode
     *   specified, the shape can be any irregular polygon.
     *   The parameters available for beginShape() are:
     *
     *   POINTS Draw a series of points
     *
     *   LINES Draw a series of unconnected line segments
     *   (individual lines)
     *
     *   TRIANGLES Draw a series of separate triangles
     *
     *   TRIANGLE_FAN Draw a series of connected triangles
     *   sharing the first vertex in a fan-like fashion
     *
     *   TRIANGLE_STRIP Draw a series of connected
     *   triangles in strip fashion
     *
     *   QUADS Draw a series of separate quads
     *
     *   QUAD_STRIP Draw quad strip using adjacent edges to
     *   form the next quad
     *
     *   TESS (WEBGL only) Handle irregular polygon for
     *   filling curve by explicit tessellation
     *
     *   After calling the beginShape() function, a series
     *   of vertex() commands must follow. To stop drawing
     *   the shape, call endShape(). Each shape will be
     *   outlined with the current stroke color and filled
     *   with the fill color.
     *
     *   Transformations such as translate(), rotate(), and
     *   scale() do not work within beginShape(). It is
     *   also not possible to use other shapes, such as
     *   ellipse() or rect() within beginShape().
     *   @param [kind] either POINTS, LINES, TRIANGLES,
     *   TRIANGLE_FAN TRIANGLE_STRIP, QUADS, QUAD_STRIP or
     *   TESS
     *   @chainable
     */
    function beginShape(kind?: p5.BEGIN_KIND): p5;

    /**
     *   Specifies vertex coordinates for Bezier curves.
     *   Each call to bezierVertex() defines the position
     *   of two control points and one anchor point of a
     *   Bezier curve, adding a new segment to a line or
     *   shape. For WebGL mode bezierVertex() can be used
     *   in 2D as well as 3D mode. 2D mode expects 6
     *   parameters, while 3D mode expects 9 parameters
     *   (including z coordinates). The first time
     *   bezierVertex() is used within a beginShape() call,
     *   it must be prefaced with a call to vertex() to set
     *   the first anchor point. This function must be used
     *   between beginShape() and endShape() and only when
     *   there is no MODE or POINTS parameter specified to
     *   beginShape().
     *   @param x2 x-coordinate for the first control point
     *   @param y2 y-coordinate for the first control point
     *   @param x3 x-coordinate for the second control
     *   point
     *   @param y3 y-coordinate for the second control
     *   point
     *   @param x4 x-coordinate for the anchor point
     *   @param y4 y-coordinate for the anchor point
     *   @chainable
     */
    function bezierVertex(x2: number, y2: number, x3: number, y3: number, x4: number, y4: number): p5;

    /**
     *   Specifies vertex coordinates for Bezier curves.
     *   Each call to bezierVertex() defines the position
     *   of two control points and one anchor point of a
     *   Bezier curve, adding a new segment to a line or
     *   shape. For WebGL mode bezierVertex() can be used
     *   in 2D as well as 3D mode. 2D mode expects 6
     *   parameters, while 3D mode expects 9 parameters
     *   (including z coordinates). The first time
     *   bezierVertex() is used within a beginShape() call,
     *   it must be prefaced with a call to vertex() to set
     *   the first anchor point. This function must be used
     *   between beginShape() and endShape() and only when
     *   there is no MODE or POINTS parameter specified to
     *   beginShape().
     *   @param x2 x-coordinate for the first control point
     *   @param y2 y-coordinate for the first control point
     *   @param z2 z-coordinate for the first control point
     *   (for WebGL mode)
     *   @param x3 x-coordinate for the second control
     *   point
     *   @param y3 y-coordinate for the second control
     *   point
     *   @param z3 z-coordinate for the second control
     *   point (for WebGL mode)
     *   @param x4 x-coordinate for the anchor point
     *   @param y4 y-coordinate for the anchor point
     *   @param z4 z-coordinate for the anchor point (for
     *   WebGL mode)
     *   @chainable
     */
    function bezierVertex(
        x2: number,
        y2: number,
        z2: number,
        x3: number,
        y3: number,
        z3: number,
        x4: number,
        y4: number,
        z4: number
    ): p5;

    /**
     *   Specifies vertex coordinates for curves. This
     *   function may only be used between beginShape() and
     *   endShape() and only when there is no MODE
     *   parameter specified to beginShape(). For WebGL
     *   mode curveVertex() can be used in 2D as well as 3D
     *   mode. 2D mode expects 2 parameters, while 3D mode
     *   expects 3 parameters. The first and last points in
     *   a series of curveVertex() lines will be used to
     *   guide the beginning and end of the curve. A
     *   minimum of four points is required to draw a tiny
     *   curve between the second and third points. Adding
     *   a fifth point with curveVertex() will draw the
     *   curve between the second, third, and fourth
     *   points. The curveVertex() function is an
     *   implementation of Catmull-Rom splines.
     *   @param x x-coordinate of the vertex
     *   @param y y-coordinate of the vertex
     *   @chainable
     */
    function curveVertex(x: number, y: number): p5;

    /**
     *   Specifies vertex coordinates for curves. This
     *   function may only be used between beginShape() and
     *   endShape() and only when there is no MODE
     *   parameter specified to beginShape(). For WebGL
     *   mode curveVertex() can be used in 2D as well as 3D
     *   mode. 2D mode expects 2 parameters, while 3D mode
     *   expects 3 parameters. The first and last points in
     *   a series of curveVertex() lines will be used to
     *   guide the beginning and end of the curve. A
     *   minimum of four points is required to draw a tiny
     *   curve between the second and third points. Adding
     *   a fifth point with curveVertex() will draw the
     *   curve between the second, third, and fourth
     *   points. The curveVertex() function is an
     *   implementation of Catmull-Rom splines.
     *   @param x x-coordinate of the vertex
     *   @param y y-coordinate of the vertex
     *   @param [z] z-coordinate of the vertex (for WebGL
     *   mode)
     *   @chainable
     */
    function curveVertex(x: number, y: number, z?: number): p5;

    /**
     *   Use the beginContour() and endContour() functions
     *   to create negative shapes within shapes such as
     *   the center of the letter 'O'. beginContour()
     *   begins recording vertices for the shape and
     *   endContour() stops recording. The vertices that
     *   define a negative shape must "wind" in the
     *   opposite direction from the exterior shape. First
     *   draw vertices for the exterior clockwise order,
     *   then for internal shapes, draw vertices shape in
     *   counter-clockwise. These functions can only be
     *   used within a beginShape()/endShape() pair and
     *   transformations such as translate(), rotate(), and
     *   scale() do not work within a
     *   beginContour()/endContour() pair. It is also not
     *   possible to use other shapes, such as ellipse() or
     *   rect() within.
     *   @chainable
     */
    function endContour(): p5;

    /**
     *   The endShape() function is the companion to
     *   beginShape() and may only be called after
     *   beginShape(). When endShape() is called, all of
     *   the image data defined since the previous call to
     *   beginShape() is written into the image buffer. The
     *   constant CLOSE as the value for the mode parameter
     *   to close the shape (to connect the beginning and
     *   the end).
     *   @param [mode] use CLOSE to close the shape
     *   @chainable
     */
    function endShape(mode?: p5.END_MODE): p5;

    /**
     *   Specifies vertex coordinates for quadratic Bezier
     *   curves. Each call to quadraticVertex() defines the
     *   position of one control points and one anchor
     *   point of a Bezier curve, adding a new segment to a
     *   line or shape. The first time quadraticVertex() is
     *   used within a beginShape() call, it must be
     *   prefaced with a call to vertex() to set the first
     *   anchor point. For WebGL mode quadraticVertex() can
     *   be used in 2D as well as 3D mode. 2D mode expects
     *   4 parameters, while 3D mode expects 6 parameters
     *   (including z coordinates). This function must be
     *   used between beginShape() and endShape() and only
     *   when there is no MODE or POINTS parameter
     *   specified to beginShape().
     *   @param cx x-coordinate for the control point
     *   @param cy y-coordinate for the control point
     *   @param x3 x-coordinate for the anchor point
     *   @param y3 y-coordinate for the anchor point
     *   @chainable
     */
    function quadraticVertex(cx: number, cy: number, x3: number, y3: number): p5;

    /**
     *   Specifies vertex coordinates for quadratic Bezier
     *   curves. Each call to quadraticVertex() defines the
     *   position of one control points and one anchor
     *   point of a Bezier curve, adding a new segment to a
     *   line or shape. The first time quadraticVertex() is
     *   used within a beginShape() call, it must be
     *   prefaced with a call to vertex() to set the first
     *   anchor point. For WebGL mode quadraticVertex() can
     *   be used in 2D as well as 3D mode. 2D mode expects
     *   4 parameters, while 3D mode expects 6 parameters
     *   (including z coordinates). This function must be
     *   used between beginShape() and endShape() and only
     *   when there is no MODE or POINTS parameter
     *   specified to beginShape().
     *   @param cx x-coordinate for the control point
     *   @param cy y-coordinate for the control point
     *   @param cz z-coordinate for the control point (for
     *   WebGL mode)
     *   @param x3 x-coordinate for the anchor point
     *   @param y3 y-coordinate for the anchor point
     *   @param z3 z-coordinate for the anchor point (for
     *   WebGL mode)
     *   @chainable
     */
    function quadraticVertex(cx: number, cy: number, cz: number, x3: number, y3: number, z3: number): p5;

    /**
     *   All shapes are constructed by connecting a series
     *   of vertices. vertex() is used to specify the
     *   vertex coordinates for points, lines, triangles,
     *   quads, and polygons. It is used exclusively within
     *   the beginShape() and endShape() functions.
     *   @param x x-coordinate of the vertex
     *   @param y y-coordinate of the vertex
     *   @chainable
     */
    function vertex(x: number, y: number): p5;

    /**
     *   All shapes are constructed by connecting a series
     *   of vertices. vertex() is used to specify the
     *   vertex coordinates for points, lines, triangles,
     *   quads, and polygons. It is used exclusively within
     *   the beginShape() and endShape() functions.
     *   @param x x-coordinate of the vertex
     *   @param y y-coordinate of the vertex
     *   @param [z] z-coordinate of the vertex. Defaults to
     *   0 if not specified.
     *   @chainable
     */
    function vertex(x: number, y: number, z?: number): p5;

    /**
     *   All shapes are constructed by connecting a series
     *   of vertices. vertex() is used to specify the
     *   vertex coordinates for points, lines, triangles,
     *   quads, and polygons. It is used exclusively within
     *   the beginShape() and endShape() functions.
     *   @param x x-coordinate of the vertex
     *   @param y y-coordinate of the vertex
     *   @param [z] z-coordinate of the vertex. Defaults to
     *   0 if not specified.
     *   @param [u] the vertex's texture u-coordinate
     *   @param [v] the vertex's texture v-coordinate
     *   @chainable
     */
    function vertex(x: number, y: number, z?: number, u?: number, v?: number): p5;

    /**
     *   Sets the 3d vertex normal to use for subsequent
     *   vertices drawn with vertex(). A normal is a vector
     *   that is generally nearly perpendicular to a
     *   shape's surface which controls how much light will
     *   be reflected from that part of the surface.
     *   @param vector A p5.Vector representing the vertex
     *   normal.
     *   @chainable
     */
    function normal(vector: p5.Vector): p5;

    /**
     *   Sets the 3d vertex normal to use for subsequent
     *   vertices drawn with vertex(). A normal is a vector
     *   that is generally nearly perpendicular to a
     *   shape's surface which controls how much light will
     *   be reflected from that part of the surface.
     *   @param x The x component of the vertex normal.
     *   @param y The y component of the vertex normal.
     *   @param z The z component of the vertex normal.
     *   @chainable
     */
    function normal(x: number, y: number, z: number): p5;

    /**
     *   Version of this p5.js.
     */
    const VERSION: p5.VERSION;

    /**
     *   The default, two-dimensional renderer.
     */
    const P2D: p5.P2D;

    /**
     *   One of the two render modes in p5.js, used for
     *   computationally intensive tasks like 3D rendering
     *   and shaders. WEBGL differs from the default P2D
     *   renderer in the following ways:
     *
     *   - Coordinate System - When drawing in WEBGL mode,
     *   the origin point (0,0,0) is located at the center
     *   of the screen, not the top-left corner. See the
     *   learn page about coordinates and transformations.
     *   - 3D Shapes - WEBGL mode can be used to draw
     *   3-dimensional shapes like box(), sphere(), cone(),
     *   and more. See the learn page about custom geometry
     *   to make more complex objects.
     *   - Shape Detail - When drawing in WEBGL mode, you
     *   can specify how smooth curves should be drawn by
     *   using a detail parameter. See the wiki section
     *   about shapes for a more information and an
     *   example.
     *   - Textures - A texture is like a skin that wraps
     *   onto a shape. See the wiki section about textures
     *   for examples of mapping images onto surfaces with
     *   textures.
     *   - Materials and Lighting - WEBGL offers different
     *   types of lights like ambientLight() to place
     *   around a scene. Materials like specularMaterial()
     *   reflect the lighting to convey shape and depth.
     *   See the learn page for styling and appearance to
     *   experiment with different combinations.
     *   - Camera - The viewport of a WEBGL sketch can be
     *   adjusted by changing camera attributes. See the
     *   learn page section about cameras for an
     *   explanation of camera controls.
     *   - Text - WEBGL requires opentype/truetype font
     *   files to be preloaded using loadFont(). See the
     *   wiki section about text for details, along with a
     *   workaround.
     *   - Shaders - Shaders are hardware accelerated
     *   programs that can be used for a variety of effects
     *   and graphics. See the introduction to shaders to
     *   get started with shaders in p5.js.
     *   - Graphics Acceleration - WEBGL mode uses the
     *   graphics card instead of the CPU, so it may help
     *   boost the performance of your sketch (example:
     *   drawing more shapes on the screen at once).
     *
     *   To learn more about WEBGL mode, check out all the
     *   interactive WEBGL tutorials in the "Learn" section
     *   of this website, or read the wiki article "Getting
     *   started with WebGL in p5".
     */
    const WEBGL: p5.WEBGL;

    /**
     *   One of the two possible values of a WebGL canvas
     *   (either WEBGL or WEBGL2), which can be used to
     *   determine what capabilities the rendering
     *   environment has.
     */
    const WEBGL2: p5.WEBGL2;
    const ARROW: p5.ARROW;
    const CROSS: p5.CROSS;
    const HAND: p5.HAND;
    const MOVE: p5.MOVE;
    const TEXT: p5.TEXT;
    const WAIT: p5.WAIT;

    /**
     *   HALF_PI is a mathematical constant with the value
     *   1.57079632679489661923. It is half the ratio of
     *   the circumference of a circle to its diameter. It
     *   is useful in combination with the trigonometric
     *   functions sin() and cos().
     */
    const HALF_PI: number;

    /**
     *   PI is a mathematical constant with the value
     *   3.14159265358979323846. It is the ratio of the
     *   circumference of a circle to its diameter. It is
     *   useful in combination with the trigonometric
     *   functions sin() and cos().
     */
    const PI: number;

    /**
     *   QUARTER_PI is a mathematical constant with the
     *   value 0.7853982. It is one quarter the ratio of
     *   the circumference of a circle to its diameter. It
     *   is useful in combination with the trigonometric
     *   functions sin() and cos().
     */
    const QUARTER_PI: number;

    /**
     *   TAU is an alias for TWO_PI, a mathematical
     *   constant with the value 6.28318530717958647693. It
     *   is twice the ratio of the circumference of a
     *   circle to its diameter. It is useful in
     *   combination with the trigonometric functions sin()
     *   and cos().
     */
    const TAU: number;

    /**
     *   TWO_PI is a mathematical constant with the value
     *   6.28318530717958647693. It is twice the ratio of
     *   the circumference of a circle to its diameter. It
     *   is useful in combination with the trigonometric
     *   functions sin() and cos().
     */
    const TWO_PI: number;

    /**
     *   Constant to be used with the angleMode() function,
     *   to set the mode in which p5.js interprets and
     *   calculates angles (either DEGREES or RADIANS).
     */
    const DEGREES: p5.DEGREES;

    /**
     *   Constant to be used with the angleMode() function,
     *   to set the mode in which p5.js interprets and
     *   calculates angles (either RADIANS or DEGREES).
     */
    const RADIANS: p5.RADIANS;
    const CORNER: p5.CORNER;
    const CORNERS: p5.CORNERS;
    const RADIUS: p5.RADIUS;
    const RIGHT: p5.RIGHT;
    const LEFT: p5.LEFT;
    const CENTER: p5.CENTER;
    const TOP: p5.TOP;
    const BOTTOM: p5.BOTTOM;
    const BASELINE: p5.BASELINE;
    const POINTS: p5.POINTS;
    const LINES: p5.LINES;
    const LINE_STRIP: p5.LINE_STRIP;
    const LINE_LOOP: p5.LINE_LOOP;
    const TRIANGLES: p5.TRIANGLES;
    const TRIANGLE_FAN: p5.TRIANGLE_FAN;
    const TRIANGLE_STRIP: p5.TRIANGLE_STRIP;
    const QUADS: p5.QUADS;
    const QUAD_STRIP: p5.QUAD_STRIP;
    const TESS: p5.TESS;
    const CLOSE: p5.CLOSE;
    const OPEN: p5.OPEN;
    const CHORD: p5.CHORD;
    const PIE: p5.PIE;
    const PROJECT: p5.PROJECT;
    const SQUARE: p5.SQUARE;
    const ROUND: p5.ROUND;
    const BEVEL: p5.BEVEL;
    const MITER: p5.MITER;
    const RGB: p5.RGB;

    /**
     *   HSB (hue, saturation, brightness) is a type of
     *   color model. You can learn more about it at HSB.
     */
    const HSB: p5.HSB;
    const HSL: p5.HSL;

    /**
     *   AUTO allows us to automatically set the width or
     *   height of an element (but not both), based on the
     *   current height and width of the element. Only one
     *   parameter can be passed to the size function as
     *   AUTO, at a time.
     */
    const AUTO: p5.AUTO;
    const ALT: number;
    const BACKSPACE: number;
    const CONTROL: number;
    const DELETE: number;
    const DOWN_ARROW: number;
    const ENTER: number;
    const ESCAPE: number;
    const LEFT_ARROW: number;
    const OPTION: number;
    const RETURN: number;
    const RIGHT_ARROW: number;
    const SHIFT: number;
    const TAB: number;
    const UP_ARROW: number;
    const BLEND: p5.BLEND;
    const REMOVE: p5.REMOVE;
    const ADD: p5.ADD;
    const DARKEST: p5.DARKEST;
    const LIGHTEST: p5.LIGHTEST;
    const DIFFERENCE: p5.DIFFERENCE;
    const SUBTRACT: p5.SUBTRACT;
    const EXCLUSION: p5.EXCLUSION;
    const MULTIPLY: p5.MULTIPLY;
    const SCREEN: p5.SCREEN;
    const REPLACE: p5.REPLACE;
    const OVERLAY: p5.OVERLAY;
    const HARD_LIGHT: p5.HARD_LIGHT;
    const SOFT_LIGHT: p5.SOFT_LIGHT;
    const DODGE: p5.DODGE;
    const BURN: p5.BURN;
    const THRESHOLD: p5.THRESHOLD;
    const GRAY: p5.GRAY;
    const OPAQUE: p5.OPAQUE;
    const INVERT: p5.INVERT;
    const POSTERIZE: p5.POSTERIZE;
    const DILATE: p5.DILATE;
    const ERODE: p5.ERODE;
    const BLUR: p5.BLUR;
    const NORMAL: p5.NORMAL;
    const ITALIC: p5.ITALIC;
    const BOLD: p5.BOLD;
    const BOLDITALIC: p5.BOLDITALIC;
    const CHAR: p5.CHAR;
    const WORD: p5.WORD;
    const LINEAR: p5.LINEAR;
    const QUADRATIC: p5.QUADRATIC;
    const BEZIER: p5.BEZIER;
    const CURVE: p5.CURVE;
    const STROKE: p5.STROKE;
    const FILL: p5.FILL;
    const TEXTURE: p5.TEXTURE;
    const IMMEDIATE: p5.IMMEDIATE;
    const IMAGE: p5.IMAGE;
    const NEAREST: p5.NEAREST;
    const REPEAT: p5.REPEAT;
    const CLAMP: p5.CLAMP;
    const MIRROR: p5.MIRROR;
    const LANDSCAPE: p5.LANDSCAPE;
    const PORTRAIT: p5.PORTRAIT;
    const GRID: p5.GRID;
    const AXES: p5.AXES;
    const LABEL: p5.LABEL;
    const FALLBACK: p5.FALLBACK;
    const CONTAIN: p5.CONTAIN;
    const COVER: p5.COVER;
    const UNSIGNED_BYTE: p5.UNSIGNED_BYTE;
    const UNSIGNED_INT: p5.UNSIGNED_INT;
    const FLOAT: p5.FLOAT;
    const HALF_FLOAT: p5.HALF_FLOAT;
    const RGBA: p5.RGBA;

    /**
     *   The print() function writes to the console area of
     *   your browser. This function is often helpful for
     *   looking at the data a program is producing. This
     *   function creates a new line of text for each call
     *   to the function. Individual elements can be
     *   separated with quotes ("") and joined with the
     *   addition operator (+). Note that calling print()
     *   without any arguments invokes the window.print()
     *   function which opens the browser's print dialog.
     *   To print a blank line to console you can write
     *   print('\n').
     *   @param contents any combination of Number, String,
     *   Object, Boolean, Array to print
     */
    function print(contents: any): void;

    /**
     *   Sets the cursor to a predefined symbol or an
     *   image, or makes it visible if already hidden. If
     *   you are trying to set an image as the cursor, the
     *   recommended size is 16×16 or 32×32 pixels. The
     *   values for parameters x and y must be less than
     *   the dimensions of the image.
     *   @param type Built-In: either ARROW, CROSS, HAND,
     *   MOVE, TEXT and WAIT Native CSS properties: 'grab',
     *   'progress', 'cell' etc. External: path for
     *   cursor's images (Allowed File extensions: .cur,
     *   .gif, .jpg, .jpeg, .png) For more information on
     *   Native CSS cursors and url visit:
     *   https://developer.mozilla.org/en-US/docs/Web/CSS/cursor
     *   @param [x] the horizontal active spot of the
     *   cursor (must be less than 32)
     *   @param [y] the vertical active spot of the cursor
     *   (must be less than 32)
     */
    function cursor(type: string | p5.CURSOR_TYPE, x?: number, y?: number): void;

    /**
     *   Specifies the number of frames to be displayed
     *   every second. For example, the function call
     *   frameRate(30) will attempt to refresh 30 times a
     *   second. If the processor is not fast enough to
     *   maintain the specified rate, the frame rate will
     *   not be achieved. Setting the frame rate within
     *   setup() is recommended. The default frame rate is
     *   based on the frame rate of the display (here also
     *   called "refresh rate"), which is set to 60 frames
     *   per second on most computers. A frame rate of 24
     *   frames per second (usual for movies) or above will
     *   be enough for smooth animations. This is the same
     *   as setFrameRate(val). Calling frameRate() with no
     *   arguments returns the current framerate. The draw
     *   function must run at least once before it will
     *   return a value. This is the same as
     *   getFrameRate().
     *
     *   Calling frameRate() with arguments that are not of
     *   the type Number or are non-positive also returns
     *   current framerate.
     *   @param fps number of frames to be displayed every
     *   second
     *   @chainable
     */
    function frameRate(fps: number): p5;

    /**
     *   Specifies the number of frames to be displayed
     *   every second. For example, the function call
     *   frameRate(30) will attempt to refresh 30 times a
     *   second. If the processor is not fast enough to
     *   maintain the specified rate, the frame rate will
     *   not be achieved. Setting the frame rate within
     *   setup() is recommended. The default frame rate is
     *   based on the frame rate of the display (here also
     *   called "refresh rate"), which is set to 60 frames
     *   per second on most computers. A frame rate of 24
     *   frames per second (usual for movies) or above will
     *   be enough for smooth animations. This is the same
     *   as setFrameRate(val). Calling frameRate() with no
     *   arguments returns the current framerate. The draw
     *   function must run at least once before it will
     *   return a value. This is the same as
     *   getFrameRate().
     *
     *   Calling frameRate() with arguments that are not of
     *   the type Number or are non-positive also returns
     *   current framerate.
     *   @return current frameRate
     */
    function frameRate(): number;

    /**
     *   Returns _targetFrameRate variable. The default
     *   _targetFrameRate is set to 60. This could be
     *   changed by calling frameRate() and setting it to
     *   the desired value. When getTargetFrameRate() is
     *   called, it should return the value that was set.
     *   @return _targetFrameRate
     */
    function getTargetFrameRate(): number;

    /**
     *   Hides the cursor from view.
     */
    function noCursor(): void;

    /**
     *   The windowResized() function is called once every
     *   time the browser window is resized. This is a good
     *   place to resize the canvas or do any other
     *   adjustments to accommodate the new window size.
     *   @param [event] optional Event callback argument.
     */
    function windowResized(event?: object): void;

    /**
     *   If argument is given, sets the sketch to
     *   fullscreen or not based on the value of the
     *   argument. If no argument is given, returns the
     *   current fullscreen state. Note that due to browser
     *   restrictions this can only be called on user
     *   input, for example, on mouse press like the
     *   example below.
     *   @param [val] whether the sketch should be in
     *   fullscreen mode or not
     *   @return current fullscreen state
     */
    function fullscreen(val?: boolean): boolean;

    /**
     *   Sets the pixel scaling for high pixel density
     *   displays. By default pixel density is set to match
     *   display density, call pixelDensity(1) to turn this
     *   off. Calling pixelDensity() with no arguments
     *   returns the current pixel density of the sketch.
     *   @param val whether or how much the sketch should
     *   scale
     *   @chainable
     */
    function pixelDensity(val: number): p5;

    /**
     *   Sets the pixel scaling for high pixel density
     *   displays. By default pixel density is set to match
     *   display density, call pixelDensity(1) to turn this
     *   off. Calling pixelDensity() with no arguments
     *   returns the current pixel density of the sketch.
     *   @return current pixel density of the sketch
     */
    function pixelDensity(): number;

    /**
     *   Returns the pixel density of the current display
     *   the sketch is running on.
     *   @return current pixel density of the display
     */
    function displayDensity(): number;

    /**
     *   Gets the current URL. Note: when using the p5
     *   Editor, this will return an empty object because
     *   the sketch is embedded in an iframe. It will work
     *   correctly if you view the sketch using the
     *   editor's present or share URLs.
     *   @return url
     */
    function getURL(): string;

    /**
     *   Gets the current URL path as an array. Note: when
     *   using the p5 Editor, this will return an empty
     *   object because the sketch is embedded in an
     *   iframe. It will work correctly if you view the
     *   sketch using the editor's present or share URLs.
     *   @return path components
     */
    function getURLPath(): string[];

    /**
     *   Gets the current URL params as an Object. Note:
     *   when using the p5 Editor, this will return an
     *   empty object because the sketch is embedded in an
     *   iframe. It will work correctly if you view the
     *   sketch using the editor's present or share URLs.
     *   @return URL params
     */
    function getURLParams(): object;

    /**
     *   The system variable frameCount contains the number
     *   of frames that have been displayed since the
     *   program started. Inside setup() the value is 0,
     *   after the first iteration of draw() it is 1, etc.
     */
    let frameCount: number;

    /**
     *   The system variable deltaTime contains the time
     *   difference between the beginning of the previous
     *   frame and the beginning of the current frame in
     *   milliseconds. This variable is useful for creating
     *   time sensitive animation or physics calculation
     *   that should stay constant regardless of frame
     *   rate.
     */
    let deltaTime: number;

    /**
     *   Confirms if the window a p5.js program is in is
     *   "focused," meaning that the sketch will accept
     *   mouse or keyboard input. This variable is "true"
     *   if the window is focused and "false" if not.
     */
    let focused: boolean;

    /**
     *   If the sketch was created in WebGL mode, then
     *   weglVersion will indicate which version of WebGL
     *   it is using. It will try to create a WebGL2 canvas
     *   unless you have requested WebGL1 via
     *   setAttributes({ version: 1 }), and will fall back
     *   to WebGL1 if WebGL2 is not available. webglVersion
     *   will always be either WEBGL2, WEBGL, or P2D if not
     *   in WebGL mode.
     */
    let webglVersion: string;

    /**
     *   System variable that stores the width of the
     *   screen display according to The default
     *   pixelDensity. This is used to run a full-screen
     *   program on any display size. To return actual
     *   screen size, multiply this by pixelDensity.
     */
    let displayWidth: number;

    /**
     *   System variable that stores the height of the
     *   screen display according to The default
     *   pixelDensity. This is used to run a full-screen
     *   program on any display size. To return actual
     *   screen size, multiply this by pixelDensity.
     */
    let displayHeight: number;

    /**
     *   System variable that stores the width of the inner
     *   window, it maps to window.innerWidth.
     */
    let windowWidth: number;

    /**
     *   System variable that stores the height of the
     *   inner window, it maps to window.innerHeight.
     */
    let windowHeight: number;

    /**
     *   System variable that stores the width of the
     *   drawing canvas. This value is set by the first
     *   parameter of the createCanvas() function. For
     *   example, the function call createCanvas(320, 240)
     *   sets the width variable to the value 320. The
     *   value of width defaults to 100 if createCanvas()
     *   is not used in a program.
     */
    let width: number;

    /**
     *   System variable that stores the height of the
     *   drawing canvas. This value is set by the second
     *   parameter of the createCanvas() function. For
     *   example, the function call createCanvas(320, 240)
     *   sets the height variable to the value 240. The
     *   value of height defaults to 100 if createCanvas()
     *   is not used in a program.
     */
    let height: number;

    /**
     *   Creates a canvas element in the document and sets
     *   its dimensions in pixels. This method should be
     *   called only once at the start of setup(). Calling
     *   createCanvas more than once in a sketch will
     *   result in very unpredictable behavior. If you want
     *   more than one drawing canvas you could use
     *   createGraphics() (hidden by default but it can be
     *   shown). Important note: in 2D mode (i.e. when
     *   p5.Renderer is not set) the origin (0,0) is
     *   positioned at the top left of the screen. In 3D
     *   mode (i.e. when p5.Renderer is set to WEBGL), the
     *   origin is positioned at the center of the canvas.
     *   See this issue for more information.
     *
     *   A WebGL canvas will use a WebGL2 context if it is
     *   supported by the browser. Check the webglVersion
     *   property to check what version is being used, or
     *   call setAttributes({ version: 1 }) to create a
     *   WebGL1 context.
     *
     *   The system variables width and height are set by
     *   the parameters passed to this function. If
     *   createCanvas() is not used, the window will be
     *   given a default size of 100×100 pixels.
     *
     *   Optionally, an existing canvas can be passed using
     *   a selector, ie. document.getElementById(''). If
     *   specified, avoid using setAttributes() afterwards,
     *   as this will remove and recreate the existing
     *   canvas.
     *
     *   For more ways to position the canvas, see the
     *   positioning the canvas wiki page.
     *   @param w width of the canvas
     *   @param h height of the canvas
     *   @param [renderer] either P2D or WEBGL
     *   @param [canvas] existing html canvas element
     *   @return pointer to p5.Renderer holding canvas
     */
    function createCanvas(w: number, h: number, renderer?: p5.RENDERER, canvas?: object): p5.Renderer;

    /**
     *   Creates a canvas element in the document and sets
     *   its dimensions in pixels. This method should be
     *   called only once at the start of setup(). Calling
     *   createCanvas more than once in a sketch will
     *   result in very unpredictable behavior. If you want
     *   more than one drawing canvas you could use
     *   createGraphics() (hidden by default but it can be
     *   shown). Important note: in 2D mode (i.e. when
     *   p5.Renderer is not set) the origin (0,0) is
     *   positioned at the top left of the screen. In 3D
     *   mode (i.e. when p5.Renderer is set to WEBGL), the
     *   origin is positioned at the center of the canvas.
     *   See this issue for more information.
     *
     *   A WebGL canvas will use a WebGL2 context if it is
     *   supported by the browser. Check the webglVersion
     *   property to check what version is being used, or
     *   call setAttributes({ version: 1 }) to create a
     *   WebGL1 context.
     *
     *   The system variables width and height are set by
     *   the parameters passed to this function. If
     *   createCanvas() is not used, the window will be
     *   given a default size of 100×100 pixels.
     *
     *   Optionally, an existing canvas can be passed using
     *   a selector, ie. document.getElementById(''). If
     *   specified, avoid using setAttributes() afterwards,
     *   as this will remove and recreate the existing
     *   canvas.
     *
     *   For more ways to position the canvas, see the
     *   positioning the canvas wiki page.
     *   @param w width of the canvas
     *   @param h height of the canvas
     *   @param [canvas] existing html canvas element
     *   @return pointer to p5.Renderer holding canvas
     */
    function createCanvas(w: number, h: number, canvas?: object): p5.Renderer;

    /**
     *   Resizes the canvas to given width and height. The
     *   canvas will be cleared and draw will be called
     *   immediately, allowing the sketch to re-render
     *   itself in the resized canvas.
     *   @param w width of the canvas
     *   @param h height of the canvas
     *   @param [noRedraw] don't redraw the canvas
     *   immediately
     */
    function resizeCanvas(w: number, h: number, noRedraw?: boolean): void;

    /**
     *   Removes the default canvas for a p5 sketch that
     *   doesn't require a canvas
     */
    function noCanvas(): void;

    /**
     *   Creates and returns a new p5.Graphics object. Use
     *   this class if you need to draw into an off-screen
     *   graphics buffer. The two parameters define the
     *   width and height in pixels. A WebGL p5.Graphics
     *   will use a WebGL2 context if it is supported by
     *   the browser. Check the pg.webglVersion property of
     *   the renderer to check what version is being used,
     *   or call pg.setAttributes({ version: 1 }) to create
     *   a WebGL1 context.
     *
     *   Optionally, an existing canvas can be passed using
     *   a selector, ie. document.getElementById(''). By
     *   default this canvas will be hidden (offscreen
     *   buffer), to make visible, set element's style to
     *   display:block;
     *   @param w width of the offscreen graphics buffer
     *   @param h height of the offscreen graphics buffer
     *   @param [renderer] either P2D or WEBGL undefined
     *   defaults to p2d
     *   @param [canvas] existing html canvas element
     *   @return offscreen graphics buffer
     */
    function createGraphics(w: number, h: number, renderer?: p5.RENDERER, canvas?: object): p5.Graphics;

    /**
     *   Creates and returns a new p5.Graphics object. Use
     *   this class if you need to draw into an off-screen
     *   graphics buffer. The two parameters define the
     *   width and height in pixels. A WebGL p5.Graphics
     *   will use a WebGL2 context if it is supported by
     *   the browser. Check the pg.webglVersion property of
     *   the renderer to check what version is being used,
     *   or call pg.setAttributes({ version: 1 }) to create
     *   a WebGL1 context.
     *
     *   Optionally, an existing canvas can be passed using
     *   a selector, ie. document.getElementById(''). By
     *   default this canvas will be hidden (offscreen
     *   buffer), to make visible, set element's style to
     *   display:block;
     *   @param w width of the offscreen graphics buffer
     *   @param h height of the offscreen graphics buffer
     *   @param [canvas] existing html canvas element
     *   @return offscreen graphics buffer
     */
    function createGraphics(w: number, h: number, canvas?: object): p5.Graphics;

    /**
     *   Creates and returns a new p5.Framebuffer, a
     *   high-performance WebGL object that you can draw to
     *   and then use as a texture. Options can include:
     *
     *   - format: The data format of the texture, either
     *   UNSIGNED_BYTE, FLOAT, or HALF_FLOAT. The default
     *   is UNSIGNED_BYTE.
     *   - channels: What color channels to store, either
     *   RGB or RGBA. The default is to match the channels
     *   in the main canvas (with alpha unless disabled
     *   with setAttributes.)
     *   - depth: A boolean, whether or not to include a
     *   depth buffer. Defaults to true.
     *   - depthFormat: The data format for depth
     *   information, either UNSIGNED_INT or FLOAT. The
     *   default is FLOAT if available, or UNSIGNED_INT
     *   otherwise.
     *   - antialias: Boolean or Number, whether or not to
     *   render with antialiased edges, and if so,
     *   optionally the number of samples to use. Defaults
     *   to whether or not the main canvas is antialiased,
     *   using a default of 2 samples if so. Antialiasing
     *   is only supported when WebGL 2 is available.
     *   - width: The width of the texture. Defaults to
     *   matching the main canvas.
     *   - height: The height of the texture. Defaults to
     *   matching the main canvas.
     *   - density: The pixel density of the texture.
     *   Defaults to the pixel density of the main canvas.
     *   - textureFiltering: Either LINEAR (nearby pixels
     *   will be interpolated when reading values from the
     *   color texture) or NEAREST (no interpolation.)
     *   Generally, use LINEAR when using the texture as an
     *   image, and use NEAREST if reading the texture as
     *   data. Defaults to LINEAR.
     *
     *   If width, height, or density are specified, then
     *   the framebuffer will keep that size until manually
     *   changed. Otherwise, it will be autosized, and it
     *   will update to match the main canvas's size and
     *   density when the main canvas changes.
     *   @param [options] An optional object with
     *   configuration
     */
    function createFramebuffer(options?: object): void;

    /**
     *   Blends the pixels in the display window according
     *   to the defined mode. There is a choice of the
     *   following modes to blend the source pixels (A)
     *   with the ones of pixels already in the display
     *   window (B): - BLEND - linear interpolation of
     *   colours: C = A*factor + B. This is the default
     *   blending mode.
     *   - ADD - sum of A and B
     *   - DARKEST - only the darkest colour succeeds: C =
     *   min(A*factor, B).
     *   - LIGHTEST - only the lightest colour succeeds: C
     *   = max(A*factor, B).
     *   - DIFFERENCE - subtract colors from underlying
     *   image. (2D)
     *   - EXCLUSION - similar to DIFFERENCE, but less
     *   extreme.
     *   - MULTIPLY - multiply the colors, result will
     *   always be darker.
     *   - SCREEN - opposite multiply, uses inverse values
     *   of the colors.
     *   - REPLACE - the pixels entirely replace the others
     *   and don't utilize alpha (transparency) values.
     *   - REMOVE - removes pixels from B with the alpha
     *   strength of A.
     *   - OVERLAY - mix of MULTIPLY and SCREEN .
     *   Multiplies dark values, and screens light values.
     *   (2D)
     *   - HARD_LIGHT - SCREEN when greater than 50% gray,
     *   MULTIPLY when lower. (2D)
     *   - SOFT_LIGHT - mix of DARKEST and LIGHTEST. Works
     *   like OVERLAY, but not as harsh. (2D)
     *   - DODGE - lightens light tones and increases
     *   contrast, ignores darks. (2D)
     *   - BURN - darker areas are applied, increasing
     *   contrast, ignores lights. (2D)
     *   - SUBTRACT - remainder of A and B (3D)
     *
     *   (2D) indicates that this blend mode only works in
     *   the 2D renderer.
     *
     *   (3D) indicates that this blend mode only works in
     *   the WEBGL renderer.
     *   @param mode blend mode to set for canvas. either
     *   BLEND, DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
     *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
     *   SOFT_LIGHT, DODGE, BURN, ADD, REMOVE or SUBTRACT
     */
    function blendMode(mode: p5.BLEND_MODE): void;

    /**
     *   The p5.js API provides a lot of functionality for
     *   creating graphics, but there is some native HTML5
     *   Canvas functionality that is not exposed by p5.
     *   You can still call it directly using the variable
     *   drawingContext, as in the example shown. This is
     *   the equivalent of calling canvas.getContext('2d');
     *   or canvas.getContext('webgl');. See this
     *   reference for the native canvas API for possible
     *   drawing functions you can call.
     */
    let drawingContext: any;

    /**
     *   Stops p5.js from continuously executing the code
     *   within draw(). If loop() is called, the code in
     *   draw() begins to run continuously again. If using
     *   noLoop() in setup(), it should be the last line
     *   inside the block. When noLoop() is used, it's not
     *   possible to manipulate or access the screen inside
     *   event handling functions such as mousePressed() or
     *   keyPressed(). Instead, use those functions to call
     *   redraw() or loop(), which will run draw(), which
     *   can update the screen properly. This means that
     *   when noLoop() has been called, no drawing can
     *   happen, and functions like saveFrames() or
     *   loadPixels() may not be used.
     *
     *   Note that if the sketch is resized, redraw() will
     *   be called to update the sketch, even after
     *   noLoop() has been specified. Otherwise, the sketch
     *   would enter an odd state until loop() was called.
     *
     *   Use isLooping() to check the current state of
     *   loop().
     */
    function noLoop(): void;

    /**
     *   By default, p5.js loops through draw()
     *   continuously, executing the code within it.
     *   However, the draw() loop may be stopped by calling
     *   noLoop(). In that case, the draw() loop can be
     *   resumed with loop(). Avoid calling loop() from
     *   inside setup().
     *
     *   Use isLooping() to check the current state of
     *   loop().
     */
    function loop(): void;

    /**
     *   By default, p5.js loops through draw()
     *   continuously, executing the code within it. If the
     *   sketch is stopped with noLoop() or resumed with
     *   loop(), isLooping() returns the current state for
     *   use within custom event handlers.
     */
    function isLooping(): boolean;

    /**
     *   The push() function saves the current drawing
     *   style settings and transformations, while pop()
     *   restores these settings. Note that these functions
     *   are always used together. They allow you to change
     *   the style and transformation settings and later
     *   return to what you had. When a new state is
     *   started with push(), it builds on the current
     *   style and transform information. The push() and
     *   pop() functions can be embedded to provide more
     *   control. (See the second example for a
     *   demonstration.) push() stores information related
     *   to the current transformation state and style
     *   settings controlled by the following functions:
     *   fill(), noFill(), noStroke(), stroke(), tint(),
     *   noTint(), strokeWeight(), strokeCap(),
     *   strokeJoin(), imageMode(), rectMode(),
     *   ellipseMode(), colorMode(), textAlign(),
     *   textFont(), textSize(), textLeading(),
     *   applyMatrix(), resetMatrix(), rotate(), scale(),
     *   shearX(), shearY(), translate(), noiseSeed().
     *
     *   In WEBGL mode additional style settings are
     *   stored. These are controlled by the following
     *   functions: setCamera(), ambientLight(),
     *   directionalLight(), pointLight(), texture(),
     *   specularMaterial(), shininess(), normalMaterial()
     *   and shader().
     */
    function push(): void;

    /**
     *   The push() function saves the current drawing
     *   style settings and transformations, while pop()
     *   restores these settings. Note that these functions
     *   are always used together. They allow you to change
     *   the style and transformation settings and later
     *   return to what you had. When a new state is
     *   started with push(), it builds on the current
     *   style and transform information. The push() and
     *   pop() functions can be embedded to provide more
     *   control. (See the second example for a
     *   demonstration.) push() stores information related
     *   to the current transformation state and style
     *   settings controlled by the following functions:
     *   fill(), noFill(), noStroke(), stroke(), tint(),
     *   noTint(), strokeWeight(), strokeCap(),
     *   strokeJoin(), imageMode(), rectMode(),
     *   ellipseMode(), colorMode(), textAlign(),
     *   textFont(), textSize(), textLeading(),
     *   applyMatrix(), resetMatrix(), rotate(), scale(),
     *   shearX(), shearY(), translate(), noiseSeed().
     *
     *   In WEBGL mode additional style settings are
     *   stored. These are controlled by the following
     *   functions: setCamera(), ambientLight(),
     *   directionalLight(), pointLight(), texture(),
     *   specularMaterial(), shininess(), normalMaterial()
     *   and shader().
     */
    function pop(): void;

    /**
     *   Executes the code within draw() one time. This
     *   function allows the program to update the display
     *   window only when necessary, for example when an
     *   event registered by mousePressed() or keyPressed()
     *   occurs. In structuring a program, it only makes
     *   sense to call redraw() within events such as
     *   mousePressed(). This is because redraw() does not
     *   run draw() immediately (it only sets a flag that
     *   indicates an update is needed).
     *
     *   The redraw() function does not work properly when
     *   called inside draw().To enable/disable animations,
     *   use loop() and noLoop().
     *
     *   In addition you can set the number of redraws per
     *   method call. Just add an integer as single
     *   parameter for the number of redraws.
     *   @param [n] Redraw for n-times. The default value
     *   is 1.
     */
    function redraw(n?: number): void;

    /**
     *   The p5() constructor enables you to activate
     *   "instance mode" instead of normal "global mode".
     *   This is an advanced topic. A short description and
     *   example is included below. Please see  Dan
     *   Shiffman's Coding Train video tutorial or this
     *   tutorial page for more info. By default, all p5.js
     *   functions are in the global namespace (i.e. bound
     *   to the window object), meaning you can call them
     *   simply ellipse(), fill(), etc. However, this might
     *   be inconvenient if you are mixing with other JS
     *   libraries (synchronously or asynchronously) or
     *   writing long programs of your own. p5.js currently
     *   supports a way around this problem called
     *   "instance mode". In instance mode, all p5
     *   functions are bound up in a single variable
     *   instead of polluting your global namespace.
     *
     *   Optionally, you can specify a default container
     *   for the canvas and any other elements to append to
     *   with a second argument. You can give the ID of an
     *   element in your html, or an html node itself.
     *
     *   Note that creating instances like this also allows
     *   you to have more than one p5 sketch on a single
     *   web page, as they will each be wrapped up with
     *   their own set up variables. Of course, you could
     *   also use iframes to have multiple sketches in
     *   global mode.
     *   @param sketch a function containing a p5.js sketch
     *   @param node ID or pointer to HTML DOM node to
     *   contain sketch in
     */
    function p5(sketch: object, node: string | object): void;

    /**
     *   Multiplies the current matrix by the one specified
     *   through the parameters. This is a powerful
     *   operation that can perform the equivalent of
     *   translate, scale, shear and rotate all at once.
     *   You can learn more about transformation matrices
     *   on  Wikipedia. The naming of the arguments here
     *   follows the naming of the  WHATWG specification
     *   and corresponds to a transformation matrix of the
     *   form:
     *   @param arr an array of numbers - should be 6 or 16
     *   length (2×3 or 4×4 matrix values)
     *   @chainable
     */
    function applyMatrix(arr: any[]): p5;

    /**
     *   Multiplies the current matrix by the one specified
     *   through the parameters. This is a powerful
     *   operation that can perform the equivalent of
     *   translate, scale, shear and rotate all at once.
     *   You can learn more about transformation matrices
     *   on  Wikipedia. The naming of the arguments here
     *   follows the naming of the  WHATWG specification
     *   and corresponds to a transformation matrix of the
     *   form:
     *   @param a numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param b numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param c numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param d numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param e numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param f numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @chainable
     */
    function applyMatrix(a: number, b: number, c: number, d: number, e: number, f: number): p5;

    /**
     *   Multiplies the current matrix by the one specified
     *   through the parameters. This is a powerful
     *   operation that can perform the equivalent of
     *   translate, scale, shear and rotate all at once.
     *   You can learn more about transformation matrices
     *   on  Wikipedia. The naming of the arguments here
     *   follows the naming of the  WHATWG specification
     *   and corresponds to a transformation matrix of the
     *   form:
     *   @param a numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param b numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param c numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param d numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param e numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param f numbers which define the 2×3 or 4×4
     *   matrix to be multiplied
     *   @param g numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param h numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param i numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param j numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param k numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param l numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param m numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param n numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param o numbers which define the 4×4 matrix to be
     *   multiplied
     *   @param p numbers which define the 4×4 matrix to be
     *   multiplied
     *   @chainable
     */
    function applyMatrix(
        a: number,
        b: number,
        c: number,
        d: number,
        e: number,
        f: number,
        g: number,
        h: number,
        i: number,
        j: number,
        k: number,
        l: number,
        m: number,
        n: number,
        o: number,
        p: number
    ): p5;

    /**
     *   Replaces the current matrix with the identity
     *   matrix.
     *   @chainable
     */
    function resetMatrix(): p5;

    /**
     *   Rotates a shape by the amount specified by the
     *   angle parameter. This function accounts for
     *   angleMode, so angles can be entered in either
     *   RADIANS or DEGREES. Objects are always rotated
     *   around their relative position to the origin and
     *   positive numbers rotate objects in a clockwise
     *   direction. Transformations apply to everything
     *   that happens after and subsequent calls to the
     *   function accumulate the effect. For example,
     *   calling rotate(HALF_PI) and then rotate(HALF_PI)
     *   is the same as rotate(PI). All transformations are
     *   reset when draw() begins again.
     *
     *   Technically, rotate() multiplies the current
     *   transformation matrix by a rotation matrix. This
     *   function can be further controlled by push() and
     *   pop().
     *   @param angle the angle of rotation, specified in
     *   radians or degrees, depending on current angleMode
     *   @param [axis] (in 3d) the axis to rotate around
     *   @chainable
     */
    function rotate(angle: number, axis?: p5.Vector | number[]): p5;

    /**
     *   Rotates a shape around X axis by the amount
     *   specified in angle parameter. The angles can be
     *   entered in either RADIANS or DEGREES. Objects are
     *   always rotated around their relative position to
     *   the origin and positive numbers rotate objects in
     *   a clockwise direction. All transformations are
     *   reset when draw() begins again.
     *   @param angle the angle of rotation, specified in
     *   radians or degrees, depending on current angleMode
     *   @chainable
     */
    function rotateX(angle: number): p5;

    /**
     *   Rotates a shape around Y axis by the amount
     *   specified in angle parameter. The angles can be
     *   entered in either RADIANS or DEGREES. Objects are
     *   always rotated around their relative position to
     *   the origin and positive numbers rotate objects in
     *   a clockwise direction. All transformations are
     *   reset when draw() begins again.
     *   @param angle the angle of rotation, specified in
     *   radians or degrees, depending on current angleMode
     *   @chainable
     */
    function rotateY(angle: number): p5;

    /**
     *   Rotates a shape around Z axis by the amount
     *   specified in angle parameter. The angles can be
     *   entered in either RADIANS or DEGREES. This method
     *   works in WEBGL mode only.
     *
     *   Objects are always rotated around their relative
     *   position to the origin and positive numbers rotate
     *   objects in a clockwise direction. All
     *   transformations are reset when draw() begins
     *   again.
     *   @param angle the angle of rotation, specified in
     *   radians or degrees, depending on current angleMode
     *   @chainable
     */
    function rotateZ(angle: number): p5;

    /**
     *   Increases or decreases the size of a shape by
     *   expanding or contracting vertices. Objects always
     *   scale from their relative origin to the coordinate
     *   system. Scale values are specified as decimal
     *   percentages. For example, the function call
     *   scale(2.0) increases the dimension of a shape by
     *   200%. Transformations apply to everything that
     *   happens after and subsequent calls to the function
     *   multiply the effect. For example, calling
     *   scale(2.0) and then scale(1.5) is the same as
     *   scale(3.0). If scale() is called within draw(),
     *   the transformation is reset when the loop begins
     *   again.
     *
     *   Using this function with the z parameter is only
     *   available in WEBGL mode. This function can be
     *   further controlled with push() and pop().
     *   @param s percent to scale the object, or
     *   percentage to scale the object in the x-axis if
     *   multiple arguments are given
     *   @param [y] percent to scale the object in the
     *   y-axis
     *   @param [z] percent to scale the object in the
     *   z-axis (webgl only)
     *   @chainable
     */
    function scale(s: number | p5.Vector | number[], y?: number, z?: number): p5;

    /**
     *   Increases or decreases the size of a shape by
     *   expanding or contracting vertices. Objects always
     *   scale from their relative origin to the coordinate
     *   system. Scale values are specified as decimal
     *   percentages. For example, the function call
     *   scale(2.0) increases the dimension of a shape by
     *   200%. Transformations apply to everything that
     *   happens after and subsequent calls to the function
     *   multiply the effect. For example, calling
     *   scale(2.0) and then scale(1.5) is the same as
     *   scale(3.0). If scale() is called within draw(),
     *   the transformation is reset when the loop begins
     *   again.
     *
     *   Using this function with the z parameter is only
     *   available in WEBGL mode. This function can be
     *   further controlled with push() and pop().
     *   @param scales per-axis percents to scale the
     *   object
     *   @chainable
     */
    function scale(scales: p5.Vector | number[]): p5;

    /**
     *   Shears a shape around the x-axis by the amount
     *   specified by the angle parameter. Angles should be
     *   specified in the current angleMode. Objects are
     *   always sheared around their relative position to
     *   the origin and positive numbers shear objects in a
     *   clockwise direction. Transformations apply to
     *   everything that happens after and subsequent calls
     *   to the function accumulates the effect. For
     *   example, calling shearX(PI/2) and then
     *   shearX(PI/2) is the same as shearX(PI). If
     *   shearX() is called within the draw(), the
     *   transformation is reset when the loop begins
     *   again.
     *
     *   Technically, shearX() multiplies the current
     *   transformation matrix by a rotation matrix. This
     *   function can be further controlled by the push()
     *   and pop() functions.
     *   @param angle angle of shear specified in radians
     *   or degrees, depending on current angleMode
     *   @chainable
     */
    function shearX(angle: number): p5;

    /**
     *   Shears a shape around the y-axis the amount
     *   specified by the angle parameter. Angles should be
     *   specified in the current angleMode. Objects are
     *   always sheared around their relative position to
     *   the origin and positive numbers shear objects in a
     *   clockwise direction. Transformations apply to
     *   everything that happens after and subsequent calls
     *   to the function accumulates the effect. For
     *   example, calling shearY(PI/2) and then
     *   shearY(PI/2) is the same as shearY(PI). If
     *   shearY() is called within the draw(), the
     *   transformation is reset when the loop begins
     *   again.
     *
     *   Technically, shearY() multiplies the current
     *   transformation matrix by a rotation matrix. This
     *   function can be further controlled by the push()
     *   and pop() functions.
     *   @param angle angle of shear specified in radians
     *   or degrees, depending on current angleMode
     *   @chainable
     */
    function shearY(angle: number): p5;

    /**
     *   Specifies an amount to displace objects within the
     *   display window. The x parameter specifies
     *   left/right translation, the y parameter specifies
     *   up/down translation. Transformations are
     *   cumulative and apply to everything that happens
     *   after and subsequent calls to the function
     *   accumulates the effect. For example, calling
     *   translate(50, 0) and then translate(20, 0) is the
     *   same as translate(70, 0). If translate() is called
     *   within draw(), the transformation is reset when
     *   the loop begins again. This function can be
     *   further controlled by using push() and pop().
     *   @param x left/right translation
     *   @param y up/down translation
     *   @param [z] forward/backward translation (WEBGL
     *   only)
     *   @chainable
     */
    function translate(x: number, y: number, z?: number): p5;

    /**
     *   Specifies an amount to displace objects within the
     *   display window. The x parameter specifies
     *   left/right translation, the y parameter specifies
     *   up/down translation. Transformations are
     *   cumulative and apply to everything that happens
     *   after and subsequent calls to the function
     *   accumulates the effect. For example, calling
     *   translate(50, 0) and then translate(20, 0) is the
     *   same as translate(70, 0). If translate() is called
     *   within draw(), the transformation is reset when
     *   the loop begins again. This function can be
     *   further controlled by using push() and pop().
     *   @param vector the vector to translate by
     *   @chainable
     */
    function translate(vector: p5.Vector): p5;

    /**
     *   Stores a value in local storage under the key
     *   name. Local storage is saved in the browser and
     *   persists between browsing sessions and page
     *   reloads. The key can be the name of the variable
     *   but doesn't have to be. To retrieve stored items
     *   see getItem. Sensitive data such as passwords or
     *   personal information should not be stored in local
     *   storage.
     */
    function storeItem(key: string, value: string | number | object | boolean | p5.Color | p5.Vector): void;

    /**
     *   Returns the value of an item that was stored in
     *   local storage using storeItem()
     *   @param key name that you wish to use to store in
     *   local storage
     *   @return Value of stored item
     */
    function getItem(key: string): number | object | string | boolean | p5.Color | p5.Vector;

    /**
     *   Clears all local storage items set with
     *   storeItem() for the current domain.
     */
    function clearStorage(): void;

    /**
     *   Removes an item that was stored with storeItem()
     */
    function removeItem(key: string): void;

    /**
     *   Creates a new instance of p5.StringDict using the
     *   key-value pair or the object you provide.
     */
    function createStringDict(key: string, value: string): p5.StringDict;

    /**
     *   Creates a new instance of p5.StringDict using the
     *   key-value pair or the object you provide.
     *   @param object object
     */
    function createStringDict(object: object): p5.StringDict;

    /**
     *   Creates a new instance of p5.NumberDict using the
     *   key-value pair or object you provide.
     */
    function createNumberDict(key: number, value: number): p5.NumberDict;

    /**
     *   Creates a new instance of p5.NumberDict using the
     *   key-value pair or object you provide.
     *   @param object object
     */
    function createNumberDict(object: object): p5.NumberDict;

    /**
     *   Searches the page for the first element that
     *   matches the given CSS selector string (can be an
     *   ID, class, tag name or a combination) and returns
     *   it as a p5.Element. The DOM node itself can be
     *   accessed with .elt. Returns null if none found.
     *   You can also specify a container to search within.
     *   @param selectors CSS selector string of element to
     *   search for
     *   @param [container] CSS selector string,
     *   p5.Element, or HTML element to search within
     *   @return p5.Element containing node found
     */
    function select(selectors: string, container?: string | p5.Element | HTMLElement): p5.Element | null;

    /**
     *   Searches the page for elements that match the
     *   given CSS selector string (can be an ID a class,
     *   tag name or a combination) and returns them as
     *   p5.Elements in an array. The DOM node itself can
     *   be accessed with .elt. Returns an empty array if
     *   none found. You can also specify a container to
     *   search within.
     *   @param selectors CSS selector string of elements
     *   to search for
     *   @param [container] CSS selector string, p5.Element
     *   , or HTML element to search within
     *   @return Array of p5.Elements containing nodes
     *   found
     */
    function selectAll(selectors: string, container?: string | p5.Element | HTMLElement): p5.Element[];

    /**
     *   Removes all elements created by p5, except any
     *   canvas / graphics elements created by createCanvas
     *   or createGraphics. Event handlers are removed, and
     *   element is removed from the DOM.
     */
    function removeElements(): void;

    /**
     *   The .changed() function is called when the value
     *   of an element changes. This can be used to attach
     *   an element specific event listener.
     *   @param fxn function to be fired when the value of
     *   an element changes. if false is passed instead,
     *   the previously firing function will no longer
     *   fire.
     *   @chainable
     */
    function changed(fxn: ((...args: any[]) => any) | boolean): p5;

    /**
     *   The .input() function is called when any user
     *   input is detected with an element. The input event
     *   is often used to detect keystrokes in a input
     *   element, or changes on a slider element. This can
     *   be used to attach an element specific event
     *   listener.
     *   @param fxn function to be fired when any user
     *   input is detected within the element. if false is
     *   passed instead, the previously firing function
     *   will no longer fire.
     *   @chainable
     */
    function input(fxn: ((...args: any[]) => any) | boolean): p5;

    /**
     *   Creates a <div></div> element in the DOM with
     *   given inner HTML.
     *   @param [html] inner HTML for element created
     *   @return pointer to p5.Element holding created node
     */
    function createDiv(html?: string): p5.Element;

    /**
     *   Creates a <p></p> element in the DOM with given
     *   inner HTML. Used for paragraph length text.
     *   @param [html] inner HTML for element created
     *   @return pointer to p5.Element holding created node
     */
    function createP(html?: string): p5.Element;

    /**
     *   Creates a <span></span> element in the DOM with
     *   given inner HTML.
     *   @param [html] inner HTML for element created
     *   @return pointer to p5.Element holding created node
     */
    function createSpan(html?: string): p5.Element;

    /**
     *   Creates an <img> element in the DOM with given src
     *   and alternate text.
     *   @param src src path or url for image
     *   @param alt alternate text to be used if image does
     *   not load. You can use also an empty string ("") if
     *   that an image is not intended to be viewed.
     *   @return pointer to p5.Element holding created node
     */
    function createImg(src: string, alt: string): p5.Element;

    /**
     *   Creates an <img> element in the DOM with given src
     *   and alternate text.
     *   @param src src path or url for image
     *   @param alt alternate text to be used if image does
     *   not load. You can use also an empty string ("") if
     *   that an image is not intended to be viewed.
     *   @param crossOrigin crossOrigin property of the img
     *   element; use either 'anonymous' or
     *   'use-credentials' to retrieve the image with
     *   cross-origin access (for later use with canvas. if
     *   an empty string("") is passed, CORS is not used
     *   @param [successCallback] callback to be called
     *   once image data is loaded with the p5.Element as
     *   argument
     *   @return pointer to p5.Element holding created node
     */
    function createImg(
        src: string,
        alt: string,
        crossOrigin: string,
        successCallback?: (...args: any[]) => any
    ): p5.Element;

    /**
     *   Creates an <a></a> element in the DOM for
     *   including a hyperlink.
     *   @param href url of page to link to
     *   @param html inner html of link element to display
     *   @param [target] target where new link should open,
     *   could be _blank, _self, _parent, _top.
     *   @return pointer to p5.Element holding created node
     */
    function createA(href: string, html: string, target?: string): p5.Element;

    /**
     *   Creates a slider <input></input> element in the
     *   DOM. Use .size() to set the display length of the
     *   slider.
     *   @param min minimum value of the slider
     *   @param max maximum value of the slider
     *   @param [value] default value of the slider
     *   @param [step] step size for each tick of the
     *   slider (if step is set to 0, the slider will move
     *   continuously from the minimum to the maximum
     *   value)
     *   @return pointer to p5.Element holding the created
     *   node
     */
    function createSlider(min: number, max: number, value?: number, step?: number): p5.Element;

    /**
     *   Creates a <button></button> element in the DOM.
     *   Use .size() to set the display size of the button.
     *   Use .mousePressed() to specify behavior on press.
     *   @param label label displayed on the button
     *   @param [value] value of the button
     *   @return pointer to p5.Element holding created node
     */
    function createButton(label: string, value?: string): p5.Element;

    /**
     *   Creates a checkbox <input></input> element in the
     *   DOM. Calling .checked() on a checkbox returns a
     *   boolean indicating whether it is checked or not.
     *   @param [label] label displayed after checkbox
     *   @param [value] value of the checkbox; checked is
     *   true, unchecked is false
     *   @return pointer to p5.Element holding created node
     */
    function createCheckbox(label?: string, value?: boolean): p5.Element;

    /**
     *   Creates a dropdown menu <select></select> element
     *   in the DOM. It also assigns select-related methods
     *   to p5.Element when selecting an existing select
     *   box. Options in the menu are unique by name (the
     *   display text). - .option(name, [value]) can be
     *   used to add an option with name (the display text)
     *   and value to the select element. If an option with
     *   name already exists within the select element,
     *   this method will change its value to value.
     *   - .value() will return the currently selected
     *   option.
     *   - .selected() will return the current dropdown
     *   element which is an instance of p5.Element.
     *   - .selected(value) can be used to make given
     *   option selected by default when the page first
     *   loads.
     *   - .disable() marks the whole dropdown element as
     *   disabled.
     *   - .disable(value) marks a given option as
     *   disabled.
     *   - .enable() marks the whole dropdown element as
     *   enabled if whole dropdown element is disabled
     *   intially.
     *   - .enable(value) marks a given option as enable if
     *   the initial option is disabled.
     *   @param [multiple] true if dropdown should support
     *   multiple selections
     *   @return pointer to p5.Element holding created node
     */
    function createSelect(multiple?: boolean): p5.Element;

    /**
     *   Creates a dropdown menu <select></select> element
     *   in the DOM. It also assigns select-related methods
     *   to p5.Element when selecting an existing select
     *   box. Options in the menu are unique by name (the
     *   display text). - .option(name, [value]) can be
     *   used to add an option with name (the display text)
     *   and value to the select element. If an option with
     *   name already exists within the select element,
     *   this method will change its value to value.
     *   - .value() will return the currently selected
     *   option.
     *   - .selected() will return the current dropdown
     *   element which is an instance of p5.Element.
     *   - .selected(value) can be used to make given
     *   option selected by default when the page first
     *   loads.
     *   - .disable() marks the whole dropdown element as
     *   disabled.
     *   - .disable(value) marks a given option as
     *   disabled.
     *   - .enable() marks the whole dropdown element as
     *   enabled if whole dropdown element is disabled
     *   intially.
     *   - .enable(value) marks a given option as enable if
     *   the initial option is disabled.
     *   @param existing DOM select element
     */
    function createSelect(existing: object): p5.Element;

    /**
     *   Creates a radio button element in the DOM. It also
     *   helps existing radio buttons assign methods of
     *   p5.Element. - .option(value, [label]) can be used
     *   to create a new option for the element. If an
     *   option with a value already exists, it will be
     *   returned. It is recommended to use string values
     *   as input for value. Optionally, a label can be
     *   provided as second argument for the option.
     *   - .remove(value) can be used to remove an option
     *   for the element. String values recommended as
     *   input for value.
     *   - .value() method will return the currently
     *   selected value.
     *   - .selected() method will return the currently
     *   selected input element.
     *   - .selected(value) method will select the option
     *   and return it. String values recommended as input
     *   for value.
     *   - .disable(Boolean) method will enable/disable the
     *   whole radio button element.
     *   @param containerElement A container HTML Element,
     *   either a div or span, inside which all existing
     *   radio inputs will be considered as options.
     *   @param [name] A name parameter for each Input
     *   Element.
     *   @return pointer to p5.Element holding created node
     */
    function createRadio(containerElement: object, name?: string): p5.Element;

    /**
     *   Creates a radio button element in the DOM. It also
     *   helps existing radio buttons assign methods of
     *   p5.Element. - .option(value, [label]) can be used
     *   to create a new option for the element. If an
     *   option with a value already exists, it will be
     *   returned. It is recommended to use string values
     *   as input for value. Optionally, a label can be
     *   provided as second argument for the option.
     *   - .remove(value) can be used to remove an option
     *   for the element. String values recommended as
     *   input for value.
     *   - .value() method will return the currently
     *   selected value.
     *   - .selected() method will return the currently
     *   selected input element.
     *   - .selected(value) method will select the option
     *   and return it. String values recommended as input
     *   for value.
     *   - .disable(Boolean) method will enable/disable the
     *   whole radio button element.
     *   @param name A name parameter for each Input
     *   Element.
     *   @return pointer to p5.Element holding created node
     */
    function createRadio(name: string): p5.Element;

    /**
     *   Creates a radio button element in the DOM. It also
     *   helps existing radio buttons assign methods of
     *   p5.Element. - .option(value, [label]) can be used
     *   to create a new option for the element. If an
     *   option with a value already exists, it will be
     *   returned. It is recommended to use string values
     *   as input for value. Optionally, a label can be
     *   provided as second argument for the option.
     *   - .remove(value) can be used to remove an option
     *   for the element. String values recommended as
     *   input for value.
     *   - .value() method will return the currently
     *   selected value.
     *   - .selected() method will return the currently
     *   selected input element.
     *   - .selected(value) method will select the option
     *   and return it. String values recommended as input
     *   for value.
     *   - .disable(Boolean) method will enable/disable the
     *   whole radio button element.
     *   @return pointer to p5.Element holding created node
     */
    function createRadio(): p5.Element;

    /**
     *   Creates a colorPicker element in the DOM for color
     *   input. The .value() method will return a hex
     *   string (#rrggbb) of the color. The .color() method
     *   will return a p5.Color object with the current
     *   chosen color.
     *   @param [value] default color of element
     *   @return pointer to p5.Element holding created node
     */
    function createColorPicker(value?: string | p5.Color): p5.Element;

    /**
     *   Creates an <input></input> element in the DOM for
     *   text input. Use .size() to set the display length
     *   of the box.
     *   @param value default value of the input box
     *   @param [type] type of text, ie text, password etc.
     *   Defaults to text. Needs a value to be specified
     *   first.
     *   @return pointer to p5.Element holding created node
     */
    function createInput(value: string, type?: string): p5.Element;

    /**
     *   Creates an <input></input> element in the DOM for
     *   text input. Use .size() to set the display length
     *   of the box.
     *   @param [value] default value of the input box
     */
    function createInput(value?: string): p5.Element;

    /**
     *   Creates an <input></input> element in the DOM of
     *   type 'file'. This allows users to select local
     *   files for use in a sketch.
     *   @param callback callback function for when a file
     *   is loaded
     *   @param [multiple] optional, to allow multiple
     *   files to be selected
     *   @return pointer to p5.Element holding created DOM
     *   element
     */
    function createFileInput(callback: (...args: any[]) => any, multiple?: boolean): p5.Element;

    /**
     *   Creates an HTML5 <video> element in the DOM for
     *   simple playback of audio/video. Shown by default,
     *   can be hidden with .hide() and drawn into canvas
     *   using image(). The first parameter can be either a
     *   single string path to a video file, or an array of
     *   string paths to different formats of the same
     *   video. This is useful for ensuring that your video
     *   can play across different browsers, as each
     *   supports different formats. See this page for
     *   further information about supported formats.
     *   @param src path to a video file, or array of paths
     *   for supporting different browsers
     *   @param [callback] callback function to be called
     *   upon 'canplaythrough' event fire, that is, when
     *   the browser can play the media, and estimates that
     *   enough data has been loaded to play the media up
     *   to its end without having to stop for further
     *   buffering of content
     *   @return pointer to video p5.MediaElement
     */
    function createVideo(src: string | string[], callback?: (...args: any[]) => any): p5.MediaElement;

    /**
     *   Creates a hidden HTML5 <audio> element in the DOM
     *   for simple audio playback. The first parameter can
     *   be either a single string path to a audio file, or
     *   an array of string paths to different formats of
     *   the same audio. This is useful for ensuring that
     *   your audio can play across different browsers, as
     *   each supports different formats. See this page for
     *   further information about supported formats.
     *   @param [src] path to an audio file, or array of
     *   paths for supporting different browsers
     *   @param [callback] callback function to be called
     *   upon 'canplaythrough' event fire, that is, when
     *   the browser can play the media, and estimates that
     *   enough data has been loaded to play the media up
     *   to its end without having to stop for further
     *   buffering of content
     *   @return pointer to audio p5.MediaElement
     */
    function createAudio(src?: string | string[], callback?: (...args: any[]) => any): p5.MediaElement;

    /**
     *   Creates a new HTML5 <video> element that contains
     *   the audio/video feed from a webcam. The element is
     *   separate from the canvas and is displayed by
     *   default. The element can be hidden using .hide().
     *   The feed can be drawn onto the canvas using
     *   image(). The loadedmetadata property can be used
     *   to detect when the element has fully loaded (see
     *   second example). More specific properties of the
     *   feed can be passing in a Constraints object. See
     *   the  W3C spec for possible properties. Note that
     *   not all of these are supported by all browsers.
     *
     *   Security note: A new browser security
     *   specification requires that getUserMedia, which is
     *   behind createCapture(), only works when you're
     *   running the code locally, or on HTTPS. Learn more
     *   here and here.
     *   @param type type of capture, either VIDEO or AUDIO
     *   if none specified, default both, or a Constraints
     *   object
     *   @param [callback] function to be called once
     *   stream has loaded
     *   @return capture video p5.Element
     */
    function createCapture(type: string | p5.TYPE | object, callback?: (...args: any[]) => any): p5.Element;

    /**
     *   Creates element with given tag in the DOM with
     *   given content.
     *   @param tag tag for the new element
     *   @param [content] html content to be inserted into
     *   the element
     *   @return pointer to p5.Element holding created node
     */
    function createElement(tag: string, content?: string): p5.Element;

    /**
     *   The setMoveThreshold() function is used to set the
     *   movement threshold for the deviceMoved() function.
     *   The default threshold is set to 0.5.
     *   @param value The threshold value
     */
    function setMoveThreshold(value: number): void;

    /**
     *   The setShakeThreshold() function is used to set
     *   the movement threshold for the deviceShaken()
     *   function. The default threshold is set to 30.
     *   @param value The threshold value
     */
    function setShakeThreshold(value: number): void;

    /**
     *   The deviceMoved() function is called when the
     *   device is moved by more than the threshold value
     *   along X, Y or Z axis. The default threshold is set
     *   to 0.5. The threshold value can be changed using
     *   setMoveThreshold().
     */
    function deviceMoved(): void;

    /**
     *   The deviceTurned() function is called when the
     *   device rotates by more than 90 degrees
     *   continuously. The axis that triggers the
     *   deviceTurned() method is stored in the turnAxis
     *   variable. The deviceTurned() method can be locked
     *   to trigger on any axis: X, Y or Z by comparing the
     *   turnAxis variable to 'X', 'Y' or 'Z'.
     */
    function deviceTurned(): void;

    /**
     *   The deviceShaken() function is called when the
     *   device total acceleration changes of accelerationX
     *   and accelerationY values is more than the
     *   threshold value. The default threshold is set to
     *   30. The threshold value can be changed using
     *   setShakeThreshold().
     */
    function deviceShaken(): void;

    /**
     *   The system variable deviceOrientation always
     *   contains the orientation of the device. The value
     *   of this variable will either be set 'landscape' or
     *   'portrait'. If no data is available it will be set
     *   to 'undefined'. either LANDSCAPE or PORTRAIT.
     */
    let deviceOrientation: p5.UNKNOWN_P5_CONSTANT;

    /**
     *   The system variable accelerationX always contains
     *   the acceleration of the device along the x axis.
     *   Value is represented as meters per second squared.
     */
    let accelerationX: number;

    /**
     *   The system variable accelerationY always contains
     *   the acceleration of the device along the y axis.
     *   Value is represented as meters per second squared.
     */
    let accelerationY: number;

    /**
     *   The system variable accelerationZ always contains
     *   the acceleration of the device along the z axis.
     *   Value is represented as meters per second squared.
     */
    let accelerationZ: number;

    /**
     *   The system variable pAccelerationX always contains
     *   the acceleration of the device along the x axis in
     *   the frame previous to the current frame. Value is
     *   represented as meters per second squared.
     */
    let pAccelerationX: number;

    /**
     *   The system variable pAccelerationY always contains
     *   the acceleration of the device along the y axis in
     *   the frame previous to the current frame. Value is
     *   represented as meters per second squared.
     */
    let pAccelerationY: number;

    /**
     *   The system variable pAccelerationZ always contains
     *   the acceleration of the device along the z axis in
     *   the frame previous to the current frame. Value is
     *   represented as meters per second squared.
     */
    let pAccelerationZ: number;

    /**
     *   The system variable rotationX always contains the
     *   rotation of the device along the x axis. If the
     *   sketch  angleMode() is set to DEGREES, the value
     *   will be -180 to 180. If it is set to RADIANS, the
     *   value will be -PI to PI. Note: The order the
     *   rotations are called is important, ie. if used
     *   together, it must be called in the order Z-X-Y or
     *   there might be unexpected behaviour.
     */
    let rotationX: number;

    /**
     *   The system variable rotationY always contains the
     *   rotation of the device along the y axis. If the
     *   sketch  angleMode() is set to DEGREES, the value
     *   will be -90 to 90. If it is set to RADIANS, the
     *   value will be -PI/2 to PI/2. Note: The order the
     *   rotations are called is important, ie. if used
     *   together, it must be called in the order Z-X-Y or
     *   there might be unexpected behaviour.
     */
    let rotationY: number;

    /**
     *   The system variable rotationZ always contains the
     *   rotation of the device along the z axis. If the
     *   sketch  angleMode() is set to DEGREES, the value
     *   will be 0 to 360. If it is set to RADIANS, the
     *   value will be 0 to 2*PI. Unlike rotationX and
     *   rotationY, this variable is available for devices
     *   with a built-in compass only.
     *
     *   Note: The order the rotations are called is
     *   important, ie. if used together, it must be called
     *   in the order Z-X-Y or there might be unexpected
     *   behaviour.
     */
    let rotationZ: number;

    /**
     *   The system variable pRotationX always contains the
     *   rotation of the device along the x axis in the
     *   frame previous to the current frame. If the sketch
     *   angleMode() is set to DEGREES, the value will be
     *   -180 to 180. If it is set to RADIANS, the value
     *   will be -PI to PI. pRotationX can also be used
     *   with rotationX to determine the rotate direction
     *   of the device along the X-axis.
     */
    let pRotationX: number;

    /**
     *   The system variable pRotationY always contains the
     *   rotation of the device along the y axis in the
     *   frame previous to the current frame. If the sketch
     *   angleMode() is set to DEGREES, the value will be
     *   -90 to 90. If it is set to RADIANS, the value will
     *   be -PI/2 to PI/2. pRotationY can also be used with
     *   rotationY to determine the rotate direction of the
     *   device along the Y-axis.
     */
    let pRotationY: number;

    /**
     *   The system variable pRotationZ always contains the
     *   rotation of the device along the z axis in the
     *   frame previous to the current frame. If the sketch
     *   angleMode() is set to DEGREES, the value will be 0
     *   to 360. If it is set to RADIANS, the value will be
     *   0 to 2*PI. pRotationZ can also be used with
     *   rotationZ to determine the rotate direction of the
     *   device along the Z-axis.
     */
    let pRotationZ: number;

    /**
     *   When a device is rotated, the axis that triggers
     *   the deviceTurned() method is stored in the
     *   turnAxis variable. The turnAxis variable is only
     *   defined within the scope of deviceTurned().
     */
    let turnAxis: string;

    /**
     *   The keyPressed() function is called once every
     *   time a key is pressed. The keyCode for the key
     *   that was pressed is stored in the keyCode
     *   variable. For non-ASCII keys, use the keyCode
     *   variable. You can check if the keyCode equals
     *   BACKSPACE, DELETE, ENTER, RETURN, TAB, ESCAPE,
     *   SHIFT, CONTROL, OPTION, ALT, UP_ARROW, DOWN_ARROW,
     *   LEFT_ARROW, RIGHT_ARROW.
     *
     *   For ASCII keys, the key that was pressed is stored
     *   in the key variable. However, it does not
     *   distinguish between uppercase and lowercase. For
     *   this reason, it is recommended to use keyTyped()
     *   to read the key variable, in which the case of the
     *   variable will be distinguished.
     *
     *   Because of how operating systems handle key
     *   repeats, holding down a key may cause multiple
     *   calls to keyTyped() (and keyReleased() as well).
     *   The rate of repeat is set by the operating system
     *   and how each computer is configured.
     *
     *
     *   Browsers may have different default behaviors
     *   attached to various key events. To prevent any
     *   default behavior for this event, add "return
     *   false" to the end of the method.
     *   @param [event] optional KeyboardEvent callback
     *   argument.
     */
    function keyPressed(event?: object): void;

    /**
     *   The keyReleased() function is called once every
     *   time a key is released. See key and keyCode for
     *   more information. Browsers may have different
     *   default behaviors attached to various key events.
     *   To prevent any default behavior for this event,
     *   add "return false" to the end of the function.
     *   @param [event] optional KeyboardEvent callback
     *   argument.
     */
    function keyReleased(event?: object): void;

    /**
     *   The keyTyped() function is called once every time
     *   a key is pressed, but action keys such as
     *   Backspace, Delete, Ctrl, Shift, and Alt are
     *   ignored. If you are trying to detect a keyCode for
     *   one of these keys, use the keyPressed() function
     *   instead. The most recent key typed will be stored
     *   in the key variable. Because of how operating
     *   systems handle key repeats, holding down a key
     *   will cause multiple calls to keyTyped() (and
     *   keyReleased() as well). The rate of repeat is set
     *   by the operating system and how each computer is
     *   configured.
     *
     *
     *   Browsers may have different default behaviors
     *   attached to various key events. To prevent any
     *   default behavior for this event, add "return
     *   false" to the end of the function.
     *   @param [event] optional KeyboardEvent callback
     *   argument.
     */
    function keyTyped(event?: object): void;

    /**
     *   The keyIsDown() function checks if the key is
     *   currently down, i.e. pressed. It can be used if
     *   you have an object that moves, and you want
     *   several keys to be able to affect its behaviour
     *   simultaneously, such as moving a sprite
     *   diagonally. You can put in any number representing
     *   the keyCode of the key, or use any of the variable
     *   keyCode names listed here.
     *   @param code The key to check for.
     *   @return whether key is down or not
     */
    function keyIsDown(code: number): boolean;

    /**
     *   The boolean system variable keyIsPressed is true
     *   if any key is pressed and false if no keys are
     *   pressed.
     */
    let keyIsPressed: boolean;

    /**
     *   The system variable key always contains the value
     *   of the most recent key on the keyboard that was
     *   typed. To get the proper capitalization, it is
     *   best to use it within keyTyped(). For non-ASCII
     *   keys, use the keyCode variable.
     */
    let key: string;

    /**
     *   The variable keyCode is used to detect special
     *   keys such as BACKSPACE, DELETE, ENTER, RETURN,
     *   TAB, ESCAPE, SHIFT, CONTROL, OPTION, ALT,
     *   UP_ARROW, DOWN_ARROW, LEFT_ARROW, RIGHT_ARROW. You
     *   can also check for custom keys by looking up the
     *   keyCode of any key on a site like this:
     *   keycode.info.
     */
    let keyCode: number;

    /**
     *   The mouseMoved() function is called every time the
     *   mouse moves and a mouse button is not pressed.
     *   Browsers may have different default behaviors
     *   attached to various mouse events. To prevent any
     *   default behavior for this event, add "return
     *   false" to the end of the method.
     *   @param [event] optional MouseEvent callback
     *   argument.
     */
    function mouseMoved(event?: object): void;

    /**
     *   The mouseDragged() function is called once every
     *   time the mouse moves and a mouse button is
     *   pressed. If no mouseDragged() function is defined,
     *   the touchMoved() function will be called instead
     *   if it is defined. Browsers may have different
     *   default behaviors attached to various mouse
     *   events. To prevent any default behavior for this
     *   event, add "return false" to the end of the
     *   function.
     *   @param [event] optional MouseEvent callback
     *   argument.
     */
    function mouseDragged(event?: object): void;

    /**
     *   The mousePressed() function is called once after
     *   every time a mouse button is pressed. The
     *   mouseButton variable (see the related reference
     *   entry) can be used to determine which button has
     *   been pressed. If no mousePressed() function is
     *   defined, the touchStarted() function will be
     *   called instead if it is defined. Browsers may have
     *   different default behaviors attached to various
     *   mouse events. To prevent any default behavior for
     *   this event, add "return false" to the end of the
     *   function.
     *   @param [event] optional MouseEvent callback
     *   argument.
     */
    function mousePressed(event?: object): void;

    /**
     *   The mouseReleased() function is called every time
     *   a mouse button is released. If no mouseReleased()
     *   function is defined, the touchEnded() function
     *   will be called instead if it is defined. Browsers
     *   may have different default behaviors attached to
     *   various mouse events. To prevent any default
     *   behavior for this event, add "return false" to the
     *   end of the function.
     *   @param [event] optional MouseEvent callback
     *   argument.
     */
    function mouseReleased(event?: object): void;

    /**
     *   The mouseClicked() function is called once after a
     *   mouse button has been pressed and then released.
     *   Browsers handle clicks differently, so this
     *   function is only guaranteed to be run when the
     *   left mouse button is clicked. To handle other
     *   mouse buttons being pressed or released, see
     *   mousePressed() or mouseReleased().
     *
     *
     *   Browsers may have different default behaviors
     *   attached to various mouse events. To prevent any
     *   default behavior for this event, add "return
     *   false" to the end of the function.
     *   @param [event] optional MouseEvent callback
     *   argument.
     */
    function mouseClicked(event?: object): void;

    /**
     *   The doubleClicked() function is executed every
     *   time a event listener has detected a dblclick
     *   event which is a part of the DOM L3 specification.
     *   The doubleClicked event is fired when a pointing
     *   device button (usually a mouse's primary button)
     *   is clicked twice on a single element. For more
     *   info on the dblclick event refer to mozilla's
     *   documentation here:
     *   https://developer.mozilla.org/en-US/docs/Web/Events/dblclick
     *   @param [event] optional MouseEvent callback
     *   argument.
     */
    function doubleClicked(event?: object): void;

    /**
     *   The function mouseWheel() is executed every time a
     *   vertical mouse wheel event is detected either
     *   triggered by an actual mouse wheel or by a
     *   touchpad. The event.delta property returns the
     *   amount the mouse wheel have scrolled. The values
     *   can be positive or negative depending on the
     *   scroll direction (on macOS with "natural"
     *   scrolling enabled, the signs are inverted).
     *
     *
     *   Browsers may have different default behaviors
     *   attached to various mouse events. To prevent any
     *   default behavior for this event, add "return
     *   false" to the end of the method.
     *
     *
     *   Due to the current support of the "wheel" event on
     *   Safari, the function may only work as expected if
     *   "return false" is included while using Safari.
     *   @param [event] optional WheelEvent callback
     *   argument.
     */
    function mouseWheel(event?: object): void;

    /**
     *   The function requestPointerLock() locks the
     *   pointer to its current position and makes it
     *   invisible. Use movedX and movedY to get the
     *   difference the mouse was moved since the last call
     *   of draw. Note that not all browsers support this
     *   feature. This enables you to create experiences
     *   that aren't limited by the mouse moving out of the
     *   screen even if it is repeatedly moved into one
     *   direction. For example, a first person perspective
     *   experience.
     */
    function requestPointerLock(): void;

    /**
     *   The function exitPointerLock() exits a previously
     *   triggered pointer Lock for example to make ui
     *   elements usable etc
     */
    function exitPointerLock(): void;

    /**
     *   The variable movedX contains the horizontal
     *   movement of the mouse since the last frame
     */
    let movedX: number;

    /**
     *   The variable movedY contains the vertical movement
     *   of the mouse since the last frame
     */
    let movedY: number;

    /**
     *   The system variable mouseX always contains the
     *   current horizontal position of the mouse, relative
     *   to (0, 0) of the canvas. The value at the top-left
     *   corner is (0, 0) for 2-D and (-width/2, -height/2)
     *   for WebGL. If touch is used instead of mouse
     *   input, mouseX will hold the x value of the most
     *   recent touch point.
     */
    let mouseX: number;

    /**
     *   The system variable mouseY always contains the
     *   current vertical position of the mouse, relative
     *   to (0, 0) of the canvas. The value at the top-left
     *   corner is (0, 0) for 2-D and (-width/2, -height/2)
     *   for WebGL. If touch is used instead of mouse
     *   input, mouseY will hold the y value of the most
     *   recent touch point.
     */
    let mouseY: number;

    /**
     *   The system variable pmouseX always contains the
     *   horizontal position of the mouse or finger in the
     *   frame previous to the current frame, relative to
     *   (0, 0) of the canvas. The value at the top-left
     *   corner is (0, 0) for 2-D and (-width/2, -height/2)
     *   for WebGL. Note: pmouseX will be reset to the
     *   current mouseX value at the start of each touch
     *   event.
     */
    let pmouseX: number;

    /**
     *   The system variable pmouseY always contains the
     *   vertical position of the mouse or finger in the
     *   frame previous to the current frame, relative to
     *   (0, 0) of the canvas. The value at the top-left
     *   corner is (0, 0) for 2-D and (-width/2, -height/2)
     *   for WebGL. Note: pmouseY will be reset to the
     *   current mouseY value at the start of each touch
     *   event.
     */
    let pmouseY: number;

    /**
     *   The system variable winMouseX always contains the
     *   current horizontal position of the mouse, relative
     *   to (0, 0) of the window.
     */
    let winMouseX: number;

    /**
     *   The system variable winMouseY always contains the
     *   current vertical position of the mouse, relative
     *   to (0, 0) of the window.
     */
    let winMouseY: number;

    /**
     *   The system variable pwinMouseX always contains the
     *   horizontal position of the mouse in the frame
     *   previous to the current frame, relative to (0, 0)
     *   of the window. Note: pwinMouseX will be reset to
     *   the current winMouseX value at the start of each
     *   touch event.
     */
    let pwinMouseX: number;

    /**
     *   The system variable pwinMouseY always contains the
     *   vertical position of the mouse in the frame
     *   previous to the current frame, relative to (0, 0)
     *   of the window. Note: pwinMouseY will be reset to
     *   the current winMouseY value at the start of each
     *   touch event.
     */
    let pwinMouseY: number;

    /**
     *   p5 automatically tracks if the mouse button is
     *   pressed and which button is pressed. The value of
     *   the system variable mouseButton is either LEFT,
     *   RIGHT, or CENTER depending on which button was
     *   pressed last. Warning: different browsers may
     *   track mouseButton differently.
     */
    let mouseButton: p5.UNKNOWN_P5_CONSTANT;

    /**
     *   The boolean system variable mouseIsPressed is true
     *   if the mouse is pressed and false if not.
     */
    let mouseIsPressed: boolean;

    /**
     *   The touchStarted() function is called once after
     *   every time a touch is registered. If no
     *   touchStarted() function is defined, the
     *   mousePressed() function will be called instead if
     *   it is defined. Browsers may have different default
     *   behaviors attached to various touch events. To
     *   prevent any default behavior for this event, add
     *   "return false" to the end of the method.
     *   @param [event] optional TouchEvent callback
     *   argument.
     */
    function touchStarted(event?: object): void;

    /**
     *   The touchMoved() function is called every time a
     *   touch move is registered. If no touchMoved()
     *   function is defined, the mouseDragged() function
     *   will be called instead if it is defined. Browsers
     *   may have different default behaviors attached to
     *   various touch events. To prevent any default
     *   behavior for this event, add "return false" to the
     *   end of the method.
     *   @param [event] optional TouchEvent callback
     *   argument.
     */
    function touchMoved(event?: object): void;

    /**
     *   The touchEnded() function is called every time a
     *   touch ends. If no touchEnded() function is
     *   defined, the mouseReleased() function will be
     *   called instead if it is defined. Browsers may have
     *   different default behaviors attached to various
     *   touch events. To prevent any default behavior for
     *   this event, add "return false" to the end of the
     *   method.
     *   @param [event] optional TouchEvent callback
     *   argument.
     */
    function touchEnded(event?: object): void;

    /**
     *   The system variable touches[] contains an array of
     *   the positions of all current touch points,
     *   relative to (0, 0) of the canvas, and IDs
     *   identifying a unique touch as it moves. Each
     *   element in the array is an object with x, y, and
     *   id properties. The touches[] array is not
     *   supported on Safari and IE on touch-based desktops
     *   (laptops).
     */
    let touches: object[];

    /**
     *   Creates a new p5.Image (the datatype for storing
     *   images). This provides a fresh buffer of pixels to
     *   play with. Set the size of the buffer with the
     *   width and height parameters. .pixels gives access
     *   to an array containing the values for all the
     *   pixels in the display window. These values are
     *   numbers. This array is the size (including an
     *   appropriate factor for the pixelDensity) of the
     *   display window x4, representing the R, G, B, A
     *   values in order for each pixel, moving from left
     *   to right across each row, then down each column.
     *   See .pixels for more info. It may also be simpler
     *   to use set() or get().
     *
     *   Before accessing the pixels of an image, the data
     *   must loaded with the loadPixels() function. After
     *   the array data has been modified, the
     *   updatePixels() function must be run to update the
     *   changes.
     *   @param width width in pixels
     *   @param height height in pixels
     *   @return the p5.Image object
     */
    function createImage(width: number, height: number): p5.Image;

    /**
     *   Save the current canvas as an image. The browser
     *   will either save the file immediately, or prompt
     *   the user with a dialogue window.
     *   @param selectedCanvas a variable representing a
     *   specific html5 canvas (optional)
     *   @param [extension] 'jpg' or 'png'
     */
    function saveCanvas(selectedCanvas: p5.Element | HTMLCanvasElement, filename?: string, extension?: string): void;

    /**
     *   Save the current canvas as an image. The browser
     *   will either save the file immediately, or prompt
     *   the user with a dialogue window.
     *   @param [extension] 'jpg' or 'png'
     */
    function saveCanvas(filename?: string, extension?: string): void;

    /**
     *   Capture a sequence of frames that can be used to
     *   create a movie. Accepts a callback. For example,
     *   you may wish to send the frames to a server where
     *   they can be stored or converted into a movie. If
     *   no callback is provided, the browser will pop up
     *   save dialogues in an attempt to download all of
     *   the images that have just been created. With the
     *   callback provided the image data isn't saved by
     *   default but instead passed as an argument to the
     *   callback function as an array of objects, with the
     *   size of array equal to the total number of frames.
     *   The arguments duration and framerate are
     *   constrained to be less or equal to 15 and 22,
     *   respectively, which means you can only download a
     *   maximum of 15 seconds worth of frames at 22 frames
     *   per second, adding up to 330 frames. This is done
     *   in order to avoid memory problems since a large
     *   enough canvas can fill up the memory in your
     *   computer very easily and crash your program or
     *   even your browser.
     *
     *   To export longer animations, you might look into a
     *   library like ccapture.js.
     *   @param extension 'jpg' or 'png'
     *   @param duration Duration in seconds to save the
     *   frames for. This parameter will be constrained to
     *   be less or equal to 15.
     *   @param framerate Framerate to save the frames in.
     *   This parameter will be constrained to be less or
     *   equal to 22.
     *   @param [callback] A callback function that will be
     *   executed to handle the image data. This function
     *   should accept an array as argument. The array will
     *   contain the specified number of frames of objects.
     *   Each object has three properties: imageData - an
     *   image/octet-stream, filename and extension.
     */
    function saveFrames(
        filename: string,
        extension: string,
        duration: number,
        framerate: number,
        callback?: (p1: any[]) => any
    ): void;

    /**
     *   Loads an image from a path and creates a p5.Image
     *   from it. The image may not be immediately
     *   available for rendering. If you want to ensure
     *   that the image is ready before doing anything with
     *   it, place the loadImage() call in preload(). You
     *   may also supply a callback function to handle the
     *   image when it's ready.
     *
     *   The path to the image should be relative to the
     *   HTML file that links in your sketch. Loading an
     *   image from a URL or other remote location may be
     *   blocked due to your browser's built-in security.
     *
     *   You can also pass in a string of a base64 encoded
     *   image as an alternative to the file path. Remember
     *   to add "data:image/png;base64," in front of the
     *   string.
     *   @param path Path of the image to be loaded
     *   @param [successCallback] Function to be called
     *   once the image is loaded. Will be passed the
     *   p5.Image.
     *   @param [failureCallback] called with event error
     *   if the image fails to load.
     *   @return the p5.Image object
     */
    function loadImage(
        path: string,
        successCallback?: (p1: p5.Image) => any,
        failureCallback?: (p1: Event) => any
    ): p5.Image;

    /**
     *   Generates a gif of your current animation and
     *   downloads it to your computer! The duration
     *   argument specifies how many seconds you want to
     *   record from your animation. This value is then
     *   converted to the necessary number of frames to
     *   generate it, depending on the value of units. More
     *   on that on the next paragraph.
     *
     *   An optional object that can contain two more
     *   arguments: delay (number) and units (string).
     *
     *   delay, specifying how much time we should wait
     *   before recording
     *
     *   units, a string that can be either 'seconds' or
     *   'frames'. By default it's 'seconds'.
     *
     *   units specifies how the duration and delay
     *   arguments will behave. If 'seconds', these
     *   arguments will correspond to seconds, meaning that
     *   3 seconds worth of animation will be created. If
     *   'frames', the arguments now correspond to the
     *   number of frames you want your animation to be, if
     *   you are very sure of this number.
     *
     *   This may be called in setup, or, like in the
     *   example below, inside an event function, like
     *   keyPressed or mousePressed.
     *   @param filename File name of your gif
     *   @param duration Duration in seconds that you wish
     *   to capture from your sketch
     *   @param options An optional object that can contain
     *   five more arguments: delay, specifying how much
     *   time we should wait before recording; units, a
     *   string that can be either 'seconds' or 'frames'.
     *   By default it's 'seconds’; silent, a boolean that
     *   defines presence of progress notifications. By
     *   default it’s false; notificationDuration, a number
     *   that defines how long in seconds the final
     *   notification will live. 0, the default value,
     *   means that the notification will never be removed;
     *   notificationID, a string that specifies the
     *   notification DOM element id. By default it’s
     *   'progressBar’.
     */
    function saveGif(filename: string, duration: number, options: object): void;

    /**
     *   Draw an image to the p5.js canvas. This function
     *   can be used with different numbers of parameters.
     *   The simplest use requires only three parameters:
     *   img, x, and y—where (x, y) is the position of the
     *   image. Two more parameters can optionally be added
     *   to specify the width and height of the image.
     *
     *   This function can also be used with eight Number
     *   parameters. To differentiate between all these
     *   parameters, p5.js uses the language of
     *   "destination rectangle" (which corresponds to
     *   "dx", "dy", etc.) and "source image" (which
     *   corresponds to "sx", "sy", etc.) below. Specifying
     *   the "source image" dimensions can be useful when
     *   you want to display a subsection of the source
     *   image instead of the whole thing. Here's a diagram
     *   to explain further:
     *
     *   This function can also be used to draw images
     *   without distorting the orginal aspect ratio, by
     *   adding 9th parameter, fit, which can either be
     *   COVER or CONTAIN. CONTAIN, as the name suggests,
     *   contains the whole image within the specified
     *   destination box without distorting the image
     *   ratio. COVER covers the entire destination box.
     *   @param img the image to display
     *   @param x the x-coordinate of the top-left corner
     *   of the image
     *   @param y the y-coordinate of the top-left corner
     *   of the image
     *   @param [width] the width to draw the image
     *   @param [height] the height to draw the image
     */
    function image(
        img: p5.Image | p5.Element | p5.Framebuffer,
        x: number,
        y: number,
        width?: number,
        height?: number
    ): void;

    /**
     *   Draw an image to the p5.js canvas. This function
     *   can be used with different numbers of parameters.
     *   The simplest use requires only three parameters:
     *   img, x, and y—where (x, y) is the position of the
     *   image. Two more parameters can optionally be added
     *   to specify the width and height of the image.
     *
     *   This function can also be used with eight Number
     *   parameters. To differentiate between all these
     *   parameters, p5.js uses the language of
     *   "destination rectangle" (which corresponds to
     *   "dx", "dy", etc.) and "source image" (which
     *   corresponds to "sx", "sy", etc.) below. Specifying
     *   the "source image" dimensions can be useful when
     *   you want to display a subsection of the source
     *   image instead of the whole thing. Here's a diagram
     *   to explain further:
     *
     *   This function can also be used to draw images
     *   without distorting the orginal aspect ratio, by
     *   adding 9th parameter, fit, which can either be
     *   COVER or CONTAIN. CONTAIN, as the name suggests,
     *   contains the whole image within the specified
     *   destination box without distorting the image
     *   ratio. COVER covers the entire destination box.
     *   @param img the image to display
     *   @param dx the x-coordinate of the destination
     *   rectangle in which to draw the source image
     *   @param dy the y-coordinate of the destination
     *   rectangle in which to draw the source image
     *   @param dWidth the width of the destination
     *   rectangle
     *   @param dHeight the height of the destination
     *   rectangle
     *   @param sx the x-coordinate of the subsection of
     *   the source image to draw into the destination
     *   rectangle
     *   @param sy the y-coordinate of the subsection of
     *   the source image to draw into the destination
     *   rectangle
     *   @param [sWidth] the width of the subsection of the
     *   source image to draw into the destination
     *   rectangle
     *   @param [sHeight] the height of the subsection of
     *   the source image to draw into the destination
     *   rectangle
     *   @param [fit] either CONTAIN or COVER
     *   @param [xAlign] either LEFT, RIGHT or CENTER
     *   default is CENTER
     *   @param [yAlign] either TOP, BOTTOM or CENTER
     *   default is CENTER
     */
    function image(
        img: p5.Image | p5.Element | p5.Framebuffer,
        dx: number,
        dy: number,
        dWidth: number,
        dHeight: number,
        sx: number,
        sy: number,
        sWidth?: number,
        sHeight?: number,
        fit?: p5.IMAGE_FIT,
        xAlign?: p5.X_ALIGN,
        yAlign?: p5.Y_ALIGN
    ): void;

    /**
     *   Sets the fill value for displaying images. Images
     *   can be tinted to specified colors or made
     *   transparent by including an alpha value. To apply
     *   transparency to an image without affecting its
     *   color, use white as the tint color and specify an
     *   alpha value. For instance, tint(255, 128) will
     *   make an image 50% transparent (assuming the
     *   default alpha range of 0-255, which can be changed
     *   with colorMode()).
     *
     *   The value for the gray parameter must be less than
     *   or equal to the current maximum value as specified
     *   by colorMode(). The default maximum value is 255.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     */
    function tint(v1: number, v2: number, v3: number, alpha?: number): void;

    /**
     *   Sets the fill value for displaying images. Images
     *   can be tinted to specified colors or made
     *   transparent by including an alpha value. To apply
     *   transparency to an image without affecting its
     *   color, use white as the tint color and specify an
     *   alpha value. For instance, tint(255, 128) will
     *   make an image 50% transparent (assuming the
     *   default alpha range of 0-255, which can be changed
     *   with colorMode()).
     *
     *   The value for the gray parameter must be less than
     *   or equal to the current maximum value as specified
     *   by colorMode(). The default maximum value is 255.
     *   @param value a color string
     */
    function tint(value: string): void;

    /**
     *   Sets the fill value for displaying images. Images
     *   can be tinted to specified colors or made
     *   transparent by including an alpha value. To apply
     *   transparency to an image without affecting its
     *   color, use white as the tint color and specify an
     *   alpha value. For instance, tint(255, 128) will
     *   make an image 50% transparent (assuming the
     *   default alpha range of 0-255, which can be changed
     *   with colorMode()).
     *
     *   The value for the gray parameter must be less than
     *   or equal to the current maximum value as specified
     *   by colorMode(). The default maximum value is 255.
     *   @param gray a gray value
     */
    function tint(gray: number, alpha?: number): void;

    /**
     *   Sets the fill value for displaying images. Images
     *   can be tinted to specified colors or made
     *   transparent by including an alpha value. To apply
     *   transparency to an image without affecting its
     *   color, use white as the tint color and specify an
     *   alpha value. For instance, tint(255, 128) will
     *   make an image 50% transparent (assuming the
     *   default alpha range of 0-255, which can be changed
     *   with colorMode()).
     *
     *   The value for the gray parameter must be less than
     *   or equal to the current maximum value as specified
     *   by colorMode(). The default maximum value is 255.
     *   @param values an array containing the
     *   red,green,blue & and alpha components of the color
     */
    function tint(values: number[]): void;

    /**
     *   Sets the fill value for displaying images. Images
     *   can be tinted to specified colors or made
     *   transparent by including an alpha value. To apply
     *   transparency to an image without affecting its
     *   color, use white as the tint color and specify an
     *   alpha value. For instance, tint(255, 128) will
     *   make an image 50% transparent (assuming the
     *   default alpha range of 0-255, which can be changed
     *   with colorMode()).
     *
     *   The value for the gray parameter must be less than
     *   or equal to the current maximum value as specified
     *   by colorMode(). The default maximum value is 255.
     *   @param color the tint color
     */
    function tint(color: p5.Color): void;

    /**
     *   Removes the current fill value for displaying
     *   images and reverts to displaying images with their
     *   original hues.
     */
    function noTint(): void;

    /**
     *   Set image mode. Modifies the location from which
     *   images are drawn by changing the way in which
     *   parameters given to image() are interpreted. The
     *   default mode is imageMode(CORNER), which
     *   interprets the second and third parameters of
     *   image() as the upper-left corner of the image. If
     *   two additional parameters are specified, they are
     *   used to set the image's width and height.
     *   imageMode(CORNERS) interprets the second and third
     *   parameters of image() as the location of one
     *   corner, and the fourth and fifth parameters as the
     *   opposite corner.
     *
     *   imageMode(CENTER) interprets the second and third
     *   parameters of image() as the image's center point.
     *   If two additional parameters are specified, they
     *   are used to set the image's width and height.
     *   @param mode either CORNER, CORNERS, or CENTER
     */
    function imageMode(mode: p5.IMAGE_MODE): void;

    /**
     *   Copies a region of pixels from one image to
     *   another, using a specified blend mode to do the
     *   operation.
     *   @param srcImage source image
     *   @param sx X coordinate of the source's upper left
     *   corner
     *   @param sy Y coordinate of the source's upper left
     *   corner
     *   @param sw source image width
     *   @param sh source image height
     *   @param dx X coordinate of the destination's upper
     *   left corner
     *   @param dy Y coordinate of the destination's upper
     *   left corner
     *   @param dw destination image width
     *   @param dh destination image height
     *   @param blendMode the blend mode. either BLEND,
     *   DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
     *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
     *   SOFT_LIGHT, DODGE, BURN, ADD or NORMAL.
     */
    function blend(
        srcImage: p5.Image,
        sx: number,
        sy: number,
        sw: number,
        sh: number,
        dx: number,
        dy: number,
        dw: number,
        dh: number,
        blendMode: p5.BLEND_MODE
    ): void;

    /**
     *   Copies a region of pixels from one image to
     *   another, using a specified blend mode to do the
     *   operation.
     *   @param sx X coordinate of the source's upper left
     *   corner
     *   @param sy Y coordinate of the source's upper left
     *   corner
     *   @param sw source image width
     *   @param sh source image height
     *   @param dx X coordinate of the destination's upper
     *   left corner
     *   @param dy Y coordinate of the destination's upper
     *   left corner
     *   @param dw destination image width
     *   @param dh destination image height
     *   @param blendMode the blend mode. either BLEND,
     *   DARKEST, LIGHTEST, DIFFERENCE, MULTIPLY,
     *   EXCLUSION, SCREEN, REPLACE, OVERLAY, HARD_LIGHT,
     *   SOFT_LIGHT, DODGE, BURN, ADD or NORMAL.
     */
    function blend(
        sx: number,
        sy: number,
        sw: number,
        sh: number,
        dx: number,
        dy: number,
        dw: number,
        dh: number,
        blendMode: p5.UNKNOWN_P5_CONSTANT
    ): void;

    /**
     *   Copies a region of the canvas to another region of
     *   the canvas and copies a region of pixels from an
     *   image used as the srcImg parameter into the canvas
     *   srcImage is specified this is used as the source.
     *   If the source and destination regions aren't the
     *   same size, it will automatically resize source
     *   pixels to fit the specified target region.
     *   @param srcImage source image
     *   @param sx X coordinate of the source's upper left
     *   corner
     *   @param sy Y coordinate of the source's upper left
     *   corner
     *   @param sw source image width
     *   @param sh source image height
     *   @param dx X coordinate of the destination's upper
     *   left corner
     *   @param dy Y coordinate of the destination's upper
     *   left corner
     *   @param dw destination image width
     *   @param dh destination image height
     */
    function copy(
        srcImage: p5.Image | p5.Element,
        sx: number,
        sy: number,
        sw: number,
        sh: number,
        dx: number,
        dy: number,
        dw: number,
        dh: number
    ): void;

    /**
     *   Copies a region of the canvas to another region of
     *   the canvas and copies a region of pixels from an
     *   image used as the srcImg parameter into the canvas
     *   srcImage is specified this is used as the source.
     *   If the source and destination regions aren't the
     *   same size, it will automatically resize source
     *   pixels to fit the specified target region.
     *   @param sx X coordinate of the source's upper left
     *   corner
     *   @param sy Y coordinate of the source's upper left
     *   corner
     *   @param sw source image width
     *   @param sh source image height
     *   @param dx X coordinate of the destination's upper
     *   left corner
     *   @param dy Y coordinate of the destination's upper
     *   left corner
     *   @param dw destination image width
     *   @param dh destination image height
     */
    function copy(sx: number, sy: number, sw: number, sh: number, dx: number, dy: number, dw: number, dh: number): void;

    /**
     *   Applies a filter to the canvas. The presets
     *   options are: THRESHOLD Converts the image to black
     *   and white pixels depending if they are above or
     *   below the threshold defined by the level
     *   parameter. The parameter must be between 0.0
     *   (black) and 1.0 (white). If no level is specified,
     *   0.5 is used.
     *
     *   GRAY Converts any colors in the image to grayscale
     *   equivalents. No parameter is used.
     *
     *   OPAQUE Sets the alpha channel to entirely opaque.
     *   No parameter is used.
     *
     *   INVERT Sets each pixel to its inverse value. No
     *   parameter is used.
     *
     *   POSTERIZE Limits each channel of the image to the
     *   number of colors specified as the parameter. The
     *   parameter can be set to values between 2 and 255,
     *   but results are most noticeable in the lower
     *   ranges.
     *
     *   BLUR Executes a Gaussian blur with the level
     *   parameter specifying the extent of the blurring.
     *   If no parameter is used, the blur is equivalent to
     *   Gaussian blur of radius 1. Larger values increase
     *   the blur.
     *
     *   ERODE Reduces the light areas. No parameter is
     *   used.
     *
     *   DILATE Increases the light areas. No parameter is
     *   used.
     *
     *   filter() does not work in WEBGL mode. A similar
     *   effect can be achieved in WEBGL mode using custom
     *   shaders. Adam Ferriss has written a selection of
     *   shader examples that contains many of the effects
     *   present in the filter examples.
     *   @param filterType either THRESHOLD, GRAY, OPAQUE,
     *   INVERT, POSTERIZE, BLUR, ERODE, DILATE or BLUR.
     *   See Filters.js for docs on each available filter
     *   @param [filterParam] an optional parameter unique
     *   to each filter, see above
     */
    function filter(filterType: p5.FILTER_TYPE, filterParam?: number): void;

    /**
     *   Get a region of pixels, or a single pixel, from
     *   the canvas. Returns an array of [R,G,B,A] values
     *   for any pixel or grabs a section of an image. If
     *   no parameters are specified, the entire image is
     *   returned. Use the x and y parameters to get the
     *   value of one pixel. Get a section of the display
     *   window by specifying additional w and h
     *   parameters. When getting an image, the x and y
     *   parameters define the coordinates for the
     *   upper-left corner of the image, regardless of the
     *   current imageMode().
     *
     *   Getting the color of a single pixel with get(x, y)
     *   is easy, but not as fast as grabbing the data
     *   directly from pixels[]. The equivalent statement
     *   to get(x, y) using pixels[] with pixel density d
     *   is
     *
     *   let x, y, d; // set these to the coordinates let
     *   off = (y * width + x) * d * 4; let components = [
     *   pixels[off], pixels[off + 1], pixels[off + 2],
     *   pixels[off + 3] ]; print(components);
     *
     *   See the reference for pixels[] for more
     *   information.
     *
     *   If you want to extract an array of colors or a
     *   subimage from an p5.Image object, take a look at
     *   p5.Image.get()
     *   @param x x-coordinate of the pixel
     *   @param y y-coordinate of the pixel
     *   @param w width of the section to be returned
     *   @param h height of the section to be returned
     *   @return the rectangle p5.Image
     */
    function get(x: number, y: number, w: number, h: number): p5.Image;

    /**
     *   Get a region of pixels, or a single pixel, from
     *   the canvas. Returns an array of [R,G,B,A] values
     *   for any pixel or grabs a section of an image. If
     *   no parameters are specified, the entire image is
     *   returned. Use the x and y parameters to get the
     *   value of one pixel. Get a section of the display
     *   window by specifying additional w and h
     *   parameters. When getting an image, the x and y
     *   parameters define the coordinates for the
     *   upper-left corner of the image, regardless of the
     *   current imageMode().
     *
     *   Getting the color of a single pixel with get(x, y)
     *   is easy, but not as fast as grabbing the data
     *   directly from pixels[]. The equivalent statement
     *   to get(x, y) using pixels[] with pixel density d
     *   is
     *
     *   let x, y, d; // set these to the coordinates let
     *   off = (y * width + x) * d * 4; let components = [
     *   pixels[off], pixels[off + 1], pixels[off + 2],
     *   pixels[off + 3] ]; print(components);
     *
     *   See the reference for pixels[] for more
     *   information.
     *
     *   If you want to extract an array of colors or a
     *   subimage from an p5.Image object, take a look at
     *   p5.Image.get()
     *   @return the whole p5.Image
     */
    function get(): p5.Image;

    /**
     *   Get a region of pixels, or a single pixel, from
     *   the canvas. Returns an array of [R,G,B,A] values
     *   for any pixel or grabs a section of an image. If
     *   no parameters are specified, the entire image is
     *   returned. Use the x and y parameters to get the
     *   value of one pixel. Get a section of the display
     *   window by specifying additional w and h
     *   parameters. When getting an image, the x and y
     *   parameters define the coordinates for the
     *   upper-left corner of the image, regardless of the
     *   current imageMode().
     *
     *   Getting the color of a single pixel with get(x, y)
     *   is easy, but not as fast as grabbing the data
     *   directly from pixels[]. The equivalent statement
     *   to get(x, y) using pixels[] with pixel density d
     *   is
     *
     *   let x, y, d; // set these to the coordinates let
     *   off = (y * width + x) * d * 4; let components = [
     *   pixels[off], pixels[off + 1], pixels[off + 2],
     *   pixels[off + 3] ]; print(components);
     *
     *   See the reference for pixels[] for more
     *   information.
     *
     *   If you want to extract an array of colors or a
     *   subimage from an p5.Image object, take a look at
     *   p5.Image.get()
     *   @param x x-coordinate of the pixel
     *   @param y y-coordinate of the pixel
     *   @return color of pixel at x,y in array format [R,
     *   G, B, A]
     */
    function get(x: number, y: number): number[];

    /**
     *   Loads the pixel data for the display window into
     *   the pixels[] array. This function must always be
     *   called before reading from or writing to pixels[].
     *   Note that only changes made with set() or direct
     *   manipulation of pixels[] will occur.
     */
    function loadPixels(): void;

    /**
     *   Changes the color of any pixel, or writes an image
     *   directly to the display window. The x and y
     *   parameters specify the pixel to change and the c
     *   parameter specifies the color value. This can be a
     *   p5.Color object, or [R, G, B, A] pixel array. It
     *   can also be a single grayscale value. When setting
     *   an image, the x and y parameters define the
     *   coordinates for the upper-left corner of the
     *   image, regardless of the current imageMode().
     *   After using set(), you must call updatePixels()
     *   for your changes to appear. This should be called
     *   once all pixels have been set, and must be called
     *   before calling .get() or drawing the image.
     *
     *   Setting the color of a single pixel with set(x, y)
     *   is easy, but not as fast as putting the data
     *   directly into pixels[]. Setting the pixels[]
     *   values directly may be complicated when working
     *   with a retina display, but will perform better
     *   when lots of pixels need to be set directly on
     *   every loop. See the reference for pixels[] for
     *   more information.
     *   @param x x-coordinate of the pixel
     *   @param y y-coordinate of the pixel
     *   @param c insert a grayscale value | a pixel array
     *   | a p5.Color object | a p5.Image to copy
     */
    function set(x: number, y: number, c: number | number[] | object): void;

    /**
     *   Updates the display window with the data in the
     *   pixels[] array. Use in conjunction with
     *   loadPixels(). If you're only reading pixels from
     *   the array, there's no need to call updatePixels()
     *   — updating is only necessary to apply changes.
     *   updatePixels() should be called anytime the pixels
     *   array is manipulated or set() is called, and only
     *   changes made with set() or direct changes to
     *   pixels[] will occur.
     *   @param [x] x-coordinate of the upper-left corner
     *   of region to update
     *   @param [y] y-coordinate of the upper-left corner
     *   of region to update
     *   @param [w] width of region to update
     *   @param [h] height of region to update
     */
    function updatePixels(x?: number, y?: number, w?: number, h?: number): void;

    /**
     *   Uint8ClampedArray containing the values for all
     *   the pixels in the display window. These values are
     *   numbers. This array is the size (include an
     *   appropriate factor for pixelDensity) of the
     *   display window x4, representing the R, G, B, A
     *   values in order for each pixel, moving from left
     *   to right across each row, then down each column.
     *   Retina and other high density displays will have
     *   more pixels[] (by a factor of pixelDensity^2). For
     *   example, if the image is 100×100 pixels, there
     *   will be 40,000. On a retina display, there will be
     *   160,000. The first four values (indices 0-3) in
     *   the array will be the R, G, B, A values of the
     *   pixel at (0, 0). The second four values (indices
     *   4-7) will contain the R, G, B, A values of the
     *   pixel at (1, 0). More generally, to set values for
     *   a pixel at (x, y):
     *
     *   let d = pixelDensity(); for (let i = 0; i < d;
     *   i++) { for (let j = 0; j < d; j++) { // loop over
     *   index = 4 * ((y * d + j) * width * d + (x * d +
     *   i)); pixels[index] = r; pixels[index+1] = g;
     *   pixels[index+2] = b; pixels[index+3] = a; } }
     *
     *   While the above method is complex, it is flexible
     *   enough to work with any pixelDensity. Note that
     *   set() will automatically take care of setting all
     *   the appropriate values in pixels[] for a given (x,
     *   y) at any pixelDensity, but the performance may
     *   not be as fast when lots of modifications are made
     *   to the pixel array.
     *
     *   Before accessing this array, the data must loaded
     *   with the loadPixels() function. After the array
     *   data has been modified, the updatePixels()
     *   function must be run to update the changes.
     *
     *   Note that this is not a standard javascript array.
     *   This means that standard javascript functions such
     *   as slice() or arrayCopy() do not work.
     */
    let pixels: number[];

    /**
     *   Loads a JSON file from a file or a URL, and
     *   returns an Object. Note that even if the JSON file
     *   contains an Array, an Object will be returned with
     *   index numbers as keys. This method is
     *   asynchronous, meaning it may not finish before the
     *   next line in your sketch is executed. JSONP is
     *   supported via a polyfill and you can pass in as
     *   the second argument an object with definitions of
     *   the json callback following the syntax specified
     *   here.
     *
     *   This method is suitable for fetching files up to
     *   size of 64MB.
     *   @param path name of the file or url to load
     *   @param [jsonpOptions] options object for jsonp
     *   related settings
     *   @param [datatype] "json" or "jsonp"
     *   @param [callback] function to be executed after
     *   loadJSON() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     *   @return JSON data
     */
    function loadJSON(
        path: string,
        jsonpOptions?: object,
        datatype?: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): object | any[];

    /**
     *   Loads a JSON file from a file or a URL, and
     *   returns an Object. Note that even if the JSON file
     *   contains an Array, an Object will be returned with
     *   index numbers as keys. This method is
     *   asynchronous, meaning it may not finish before the
     *   next line in your sketch is executed. JSONP is
     *   supported via a polyfill and you can pass in as
     *   the second argument an object with definitions of
     *   the json callback following the syntax specified
     *   here.
     *
     *   This method is suitable for fetching files up to
     *   size of 64MB.
     *   @param path name of the file or url to load
     *   @param datatype "json" or "jsonp"
     *   @param [callback] function to be executed after
     *   loadJSON() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     */
    function loadJSON(
        path: string,
        datatype: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): object | any[];

    /**
     *   Loads a JSON file from a file or a URL, and
     *   returns an Object. Note that even if the JSON file
     *   contains an Array, an Object will be returned with
     *   index numbers as keys. This method is
     *   asynchronous, meaning it may not finish before the
     *   next line in your sketch is executed. JSONP is
     *   supported via a polyfill and you can pass in as
     *   the second argument an object with definitions of
     *   the json callback following the syntax specified
     *   here.
     *
     *   This method is suitable for fetching files up to
     *   size of 64MB.
     *   @param path name of the file or url to load
     *   @param callback function to be executed after
     *   loadJSON() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     */
    function loadJSON(
        path: string,
        callback: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): object | any[];

    /**
     *   Reads the contents of a file and creates a String
     *   array of its individual lines. If the name of the
     *   file is used as the parameter, as in the above
     *   example, the file must be located in the sketch
     *   directory/folder. Alternatively, the file may be
     *   loaded from anywhere on the local computer using
     *   an absolute path (something that starts with / on
     *   Unix and Linux, or a drive letter on Windows), or
     *   the filename parameter can be a URL for a file
     *   found on a network.
     *
     *   This method is asynchronous, meaning it may not
     *   finish before the next line in your sketch is
     *   executed.
     *
     *   This method is suitable for fetching files up to
     *   size of 64MB.
     *   @param filename name of the file or url to load
     *   @param [callback] function to be executed after
     *   loadStrings() completes, Array is passed in as
     *   first argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     *   @return Array of Strings
     */
    function loadStrings(
        filename: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): string[];

    /**
     *   Reads the contents of a file or URL and creates a
     *   p5.Table object with its values. If a file is
     *   specified, it must be located in the sketch's
     *   "data" folder. The filename parameter can also be
     *   a URL to a file found online. By default, the file
     *   is assumed to be comma-separated (in CSV format).
     *   Table only looks for a header row if the 'header'
     *   option is included. This method is asynchronous,
     *   meaning it may not finish before the next line in
     *   your sketch is executed. Calling loadTable()
     *   inside preload() guarantees to complete the
     *   operation before setup() and draw() are called.
     *   Outside of preload(), you may supply a callback
     *   function to handle the object:
     *
     *   All files loaded and saved use UTF-8 encoding.
     *   This method is suitable for fetching files up to
     *   size of 64MB.
     *   @param filename name of the file or URL to load
     *   @param [extension] parse the table by
     *   comma-separated values "csv", semicolon-separated
     *   values "ssv", or tab-separated values "tsv"
     *   @param [header] "header" to indicate table has
     *   header row
     *   @param [callback] function to be executed after
     *   loadTable() completes. On success, the Table
     *   object is passed in as the first argument.
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     *   @return Table object containing data
     */
    function loadTable(
        filename: string,
        extension?: string,
        header?: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): object;

    /**
     *   Reads the contents of a file and creates an XML
     *   object with its values. If the name of the file is
     *   used as the parameter, as in the above example,
     *   the file must be located in the sketch
     *   directory/folder. Alternatively, the file maybe be
     *   loaded from anywhere on the local computer using
     *   an absolute path (something that starts with / on
     *   Unix and Linux, or a drive letter on Windows), or
     *   the filename parameter can be a URL for a file
     *   found on a network.
     *
     *   This method is asynchronous, meaning it may not
     *   finish before the next line in your sketch is
     *   executed. Calling loadXML() inside preload()
     *   guarantees to complete the operation before
     *   setup() and draw() are called.
     *
     *   Outside of preload(), you may supply a callback
     *   function to handle the object.
     *
     *   This method is suitable for fetching files up to
     *   size of 64MB.
     *   @param filename name of the file or URL to load
     *   @param [callback] function to be executed after
     *   loadXML() completes, XML object is passed in as
     *   first argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     *   @return XML object containing data
     */
    function loadXML(
        filename: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): object;

    /**
     *   This method is suitable for fetching files up to
     *   size of 64MB.
     *   @param file name of the file or URL to load
     *   @param [callback] function to be executed after
     *   loadBytes() completes
     *   @param [errorCallback] function to be executed if
     *   there is an error
     *   @return an object whose 'bytes' property will be
     *   the loaded buffer
     */
    function loadBytes(
        file: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): object;

    /**
     *   Method for executing an HTTP GET request. If data
     *   type is not specified, p5 will try to guess based
     *   on the URL, defaulting to text. This is equivalent
     *   to calling httpDo(path, 'GET'). The 'binary'
     *   datatype will return a Blob object, and the
     *   'arrayBuffer' datatype will return an ArrayBuffer
     *   which can be used to initialize typed arrays (such
     *   as Uint8Array).
     *   @param path name of the file or url to load
     *   @param [datatype] "json", "jsonp", "binary",
     *   "arrayBuffer", "xml", or "text"
     *   @param [data] param data passed sent with request
     *   @param [callback] function to be executed after
     *   httpGet() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     *   @return A promise that resolves with the data when
     *   the operation completes successfully or rejects
     *   with the error after one occurs.
     */
    function httpGet(
        path: string,
        datatype?: string,
        data?: object | boolean,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;

    /**
     *   Method for executing an HTTP GET request. If data
     *   type is not specified, p5 will try to guess based
     *   on the URL, defaulting to text. This is equivalent
     *   to calling httpDo(path, 'GET'). The 'binary'
     *   datatype will return a Blob object, and the
     *   'arrayBuffer' datatype will return an ArrayBuffer
     *   which can be used to initialize typed arrays (such
     *   as Uint8Array).
     *   @param path name of the file or url to load
     *   @param data param data passed sent with request
     *   @param [callback] function to be executed after
     *   httpGet() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     */
    function httpGet(
        path: string,
        data: object | boolean,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;

    /**
     *   Method for executing an HTTP GET request. If data
     *   type is not specified, p5 will try to guess based
     *   on the URL, defaulting to text. This is equivalent
     *   to calling httpDo(path, 'GET'). The 'binary'
     *   datatype will return a Blob object, and the
     *   'arrayBuffer' datatype will return an ArrayBuffer
     *   which can be used to initialize typed arrays (such
     *   as Uint8Array).
     *   @param path name of the file or url to load
     *   @param callback function to be executed after
     *   httpGet() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     */
    function httpGet(
        path: string,
        callback: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;

    /**
     *   Method for executing an HTTP POST request. If data
     *   type is not specified, p5 will try to guess based
     *   on the URL, defaulting to text. This is equivalent
     *   to calling httpDo(path, 'POST').
     *   @param path name of the file or url to load
     *   @param [datatype] "json", "jsonp", "xml", or
     *   "text". If omitted, httpPost() will guess.
     *   @param [data] param data passed sent with request
     *   @param [callback] function to be executed after
     *   httpPost() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     *   @return A promise that resolves with the data when
     *   the operation completes successfully or rejects
     *   with the error after one occurs.
     */
    function httpPost(
        path: string,
        datatype?: string,
        data?: object | boolean,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;

    /**
     *   Method for executing an HTTP POST request. If data
     *   type is not specified, p5 will try to guess based
     *   on the URL, defaulting to text. This is equivalent
     *   to calling httpDo(path, 'POST').
     *   @param path name of the file or url to load
     *   @param data param data passed sent with request
     *   @param [callback] function to be executed after
     *   httpPost() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     */
    function httpPost(
        path: string,
        data: object | boolean,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;

    /**
     *   Method for executing an HTTP POST request. If data
     *   type is not specified, p5 will try to guess based
     *   on the URL, defaulting to text. This is equivalent
     *   to calling httpDo(path, 'POST').
     *   @param path name of the file or url to load
     *   @param callback function to be executed after
     *   httpPost() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     */
    function httpPost(
        path: string,
        callback: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;

    /**
     *   Method for executing an HTTP request. If data type
     *   is not specified, p5 will try to guess based on
     *   the URL, defaulting to text. For more advanced
     *   use, you may also pass in the path as the first
     *   argument and a object as the second argument, the
     *   signature follows the one specified in the Fetch
     *   API specification. This method is suitable for
     *   fetching files up to size of 64MB when "GET" is
     *   used.
     *   @param path name of the file or url to load
     *   @param [method] either "GET", "POST", or "PUT",
     *   defaults to "GET"
     *   @param [datatype] "json", "jsonp", "xml", or
     *   "text"
     *   @param [data] param data passed sent with request
     *   @param [callback] function to be executed after
     *   httpGet() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     *   @return A promise that resolves with the data when
     *   the operation completes successfully or rejects
     *   with the error after one occurs.
     */
    function httpDo(
        path: string,
        method?: string,
        datatype?: string,
        data?: object,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;

    /**
     *   Method for executing an HTTP request. If data type
     *   is not specified, p5 will try to guess based on
     *   the URL, defaulting to text. For more advanced
     *   use, you may also pass in the path as the first
     *   argument and a object as the second argument, the
     *   signature follows the one specified in the Fetch
     *   API specification. This method is suitable for
     *   fetching files up to size of 64MB when "GET" is
     *   used.
     *   @param path name of the file or url to load
     *   @param options Request object options as
     *   documented in the "fetch" API reference
     *   @param [callback] function to be executed after
     *   httpGet() completes, data is passed in as first
     *   argument
     *   @param [errorCallback] function to be executed if
     *   there is an error, response is passed in as first
     *   argument
     */
    function httpDo(
        path: string,
        options: object,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): Promise<any>;
    function createWriter(name: string, extension?: string): p5.PrintWriter;

    /**
     *   Saves a given element(image, text, json, csv, wav,
     *   or html) to the client's computer. The first
     *   parameter can be a pointer to element we want to
     *   save. The element can be one of p5.Element,an
     *   Array of Strings, an Array of JSON, a JSON object,
     *   a p5.Table , a p5.Image, or a p5.SoundFile
     *   (requires p5.sound). The second parameter is a
     *   filename (including extension).The third parameter
     *   is for options specific to this type of object.
     *   This method will save a file that fits the given
     *   parameters. If it is called without specifying an
     *   element, by default it will save the whole canvas
     *   as an image file. You can optionally specify a
     *   filename as the first parameter in such a case.
     *   Note that it is not recommended to call this
     *   method within draw, as it will open a new save
     *   dialog on every render.
     *   @param [objectOrFilename] If filename is provided,
     *   will save canvas as an image with either png or
     *   jpg extension depending on the filename. If object
     *   is provided, will save depending on the object and
     *   filename (see examples above).
     *   @param [filename] If an object is provided as the
     *   first parameter, then the second parameter
     *   indicates the filename, and should include an
     *   appropriate file extension (see examples above).
     *   @param [options] Additional options depend on
     *   filetype. For example, when saving JSON, true
     *   indicates that the output will be optimized for
     *   filesize, rather than readability.
     */
    function save(objectOrFilename?: object | string, filename?: string, options?: boolean | string): void;

    /**
     *   Writes the contents of an Array or a JSON object
     *   to a .json file. The file saving process and
     *   location of the saved file will vary between web
     *   browsers.
     *   @param [optimize] If true, removes line breaks and
     *   spaces from the output file to optimize filesize
     *   (but not readability).
     */
    function saveJSON(json: any[] | object, filename: string, optimize?: boolean): void;

    /**
     *   Writes an array of Strings to a text file, one
     *   line per String. The file saving process and
     *   location of the saved file will vary between web
     *   browsers.
     *   @param list string array to be written
     *   @param filename filename for output
     *   @param [extension] the filename's extension
     *   @param [isCRLF] if true, change line-break to CRLF
     */
    function saveStrings(list: string[], filename: string, extension?: string, isCRLF?: boolean): void;

    /**
     *   Writes the contents of a Table object to a file.
     *   Defaults to a text file with
     *   comma-separated-values ('csv') but can also use
     *   tab separation ('tsv'), or generate an HTML table
     *   ('html'). The file saving process and location of
     *   the saved file will vary between web browsers.
     *   @param Table the Table object to save to a file
     *   @param filename the filename to which the Table
     *   should be saved
     *   @param [options] can be one of "tsv", "csv", or
     *   "html"
     */
    function saveTable(Table: p5.Table, filename: string, options?: string): void;

    /**
     *   Calculates the absolute value (magnitude) of a
     *   number. Maps to Math.abs(). The absolute value of
     *   a number is always positive.
     *   @param n number to compute
     *   @return absolute value of given number
     */
    function abs(n: number): number;

    /**
     *   Calculates the closest int value that is greater
     *   than or equal to the value of the parameter. Maps
     *   to Math.ceil(). For example, ceil(9.03) returns
     *   the value 10.
     *   @param n number to round up
     *   @return rounded up number
     */
    function ceil(n: number): number;

    /**
     *   Constrains a value between a minimum and maximum
     *   value.
     *   @param n number to constrain
     *   @param low minimum limit
     *   @param high maximum limit
     *   @return constrained number
     */
    function constrain(n: number, low: number, high: number): number;

    /**
     *   Calculates the distance between two points, in
     *   either two or three dimensions. If you looking for
     *   distance between two vectors see p5.Vector.dist()
     *   @param x1 x-coordinate of the first point
     *   @param y1 y-coordinate of the first point
     *   @param x2 x-coordinate of the second point
     *   @param y2 y-coordinate of the second point
     *   @return distance between the two points
     */
    function dist(x1: number, y1: number, x2: number, y2: number): number;

    /**
     *   Calculates the distance between two points, in
     *   either two or three dimensions. If you looking for
     *   distance between two vectors see p5.Vector.dist()
     *   @param x1 x-coordinate of the first point
     *   @param y1 y-coordinate of the first point
     *   @param z1 z-coordinate of the first point
     *   @param x2 x-coordinate of the second point
     *   @param y2 y-coordinate of the second point
     *   @param z2 z-coordinate of the second point
     *   @return distance between the two points
     */
    function dist(x1: number, y1: number, z1: number, x2: number, y2: number, z2: number): number;

    /**
     *   Returns Euler's number e (2.71828...) raised to
     *   the power of the n parameter. Maps to Math.exp().
     *   @param n exponent to raise
     *   @return e^n
     */
    function exp(n: number): number;

    /**
     *   Calculates the closest int value that is less than
     *   or equal to the value of the parameter. Maps to
     *   Math.floor().
     *   @param n number to round down
     *   @return rounded down number
     */
    function floor(n: number): number;

    /**
     *   Calculates a number between two numbers at a
     *   specific increment. The amt parameter is the
     *   amount to interpolate between the two values where
     *   0.0 is equal to the first point, 0.1 is very near
     *   the first point, 0.5 is half-way in between, and
     *   1.0 is equal to the second point. If the value of
     *   amt is more than 1.0 or less than 0.0, the number
     *   will be calculated accordingly in the ratio of the
     *   two given numbers. The lerp() function is
     *   convenient for creating motion along a straight
     *   path and for drawing dotted lines.
     *   @param start first value
     *   @param stop second value
     *   @param amt number
     *   @return lerped value
     */
    function lerp(start: number, stop: number, amt: number): number;

    /**
     *   Calculates the natural logarithm (the base-e
     *   logarithm) of a number. This function expects the
     *   n parameter to be a value greater than 0.0. Maps
     *   to Math.log().
     *   @param n number greater than 0
     *   @return natural logarithm of n
     */
    function log(n: number): number;

    /**
     *   Calculates the magnitude (or length) of a vector.
     *   A vector is a direction in space commonly used in
     *   computer graphics and linear algebra. Because it
     *   has no "start" position, the magnitude of a vector
     *   can be thought of as the distance from the
     *   coordinate 0,0 to its x,y value. Therefore, mag()
     *   is a shortcut for writing dist(0, 0, x, y).
     *   @param a first value
     *   @param b second value
     *   @return magnitude of vector from (0,0) to (a,b)
     */
    function mag(a: number, b: number): number;

    /**
     *   Re-maps a number from one range to another. In the
     *   first example above, the number 25 is converted
     *   from a value in the range of 0 to 100 into a value
     *   that ranges from the left edge of the window (0)
     *   to the right edge (width).
     *   @param value the incoming value to be converted
     *   @param start1 lower bound of the value's current
     *   range
     *   @param stop1 upper bound of the value's current
     *   range
     *   @param start2 lower bound of the value's target
     *   range
     *   @param stop2 upper bound of the value's target
     *   range
     *   @param [withinBounds] constrain the value to the
     *   newly mapped range
     *   @return remapped number
     */
    function map(
        value: number,
        start1: number,
        stop1: number,
        start2: number,
        stop2: number,
        withinBounds?: boolean
    ): number;

    /**
     *   Determines the largest value in a sequence of
     *   numbers, and then returns that value. max()
     *   accepts any number of Number parameters, or an
     *   Array of any length.
     *   @param n0 Number to compare
     *   @param n1 Number to compare
     *   @return maximum Number
     */
    function max(n0: number, n1: number): number;

    /**
     *   Determines the largest value in a sequence of
     *   numbers, and then returns that value. max()
     *   accepts any number of Number parameters, or an
     *   Array of any length.
     *   @param nums Numbers to compare
     */
    function max(nums: number[]): number;

    /**
     *   Determines the smallest value in a sequence of
     *   numbers, and then returns that value. min()
     *   accepts any number of Number parameters, or an
     *   Array of any length.
     *   @param n0 Number to compare
     *   @param n1 Number to compare
     *   @return minimum Number
     */
    function min(n0: number, n1: number): number;

    /**
     *   Determines the smallest value in a sequence of
     *   numbers, and then returns that value. min()
     *   accepts any number of Number parameters, or an
     *   Array of any length.
     *   @param nums Numbers to compare
     */
    function min(nums: number[]): number;

    /**
     *   Normalizes a number from another range into a
     *   value between 0 and 1. Identical to map(value,
     *   low, high, 0, 1). Numbers outside of the range are
     *   not clamped to 0 and 1, because out-of-range
     *   values are often intentional and useful. (See the
     *   example above.)
     *   @param value incoming value to be normalized
     *   @param start lower bound of the value's current
     *   range
     *   @param stop upper bound of the value's current
     *   range
     *   @return normalized number
     */
    function norm(value: number, start: number, stop: number): number;

    /**
     *   Facilitates exponential expressions. The pow()
     *   function is an efficient way of multiplying
     *   numbers by themselves (or their reciprocals) in
     *   large quantities. For example, pow(3, 5) is
     *   equivalent to the expression 3 × 3 × 3 × 3 × 3 and
     *   pow(3, -5) is equivalent to 1 / 3 × 3 × 3 × 3 × 3.
     *   Maps to Math.pow().
     *   @param n base of the exponential expression
     *   @param e power by which to raise the base
     *   @return n^e
     */
    function pow(n: number, e: number): number;

    /**
     *   Calculates the integer closest to the n parameter.
     *   For example, round(133.8) returns the value 134.
     *   Maps to Math.round().
     *   @param n number to round
     *   @param [decimals] number of decimal places to
     *   round to, default is 0
     *   @return rounded number
     */
    function round(n: number, decimals?: number): number;

    /**
     *   Squares a number (multiplies a number by itself).
     *   The result is always a positive number, as
     *   multiplying two negative numbers always yields a
     *   positive result. For example, -1 * -1 = 1.
     *   @param n number to square
     *   @return squared number
     */
    function sq(n: number): number;

    /**
     *   Calculates the square root of a number. The square
     *   root of a number is always positive, even though
     *   there may be a valid negative root. The square
     *   root s of number a is such that s*s = a. It is the
     *   opposite of squaring. Maps to Math.sqrt().
     *   @param n non-negative number to square root
     *   @return square root of number
     */
    function sqrt(n: number): number;

    /**
     *   Calculates the fractional part of a number.
     *   @param num Number whose fractional part needs to
     *   be found out
     *   @return fractional part of x, i.e, {x}
     */
    function fract(num: number): number;

    /**
     *   Creates a new p5.Vector (the datatype for storing
     *   vectors). This provides a two or three-dimensional
     *   vector, specifically a Euclidean (also known as
     *   geometric) vector. A vector is an entity that has
     *   both magnitude and direction.
     *   @param [x] x component of the vector
     *   @param [y] y component of the vector
     *   @param [z] z component of the vector
     */
    function createVector(x?: number, y?: number, z?: number): p5.Vector;

    /**
     *   Returns the Perlin noise value at specified
     *   coordinates. Perlin noise is a random sequence
     *   generator producing a more naturally ordered,
     *   harmonic succession of numbers compared to the
     *   standard random() function. It was invented by Ken
     *   Perlin in the 1980s and been used since in
     *   graphical applications to produce procedural
     *   textures, natural motion, shapes, terrains etc.
     *   The main difference to the random() function is
     *   that Perlin noise is defined in an infinite
     *   n-dimensional space where each pair of coordinates
     *   corresponds to a fixed semi-random value (fixed
     *   only for the lifespan of the program; see the
     *   noiseSeed() function). p5.js can compute 1D, 2D
     *   and 3D noise, depending on the number of
     *   coordinates given. The resulting value will always
     *   be between 0.0 and 1.0. The noise value can be
     *   animated by moving through the noise space as
     *   demonstrated in the example above. The 2nd and 3rd
     *   dimensions can also be interpreted as time.
     *
     *   The actual noise is structured similar to an audio
     *   signal, in respect to the function's use of
     *   frequencies. Similar to the concept of harmonics
     *   in physics, Perlin noise is computed over several
     *   octaves which are added together for the final
     *   result.
     *
     *   Another way to adjust the character of the
     *   resulting sequence is the scale of the input
     *   coordinates. As the function works within an
     *   infinite space the value of the coordinates
     *   doesn't matter as such, only the distance between
     *   successive coordinates does (eg. when using
     *   noise() within a loop). As a general rule the
     *   smaller the difference between coordinates, the
     *   smoother the resulting noise sequence will be.
     *   Steps of 0.005-0.03 work best for most
     *   applications, but this will differ depending on
     *   use.
     *   @param x x-coordinate in noise space
     *   @param [y] y-coordinate in noise space
     *   @param [z] z-coordinate in noise space
     *   @return Perlin noise value (between 0 and 1) at
     *   specified coordinates
     */
    function noise(x: number, y?: number, z?: number): number;

    /**
     *   Adjusts the character and level of detail produced
     *   by the Perlin noise function. Similar to harmonics
     *   in physics, noise is computed over several
     *   octaves. Lower octaves contribute more to the
     *   output signal and as such define the overall
     *   intensity of the noise, whereas higher octaves
     *   create finer-grained details in the noise
     *   sequence. By default, noise is computed over 4
     *   octaves with each octave contributing exactly half
     *   as much as its predecessor, starting at 50%
     *   strength for the 1st octave. This falloff amount
     *   can be changed by adding an additional function
     *   parameter. Eg. a falloff factor of 0.75 means each
     *   octave will now have 75% impact (25% less) of the
     *   previous lower octave. Any value between 0.0 and
     *   1.0 is valid, however, note that values greater
     *   than 0.5 might result in greater than 1.0 values
     *   returned by noise(). By changing these parameters,
     *   the signal created by the noise() function can be
     *   adapted to fit very specific needs and
     *   characteristics.
     *   @param lod number of octaves to be used by the
     *   noise
     *   @param falloff falloff factor for each octave
     */
    function noiseDetail(lod: number, falloff: number): void;

    /**
     *   Sets the seed value for noise(). By default,
     *   noise() produces different results each time the
     *   program is run. Set the seed parameter to a
     *   constant to return the same pseudo-random numbers
     *   each time the software is run.
     *   @param seed the seed value
     */
    function noiseSeed(seed: number): void;

    /**
     *   Sets the seed value for random(). By default,
     *   random() produces different results each time the
     *   program is run. Set the seed parameter to a
     *   constant to return the same pseudo-random numbers
     *   each time the software is run.
     *   @param seed the seed value
     */
    function randomSeed(seed: number): void;

    /**
     *   Return a random floating-point number. Takes
     *   either 0, 1 or 2 arguments.
     *
     *   If no argument is given, returns a random number
     *   from 0 up to (but not including) 1.
     *
     *   If one argument is given and it is a number,
     *   returns a random number from 0 up to (but not
     *   including) the number.
     *
     *   If one argument is given and it is an array,
     *   returns a random element from that array.
     *
     *   If two arguments are given, returns a random
     *   number from the first argument up to (but not
     *   including) the second argument.
     *   @param [min] the lower bound (inclusive)
     *   @param [max] the upper bound (exclusive)
     *   @return the random number
     */
    function random(min?: number, max?: number): number;

    /**
     *   Return a random floating-point number. Takes
     *   either 0, 1 or 2 arguments.
     *
     *   If no argument is given, returns a random number
     *   from 0 up to (but not including) 1.
     *
     *   If one argument is given and it is a number,
     *   returns a random number from 0 up to (but not
     *   including) the number.
     *
     *   If one argument is given and it is an array,
     *   returns a random element from that array.
     *
     *   If two arguments are given, returns a random
     *   number from the first argument up to (but not
     *   including) the second argument.
     *   @param choices the array to choose from
     *   @return the random element from the array
     */
    function random(choices: any[]): any;

    /**
     *   Returns a random number fitting a Gaussian, or
     *   normal, distribution. There is theoretically no
     *   minimum or maximum value that randomGaussian()
     *   might return. Rather, there is just a very low
     *   probability that values far from the mean will be
     *   returned; and a higher probability that numbers
     *   near the mean will be returned. Takes either 0, 1
     *   or 2 arguments. If no args, the mean is 0 and the
     *   standard deviation is 1.
     *
     *   If one arg, that arg is the mean and the standard
     *   deviation is 1.
     *
     *   If two args, the first arg is the mean and the
     *   second is the standard deviation.
     *   @param [mean] the mean
     *   @param [sd] the standard deviation
     *   @return the random number
     */
    function randomGaussian(mean?: number, sd?: number): number;

    /**
     *   The inverse of cos(), returns the arc cosine of a
     *   value. This function expects the values in the
     *   range of -1 to 1 and values are returned in the
     *   range 0 to PI (3.1415927) if the angleMode() is
     *   RADIANS or 0 to 180 if the angleMode() is DEGREES.
     *   @param value the value whose arc cosine is to be
     *   returned
     *   @return the arc cosine of the given value
     */
    function acos(value: number): number;

    /**
     *   The inverse of sin(), returns the arc sine of a
     *   value. This function expects the values in the
     *   range of -1 to 1 and values are returned in the
     *   range -PI/2 to PI/2 if the angleMode is RADIANS or
     *   -90 to 90 if the angle mode is DEGREES.
     *   @param value the value whose arc sine is to be
     *   returned
     *   @return the arc sine of the given value
     */
    function asin(value: number): number;

    /**
     *   The inverse of tan(), returns the arc tangent of a
     *   value. This function expects the values in the
     *   range of -Infinity to Infinity (exclusive) and
     *   values are returned in the range -PI/2 to PI/2 if
     *   the angleMode is RADIANS or -90 to 90 if the angle
     *   mode is DEGREES.
     *   @param value the value whose arc tangent is to be
     *   returned
     *   @return the arc tangent of the given value
     */
    function atan(value: number): number;

    /**
     *   Calculates the angle (in radians) from a specified
     *   point to the coordinate origin as measured from
     *   the positive x-axis. Values are returned as a
     *   float in the range from PI to -PI if the
     *   angleMode() is RADIANS or 180 to -180 if the
     *   angleMode() is DEGREES. The atan2() function is
     *   most often used for orienting geometry to the
     *   position of the cursor. Note: The y-coordinate of
     *   the point is the first parameter, and the
     *   x-coordinate is the second parameter, due to the
     *   structure of calculating the tangent.
     *   @param y y-coordinate of the point
     *   @param x x-coordinate of the point
     *   @return the arc tangent of the given point
     */
    function atan2(y: number, x: number): number;

    /**
     *   Calculates the cosine of an angle. This function
     *   takes into account the current angleMode. Values
     *   are returned in the range -1 to 1.
     *   @param angle the angle
     *   @return the cosine of the angle
     */
    function cos(angle: number): number;

    /**
     *   Calculates the sine of an angle. This function
     *   takes into account the current angleMode. Values
     *   are returned in the range -1 to 1.
     *   @param angle the angle
     *   @return the sine of the angle
     */
    function sin(angle: number): number;

    /**
     *   Calculates the tangent of an angle. This function
     *   takes into account the current angleMode. Values
     *   are returned in the range of all real numbers.
     *   @param angle the angle
     *   @return the tangent of the angle
     */
    function tan(angle: number): number;

    /**
     *   Converts a radian measurement to its corresponding
     *   value in degrees. Radians and degrees are two ways
     *   of measuring the same thing. There are 360 degrees
     *   in a circle and 2*PI radians in a circle. For
     *   example, 90° = PI/2 = 1.5707964. This function
     *   does not take into account the current
     *   angleMode().
     *   @param radians the radians value to convert to
     *   degrees
     *   @return the converted angle
     */
    function degrees(radians: number): number;

    /**
     *   Converts a degree measurement to its corresponding
     *   value in radians. Radians and degrees are two ways
     *   of measuring the same thing. There are 360 degrees
     *   in a circle and 2*PI radians in a circle. For
     *   example, 90° = PI/2 = 1.5707964. This function
     *   does not take into account the current angleMode.
     *   @param degrees the degree value to convert to
     *   radians
     *   @return the converted angle
     */
    function radians(degrees: number): number;

    /**
     *   Sets the current mode of p5 to the given mode.
     *   Default mode is RADIANS. Calling angleMode() with
     *   no arguments returns current anglemode.
     *   @param mode either RADIANS or DEGREES
     */
    function angleMode(mode: p5.ANGLE_MODE): void;

    /**
     *   Sets the current mode of p5 to the given mode.
     *   Default mode is RADIANS. Calling angleMode() with
     *   no arguments returns current anglemode.
     *   @return mode either RADIANS or DEGREES
     */
    function angleMode(): p5.UNKNOWN_P5_CONSTANT;

    /**
     *   Sets the current alignment for drawing text.
     *   Accepts two arguments: horizAlign (LEFT, CENTER,
     *   or RIGHT) and vertAlign (TOP, BOTTOM, CENTER, or
     *   BASELINE). The horizAlign parameter is in
     *   reference to the x value of the text() function,
     *   while the vertAlign parameter is in reference to
     *   the y value.
     *
     *   So if you write textAlign(LEFT), you are aligning
     *   the left edge of your text to the x value you give
     *   in text(). If you write textAlign(RIGHT, TOP), you
     *   are aligning the right edge of your text to the x
     *   value and the top edge of the text to the y value.
     *   @param horizAlign horizontal alignment, either
     *   LEFT, CENTER, or RIGHT
     *   @param [vertAlign] vertical alignment, either TOP,
     *   BOTTOM, CENTER, or BASELINE
     *   @chainable
     */
    function textAlign(horizAlign: p5.HORIZ_ALIGN, vertAlign?: p5.VERT_ALIGN): p5;

    /**
     *   Sets the current alignment for drawing text.
     *   Accepts two arguments: horizAlign (LEFT, CENTER,
     *   or RIGHT) and vertAlign (TOP, BOTTOM, CENTER, or
     *   BASELINE). The horizAlign parameter is in
     *   reference to the x value of the text() function,
     *   while the vertAlign parameter is in reference to
     *   the y value.
     *
     *   So if you write textAlign(LEFT), you are aligning
     *   the left edge of your text to the x value you give
     *   in text(). If you write textAlign(RIGHT, TOP), you
     *   are aligning the right edge of your text to the x
     *   value and the top edge of the text to the y value.
     */
    function textAlign(): object;

    /**
     *   Sets/gets the spacing, in pixels, between lines of
     *   text. This setting will be used in all subsequent
     *   calls to the text() function.
     *   @param leading the size in pixels for spacing
     *   between lines
     *   @chainable
     */
    function textLeading(leading: number): p5;

    /**
     *   Sets/gets the spacing, in pixels, between lines of
     *   text. This setting will be used in all subsequent
     *   calls to the text() function.
     */
    function textLeading(): number;

    /**
     *   Sets/gets the current font size. This size will be
     *   used in all subsequent calls to the text()
     *   function. Font size is measured in pixels.
     *   @param theSize the size of the letters in units of
     *   pixels
     *   @chainable
     */
    function textSize(theSize: number): p5;

    /**
     *   Sets/gets the current font size. This size will be
     *   used in all subsequent calls to the text()
     *   function. Font size is measured in pixels.
     */
    function textSize(): number;

    /**
     *   Sets/gets the style of the text for system fonts
     *   to NORMAL, ITALIC, BOLD or BOLDITALIC. Note: this
     *   may be is overridden by CSS styling. For
     *   non-system fonts (opentype, truetype, etc.) please
     *   load styled fonts instead.
     *   @param theStyle styling for text, either NORMAL,
     *   ITALIC, BOLD or BOLDITALIC
     *   @chainable
     */
    function textStyle(theStyle: p5.THE_STYLE): p5;

    /**
     *   Sets/gets the style of the text for system fonts
     *   to NORMAL, ITALIC, BOLD or BOLDITALIC. Note: this
     *   may be is overridden by CSS styling. For
     *   non-system fonts (opentype, truetype, etc.) please
     *   load styled fonts instead.
     */
    function textStyle(): string;

    /**
     *   Calculates and returns the width of any character
     *   or text string.
     *   @param theText the String of characters to measure
     *   @return the calculated width
     */
    function textWidth(theText: string): number;

    /**
     *   Returns the ascent of the current font at its
     *   current size. The ascent represents the distance,
     *   in pixels, of the tallest character above the
     *   baseline.
     */
    function textAscent(): number;

    /**
     *   Returns the descent of the current font at its
     *   current size. The descent represents the distance,
     *   in pixels, of the character with the longest
     *   descender below the baseline.
     */
    function textDescent(): number;

    /**
     *   Specifies how lines of text are wrapped within a
     *   text box. This requires a max-width set on the
     *   text area, specified in text() as parameter x2.
     *   WORD wrap style only breaks lines at spaces. A
     *   single string without spaces that exceeds the
     *   boundaries of the canvas or text area is not
     *   truncated, and will overflow the desired area,
     *   disappearing at the canvas edge.
     *
     *   CHAR wrap style breaks lines wherever needed to
     *   stay within the text box.
     *
     *   WORD is the default wrap style, and both styles
     *   will still break lines at any line breaks (\n)
     *   specified in the original text. The text area
     *   max-height parameter (y2) also still applies to
     *   wrapped text in both styles, lines of text that do
     *   not fit within the text area will not be drawn to
     *   the screen.
     *   @param wrapStyle text wrapping style, either WORD
     *   or CHAR
     *   @return wrapStyle
     */
    function textWrap(wrapStyle: p5.WRAP_STYLE): string;

    /**
     *   Loads an opentype font file (.otf, .ttf) from a
     *   file or a URL, and returns a p5.Font object. This
     *   function is asynchronous, meaning it may not
     *   finish before the next line in your sketch is
     *   executed. The path to the font should be relative
     *   to the HTML file that links in your sketch.
     *   Loading fonts from a URL or other remote location
     *   may be blocked due to your browser's built-in
     *   security.
     *   @param path name of the file or url to load
     *   @param [callback] function to be executed after
     *   loadFont() completes
     *   @param [onError] function to be executed if an
     *   error occurs
     *   @return p5.Font object
     */
    function loadFont(path: string, callback?: (...args: any[]) => any, onError?: (...args: any[]) => any): p5.Font;

    /**
     *   Draws text to the screen. Displays the information
     *   specified in the first parameter on the screen in
     *   the position specified by the additional
     *   parameters. A default font will be used unless a
     *   font is set with the textFont() function and a
     *   default size will be used unless a font is set
     *   with textSize(). Change the color of the text with
     *   the fill() function. Change the outline of the
     *   text with the stroke() and strokeWeight()
     *   functions. The text displays in relation to the
     *   textAlign() function, which gives the option to
     *   draw to the left, right, and center of the
     *   coordinates.
     *
     *   The x2 and y2 parameters define a rectangular area
     *   to display within and may only be used with string
     *   data. When these parameters are specified, they
     *   are interpreted based on the current rectMode()
     *   setting. Text that does not fit completely within
     *   the rectangle specified will not be drawn to the
     *   screen. If x2 and y2 are not specified, the
     *   baseline alignment is the default, which means
     *   that the text will be drawn upwards from x and y.
     *
     *   WEBGL: Only opentype/truetype fonts are supported.
     *   You must load a font using the loadFont() method
     *   (see the example above). stroke() currently has no
     *   effect in webgl mode. Learn more about working
     *   with text in webgl mode on the wiki.
     *   @param str the alphanumeric symbols to be
     *   displayed
     *   @param x x-coordinate of text
     *   @param y y-coordinate of text
     *   @param [x2] by default, the width of the text box,
     *   see rectMode() for more info
     *   @param [y2] by default, the height of the text
     *   box, see rectMode() for more info
     *   @chainable
     */
    function text(str: string | object | any[] | number | boolean, x: number, y: number, x2?: number, y2?: number): p5;

    /**
     *   Sets the current font that will be drawn with the
     *   text() function. If textFont() is called without
     *   any argument, it will return the current font if
     *   one has been set already. If not, it will return
     *   the name of the default font as a string. If
     *   textFont() is called with a font to use, it will
     *   return the p5 object. WEBGL: Only fonts loaded via
     *   loadFont() are supported.
     *   @return the current font / p5 Object
     */
    function textFont(): object;

    /**
     *   Sets the current font that will be drawn with the
     *   text() function. If textFont() is called without
     *   any argument, it will return the current font if
     *   one has been set already. If not, it will return
     *   the name of the default font as a string. If
     *   textFont() is called with a font to use, it will
     *   return the p5 object. WEBGL: Only fonts loaded via
     *   loadFont() are supported.
     *   @param font a font loaded via loadFont(), or a
     *   String representing a web safe font (a font that
     *   is generally available across all systems)
     *   @param [size] the font size to use
     *   @chainable
     */
    function textFont(font: object | string, size?: number): p5;

    /**
     *   Adds a value to the end of an array. Extends the
     *   length of the array by one. Maps to Array.push().
     *   @param array Array to append
     *   @param value to be added to the Array
     *   @return the array that was appended to
     */
    function append(array: any[], value: any): any[];

    /**
     *   Copies an array (or part of an array) to another
     *   array. The src array is copied to the dst array,
     *   beginning at the position specified by srcPosition
     *   and into the position specified by dstPosition.
     *   The number of elements to copy is determined by
     *   length. Note that copying values overwrites
     *   existing values in the destination array. To
     *   append values instead of overwriting them, use
     *   concat(). The simplified version with only two
     *   arguments, arrayCopy(src, dst), copies an entire
     *   array to another of the same size. It is
     *   equivalent to arrayCopy(src, 0, dst, 0,
     *   src.length).
     *
     *   Using this function is far more efficient for
     *   copying array data than iterating through a for()
     *   loop and copying each element individually.
     *   @param src the source Array
     *   @param srcPosition starting position in the source
     *   Array
     *   @param dst the destination Array
     *   @param dstPosition starting position in the
     *   destination Array
     *   @param length number of Array elements to be
     *   copied
     */
    function arrayCopy(src: any[], srcPosition: number, dst: any[], dstPosition: number, length: number): void;

    /**
     *   Copies an array (or part of an array) to another
     *   array. The src array is copied to the dst array,
     *   beginning at the position specified by srcPosition
     *   and into the position specified by dstPosition.
     *   The number of elements to copy is determined by
     *   length. Note that copying values overwrites
     *   existing values in the destination array. To
     *   append values instead of overwriting them, use
     *   concat(). The simplified version with only two
     *   arguments, arrayCopy(src, dst), copies an entire
     *   array to another of the same size. It is
     *   equivalent to arrayCopy(src, 0, dst, 0,
     *   src.length).
     *
     *   Using this function is far more efficient for
     *   copying array data than iterating through a for()
     *   loop and copying each element individually.
     *   @param src the source Array
     *   @param dst the destination Array
     *   @param [length] number of Array elements to be
     *   copied
     */
    function arrayCopy(src: any[], dst: any[], length?: number): void;

    /**
     *   Concatenates two arrays, maps to Array.concat().
     *   Does not modify the input arrays.
     *   @param a first Array to concatenate
     *   @param b second Array to concatenate
     *   @return concatenated array
     */
    function concat(a: any[], b: any[]): any[];

    /**
     *   Reverses the order of an array, maps to
     *   Array.reverse()
     *   @param list Array to reverse
     *   @return the reversed list
     */
    function reverse(list: any[]): any[];

    /**
     *   Decreases an array by one element and returns the
     *   shortened array, maps to Array.pop().
     *   @param list Array to shorten
     *   @return shortened Array
     */
    function shorten(list: any[]): any[];

    /**
     *   Randomizes the order of the elements of an array.
     *   Implements  Fisher-Yates Shuffle Algorithm.
     *   @param array Array to shuffle
     *   @param [bool] modify passed array
     *   @return shuffled Array
     */
    function shuffle(array: any[], bool?: boolean): any[];

    /**
     *   Sorts an array of numbers from smallest to
     *   largest, or puts an array of words in alphabetical
     *   order. The original array is not modified; a
     *   re-ordered array is returned. The count parameter
     *   states the number of elements to sort. For
     *   example, if there are 12 elements in an array and
     *   count is set to 5, only the first 5 elements in
     *   the array will be sorted.
     *   @param list Array to sort
     *   @param [count] number of elements to sort,
     *   starting from 0
     *   @return the sorted list
     */
    function sort(list: any[], count?: number): any[];

    /**
     *   Inserts a value or an array of values into an
     *   existing array. The first parameter specifies the
     *   initial array to be modified, and the second
     *   parameter defines the data to be inserted. The
     *   third parameter is an index value which specifies
     *   the array position from which to insert data.
     *   (Remember that array index numbering starts at
     *   zero, so the first position is 0, the second
     *   position is 1, and so on.)
     *   @param list Array to splice into
     *   @param value value to be spliced in
     *   @param position in the array from which to insert
     *   data
     *   @return the list
     */
    function splice(list: any[], value: any, position: number): any[];

    /**
     *   Extracts an array of elements from an existing
     *   array. The list parameter defines the array from
     *   which the elements will be copied, and the start
     *   and count parameters specify which elements to
     *   extract. If no count is given, elements will be
     *   extracted from the start to the end of the array.
     *   When specifying the start, remember that the first
     *   array element is 0. This function does not change
     *   the source array.
     *   @param list Array to extract from
     *   @param start position to begin
     *   @param [count] number of values to extract
     *   @return Array of extracted elements
     */
    function subset(list: any[], start: number, count?: number): any[];

    /**
     *   Converts a string to its floating point
     *   representation. The contents of a string must
     *   resemble a number, or NaN (not a number) will be
     *   returned. For example, float("1234.56") evaluates
     *   to 1234.56, but float("giraffe") will return NaN.
     *   When an array of values is passed in, then an
     *   array of floats of the same length is returned.
     *   @param str float string to parse
     *   @return floating point representation of string
     */
    function float(str: string): number;

    /**
     *   Converts a boolean, string, or float to its
     *   integer representation. When an array of values is
     *   passed in, then an int array of the same length is
     *   returned.
     *   @param n value to parse
     *   @param [radix] the radix to convert to (default:
     *   10)
     *   @return integer representation of value
     */
    function int(n: string | boolean | number, radix?: number): number;

    /**
     *   Converts a boolean, string, or float to its
     *   integer representation. When an array of values is
     *   passed in, then an int array of the same length is
     *   returned.
     *   @param ns values to parse
     *   @param [radix] the radix to convert to (default:
     *   10)
     *   @return integer representation of values
     */
    function int(ns: any[], radix?: number): number[];

    /**
     *   Converts a boolean, string or number to its string
     *   representation. When an array of values is passed
     *   in, then an array of strings of the same length is
     *   returned.
     *   @param n value to parse
     *   @return string representation of value
     */
    function str(n: string | boolean | number | any[]): string;

    /**
     *   Converts a number or string to its boolean
     *   representation. For a number, any non-zero value
     *   (positive or negative) evaluates to true, while
     *   zero evaluates to false. For a string, the value
     *   "true" evaluates to true, while any other value
     *   evaluates to false. When an array of number or
     *   string values is passed in, then a array of
     *   booleans of the same length is returned.
     *   @param n value to parse
     *   @return boolean representation of value
     */
    function boolean(n: string | boolean | number | any[]): boolean;

    /**
     *   Converts a number, string representation of a
     *   number, or boolean to its byte representation. A
     *   byte can be only a whole number between -128 and
     *   127, so when a value outside of this range is
     *   converted, it wraps around to the corresponding
     *   byte representation. When an array of number,
     *   string or boolean values is passed in, then an
     *   array of bytes the same length is returned.
     *   @param n value to parse
     *   @return byte representation of value
     */
    function byte(n: string | boolean | number): number;

    /**
     *   Converts a number, string representation of a
     *   number, or boolean to its byte representation. A
     *   byte can be only a whole number between -128 and
     *   127, so when a value outside of this range is
     *   converted, it wraps around to the corresponding
     *   byte representation. When an array of number,
     *   string or boolean values is passed in, then an
     *   array of bytes the same length is returned.
     *   @param ns values to parse
     *   @return array of byte representation of values
     */
    function byte(ns: any[]): number[];

    /**
     *   Converts a number or string to its corresponding
     *   single-character string representation. If a
     *   string parameter is provided, it is first parsed
     *   as an integer and then translated into a
     *   single-character string. When an array of number
     *   or string values is passed in, then an array of
     *   single-character strings of the same length is
     *   returned.
     *   @param n value to parse
     *   @return string representation of value
     */
    function char(n: string | number): string;

    /**
     *   Converts a number or string to its corresponding
     *   single-character string representation. If a
     *   string parameter is provided, it is first parsed
     *   as an integer and then translated into a
     *   single-character string. When an array of number
     *   or string values is passed in, then an array of
     *   single-character strings of the same length is
     *   returned.
     *   @param ns values to parse
     *   @return array of string representation of values
     */
    function char(ns: any[]): string[];

    /**
     *   Converts a single-character string to its
     *   corresponding integer representation. When an
     *   array of single-character string values is passed
     *   in, then an array of integers of the same length
     *   is returned.
     *   @param n value to parse
     *   @return integer representation of value
     */
    function unchar(n: string): number;

    /**
     *   Converts a single-character string to its
     *   corresponding integer representation. When an
     *   array of single-character string values is passed
     *   in, then an array of integers of the same length
     *   is returned.
     *   @param ns values to parse
     *   @return integer representation of values
     */
    function unchar(ns: any[]): number[];

    /**
     *   Converts a number to a string in its equivalent
     *   hexadecimal notation. If a second parameter is
     *   passed, it is used to set the number of characters
     *   to generate in the hexadecimal notation. When an
     *   array is passed in, an array of strings in
     *   hexadecimal notation of the same length is
     *   returned.
     *   @param n value to parse
     *   @return hexadecimal string representation of value
     */
    function hex(n: number, digits?: number): string;

    /**
     *   Converts a number to a string in its equivalent
     *   hexadecimal notation. If a second parameter is
     *   passed, it is used to set the number of characters
     *   to generate in the hexadecimal notation. When an
     *   array is passed in, an array of strings in
     *   hexadecimal notation of the same length is
     *   returned.
     *   @param ns array of values to parse
     *   @return hexadecimal string representation of
     *   values
     */
    function hex(ns: number[], digits?: number): string[];

    /**
     *   Converts a string representation of a hexadecimal
     *   number to its equivalent integer value. When an
     *   array of strings in hexadecimal notation is passed
     *   in, an array of integers of the same length is
     *   returned.
     *   @param n value to parse
     *   @return integer representation of hexadecimal
     *   value
     */
    function unhex(n: string): number;

    /**
     *   Converts a string representation of a hexadecimal
     *   number to its equivalent integer value. When an
     *   array of strings in hexadecimal notation is passed
     *   in, an array of integers of the same length is
     *   returned.
     *   @param ns values to parse
     *   @return integer representations of hexadecimal
     *   value
     */
    function unhex(ns: any[]): number[];

    /**
     *   Combines an array of Strings into one String, each
     *   separated by the character(s) used for the
     *   separator parameter. To join arrays of ints or
     *   floats, it's necessary to first convert them to
     *   Strings using nf() or nfs().
     *   @param list array of Strings to be joined
     *   @param separator String to be placed between each
     *   item
     *   @return joined String
     */
    function join(list: any[], separator: string): string;

    /**
     *   This function is used to apply a regular
     *   expression to a piece of text, and return matching
     *   groups (elements found inside parentheses) as a
     *   String array. If there are no matches, a null
     *   value will be returned. If no groups are specified
     *   in the regular expression, but the sequence
     *   matches, an array of length 1 (with the matched
     *   text as the first element of the array) will be
     *   returned. To use the function, first check to see
     *   if the result is null. If the result is null, then
     *   the sequence did not match at all. If the sequence
     *   did match, an array is returned.
     *
     *   If there are groups (specified by sets of
     *   parentheses) in the regular expression, then the
     *   contents of each will be returned in the array.
     *   Element [0] of a regular expression match returns
     *   the entire matching string, and the match groups
     *   start at element [1] (the first group is [1], the
     *   second [2], and so on).
     *   @param str the String to be searched
     *   @param regexp the regexp to be used for matching
     *   @return Array of Strings found
     */
    function match(str: string, regexp: string): string[];

    /**
     *   This function is used to apply a regular
     *   expression to a piece of text, and return a list
     *   of matching groups (elements found inside
     *   parentheses) as a two-dimensional String array. If
     *   there are no matches, a null value will be
     *   returned. If no groups are specified in the
     *   regular expression, but the sequence matches, a
     *   two dimensional array is still returned, but the
     *   second dimension is only of length one. To use the
     *   function, first check to see if the result is
     *   null. If the result is null, then the sequence did
     *   not match at all. If the sequence did match, a 2D
     *   array is returned.
     *
     *   If there are groups (specified by sets of
     *   parentheses) in the regular expression, then the
     *   contents of each will be returned in the array.
     *   Assuming a loop with counter variable i, element
     *   [i][0] of a regular expression match returns the
     *   entire matching string, and the match groups start
     *   at element [i][1] (the first group is [i][1], the
     *   second [i][2], and so on).
     *   @param str the String to be searched
     *   @param regexp the regexp to be used for matching
     *   @return 2d Array of Strings found
     */
    function matchAll(str: string, regexp: string): string[];

    /**
     *   Utility function for formatting numbers into
     *   strings. There are two versions: one for
     *   formatting floats, and one for formatting ints.
     *   The values for the digits, left, and right
     *   parameters should always be positive integers.
     *
     *   (NOTE): Be cautious when using left and right
     *   parameters as it prepends numbers of 0's if the
     *   parameter if greater than the current length of
     *   the number.
     *
     *   For example if number is 123.2 and left parameter
     *   passed is 4 which is greater than length of 123
     *   (integer part) i.e 3 than result will be 0123.2.
     *   Same case for right parameter i.e. if right is 3
     *   than the result will be 123.200.
     *   @param num the Number to format
     *   @param [left] number of digits to the left of the
     *   decimal point
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted String
     */
    function nf(num: number | string, left?: number | string, right?: number | string): string;

    /**
     *   Utility function for formatting numbers into
     *   strings. There are two versions: one for
     *   formatting floats, and one for formatting ints.
     *   The values for the digits, left, and right
     *   parameters should always be positive integers.
     *
     *   (NOTE): Be cautious when using left and right
     *   parameters as it prepends numbers of 0's if the
     *   parameter if greater than the current length of
     *   the number.
     *
     *   For example if number is 123.2 and left parameter
     *   passed is 4 which is greater than length of 123
     *   (integer part) i.e 3 than result will be 0123.2.
     *   Same case for right parameter i.e. if right is 3
     *   than the result will be 123.200.
     *   @param nums the Numbers to format
     *   @param [left] number of digits to the left of the
     *   decimal point
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted Strings
     */
    function nf(nums: any[], left?: number | string, right?: number | string): string[];

    /**
     *   Utility function for formatting numbers into
     *   strings and placing appropriate commas to mark
     *   units of 1000. There are two versions: one for
     *   formatting ints, and one for formatting an array
     *   of ints. The value for the right parameter should
     *   always be a positive integer.
     *   @param num the Number to format
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted String
     */
    function nfc(num: number | string, right?: number | string): string;

    /**
     *   Utility function for formatting numbers into
     *   strings and placing appropriate commas to mark
     *   units of 1000. There are two versions: one for
     *   formatting ints, and one for formatting an array
     *   of ints. The value for the right parameter should
     *   always be a positive integer.
     *   @param nums the Numbers to format
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted Strings
     */
    function nfc(nums: any[], right?: number | string): string[];

    /**
     *   Utility function for formatting numbers into
     *   strings. Similar to nf() but puts a "+" in front
     *   of positive numbers and a "-" in front of negative
     *   numbers. There are two versions: one for
     *   formatting floats, and one for formatting ints.
     *   The values for left, and right parameters should
     *   always be positive integers.
     *   @param num the Number to format
     *   @param [left] number of digits to the left of the
     *   decimal point
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted String
     */
    function nfp(num: number, left?: number, right?: number): string;

    /**
     *   Utility function for formatting numbers into
     *   strings. Similar to nf() but puts a "+" in front
     *   of positive numbers and a "-" in front of negative
     *   numbers. There are two versions: one for
     *   formatting floats, and one for formatting ints.
     *   The values for left, and right parameters should
     *   always be positive integers.
     *   @param nums the Numbers to format
     *   @param [left] number of digits to the left of the
     *   decimal point
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted Strings
     */
    function nfp(nums: number[], left?: number, right?: number): string[];

    /**
     *   Utility function for formatting numbers into
     *   strings. Similar to nf() but puts an additional
     *   "_" (space) in front of positive numbers just in
     *   case to align it with negative numbers which
     *   includes "-" (minus) sign. The main usecase of
     *   nfs() can be seen when one wants to align the
     *   digits (place values) of a non-negative number
     *   with some negative number (See the example to get
     *   a clear picture). There are two versions: one for
     *   formatting float, and one for formatting int.
     *
     *   The values for the digits, left, and right
     *   parameters should always be positive integers.
     *
     *   (IMP): The result on the canvas basically the
     *   expected alignment can vary based on the typeface
     *   you are using.
     *
     *   (NOTE): Be cautious when using left and right
     *   parameters as it prepends numbers of 0's if the
     *   parameter if greater than the current length of
     *   the number.
     *
     *   For example if number is 123.2 and left parameter
     *   passed is 4 which is greater than length of 123
     *   (integer part) i.e 3 than result will be 0123.2.
     *   Same case for right parameter i.e. if right is 3
     *   than the result will be 123.200.
     *   @param num the Number to format
     *   @param [left] number of digits to the left of the
     *   decimal point
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted String
     */
    function nfs(num: number, left?: number, right?: number): string;

    /**
     *   Utility function for formatting numbers into
     *   strings. Similar to nf() but puts an additional
     *   "_" (space) in front of positive numbers just in
     *   case to align it with negative numbers which
     *   includes "-" (minus) sign. The main usecase of
     *   nfs() can be seen when one wants to align the
     *   digits (place values) of a non-negative number
     *   with some negative number (See the example to get
     *   a clear picture). There are two versions: one for
     *   formatting float, and one for formatting int.
     *
     *   The values for the digits, left, and right
     *   parameters should always be positive integers.
     *
     *   (IMP): The result on the canvas basically the
     *   expected alignment can vary based on the typeface
     *   you are using.
     *
     *   (NOTE): Be cautious when using left and right
     *   parameters as it prepends numbers of 0's if the
     *   parameter if greater than the current length of
     *   the number.
     *
     *   For example if number is 123.2 and left parameter
     *   passed is 4 which is greater than length of 123
     *   (integer part) i.e 3 than result will be 0123.2.
     *   Same case for right parameter i.e. if right is 3
     *   than the result will be 123.200.
     *   @param nums the Numbers to format
     *   @param [left] number of digits to the left of the
     *   decimal point
     *   @param [right] number of digits to the right of
     *   the decimal point
     *   @return formatted Strings
     */
    function nfs(nums: any[], left?: number, right?: number): string[];

    /**
     *   The split() function maps to String.split(), it
     *   breaks a String into pieces using a character or
     *   string as the delimiter. The delim parameter
     *   specifies the character or characters that mark
     *   the boundaries between each piece. A String[]
     *   array is returned that contains each of the
     *   pieces. The splitTokens() function works in a
     *   similar fashion, except that it splits using a
     *   range of characters instead of a specific
     *   character or sequence.
     *   @param value the String to be split
     *   @param delim the String used to separate the data
     *   @return Array of Strings
     */
    function split(value: string, delim: string): string[];

    /**
     *   The splitTokens() function splits a String at one
     *   or many character delimiters or "tokens." The
     *   delim parameter specifies the character or
     *   characters to be used as a boundary. If no delim
     *   characters are specified, any whitespace character
     *   is used to split. Whitespace characters include
     *   tab (\t), line feed (\n), carriage return (\r),
     *   form feed (\f), and space.
     *   @param value the String to be split
     *   @param [delim] list of individual Strings that
     *   will be used as separators
     *   @return Array of Strings
     */
    function splitTokens(value: string, delim?: string): string[];

    /**
     *   Removes whitespace characters from the beginning
     *   and end of a String. In addition to standard
     *   whitespace characters such as space, carriage
     *   return, and tab, this function also removes the
     *   Unicode "nbsp" character.
     *   @param str a String to be trimmed
     *   @return a trimmed String
     */
    function trim(str: string): string;

    /**
     *   Removes whitespace characters from the beginning
     *   and end of a String. In addition to standard
     *   whitespace characters such as space, carriage
     *   return, and tab, this function also removes the
     *   Unicode "nbsp" character.
     *   @param strs an Array of Strings to be trimmed
     *   @return an Array of trimmed Strings
     */
    function trim(strs: any[]): string[];

    /**
     *   p5.js communicates with the clock on your
     *   computer. The day() function returns the current
     *   day as a value from 1 - 31.
     *   @return the current day
     */
    function day(): number;

    /**
     *   p5.js communicates with the clock on your
     *   computer. The hour() function returns the current
     *   hour as a value from 0 - 23.
     *   @return the current hour
     */
    function hour(): number;

    /**
     *   p5.js communicates with the clock on your
     *   computer. The minute() function returns the
     *   current minute as a value from 0 - 59.
     *   @return the current minute
     */
    function minute(): number;

    /**
     *   Returns the number of milliseconds (thousandths of
     *   a second) since starting the sketch (when setup()
     *   is called). This information is often used for
     *   timing events and animation sequences.
     *   @return the number of milliseconds since starting
     *   the sketch
     */
    function millis(): number;

    /**
     *   p5.js communicates with the clock on your
     *   computer. The month() function returns the current
     *   month as a value from 1 - 12.
     *   @return the current month
     */
    function month(): number;

    /**
     *   p5.js communicates with the clock on your
     *   computer. The second() function returns the
     *   current second as a value from 0 - 59.
     *   @return the current second
     */
    function second(): number;

    /**
     *   p5.js communicates with the clock on your
     *   computer. The year() function returns the current
     *   year as an integer (2014, 2015, 2016, etc).
     *   @return the current year
     */
    function year(): number;

    /**
     *   Draw a plane with given a width and height
     *   @param [width] width of the plane
     *   @param [height] height of the plane
     *   @param [detailX] Optional number of triangle
     *   subdivisions in x-dimension
     *   @param [detailY] Optional number of triangle
     *   subdivisions in y-dimension
     *   @chainable
     */
    function plane(width?: number, height?: number, detailX?: number, detailY?: number): p5;

    /**
     *   Draw a box with given width, height and depth
     *   @param [width] width of the box
     *   @param [height] height of the box
     *   @param [depth] depth of the box
     *   @param [detailX] Optional number of triangle
     *   subdivisions in x-dimension
     *   @param [detailY] Optional number of triangle
     *   subdivisions in y-dimension
     *   @chainable
     */
    function box(width?: number, height?: number, depth?: number, detailX?: number, detailY?: number): p5;

    /**
     *   Draw a sphere with given radius. DetailX and
     *   detailY determines the number of subdivisions in
     *   the x-dimension and the y-dimension of a sphere.
     *   More subdivisions make the sphere seem smoother.
     *   The recommended maximum values are both 24. Using
     *   a value greater than 24 may cause a warning or
     *   slow down the browser.
     *   @param [radius] radius of circle
     *   @param [detailX] optional number of subdivisions
     *   in x-dimension
     *   @param [detailY] optional number of subdivisions
     *   in y-dimension
     *   @chainable
     */
    function sphere(radius?: number, detailX?: number, detailY?: number): p5;

    /**
     *   Draw a cylinder with given radius and height
     *   DetailX and detailY determines the number of
     *   subdivisions in the x-dimension and the
     *   y-dimension of a cylinder. More subdivisions make
     *   the cylinder seem smoother. The recommended
     *   maximum value for detailX is 24. Using a value
     *   greater than 24 may cause a warning or slow down
     *   the browser.
     *   @param [radius] radius of the surface
     *   @param [height] height of the cylinder
     *   @param [detailX] number of subdivisions in
     *   x-dimension; default is 24
     *   @param [detailY] number of subdivisions in
     *   y-dimension; default is 1
     *   @param [bottomCap] whether to draw the bottom of
     *   the cylinder
     *   @param [topCap] whether to draw the top of the
     *   cylinder
     *   @chainable
     */
    function cylinder(
        radius?: number,
        height?: number,
        detailX?: number,
        detailY?: number,
        bottomCap?: boolean,
        topCap?: boolean
    ): p5;

    /**
     *   Draw a cone with given radius and height DetailX
     *   and detailY determine the number of subdivisions
     *   in the x-dimension and the y-dimension of a cone.
     *   More subdivisions make the cone seem smoother. The
     *   recommended maximum value for detailX is 24. Using
     *   a value greater than 24 may cause a warning or
     *   slow down the browser.
     *   @param [radius] radius of the bottom surface
     *   @param [height] height of the cone
     *   @param [detailX] number of segments, the more
     *   segments the smoother geometry default is 24
     *   @param [detailY] number of segments, the more
     *   segments the smoother geometry default is 1
     *   @param [cap] whether to draw the base of the cone
     *   @chainable
     */
    function cone(radius?: number, height?: number, detailX?: number, detailY?: number, cap?: boolean): p5;

    /**
     *   Draw an ellipsoid with given radius DetailX and
     *   detailY determine the number of subdivisions in
     *   the x-dimension and the y-dimension of a cone.
     *   More subdivisions make the ellipsoid appear to be
     *   smoother. Avoid detail number above 150, it may
     *   crash the browser.
     *   @param [radiusx] x-radius of ellipsoid
     *   @param [radiusy] y-radius of ellipsoid
     *   @param [radiusz] z-radius of ellipsoid
     *   @param [detailX] number of segments, the more
     *   segments the smoother geometry default is 24.
     *   Avoid detail number above 150, it may crash the
     *   browser.
     *   @param [detailY] number of segments, the more
     *   segments the smoother geometry default is 16.
     *   Avoid detail number above 150, it may crash the
     *   browser.
     *   @chainable
     */
    function ellipsoid(radiusx?: number, radiusy?: number, radiusz?: number, detailX?: number, detailY?: number): p5;

    /**
     *   Draw a torus with given radius and tube radius
     *   DetailX and detailY determine the number of
     *   subdivisions in the x-dimension and the
     *   y-dimension of a torus. More subdivisions make the
     *   torus appear to be smoother. The default and
     *   maximum values for detailX and detailY are 24 and
     *   16, respectively. Setting them to relatively small
     *   values like 4 and 6 allows you to create new
     *   shapes other than a torus.
     *   @param [radius] radius of the whole ring
     *   @param [tubeRadius] radius of the tube
     *   @param [detailX] number of segments in
     *   x-dimension, the more segments the smoother
     *   geometry default is 24
     *   @param [detailY] number of segments in
     *   y-dimension, the more segments the smoother
     *   geometry default is 16
     *   @chainable
     */
    function torus(radius?: number, tubeRadius?: number, detailX?: number, detailY?: number): p5;

    /**
     *   Allows movement around a 3D sketch using a mouse
     *   or trackpad or touch. Left-clicking and dragging
     *   or swipe motion will rotate the camera position
     *   about the center of the sketch, right-clicking and
     *   dragging or multi-swipe will pan the camera
     *   position without rotation, and using the mouse
     *   wheel (scrolling) or pinch in/out will move the
     *   camera further or closer from the center of the
     *   sketch. This function can be called with
     *   parameters dictating sensitivity to mouse/touch
     *   movement along the X and Y axes. Calling this
     *   function without parameters is equivalent to
     *   calling orbitControl(1,1). To reverse direction of
     *   movement in either axis, enter a negative number
     *   for sensitivity.
     *   @param [sensitivityX] sensitivity to mouse
     *   movement along X axis
     *   @param [sensitivityY] sensitivity to mouse
     *   movement along Y axis
     *   @param [sensitivityZ] sensitivity to scroll
     *   movement along Z axis
     *   @param [options] An optional object that can
     *   contain additional settings, disableTouchActions -
     *   Boolean, default value is true. Setting this to
     *   true makes mobile interactions smoother by
     *   preventing accidental interactions with the page
     *   while orbiting. But if you're already doing it via
     *   css or want the default touch actions, consider
     *   setting it to false. freeRotation - Boolean,
     *   default value is false. By default, horizontal
     *   movement of the mouse or touch pointer rotates the
     *   camera around the y-axis, and vertical movement
     *   rotates the camera around the x-axis. But if
     *   setting this option to true, the camera always
     *   rotates in the direction the pointer is moving.
     *   For zoom and move, the behavior is the same
     *   regardless of true/false.
     *   @chainable
     */
    function orbitControl(sensitivityX?: number, sensitivityY?: number, sensitivityZ?: number, options?: object): p5;

    /**
     *   debugMode() helps visualize 3D space by adding a
     *   grid to indicate where the ‘ground’ is in a sketch
     *   and an axes icon which indicates the +X, +Y, and
     *   +Z directions. This function can be called without
     *   parameters to create a default grid and axes icon,
     *   or it can be called according to the examples
     *   above to customize the size and position of the
     *   grid and/or axes icon. The grid is drawn using the
     *   most recently set stroke color and weight. To
     *   specify these parameters, add a call to stroke()
     *   and strokeWeight() just before the end of the
     *   draw() loop. By default, the grid will run through
     *   the origin (0,0,0) of the sketch along the XZ
     *   plane and the axes icon will be offset from the
     *   origin. Both the grid and axes icon will be sized
     *   according to the current canvas size. Note that
     *   because the grid runs parallel to the default
     *   camera view, it is often helpful to use debugMode
     *   along with orbitControl to allow full view of the
     *   grid.
     */
    function debugMode(): void;

    /**
     *   debugMode() helps visualize 3D space by adding a
     *   grid to indicate where the ‘ground’ is in a sketch
     *   and an axes icon which indicates the +X, +Y, and
     *   +Z directions. This function can be called without
     *   parameters to create a default grid and axes icon,
     *   or it can be called according to the examples
     *   above to customize the size and position of the
     *   grid and/or axes icon. The grid is drawn using the
     *   most recently set stroke color and weight. To
     *   specify these parameters, add a call to stroke()
     *   and strokeWeight() just before the end of the
     *   draw() loop. By default, the grid will run through
     *   the origin (0,0,0) of the sketch along the XZ
     *   plane and the axes icon will be offset from the
     *   origin. Both the grid and axes icon will be sized
     *   according to the current canvas size. Note that
     *   because the grid runs parallel to the default
     *   camera view, it is often helpful to use debugMode
     *   along with orbitControl to allow full view of the
     *   grid.
     *   @param mode either GRID or AXES
     */
    function debugMode(mode: p5.DEBUG_MODE): void;

    /**
     *   debugMode() helps visualize 3D space by adding a
     *   grid to indicate where the ‘ground’ is in a sketch
     *   and an axes icon which indicates the +X, +Y, and
     *   +Z directions. This function can be called without
     *   parameters to create a default grid and axes icon,
     *   or it can be called according to the examples
     *   above to customize the size and position of the
     *   grid and/or axes icon. The grid is drawn using the
     *   most recently set stroke color and weight. To
     *   specify these parameters, add a call to stroke()
     *   and strokeWeight() just before the end of the
     *   draw() loop. By default, the grid will run through
     *   the origin (0,0,0) of the sketch along the XZ
     *   plane and the axes icon will be offset from the
     *   origin. Both the grid and axes icon will be sized
     *   according to the current canvas size. Note that
     *   because the grid runs parallel to the default
     *   camera view, it is often helpful to use debugMode
     *   along with orbitControl to allow full view of the
     *   grid.
     *   @param mode either GRID or AXES
     *   @param [gridSize] size of one side of the grid
     *   @param [gridDivisions] number of divisions in the
     *   grid
     *   @param [xOff] X axis offset from origin (0,0,0)
     *   @param [yOff] Y axis offset from origin (0,0,0)
     *   @param [zOff] Z axis offset from origin (0,0,0)
     */
    function debugMode(
        mode: p5.UNKNOWN_P5_CONSTANT,
        gridSize?: number,
        gridDivisions?: number,
        xOff?: number,
        yOff?: number,
        zOff?: number
    ): void;

    /**
     *   debugMode() helps visualize 3D space by adding a
     *   grid to indicate where the ‘ground’ is in a sketch
     *   and an axes icon which indicates the +X, +Y, and
     *   +Z directions. This function can be called without
     *   parameters to create a default grid and axes icon,
     *   or it can be called according to the examples
     *   above to customize the size and position of the
     *   grid and/or axes icon. The grid is drawn using the
     *   most recently set stroke color and weight. To
     *   specify these parameters, add a call to stroke()
     *   and strokeWeight() just before the end of the
     *   draw() loop. By default, the grid will run through
     *   the origin (0,0,0) of the sketch along the XZ
     *   plane and the axes icon will be offset from the
     *   origin. Both the grid and axes icon will be sized
     *   according to the current canvas size. Note that
     *   because the grid runs parallel to the default
     *   camera view, it is often helpful to use debugMode
     *   along with orbitControl to allow full view of the
     *   grid.
     *   @param mode either GRID or AXES
     *   @param [axesSize] size of axes icon
     *   @param [xOff] X axis offset from origin (0,0,0)
     *   @param [yOff] Y axis offset from origin (0,0,0)
     *   @param [zOff] Z axis offset from origin (0,0,0)
     */
    function debugMode(
        mode: p5.UNKNOWN_P5_CONSTANT,
        axesSize?: number,
        xOff?: number,
        yOff?: number,
        zOff?: number
    ): void;

    /**
     *   debugMode() helps visualize 3D space by adding a
     *   grid to indicate where the ‘ground’ is in a sketch
     *   and an axes icon which indicates the +X, +Y, and
     *   +Z directions. This function can be called without
     *   parameters to create a default grid and axes icon,
     *   or it can be called according to the examples
     *   above to customize the size and position of the
     *   grid and/or axes icon. The grid is drawn using the
     *   most recently set stroke color and weight. To
     *   specify these parameters, add a call to stroke()
     *   and strokeWeight() just before the end of the
     *   draw() loop. By default, the grid will run through
     *   the origin (0,0,0) of the sketch along the XZ
     *   plane and the axes icon will be offset from the
     *   origin. Both the grid and axes icon will be sized
     *   according to the current canvas size. Note that
     *   because the grid runs parallel to the default
     *   camera view, it is often helpful to use debugMode
     *   along with orbitControl to allow full view of the
     *   grid.
     *   @param [gridSize] size of one side of the grid
     *   @param [gridDivisions] number of divisions in the
     *   grid
     *   @param [axesSize] size of axes icon
     */
    function debugMode(
        gridSize?: number,
        gridDivisions?: number,
        gridXOff?: number,
        gridYOff?: number,
        gridZOff?: number,
        axesSize?: number,
        axesXOff?: number,
        axesYOff?: number,
        axesZOff?: number
    ): void;

    /**
     *   Turns off debugMode() in a 3D sketch.
     */
    function noDebugMode(): void;

    /**
     *   Creates an ambient light with the given color.
     *   Ambient light does not come from a specific
     *   direction. Objects are evenly lit from all sides.
     *   Ambient lights are almost always used in
     *   combination with other types of lights.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param [alpha] alpha value relative to current
     *   color range (default is 0-255)
     *   @chainable
     */
    function ambientLight(v1: number, v2: number, v3: number, alpha?: number): p5;

    /**
     *   Creates an ambient light with the given color.
     *   Ambient light does not come from a specific
     *   direction. Objects are evenly lit from all sides.
     *   Ambient lights are almost always used in
     *   combination with other types of lights.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param gray number specifying value between white
     *   and black
     *   @param [alpha] alpha value relative to current
     *   color range (default is 0-255)
     *   @chainable
     */
    function ambientLight(gray: number, alpha?: number): p5;

    /**
     *   Creates an ambient light with the given color.
     *   Ambient light does not come from a specific
     *   direction. Objects are evenly lit from all sides.
     *   Ambient lights are almost always used in
     *   combination with other types of lights.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param value a color string
     *   @chainable
     */
    function ambientLight(value: string): p5;

    /**
     *   Creates an ambient light with the given color.
     *   Ambient light does not come from a specific
     *   direction. Objects are evenly lit from all sides.
     *   Ambient lights are almost always used in
     *   combination with other types of lights.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param values an array containing the
     *   red,green,blue & and alpha components of the color
     *   @chainable
     */
    function ambientLight(values: number[]): p5;

    /**
     *   Creates an ambient light with the given color.
     *   Ambient light does not come from a specific
     *   direction. Objects are evenly lit from all sides.
     *   Ambient lights are almost always used in
     *   combination with other types of lights.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color
     *   @chainable
     */
    function ambientLight(color: p5.Color): p5;

    /**
     *   Sets the color of the specular highlight of a
     *   non-ambient light (i.e. all lights except
     *   ambientLight()). specularColor() affects only the
     *   lights which are created after it in the code.
     *
     *   This function is used in combination with
     *   specularMaterial(). If a geometry does not use
     *   specularMaterial(), this function will have no
     *   effect.
     *
     *   The default color is white (255, 255, 255), which
     *   is used if specularColor() is not explicitly
     *   called.
     *
     *   Note: specularColor is equivalent to the
     *   Processing function lightSpecular.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @chainable
     */
    function specularColor(v1: number, v2: number, v3: number): p5;

    /**
     *   Sets the color of the specular highlight of a
     *   non-ambient light (i.e. all lights except
     *   ambientLight()). specularColor() affects only the
     *   lights which are created after it in the code.
     *
     *   This function is used in combination with
     *   specularMaterial(). If a geometry does not use
     *   specularMaterial(), this function will have no
     *   effect.
     *
     *   The default color is white (255, 255, 255), which
     *   is used if specularColor() is not explicitly
     *   called.
     *
     *   Note: specularColor is equivalent to the
     *   Processing function lightSpecular.
     *   @param gray number specifying value between white
     *   and black
     *   @chainable
     */
    function specularColor(gray: number): p5;

    /**
     *   Sets the color of the specular highlight of a
     *   non-ambient light (i.e. all lights except
     *   ambientLight()). specularColor() affects only the
     *   lights which are created after it in the code.
     *
     *   This function is used in combination with
     *   specularMaterial(). If a geometry does not use
     *   specularMaterial(), this function will have no
     *   effect.
     *
     *   The default color is white (255, 255, 255), which
     *   is used if specularColor() is not explicitly
     *   called.
     *
     *   Note: specularColor is equivalent to the
     *   Processing function lightSpecular.
     *   @param value color as a CSS string
     *   @chainable
     */
    function specularColor(value: string): p5;

    /**
     *   Sets the color of the specular highlight of a
     *   non-ambient light (i.e. all lights except
     *   ambientLight()). specularColor() affects only the
     *   lights which are created after it in the code.
     *
     *   This function is used in combination with
     *   specularMaterial(). If a geometry does not use
     *   specularMaterial(), this function will have no
     *   effect.
     *
     *   The default color is white (255, 255, 255), which
     *   is used if specularColor() is not explicitly
     *   called.
     *
     *   Note: specularColor is equivalent to the
     *   Processing function lightSpecular.
     *   @param values color as an array containing the
     *   red, green, and blue components
     *   @chainable
     */
    function specularColor(values: number[]): p5;

    /**
     *   Sets the color of the specular highlight of a
     *   non-ambient light (i.e. all lights except
     *   ambientLight()). specularColor() affects only the
     *   lights which are created after it in the code.
     *
     *   This function is used in combination with
     *   specularMaterial(). If a geometry does not use
     *   specularMaterial(), this function will have no
     *   effect.
     *
     *   The default color is white (255, 255, 255), which
     *   is used if specularColor() is not explicitly
     *   called.
     *
     *   Note: specularColor is equivalent to the
     *   Processing function lightSpecular.
     *   @param color color as a p5.Color
     *   @chainable
     */
    function specularColor(color: p5.Color): p5;

    /**
     *   Creates a directional light with the given color
     *   and direction. Directional light comes from one
     *   direction. The direction is specified as numbers
     *   inclusively between -1 and 1. For example, setting
     *   the direction as (0, -1, 0) will cause the
     *   geometry to be lit from below (since the light
     *   will be facing directly upwards). Similarly,
     *   setting the direction as (1, 0, 0) will cause the
     *   geometry to be lit from the left (since the light
     *   will be facing directly rightwards).
     *
     *   Directional lights do not have a specific point of
     *   origin, and therefore cannot be positioned closer
     *   or farther away from a geometry.
     *
     *   A maximum of 5 directional lights can be active at
     *   once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param x x component of direction (inclusive range
     *   of -1 to 1)
     *   @param y y component of direction (inclusive range
     *   of -1 to 1)
     *   @param z z component of direction (inclusive range
     *   of -1 to 1)
     *   @chainable
     */
    function directionalLight(v1: number, v2: number, v3: number, x: number, y: number, z: number): p5;

    /**
     *   Creates a directional light with the given color
     *   and direction. Directional light comes from one
     *   direction. The direction is specified as numbers
     *   inclusively between -1 and 1. For example, setting
     *   the direction as (0, -1, 0) will cause the
     *   geometry to be lit from below (since the light
     *   will be facing directly upwards). Similarly,
     *   setting the direction as (1, 0, 0) will cause the
     *   geometry to be lit from the left (since the light
     *   will be facing directly rightwards).
     *
     *   Directional lights do not have a specific point of
     *   origin, and therefore cannot be positioned closer
     *   or farther away from a geometry.
     *
     *   A maximum of 5 directional lights can be active at
     *   once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param direction direction of light as a p5.Vector
     *   @chainable
     */
    function directionalLight(v1: number, v2: number, v3: number, direction: p5.Vector): p5;

    /**
     *   Creates a directional light with the given color
     *   and direction. Directional light comes from one
     *   direction. The direction is specified as numbers
     *   inclusively between -1 and 1. For example, setting
     *   the direction as (0, -1, 0) will cause the
     *   geometry to be lit from below (since the light
     *   will be facing directly upwards). Similarly,
     *   setting the direction as (1, 0, 0) will cause the
     *   geometry to be lit from the left (since the light
     *   will be facing directly rightwards).
     *
     *   Directional lights do not have a specific point of
     *   origin, and therefore cannot be positioned closer
     *   or farther away from a geometry.
     *
     *   A maximum of 5 directional lights can be active at
     *   once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param x x component of direction (inclusive range
     *   of -1 to 1)
     *   @param y y component of direction (inclusive range
     *   of -1 to 1)
     *   @param z z component of direction (inclusive range
     *   of -1 to 1)
     *   @chainable
     */
    function directionalLight(color: p5.Color | number[] | string, x: number, y: number, z: number): p5;

    /**
     *   Creates a directional light with the given color
     *   and direction. Directional light comes from one
     *   direction. The direction is specified as numbers
     *   inclusively between -1 and 1. For example, setting
     *   the direction as (0, -1, 0) will cause the
     *   geometry to be lit from below (since the light
     *   will be facing directly upwards). Similarly,
     *   setting the direction as (1, 0, 0) will cause the
     *   geometry to be lit from the left (since the light
     *   will be facing directly rightwards).
     *
     *   Directional lights do not have a specific point of
     *   origin, and therefore cannot be positioned closer
     *   or farther away from a geometry.
     *
     *   A maximum of 5 directional lights can be active at
     *   once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param direction direction of light as a p5.Vector
     *   @chainable
     */
    function directionalLight(color: p5.Color | number[] | string, direction: p5.Vector): p5;

    /**
     *   Creates a point light with the given color and
     *   position. A point light emits light from a single
     *   point in all directions. Because the light is
     *   emitted from a specific point (position), it has a
     *   different effect when it is positioned farther vs.
     *   nearer an object.
     *
     *   A maximum of 5 point lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param x x component of position
     *   @param y y component of position
     *   @param z z component of position
     *   @chainable
     */
    function pointLight(v1: number, v2: number, v3: number, x: number, y: number, z: number): p5;

    /**
     *   Creates a point light with the given color and
     *   position. A point light emits light from a single
     *   point in all directions. Because the light is
     *   emitted from a specific point (position), it has a
     *   different effect when it is positioned farther vs.
     *   nearer an object.
     *
     *   A maximum of 5 point lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param position of light as a p5.Vector
     *   @chainable
     */
    function pointLight(v1: number, v2: number, v3: number, position: p5.Vector): p5;

    /**
     *   Creates a point light with the given color and
     *   position. A point light emits light from a single
     *   point in all directions. Because the light is
     *   emitted from a specific point (position), it has a
     *   different effect when it is positioned farther vs.
     *   nearer an object.
     *
     *   A maximum of 5 point lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param x x component of position
     *   @param y y component of position
     *   @param z z component of position
     *   @chainable
     */
    function pointLight(color: p5.Color | number[] | string, x: number, y: number, z: number): p5;

    /**
     *   Creates a point light with the given color and
     *   position. A point light emits light from a single
     *   point in all directions. Because the light is
     *   emitted from a specific point (position), it has a
     *   different effect when it is positioned farther vs.
     *   nearer an object.
     *
     *   A maximum of 5 point lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param position of light as a p5.Vector
     *   @chainable
     */
    function pointLight(color: p5.Color | number[] | string, position: p5.Vector): p5;

    /**
     *   Places an ambient and directional light in the
     *   scene. The lights are set to ambientLight(128,
     *   128, 128) and directionalLight(128, 128, 128, 0,
     *   0, -1). Note: lights need to be called (whether
     *   directly or indirectly) within draw() to remain
     *   persistent in a looping program. Placing them in
     *   setup() will cause them to only have an effect the
     *   first time through the loop.
     *   @chainable
     */
    function lights(): p5;

    /**
     *   Sets the falloff rate for pointLight() and
     *   spotLight(). lightFalloff() affects only the
     *   lights which are created after it in the code.
     *
     *   The constant, linear, an quadratic parameters are
     *   used to calculate falloff as follows:
     *
     *   d = distance from light position to vertex
     *   position
     *
     *   falloff = 1 / (CONSTANT + d * LINEAR + (d * d) *
     *   QUADRATIC)
     *   @param constant CONSTANT value for determining
     *   falloff
     *   @param linear LINEAR value for determining falloff
     *   @param quadratic QUADRATIC value for determining
     *   falloff
     *   @chainable
     */
    function lightFalloff(constant: number, linear: number, quadratic: number): p5;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param x x component of position
     *   @param y y component of position
     *   @param z z component of position
     *   @param rx x component of light direction
     *   (inclusive range of -1 to 1)
     *   @param ry y component of light direction
     *   (inclusive range of -1 to 1)
     *   @param rz z component of light direction
     *   (inclusive range of -1 to 1)
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     *   @chainable
     */
    function spotLight(
        v1: number,
        v2: number,
        v3: number,
        x: number,
        y: number,
        z: number,
        rx: number,
        ry: number,
        rz: number,
        angle?: number,
        concentration?: number
    ): p5;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param position position of light as a p5.Vector
     *   @param direction direction of light as a p5.Vector
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     */
    function spotLight(
        color: p5.Color | number[] | string,
        position: p5.Vector,
        direction: p5.Vector,
        angle?: number,
        concentration?: number
    ): void;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param position position of light as a p5.Vector
     *   @param direction direction of light as a p5.Vector
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     */
    function spotLight(
        v1: number,
        v2: number,
        v3: number,
        position: p5.Vector,
        direction: p5.Vector,
        angle?: number,
        concentration?: number
    ): void;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param x x component of position
     *   @param y y component of position
     *   @param z z component of position
     *   @param direction direction of light as a p5.Vector
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     */
    function spotLight(
        color: p5.Color | number[] | string,
        x: number,
        y: number,
        z: number,
        direction: p5.Vector,
        angle?: number,
        concentration?: number
    ): void;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param position position of light as a p5.Vector
     *   @param rx x component of light direction
     *   (inclusive range of -1 to 1)
     *   @param ry y component of light direction
     *   (inclusive range of -1 to 1)
     *   @param rz z component of light direction
     *   (inclusive range of -1 to 1)
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     */
    function spotLight(
        color: p5.Color | number[] | string,
        position: p5.Vector,
        rx: number,
        ry: number,
        rz: number,
        angle?: number,
        concentration?: number
    ): void;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param x x component of position
     *   @param y y component of position
     *   @param z z component of position
     *   @param direction direction of light as a p5.Vector
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     */
    function spotLight(
        v1: number,
        v2: number,
        v3: number,
        x: number,
        y: number,
        z: number,
        direction: p5.Vector,
        angle?: number,
        concentration?: number
    ): void;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param position position of light as a p5.Vector
     *   @param rx x component of light direction
     *   (inclusive range of -1 to 1)
     *   @param ry y component of light direction
     *   (inclusive range of -1 to 1)
     *   @param rz z component of light direction
     *   (inclusive range of -1 to 1)
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     */
    function spotLight(
        v1: number,
        v2: number,
        v3: number,
        position: p5.Vector,
        rx: number,
        ry: number,
        rz: number,
        angle?: number,
        concentration?: number
    ): void;

    /**
     *   Creates a spot light with the given color,
     *   position, light direction, angle, and
     *   concentration. Like a pointLight(), a spotLight()
     *   emits light from a specific point (position). It
     *   has a different effect when it is positioned
     *   farther vs. nearer an object.
     *
     *   However, unlike a pointLight(), the light is
     *   emitted in one direction along a conical shape.
     *   The shape of the cone can be controlled using the
     *   angle and concentration parameters.
     *
     *   The angle parameter is used to determine the
     *   radius of the cone. And the concentration
     *   parameter is used to focus the light towards the
     *   center of the cone. Both parameters are optional,
     *   however if you want to specify concentration, you
     *   must also specify angle. The minimum concentration
     *   value is 1.
     *
     *   A maximum of 5 spot lights can be active at once.
     *
     *   Note: lights need to be called (whether directly
     *   or indirectly) within draw() to remain persistent
     *   in a looping program. Placing them in setup() will
     *   cause them to only have an effect the first time
     *   through the loop.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @param x x component of position
     *   @param y y component of position
     *   @param z z component of position
     *   @param rx x component of light direction
     *   (inclusive range of -1 to 1)
     *   @param ry y component of light direction
     *   (inclusive range of -1 to 1)
     *   @param rz z component of light direction
     *   (inclusive range of -1 to 1)
     *   @param [angle] angle of cone. Defaults to PI/3
     *   @param [concentration] concentration of cone.
     *   Defaults to 100
     */
    function spotLight(
        color: p5.Color | number[] | string,
        x: number,
        y: number,
        z: number,
        rx: number,
        ry: number,
        rz: number,
        angle?: number,
        concentration?: number
    ): void;

    /**
     *   Removes all lights present in a sketch. All
     *   subsequent geometry is rendered without lighting
     *   (until a new light is created with a call to one
     *   of the lighting functions (lights(),
     *   ambientLight(), directionalLight(), pointLight(),
     *   spotLight()).
     *   @chainable
     */
    function noLights(): p5;

    /**
     *   Load a 3d model from an OBJ or STL file.
     *   loadModel() should be placed inside of preload().
     *   This allows the model to load fully before the
     *   rest of your code is run.
     *
     *   One of the limitations of the OBJ and STL format
     *   is that it doesn't have a built-in sense of scale.
     *   This means that models exported from different
     *   programs might be very different sizes. If your
     *   model isn't displaying, try calling loadModel()
     *   with the normalized parameter set to true. This
     *   will resize the model to a scale appropriate for
     *   p5. You can also make additional changes to the
     *   final size of your model with the scale()
     *   function.
     *
     *   Also, the support for colored STL files is not
     *   present. STL files with color will be rendered
     *   without color properties.
     *   @param path Path of the model to be loaded
     *   @param normalize If true, scale the model to a
     *   standardized size when loading
     *   @param [successCallback] Function to be called
     *   once the model is loaded. Will be passed the 3D
     *   model object.
     *   @param [failureCallback] called with event error
     *   if the model fails to load.
     *   @param [fileType] The file extension of the model
     *   (.stl, .obj).
     *   @return the p5.Geometry object
     */
    function loadModel(
        path: string,
        normalize: boolean,
        successCallback?: (p1: p5.Geometry) => any,
        failureCallback?: (p1: Event) => any,
        fileType?: string
    ): p5.Geometry;

    /**
     *   Load a 3d model from an OBJ or STL file.
     *   loadModel() should be placed inside of preload().
     *   This allows the model to load fully before the
     *   rest of your code is run.
     *
     *   One of the limitations of the OBJ and STL format
     *   is that it doesn't have a built-in sense of scale.
     *   This means that models exported from different
     *   programs might be very different sizes. If your
     *   model isn't displaying, try calling loadModel()
     *   with the normalized parameter set to true. This
     *   will resize the model to a scale appropriate for
     *   p5. You can also make additional changes to the
     *   final size of your model with the scale()
     *   function.
     *
     *   Also, the support for colored STL files is not
     *   present. STL files with color will be rendered
     *   without color properties.
     *   @param path Path of the model to be loaded
     *   @param [successCallback] Function to be called
     *   once the model is loaded. Will be passed the 3D
     *   model object.
     *   @param [failureCallback] called with event error
     *   if the model fails to load.
     *   @param [fileType] The file extension of the model
     *   (.stl, .obj).
     *   @return the p5.Geometry object
     */
    function loadModel(
        path: string,
        successCallback?: (p1: p5.Geometry) => any,
        failureCallback?: (p1: Event) => any,
        fileType?: string
    ): p5.Geometry;

    /**
     *   Render a 3d model to the screen.
     *   @param model Loaded 3d model to be rendered
     */
    function model(model: p5.Geometry): void;

    /**
     *   Creates a new p5.Shader object from the provided
     *   vertex and fragment shader files. The shader files
     *   are loaded asynchronously in the background, so
     *   this method should be used in preload().
     *
     *   Note, shaders can only be used in WEBGL mode.
     *   @param vertFilename path to file containing vertex
     *   shader source code
     *   @param fragFilename path to file containing
     *   fragment shader source code
     *   @param [callback] callback to be executed after
     *   loadShader completes. On success, the p5.Shader
     *   object is passed as the first argument.
     *   @param [errorCallback] callback to be executed
     *   when an error occurs inside loadShader. On error,
     *   the error is passed as the first argument.
     *   @return a shader object created from the provided
     *   vertex and fragment shader files.
     */
    function loadShader(
        vertFilename: string,
        fragFilename: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): p5.Shader;

    /**
     *   Creates a new p5.Shader object from the provided
     *   vertex and fragment shader code. Note, shaders can
     *   only be used in WEBGL mode.
     *   @param vertSrc source code for the vertex shader
     *   @param fragSrc source code for the fragment shader
     *   @return a shader object created from the provided
     *   vertex and fragment shaders.
     */
    function createShader(vertSrc: string, fragSrc: string): p5.Shader;

    /**
     *   Sets the p5.Shader object to be used to render
     *   subsequent shapes. Custom shaders can be created
     *   using the createShader() and loadShader()
     *   functions.
     *
     *   Use resetShader() to restore the default shaders.
     *
     *   Note, shaders can only be used in WEBGL mode.
     *   @param s the p5.Shader object to use for rendering
     *   shapes.
     *   @chainable
     */
    function shader(s: p5.Shader): p5;

    /**
     *   Restores the default shaders. Code that runs after
     *   resetShader() will not be affected by the shader
     *   previously set by shader()
     *   @chainable
     */
    function resetShader(): p5;

    /**
     *   Sets the texture that will be used to render
     *   subsequent shapes. A texture is like a "skin" that
     *   wraps around a 3D geometry. Currently supported
     *   textures are images, video, and offscreen renders.
     *
     *   To texture a geometry created with beginShape(),
     *   you will need to specify uv coordinates in
     *   vertex().
     *
     *   Note, texture() can only be used in WEBGL mode.
     *
     *   You can view more materials in this example.
     *   @param tex image to use as texture
     *   @chainable
     */
    function texture(tex: p5.Image | p5.MediaElement | p5.Graphics | p5.Framebuffer): p5;

    /**
     *   Sets the coordinate space for texture mapping. The
     *   default mode is IMAGE which refers to the actual
     *   coordinates of the image. NORMAL refers to a
     *   normalized space of values ranging from 0 to 1.
     *   With IMAGE, if an image is 100×200 pixels, mapping
     *   the image onto the entire size of a quad would
     *   require the points (0,0) (100, 0) (100,200)
     *   (0,200). The same mapping in NORMAL is (0,0) (1,0)
     *   (1,1) (0,1).
     *   @param mode either IMAGE or NORMAL
     */
    function textureMode(mode: p5.TEXTURE_MODE): void;

    /**
     *   Sets the global texture wrapping mode. This
     *   controls how textures behave when their uv's go
     *   outside of the 0 to 1 range. There are three
     *   options: CLAMP, REPEAT, and MIRROR. CLAMP causes
     *   the pixels at the edge of the texture to extend to
     *   the bounds. REPEAT causes the texture to tile
     *   repeatedly until reaching the bounds. MIRROR works
     *   similarly to REPEAT but it flips the texture with
     *   every new tile.
     *
     *   REPEAT & MIRROR are only available if the texture
     *   is a power of two size (128, 256, 512, 1024,
     *   etc.).
     *
     *   This method will affect all textures in your
     *   sketch until a subsequent textureWrap() call is
     *   made.
     *
     *   If only one argument is provided, it will be
     *   applied to both the horizontal and vertical axes.
     *   @param wrapX either CLAMP, REPEAT, or MIRROR
     *   @param [wrapY] either CLAMP, REPEAT, or MIRROR
     */
    function textureWrap(wrapX: p5.WRAP_X, wrapY?: p5.WRAP_Y): void;

    /**
     *   Sets the current material as a normal material. A
     *   normal material is not affected by light. It is
     *   often used as a placeholder material when
     *   debugging.
     *
     *   Surfaces facing the X-axis become red, those
     *   facing the Y-axis become green, and those facing
     *   the Z-axis become blue.
     *
     *   You can view more materials in this example.
     *   @chainable
     */
    function normalMaterial(): p5;

    /**
     *   Sets the ambient color of the material. The
     *   ambientMaterial() color represents the components
     *   of the ambientLight() color that the object
     *   reflects.
     *
     *   Consider an ambientMaterial() with the color
     *   yellow (255, 255, 0). If the ambientLight() emits
     *   the color white (255, 255, 255), then the object
     *   will appear yellow as it will reflect the red and
     *   green components of the light. If the
     *   ambientLight() emits the color red (255, 0, 0),
     *   then the object will appear red as it will reflect
     *   the red component of the light. If the
     *   ambientLight() emits the color blue (0, 0, 255),
     *   then the object will appear black, as there is no
     *   component of the light that it can reflect.
     *
     *   You can view more materials in this example.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @chainable
     */
    function ambientMaterial(v1: number, v2: number, v3: number): p5;

    /**
     *   Sets the ambient color of the material. The
     *   ambientMaterial() color represents the components
     *   of the ambientLight() color that the object
     *   reflects.
     *
     *   Consider an ambientMaterial() with the color
     *   yellow (255, 255, 0). If the ambientLight() emits
     *   the color white (255, 255, 255), then the object
     *   will appear yellow as it will reflect the red and
     *   green components of the light. If the
     *   ambientLight() emits the color red (255, 0, 0),
     *   then the object will appear red as it will reflect
     *   the red component of the light. If the
     *   ambientLight() emits the color blue (0, 0, 255),
     *   then the object will appear black, as there is no
     *   component of the light that it can reflect.
     *
     *   You can view more materials in this example.
     *   @param gray number specifying value between white
     *   and black
     *   @chainable
     */
    function ambientMaterial(gray: number): p5;

    /**
     *   Sets the ambient color of the material. The
     *   ambientMaterial() color represents the components
     *   of the ambientLight() color that the object
     *   reflects.
     *
     *   Consider an ambientMaterial() with the color
     *   yellow (255, 255, 0). If the ambientLight() emits
     *   the color white (255, 255, 255), then the object
     *   will appear yellow as it will reflect the red and
     *   green components of the light. If the
     *   ambientLight() emits the color red (255, 0, 0),
     *   then the object will appear red as it will reflect
     *   the red component of the light. If the
     *   ambientLight() emits the color blue (0, 0, 255),
     *   then the object will appear black, as there is no
     *   component of the light that it can reflect.
     *
     *   You can view more materials in this example.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @chainable
     */
    function ambientMaterial(color: p5.Color | number[] | string): p5;

    /**
     *   Sets the emissive color of the material. An
     *   emissive material will display the emissive color
     *   at full strength regardless of lighting. This can
     *   give the appearance that the object is glowing.
     *
     *   Note, "emissive" is a misnomer in the sense that
     *   the material does not actually emit light that
     *   will affect surrounding objects.
     *
     *   You can view more materials in this example.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param [alpha] alpha value relative to current
     *   color range (default is 0-255)
     *   @chainable
     */
    function emissiveMaterial(v1: number, v2: number, v3: number, alpha?: number): p5;

    /**
     *   Sets the emissive color of the material. An
     *   emissive material will display the emissive color
     *   at full strength regardless of lighting. This can
     *   give the appearance that the object is glowing.
     *
     *   Note, "emissive" is a misnomer in the sense that
     *   the material does not actually emit light that
     *   will affect surrounding objects.
     *
     *   You can view more materials in this example.
     *   @param gray number specifying value between white
     *   and black
     *   @chainable
     */
    function emissiveMaterial(gray: number): p5;

    /**
     *   Sets the emissive color of the material. An
     *   emissive material will display the emissive color
     *   at full strength regardless of lighting. This can
     *   give the appearance that the object is glowing.
     *
     *   Note, "emissive" is a misnomer in the sense that
     *   the material does not actually emit light that
     *   will affect surrounding objects.
     *
     *   You can view more materials in this example.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @chainable
     */
    function emissiveMaterial(color: p5.Color | number[] | string): p5;

    /**
     *   Sets the specular color of the material. A
     *   specular material is reflective (shiny). The
     *   shininess can be controlled by the shininess()
     *   function.
     *
     *   Like ambientMaterial(), the specularMaterial()
     *   color is the color the object will reflect under
     *   ambientLight(). However unlike ambientMaterial(),
     *   for all other types of lights (directionalLight(),
     *   pointLight(), spotLight()), a specular material
     *   will reflect the color of the light source. This
     *   is what gives it its "shiny" appearance.
     *
     *   You can view more materials in this example.
     *   @param gray number specifying value between white
     *   and black.
     *   @param [alpha] alpha value relative to current
     *   color range (default is 0-255)
     *   @chainable
     */
    function specularMaterial(gray: number, alpha?: number): p5;

    /**
     *   Sets the specular color of the material. A
     *   specular material is reflective (shiny). The
     *   shininess can be controlled by the shininess()
     *   function.
     *
     *   Like ambientMaterial(), the specularMaterial()
     *   color is the color the object will reflect under
     *   ambientLight(). However unlike ambientMaterial(),
     *   for all other types of lights (directionalLight(),
     *   pointLight(), spotLight()), a specular material
     *   will reflect the color of the light source. This
     *   is what gives it its "shiny" appearance.
     *
     *   You can view more materials in this example.
     *   @param v1 red or hue value relative to the current
     *   color range
     *   @param v2 green or saturation value relative to
     *   the current color range
     *   @param v3 blue or brightness value relative to the
     *   current color range
     *   @param [alpha] alpha value relative to current
     *   color range (default is 0-255)
     *   @chainable
     */
    function specularMaterial(v1: number, v2: number, v3: number, alpha?: number): p5;

    /**
     *   Sets the specular color of the material. A
     *   specular material is reflective (shiny). The
     *   shininess can be controlled by the shininess()
     *   function.
     *
     *   Like ambientMaterial(), the specularMaterial()
     *   color is the color the object will reflect under
     *   ambientLight(). However unlike ambientMaterial(),
     *   for all other types of lights (directionalLight(),
     *   pointLight(), spotLight()), a specular material
     *   will reflect the color of the light source. This
     *   is what gives it its "shiny" appearance.
     *
     *   You can view more materials in this example.
     *   @param color color as a p5.Color, as an array, or
     *   as a CSS string
     *   @chainable
     */
    function specularMaterial(color: p5.Color | number[] | string): p5;

    /**
     *   Sets the amount of gloss ("shininess") of a
     *   specularMaterial(). The default and minimum value
     *   is 1.
     *   @param shine degree of shininess
     *   @chainable
     */
    function shininess(shine: number): p5;

    /**
     *   Sets the position of the current camera in a 3D
     *   sketch. Parameters for this function define the
     *   camera's position, the center of the sketch (where
     *   the camera is pointing), and an up direction (the
     *   orientation of the camera). This function
     *   simulates the movements of the camera, allowing
     *   objects to be viewed from various angles.
     *   Remember, it does not move the objects themselves
     *   but the camera instead. For example when the
     *   centerX value is positive, and the camera is
     *   rotating to the right side of the sketch, the
     *   object will seem like it's moving to the left.
     *
     *   See this example to view the position of your
     *   camera.
     *
     *   If no parameters are given, the following default
     *   is used: camera(0, 0, (height/2) / tan(PI/6), 0,
     *   0, 0, 0, 1, 0)
     *   @param [x] camera position value on x axis
     *   @param [y] camera position value on y axis
     *   @param [z] camera position value on z axis
     *   @param [centerX] x coordinate representing center
     *   of the sketch
     *   @param [centerY] y coordinate representing center
     *   of the sketch
     *   @param [centerZ] z coordinate representing center
     *   of the sketch
     *   @param [upX] x component of direction 'up' from
     *   camera
     *   @param [upY] y component of direction 'up' from
     *   camera
     *   @param [upZ] z component of direction 'up' from
     *   camera
     *   @chainable
     */
    function camera(
        x?: number,
        y?: number,
        z?: number,
        centerX?: number,
        centerY?: number,
        centerZ?: number,
        upX?: number,
        upY?: number,
        upZ?: number
    ): p5;

    /**
     *   Sets a perspective projection for the current
     *   camera in a 3D sketch. This projection represents
     *   depth through foreshortening: objects that are
     *   close to the camera appear their actual size while
     *   those that are further away from the camera appear
     *   smaller. The parameters to this function define
     *   the viewing frustum (the truncated pyramid within
     *   which objects are seen by the camera) through
     *   vertical field of view, aspect ratio (usually
     *   width/height), and near and far clipping planes.
     *
     *   If no parameters are given, the following default
     *   is used: perspective(PI/3, width/height, eyeZ/10,
     *   eyeZ*10), where eyeZ is equal to ((height/2) /
     *   tan(PI/6)).
     *   @param [fovy] camera frustum vertical field of
     *   view, from bottom to top of view, in angleMode
     *   units
     *   @param [aspect] camera frustum aspect ratio
     *   @param [near] frustum near plane length
     *   @param [far] frustum far plane length
     *   @chainable
     */
    function perspective(fovy?: number, aspect?: number, near?: number, far?: number): p5;

    /**
     *   Sets an orthographic projection for the current
     *   camera in a 3D sketch and defines a box-shaped
     *   viewing frustum within which objects are seen. In
     *   this projection, all objects with the same
     *   dimension appear the same size, regardless of
     *   whether they are near or far from the camera. The
     *   parameters to this function specify the viewing
     *   frustum where left and right are the minimum and
     *   maximum x values, top and bottom are the minimum
     *   and maximum y values, and near and far are the
     *   minimum and maximum z values.
     *
     *   If no parameters are given, the following default
     *   is used: ortho(-width/2, width/2, -height/2,
     *   height/2).
     *   @param [left] camera frustum left plane
     *   @param [right] camera frustum right plane
     *   @param [bottom] camera frustum bottom plane
     *   @param [top] camera frustum top plane
     *   @param [near] camera frustum near plane
     *   @param [far] camera frustum far plane
     *   @chainable
     */
    function ortho(left?: number, right?: number, bottom?: number, top?: number, near?: number, far?: number): p5;

    /**
     *   Sets the frustum of the current camera as defined
     *   by the parameters. A frustum is a geometric form:
     *   a pyramid with its top cut off. With the viewer's
     *   eye at the imaginary top of the pyramid, the six
     *   planes of the frustum act as clipping planes when
     *   rendering a 3D view. Thus, any form inside the
     *   clipping planes is visible; anything outside those
     *   planes is not visible.
     *
     *   Setting the frustum changes the perspective of the
     *   scene being rendered. This can be achieved more
     *   simply in many cases by using perspective().
     *
     *   If no parameters are given, the following default
     *   is used: frustum(-width/20, width/20, height/20,
     *   -height/20, eyeZ/10, eyeZ*10), where eyeZ is equal
     *   to ((height/2) / tan(PI/6)).
     *   @param [left] camera frustum left plane
     *   @param [right] camera frustum right plane
     *   @param [bottom] camera frustum bottom plane
     *   @param [top] camera frustum top plane
     *   @param [near] camera frustum near plane
     *   @param [far] camera frustum far plane
     *   @chainable
     */
    function frustum(left?: number, right?: number, bottom?: number, top?: number, near?: number, far?: number): p5;

    /**
     *   Creates a new p5.Camera object and sets it as the
     *   current (active) camera. The new camera is
     *   initialized with a default position (see camera())
     *   and a default perspective projection (see
     *   perspective()). Its properties can be controlled
     *   with the p5.Camera methods.
     *
     *   Note: Every 3D sketch starts with a default camera
     *   initialized. This camera can be controlled with
     *   the global methods camera(), perspective(),
     *   ortho(), and frustum() if it is the only camera in
     *   the scene.
     *   @return The newly created camera object.
     */
    function createCamera(): p5.Camera;

    /**
     *   Sets the current (active) camera of a 3D sketch.
     *   Allows for switching between multiple cameras.
     *   @param cam p5.Camera object
     */
    function setCamera(cam: p5.Camera): void;

    /**
     *   Sets the normal to use for subsequent vertices.
     *   @chainable
     */
    function vertexNormal(x: number, y: number, z: number, v: p5.Vector): p5;

    /**
     *   Set attributes for the WebGL Drawing context. This
     *   is a way of adjusting how the WebGL renderer works
     *   to fine-tune the display and performance. Note
     *   that this will reinitialize the drawing context if
     *   called after the WebGL canvas is made.
     *
     *   If an object is passed as the parameter, all
     *   attributes not declared in the object will be set
     *   to defaults.
     *
     *   The available attributes are:
     *
     *   alpha - indicates if the canvas contains an alpha
     *   buffer default is true
     *
     *   depth - indicates whether the drawing buffer has a
     *   depth buffer of at least 16 bits - default is true
     *
     *   stencil - indicates whether the drawing buffer has
     *   a stencil buffer of at least 8 bits
     *
     *   antialias - indicates whether or not to perform
     *   anti-aliasing default is false (true in Safari)
     *
     *   premultipliedAlpha - indicates that the page
     *   compositor will assume the drawing buffer contains
     *   colors with pre-multiplied alpha default is true
     *
     *   preserveDrawingBuffer - if true the buffers will
     *   not be cleared and and will preserve their values
     *   until cleared or overwritten by author (note that
     *   p5 clears automatically on draw loop) default is
     *   true
     *
     *   perPixelLighting - if true, per-pixel lighting
     *   will be used in the lighting shader otherwise
     *   per-vertex lighting is used. default is true.
     *
     *   version - either 1 or 2, to specify which WebGL
     *   version to ask for. By default, WebGL 2 will be
     *   requested. If WebGL2 is not available, it will
     *   fall back to WebGL 1. You can check what version
     *   is used with by looking at the global webglVersion
     *   property.
     *   @param key Name of attribute
     *   @param value New value of named attribute
     */
    function setAttributes(key: string, value: boolean): void;

    /**
     *   Set attributes for the WebGL Drawing context. This
     *   is a way of adjusting how the WebGL renderer works
     *   to fine-tune the display and performance. Note
     *   that this will reinitialize the drawing context if
     *   called after the WebGL canvas is made.
     *
     *   If an object is passed as the parameter, all
     *   attributes not declared in the object will be set
     *   to defaults.
     *
     *   The available attributes are:
     *
     *   alpha - indicates if the canvas contains an alpha
     *   buffer default is true
     *
     *   depth - indicates whether the drawing buffer has a
     *   depth buffer of at least 16 bits - default is true
     *
     *   stencil - indicates whether the drawing buffer has
     *   a stencil buffer of at least 8 bits
     *
     *   antialias - indicates whether or not to perform
     *   anti-aliasing default is false (true in Safari)
     *
     *   premultipliedAlpha - indicates that the page
     *   compositor will assume the drawing buffer contains
     *   colors with pre-multiplied alpha default is true
     *
     *   preserveDrawingBuffer - if true the buffers will
     *   not be cleared and and will preserve their values
     *   until cleared or overwritten by author (note that
     *   p5 clears automatically on draw loop) default is
     *   true
     *
     *   perPixelLighting - if true, per-pixel lighting
     *   will be used in the lighting shader otherwise
     *   per-vertex lighting is used. default is true.
     *
     *   version - either 1 or 2, to specify which WebGL
     *   version to ask for. By default, WebGL 2 will be
     *   requested. If WebGL2 is not available, it will
     *   fall back to WebGL 1. You can check what version
     *   is used with by looking at the global webglVersion
     *   property.
     *   @param obj object with key-value pairs
     */
    function setAttributes(obj: object): void;

    /**
     *   Returns the Audio Context for this sketch. Useful
     *   for users who would like to dig deeper into the
     *   Web Audio API . Some browsers require users to
     *   startAudioContext with a user gesture, such as
     *   touchStarted in the example below.
     *   @return AudioContext for this sketch
     */
    function getAudioContext(): object;

    /**
     *   It is not only a good practice to give users
     *   control over starting audio. This policy is
     *   enforced by many web browsers, including iOS and
     *   Google Chrome, which create the Web Audio API's
     *   Audio Context in a suspended state. In these
     *   browser-specific policies, sound will not play
     *   until a user interaction event (i.e.
     *   mousePressed()) explicitly resumes the
     *   AudioContext, or starts an audio node. This can be
     *   accomplished by calling start() on a
     *   p5.Oscillator,  play() on a p5.SoundFile, or
     *   simply userStartAudio().
     *
     *   userStartAudio() starts the AudioContext on a user
     *   gesture. The default behavior will enable audio on
     *   any mouseUp or touchEnd event. It can also be
     *   placed in a specific interaction function, such as
     *   mousePressed() as in the example below. This
     *   method utilizes StartAudioContext , a library by
     *   Yotam Mann (MIT Licence, 2016).
     *   @param [elements] This argument can be an Element,
     *   Selector String, NodeList, p5.Element, jQuery
     *   Element, or an Array of any of those.
     *   @param [callback] Callback to invoke when the
     *   AudioContext has started
     *   @return Returns a Promise that resolves when the
     *   AudioContext state is 'running'
     */
    function userStartAudio(elements?: Element | any[], callback?: (...args: any[]) => any): Promise<any>;

    /**
     *   Returns a number representing the output volume
     *   for sound in this sketch.
     *   @return Output volume for sound in this sketch.
     *   Should be between 0.0 (silence) and 1.0.
     */
    function getOutputVolume(): number;

    /**
     *   Scale the output of all sound in this sketch
     *   Scaled between 0.0 (silence) and 1.0 (full
     *   volume). 1.0 is the maximum amplitude of a digital
     *   sound, so multiplying by greater than 1.0 may
     *   cause digital distortion. To fade, provide a
     *   rampTime parameter. For more complex fades, see
     *   the Envelope class. Alternately, you can pass in a
     *   signal source such as an oscillator to modulate
     *   the amplitude with an audio signal.
     *
     *   How This Works: When you load the p5.sound module,
     *   it creates a single instance of p5sound. All sound
     *   objects in this module output to p5sound before
     *   reaching your computer's output. So if you change
     *   the amplitude of p5sound, it impacts all of the
     *   sound in this module.
     *
     *   If no value is provided, returns a Web Audio API
     *   Gain Node
     *   @param volume Volume (amplitude) between 0.0 and
     *   1.0 or modulating signal/oscillator
     *   @param [rampTime] Fade for t seconds
     *   @param [timeFromNow] Schedule this event to happen
     *   at t seconds in the future
     */
    function outputVolume(volume: number | object, rampTime?: number, timeFromNow?: number): void;

    /**
     *   Returns a number representing the sample rate, in
     *   samples per second, of all sound objects in this
     *   audio context. It is determined by the sampling
     *   rate of your operating system's sound card, and it
     *   is not currently possile to change. It is often
     *   44100, or twice the range of human hearing.
     *   @return samplerate samples per second
     */
    function sampleRate(): number;

    /**
     *   Returns the closest MIDI note value for a given
     *   frequency.
     *   @param frequency A freqeuncy, for example, the "A"
     *   above Middle C is 440Hz
     *   @return MIDI note value
     */
    function freqToMidi(frequency: number): number;

    /**
     *   Returns the frequency value of a MIDI note value.
     *   General MIDI treats notes as integers where middle
     *   C is 60, C# is 61, D is 62 etc. Useful for
     *   generating musical frequencies with oscillators.
     *   @param midiNote The number of a MIDI note
     *   @return Frequency value of the given MIDI note
     */
    function midiToFreq(midiNote: number): number;

    /**
     *   List the SoundFile formats that you will include.
     *   LoadSound will search your directory for these
     *   extensions, and will pick a format that is
     *   compatable with the client's web browser. Here is
     *   a free online file converter.
     *   @param [formats] i.e. 'mp3', 'wav', 'ogg'
     */
    function soundFormats(formats?: string): void;

    /**
     *   Save a p5.SoundFile as a .wav file. The browser
     *   will prompt the user to download the file to their
     *   device. For uploading audio to a server, use
     *   p5.SoundFile.saveBlob.
     *   @param soundFile p5.SoundFile that you wish to
     *   save
     *   @param fileName name of the resulting .wav file.
     */
    function saveSound(soundFile: p5.SoundFile, fileName: string): void;

    /**
     *   loadSound() returns a new p5.SoundFile from a
     *   specified path. If called during preload(), the
     *   p5.SoundFile will be ready to play in time for
     *   setup() and draw(). If called outside of preload,
     *   the p5.SoundFile will not be ready immediately, so
     *   loadSound accepts a callback as the second
     *   parameter. Using a  local server is recommended
     *   when loading external files.
     *   @param path Path to the sound file, or an array
     *   with paths to soundfiles in multiple formats i.e.
     *   ['sound.ogg', 'sound.mp3']. Alternately, accepts
     *   an object: either from the HTML5 File API, or a
     *   p5.File.
     *   @param [successCallback] Name of a function to
     *   call once file loads
     *   @param [errorCallback] Name of a function to call
     *   if there is an error loading the file.
     *   @param [whileLoading] Name of a function to call
     *   while file is loading. This function will receive
     *   the percentage loaded so far, from 0.0 to 1.0.
     *   @return Returns a p5.SoundFile
     */
    function loadSound(
        path: string | any[],
        successCallback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any,
        whileLoading?: (...args: any[]) => any
    ): p5.SoundFile;

    /**
     *   Create a p5.Convolver. Accepts a path to a
     *   soundfile that will be used to generate an impulse
     *   response.
     *   @param path path to a sound file
     *   @param [callback] function to call if loading is
     *   successful. The object will be passed in as the
     *   argument to the callback function.
     *   @param [errorCallback] function to call if loading
     *   is not successful. A custom error will be passed
     *   in as the argument to the callback function.
     */
    function createConvolver(
        path: string,
        callback?: (...args: any[]) => any,
        errorCallback?: (...args: any[]) => any
    ): p5.Convolver;

    /**
     *   Set the global tempo, in beats per minute, for all
     *   p5.Parts. This method will impact all active
     *   p5.Parts.
     *   @param BPM Beats Per Minute
     *   @param rampTime Seconds from now
     */
    function setBPM(BPM: number, rampTime: number): void;

    /**
     *   p5.soundOut is the p5.sound final output bus. It
     *   sends output to the destination of this window's
     *   web audio context. It contains Web Audio API nodes
     *   including a dyanmicsCompressor (.limiter), and
     *   Gain Nodes for .input and .output.
     */
    let soundOut: object;
}


// ============================================================================
// DUAL EXPORT SUPPORT
// Supports both import styles for maximum compatibility
// ============================================================================
export as namespace p5;
export = p5;
