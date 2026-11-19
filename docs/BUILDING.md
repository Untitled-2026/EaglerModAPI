# Automated builds

EaglerModAPI uses GitHub Actions to check the Lua source, validate package metadata and create installable Zeus ZIP files.

## What the workflow builds

The workflow creates:

- `EaglerModAPI-<version>.zip` — the library package. It contains root-level `metadata.json` and `main.lua`, plus the `src/` Lua modules.
- `EaglerModAPI-TestMod-<version>.zip` — the example consumer mod. It contains root-level `metadata.json` and `main.lua`, and declares EaglerModAPI as a dependency.
- `SHA256SUMS.txt` — SHA-256 checksums for both ZIP files.

The workflow installs Lua 5.4 and runs `luac5.4 -p` against the library entry point and all Lua source/example files. This checks syntax without executing the code inside Eaglercraft.

The packaging script is `scripts/build_packages.py`. It uses only Python's standard library, validates both metadata files, checks the API dependency and matching versions, creates the packages, and verifies the generated ZIP archives.

## When builds run

The **Build Zeus mod packages** workflow runs when:

- a commit is pushed to `main`;
- a pull request targeting `main` is opened or updated;
- a maintainer manually runs the workflow from the GitHub Actions tab;
- a version tag matching `v*` is pushed.

For ordinary pushes, pull requests and manual runs, the downloadable packages appear under the completed workflow run's **Artifacts** section. Build artifacts are retained for 30 days.

## Publishing a versioned release

1. Update the `version` field in both mod `metadata.json` files to the same release version.
2. Commit and push those changes to `main`.
3. Create and push a matching version tag. For example, for version `0.3.0`:

   ```bash
   git tag v0.3.0
   git push origin v0.2.0
   ```

4. GitHub Actions validates that the tag version matches the metadata version, builds both packages, and creates a GitHub Release with the two ZIP files and checksum file attached.

The release job receives `contents: write` permission only because creating a GitHub Release requires it. The normal build job has read-only repository permissions.

## Local build

From the repository root, run:

```bash
python3 scripts/build_packages.py
```

The packages are written to `dist/`. To check that a release tag matches the metadata version:

```bash
python3 scripts/build_packages.py --expected-version 0.3.0
```
