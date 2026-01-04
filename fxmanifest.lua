fx_version 'cerulean'
game 'gta5'

author 'RP-Alpha'
description 'RP-Alpha Housing System'
version '1.0.0'

dependencies {
    'rpa-lib',
    'oxmysql'
}

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

-- Server exports
server_exports {
    'IsHouseOwned',
    'DoesPlayerOwnHouse',
    'GetPlayerHouses'
}

lua54 'yes'
