# EaglerModAPI

**A cross-version helper framework for Eaglercraft Zeus mods.**

EaglerModAPI is a Lua library mod that sits on top of the built-in Zeus modding system. Its goal is to give mod developers a consistent, documented interface across Eaglercraft 26.2 and 26.3, while adding reusable helpers that Zeus does not provide directly.

> **Status:** EaglerModAPI 0.5.0 is in development. Versions 0.3.0 and 0.4.0 were user-tested successfully in Eaglercraft 26.2 and 26.3. The 0.5.0 Settings, Keybinds and Storage additions are awaiting in-game testing.

## Goals

- **Write once:** let mod authors use one EaglerModAPI interface across supported Eaglercraft versions.
- **Compatibility:** detect the running game version and inspect the Zeus functions actually available.
- **Honest feature support:** use a shared implementation when the documented Zeus API is the same; add a version-specific adapter only when a real difference is verified.
- **Useful additions:** build higher-level helpers and modules on top of Zeus.
- **Safe fallbacks:** report unsupported features clearly instead of silently pretending they work.

## Current support

| Eaglercraft | Status | Notes |
| --- | --- | --- |
| 26.2 | 0.4.0 user-tested (reported) | 0.3.0 and 0.4.0 example flows passed; 0.5.0 pending. |
| 26.3 | 0.4.0 user-tested (reported) | 0.3.0 and 0.4.0 example flows passed; 0.5.0 pending. |
| Other versions | Unsupported | No compatibility promise yet. |

The official Zeus documentation currently presents a shared modding API reference for 26.2 and 26.3. That does **not** replace testing against both clients.

## Repository layout

```text
EaglerModAPI/
├── metadata.json
├── main.lua
├── src/
│   ├── core/
│   ├── compat/
│   │   └── versions/
│   └── modules/
├── examples/
├── docs/
└── tests/
```

## Automated builds

GitHub Actions automatically validates the metadata and builds both installable ZIPs on pushes to `main`, pull requests targeting `main`, and manual workflow runs. Open the repository's **Actions** tab, select **Build Zeus mod packages**, open a successful run, and download its artifact named `EaglerModAPI-packages-<commit>`. The artifact contains both ZIPs and `SHA256SUMS.txt`, and is retained for 30 days.

To publish permanent versioned download assets, update the version in both mod metadata files, then push a matching tag such as `v0.3.0`. The workflow will create a GitHub Release containing both ZIPs and their checksums. See [docs/BUILDING.md](docs/BUILDING.md) for details.

To test the current 0.5.0 development build, download the newest successful build artifact from the [GitHub Actions workflow](https://github.com/Untitled-2026/EaglerModAPI/actions/workflows/build-mods.yml). Ordinary CI runs do not overwrite the 0.1.0 preview downloads.

## Install and test in Eaglercraft

1. For the latest 0.5.0 test, open the [GitHub Actions workflow](https://github.com/Untitled-2026/EaglerModAPI/actions/workflows/build-mods.yml), select the newest successful run, and download its `EaglerModAPI-packages-...` artifact.
2. Extract the outer artifact ZIP. It contains two mod ZIPs and a checksum file; do not extract the individual mod ZIPs.
3. Open Eaglercraft **26.3** and go to the title screen.
4. Open **Mods** → **Import mod** → **Choose a .zip or .lua file...**.
5. Select `EaglerModAPI-0.5.0.zip`, review the install prompt, and click **Install**.
6. In the Mods list, make sure **EaglerModAPI** is enabled.
7. Repeat the import steps with `EaglerModAPI-TestMod-0.5.0.zip`.
8. Make sure **EaglerModAPI Test Mod** is enabled. It lists EaglerModAPI as a dependency.
9. Enter a **singleplayer** world. The HUD should show player/world details and a health bar. Run `/emapi` and `/emapi ping` to test the Commands and Events APIs.
10. Run `/emapi notify`, `/emapi timer`, `/emapi clock`, `/emapi repeat` and `/emapi stop` to test the UI and Timer APIs. Open the test mod's Settings page to change HUD settings and its keybind; press the configured key to toggle the HUD, then use `/emapi prefs` and `/emapi count` to inspect preferences and saved state.
11. Check the test mod's **Log** if anything is missing or an error appears, then repeat in Eaglercraft **26.2**. Record exact client builds and browser versions in [tests/COMPATIBILITY-MATRIX.md](tests/COMPATIBILITY-MATRIX.md).

**Command input note:** Eaglercraft may show an “unknown or misspelled command” hint while a local mod command is being typed. If the command is registered, it can still run when submitted. The documented Zeus command API does not currently expose a chat autocomplete/suggestion registration function.

**Important:** Zeus mods run on the title screen, in menus, in singleplayer and LAN worlds, and on servers. On a server, a mod runs locally for you; other players do not see its HUD or know it is running. Mod-added blocks, items and mobs only work in singleplayer and LAN worlds you open. Follow each server's rules. Only install packages you trust.

For the official step-by-step import guide, see [Install and share mods](https://eaglercraft.com/docs/modding/install-and-share). For the package format and dependency rules, see [Zeus packaging](https://eaglercraft.com/docs/modding/packaging).

## Using the API from another mod

Install and enable EaglerModAPI, then declare it as a dependency in the other mod's `metadata.json`:

```json
{
  "dependencies": {
    "eaglermodapi": "*"
  }
}
```

Retrieve the exported API from Lua:

```lua
local EaglerModAPI = mods.get("eaglermodapi")
assert(EaglerModAPI, "EaglerModAPI must be installed and enabled")
```

For the current consumer example's source files, see [examples/consumer](examples/consumer).

## API surface

The 0.5.0 development API includes:

- `EaglerModAPI.getInfo()` — API and detected game-version information.
- `EaglerModAPI.compat` — supported-version and capability checks.
- `EaglerModAPI.player` — normalized identity, position, movement, health, hunger, XP, status, inventory and player-action helpers.
- `EaglerModAPI.world` — normalized block, light, biome, time, weather, player-list and nearby-entity helpers.
- `EaglerModAPI.hud` — named HUD panels, built-in HUD controls, and drawing helpers for text, panels and bars.
- `EaglerModAPI.events` — event listeners, one-time listeners, removal and custom events.
- `EaglerModAPI.commands` — register, remove and list local mod commands.
- `EaglerModAPI.timer` — schedule one-shot and repeating callbacks, cancel timers, and read timer time/ticks.
- `EaglerModAPI.ui` — show popup notifications through Zeus.
- `EaglerModAPI.settings` — create player-editable settings pages and react to setting changes.
- `EaglerModAPI.keys` — register configurable keybinds and inspect keyboard state/key codes.
- `EaglerModAPI.storage` — read and write persistent per-mod data.

The public functions are documented in [docs/API.md](docs/API.md). The exact capability list is discovered at runtime; a capability is only reported when the corresponding Zeus function exists. The 0.3.0 example flow was reported working in both supported clients. That confirms the tested example paths, not every individual helper.

## Development principles

1. Keep game-version detection separate from feature detection.
2. Prefer capability detection over version-number branching.
3. Keep version adapters small and limited to verified differences.
4. Normalize awkward return shapes at the EaglerModAPI boundary (for example, Zeus position functions return three Lua values; EaglerModAPI returns a named table).
5. Document whether each feature is documented, manually tested, or experimental.
6. Do not claim support for engine-level features that the Zeus sandbox cannot expose.

## Official references

- [Eaglercraft modding documentation](https://dev.eaglercraft.com/docs/modding)
- [Zeus API reference](https://dev.eaglercraft.com/docs/modding/api)
- [Packaging and dependencies](https://dev.eaglercraft.com/docs/modding/packaging)
- [How mods run](https://dev.eaglercraft.com/docs/modding/how-mods-run)

## License

No license has been selected yet. Until one is added, the repository should be treated as **all rights reserved**; do not assume the code is available for reuse.
