-- Colors library for embedded color processing on FANDOM.
-- Supports HSL, RGB and hexadecimal web colors.
-- @module              c
-- @version             2.5.0
-- @usage               require("Dev:Colors")
-- @author              Speedit
-- @release             stable; unit tests passed
-- <nowiki>

-- Module package.
local c = {}

-- Module utilites, configuration/cache variables.
-- @section             colordat

-- Site SASS styling parameter cache.
local sassParams = mw.site.sassParams or {
    ['background-dynamic']      = 'false',
    ['background-image']        = '',
    ['background-image-height'] = '0',
    ['background-image-width']  = '0',
    ['color-body']              = '#f6f6f6',
    ['color-body-middle']       = '#f6f6f6',
    ['color-buttons']           = '#a7d7f9',
    ['color-community-header']  = '#f6f6f6',
    ['color-header']            = '#f6f6f6',
    ['color-links']             = '#0b0080',
    ['color-page']              = '#ffffff',
}

-- Web color RGB presets.
local presets = mw.loadData('Dev:Colors/presets')

-- Error message data.
local i18n = require('Dev:I18n').loadMessages('Colors')

-- Validation ranges for color types and number formats.
local ranges = {
    rgb         = {    0, 255 },
    hsl         = {    0,   1 },
    hue         = {    0, 360 },
    percentage  = { -100, 100 },
    prop        = {    0, 100 },
    degree      = { -360, 360 }
}

-- Module registry for use in loops.
local registry = {
    spaces = { 'rgb', 'hsl' },
    ops    = { 'rotate', 'saturate', 'lighten' },
    props  = { 'red', 'green', 'blue', 'hue', 'sat', 'lum' },
}

-- Color item class.
-- @type                Color
local Color = { tup = {}, typ = 'color', alp = 1 }

-- Color instance constructor.
-- @function          Color:new
-- @param             {string} typ Color space type ('hsl' or 'rgb').
-- @param             {table} tup Color tuple in HSL or RGB
-- @param             {number} alp Alpha value range 0-1
-- @raise             'no color data provided'
-- @raise             'no valid color type'
-- @return            {table} Color instance.
function Color.new(self, tup, typ, alp)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    -- Validate color data tuple.
    if type(tup) ~= 'table' or #tup ~= 3 then
        error(i18n:msg('no-data'))
    end
    -- Validate color type.
    local typdir = { rgb = 1, hsl = 1 }
    if type(typdir[typ]) == 'nil' then
        error(i18n:msg('invalid-type', typ))
    end
    -- Validate color tuple numbers.
    for n = 1, 3 do
        check( (n == 1 and typ == 'hsl') and 'hue' or typ, tup[n])
    end
    check('hsl', alp)
    -- Initialise properties.
    o.tup = tup
    o.typ = typ
    o.alp = alp
    return o -- output
end

-- Color hexadecimal string output.
-- @name                Color:hex
-- @return              {string} Hexadecimal color string.
function Color.hex(self)
    -- RGB conversion, variables.
    local this = clone(self, 'rgb')
    local hex = '#'
    -- Hex string concatenation.
    for i, t in ipairs(this.tup) do
        -- Hexadecimal conversion.
        hex = #mw.ustring.format('%x', t) == 1 -- leftpad
            and hex .. '0' .. mw.ustring.format('%x', t)
            or hex .. mw.ustring.format('%x', t)
    end
    -- Alpha channel addition.
    local alp = string.format('%x', this.alp*255)
    if alp ~= 'ff' then
        hex = #alp == 1 and hex .. '0' .. alp or hex .. alp
    end
    return hex -- output
end

-- Color string default output.
-- @name                Color:string
-- @return              {string} Hexadecimal 6-digit or HSLA color string.
function Color.string(self)
    return self.alp ~= 1 and self:hsl() or self:hex()
end

-- Color space string output.
for i, t in ipairs(registry.spaces) do
    -- @name Color:rgb
    -- @return RGB color string.
    -- @name Color:hsl
    -- @return HSL color string.
    Color[t] = function(self)
        -- Convert tuple.
        local this = clone(self, t)
        if t == 'hsl' then
            for i, t in ipairs(this.tup) do
                if ({[2]=1, [3]=1})[i] then
                    this.tup[i] = tostring(t*100) .. '%'
                end
            end
        end
        return this.alp ~= 1
            and t .. 'a(' .. table.concat(this.tup, ', ') .. ', ' .. this.alp .. ')'
            or t .. '(' .. table.concat(this.tup, ', ') .. ')'
    end
end

-- Color property getter-setter.
for i, p in ipairs(registry.props) do
    -- @name        Color:red
    -- @param       {number} val Red value to set.         1 - 255
    -- @name        Color:green
    -- @param       {number} val Green value to set.       1 - 255
    -- @name        Color:blue
    -- @param       {number} val Blue value to set.        1 - 255
    -- @name        Color:hue
    -- @param       {number} val Hue value to set.         0 - 360
    -- @name        Color:sat
    -- @param       {number} val Saturation value to set.  0 - 100
    -- @name        Color:lum
    -- @param       {number} val Luminosity value to set.  0 - 100
    -- @return      {table} Color instance.
    Color[p] = function(self, val)
        -- Property settings.
        local n = 1 + (i - 1) % 3
        local typ = i < 4 and 'rgb' or 'hsl'
        local chk = i == 4 and 'hue' or typ
        -- Setter-getter.
        local this = clone(self, typ)
        if val then
            -- Value processing.
            if typ == 'hsl' and n > 1 then
                val = val / 100
            end
            check(chk, val)
            -- Property setter.
            this.tup[n] = val
            return this -- chainable
        else
            -- Property getter.
            return this.tup[n]
        end
    end
end

-- Alpha getter-setter for color compositing.
-- @name                Color:alpha
-- @param               {number} mod Modifier 0 - 100
-- @return              {table} Color instance.
function Color.alpha(self, val)
    if val then
        check('prop', val)
        self.alp = val / 100
        return self
    else
        return self.alp
    end
end

-- Post-processing operators for web color properties.
for i, o in ipairs(registry.ops) do
    -- @name        Color:rotate
    -- @param       {number} mod Modifier -360 - 360
    -- @name        Color:saturate
    -- @param       {number} mod Modifier -100 - 100
    -- @name        Color:lighten
    -- @param       {number} mod Modifier -100 - 100
    -- @return      {table} Color instance.
    Color[o] = function(self, mod)
        -- Operator settings.
        local div = o == 'rotate' and 1 or 100
        local chk = o == 'rotate' and 'degree' or 'percentage'
        local cap = o == 'rotate' and circle or limit
        local max = o == 'rotate' and 360 or 1
        -- Color rotation.
        check(chk, mod)
        local this = clone(self, 'hsl')
        this.tup[i] = cap(this.tup[i] + (mod / div), max)
        return this
    end
end

-- Opacification utility for color compositing.
-- @name                Color:opacify
-- @param               {number} mod Modifier -100 - 100 (100 by default)
-- @return              {table} Color instance.
function Color.opacify(self, mod)
    check('percentage', mod)
    self.alp = limit(self.alp + (mod / 100), 1)
    return self
end

-- Color additive mixing utility.
-- @name                Color:mix
-- @param               {string|table} other Module-compatible color string or instance.
-- @param               {number} weight Color weight of original (0 - 100).
-- @return              {table} Color instance.
function Color.mix(self, other, weight)
    -- Conversion for strings.
    if not c.instance(other) then
        other = c.parse(other)
        convert(other, 'rgb')
    else
        other = clone(other, 'rgb')
    end
    -- Mix weight, variables.
    weight = weight or 50
    check('prop', weight)
    weight = weight/100
    local this = clone(self, 'rgb')
    -- Mixing logic.
    for i, t in ipairs(this.tup) do
        this.tup[i] = t * weight + other.tup[i] * (1 - weight)
        this.tup[i] = limit(this.tup[i], 255)
    end
    return this -- output
end

-- Color inversion utility.
-- name                 Color:invert
-- @return              {table} Color instance.
function Color.invert(self)
    local this = clone(self, 'rgb')
    -- Calculate 8-bit inverse of RGB tuple.
    for i, t in ipairs(this.tup) do
        this.tup[i] = 255 - t
    end
    return this -- output
end

-- Complementary color utility.
-- @name                Color:complement
-- @return              {table} Color instance.
function Color.complement(self)
    return self:rotate(180)
end

-- Color brightness testing.
-- @name                Color:bright
-- @param               {number} lim Luminosity threshold (50 default).
-- @return              {bool} Boolean for tone beyond threshold.
function Color.bright(self, lim)
    lim = lim and tonumber(lim)/100 or 0.5
    local this = clone(self, 'hsl')
    return this.tup[3] >= lim
end

-- Color luminance testing.
-- @name                Color:luminant
-- @param               {number} lim Luminance threshold (50 default).
-- @return              {bool} Boolean for luminance beyond threshold.
-- @see                 [[wikipedia:Relative luminance]]
function Color.luminant(self, lim)
    -- Function arguments.
    lim = lim and tonumber(lim)/100 or 0.5
    check('hsl', lim)
    -- Derived variables.
    local hsl = clone(self, 'hsl')
    local sat = hsl.tup[2]
    local lum = hsl.tup[3]
    local rgb = clone(self, 'rgb').tup
    -- Compute linear RGB tuple.
    for i, t in ipairs(rgb) do
        rgb[i] = t > 0.4045 and
            math.pow(((t + 0.05) / 1.055), 2.4) or
            t / 12.92
    end
    -- Relative colorimetric luminance.
    local rel =
        rgb[1] * 0.2126 +
        rgb[2] * 0.7152 +
        rgb[3] * 0.0722
    -- WCAG luminance contribution.
    local quo = sat * (0.2038 * (rel - 0.5) / 0.5)
    -- Return luma-lumi comparison.
    return (lum >= (lim - quo))
end

-- Color status testing.
-- @name                Color:chromatic
-- @return              {bool} Boolean for color status.
function Color.chromatic(self)
    local this = clone(self, 'hsl')
    return this.tup[2] ~= 0 and -- sat   = not 0
           this.tup[3] ~= 0 and -- lum   = not 0
           this.alp ~= 0        -- alpha = not 0
end

-- Internal color utilities.
-- @section             colorutils

-- Boundary validation for color types.
-- @param               {string} t Range type.
-- @param               {number} n Number to validate.
-- @raise               'color value $n invalid or out of $t bounds'
-- @return              {bool} Validity of number.
function check(t, n)
    local min = ranges[t][1] -- Boundary variables
    local max = ranges[t][2]
    -- Boundary comparison.
    if type(n) ~= 'number' then
        error(i18n:msg('invalid-value', type(n), tostring(n)))
    elseif n < min or n > max then
        error(i18n:msg('out-of-bounds', n, t))
    end
end

-- Rounding utility for color tuples.
-- @param               {number} tup Color tuple.
-- @param               {number} dec Number of decimal places.
-- @return              {number} Rounded tuple value.
function round(tup, dec)
    local ord = 10^(dec or 0)
    return math.floor(tup * ord + 0.5) / ord
end

-- Cloning utility for color items.
-- @param               {table} clr Color instance.
-- @param               {string} typ Color type of clone.
-- @return              {table} New (clone) color instance.
function clone(clr, typ)
    local c = Color:new( clr.tup, clr.typ, clr.alp ) -- new color
    convert(c, typ) -- conversion
    return c -- output
end

-- Range limiter for color processing.
-- @param               {number} val Numeric value to limit.
-- @param               {number} max Maximum value for limit boundary.
-- @return              {number} Limited value.
function limit(val, max)
    return math.max(0, math.min(val, max))
end

-- Circular spatial processing for ranges.
-- @param               {number} val Numeric value to cycle.
-- @param               {number} max Maximum value for cycle boundary.
-- @return              {number} Cyclical positive value below max.
function circle(val, max)
    if val < 0 then        -- negative; below cycle minimum
        val = val + max
    elseif val > max then -- exceeds cycle maximum
        val = val - max
    end
    return val -- output
end

-- Color space converter.
-- @param               {table} clr Color instance.
-- @param               {string} typ Color type to output.
-- @return              {table} Converted color instance.
function convert(clr, typ)
    if clr.typ ~= typ then
        clr.typ   = typ
        if typ == 'rgb' then
            clr.tup = hslToRgb(clr.tup)
        else
            clr.tup = rgbToHsl(clr.tup)
        end
    end
    for i, t in ipairs(clr.tup) do
        if clr.typ == 'rgb' then
            clr.tup[i] = round(clr.tup[i], 0)
        elseif clr.typ == 'hsl' then
            clr.tup[i] = i == 1
                and round(clr.tup[i], 0)
                or  round(clr.tup[i], 2)
        end
    end
end

-- RGB-HSL tuple converter.
-- @param               {table} rgb Tuple table of RGB values.
-- @return              {table} Tuple table of HSL values.
-- @see                 http://www.easyrgb.com/en/math.php#m_rgb_hsl
function rgbToHsl(rgb)
    -- Preprocessing RGB values.
    for i, t in ipairs(rgb) do
        rgb[i] = t/255
    end
    local r,g,b = rgb[1], rgb[2], rgb[3]
    -- Range variables for calculation.
    local min = math.min(r, g, b)
    local max = math.max(r, g, b)
    local d = max - min
    -- Default values for achromatic colors.
    local h, s, l = 0, 0, ((min + max) / 2)
    -- Calculation for chromatic colors.
    if d > 0 then
        -- Compute saturation.
        s = l < 0.5 and d / (max + min) or d / (2 - max - min)
        -- Compute hue.
        h = max == r and (g - b) / d or
            max == g and 2 + (b - r)/d or
            max == b and 4 + (r - g)/d
        h = circle(h/6, 1)
    end
    -- Output tuple.
    return { h * 360, s, l }
end

-- HSL component conversion subroutine to RGB.
-- @param               {number} p Temporary variable 1.
-- @param               {number} q Temporary variable 2.
-- @param               {number} t Modifier for primary color.
-- @return              {number} HSL component.
-- @see                 http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
function hueToRgb(p, q, t)
    -- Normalise color modifier.
    if t < 0 then
        t = t + 1
    elseif t > 1 then
        t = t - 1
    end
    -- Compute RGB component.
    if t < 1/6 then
        return p + (q - p) * 6 * t
    elseif t < 1/2 then
        return q
    elseif t < 2/3 then
        return p + (q - p) * (2/3 - t) * 6
    else
        return p
    end
end

-- HSL-RGB tuple converter.
-- @param               {table} hsl Tuple table of HSL values.
-- @return              {table} Tuple table of RGB values.
function hslToRgb(hsl)
    local h, s, l = hsl[1]/360, hsl[2], hsl[3]
    local r
    local g
    local b
    local p
    local q
    -- Achromatic handling.
    if s == 0 then
        r,g,b = l,l,l
    -- RGB conversion.
    else
        -- Assign first temporary variable.
        q = l < 0.5 and l * (1 + s) or l + s - l * s
        -- Derive second temporary variable.
        p = 2 * l - q
        -- Use subroutine for RGB color values.
        r = hueToRgb(p, q, h + 1/3)
        g = hueToRgb(p, q, h)
        b = hueToRgb(p, q, h - 1/3)
    end
    -- Conversion to 8-bit values.
    return { r * 255, g * 255, b * 255 }
end

-- Package methods and members.
-- @section             colorexp

-- Creation of RGB color instances.
-- @param               {number} r red   1-255
-- @param               {number} g green 1-255
-- @param               {number} b blue  1-255
-- @param               {number} a alpha 0-1
-- @see                 Color:newco
-- @return              {table} Color instance.
function c.fromRgb(r, g, b, a)
    return Color:new({ r, g, b }, 'rgb', a or 1);
end

-- Creation of HSL color instances.
-- @param               {number} h Hue value.        0-360
-- @param               {number} s Saturation value. 0-1
-- @param               {number} l Luminance value.  0-1
-- @param               {number} a Alpha channel.    0-1
-- @see                 Color:new
-- @return              {table} Color instance.
function c.fromHsl(h, s, l, a)
    return Color:new({ h, s, l }, 'hsl', a or 1);
end

-- Parsing logic for color strings.
-- @param               {string} str Valid color string.
-- @raise               'cannot parse $str'
-- @see                 Color:new
-- @return              {table} Color instance.
function c.parse(str)
    local typ
    local tup = {}
    local alp = 1
    str, _ = mw.ustring.gsub(str, '%s', '')
    -- Variable substitution.
    if c.params and c.params[mw.ustring.match(str, '^%$([%w-]+)$') or ''] then
        str = c.params[mw.ustring.match(str, '^%$([%w-]+)$')]
    elseif sassParams[mw.ustring.match(str, '^%$([%w-]+)$') or ''] then
        str = sassParams[mw.ustring.match(str, '^%$([%w-]+)$')]
    end
    -- Subroutine for RGB/HSL color data extraction.
    function extract(str)
        for t in mw.ustring.gmatch(str, '([^,]+)') do
            local tp = mw.ustring.find(t, '%%') and
                tonumber(mw.ustring.match(t, '[^%%]+'))/100 or
                t
            if #tup == 3 then
                alp = tonumber(tp)
            else
                tup[#tup+1] = tonumber(tp)
            end
        end
    end
    -- Parsing patterns for hex format.
    if mw.ustring.match(str, '^%#[%x]+$') and ({
        [4] = 1, [5] = 1, -- #xxxx?
        [7] = 1, [9] = 1  -- #xxxxxxx?x?
    })[#str] then
        -- Hex color data extraction.
        if #str == 4 then
            tup[1], tup[2], tup[3] = mw.ustring.match(str, '^%#(%x)(%x)(%x)$')
        elseif #str == 5 then
            tup[1], tup[2], tup[3], alp = mw.ustring.match(str, '^%#(%x)(%x)(%x)(%x)$')
            alp = alp .. alp
        elseif #str == 7 then
            tup[1], tup[2], tup[3] = mw.ustring.match(str, '^%#(%x%x)(%x%x)(%x%x)$')
            alp = 1
        elseif #str == 9 then
            tup[1], tup[2], tup[3], alp = mw.ustring.match(str, '^%#(%x%x)(%x%x)(%x%x)(%x%x)$')
        end
        -- RGB conversion from hex format.
        for i, t in ipairs(tup) do
            tup[i] = tonumber(#t == 2 and t or t .. t, 16)
        end
        if #str == 5 or #str == 9 then
            alp = tonumber(alp, 16)
        end
        typ = 'rgb'
    -- Parsing patterns for RGB format.
    elseif mw.ustring.match(str, 'rgba?%([%d,.%%]+%)') then
        extract(mw.ustring.match(str, '^rgba?%(([0-9.,%%]+)%)$'))
        typ = 'rgb'
    -- Parsing patterns for HSL format.
    elseif mw.ustring.match(str, 'hsla?%([%d,.%%]+%)') then
        extract(mw.ustring.match(str, '^hsla?%(([0-9.,%%]+)%)$'))
        typ = 'hsl'
    -- Conversion of web color names to RGB.
    elseif presets[str] then
        local p = presets[str]
        tup = { p[1], p[2], p[3] }
        typ = 'rgb'
    -- Support for 'transparent'.
    elseif str == 'transparent' then
        tup = {    0,    0,    0 }
        typ = 'rgb'
        alp = 0
    -- Error if string format is invalid.
    else error(i18n:msg('unparse', (str or ''))) end
    -- Pass data to color constructor.
    return Color:new(tup, typ, alp)
end

-- Instance test function for colors.
-- @param               {table|string} item Color item or string.
-- @return              {bool} Whether the color item was instantiated.
function c.instance(item)
    -- Prototype to compare.
    local i = getmetatable(item)
    -- Test if item has a prototype.
    return i and i.typ == 'color' or false
end

-- Color SASS parameter access utility for templating.
-- @param               {table} frame Frame invocation object.
-- @usage               {{#invoke:colors|wikia|key}}
-- @raise               'invalid SASS parameter name supplied'
-- @return              {string} Color string aligning with parameter.
function c.wikia(frame)
    -- Check if parameter name was supplied.
    if not frame or not frame.args[1] then
        error(i18n:msg('invalid-param'))
    end
    -- Frame arguments.
    local key = mw.text.trim(frame.args[1])
    local val =
        -- Assign custom parameter value.
        c.params and c.params[key] and
            c.params[key]
        -- Assign default parameter value.
        or  sassParams[key] and
            sassParams[key]
        or '<Dev:Colors: ' .. i18n:msg('invalid-param') .. '>'
    return mw.text.trim(val)
end

-- Color parameter parser for inline styling.
-- @param               {table} frame Frame invocation object.
-- @param               {string} frame.args[1]
-- @usage               {{#invoke:colors|css|styling}}
-- @raise               'no styling supplied'
-- @return              {string} CSS styling with $parameters from c.params.
function c.css(frame)
    -- Check if styling has been supplied.
    if not frame.args[1] then
        error(i18n:msg('no-style'))
    end
    -- Extract styling from frame.
    local styles = mw.text.trim(frame.args[1])
    -- Substitution of colors.
    local o, _ = mw.ustring.gsub(styles, '%$([%w-]+)', c.params)
    -- Output parsed styling.
    return o
end

-- Color generator for high-contrast text.
-- @param               {table} frame Frame invocation object.
-- @param               {string} frame.args[1] Color to process.
-- @param               {string} frame.args[2] Dark color to return.
-- @param               {string} frame.args[3] Light color to return.
-- @param               {string} frame.args.lum Whether luminance is used.
-- @usage               {{#invoke:colors|text|bg|dark color|light color}}
-- @raise               'no color supplied'
-- @return              {string} Color string '#000000'/$2 or '#ffffff'/$3.
function c.text(frame)
    -- Check if a color has been supplied.
    if not frame or not frame.args[1] then
        error(i18n:msg('no-color'))
    end
    -- Frame arguments.
    local str = mw.text.trim(frame.args[1])
    local clr = {
        (mw.text.trim(frame.args[2] or '#000000')),
        (mw.text.trim(frame.args[3] or '#ffffff')),
    }
    -- Brightness conditional.
    local b = type(({
                ['1']    = 1,
                ['true'] = 1
            })[frame.args.lum or '']) ~= 'nil'
        and c.parse(str):luminant()
        or  c.parse(str):bright()
    return b and clr[1] or clr[2]
end

-- CSS variables stylesheet generator.
-- @param               {table} frame Frame invocation object.
-- @param               {table} frame.args.s Optional number of spaces.
function c.variables(frame)
    local s = frame.args.s
    local m = s ~= nil
    local n = tonumber(s)

    local sep = (m and n) and '\n' or ' '
    local ind = (m and n) and string.rep(' ', n) or ''
    local prm = c.params

    local ret = {}

    local sortkeys = {}
    for k, p in pairs(prm) do
        table.insert(sortkeys, k)
    end
    table.sort(sortkeys)

    table.insert(ret, ':root {')
    for i, k in ipairs(sortkeys) do
        local val = prm[k]
        if
            tostring(val) ~= 'false' and
            tostring(val) ~= 'true'
        then
            if tonumber(val) ~= nil then
                val = tostring(val) .. 'px'
            elseif #mw.text.trim(val) == 0 then
                val = '""'
            end

            local prop = table.concat({
                ind,
                '--', k, ': ',
                val, ';'
            })
            table.insert(ret, prop)
        end
    end
    table.insert(ret, '}')

    return table.concat(ret, sep)
end

-- Template wrapper for [[Template:Colors]].
-- @param               {table} frame Frame invocation object.
-- @usage               {{#invoke:colors|main}}
function c.main(frame)
    -- Extract arguments.
    local parentFrame = frame:getParent()
    local templateArgs = {}
    for p, v in pairs(parentFrame.args) do
        templateArgs[p] = v
    end
    -- Extract function name as first argument.
    local fn = templateArgs[1] and table.remove(templateArgs, 1)
    -- Check for function argument.
    if fn == nil then
        error((mw.ustring.gsub(mw.ustring.match(mw.message.new('scribunto-common-nofunction'):plain(), ':%s(.*)%p$'), '^.', mw.ustring.lower)))
    end
    -- Check function exists.
    if c[fn] == nil then
        error((mw.ustring.gsub(mw.ustring.match(mw.message.new('scribunto-common-nosuchfunction'):plain(), ':%s(.*)%p$'), '^.', mw.ustring.lower)))
    end
    -- Execute function if it does.
    parentFrame.args = templateArgs
    return c[fn](parentFrame)
end

-- FANDOM color parameters (common SASS colors).
-- @name                c.params
-- @usage               colors.params['key']
c.params = (function(p)
    -- Remove the unneeded parameters.
    local ext_params = {
        'oasisTypography',
        'widthType',
        'page-opacity'
    }
    for k, c in ipairs(ext_params) do p[c] = nil end
    -- Brightness conditionals for post-processing.
    local page_bright = c.parse('$color-page'):bright()
    local page_bright_90 = c.parse('$color-page'):bright(90)
    local header_bright = c.parse('$color-community-header'):bright()
    local buttons_bright = c.parse('$color-buttons'):bright()
    -- Derived opacity values.
    local pi_bg_o = page_bright and 90 or 85
    -- Derived colors and variables.
    --- Main derived parameters.
    p['color-text'] = page_bright and '#3a3a3a' or '#d5d4d4'
    p['color-contrast'] = page_bright and '#000000' or '#ffffff'
    p['color-page-border'] = page_bright
        and c.parse('$color-page'):mix('#000', 80):string()
        or  c.parse('$color-page'):mix('#fff', 80):string()
    p['color-button-highlight'] = buttons_bright
            and c.parse('$color-buttons'):mix('#000', 80):string()
            or  c.parse('$color-buttons'):mix('#fff', 80):string()
    p['color-button-text'] = buttons_bright and '#000000' or '#ffffff'
    --- PortableInfobox color parameters.
    p['infobox-background'] =
        c.parse('$color-page'):mix('$color-links', pi_bg_o):string()
    p['infobox-section-header-background'] =
        c.parse('$color-page'):mix('$color-links', 75):string()
    --- CommunityHeader color parameters.
    p['color-community-header-text'] = header_bright
        and '#000000'
        or  '#ffffff'
    p['dropdown-background-color'] = (function(p)
        if page_bright_90 then
            return '#ffffff'
        elseif page_bright then
            return p:mix('#fff', 90):string()
        else
            return p:mix('#000', 90):string()
        end
    end)(c.parse('$color-page'))
    p['dropdown-menu-highlight'] = c.parse('$color-links'):alpha(10):rgb()
    --- Custom SASS parameters.
    p['is-dark-wiki'] = not page_bright
    -- Export SASS parameter table.
    return p
end)(sassParams)

-- Module export.
return c

-- </nowiki>
