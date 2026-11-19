# Public API (0.4.0)

Consumer mods retrieve the library after declaring `eaglermodapi` as a dependency:

```lua
local API = mods.get("eaglermodapi")
assert(API, "EaglerModAPI is missing or disabled")
```

EaglerModAPI wraps the documented Zeus Lua API and adds convenience helpers. Callbacks receive the same arguments as Zeus; event data and drawing contexts are not rewritten.

## Core

- `API.getInfo()` — returns `name`, `version`, `gameVersion`, `supported`, `adapter` and `verification`.
- `API.getCapabilities()` — returns booleans for the Zeus functions detected at runtime.
- `API.hasCapability(name)` — checks one capability.

## Compatibility

- `API.compat.getGameVersion()`
- `API.compat.getAdapterId()`
- `API.compat.isSupported()`
- `API.compat.getVerificationStatus()`
- `API.compat.getCapabilities()`
- `API.compat.has(name)`

## Player API

Most methods require an active player in a world. `exists()`, `getGamemode()` and `getLookingAt()` can be used without that check.

| Function | Returns |
| --- | --- |
| `exists()` | Whether a player is present. |
| `getName()`, `getUUID()` | Player identity. |
| `getPosition()`, `getBlockPosition()`, `getEyePosition()`, `getVelocity()` | Named vector table: `{ x, y, z }`. |
| `getX()`, `getY()`, `getZ()` | Individual position coordinates. |
| `setVelocity(x, y, z)` | Sets velocity. |
| `getRotation()` | `{ yaw, pitch }`. |
| `getYaw()`, `getPitch()`, `getFacing()` | View direction. |
| `setRotation(yaw, pitch)` | Sets view direction. |
| `getHealth()`, `getMaxHealth()`, `getFood()`, `getSaturation()`, `getArmor()` | Player status values. |
| `getXPLevel()`, `getXPProgress()` | Experience level and progress. |
| `isOnGround()`, `isSneaking()`, `isSprinting()`, `isSwimming()`, `isFlying()` | Movement state. |
| `setSprinting(enabled)` | Sets sprinting state. |
| `getGamemode()`, `getDimension()`, `getBiome()` | Current player context. |
| `getHeldItem()`, `getOffhandItem()`, `getSelectedSlot()`, `getInventory()` | Inventory information. |
| `selectSlot(slot)` | Selects hotbar slot 1 through 9. |
| `getEffects()` | Active status effects. |
| `getLookingAt()` | Block/entity information or `nil`. |
| `jump()`, `swing()` | Performs the corresponding player action. |

See the [Zeus API reference](https://dev.eaglercraft.com/docs/modding/api) for the original data fields returned by player and inventory functions.

## World API

World methods other than `exists()` require an active world.

| Function | Returns |
| --- | --- |
| `exists()` | Whether a world is active. |
| `getBlock(x, y, z)` | Block ID at a position. |
| `getLight(x, y, z)` | Light level from 0 to 15. |
| `getBiomeAt(x, y, z)` | Biome ID. |
| `getTime()`, `getDay()`, `getTimeOfDay()` | World clock information. |
| `getWeather()` | `"clear"`, `"rain"` or `"thunder"`. |
| `getPlayers()` | Players in the world, including you. |
| `getEntities(radius)` | Nearby entities, excluding you; radius defaults to 64 and Zeus returns at most 512. |

## HUD API

The HUD API wraps Zeus's HUD functions and provides reusable drawing helpers. Zeus calls a panel callback with `ctx` and `partialTick` every frame. The HUD is only drawn while in a world.

### Register and remove panels

```lua
API.hud.add("my_panel", function(ctx, partialTick)
    API.hud.drawPanel(ctx, 4, 4, 120, 32)
    API.hud.drawText(ctx, "Hello HUD", 10, 10)
end)

API.hud.remove("my_panel")
```

- `API.hud.add(callback, options?)`
- `API.hud.add(name, callback, options?)`
- `API.hud.remove(name)` — calls Zeus `hud.removeLayer`.

Options support Zeus's `before` and `after` placement fields.

### Draw helpers

- `API.hud.drawText(ctx, text, x, y, options?)` — options: `color`, `shadow`.
- `API.hud.drawPanel(ctx, x, y, width, height, options?)` — options: `background`, `border`.
- `API.hud.drawBar(ctx, x, y, width, height, value, maximum, options?)` — options: `background`, `fill`, `border`. The ratio is clamped between 0 and 1.

These helpers use the documented Zeus drawing context methods `ctx:text`, `ctx:rect` and `ctx:outline`. Coordinates are GUI pixels.

### Modify built-in HUD elements

- `API.hud.before(elementId, callback)`
- `API.hud.after(elementId, callback)`
- `API.hud.hide(elementId)`
- `API.hud.show(elementId)`
- `API.hud.replace(elementId, callback)` — callback receives `ctx, partialTick, drawOriginal`.
- `API.hud.isHidden(elementId)`
- `API.hud.elements()`

Use element IDs returned by `API.hud.elements()`. For example, `"hotbar"`, `"crosshair"`, `"player_health"` and `"chat"`.

## Events API

The Events API passes event callback arguments through unchanged from Zeus.

- `API.events.on(name, callback, priority?)` — listens every time the event fires.
- `API.events.once(name, callback, priority?)` — listens only for the next occurrence.
- `API.events.off(handle)` — removes a listener using its handle.
- `API.events.emit(name, ...)` — emits a custom event to mods, including your own.

Priority must be a whole number; the default is 0 and higher priorities run first among listeners in your mod. The handle returned by `on` or `once` also supports Zeus's `:remove()` method.

Example:

```lua
local handle = API.events.on("world_join", function(event)
    chat.print("Joined a world!")
end)

-- Later:
API.events.off(handle)
```

Custom event names should start with your mod ID to avoid collisions, for example `"my_mod:ready"`. Zeus custom events run synchronously and cannot be cancelled. For normal cancellable events, call `event:cancel()` only when the event documentation says it can be cancelled.

## Commands API

Commands are local mod commands; they are not sent to the multiplayer server.

- `API.commands.register(name, callback, description?)`
- `API.commands.unregister(name)`
- `API.commands.list()`

The callback receives `args` (a list of words) and `raw` (the full text following the command name).

Example:

```lua
API.commands.register("helloapi", function(args, raw)
    chat.print("Hello, " .. (args[1] or "player"))
end, "Say hello")
```

Do not register a command name already used by another mod or a built-in command. Registering a conflicting mod command can fail, and a mod command can take precedence over the game's command with the same name.

**Chat input hint:** Eaglercraft's chat input may show an “unknown or misspelled command” hint while a local mod command is being typed, even though pressing Enter runs the registered command. The documented Zeus Lua API currently provides command registration, removal and listing, but no function to add local commands to the chat autocomplete/suggestion system. This is a client-side hint limitation, not a failure of `API.commands.register`.

## Settings API

The Settings API creates options in the mod's Settings page. Zeus saves setting values automatically.

- `API.settings.toggle(key, options)` — on/off setting.
- `API.settings.slider(key, options)` — numeric setting with `min`, `max`, optional `step` and `default`.
- `API.settings.choice(key, options)` — selection from an `options` list.
- `API.settings.text(key, options)` — text field.
- `API.settings.key(key, options)` — configurable key value.
- `API.settings.color(key, options)` — color picker. Its value is a number such as `0xFFFFFFFF`, suitable for Zeus drawing functions.
- `API.settings.button(key, options)` — button that calls `options.onClick`.
- `API.settings.get(key)`, `API.settings.set(key, value)` — read or change a setting.
- `API.settings.reset(key)` — restore its default.
- `API.settings.all()` — return all setting values.
- `API.settings.onChange(callback)` — callback receives `key, value, oldValue` whenever a setting changes.
- `API.settings.open()` — open the mod's settings page.

Every setting requires a non-empty `label`. A `description` is optional. Do not use reserved keys that match a Settings API function name, such as `toggle`, `get`, `set` or `open`.

Example:

```lua
API.settings.toggle("showHud", {
    label = "Show HUD",
    default = true
})

API.settings.slider("hudWidth", {
    label = "HUD width",
    min = 220,
    max = 360,
    step = 10,
    default = 260
})

if API.settings.get("showHud") then
    -- Draw the HUD.
end
```

## Keybinds API

- `API.keys.bind(options)` — register a configurable keybind.
- `API.keys.isDown(name)` — check whether a keyboard key is held.
- `API.keys.code(name)` — return a key's numeric code, or `nil`.
- `API.keys.name(code)` — return the name for a numeric key code.

The `bind` options are `id` (unique within your mod), `label`, optional `description`, optional `default` key name, optional `onPress` and `onRelease` callbacks, and optional `inScreens` boolean. Keybinds automatically appear in the mod's Settings page and players can rebind them there. The selected key can be read with `API.settings.get(id)`.

Example:

```lua
API.keys.bind({
    id = "toggle_hud",
    label = "Toggle HUD",
    default = "h",
    onPress = function()
        local enabled = API.settings.get("showHud")
        API.settings.set("showHud", not enabled)
    end
})
```

## Persistent Storage API

The Storage API wraps Zeus's per-mod persistent `storage` table.

- `API.storage.get(key, defaultValue?)` — read a value, using the default when no value exists.
- `API.storage.set(key, value, saveImmediately?)` — set a value. Pass `true` to call `mod.save()` immediately.
- `API.storage.remove(key, saveImmediately?)` — remove a value.
- `API.storage.all()` — return the underlying storage table.
- `API.storage.save()` — save settings and storage immediately.

Only strings, booleans, finite numbers and plain tables of those values are accepted. Do not replace the table returned by `API.storage.all()`; change its fields through the helper methods or by assigning individual fields. Zeus also saves storage and settings periodically and when the mod unloads, but call `save()` after important changes to ensure they are written.

Example:

```lua
local visits = API.storage.get("visits", 0)
API.storage.set("visits", visits + 1, true)
```

## Timer API

The Timer API wraps Zeus's timer scheduler and passes timer handles through unchanged.

- `API.timer.after(seconds, callback)` — runs the callback once after the delay and returns a timer handle.
- `API.timer.every(seconds, callback)` — runs the callback repeatedly and returns a timer handle. The interval must be greater than zero.
- `API.timer.cancel(handle)` — cancels a timer using its native `:cancel()` method.
- `API.timer.isActive(handle)` — reads the handle's `active` property.
- `API.timer.time()` — returns the current timer time in seconds, including milliseconds.
- `API.timer.ticks()` — returns the number of game ticks since the game started.

A delay must be a finite, non-negative number. Timer callbacks are passed directly to Zeus.

Example:

```lua
local handle = API.timer.every(5, function()
    API.ui.notify("Reminder", "Five seconds have passed.")
end)

-- Later:
API.timer.cancel(handle)
```

## UI API

- `API.ui.notify(title, message)` — displays a Zeus popup notification. Both arguments must be strings. A new notification replaces the previous popup.

Example:

```lua
API.ui.notify("My Mod", "Settings saved.")
```

## Errors

Wrapper methods return `nil, error_code` when validation fails, the required game context is missing, or the Zeus function is unavailable. Registration functions return `true` on success. Event listener registration returns the native Zeus handle.

## Compatibility note

The 0.3.0 and 0.4.0 example flows were user-reported as working in Eaglercraft 26.2 and 26.3. The Settings, Keybinds and Storage wrappers added in 0.5.0 are awaiting in-game testing on both clients. See [the compatibility matrix](../tests/COMPATIBILITY-MATRIX.md).
