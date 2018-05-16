Scribunto library for embedded color processing in the FANDOM environment.

This Lua project is a **direct port** of https://dev.wikia.com/wiki/Colors - a JavaScript library by Pecoes, with support for alpha values.

A full author history of the original JS library is here:
>https://dev.wikia.com/wiki/MediaWiki:Colors/code.js?action=history

# Usage
**Note:** The module is unpublished on FANDOM. **DON't** actually use it yet.
```lua
local colors = require("Dev:Colors")
```

# Package members and methods
* `colors.wikia` - template utility for accessing CSS colors
* `colors.css` - template utility for FANDOM CSS $parameter support
* `colors.fromRgb` - color item creation from RGB tuple
* `colors.fromHsl` - color item creation from HSL tuple
* `colors.parse` - color parsing of any valid [CSS color](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value) string
* `colors.params` - table of FANDOM SASS colors for Lua modules

***Example usage on a wiki:***
```
<div style="{{#invoke:colors|css|1px solid $color-community-header}}"></div>
```
***Rendered output on desktop:***
```
<div style="1px solid #404a57"></div>
```

# Color item methods
## Property getter-setter methods
* `Color:red` - red color value (1-255)
* `Color:green` - green color value (1-255)
* `Color:blue` - blue color value (1-255)
* `Color:hue` - hue color value (0-1)
* `Color:sat` - saturation color value (0-1)
* `Color:lum` - luminosity value (0-1)
* `Color:alpha` - alpha value (0-1)
## Processing methods
* `Color:rotate` - color rotation by degree
* `Color:saturate` - color saturation change by modifier (scaled by 100)
* `Color:lighten` - color lightness change by modifier (scaled by 100)
* `Color:mix` - mixing with other color items or strings (scaled by 100, in reverse)
* `Color:invert` - inversion of color item
* `Color:complement` - complement of color item
## Output methods
* `Color:hex` - hexadecimal RGB string output (`#RRGGBB(AA)`)
* `Color:rgb` - [RGB(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#rgb()_and_rgba()) (`rgb(#,#%,#%)`)
* `Color:hsl` - [HSL(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#hsl()_and_hsla()) (`hsl(#,#%,#%)`)
* `Color:tostring` - hexadecimal or HSLA string string output (`#RRGGBB`/`hsla(#,#%,#%,#)`)
## Conditionals for color logic
* `Color:isBright` - brightness boolean for color item
* `Color:isColor` - color saturation and visibility status for color item