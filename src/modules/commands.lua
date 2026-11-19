-- Consistent wrappers for mod-local Zeus chat commands.

local Commands = {}

local function hasFunction(name)
    return type(commands) == "table" and type(commands[name]) == "function"
end

function Commands.register(name, callback, description)
    if type(name) ~= "string" or name == "" then
        return nil, "command_name_must_be_a_non_empty_string"
    end
    if name:find("%s") or name:sub(1, 1) == "/" then
        return nil, "command_name_must_be_one_word_without_slash"
    end
    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end
    if description ~= nil and type(description) ~= "string" then
        return nil, "description_must_be_a_string"
    end
    if not hasFunction("register") then
        return nil, "zeus_function_unavailable: commands.register"
    end

    local ok, result = pcall(commands.register, name, callback, description)
    if not ok then return nil, tostring(result) end
    return true
end

function Commands.unregister(name)
    if type(name) ~= "string" or name == "" then
        return nil, "command_name_must_be_a_non_empty_string"
    end
    if not hasFunction("unregister") then
        return nil, "zeus_function_unavailable: commands.unregister"
    end

    local ok, result = pcall(commands.unregister, name)
    if not ok then return nil, tostring(result) end
    return true
end

function Commands.list()
    if not hasFunction("list") then
        return nil, "zeus_function_unavailable: commands.list"
    end

    local ok, result = pcall(commands.list)
    if not ok then return nil, tostring(result) end
    return result
end

return Commands
