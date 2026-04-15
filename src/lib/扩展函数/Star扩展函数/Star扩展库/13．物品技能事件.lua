--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
--   SU_GetLastSpellItemAbilityTargetPoint() - 获取目标点
-- 
-- 依赖：
--   - StarBaseHT (jass.globals.StarBaseHT) - 统一回调哈希表
--   - YDHT (jass.globals.YDHT) - 逆天哈希表
--   - StrHEX(s) = StringHash(s) - 字符串转哈希码
local jass = require("jass.common")
local jglobals = require("jass.globals")
local Star_LastSpellItemAbility = 0
local Star_LastSpellItemAbilityTargetX = 0
local Star_LastSpellItemAbilityTargetY = 0
local Star_LastSpellItemAbilityTargetPoint = nil
local su_iatList = {}
local su_iatIndex = 0
local su_ItemAbilityTrig = nil
local su_ItemAbilityTrig2 = nil
local HASH_LAST_SPELL = jass.StringHash("最后使用的技能")
local HASH_LAST_SPELL_X = jass.StringHash("最后使用的技能X")
local HASH_LAST_SPELL_Y = jass.StringHash("最后使用的技能Y")
local HASH_ITEM_ABILITY_INDEX = jass.StringHash("物品技能事件索引")
--- 注册物品技能事件
-- 
-- @param trg 触发器
function ____exports.SU_AddItemAbilityEvent(self, trg)
    if trg == nil or trg == 0 then
        return
    end
    local ____temp_0
    if jglobals and jglobals.YDHT then
        ____temp_0 = jglobals.YDHT
    else
        ____temp_0 = nil
    end
    local YDHT = ____temp_0
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
    local ____temp_1
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_1 = jass.GetTriggerUnit()
    else
        ____temp_1 = nil
    end
    local u = ____temp_1
    if u == nil then
        return
    end
    local hd = jass.GetHandleId(u)
    local ____temp_2
    if jglobals and jglobals.StarBaseHT then
        ____temp_2 = jglobals.StarBaseHT
    else
        ____temp_2 = nil
    end
    local StarBaseHT = ____temp_2
    if StarBaseHT ~= nil and type(jass.SaveInteger) == "function" then
        local ____temp_3
        if type(jass.GetSpellAbilityId) == "function" then
            ____temp_3 = jass.GetSpellAbilityId()
        else
            ____temp_3 = 0
        end
        local spellId = ____temp_3
        jass.SaveInteger(StarBaseHT, hd, HASH_LAST_SPELL, spellId)
    end
    if StarBaseHT ~= nil and type(jass.SaveReal) == "function" then
        local ____temp_4
        if type(jass.GetSpellTargetX) == "function" then
            ____temp_4 = jass.GetSpellTargetX()
        else
            ____temp_4 = 0
        end
        local x = ____temp_4
        local ____temp_5
        if type(jass.GetSpellTargetY) == "function" then
            ____temp_5 = jass.GetSpellTargetY()
        else
            ____temp_5 = 0
        end
        local y = ____temp_5
        jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_X, x)
        jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_Y, y)
    end
end
--- 物品使用回调（内部使用）
local function SU_InititemAbilityListener_2(self)
    local ____temp_6
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_6 = jass.GetTriggerUnit()
    else
        ____temp_6 = nil
    end
    local u = ____temp_6
    if u == nil then
        return
    end
    local hd = jass.GetHandleId(u)
    local ____temp_7
    if jglobals and jglobals.StarBaseHT then
        ____temp_7 = jglobals.StarBaseHT
    else
        ____temp_7 = nil
    end
    local StarBaseHT = ____temp_7
    if StarBaseHT ~= nil then
        local ____temp_8
        if type(jass.LoadInteger) == "function" then
            ____temp_8 = jass.LoadInteger(StarBaseHT, hd, HASH_LAST_SPELL)
        else
            ____temp_8 = 0
        end
        Star_LastSpellItemAbility = ____temp_8
        local ____temp_9
        if type(jass.LoadReal) == "function" then
            ____temp_9 = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_X)
        else
            ____temp_9 = 0
        end
        Star_LastSpellItemAbilityTargetX = ____temp_9
        local ____temp_10
        if type(jass.LoadReal) == "function" then
            ____temp_10 = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_Y)
        else
            ____temp_10 = 0
        end
        Star_LastSpellItemAbilityTargetY = ____temp_10
    end
    if su_iatIndex > 0 then
        if type(jass.Location) == "function" then
            Star_LastSpellItemAbilityTargetPoint = jass.Location(Star_LastSpellItemAbilityTargetX, Star_LastSpellItemAbilityTargetY)
        end
        do
            local i = 0
            while i < su_iatIndex do
                local trig = su_iatList[i + 1]
                if trig ~= nil and type(jass.IsTriggerEnabled) == "function" and jass.IsTriggerEnabled(trig) then
                    if type(jass.TriggerEvaluate) == "function" and jass.TriggerEvaluate(trig) then
                        jass.TriggerExecute(trig)
                    end
                end
                i = i + 1
            end
        end
        if Star_LastSpellItemAbilityTargetPoint ~= nil then
            if type(jass.RemoveLocation) == "function" then
                jass.RemoveLocation(Star_LastSpellItemAbilityTargetPoint)
            end
            Star_LastSpellItemAbilityTargetPoint = nil
        end
    end
end
--- 初始化物品技能监听
-- 需要在地图初始化时调用
function ____exports.SU_InititemAbilityListener(self)
    local ____temp_11
    if type(jass.CreateTrigger) == "function" then
        ____temp_11 = jass.CreateTrigger()
    else
        ____temp_11 = nil
    end
    su_ItemAbilityTrig = ____temp_11
    local ____temp_12
    if type(jass.CreateTrigger) == "function" then
        ____temp_12 = jass.CreateTrigger()
    else
        ____temp_12 = nil
    end
    su_ItemAbilityTrig2 = ____temp_12
    if su_ItemAbilityTrig == nil or su_ItemAbilityTrig2 == nil then
        return
    end
    if type(jass.TriggerRegisterAnyUnitEventBJ) == "function" then
        jass.TriggerRegisterAnyUnitEventBJ(su_ItemAbilityTrig, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT)
    end
    if type(jass.TriggerRegisterAnyUnitEventBJ) == "function" then
        jass.TriggerRegisterAnyUnitEventBJ(su_ItemAbilityTrig2, jass.EVENT_PLAYER_UNIT_USE_ITEM)
    end
    if type(jass.TriggerAddAction) == "function" then
        jass.TriggerAddAction(su_ItemAbilityTrig, SU_InititemAbilityListener_1)
        jass.TriggerAddAction(su_ItemAbilityTrig2, SU_InititemAbilityListener_2)
    end
end
--- 获取最后使用的物品技能ID
function ____exports.SU_GetLastSpellItemAbility(self)
    return Star_LastSpellItemAbility
end
--- 获取最后使用的物品技能目标X坐标
function ____exports.SU_GetLastSpellItemAbilityTargetX(self)
    return Star_LastSpellItemAbilityTargetX
end
--- 获取最后使用的物品技能目标Y坐标
function ____exports.SU_GetLastSpellItemAbilityTargetY(self)
    return Star_LastSpellItemAbilityTargetY
end
--- 获取最后使用的物品技能目标点
function ____exports.SU_GetLastSpellItemAbilityTargetPoint(self)
    return Star_LastSpellItemAbilityTargetPoint
end
return ____exports
