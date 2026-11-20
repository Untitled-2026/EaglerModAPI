-- Factory for storage wrappers bound to the calling mod's Zeus namespace.
-- Storage and mod.save are per-mod; never access the library mod's globals for consumers.

local Storage = {}

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

function Storage.bind(storageNamespace, modNamespace)
    if type(storageNamespace) ~= "table" then
        return nil, "storage_namespace_must_be_a_table"
    end
    if type(modNamespace) ~= "table" then
        return nil, "mod_namespace_must_be_a_table"
    end

    local Bound = {}

    local function saveNow()
        if type(modNamespace.save) ~= "function" then
            return nil, "zeus_function_unavailable: mod.save"
        end
        local ok, err = pcall(modNamespace.save)
        if not ok then return nil, tostring(err) end
        return true
    end

    function Bound.get(key, defaultValue)
        if type(key) ~= "string" or key == "" then
            return nil, "storage_key_must_be_a_non_empty_string"
        end
        local value = storageNamespace[key]
        if value == nil then return defaultValue end
        return value
    end

    function Bound.set(key, value, saveImmediately)
        if type(key) ~= "string" or key == "" then
            return nil, "storage_key_must_be_a_non_empty_string"
        end
        if saveImmediately ~= nil and type(saveImmediately) ~= "boolean" then
            return nil, "saveImmediately_must_be_boolean"
        end
        if value ~= nil and not isStorable(value, {}, 1) then
            return nil, "value_must_contain_only_finite_numbers_strings_booleans_and_plain_tables"
        end

        storageNamespace[key] = value
        if saveImmediately then return saveNow() end
        return true
    end

    function Bound.remove(key, saveImmediately)
        return Bound.set(key, nil, saveImmediately)
    end

    function Bound.all()
        return storageNamespace
    end

    function Bound.save()
        return saveNow()
    end

    return Bound
end

return Storage
