# Public API (0.2.0)

Consumer mods retrieve the library after declaring `eaglermodapi` as a dependency:

```lua
local API = mods.get("eaglermodapi")
assert(API, "EaglerModAPI is missing or disabled")
```

Functions documented below wrap the corresponding Zeus API functions. Values are normalized where useful. Functions return `nil, error_code` when the player/world is unavailable, an argument is invalid, or Zeus reports an error.

## Core

### `API.getInfo()`

Returns a table containing `name`, `version`, `gameVersion`, `supported`, `adapter` and `verification`.

### `API.getCapabilities()`

Returns a table of booleans describing which underlying Zeus functions are available.

### `API.hasCapability(name)`

Returns `true` only when the named capability is present.

## Compatibility

- `API.compat.getGameVersion()`
- `API.compat.getAdapterId()`
- `API.compat.isSupported()`
- `API.compat.getVerificationStatus()`
- `API.compat.getCapabilities()`
- `API.compat.has(name)`

## Player API

Most player methods require an active player in a world. `exists()`, `getGamemode()` and `getLookingAt()` are safe to call without that check, matching the Zeus API reference.

### Presence and identity

| Function | Returns |
| --- | --- |
| `API.player.exists()` | `true` if a player is available; otherwise `false`. |
| `API.player.getName()` | Player username. |
| `API.player.getUUID()` | Player UUID. |

### Position and movement

| Function | Returns |
| --- | --- |
| `getPosition()` | `{ x, y, z }` for the player's feet position. |
| `getX()`, `getY()`, `getZ()` | One coordinate each. |
| `getBlockPosition()` | `{ x, y, z }` block coordinates. |
| `getEyePosition()` | `{ x, y, z }` eye coordinates. |
| `getVelocity()` | `{ x, y, z }` velocity in blocks per tick. |
| `setVelocity(x, y, z)` | Sets velocity; returns `true` on success. |
| `getRotation()` | `{ yaw, pitch }` in degrees. |
| `getYaw()`, `getPitch()` | Individual rotation values. |
| `setRotation(yaw, pitch)` | Sets rotation; returns `true` on success. |
| `getFacing()` | `"north"`, `"south"`, `"east"` or `"west"`. |

### Player status

| Function | Returns |
| --- | --- |
| `getHealth()`, `getMaxHealth()` | Current and maximum health (20 is ten hearts). |
| `getFood()`, `getSaturation()` | Hunger and saturation. |
| `getArmor()` | Armor points. |
| `getXPLevel()`, `getXPProgress()` | Experience level and progress (0 to 1). |
| `isOnGround()` | Whether the player is on the ground. |
| `isSneaking()`, `isSprinting()` | Movement state. |
| `isSwimming()`, `isFlying()` | Movement state. |
| `setSprinting(enabled)` | Starts/stops sprinting; `enabled` must be boolean. |
| `getGamemode()` | `"survival"`, `"creative"`, `"adventure"`, `"spectator"` or `nil`. |
| `getDimension()` | Dimension ID, such as `"minecraft:overworld"`. |
| `getBiome()` | Current biome ID, or `nil`. |

### Inventory and actions

| Function | Returns |
| --- | --- |
| `getHeldItem()`, `getOffhandItem()` | Item table or `nil` for an empty hand. |
| `getSelectedSlot()` | Selected hotbar slot (1 to 9). |
| `selectSlot(slot)` | Selects a hotbar slot from 1 to 9; returns `true` on success. |
| `getInventory()` | List of non-empty inventory items. |
| `getEffects()` | List of active status effects. |
| `getLookingAt()` | Block/entity information or `nil`. |
| `jump()`, `swing()` | Performs the action; returns `true` on success. |

Zeus item tables contain `id`, `count`, `name`, `damage` and `maxDamage`. Inventory items also contain `slot`. Status effects contain `id`, `amplifier` and `duration` in ticks. `getLookingAt()` returns a typed block or entity table; see the official Zeus API reference for its fields.

## World API

World methods other than `exists()` require an active world.

| Function | Returns |
| --- | --- |
| `API.world.exists()` | `true` when in a world; otherwise `false`. |
| `getBlock(x, y, z)` | Block ID at the position. |
| `getLight(x, y, z)` | Light level (0 to 15). |
| `getBiomeAt(x, y, z)` | Biome ID or `nil`. |
| `getTime()` | World clock in ticks. |
| `getDay()` | Day number. |
| `getTimeOfDay()` | Time within the day (0 to 23999). |
| `getWeather()` | `"clear"`, `"rain"` or `"thunder"`. |
| `getPlayers()` | List of players in the world, including you. |
| `getEntities(radius)` | Nearby entities, excluding you; radius defaults to 64 and Zeus returns at most 512. |

World block/light/biome functions require numeric coordinates. `getEntities` accepts an optional positive numeric radius.

## Error handling

- `nil, "player_unavailable"`: a player-dependent method was called without a player.
- `nil, "world_unavailable"`: a world-dependent method was called outside a world.
- `nil, "zeus_function_unavailable: ..."`: the expected Zeus function is not exposed.
- Argument errors use descriptive strings such as `"coordinates_must_be_numbers"`.

Action methods return `true` when the Zeus call succeeds, or `nil, error_code` when it cannot be completed.

## Compatibility note

This API is designed against the shared Zeus API reference for Eaglercraft 26.2 and 26.3. The new 0.2.0 functions still need in-game testing in both versions. See [the compatibility matrix](../tests/COMPATIBILITY-MATRIX.md).
