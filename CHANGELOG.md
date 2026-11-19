# Changelog

All notable project changes are recorded here.

## [0.3.0] - In development

### Added
- HUD API wrappers for adding/removing panels and modifying built-in HUD elements.
- HUD drawing helpers for text, panels and progress bars.
- Events API wrappers for listeners, one-time listeners, removal and custom events.
- Commands API wrappers for registering, unregistering and listing mod-local commands.
- Example mod now demonstrates the HUD, Events and Commands APIs.
- Runtime capability detection for HUD, Events and Commands functions.

### Changed
- Bumped the library and example package metadata to 0.3.0.
- Updated the public API documentation and test checklist.

### Testing
- 0.2.0 was user-reported as working in Eaglercraft 26.2 and 26.3.
- 0.3.0 requires in-game testing in both supported versions.

## [0.2.0] - Preview

### Added
- Expanded Player API for identity, position, movement, health, hunger, experience, status, dimension, biome, inventory, effects and basic actions.
- Expanded World API for blocks, light, biomes, time, day, weather, players and nearby entities.
- Expanded runtime capability detection for the documented Zeus Player and World functions.
- Multi-line Player and World example HUD.

### Changed
- Bumped the library and example package metadata to 0.2.0.
- Documented the 0.2.0 public helper surface.

### Testing
- User-reported successful test of the 0.2.0 library and expanded example HUD in Eaglercraft 26.2 and 26.3 on 2026-11-18.
- Exact client build numbers and browser versions were not recorded.
- Other helper methods still need focused tests.

## [0.1.0] - Initial preview

### Added
- Initial Lua library-mod structure.
- Game-version detection for Eaglercraft 26.2 and 26.3.
- Runtime capability probing for documented Zeus namespaces.
- Initial Player and World helpers.
- A consumer-mod example and manual test checklist.
