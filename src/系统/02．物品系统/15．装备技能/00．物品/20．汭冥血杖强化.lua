--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____6C6D_51A5_8840_6756_5F3A_5316_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["汭冥血杖强化物品ID"]
local ____19_FF0E_6C6D_51A5_8840_6756 = require("系统.02．物品系统.15．装备技能.00．物品.19．汭冥血杖")
local _____6267_884C_6C6D_51A5_8840_6756_732E_796D = ____19_FF0E_6C6D_51A5_8840_6756["执行汭冥血杖献祭"]
---
-- @noSelfInFile
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local function _____662F_5426_4E3A_6C6D_51A5_8840_6756_5F3A_5316(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____6C6D_51A5_8840_6756_5F3A_5316_7269_54C1ID
end
____exports["处理汭冥血杖强化使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_6C6D_51A5_8840_6756_5F3A_5316(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    _____6267_884C_6C6D_51A5_8840_6756_732E_796D(_____4E0A_4E0B_6587, true)
end
return ____exports
