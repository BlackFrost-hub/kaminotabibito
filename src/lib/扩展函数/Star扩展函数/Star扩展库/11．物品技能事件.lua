--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local resetLastSpellContext, lastItemAbilityContext
function resetLastSpellContext(self)
    lastItemAbilityContext.abilityId = 0
    lastItemAbilityContext.targetX = 0
    lastItemAbilityContext.targetY = 0
    lastItemAbilityContext.targetUnit = nil
    lastItemAbilityContext.targetPoint = nil
end
--- Star扩展库 - 物品技能事件系统
-- 
-- 来源于 StarUnit.j，提供物品技能事件监听功能。
-- 当单位使用物品时，触发注册的物品技能事件。
-- 
-- 公开接口：
--   SU_AddItemAbilityEvent(trg)     - 注册物品技能事件
--   SU_InititemAbilityListener()    - 初始化物品技能监听
--   SU_GetLastSpellItemAbility()    - 获取最后使用的物品技能ID
--   SU_GetLastSpellItemAbilityTargetX() - 获取目标X坐标
--   SU_GetLastSpellItemAbilityTargetY() - 获取目标Y坐标
--   SU_GetLastSpellItemAbilityTargetUnit() - 获取目标单位
--   SU_GetLastSpellItemAbilityTargetPoint() - 获取目标点
-- 
-- 依赖：
--   - StarBaseHT (jass.globals.StarBaseHT) - 统一回调哈希表
--   - YDHT (jass.globals.YDHT) - 逆天哈希表
--   - StrHEX(s) = StringHash(s) - 字符串转哈希码
local jass = require("jass.common")
local jglobals = require("jass.globals")
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local ____require_result_0 = require("系统.03．技能系统.00．技能事件.01．核心功能")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
lastItemAbilityContext = {
    abilityId = 0,
    targetX = 0,
    targetY = 0,
    targetUnit = nil,
    targetPoint = nil
}
local su_iatList = {}
local su_iatIndex = 0
local su_ItemAbilityTrig2 = nil
local su_ItemAbilityInited = false
local STAR_ITEM_ABILITY_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
local HASH_LAST_SPELL = jass.StringHash("最后使用的技能")
local HASH_LAST_SPELL_X = jass.StringHash("最后使用的技能X")
local HASH_LAST_SPELL_Y = jass.StringHash("最后使用的技能Y")
local HASH_LAST_SPELL_TARGET_UNIT = jass.StringHash("最后使用的技能目标单位")
local HASH_ITEM_ABILITY_INDEX = jass.StringHash("物品技能事件索引")
local function getStarBaseHT(self)
    local ____temp_1
    if jglobals and jglobals.StarBaseHT then
        ____temp_1 = jglobals.StarBaseHT
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
local function getYDHT(self)
    local ____temp_2
    if jglobals and jglobals.YDHT then
        ____temp_2 = jglobals.YDHT
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
local function getTriggerUnitOrNull(self)
    return jass.GetTriggerUnit()
end
local function saveLastSpellContext(self, caster)
    local StarBaseHT = getStarBaseHT(nil)
    if caster == nil or StarBaseHT == nil then
        return
    end
    local hd = jass.GetHandleId(caster)
    local spellId = jass.GetSpellAbilityId()
    local x = jass.GetSpellTargetX()
    local y = jass.GetSpellTargetY()
    local targetUnit = jass.GetSpellTargetUnit()
    jass.SaveInteger(StarBaseHT, hd, HASH_LAST_SPELL, spellId)
    jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_X, x)
    jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_Y, y)
    jass.SaveUnitHandle(StarBaseHT, hd, HASH_LAST_SPELL_TARGET_UNIT, targetUnit)
end
local function loadLastSpellContext(self, caster)
    local StarBaseHT = getStarBaseHT(nil)
    if caster == nil or StarBaseHT == nil then
        resetLastSpellContext(nil)
        return
    end
    local hd = jass.GetHandleId(caster)
    lastItemAbilityContext.abilityId = jass.LoadInteger(StarBaseHT, hd, HASH_LAST_SPELL)
    lastItemAbilityContext.targetX = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_X)
    lastItemAbilityContext.targetY = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_Y)
    lastItemAbilityContext.targetUnit = jass.LoadUnitHandle(StarBaseHT, hd, HASH_LAST_SPELL_TARGET_UNIT)
    if lastItemAbilityContext.targetUnit == 0 then
        lastItemAbilityContext.targetUnit = nil
    end
end
local function createLastSpellTargetPoint(self)
    lastItemAbilityContext.targetPoint = nil
    lastItemAbilityContext.targetPoint = jass.Location(lastItemAbilityContext.targetX, lastItemAbilityContext.targetY)
end
local function destroyLastSpellTargetPoint(self)
    if lastItemAbilityContext.targetPoint == nil then
        return
    end
    jass.RemoveLocation(lastItemAbilityContext.targetPoint)
    lastItemAbilityContext.targetPoint = nil
end
local function fireItemAbilityEvents(self)
    if #su_iatList <= 0 then
        return
    end
    createLastSpellTargetPoint(nil)
    do
        local i = 0
        while i < #su_iatList do
            do
                local trig = su_iatList[i + 1]
                if trig == nil then
                    goto __continue17
                end
                if not jass.IsTriggerEnabled(trig) then
                    goto __continue17
                end
                if not jass.TriggerEvaluate(trig) then
                    goto __continue17
                end
                jass.TriggerExecute(trig)
            end
            ::__continue17::
            i = i + 1
        end
    end
    destroyLastSpellTargetPoint(nil)
end
--- 注册物品技能事件
-- 
-- @param trg 触发器
function ____exports.SU_AddItemAbilityEvent(self, trg)
    if trg == nil or trg == 0 then
        return
    end
    local YDHT = getYDHT(nil)
    if YDHT == nil then
        return
    end
    local hd = jass.GetHandleId(trg)
    local hasIndex = jass.HaveSavedInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX)
    if not hasIndex then
        jass.SaveInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX, su_iatIndex)
        su_iatList[su_iatIndex + 1] = trg
        su_iatIndex = su_iatIndex + 1
    end
end
--- 技能施放回调（内部使用）
local function SU_InititemAbilityListener_1(self)
    local u = getTriggerUnitOrNull(nil)
    if u == nil then
        return
    end
    saveLastSpellContext(nil, u)
end
--- 物品使用回调（内部使用）
local function SU_InititemAbilityListener_2(self)
    local u = getTriggerUnitOrNull(nil)
    if u == nil then
        return
    end
    loadLastSpellContext(nil, u)
    fireItemAbilityEvents(nil)
end
--- 初始化物品技能监听
-- 需要在地图初始化时调用
function ____exports.SU_InititemAbilityListener(self)
    if su_ItemAbilityInited then
        return
    end
    su_ItemAbilityTrig2 = jass.CreateTrigger()
    if su_ItemAbilityTrig2 == nil then
        return
    end
    registerSpellEffectListener(nil, SU_InititemAbilityListener_1)
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(su_ItemAbilityTrig2, STAR_ITEM_ABILITY_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_USE_ITEM)
    jass.TriggerAddAction(su_ItemAbilityTrig2, SU_InititemAbilityListener_2)
    su_ItemAbilityInited = true
end
--- 获取最后使用的物品技能ID
function ____exports.SU_GetLastSpellItemAbility(self)
    return lastItemAbilityContext.abilityId
end
--- 获取最后使用的物品技能目标X坐标
function ____exports.SU_GetLastSpellItemAbilityTargetX(self)
    return lastItemAbilityContext.targetX
end
--- 获取最后使用的物品技能目标Y坐标
function ____exports.SU_GetLastSpellItemAbilityTargetY(self)
    return lastItemAbilityContext.targetY
end
--- 获取最后使用的物品技能目标单位
function ____exports.SU_GetLastSpellItemAbilityTargetUnit(self)
    return lastItemAbilityContext.targetUnit
end
--- 获取最后使用的物品技能目标点
function ____exports.SU_GetLastSpellItemAbilityTargetPoint(self)
    return lastItemAbilityContext.targetPoint
end
return ____exports
