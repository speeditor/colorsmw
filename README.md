[![GitHub release](https://img.shields.io/github/release/speeditor/colorsmw/all.svg?style=flat-square&longCache=true)](https://github.com/speeditor/colorsmw/releases) [![Lua](https://img.shields.io/badge/lua%20-5.1.5-blue.svg?style=flat-square&longCache=true)](https://dev.wikia.com/wiki/Lua_reference_manual) [![UnitTests](https://img.shields.io/badge/unit%20tests-passing-green.svg?style=flat-square&longCache=true)](https://dev.wikia.com/wiki/Module_talk:Colors/testcases)

# colorsmw
Scribunto library for embedded color processing in the FANDOM environment ([extended documentation](https://dev.wikia.com/wiki/Global_Lua_Modules/Colors)).

This Lua project is a **direct port** of https://dev.wikia.com/wiki/Colors (a JavaScript library by Pecoes), with support for alpha values.

A full author history of the original JS library is here:
>https://dev.wikia.com/wiki/MediaWiki:Colors/code.js?action=history

## Usage
```lua
local colors = require("Dev:Colors")
```

## Package members and methods
The following keys are exposed in the module package:
* `colors.main` - template wrapper function
* `colors.wikia` - template utility for accessing CSS colors
* `colors.css` - template utility for FANDOM CSS $parameter support
* `colors.text` - template utility for high contrast text colors
* `colors.fromRgb` - color item creation from RGB tuple
* `colors.fromHsl` - color item creation from HSL tuple
* `colors.parse` - color parsing of any valid [CSS color](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value) string
* `colors.instance` - color instance test
* `colors.params` - table of FANDOM SASS colors for Lua modules

***Example usage on a wiki:***
```mediawiki
<div style="{{#invoke:colors|css|1px solid $color-community-header}}"></div>
```
***Example usage in a Lua module***
```lua
local colors = require("Dev:Colors")
mw.log(colors.fromHsl(0.18, 74, 87):string())
```

## Color item methods
### Property getter-setter methods
These methods retrieve or override color properties. They accept a optional value parameter.
* `Color:red` - red color value (1-255)
* `Color:green` - green color value (1-255)
* `Color:blue` - blue color value (1-255)
* `Color:hue` - hue color value (0-360)
* `Color:sat` - saturation color value (0-100)
* `Color:lum` - luminosity value (0-100)
* `Color:alpha` - alpha value (0-100)
### Processing methods
The methods marked **\*** accept one optional modifier value parameter.
* `Color:rotate`* - color rotation by degree (0 to 360)
* `Color:saturate`* - color saturation change by modifier (-100 to 100)
* `Color:lighten`* - color lightness change by modifier (-100 to 100)
* `Color:opacify`* - color alpha change by modifier (-100 to 100)
* `Color:mix` - mixing with other color items or strings (scaled by 100, reverse weighted)
```lua
colors.parse('#fff'):mix('#000', 80):hex() -- outputs '#cccccc'
```
* `Color:invert` - inversion of color item
* `Color:complement` - complement of color item
### Output methods
These methods return a valid CSS color string.
* `Color:hex` - hexadecimal RGB string output (`#RRGGBB(AA)`)
* `Color:rgb` - [RGB(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#rgb()_and_rgba()) (`rgb(#,#%,#%)`)
* `Color:hsl` - [HSL(A) functional string output](https://developer.mozilla.org/en-US/docs/Web/CSS/color_value#hsl()_and_hsla()) (`hsl(#,#%,#%)`)
* `Color:string` - hexadecimal or HSLA string string output (`#RRGGBB`/`hsla(#,#%,#%,#)`)
### Conditionals for color logic
These methods return a boolean for use in Lua logic.
* `Color:bright` - brightness status for color item (accepts optional 1-100 limit parameter)
* `Color:luminant` - [luminance](https://en.wikipedia.org/wiki/Relative_luminance) status for color item (accepts optional 1-100 limit parameter)
* `Color:chromatic` - color saturation and visibility status for color item
