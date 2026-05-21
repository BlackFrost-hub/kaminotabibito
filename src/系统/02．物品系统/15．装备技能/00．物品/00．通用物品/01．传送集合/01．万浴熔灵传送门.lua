--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_0.StarOther_PanCameraToTimedForPlayer
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品配置")
local _____901A_7528_7269_54C1ID = ____require_result_1["通用物品ID"]
local _____901A_7528_7269_54C1_914D_7F6E = ____require_result_1["通用物品配置"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____5220_9664_7269_54C1 = ____require_result_2["删除物品"]
local GetItemTypeId = jass.GetItemTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetRectCenterX = jass.GetRectCenterX
local GetRectCenterY = jass.GetRectCenterY
local SetUnitPosition = jass.SetUnitPosition
local function _____83B7_53D6_4E07_6D74_7194_7075_955C_5934_77E9_5F62()
    return jglobals[_____901A_7528_7269_54C1_914D_7F6E["万浴熔灵镜头矩形"]]
end
____exports["处理万浴熔灵传送门"] = function(_____5355_4F4D, _____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    if _____901A_7528_7269_54C1ID["传送门_万浴熔灵"] <= 0 then
        return
    end
    if GetItemTypeId(_____7269_54C1) ~= _____901A_7528_7269_54C1ID["传送门_万浴熔灵"] then
        return
    end
    local _____955C_5934_77E9_5F62 = _____83B7_53D6_4E07_6D74_7194_7075_955C_5934_77E9_5F62()
    if _____955C_5934_77E9_5F62 ~= nil and _____955C_5934_77E9_5F62 ~= 0 then
        StarOther_PanCameraToTimedForPlayer(
            GetOwningPlayer(_____5355_4F4D),
            GetRectCenterX(_____955C_5934_77E9_5F62),
            GetRectCenterY(_____955C_5934_77E9_5F62),
            0
        )
    end
    SetUnitPosition(_____5355_4F4D, _____901A_7528_7269_54C1_914D_7F6E["万浴熔灵传送X"], _____901A_7528_7269_54C1_914D_7F6E["万浴熔灵传送Y"])
    _____5220_9664_7269_54C1(_____7269_54C1)
end
return ____exports
