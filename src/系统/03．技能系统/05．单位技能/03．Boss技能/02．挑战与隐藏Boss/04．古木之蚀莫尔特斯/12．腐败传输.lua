--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____589E_52A0_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家腐败值"]
local _____540C_6B65Boss_8150_8D25_62A4_76FE_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["同步Boss腐败护盾值"]
local _____5237_65B0Boss_8150_8D25_62A4_76FEBuff = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新Boss腐败护盾Buff"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____01_FF0E_8840_91CF_8282_70B9_89E6_53D1_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.01．血量节点触发器")
local _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668 = ____01_FF0E_8840_91CF_8282_70B9_89E6_53D1_5668["创建血量节点触发器"]
local ____01_FF0E_6301_7EED_5355_4F4D_8FDE_7EBF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.07．机制连线.01．持续单位连线")
local _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF = ____01_FF0E_6301_7EED_5355_4F4D_8FDE_7EBF["创建持续单位连线"]
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.09．单位基础与生命周期函数")
local SU_GetUnitLostHP = ____require_result_0.SU_GetUnitLostHP
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_1["获取Boss技能随机敌对英雄"]
local function _____521B_5EFA_8150_8D25_4F20_8F93_8FDE_7EBF(context, target)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]
    _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败传输连线",
        ["起点单位"] = context["Boss单位"],
        ["终点单位"] = target,
        ["闪电代码"] = cfg["连线效果"],
        ["持续秒"] = cfg["连线持续秒"],
        ["起点高度"] = cfg["连线起点高度"],
        ["终点高度"] = cfg["连线终点高度"],
        ["Tick间隔毫秒"] = cfg["连线Tick间隔毫秒"]
    })
end
local function _____8BA1_7B97_8150_8D25_4F20_8F93_62A4_76FE(target)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]
    local _____5DF2_635F_5931_751F_547D_503C = SU_GetUnitLostHP(target)
    local _____8BA1_7B97_62A4_76FE_503C = _____5DF2_635F_5931_751F_547D_503C * cfg["护盾目标已损生命比例"]
    return _____8BA1_7B97_62A4_76FE_503C < cfg["护盾最低值"] and cfg["护盾最低值"] or _____8BA1_7B97_62A4_76FE_503C
end
local function _____6267_884C_4E00_6B21_8150_8D25_4F20_8F93(context)
    local boss = context["Boss单位"]
    local bossValid = _____5355_4F4D_6709_6548(boss)
    _____540C_6B65Boss_8150_8D25_62A4_76FE_503C(context)
    if not bossValid then
        return
    end
    local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
    local targetValid = _____5355_4F4D_6709_6548(target)
    if not targetValid then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败传输"]
    _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, target, cfg["转移腐败值"])
    local shieldDelta = _____8BA1_7B97_8150_8D25_4F20_8F93_62A4_76FE(target)
    context["腐败护盾值"] = context["腐败护盾值"] + shieldDelta
    _____5237_65B0Boss_8150_8D25_62A4_76FEBuff(context)
    _____521B_5EFA_8150_8D25_4F20_8F93_8FDE_7EBF(context, target)
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["腐败传输"]["护盾增长"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = GetUnitX(context["Boss单位"]),
        Y = GetUnitY(context["Boss单位"]),
        ["裁断距离"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["关键机制触发概率百分比"]
    })
end
--- 测试入口：直接执行一次血量节点对应的腐败传输，便于验证连线、腐败值和 Boss 护盾。
____exports["测试触发莫尔特斯腐败传输"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____6267_884C_4E00_6B21_8150_8D25_4F20_8F93(context)
end
____exports["注册莫尔特斯腐败传输节点"] = function(context)
    if context["腐败传输节点已注册"] then
        return
    end
    context["腐败传输节点已注册"] = true
    local _____8282_70B9_5217_8868 = {}
    do
        local _____767E_5206_6BD4 = 95
        while _____767E_5206_6BD4 >= 5 do
            _____8282_70B9_5217_8868[#_____8282_70B9_5217_8868 + 1] = {
                ID = ("腐败传输-" .. tostring(_____767E_5206_6BD4)) .. "%",
                ["百分比"] = _____767E_5206_6BD4 * 0.01,
                ["on触发"] = function(_unit, ______5F53_524D_767E_5206_6BD4)
                    _____6267_884C_4E00_6B21_8150_8D25_4F20_8F93(context)
                end
            }
            _____767E_5206_6BD4 = _____767E_5206_6BD4 - 5
        end
    end
    _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败传输节点",
        ["单位"] = context["Boss单位"],
        ["节点列表"] = _____8282_70B9_5217_8868,
        ["Tick间隔毫秒"] = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"]
    })
end
return ____exports
