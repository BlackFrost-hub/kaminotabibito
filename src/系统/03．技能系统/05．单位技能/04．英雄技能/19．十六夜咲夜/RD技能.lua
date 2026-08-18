--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_2["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_3["结束独立技能伤害实例"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜")
local _____5341_516D_591C_54B2_591CBuffID = ____require_result_6["十六夜咲夜BuffID"]
local ____RD_5E8F_53F7 = 0
local function _____83B7_53D6RD_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function ____RD_679A_4E3E_654C_519B(context)
    local result = {}
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        group,
        jass.GetUnitX(context["目标"]),
        jass.GetUnitY(context["目标"]),
        _____914D_7F6E.RD["伤害半径"],
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
            ) or jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) then
                goto __continue4
            end
            result[#result + 1] = unit
        end
        ::__continue4::
    end
    jass.DestroyGroup(group)
    return result
end
local function ____RD_6E05_7406(context)
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
    context["快照周期ID"] = 0
    context["刀光周期ID"] = 0
    context["切割周期ID"] = 0
    do
        local i = 0
        while i < #context["刀光"] do
            _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["刀光"][i + 1])
            i = i + 1
        end
    end
    context["刀光"] = {}
    _____5B89_5168_79FB_9664_5355_4F4D_58F3(context["法阵"])
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        jass.SetUnitInvulnerable(context["目标"], false)
        _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["来源"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["目标"], _____5341_516D_591C_54B2_591CBuffID["收缩世界目标封印"])
    end
    if context["施法者"] ~= nil and context["施法者"] ~= 0 then
        jass.SetUnitInvulnerable(context["施法者"], false)
        _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["来源"])
        jass.SetUnitTimeScale(context["施法者"], 1)
        jass.SetUnitAnimation(context["施法者"], "stand")
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____5341_516D_591C_54B2_591CBuffID["收缩世界吟唱"])
    end
    _____5173_95ED_541F_5531_6761("常规技能")
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
end
local function ____RD_7EF4_6301_5C01_5370(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        ____RD_6E05_7406(context)
        return
    end
    jass.SetUnitState(context["目标"], jass.UNIT_STATE_LIFE, context["目标生命快照"])
    jass.SetUnitState(context["目标"], jass.UNIT_STATE_MANA, context["目标魔法快照"])
end
local function ____RD_6267_884C_5207_5272(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        ____RD_6E05_7406(context)
        return
    end
    if context["切割计数"] >= _____914D_7F6E.RD["刀光数量"] then
        ____RD_6E05_7406(context)
        return
    end
    local targets = ____RD_679A_4E3E_654C_519B(context)
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
        ["每目标处理器"] = function()
            return {["伤害"] = context["攻击力快照"] * _____914D_7F6E.RD["伤害攻击力倍率"]}
        end
    })
    if context["刀光"][context["切割计数"] + 1] ~= nil then
        jass.SetUnitTimeScale(context["刀光"][context["切割计数"] + 1], 20)
        jass.SetUnitAnimation(context["刀光"][context["切割计数"] + 1], "death")
    end
    context["切割计数"] = context["切割计数"] + 1
end
local function ____RD_5F00_59CB_5207_5272(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    context["切割计数"] = 0
    ____RD_6267_884C_5207_5272(context)
    context["切割周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.RD["切割间隔毫秒"], ____RD_6267_884C_5207_5272, context)
end
local function ____RD_521B_5EFA_5200_5149(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if context["刀光计数"] >= _____914D_7F6E.RD["刀光数量"] then
        if context["刀光周期ID"] ~= 0 then
            _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["刀光周期ID"])
        end
        context["刀光周期ID"] = 0
        addDelayedCallback(_____914D_7F6E.RD["准备后延迟秒"] * 1000, ____RD_5F00_59CB_5207_5272, context)
        return
    end
    local angle = jass.GetRandomReal(0, 360)
    local distance = jass.GetRandomReal(0, _____914D_7F6E.RD["伤害半径"])
    local x = _____6781_5750_6807X(
        jass.GetUnitX(context["目标"]),
        distance,
        angle
    )
    local y = _____6781_5750_6807Y(
        jass.GetUnitY(context["目标"]),
        distance,
        angle
    )
    local slash = _____521B_5EFA_54B2_591C_5355_4F4D_58F3(
        context["施法者"],
        _____914D_7F6E["单位壳"]["收缩刀光"],
        x,
        y,
        jass.GetRandomReal(0, 360)
    )
    if slash ~= nil and slash ~= 0 then
        jass.SetUnitScale(slash, _____914D_7F6E.RD["刀光缩放"], _____914D_7F6E.RD["刀光缩放"], _____914D_7F6E.RD["刀光缩放"])
        jass.SetUnitFlyHeight(slash, _____914D_7F6E.RD["刀光高度"], 0)
        jass.SetUnitTimeScale(slash, 0)
        local ____context__5200_5149_7 = context["刀光"]
        ____context__5200_5149_7[#____context__5200_5149_7 + 1] = slash
    end
    context["刀光计数"] = context["刀光计数"] + 1
end
local function ____RD_541F_5531_5B8C_6210(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if context["快照周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["快照周期ID"])
    end
    context["快照周期ID"] = 0
    _____5173_95ED_541F_5531_6761("常规技能")
    jass.SetUnitInvulnerable(context["目标"], false)
    jass.SetUnitAnimationByIndex(context["施法者"], 3)
    jass.SetUnitTimeScale(context["施法者"], 1.5)
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RD2", context["施法者"])
    context["刀光周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.RD["刀光准备间隔毫秒"], ____RD_521B_5EFA_5200_5149, context)
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRD(_listener, caster, _____6280_80FD_5B9E_4F8BID)
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
            jass.GetRandomReal(0, 360)
        ),
        ["刀光"] = {},
        ["目标生命快照"] = jass.GetUnitState(target, jass.UNIT_STATE_LIFE),
        ["目标魔法快照"] = jass.GetUnitState(target, jass.UNIT_STATE_MANA),
        ["攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster),
        ["快照周期ID"] = 0,
        ["刀光周期ID"] = 0,
        ["切割周期ID"] = 0,
        ["刀光计数"] = 0,
        ["切割计数"] = 0,
        ["已结束"] = false
    }
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["来源"])
    _____6DFB_52A0_5355_4F4D_6682_505C(target, context["来源"])
    jass.SetUnitInvulnerable(caster, true)
    jass.SetUnitInvulnerable(target, true)
    jass.SetUnitAnimationByIndex(caster, 8)
    registerManualBuff(
        caster,
        _____5341_516D_591C_54B2_591CBuffID["收缩世界吟唱"],
        _____914D_7F6E.RD["吟唱秒"],
        0,
        {sourceUnit = caster}
    )
    registerManualBuff(
        target,
        _____5341_516D_591C_54B2_591CBuffID["收缩世界目标封印"],
        _____914D_7F6E.RD["吟唱秒"],
        0,
        {sourceUnit = caster}
    )
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RD1", caster)
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = _____914D_7F6E.RD["吟唱秒"], ["标题文本"] = "收缩的世界", ["提示文本"] = "时间正在收缩"})
    context["快照周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.RD["快照周期毫秒"], ____RD_7EF4_6301_5C01_5370, context)
    addDelayedCallback(_____914D_7F6E.RD["吟唱秒"] * 1000, ____RD_541F_5531_5B8C_6210, context)
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
