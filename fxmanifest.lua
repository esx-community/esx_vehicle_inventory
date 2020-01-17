fx_version 'adamant'

game 'gta5'

description 'ESX truck inventory'

version '1.0.0'

server_scripts {
  '@async/async.lua',
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  'config.lua',
  'client/main.lua'
}
