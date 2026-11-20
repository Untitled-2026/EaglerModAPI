local compat = require("src.compat.init")
local player = require("src.modules.player")
local world = require("src.modules.world")
local hud = require("src.modules.hud")
local events = require("src.modules.events")
local commands = require("src.modules.commands")
local timer = require("src.modules.timer")
local ui = require("src.modules.ui")
local settingsModule = require("src.modules.settings")
local keysModule = require("src.modules.keys")
local storageModule = require("src.modules.storage")
local gameModule = require("src.modules.game")
local cameraModule = require("src.modules.camera")
local mouseModule = require("src.modules.mouse")
local soundModule = require("src.modules.sound")

local API = {
    name = "EaglerModAPI",
    version = "0.6.0",
    compat = compat,
    player = player,
    world = world,
    hud = hud,
    events = events,
    commands = commands,
    timer = timer,
    ui = ui,
    settings = settingsModule,
    keys = keysModule,
    storage = storageModule,
    game = gameModule,
    camera = cameraModule,
    mouse = mouseModule,
    sound = soundModule
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

-- Bind per-mod Zeus namespaces so helper registrations and saved data belong
-- to the consumer mod rather than EaglerModAPI itself.
function API.forMod(context)
    if type(context) ~= "table" then
        return nil, "mod_context_must_be_a_table"
    end

    local boundSettings, settingsError = settingsModule.bind(context.settings)
    if not boundSettings then return nil, settingsError end

    local boundKeys, keysError = keysModule.bind(context.keys)
    if not boundKeys then return nil, keysError end

    local boundStorage, storageError = storageModule.bind(context.storage, context.mod)
    if not boundStorage then return nil, storageError end

    local BoundAPI = {}
    for key, value in pairs(API) do
        BoundAPI[key] = value
    end

    BoundAPI.settings = boundSettings
    BoundAPI.keys = boundKeys
    BoundAPI.storage = boundStorage
    return BoundAPI
end

return API
