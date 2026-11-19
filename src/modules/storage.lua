-- Convenience helpers for Zeus's persistent per-mod storage table.

local Storage = {}

local function hasStorage()
    return type(storage) == "table"
end

local function finiteNumber(value)
    return value == value and value ~= math.huge and value ~= -math.huge
end

local function isStorable(value, seen, depth)
    local valueType = type(value)
    if valueType == "string" or valueType == "boolean" then
        return true
    end
    if valueType == "number" then
        return finiteNumber(value)
    end
    if valueType ~= "table" or depth > 32 or seen[value] then
        return false
    end

    seen[value] = true
    for key, child in pairs(value) do
        local keyType = type(key)
        if not ((keyType == "string" and key ~= "")
            or (keyType == "number" and key >= 1 and key % 1 == 0)) then
            seen[value] = nil
            return false
        end
        if not isStorable(child, seen, depth + 1) then
            seen[value] = nil
            return false
        end
    end
    seen[value] = nil
    return true
end

local function saveNow()
    if type(mod) ~= "table" or type(mod.save) ~= "function" then
        return nil, "zeus_function_unavailable: mod.save"
    end
    local ok, err = pcall(mod.save)
    if not ok then return nil, tostring(err) end
    return true
end

function Storage.get(key, defaultValue)
    if type(key) ~= "string" or key == "" then
        return nil, "storage_key_must_be_a_non_empty_string"
    end
    if not hasStorage() then
        return nil, "zeus_storage_unavailable"
    end
    local value = storage[key]
    if value == nil then return defaultValue end
    return value
end

function Storage.set(key, value, saveImmediately)
    if type(key) ~= "string" or key == "" then
        return nil, "storage_key_must_be_a_non_empty_string"
    end
    if saveImmediately ~= nil and type(saveImmediately) ~= "boolean" then
        return nil, "saveImmediately_must_be_boolean"
    end
    if not hasStorage() then
        return nil, "zeus_storage_unavailable"
    end
    if value ~= nil and not isStorable(value, {}, 1) then
        return nil, "value_must_contain_only_finite_numbers_strings_booleans_and_plain_tables"
    end

    storage[key] = value
    if saveImmediately then return saveNow() end
    return true
end

function Storage.remove(key, saveImmediately)
    return Storage.set(key, nil, saveImmediately)
end

function Storage.all()
    if not hasStorage() then
        return nil, "zeus_storage_unavailable"
    end
    return storage
end

function Storage.save()
    return saveNow()
end

return Storage
