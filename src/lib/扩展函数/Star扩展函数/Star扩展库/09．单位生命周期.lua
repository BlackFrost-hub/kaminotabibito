--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 单位生命周期函数
-- 
-- 来源于 StarUnit.j，提供单位生命周期类型判断功能。
-- 
-- 公开接口：
--   IsWaterElement(u)          - 判断是否为水元素
--   GetUnitTimedLifeID(u)      - 获取单位生命周期类型ID
--   I2TimedLifeID(i)           - 整数转生命周期枚举ID（GUI封装）
local jass = require("jass.common")
____exports.TIMED_LIFE_NONE = 0
____exports.TIMED_LIFE_RAISE_DEAD = 1
____exports.TIMED_LIFE_DISEASE_CLOUD = 2
____exports.TIMED_LIFE_FORCE_OF_NATURE = 3
____exports.TIMED_LIFE_HEALING_WARD = 4
____exports.TIMED_LIFE_ANIMATE_DEAD = 5
____exports.TIMED_LIFE_WATER_ELEMENTAL = 6
____exports.TIMED_LIFE_TIMED = 7
--- 判断单位是否为水元素
-- 
-- @param u 目标单位
-- @returns 是否为水元素
function ____exports.IsWaterElement(self, u)
    if u == nil or u == 0 then
        return false
    end
    local BHWE = 1112045413
    return type(jass.GetUnitAbilityLevel) == "function" and jass.GetUnitAbilityLevel(u, BHWE) ~= 0
end
--- 获取单位生命周期类型ID
-- 
-- @param u 目标单位
-- @returns 生命周期类型ID（0-7）
function ____exports.GetUnitTimedLifeID(self, u)
    if u == nil or u == 0 then
        return ____exports.TIMED_LIFE_NONE
    end
    if type(jass.GetUnitAbilityLevel) ~= "function" then
        return ____exports.TIMED_LIFE_NONE
    end
    if jass.GetUnitAbilityLevel(u, 1112891758) ~= 0 then
        return ____exports.TIMED_LIFE_RAISE_DEAD
    end
    if jass.GetUnitAbilityLevel(u, 1113682028) ~= 0 then
        return ____exports.TIMED_LIFE_DISEASE_CLOUD
    end
    if jass.GetUnitAbilityLevel(u, 1111844462) ~= 0 then
        return ____exports.TIMED_LIFE_FORCE_OF_NATURE
    end
    if jass.GetUnitAbilityLevel(u, 1114142564) ~= 0 then
        return ____exports.TIMED_LIFE_HEALING_WARD
    end
    if jass.GetUnitAbilityLevel(u, 1114792297) ~= 0 then
        return ____exports.TIMED_LIFE_ANIMATE_DEAD
    end
    if jass.GetUnitAbilityLevel(u, 1112045413) ~= 0 then
        return ____exports.TIMED_LIFE_WATER_ELEMENTAL
    end
    if jass.GetUnitAbilityLevel(u, 1112820806) ~= 0 then
        return ____exports.TIMED_LIFE_TIMED
    end
    return ____exports.TIMED_LIFE_NONE
end
--- 整数转生命周期枚举ID（GUI封装）
-- 
-- @param i 整数值
-- @returns 生命周期枚举ID
function ____exports.I2TimedLifeID(self, i)
    return i
end
return ____exports
