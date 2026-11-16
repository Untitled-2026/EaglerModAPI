# Public API (0.1.0)

Consumer mods first retrieve the library:

```lua
local API = mods.get("eaglermodapi")
assert(API, "EaglerModAPI is missing or disabled")
```

## Core

### `API.getInfo()`

Returns a table:

- `name`: API name.
- `version`: EaglerModAPI version.
- `gameVersion`: detected game version string.
- `supported`: whether the detected version is a configured target.
- `adapter`: selected adapter ID, or `"unsupported"`.
- `verification`: documentation/runtime-test status.

### `API.getCapabilities()`

Returns a table of booleans for probed Zeus functions, including `playerPosition`, `worldBlock`, `hudAdd`, and `eventsOn`.

### `API.hasCapability(name)`

Returns whether a named capability is available.

## Compatibility

- `API.compat.getGameVersion()`
- `API.compat.getAdapterId()`
- `API.compat.isSupported()`
- `API.compat.getVerificationStatus()`
- `API.compat.getCapabilities()`
- `API.compat.has(name)`

## Player

All world-dependent functions check that a player exists.

### `API.player.exists()`

Returns `true` if a player is available; otherwise `false`.

### `API.player.getPosition()`

Returns `{ x = number, y = number, z = number }`, or `nil, error_code`.

### `API.player.getName()`

Returns the player name, or `nil, error_code`.

### `API.player.getHealth()`

Returns the player's current health, or `nil, error_code`.

## World

### `API.world.exists()`

Returns `true` if a world is available; otherwise `false`.

### `API.world.getBlock(x, y, z)`

Returns the block ID, or `nil, error_code`.

### `API.world.getTime()`

Returns the world time in ticks, or `nil, error_code`.

## Error conventions

When an operation cannot run, functions return `nil, error_code` rather than deliberately throwing an error. Callers should check the first return value before using it.
