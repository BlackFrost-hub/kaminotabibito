--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____64AD_653E_70B9_7279_6548 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["播放点特效"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____9020_6210_5F3A_5316_4F24_5BB3 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成强化伤害"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____5F85_81EA_4F24_5355_4F4D = {}
local function _____6267_884C_72C2_66B4_6811_679D_81EA_4F24()
    local unit = table.remove(_____5F85_81EA_4F24_5355_4F4D, 1)
    if unit == nil or unit == 0 then
        return
    end
    _____9020_6210_5F3A_5316_4F24_5BB3(unit, unit, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["狂暴树枝"]["自伤"])
end
____exports["处理狂暴树枝使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["狂暴树枝"]) then
        return
    end
    local unit = ctx["施法单位"]
    _____64AD_653E_70B9_7279_6548(
        "Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl",
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit)
    )
    _____5F85_81EA_4F24_5355_4F4D[#_____5F85_81EA_4F24_5355_4F4D + 1] = unit
    addDelayedCallback(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["狂暴树枝"]["延迟毫秒"], _____6267_884C_72C2_66B4_6811_679D_81EA_4F24)
end
return ____exports
