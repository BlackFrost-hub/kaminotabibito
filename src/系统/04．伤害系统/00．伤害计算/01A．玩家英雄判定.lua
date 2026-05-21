--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitInGroup = jass.IsUnitInGroup
____exports["是玩家英雄组单位"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 ~= 0 then
        return IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_5355_4F4D_7EC4) == true
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    return getRegisteredPlayerHero(owner) == unit
end
return ____exports
