-- Wrappers for Zeus keybinds and keyboard-state helpers.

local Keys = {}

local function hasFunction(name)
    return type(keys) == "table" and type(keys[name]) == "function"
end

function Keys.bind(options)
    if type(options) ~= "table" then
        return nil, "keybind_options_must_be_a_table"
    end
    if type(options.id) ~= "string" or options.id == "" then
        return nil, "keybind_id_must_be_a_non_empty_string"
    end
    if type(options.label) ~= "string" or options.label == "" then
        return nil, "keybind_label_must_be_a_non_empty_string"
    end
    if options.default ~= nil and type(options.default) ~= "string" then
        return nil, "keybind_default_must_be_a_key_name"
    end
    if options.description ~= nil and type(options.description) ~= "string" then
        return nil, "keybind_description_must_be_a_string"
    end
    if options.onPress ~= nil and type(options.onPress) ~= "function" then
        return nil, "keybind_onPress_must_be_a_function"
    end
    if options.onRelease ~= nil and type(options.onRelease) ~= "function" then
        return nil, "keybind_onRelease_must_be_a_function"
    end
    if options.inScreens ~= nil and type(options.inScreens) ~= "boolean" then
        return nil, "keybind_inScreens_must_be_boolean"
    end
    if not options.onPress and not options.onRelease then
        return nil, "keybind_requires_onPress_or_onRelease"
    end
    if not hasFunction("bind") then
        return nil, "zeus_function_unavailable: keys.bind"
    end

    local ok, err = pcall(keys.bind, options)
    if not ok then return nil, tostring(err) end
    return true
end

function Keys.isDown(name)
    if type(name) ~= "string" or name == "" then
        return nil, "key_name_must_be_a_non_empty_string"
    end
    if not hasFunction("isDown") then
        return nil, "zeus_function_unavailable: keys.isDown"
    end
    local ok, result = pcall(keys.isDown, name)
    if not ok then return nil, tostring(result) end
    return result
end

function Keys.code(name)
    if type(name) ~= "string" or name == "" then
        return nil, "key_name_must_be_a_non_empty_string"
    end
    if not hasFunction("code") then
        return nil, "zeus_function_unavailable: keys.code"
    end
    local ok, result = pcall(keys.code, name)
    if not ok then return nil, tostring(result) end
    return result
end

function Keys.name(code)
    if type(code) ~= "number" or code % 1 ~= 0 then
        return nil, "key_code_must_be_an_integer"
    end
    if not hasFunction("name") then
        return nil, "zeus_function_unavailable: keys.name"
    end
    local ok, result = pcall(keys.name, code)
    if not ok then return nil, tostring(result) end
    return result
end

return Keys
