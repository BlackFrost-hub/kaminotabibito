--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____83B7_53D6_672C_6B21_5370_8BB0_589E_4F24, registerManualBuff, setThreat, _____8BBE_7F6E_5F3A_5236_653B_51FB_76EE_6807, _____8BBE_7F6E_5F53_524D_76EE_6807, _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570, GetUnitName, GetHandleId, IssueTargetOrder
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
function _____83B7_53D6_672C_6B21_5370_8BB0_589E_4F24()
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    return _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 1 and config["单人额外伤害加成"] or config["Boss对标记目标伤害加成"]
end
____exports["释放瑟兰迪尔执法印记"] = function(context, target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local bonus = _____83B7_53D6_672C_6B21_5370_8BB0_589E_4F24()
    local durationMs = config["持续秒"] * 1000
    setThreat(context["Boss单位"], target, 1000)
    _____8BBE_7F6E_5F3A_5236_653B_51FB_76EE_6807(context["Boss单位"], target, durationMs)
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
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_2.getBuffRuntime
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807 = ____require_result_3["获取Boss技能应攻击目标"]
local _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4 = ____require_result_3["获取Boss技能最近敌对英雄"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
setThreat = ____require_result_4.setThreat
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.02．目标选择")
_____8BBE_7F6E_5F3A_5236_653B_51FB_76EE_6807 = ____require_result_5["设置强制攻击目标"]
_____8BBE_7F6E_5F53_524D_76EE_6807 = ____require_result_5["设置当前目标"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_6.registerDamageModifier
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
_____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_7["取当前有效玩家人数"]
local jass = require("jass.common")
GetUnitName = jass.GetUnitName
local GetUnitTypeId = jass.GetUnitTypeId
GetHandleId = jass.GetHandleId
IssueTargetOrder = jass.IssueTargetOrder
local _____745F_5170_8FEA_5C14_5355_4F4DID = stringToFourCC("N057")
local _____4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function ____on_6267_6CD5_5370_8BB0_4F24_5BB3_4FEE_6B63(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    if not _____5355_4F4D_6709_6548(context.attacker) or not _____5355_4F4D_6709_6548(context.target) then
        return context.currentDamage
    end
    if GetUnitTypeId(context.attacker) ~= _____745F_5170_8FEA_5C14_5355_4F4DID then
        return context.currentDamage
    end
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
    registerDamageModifier(____on_6267_6CD5_5370_8BB0_4F24_5BB3_4FEE_6B63, 35)
end
____exports["尝试触发瑟兰迪尔执法印记"] = function(context)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["执法印记"]
    local now = getServerTime()
    if context["上次执法印记Ms"] > 0 and now - context["上次执法印记Ms"] < config["周期秒"] * 1000 then
        return
    end
    context["上次执法印记Ms"] = now
    local threatTarget = _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807(context["Boss单位"])
    local ____temp_10 = threatTarget and threatTarget.targetRef
    if ____temp_10 == nil then
        ____temp_10 = _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4(context["Boss单位"])
    end
    local target = ____temp_10
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    ____exports["释放瑟兰迪尔执法印记"](context, target)
end
____exports["注册瑟兰迪尔执法印记"] = function()
    _____786E_4FDD_6267_6CD5_5370_8BB0_4F24_5BB3_4FEE_6B63()
end
return ____exports
