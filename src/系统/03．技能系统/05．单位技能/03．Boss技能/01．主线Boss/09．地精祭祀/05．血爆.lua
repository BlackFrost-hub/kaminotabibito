--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.00．配置")
local _____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["地精祭祀单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建地精祭祀上下文"]
local _____83B7_53D6_5730_7CBE_796D_7940_8303_56F4_76EE_6807 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取地精祭祀范围目标"]
local _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["地精祭祀单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.02．数值与表现配置")
local _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["地精祭祀技能配置"]
local _____5730_7CBE_796D_7940_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["地精祭祀音效配置"]
local ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____16_FF0E_6280_80FD_63D0_793A_5708_5DE5_5382["创建技能提示圈"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____require_result_0["播放Boss坐标音效"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_2["施加快速控制Buff"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local jass = require("jass.common")
local globals = require("jass.globals")
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimation = jass.SetUnitAnimation
local StartSound = jass.StartSound
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____8840_7206_6280_80FDID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["血爆"])
local _____5730_7CBE_796D_7940_8840_7206_5DF2_6CE8_518C = false
local function _____64AD_653E_5730_7CBE_796D_7940_70B9_7279_6548(_____7279_6548, x, y)
    EC_CreateEffect(
        _____7279_6548["路径"],
        x,
        y,
        _____7279_6548.Z,
        _____7279_6548["朝向"],
        _____7279_6548["缩放"],
        _____7279_6548["动画速度"],
        _____7279_6548["持续秒"]
    )
end
local function _____64AD_653E_5730_7CBE_796D_7940_914D_7F6E_97F3_6548(_____5168_5C40_53D8_91CF_540D)
    local _____97F3_6548 = globals[_____5168_5C40_53D8_91CF_540D]
    if _____97F3_6548 ~= nil and _____97F3_6548 ~= 0 then
        StartSound(_____97F3_6548)
    end
end
local function ____on_8840_7206_8BFB_6761_7ED3_675F()
    _____5173_95ED_541F_5531_6761(_____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["血爆"]["读条通道"])
end
local function ____on_8840_7206_7ED3_7B97(variable)
    local _____5FEB_7167 = variable
    if _____5FEB_7167 == nil or not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(_____5FEB_7167["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____5FEB_7167["上下文"]["Boss单位"]
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["血爆"]
    _____64AD_653E_5730_7CBE_796D_7940_70B9_7279_6548(_____914D_7F6E["爆炸特效"], _____5FEB_7167.X, _____5FEB_7167.Y)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____5730_7CBE_796D_7940_97F3_6548_914D_7F6E["血爆"]["爆炸命中"], _____5FEB_7167.X, _____5FEB_7167.Y, _____5730_7CBE_796D_7940_97F3_6548_914D_7F6E["默认裁断距离"])
    local _____76EE_6807_5217_8868 = _____83B7_53D6_5730_7CBE_796D_7940_8303_56F4_76EE_6807(
        boss,
        _____5FEB_7167.X,
        _____5FEB_7167.Y,
        _____914D_7F6E["作用半径"],
        _____914D_7F6E["最大飞行高度"]
    )
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            local _____76EE_6807 = _____76EE_6807_5217_8868[i + 1]
            _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                ["来源"] = boss,
                ["目标"] = _____76EE_6807,
                ["技能ID"] = _____8840_7206_6280_80FDID,
                ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["Boss攻击力比例"], ["目标最大生命比例"] = _____914D_7F6E["目标最大生命比例"]},
                attack = true,
                ranged = false,
                attackType = ATTACK_TYPE_NORMAL,
                ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["标签"] = "地精祭祀·血爆"
            })
            _____65BD_52A0_5FEB_901F_63A7_5236Buff(
                boss,
                _____76EE_6807,
                0,
                _____914D_7F6E["眩晕秒"],
                "地精祭祀-血爆",
                "技能"
            )
            i = i + 1
        end
    end
end
____exports["释放地精祭祀血爆"] = function(_____4E0A_4E0B_6587, _____76EE_6807_5355_4F4D)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(boss) or not _____5730_7CBE_796D_7940_5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        return false
    end
    local _____914D_7F6E = _____5730_7CBE_796D_7940_6280_80FD_914D_7F6E["血爆"]
    local _____5FEB_7167 = {
        ["上下文"] = _____4E0A_4E0B_6587,
        X = GetUnitX(_____76EE_6807_5355_4F4D),
        Y = GetUnitY(_____76EE_6807_5355_4F4D)
    }
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法硬直秒"])
    SetUnitAnimation(boss, _____914D_7F6E["动作名称"])
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["施法硬直秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    _____64AD_653E_5730_7CBE_796D_7940_914D_7F6E_97F3_6548(_____914D_7F6E["音效全局变量名"])
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "敌方圆形",
        X = _____5FEB_7167.X,
        Y = _____5FEB_7167.Y,
        ["半径"] = _____914D_7F6E["作用半径"],
        ["持续时间"] = _____914D_7F6E["预警秒"],
        ["来源单位"] = boss
    })
    _____64AD_653E_5730_7CBE_796D_7940_70B9_7279_6548(_____914D_7F6E["预警特效"], _____5FEB_7167.X, _____5FEB_7167.Y)
    local _____7ED3_7B97_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["预警秒"] * 1000, ____on_8840_7206_7ED3_7B97, _____5FEB_7167)
    local ____self_9 = _____4E0A_4E0B_6587["清理"]
    ____self_9["登记延迟回调"](____self_9, "地精祭祀-血爆结算", _____7ED3_7B97_56DE_8C03ID)
    local _____8BFB_6761_56DE_8C03ID = addDelayedCallback(_____914D_7F6E["施法硬直秒"] * 1000, ____on_8840_7206_8BFB_6761_7ED3_675F)
    local ____self_10 = _____4E0A_4E0B_6587["清理"]
    ____self_10["登记延迟回调"](____self_10, "地精祭祀-血爆读条结束", _____8BFB_6761_56DE_8C03ID)
    return true
end
local function ____on_5730_7CBE_796D_7940_8840_7206_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8840_7206_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587(castingUnit)
    if _____4E0A_4E0B_6587 ~= nil then
        ____exports["释放地精祭祀血爆"](
            _____4E0A_4E0B_6587,
            GetSpellTargetUnit()
        )
    end
end
____exports["注册地精祭祀血爆"] = function()
    if _____5730_7CBE_796D_7940_8840_7206_5DF2_6CE8_518C then
        return
    end
    _____5730_7CBE_796D_7940_8840_7206_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_5730_7CBE_796D_7940_8840_7206_751F_6548)
end
return ____exports
