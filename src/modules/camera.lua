-- Wrappers for Zeus camera position, rotation and world-to-screen projection.

local Camera = {}

local function hasFunction(name)
    return type(camera) == "table" and type(camera[name]) == "function"
end

local function callValues(name, ...)
    if not hasFunction(name) then
        return nil, "zeus_function_unavailable: camera." .. name
    end
    local ok, a, b, c = pcall(camera[name], ...)
    if not ok then return nil, tostring(a) end
    return a, b, c
end

function Camera.getPosition()
    local x, y, z = callValues("pos")
    if x == nil then return nil, y end
    return { x = x, y = y, z = z }
end

function Camera.getYaw()
    return callValues("yaw")
end

function Camera.getPitch()
    return callValues("pitch")
end

function Camera.getRotation()
    local yaw, yawError = Camera.getYaw()
    if yaw == nil then return nil, yawError end
    local pitch, pitchError = Camera.getPitch()
    if pitch == nil then return nil, pitchError end
    return { yaw = yaw, pitch = pitch }
end

function Camera.project(x, y, z)
    if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
        return nil, "coordinates_must_be_numbers"
    end
    local screenX, screenY, depth = callValues("project", x, y, z)
    if screenX == nil then return nil, screenY end
    if screenY == nil or depth == nil then
        return nil, "projection_unavailable"
    end
    return { x = screenX, y = screenY, depth = depth }
end

return Camera
