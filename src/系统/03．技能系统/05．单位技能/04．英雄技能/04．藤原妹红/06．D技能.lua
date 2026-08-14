local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00．配置")
local _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["藤原妹红单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00A．表现工具")
local _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红单位音效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红点特效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红单位特效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统")
local _____5F00_59CB_7EBF_6027_5347_964D = ____require_result_1["开始线性升降"]
local _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D = ____require_result_1["停止单位线性升降"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_2["施加眩晕"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_4["获取范围敌军"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local GetHandleId = jass.GetHandleId
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local BJ_DEGTORAD = jass.bj_DEGTORAD or 0.017453292519943295
local stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe
local _____666E_901AD_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通D技能ID"])
local _____666E_901AD_4E0A_4E0B_6587_8868 = {}
local ____D_51FB_98DE_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    return (unit == nil or unit == 0) and 0 or (GetHandleId(unit) or 0)
end
local function _____83B7_53D6D_4E0A_4E0B_6587(unit)
    return unit
end
local function ____D_76EE_6807_5141_8BB8_547D_4E2D(caster, target)
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return false
    end
    return IsUnitEnemy(
        target,
        GetOwningPlayer(caster)
    )
end
local function _____6E05_7406D_51FB_98DE_76EE_6807(context)
    do
        local i = 0
        while i < #context["击飞目标列表"] do
            local target = context["击飞目标列表"][i + 1]
            local targetId = _____53D6_5355_4F4D_53E5_67C4ID(target)
            local record = ____D_51FB_98DE_8868[targetId]
            if record ~= nil and record["施法者"] == context["施法者"] then
                __TS__Delete(____D_51FB_98DE_8868, targetId)
                _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D(target, "中断")
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(context["击飞目标列表"], 0)
end
local function _____6E05_7406_85E4_539F_59B9_7EA2D(context)
    if not context["活跃"] then
        return
    end
    context["活跃"] = false
    if context["爆炸计时回调ID"] ~= 0 then
        removePeriodicCallback(context["爆炸计时回调ID"])
        context["爆炸计时回调ID"] = 0
    end
    if context["燃烧回调ID"] ~= 0 then
        removePeriodicCallback(context["燃烧回调ID"])
        context["燃烧回调ID"] = 0
    end
    _____6E05_7406D_51FB_98DE_76EE_6807(context)
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if _____666E_901AD_4E0A_4E0B_6587_8868[casterId] == context then
        __TS__Delete(_____666E_901AD_4E0A_4E0B_6587_8868, casterId)
    end
end
local function ____D_51FB_98DE_5347_964D_7ED3_675F(unit, reason, _liftId)
    local targetId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    local record = ____D_51FB_98DE_8868[targetId]
    if record == nil then
        return
    end
    if reason == "完成" and not record["已开始下降"] and _____5355_4F4D_5B58_6D3B(record["施法者"]) and _____5355_4F4D_5B58_6D3B(record["目标"]) then
        record["已开始下降"] = true
        _____5F00_59CB_7EBF_6027_5347_964D(record["目标"], {
            ["持续时间"] = 0.25,
            ["高度变化"] = -2080,
            ["暂停单位"] = false,
            ["主单位"] = record["施法者"],
            ["结束回调"] = ____D_51FB_98DE_5347_964D_7ED3_675F
        })
        return
    end
    __TS__Delete(____D_51FB_98DE_8868, targetId)
end
local function _____5F00_59CBD_51FB_98DE(context, target)
    local targetId = _____53D6_5355_4F4D_53E5_67C4ID(target)
    if targetId == 0 then
        return
    end
    local record = {["施法者"] = context["施法者"], ["目标"] = target, ["已开始下降"] = false}
    ____D_51FB_98DE_8868[targetId] = record
    local ____context__51FB_98DE_76EE_6807_5217_8868_7 = context["击飞目标列表"]
    ____context__51FB_98DE_76EE_6807_5217_8868_7[#____context__51FB_98DE_76EE_6807_5217_8868_7 + 1] = target
    _____5F00_59CB_7EBF_6027_5347_964D(target, {
        ["持续时间"] = 0.25,
        ["高度变化"] = 2080,
        ["暂停单位"] = false,
        ["主单位"] = context["施法者"],
        ["结束回调"] = ____D_51FB_98DE_5347_964D_7ED3_675F
    })
end
local function _____5904_7406_85E4_539F_59B9_7EA2D_71C3_70E7_76EE_6807(target, _index, variable)
    local context = variable
    if context == nil or not ____D_76EE_6807_5141_8BB8_547D_4E2D(context["施法者"], target) then
        return nil
    end
    _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548(target, _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通D"]["持续特效资源"], "origin")
    return {
        ["伤害"] = context["燃烧伤害"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____85E4_539F_59B9_7EA2D_71C3_70E7Tick(variable)
    local context = variable
    if context == nil or not context["活跃"] then
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通D"]
    if context["燃烧次数"] >= cfg["燃烧次数"] then
        _____6E05_7406_85E4_539F_59B9_7EA2D(context)
        return
    end
    context["燃烧次数"] = context["燃烧次数"] + 1
    local targets = _____83B7_53D6_8303_56F4_654C_519B(context["施法者"], context.X, context.Y, cfg["爆炸范围"])
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = targets,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____666E_901AD_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "藤原妹红-燃烧殆尽",
        ["每目标处理器"] = _____5904_7406_85E4_539F_59B9_7EA2D_71C3_70E7_76EE_6807,
        ["变量"] = context
    })
end
local function _____85E4_539F_59B9_7EA2D_7206_70B8(context)
    if not context["活跃"] or context["爆炸已结算"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406_85E4_539F_59B9_7EA2D(context)
        return
    end
    context["爆炸已结算"] = true
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通D"]
    context["燃烧伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["施法者"]) * cfg["伤害攻击力倍率"]
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["中心特效"], context.X, context.Y)
    do
        local i = 0
        while i < cfg["外围特效数量"] do
            local angle = cfg["外围特效间隔角度"] * (i + 1)
            local radians = angle * BJ_DEGTORAD
            _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
                cfg["外围特效"],
                context.X + Cos(radians) * cfg["外围特效半径"],
                context.Y + Sin(radians) * cfg["外围特效半径"],
                angle
            )
            i = i + 1
        end
    end
    local targets = _____83B7_53D6_8303_56F4_654C_519B(context["施法者"], context.X, context.Y, cfg["爆炸范围"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not ____D_76EE_6807_5141_8BB8_547D_4E2D(context["施法者"], target) then
                    goto __continue32
                end
                _____65BD_52A0_7729_6655(
                    context["施法者"],
                    target,
                    cfg["控制秒"],
                    "藤原妹红-燃烧殆尽",
                    "技能"
                )
                _____5F00_59CBD_51FB_98DE(context, target)
            end
            ::__continue32::
            i = i + 1
        end
    end
    context["燃烧回调ID"] = addPeriodicCallback(cfg["燃烧间隔毫秒"], _____85E4_539F_59B9_7EA2D_71C3_70E7Tick, context)
    if context["燃烧次数"] == 0 then
        context["燃烧次数"] = 0
    end
end
local function _____85E4_539F_59B9_7EA2D_6301_7EED_8868_73B0(context)
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通D"]
    local angle = cfg["持续特效角度列表"][context["持续表现次数"] + 1]
    if angle == nil then
        return
    end
    local radians = angle * BJ_DEGTORAD
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
        cfg["持续特效资源"],
        context.X + Cos(radians) * cfg["持续特效半径"],
        context.Y + Sin(radians) * cfg["持续特效半径"],
        angle
    )
    context["持续表现次数"] = context["持续表现次数"] + 1
end
local function _____85E4_539F_59B9_7EA2D_7206_70B8_8BA1_65F6Tick(variable)
    local context = variable
    if context == nil or not context["活跃"] then
        return
    end
    _____85E4_539F_59B9_7EA2D_6301_7EED_8868_73B0(context)
    if context["持续表现次数"] >= #_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通D"]["持续特效角度列表"] then
        if context["爆炸计时回调ID"] ~= 0 then
            removePeriodicCallback(context["爆炸计时回调ID"])
        end
        context["爆炸计时回调ID"] = 0
        _____85E4_539F_59B9_7EA2D_7206_70B8(context)
    end
end
local function _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AD(_context, caster, skillInstanceId)
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(caster)
    local oldContext = _____666E_901AD_4E0A_4E0B_6587_8868[casterId]
    if oldContext ~= nil then
        _____6E05_7406_85E4_539F_59B9_7EA2D(oldContext)
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通D"]
    local context = {
        ["施法者"] = caster,
        X = GetSpellTargetX(),
        Y = GetSpellTargetY(),
        ["技能实例ID"] = skillInstanceId,
        ["爆炸计时回调ID"] = 0,
        ["燃烧回调ID"] = 0,
        ["爆炸已结算"] = false,
        ["持续表现次数"] = 0,
        ["燃烧次数"] = 0,
        ["燃烧伤害"] = 0,
        ["击飞目标列表"] = {},
        ["活跃"] = true
    }
    _____666E_901AD_4E0A_4E0B_6587_8868[casterId] = context
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    context["爆炸计时回调ID"] = addPeriodicCallback(cfg["启动间隔毫秒"], _____85E4_539F_59B9_7EA2D_7206_70B8_8BA1_65F6Tick, context)
end
local function _____85E4_539F_59B9_7EA2D_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    for key in pairs(_____666E_901AD_4E0A_4E0B_6587_8868) do
        do
            local context = _____666E_901AD_4E0A_4E0B_6587_8868[__TS__Number(key)]
            if context == nil or context["施法者"] ~= dyingUnit then
                goto __continue45
            end
            _____6E05_7406_85E4_539F_59B9_7EA2D(context)
        end
        ::__continue45::
    end
    for key in pairs(____D_51FB_98DE_8868) do
        do
            local record = ____D_51FB_98DE_8868[__TS__Number(key)]
            if record == nil or record["施法者"] ~= dyingUnit and record["目标"] ~= dyingUnit then
                goto __continue48
            end
            _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D(record["目标"], "中断")
            __TS__Delete(
                ____D_51FB_98DE_8868,
                __TS__Number(key)
            )
        end
        ::__continue48::
    end
end
____exports["注册藤原妹红普通D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-燃烧殆尽",
        ["单位类型ID"] = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"]),
        ["技能ID"] = _____666E_901AD_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6D_4E0A_4E0B_6587,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["技能实例持续秒"],
        ["释放技能"] = _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AD
    })
    registerDeathListener(_____85E4_539F_59B9_7EA2D_5355_4F4D_6B7B_4EA1)
end
____exports["注册藤原妹红普通D"]()
____exports["藤原妹红普通D技能状态"] = {["已完成设计"] = true, ["已完成实现"] = true, ["伤害形态"] = "1.6秒爆炸后20次火焰批量AOE"}
return ____exports
