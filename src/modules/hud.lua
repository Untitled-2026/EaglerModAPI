-- Higher-level wrappers and drawing helpers for the documented Zeus HUD API.

local HUD = {}

local function hasFunction(name)
    return type(hud) == "table" and type(hud[name]) == "function"
end

local function invoke(name, ...)
    if not hasFunction(name) then
        return false, "zeus_function_unavailable: hud." .. name
    end

    local ok, result = pcall(hud[name], ...)
    if not ok then
        return false, tostring(result)
    end

    return true, result
end

function HUD.add(nameOrCallback, callbackOrOptions, maybeOptions)
    local name, callback, options

    if type(nameOrCallback) == "function" then
        name = nil
        callback = nameOrCallback
        options = callbackOrOptions
    elseif type(nameOrCallback) == "string" and nameOrCallback ~= "" then
        name = nameOrCallback
        callback = callbackOrOptions
        options = maybeOptions
    else
        return nil, "name_or_callback_required"
    end

    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end
    if options ~= nil and type(options) ~= "table" then
        return nil, "options_must_be_a_table"
    end

    if not hasFunction("add") then
        return nil, "zeus_function_unavailable: hud.add"
    end

    local ok, err
    if name ~= nil then
        ok, err = pcall(hud.add, name, callback, options)
    elseif options ~= nil then
        ok, err = pcall(hud.add, callback, options)
    else
        ok, err = pcall(hud.add, callback)
    end

    if not ok then
        return nil, tostring(err)
    end

    return true
end

function HUD.remove(name)
    if type(name) ~= "string" or name == "" then
        return nil, "name_must_be_a_non_empty_string"
    end
    local ok, result = invoke("removeLayer", name)
    if not ok then return nil, result end
    return result
end

function HUD.before(elementId, callback)
    if type(elementId) ~= "string" or elementId == "" then
        return nil, "element_id_must_be_a_non_empty_string"
    end
    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end
    local ok, result = invoke("before", elementId, callback)
    if not ok then return nil, result end
    return true
end

function HUD.after(elementId, callback)
    if type(elementId) ~= "string" or elementId == "" then
        return nil, "element_id_must_be_a_non_empty_string"
    end
    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end
    local ok, result = invoke("after", elementId, callback)
    if not ok then return nil, result end
    return true
end

function HUD.hide(elementId)
    if type(elementId) ~= "string" or elementId == "" then
        return nil, "element_id_must_be_a_non_empty_string"
    end
    local ok, result = invoke("hide", elementId)
    if not ok then return nil, result end
    return true
end

function HUD.show(elementId)
    if type(elementId) ~= "string" or elementId == "" then
        return nil, "element_id_must_be_a_non_empty_string"
    end
    local ok, result = invoke("show", elementId)
    if not ok then return nil, result end
    return true
end

function HUD.replace(elementId, callback)
    if type(elementId) ~= "string" or elementId == "" then
        return nil, "element_id_must_be_a_non_empty_string"
    end
    if type(callback) ~= "function" then
        return nil, "callback_must_be_a_function"
    end
    local ok, result = invoke("replace", elementId, callback)
    if not ok then return nil, result end
    return true
end

function HUD.isHidden(elementId)
    if type(elementId) ~= "string" or elementId == "" then
        return nil, "element_id_must_be_a_non_empty_string"
    end
    local ok, result = invoke("isHidden", elementId)
    if not ok then return nil, result end
    return result
end

function HUD.elements()
    local ok, result = invoke("elements")
    if not ok then return nil, result end
    return result
end

local function callContext(ctx, method, ...)
    if ctx == nil then
        return nil, "drawing_context_required"
    end
    local ok, result = pcall(function(...)
        return ctx[method](ctx, ...)
    end, ...)
    if not ok then
        return nil, tostring(result)
    end
    return result
end

function HUD.drawText(ctx, value, x, y, options)
    if type(value) ~= "string" then
        return nil, "text_must_be_a_string"
    end
    if type(x) ~= "number" or type(y) ~= "number" then
        return nil, "coordinates_must_be_numbers"
    end
    options = options or {}
    if type(options) ~= "table" then
        return nil, "options_must_be_a_table"
    end
    local result, err = callContext(
        ctx, "text", value, x, y, options.color, options.shadow
    )
    if err then return nil, err end
    return result
end

function HUD.drawPanel(ctx, x, y, width, height, options)
    if type(x) ~= "number" or type(y) ~= "number"
        or type(width) ~= "number" or type(height) ~= "number"
        or width < 0 or height < 0 then
        return nil, "panel_dimensions_must_be_non_negative_numbers"
    end
    options = options or {}
    if type(options) ~= "table" then
        return nil, "options_must_be_a_table"
    end

    local _, err = callContext(
        ctx, "rect", x, y, width, height, options.background or "#90000000"
    )
    if err then return nil, err end

    if options.border then
        local _, borderErr = callContext(
            ctx, "outline", x, y, width, height, options.border
        )
        if borderErr then return nil, borderErr end
    end

    return true
end

function HUD.drawBar(ctx, x, y, width, height, value, maximum, options)
    if type(x) ~= "number" or type(y) ~= "number"
        or type(width) ~= "number" or type(height) ~= "number"
        or type(value) ~= "number" or type(maximum) ~= "number"
        or width < 0 or height < 0 or maximum <= 0 then
        return nil, "invalid_bar_arguments"
    end
    options = options or {}
    if type(options) ~= "table" then
        return nil, "options_must_be_a_table"
    end

    local ratio = math.max(0, math.min(1, value / maximum))
    local _, bgErr = callContext(
        ctx, "rect", x, y, width, height, options.background or "#90000000"
    )
    if bgErr then return nil, bgErr end

    local _, fillErr = callContext(
        ctx, "rect", x, y, width * ratio, height, options.fill or "#55CC55"
    )
    if fillErr then return nil, fillErr end

    if options.border then
        local _, borderErr = callContext(
            ctx, "outline", x, y, width, height, options.border
        )
        if borderErr then return nil, borderErr end
    end

    return true
end

return HUD
