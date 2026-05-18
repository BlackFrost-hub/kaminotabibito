--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5DE8_9B54_5927_5251_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["巨魔大剑物品ID"]
local ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.02．施法触发.00．施法触发配置")
local _____5DE8_9B54_5927_5251_914D_7F6E = ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E["巨魔大剑配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local jass = require("jass.common")
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local YDUserDataClearSafe = ____require_result_3.YDUserDataClearSafe
local getObjectPropertyIntegerSafe = ____require_result_3.getObjectPropertyIntegerSafe
local ____require_result_4 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ObjectType = ____require_result_4.ObjectType
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local function _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____5DE8_9B54_5927_5251_7269_54C1ID <= 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(_____5355_4F4D, _____5DE8_9B54_5927_5251_7269_54C1ID) == true
end
local function _____5DE8_9B54_5927_5251_6761_4EF6_6210_7ACB(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if not IsUnitType(_____65BD_6CD5_5355_4F4D, UNIT_TYPE_HERO) then
        return false
    end
    if not _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(_____65BD_6CD5_5355_4F4D) then
        return false
    end
    local DataB1 = getObjectPropertyIntegerSafe(ObjectType.ABILITY, _____6280_80FDID, "DataB1")
    return DataB1 == 1 or DataB1 == 3
end
____exports["处理巨魔大剑施法"] = function(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    debugLogForce("10．巨魔大剑", "进入", "处理巨魔大剑施法")
    if not _____5DE8_9B54_5927_5251_6761_4EF6_6210_7ACB(_____65BD_6CD5_5355_4F4D, _____6280_80FDID) then
        return
    end
    YDUserDataSetSafe(
        "unit",
        _____65BD_6CD5_5355_4F4D,
        _____5DE8_9B54_5927_5251_914D_7F6E["标记名"],
        "boolean",
        true
    )
    addDelayedCallback(
        _____5DE8_9B54_5927_5251_914D_7F6E["持续时间"] * 1000,
        function()
            YDUserDataSetSafe(
                "unit",
                _____65BD_6CD5_5355_4F4D,
                _____5DE8_9B54_5927_5251_914D_7F6E["标记名"],
                "boolean",
                false
            )
            YDUserDataClearSafe("unit", _____65BD_6CD5_5355_4F4D, _____5DE8_9B54_5927_5251_914D_7F6E["标记名"], "boolean")
        end
    )
end
return ____exports
