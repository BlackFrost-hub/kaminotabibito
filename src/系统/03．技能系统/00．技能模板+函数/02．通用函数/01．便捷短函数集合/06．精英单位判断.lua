--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 精英单位判断便捷函数
-- 
-- 功能：判断单位是否是精英单位
-- 精英单位定义：恶魔种族 或 英雄类型
local jass = require("jass.common")
local IsUnitRace = jass.IsUnitRace
local IsUnitType = jass.IsUnitType
local RACE_DEMON = jass.RACE_DEMON
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
--- 判断是否是精英单位
-- 精英单位：恶魔种族 或 英雄类型
____exports["是否精英单位"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return IsUnitRace(unit, RACE_DEMON) == true or IsUnitType(unit, UNIT_TYPE_HERO) == true
end
--- 判断是否是恶魔单位
____exports["是否恶魔单位"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return IsUnitRace(unit, RACE_DEMON) == true
end
--- 判断是否是英雄单位
____exports["是否英雄单位"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return IsUnitType(unit, UNIT_TYPE_HERO) == true
end
--- 判断是否是普通敌人（杂鱼/蝼蚁/普通敌人/野怪）
-- 条件：恶魔种族 或 野兽种族
-- RACE_DEMON = 恶魔种族
-- ConvertRace(8) = 野兽种族
____exports["是否普通敌人"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local RACE_BEAST = jass.ConvertRace(8)
    return IsUnitRace(unit, RACE_DEMON) == true or IsUnitRace(unit, RACE_BEAST) == true
end
--- 判断是否是蝼蚁敌人（普通敌人 + 非恶魔 + 非英雄）
____exports["是否蝼蚁敌人"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if IsUnitRace(unit, RACE_DEMON) == true then
        return false
    end
    if IsUnitType(unit, UNIT_TYPE_HERO) == true then
        return false
    end
    local RACE_BEAST = jass.ConvertRace(8)
    return IsUnitRace(unit, RACE_BEAST) == true
end
return ____exports
