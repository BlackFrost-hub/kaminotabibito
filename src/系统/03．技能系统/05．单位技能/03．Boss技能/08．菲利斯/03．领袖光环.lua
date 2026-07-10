--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.01．运行时上下文")
local _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部菲利斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.02．数值与表现配置")
local _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯数值与表现配置"]
local _____83F2_5229_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯音效配置"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.08．台词播放")
local _____64AD_653E_83F2_5229_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放菲利斯台词"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAbilityLevel = jass.SetUnitAbilityLevel
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯")
local _____83F2_5229_65AFBuffID = ____require_result_2["菲利斯BuffID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_3["创建Dz绑定单位特效"]
local _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_3["销毁Dz绑定单位特效"]
local _____9886_8896_5149_73AF_6280_80FDID = stringToFourCC(_____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]["技能槽位"])
local _____9886_8896_5149_73AF_5DF2_6CE8_518C = false
local _____9886_8896_5149_73AF_7279_6548_952E = "菲利斯-领袖光环"
local function _____751F_547D_6BD4_4F8B(unit)
    local maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 0
    end
    return GetUnitState(unit, UNIT_STATE_LIFE) / maxLife
end
local function _____5237_65B0_5355_4E2A_9886_8896_5149_73AF(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]
    local low = _____751F_547D_6BD4_4F8B(boss) < cfg["生命切换阈值"]
    local wasLow = context["当前领袖光环低血"]
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
    SetUnitAbilityLevel(boss, _____9886_8896_5149_73AF_6280_80FDID, low and cfg["低血物编等级"] or cfg["高血物编等级"])
    registerManualBuff(
        boss,
        _____83F2_5229_65AFBuffID["领袖光环"],
        1.4,
        low and -cfg["低血友军攻击降低"] or cfg["高血友军攻击提高"],
        {sourceName = "菲利斯-领袖光环"}
    )
    _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548(boss, _____9886_8896_5149_73AF_7279_6548_952E)
    _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(
        boss,
        "origin",
        low and cfg["低血光环特效路径"] or cfg["高血光环特效路径"],
        _____9886_8896_5149_73AF_7279_6548_952E,
        cfg["光环特效缩放"]
    )
end
local function _____9886_8896_5149_73AF_4F24_5BB3_4FEE_6B63(damageContext)
    if damageContext == nil or damageContext.isNormalAttack ~= true then
        return damageContext.currentDamage
    end
    local attacker = damageContext.attacker
    if not _____5355_4F4D_6709_6548(attacker) then
        return damageContext.currentDamage
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]
    local list = _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #list do
            do
                local boss = list[i + 1]["Boss单位"]
                if not _____5355_4F4D_6709_6548(boss) or attacker == boss then
                    goto __continue11
                end
                if IsUnitAlly(
                    attacker,
                    GetOwningPlayer(boss)
                ) ~= true then
                    goto __continue11
                end
                if list[i + 1]["当前领袖光环低血"] then
                    return damageContext.currentDamage * (1 - cfg["低血友军攻击降低"])
                end
                return damageContext.currentDamage * (1 + cfg["高血友军攻击提高"])
            end
            ::__continue11::
            i = i + 1
        end
    end
    return damageContext.currentDamage
end
____exports["注册菲利斯领袖光环"] = function()
    if _____9886_8896_5149_73AF_5DF2_6CE8_518C then
        return
    end
    _____9886_8896_5149_73AF_5DF2_6CE8_518C = true
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({["名称"] = "菲利斯-领袖光环", ["间隔毫秒"] = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["领袖光环"]["检查间隔毫秒"], ["取上下文列表"] = _____83B7_53D6_5168_90E8_83F2_5229_65AF_4E0A_4E0B_6587, ["执行"] = _____5237_65B0_5355_4E2A_9886_8896_5149_73AF})
    registerDamageModifier(_____9886_8896_5149_73AF_4F24_5BB3_4FEE_6B63, 34)
end
return ____exports
