--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____6307_6325_4E4B_5251_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["指挥之剑物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____6307_6325_4E4B_5251_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["指挥之剑配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.02．易伤")
local _____65BD_52A0_6613_4F24 = ____require_result_0["施加易伤"]
local GetItemTypeId = jass.GetItemTypeId
local function _____662F_5426_4E3A_6307_6325_4E4B_5251(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    if _____6307_6325_4E4B_5251_7269_54C1ID <= 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____6307_6325_4E4B_5251_7269_54C1ID
end
____exports["处理指挥之剑使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_6307_6325_4E4B_5251(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    _____65BD_52A0_6613_4F24(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D, {["持续时间"] = _____6307_6325_4E4B_5251_914D_7F6E["持续时间"], ["伤害增加百分比"] = _____6307_6325_4E4B_5251_914D_7F6E["易伤百分比"]})
end
return ____exports
