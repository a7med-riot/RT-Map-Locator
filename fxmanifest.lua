-- =============================================================
--  prmap | fxmanifest.lua
-- =============================================================

fx_version 'cerulean'
game      'gta5'

name        'prmap'
description 'Postal-code map locator — QBCore & OX compatible'
version     '2.0.0'
author      'prmap'

-- Optional framework dependencies (script runs without them in standalone mode)
-- dependency 'qb-core'
-- dependency 'ox_core'
-- dependency 'ox_lib'
-- dependency 'qb-input'

-- Config must load first, then locale, then client
shared_scripts {
    'config.lua',
}

client_scripts {
    'locales/en.lua',   -- default locale; swap to 'locales/ar.lua' for Arabic
    'client.lua',
}

-- JSON data file shipped with the resource
files {
    'postals.json',
}

lua54 'yes'
