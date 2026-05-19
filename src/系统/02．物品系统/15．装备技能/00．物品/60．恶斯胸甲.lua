local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_53E5_67C4ID = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取句柄ID"]
local _____53D6_5F53_524D_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取当前生命"]
local _____8BBE_7F6E_751F_547D = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["设置生命"]
local _____9020_6210_706B_7130_4F24_5BB3 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成火焰伤害"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local _____7A97_53E3_8868 = {}
local _____5230_671F_961F_5217 = {}
local _____540E_7EED_4F24_5BB3_961F_5217 = {}
local function _____6E05_9664_6076_65AF_80F8_7532_7A97_53E3()
    local unit = table.remove(_____5230_671F_961F_5217, 1)
    local id = _____53D6_53E5_67C4ID(unit)
    if id ~= 0 then
        __TS__Delete(_____7A97_53E3_8868, id)
    end
end
local function _____6267_884C_6076_65AF_80F8_7532_540E_7EED_4F24_5BB3()
    local item = table.remove(_____540E_7EED_4F24_5BB3_961F_5217, 1)
    if item == nil then
        return
    end
    _____9020_6210_706B_7130_4F24_5BB3(item["来源"], item["目标"], item["伤害"])
end
____exports["处理恶斯胸甲使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["恶斯胸甲"]) then
        return
    end
    local unit = ctx["施法单位"]
    local currentLife = _____53D6_5F53_524D_751F_547D(unit)
    local cost = currentLife * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["当前生命消耗比例"]
    if cost < _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["最低消耗"] then
        cost = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["最低消耗"]
    end
    if cost > currentLife - 1 then
        cost = currentLife - 1
    end
    if cost > 0 then
        _____8BBE_7F6E_751F_547D(unit, currentLife - cost)
    end
    _____7A97_53E3_8868[_____53D6_53E5_67C4ID(unit)] = {["消耗生命"] = cost}
    _____5230_671F_961F_5217[#_____5230_671F_961F_5217 + 1] = unit
    addDelayedCallback(_____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["持续毫秒"], _____6E05_9664_6076_65AF_80F8_7532_7A97_53E3)
end
____exports["处理恶斯胸甲伤害修正"] = function(context)
    local attacker = context.attacker
    local id = _____53D6_53E5_67C4ID(attacker)
    local ____temp_1
    if id == 0 then
        ____temp_1 = nil
    else
        ____temp_1 = _____7A97_53E3_8868[id]
    end
    local state = ____temp_1
    if state == nil then
        return context.currentDamage
    end
    if not (context.currentDamage > _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["触发伤害阈值"]) then
        return context.currentDamage
    end
    __TS__Delete(_____7A97_53E3_8868, id)
    _____540E_7EED_4F24_5BB3_961F_5217[#_____540E_7EED_4F24_5BB3_961F_5217 + 1] = {["来源"] = attacker, ["目标"] = context.target, ["伤害"] = state["消耗生命"] * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["后续伤害倍率"]}
    addDelayedCallback(0, _____6267_884C_6076_65AF_80F8_7532_540E_7EED_4F24_5BB3)
    return context.currentDamage * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶斯胸甲"]["伤害提升倍率"]
end
return ____exports
