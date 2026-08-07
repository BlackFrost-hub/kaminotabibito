--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.01．运行时上下文")
local _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部菲利斯上下文"]
local _____83B7_53D6_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取菲利斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.02．数值与表现配置")
local _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯数值与表现配置"]
local _____83F2_5229_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯音效配置"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.08．台词播放")
local _____64AD_653E_83F2_5229_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放菲利斯台词"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____02_FF0E_6570_503CBuff_8303_56F4_5149_73AF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.02．数值Buff范围光环")
local _____521B_5EFA_624B_52A8_6570_503CBuff_8303_56F4_5149_73AF = ____02_FF0E_6570_503CBuff_8303_56F4_5149_73AF["创建手动数值Buff范围光环"]
local _____540C_6B65_624B_52A8_6570_503CBuff_8303_56F4_5149_73AF = ____02_FF0E_6570_503CBuff_8303_56F4_5149_73AF["同步手动数值Buff范围光环"]
local ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_72B6_6001ID_5C5E_6027 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["调整状态ID属性"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.05．菲利斯")
local _____83F2_5229_65AFBuffID = ____require_result_2["菲利斯BuffID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_3["创建Dz绑定单位特效"]
local _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_3["销毁Dz绑定单位特效"]
local ____require_result_4 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_4["技能_设置技能冷却时间"]
local ____require_result_5 = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4 = ____require_result_5["技能_获取技能当前冷却时间"]
local _____5251_6C14_7075_65A9_6280_80FDID = stringToFourCC(_____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑气灵斩"]["技能槽位"])
local _____653B_51FB_529B_5C5E_6027ID = 1
local _____9886_8896_5149_73AF_5DF2_6CE8_518C = false
local _____9886_8896_5149_73AF_7279_6548_952E = "菲利斯-领袖光环"
local _____9886_8896_5149_73AF_8303_56F4ID = 0
local function _____751F_547D_6BD4_4F8B(unit)
    local maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 0
    end
    return GetUnitState(unit, UNIT_STATE_LIFE) / maxLife
end
local function _____53D6_9886_8896_5149_73AF_653B_51FB_529B_500D_7387(holder)
    local context = _____83B7_53D6_83F2_5229_65AF_4E0A_4E0B_6587(holder)
    if context == nil then
        return 0
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]
    return context["当前领袖光环低血"] and -cfg["低血友军攻击降低"] or cfg["高血友军攻击提高"]
end
local function _____8BA1_7B97_9886_8896_5149_73AF_653B_51FB_589E_91CF(target, _____603B_5C42_6570, _____5DF2_5E94_7528_653B_51FB_529B_589E_91CF, holder)
    if _____603B_5C42_6570 <= 0 then
        return 0
    end
    local _____5F53_524D_653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(target)
    local _____57FA_7840_653B_51FB_529B = _____5F53_524D_653B_51FB_529B - _____5DF2_5E94_7528_653B_51FB_529B_589E_91CF
    local _____653B_51FB_529B_500D_7387 = _____53D6_9886_8896_5149_73AF_653B_51FB_529B_500D_7387(holder)
    return _____57FA_7840_653B_51FB_529B > 0 and _____57FA_7840_653B_51FB_529B * _____653B_51FB_529B_500D_7387 or 0
end
local function _____540C_6B65_5251_6C14_7075_65A9_4F4E_8840_51B7_5374(context, low, wasLow)
    if low == wasLow then
        return
    end
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or GetUnitAbilityLevel(boss, _____5251_6C14_7075_65A9_6280_80FDID) <= 0 then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E
    local _____5F53_524D_51B7_5374 = _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(boss, _____5251_6C14_7075_65A9_6280_80FDID) or 0
    if low then
        local _____7F29_77ED_540E_51B7_5374 = _____5F53_524D_51B7_5374 * (1 - cfg["领袖光环"]["低血剑气灵斩冷却缩短"])
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(boss, _____5251_6C14_7075_65A9_6280_80FDID, _____7F29_77ED_540E_51B7_5374, cfg["剑气灵斩"]["低血冷却秒"])
        return
    end
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(boss, _____5251_6C14_7075_65A9_6280_80FDID, _____5F53_524D_51B7_5374, cfg["剑气灵斩"]["冷却秒"])
end
local function _____5E94_7528_9886_8896_5149_73AF_653B_51FB_529B_5DEE_503C(target, _____5DEE_503C)
    _____8C03_6574_72B6_6001ID_5C5E_6027(target, _____653B_51FB_529B_5C5E_6027ID, _____5DEE_503C)
end
local function _____53D6_9886_8896_5149_73AFBuff_663E_793A_503C(_target, ______603B_5C42_6570, holder)
    return _____53D6_9886_8896_5149_73AF_653B_51FB_529B_500D_7387(holder)
end
local function _____53D6_9886_8896_5149_73AFBuff_9644_52A0_53C2_6570(_target, ______603B_5C42_6570, _holder)
    return {sourceName = "菲利斯-领袖光环"}
end
local function _____6CE8_518C_9886_8896_5149_73AF_6E05_7406(context)
    if context["领袖光环清理已注册"] then
        return
    end
    context["领袖光环清理已注册"] = true
    local boss = context["Boss单位"]
    local ____self_6 = context["清理"]
    ____self_6["登记清理"](
        ____self_6,
        "菲利斯-领袖光环",
        function()
            _____540C_6B65_624B_52A8_6570_503CBuff_8303_56F4_5149_73AF(_____9886_8896_5149_73AF_8303_56F4ID, boss, false)
        end
    )
end
local function _____5237_65B0_5355_4E2A_9886_8896_5149_73AF(context)
    local boss = context["Boss单位"]
    _____6CE8_518C_9886_8896_5149_73AF_6E05_7406(context)
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]
    local low = _____751F_547D_6BD4_4F8B(boss) < cfg["生命切换阈值"]
    local wasLow = context["当前领袖光环低血"]
    _____540C_6B65_5251_6C14_7075_65A9_4F4E_8840_51B7_5374(context, low, wasLow)
    context["当前领袖光环低血"] = low
    if not wasLow and low then
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____83F2_5229_65AF_97F3_6548_914D_7F6E["领袖光环"]["低血切换"],
            GetUnitX(boss),
            GetUnitY(boss),
            _____83F2_5229_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
        )
        _____64AD_653E_83F2_5229_65AF_53F0_8BCD(boss, "领袖光环", 0)
    end
    registerManualBuff(
        boss,
        _____83F2_5229_65AFBuffID["领袖光环"],
        1.4,
        low and -cfg["低血友军攻击降低"] or cfg["高血友军攻击提高"],
        {sourceName = "菲利斯-领袖光环"}
    )
    _____540C_6B65_624B_52A8_6570_503CBuff_8303_56F4_5149_73AF(_____9886_8896_5149_73AF_8303_56F4ID, boss, true)
    _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548(boss, _____9886_8896_5149_73AF_7279_6548_952E)
    _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(
        boss,
        "origin",
        low and cfg["低血光环特效路径"] or cfg["高血光环特效路径"],
        _____9886_8896_5149_73AF_7279_6548_952E,
        cfg["光环特效缩放"]
    )
end
____exports["注册菲利斯领袖光环"] = function()
    if _____9886_8896_5149_73AF_5DF2_6CE8_518C then
        return
    end
    _____9886_8896_5149_73AF_5DF2_6CE8_518C = true
    _____9886_8896_5149_73AF_8303_56F4ID = _____521B_5EFA_624B_52A8_6570_503CBuff_8303_56F4_5149_73AF({
        ["状态ID"] = "菲利斯-领袖光环",
        ["半径"] = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]["范围"],
        ["目标类型"] = "友军不含自己",
        ["排除无敌"] = true,
        ["最大层数"] = 1,
        ["数值效果列表"] = {{key = "攻击力", ["计算总值"] = _____8BA1_7B97_9886_8896_5149_73AF_653B_51FB_589E_91CF, ["应用差值"] = _____5E94_7528_9886_8896_5149_73AF_653B_51FB_529B_5DEE_503C}},
        Buff = {BuffID = _____83F2_5229_65AFBuffID["领袖光环"], ["持续秒"] = 1.4, ["取显示值"] = _____53D6_9886_8896_5149_73AFBuff_663E_793A_503C, ["取附加参数"] = _____53D6_9886_8896_5149_73AFBuff_9644_52A0_53C2_6570}
    })
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({["名称"] = "菲利斯-领袖光环", ["间隔毫秒"] = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]["检查间隔毫秒"], ["取上下文列表"] = _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587, ["执行"] = _____5237_65B0_5355_4E2A_9886_8896_5149_73AF})
end
return ____exports
