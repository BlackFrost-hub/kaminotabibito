local ____lualib = require("lualib_bundle")
local __TS__ArrayIncludes = ____lualib.__TS__ArrayIncludes
local ____exports = {}
local skeyIndex, fireHealEvent, jass, jglobals, STES_GetTable, YDLocal5Set, YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex
function skeyIndex(self)
    if type(jglobals.STES_skey_index) == "number" and jglobals.STES_skey_index ~= 0 then
        return jglobals.STES_skey_index
    end
    if type(jass.StringHash) == "function" then
        return jass.StringHash("index")
    end
    return 0
end
function fireHealEvent(self, target, healAmount, sourcePlayer)
    local ht = STES_GetTable(nil)
    if ht == nil then
        return
    end
    local hash = jass.StringHash(____exports.HEAL_EVENT_NAME)
    local sk = skeyIndex(nil)
    local loopIndex = jass.LoadInteger(ht, hash, sk)
    do
        local i = 0
        while i < loopIndex do
            local trg = jass.LoadTriggerHandle(ht, hash, i)
            if trg then
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                YDLocal5Set(nil, "real", "HealAmount", healAmount)
                YDLocal5Set(nil, "unit", "HealTarget", target)
                YDLocal5Set(nil, "unit", "HealSource", nil)
                YDLocal5Set(nil, "player", "HealSourcePlayer", sourcePlayer)
                YDLocal5Set(nil, "boolean", "HealEffect", true)
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            i = i + 1
        end
    end
end
jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local TriggerRegisterAnyUnitEventBJ = ____require_result_0.TriggerRegisterAnyUnitEventBJ
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetSpellAbilityId = ____require_result_1.GetSpellAbilityId
local ____require_result_2 = require("lib.扩展函数.YDWE函数.index")
local YDWEGetUnitAbilityDataReal = ____require_result_2.YDWEGetUnitAbilityDataReal
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_GetTable = ____require_result_3.STES_GetTable
local STES_Fire = ____require_result_3.STES_Fire
local ____require_result_4 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal5Set = ____require_result_4.YDLocal5Set
local YDLocal7Set = ____require_result_4.YDLocal7Set
local clearStar_PIndex = ____require_result_4.clearStar_PIndex
local ____require_result_5 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
YDLocalExecuteTrigger = ____require_result_5.YDLocalExecuteTrigger
YDTriggerExecuteTrigger = ____require_result_5.YDTriggerExecuteTrigger
saveParentIndex = ____require_result_5.saveParentIndex
--- 治疗事件名称
____exports.HEAL_EVENT_NAME = "治疗事件"
--- 治疗命令ID列表
local HEAL_ORDER_IDS = {852092, 852063, 852501, 852160}
--- 技能数据字段：治疗量
local HEAL_DATA_FIELD = 108
--- 检查命令ID是否为治疗命令
local function isHealOrder(self, orderId)
    return __TS__ArrayIncludes(HEAL_ORDER_IDS, orderId)
end
--- 触发器
local healEventTrigger = nil
--- 治疗事件处理函数
local function onSpellChannel(self)
    local caster = jass.GetTriggerUnit()
    local abilityId = GetSpellAbilityId(nil)
    local target = jass.GetSpellTargetUnit()
    if not jass.IsUnitType(caster, jass.UNIT_TYPE_ANCIENT) then
        return
    end
    local currentOrder = jass.GetUnitCurrentOrder(caster)
    if not isHealOrder(nil, currentOrder) then
        return
    end
    local healAmount = YDWEGetUnitAbilityDataReal(
        nil,
        target,
        abilityId,
        1,
        HEAL_DATA_FIELD
    )
    jass.IssueImmediateOrder(caster, "stop")
    jass.UnitRemoveAbility(caster, abilityId)
    fireHealEvent(
        nil,
        target,
        healAmount,
        jass.GetOwningPlayer(caster)
    )
end
--- 初始化治疗事件系统
function ____exports.initHealEvent(self)
    if healEventTrigger ~= nil then
        return
    end
    healEventTrigger = jass.CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(nil, healEventTrigger, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    jass.TriggerAddAction(healEventTrigger, onSpellChannel)
end
return ____exports
