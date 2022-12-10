fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'ac_gifts'
author 'ANTOND.#8507'
version '0.0.0'
description 'A simple script to create Christmas gifts for ox_inventory..'
repository 'https://github.com/acscripts/ac_gifts'

server_only 'yes'

server_scripts {
  'config.lua',
  'server/main.lua',
}

dependency 'ox_inventory'
