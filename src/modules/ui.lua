-- Higher-level wrappers for the documented Zeus UI API.

local UI = {}

function UI.notify(title, message)
    if type(title) ~= "string" or type(message) ~= "string" then
        return nil, "title_and_message_must_be_strings"
    end

    if type(ui) ~= "table" or type(ui.notify) ~= "function" then
        return nil, "zeus_function_unavailable: ui.notify"
    end

    local ok, err = pcall(ui.notify, title, message)
    if not ok then
        return nil, tostring(err)
    end

    return true
end

return UI
