local World = {}

local function hasWorldFunction(name)
    return type(world) == "table" and type(world[name]) == "function"
end

function World.exists()
    if not hasWorldFunction("exists") then
        return false
    end

    local ok, result = pcall(world.exists)
    return ok and result == true
end

function World.getBlock(x, y, z)
    if not World.exists() then
        return nil, "world_unavailable"
    end

    if not hasWorldFunction("block") then
        return nil, "zeus_function_unavailable: world.block"
    end

    if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
        return nil, "coordinates_must_be_numbers"
    end

    local ok, blockId = pcall(world.block, x, y, z)
    if not ok then
        return nil, tostring(blockId)
    end

    return blockId
end

function World.getTime()
    if not World.exists() then
        return nil, "world_unavailable"
    end

    if not hasWorldFunction("time") then
        return nil, "zeus_function_unavailable: world.time"
    end

    local ok, time = pcall(world.time)
    if not ok then
        return nil, tostring(time)
    end

    return time
end

return World
