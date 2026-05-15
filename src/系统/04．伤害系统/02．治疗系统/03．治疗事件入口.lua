local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local skeyIndex, dispatchHealRequestEvent, jass, jglobals, STES_GetTable, YDLocal5Set, YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.04．伤害系统.02．治疗系统.00．常量定义")
local HEAL_EVENTS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_EVENTS
local HEAL_REQUEST_KEYS = ____00_FF0E_5E38_91CF_5B9A_4E49.HEAL_REQUEST_KEYS
function skeyIndex()
    if type(jglobals.STES_skey_index) == "number" and jglobals.STES_skey_index ~= 0 then
        return jglobals.STES_skey_index
    end
    return jass.StringHash("index")
end
function dispatchHealRequestEvent(target, healAmount, sourceUnit)
    local ht = STES_GetTable(nil)
    if ht == nil then
        return
    end
    local hash = jass.StringHash(HEAL_EVENTS.REQUEST)
    local sk = skeyIndex()
    local loopIndex = jass.LoadInteger(ht, hash, sk)
    do
        local i = 0
        while i < loopIndex do
            local trg = jass.LoadTriggerHandle(ht, hash, i)
            if trg then
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                YDLocal5Set(nil, "real", HEAL_REQUEST_KEYS.AMOUNT, healAmount)
                YDLocal5Set(nil, "unit", HEAL_REQUEST_KEYS.TARGET, target)
                YDLocal5Set(nil, "unit", HEAL_REQUEST_KEYS.SOURCE, sourceUnit)
                YDLocal5Set(
                    nil,
                    "player",
                    HEAL_REQUEST_KEYS.SOURCE_PLAYER,
                    jass.GetOwningPlayer(sourceUnit)
                )
                YDLocal5Set(nil, "boolean", HEAL_REQUEST_KEYS.EFFECT, true)
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
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellChannelListener = ____require_result_1.registerSpellChannelListener
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_GetTable = ____require_result_3.STES_GetTable
local ____require_result_4 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local registerStesListener = ____require_result_4.registerStesListener
local ydlStes_syncTriggerStep = ____require_result_4.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_4.ydlStes_finishChildCleanup
local ydlStes_readUnit5 = ____require_result_4.ydlStes_readUnit5
local ydlStes_readReal5 = ____require_result_4.ydlStes_readReal5
local ydlStes_readBoolean5 = ____require_result_4.ydlStes_readBoolean5
local ____require_result_5 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
YDLocal5Set = ____require_result_5.YDLocal5Set
local ____require_result_6 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
YDLocalExecuteTrigger = ____require_result_6.YDLocalExecuteTrigger
YDTriggerExecuteTrigger = ____require_result_6.YDTriggerExecuteTrigger
saveParentIndex = ____require_result_6.saveParentIndex
--- 治疗命令ID列表：医疗波/治疗链/神圣之光/死亡缠绕(治疗)
local HEAL_ORDER_IDS = {852092, 852063, 852501, 852160}
--- 技能数据字段：治疗量
local HEAL_DATA_FIELD = 108
local function isHealOrder(orderId)
    return __TS__ArrayIndexOf(HEAL_ORDER_IDS, orderId) >= 0
end
--- 命中古老马甲 + 治疗命令时，停手/移除技能，并对「治疗事件」所有注册子触发器派发 YDLocal5
local function onSpellChannel(castingUnit, spellAbilityId)
    if not jass.IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT) then
        return
    end
    local currentOrder = jass.GetUnitCurrentOrder(castingUnit)
    if not isHealOrder(currentOrder) then
        return
    end
    local target = jass.GetSpellTargetUnit()
    local healAmount = YDWEGetUnitAbilityDataReal(
        nil,
        target,
        spellAbilityId,
        1,
        HEAL_DATA_FIELD
    )
    jass.IssueImmediateOrder(castingUnit, "stop")
    jass.UnitRemoveAbility(castingUnit, spellAbilityId)
    dispatchHealRequestEvent(target, healAmount, castingUnit)
end
--- STES「治疗事件」统一桥。
-- 约定：JASS/Lua 只要按同名参数写入 YDLocal5 并触发「治疗事件」，这里就会统一转入 doHeal。
local function onHealEventStes()
    do
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            ydlStes_syncTriggerStep(nil, nil)
            local target = ydlStes_readUnit5(nil, nil, HEAL_REQUEST_KEYS.TARGET)
            local source = ydlStes_readUnit5(nil, nil, HEAL_REQUEST_KEYS.SOURCE)
            local amount = ydlStes_readReal5(nil, nil, HEAL_REQUEST_KEYS.AMOUNT)
            local healEffect = ydlStes_readBoolean5(nil, nil, HEAL_REQUEST_KEYS.EFFECT)
            if target == nil or target == 0 then
                return true
            end
            if amount <= 0 then
                return true
            end
            doHeal(nil, {
                HealSource = source,
                HealTarget = target,
                HealAmount = amount,
                ItemHeal = false,
                HealEffect = healEffect
            })
        end)
        do
            ydlStes_finishChildCleanup(nil, nil)
        end
        if not ____try then
            error(____hasReturned, 0)
        end
        if ____try and ____hasReturned then
            return ____returnValue
        end
    end
end
--- 具名 STES 桥接动作，避免匿名闭包进入 JASS/Lua 侧。
local function onHealEventStesAction()
    onHealEventStes()
end
local healRequestEntryInitialized = false
local healRequestBridgeRegistered = false
--- 初始化「施法治疗事件」分发器，通过统一技能事件回调工作
function ____exports.initHealRequestEntry()
    if healRequestEntryInitialized then
        return
    end
    healRequestEntryInitialized = true
    if not healRequestBridgeRegistered then
        registerStesListener(nil, HEAL_EVENTS.REQUEST, onHealEventStesAction)
        healRequestBridgeRegistered = true
    end
    registerSpellChannelListener(onSpellChannel)
end
return ____exports
