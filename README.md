Scribunto library for embedded color processing in the FANDOM environment.

This Lua project is a **direct port** of https://dev.wikia.com/wiki/Colors (a JavaScript library by Pecoes), with support for alpha values.

A full author history of the original JS library is here:
>https://dev.wikia.com/wiki/MediaWiki:Colors/code.js?action=history

# Usage
**Note:** The module is unpublished on FANDOM. **DON'T** actually use it yet.
```lua
local colors = require("Dev:Colors")
```

# Package members and methods
The following keys are exposed in the module package:
* `colors.wikia` - template utility for accessing CSS colors
* `colors.css` - template utility for FANDOM CSS $parameter support
* `colors.fromRgb` - color item creation from RGB tuple
* `colors.fromHsl` - color item creation from HSL tuple
* `colors.parse` - color parsing of any valid [CSS color](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value) string
* `colors.params` - table of FANDOM SASS colors for Lua modules

***Example usage on a wiki:***
```html
<div style="{{#invoke:colors|css|1px solid $color-community-header}}"></div>
```
***Rendered output on desktop:***
```html
<div style="1px solid #404a57"></div>
```

# Color item methods
## Property getter-setter methods
These methods retrieve or override color properties. They accept a optional value parameter.
* `Color:red` - red color value (1-255)
* `Color:green` - green color value (1-255)
* `Color:blue` - blue color value (1-255)
* `Color:hue` - hue color value (0-1)
* `Color:sat` - saturation color value (0-1)
* `Color:lum` - luminosity value (0-1)
* `Color:alpha` - alpha value (0-1)
## Processing methods
The methods marked **\*** accept one optional modifier value parameter.
* `Color:rotate`* - color rotation by degree
* `Color:saturate`* - color saturation change by modifier (scaled by 100)
* `Color:lighten`* - color lightness change by modifier (scaled by 100)
* `Color:mix` - mixing with other color items or strings (scaled by 100, in reverse)
```lua
c.parse('#000'):mix('#fff', 80):hex() -- outputs '#ccc'
```
* `Color:invert` - inversion of color item
* `Color:complement` - complement of color item
## Output methods
These methods return a valid CSS color string.
* `Color:hex` - hexadecimal RGB string output (`#RRGGBB(AA)`)
* `Color:rgb` - [RGB(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#rgb()_and_rgba()) (`rgb(#,#%,#%)`)
* `Color:hsl` - [HSL(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#hsl()_and_hsla()) (`hsl(#,#%,#%)`)
* `Color:tostring` - hexadecimal or HSLA string string output (`#RRGGBB`/`hsla(#,#%,#%,#)`)
## Conditionals for color logic
These methods return a boolean for use in Lua logic.
* `Color:isBright` - brightness status for color item (accepts optional 1-100 limit parameter)
* `Color:isColor` - color saturation and visibility status for color item
