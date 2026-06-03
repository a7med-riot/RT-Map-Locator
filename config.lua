-- =============================================================
--  prmap | config.lua
--  Centralised configuration — edit here, not in client.lua
-- =============================================================

Config = {}

-- -------------------------------------------------------
--  Framework detection
--  'auto'   → auto-detect QBCore or OX at runtime
--  'qbcore' → force QBCore
--  'ox'     → force OX (ox_core)
-- -------------------------------------------------------
Config.Framework = 'auto'

-- -------------------------------------------------------
--  Notification backend
--  'auto'     → use whichever is running (ox_lib first, then qb-notify, then native)
--  'ox'       → ox_lib notifications (lib.notify)
--  'qbcore'   → QBCore.Functions.Notify
--  'native'   → built-in GTA V notifications (no dependency)
-- -------------------------------------------------------
Config.NotifyBackend = 'auto'

-- -------------------------------------------------------
--  Default notification duration (milliseconds)
-- -------------------------------------------------------
Config.NotifyDuration = 4000

-- -------------------------------------------------------
--  Input dialog backend
--  'auto'   → prefer ox_lib, fall back to qb-input
--  'ox'     → ox_lib (lib.inputDialog)
--  'qbcore' → qb-input (exports['qb-input']:ShowInput)
-- -------------------------------------------------------
Config.InputBackend = 'auto'

-- -------------------------------------------------------
--  Chat command that opens the postal search dialog
--  Set to false/nil to disable the command entirely
-- -------------------------------------------------------
Config.Command = 'grid'

-- -------------------------------------------------------
--  Keybind to open the postal search dialog
--  Uses RegisterKeyMapping — players can rebind in settings
--  Set to false/nil to disable keybind registration
-- -------------------------------------------------------
Config.Keybind         = 'F7'
Config.KeybindMapper   = 'keyboard'   -- 'keyboard' | 'controller'

-- -------------------------------------------------------
--  Waypoint settings
-- -------------------------------------------------------
Config.SetWaypoint = true   -- set a GPS waypoint on the map

-- -------------------------------------------------------
--  Blip settings (circle drawn around the postal)
-- -------------------------------------------------------
Config.Blip = {
    enabled  = true,
    sprite   = 1,       -- blip sprite id
    color    = 1,       -- blip colour  (1 = red)
    scale    = 0.8,
    alpha    = 200,     -- 0-255
    radius   = 80.0,    -- radius of the circle blip (metres)
}

-- -------------------------------------------------------
--  Postals JSON file name (relative to resource root)
-- -------------------------------------------------------
Config.PostalsFile = 'postals.json'

-- -------------------------------------------------------
--  Startup delay before postals are loaded (ms)
--  Give other resources time to start
-- -------------------------------------------------------
Config.StartupDelay = 800
