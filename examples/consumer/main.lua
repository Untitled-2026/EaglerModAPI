local LibraryAPI = mods.get("eaglermodapi")
assert(LibraryAPI, "Enable the EaglerModAPI dependency before this example")

-- Bind the helpers to this test mod's own Zeus namespaces.
-- This makes settings, keybinds and saved data belong to the test mod.
local API, bindError = LibraryAPI.forMod({
    settings = settings,
    keys = keys,
    storage = storage,
    mod = mod
})
assert(API, bindError or "Could not bind EaglerModAPI to this mod")

local info = API.getInfo()
chat.print("EaglerModAPI " .. info.version .. " | Eaglercraft " .. info.gameVersion)

local function display(value)
    if value == nil then
        return "n/a"
    end
    return tostring(value)
end

-- Register player-editable settings. Zeus displays these in the mod's Settings page.
API.settings.toggle("hudEnabled", {
    label = "Show status HUD",
    description = "Show or hide the player and world information panel.",
    default = true
})

API.settings.choice("hudCorner", {
    label = "HUD corner",
    description = "Choose where the status panel appears.",
    options = { "Top left", "Top right", "Bottom left", "Bottom right" },
    default = "Top left"
})

API.settings.slider("hudWidth", {
    label = "HUD width",
    description = "Change the width of the status panel.",
    min = 230,
    max = 360,
    step = 10,
    default = 254
})

API.settings.text("hudPrefix", {
    label = "HUD title",
    description = "Text shown at the start of the HUD title.",
    default = "EaglerModAPI"
})

API.settings.color("hudTextColor", {
    label = "HUD title color",
    description = "Choose the color used for the HUD title.",
    default = 0xFF55FF55
})

API.settings.toggle("notifyOnToggle", {
    label = "Notify when HUD toggles",
    description = "Show a popup after changing the HUD with its keybind.",
    default = true
})

API.settings.button("resetToggleCount", {
    label = "Reset saved HUD toggle count",
    description = "Set the persistent toggle counter back to zero.",
    onClick = function()
        local ok, err = API.storage.set("hudToggleCount", 0, true)
        if ok then
            API.ui.notify("EaglerModAPI", "Saved toggle counter reset.")
        else
            mod.warn("Could not reset toggle counter: " .. tostring(err))
        end
    end
})

-- Log settings changes for debugging without flooding the chat.
API.settings.onChange(function(key, value, oldValue)
    if key == "hudEnabled" then
        mod.log("HUD visibility changed:", tostring(oldValue), "->", tostring(value))
    end
end)

-- The keybind appears automatically in the mod's Settings page and can be rebound.
API.keys.bind({
    id = "toggle_hud",
    label = "Toggle status HUD",
    description = "Show or hide the EaglerModAPI status panel.",
    default = "h",
    onPress = function()
        local currentlyEnabled = API.settings.get("hudEnabled")
        if currentlyEnabled == nil then currentlyEnabled = true end

        local enabled = not currentlyEnabled
        local ok, err = API.settings.set("hudEnabled", enabled)
        if not ok then
            mod.warn("Could not toggle HUD: " .. tostring(err))
            return
        end

        local count = API.storage.get("hudToggleCount", 0)
        if type(count) ~= "number" then count = 0 end
        local saved, saveError = API.storage.set("hudToggleCount", count + 1, true)
        if not saved then
            mod.warn("Could not save HUD toggle count: " .. tostring(saveError))
        end

        if API.settings.get("notifyOnToggle") ~= false then
            API.ui.notify("EaglerModAPI", enabled and "HUD enabled." or "HUD hidden.")
        end
    end,
    inScreens = false
})

-- Demonstrate the higher-level HUD API and the built-in Zeus drawing context.
API.hud.add("eaglermodapi_example", function(ctx)
    if API.settings.get("hudEnabled") == false then
        return
    end

    local width = API.settings.get("hudWidth") or 254
    local corner = API.settings.get("hudCorner") or "Top left"
    local prefix = API.settings.get("hudPrefix") or "EaglerModAPI"
    local titleColor = API.settings.get("hudTextColor") or 0xFF55FF55

    local x = 4
    local y = 4
    if corner:find("right") and type(ctx.width) == "number" then
        x = math.max(4, ctx.width - width - 4)
    end
    if corner:find("Bottom") and type(ctx.height) == "number" then
        y = math.max(4, ctx.height - 106)
    end

    local position = API.player.getPosition()
    if not position then
        API.hud.drawPanel(ctx, x, y, width, 28, {
            background = "#99000000",
            border = "#55FFFFFF"
        })
        API.hud.drawText(ctx, prefix .. ": waiting for player", x + 6, y + 6, {
            color = titleColor
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

    API.hud.drawPanel(ctx, x, y, width, 102, {
        background = "#99000000",
        border = "#6677AAFF"
    })

    API.hud.drawText(ctx, prefix .. " 0.6.0 | " .. display(name), x + 6, y + 6, {
        color = titleColor
    })
    API.hud.drawText(
        ctx,
        string.format("XYZ: %.1f / %.1f / %.1f",
            position.x, position.y, position.z),
        x + 6, y + 17
    )
    API.hud.drawText(
        ctx,
        "Health: " .. display(health) .. "/" .. display(maxHealth)
            .. "  Food: " .. display(food),
        x + 6, y + 28
    )

    if type(health) == "number" and type(maxHealth) == "number" and maxHealth > 0 then
        API.hud.drawBar(ctx, x + 6, y + 40, 110, 6, health, maxHealth, {
            background = "#AA333333",
            fill = "#55CC55",
            border = "#AAFFFFFF"
        })
    end

    API.hud.drawText(
        ctx,
        "Mode: " .. display(gamemode) .. " | " .. display(dimension),
        x + 6, y + 51
    )
    API.hud.drawText(
        ctx,
        "Biome: " .. display(biome) .. " | " .. display(weather),
        x + 6, y + 62
    )
    API.hud.drawText(
        ctx,
        "Day: " .. display(day) .. " | Time: " .. display(timeOfDay),
        x + 6, y + 73
    )
    local fps = API.game.getFPS()
    local cameraRotation = API.camera.getRotation()
    API.hud.drawText(
        ctx,
        "FPS: " .. display(fps) .. " | View: "
            .. display(cameraRotation and cameraRotation.yaw) .. "/"
            .. display(cameraRotation and cameraRotation.pitch),
        x + 6, y + 84
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

    if command == "inspect" then
        local size = API.game.getSize()
        local cameraPosition = API.camera.getPosition()
        local cameraRotation = API.camera.getRotation()
        local mousePosition = API.mouse.getPosition()

        chat.print("FPS: " .. display(API.game.getFPS()))
        chat.print("Screen: " .. display(API.game.getScreen()))
        chat.print("Paused: " .. display(API.game.isPaused())
            .. " | In world: " .. display(API.game.inWorld())
            .. " | Singleplayer: " .. display(API.game.isSingleplayer()))
        chat.print("Canvas: " .. display(size and size.width) .. " x " .. display(size and size.height)
            .. " | GUI scale: " .. display(API.game.getScale()))
        chat.print("Camera: " .. display(cameraPosition and cameraPosition.x) .. ", "
            .. display(cameraPosition and cameraPosition.y) .. ", "
            .. display(cameraPosition and cameraPosition.z))
        chat.print("Camera yaw/pitch: " .. display(cameraRotation and cameraRotation.yaw)
            .. " / " .. display(cameraRotation and cameraRotation.pitch))
        chat.print("Mouse: " .. display(mousePosition and mousePosition.x)
            .. ", " .. display(mousePosition and mousePosition.y))
        return
    end

    if command == "sound" then
        local result, err = API.sound.play("entity.experience_orb.pickup")
        if result then
            chat.print("Game sound played.")
        else
            chat.print("Sound failed: " .. tostring(err))
        end
        return
    end

    if command == "chat" then
        local ok, err = API.game.openChat("/emapi ping")
        if ok then
            chat.print("Chat opened with /emapi ping prefilled. Press Enter to run it.")
        else
            chat.print("Could not open chat: " .. tostring(err))
        end
        return
    end

    if command == "optioncheck" then
        local fov, readError = API.game.getOption("fov")
        if fov == nil then
            chat.print("Could not read FOV: " .. tostring(readError))
            return
        end
        local ok, setError = API.game.setOption("fov", fov)
        if ok then
            chat.print("Game option read/write check passed. Current FOV: " .. tostring(fov))
        else
            chat.print("Game option write failed: " .. tostring(setError))
        end
        return
    end

    if command == "prefs" then
        chat.print("HUD enabled: " .. display(API.settings.get("hudEnabled")))
        chat.print("HUD corner: " .. display(API.settings.get("hudCorner")))
        chat.print("HUD width: " .. display(API.settings.get("hudWidth")))
        chat.print("Toggle key: " .. display(API.settings.get("toggle_hud")))
        chat.print("Saved HUD toggles: " .. display(API.storage.get("hudToggleCount", 0)))
        return
    end

    if command == "count" then
        chat.print("Saved HUD toggles: " .. display(API.storage.get("hudToggleCount", 0)))
        return
    end

    if command == "resetcount" then
        local ok, err = API.storage.set("hudToggleCount", 0, true)
        if ok then
            chat.print("Saved HUD toggle count reset to zero.")
        else
            chat.print("Could not reset count: " .. tostring(err))
        end
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
    chat.print("Try /emapi inspect, sound, chat or optioncheck; /emapi prefs, count, resetcount, notify, timer, repeat, stop, clock and ping.")
end, "Test the EaglerModAPI modules with local subcommands")
