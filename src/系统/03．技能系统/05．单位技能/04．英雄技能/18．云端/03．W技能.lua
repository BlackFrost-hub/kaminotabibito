--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.18．云端.00．配置")
local _____4E91_7AEF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["云端技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.18．云端.01．状态表")
local _____6D88_8017_4E91_7AEFW_6A21_5F0F = ____01_FF0E_72B6_6001_8868["消耗云端W模式"]
local ____18_FF0E_4E91_7AEF = require("系统.05．Buff系统.03．Buff表.02．英雄.18．云端")
local _____4E91_7AEFBuffID = ____18_FF0E_4E91_7AEF["云端BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_2["造成单体技能伤害"]
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_3.doHeal
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local GS_Suspend = ____require_result_6.GS_Suspend
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_7["销毁点特效"]
local ____require_result_8 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_8.IsUnitAliveBJ
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetHeroInt = jass.GetHeroInt
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimation = jass.SetUnitAnimation
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local bj_RADTODEG = jass.bj_RADTODEG
local bj_DEGTORAD = jass.bj_DEGTORAD
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local DzSetEffectPos = japi.DzSetEffectPos
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local _____914D_7F6E = _____4E91_7AEF_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____W_7C7B_578BID = stringToFourCCSafe(_____914D_7F6E.W["技能ID"])
local ____W_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587(unit)
    local id = GetHandleId(unit)
    local ctx = ____W_4E0A_4E0B_6587_8868[id]
    if ctx == nil then
        ctx = {
            ["施法者"] = unit,
            ["模式"] = "光剑",
            ["伤害快照"] = 0,
            ["起点X"] = 0,
            ["起点Y"] = 0,
            ["角度"] = 0,
            ["Tick数"] = 0,
            ["已命中组"] = {},
            ["路径特效"] = nil,
            ["回调ID"] = 0,
            ["已启动"] = false
        }
        ____W_4E0A_4E0B_6587_8868[id] = ctx
    end
    return ctx
end
local function ____W_53EF_91CA_653E(context, _caster)
    return context["已启动"] ~= true
end
local function _____7ED3_675FW_8DEF_5F84(ctx)
    debugLogForce(
        "云端W",
        "结束-路径清理",
        "施法者",
        GetHandleId(ctx["施法者"]),
        "模式",
        ctx["模式"],
        "技能实例ID",
        ctx["技能实例ID"]
    )
    if ctx["回调ID"] ~= 0 then
        removePeriodicCallback(ctx["回调ID"])
    end
    ctx["回调ID"] = 0
    if ctx["路径特效"] ~= nil and ctx["路径特效"] ~= 0 then
        _____9500_6BC1_70B9_7279_6548(ctx["路径特效"])
    end
    ctx["路径特效"] = nil
    ctx["已命中组"] = {}
    ctx["已启动"] = false
    local caster = ctx["施法者"]
    if caster ~= nil and caster ~= 0 then
        GS_Suspend(caster, 0)
        SetUnitInvulnerable(caster, false)
        SetUnitTimeScale(caster, 1)
    end
end
local function _____7ED3_7B97W_8303_56F4(ctx, x, y)
    local caster = ctx["施法者"]
    local owner = GetOwningPlayer(caster)
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        x,
        y,
        _____914D_7F6E.W["路径"]["结算半径码"],
        nil
    )
    local u = FirstOfGroup(group)
    local _____672CTick_547D_4E2D_6570 = 0
    while u ~= nil and u ~= 0 do
        GroupRemoveUnit(group, u)
        if IsUnitAliveBJ(u) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) and ctx["已命中组"][GetHandleId(u)] ~= true then
            ctx["已命中组"][GetHandleId(u)] = true
            _____672CTick_547D_4E2D_6570 = _____672CTick_547D_4E2D_6570 + 1
            local _____662F_654C_4EBA = IsUnitEnemy(u, owner)
            debugLogForce(
                "云端W",
                "范围结算-命中",
                "施法者",
                GetHandleId(caster),
                "目标",
                GetHandleId(u),
                "模式",
                ctx["模式"],
                "是敌人",
                _____662F_654C_4EBA,
                "X",
                x,
                "Y",
                y,
                "伤害快照",
                ctx["伤害快照"],
                "技能实例ID",
                ctx["技能实例ID"]
            )
            if ctx["模式"] == "光剑" then
                if _____662F_654C_4EBA then
                    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                        ["来源"] = caster,
                        ["目标"] = u,
                        ["伤害"] = ctx["伤害快照"],
                        ["伤害类型"] = DAMAGE_TYPE_DIVINE,
                        attack = false,
                        attackType = ATTACK_TYPE_NORMAL,
                        weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
                        ["来源类型"] = "单位技能",
                        ["标签"] = "云端-W光剑",
                        ["技能ID"] = ____W_7C7B_578BID,
                        ["技能实例ID"] = ctx["技能实例ID"]
                    })
                else
                    doHeal({
                        HealSource = caster,
                        HealTarget = u,
                        HealAmount = ctx["伤害快照"] * _____914D_7F6E.W["光剑"]["治疗比例"],
                        ItemHeal = false,
                        HealEffect = true
                    })
                end
            elseif _____662F_654C_4EBA then
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = caster,
                    ["目标"] = u,
                    ["伤害"] = ctx["伤害快照"],
                    ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                    attack = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_METAL_HEAVY_BASH,
                    ["来源类型"] = "单位技能",
                    ["标签"] = "云端-W暗剑",
                    ["技能ID"] = ____W_7C7B_578BID,
                    ["技能实例ID"] = ctx["技能实例ID"]
                })
                _____65BD_52A0_7729_6655(
                    caster,
                    u,
                    _____914D_7F6E.W["暗剑"]["眩晕秒"],
                    "云端-暗剑",
                    "技能"
                )
                registerManualBuff(u, _____4E91_7AEFBuffID["暗剑眩晕"], _____914D_7F6E.W["暗剑"]["眩晕秒"], 0)
            end
        end
        u = FirstOfGroup(group)
    end
    DestroyGroup(group)
    if _____672CTick_547D_4E2D_6570 > 0 then
        debugLogForce(
            "云端W",
            "范围结算-本Tick命中数",
            "施法者",
            GetHandleId(caster),
            "模式",
            ctx["模式"],
            "命中数",
            _____672CTick_547D_4E2D_6570,
            "X",
            x,
            "Y",
            y,
            "技能实例ID",
            ctx["技能实例ID"]
        )
    end
end
local function _____63A8_8FDBW_8DEF_5F84(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    ctx["Tick数"] = ctx["Tick数"] + 1
    if ctx["Tick数"] > _____914D_7F6E.W["路径"]["最大Tick数"] then
        debugLogForce(
            "云端W",
            "推进-达到最大Tick结束",
            "施法者",
            GetHandleId(ctx["施法者"]),
            "Tick数",
            ctx["Tick数"],
            "技能实例ID",
            ctx["技能实例ID"]
        )
        _____7ED3_675FW_8DEF_5F84(ctx)
        return
    end
    local rad = ctx["角度"] * bj_DEGTORAD
    local x = ctx["起点X"] + Cos(rad) * (_____914D_7F6E.W["路径"]["每Tick距离"] * ctx["Tick数"])
    local y = ctx["起点Y"] + Sin(rad) * (_____914D_7F6E.W["路径"]["每Tick距离"] * ctx["Tick数"])
    if ctx["路径特效"] ~= nil and ctx["路径特效"] ~= 0 then
        DzSetEffectPos(ctx["路径特效"], x, y, 0)
    end
    local _____5206_652F = ctx["模式"] == "光剑" and _____914D_7F6E.W["光剑"] or _____914D_7F6E.W["暗剑"]
    do
        local i = 0
        while i < #_____5206_652F["路径特效"] do
            local p = _____5206_652F["路径特效"][i + 1]
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = p["模型"],
                X = x,
                Y = y,
                Z = p["高度"],
                ["面向角度"] = 270,
                ["缩放"] = p["缩放"],
                ["持续秒"] = p["持续秒"]
            })
            i = i + 1
        end
    end
    if ctx["施法者"] ~= nil and ctx["施法者"] ~= 0 and IsUnitAliveBJ(ctx["施法者"]) then
        _____7ED3_7B97W_8303_56F4(ctx, x, y)
    end
end
local function _____542F_52A8W_8DEF_5F84(variable)
    local ctx = variable
    if ctx == nil or ctx["已启动"] ~= true then
        return
    end
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not IsUnitAliveBJ(caster) then
        debugLogForce(
            "云端W",
            "启动-施法者失效结束",
            "施法者",
            GetHandleId(caster),
            "技能实例ID",
            ctx["技能实例ID"]
        )
        _____7ED3_675FW_8DEF_5F84(ctx)
        return
    end
    debugLogForce(
        "云端W",
        "启动-路径开始",
        "施法者",
        GetHandleId(caster),
        "模式",
        ctx["模式"],
        "技能实例ID",
        ctx["技能实例ID"]
    )
    ctx["Tick数"] = 0
    ctx["回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.W["路径"]["Tick间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBW_8DEF_5F84,
        ctx
    )
end
local function _____91CA_653EW_5149_6697_9B54_5251(context, caster, _____6280_80FD_5B9E_4F8BID)
    local sx = GetUnitX(caster)
    local sy = GetUnitY(caster)
    local tx = GetSpellTargetX()
    local ty = GetSpellTargetY()
    local _____89D2_5EA6 = Atan2(ty - sy, tx - sx) * bj_RADTODEG
    local _____6A21_5F0F = _____6D88_8017_4E91_7AEFW_6A21_5F0F(caster)
    local _____7B49_7EA7 = GetUnitAbilityLevel(caster, ____W_7C7B_578BID)
    local _____4F24_5BB3_5FEB_7167 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * _____914D_7F6E.W["伤害公式"]["攻击力倍率"] + GetHeroInt(caster, true) * (_____914D_7F6E.W["伤害公式"]["智力每级系数"] * _____7B49_7EA7)
    debugLogForce(
        "云端W",
        "入口-释放",
        "施法者",
        GetHandleId(caster),
        "技能ID",
        _____914D_7F6E.W["技能ID"],
        "技能实例ID",
        _____6280_80FD_5B9E_4F8BID,
        "模式",
        _____6A21_5F0F,
        "等级",
        _____7B49_7EA7,
        "伤害快照",
        _____4F24_5BB3_5FEB_7167,
        "角度",
        _____89D2_5EA6,
        "目标点X",
        tx,
        "目标点Y",
        ty
    )
    context["施法者"] = caster
    context["模式"] = _____6A21_5F0F
    context["伤害快照"] = _____4F24_5BB3_5FEB_7167
    context["起点X"] = sx
    context["起点Y"] = sy
    context["角度"] = _____89D2_5EA6
    context["Tick数"] = 0
    context["已命中组"] = {}
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["已启动"] = true
    GS_Suspend(caster, _____914D_7F6E.W["硬直秒"])
    SetUnitInvulnerable(caster, true)
    SetUnitTimeScale(caster, _____914D_7F6E.W["时间流速"])
    SetUnitAnimation(caster, _____914D_7F6E.W["动作名"])
    local _____5206_652F = _____6A21_5F0F == "光剑" and _____914D_7F6E.W["光剑"] or _____914D_7F6E.W["暗剑"]
    context["路径特效"] = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____5206_652F["起手特效"]["模型"],
        X = sx,
        Y = sy,
        Z = 0,
        ["面向角度"] = _____89D2_5EA6,
        ["缩放"] = _____5206_652F["起手特效"]["缩放"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.W["护场特效"]["模型"],
        X = sx,
        Y = sy,
        Z = 0,
        ["面向角度"] = _____89D2_5EA6,
        ["缩放"] = _____914D_7F6E.W["护场特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.W["护场特效"]["持续秒"],
        ["红"] = _____5206_652F["护场颜色"]["红"],
        ["绿"] = _____5206_652F["护场颜色"]["绿"],
        ["蓝"] = _____5206_652F["护场颜色"]["蓝"],
        ["透明度"] = _____5206_652F["护场颜色"]["透明度"]
    })
    addDelayedCallback(
        math.floor(_____914D_7F6E.W["路径"]["启动延迟秒"] * 1000 + 0.5),
        _____542F_52A8W_8DEF_5F84,
        context
    )
end
____exports["注册云端W"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "云端-光暗魔剑（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.W["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["可释放"] = ____W_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EW_5149_6697_9B54_5251,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 3
    })
end
____exports["注册云端W"]()
return ____exports
