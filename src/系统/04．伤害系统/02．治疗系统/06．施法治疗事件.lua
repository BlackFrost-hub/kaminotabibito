local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local skeyIndex, fireHealEvent, jass, jglobals, STES_GetTable, YDLocal5Set, YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex
function skeyIndex(self)
    if type(jglobals.STES_skey_index) == "number" and jglobals.STES_skey_index ~= 0 then
        return jglobals.STES_skey_index
    end
    return jass:StringHash("index")
end
function fireHealEvent(self, target, healAmount, sourcePlayer)
    local ht = STES_GetTable(nil)
    if ht == nil then
        return
    end
    local hash = jass:StringHash(____exports.HEAL_EVENT_NAME)
    local sk = skeyIndex(nil)
    local loopIndex = jass:LoadInteger(ht, hash, sk)
    do
        local i = 0
        while i < loopIndex do
            local trg = jass:LoadTriggerHandle(ht, hash, i)
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
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDWEGetUnitAbilityDataReal = ____require_result_0.YDWEGetUnitAbilityDataReal
local ____require_result_1 = require("系统.03．技能系统.00．技能事件.01．核心功能")
local registerSpellChannelListener = ____require_result_1.registerSpellChannelListener
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_GetTable = ____require_result_2.STES_GetTable
local ____require_result_3 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal5Set = ____require_result_3.YDLocal5Set
local ____require_result_4 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
YDLocalExecuteTrigger = ____require_result_4.YDLocalExecuteTrigger
YDTriggerExecuteTrigger = ____require_result_4.YDTriggerExecuteTrigger
saveParentIndex = ____require_result_4.saveParentIndex
--- STES 治疗事件名（古老马甲施法治疗分发用）
____exports.HEAL_EVENT_NAME = "治疗事件"
--- 治疗命令ID列表：医疗波/治疗链/神圣之光/死亡缠绕(治疗)
local HEAL_ORDER_IDS = {852092, 852063, 852501, 852160}
--- 技能数据字段：治疗量
local HEAL_DATA_FIELD = 108
local function isHealOrder(self, orderId)
    return __TS__ArrayIndexOf(HEAL_ORDER_IDS, orderId) >= 0
end
--- 命中古老马甲 + 治疗命令时，停手/移除技能，并对「治疗事件」所有注册子触发器派发 YDLocal5
local function onSpellChannel(self, castingUnit, spellAbilityId)
    if not jass:IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT) then
        return
    end
    local currentOrder = jass:GetUnitCurrentOrder(castingUnit)
    if not isHealOrder(nil, currentOrder) then
        return
    end
    local target = jass:GetSpellTargetUnit()
    local healAmount = YDWEGetUnitAbilityDataReal(
        nil,
        target,
        spellAbilityId,
        1,
        HEAL_DATA_FIELD
    )
    jass:IssueImmediateOrder(castingUnit, "stop")
    jass:UnitRemoveAbility(castingUnit, spellAbilityId)
    fireHealEvent(
        nil,
        target,
        healAmount,
        jass:GetOwningPlayer(castingUnit)
    )
end
local _initialized = false
--- 初始化「施法治疗事件」分发器，通过统一技能事件回调工作
function ____exports.initHealEvent(self)
    if _initialized then
        return
    end
    _initialized = true
    registerSpellChannelListener(nil, onSpellChannel)
end
return ____exports
