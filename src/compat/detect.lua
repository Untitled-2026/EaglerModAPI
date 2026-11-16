local Detect = {}

local function readVersionValue()
    -- mod.minecraft is the documented version field for the current mod.
    if type(mod) == "table" and mod.minecraft ~= nil then
        return tostring(mod.minecraft)
    end

    -- game.version is also documented by Zeus as the running game version.
    if type(game) == "table" and game.version ~= nil then
        return tostring(game.version)
    end

    return "unknown"
end

function Detect.getGameVersion()
    return readVersionValue()
end

function Detect.getVersionKey()
    local version = readVersionValue()

    if string.match(version, "^26%.2") then
        return "26.2"
    end

    if string.match(version, "^26%.3") then
        return "26.3"
    end

    return nil
end

return Detect
