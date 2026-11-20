-- Wrappers for documented game sound playback.

local Sound = {}

local function finite(value)
    return type(value) == "number"
        and value == value
        and value ~= math.huge
        and value ~= -math.huge
end

function Sound.play(id, volume, pitch)
    if type(id) ~= "string" or id == "" then
        return nil, "sound_id_must_be_a_non_empty_string"
    end
    if volume ~= nil and (not finite(volume) or volume < 0) then
        return nil, "volume_must_be_a_non_negative_finite_number"
    end
    if pitch ~= nil and (not finite(pitch) or pitch <= 0) then
        return nil, "pitch_must_be_a_positive_finite_number"
    end
    if type(sound) ~= "table" or type(sound.play) ~= "function" then
        return nil, "zeus_function_unavailable: sound.play"
    end

    local ok, result = pcall(sound.play, id, volume, pitch)
    if not ok then return nil, tostring(result) end
    return result == nil and true or result
end

return Sound
