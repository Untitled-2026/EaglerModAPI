# Architecture

## Runtime model

EaglerModAPI is a Zeus library mod, not a replacement for the Zeus runtime.

1. Zeus loads the EaglerModAPI package.
2. `main.lua` loads the internal Lua modules using Zeus `require`.
3. EaglerModAPI assigns its public table to `mod.export`.
4. Consumer mods declare `eaglermodapi` as a dependency.
5. Consumer mods obtain the API with `mods.get("eaglermodapi")`.

## Layers

- **Core:** public API identity and entry points.
- **Compatibility detection:** reads the current game version and selects a supported adapter descriptor.
- **Capability probe:** checks the actual Zeus global namespaces and functions available at runtime.
- **Adapters:** contain only version-specific behavior that has been demonstrated to differ.
- **Modules:** normalized, higher-level functions for player, world, HUD, UI and other domains as they are implemented.

## Version strategy

The official public Zeus documentation describes the mod system as built into Eaglercraft 26.2 and 26.3 and provides a shared API reference. Therefore, the initial adapters are intentionally small descriptors, while common implementation stays shared.

Do not add conditional branches just because the version string differs. Add a version-specific implementation only when at least one of these is true:

- the official docs explicitly show a different signature or behavior;
- a reproducible test demonstrates a difference;
- a documented issue or release note confirms a difference.

When possible, use capability detection first. Version detection is a fallback for genuine behavioral differences, not a substitute for checking whether a function exists.

## Return-value normalization

Zeus functions such as `player.pos()` return multiple Lua values. EaglerModAPI converts these to named tables, such as:

```lua
local pos = API.player.getPosition()
-- { x = number, y = number, z = number }
```

Functions return `nil, error_code` when the required game context or Zeus function is unavailable.

## Scope and limitations

EaglerModAPI can combine and simplify functions exposed by Zeus. It cannot automatically access engine internals or create capabilities that the Zeus sandbox does not expose. Features requiring deeper game integration would need a separate investigation into whether a supported extension point exists.
