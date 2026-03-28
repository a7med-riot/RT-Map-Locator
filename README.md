# RT Map Locator – Postal Search & GPS Waypoint System

> Upgraded: Full **QBCore** & **OX** framework compatibility, configurable notifications, locale system, and clean config file.

---

## Features

| Feature | Details |
|---|---|
| Framework support | QBCore · OX (ox_core) · Standalone (no framework) |
| Notification backends | ox_lib · QBCore.Functions.Notify · Native GTA V |
| Input dialog backends | ox_lib inputDialog · qb-input · auto-detect |
| Language / locale system | `locales/en.lua` (English) · `locales/ar.lua` (Arabic) |
| Config file | All settings in `config.lua` — no need to touch Lua logic |
| Keybind | Rebindable via GTA V settings (RegisterKeyMapping) |
| Exports | `openSearch` · `locatePostal` · `removeBlip` |
| Events | `rtmap:open` (net) · `rtmap:openLocal` (local) |

---

## File Structure

```
rtmap/
├── config.lua          ← all settings live here
├── client.lua          ← main script (framework-agnostic)
├── fxmanifest.lua      ← resource manifest
├── postals.json        ← postal coordinate data
└── locales/
    ├── en.lua          ← English strings (default)
    └── ar.lua          ← Arabic strings
```

---

## Installation

1. Drop the `rtmap` folder into your `resources/` directory.
2. Add `ensure rtmap` to your `server.cfg`.
3. Open `config.lua` and adjust to your server's setup (see below).
4. Restart the resource or reboot your server.

---

## Configuration (`config.lua`)

### Framework detection

```lua
Config.Framework = 'auto'   -- 'auto' | 'qbcore' | 'ox'
```

`'auto'` detects which framework is running at startup. Force a value if auto-detection causes issues.

---

### Notification backend

```lua
Config.NotifyBackend = 'auto'   -- 'auto' | 'ox' | 'qbcore' | 'native'
```

| Value | Sends notifications via |
|---|---|
| `'auto'` | ox_lib if running, then QBCore, then native |
| `'ox'` | `lib.notify()` (requires ox_lib) |
| `'qbcore'` | `QBCore.Functions.Notify()` |
| `'native'` | Built-in GTA V ticker — no dependency |

---

### Input dialog backend

```lua
Config.InputBackend = 'auto'   -- 'auto' | 'ox' | 'qbcore'
```

| Value | Opens dialog via |
|---|---|
| `'auto'` | ox_lib if running, then qb-input |
| `'ox'` | `lib.inputDialog()` (requires ox_lib) |
| `'qbcore'` | `exports['qb-input']:ShowInput()` |

---

### Command & Keybind

```lua
Config.Command = 'grid'     -- chat command  (false to disable)
Config.Keybind = 'F7'       -- default key   (false to disable)
```

Players can rebind the key in **GTA V Settings → Key Bindings → FiveM**.

---

### Blip

```lua
Config.Blip = {
    enabled = true,
    sprite  = 1,
    color   = 1,     -- 1 = red
    scale   = 0.8,
    alpha   = 200,
    radius  = 80.0,  -- metres
}
```

Set `enabled = false` to disable the circle blip entirely.

---

## Changing Language

Open `fxmanifest.lua` and change the locale line:

```lua
client_scripts {
    'locales/ar.lua',   -- Arabic
    'client.lua',
}
```

Available locales: `en.lua` (English), `ar.lua` (Arabic).

To add a new language, copy `locales/en.lua`, rename it (e.g. `locales/fr.lua`), translate the strings, and update `fxmanifest.lua`.

---

## Events & Exports

### Trigger the dialog from another resource

```lua
-- Net event (server → client)
TriggerClientEvent('rtmap:open', source)

-- Local event (client → client)
TriggerEvent('rtmap:openLocal')

-- Export (client script)
exports['rtmap']:openSearch()
exports['rtmap']:locatePostal(1000)   -- jump to postal 1000 directly
exports['rtmap']:removeBlip()          -- clear the circle blip
```

---

## Postals JSON Format

The resource accepts several common formats:

```json
[
  { "code": "1000", "x": 2325.43, "y": 5147.21 },
  { "postal": "1001", "x": 2151.21, "y": 5166.08 },
  { "id": "1002", "x": 2059.65, "y": 5105.84 }
]
```

Supported key names for the code field: `code`, `postal`, `id`, `name`.

---

## Dependencies (all optional)

| Resource | Required for |
|---|---|
| `ox_lib` | ox_lib notifications + ox_lib input dialog |
| `qb-core` | QBCore.Functions.Notify |
| `qb-input` | qb-input dialog |

The script runs in **standalone mode** with native GTA V notifications if none of the above are present.
