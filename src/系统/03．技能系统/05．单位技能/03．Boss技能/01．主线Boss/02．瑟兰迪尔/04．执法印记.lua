--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_1.getBuffRuntime
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807 = ____require_result_2["获取Boss技能应攻击目标"]
local _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4 = ____require_result_2["获取Boss技能最近敌对英雄"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local setThreat = ____require_result_3.setThreat
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
local _____8BBE_7F6E_5F3A_5236_653B_51FB_76EE_6807 = ____require_result_4["设置强制攻击目标"]
local _____8BBE_7F6E_5F53_524D_76EE_6807 = ____require_result_4["设置当前目标"]
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_5["取当前有效玩家人数"]
local jass = require("jass.common")
local GetUnitName = jass.GetUnitName
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local IssueTargetOrder = jass.IssueTargetOrder
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态")
local _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5 = ____require_result_6["单位是否正在原生施法"]
local _____745F_5170_8FEA_5C14_5355_4F4DID = stringToFourCC("N057")
local _____4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function _____83B7_53D6_672C_6B21_5370_8BB0_589E_4F24()
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    return _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 1 and config["单人额外伤害加成"] or config["Boss对标记目标伤害加成"]
end
local function _____662F_6267_6CD5_5370_8BB0_4F24_5BB3(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    if not _____5355_4F4D_6709_6548(context.attacker) or not _____5355_4F4D_6709_6548(context.target) then
        return false
    end
    if GetUnitTypeId(context.attacker) ~= _____745F_5170_8FEA_5C14_5355_4F4DID then
        return false
    end
    local buffRuntime = getBuffRuntime(context.target, config.BuffID)
    return buffRuntime ~= nil and buffRuntime.effect > 0
end
local function ____on_6267_6CD5_5370_8BB0_4F24_5BB3_4FEE_6B63(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    local buffRuntime = getBuffRuntime(context.target, config.BuffID)
    if buffRuntime == nil or buffRuntime.effect <= 0 then
        return context.currentDamage
    end
    return context.currentDamage * (1 + buffRuntime.effect)
end
local function _____786E_4FDD_6267_6CD5_5370_8BB0_4F24_5BB3_4FEE_6B63()
    if _____4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "瑟兰迪尔执法印记增伤", ["优先级"] = 35, ["条件"] = _____662F_6267_6CD5_5370_8BB0_4F24_5BB3, ["修正"] = ____on_6267_6CD5_5370_8BB0_4F24_5BB3_4FEE_6B63})
end
____exports["选择瑟兰迪尔执法印记目标"] = function(context)
    local threatTarget = _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807(context["Boss单位"])
    local ____temp_9 = threatTarget and threatTarget.targetRef
    if ____temp_9 == nil then
        ____temp_9 = _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4(context["Boss单位"])
    end
    return ____temp_9
end
____exports["释放瑟兰迪尔执法印记"] = function(context, target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    local bonus = _____83B7_53D6_672C_6B21_5370_8BB0_589E_4F24()
    local durationMs = config["持续秒"] * 1000
    setThreat(context["Boss单位"], target, 1000)
    _____8BBE_7F6E_5F3A_5236_653B_51FB_76EE_6807(context["Boss单位"], target, durationMs)
    if _____5355_4F4D_662F_5426_6B63_5728_539F_751F_65BD_6CD5(context["Boss单位"]) then
        return true
    end
    IssueTargetOrder(context["Boss单位"], "attack", target)
    _____8BBE_7F6E_5F53_524D_76EE_6807(
        GetHandleId(context["Boss单位"]),
        GetHandleId(target)
    )
    registerManualBuff(
        target,
        config.BuffID,
        config["持续秒"],
        bonus,
        {
            sourceName = GetUnitName(context["Boss单位"]),
            iconOverride = "BuffIcon\\Boss\\Thranduil\\zhifayinji.blp",
            effectModelOverride = config["特效"]
        }
    )
    return true
end
____exports["注册瑟兰迪尔执法印记"] = function()
    _____786E_4FDD_6267_6CD5_5370_8BB0_4F24_5BB3_4FEE_6B63()
end
return ____exports
