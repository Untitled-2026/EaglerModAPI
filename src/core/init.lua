local compat = require("src.compat.init")
local player = require("src.modules.player")
local world = require("src.modules.world")

local API = {
    name = "EaglerModAPI",
    version = "0.1.0",
    compat = compat,
    player = player,
    world = world
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
