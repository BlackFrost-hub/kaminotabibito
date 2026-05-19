--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_8303_56F4_53CB_519B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围友军"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____6E05_9664_8D1F_9762Buff = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["清除负面Buff"]
local _____6267_884C_6CBB_7597 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["执行治疗"]
____exports["处理守卫大剑使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["守卫大剑"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["守卫大剑"]
    local unit = ctx["施法单位"]
    local allies = _____83B7_53D6_8303_56F4_53CB_519B(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        cfg["半径"]
    )
    local removed = 0
    for ____, ally in ipairs(allies) do
        removed = removed + _____6E05_9664_8D1F_9762Buff(ally)
    end
    if removed <= 0 then
        _____6267_884C_6CBB_7597(unit, unit, cfg["兜底治疗"])
    end
end
return ____exports
