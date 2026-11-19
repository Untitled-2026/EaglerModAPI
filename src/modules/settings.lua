-- Wrappers for the documented Zeus settings API.

local Settings = {}

local RESERVED = {
    toggle = true, slider = true, choice = true, text = true,
    key = true, color = true, button = true, get = true,
    set = true, reset = true, all = true, onChange = true, open = true
}

local function hasFunction(name)
    return type(settings) == "table" and type(settings[name]) == "function"
end

local function define(kind, key, options)
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
    elseif (kind == "text" or kind == "key") then
        if options.default ~= nil and type(options.default) ~= "string" then
            return nil, kind .. "_default_must_be_a_string"
        end
    elseif kind == "color" then
        if options.default ~= nil and type(options.default) ~= "number" then
            return nil, "color_default_must_be_a_number"
        end
    elseif kind == "button" then
        if type(options.onClick) ~= "function" then
            return nil, "button_onClick_must_be_a_function"
        end
    end

    if not hasFunction(kind) then
        return nil, "zeus_function_unavailable: settings." .. kind
    end

    local ok, result = pcall(settings[kind], key, options)
    if not ok then
        return nil, tostring(result)
    end
    return result
end

function Settings.toggle(key, options) return define("toggle", key, options) end
function Settings.slider(key, options) return define("slider", key, options) end
function Settings.choice(key, options) return define("choice", key, options) end
function Settings.text(key, options) return define("text", key, options) end
function Settings.key(key, options) return define("key", key, options) end
function Settings.color(key, options) return define("color", key, options) end
function Settings.button(key, options) return define("button", key, options) end

function Settings.get(key)
    if type(key) ~= "string" or key == "" then
        return nil, "setting_key_must_be_a_non_empty_string"
    end
    if not hasFunction("get") then
        return nil, "zeus_function_unavailable: settings.get"
    end
    local ok, result = pcall(settings.get, key)
    if not ok then return nil, tostring(result) end
    return result
end

function Settings.set(key, value)
    if type(key) ~= "string" or key == "" then
        return nil, "setting_key_must_be_a_non_empty_string"
    end
    if not hasFunction("set") then
        return nil, "zeus_function_unavailable: settings.set"
    end
    local ok, err = pcall(settings.set, key, value)
    if not ok then return nil, tostring(err) end
    return true
end

function Settings.reset(key)
    if type(key) ~= "string" or key == "" then
        return nil, "setting_key_must_be_a_non_empty_string"
    end
    if not hasFunction("reset") then
        return nil, "zeus_function_unavailable: settings.reset"
    end
    local ok, err = pcall(settings.reset, key)
    if not ok then return nil, tostring(err) end
    return true
end

function Settings.all()
    if not hasFunction("all") then
        return nil, "zeus_function_unavailable: settings.all"
    end
    local ok, result = pcall(settings.all)
    if not ok then return nil, tostring(result) end
    return result
end

function Settings.onChange(callback)
    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end
    if not hasFunction("onChange") then
        return nil, "zeus_function_unavailable: settings.onChange"
    end
    local ok, result = pcall(settings.onChange, callback)
    if not ok then return nil, tostring(result) end
    return result == nil and true or result
end

function Settings.open()
    if not hasFunction("open") then
        return nil, "zeus_function_unavailable: settings.open"
    end
    local ok, err = pcall(settings.open)
    if not ok then return nil, tostring(err) end
    return true
end

return Settings
