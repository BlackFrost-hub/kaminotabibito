--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品配置")
local _____901A_7528_7269_54C1ID = ____require_result_1["通用物品ID"]
local _____901A_7528_7269_54C1_914D_7F6E = ____require_result_1["通用物品配置"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____5220_9664_7269_54C1 = ____require_result_2["删除物品"]
local _____7269_54C1_7C7B_578BID_5728_5217_8868_4E2D = ____require_result_2["物品类型ID在列表中"]
local _____53D6_7269_54C1_53E5_67C4ID = ____require_result_2["取物品句柄ID"]
local GetItemTypeId = jass.GetItemTypeId
local _____5EF6_8FDF_5220_9664_7269_54C1_961F_5217 = {}
local function ____on_5408_6210_6253_9020_5EF6_8FDF_5220_9664()
    local _____7269_54C1 = table.remove(_____5EF6_8FDF_5220_9664_7269_54C1_961F_5217, 1)
    _____5220_9664_7269_54C1(_____7269_54C1)
end
____exports["处理通用物品合成打造"] = function(______5355_4F4D, _____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    if #_____901A_7528_7269_54C1ID["合成打造列表"] <= 0 then
        return
    end
    local _____7269_54C1_7C7B_578BID = GetItemTypeId(_____7269_54C1)
    if not _____7269_54C1_7C7B_578BID_5728_5217_8868_4E2D(_____7269_54C1_7C7B_578BID, _____901A_7528_7269_54C1ID["合成打造列表"]) then
        return
    end
    local _____7269_54C1_53E5_67C4ID = _____53D6_7269_54C1_53E5_67C4ID(_____7269_54C1)
    if _____7269_54C1_53E5_67C4ID <= 0 then
        return
    end
    _____5EF6_8FDF_5220_9664_7269_54C1_961F_5217[#_____5EF6_8FDF_5220_9664_7269_54C1_961F_5217 + 1] = _____7269_54C1
    addDelayedCallback(_____901A_7528_7269_54C1_914D_7F6E["合成打造延迟毫秒"], ____on_5408_6210_6253_9020_5EF6_8FDF_5220_9664)
end
return ____exports
