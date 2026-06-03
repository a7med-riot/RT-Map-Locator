-- =============================================================
--  prmap | locales/en.lua  (default English locale)
--  To add a new language: copy this file, rename it, and
--  update Config.Locale in config.lua to match.
-- =============================================================

Locale = {}

-- -------------------------------------------------------
--  Notification / UI strings
-- -------------------------------------------------------
Locale.strings = {
    -- General resource title shown in notifications
    resource_title        = 'Postal Map',

    -- Startup
    postals_loaded        = 'Loaded %d postal codes.',
    postals_file_missing  = 'postals.json not found.',
    postals_file_invalid  = 'postals.json could not be parsed.',

    -- Search dialog
    dialog_header         = 'Postal Code',
    dialog_submit         = 'Set Waypoint',
    dialog_input_label    = 'Enter postal code (e.g. 1000)',

    -- Validation
    postals_not_ready     = 'Postal codes are not loaded yet.',
    input_cancelled       = 'Search cancelled.',
    input_invalid_number  = 'Invalid number entered.',
    postal_not_found      = 'Postal code not found.',

    -- Success
    waypoint_set          = 'Waypoint set for postal %s.',

    -- Dependency errors
    input_resource_missing = 'Input resource is not running.',
}

-- -------------------------------------------------------
--  Helper: retrieve a locale string (with optional fmt args)
-- -------------------------------------------------------
function Locale.t(key, ...)
    local str = Locale.strings[key]
    if not str then
        return '[missing: ' .. tostring(key) .. ']'
    end
    if select('#', ...) > 0 then
        return str:format(...)
    end
    return str
end
