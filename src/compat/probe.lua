local Probe = {}

local function hasFunction(namespace, functionName)
    return type(namespace) == "table"
        and type(namespace[functionName]) == "function"
end

function Probe.all()
    return {
        gameVersion = type(game) == "table" and game.version ~= nil,
        playerExists = hasFunction(player, "exists"),
        playerPosition = hasFunction(player, "pos"),
        playerName = hasFunction(player, "name"),
        worldExists = hasFunction(world, "exists"),
        worldBlock = hasFunction(world, "block"),
        hudAdd = hasFunction(hud, "add"),
        eventsOn = hasFunction(events, "on"),
        timerAfter = hasFunction(timer, "after"),
        commandsRegister = hasFunction(commands, "register"),
        uiNotify = hasFunction(ui, "notify"),
        modExports = type(mod) == "table" and type(mod.export) == "table",
        otherMods = hasFunction(mods, "get")
    }
end

function Probe.has(name)
    local capabilities = Probe.all()
    return capabilities[name] == true
end

return Probe
