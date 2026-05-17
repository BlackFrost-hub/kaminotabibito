local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local ____01_FF0E_88C5_5907_6570_636E = require("系统.02．物品系统.01．装备数据")
local items = ____01_FF0E_88C5_5907_6570_636E.items
local function normalizeItemName(name)
    local result = ""
    do
        local i = 0
        while i < #name do
            do
                local ch = __TS__StringCharAt(name, i)
                if ch == "|" then
                    local next = __TS__StringCharAt(name, i + 1)
                    if next == "r" or next == "R" then
                        i = i + 1
                        goto __continue4
                    end
                    if next == "c" or next == "C" then
                        i = i + 9
                        goto __continue4
                    end
                end
                result = result .. ch
            end
            ::__continue4::
            i = i + 1
        end
    end
    return __TS__StringTrim(result)
end
____exports["按名字反查物品ID"] = function(name)
    local normalized = normalizeItemName(name)
    for ____, ____value in ipairs(__TS__ObjectEntries(items)) do
        local itemId = ____value[1]
        local data = ____value[2]
        if normalizeItemName(data.name or "") == normalized then
            return itemId
        end
    end
    return nil
end
____exports.resolveItemIdByName = ____exports["按名字反查物品ID"]
return ____exports
