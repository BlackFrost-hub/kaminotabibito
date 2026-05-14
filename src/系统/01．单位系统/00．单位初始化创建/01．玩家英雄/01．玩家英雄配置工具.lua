--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_0.fourCCToString
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____73A9_5BB6_82F1_96C4_914D_7F6E_8868 = ____require_result_1["玩家英雄配置表"]
____exports["获取玩家英雄配置"] = function(heroRawcode)
    if heroRawcode == nil or heroRawcode == "" then
        return nil
    end
    return _____73A9_5BB6_82F1_96C4_914D_7F6E_8868[heroRawcode] or nil
end
____exports["获取单位英雄Rawcode"] = function(unit)
    if unit == nil or unit == 0 then
        return ""
    end
    local typeId = jass.GetUnitTypeId(unit) or 0
    if typeId == 0 then
        return ""
    end
    return fourCCToString(nil, typeId) or ""
end
____exports["获取单位玩家英雄配置"] = function(unit)
    return ____exports["获取玩家英雄配置"](____exports["获取单位英雄Rawcode"](unit))
end
____exports["是否指定玩家英雄"] = function(unit, heroRawcode)
    if heroRawcode == nil or heroRawcode == "" then
        return false
    end
    return ____exports["获取单位英雄Rawcode"](unit) == heroRawcode
end
return ____exports
