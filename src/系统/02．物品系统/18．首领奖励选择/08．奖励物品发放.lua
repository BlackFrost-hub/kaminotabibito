--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local _____5168_5C40_53D8_91CF = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_0.getRegisteredPlayerHero
local ____require_result_1 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_1["按名字反查物品ID"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitAddItem = jass.UnitAddItem
____exports["获取首领奖励接收英雄"] = function(_____73A9_5BB6)
    local _____6CE8_518C_82F1_96C4 = getRegisteredPlayerHero(_____73A9_5BB6)
    if _____6CE8_518C_82F1_96C4 ~= nil and _____6CE8_518C_82F1_96C4 ~= 0 then
        return _____6CE8_518C_82F1_96C4
    end
    return _____5168_5C40_53D8_91CF.gg_unit_Hamg_0002
end
____exports["发放首领奖励装备"] = function(_____73A9_5BB6, _____88C5_5907_540D)
    local _____82F1_96C4 = ____exports["获取首领奖励接收英雄"](_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____7269_54C1ID_5B57_7B26_4E32 = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    local _____7269_54C1_7C7B_578BID = stringToFourCCSafe(_____7269_54C1ID_5B57_7B26_4E32)
    if _____7269_54C1_7C7B_578BID == 0 then
        return false
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____7269_54C1_7C7B_578BID,
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4)
    )
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    UnitAddItem(_____82F1_96C4, _____7269_54C1)
    return true
end
return ____exports
