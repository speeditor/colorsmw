-- Unit tests for colorsmw library.
-- @usage  Dependent on UnitTests Scribunto module.
--         https://dev.wikia.com/wiki/Global_Lua_Modules/UnitTests
-- @see    Unit test report:
--         https://dev.wikia.com/wiki/Module_talk:Colors/testcases
-- @submodule
return {
    fromRgb = {
        options = {
            mode = 'method',
            deep = true,
            unpk = true
        },
        tests = {
            {
                {  64,  74,  87 },
                { tup = {  64,  74,  87 }, typ = 'rgb', alp = 1 }
            },
            {
                {   0, 155, 190, 0.1 },
                { tup = {   0, 155, 190 }, typ = 'rgb', alp = 0.1 }
            }
        }
    },
    fromHsl = {
        options = {
            mode = 'method',
            deep = true,
            unpk = true
        },
        tests = {
            {
                { 214, 0.15, 0.3 },
                { tup = { 214, 0.15, 0.3 }, typ = 'hsl', alp = 1 }
            },
            {
                { 191, 1, 0.37, 0.1 },
                { tup = { 191,   1, 0.37 }, typ = 'hsl', alp = 0.1 }
            }
        }
    },
    instance = {
        options = {
            mode = 'method'
        },
        tests = {
            {
                require('Dev:Colors').parse('#404a57'),
                true
            },
            {
                require('Dev:Colors').parse('hsl(214, 15%, 30%)'),
                true
            },
            {
                'hsl(214, 15%, 30%)',
                false
            },
            {
                '#404a57',
                false
            }
        }
    },
    wikia = {
        options = {
            mode = 'invocation',
            nowiki = true
        },
        tests = {
            {
                nil, 'invalid SASS parameter name supplied', {['err'] = true}
            },
            { 'color-button-text', '#ffffff' },
            { 'dropdown-background-color', '#ffffff' },
            { 'dropdown-menu-highlight', 'rgba(0, 155, 190, 0.1)' }
        }
    },
    css = {
        options = {
            mode = 'invocation',
            nowiki = true
        },
        tests = {
            {
                nil,
                'no styling supplied',
                { ['err'] = true }
            },
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
    },
    text = {
        options = {
            mode = 'invocation',
            nowiki = true
        },
        tests = {
            { nil, 'no color supplied', { ['err'] = true } },
            { 'blue', '#000000' },
            { 'rgb(58, 58, 58)', '#ffffff' },
            { '$color-community-header', '#ffffff' },
            { '$color-community-header|#0f0f0f|#f0f0f0', '#f0f0f0' },
            { 'yellow|lum=true', '#000000' },
        }
    },
    variables = {
        options = {
            mode = 'invocation',
            nowiki = true
        },
        tests = {
            { nil, ':root { --background-image: ""; --background-image-height: 168px; --background-image-width: 271px; --color-body: #f6f6f6; --color-body-middle: #bacdd8; --color-button-highlight: #666e79; --color-button-text: #ffffff; --color-buttons: #404a57; --color-community-header: #404a57; --color-community-header-text: #ffffff; --color-contrast: #000000; --color-header: #404a57; --color-links: #009bbe; --color-page: #ffffff; --color-page-border: #cccccc; --color-text: #3a3a3a; --dropdown-background-color: #ffffff; --dropdown-menu-highlight: rgba(0, 155, 190, 0.1); --infobox-background: #e6f5f9; --infobox-section-header-background: #bfe6ef; --wordmark-font: cpmono; }' },
            { 's = 4', ':root {\n    --background-image: "";\n    --background-image-height: 168px;\n    --background-image-width: 271px;\n    --color-body: #f6f6f6;\n    --color-body-middle: #bacdd8;\n    --color-button-highlight: #666e79;\n    --color-button-text: #ffffff;\n    --color-buttons: #404a57;\n    --color-community-header: #404a57;\n    --color-community-header-text: #ffffff;\n    --color-contrast: #000000;\n    --color-header: #404a57;\n    --color-links: #009bbe;\n    --color-page: #ffffff;\n    --color-page-border: #cccccc;\n    --color-text: #3a3a3a;\n    --dropdown-background-color: #ffffff;\n    --dropdown-menu-highlight: rgba(0, 155, 190, 0.1);\n    --infobox-background: #e6f5f9;\n    --infobox-section-header-background: #bfe6ef;\n    --wordmark-font: cpmono;\n}' }
        }
    },
    main = {
        options = {
            mode = 'invocation',
            nowiki = true
        },
        tests = {
            { nil, 'you must specify a function to call', { ['err'] = true } },
        }
    }
}
