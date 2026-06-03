-- =============================================================
--  prmap | client.lua
--  Postal-code map locator — QBCore & OX compatible
--  Reads all settings from config.lua and locales/*.lua
-- =============================================================

local Postals  = {}
local areaBlip = nil

-- =============================================================
--  Framework bridge (resolved once at startup)
-- =============================================================
local Framework = nil

local function resolveFramework()
    local want = (Config.Framework or 'auto'):lower()

    if want == 'qbcore' or (want == 'auto' and GetResourceState('qb-core') == 'started') then
        local ok, QBCore = pcall(exports['qb-core'].GetCoreObject)
        if ok and QBCore then
            Framework = { name = 'qbcore', core = QBCore }
            return
        end
    end

    if want == 'ox' or (want == 'auto' and GetResourceState('ox_core') == 'started') then
        Framework = { name = 'ox' }
        return
    end

    -- Fallback — standalone mode (no framework required)
    Framework = { name = 'standalone' }
end

-- =============================================================
--  Notification system
--  Priority: ox_lib → QBCore.Functions.Notify → native
-- =============================================================
local function notify(key, nType, duration, ...)
    local message = Locale.t(key, ...)
    local title   = Locale.t('resource_title')
    local dur     = duration or Config.NotifyDuration or 4000
    local want    = (Config.NotifyBackend or 'auto'):lower()

    -- ── OX Lib ──────────────────────────────────────────────
    if want == 'ox' or (want == 'auto' and GetResourceState('ox_lib') == 'started') then
        lib.notify({
            title       = title,
            description = message,
            type        = nType or 'inform',   -- success | error | inform | warning
            duration    = dur,
        })
        return
    end

    -- ── QBCore ──────────────────────────────────────────────
    if want == 'qbcore' or (want == 'auto' and Framework and Framework.name == 'qbcore') then
        -- QBCore uses 'success'|'error'|'primary'|'warning'
        local qbType = nType == 'inform' and 'primary' or (nType or 'primary')
        if Framework and Framework.core then
            Framework.core.Functions.Notify(message, qbType, dur)
            return
        end
        -- Core not ready yet — fall through to native
    end

    -- ── Native (GTA V) ──────────────────────────────────────
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(('[%s] %s'):format(title, message))
    EndTextCommandThefeedPostTicker(false, true)
end

-- =============================================================
--  Input dialog
--  Priority: ox_lib → qb-input
-- =============================================================
local function openInputDialog(callback)
    local want = (Config.InputBackend or 'auto'):lower()

    -- ── OX Lib ──────────────────────────────────────────────
    if want == 'ox' or (want == 'auto' and GetResourceState('ox_lib') == 'started') then
        local result = lib.inputDialog(Locale.t('dialog_header'), {
            {
                type        = 'number',
                label       = Locale.t('dialog_input_label'),
                icon        = 'map-pin',
                required    = true,
                min         = 1,
            }
        })

        if not result then
            notify('input_cancelled', 'inform', 2500)
            callback(nil)
            return
        end

        callback(tonumber(result[1]))
        return
    end

    -- ── QBCore / qb-input ───────────────────────────────────
    if want == 'qbcore' or want == 'auto' then
        if GetResourceState('qb-input') ~= 'started' then
            notify('input_resource_missing', 'error')
            callback(nil)
            return
        end

        local dialog = exports['qb-input']:ShowInput({
            header     = Locale.t('dialog_header'),
            submitText = Locale.t('dialog_submit'),
            inputs     = {
                {
                    text       = Locale.t('dialog_input_label'),
                    name       = 'grid',
                    type       = 'number',
                    isRequired = true,
                }
            }
        })

        if not dialog or not dialog.grid then
            notify('input_cancelled', 'inform', 2500)
            callback(nil)
            return
        end

        callback(tonumber(dialog.grid))
        return
    end

    -- Fallback: no input resource available
    notify('input_resource_missing', 'error')
    callback(nil)
end

-- =============================================================
--  Blip helpers
-- =============================================================
local function removeBlip()
    if areaBlip then
        RemoveBlip(areaBlip)
        areaBlip = nil
    end
end

local function placeBlip(x, y)
    removeBlip()
    if not Config.Blip or not Config.Blip.enabled then return end

    areaBlip = AddBlipForRadius(x, y, 0.0, Config.Blip.radius or 80.0)
    SetBlipSprite(areaBlip,   Config.Blip.sprite or 1)
    SetBlipColour(areaBlip,   Config.Blip.color  or 1)
    SetBlipAlpha(areaBlip,    Config.Blip.alpha  or 200)
end

-- =============================================================
--  Load postals from JSON file
-- =============================================================
local function loadPostals()
    local raw = LoadResourceFile(GetCurrentResourceName(), Config.PostalsFile or 'postals.json')
    if not raw then
        notify('postals_file_missing', 'error')
        return false
    end

    local ok, data = pcall(json.decode, raw)
    if not ok or not data then
        notify('postals_file_invalid', 'error')
        return false
    end

    local count = 0
    for _, p in ipairs(data) do
        -- Support multiple common postal JSON formats
        local code = p.code or p.postal or p.id or p.name
        local x    = tonumber(p.x)
        local y    = tonumber(p.y)

        if code and x and y then
            Postals[tostring(code)] = { x = x, y = y }
            count = count + 1
        end
    end

    if count > 0 then
        notify('postals_loaded', 'success', 3500, count)
    else
        notify('postals_file_invalid', 'error')
        return false
    end

    return true
end

-- =============================================================
--  Locate a postal code
-- =============================================================
local function locatePostal(id)
    local key  = tostring(id)
    local data = Postals[key]

    if not data then
        notify('postal_not_found', 'error')
        return false
    end

    removeBlip()

    if Config.SetWaypoint then
        SetNewWaypoint(data.x, data.y)
    end

    placeBlip(data.x, data.y)
    notify('waypoint_set', 'success', 2500, key)
    return true
end

-- =============================================================
--  Open the search dialog
-- =============================================================
local function openSearch()
    if not next(Postals) then
        notify('postals_not_ready', 'error')
        return
    end

    openInputDialog(function(id)
        if not id then return end

        if type(id) ~= 'number' then
            notify('input_invalid_number', 'error')
            return
        end

        locatePostal(id)
    end)
end

-- =============================================================
--  Startup
-- =============================================================
CreateThread(function()
    Wait(Config.StartupDelay or 800)
    resolveFramework()
    loadPostals()
end)

-- =============================================================
--  Network event (server can trigger the dialog on a player)
-- =============================================================
RegisterNetEvent('prmap:open', function()
    openSearch()
end)

-- =============================================================
--  Local event (trigger from other client-side scripts)
-- =============================================================
AddEventHandler('prmap:openLocal', function()
    openSearch()
end)

-- =============================================================
--  Chat command  (toggleable via Config.Command)
-- =============================================================
if Config.Command then
    RegisterCommand(Config.Command, function()
        openSearch()
    end, false)
end

-- =============================================================
--  Keybind  (toggleable via Config.Keybind)
-- =============================================================
if Config.Keybind then
    RegisterKeyMapping(
        Config.Command or 'grid',
        Locale.t('dialog_header'),
        Config.KeybindMapper or 'keyboard',
        Config.Keybind
    )
end

-- =============================================================
--  Exports  (other resources can call these)
-- =============================================================
exports('openSearch',   openSearch)
exports('locatePostal', locatePostal)
exports('removeBlip',   removeBlip)
