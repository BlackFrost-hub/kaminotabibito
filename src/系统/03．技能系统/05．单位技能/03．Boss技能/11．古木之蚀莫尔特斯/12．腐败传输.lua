--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.01．运行时上下文")
local _____589E_52A0_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家腐败值"]
local _____5237_65B0Boss_8150_8D25_62A4_76FEBuff = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新Boss腐败护盾Buff"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local AddLightning = jass.AddLightning
local DestroyLightning = jass.DestroyLightning
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_1["获取Boss技能随机敌对英雄"]
local function _____5F53_524D_751F_547D_767E_5206_6BD4_6863_4F4D(boss)
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return 100
    end
    local ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife
    local percent = 100
    while percent > 0 and ratio <= (percent - 5) * 0.01 do
        percent = percent - 5
    end
    return percent
end
local function _____83AB_5C14_7279_65AF_8150_8D25_4F20_8F93_8FDE_7EBF_9500_6BC1(variable)
    local lightning = variable
    if lightning ~= nil and lightning ~= 0 then
        DestroyLightning(lightning)
    end
end
local function _____521B_5EFA_8150_8D25_4F20_8F93_8FDE_7EBF(context, target)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]
    local lightning = AddLightning(
        cfg["连线效果"],
        false,
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        GetUnitX(target),
        GetUnitY(target)
    )
    local id = addDelayedCallback(700, _____83AB_5C14_7279_65AF_8150_8D25_4F20_8F93_8FDE_7EBF_9500_6BC1, lightning)
    local ____self_2 = context["清理"]
    ____self_2["登记延迟回调"](____self_2, "莫尔特斯-腐败传输连线", id)
end
local function _____6267_884C_4E00_6B21_8150_8D25_4F20_8F93(context)
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(context["Boss单位"])
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]
    _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, target, cfg["转移腐败值"])
    context["腐败护盾值"] = context["腐败护盾值"] + cfg["转移腐败值"] * cfg["护盾每点腐败值"]
    _____5237_65B0Boss_8150_8D25_62A4_76FEBuff(context)
    _____521B_5EFA_8150_8D25_4F20_8F93_8FDE_7EBF(context, target)
end
____exports["处理莫尔特斯腐败传输"] = function(context, _nowMs)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    local current = _____5F53_524D_751F_547D_767E_5206_6BD4_6863_4F4D(context["Boss单位"])
    while context["下次腐败传输档位"] >= current and context["下次腐败传输档位"] > 0 do
        _____6267_884C_4E00_6B21_8150_8D25_4F20_8F93(context)
        context["下次腐败传输档位"] = context["下次腐败传输档位"] - 5
    end
end
____exports["注册莫尔特斯腐败传输"] = function()
end
return ____exports
