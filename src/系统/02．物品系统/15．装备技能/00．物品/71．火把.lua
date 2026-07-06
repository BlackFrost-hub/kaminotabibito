--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____9650_5236_76EE_6807_70B9_8DDD_79BB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["限制目标点距离"]
local _____521B_5EFA_706B_628A_5355_4F4D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["创建火把单位"]
____exports["处理火把使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["火把"]) then
        return
    end
    local unit = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["火把"]
    local sx = _____53D6_5355_4F4DX(unit)
    local sy = _____53D6_5355_4F4DY(unit)
    local point = _____9650_5236_76EE_6807_70B9_8DDD_79BB(
        sx,
        sy,
        ctx["目标X"],
        ctx["目标Y"],
        cfg["最大距离"]
    )
    _____521B_5EFA_706B_628A_5355_4F4D(
        unit,
        point.x,
        point.y,
        point.angle,
        cfg["模型"],
        cfg["持续时间"]
    )
end
return ____exports
