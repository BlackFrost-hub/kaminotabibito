local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local _____53D6_5F53_524D_9B54_6CD5 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前魔法"]
local _____53D6_6700_5927_9B54_6CD5 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大魔法"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.02．伤害事件状态")
local _____5355_4F4D_51B7_5374_4E2D = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["单位冷却中"]
local _____8BBE_7F6E_5355_4F4D_51B7_5374 = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["设置单位冷却"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____require_result_0["开始无敌帧"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local jass = require("jass.common")
local SetUnitState = jass.SetUnitState
local GetHandleId = jass.GetHandleId
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local _____65AF_5C14_6CD5_888D_7ED3_7B97_5217_8868 = {}
local _____5DF2_542F_52A8_65AF_5C14_6CD5_888D_9A71_52A8 = false
local function _____7ED3_675F_65AF_5C14_6CD5_888D_7ED3_7B97(_____8BB0_5F55, _____7D22_5F15)
    SetUnitState(_____8BB0_5F55["目标"], UNIT_STATE_MANA, 1)
    __TS__ArraySplice(_____65AF_5C14_6CD5_888D_7ED3_7B97_5217_8868, _____7D22_5F15, 1)
end
local function ____on_65AF_5C14_6CD5_888DTick()
    do
        local i = #_____65AF_5C14_6CD5_888D_7ED3_7B97_5217_8868 - 1
        while i >= 0 do
            do
                local _____8BB0_5F55 = _____65AF_5C14_6CD5_888D_7ED3_7B97_5217_8868[i + 1]
                if _____8BB0_5F55 == nil or _____8BB0_5F55["目标"] == nil or _____8BB0_5F55["目标"] == 0 then
                    __TS__ArraySplice(_____65AF_5C14_6CD5_888D_7ED3_7B97_5217_8868, i, 1)
                    goto __continue5
                end
                if _____8BB0_5F55["剩余次数"] <= 0 then
                    _____7ED3_675F_65AF_5C14_6CD5_888D_7ED3_7B97(_____8BB0_5F55, i)
                    goto __continue5
                end
                _____6267_884C_7269_54C1_6CBB_7597(_____8BB0_5F55["目标"], _____8BB0_5F55["目标"], _____8BB0_5F55["每跳扣魔"] * 1.2, "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl")
                local _____5F53_524D_9B54_6CD5 = _____53D6_5F53_524D_9B54_6CD5(_____8BB0_5F55["目标"])
                local _____4E0B_6B21_9B54_6CD5 = _____5F53_524D_9B54_6CD5 - _____8BB0_5F55["每跳扣魔"]
                SetUnitState(_____8BB0_5F55["目标"], UNIT_STATE_MANA, _____4E0B_6B21_9B54_6CD5 > 1 and _____4E0B_6B21_9B54_6CD5 or 1)
                _____8BB0_5F55["剩余次数"] = _____8BB0_5F55["剩余次数"] - 1
                if _____8BB0_5F55["剩余次数"] <= 0 then
                    _____7ED3_675F_65AF_5C14_6CD5_888D_7ED3_7B97(_____8BB0_5F55, i)
                end
            end
            ::__continue5::
            i = i - 1
        end
    end
end
local function _____786E_4FDD_6CE8_518C()
    if _____5DF2_542F_52A8_65AF_5C14_6CD5_888D_9A71_52A8 then
        return
    end
    _____5DF2_542F_52A8_65AF_5C14_6CD5_888D_9A71_52A8 = true
    addPeriodicCallback(20, ____on_65AF_5C14_6CD5_888DTick)
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
    local _____51B7_5374_952E = "斯尔法袍:" .. tostring(GetHandleId(target))
    if _____5355_4F4D_51B7_5374_4E2D(_____51B7_5374_952E) then
        return context.currentDamage
    end
    _____8BBE_7F6E_5355_4F4D_51B7_5374(_____51B7_5374_952E, 60)
    _____5F00_59CB_65E0_654C_5E27(target, 0.5)
    _____786E_4FDD_6CE8_518C()
    local _____5F53_524D_9B54_6CD5 = _____53D6_5F53_524D_9B54_6CD5(target)
    local _____6BCF_8DF3_6263_9B54 = _____5F53_524D_9B54_6CD5 * 0.04
    _____65AF_5C14_6CD5_888D_7ED3_7B97_5217_8868[#_____65AF_5C14_6CD5_888D_7ED3_7B97_5217_8868 + 1] = {["目标"] = target, ["每跳扣魔"] = _____6BCF_8DF3_6263_9B54, ["剩余次数"] = 25}
    return 0
end
return ____exports
