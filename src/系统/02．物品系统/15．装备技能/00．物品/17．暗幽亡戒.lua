--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____6697_5E7D_4EA1_6212_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["暗幽亡戒物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____6697_5E7D_4EA1_6212_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["暗幽亡戒配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_0.createUnitEffect
local GetItemTypeId = jass.GetItemTypeId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local function _____662F_5426_4E3A_6697_5E7D_4EA1_6212(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____6697_5E7D_4EA1_6212_7269_54C1ID
end
____exports["处理暗幽亡戒使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_6697_5E7D_4EA1_6212(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____8F6C_79FB_503C = GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MANA) * _____6697_5E7D_4EA1_6212_914D_7F6E["魔法转移比例"]
    SetUnitState(
        _____76EE_6807_5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_MANA) + _____8F6C_79FB_503C
    )
    createUnitEffect(
        _____76EE_6807_5355_4F4D,
        _____6697_5E7D_4EA1_6212_914D_7F6E["特效挂点"],
        _____6697_5E7D_4EA1_6212_914D_7F6E["特效路径"],
        _____6697_5E7D_4EA1_6212_914D_7F6E["特效持续时间"],
        "暗幽亡戒"
    )
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MANA) - _____8F6C_79FB_503C
    )
end
return ____exports
