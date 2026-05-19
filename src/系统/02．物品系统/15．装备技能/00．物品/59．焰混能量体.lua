local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_53E5_67C4ID = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取句柄ID"]
local _____4E34_65F6_8C03_6574_653B_901F = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["临时调整攻速"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____5269_4F59_666E_653B_6B21_6570 = {}
local _____6FC0_6D3B_8868 = {}
local _____56DE_9000_961F_5217 = {}
local function _____6E05_9664_7130_6DF7_80FD_91CF_4F53(unit)
    local id = _____53D6_53E5_67C4ID(unit)
    if id == 0 or _____6FC0_6D3B_8868[id] ~= true then
        return
    end
    __TS__Delete(_____6FC0_6D3B_8868, id)
    __TS__Delete(_____5269_4F59_666E_653B_6B21_6570, id)
    _____4E34_65F6_8C03_6574_653B_901F(unit, -_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["焰混能量体"]["攻速"])
end
local function _____7130_6DF7_80FD_91CF_4F53_5230_671F()
    local unit = table.remove(_____56DE_9000_961F_5217, 1)
    if unit == nil or unit == 0 then
        return
    end
    _____6E05_9664_7130_6DF7_80FD_91CF_4F53(unit)
end
____exports["处理焰混能量体使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["焰混能量体"]) then
        return
    end
    local unit = ctx["施法单位"]
    local id = _____53D6_53E5_67C4ID(unit)
    if id == 0 then
        return
    end
    _____6E05_9664_7130_6DF7_80FD_91CF_4F53(unit)
    _____6FC0_6D3B_8868[id] = true
    _____5269_4F59_666E_653B_6B21_6570[id] = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["焰混能量体"]["普攻次数"]
    _____4E34_65F6_8C03_6574_653B_901F(unit, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["焰混能量体"]["攻速"])
    _____56DE_9000_961F_5217[#_____56DE_9000_961F_5217 + 1] = unit
    addDelayedCallback(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["焰混能量体"]["持续毫秒"], _____7130_6DF7_80FD_91CF_4F53_5230_671F)
end
____exports["处理焰混能量体伤害"] = function(_target, attacker, _applied, snapshot)
    if snapshot == nil or snapshot.isNormalAttack ~= true then
        return
    end
    local id = _____53D6_53E5_67C4ID(attacker)
    if id == 0 or _____6FC0_6D3B_8868[id] ~= true then
        return
    end
    local remain = (_____5269_4F59_666E_653B_6B21_6570[id] or 0) - 1
    if remain <= 0 then
        _____6E05_9664_7130_6DF7_80FD_91CF_4F53(attacker)
    else
        _____5269_4F59_666E_653B_6B21_6570[id] = remain
    end
end
return ____exports
