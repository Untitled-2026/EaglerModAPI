-- Normalized wrappers for the documented Zeus world API.

local World = {}

local function hasFunction(name)
    return type(world) == "table" and type(world[name]) == "function"
end

local function invoke(name, ...)
    if not hasFunction(name) then
        return false, "zeus_function_unavailable: world." .. name
    end

    local ok, value = pcall(world[name], ...)
    if not ok then
        return false, tostring(value)
    end

    return true, value
end

local function callValue(name, ...)
    if not World.exists() then
        return nil, "world_unavailable"
    end

    local ok, value = invoke(name, ...)
    if not ok then
        return nil, value
    end

    return value
end

local function validateCoordinates(x, y, z)
    return type(x) == "number"
        and type(y) == "number"
        and type(z) == "number"
end

function World.exists()
    if not hasFunction("exists") then
        return false
    end
    local ok, result = pcall(world.exists)
    return ok and result == true
end

function World.getBlock(x, y, z)
    if not validateCoordinates(x, y, z) then
        return nil, "coordinates_must_be_numbers"
    end
    return callValue("block", x, y, z)
end

function World.getLight(x, y, z)
    if not validateCoordinates(x, y, z) then
        return nil, "coordinates_must_be_numbers"
    end
    return callValue("light", x, y, z)
end

function World.getBiomeAt(x, y, z)
    if not validateCoordinates(x, y, z) then
        return nil, "coordinates_must_be_numbers"
    end
    return callValue("biome", x, y, z)
end

function World.getTime() return callValue("time") end
function World.getDay() return callValue("day") end
function World.getTimeOfDay() return callValue("timeOfDay") end
function World.getWeather() return callValue("weather") end
function World.getPlayers() return callValue("players") end

function World.getEntities(radius)
    if radius ~= nil and (type(radius) ~= "number" or radius <= 0) then
        return nil, "radius_must_be_a_positive_number"
    end

    if radius == nil then
        return callValue("entities")
    end

    return callValue("entities", radius)
end

return World
