--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____9020_6210_7CBE_795E_81EA_4F24 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成精神自伤"]
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.index")
local _____662F_5426_666E_901A_654C_4EBA = ____require_result_0["是否普通敌人"]
____exports["处理嗜狱恶剑使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["嗜狱恶剑"]) then
        return
    end
    _____9020_6210_7CBE_795E_81EA_4F24(ctx["施法单位"], _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["嗜狱恶剑"]["自伤"])
end
____exports["处理嗜狱恶剑伤害修正"] = function(context)
    local target = context.target
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["嗜狱恶剑"]) then
        return context.currentDamage
    end
    local attacker = context.attacker
    if attacker == nil or attacker == 0 then
        return context.currentDamage
    end
    if not _____662F_5426_666E_901A_654C_4EBA(attacker) then
        return context.currentDamage
    end
    return context.currentDamage * 0.9
end
____exports["处理嗜狱恶剑造成伤害"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.attacker, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["嗜狱恶剑"]) then
        return
    end
    local target = ctx.target
    if target == nil or target == 0 then
        return
    end
    if not _____662F_5426_666E_901A_654C_4EBA(target) then
        return
    end
    local _____989D_5916_4F24_5BB3 = ctx.applied * 0.2
    _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(ctx.attacker, target, _____989D_5916_4F24_5BB3, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["普通"])
end
return ____exports
