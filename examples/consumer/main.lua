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

hud.add("eaglermodapi_example", function(ctx)
    local position, positionError = API.player.getPosition()

    if not position then
        ctx:text(
            "EaglerModAPI: waiting for player (" .. display(positionError) .. ")",
            4, 4, "#FFCC55"
        )
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

    ctx:text("EaglerModAPI 0.2.0 | " .. display(name), 4, 4, "#55FF55")
    ctx:text(
        string.format("Position: X %.1f  Y %.1f  Z %.1f",
            position.x, position.y, position.z),
        4, 14, "#FFFFFF"
    )
    ctx:text(
        "Health: " .. display(health) .. "/" .. display(maxHealth)
            .. " | Food: " .. display(food),
        4, 24, "#FFFFFF"
    )
    ctx:text(
        "Mode: " .. display(gamemode) .. " | Dimension: " .. display(dimension),
        4, 34, "#FFFFFF"
    )
    ctx:text(
        "Biome: " .. display(biome) .. " | Weather: " .. display(weather),
        4, 44, "#FFFFFF"
    )
    ctx:text(
        "Day: " .. display(day) .. " | Time: " .. display(timeOfDay),
        4, 54, "#FFFFFF"
    )
end)
