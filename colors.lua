-- Colors library for embedded color processing on FANDOM.
-- Supports HSL, RGB and hexadecimal web colors.
-- @module  c
-- @version 0.6.7
-- @usage   require("Dev:Colors")
-- @author  Speedit
-- @release beta; experimental, undergoing testing
-- <nowiki>

-- Library variables
--- Package table
local c = {}
--- Color item class
--- @classmod Color
local Color = { tuple = {}, type = 'rgb', alpha = 1 }

-- Site SASS styling parameter cache.
-- @todo Cache mw.site.sassParams when [[github:Wikia/app/pull/15301]] is merged.
--       Currently, the module has static parameters for dev.wikia.com only.
--
-- local sassParams = mw.site.sassParams
local sassParams = {
    ['background-dynamic'] = 'false',
    ['background-image'] = '',
    ['background-image-height'] = '801',
    ['background-image-width'] = '1700',
    ['color-body'] = '#2c343d',
    ['color-body-middle'] = '#2c343d',
    ['color-buttons'] = '#00b7e0',
    ['color-community-header'] = '#404a57',
    ['color-header'] = '#404a57',
    ['color-links'] = '#00c8e0',
    ['color-page'] = '#39424d',
    ['oasisTypography'] = 1,
    ['page-opacity'] = '100',
    ['widthType'] = 0
}

-- Web color RGB preset table.
local presets = {
    aliceblue = { 240, 248, 255 },
    antiquewhite = { 250, 235, 215 },
    aqua = { 0, 255, 255 },
    aquamarine = { 127, 255, 212 },
    azure = { 240, 255, 255 },
    beige = { 245, 245, 220 },
    bisque = { 255, 228, 196 },
    black = { 0, 0, 0 },
    blanchedalmond = { 255, 235, 205 },
    blue = { 0, 0, 255 },
    blueviolet = { 138, 43, 226 },
    brown = { 165, 42, 42 },
    burlywood = { 222, 184, 135 },
    cadetblue = { 95, 158, 160 },
    chartreuse = { 127, 255, 0 },
    chocolate = { 210, 105, 30 },
    coral = { 255, 127, 80 },
    cornflowerblue = { 100, 149, 237 },
    cornsilk = { 255, 248, 220 },
    crimson = { 220, 20, 60 },
    cyan = { 0, 255, 255 },
    darkblue = { 0, 0, 139 },
    darkcyan = { 0, 139, 139 },
    darkgoldenrod = { 184, 134, 11 },
    darkgray = { 169, 169, 169 },
    darkgrey = { 169, 169, 169 },
    darkgreen = { 0, 100, 0 },
    darkkhaki = { 189, 183, 107 },
    darkmagenta = { 139, 0, 139 },
    darkolivegreen = { 85, 107, 47 },
    darkorange = { 255, 140, 0 },
    darkorchid = { 153, 50, 204 },
    darkred = { 139, 0, 0 },
    darksalmon = { 233, 150, 122 },
    darkseagreen = { 143, 188, 143 },
    darkslateblue = { 72, 61, 139 },
    darkslategray = { 47, 79, 79 },
    darkslategrey = { 47, 79, 79 },
    darkturquoise = { 0, 206, 209 },
    darkviolet = { 148, 0, 211 },
    deeppink = { 255, 20, 147 },
    deepskyblue = { 0, 191, 255 },
    dimgray = { 105, 105, 105 },
    dimgrey = { 105, 105, 105 },
    dodgerblue = { 30, 144, 255 },
    firebrick = { 178, 34, 34 },
    floralwhite = { 255, 250, 240 },
    forestgreen = { 34, 139, 34 },
    fuchsia = { 255, 0, 255 },
    gainsboro = { 220, 220, 220 },
    ghostwhite = { 248, 248, 255 },
    gold = { 255, 215, 0 },
    goldenrod = { 218, 165, 32 },
    gray = { 128, 128, 128 },
    grey = { 128, 128, 128 },
    green = { 0, 128, 0 },
    greenyellow = { 173, 255, 47 },
    honeydew = { 240, 255, 240 },
    hotpink = { 255, 105, 180 },
    indianred  = { 205, 92, 92 },
    indigo   = { 75, 0, 130 },
    ivory = { 255, 255, 240 },
    khaki = { 240, 230, 140 },
    lavender = { 230, 230, 250 },
    lavenderblush = { 255, 240, 245 },
    lawngreen = { 124, 252, 0 },
    lemonchiffon = { 255, 250, 205 },
    lightblue = { 173, 216, 230 },
    lightcoral = { 240, 128, 128 },
    lightcyan = { 224, 255, 255 },
    lightgoldenrodyellow = { 250, 250, 210 },
    lightgray = { 211, 211, 211 },
    lightgrey = { 211, 211, 211 },
    lightgreen = { 144, 238, 144 },
    lightpink = { 255, 182, 193 },
    lightsalmon = { 255, 160, 122 },
    lightseagreen = { 32, 178, 170 },
    lightskyblue = { 135, 206, 250 },
    lightslategray = { 119, 136, 153 },
    lightslategrey = { 119, 136, 153 },
    lightsteelblue = { 176, 196, 222 },
    lightyellow = { 255, 255, 224 },
    lime = { 0, 255, 0 },
    limegreen = { 50, 205, 50 },
    linen = { 250, 240, 230 },
    magenta = { 255, 0, 255 },
    maroon = { 128, 0, 0 },
    mediumaquamarine = { 102, 205, 170 },
    mediumblue = { 0, 0, 205 },
    mediumorchid = { 186, 85, 211 },
    mediumpurple = { 147, 112, 219 },
    mediumseagreen = { 60, 179, 113 },
    mediumslateblue = { 123, 104, 238 },
    mediumspringgreen = { 0, 250, 154 },
    mediumturquoise = { 72, 209, 204 },
    mediumvioletred = { 199, 21, 133 },
    midnightblue = { 25, 25, 112 },
    mintcream = { 245, 255, 250 },
    mistyrose = { 255, 228, 225 },
    moccasin = { 255, 228, 181 },
    navajowhite = { 255, 222, 173 },
    navy = { 0, 0, 128 },
    oldlace = { 253, 245, 230 },
    olive = { 128, 128, 0 },
    olivedrab = { 107, 142, 35 },
    orange = { 255, 165, 0 },
    orangered = { 255, 69, 0 },
    orchid = { 218, 112, 214 },
    palegoldenrod = { 238, 232, 170 },
    palegreen = { 152, 251, 152 },
    paleturquoise = { 175, 238, 238 },
    palevioletred = { 219, 112, 147 },
    papayawhip = { 255, 239, 213 },
    peachpuff = { 255, 218, 185 },
    peru = { 205, 133, 63 },
    pink = { 255, 192, 203 },
    plum = { 221, 160, 221 },
    powderblue = { 176, 224, 230 },
    purple = { 128, 0, 128 },
    rebeccapurple = { 102, 51, 153 },
    red = { 255, 0, 0 },
    rosybrown = { 188, 143, 143 },
    royalblue = { 65, 105, 225 },
    saddlebrown = { 139, 69, 19 },
    salmon = { 250, 128, 114 },
    sandybrown = { 244, 164, 96 },
    seagreen = { 46, 139, 87 },
    seashell = { 255, 245, 238 },
    sienna = { 160, 82, 45 },
    silver = { 192, 192, 192 },
    skyblue = { 135, 206, 235 },
    slateblue = { 106, 90, 205 },
    slategray = { 112, 128, 144 },
    slategrey = { 112, 128, 144 },
    snow = { 255, 250, 250 },
    springgreen = { 0, 255, 127 },
    steelblue = { 70, 130, 180 },
    tan = { 210, 180, 140 },
    teal = { 0, 128, 128 },
    thistle = { 216, 191, 216 },
    tomato = { 255, 99, 71 },
    turquoise = { 64, 224, 208 },
    violet = { 238, 130, 238 },
    wheat = { 245, 222, 179 },
    white = { 255, 255, 255 },
    whitesmoke = { 245, 245, 245 },
    yellow = { 255, 255, 0 },
    yellowgreen = { 154, 205, 50 }
}

-- Validation ranges for color types and number formats.
local ranges = {
    rgb = { 0, 255 },
    hsl = { 0, 1 },
    alpha = { 0, 1 },
    percentage = { -100, 100 },
    mix = { 0, 100 },
    degree = { -360, 360 }
}

-- Boundary validation for color types.
-- @param t Range type.
-- @param n Number to validate.
-- @raise 'color value $n invalid or out of $t bounds'
-- @return {bool} Validity of number.
function check(t, n)
    local min = ranges[t][1] -- Boundary variables
    local max = ranges[t][2]
    -- Boundary comparison
    if type(n) ~= 'number' then
        error('invalid color value input: ' .. type(n) .. ' "' .. n .. '"')
    elseif n < min or n > max then
        error('color value "' .. n .. '" invalid or out of "' .. t .. '" bounds')
    end
end

-- Instantiate a new Color instance.
-- @function Color:new
-- @param typ Type - color space 'hsl' or 'rgb'
-- @param tup Color tuple in HSL or RGB
-- @param alp Alpha value range 0-1
-- @raise 'no color data provided'
-- @raise 'no valid color type'
-- @return Color instance.
function Color.new(self, tup, typ, alp)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    -- Validate color data tuple
    if type(tup) ~= 'table' or #tup ~= 3 then
        error('no color data provided')
    end
    -- Validate color type
    local typdir = { rgb = 1, hsl = 1 }
    if type(typdir[typ]) == 'nil' then
        error('invalid valid color type "' .. typ ..'" specified')
    end
    -- Validate color tuple numbers
    for i, n in ipairs(tup) do
        check(typ, n)
    end
    check('alpha', alp)
    -- Initialise properties
    o.tuple = tup
    o.type  = typ
    if alp then
        o.alpha = alp
    end
    return o -- output
end

-- Creation of RGB color instances.
-- @param r red   1-255
-- @param g green 1-255
-- @param b blue  1-255
-- @param a alpha 0-1
-- @see Color:new
-- @return Color instance.
function c.fromRgb(r, g, b, a)
    return Color:new({ r, g, b }, 'rgb', a or 1);
end

-- Creation of HSL color instances.
-- @param h Hue value.        0-1
-- @param s Saturation value. 0-1
-- @param l Luminance value.  0-1
-- @param a Alpha channel.    0-1
-- @see Color:new
-- @return Color instance.    
function c.fromHsl(h, s, l, a)
    return Color:new({ h, s, l }, 'hsl', a or 1);
end

-- Parsing logic for color strings.
-- @param str Valid color string.
-- @raise 'Cannot parse $str'
-- @see Color:new
-- @return Color instance.
function c.parse(str)
    local typ
    local tup = {}
    local alp = 1
    str = string.gsub(str, '%s', '')
    -- Variable substitution
    if c.params and c.params[string.match(str, '^%$([%w-]+)$') or ''] then
        str = c.params[string.match(str, '^%$([%w-]+)$')]
    elseif sassParams[string.match(str, '^%$([%w-]+)$') or ''] then
        str = sassParams[string.match(str, '^%$([%w-]+)$')]
    end
    -- Subroutine for RGB/HSL color data extraction
    function extract(str)
        for t in string.gmatch(str, '([^,]+)') do
            if #tup == 3 then
                alpha = tonumber(t)
            else
                tup[#tup+1] = tonumber(t)
            end
        end
    end
    -- Parsing patterns for hex format
    if string.match(str, '^%#[%x]+$') and #str == 4 or #str == 5 or #str == 7 or #str == 9 then
        -- Hex color data extraction
        if #str == 4 then
            tup[1], tup[2], tup[3] = string.match(str, '^%#(%x)(%x)(%x)$')
            tup = { tup[1] .. tup[1], tup[2] .. tup[2], tup[3] .. tup[3] }
        elseif #str == 5 then
            tup[1], tup[2], tup[3], alp = string.match(str, '^%#(%x)(%x)(%x)(%x)$')
            tup = { tup[1] .. tup[1], tup[2] .. tup[2], tup[3] .. tup[3] }
            alp = alp .. alp
        elseif #str == 7 then
            tup[1], tup[2], tup[3] = string.match(str, '^%#(%x%x)(%x%x)(%x%x)$')
            alp = 1
        elseif #str == 9 then
            tup[1], tup[2], tup[3], alp = string.match(str, '^%#(%x%x)(%x%x)(%x%x)(%x%x)$')
        end
        -- RGB conversion from hex format
        for i, t in ipairs(tup) do
            tup[i] = tonumber(t, 16)
        end
        if #str == 5 or #str == 9 then
            alp = tonumber(alp, 16)
        end
        typ = 'rgb'
    -- Parsing patterns for RGB format
    elseif string.match(str, 'rgb[a]?%([%d,]%)') then
        extract(string.match(str, '^rgba?%(([0-9.,]+)%)$'))
        typ = 'rgb'
    -- Parsing patterns for HSL format
    elseif string.match(str, 'hsl[a]?%([%d,]%)') then
        extract(string.match(str, '^hsla?%(([0-9.,]+)%)$'))
        typ = 'hsl'
    -- Conversion of web color names to RGB
    elseif presets[str] then
        tup = presets[str]
        typ = 'rgb'
    -- Error if string format is invalid
    else error('cannot parse "' + str'"') end
    -- Pass data to color constructor
    return Color:new(tup, typ, alp)
end

-- Color hexadecimal string output
-- @name Color:hex
-- @return Hexadecimal color string.
function Color.hex(self)
    -- RGB conversion, variables
    local this = clone(self, 'rgb')
    local hex = '#'
    local alp
    -- Hex string concatenation
    for i, t in ipairs(this.tuple) do
        -- Hexadecimal conversion
        if #string.format('%x', t) == 1 then -- leftpad
            hex = hex .. '0' .. string.format('%x', t)
        else
            hex = hex .. string.format('%x', t)
        end
    end
    -- Alpha channel addition
    if this.alpha ~= 1 then
        alp = string.format('%x', this.alpha*255)
        hex = hex .. alp
    end
    return hex -- output
end

-- Color string output as default.
-- @name Color:tostring()
-- @return Hexadecimal 6-digit or HSLA color string.
function Color.tostring(self)
    if self.alpha ~= 1 then
        return self:hsl()
    else
        return self:hex()
    end
end

-- Color space string output.
local spaces = { 'rgb', 'hsl' }
for i, t in ipairs(spaces) do
    -- @name Color:rgb
    -- @return RGB color string.
    -- @name Color:hsl
    -- @return HSL color string.
    Color[t] = function(self)
        local this = clone(self, t)
        if this.alpha ~= 1 then
            return t + 'a(' + table.concat(color.tuple, ', ') + ', ' + color.alpha ')'
        else
            return t + '(' + table.concat(color.tuple, ', ') ')'
        end
    end
end

-- Cloning utility for color items.
-- @param clr Color instance.
-- @param typ Color type for clone.
-- @return New (clone) color instance.
function clone(clr, typ)
    local c = Color:new(
        {
            clr.tuple[1],
            clr.tuple[2],
            clr.tuple[3]
        },
        clr.type,
        clr.alpha
    ) -- new color
    convert(c, typ) -- conversion
    return c -- output
end

-- Limiting ranges for color processing.
-- @param val Numeric value to limit.
-- @param max Maximum value for limit boundary.
-- @return Limited value.
function limit(val, max)
    return math.max(0, math.min(val, max))
end

-- Circular spatial processing for ranges.
-- @param val Numeric value to cycle.
-- @param max Maximum value for cycle boundary.
-- @return Cyclical positive value below max.
function circle(val, max)
    if val < 0 then        -- negative; below cycle minimum
        val = val + max
    elseif val > max then -- exceeds cycle maximum
        val = val - max
    end
    return val -- output
end

-- Color space conversion.
-- @param clr Color instance.
-- @param typ Color type to output.
-- @return Converted color instance.
function convert(clr, typ)
    if clr.type ~= typ then
        clr.type   = typ
        if typ == 'rgb' then
            clr.tuple = hslToRgb(clr.tuple)
        else
            clr.tuple = rgbToHsl(clr.tuple)
        end
    end
    if clr.type == 'rgb' then
        for i, t in ipairs(clr.tuple) do
            clr.tuple[i] = math.floor(clr.tuple[i])
        end
    end
end

-- RGB-HSL tuple conversion
-- @param rgb Tuple table of RGB values.
-- @return Tuple table of HSL values.
function rgbToHsl(rgb)
    for i, t in ipairs(rgb) do
        rgb[i] = i/255
    end
    local r = rgb[1]
    local g = rgb[2]
    local b = rgb[3]
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local l = (max + min) / 2
    local h
    local s
    local m
    if max == min then -- achromatic
        local a = 0
        h,s = a,a
    else
        local d = max - min
        if l > 0.5 then
            s = d / (2 - max - min)
        else
            s = d / (max + min)
        end
        if max == r then
            if g < b then m = 6 else m = 0 end
            h = (g - b)  / d + m
        elseif max == g then
            h = (b - r)  / d + 2
        elseif max == b then
            h = (r - g)  / d + 4
        end
        h = h/6;
    end
    return { h, s, l }
end

-- HSL component conversion subroutine to RGB
-- @param p temporary variable 1
-- @param q temporary variable 2
-- @param t modifier for primary color
-- @see http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
function hueToRgb(p, q, t)
    if t < 0 then
        t = t + 1
    elseif t > 1 then
        t = t - 1
    end
    if t < 1/6 then
        return p + (q - p)  * 6 * t
    elseif t < 1/2 then
        return q
    elseif t < 2/3 then
        return p + (q - p)  * (2/3 - t)  * 6
    else
        return p
    end
end

-- HSL-RGB tuple conversion.
-- @param hsl Tuple table of HSL values.
-- @return Tuple table of RGB values.
function hslToRgb(hsl)
    local h = hsl[1]
    local s = hsl[2]
    local l = hsl[3]
    local r
    local g
    local b
    -- Achromatic handling
    if s == 0 then
        local a = 1
        r,g,b = a,a,a
    -- RGB conversion
    else
        -- Assign first temporary variable
        if l < 0.5 then
            local q = l * (1 + s) 
        else 
            local q = l + s - l * s
        end
        -- Derive second temporary variable
        local p = 2 * l - q
        -- Use subroutine for RGB color values
        r = hueToRgb(p, q, h + 1/3)
        g = hueToRgb(p, q, h)
        b = hueToRgb(p, q, h - 1/3)
    end
    -- Conversion to 8-bit values
    return { r * 255, g * 255, b * 255 }
end

-- Color property getter-setter.
-- @name Color:red
-- @param val Red value to set.         1 - 255
-- @name Color:green
-- @param val Green value to set.       1 - 255
-- @name Color:blue
-- @param val Blue value to set.        1 - 255
-- @name Color:hue
-- @param val Hue value to set.         0 - 1
-- @name Color:sat
-- @param val Saturation value to set.  0 - 1
-- @name Color:lum
-- @param val Luminosity value to set.  0 - 1
local props = { 'red', 'green', 'blue', 'hue', 'saturation', 'lightness' }
for i, p in ipairs(props) do
    local n = (i - 1) / 3
    if i < 1 then
        typ = 'rgb'
    else
        typ = 'hsl'
    end
    Color[p] = function(self, val)
        local this = clone(self, typ)
        if value then
            check(typ, val)
            this.tuple[n] = value
            return this
        else
            return this.tuple[n]
        end
    end
end
-- Alpha getter-setter for color compositing.
-- @name Color:alpha
-- @param mod Modifier 1 - max (100 by default)
-- @return Color instance.
function Color.alpha(self, val)
    if value then
        check('alpha', val)
        self.alpha = val / 100
    else
        return self.alpha
    end
end

-- Post-processing for web color properties.
local ops = { 'rotate', 'saturate', 'lighten' }
for i, o in ipairs(ops) do
    if o == 'rotate' then
        local div = 360
        local typ = 'degree'
        local cap = circle
    else 
        local div = 100
        local typ = 'percentage'
        local cap = limit
    end
    -- @name Color:rotate
    -- @param mod Modifier 0 - 360
    -- @name Color:saturate
    -- @param mod Modifier 0 - 100
    -- @name Color:lighten
    -- @param mod Modifier 0 - 100
    -- @return Color instance.
    Color[o] = function(self, mod)
        check(typ, mod)
        local this = clone(self, 'hsl')
        this.tuple[i] = cap(self.tuple[i] * (1 + mod / div), 1)
        return this
    end
end

-- Opacification utility for color compositing.
-- @name Color:opacify
-- @param mod Modifier -100 - 100 (100 by default)
-- @return Color instance.
function Color.opacify(self, mod)
    check('percentage', mod)
    self.alpha = cap(self.tuple[i] * (1 + mod / 100), 1)
    return self
end

-- Color additive mixing utility.
-- @name Color:mix
-- @param other Module-compatible color string or instance.
-- @param weight Color weight of original (0 - 100).
-- @return Color instance.
function Color.mix(self, other, weight)
    -- Conversion for strings
    if not other.isColor then
        other = c.parse(other)
        convert(other, 'rgb')
    else
        other = clone(other, 'rgb')
    end
    -- Mix weight, variables
    weight = weight or 50
    check('mix', weight)
    weight = weight/100
    local this = clone(self, 'rgb')
    -- Mixing logic
    for i, t in ipairs(this.tuple) do
        this.tuple[i] = math.floor(t * weight + other.tuple[i] * (1 - weight))
        this.tuple[i] = limit(t, 255)
    end
    return self -- output
end

-- Color inversion utility.
-- name Color:invert
-- @return Color instance.
function Color.invert(self)
    local this = clone(self, 'rgb')
    -- Calculate 8-bit inverse of RGB tuple.
    for i, t in ipairs(self.tuple) do
        self.tuple[i] = 255 - t
    end
    return self -- output
end

-- Complementary color utility.
-- @name Color:complement
-- @return Color instance.
function Color.complement(self)
    return self:rotate(180)
end

-- Color brightness testing.
-- @name Color:isBright
-- @param lim Luminosity threshold (0.5 default).
-- @return Boolean for luminosity beyond threshold.
function Color.isBright(self, lim)
    if lim then
        lim = tonumber(lim)/100
    else
        lim = 0.5
    end
    local clr = clone(self, 'hsl')
    return clr.alpha >= lim
end

-- Color status testing.
-- @name Color:isColor
-- @return Boolean for whether the instance is a color.
function Color.isColor(self)
    convert(self, 'hsl')
    return clr.tuple[2] ~= 0 and -- sat   = not 0
           clr.tuple[3] ~= 0 and -- lum   = not 0
           clr.alpha ~= 0        -- alpha = not 0
end

-- Color SASS parameter access utility for templating.
-- @param frame Invocation frame.
-- @usage {{#invoke:colors|param|key}}
-- @raise 'invalid SASS parameter name supplied'
-- @return Color string aligning with parameter.
function c.wikia(frame)
    if frame.args and frame.args[1] then
        local key = mw.text.trim(frame.args[1])
        -- Assign custom parameter value.
        if c.params and c.params[key] then
            local val = c.params[key]
        -- Assign default parameter value.
        elseif sassParams[key] then
            local val = sassParams[key]
        end
        return val
    else
        error('invalid SASS parameter name supplied')
    end
end

-- Color parameter parser for inline styling.
-- @param frame Invocation frame.
-- @usage {{#invoke:colors|css|styling}}
-- @raise 'no styling supplied'
-- @return CSS styling with $parameters substituted from c.wikia.
function c.css(frame)
    -- Check if styling has been supplied
    if frame.args and frame.args[1] then
        local styles = mw.text.trim(frame.args[1])
        -- Substitution of colors
        local output = string.gsub(styles, '%$([%w-]+)', c.wikia)
        return c.parse(output)
    else
        error('no styling supplied')
    end
end

-- FANDOM color parameters.
-- @name c.params
-- @usage Direct access to SASS colors in Lua modules.
-- @todo use mw.site.sassParams when [[github:Wikia/app/pull/15301]] is merged
(function(p)
    -- Remove the unneeded parameters.
    local ext_params = {
        'oasisTypography',
        'widthType'
    }
    for k, c in ipairs(ext_params) do
        p[k] = null
    end
    -- Brightness conditionals for post-processing.
    local page_bright = c.parse('$color-page'):isBright()
    local page_bright_90 = c.parse('$color-page'):isBright(90)
    local buttons_bright = c.parse('$color-buttons'):isBright()
    -- Derived opacity values
    local pi_bg_o = (function()
        if page_bright then return 90 else return 85 end
    end)
    -- Derived colors and variables.
    local d = {
        ['page-opacity'] = tonumber(p['page-opacity'])/100,
        ['color-text'] = (function()
            if page_bright then return '#3a3a3a' else return '#d5d4d4' end
        end),
        ['color-contrast'] = (function()
            if page_bright then return '#000000' else return '#ffffff' end
        end),
        ['color-page-border'] = (function()
            if page_bright then
                return c.parse('$color-page'):lighten(-20):tostring()
            else
                return c.parse('$color-page'):lighten(20):tostring()
            end
        end),
        ['is-dark-wiki'] = (function()
            return not page_bright
        end),
        ['infobox-background'] =
            c.parse('$color-page'):mix('$color-links', pi_bg_o):tostring(),
        ['infobox-section-header-background'] =
            c.parse('$color-page'):mix('$color-links', 75):tostring(),
        ['color-button-highlight'] = (function()
            if buttons_bright then
                return c.parse('$color-buttons'):lighten(-20):tostring()
            else
                return c.parse('$color-buttons'):lighten(20):tostring()
            end
        end),
        ['color-button-text'] = (function()
            if buttons_bright then return '#000000' else return '#ffffff' end
        end),
        ['dropdown-background-color'] = (function()
            if page_bright_90 then
                return '#ffffff'
            elseif page_bright then
                return c.parse('$color-page'):mix('#fff', 90):tostring()
            else
                return c.parse('$color-page'):mix('#000', 90):tostring()
            end
        end),
        ['dropdown-menu-highlight'] = c.parse('$color-links'):alpha(10):tostring()
    }
    -- Concatenate derived and default SASS parameters.
    for k, c in ipairs(d) do p[k] = c end
    -- Expose parameters as Lua table
    c.params = p
end)(sassParams)

return c -- export

-- </nowiki>