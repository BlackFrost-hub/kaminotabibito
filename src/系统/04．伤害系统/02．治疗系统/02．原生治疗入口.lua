local ____lualib = require("lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
--- 治疗事件系统（旧版兼容）
-- 
-- 功能：马甲单位施放治疗技能时，执行治疗
-- 
-- 工作流程：
-- 1. TS端检测马甲单位施放治疗技能
-- 2. 直接调用 doHeal 执行治疗（TS函数参数传参，不需要YDLocal）
-- 3. doHeal 内部会触发相关STES事件
-- 
-- 后续接手者注意：
-- 1. 治疗命令ID列表可根据需要扩展
-- 2. 直接调用 doHeal，不需要手动触发STES事件
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellChannelListener = ____require_result_0.registerSpellChannelListener
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetSpellAbilityId = ____require_result_1.GetSpellAbilityId
local ____require_result_2 = require("lib.扩展函数.YDWE函数.index")
local YDWEGetUnitAbilityDataReal = ____require_result_2.YDWEGetUnitAbilityDataReal
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_3.doHeal
--- 治疗命令ID列表
local HEAL_ORDER_IDS = {852092, 852063, 852501, 852160}
--- 技能数据字段：治疗量（DataA = 108）
local HEAL_DATA_FIELD = 108
--- 系统开关
local NATIVE_HEAL_ENTRY_ENABLED = true
--- 检查命令ID是否为治疗命令
local function isHealOrder(orderId)
    return __TS__ArrayIncludes(HEAL_ORDER_IDS, orderId)
end
--- 检查单位是否为马甲单位（古树类型）
local function isProxyUnit(unit)
    if unit == nil then
        return false
    end
    return jass:IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) == true
end
--- 触发器实例
local nativeHealEntryInitialized = false
--- 治疗事件处理函数
-- 
-- 逻辑：
-- 1. 检查施法者是否为马甲单位（古树类型）
-- 2. 检查当前命令是否为治疗命令
-- 3. 获取施法者的技能数据（治疗量）
-- 4. 发出stop命令并移除技能
-- 5. 直接调用 doHeal 执行治疗（TS参数传参）
local function onSpellChannel(castingUnit, spellAbilityId)
    local ____temp_4
    if castingUnit ~= nil then
        ____temp_4 = castingUnit
    else
        ____temp_4 = jass:GetTriggerUnit()
    end
    local caster = ____temp_4
    local abilityId = spellAbilityId ~= nil and spellAbilityId or GetSpellAbilityId(nil)
    if not isProxyUnit(caster) then
        return
    end
    local currentOrder = jass:GetUnitCurrentOrder(caster)
    if not isHealOrder(currentOrder) then
        return
    end
    local target = jass:GetSpellTargetUnit()
    if target == nil then
        return
    end
    local healAmount = YDWEGetUnitAbilityDataReal(
        nil,
        caster,
        abilityId,
        1,
        HEAL_DATA_FIELD
    )
    jass:IssueImmediateOrder(caster, "stop")
    jass:UnitRemoveAbility(caster, abilityId)
    doHeal(nil, {
        HealSource = caster,
        HealTarget = target,
        HealAmount = healAmount,
        ItemHeal = false,
        HealEffect = true
    })
end
--- 初始化治疗事件系统（旧版）
-- 
-- 注册 EVENT_PLAYER_UNIT_SPELL_CHANNEL 事件
-- 当任意马甲单位施放治疗技能时触发
function ____exports.initNativeHealEntry()
    if not NATIVE_HEAL_ENTRY_ENABLED then
        return
    end
    if nativeHealEntryInitialized then
        return
    end
    nativeHealEntryInitialized = true
    registerSpellChannelListener(onSpellChannel)
end
--- 检查系统是否已初始化
function ____exports.isNativeHealEntryInitialized()
    return nativeHealEntryInitialized
end
return ____exports
