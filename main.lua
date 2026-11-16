-- EaglerModAPI library entry point.
-- Other mods can access this table with mods.get("eaglermodapi").

local EaglerModAPI = require("src.core.init")

mod.export = EaglerModAPI

mod.log(
    "EaglerModAPI " .. EaglerModAPI.version ..
    " loaded for Eaglercraft " .. EaglerModAPI.compat.getGameVersion()
)
