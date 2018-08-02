-- Error message datastore.
-- To extend this, populate the following:
--[[ 
    ["lang"] = {
        ["unparse"]       = "",
        ["invalid-param"] = "",
        ["invalid-value"] = "",
        ["invalid-type"]  = "",
        ["no-color"]      = "",
        ["no-data"]       = "",
        ["no-styling"]    = "",
        ["out-of-bounds"] = ""
    }
]]--
-- @version             2.1.4
-- @submodule
return {
    ["en"] = {
        ["unparse"]       = "cannot parse \"$1\"",
        ["invalid-param"] = "invalid SASS parameter name supplied",
        ["invalid-value"] = "invalid color value input: $1 \"$2\"",
        ["invalid-type"]  = "invalid color type \"$1\" specified",
        ["no-color"]      = "no color supplied",
        ["no-data"]       = "no color data provided",
        ["no-style"]      = "no styling supplied",
        ["out-of-bounds"] = "color value \"$1\" out of \"$2\" bounds"
    }
}