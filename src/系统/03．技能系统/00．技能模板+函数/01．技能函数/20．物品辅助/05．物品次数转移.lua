--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetItemCharges = jass.GetItemCharges
local SetItemCharges = jass.SetItemCharges
local ____require_result_0 = require("lib.扩展函数.物品相关函数.物品判断函数")
local GetItemOfTypeFromUnitBJ = ____require_result_0.GetItemOfTypeFromUnitBJ
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____83B7_53D6_7269_54C1_6B21_6570 = ____require_result_1["获取物品次数"]
local _____8BBE_7F6E_7269_54C1_6B21_6570 = ____require_result_1["设置物品次数"]
local _____589E_52A0_7269_54C1_6B21_6570 = ____require_result_1["增加物品次数"]
____exports["转移物品次数"] = function(_____6765_6E90_7269_54C1, _____76EE_6807_7269_54C1, _____6570_91CF)
    if _____6765_6E90_7269_54C1 == nil or _____6765_6E90_7269_54C1 == 0 or _____76EE_6807_7269_54C1 == nil or _____76EE_6807_7269_54C1 == 0 or _____6570_91CF <= 0 then
        return 0
    end
    local _____6765_6E90_6B21_6570 = GetItemCharges(_____6765_6E90_7269_54C1)
    local _____76EE_6807_6B21_6570 = GetItemCharges(_____76EE_6807_7269_54C1)
    if _____6765_6E90_6B21_6570 <= 0 then
        return 0
    end
    local _____5B9E_9645_8F6C_79FB = _____6570_91CF < _____6765_6E90_6B21_6570 and _____6570_91CF or _____6765_6E90_6B21_6570
    local _____76EE_6807_53EF_589E_52A0 = 2147483647 - _____76EE_6807_6B21_6570
    local _____771F_6B63_8F6C_79FB = _____5B9E_9645_8F6C_79FB < _____76EE_6807_53EF_589E_52A0 and _____5B9E_9645_8F6C_79FB or _____76EE_6807_53EF_589E_52A0
    if _____771F_6B63_8F6C_79FB <= 0 then
        return 0
    end
    SetItemCharges(_____6765_6E90_7269_54C1, _____6765_6E90_6B21_6570 - _____771F_6B63_8F6C_79FB)
    SetItemCharges(_____76EE_6807_7269_54C1, _____76EE_6807_6B21_6570 + _____771F_6B63_8F6C_79FB)
    return _____771F_6B63_8F6C_79FB
end
____exports["转移单位物品次数"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____7269_54C1_7C7B_578BID, _____6570_91CF)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or _____7269_54C1_7C7B_578BID == 0 or _____6570_91CF <= 0 then
        return 0
    end
    local _____6765_6E90_7269_54C1 = GetItemOfTypeFromUnitBJ(_____6765_6E90_5355_4F4D, _____7269_54C1_7C7B_578BID)
    local _____76EE_6807_7269_54C1 = GetItemOfTypeFromUnitBJ(_____76EE_6807_5355_4F4D, _____7269_54C1_7C7B_578BID)
    if _____6765_6E90_7269_54C1 == nil or _____6765_6E90_7269_54C1 == 0 or _____76EE_6807_7269_54C1 == nil or _____76EE_6807_7269_54C1 == 0 then
        return 0
    end
    return ____exports["转移物品次数"](_____6765_6E90_7269_54C1, _____76EE_6807_7269_54C1, _____6570_91CF)
end
____exports["获取物品次数"] = _____83B7_53D6_7269_54C1_6B21_6570
____exports["设置物品次数"] = _____8BBE_7F6E_7269_54C1_6B21_6570
____exports["增加物品次数"] = _____589E_52A0_7269_54C1_6B21_6570
return ____exports
