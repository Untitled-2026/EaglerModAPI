# Changelog

All notable project changes are recorded here.

## [0.2.0] - Preview

### Added
- Expanded Player API for identity, position, movement, health, hunger, experience, status, dimension, biome, inventory, effects and basic actions.
- Expanded World API for blocks, light, biomes, time, day, weather, players and nearby entities.
- Expanded runtime capability detection for the documented Zeus Player and World functions.
- Updated the example test mod with a multi-line Player and World HUD.

### Changed
- Bumped the library and example package metadata to 0.2.0.
- Documented the complete 0.2.0 public helper surface.

### Testing
- User-reported successful test of the 0.2.0 library and expanded example HUD in Eaglercraft 26.2 and 26.3 on 2026-11-18.
- The example HUD exercised position, player name, health, max health, hunger, gamemode, dimension, biome, day and time-of-day, and weather queries.
- Exact client build numbers and browser versions were not recorded.
- Other helper methods still need focused tests.

## [0.1.0] - Initial preview

### Added
- Initial Lua library-mod structure.
- Game-version detection for Eaglercraft 26.2 and 26.3.
- Runtime capability probing for documented Zeus namespaces.
- Initial Player and World helpers.
- A consumer-mod example and manual test checklist.
