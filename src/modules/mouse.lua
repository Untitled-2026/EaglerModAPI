-- Wrappers for mouse position and button state.

local Mouse = {}

local function hasFunction(name)
    return type(mouse) == "table" and type(mouse[name]) == "function"
end

local function callValue(name, ...)
    if not hasFunction(name) then
        return nil, "zeus_function_unavailable: mouse." .. name
    end
    local ok, result = pcall(mouse[name], ...)
    if not ok then return nil, tostring(result) end
    return result
end

function Mouse.getX() return callValue("x") end
function Mouse.getY() return callValue("y") end

function Mouse.getPosition()
    local x, xError = Mouse.getX()
    if x == nil then return nil, xError end
    local y, yError = Mouse.getY()
    if y == nil then return nil, yError end
    return { x = x, y = y }
end

function Mouse.isDown(button)
    if button ~= "left" and button ~= "right" and button ~= "middle" then
        return nil, "button_must_be_left_right_or_middle"
    end
    return callValue("isDown", button)
end

return Mouse
