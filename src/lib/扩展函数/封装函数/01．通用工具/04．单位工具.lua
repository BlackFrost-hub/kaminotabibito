--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 单位工具函数
-- 判断单位类型、查找单位等
local jass = require("jass.common")
local g = require("jass.globals")
local groupScratchPool = {}
local GetUnitStateJass = jass.GetUnitState
local SetUnitStateJass = jass.SetUnitState
local ConvertUnitState = jass.ConvertUnitState
local R2I = jass.R2I
local function acquireScratchGroup(self)
    local scratch = table.remove(groupScratchPool)
    if scratch then
        return scratch
    end
    return jass:CreateGroup()
end
local function releaseScratchGroup(self, group)
    if not group or group == 0 then
        return
    end
    while true do
        local unit = jass:FirstOfGroup(group)
        if not unit or unit == 0 then
            break
        end
        jass:GroupRemoveUnit(group, unit)
    end
    groupScratchPool[#groupScratchPool + 1] = group
end
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
    if utHero ~= nil then
        return jass:IsUnitType(unit, utHero) == true
    end
    return jass:GetHeroLevel(unit) > 0
end
--- 判断单位是否为玩家单位（玩家0-4）
-- 用于区分玩家单位和敌对单位
-- 
-- @param unit 目标单位
-- @returns 是否为玩家单位
function ____exports.isPlayerUnit(self, unit)
    if unit == nil then
        return false
    end
    local owner = jass:GetOwningPlayer(unit)
    if owner == nil then
        return false
    end
    local playerId = jass:GetPlayerId(owner)
    return playerId >= 0 and playerId <= 4
end
--- 判断单位是否为马甲单位（古老单位）
-- 马甲单位造成的伤害，吸血/吸魔效果转给玩家英雄
-- 
-- @param unit 目标单位
-- @returns 是否为马甲单位
function ____exports.isAncientUnit(self, unit)
    if unit == nil then
        return false
    end
    return jass:IsUnitType(unit, jass.UNIT_TYPE_ANCIENT)
end
--- 判断单位是否为"特殊单位"（召唤物/幻象），这些单位通常不触发装备等功能
function ____exports.isSpecialUnit(self, unit)
    if not unit then
        return true
    end
    if jass:IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return true
    end
    if jass:IsUnitIllusion(unit) then
        return true
    end
    return false
end
--- 查找指定玩家的英雄单位
-- 
-- @param playerId 玩家索引（0-15）
-- @returns 英雄单位，如果没有找到返回 null
function ____exports.findHeroOfPlayer(self, playerId)
    local group = jass:CreateGroup()
    jass:GroupEnumUnitsOfPlayer(
        group,
        jass:Player(playerId),
        nil
    )
    local unit = jass:FirstOfGroup(group)
    jass:DestroyGroup(group)
    if unit and ____exports.isHeroUnit(nil, unit) then
        return unit
    end
    return nil
end
--- 用 `FirstOfGroup + while` 在 Lua 层遍历单位组，并在遍历结束后恢复原组成员。
-- 不把业务 action 挂到 JASS 的 `ForGroup` 回调里，适合联机场景逐步替换原生 `ForGroup`。
function ____exports.forEachUnitInGroup(self, group, action)
    if not group or type(action) ~= "function" then
        return
    end
    local scratch = acquireScratchGroup(nil)
    do
        local ____try, ____error = pcall(function()
            while true do
                local unit = jass:FirstOfGroup(group)
                if not unit or unit == 0 then
                    break
                end
                jass:GroupRemoveUnit(group, unit)
                jass:GroupAddUnit(scratch, unit)
                action(nil, unit)
            end
            while true do
                local unit = jass:FirstOfGroup(scratch)
                if not unit or unit == 0 then
                    break
                end
                jass:GroupRemoveUnit(scratch, unit)
                jass:GroupAddUnit(group, unit)
            end
        end)
        do
            releaseScratchGroup(nil, scratch)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
--- 获取单位的攻击类型（Attack Type）
-- 单位状态0x23对应攻击类型，使用ConvertUnitState转换
function ____exports.Ir_GetUnitAttackType(u)
    return R2I(GetUnitStateJass(
        u,
        ConvertUnitState(35)
    ))
end
function ____exports.Ir_SetUnitAttackType(u, atp)
    SetUnitStateJass(
        u,
        ConvertUnitState(35),
        atp
    )
end
--- 获取单位所属玩家的ID
-- 
-- @param unit 单位句柄
-- @returns 玩家ID（0-11），如果单位无效则返回 -1
function ____exports.getUnitOwnerId(self, unit)
    if not unit or unit == 0 then
        return -1
    end
    local owner = jass:GetOwningPlayer(unit)
    if not owner or owner == 0 then
        return -1
    end
    return jass:GetPlayerId(owner)
end
--- 检查句柄是否有效（非 null、非 0、非 undefined）
-- 
-- @param handle 任何句柄类型
-- @returns 是否有效
function ____exports.isHandleValid(self, handle)
    return handle ~= nil and handle ~= 0
end
return ____exports
