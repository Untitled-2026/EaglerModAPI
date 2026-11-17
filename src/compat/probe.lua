local Probe = {}

local function hasFunction(namespace, functionName)
    return type(namespace) == "table"
        and type(namespace[functionName]) == "function"
end

function Probe.all()
    return {
        gameVersion = type(game) == "table" and game.version ~= nil,

        playerExists = hasFunction(player, "exists"),
        playerName = hasFunction(player, "name"),
        playerUUID = hasFunction(player, "uuid"),
        playerPosition = hasFunction(player, "pos"),
        playerCoordinates = hasFunction(player, "x")
            and hasFunction(player, "y")
            and hasFunction(player, "z"),
        playerBlockPosition = hasFunction(player, "blockPos"),
        playerEyePosition = hasFunction(player, "eyePos"),
        playerVelocity = hasFunction(player, "velocity"),
        playerSetVelocity = hasFunction(player, "setVelocity"),
        playerRotation = hasFunction(player, "yaw")
            and hasFunction(player, "pitch"),
        playerSetRotation = hasFunction(player, "setRotation"),
        playerFacing = hasFunction(player, "facing"),
        playerHealth = hasFunction(player, "health"),
        playerMaxHealth = hasFunction(player, "maxHealth"),
        playerFood = hasFunction(player, "food"),
        playerSaturation = hasFunction(player, "saturation"),
        playerArmor = hasFunction(player, "armor"),
        playerXP = hasFunction(player, "xpLevel")
            and hasFunction(player, "xpProgress"),
        playerMovementState = hasFunction(player, "isOnGround")
            and hasFunction(player, "isSneaking")
            and hasFunction(player, "isSprinting")
            and hasFunction(player, "isSwimming")
            and hasFunction(player, "isFlying"),
        playerSetSprinting = hasFunction(player, "setSprinting"),
        playerGamemode = hasFunction(player, "gamemode"),
        playerDimension = hasFunction(player, "dimension"),
        playerBiome = hasFunction(player, "biome"),
        playerItems = hasFunction(player, "heldItem")
            and hasFunction(player, "offhandItem"),
        playerInventory = hasFunction(player, "inventory"),
        playerEffects = hasFunction(player, "effects"),
        playerSelectSlot = hasFunction(player, "selectedSlot")
            and hasFunction(player, "selectSlot"),
        playerJump = hasFunction(player, "jump"),
        playerSwing = hasFunction(player, "swing"),
        playerLookingAt = hasFunction(player, "lookingAt"),

        worldExists = hasFunction(world, "exists"),
        worldBlock = hasFunction(world, "block"),
        worldLight = hasFunction(world, "light"),
        worldBiome = hasFunction(world, "biome"),
        worldTime = hasFunction(world, "time"),
        worldDay = hasFunction(world, "day"),
        worldTimeOfDay = hasFunction(world, "timeOfDay"),
        worldWeather = hasFunction(world, "weather"),
        worldPlayers = hasFunction(world, "players"),
        worldEntities = hasFunction(world, "entities"),

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
