local Player = {}

local function hasPlayerFunction(name)
    return type(player) == "table" and type(player[name]) == "function"
end

function Player.exists()
    if not hasPlayerFunction("exists") then
        return false
    end

    local ok, result = pcall(player.exists)
    return ok and result == true
end

function Player.getPosition()
    if not Player.exists() then
        return nil, "player_unavailable"
    end

    if not hasPlayerFunction("pos") then
        return nil, "zeus_function_unavailable: player.pos"
    end

    local ok, x, y, z = pcall(player.pos)
    if not ok then
        return nil, tostring(x)
    end

    return { x = x, y = y, z = z }
end

function Player.getName()
    if not Player.exists() then
        return nil, "player_unavailable"
    end

    if not hasPlayerFunction("name") then
        return nil, "zeus_function_unavailable: player.name"
    end

    local ok, name = pcall(player.name)
    if not ok then
        return nil, tostring(name)
    end

    return name
end

function Player.getHealth()
    if not Player.exists() then
        return nil, "player_unavailable"
    end

    if not hasPlayerFunction("health") then
        return nil, "zeus_function_unavailable: player.health"
    end

    local ok, health = pcall(player.health)
    if not ok then
        return nil, tostring(health)
    end

    return health
end

return Player
