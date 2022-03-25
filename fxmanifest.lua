fx_version 'cerulean'
games { 'gta5' }

author 'Marco H. <marco@marco1223.de>'
description 'FiveM Custom Framework'
version '1.0.0 Alpha'

shared_scripts {
    'locale.lua',
    'locales/*.lua'
}

client_scripts {
    'configs/ClientConfig.lua',
    'locale.lua',
    'locales/*.lua',
    'client/client.lua',
    'client/plugins/*.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'configs/ClientConfig.lua',
    'locale.lua',
    'locales/*.lua',
    'server/server.lua',
    'server/plugins/*.lua'
}

files {
    'locale.js'
}