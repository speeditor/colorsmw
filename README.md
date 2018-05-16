Stribunto library for embedded color processing in the FANDOM environment. Written in Lua.

# Package members and methods
* c.wikia - template utility for accessing CSS colors
* c.css - template utility for FANDOM CSS $parameter support
* c.fromRgb - color item creation from RGB tuple
* c.fromHsl - color item creation from HSL tuple
* c.parse - color parsing of any valid [CSS <color>](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value) string
* c.params - table of FANDOM SASS colors for Lua modules

# Color item methods
## Processing methods
* Color:rotate - color rotation by degree
* Color:saturate - color saturation change by modifier (scaled by 100)
* Color:lighten - color lightness change by modifier (scaled by 100)
* Color:alpha - alpha channel modification by modifier (scaled by 100)
* Color:mix - mixing with other color items or strings (scaled by 100, in reverse)
* Color:invert - inversion of color item
* Color:complement - complement of color item
## Output methods
* Color:hex - hexadecimal RGB string output (`#RRGGBB(AA)`)
* Color:rgb - [RGB(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#rgb()_and_rgba())
* Color:hsl - [HSL(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#hsl()_and_hsla())
* Color:tostring - hexadecimal or HSLA string string output (`#RRGGBB`/`hsla(#,#%,#%,#)`)
## Conditionals for color logic
* Color:isBright - brightness boolean for color item
* Color:isColor - color saturation and visibility status for color item