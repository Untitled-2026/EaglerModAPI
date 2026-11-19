# Compatibility test matrix

| Client | API version | Client build | Browser | Date tested | Result | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Eaglercraft 26.2 | 0.2.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Library and expanded Player/World example HUD confirmed working. |
| Eaglercraft 26.3 | 0.2.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Library and expanded Player/World example HUD confirmed working. |
| Eaglercraft 26.2 | 0.3.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Main example flow: HUD updates, /emapi, /emapi ping, and world-join event message. |
| Eaglercraft 26.3 | 0.3.0 | Not recorded | Not recorded | 2026-11-18 | Pass (user-reported) | Main example flow: HUD updates, /emapi, /emapi ping, and world-join event message. |
| Eaglercraft 26.2 | 0.4.0 | Not tested | Not tested | — | Pending | Timer and UI notification modules require in-game testing. |
| Eaglercraft 26.3 | 0.4.0 | Not tested | Not tested | — | Pending | Timer and UI notification modules require in-game testing. |

The 0.2.0 and 0.3.0 results are user-reported. Exact client build numbers and browser versions were not supplied. GitHub Actions passing confirms Lua syntax and package integrity; it does not certify behavior inside the game. Individual helper methods should only be marked tested after they have been checked directly.
