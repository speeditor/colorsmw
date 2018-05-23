-- Unit tests for colorsmw library.
-- @module t
-- @usage  Dependent on UnitTests Scribunto module.
--         https://dev.wikia.com/wiki/Global_Lua_Modules/UnitTests
-- @see    Unit test report:
--         https://dev.wikia.com/wiki/Module_talk:Colors/testcases
local t = {
    css = {
        options = {
            nowiki = true
        },
        tests = {
            preprocess_equals_many = {
                {
                    'background: $infobox-background; clear: right; float: right; margin: 0 0 15px 15px; width: 270px;',
                    'background: #e6f5f8; clear: right; float: right; margin: 0 0 15px 15px; width: 270px;'
                },
                {
                    'background-color: $color-community-header; color: $color-community-header-text;',
                    'background-color: #404a57; color: #ffffff;'
                },
                {
                    'background-color: $infobox-background; border-color: $color-links; color: $color-text;',
                    'background-color: #e6f5f8; border-color: #009bbe; color: #3a3a3a;'
                }
            }
        }
    },
    wikia = {
        options = {
            nowiki = true
        },
        tests = {
            preprocess_equals_many = {
                { 'page-opacity', '1' },
                { 'color-button-text', '#ffffff' },
                { 'dropdown-background-color', '#ffffff' },
                { 'dropdown-menu-highlight', 'rgba(0, 155, 190, 0.1)' }
            }
        }
    }
}
return t