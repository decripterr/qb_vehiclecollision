fx_version 'cerulean'
game 'gta5'

author 'Decripterr'
description 'QBCore vehicle collision logger with rcore_tuning integration'
version '1.0.0'

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@qb-core/server/main.lua',
    'server/main.lua'
}
