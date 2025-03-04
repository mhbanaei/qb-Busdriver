fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'mhbanaei'
description 'It allows player to drive as the bus driver and it does have the multi-terminal on it '
version '1.2.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua'
}

server_script 'server/main.lua'
