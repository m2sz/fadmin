--shared_script '@bonbondefurius/shared_fg-obfuscated.lua'
--shared_script '@bonbondefurius/ai_module_fg-obfuscated.lua'
fx_version "adamant"
games {"gta5"}
lua54 'yes'
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config/esx-server.lua',
}
client_scripts {
    'config/esx-client.lua',
    "RageUI/RMenu.lua",
}
shared_scripts {
    -- Configs files
    'config/permissions.lua',
    'config/config.lua',
    'config/logs.lua',
    'config/shared_functions.lua',
    'code/helper.lua',
}
client_scripts {
    -- Clients files
    'code/cl_callback.lua',
    'code/client.lua',
    'code/actions.lua',
    'code/spectate.lua',
    'code/uniqueId/client.lua',
    'code/noclip.lua',
    'code/open_functions.lua',
    'code/functions.lua', 
    'code/menus/*.lua',
    'code/fantome.lua',
    'code/scaleforms.lua',
    'config/custom_menu.lua',
    'code/skin.lua',
    'code/staffgun/cl_staffgun.lua',
}
server_scripts {
    -- Servers files
    'code/sv_callback.lua',
    'code/server.lua',
    'code/uniqueId/server.lua',
    'crypted/ranks.lua',
    'code/sanctions.lua',
    'code/sv_reports.lua',
    'code/sv_bans.lua',
    'code/staffgun/sv_staffgun.lua',
}
exports {
    'checkAcces',
    'checkPerms',
    'getStaffMode',
}
client_exports {
    'checkPerms',
    'getStaffMode',
}
server_exports {
    'checkAcces',
    'checkPerms',
    'getStaffMode',
    'getUIDfromID',
    'getIDfromUID',
    'getIdentifierfromUID',
    'getUIDfromIdentifier',
}
escrow_ignore {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    "config/*.lua",
    "code/*.lua",
    "code/uniqueId/*.lua",
    "code/menus/*.lua",
    "code/staffgun/*.lua",
}
files {
    'stream/*.ytd',
}
this_is_a_map 'yes'
dependency '/assetpacks'