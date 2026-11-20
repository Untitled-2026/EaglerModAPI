-- Eaglercraft 26.3 adapter descriptor.
-- The official public docs currently describe the same Zeus Lua API for 26.2
-- and 26.3. Keep this descriptor separate so verified differences can be
-- handled here later without duplicating shared module code.

return {
    id = "26.3",
    apiFamily = "zeus-lua",
    documentationStatus = "documented",
    runtimeTestStatus = "0.3.0 and 0.4.0 example flows passed (user-reported 2026-11-19); 0.5.0 settings ownership issue; 0.5.1 context binding pending"
}
