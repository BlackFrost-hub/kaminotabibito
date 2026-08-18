local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.01．飞刀与时间工具")
local _____4E24_70B9_89D2_5EA6 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["极坐标Y"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["单位存活"]
local _____83B7_53D6_54B2_591C_73B0_5B58_98DE_5200 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["获取咲夜现存飞刀"]
local _____64AD_653E_54B2_591C_5750_6807_97F3_6548 = ____01_FF0E_98DE_5200_4E0E_65F6_95F4_5DE5_5177["播放咲夜坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制")
local _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807 = ____require_result_2["执行战斗自身传送到坐标"]
local ____RA_5F3A_5316_4EE4_724C_8868 = {}
local ____RA_5F3A_5316_4EE4_724C_81EA_589E = 0
____exports["十六夜咲夜处于RA强化"] = function(caster)
    if caster == nil or caster == 0 then
        return false
    end
    return ____RA_5F3A_5316_4EE4_724C_8868[jass.GetHandleId(caster)] ~= nil
end
local function _____83B7_53D6RA_76D1_542C_4E0A_4E0B_6587(_caster)
    return {["占位"] = true}
end
local function _____679A_4E3E_8303_56F4_5355_4F4D(caster, x, y, radius)
    local result = {}
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    while true do
        local unit = jass.FirstOfGroup(group)
        if unit == nil or unit == 0 then
            break
        end
        jass.GroupRemoveUnit(group, unit)
        if unit ~= caster and _____5355_4F4D_5B58_6D3B(unit) and not jass.IsUnitType(unit, jass.UNIT_TYPE_TAUREN) then
            result[#result + 1] = unit
        end
    end
    jass.DestroyGroup(group)
    return result
end
local function _____7ED3_675FRA(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    context["已结束"] = true
    local casterId = jass.GetHandleId(context["施法者"])
    if ____RA_5F3A_5316_4EE4_724C_8868[casterId] == context["强化令牌"] then
        __TS__Delete(____RA_5F3A_5316_4EE4_724C_8868, casterId)
    end
    do
        local i = 0
        while i < #context["冻结单位"] do
            _____79FB_9664_5355_4F4D_6682_505C(context["冻结单位"][i + 1]["单位"], context["来源"])
            i = i + 1
        end
    end
    _____64AD_653E_54B2_591C_5750_6807_97F3_6548(
        "gg_snd_IzayoiSakuya_RA",
        jass.GetUnitX(context["施法者"]),
        jass.GetUnitY(context["施法者"])
    )
end
local function _____91CA_653E_5341_516D_591C_54B2_591CRA(_listener, caster, _____6280_80FD_5B9E_4F8BID)
    local startX = jass.GetUnitX(caster)
    local startY = jass.GetUnitY(caster)
    local targetX = jass.GetSpellTargetX()
    local targetY = jass.GetSpellTargetY()
    local angle = _____4E24_70B9_89D2_5EA6(startX, startY, targetX, targetY)
    local dx = targetX - startX
    local dy = targetY - startY
    local targetDistance = jass.SquareRoot(dx * dx + dy * dy)
    local moveDistance = math.min(
        targetDistance,
        math.min(
            _____914D_7F6E.RA["基础位移"] + jass.GetHeroAgi(caster, true) * _____914D_7F6E.RA["敏捷位移倍率"],
            _____914D_7F6E.RA["最大位移"]
        )
    )
    _____6267_884C_6218_6597_81EA_8EAB_4F20_9001_5230_5750_6807(
        caster,
        _____6781_5750_6807X(startX, moveDistance, angle),
        _____6781_5750_6807Y(startY, moveDistance, angle)
    )
    local source = "十六夜咲夜-RA:" .. tostring(_____6280_80FD_5B9E_4F8BID or jass.GetHandleId(caster))
    local frozen = _____679A_4E3E_8303_56F4_5355_4F4D(caster, startX, startY, _____914D_7F6E.RA["单位冻结半径"])
    local records = {}
    do
        local i = 0
        while i < #frozen do
            _____6DFB_52A0_5355_4F4D_6682_505C(frozen[i + 1], source)
            records[#records + 1] = {["单位"] = frozen[i + 1]}
            i = i + 1
        end
    end
    local knives = _____83B7_53D6_54B2_591C_73B0_5B58_98DE_5200(caster, startX, startY, _____914D_7F6E.RA["飞刀冻结半径"])
    do
        local i = 0
        while i < #knives do
            local knife = knives[i + 1]
            knife["设置角度"](_____4E24_70B9_89D2_5EA6(
                jass.GetUnitX(knife["单位"]),
                jass.GetUnitY(knife["单位"]),
                targetX,
                targetY
            ))
            knife["设置已飞行距离"](math.max(
                0,
                knife["取已飞行距离"]() - _____914D_7F6E.RA["返还飞行距离"]
            ))
            i = i + 1
        end
    end
    ____RA_5F3A_5316_4EE4_724C_81EA_589E = ____RA_5F3A_5316_4EE4_724C_81EA_589E + 1
    ____RA_5F3A_5316_4EE4_724C_8868[jass.GetHandleId(caster)] = ____RA_5F3A_5316_4EE4_724C_81EA_589E
    _____64AD_653E_54B2_591C_5750_6807_97F3_6548("gg_snd_IzayoiSakuya_RA2", startX, startY)
    _____64AD_653E_54B2_591C_5750_6807_97F3_6548("gg_snd_BlinkBirth1", startX, startY)
    addDelayedCallback(_____914D_7F6E.RA["持续秒"] * 1000, _____7ED3_675FRA, {
        ["施法者"] = caster,
        ["来源"] = source,
        ["冻结单位"] = records,
        ["已结束"] = false,
        ["强化令牌"] = ____RA_5F3A_5316_4EE4_724C_81EA_589E
    })
end
____exports["注册十六夜咲夜RA"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "十六夜咲夜-女仆秘技杀人玩偶（RA）",
        ["单位类型ID"] = _____914D_7F6E["英雄单位类型ID"],
        ["技能ID"] = _____914D_7F6E["技能"].RA["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6RA_76D1_542C_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5341_516D_591C_54B2_591CRA,
        ["创建独立技能实例"] = false
    })
end
____exports["注册十六夜咲夜RA"]()
return ____exports
