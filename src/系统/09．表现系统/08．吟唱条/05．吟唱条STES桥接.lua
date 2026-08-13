--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BFB_53D6_541F_5531_6761_4E8B_4EF6_53C2_6570, ____on_541F_5531_6761Stes_4E8B_4EF6Action, jassStesHashtable, countOnJassStesTable, _____91CD_8BD5_6CE8_518C_541F_5531_6761Stes, _____5B89_6392_91CD_8BD5_6CE8_518C, _____5C1D_8BD5_6CE8_518C_541F_5531_6761Stes, jass, jglobals, registerStesListener, ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_readReal5, ydlStes_readInteger5, ydlStes_readString5, createDelayedCall, debugLogForce, _____542F_52A8_541F_5531_6761, _____6A21_5757_540D, _____5168_5C40_5DF2_6CE8_518C_6807_8BB0_952E, _____5168_5C40_89E6_53D1_5668_952E, _____5168_5C40_91CD_8BD5_6B21_6570_952E, _____6700_5927_6CE8_518C_5C1D_8BD5_6B21_6570, _____91CD_8BD5_95F4_9694_79D2, _____541F_5531_6761Stes_89E6_53D1_5668
function _____8BFB_53D6_541F_5531_6761_4E8B_4EF6_53C2_6570()
    local sj = ydlStes_readReal5(nil, "sj")
    if sj == 0 then
        sj = ydlStes_readReal5(nil, "总时长")
    end
    if sj == 0 then
        sj = ydlStes_readReal5(nil, "time")
    end
    local _____989C_8272ID = ydlStes_readInteger5(nil, "颜色ID")
    if _____989C_8272ID == 0 then
        _____989C_8272ID = ydlStes_readInteger5(nil, "颜色")
    end
    if _____989C_8272ID == 0 then
        _____989C_8272ID = ydlStes_readInteger5(nil, "棰滆壊ID")
    end
    local _____63D0_793A_5B57_7B26_4E32 = ydlStes_readString5(nil, "string")
    if _____63D0_793A_5B57_7B26_4E32 == "" then
        _____63D0_793A_5B57_7B26_4E32 = ydlStes_readString5(nil, "提示文本")
    end
    if _____63D0_793A_5B57_7B26_4E32 == "" then
        _____63D0_793A_5B57_7B26_4E32 = ydlStes_readString5(nil, "文本")
    end
    return {sj = sj, ["颜色ID"] = _____989C_8272ID, string = _____63D0_793A_5B57_7B26_4E32}
end
____exports["根据Stes事件启动吟唱条"] = function()
    do
        local ____try, ____error = pcall(function()
            ydlStes_syncTriggerStep(nil)
            local _____53C2_6570 = _____8BFB_53D6_541F_5531_6761_4E8B_4EF6_53C2_6570()
            local _____603B_65F6_957F = _____53C2_6570.sj
            local _____989C_8272ID = _____53C2_6570["颜色ID"]
            local ____temp_5
            if _____53C2_6570.string ~= "" then
                ____temp_5 = _____53C2_6570.string
            else
                ____temp_5 = nil
            end
            local _____63D0_793A_6587_672C = ____temp_5
            _____542F_52A8_541F_5531_6761(nil, {["总时长"] = _____603B_65F6_957F, ["颜色ID"] = _____989C_8272ID, ["提示文本"] = _____63D0_793A_6587_672C})
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
function ____on_541F_5531_6761Stes_4E8B_4EF6Action()
    ____exports["根据Stes事件启动吟唱条"]()
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
function _____91CD_8BD5_6CE8_518C_541F_5531_6761Stes()
    _____5C1D_8BD5_6CE8_518C_541F_5531_6761Stes()
end
function _____5B89_6392_91CD_8BD5_6CE8_518C()
    createDelayedCall(_____91CD_8BD5_95F4_9694_79D2, _____91CD_8BD5_6CE8_518C_541F_5531_6761Stes)
end
function _____5C1D_8BD5_6CE8_518C_541F_5531_6761Stes()
    local g = _G
    if g[_____5168_5C40_5DF2_6CE8_518C_6807_8BB0_952E] then
        return
    end
    if g[_____5168_5C40_89E6_53D1_5668_952E] == nil then
        _____541F_5531_6761Stes_89E6_53D1_5668 = registerStesListener(____exports["吟唱条STES事件名"], ____on_541F_5531_6761Stes_4E8B_4EF6Action)
        g[_____5168_5C40_89E6_53D1_5668_952E] = _____541F_5531_6761Stes_89E6_53D1_5668
    else
        _____541F_5531_6761Stes_89E6_53D1_5668 = g[_____5168_5C40_89E6_53D1_5668_952E]
    end
    local jCount = countOnJassStesTable(____exports["吟唱条STES事件名"])
    local _____5DF2_5C1D_8BD5_6B21_6570 = g[_____5168_5C40_91CD_8BD5_6B21_6570_952E] or 0
    g[_____5168_5C40_91CD_8BD5_6B21_6570_952E] = _____5DF2_5C1D_8BD5_6B21_6570 + 1
    if jCount >= 1 then
        g[_____5168_5C40_5DF2_6CE8_518C_6807_8BB0_952E] = true
        return
    end
    if g[_____5168_5C40_91CD_8BD5_6B21_6570_952E] >= _____6700_5927_6CE8_518C_5C1D_8BD5_6B21_6570 then
        debugLogForce(
            _____6A21_5757_540D,
            "注册失败",
            "event=",
            ____exports["吟唱条STES事件名"],
            "最后计数=",
            jCount
        )
        return
    end
    _____5B89_6392_91CD_8BD5_6CE8_518C()
end
jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
registerStesListener = ____require_result_0.registerStesListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
ydlStes_syncTriggerStep = ____require_result_1.ydlStes_syncTriggerStep
ydlStes_finishChildCleanup = ____require_result_1.ydlStes_finishChildCleanup
ydlStes_readReal5 = ____require_result_1.ydlStes_readReal5
ydlStes_readInteger5 = ____require_result_1.ydlStes_readInteger5
ydlStes_readString5 = ____require_result_1.ydlStes_readString5
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
createDelayedCall = ____require_result_2.createDelayedCall
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_3.debugLogForce
local ____require_result_4 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
_____542F_52A8_541F_5531_6761 = ____require_result_4["显示吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_4["关闭吟唱条"]
____exports["吟唱条STES事件名"] = "注册吟唱条"
_____6A21_5757_540D = "吟唱条桥接"
_____5168_5C40_5DF2_6CE8_518C_6807_8BB0_952E = "__syzl_castbar_registered"
_____5168_5C40_89E6_53D1_5668_952E = "__syzl_castbar_trig"
_____5168_5C40_91CD_8BD5_6B21_6570_952E = "__syzl_castbar_reg_attempt"
_____6700_5927_6CE8_518C_5C1D_8BD5_6B21_6570 = 30
_____91CD_8BD5_95F4_9694_79D2 = 0.1
_____541F_5531_6761Stes_89E6_53D1_5668 = nil
____exports["确保Stes已注册"] = function()
    _____5C1D_8BD5_6CE8_518C_541F_5531_6761Stes()
end
____exports["确保Stes已注册"]()
return ____exports
