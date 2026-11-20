-- Factory for settings wrappers bound to the calling mod's Zeus settings namespace.
-- Zeus settings are per-mod, so a consumer must pass its own global settings table.

local Settings = {}

local RESERVED = {
    enabled = true,
    toggle = true, slider = true, choice = true, text = true,
    key = true, color = true, button = true, get = true,
    set = true, reset = true, all = true, onChange = true, open = true
}

local function hasFunction(namespace, name)
    return type(namespace) == "table"
        and type(namespace[name]) == "function"
end

local function define(namespace, kind, key, options)
    if type(key) ~= "string" or key == "" then
        return nil, "setting_key_must_be_a_non_empty_string"
    end
    if RESERVED[key] then
        return nil, "setting_key_is_reserved"
    end
    if type(options) ~= "table" then
        return nil, "setting_options_must_be_a_table"
    end
    if type(options.label) ~= "string" or options.label == "" then
        return nil, "setting_label_must_be_a_non_empty_string"
    end
    if options.description ~= nil and type(options.description) ~= "string" then
        return nil, "setting_description_must_be_a_string"
    end

    if kind == "toggle" and options.default ~= nil and type(options.default) ~= "boolean" then
        return nil, "toggle_default_must_be_boolean"
    elseif kind == "slider" then
        if type(options.min) ~= "number" or type(options.max) ~= "number"
            or options.min >= options.max then
            return nil, "slider_min_and_max_must_be_numbers_with_min_less_than_max"
        end
        if options.step ~= nil and (type(options.step) ~= "number" or options.step <= 0) then
            return nil, "slider_step_must_be_a_positive_number"
        end
        if options.default ~= nil and type(options.default) ~= "number" then
            return nil, "slider_default_must_be_a_number"
        end
    elseif kind == "choice" then
        if type(options.options) ~= "table" or #options.options == 0 then
            return nil, "choice_options_must_be_a_non_empty_list"
        end
    elseif kind == "text" or kind == "key" then
        if options.default ~= nil and type(options.default) ~= "string" then
            return nil, kind .. "_default_must_be_a_string"
        end
    elseif kind == "color" then
        if options.default ~= nil and type(options.default) ~= "number"
            and type(options.default) ~= "string" then
            return nil, "color_default_must_be_a_number_or_hex_string"
        end
    elseif kind == "button" then
        if type(options.onClick) ~= "function" then
            return nil, "button_onClick_must_be_a_function"
        end
    end

    if not hasFunction(namespace, kind) then
        return nil, "zeus_function_unavailable: settings." .. kind
    end

    local ok, result = pcall(namespace[kind], key, options)
    if not ok then
        return nil, tostring(result)
    end
    return result
end

function Settings.bind(namespace)
    if type(namespace) ~= "table" then
        return nil, "settings_namespace_must_be_a_table"
    end

    local Bound = {}

    local kinds = { "toggle", "slider", "choice", "text", "key", "color", "button" }
    local function makeDefinition(settingKind)
        return function(key, options)
            return define(namespace, settingKind, key, options)
        end
    end
    for _, kind in ipairs(kinds) do
        Bound[kind] = makeDefinition(kind)
    end

    function Bound.get(key)
        if type(key) ~= "string" or key == "" then
            return nil, "setting_key_must_be_a_non_empty_string"
        end
        if not hasFunction(namespace, "get") then
            return nil, "zeus_function_unavailable: settings.get"
        end
        local ok, result = pcall(namespace.get, key)
        if not ok then return nil, tostring(result) end
        return result
    end

    function Bound.set(key, value)
        if type(key) ~= "string" or key == "" then
            return nil, "setting_key_must_be_a_non_empty_string"
        end
        if not hasFunction(namespace, "set") then
            return nil, "zeus_function_unavailable: settings.set"
        end
        local ok, err = pcall(namespace.set, key, value)
        if not ok then return nil, tostring(err) end
        return true
    end

    function Bound.reset(key)
        if type(key) ~= "string" or key == "" then
            return nil, "setting_key_must_be_a_non_empty_string"
        end
        if not hasFunction(namespace, "reset") then
            return nil, "zeus_function_unavailable: settings.reset"
        end
        local ok, err = pcall(namespace.reset, key)
        if not ok then return nil, tostring(err) end
        return true
    end

    function Bound.all()
        if not hasFunction(namespace, "all") then
            return nil, "zeus_function_unavailable: settings.all"
        end
        local ok, result = pcall(namespace.all)
        if not ok then return nil, tostring(result) end
        return result
    end

    function Bound.onChange(callback)
        if type(callback) ~= "function" then
            return nil, "callback_must_be_a_function"
        end
        if not hasFunction(namespace, "onChange") then
            return nil, "zeus_function_unavailable: settings.onChange"
        end
        local ok, result = pcall(namespace.onChange, callback)
        if not ok then return nil, tostring(result) end
        return result == nil and true or result
    end

    function Bound.open()
        if not hasFunction(namespace, "open") then
            return nil, "zeus_function_unavailable: settings.open"
        end
        local ok, err = pcall(namespace.open)
        if not ok then return nil, tostring(err) end
        return true
    end

    return Bound
end

return Settings
