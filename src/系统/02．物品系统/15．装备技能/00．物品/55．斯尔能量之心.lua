--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____5355_4F4D_6301_6709_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位持有物品"]
local _____589E_52A0_7269_54C1_6B21_6570 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["增加物品次数"]
local _____83B7_53D6_7269_54C1_6B21_6570 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取物品次数"]
local _____8BBE_7F6E_7269_54C1_6B21_6570 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["设置物品次数"]
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["调整玩家属性"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____56DE_9000_961F_5217 = {}
local function _____56DE_9000_65AF_5C14_80FD_91CF_4E4B_5FC3_589E_4F24()
    local unit = table.remove(_____56DE_9000_961F_5217, 1)
    if unit == nil or unit == 0 then
        return
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "伤害%", -_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["斯尔能量之心"]["伤害提升"])
end
____exports["处理斯尔能量之心击杀"] = function(_dyingUnit, killingUnit)
    if not _____5355_4F4D_6301_6709_7269_54C1(killingUnit, _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["斯尔能量之心"]
    _____589E_52A0_7269_54C1_6B21_6570(killingUnit, _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"], cfg["击杀层数"], cfg["触发层数"])
end
____exports["处理斯尔能量之心使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"]) then
        return
    end
    local unit = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["斯尔能量之心"]
    if _____83B7_53D6_7269_54C1_6B21_6570(unit, _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"]) < cfg["触发层数"] then
        return
    end
    _____8BBE_7F6E_7269_54C1_6B21_6570(unit, _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"], 0)
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "伤害%", cfg["伤害提升"])
    _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = unit
    addDelayedCallback(cfg["持续毫秒"], _____56DE_9000_65AF_5C14_80FD_91CF_4E4B_5FC3_589E_4F24)
end
return ____exports
