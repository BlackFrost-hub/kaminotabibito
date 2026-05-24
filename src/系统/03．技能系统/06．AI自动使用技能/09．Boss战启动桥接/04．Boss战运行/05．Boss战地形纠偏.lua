--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnit = ____require_result_0.RectContainsUnit
local ____require_result_1 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local IsUnitPausedBJ = ____require_result_1.IsUnitPausedBJ
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitPosition = jass.SetUnitPosition
local IsTerrainPathable = jass.IsTerrainPathable
local SquareRoot = jass.SquareRoot
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local _____73A9_5BB6_5730_5F62_7EA0_504F_6B65_957F = 150
local _____73A9_5BB6_5730_5F62_7EA0_504F_6700_5927_6B65_6570 = 24
local _____5F53_524D_7EA0_504F_77E9_5F62 = nil
local _____5F53_524D_76EE_6807X = 0
local _____5F53_524D_76EE_6807Y = 0
local function _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
end
local function ____on_5FEB_901F_7EA0_504F_73A9_5BB6_82F1_96C4()
    local unit = GetEnumUnit()
    if unit == nil or unit == 0 then
        return
    end
    if IsUnitPausedBJ(unit) then
        return
    end
    if _____5F53_524D_7EA0_504F_77E9_5F62 ~= nil and _____5F53_524D_7EA0_504F_77E9_5F62 ~= 0 and not RectContainsUnit(_____5F53_524D_7EA0_504F_77E9_5F62, unit) then
        return
    end
    if not IsTerrainPathable(
        GetUnitX(unit),
        GetUnitY(unit),
        PATHING_TYPE_WALKABILITY
    ) then
        return
    end
    local currentX = GetUnitX(unit)
    local currentY = GetUnitY(unit)
    do
        local i = 0
        while i < _____73A9_5BB6_5730_5F62_7EA0_504F_6700_5927_6B65_6570 do
            local dx = _____5F53_524D_76EE_6807X - currentX
            local dy = _____5F53_524D_76EE_6807Y - currentY
            local distSq = dx * dx + dy * dy
            if distSq <= 0.01 then
                break
            end
            local dist = SquareRoot(distSq)
            if dist <= 0.01 then
                break
            end
            local move = dist < _____73A9_5BB6_5730_5F62_7EA0_504F_6B65_957F and dist or _____73A9_5BB6_5730_5F62_7EA0_504F_6B65_957F
            currentX = currentX + dx / dist * move
            currentY = currentY + dy / dist * move
            SetUnitPosition(unit, currentX, currentY)
            if not IsTerrainPathable(
                GetUnitX(unit),
                GetUnitY(unit),
                PATHING_TYPE_WALKABILITY
            ) then
                return
            end
            i = i + 1
        end
    end
end
____exports["纠偏玩家英雄位置到Boss"] = function(context)
    local _____73A9_5BB6_82F1_96C4_7EC4 = _____8BFB_53D6_73A9_5BB6_82F1_96C4_7EC4()
    if _____73A9_5BB6_82F1_96C4_7EC4 == nil or _____73A9_5BB6_82F1_96C4_7EC4 == 0 then
        return
    end
    if context["地点矩形"] == nil or context["地点矩形"] == 0 then
        return
    end
    _____5F53_524D_7EA0_504F_77E9_5F62 = context["地点矩形"]
    _____5F53_524D_76EE_6807X = GetUnitX(context["Boss单位"])
    _____5F53_524D_76EE_6807Y = GetUnitY(context["Boss单位"])
    ForGroup(_____73A9_5BB6_82F1_96C4_7EC4, ____on_5FEB_901F_7EA0_504F_73A9_5BB6_82F1_96C4)
end
return ____exports
