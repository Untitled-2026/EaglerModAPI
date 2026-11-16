local detect = require("src.compat.detect")
local probe = require("src.compat.probe")

local adapters = {
    ["26.2"] = require("src.compat.versions.v26_2"),
    ["26.3"] = require("src.compat.versions.v26_3")
}

local Compat = {}

function Compat.getGameVersion()
    return detect.getGameVersion()
end

function Compat.getAdapterId()
    local versionKey = detect.getVersionKey()
    local adapter = versionKey and adapters[versionKey] or nil
    return adapter and adapter.id or "unsupported"
end

function Compat.isSupported()
    local versionKey = detect.getVersionKey()
    return versionKey ~= nil and adapters[versionKey] ~= nil
end

function Compat.getVerificationStatus()
    local versionKey = detect.getVersionKey()
    local adapter = versionKey and adapters[versionKey] or nil

    if not adapter then
        return "unsupported"
    end

    return adapter.documentationStatus .. "; runtime testing " .. adapter.runtimeTestStatus
end

function Compat.getCapabilities()
    return probe.all()
end

function Compat.has(name)
    if type(name) ~= "string" then
        return false
    end

    return probe.has(name)
end

return Compat
