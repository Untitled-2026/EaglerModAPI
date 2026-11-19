-- Consistent wrappers for Zeus event listeners and custom events.

local Events = {}

local function hasFunction(name)
    return type(events) == "table" and type(events[name]) == "function"
end

local function validate(name, callback, priority)
    if type(name) ~= "string" or name == "" then
        return nil, "event_name_must_be_a_non_empty_string"
    end
    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end
    if priority ~= nil and (type(priority) ~= "number" or priority % 1 ~= 0) then
        return nil, "priority_must_be_a_whole_number"
    end
    return true
end

local function addListener(method, name, callback, priority)
    local valid, validationError = validate(name, callback, priority)
    if not valid then return nil, validationError end

    if not hasFunction(method) then
        return nil, "zeus_function_unavailable: events." .. method
    end

    local ok, handle
    if priority ~= nil then
        ok, handle = pcall(events[method], name, callback, priority)
    else
        ok, handle = pcall(events[method], name, callback)
    end
    if not ok then return nil, tostring(handle) end
    return handle
end

function Events.on(name, callback, priority)
    return addListener("on", name, callback, priority)
end

function Events.once(name, callback, priority)
    return addListener("once", name, callback, priority)
end

function Events.off(handle)
    if handle == nil then
        return nil, "event_handle_required"
    end
    if not hasFunction("off") then
        return nil, "zeus_function_unavailable: events.off"
    end
    local ok, result = pcall(events.off, handle)
    if not ok then return nil, tostring(result) end
    return true
end

function Events.emit(name, ...)
    if type(name) ~= "string" or name == "" then
        return nil, "event_name_must_be_a_non_empty_string"
    end
    if not hasFunction("emit") then
        return nil, "zeus_function_unavailable: events.emit"
    end
    local ok, result = pcall(events.emit, name, ...)
    if not ok then return nil, tostring(result) end
    return true
end

return Events
