local API = mods.get("eaglermodapi")
assert(API, "Enable the EaglerModAPI dependency before this example")

local info = API.getInfo()
chat.print("EaglerModAPI " .. info.version .. " | Eaglercraft " .. info.gameVersion)

local function display(value)
    if value == nil then
        return "n/a"
    end
    return tostring(value)
end

-- Demonstrate the higher-level HUD API and the built-in Zeus drawing context.
API.hud.add("eaglermodapi_example", function(ctx)
    local position = API.player.getPosition()
    if not position then
        API.hud.drawPanel(ctx, 4, 4, 224, 28, {
            background = "#99000000",
            border = "#55FFFFFF"
        })
        API.hud.drawText(ctx, "EaglerModAPI: waiting for player", 10, 10, {
            color = "#FFCC55"
        })
        return
    end

    local name = API.player.getName()
    local health = API.player.getHealth()
    local maxHealth = API.player.getMaxHealth()
    local food = API.player.getFood()
    local gamemode = API.player.getGamemode()
    local dimension = API.player.getDimension()
    local biome = API.player.getBiome()
    local day = API.world.getDay()
    local timeOfDay = API.world.getTimeOfDay()
    local weather = API.world.getWeather()

    API.hud.drawPanel(ctx, 4, 4, 254, 91, {
        background = "#99000000",
        border = "#6677AAFF"
    })

    API.hud.drawText(ctx, "EaglerModAPI 0.3.0 | " .. display(name), 10, 10, {
        color = "#55FF55"
    })
    API.hud.drawText(
        ctx,
        string.format("XYZ: %.1f / %.1f / %.1f",
            position.x, position.y, position.z),
        10, 21
    )
    API.hud.drawText(
        ctx,
        "Health: " .. display(health) .. "/" .. display(maxHealth)
            .. "  Food: " .. display(food),
        10, 32
    )

    if type(health) == "number" and type(maxHealth) == "number" and maxHealth > 0 then
        API.hud.drawBar(ctx, 10, 44, 110, 6, health, maxHealth, {
            background = "#AA333333",
            fill = "#55CC55",
            border = "#AAFFFFFF"
        })
    end

    API.hud.drawText(
        ctx,
        "Mode: " .. display(gamemode) .. " | " .. display(dimension),
        10, 55
    )
    API.hud.drawText(
        ctx,
        "Biome: " .. display(biome) .. " | " .. display(weather),
        10, 66
    )
    API.hud.drawText(
        ctx,
        "Day: " .. display(day) .. " | Time: " .. display(timeOfDay),
        10, 77
    )
end)

-- Demonstrate ordinary game events and custom events shared with other mods.
API.events.on("world_join", function(event)
    local mode = event and event.singleplayer and "singleplayer" or "multiplayer/LAN"
    chat.print("[EaglerModAPI] Joined a world (" .. mode .. ")")
end)

API.events.on("eaglermodapi_example:ping", function(message)
    chat.print("[EaglerModAPI event] " .. tostring(message))
end)

-- Demonstrate mod-local commands. These commands are not sent to the server.
API.commands.register("emapi", function(args, raw)
    if args[1] == "ping" then
        API.events.emit("eaglermodapi_example:ping", "Custom event fired successfully!")
        return
    end

    local current = API.getInfo()
    local pos = API.player.getPosition()

    chat.print("EaglerModAPI " .. current.version .. " | Eaglercraft " .. current.gameVersion)
    if pos then
        chat.print(string.format("Position: %.1f, %.1f, %.1f", pos.x, pos.y, pos.z))
    else
        chat.print("Position unavailable (join a world first).")
    end
    chat.print("Use /emapi ping to test the custom event API.")
end, "Show API information; use /emapi ping to test events")
