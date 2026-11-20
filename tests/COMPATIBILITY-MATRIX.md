# Compatibility test matrix

| Client | API version | Client build | Browser | Date tested | Result | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Eaglercraft 26.2 | 0.2.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Library and expanded Player/World example HUD confirmed working. |
| Eaglercraft 26.3 | 0.2.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Library and expanded Player/World example HUD confirmed working. |
| Eaglercraft 26.2 | 0.3.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Main example flow: HUD updates, /emapi, /emapi ping, and world-join event message. |
| Eaglercraft 26.3 | 0.3.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Main example flow: HUD updates, /emapi, /emapi ping, and world-join event message. |
| Eaglercraft 26.2 | 0.4.0 | Not recorded | Not recorded | 2026-11-19 | Pass (user-reported) | Timer, UI notification and test-mod example reported working. |
| Eaglercraft 26.3 | 0.4.0 | Not recorded | Not recorded | 2026-11-19 | Pass (user-reported) | Timer, UI notification and test-mod example reported working. |

| Eaglercraft 26.2 | 0.5.0 | Not recorded | Not recorded | 2026-11-19 | Issue reported | Settings page appeared under EaglerModAPI instead of EaglerModAPI Test Mod; remaining tests not completed. |
| Eaglercraft 26.3 | 0.5.0 | Not tested | Not tested | — | Not tested | First-step issue reported in the 26.3 test; no separate 26.2 result was supplied. |

| Eaglercraft 26.2 | 0.5.1 | Not tested | Not tested | — | Pending | Verify Settings, Keybinds and Storage are owned by the consumer test mod. |
| Eaglercraft 26.3 | 0.5.1 | Not tested | Not tested | — | Pending | Verify Settings, Keybinds and Storage are owned by the consumer test mod. |

The 0.2.0, 0.3.0 and 0.4.0 results are user-reported. Exact client build numbers and browser versions were not supplied. GitHub Actions passing confirms Lua syntax and package integrity; it does not certify behavior inside the game. Exact client build numbers and browser versions were not supplied for the 0.4.0 test. Individual helper methods should only be marked tested after they have been checked directly.
