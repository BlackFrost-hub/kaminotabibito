local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____53D6_5207_5272_6682_505C_6765_6E90, ____RD_8BBE_7F6E_78B0_649E, ____RD_679A_4E3E_5207_5272_654C_519B, ____RD_8BB0_5F55_88AB_5207_5355_4F4D, ____RD_6062_590D_88AB_5207_5355_4F4D, ____RD_5904_7406_5207_5272_76EE_6807, ____RD_51BB_7ED3_5200_5149, ____RD_4E0B_964D, ____RD_6B63_5E38_6536_5C3E, ____RD_6267_884C_5207_5272, ____RD_5F00_59CB_5207_5272, ____RD_521B_5EFA_5200_5149, ____RD_541F_5531_5B8C_6210, jass, japi, GetRandomDirectionDeg, addDelayedCallback, _____6DFB_52A0_5355_4F4D_6682_505C, _____79FB_9664_5355_4F4D_6682_505C, _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3, _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____5341_516D_591C_54B2_591CBuffID, CinematicFilterGenericBJ, ____RD_914D_7F6E, ____RD_78B0_649E_7C7B_578B, ____RD_6765_6E90_540E_7F00
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____521B_5EFA_54B2_591C_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["创建咲夜单位壳"]
local _____5B89_5168_79FB_9664_5355_4F4D_58F3 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["安全移除单位壳"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注册咲夜周期任务"]
local _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["移除咲夜周期任务"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local _____7B26_5361_516C_5171 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.符卡公共")
local _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374 = _____7B26_5361_516C_5171["设置十六夜咲夜符卡书冷却"]
function _____53D6_5207_5272_6682_505C_6765_6E90(context)
    return context["来源"] .. ____RD_6765_6E90_540E_7F00
end
function ____RD_8BBE_7F6E_78B0_649E(unit, enabled)
    if unit == nil or unit == 0 then
        return
    end
    if japi ~= nil and type(japi.EXSetUnitCollisionType) == "function" then
        japi.EXSetUnitCollisionType(enabled, unit, ____RD_78B0_649E_7C7B_578B)
    end
end
function ____RD_679A_4E3E_5207_5272_654C_519B(context)
    local result = {}
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        group,
        context["目标中心X"],
        context["目标中心Y"],
        ____RD_914D_7F6E["伤害半径"],
        nil
    )
    while true do
        do
            local unit = jass.FirstOfGroup(group)
            if unit == nil or unit == 0 then
                break
            end
            jass.GroupRemoveUnit(group, unit)
            if not _____5355_4F4D_5B58_6D3B(unit) or not jass.IsUnitEnemy(
                unit,
                jass.GetOwningPlayer(context["施法者"])
            ) or jass.IsUnitType(unit, jass.UNIT_TYPE_TAUREN) then
                goto __continue8
            end
            result[#result + 1] = unit
        end
        ::__continue8::
    end
    jass.DestroyGroup(group)
    return result
end
function ____RD_8BB0_5F55_88AB_5207_5355_4F4D(context, unit)
    local id = jass.GetHandleId(unit)
    if context["记录单位索引"][id] then
        return
    end
    context["记录单位索引"][id] = true
    local ____context__8BB0_5F55_5355_4F4D_10 = context["记录单位"]
    ____context__8BB0_5F55_5355_4F4D_10[#____context__8BB0_5F55_5355_4F4D_10 + 1] = unit
end
function ____RD_6062_590D_88AB_5207_5355_4F4D(context)
    local source = _____53D6_5207_5272_6682_505C_6765_6E90(context)
    do
        local i = 0
        while i < #context["记录单位"] do
            do
                local unit = context["记录单位"][i + 1]
                if unit == nil or unit == 0 then
                    goto __continue15
                end
                ____RD_8BBE_7F6E_78B0_649E(unit, true)
                _____79FB_9664_5355_4F4D_6682_505C(unit, source)
                jass.SetUnitTimeScale(unit, 1)
                jass.SetUnitPathing(unit, true)
            end
            ::__continue15::
            i = i + 1
        end
    end
end
function ____RD_5904_7406_5207_5272_76EE_6807(context, target)
    jass.SetUnitPathing(target, false)
    local moveAngle = jass.GetUnitFacing(target) + 180
    jass.SetUnitPosition(
        target,
        _____6781_5750_6807X(
            jass.GetUnitX(target),
            ____RD_914D_7F6E["目标位移距离"],
            moveAngle
        ),
        _____6781_5750_6807Y(
            jass.GetUnitY(target),
            ____RD_914D_7F6E["目标位移距离"],
            moveAngle
        )
    )
    jass.SetUnitFacing(
        target,
        GetRandomDirectionDeg()
    )
    _____6DFB_52A0_5355_4F4D_6682_505C(
        target,
        _____53D6_5207_5272_6682_505C_6765_6E90(context)
    )
    ____RD_8BBE_7F6E_78B0_649E(target, false)
    jass.SetUnitTimeScale(target, 20)
    jass.SetUnitAnimation(target, "Death")
    ____RD_8BB0_5F55_88AB_5207_5355_4F4D(context, target)
end
function ____RD_51BB_7ED3_5200_5149(variable)
    local params = variable
    if params == nil or params["上下文"]["已结束"] or params["上下文"]["正常收尾"] then
        return
    end
    if _____5355_4F4D_5B58_6D3B(params["刀光"]) then
        jass.SetUnitTimeScale(params["刀光"], 0)
    end
end
function ____RD_4E0B_964D(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        context["已结束"] = true
        if context["下降周期ID"] ~= 0 then
            _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["下降周期ID"])
        end
        context["下降周期ID"] = 0
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        return
    end
    if context["下降计数"] >= ____RD_914D_7F6E["下降次数"] then
        jass.SetUnitFlyHeight(
            context["施法者"],
            jass.GetUnitDefaultFlyHeight(context["施法者"]),
            0
        )
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["下降周期ID"])
        context["下降周期ID"] = 0
        context["已结束"] = true
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        return
    end
    jass.SetUnitFlyHeight(
        context["施法者"],
        jass.GetUnitFlyHeight(context["施法者"]) - ____RD_914D_7F6E["下降每次高度"],
        0
    )
    context["下降计数"] = context["下降计数"] + 1
end
function ____RD_6B63_5E38_6536_5C3E(context)
    if context["已结束"] or context["正常收尾"] then
        return
    end
    context["正常收尾"] = true
    if context["快照周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["快照周期ID"])
    end
    if context["刀光周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["刀光周期ID"])
    end
    if context["切割周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["切割周期ID"])
    end
    context["快照周期ID"] = 0
    context["刀光周期ID"] = 0
    context["切割周期ID"] = 0
    ____RD_6062_590D_88AB_5207_5355_4F4D(context)
    if _____5355_4F4D_5B58_6D3B(context["目标"]) then
        jass.SetUnitInvulnerable(context["目标"], false)
        _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["来源"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["目标"], _____5341_516D_591C_54B2_591CBuffID["收缩世界目标封印"])
    end
    if _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        jass.SetUnitInvulnerable(context["施法者"], false)
        _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["来源"])
        jass.SetUnitTimeScale(context["施法者"], 1)
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____5341_516D_591C_54B2_591CBuffID["收缩世界吟唱"])
    end
    do
        local i = 0
        while i < #context["刀光"] do
            if _____5355_4F4D_5B58_6D3B(context["刀光"][i + 1]) then
                jass.SetUnitTimeScale(context["刀光"][i + 1], 1)
            end
            i = i + 1
        end
    end
    CinematicFilterGenericBJ(
        0.5,
        jass.BLEND_MODE_BLEND,
        "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
        100,
        100,
        100,
        100,
        0,
        0,
        0,
        100
    )
    context["下降计数"] = 0
    context["下降周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(____RD_914D_7F6E["下降周期毫秒"], ____RD_4E0B_964D, context)
end
function ____RD_6267_884C_5207_5272(variable)
    local context = variable
    if context == nil or context["已结束"] or context["正常收尾"] then
        return
    end
    if context["切割计数"] >= ____RD_914D_7F6E["切割次数"] then
        ____RD_6B63_5E38_6536_5C3E(context)
        return
    end
    local targets = ____RD_679A_4E3E_5207_5272_654C_519B(context)
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = targets,
        ["伤害类型"] = jass.DAMAGE_TYPE_NORMAL,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_HERO,
        weaponType = jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____914D_7F6E["技能"].RD["类型ID"],
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "十六夜咲夜-RD-收缩的世界",
        ["伤害形态"] = "AOE",
        ["每目标处理器"] = function(target)
            ____RD_5904_7406_5207_5272_76EE_6807(context, target)
            return {["伤害"] = context["攻击力快照"] * ____RD_914D_7F6E["伤害攻击力倍率"]}
        end,
        ["每目标结算后处理器"] = function(target)
            if not jass.IsUnitType(target, jass.UNIT_TYPE_TAUREN) and jass.IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) then
                jass.KillUnit(target)
            end
        end
    })
    context["切割计数"] = context["切割计数"] + 1
    do
        local i = 0
        while i < ____RD_914D_7F6E["每批刀光数量"] do
            do
                if #context["待切刀光"] <= 0 then
                    break
                end
                local index = jass.GetRandomInt(0, #context["待切刀光"] - 1)
                local slash = context["待切刀光"][index + 1]
                __TS__ArraySplice(context["待切刀光"], index, 1)
                if slash == nil or slash == 0 or not _____5355_4F4D_5B58_6D3B(slash) then
                    goto __continue59
                end
                jass.SetUnitTimeScale(slash, 0.4)
                local angle = GetRandomDirectionDeg()
                local distance = jass.GetRandomReal(____RD_914D_7F6E["刀光移动最小距离"], ____RD_914D_7F6E["刀光移动最大距离"])
                jass.SetUnitPosition(
                    slash,
                    _____6781_5750_6807X(
                        jass.GetUnitX(slash),
                        distance,
                        angle
                    ),
                    _____6781_5750_6807Y(
                        jass.GetUnitY(slash),
                        distance,
                        angle
                    )
                )
                jass.SetUnitFacing(
                    slash,
                    GetRandomDirectionDeg()
                )
            end
            ::__continue59::
            i = i + 1
        end
    end
end
function ____RD_5F00_59CB_5207_5272(variable)
    local context = variable
    if context == nil or context["已结束"] or context["正常收尾"] then
        return
    end
    context["切割计数"] = 0
    context["切割周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(____RD_914D_7F6E["切割间隔毫秒"], ____RD_6267_884C_5207_5272, context)
end
function ____RD_521B_5EFA_5200_5149(variable)
    local context = variable
    if context == nil or context["已结束"] or context["正常收尾"] then
        return
    end
    if context["准备批次计数"] >= ____RD_914D_7F6E["刀光准备批次"] then
        if context["刀光周期ID"] ~= 0 then
            _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["刀光周期ID"])
        end
        context["刀光周期ID"] = 0
        addDelayedCallback(____RD_914D_7F6E["准备后延迟秒"] * 1000, ____RD_5F00_59CB_5207_5272, context)
        return
    end
    context["准备批次计数"] = context["准备批次计数"] + 1
    local lastSlash = nil
    do
        local i = 0
        while i < ____RD_914D_7F6E["每批刀光数量"] do
            do
                local angle = GetRandomDirectionDeg()
                local distance = jass.GetRandomReal(0, 850)
                local slash = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
                    context["施法者"],
                    _____914D_7F6E["单位壳"]["收缩刀光"],
                    _____6781_5750_6807X(context["目标中心X"], distance, angle),
                    _____6781_5750_6807Y(context["目标中心Y"], distance, angle),
                    GetRandomDirectionDeg()
                )
                if slash == nil or slash == 0 then
                    goto __continue69
                end
                jass.SetUnitScale(slash, ____RD_914D_7F6E["刀光缩放"], ____RD_914D_7F6E["刀光缩放"], ____RD_914D_7F6E["刀光缩放"])
                jass.SetUnitFacing(
                    slash,
                    GetRandomDirectionDeg()
                )
                local ____context__5200_5149_11 = context["刀光"]
                ____context__5200_5149_11[#____context__5200_5149_11 + 1] = slash
                local ____context__5F85_5207_5200_5149_12 = context["待切刀光"]
                ____context__5F85_5207_5200_5149_12[#____context__5F85_5207_5200_5149_12 + 1] = slash
                context["刀光计数"] = context["刀光计数"] + 1
                lastSlash = slash
            end
            ::__continue69::
            i = i + 1
        end
    end
    if lastSlash ~= nil and lastSlash ~= 0 then
        addDelayedCallback(____RD_914D_7F6E["刀光冻结延迟毫秒"], ____RD_51BB_7ED3_5200_5149, {["上下文"] = context, ["刀光"] = lastSlash})
    end
end
function ____RD_541F_5531_5B8C_6210(variable)
    local context = variable
    if context == nil or context["已结束"] or context["正常收尾"] then
        return
    end
    if context["快照周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["快照周期ID"])
    end
    context["快照周期ID"] = 0
    jass.SetUnitInvulnerable(context["目标"], false)
    context["刀光周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(____RD_914D_7F6E["刀光准备间隔毫秒"], ____RD_521B_5EFA_5200_5149, context)
end
jass = require("jass.common")
japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
GetRandomDirectionDeg = ____require_result_0.GetRandomDirectionDeg
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
_____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_2["添加单位暂停"]
_____79FB_9664_5355_4F4D_6682_505C = ____require_result_2["移除单位暂停"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_4["造成批量AOE技能伤害"]
_____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_4["结束独立技能伤害实例"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_6["移除单位指定Buff"]
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜")
_____5341_516D_591C_54B2_591CBuffID = ____require_result_7["十六夜咲夜BuffID"]
local ____require_result_8 = require("lib.扩展函数.BJ函数.05A．电影函数")
CinematicFilterGenericBJ = ____require_result_8.CinematicFilterGenericBJ
local ____require_result_9 = require("平台扩展API动作")
local _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B = ____require_result_9["单位扩展_设移动类型"]
____RD_914D_7F6E = _____914D_7F6E.RD
____RD_78B0_649E_7C7B_578B = 1
____RD_6765_6E90_540E_7F00 = ":切割"
local ____RD_5E8F_53F7 = 0
local function _____83B7_53D6RD_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function ____RD_5F02_5E38_6E05_7406(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["快照周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["快照周期ID"])
    end
    if context["刀光周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["刀光周期ID"])
    end
    if context["切割周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["切割周期ID"])
    end
    if context["下降周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["下降周期ID"])
    end
    context["快照周期ID"] = 0
    context["刀光周期ID"] = 0
    context["切割周期ID"] = 0
    context["下降周期ID"] = 0
    do
        local i = 0
        while i < #context["刀光"] do
            _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["刀光"][i + 1])
            i = i + 1
        end
    end
    context["刀光"] = {}
    context["待切刀光"] = {}
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["法阵"])
    ____RD_6062_590D_88AB_5207_5355_4F4D(context)
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        jass.SetUnitInvulnerable(context["目标"], false)
        _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["来源"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["目标"], _____5341_516D_591C_54B2_591CBuffID["收缩世界目标封印"])
    end
    if context["施法者"] ~= nil and context["施法者"] ~= 0 then
        jass.SetUnitInvulnerable(context["施法者"], false)
        _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["来源"])
        jass.SetUnitTimeScale(context["施法者"], 1)
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____5341_516D_591C_54B2_591CBuffID["收缩世界吟唱"])
    end
    _____5173_95ED_541F_5531_6761("常规技能")
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
end
local function ____RD_7EF4_6301_5C01_5370(variable)
    local context = variable
    if context == nil or context["已结束"] or context["正常收尾"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        ____RD_5F02_5E38_6E05_7406(context)
        return
    end
    if context["吟唱计数"] >= ____RD_914D_7F6E["吟唱完成计数"] then
        ____RD_541F_5531_5B8C_6210(context)
        return
    end
    context["吟唱计数"] = context["吟唱计数"] + 1
    jass.SetUnitInvulnerable(context["目标"], true)
    jass.SetUnitFacing(
        context["目标"],
        jass.Atan2(
            jass.GetUnitY(context["施法者"]) - jass.GetUnitY(context["目标"]),
            jass.GetUnitX(context["施法者"]) - jass.GetUnitX(context["目标"])
        ) / jass.bj_DEGTORAD
    )
    jass.SetUnitState(context["目标"], jass.UNIT_STATE_LIFE, context["目标生命快照"])
    jass.SetUnitState(context["目标"], jass.UNIT_STATE_MANA, context["目标魔法快照"])
    jass.SetUnitFlyHeight(
        context["施法者"],
        jass.GetUnitFlyHeight(context["施法者"]) + 5,
        0
    )
    if context["吟唱计数"] == ____RD_914D_7F6E["吟唱动作切换计数"] then
        jass.SetUnitAnimationByIndex(context["施法者"], 3)
        jass.SetUnitTimeScale(context["施法者"], 1.5)
    end
    if context["吟唱计数"] == ____RD_914D_7F6E["吟唱音效计数"] then
        _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RD2", context["施法者"])
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRD(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374(caster, _____914D_7F6E["符卡间隔秒"].RD)
    local target = jass.GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    ____RD_5E8F_53F7 = ____RD_5E8F_53F7 + 1
    local context = {
        ["施法者"] = caster,
        ["目标"] = target,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["来源"] = "十六夜咲夜-RD:" .. tostring(____RD_5E8F_53F7),
        ["法阵"] = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
            caster,
            _____914D_7F6E["单位壳"]["收缩法阵"],
            jass.GetUnitX(caster),
            jass.GetUnitY(caster),
            GetRandomDirectionDeg()
        ),
        ["刀光"] = {},
        ["待切刀光"] = {},
        ["记录单位"] = {},
        ["记录单位索引"] = {},
        ["目标生命快照"] = jass.GetUnitState(target, jass.UNIT_STATE_LIFE),
        ["目标魔法快照"] = jass.GetUnitState(target, jass.UNIT_STATE_MANA),
        ["目标中心X"] = jass.GetUnitX(target),
        ["目标中心Y"] = jass.GetUnitY(target),
        ["攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["吟唱计数"] = 0,
        ["快照周期ID"] = 0,
        ["刀光周期ID"] = 0,
        ["切割周期ID"] = 0,
        ["下降周期ID"] = 0,
        ["刀光计数"] = 0,
        ["准备批次计数"] = 0,
        ["切割计数"] = 0,
        ["下降计数"] = 0,
        ["正常收尾"] = false,
        ["已结束"] = false
    }
    if context["法阵"] ~= nil and context["法阵"] ~= 0 then
        jass.SetUnitScale(context["法阵"], ____RD_914D_7F6E["法阵缩放"], ____RD_914D_7F6E["法阵缩放"], ____RD_914D_7F6E["法阵缩放"])
    end
    jass.SetCameraField(jass.CAMERA_FIELD_TARGET_DISTANCE, 3000, 0)
    _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B(caster, 2)
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["来源"])
    _____6DFB_52A0_5355_4F4D_6682_505C(target, context["来源"])
    jass.SetUnitInvulnerable(caster, true)
    jass.SetUnitInvulnerable(target, true)
    jass.SetUnitAnimationByIndex(caster, 8)
    registerManualBuff(
        caster,
        _____5341_516D_591C_54B2_591CBuffID["收缩世界吟唱"],
        ____RD_914D_7F6E["吟唱秒"],
        0,
        {sourceUnit = caster}
    )
    registerManualBuff(
        target,
        _____5341_516D_591C_54B2_591CBuffID["收缩世界目标封印"],
        ____RD_914D_7F6E["吟唱秒"],
        0,
        {sourceUnit = caster}
    )
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RD1", caster)
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = ____RD_914D_7F6E["吟唱秒"], ["标题文本"] = "收缩的世界", ["提示文本"] = "时间正在收缩"})
    context["快照周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(____RD_914D_7F6E["快照周期毫秒"], ____RD_7EF4_6301_5C01_5370, context)
end
____exports["注册十六夜咲夜RD"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-收缩的世界（RD）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RD["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RD_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 20
    })
end
____exports["注册十六夜咲夜RD"]()
return ____exports
