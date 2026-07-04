--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local _____53D6_5F53_524D_9B54_6CD5 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前魔法"]
local _____53D6_6700_5927_9B54_6CD5 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大魔法"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local ____10_FF0E_5468_671F_6267_884C_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.10．周期执行模板.index")
local _____542F_52A8_8BA1_6570_5468_671F_6267_884C = ____10_FF0E_5468_671F_6267_884C_6A21_677F["启动计数周期执行"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____require_result_0["开始无敌帧"]
local jass = require("jass.common")
local SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local function _____7ED3_675F_65AF_5C14_6CD5_888D_7ED3_7B97(_____8BB0_5F55)
    if _____8BB0_5F55["目标"] == nil or _____8BB0_5F55["目标"] == 0 then
        return
    end
    SetUnitState(_____8BB0_5F55["目标"], UNIT_STATE_MANA, 1)
end
local function ____on_65AF_5C14_6CD5_888DTick(_____8BB0_5F55)
    if _____8BB0_5F55 == nil or _____8BB0_5F55["目标"] == nil or _____8BB0_5F55["目标"] == 0 then
        return false
    end
    _____6267_884C_7269_54C1_6CBB_7597(_____8BB0_5F55["目标"], _____8BB0_5F55["目标"], _____8BB0_5F55["每跳扣魔"] * 1.2, "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
    local _____5F53_524D_9B54_6CD5 = _____53D6_5F53_524D_9B54_6CD5(_____8BB0_5F55["目标"])
    local _____4E0B_6B21_9B54_6CD5 = _____5F53_524D_9B54_6CD5 - _____8BB0_5F55["每跳扣魔"]
    SetUnitState(_____8BB0_5F55["目标"], UNIT_STATE_MANA, _____4E0B_6B21_9B54_6CD5 > 1 and _____4E0B_6B21_9B54_6CD5 or 1)
end
____exports["处理斯尔法袍伤害修正"] = function(context)
    local target = context.target
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["斯尔法袍"]) then
        return context.currentDamage
    end
    if context.currentDamage < _____53D6_5F53_524D_751F_547D(target) then
        return context.currentDamage
    end
    if _____53D6_5F53_524D_9B54_6CD5(target) <= _____53D6_6700_5927_9B54_6CD5(target) * 0.2 then
        return context.currentDamage
    end
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(target, "斯尔法袍", "伤害事件装备")
    if _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E) then
        return context.currentDamage
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(_____51B7_5374_952E, 60, target, "斯尔法袍")
    _____5F00_59CB_65E0_654C_5E27(target, 0.5)
    local _____5F53_524D_9B54_6CD5 = _____53D6_5F53_524D_9B54_6CD5(target)
    local _____6BCF_8DF3_6263_9B54 = _____5F53_524D_9B54_6CD5 * 0.04
    local _____8BB0_5F55 = {["目标"] = target, ["每跳扣魔"] = _____6BCF_8DF3_6263_9B54}
    _____542F_52A8_8BA1_6570_5468_671F_6267_884C({
        ["间隔毫秒"] = 20,
        ["最大次数"] = 25,
        ["on周期"] = function()
            return ____on_65AF_5C14_6CD5_888DTick(_____8BB0_5F55)
        end,
        ["on完成"] = function()
            _____7ED3_675F_65AF_5C14_6CD5_888D_7ED3_7B97(_____8BB0_5F55)
        end
    })
    return 0
end
return ____exports
