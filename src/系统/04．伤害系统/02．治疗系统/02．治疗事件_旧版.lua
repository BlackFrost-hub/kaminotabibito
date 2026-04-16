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
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local TriggerRegisterAnyUnitEventBJ = ____require_result_0.TriggerRegisterAnyUnitEventBJ
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetSpellAbilityId = ____require_result_1.GetSpellAbilityId
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
--- 治疗命令ID列表
local HEAL_ORDER_IDS = {852092, 852063, 852501, 852160}
--- 技能数据字段：治疗量（DataA = 108）
local HEAL_DATA_FIELD = 108
--- 系统开关
local HEAL_EVENT_OLD_ENABLED = true
--- 检查命令ID是否为治疗命令
local function isHealOrder(self, orderId)
    return __TS__ArrayIncludes(HEAL_ORDER_IDS, orderId)
end
--- 检查单位是否为马甲单位（古树类型）
local function isProxyUnit(self, unit)
    if unit == nil then
        return false
    end
    return jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) == true
end
--- 触发器实例
local healEventOldTrigger = nil
--- 治疗事件处理函数
-- 
-- 逻辑：
-- 1. 检查施法者是否为马甲单位（古树类型）
-- 2. 检查当前命令是否为治疗命令
-- 3. 获取施法者的技能数据（治疗量）
-- 4. 发出stop命令并移除技能
-- 5. 直接调用 doHeal 执行治疗（TS参数传参）
local function onSpellChannel(self)
    local caster = jass.GetTriggerUnit()
    local abilityId = GetSpellAbilityId(nil)
    if not isProxyUnit(nil, caster) then
        return
    end
    local currentOrder = jass.GetUnitCurrentOrder(caster)
    if not isHealOrder(nil, currentOrder) then
        return
    end
    local target = jass.GetSpellTargetUnit()
    if target == nil then
        return
    end
    local healAmount = japi.YDWEGetUnitAbilityDataReal(caster, abilityId, 1, HEAL_DATA_FIELD)
    jass.IssueImmediateOrder(caster, "stop")
    jass.UnitRemoveAbility(caster, abilityId)
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
function ____exports.initHealEventOld(self)
    if not HEAL_EVENT_OLD_ENABLED then
        return
    end
    if healEventOldTrigger ~= nil then
        return
    end
    healEventOldTrigger = jass.CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(nil, healEventOldTrigger, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    jass.TriggerAddAction(healEventOldTrigger, onSpellChannel)
end
--- 检查系统是否已初始化
function ____exports.isHealEventOldInitialized(self)
    return healEventOldTrigger ~= nil
end
return ____exports
