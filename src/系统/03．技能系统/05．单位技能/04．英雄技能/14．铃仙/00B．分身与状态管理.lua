local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00．配置")
local _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["铃仙单位技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
local forEachUnitInGroup = ____require_result_2.forEachUnitInGroup
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算")
local _____79D2_8F6C_6BEB_79D2 = ____require_result_4["秒转毫秒"]
local _____94C3_4ED9_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local IsUnitIllusion = jass.IsUnitIllusion
local IsUnitType = jass.IsUnitType
local _____94C3_4ED9_82F1_96C4_8868 = {}
____exports["是铃仙本体"] = function(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____94C3_4ED9_5355_4F4D_7C7B_578BID
end
____exports["注册铃仙英雄"] = function(_____82F1_96C4)
    if not ____exports["是铃仙本体"](_____82F1_96C4) then
        return
    end
    _____94C3_4ED9_82F1_96C4_8868[GetPlayerId(GetOwningPlayer(_____82F1_96C4))] = _____82F1_96C4
end
____exports["获取玩家铃仙英雄"] = function(player)
    if player == nil or player == 0 then
        return nil
    end
    local hero = _____94C3_4ED9_82F1_96C4_8868[GetPlayerId(player)]
    if hero == nil or hero == 0 or jass.IsUnitType(hero, jass.UNIT_TYPE_DEAD) then
        return nil
    end
    return hero
end
--- 是否为铃仙分身（幻象 + 同类型）
____exports["是铃仙分身"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if not IsUnitIllusion(unit) then
        return false
    end
    return GetUnitTypeId(unit) == _____94C3_4ED9_5355_4F4D_7C7B_578BID
end
--- 每个铃仙英雄关联一个分身单位组
local _____5206_8EAB_5355_4F4D_7EC4_8868 = {}
____exports["获取铃仙分身组"] = function(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local list = _____5206_8EAB_5355_4F4D_7EC4_8868[id]
    if list == nil then
        list = {}
        _____5206_8EAB_5355_4F4D_7EC4_8868[id] = list
    end
    return list
end
____exports["铃仙分身数量"] = function(_____82F1_96C4)
    local list = _____5206_8EAB_5355_4F4D_7EC4_8868[GetHandleId(_____82F1_96C4)]
    if list == nil then
        return 0
    end
    do
        local i = #list - 1
        while i >= 0 do
            local u = list[i + 1]
            if u == nil or u == 0 or IsUnitType(u, jass.UNIT_TYPE_DEAD) then
                __TS__ArraySplice(list, i, 1)
            end
            i = i - 1
        end
    end
    return #list
end
____exports["加入铃仙分身"] = function(_____82F1_96C4, _____5206_8EAB)
    if _____5206_8EAB == nil or _____5206_8EAB == 0 then
        return
    end
    local list = ____exports["获取铃仙分身组"](_____82F1_96C4)
    if __TS__ArrayIndexOf(list, _____5206_8EAB) < 0 then
        list[#list + 1] = _____5206_8EAB
    end
end
____exports["移除铃仙分身"] = function(_____82F1_96C4, _____5206_8EAB)
    local list = _____5206_8EAB_5355_4F4D_7EC4_8868[GetHandleId(_____82F1_96C4)]
    if list == nil then
        return
    end
    local index = __TS__ArrayIndexOf(list, _____5206_8EAB)
    if index >= 0 then
        __TS__ArraySplice(list, index, 1)
    end
end
____exports["清空铃仙分身"] = function(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local list = _____5206_8EAB_5355_4F4D_7EC4_8868[id]
    if list ~= nil then
        __TS__ArraySetLength(list, 0)
    end
end
local function _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
--- 对所有玩家英雄设置「免疫伤害」标记，持续时间后清除
____exports["全图英雄免疫伤害"] = function(_____6301_7EED_79D2)
    local group = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if group == nil or group == 0 then
        return
    end
    local _____5FEB_7167 = {}
    forEachUnitInGroup(
        group,
        function(u)
            if u ~= nil and u ~= 0 then
                _____5FEB_7167[#_____5FEB_7167 + 1] = u
            end
        end
    )
    do
        local i = 0
        while i < #_____5FEB_7167 do
            local hero = _____5FEB_7167[i + 1]
            YDUserDataSetSafe(
                "unit",
                hero,
                "免疫伤害",
                "boolean",
                true
            )
            i = i + 1
        end
    end
    addDelayedCallback(
        _____79D2_8F6C_6BEB_79D2(_____6301_7EED_79D2),
        function()
            do
                local i = 0
                while i < #_____5FEB_7167 do
                    do
                        local hero = _____5FEB_7167[i + 1]
                        if hero == nil or hero == 0 then
                            goto __continue35
                        end
                        YDUserDataSetSafe(
                            "unit",
                            hero,
                            "免疫伤害",
                            "boolean",
                            false
                        )
                    end
                    ::__continue35::
                    i = i + 1
                end
            end
        end
    )
end
____exports["是有效敌对目标"] = function(_____65BD_6CD5_8005, target)
    if target == nil or target == 0 or target == _____65BD_6CD5_8005 then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_DEAD) then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_STRUCTURE) then
        return false
    end
    return jass.IsUnitEnemy(
        target,
        GetOwningPlayer(_____65BD_6CD5_8005)
    ) == true
end
return ____exports
