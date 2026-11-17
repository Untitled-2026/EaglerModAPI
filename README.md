# EaglerModAPI

**A cross-version helper framework for Eaglercraft Zeus mods.**

EaglerModAPI is a Lua library mod that sits on top of the built-in Zeus modding system. Its goal is to give mod developers a consistent, documented interface across Eaglercraft 26.2 and 26.3, while adding reusable helpers that Zeus does not provide directly.

> **Status:** Early development (0.1.0). The initial library and coordinate HUD example have been reported working in Eaglercraft 26.2 and 26.3. Broader feature testing is still required.

## Goals

- **Write once:** let mod authors use one EaglerModAPI interface across supported Eaglercraft versions.
- **Compatibility:** detect the running game version and inspect the Zeus functions actually available.
- **Honest feature support:** use a shared implementation when the documented Zeus API is the same; add a version-specific adapter only when a real difference is verified.
- **Useful additions:** build higher-level helpers and modules on top of Zeus.
- **Safe fallbacks:** report unsupported features clearly instead of silently pretending they work.

## Current support

| Eaglercraft | Status | Notes |
| --- | --- | --- |
| 26.2 | User-tested (reported) | Core library and coordinate HUD example reported working; exact client build/browser not recorded. |
| 26.3 | User-tested (reported) | Core library and coordinate HUD example reported working; exact client build/browser not recorded. |
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

## Downloads

These are ready-to-import Zeus packages (not the full GitHub source archive):

- **[EaglerModAPI 0.1.0 — library](https://raw.githubusercontent.com/Untitled-2026/EaglerModAPI/main/downloads/EaglerModAPI-0.1.0.zip)**
- **[EaglerModAPI Test Mod 0.1.0 — coordinate HUD example](https://raw.githubusercontent.com/Untitled-2026/EaglerModAPI/main/downloads/EaglerModAPI-TestMod-0.1.0.zip)**

The Test Mod depends on EaglerModAPI, so install and enable the library first. Both packages have been reported working in Eaglercraft 26.2 and 26.3; broader feature testing is still ongoing.

## Automated builds

GitHub Actions automatically validates the metadata and builds both installable ZIPs on pushes to `main`, pull requests targeting `main`, and manual workflow runs. Open the repository's **Actions** tab, select **Build Zeus mod packages**, open a successful run, and download its artifact named `EaglerModAPI-packages-<commit>`. The artifact contains both ZIPs and `SHA256SUMS.txt`, and is retained for 30 days.

To publish permanent versioned download assets, update the version in both mod metadata files, then push a matching tag such as `v0.2.0`. The workflow will create a GitHub Release containing both ZIPs and their checksums. See [docs/BUILDING.md](docs/BUILDING.md) for details.

The links in the Downloads section above are the checked-in 0.1.0 preview packages; ordinary CI runs do not overwrite those files.

## Install and test in Eaglercraft

1. Download both ZIP files above. Do not extract them.
2. Open Eaglercraft **26.3** and go to the title screen.
3. Open **Mods** → **Import mod** → **Choose a .zip or .lua file...**.
4. Select `EaglerModAPI-0.1.0.zip`, review the install prompt, and click **Install**.
5. In the Mods list, make sure **EaglerModAPI** is enabled.
6. Repeat the import steps with `EaglerModAPI-TestMod-0.1.0.zip`.
7. Make sure **EaglerModAPI Test Mod** is enabled. It lists EaglerModAPI as a dependency.
8. Enter a **singleplayer** world. The test mod should display your X, Y and Z coordinates in a HUD line near the top-left corner.
9. If the HUD does not appear, open the test mod's **Log** in the Mods menu and check for an error.
10. Repeat the same test in Eaglercraft **26.2**. Record the exact client build and browser when available in [tests/COMPATIBILITY-MATRIX.md](tests/COMPATIBILITY-MATRIX.md).

**Important:** Zeus mods run in singleplayer and pause when you join a multiplayer server. Importing a mod ZIP runs its code inside the game, so only install packages you trust.

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

## Initial API surface

The first development milestone focuses on:

- `EaglerModAPI.getInfo()` — API and detected game-version information.
- `EaglerModAPI.compat` — supported-version and capability checks.
- `EaglerModAPI.player` — normalized player information.
- `EaglerModAPI.world` — normalized world queries.

The public functions are documented in [docs/API.md](docs/API.md). The exact capability list is discovered at runtime; a capability is only reported when the corresponding Zeus function exists.

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
