--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4EC7_6068_5B58_50A8 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getEnemyThreats = ____00_FF0E_4EC7_6068_5B58_50A8.getEnemyThreats
local getHighestThreat = ____00_FF0E_4EC7_6068_5B58_50A8.getHighestThreat
local ____02_FF0E_76EE_6807_9009_62E9 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
local _____83B7_53D6_5E94_653B_51FB_76EE_6807 = ____02_FF0E_76EE_6807_9009_62E9["获取应攻击目标"]
____exports["获取Boss技能最高仇恨目标"] = function(boss, filter)
    return getHighestThreat(boss, filter)
end
____exports["获取Boss技能应攻击目标"] = function(boss, filter)
    return _____83B7_53D6_5E94_653B_51FB_76EE_6807(boss, filter)
end
____exports["获取Boss技能仇恨目标列表"] = function(boss, filter)
    local entries = getEnemyThreats(boss)
    if filter == nil then
        return entries
    end
    local result = {}
    do
        local i = 0
        while i < #entries do
            if filter(entries[i + 1]) then
                result[#result + 1] = entries[i + 1]
            end
            i = i + 1
        end
    end
    return result
end
return ____exports
