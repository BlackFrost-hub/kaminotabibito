--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 单位工具函数
-- 判断单位类型、查找单位等
local jass = require("jass.common")
local japi = require("jass.japi")
local g = require("jass.globals")
--- 判断单位是否为英雄单位
function ____exports.isHeroUnit(self, unit)
    if not unit then
        return false
    end
    local ____jass_UNIT_TYPE_HERO_0 = jass.UNIT_TYPE_HERO
    if ____jass_UNIT_TYPE_HERO_0 == nil then
        ____jass_UNIT_TYPE_HERO_0 = g.UNIT_TYPE_HERO
    end
    local utHero = ____jass_UNIT_TYPE_HERO_0
    if utHero ~= nil and type(jass.IsUnitType) == "function" then
        return jass.IsUnitType(unit, utHero) == true
    end
    if type(jass.GetHeroLevel) == "function" then
        return jass.GetHeroLevel(unit) > 0
    end
    return false
end
--- 判断单位是否为"特殊单位"（召唤物/幻象），这些单位通常不触发装备等功能
function ____exports.isSpecialUnit(self, unit)
    if not unit then
        return true
    end
    if jass.UNIT_TYPE_SUMMONED ~= nil and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return true
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return true
    end
    if type(jass.IsUnitIllusion) == "function" and jass.IsUnitIllusion(unit) then
        return true
    end
    return false
end
--- 查找指定玩家的英雄单位
-- 
-- @param playerId 玩家索引（0-15）
-- @returns 英雄单位，如果没有找到返回 null
function ____exports.findHeroOfPlayer(self, playerId)
    if type(jass.CreateGroup) ~= "function" or type(jass.GroupEnumUnitsOfPlayer) ~= "function" then
        return nil
    end
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsOfPlayer(
        group,
        jass.Player(playerId),
        nil
    )
    local unit = jass.FirstOfGroup(group)
    jass.DestroyGroup(group)
    if unit and ____exports.isHeroUnit(nil, unit) then
        return unit
    end
    return nil
end
--- 获取单位的攻击类型（Attack Type）
-- 单位状态0x23对应攻击类型，使用ConvertUnitState转换
function ____exports.Ir_GetUnitAttackType(self, u)
    return jass.R2I(japi.GetUnitState(
        u,
        jass.ConvertUnitState(35)
    ))
end
function ____exports.Ir_SetUnitAttackType(self, u, atp)
    japi.SetUnitState(
        u,
        jass.ConvertUnitState(35),
        atp
    )
end
return ____exports
