--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_5355_4F4D_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位攻击"]
local _____4E34_65F6_8C03_6574_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["临时调整攻击"]
local _____4E34_65F6_8C03_6574_653B_901F = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["临时调整攻速"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____56DE_9000_961F_5217 = {}
local function _____56DE_9000_5730_72F1_706B_5361_724C_653B_51FB()
    local item = table.remove(_____56DE_9000_961F_5217, 1)
    if item == nil then
        return
    end
    _____4E34_65F6_8C03_6574_653B_51FB(item["单位"], -item["攻击"])
    _____4E34_65F6_8C03_6574_653B_901F(item["单位"], -item["攻速"])
end
____exports["处理地狱火卡牌攻击使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["地狱火卡牌攻击"]) then
        return
    end
    local ____temp_1
    if ctx["目标单位"] ~= nil and ctx["目标单位"] ~= 0 then
        ____temp_1 = ctx["目标单位"]
    else
        ____temp_1 = ctx["施法单位"]
    end
    local unit = ____temp_1
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["地狱火卡牌攻击"]
    local attack = _____53D6_5355_4F4D_653B_51FB(unit) * cfg["攻击比例"]
    _____4E34_65F6_8C03_6574_653B_51FB(unit, attack)
    _____4E34_65F6_8C03_6574_653B_901F(unit, cfg["攻速"])
    _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = {["单位"] = unit, ["攻击"] = attack, ["攻速"] = cfg["攻速"]}
    addDelayedCallback(cfg["持续毫秒"], _____56DE_9000_5730_72F1_706B_5361_724C_653B_51FB)
end
return ____exports
