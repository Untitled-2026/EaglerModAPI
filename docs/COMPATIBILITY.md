# Compatibility policy

## Supported targets

- Eaglercraft 26.2
- Eaglercraft 26.3

The main 0.3.0 and 0.4.0 example flows were user-reported as passing on both targets. The 0.5.0 preview exposed a settings ownership issue. Version 0.5.1 adds explicit per-mod binding for Settings, Keybinds and Storage and remains pending in-game testing on each client.

## Detection order

The compatibility detector reads:

1. `mod.minecraft` (documented current Minecraft/game version for the mod);
2. `game.version` as a fallback.

Unknown versions are reported as unsupported. The API still exposes capability information so diagnostics can explain what is available, but support is not promised for unknown versions.

## Capability detection

The current probe checks for specific documented Zeus functions and namespaces. It does not assume every feature exists merely because a version is recognized.

Example:

```lua
if API.hasCapability("playerPosition") then
    local pos = API.player.getPosition()
end
```

## Adding a version

1. Read the official Zeus API reference and version-specific release notes.
2. Test the relevant API calls in the new client.
3. Add a descriptor under `src/compat/versions/`.
4. Extend `src/compat/detect.lua` to recognize the exact version.
5. Add or update capability probes if necessary.
6. Add the version to `metadata.json` and the consumer example metadata only after package compatibility is confirmed.
7. Record the tested client build and results in `tests/COMPATIBILITY-MATRIX.md`.

## Compatibility states

- **Documented:** official documentation describes the API for the target.
- **Runtime tested:** the relevant version's manual test checklist passed on that client build; record whether the result is user-reported or independently reproduced.
- **Experimental:** behavior exists but has not passed the complete test checklist.
- **Unsupported:** no compatibility promise is made.
