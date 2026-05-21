--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_0.EC_CreateEffect
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品配置")
local _____901A_7528_7269_54C1ID = ____require_result_1["通用物品ID"]
local _____901A_7528_7269_54C1_914D_7F6E = ____require_result_1["通用物品配置"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____5220_9664_7269_54C1 = ____require_result_2["删除物品"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
____exports["处理通用物品获取特效"] = function(_____5355_4F4D, _____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    if _____901A_7528_7269_54C1ID["获取特效"] <= 0 then
        return
    end
    if GetItemTypeId(_____7269_54C1) ~= _____901A_7528_7269_54C1ID["获取特效"] then
        return
    end
    _____5220_9664_7269_54C1(_____7269_54C1)
    EC_CreateEffect(
        _____901A_7528_7269_54C1_914D_7F6E["获取特效路径"],
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D),
        0,
        _____901A_7528_7269_54C1_914D_7F6E["获取特效角度"],
        _____901A_7528_7269_54C1_914D_7F6E["获取特效尺寸"],
        1,
        _____901A_7528_7269_54C1_914D_7F6E["获取特效持续时间"]
    )
end
return ____exports
