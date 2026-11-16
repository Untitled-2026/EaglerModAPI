local API = mods.get("eaglermodapi")
assert(API, "Enable the EaglerModAPI dependency before this example")

local info = API.getInfo()
chat.print("EaglerModAPI " .. info.version .. " | Eaglercraft " .. info.gameVersion)

hud.add("eaglermodapi_example", function(ctx)
    local position = API.player.getPosition()

    if not position then
        ctx:text("EaglerModAPI: waiting for player", 4, 4, "#FFCC55")
        return
    end

    ctx:text(
        string.format("EaglerModAPI | X: %.1f Y: %.1f Z: %.1f",
            position.x, position.y, position.z),
        4, 4, "#55FF55"
    )
end)
