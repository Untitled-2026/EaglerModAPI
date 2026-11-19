local compat = require("src.compat.init")
local player = require("src.modules.player")
local world = require("src.modules.world")
local hud = require("src.modules.hud")
local events = require("src.modules.events")
local commands = require("src.modules.commands")
local timer = require("src.modules.timer")
local ui = require("src.modules.ui")

local API = {
    name = "EaglerModAPI",
    version = "0.4.0",
    compat = compat,
    player = player,
    world = world,
    hud = hud,
    events = events,
    commands = commands,
    timer = timer,
    ui = ui
}

function API.getInfo()
    return {
        name = API.name,
        version = API.version,
        gameVersion = compat.getGameVersion(),
        supported = compat.isSupported(),
        adapter = compat.getAdapterId(),
        verification = compat.getVerificationStatus()
    }
end

function API.getCapabilities()
    return compat.getCapabilities()
end

function API.hasCapability(name)
    return compat.has(name)
end

return API
