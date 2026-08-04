--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品配置")
local _____901A_7528_7269_54C1ID = ____require_result_1["通用物品ID"]
local ____require_result_2 = require("系统.02．物品系统.15．装备技能.00．物品.00．通用物品.00．通用物品工具")
local _____5220_9664_7269_54C1 = ____require_result_2["删除物品"]
local GetItemTypeId = jass.GetItemTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local UnitAddAbility = jass.UnitAddAbility
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
____exports["处理通用物品领取技能"] = function(_____5355_4F4D, _____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    if _____901A_7528_7269_54C1ID["领取技能"] <= 0 then
        return
    end
    if GetItemTypeId(_____7269_54C1) ~= _____901A_7528_7269_54C1ID["领取技能"] then
        return
    end
    _____5220_9664_7269_54C1(_____7269_54C1)
    local _____73A9_5BB6 = GetOwningPlayer(_____5355_4F4D)
    local _____6280_80FDID = YDUserDataGetSafe("player", _____73A9_5BB6, "FF", "abilcode")
    local _____5DF2_9886_53D6 = YDUserDataGetSafe("player", _____73A9_5BB6, "FF领取", "boolean") == true
    if _____6280_80FDID == nil or _____6280_80FDID == 0 or _____5DF2_9886_53D6 then
        return
    end
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        6,
        "（领取成功）"
    )
    YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        "FF领取",
        "boolean",
        true
    )
    UnitAddAbility(_____5355_4F4D, _____6280_80FDID)
end
return ____exports
