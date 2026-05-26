local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_1.YDUserDataClearTable
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
do
    local ____17_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_6B7B_4EA1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.17．第一章最终Boss教派死亡")
    ____exports["教派最终Boss死亡剧情片段"] = ____17_FF0E_7B2C_4E00_7AE0_6700_7EC8Boss_6559_6D3E_6B7B_4EA1["教派最终Boss死亡剧情片段"]
end
local GetDyingUnit = jass.GetDyingUnit
local GetUnitTypeId = jass.GetUnitTypeId
local SetUnitPosition = jass.SetUnitPosition
local UnitSuspendDecay = jass.UnitSuspendDecay
____exports["执行蒙面人死亡"] = function(_____53C2_6570)
    local dyingUnit = GetDyingUnit()
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    local dyingTypeId = GetUnitTypeId(dyingUnit)
    if dyingTypeId ~= stringToFourCCSafe("N05N") and dyingTypeId ~= stringToFourCCSafe("N05M") then
        return
    end
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or __TS__Number(_____53C2_6570["目标进度"]) or 18)
    UnitSuspendDecay(dyingUnit, true)
    YDUserDataClearSafe(
        "string",
        "Boss",
        dyingTypeId == stringToFourCCSafe("N05M") and "教派学者" or "教派剑士",
        "unit"
    )
    YDUserDataClearTable("unit", dyingUnit)
    local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
    local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
    local _____957F_8001 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit")
    if _____957F_8001 ~= nil and _____957F_8001 ~= 0 then
        SetUnitPosition(
            _____957F_8001,
            __TS__Number(_____53C2_6570["族长新位置X"]) or 28775.2,
            __TS__Number(_____53C2_6570["族长新位置Y"]) or -28660.2
        )
    end
end
local function _____6267_884C_7B2C_4E00_7AE0_5B8C_6210_4EFB_52A1_5237_65B0()
end
____exports["第一章最终Boss教派死亡剧情动作注册表"] = {["SW01死亡事件_蒙面人死亡"] = ____exports["执行蒙面人死亡"], ["JLC精灵村_第一章完成任务刷新"] = _____6267_884C_7B2C_4E00_7AE0_5B8C_6210_4EFB_52A1_5237_65B0}
return ____exports
