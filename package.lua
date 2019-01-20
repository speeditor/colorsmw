return {
    name = 'colorsmw',
    version = '2.5.0',
    description = 'Scribunto library for FANDOM color processing, written in Lua.',
    homepage = 'https://github.com/speeditor/colorsmw',
    author = 'Speedit <speeditwikia@gmail.com>',
    license = 'CC-BY-SA 3.0',
    tags = {'mediawiki', 'fandom', 'lua', 'colors'},
    contributors = {
        -- code contributors
        'DarthKitty <https://dev.wikia.com/wiki/User:DarthKitty>',
        'Technobliterator <https://dev.wikia.com/wiki/User:Technobliterator>',
        -- translations
        'Tokina8937 <https://dev.wikia.com/wiki/User:Tokina8937>',
        'Laclale <https://dev.wikia.com/wiki/User:Laclale>',
        'Mix Gerder <https://dev.wikia.com/wiki/User:DarthKitty>',
        'Quentum <https://dev.wikia.com/wiki/User:Quentum>'
    },
    dependencies = {
        ['Scribunto']   = 'https://github.com/wikimedia/mediawiki-extensions-Scribunto',
        ['Testharness'] = 'https://dev.wikia.com/index.php?title=Module:Testharness&action=raw',
        ['I18n']        = 'https://dev.wikia.com/index.php?title=Module:I18n&action=raw'
    },
    files = {
        '..lua',
        '..mediawiki',
        'README.md'
    }
}
