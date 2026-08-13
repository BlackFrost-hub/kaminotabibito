local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.00．配置")
local _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派学者单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派学者上下文"]
local _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派学者单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置")
local _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者技能配置"]
local _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者音效配置"]
local ____09_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.09．台词播放")
local _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD = ____09_FF0E_53F0_8BCD_64AD_653E["播放教派学者台词"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8DDD_79BB_5E73_65B9XY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离平方XY"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_1["施加快速控制Buff"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_5.EC_CreateEffect
local ____require_result_6 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_6.Sound3DII_CooPlayReuse
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimation = jass.SetUnitAnimation
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6DF1_6E0A_4E4B_7262_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["深渊之牢"])
local _____6DF1_6E0A_4E4B_7262_5DF2_6CE8_518C = false
local function _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(unit, attr, delta)
    if unit == nil or unit == 0 or delta == 0 then
        return
    end
    local current = __TS__Number(YDUserDataGetSafe("unit", unit, attr, "real")) or 0
    YDUserDataSetSafe(
        "unit",
        unit,
        attr,
        "real",
        current + delta
    )
end
local function ____on_6559_6D3E_5B66_8005_8BFB_6761_5173_95ED(variable)
    local _____8BF7_6C42 = variable
    if _____8BF7_6C42 == nil then
        return
    end
    _____5173_95ED_541F_5531_6761(_____8BF7_6C42["通道"])
end
local function _____5F00_59CB_6DF1_6E0A_4E4B_7262_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587["Boss单位"]
    local _____516C_5171 = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["深渊之牢"]
    _____5F00_59CB_786C_76F4(boss, _____516C_5171["通魔施法秒"])
    SetUnitAnimation(boss, _____516C_5171["动作名"])
    _____64AD_653E_6559_6D3E_5B66_8005_53F0_8BCD(boss, "深渊之牢")
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____516C_5171["通魔施法秒"],
        ["颜色ID"] = _____516C_5171["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    local _____56DE_8C03ID = addDelayedCallback(_____516C_5171["通魔施法秒"] * 1000, ____on_6559_6D3E_5B66_8005_8BFB_6761_5173_95ED, {["通道"] = _____914D_7F6E["读条通道"], ["Boss单位"] = boss})
    local ____self_8 = _____4E0A_4E0B_6587["清理"]
    ____self_8["登记延迟回调"](____self_8, "教派学者-深渊之牢读条关闭", _____56DE_8C03ID)
end
local function _____6062_590D_6DF1_6E0A_7262_7B3C_6697_6297(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已恢复"] then
        return
    end
    if _____72B6_6001["周期回调ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["周期回调ID"])
        _____72B6_6001["周期回调ID"] = 0
    end
    local buffID = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["深渊牢笼暗抗"]
    local _____5F53_524DBuff_8FD0_884C_65F6 = getBuffRuntime(_____72B6_6001["目标单位"], buffID)
    _____72B6_6001["已恢复"] = true
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(_____72B6_6001["目标单位"], "暗属性抗性", -_____72B6_6001["增加值"])
    if _____72B6_6001["Buff运行时"] ~= nil and _____5F53_524DBuff_8FD0_884C_65F6 == _____72B6_6001["Buff运行时"] then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["目标单位"], buffID)
    end
    _____72B6_6001["Buff运行时"] = nil
end
local function ____on_6DF1_6E0A_7262_7B3C_6697_6297Buff_68C0_67E5(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已恢复"] then
        return
    end
    local _____5F53_524DBuff_8FD0_884C_65F6 = getBuffRuntime(_____72B6_6001["目标单位"], _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["深渊牢笼暗抗"])
    if _____72B6_6001["Buff运行时"] == nil or _____5F53_524DBuff_8FD0_884C_65F6 ~= _____72B6_6001["Buff运行时"] then
        _____6062_590D_6DF1_6E0A_7262_7B3C_6697_6297(_____72B6_6001)
    end
end
local function _____65BD_52A0_6DF1_6E0A_7262_7B3C_6697_6297(_____72B6_6001)
    local target = _____72B6_6001["目标单位"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["深渊之牢"]
    _____4FEE_6539_5355_4F4D_5B9E_6570_5C5E_6027(target, "暗属性抗性", _____914D_7F6E["暗属性抗性提高"])
    registerManualBuff(
        target,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["深渊牢笼暗抗"],
        _____914D_7F6E["暗抗持续秒"],
        _____914D_7F6E["暗属性抗性提高"],
        {sourceUnit = _____72B6_6001["上下文"]["Boss单位"], effectSourceName = "深渊之牢反噬奖励", effectSourceType = "技能"}
    )
    local _____6697_6297_72B6_6001 = {
        ["已恢复"] = false,
        ["目标单位"] = target,
        ["增加值"] = _____914D_7F6E["暗属性抗性提高"],
        ["Buff运行时"] = getBuffRuntime(target, _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["深渊牢笼暗抗"]),
        ["周期回调ID"] = 0
    }
    local ____self_9 = _____72B6_6001["上下文"]["清理"]
    ____self_9["登记清理"](____self_9, "教派学者-深渊牢笼暗抗恢复", _____6062_590D_6DF1_6E0A_7262_7B3C_6697_6297, _____6697_6297_72B6_6001)
    _____6697_6297_72B6_6001["周期回调ID"] = addPeriodicCallback(_____914D_7F6E["暗抗Buff检查间隔秒"] * 1000, ____on_6DF1_6E0A_7262_7B3C_6697_6297Buff_68C0_67E5, _____6697_6297_72B6_6001)
    local ____self_10 = _____72B6_6001["上下文"]["清理"]
    ____self_10["登记周期回调"](____self_10, "教派学者-深渊牢笼暗抗Buff检查", _____6697_6297_72B6_6001["周期回调ID"])
    local _____56DE_8C03ID = addDelayedCallback(_____914D_7F6E["暗抗持续秒"] * 1000, _____6062_590D_6DF1_6E0A_7262_7B3C_6697_6297, _____6697_6297_72B6_6001)
    local ____self_11 = _____72B6_6001["上下文"]["清理"]
    ____self_11["登记延迟回调"](____self_11, "教派学者-深渊牢笼暗抗到期", _____56DE_8C03ID)
end
local function _____7ED3_675F_6DF1_6E0A_4E4B_7262(_____72B6_6001, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    if _____72B6_6001["周期回调ID"] ~= 0 then
        removePeriodicCallback(_____72B6_6001["周期回调ID"])
        _____72B6_6001["周期回调ID"] = 0
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["目标单位"], _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["深渊牢笼"])
    if _____72B6_6001["上下文"]["深渊之牢状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["深渊之牢状态"] = nil
    end
end
local function ____on_6DF1_6E0A_4E4B_7262_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____7ED3_675F_6DF1_6E0A_4E4B_7262(_____72B6_6001, "上下文清理")
    end
end
local function _____7ED3_7B97_6DF1_6E0A_4E4B_7262_79BB_5F00(_____72B6_6001)
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local target = _____72B6_6001["目标单位"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["深渊之牢"]
    local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["技能ID"] = _____6DF1_6E0A_4E4B_7262_6280_80FDID,
        ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["Boss攻击力比例"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = _____914D_7F6E["伤害标签"]
    })
    if _____7ED3_679C["是否造成伤害"] then
        _____65BD_52A0_5FEB_901F_63A7_5236Buff(
            boss,
            target,
            0,
            _____914D_7F6E["离开眩晕秒"],
            "教派学者-深渊之牢",
            "技能"
        )
        EC_CreateEffect(
            _____914D_7F6E["离开命中特效路径"],
            GetUnitX(target),
            GetUnitY(target),
            0,
            0,
            _____914D_7F6E["离开命中特效缩放"],
            1,
            1
        )
        Sound3DII_CooPlayReuse(
            _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["深渊之牢"]["离开命中"],
            GetUnitX(target),
            GetUnitY(target),
            0,
            _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
        )
    end
    _____7ED3_675F_6DF1_6E0A_4E4B_7262(_____72B6_6001, "目标离开牢笼")
end
local function _____7ED3_7B97_6DF1_6E0A_4E4B_7262_53CD_566C(_____72B6_6001)
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local target = _____72B6_6001["目标单位"]
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["深渊之牢"]
    local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = target,
        ["目标"] = boss,
        ["技能ID"] = _____6DF1_6E0A_4E4B_7262_6280_80FDID,
        ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["反噬目标攻击力比例"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = _____914D_7F6E["反噬伤害标签"],
        ["来源类型"] = "其他"
    })
    EC_CreateEffect(
        _____914D_7F6E["反噬特效路径1"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        0,
        1,
        1,
        1
    )
    EC_CreateEffect(
        _____914D_7F6E["反噬特效路径2"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        0,
        1,
        1,
        1
    )
    EC_CreateEffect(
        _____914D_7F6E["反噬特效路径3"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        0,
        1,
        1,
        1
    )
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["深渊之牢"]["无伤反噬"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
    _____65BD_52A0_6DF1_6E0A_7262_7B3C_6697_6297(_____72B6_6001)
    _____7ED3_675F_6DF1_6E0A_4E4B_7262(_____72B6_6001, "无伤完成")
end
local function ____on_6DF1_6E0A_4E4B_7262_5468_671F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local target = _____72B6_6001["目标单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(target) then
        _____7ED3_675F_6DF1_6E0A_4E4B_7262(_____72B6_6001, "Boss或目标失效")
        return
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["深渊之牢"]
    _____72B6_6001["已运行秒"] = _____72B6_6001["已运行秒"] + _____914D_7F6E["检查间隔秒"]
    if _____8DDD_79BB_5E73_65B9XY(
        GetUnitX(target),
        GetUnitY(target),
        _____72B6_6001["中心X"],
        _____72B6_6001["中心Y"]
    ) > _____914D_7F6E["判定半径"] * _____914D_7F6E["判定半径"] then
        _____7ED3_7B97_6DF1_6E0A_4E4B_7262_79BB_5F00(_____72B6_6001)
        return
    end
    if _____72B6_6001["已运行秒"] + 0.001 >= _____914D_7F6E["持续秒"] then
        _____7ED3_7B97_6DF1_6E0A_4E4B_7262_53CD_566C(_____72B6_6001)
    end
end
local function _____542F_52A8_6DF1_6E0A_4E4B_7262_673A_5236(_____4E0A_4E0B_6587, target)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(boss) or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(target) or _____4E0A_4E0B_6587["深渊之牢状态"] ~= nil then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["深渊之牢"]
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["目标单位"] = target,
        ["中心X"] = GetUnitX(target),
        ["中心Y"] = GetUnitY(target),
        ["已运行秒"] = 0,
        ["周期回调ID"] = 0
    }
    _____4E0A_4E0B_6587["深渊之牢状态"] = _____72B6_6001
    local ____self_14 = _____4E0A_4E0B_6587["清理"]
    ____self_14["登记清理"](____self_14, "教派学者-深渊之牢清理", ____on_6DF1_6E0A_4E4B_7262_6E05_7406, _____72B6_6001)
    registerManualBuff(
        target,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E.Buff["深渊牢笼"],
        _____914D_7F6E["持续秒"],
        _____914D_7F6E["判定半径"],
        {sourceUnit = boss, effectSourceName = "深渊之牢", effectSourceType = "技能"}
    )
    EC_CreateEffect(
        _____914D_7F6E["牢笼模型路径"],
        _____72B6_6001["中心X"],
        _____72B6_6001["中心Y"],
        0,
        0,
        _____914D_7F6E["牢笼缩放"],
        1,
        _____914D_7F6E["持续秒"]
    )
    Sound3DII_CooPlayReuse(
        _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["深渊之牢"]["牢笼锁定"],
        _____72B6_6001["中心X"],
        _____72B6_6001["中心Y"],
        0,
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
    _____72B6_6001["周期回调ID"] = addPeriodicCallback(_____914D_7F6E["检查间隔秒"] * 1000, ____on_6DF1_6E0A_4E4B_7262_5468_671F, _____72B6_6001)
    local ____self_15 = _____4E0A_4E0B_6587["清理"]
    ____self_15["登记周期回调"](____self_15, "教派学者-深渊之牢周期", _____72B6_6001["周期回调ID"])
    return true
end
local function ____on_6DF1_6E0A_4E4B_7262_5EF6_8FDF_542F_52A8(variable)
    local _____8BF7_6C42 = variable
    if _____8BF7_6C42 ~= nil then
        _____542F_52A8_6DF1_6E0A_4E4B_7262_673A_5236(_____8BF7_6C42["上下文"], _____8BF7_6C42["目标单位"])
    end
end
____exports["释放教派学者深渊之牢"] = function(_____4E0A_4E0B_6587, target)
    if not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(_____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]) or not _____6559_6D3E_5B66_8005_5355_4F4D_5B58_6D3B(target) or _____4E0A_4E0B_6587["深渊之牢状态"] ~= nil then
        return false
    end
    _____5F00_59CB_6DF1_6E0A_4E4B_7262_65BD_6CD5_8868_73B0(_____4E0A_4E0B_6587)
    local _____56DE_8C03ID = addDelayedCallback(_____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["通魔施法秒"] * 1000, ____on_6DF1_6E0A_4E4B_7262_5EF6_8FDF_542F_52A8, {["上下文"] = _____4E0A_4E0B_6587, ["目标单位"] = target})
    local ____self_18 = _____4E0A_4E0B_6587["清理"]
    ____self_18["登记延迟回调"](____self_18, "教派学者-深渊之牢测试释放", _____56DE_8C03ID)
    return true
end
____exports["注册教派学者深渊之牢"] = function()
    if _____6DF1_6E0A_4E4B_7262_5DF2_6CE8_518C then
        return
    end
    _____6DF1_6E0A_4E4B_7262_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "教派学者-深渊之牢",
        ["单位类型ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["单位ID"],
        ["技能ID"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["技能壳"]["深渊之牢"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587,
        ["释放技能"] = function(_____4E0A_4E0B_6587)
            ____exports["释放教派学者深渊之牢"](
                _____4E0A_4E0B_6587,
                GetSpellTargetUnit()
            )
        end
    })
end
return ____exports
