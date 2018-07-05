return {
    name = 'colorsmw',
    version = '2.1.0',
    description = 'Scribunto library for FANDOM color processing, written in Lua.',
    homepage = 'https://github.com/speeditor/colorsmw',
    author = 'Speedit <speeditwikia@gmail.com>',
    license = 'CC-BY-SA 3.0',
    tags = {'mediawiki', 'fandom', 'lua', 'colors'},
    contributors = {
        'DarthKitty <https://dev.wikia.com/wiki/User:DarthKitty>'
    },
    dependencies = {
        ['Scribunto'] = 'https://github.com/wikimedia/mediawiki-extensions-Scribunto',
        ['UnitTests'] = 'https://dev.wikia.com/wiki/Module:UnitTests',
    },
    files = {
        '..lua',
        '..mediawiki',
        'README.md'
    }
}