# Testing

EaglerModAPI uses manual in-game tests because Zeus code runs inside the Eaglercraft client. The build workflow validates packaging and metadata, but it cannot replace testing functions inside the game.

## Before testing

- Use a separate test world.
- Keep a backup of any world used for testing.
- Test the Player and World query helpers in a singleplayer world so the results are predictable.
- Record the exact Eaglercraft build and browser used.
- Zeus mods can also run on the title screen, in menus, in LAN worlds and on servers. On servers, their HUD and local behavior are only visible to the local player; mod-added blocks, items and mobs work only in singleplayer and LAN worlds you open.

## 0.2.0 Player and World test

1. Build or download the API and Test Mod ZIPs from the latest successful GitHub Actions run.
2. Import and enable EaglerModAPI first.
3. Import and enable EaglerModAPI Test Mod.
4. Confirm the test mod reports the API and game versions in chat.
5. Enter a singleplayer world.
6. Confirm the HUD displays coordinates, player name, health, hunger, gamemode, dimension, biome, weather and world time.
7. Open each mod's Log and check for load errors.
8. Check that the HUD updates when the player moves and when the world time changes.
9. Repeat on Eaglercraft 26.2 and 26.3 separately.

## Failure cases

- Disable EaglerModAPI and confirm the dependent example does not load.
- Load the library on the title screen before entering a world; player/world helpers that require a world should return an unavailable result rather than crash.
- Confirm `getEntities` rejects a zero or negative radius.
- Confirm `selectSlot` rejects values outside 1 to 9 and non-integer values.
- Confirm an unsupported game version is reported as unsupported.

## Reporting

Record results in `COMPATIBILITY-MATRIX.md`. Include client build, browser, test date, result, and notes. Mark the new 0.2.0 functions as tested only after completing the full checklist on that client version.
