--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.25．延迟批处理队列")
local _____521B_5EFA_5EF6_8FDF_6279_5904_7406_961F_5217 = ____require_result_0["创建延迟批处理队列"]
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品配置")
local _____901A_7528_7269_54C1ID = ____require_result_1["通用物品ID"]
local _____901A_7528_7269_54C1_914D_7F6E = ____require_result_1["通用物品配置"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____5220_9664_7269_54C1 = ____require_result_2["删除物品"]
local _____7269_54C1_7C7B_578BID_5728_5217_8868_4E2D = ____require_result_2["物品类型ID在列表中"]
local _____53D6_7269_54C1_53E5_67C4ID = ____require_result_2["取物品句柄ID"]
local GetItemTypeId = jass.GetItemTypeId
local _____5408_6210_6253_9020_5EF6_8FDF_5220_9664_961F_5217 = _____521B_5EFA_5EF6_8FDF_6279_5904_7406_961F_5217(
    "通用物品合成打造延迟删除",
    {
        ["延迟毫秒"] = _____901A_7528_7269_54C1_914D_7F6E["合成打造延迟毫秒"],
        ["处理"] = function(_____7269_54C1)
            _____5220_9664_7269_54C1(_____7269_54C1)
        end
    }
)
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
    _____5408_6210_6253_9020_5EF6_8FDF_5220_9664_961F_5217["加入"](_____7269_54C1)
end
return ____exports
