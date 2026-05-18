--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5730_7CBE_94A5_5319_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["地精钥匙物品ID"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_0.ModifyGateBJ
local GetItemTypeId = jass.GetItemTypeId
local IsDestructableInvulnerable = jass.IsDestructableInvulnerable
local SetDestructableInvulnerable = jass.SetDestructableInvulnerable
local bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN
local function _____662F_5426_4E3A_5730_7CBE_94A5_5319(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____5730_7CBE_94A5_5319_7269_54C1ID
end
____exports["处理地精钥匙使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_5730_7CBE_94A5_5319(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____5927_95E8 = _____4E0A_4E0B_6587["目标可破坏物"]
    if _____5927_95E8 == nil or _____5927_95E8 == 0 then
        return
    end
    if IsDestructableInvulnerable(_____5927_95E8) then
        return
    end
    ModifyGateBJ(bj_GATEOPERATION_OPEN, _____5927_95E8)
    SetDestructableInvulnerable(_____5927_95E8, true)
end
return ____exports
