# Testing

The first release uses manual in-game tests because Zeus code runs inside the Eaglercraft client.

## Before testing

- Use a separate test world.
- Keep a backup of any world used for testing.
- Test only in singleplayer; Zeus mods pause when connecting to servers or LAN worlds.
- Record the exact Eaglercraft build and browser used.

## Basic test

1. Import and enable EaglerModAPI.
2. Import and enable the example consumer mod.
3. Confirm the example mod reports the API and game versions in chat.
4. Enter a singleplayer world.
5. Confirm the HUD displays the player's X, Y and Z coordinates.
6. Return to the title screen and confirm the mods resume/load without errors.
7. Open each mod's Log and check for load errors.
8. Repeat on Eaglercraft 26.2 and 26.3 separately.

## Failure cases

- Disable EaglerModAPI and confirm the dependent example does not load.
- Test the library on a title screen before entering a world; player/world helpers should return an unavailable result rather than crash.
- Confirm an unsupported game version is reported as unsupported.

## Reporting

Record results in `COMPATIBILITY-MATRIX.md`. Include client build, browser, test date, result, and notes. Do not mark a whole version as tested based on a single successful function call.
