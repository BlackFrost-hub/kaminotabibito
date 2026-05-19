--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____82F1_96C4_4E3B_5C5E_6027_662F_667A_529B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["英雄主属性是智力"]
local _____589E_52A0_82F1_96C4_7ECF_9A8C_4E0E_667A_529B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["增加英雄经验与智力"]
local _____53D6_53E5_67C4ID = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取句柄ID"]
local _____5DF2_53C2_609F_8868 = {}
____exports["处理商人之书使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["商人之书"]) then
        return
    end
    local unit = ctx["施法单位"]
    local id = _____53D6_53E5_67C4ID(unit)
    if id == 0 or _____5DF2_53C2_609F_8868[id] == true then
        return
    end
    if not _____82F1_96C4_4E3B_5C5E_6027_662F_667A_529B(unit) then
        return
    end
    _____5DF2_53C2_609F_8868[id] = true
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["商人之书"]
    _____589E_52A0_82F1_96C4_7ECF_9A8C_4E0E_667A_529B(unit, cfg["经验次数"], cfg["每次经验"], cfg["智力增加"])
end
return ____exports
