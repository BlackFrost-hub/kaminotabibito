--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04A_FF0E_5FEB_901FBuff_5171_4EAB = require("lib.扩展函数.Star扩展函数.Star扩展库.04A．快速Buff共享")
local SFB_Unit = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.SFB_Unit
local getUnitSourceName = ____04A_FF0E_5FEB_901FBuff_5171_4EAB.getUnitSourceName
--- Star扩展库 - 快速Buff幻象物品
-- 
-- 单独拆分原因：
-- - 幻象物品是独立业务，不该堆在 04A 共享层
-- - 这里专管召唤桥接、上下文匹配、BuffUI 挂载
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local summonEvent = require("系统.00．核心系统.01．事件中心.09．单位召唤事件中心")
local ITEM_ILLUSION_BUFF_ID = "C019"
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitIllusion = jass.IsUnitIllusion
local SetUnitOwner = jass.SetUnitOwner
local pendingItemIllusionContext = nil
local itemIllusionSummonBridgeInited = false
local function isMatchingPendingItemIllusionContext(summonedUnit, summoningUnit, ctx)
    if summonedUnit == nil or summonedUnit == 0 then
        return false
    end
    if not IsUnitIllusion(summonedUnit) then
        return false
    end
    if GetUnitTypeId(summonedUnit) ~= ctx.targetTypeId then
        return false
    end
    if summoningUnit == nil or summoningUnit == 0 then
        return true
    end
    if summoningUnit == ctx.targetUnit then
        return true
    end
    if summoningUnit == SFB_Unit then
        return true
    end
    return GetHandleId(summoningUnit) == ctx.targetHandleId
end
local function applyItemIllusionSummonBuff(summonedUnit, ctx)
    if ctx.duration <= 0 then
        return
    end
    SetUnitOwner(summonedUnit, ctx.targetOwner, true)
    registerManualBuff(
        summonedUnit,
        ITEM_ILLUSION_BUFF_ID,
        ctx.duration,
        0,
        {sourceName = getUnitSourceName(ctx.sourceUnit, ctx.targetUnit)}
    )
end
local function onItemIllusionSummoned(summonedUnit, summoningUnit)
    local ctx = pendingItemIllusionContext
    if ctx == nil then
        return
    end
    if not isMatchingPendingItemIllusionContext(summonedUnit, summoningUnit, ctx) then
        return
    end
    pendingItemIllusionContext = nil
    applyItemIllusionSummonBuff(summonedUnit, ctx)
end
function ____exports.initItemIllusionSummonBridge()
    if itemIllusionSummonBridgeInited then
        return
    end
    itemIllusionSummonBridgeInited = true
    summonEvent["注册召唤监听"](onItemIllusionSummoned)
end
____exports["SFB_记录幻象物品上下文"] = function(sourceUnit, targetUnit, duration)
    if targetUnit == nil or targetUnit == 0 or duration <= 0 then
        pendingItemIllusionContext = nil
        return
    end
    pendingItemIllusionContext = {
        sourceUnit = sourceUnit,
        targetUnit = targetUnit,
        duration = duration,
        targetOwner = GetOwningPlayer(targetUnit),
        targetTypeId = GetUnitTypeId(targetUnit),
        targetHandleId = GetHandleId(targetUnit)
    }
end
____exports["SFB_清空幻象物品上下文"] = function()
    pendingItemIllusionContext = nil
end
return ____exports
