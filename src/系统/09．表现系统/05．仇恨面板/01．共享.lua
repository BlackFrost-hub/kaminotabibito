local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.05．仇恨面板.00．常量定义")
local THREAT_PANEL_PLAYER_UNIT_MAX_PID = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PLAYER_UNIT_MAX_PID
local ____05_FF0E_73A9_5BB6_9009_4E2D_5355_4F4D_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local getSoleSelectedUnitForPlayer = ____05_FF0E_73A9_5BB6_9009_4E2D_5355_4F4D_4E8B_4EF6_4E2D_5FC3.getSoleSelectedUnitForPlayer
--- 仇恨面板 - 共享模块
-- 
-- 包含 jass/japi 绑定、接口定义、状态容器和工具函数。
local japi = require("jass.japi")
local jass = require("jass.common")
____exports.DzGetGameUI = japi.DzGetGameUI
____exports.DzLoadToc = japi.DzLoadToc
____exports.DzCreateFrame = japi.DzCreateFrame
____exports.DzCreateFrameByTagName = japi.DzCreateFrameByTagName
____exports.DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
____exports.DzFrameSetSize = japi.DzFrameSetSize
____exports.DzFrameSetTexture = japi.DzFrameSetTexture
____exports.DzFrameSetAlpha = japi.DzFrameSetAlpha
____exports.DzFrameSetPriority = japi.DzFrameSetPriority
____exports.DzFrameSetText = japi.DzFrameSetText
____exports.DzFrameSetFont = japi.DzFrameSetFont
____exports.DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
____exports.DzFrameShow = japi.DzFrameShow
____exports.Player = jass.Player
____exports.GetLocalPlayer = jass.GetLocalPlayer
____exports.GetPlayerId = jass.GetPlayerId
____exports.GetOwningPlayer = jass.GetOwningPlayer
____exports.GetUnitName = jass.GetUnitName
____exports.GetUnitTypeId = jass.GetUnitTypeId
____exports.IsUnitType = jass.IsUnitType
____exports.R2I = jass.R2I
____exports.UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
____exports.ABS_BOTTOMLEFT = 6
____exports.TEXT_ALIGN_CENTER = 18
____exports.TEXT_ALIGN_LEFT = 2
____exports.EMPTY_ROW = "|cff9f9f9f-|r"
____exports["玩家面板表"] = {}
____exports["玩家视图模型表"] = {}
____exports["玩家上次有效敌方目标表"] = {}
____exports["玩家面板显示状态表"] = {}
____exports["单位是有效怪物单位"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if ____exports.GetUnitTypeId(_____5355_4F4D) == 0 then
        return false
    end
    if ____exports.IsUnitType(_____5355_4F4D, ____exports.UNIT_TYPE_DEAD) then
        return false
    end
    local _____6240_6709_8005 = ____exports.GetOwningPlayer(_____5355_4F4D)
    if _____6240_6709_8005 == nil or _____6240_6709_8005 == 0 then
        return false
    end
    local _____73A9_5BB6ID = ____exports.GetPlayerId(_____6240_6709_8005)
    return _____73A9_5BB6ID > THREAT_PANEL_PLAYER_UNIT_MAX_PID
end
____exports["获取单位所有者玩家ID"] = function(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return -1
    end
    local _____6240_6709_8005 = ____exports.GetOwningPlayer(_____5355_4F4D)
    if _____6240_6709_8005 == nil or _____6240_6709_8005 == 0 then
        return -1
    end
    return ____exports.GetPlayerId(_____6240_6709_8005)
end
____exports["获取用于显示的目标单位"] = function(playerId)
    local _____5F53_524D_9009_4E2D_5355_4F4D = getSoleSelectedUnitForPlayer(playerId)
    if _____5F53_524D_9009_4E2D_5355_4F4D ~= nil and _____5F53_524D_9009_4E2D_5355_4F4D ~= 0 then
        if ____exports["单位是有效怪物单位"](_____5F53_524D_9009_4E2D_5355_4F4D) then
            ____exports["玩家上次有效敌方目标表"][playerId] = _____5F53_524D_9009_4E2D_5355_4F4D
            return _____5F53_524D_9009_4E2D_5355_4F4D
        end
        local _____5F53_524D_6240_6709_8005_73A9_5BB6ID = ____exports["获取单位所有者玩家ID"](_____5F53_524D_9009_4E2D_5355_4F4D)
        if _____5F53_524D_6240_6709_8005_73A9_5BB6ID >= 0 and _____5F53_524D_6240_6709_8005_73A9_5BB6ID <= THREAT_PANEL_PLAYER_UNIT_MAX_PID then
            local _____7F13_5B58_5355_4F4D = ____exports["玩家上次有效敌方目标表"][playerId]
            if _____7F13_5B58_5355_4F4D ~= nil and _____7F13_5B58_5355_4F4D ~= 0 and ____exports["单位是有效怪物单位"](_____7F13_5B58_5355_4F4D) then
                return _____7F13_5B58_5355_4F4D
            end
            return nil
        end
        return nil
    end
    return nil
end
____exports["截断名称"] = function(name, maxLen)
    if name == nil or #name <= maxLen then
        return name
    end
    return __TS__StringSubstring(name, 0, maxLen) .. "…"
end
____exports["十倍精度文本"] = function(value)
    local _____5341_500D_6574_6570 = ____exports.R2I(value * 10 + 0.5)
    local _____6574_6570_90E8_5206 = ____exports.R2I(_____5341_500D_6574_6570 / 10)
    local _____5C0F_6570_90E8_5206 = _____5341_500D_6574_6570 - _____6574_6570_90E8_5206 * 10
    return (tostring(_____6574_6570_90E8_5206) .. ".") .. tostring(_____5C0F_6570_90E8_5206)
end
____exports["百分比文本"] = function(_____4EC7_6068_503C)
    return ____exports["十倍精度文本"](_____4EC7_6068_503C / 10) .. "%"
end
____exports["按仇恨降序排序"] = function(entries)
    local result = {}
    do
        local i = 0
        while i < #entries do
            result[#result + 1] = entries[i + 1]
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #result - 1 do
            local bestIndex = i
            do
                local j = i + 1
                while j < #result do
                    if result[j + 1].threat > result[bestIndex + 1].threat then
                        bestIndex = j
                    end
                    j = j + 1
                end
            end
            if bestIndex ~= i then
                local temp = result[i + 1]
                result[i + 1] = result[bestIndex + 1]
                result[bestIndex + 1] = temp
            end
            i = i + 1
        end
    end
    return result
end
return ____exports
