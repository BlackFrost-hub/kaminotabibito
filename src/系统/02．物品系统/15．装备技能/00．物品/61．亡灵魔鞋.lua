--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_8303_56F4_5C38_4F53 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围尸体"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____53D6_6700_5927_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取最大生命"]
local _____53D6_6700_5927_9B54_6CD5 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取最大魔法"]
local _____6267_884C_6CBB_7597 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["执行治疗"]
local _____5355_4F4D_6240_5728_70B9_662F_8352_829C = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位所在点是荒芜"]
local _____64AD_653E_70B9_7279_6548 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["播放点特效"]
____exports["处理亡灵魔鞋使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["亡灵魔鞋"]) then
        return
    end
    local unit = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["亡灵魔鞋"]
    local x = _____53D6_5355_4F4DX(unit)
    local y = _____53D6_5355_4F4DY(unit)
    local corpses = _____83B7_53D6_8303_56F4_5C38_4F53(x, y, cfg["半径"])
    for ____, target in ipairs(corpses) do
        _____64AD_653E_70B9_7279_6548(
            "Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl",
            _____53D6_5355_4F4DX(target),
            _____53D6_5355_4F4DY(target)
        )
    end
    local deadCount = #corpses
    local heal = _____53D6_6700_5927_751F_547D(unit) * cfg["每尸体生命比例"] * deadCount
    local mana = _____5355_4F4D_6240_5728_70B9_662F_8352_829C(unit) and _____53D6_6700_5927_9B54_6CD5(unit) * cfg["荒芜魔法比例"] or 0
    if heal > 0 or mana > 0 then
        _____6267_884C_6CBB_7597(unit, unit, heal, mana)
    end
end
return ____exports
