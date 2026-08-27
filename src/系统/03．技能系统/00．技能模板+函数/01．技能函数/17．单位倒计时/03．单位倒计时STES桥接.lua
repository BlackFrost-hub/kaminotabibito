--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BFB_53D6_5355_4F4D_7C7B_578B_53C2_6570, _____8BFB_53D6_5355_4F4D_5012_8BA1_65F6_4E8B_4EF6_53C2_6570, ____on_5355_4F4D_5012_8BA1_65F6Stes_4E8B_4EF6Action, jassStesHashtable, countOnJassStesTable, onRetryRegisterUnitTimerStes, scheduleRetry, tryRegisterUnitTimerStes, jass, jglobals, registerStesListener, ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readInteger5, ydlStes_readUnitcode5, ydlStes_readReal5, ydlStes_readString5, ydlStes_readUnit5, createDelayedCall, debugLogForce, _____542F_52A8_5355_4F4D_5012_8BA1_65F6, _____6A21_5757_540D, REG_GUARD, TRIG_KEY, ATTEMPT_KEY, MAX_REG_ATTEMPTS, RETRY_SEC, _____5355_4F4D_5012_8BA1_65F6Stes_89E6_53D1_5668
function _____8BFB_53D6_5355_4F4D_7C7B_578B_53C2_6570(name)
    local text = ydlStes_readString5(nil, name)
    if #text == 4 then
        return text
    end
    local unitcode = ydlStes_readUnitcode5(nil, name)
    if unitcode ~= 0 then
        return unitcode
    end
    local integer = ydlStes_readInteger5(nil, name)
    return integer ~= 0 and integer or nil
end
function _____8BFB_53D6_5355_4F4D_5012_8BA1_65F6_4E8B_4EF6_53C2_6570()
    local _____53C2_6570 = {
        Unit = ydlStes_readUnit5(nil, "Unit"),
        time = ydlStes_readReal5(nil, "time"),
        x = ydlStes_readReal5(nil, "x"),
        y = ydlStes_readReal5(nil, "y"),
        EffectID = ydlStes_readInteger5(nil, "EffectID"),
        PowerUPtime = ydlStes_readReal5(nil, "PowerUPtime"),
        PowerUPHP = ydlStes_readReal5(nil, "PowerUPHP"),
        PowerUPModel = ydlStes_readString5(nil, "PowerUPModel"),
        PowerUPunitType = _____8BFB_53D6_5355_4F4D_7C7B_578B_53C2_6570("PowerUPunitType")
    }
    local _____7EA2 = ydlStes_readReal5(nil, "红")
    local _____7EFF = ydlStes_readReal5(nil, "绿")
    local _____84DD = ydlStes_readReal5(nil, "蓝")
    local _____900F_660E_5EA6 = ydlStes_readReal5(nil, "透明度")
    if _____7EA2 ~= 0 or _____7EFF ~= 0 or _____84DD ~= 0 or _____900F_660E_5EA6 ~= 0 then
        _____53C2_6570["红"] = _____7EA2
        _____53C2_6570["绿"] = _____7EFF
        _____53C2_6570["蓝"] = _____84DD
        _____53C2_6570["透明度"] = _____900F_660E_5EA6 ~= 0 and _____900F_660E_5EA6 or 255
    end
    return _____53C2_6570
end
____exports["根据Stes事件启动单位倒计时"] = function()
    do
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            ydlStes_syncTriggerStep(nil)
            local _____53C2_6570 = _____8BFB_53D6_5355_4F4D_5012_8BA1_65F6_4E8B_4EF6_53C2_6570()
            local id = _____542F_52A8_5355_4F4D_5012_8BA1_65F6(_____53C2_6570)
            debugLogForce(
                _____6A21_5757_540D,
                "收到 UnitTimer",
                "id=",
                id,
                "unit=",
                _____53C2_6570.Unit,
                "time=",
                _____53C2_6570.time,
                "effectID=",
                _____53C2_6570.EffectID
            )
            return true, id
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____hasReturned, 0)
        end
        if ____try and ____hasReturned then
            return ____returnValue
        end
    end
end
function ____on_5355_4F4D_5012_8BA1_65F6Stes_4E8B_4EF6Action()
    ____exports["根据Stes事件启动单位倒计时"]()
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
    return jass:LoadInteger(
        ht,
        jass:StringHash(eventName),
        jass:StringHash("index")
    )
end
function onRetryRegisterUnitTimerStes()
    tryRegisterUnitTimerStes()
end
function scheduleRetry()
    createDelayedCall(RETRY_SEC, onRetryRegisterUnitTimerStes)
end
function tryRegisterUnitTimerStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if g[TRIG_KEY] == nil then
        _____5355_4F4D_5012_8BA1_65F6Stes_89E6_53D1_5668 = registerStesListener(____exports["单位倒计时STES事件名"], ____on_5355_4F4D_5012_8BA1_65F6Stes_4E8B_4EF6Action)
        g[TRIG_KEY] = _____5355_4F4D_5012_8BA1_65F6Stes_89E6_53D1_5668
    else
        _____5355_4F4D_5012_8BA1_65F6Stes_89E6_53D1_5668 = g[TRIG_KEY]
    end
    local jCount = countOnJassStesTable(____exports["单位倒计时STES事件名"])
    local attempt = g[ATTEMPT_KEY] or 0
    g[ATTEMPT_KEY] = attempt + 1
    if jCount >= 1 then
        g[REG_GUARD] = true
        debugLogForce(
            _____6A21_5757_540D,
            "注册成功",
            "event=",
            ____exports["单位倒计时STES事件名"],
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
            ____exports["单位倒计时STES事件名"],
            "最后计数=",
            jCount
        )
        return
    end
    scheduleRetry()
end
jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
registerStesListener = ____require_result_0.registerStesListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
ydlStes_syncTriggerStep = ____require_result_1.ydlStes_syncTriggerStep
ydlStes_finishChildCleanup = ____require_result_1.ydlStes_finishChildCleanup
ydlStes_readInteger5 = ____require_result_1.ydlStes_readInteger5
ydlStes_readUnitcode5 = ____require_result_1.ydlStes_readUnitcode5
ydlStes_readReal5 = ____require_result_1.ydlStes_readReal5
ydlStes_readString5 = ____require_result_1.ydlStes_readString5
ydlStes_readUnit5 = ____require_result_1.ydlStes_readUnit5
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
createDelayedCall = ____require_result_2.createDelayedCall
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_3.debugLogForce
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.17．单位倒计时.04．对外接口")
_____542F_52A8_5355_4F4D_5012_8BA1_65F6 = ____require_result_4["启动单位倒计时"]
____exports["单位倒计时STES事件名"] = "UnitTimer"
_____6A21_5757_540D = "单位倒计时桥接"
REG_GUARD = "__syzl_unit_timer_registered"
TRIG_KEY = "__syzl_unit_timer_trig"
ATTEMPT_KEY = "__syzl_unit_timer_reg_attempt"
MAX_REG_ATTEMPTS = 30
RETRY_SEC = 0.1
_____5355_4F4D_5012_8BA1_65F6Stes_89E6_53D1_5668 = nil
____exports["注册单位倒计时Stes桥接"] = function()
    tryRegisterUnitTimerStes()
end
____exports["注册单位倒计时Stes桥接"]()
return ____exports
