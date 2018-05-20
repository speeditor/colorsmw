-- Unit tests for colorsmw library.
-- @module t
-- @usage  Dependent on UnitTests Scribunto module.
--         https://dev.wikia.com/wiki/Global_Lua_Modules/UnitTests
-- @see    Results stored at:
--         https://dev.wikia.com/wiki/Module_talk:Colors/testcases
local t = {
    wikia = {
        options = {
            nowiki = false
        },
        tests = {
            preprocess_equals_many = {
                { 'page-opacity', '1' },
                { 'color-button-text', '#ffffff' },
            },
        },
    },
    css = {
        options = {
            nowiki = false
        },
        tests = {
            preprocess_equals_many = {
                { 'background: $color-community-header', 'background: #404a57' },
                { 'border: 1px solid $color-page-border', 'border: 1px solid #cccccc' }
            },
        },
    },
}
 
return t