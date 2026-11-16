# EaglerModAPI

**A cross-version helper framework for Eaglercraft Zeus mods.**

EaglerModAPI is a Lua library mod that sits on top of the built-in Zeus modding system. Its goal is to give mod developers a consistent, documented interface across Eaglercraft 26.2 and 26.3, while adding reusable helpers that Zeus does not provide directly.

> **Status:** Early development (0.1.0). The structure and initial API are being established. Runtime testing in both game versions is still required.

## Goals

- **Write once:** let mod authors use one EaglerModAPI interface across supported Eaglercraft versions.
- **Compatibility:** detect the running game version and inspect the Zeus functions actually available.
- **Honest feature support:** use a shared implementation when the documented Zeus API is the same; add a version-specific adapter only when a real difference is verified.
- **Useful additions:** build higher-level helpers and modules on top of Zeus.
- **Safe fallbacks:** report unsupported features clearly instead of silently pretending they work.

## Current support

| Eaglercraft | Status | Notes |
| --- | --- | --- |
| 26.2 | Documentation target | Public Zeus docs cover this version; runtime validation pending. |
| 26.3 | Documentation target | Public Zeus docs cover this version; runtime validation pending. |
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

## Installing / using during development

1. Package this repository's mod files as a ZIP with `metadata.json` at the package root.
2. Import the ZIP through the Eaglercraft Mods menu in a supported client.
3. Enable **EaglerModAPI**.
4. For a mod that uses the library, add this dependency to its `metadata.json`:

   ```json
   {
     "dependencies": {
       "eaglermodapi": "*"
     }
   }
   ```

5. In that mod's Lua code, retrieve the exported API:

   ```lua
   local EaglerModAPI = mods.get("eaglermodapi")
   assert(EaglerModAPI, "EaglerModAPI must be installed and enabled")
   ```

For the current example consumer, see [examples/consumer](examples/consumer).

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
