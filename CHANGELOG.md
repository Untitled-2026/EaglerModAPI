# Changelog

All notable project changes are recorded here.

## [0.5.1] - In development

### Fixed
- Settings created by consumer mods are now registered under the consumer's own Mods → Settings page instead of EaglerModAPI.
- Keybinds and persistent storage are now scoped to the consuming mod as well.
- Added `API.forMod({ settings, keys, storage, mod })` to bind the per-mod Zeus namespaces explicitly.
- Updated the test mod and documentation to use the scoped API instance.

### Testing
- Awaiting in-game verification in Eaglercraft 26.2 and 26.3. The 0.5.0 test exposed the per-mod ownership bug before the remaining checklist was completed.

## [0.5.0] - Superseded preview

### Added
- Settings API wrappers for toggles, sliders, choices, text, key, color and button settings.
- Settings access helpers for get, set, reset, list, change callbacks and opening the settings page.
- Keybind API wrappers for configurable keybinds and keyboard-state/name/code helpers.
- Persistent Storage API helpers with validation for serializable values and optional immediate saving.
- Example HUD preferences, a configurable H-key HUD toggle, and a persistent toggle counter.
- Runtime capability detection for Settings, Keybinds, persistent Storage and manual saving.

### Changed
- Bumped the library and example package metadata to 0.5.0.
- Updated the public API documentation and manual test checklist.

### Testing
- First test step exposed that settings appeared under EaglerModAPI instead of the consumer test mod. No full 0.5.0 test was completed; the issue was fixed in 0.5.1.

## [0.4.0] - Tested preview

### Added
- Timer API wrappers for one-shot and repeating timers, cancellation, active-state checks, elapsed time and game ticks.
- UI API wrapper for Zeus popup notifications.
- Example commands for testing notifications, delayed/repeating timers and timer counters.

### Changed
- Bumped the library and example package metadata to 0.4.0.
- Extended runtime capability detection and the package validation list for the new modules.
- Updated the API documentation and manual test checklist.

### Testing
- User-reported successful testing in Eaglercraft 26.2 and 26.3 on 2026-11-19.
- Command input may still display an unknown-command hint before submission; registered local commands execute successfully. The current documented Zeus Lua API has no command autocomplete/suggestion registration function.

## [0.3.0] - Tested preview

### Added
- HUD API wrappers for adding/removing panels and modifying built-in HUD elements.
- HUD drawing helpers for text, panels and progress bars.
- Events API wrappers for listeners, one-time listeners, removal and custom events.
- Commands API wrappers for registering, unregistering and listing mod-local commands.
- Example mod demonstrates the HUD, Events and Commands APIs.
- Runtime capability detection for HUD, Events and Commands functions.

### Changed
- Bumped the library and example package metadata to 0.3.0.
- Updated the public API documentation and test checklist.

### Testing
- User-reported successful test of the main 0.3.0 example flow in Eaglercraft 26.2 and 26.3 on 2026-11-18: HUD updates, /emapi, /emapi ping, and the world-join event message.
- Exact client build numbers and browser versions were not recorded.
- Additional individual helper methods were not all tested separately.

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
