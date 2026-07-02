--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local g = require("jass.globals")
local C = require("系统.00．核心系统.00．玩家系统.00．常量")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
____exports["脱战开关"] = true
____exports["玩家英雄脱战时间秒"] = 18
____exports["Boss脱战时间秒"] = 10
____exports["普通单位脱战时间秒"] = ____exports["玩家英雄脱战时间秒"]
____exports["脱战移速技能ID"] = 1093677378
____exports["脱战BuffID"] = 1110454321
____exports["脱战伤害阈值比例"] = 0.012
____exports["取脱战时间秒"] = function(_____4E3B_4F53_7C7B_578B)
    if _____4E3B_4F53_7C7B_578B == "Boss" then
        return ____exports["Boss脱战时间秒"]
    end
    if _____4E3B_4F53_7C7B_578B == "普通单位" then
        return ____exports["普通单位脱战时间秒"]
    end
    return ____exports["玩家英雄脱战时间秒"]
end
____exports["判断单位是否当前Boss"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local boss = g.udg_Boss
    if boss ~= nil and boss ~= 0 and unit == boss then
        return true
    end
    return false
end
____exports["判断单位是否注册玩家英雄"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if GetUnitTypeId(unit) == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    return YDUserDataGet("player", owner, C.YD_ATTR_PLAYER_HERO_UNIT, "unit") == unit
end
____exports["取单位默认脱战主体类型"] = function(unit)
    if ____exports["判断单位是否当前Boss"](unit) then
        return "Boss"
    end
    if unit == nil or unit == 0 then
        return "普通单位"
    end
    if GetUnitTypeId(unit) == 0 then
        return "普通单位"
    end
    if ____exports["判断单位是否注册玩家英雄"](unit) then
        return "玩家英雄"
    end
    return "普通单位"
end
____exports["取单位默认脱战时间秒"] = function(unit, _____6307_5B9A_4E3B_4F53_7C7B_578B)
    return ____exports["取脱战时间秒"](_____6307_5B9A_4E3B_4F53_7C7B_578B or ____exports["取单位默认脱战主体类型"](unit))
end
return ____exports
