--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["调整玩家属性"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____56DE_9000_961F_5217 = {}
local function _____56DE_9000_6D74_9B54_836F_5242_9B54_6CD5_4F24_5BB3()
    local unit = table.remove(_____56DE_9000_961F_5217, 1)
    if unit == nil or unit == 0 then
        return
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "魔法伤害", -_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["浴魔药剂"]["魔法伤害提升"])
end
____exports["处理浴魔药剂使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["浴魔药剂"]) then
        return
    end
    local unit = ctx["施法单位"]
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, "魔法伤害", _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["浴魔药剂"]["魔法伤害提升"])
    _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = unit
    addDelayedCallback(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["浴魔药剂"]["持续毫秒"], _____56DE_9000_6D74_9B54_836F_5242_9B54_6CD5_4F24_5BB3)
end
return ____exports
