-- =============================================================
--  prmap | locales/ar.lua  (Arabic locale — اللغة العربية)
--  To use: set Config.Locale = 'ar' in config.lua
-- =============================================================

Locale = {}

Locale.strings = {
    resource_title        = 'الخريطة',

    postals_loaded        = 'تم تحميل %d مربع.',
    postals_file_missing  = 'ملف postals.json غير موجود.',
    postals_file_invalid  = 'ملف postals.json تالف أو غير صالح.',

    dialog_header         = 'رقم المربع',
    dialog_submit         = 'تحديد الموقع',
    dialog_input_label    = 'اكتب رقم المربع (مثال: 1000)',

    postals_not_ready     = 'المربعات لم يتم تحميلها بعد.',
    input_cancelled       = 'تم إلغاء البحث.',
    input_invalid_number  = 'الرقم المُدخل غير صحيح.',
    postal_not_found      = 'رقم المربع غير موجود.',

    waypoint_set          = 'تم تحديد موقع المربع %s.',

    input_resource_missing = 'مورد الإدخال غير مُشغَّل.',
}

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
