# Testing

EaglerModAPI uses manual in-game tests because Zeus code runs inside the Eaglercraft client. GitHub Actions checks Lua 5.4 syntax, package metadata and ZIP integrity, but it cannot replace testing in the game.

## Before testing

- Use a separate test world.
- Keep a backup of any world used for testing.
- Record the exact Eaglercraft build and browser used.
- Test Player and World queries in a world; event and command APIs can also be checked from the title screen where appropriate.
- Zeus mods can run on the title screen, in menus, in singleplayer, LAN worlds and on servers. Mod-added blocks/items/mobs are restricted to singleplayer and LAN worlds you open. Follow each server's rules.

## 0.3.0 HUD, Events and Commands test (main example flow reported passing)

1. Download the newest successful **Build Zeus mod packages** artifact from GitHub Actions.
2. Extract the outer artifact ZIP; do not extract either mod ZIP inside it.
3. Import and enable EaglerModAPI first.
4. Import and enable EaglerModAPI Test Mod.
5. Confirm chat reports EaglerModAPI 0.3.0 and the game version.
6. Enter a singleplayer world.
7. Confirm the HUD panel appears with coordinates, player/world information and a health bar.
8. Move around and confirm the position text updates.
9. Run `/emapi` and confirm the command prints API/version and position information.
10. Run `/emapi ping` and confirm the custom event message appears in chat.
11. Leave the world and join again; confirm the `world_join` event message appears.
12. Open each mod's Log and check for load errors.
13. Repeat all checks in Eaglercraft 26.2 and 26.3 separately.

The main 0.3.0 example flow was reported passing in both target clients on 2026-11-18. Exact client build and browser versions were not recorded. The additional checks below remain useful for testing individual helper methods beyond the main example.

## 0.4.0 Timer and UI notification test

1. Download the newest successful **Build Zeus mod packages** artifact from GitHub Actions.
2. Extract the outer artifact ZIP; do not extract either mod ZIP inside it.
3. Import and enable EaglerModAPI 0.4.0, then import and enable EaglerModAPI Test Mod 0.4.0.
4. Confirm chat reports EaglerModAPI 0.4.0.
5. Run `/emapi notify` and confirm the popup notification appears.
6. Run `/emapi timer`; confirm the scheduled message appears after about two seconds.
7. Run `/emapi clock`; confirm timer time and game tick values are printed.
8. Run `/emapi repeat`; confirm a notification appears about every five seconds.
9. Run `/emapi stop`; confirm the repeating timer stops and no more notifications arrive.
10. Check both Mods menu Logs for load errors.
11. Repeat all checks in Eaglercraft 26.2 and 26.3 separately.

## Additional API checks

These checks can be done with a small temporary test mod or in the in-game editor:

- Register a named HUD panel, then remove it with `API.hud.remove(name)`.
- Check `API.hud.elements()` and `API.hud.isHidden("crosshair")`.
- Register an event listener, trigger its event, then remove the listener with `API.events.off(handle)`.
- Register a one-time event listener with `API.events.once` and confirm it only fires once.
- Register a test command and remove it with `API.commands.unregister`.
- Check that invalid event names, callback types, command names and HUD dimensions return useful errors.

## Failure cases

- Disable EaglerModAPI and confirm the dependent example does not load.
- Load the library on the title screen; world/player queries that require a world should return unavailable rather than crash.
- Confirm an unsupported game version is reported as unsupported.
- Check the Mods menu Log for the first error before reporting a failure.

## Reporting

Record results in `COMPATIBILITY-MATRIX.md`. Include client build, browser, test date, result, and notes. Mark 0.4.0 as verified only after its Timer and UI notification checklist has passed on that client version. Mark individual helper methods as tested only after they have been checked directly.
