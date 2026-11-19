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

    API.hud.drawText(ctx, "EaglerModAPI " .. info.version .. " | " .. display(name), 10, 10, {
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

local repeatingTimer = nil

-- Clean up the repeating timer if this mod is unloaded.
API.events.on("unload", function()
    if repeatingTimer then
        API.timer.cancel(repeatingTimer)
        repeatingTimer = nil
    end
end)

-- Demonstrate mod-local commands for all current example modules.
API.commands.register("emapi", function(args, raw)
    local command = args[1]

    if command == "ping" then
        API.events.emit("eaglermodapi_example:ping", "Custom event fired successfully!")
        return
    end

    if command == "notify" then
        local ok, err = API.ui.notify("EaglerModAPI notification", "The UI notification helper works.")
        if ok then
            chat.print("Notification displayed.")
        else
            chat.print("Notification failed: " .. tostring(err))
        end
        return
    end

    if command == "timer" then
        local handle, err = API.timer.after(2, function()
            local ok, notifyError = API.ui.notify("EaglerModAPI timer", "The 2-second timer fired.")
            if not ok then
                chat.print("Timer notification failed: " .. tostring(notifyError))
            end
        end)
        if handle then
            chat.print("A notification is scheduled for about two seconds from now.")
        else
            chat.print("Could not schedule timer: " .. tostring(err))
        end
        return
    end

    if command == "repeat" then
        if repeatingTimer and API.timer.isActive(repeatingTimer) then
            chat.print("A repeating timer is already running. Use /emapi stop to cancel it.")
            return
        end

        local handle, err = API.timer.every(5, function()
            API.ui.notify("EaglerModAPI repeating timer", "Five seconds have passed.")
        end)
        if handle then
            repeatingTimer = handle
            chat.print("Repeating notification started. Use /emapi stop to cancel it.")
        else
            chat.print("Could not start repeating timer: " .. tostring(err))
        end
        return
    end

    if command == "stop" then
        if not repeatingTimer then
            chat.print("No repeating timer is running.")
            return
        end

        local ok, err = API.timer.cancel(repeatingTimer)
        if ok then
            repeatingTimer = nil
            chat.print("Repeating timer cancelled.")
        else
            chat.print("Could not cancel timer: " .. tostring(err))
        end
        return
    end

    if command == "clock" then
        local currentTime, timeError = API.timer.time()
        local currentTicks, ticksError = API.timer.ticks()
        chat.print("Timer time: " .. display(currentTime or timeError))
        chat.print("Game ticks: " .. display(currentTicks or ticksError))
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
    chat.print("Try /emapi notify, timer, repeat, stop or clock; use /emapi ping for events.")
end, "Test the EaglerModAPI modules with local subcommands")
