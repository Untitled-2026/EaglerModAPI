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

## 0.6.0 Game, Camera, Mouse and Sound test

1. Download the newest successful **Build Zeus mod packages** artifact from GitHub Actions.
2. Extract the outer artifact ZIP; do not extract either mod ZIP inside it.
3. Import and enable EaglerModAPI 0.6.0, then import and enable EaglerModAPI Test Mod 0.6.0.
4. Enter a world and confirm the HUD adds FPS and camera yaw/pitch values.
5. Run `/emapi inspect` and check that it prints FPS, screen ID, screen size, camera position/rotation and mouse position.
6. Move the mouse and run `/emapi inspect` again; confirm the mouse coordinates change.
7. Run `/emapi sound` and confirm the experience-orb pickup sound plays.
8. Run `/emapi chat`; confirm chat opens with `/emapi ping` prefilled. Press Enter only if you intend to run that command.
9. Run `/emapi optioncheck`; confirm it reads the current FOV and writes the same value back without changing the setting.
10. In a small temporary test mod, call `API.camera.project(x, y, z)` on a position in front of the camera and confirm the returned screen coordinates; also confirm a position behind the camera can return `nil`.
11. Check the Mods menu Logs for errors.
12. Repeat all checks in Eaglercraft 26.2 and 26.3 separately.

## 0.5.1 Settings, Keybinds and Storage test

1. Download the newest successful **Build Zeus mod packages** artifact from GitHub Actions.
2. Extract the outer artifact ZIP; do not extract either mod ZIP inside it.
3. Import and enable EaglerModAPI 0.5.1, then import and enable EaglerModAPI Test Mod 0.5.1.
4. Confirm **EaglerModAPI** itself does not have the test mod's settings. Open Mods → EaglerModAPI Test Mod → Settings and confirm the HUD controls appear there.
5. Change the HUD title, position, width and title color. Confirm the HUD updates to match.
6. Turn off **Show status HUD** in Settings and confirm the panel disappears; turn it back on.
7. Find **Toggle status HUD** in the same settings page and change its key from H to another key.
8. Return to a world, press the newly assigned key and confirm it toggles the HUD.
9. Run `/emapi prefs` to check the current preferences and key assignment.
10. Run `/emapi count`, toggle the HUD several times, and confirm the saved count increases.
11. Reload or disable and re-enable the test mod, then run `/emapi count` again to confirm the saved value remains.
12. Press **Reset saved HUD toggle count** in Settings or run `/emapi resetcount`; confirm the count returns to zero.
13. Check both Mods menu Logs for errors.
14. Repeat all checks in Eaglercraft 26.2 and 26.3 separately.

## Command input hint

When typing a registered local mod command, Eaglercraft may show an "unknown or misspelled command" hint before Enter is pressed. Submit the command to confirm it executes. The current documented Zeus API does not provide a supported autocomplete/suggestion registration function, so this hint is a client UI limitation rather than a command dispatch failure.

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

Record results in `COMPATIBILITY-MATRIX.md`. Include client build, browser, test date, result, and notes. Mark 0.5.1 as verified only after its Settings, Keybinds and Storage checklist has passed on that client version. Mark individual helper methods as tested only after they have been checked directly.
