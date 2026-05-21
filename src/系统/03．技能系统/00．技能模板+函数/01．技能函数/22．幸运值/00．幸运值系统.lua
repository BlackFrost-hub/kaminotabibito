local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomReal = jass.GetRandomReal
____exports["幸运值属性名"] = "幸运值"
local function _____9650_5236_6982_7387(value)
    if value <= 0 then
        return 0
    end
    if value >= 1 then
        return 1
    end
    return value
end
____exports["取玩家幸运值"] = function(_____73A9_5BB6)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("player", _____73A9_5BB6, ____exports["幸运值属性名"], "real")) or 0
end
____exports["设置玩家幸运值"] = function(_____73A9_5BB6, _____5E78_8FD0_503C)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        ____exports["幸运值属性名"],
        "real",
        _____5E78_8FD0_503C
    )
end
____exports["增加玩家幸运值"] = function(_____73A9_5BB6, _____589E_91CF)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    ____exports["设置玩家幸运值"](
        _____73A9_5BB6,
        ____exports["取玩家幸运值"](_____73A9_5BB6) + _____589E_91CF
    )
end
____exports["按玩家幸运修正概率"] = function(_____539F_59CB_6982_7387, _____73A9_5BB6)
    if not (_____539F_59CB_6982_7387 > 0) then
        return 0
    end
    local _____5E78_8FD0_503C = ____exports["取玩家幸运值"](_____73A9_5BB6)
    return _____9650_5236_6982_7387(_____539F_59CB_6982_7387 * (1 + _____5E78_8FD0_503C))
end
____exports["按单位所属玩家幸运修正概率"] = function(_____539F_59CB_6982_7387, _____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return _____9650_5236_6982_7387(_____539F_59CB_6982_7387)
    end
    return ____exports["按玩家幸运修正概率"](
        _____539F_59CB_6982_7387,
        GetOwningPlayer(_____5355_4F4D)
    )
end
____exports["玩家幸运概率通过"] = function(_____539F_59CB_6982_7387, _____73A9_5BB6)
    local _____6700_7EC8_6982_7387 = ____exports["按玩家幸运修正概率"](_____539F_59CB_6982_7387, _____73A9_5BB6)
    if _____6700_7EC8_6982_7387 >= 1 then
        return true
    end
    if _____6700_7EC8_6982_7387 <= 0 then
        return false
    end
    return GetRandomReal(0, 1) <= _____6700_7EC8_6982_7387
end
____exports["单位幸运概率通过"] = function(_____539F_59CB_6982_7387, _____5355_4F4D)
    local _____6700_7EC8_6982_7387 = ____exports["按单位所属玩家幸运修正概率"](_____539F_59CB_6982_7387, _____5355_4F4D)
    if _____6700_7EC8_6982_7387 >= 1 then
        return true
    end
    if _____6700_7EC8_6982_7387 <= 0 then
        return false
    end
    return GetRandomReal(0, 1) <= _____6700_7EC8_6982_7387
end
____exports["装备触发概率修正"] = function(_____539F_59CB_6982_7387, _____89E6_53D1_5355_4F4D)
    return ____exports["按单位所属玩家幸运修正概率"](_____539F_59CB_6982_7387, _____89E6_53D1_5355_4F4D)
end
____exports["装备触发概率通过"] = function(_____539F_59CB_6982_7387, _____89E6_53D1_5355_4F4D)
    return ____exports["单位幸运概率通过"](_____539F_59CB_6982_7387, _____89E6_53D1_5355_4F4D)
end
return ____exports
