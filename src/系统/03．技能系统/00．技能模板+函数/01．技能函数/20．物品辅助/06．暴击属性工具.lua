local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local GetOwningPlayer = jass.GetOwningPlayer
local _____66B4_51FB_7387_5C5E_6027_540D = "暴击率"
local _____66B4_51FB_4F24_5BB3_5C5E_6027_540D = "暴击伤害"
local function _____8BFB_53D6_73A9_5BB6_5B9E_6570_5C5E_6027(unit, _____5C5E_6027_540D)
    if unit == nil or unit == 0 then
        return 0
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("player", owner, _____5C5E_6027_540D, "real")) or 0
end
____exports["读取玩家暴击率"] = function(unit)
    return _____8BFB_53D6_73A9_5BB6_5B9E_6570_5C5E_6027(unit, _____66B4_51FB_7387_5C5E_6027_540D)
end
____exports["读取玩家暴击伤害"] = function(unit)
    return _____8BFB_53D6_73A9_5BB6_5B9E_6570_5C5E_6027(unit, _____66B4_51FB_4F24_5BB3_5C5E_6027_540D)
end
return ____exports
