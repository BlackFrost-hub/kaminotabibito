--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_8303_56F4_654C_4EBA = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围敌人"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____53D6_5F53_524D_9B54_6CD5 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取当前魔法"]
local _____53D6_6700_5927_9B54_6CD5 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取最大魔法"]
local _____8BBE_7F6E_9B54_6CD5 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["设置魔法"]
local _____65BD_52A0_51CF_901F = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["施加减速"]
local _____9020_6210_706B_7130_4F24_5BB3 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成火焰伤害"]
local _____65BD_52A0_7729_6655 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["施加眩晕"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____5EF6_8FDF_6267_884C = ____20_FF0E_7269_54C1_8F85_52A9["延迟执行"]
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHeroInt = jass.GetHeroInt
local function _____7ED3_7B97_7194_5CA9_5730_72F1_4E4B_6572_949F(_____6765_6E90, _____76EE_6807_5217_8868)
    local damage = GetHeroInt(_____6765_6E90, true) * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["地狱敲钟"]["智力伤害倍率"]
    for ____, target in ipairs(_____76EE_6807_5217_8868) do
        _____9020_6210_706B_7130_4F24_5BB3(_____6765_6E90, target, damage)
        _____65BD_52A0_7729_6655(_____6765_6E90, target, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["地狱敲钟"]["熔岩眩晕"])
    end
end
____exports["处理熔岩地狱之敲钟使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["熔岩地狱之敲钟"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["地狱敲钟"]
    local unit = ctx["施法单位"]
    _____8BBE_7F6E_9B54_6CD5(
        unit,
        _____53D6_5F53_524D_9B54_6CD5(unit) - (_____53D6_6700_5927_9B54_6CD5(unit) * cfg["消耗最大魔法比例"] + cfg["消耗固定魔法"])
    )
    local targets = _____83B7_53D6_8303_56F4_654C_4EBA(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        cfg["半径"]
    )
    for ____, target in ipairs(targets) do
        _____65BD_52A0_51CF_901F(unit, target, cfg["熔岩减速"], cfg["熔岩延迟毫秒"] / 1000)
    end
    _____5EF6_8FDF_6267_884C(
        cfg["熔岩延迟毫秒"],
        function()
            _____7ED3_7B97_7194_5CA9_5730_72F1_4E4B_6572_949F(unit, targets)
        end
    )
end
return ____exports
