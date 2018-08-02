-- Unit tests for colorsmw library.
-- @usage  Dependent on UnitTests Scribunto module.
--         https://dev.wikia.com/wiki/Global_Lua_Modules/UnitTests
-- @see    Unit test report:
--         https://dev.wikia.com/wiki/Module_talk:Colors/testcases
-- @submodule
return {
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
    },
    css = {
        options = {
            nowiki = true
        },
        tests = {
            preprocess_equals_many = {
                {
                    'background-color: $dropdown-menu-highlight; color: $color-links;',
                    'background-color: rgba(0, 155, 190, 0.1); color: #009bbe;'
                },
                {
                    'background-color: $infobox-background; clear: right; float: right; margin: 0 0 15px 15px; width: 270px;',
                    'background-color: #e6f5f9; clear: right; float: right; margin: 0 0 15px 15px; width: 270px;'
                },
                {
                    'background-color: $color-community-header; color: $color-community-header-text;',
                    'background-color: #404a57; color: #ffffff;'
                },
                {
                    'background-color: $infobox-background; border-color: $color-links; color: $color-text;',
                    'background-color: #e6f5f9; border-color: #009bbe; color: #3a3a3a;'
                }
            }
        }
    },
    text = {
        options = {
            nowiki = true
        },
        tests = {
            preprocess_equals_many = {
                { 'blue', '#000000' },
                { 'rgb(58, 58, 58)', '#ffffff' },
                { '$color-community-header', '#ffffff' },
                { '$color-community-header|#0f0f0f|#f0f0f0', '#f0f0f0' },
                { 'yellow|lum=true', '#000000' },
            }
        }
    }
}