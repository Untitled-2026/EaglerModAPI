-- Normalized wrappers for the documented Zeus player API.
-- World-dependent methods return nil, error_code when a player is unavailable.

local Player = {}

local function hasFunction(name)
    return type(player) == "table" and type(player[name]) == "function"
end

local function invoke(name, ...)
    if not hasFunction(name) then
        return false, "zeus_function_unavailable: player." .. name
    end

    local ok, a, b, c = pcall(player[name], ...)
    if not ok then
        return false, tostring(a)
    end

    return true, a, b, c
end

local function callValue(name, needsPlayer, ...)
    if needsPlayer and not Player.exists() then
        return nil, "player_unavailable"
    end

    local ok, value = invoke(name, ...)
    if not ok then
        return nil, value
    end

    return value
end

local function callVector(name)
    if not Player.exists() then
        return nil, "player_unavailable"
    end

    local ok, x, y, z = invoke(name)
    if not ok then
        return nil, x
    end

    return { x = x, y = y, z = z }
end

local function callAction(name, ...)
    if not Player.exists() then
        return nil, "player_unavailable"
    end

    local ok, result = invoke(name, ...)
    if not ok then
        return nil, result
    end
    if result == false then
        return nil, "operation_rejected"
    end

    return true
end

function Player.exists()
    if not hasFunction("exists") then
        return false
    end
    local ok, result = pcall(player.exists)
    return ok and result == true
end

function Player.getName() return callValue("name", true) end
function Player.getUUID() return callValue("uuid", true) end
function Player.getPosition() return callVector("pos") end
function Player.getX() return callValue("x", true) end
function Player.getY() return callValue("y", true) end
function Player.getZ() return callValue("z", true) end
function Player.getBlockPosition() return callVector("blockPos") end
function Player.getEyePosition() return callVector("eyePos") end
function Player.getVelocity() return callVector("velocity") end

function Player.setVelocity(x, y, z)
    if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
        return nil, "velocity_components_must_be_numbers"
    end
    return callAction("setVelocity", x, y, z)
end

function Player.getRotation()
    if not Player.exists() then
        return nil, "player_unavailable"
    end
    local ok, yaw = invoke("yaw")
    if not ok then return nil, yaw end
    local pitchOk, pitch = invoke("pitch")
    if not pitchOk then return nil, pitch end
    return { yaw = yaw, pitch = pitch }
end

function Player.getYaw() return callValue("yaw", true) end
function Player.getPitch() return callValue("pitch", true) end

function Player.setRotation(yaw, pitch)
    if type(yaw) ~= "number" or type(pitch) ~= "number" then
        return nil, "rotation_components_must_be_numbers"
    end
    return callAction("setRotation", yaw, pitch)
end

function Player.getFacing() return callValue("facing", true) end
function Player.getHealth() return callValue("health", true) end
function Player.getMaxHealth() return callValue("maxHealth", true) end
function Player.getFood() return callValue("food", true) end
function Player.getSaturation() return callValue("saturation", true) end
function Player.getArmor() return callValue("armor", true) end
function Player.getXPLevel() return callValue("xpLevel", true) end
function Player.getXPProgress() return callValue("xpProgress", true) end
function Player.isOnGround() return callValue("isOnGround", true) end
function Player.isSneaking() return callValue("isSneaking", true) end
function Player.isSprinting() return callValue("isSprinting", true) end
function Player.isSwimming() return callValue("isSwimming", true) end
function Player.isFlying() return callValue("isFlying", true) end

function Player.setSprinting(enabled)
    if type(enabled) ~= "boolean" then
        return nil, "enabled_must_be_boolean"
    end
    return callAction("setSprinting", enabled)
end

-- Zeus documents these two functions as safe outside a world.
function Player.getGamemode() return callValue("gamemode", false) end
function Player.getLookingAt() return callValue("lookingAt", false) end

function Player.getDimension() return callValue("dimension", true) end
function Player.getBiome() return callValue("biome", true) end
function Player.getHeldItem() return callValue("heldItem", true) end
function Player.getOffhandItem() return callValue("offhandItem", true) end
function Player.getSelectedSlot() return callValue("selectedSlot", true) end

function Player.selectSlot(slot)
    if type(slot) ~= "number" or slot % 1 ~= 0 or slot < 1 or slot > 9 then
        return nil, "slot_must_be_an_integer_from_1_to_9"
    end
    return callAction("selectSlot", slot)
end

function Player.getInventory() return callValue("inventory", true) end
function Player.getEffects() return callValue("effects", true) end
function Player.jump() return callAction("jump") end
function Player.swing() return callAction("swing") end

return Player
