-- Safe wrappers for the documented Zeus timer API.

local Timer = {}

local function hasFunction(name)
    return type(timer) == "table" and type(timer[name]) == "function"
end

local function validSeconds(seconds, allowZero)
    if type(seconds) ~= "number"
        or seconds ~= seconds
        or seconds == math.huge
        or seconds == -math.huge then
        return false
    end

    if allowZero then
        return seconds >= 0
    end
    return seconds > 0
end

local function schedule(method, seconds, callback)
    if not validSeconds(seconds, method == "after") then
        if method == "after" then
            return nil, "delay_must_be_a_finite_non_negative_number"
        end
        return nil, "interval_must_be_a_finite_positive_number"
    end

    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end

    if not hasFunction(method) then
        return nil, "zeus_function_unavailable: timer." .. method
    end

    local ok, handle = pcall(timer[method], seconds, callback)
    if not ok then
        return nil, tostring(handle)
    end
    if handle == nil then
        return nil, "timer_handle_unavailable"
    end

    return handle
end

function Timer.after(seconds, callback)
    return schedule("after", seconds, callback)
end

function Timer.every(seconds, callback)
    return schedule("every", seconds, callback)
end

function Timer.cancel(handle)
    if handle == nil then
        return nil, "timer_handle_required"
    end

    local ok, cancel = pcall(function()
        return handle.cancel
    end)
    if not ok then
        return nil, tostring(cancel)
    end
    if type(cancel) ~= "function" then
        return nil, "invalid_timer_handle"
    end

    local cancelled, err = pcall(cancel, handle)
    if not cancelled then
        return nil, tostring(err)
    end

    return true
end

function Timer.isActive(handle)
    if handle == nil then
        return nil, "timer_handle_required"
    end

    local ok, active = pcall(function()
        return handle.active
    end)
    if not ok then
        return nil, tostring(active)
    end
    if type(active) ~= "boolean" then
        return nil, "timer_active_state_unavailable"
    end

    return active
end

function Timer.time()
    if not hasFunction("time") then
        return nil, "zeus_function_unavailable: timer.time"
    end

    local ok, value = pcall(timer.time)
    if not ok then
        return nil, tostring(value)
    end
    return value
end

function Timer.ticks()
    if not hasFunction("ticks") then
        return nil, "zeus_function_unavailable: timer.ticks"
    end

    local ok, value = pcall(timer.ticks)
    if not ok then
        return nil, tostring(value)
    end
    return value
end

return Timer
