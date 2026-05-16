--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local registerStesListener = ____require_result_0.registerStesListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_1.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_1.ydlStes_finishChildCleanup
local ydlStes_readBoolean5 = ____require_result_1.ydlStes_readBoolean5
local ydlStes_readInteger5 = ____require_result_1.ydlStes_readInteger5
local ydlStes_readReal5 = ____require_result_1.ydlStes_readReal5
local ydlStes_readString5 = ____require_result_1.ydlStes_readString5
local ydlStes_readUnit5 = ____require_result_1.ydlStes_readUnit5
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.04．周期AOE核心")
local _____542F_52A8_5468_671F_8303_56F4_6548_679C = ____require_result_2["启动周期范围效果"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.03．禁锢寄生")
local _____65BD_52A0_7981_9522 = ____require_result_3["施加禁锢"]
local _____65BD_52A0_5BC4_751F = ____require_result_3["施加寄生"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.02．腐败层数")
local _____5E94_7528_8150_8D25_5C42_6570 = ____require_result_4["应用腐败层数"]
____exports["周期范围效果STES事件名"] = "PeriodicAoe_Event"
____exports["禁锢STES事件名"] = "禁锢"
____exports["寄生STES事件名"] = "寄生"
____exports["腐败层数STES事件名"] = "DebuffStacks"
local function _____8BFB_53D6_6301_7EED_539F_751F_6548_679C_53C2_6570()
    return {
        BuffSource = ydlStes_readUnit5(nil, "BuffSource"),
        BuffTarget = ydlStes_readUnit5(nil, "BuffTarget"),
        HitDamage = ydlStes_readReal5(nil, "HitDamage"),
        DamageInterval = ydlStes_readReal5(nil, "DamageInterval"),
        time = ydlStes_readReal5(nil, "time")
    }
end
____exports["根据Stes启动周期范围效果"] = function()
    do
        local ____try, ____error = pcall(function()
            ydlStes_syncTriggerStep(nil)
            _____542F_52A8_5468_671F_8303_56F4_6548_679C({
                AoeEffectFileID = ydlStes_readString5(nil, "AoeEffectFileID"),
                EffectID = ydlStes_readInteger5(nil, "EffectID"),
                EffectInterval = ydlStes_readReal5(nil, "EffectInterval"),
                EffectSourceUnit = ydlStes_readUnit5(nil, "EffectSourceUnit"),
                EffectTime = ydlStes_readReal5(nil, "EffectTime"),
                r = ydlStes_readReal5(nil, "r"),
                x = ydlStes_readReal5(nil, "x"),
                y = ydlStes_readReal5(nil, "y")
            })
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
____exports["根据Stes施加禁锢"] = function()
    do
        local ____try, ____error = pcall(function()
            ydlStes_syncTriggerStep(nil)
            _____65BD_52A0_7981_9522(_____8BFB_53D6_6301_7EED_539F_751F_6548_679C_53C2_6570())
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
____exports["根据Stes施加寄生"] = function()
    do
        local ____try, ____error = pcall(function()
            ydlStes_syncTriggerStep(nil)
            _____65BD_52A0_5BC4_751F(_____8BFB_53D6_6301_7EED_539F_751F_6548_679C_53C2_6570())
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
____exports["根据Stes应用腐败层数"] = function()
    do
        local ____try, ____error = pcall(function()
            ydlStes_syncTriggerStep(nil)
            _____5E94_7528_8150_8D25_5C42_6570({
                TargetUnit = ydlStes_readUnit5(nil, "TargetUnit"),
                Stacks = ydlStes_readReal5(nil, "Stacks"),
                ["腐败值"] = ydlStes_readBoolean5(nil, "腐败值")
            })
        end)
        do
            ydlStes_finishChildCleanup(nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
local function ____on_5468_671F_8303_56F4_6548_679CStes()
    ____exports["根据Stes启动周期范围效果"]()
end
local function ____on_7981_9522Stes()
    ____exports["根据Stes施加禁锢"]()
end
local function ____on_5BC4_751FStes()
    ____exports["根据Stes施加寄生"]()
end
local function ____on_8150_8D25_5C42_6570Stes()
    ____exports["根据Stes应用腐败层数"]()
end
____exports["注册周期范围效果Stes桥接"] = function()
    registerStesListener(____exports["周期范围效果STES事件名"], ____on_5468_671F_8303_56F4_6548_679CStes)
    registerStesListener(____exports["禁锢STES事件名"], ____on_7981_9522Stes)
    registerStesListener(____exports["寄生STES事件名"], ____on_5BC4_751FStes)
    registerStesListener(____exports["腐败层数STES事件名"], ____on_8150_8D25_5C42_6570Stes)
end
____exports["注册周期范围效果Stes桥接"]()
return ____exports
