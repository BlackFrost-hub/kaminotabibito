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
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local TriggerRegisterAnyUnitEventBJ = ____require_result_0.TriggerRegisterAnyUnitEventBJ
lastItemAbilityContext = {
    abilityId = 0,
    targetX = 0,
    targetY = 0,
    targetUnit = nil,
    targetPoint = nil
}
local su_iatList = {}
local su_iatIndex = 0
local su_ItemAbilityTrig = nil
local su_ItemAbilityTrig2 = nil
local su_ItemAbilityInited = false
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
    local ____temp_3
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_3 = jass.GetTriggerUnit()
    else
        ____temp_3 = nil
    end
    return ____temp_3
end
local function saveLastSpellContext(self, caster)
    local StarBaseHT = getStarBaseHT(nil)
    if caster == nil or StarBaseHT == nil then
        return
    end
    local hd = jass.GetHandleId(caster)
    local ____temp_4
    if type(jass.GetSpellAbilityId) == "function" then
        ____temp_4 = jass.GetSpellAbilityId()
    else
        ____temp_4 = 0
    end
    local spellId = ____temp_4
    local ____temp_5
    if type(jass.GetSpellTargetX) == "function" then
        ____temp_5 = jass.GetSpellTargetX()
    else
        ____temp_5 = 0
    end
    local x = ____temp_5
    local ____temp_6
    if type(jass.GetSpellTargetY) == "function" then
        ____temp_6 = jass.GetSpellTargetY()
    else
        ____temp_6 = 0
    end
    local y = ____temp_6
    local ____temp_7
    if type(jass.GetSpellTargetUnit) == "function" then
        ____temp_7 = jass.GetSpellTargetUnit()
    else
        ____temp_7 = nil
    end
    local targetUnit = ____temp_7
    if type(jass.SaveInteger) == "function" then
        jass.SaveInteger(StarBaseHT, hd, HASH_LAST_SPELL, spellId)
    end
    if type(jass.SaveReal) == "function" then
        jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_X, x)
        jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_Y, y)
    end
    if type(jass.SaveUnitHandle) == "function" then
        jass.SaveUnitHandle(StarBaseHT, hd, HASH_LAST_SPELL_TARGET_UNIT, targetUnit)
    end
end
local function loadLastSpellContext(self, caster)
    local StarBaseHT = getStarBaseHT(nil)
    if caster == nil or StarBaseHT == nil then
        resetLastSpellContext(nil)
        return
    end
    local hd = jass.GetHandleId(caster)
    local ____temp_8
    if type(jass.LoadInteger) == "function" then
        ____temp_8 = jass.LoadInteger(StarBaseHT, hd, HASH_LAST_SPELL)
    else
        ____temp_8 = 0
    end
    lastItemAbilityContext.abilityId = ____temp_8
    local ____temp_9
    if type(jass.LoadReal) == "function" then
        ____temp_9 = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_X)
    else
        ____temp_9 = 0
    end
    lastItemAbilityContext.targetX = ____temp_9
    local ____temp_10
    if type(jass.LoadReal) == "function" then
        ____temp_10 = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_Y)
    else
        ____temp_10 = 0
    end
    lastItemAbilityContext.targetY = ____temp_10
    local ____temp_11
    if type(jass.LoadUnitHandle) == "function" then
        ____temp_11 = jass.LoadUnitHandle(StarBaseHT, hd, HASH_LAST_SPELL_TARGET_UNIT)
    else
        ____temp_11 = nil
    end
    lastItemAbilityContext.targetUnit = ____temp_11
    if lastItemAbilityContext.targetUnit == 0 then
        lastItemAbilityContext.targetUnit = nil
    end
end
local function createLastSpellTargetPoint(self)
    lastItemAbilityContext.targetPoint = nil
    if type(jass.Location) ~= "function" then
        return
    end
    lastItemAbilityContext.targetPoint = jass.Location(lastItemAbilityContext.targetX, lastItemAbilityContext.targetY)
end
local function destroyLastSpellTargetPoint(self)
    if lastItemAbilityContext.targetPoint == nil then
        return
    end
    if type(jass.RemoveLocation) == "function" then
        jass.RemoveLocation(lastItemAbilityContext.targetPoint)
    end
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
                    goto __continue22
                end
                if type(jass.IsTriggerEnabled) == "function" and not jass.IsTriggerEnabled(trig) then
                    goto __continue22
                end
                if type(jass.TriggerEvaluate) == "function" and not jass.TriggerEvaluate(trig) then
                    goto __continue22
                end
                if type(jass.TriggerExecute) == "function" then
                    jass.TriggerExecute(trig)
                end
            end
            ::__continue22::
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
    local hasIndex = type(jass.HaveSavedInteger) == "function" and jass.HaveSavedInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX)
    if not hasIndex then
        if type(jass.SaveInteger) == "function" then
            jass.SaveInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX, su_iatIndex)
        end
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
    local ____temp_12
    if type(jass.CreateTrigger) == "function" then
        ____temp_12 = jass.CreateTrigger()
    else
        ____temp_12 = nil
    end
    su_ItemAbilityTrig = ____temp_12
    local ____temp_13
    if type(jass.CreateTrigger) == "function" then
        ____temp_13 = jass.CreateTrigger()
    else
        ____temp_13 = nil
    end
    su_ItemAbilityTrig2 = ____temp_13
    if su_ItemAbilityTrig == nil or su_ItemAbilityTrig2 == nil then
        return
    end
    TriggerRegisterAnyUnitEventBJ(nil, su_ItemAbilityTrig, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerRegisterAnyUnitEventBJ(nil, su_ItemAbilityTrig2, jass.EVENT_PLAYER_UNIT_USE_ITEM)
    if type(jass.TriggerAddAction) == "function" then
        jass.TriggerAddAction(su_ItemAbilityTrig, SU_InititemAbilityListener_1)
        jass.TriggerAddAction(su_ItemAbilityTrig2, SU_InititemAbilityListener_2)
    end
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
