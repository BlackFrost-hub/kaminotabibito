--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 宝箱系统 - 事件注册
-- 
-- 功能：
-- 1. 监听单位发布目标命令事件（EVENT_UNIT_ISSUED_TARGET_ORDER）
-- 2. 当目标为可破坏物时，检查是否为可交互目标
-- 3. 如果是，调用核心功能处理
-- 
-- 注册方式：通过玩家英雄注册联动，在英雄登记时自动注册命令事件
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.06．经济系统.00．宝箱系统.03．宝箱核心")
local onUnitTargetInteractable = ____require_result_0.onUnitTargetInteractable
local isInteractable = ____require_result_0.isInteractable
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_1.YDLocal5Get
local helper = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local EVENT_UNIT_ISSUED_TARGET_ORDER = 19
local REG_GUARD = "__syzl_chestSystem_registered"
local TRIG_KEY = "__syzl_chestSystem_trig"
local ATTEMPT_KEY = "__syzl_chestSystem_attempt"
local MAX_REG_ATTEMPTS = 30
local RETRY_SEC = 0.1
--- STES事件名：单位发布目标命令
local STES_EVENT_UNIT_TARGET_ORDER = "单位发布目标命令"
--- 处理单位发布目标命令事件
local function onUnitIssuedTargetOrder()
    local unit = jass:GetTriggerUnit()
    if not unit then
        return
    end
    local target = jass:GetOrderTargetDestructable()
    if not target then
        return
    end
    local targetType = jass:GetDestructableTypeId(target)
    if not isInteractable(nil, targetType) then
        return
    end
    onUnitTargetInteractable(nil, unit, target)
end
local function jassStesHashtable()
    local candidates = {jglobals.STES___HT, jglobals.STES_HT, jglobals.udg_STES___HT, jglobals.udg_STES_HT}
    do
        local i = 0
        while i < #candidates do
            local ____table = candidates[i + 1]
            if ____table ~= nil and ____table ~= 0 then
                return ____table
            end
            i = i + 1
        end
    end
    return nil
end
local function countOnJassStesTable(eventName)
    local ht = jassStesHashtable()
    if ht == nil or ht == 0 then
        return -1
    end
    return jass:LoadInteger(
        ht,
        jass:StringHash(eventName),
        helper:ydlStes_skeyIndex(nil)
    )
end
local function scheduleRetry(fn)
    local timer = jass:CreateTimer()
    jass:TimerStart(
        timer,
        RETRY_SEC,
        false,
        function()
            jass:DestroyTimer(timer)
            fn()
        end
    )
end
--- 注册单位目标命令事件监听
local function tryRegisterTargetOrderStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if g[TRIG_KEY] == nil then
        local trig = jass:CreateTrigger()
        jass:TriggerAddAction(trig, onUnitIssuedTargetOrder)
        g[TRIG_KEY] = trig
    end
    helper:ydlStes_registerAfterGetTable(nil, g[TRIG_KEY], STES_EVENT_UNIT_TARGET_ORDER)
    local count = countOnJassStesTable(STES_EVENT_UNIT_TARGET_ORDER)
    local attempt = (g[ATTEMPT_KEY] or 0) + 1
    g[ATTEMPT_KEY] = attempt
    if count >= 1 or attempt >= MAX_REG_ATTEMPTS then
        g[REG_GUARD] = true
        return
    end
    scheduleRetry(function()
        tryRegisterTargetOrderStes()
    end)
end
--- 为英雄注册目标命令事件
-- 当英雄被登记时调用
function ____exports.registerChestSystemHero(hero)
    if not hero then
        return
    end
    local g = _G
    if g[TRIG_KEY] == nil then
        local trig = jass:CreateTrigger()
        jass:TriggerAddAction(trig, onUnitIssuedTargetOrder)
        g[TRIG_KEY] = trig
    end
    local ev = jass:ConvertUnitEvent(EVENT_UNIT_ISSUED_TARGET_ORDER)
    unitSpecificEventCenter.registerUnitEventTrigger(g[TRIG_KEY], hero, ev)
end
--- 初始化宝箱系统
function ____exports.initChestSystem()
    tryRegisterTargetOrderStes()
end
____exports.STES_EVENT_UNIT_TARGET_ORDER = STES_EVENT_UNIT_TARGET_ORDER
return ____exports
