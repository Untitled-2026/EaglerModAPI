# Development guide

## Editing

- Keep reusable runtime code under `src/`.
- Keep the Zeus package entry point in the repository root as `main.lua`.
- Keep package metadata in root `metadata.json`.
- Keep consumer examples separate from the library package entry point.
- Use Lua 5.4 syntax supported by Zeus.

## Adding a helper

1. Confirm the underlying Zeus function in the official API reference.
2. Add a small module under `src/modules/`.
3. Normalize return values and provide useful error codes.
4. Probe the underlying function before calling it when the function may be absent.
5. Document the public function in `docs/API.md`.
6. Add a focused example or manual test.

## Releasing a package

A Zeus package is a ZIP containing `metadata.json`, `main.lua`, and the Lua files loaded by `require`. The metadata must list the correct supported Minecraft versions and Zeus API version.

The GitHub repository archive is convenient for development, but future releases should use a clean release ZIP containing only the packaged mod files (not docs, tests or repository extras).

## Testing status

Do not mark a version as runtime-tested until the checklist in `tests/README.md` has been completed in that exact game version.
