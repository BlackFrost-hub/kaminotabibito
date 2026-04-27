--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 技能吟唱条系统 - 输入层
-- 
-- 职责：
-- - STES「注册吟唱条」子触发读取（颜色ID / sj / string）
-- - JASS STES 哈希表注册计数重试（与装备提取一致的桥接模式）
-- - 解析到参数后调用渲染层的 startCastBar
-- 
-- 不包含：UI 渲染、数据存储。
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.07．技能吟唱条.00．常量定义")
local DEFAULT_COLOR_ID = ____require_result_0.DEFAULT_COLOR_ID
local EVENT_NAME_CAST_BAR = ____require_result_0.EVENT_NAME_CAST_BAR
local ____require_result_1 = require("系统.03．技能系统.07．技能吟唱条.02．渲染")
local startCastBar = ____require_result_1.startCastBar
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_2.STES_Register
local ____require_result_3 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_3.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_3.ydlStes_finishChildCleanup
local ydlStes_skeyIndex = ____require_result_3.ydlStes_skeyIndex
local ydlStes_registerAfterGetTable = ____require_result_3.ydlStes_registerAfterGetTable
local ydlStes_readInteger5 = ____require_result_3.ydlStes_readInteger5
local ydlStes_readReal5 = ____require_result_3.ydlStes_readReal5
local ydlStes_readString5 = ____require_result_3.ydlStes_readString5
local REG_GUARD = "__syzl_castBar_registered"
local TRIG_KEY = "__syzl_castBar_trig"
local ATTEMPT_KEY = "__syzl_castBarRegAttempt"
local MAX_REG_ATTEMPTS = 30
local RETRY_SEC = 0.1
local function onCastBarEvent()
    ydlStes_syncTriggerStep(nil, nil)
    local colorId = ydlStes_readInteger5(nil, nil, "颜色ID") or DEFAULT_COLOR_ID
    local totalTime = ydlStes_readReal5(nil, nil, "sj") or 1
    local customString = ydlStes_readString5(nil, nil, "string") or ""
    ydlStes_finishChildCleanup(nil, nil)
    startCastBar(nil, colorId, totalTime, customString)
end
local function jassStesHashtable()
    local jg = jglobals
    local cands = {jg.STES___HT, jg.STES_HT, jg.udg_STES___HT, jg.udg_STES_HT}
    do
        local i = 0
        while i < #cands do
            local t = cands[i + 1]
            if t ~= nil and t ~= 0 then
                return t
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
    local h = jass:StringHash(eventName)
    return jass:LoadInteger(
        ht,
        h,
        ydlStes_skeyIndex(nil, nil)
    )
end
local function scheduleRetry(fn)
    local tm = jass:CreateTimer()
    jass:TimerStart(
        tm,
        RETRY_SEC,
        false,
        function()
            jass:DestroyTimer(tm)
            fn(nil)
        end
    )
end
function ____exports.tryRegisterCastBarStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if STES_Register == nil then
        g[REG_GUARD] = true
        return
    end
    if g[TRIG_KEY] == nil then
        local trig = jass:CreateTrigger()
        jass:TriggerAddAction(trig, onCastBarEvent)
        g[TRIG_KEY] = trig
    end
    local trig = g[TRIG_KEY]
    ydlStes_registerAfterGetTable(nil, nil, trig, EVENT_NAME_CAST_BAR)
    local jCount = countOnJassStesTable(EVENT_NAME_CAST_BAR)
    local attempt = g[ATTEMPT_KEY] or 0
    g[ATTEMPT_KEY] = attempt + 1
    if jCount >= 1 then
        g[REG_GUARD] = true
        return
    end
    if g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS then
        g[REG_GUARD] = true
        return
    end
    scheduleRetry(function()
        ____exports.tryRegisterCastBarStes()
    end)
end
return ____exports
