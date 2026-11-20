-- Wrappers for the documented Zeus game API.

local Game = {}

local OPTION_RULES = {
    fov = { kind = "integer", min = 30, max = 110 },
    gamma = { kind = "number", min = 0, max = 1 },
    brightness = { alias = "gamma", kind = "number", min = 0, max = 1 },
    renderDistance = { kind = "integer", min = 2 },
    sensitivity = { kind = "number", min = 0, max = 1 },
    viewBobbing = { kind = "boolean" },
    fovEffects = { kind = "number", min = 0, max = 1 },
    framerateLimit = { kind = "step", min = 10, max = 260, step = 10 },
    chatOpacity = { kind = "number", min = 0, max = 1 },
    subtitles = { kind = "boolean" },
    masterVolume = { kind = "number", min = 0, max = 1 },
    musicVolume = { kind = "number", min = 0, max = 1 },
    guiScale = { kind = "readonly" }
}

local function hasFunction(name)
    return type(game) == "table" and type(game[name]) == "function"
end

local function callValue(name, ...)
    if not hasFunction(name) then
        return nil, "zeus_function_unavailable: game." .. name
    end
    local ok, value = pcall(game[name], ...)
    if not ok then return nil, tostring(value) end
    return value
end

function Game.getFPS() return callValue("fps") end
function Game.getWidth() return callValue("width") end
function Game.getHeight() return callValue("height") end
function Game.getScale() return callValue("scale") end
function Game.isPaused() return callValue("isPaused") end
function Game.inWorld() return callValue("inWorld") end
function Game.isSingleplayer() return callValue("isSingleplayer") end
function Game.getScreen() return callValue("screen") end

function Game.getSize()
    local width, widthError = Game.getWidth()
    if width == nil then return nil, widthError end
    local height, heightError = Game.getHeight()
    if height == nil then return nil, heightError end
    return { width = width, height = height }
end

function Game.getOption(name)
    if type(name) ~= "string" or name == "" then
        return nil, "option_name_must_be_a_non_empty_string"
    end
    local rule = OPTION_RULES[name]
    if not rule then return nil, "unsupported_game_option" end
    return callValue("option", rule.alias or name)
end

function Game.setOption(name, value)
    if type(name) ~= "string" or name == "" then
        return nil, "option_name_must_be_a_non_empty_string"
    end
    local rule = OPTION_RULES[name]
    if not rule then return nil, "unsupported_game_option" end
    if rule.kind == "readonly" then return nil, "game_option_is_read_only" end

    if rule.kind == "boolean" then
        if type(value) ~= "boolean" then
            return nil, "option_value_must_be_boolean"
        end
    else
        if type(value) ~= "number" or value ~= value
            or value == math.huge or value == -math.huge then
            return nil, "option_value_must_be_a_finite_number"
        end
        if value < rule.min or (rule.max and value > rule.max) then
            return nil, "option_value_out_of_range"
        end
        if rule.kind == "integer" and value % 1 ~= 0 then
            return nil, "option_value_must_be_an_integer"
        end
        if rule.kind == "step" and value % rule.step ~= 0 then
            return nil, "option_value_must_match_step"
        end
    end

    if not hasFunction("setOption") then
        return nil, "zeus_function_unavailable: game.setOption"
    end
    local ok, result = pcall(game.setOption, rule.alias or name, value)
    if not ok then return nil, tostring(result) end
    if result == false then return nil, "option_change_rejected" end
    return true
end

function Game.openChat(text)
    if text ~= nil and type(text) ~= "string" then
        return nil, "chat_prefill_must_be_a_string"
    end
    if not hasFunction("openChat") then
        return nil, "zeus_function_unavailable: game.openChat"
    end
    local ok, result
    if text == nil then
        ok, result = pcall(game.openChat)
    else
        ok, result = pcall(game.openChat, text)
    end
    if not ok then return nil, tostring(result) end
    if result == false then return nil, "chat_open_rejected" end
    return true
end

return Game
