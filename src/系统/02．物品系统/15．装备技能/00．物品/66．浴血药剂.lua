--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____4E34_65F6_8C03_6574_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["临时调整攻击"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____56DE_9000_961F_5217 = {}
local function _____56DE_9000_6D74_8840_836F_5242_653B_51FB()
    local unit = table.remove(_____56DE_9000_961F_5217, 1)
    if unit == nil or unit == 0 then
        return
    end
    _____4E34_65F6_8C03_6574_653B_51FB(unit, -_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["浴血药剂"]["攻击增加"])
end
____exports["处理浴血药剂使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["浴血药剂"]) then
        return
    end
    local unit = ctx["施法单位"]
    _____4E34_65F6_8C03_6574_653B_51FB(unit, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["浴血药剂"]["攻击增加"])
    _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = unit
    addDelayedCallback(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["浴血药剂"]["持续毫秒"], _____56DE_9000_6D74_8840_836F_5242_653B_51FB)
end
return ____exports
