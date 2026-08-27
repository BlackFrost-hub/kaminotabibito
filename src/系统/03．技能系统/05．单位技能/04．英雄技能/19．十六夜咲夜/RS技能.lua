--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____83B7_53D6_54B2_591C_73B0_5B58_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["获取咲夜现存飞刀"]
local _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜单位音效"]
local _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["施加短硬直并播放动作"]
local _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["注册咲夜周期任务"]
local _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["移除咲夜周期任务"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local _____7B26_5361_516C_5171 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.符卡公共")
local _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374 = _____7B26_5361_516C_5171["设置十六夜咲夜符卡书冷却"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____require_result_2["执行战斗自身传送到坐标"]
local function _____83B7_53D6RS_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function _____89E3_9664RS_76EE_6807_6682_505C(variable)
    local data = variable
    if data == nil then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(data["目标"], data["来源"])
    if _____5355_4F4D_5B58_6D3B(data["目标"]) then
        jass:SetUnitVertexColor(
            data["目标"],
            255,
            255,
            255,
            255
        )
    end
end
local function _____7ED3_675FRS_56DE_6536(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["周期ID"] ~= 0 then
        _____79FB_9664_54B2_591C_5468_671F_4EFB_52A1(context["周期ID"])
    end
    context["周期ID"] = 0
end
local function _____63A8_8FDBRS_56DE_6536(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    context.Tick = context.Tick + 1
    local remaining = 0
    do
        local i = 0
        while i < #context["飞刀"] do
            do
                local knife = context["飞刀"][i + 1]
                if not _____5355_4F4D_5B58_6D3B(knife["单位"]) then
                    goto __continue12
                end
                local dx = jass:GetUnitX(knife["单位"]) - jass:GetUnitX(context["施法者"])
                local dy = jass:GetUnitY(knife["单位"]) - jass:GetUnitY(context["施法者"])
                if dx * dx + dy * dy <= _____914D_7F6E.RS["回收距离"] * _____914D_7F6E.RS["回收距离"] then
                    knife["结束"]()
                    goto __continue12
                end
                knife["设置角度"](_____4E24_70B9_89D2_5EA6(
                    jass:GetUnitX(knife["单位"]),
                    jass:GetUnitY(knife["单位"]),
                    jass:GetUnitX(context["施法者"]),
                    jass:GetUnitY(context["施法者"])
                ))
                remaining = remaining + 1
            end
            ::__continue12::
            i = i + 1
        end
    end
    if remaining <= 0 or context.Tick >= _____914D_7F6E.RS["最大检查Tick"] then
        _____7ED3_675FRS_56DE_6536(context)
    end
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRS(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    _____8BBE_7F6E_5341_516D_591C_54B2_591C_7B26_5361_4E66_51B7_5374(caster, _____914D_7F6E["符卡间隔秒"].RS)
    local target = jass:GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local targetSource = "十六夜咲夜-RS目标:" .. tostring(_____6280_80FD_5B9E_4F8BID or jass:GetHandleId(caster))
    _____6DFB_52A0_5355_4F4D_6682_505C(target, targetSource)
    jass:SetUnitVertexColor(
        target,
        255,
        255,
        255,
        120
    )
    addDelayedCallback(_____914D_7F6E.RS["目标暂停秒"] * 1000, _____89E3_9664RS_76EE_6807_6682_505C, {["目标"] = target, ["来源"] = targetSource})
    local targetFacing = jass:GetUnitFacing(target)
    local landingX = _____6781_5750_6807X(
        jass:GetUnitX(target),
        _____914D_7F6E.RS["瞬移偏移"],
        targetFacing + 180
    )
    local landingY = _____6781_5750_6807Y(
        jass:GetUnitY(target),
        _____914D_7F6E.RS["瞬移偏移"],
        targetFacing + 180
    )
    _____65BD_52A0_77ED_786C_76F4_5E76_64AD_653E_52A8_4F5C(
        caster,
        "十六夜咲夜-RS:" .. tostring(_____6280_80FD_5B9E_4F8BID or jass:GetHandleId(caster)),
        _____914D_7F6E.RS["硬直秒"],
        "spell,slam"
    )
    if not _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(caster, landingX, landingY) then
        return
    end
    jass:SetUnitFacing(
        caster,
        _____4E24_70B9_89D2_5EA6(
            landingX,
            landingY,
            jass:GetUnitX(target),
            jass:GetUnitY(target)
        )
    )
    _____64AD_653E_54B2_591C_5355_4F4D_97F3_6548("gg_snd_IzayoiSakuya_RS", caster)
    local knives = _____83B7_53D6_54B2_591C_73B0_5B58_98DE_5200(caster, landingX, landingY, _____914D_7F6E.RS["飞刀搜索半径"])
    do
        local i = 0
        while i < #knives do
            local knife = knives[i + 1]
            knife["设置角度"](_____4E24_70B9_89D2_5EA6(
                jass:GetUnitX(knife["单位"]),
                jass:GetUnitY(knife["单位"]),
                landingX,
                landingY
            ))
            knife["设置每Tick位移"](knife["取每Tick位移"]() * _____914D_7F6E.RS["回收速度倍率"])
            knife["设置已飞行距离"](0)
            knife["设置最大距离"](_____914D_7F6E.RS["回收最大距离"])
            i = i + 1
        end
    end
    local context = {
        ["施法者"] = caster,
        ["飞刀"] = knives,
        Tick = 0,
        ["周期ID"] = 0,
        ["已结束"] = false
    }
    context["周期ID"] = _____6CE8_518C_54B2_591C_5468_671F_4EFB_52A1(_____914D_7F6E.RS["检查周期毫秒"], _____63A8_8FDBRS_56DE_6536, context)
end
____exports["注册十六夜咲夜RS"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-吾刃回归（RS）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RS["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RS_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRS,
        ["创建独立技能实例"] = false
    })
end
____exports["注册十六夜咲夜RS"]()
return ____exports
