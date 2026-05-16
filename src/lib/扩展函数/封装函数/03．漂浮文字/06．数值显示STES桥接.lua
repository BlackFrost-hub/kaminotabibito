--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BFB_53D6_53EF_9009_5B57_7B26_4E32, _____8BFB_53D6_53EF_9009_6B63_6570, _____8BFB_53D6_53EF_9009_975E_8D1F_6570, _____8BFB_53D6_6570_503C_663E_793A_53C2_6570, ____on_6570_503C_663E_793AStes_4E8B_4EF6Action, jassStesHashtable, countOnJassStesTable, onRetryRegisterValueDisplayStes, scheduleRetry, tryRegisterValueDisplayStes, jglobals, registerStesListener, ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readBoolean5, ydlStes_readReal5, ydlStes_readString5, ydlStes_readUnit5, createDelayedCall, _____663E_793A_6570_503C_6F02_6D6E_6587_5B57, debugLogForce, _____6A21_5757_540D, REG_GUARD, TRIG_KEY, ATTEMPT_KEY, MAX_REG_ATTEMPTS, RETRY_SEC, LoadInteger, StringHash, _____6570_503C_663E_793A_89E6_53D1_5668
function _____8BFB_53D6_53EF_9009_5B57_7B26_4E32(name)
    local value = ydlStes_readString5(nil, name)
    return value ~= "" and value or nil
end
function _____8BFB_53D6_53EF_9009_6B63_6570(name)
    local value = ydlStes_readReal5(nil, name)
    return value > 0 and value or nil
end
function _____8BFB_53D6_53EF_9009_975E_8D1F_6570(name)
    local value = ydlStes_readReal5(nil, name)
    return value >= 0 and value or nil
end
function _____8BFB_53D6_6570_503C_663E_793A_53C2_6570()
    local unit = ydlStes_readUnit5(nil, "单位")
    local ____ydlStes_readReal5_result_7 = ydlStes_readReal5(nil, "X")
    local ____ydlStes_readReal5_result_8 = ydlStes_readReal5(nil, "Y")
    local ____ydlStes_readReal5_result_9 = ydlStes_readReal5(nil, "数值")
    local ____8BFB_53D6_53EF_9009_5B57_7B26_4E32_result_10 = _____8BFB_53D6_53EF_9009_5B57_7B26_4E32("后缀")
    local ____8BFB_53D6_53EF_9009_6B63_6570_result_11 = _____8BFB_53D6_53EF_9009_6B63_6570("红")
    local ____8BFB_53D6_53EF_9009_6B63_6570_result_12 = _____8BFB_53D6_53EF_9009_6B63_6570("绿")
    local ____8BFB_53D6_53EF_9009_6B63_6570_result_13 = _____8BFB_53D6_53EF_9009_6B63_6570("蓝")
    local ____8BFB_53D6_53EF_9009_6B63_6570_result_14 = _____8BFB_53D6_53EF_9009_6B63_6570("大小")
    local ____8BFB_53D6_53EF_9009_975E_8D1F_6570_result_15 = _____8BFB_53D6_53EF_9009_975E_8D1F_6570("小数位数")
    local ____ydlStes_readBoolean5_result_5
    if ydlStes_readBoolean5(nil, "显示正号") then
        ____ydlStes_readBoolean5_result_5 = true
    else
        ____ydlStes_readBoolean5_result_5 = nil
    end
    local ____ydlStes_readBoolean5_result_6
    if ydlStes_readBoolean5(nil, "零值隐藏") then
        ____ydlStes_readBoolean5_result_6 = true
    else
        ____ydlStes_readBoolean5_result_6 = nil
    end
    return {
        ["单位"] = unit,
        X = ____ydlStes_readReal5_result_7,
        Y = ____ydlStes_readReal5_result_8,
        ["数值"] = ____ydlStes_readReal5_result_9,
        ["后缀"] = ____8BFB_53D6_53EF_9009_5B57_7B26_4E32_result_10,
        ["红"] = ____8BFB_53D6_53EF_9009_6B63_6570_result_11,
        ["绿"] = ____8BFB_53D6_53EF_9009_6B63_6570_result_12,
        ["蓝"] = ____8BFB_53D6_53EF_9009_6B63_6570_result_13,
        ["大小"] = ____8BFB_53D6_53EF_9009_6B63_6570_result_14,
        ["小数位数"] = ____8BFB_53D6_53EF_9009_975E_8D1F_6570_result_15,
        ["显示正号"] = ____ydlStes_readBoolean5_result_5,
        ["零值隐藏"] = ____ydlStes_readBoolean5_result_6
    }
end
____exports["根据Stes事件显示数值"] = function()
    do
        local ____try, ____error = pcall(function()
            ydlStes_syncTriggerStep(nil)
            local _____53C2_6570 = _____8BFB_53D6_6570_503C_663E_793A_53C2_6570()
            _____663E_793A_6570_503C_6F02_6D6E_6587_5B57(_____53C2_6570)
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
function ____on_6570_503C_663E_793AStes_4E8B_4EF6Action()
    ____exports["根据Stes事件显示数值"]()
end
function jassStesHashtable()
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
function countOnJassStesTable(eventName)
    local ht = jassStesHashtable()
    if ht == nil or ht == 0 then
        return -1
    end
    return LoadInteger(
        ht,
        StringHash(eventName),
        StringHash("index")
    )
end
function onRetryRegisterValueDisplayStes()
    tryRegisterValueDisplayStes()
end
function scheduleRetry()
    createDelayedCall(RETRY_SEC, onRetryRegisterValueDisplayStes)
end
function tryRegisterValueDisplayStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if g[TRIG_KEY] == nil then
        _____6570_503C_663E_793A_89E6_53D1_5668 = registerStesListener(____exports["数值显示STES事件名"], ____on_6570_503C_663E_793AStes_4E8B_4EF6Action)
        g[TRIG_KEY] = _____6570_503C_663E_793A_89E6_53D1_5668
    else
        _____6570_503C_663E_793A_89E6_53D1_5668 = g[TRIG_KEY]
    end
    local jCount = countOnJassStesTable(____exports["数值显示STES事件名"])
    local attempt = g[ATTEMPT_KEY] or 0
    g[ATTEMPT_KEY] = attempt + 1
    if jCount >= 1 then
        g[REG_GUARD] = true
        debugLogForce(
            _____6A21_5757_540D,
            "注册成功",
            "event=",
            ____exports["数值显示STES事件名"],
            "count=",
            jCount
        )
        return
    end
    if g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS then
        debugLogForce(
            _____6A21_5757_540D,
            "注册失败",
            "event=",
            ____exports["数值显示STES事件名"],
            "最后计数=",
            jCount
        )
        return
    end
    scheduleRetry()
end
--- 数值显示 STES 桥接
-- 
-- 只作为 JASS 兼容入口使用；TS/Lua 内部请直接调用数值漂浮文字接口。
local jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
registerStesListener = ____require_result_0.registerStesListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
ydlStes_syncTriggerStep = ____require_result_1.ydlStes_syncTriggerStep
ydlStes_finishChildCleanup = ____require_result_1.ydlStes_finishChildCleanup
ydlStes_readBoolean5 = ____require_result_1.ydlStes_readBoolean5
ydlStes_readReal5 = ____require_result_1.ydlStes_readReal5
ydlStes_readString5 = ____require_result_1.ydlStes_readString5
ydlStes_readUnit5 = ____require_result_1.ydlStes_readUnit5
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
createDelayedCall = ____require_result_2.createDelayedCall
local ____require_result_3 = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字")
_____663E_793A_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_3["显示数值漂浮文字"]
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_4.debugLogForce
____exports["数值显示STES事件名"] = "数值显示"
_____6A21_5757_540D = "数值显示STES桥接"
REG_GUARD = "__syzl_value_display_registered"
TRIG_KEY = "__syzl_value_display_trig"
ATTEMPT_KEY = "__syzl_value_display_reg_attempt"
MAX_REG_ATTEMPTS = 30
RETRY_SEC = 0.1
LoadInteger = jass.LoadInteger
StringHash = jass.StringHash
_____6570_503C_663E_793A_89E6_53D1_5668 = nil
____exports["注册数值显示Stes桥接"] = function()
    tryRegisterValueDisplayStes()
end
____exports["注册数值显示Stes桥接"]()
return ____exports
