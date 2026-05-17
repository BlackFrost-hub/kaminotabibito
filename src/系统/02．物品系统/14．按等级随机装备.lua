local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local ____01_FF0E_88C5_5907_6570_636E = require("系统.02．物品系统.01．装备数据")
local items = ____01_FF0E_88C5_5907_6570_636E.items
local jass = require("jass.common")
local GetRandomInt = jass.GetRandomInt
local _____7269_54C1_6C60_540D_5230_7B49_7EA7_6620_5C04 = {
    ["D+级物品池"] = "D+",
    ["D++级物品池"] = "D++",
    ["C-级物品池"] = "C-",
    ["C级物品池"] = "C",
    ["C+级物品池"] = "C+",
    ["C++级物品池"] = "C++",
    ["B-级物品"] = "B-"
}
____exports["物品池名映射装备等级"] = function(_____7269_54C1_6C60_540D)
    return _____7269_54C1_6C60_540D_5230_7B49_7EA7_6620_5C04[_____7269_54C1_6C60_540D]
end
____exports["按装备等级筛选物品ID"] = function(_____7B49_7EA7)
    local result = {}
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(items),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local itemId = ____value[1]
        local data = ____value[2]
        do
            if #itemId ~= 4 then
                goto __continue5
            end
            if (data and data.level) ~= _____7B49_7EA7 then
                goto __continue5
            end
            result[#result + 1] = itemId
        end
        ::__continue5::
    end
    return result
end
____exports["按装备等级随机物品ID"] = function(_____7B49_7EA7)
    local _____5019_9009_7269_54C1 = ____exports["按装备等级筛选物品ID"](_____7B49_7EA7)
    if #_____5019_9009_7269_54C1 <= 0 then
        return nil
    end
    local _____7D22_5F15 = GetRandomInt(1, #_____5019_9009_7269_54C1) - 1
    return _____5019_9009_7269_54C1[_____7D22_5F15 + 1]
end
____exports["按物品池名随机装备ID"] = function(_____7269_54C1_6C60_540D)
    local _____7B49_7EA7 = ____exports["物品池名映射装备等级"](_____7269_54C1_6C60_540D)
    if not _____7B49_7EA7 then
        return nil
    end
    return ____exports["按装备等级随机物品ID"](_____7B49_7EA7)
end
____exports.mapChestPoolNameToItemLevel = ____exports["物品池名映射装备等级"]
____exports.getItemIdsByLevel = ____exports["按装备等级筛选物品ID"]
____exports.getRandomItemIdByLevel = ____exports["按装备等级随机物品ID"]
____exports.getRandomEquipmentIdByPoolName = ____exports["按物品池名随机装备ID"]
return ____exports
