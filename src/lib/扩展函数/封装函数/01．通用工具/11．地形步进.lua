--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 地形步进工具
-- 
-- 从指定起点沿固定角度做离散步进。
-- 每次先检查“下一步坐标”是否可通行：
-- 1. 可通行：推进到下一步坐标
-- 2. 不可通行：立即停止在当前坐标
-- 
-- 不做最近可走点矫正，不做吸附修正。
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
local Cos = jass.Cos
local Sin = jass.Sin
local GetRectMinX = jass.GetRectMinX
local GetRectMaxX = jass.GetRectMaxX
local GetRectMinY = jass.GetRectMinY
local GetRectMaxY = jass.GetRectMaxY
local DzUnitCanPlaceAround = japi.DzUnitCanPlaceAround
local _____9ED8_8BA4_68C0_6D4B_7EC6_5206_8DDD_79BB = 6
local function _____5728_53EF_73A9_533A_57DF_5185(x, y)
    local playable = jglobals.bj_mapInitialPlayableArea
    return x >= GetRectMinX(playable) and y >= GetRectMinY(playable) and x <= GetRectMaxX(playable) and y <= GetRectMaxY(playable)
end
local function _____4E0B_4E00_6B65_53EF_901A_884C(_____53C2_6570, x, y)
    return X_IsTerrainWalkable(nil, x, y)
end
____exports["沿角度步进直到地形阻挡"] = function(_____53C2_6570)
    local _____5F27_5EA6 = _____53C2_6570["角度度"] * 0.01745329252
    local _____5B9E_9645_5355_6B65_8DDD_79BB = _____53C2_6570["单步距离"]
    local _____68C0_6D4B_7EC6_5206_8DDD_79BB = _____53C2_6570["检测细分距离"] ~= nil and _____53C2_6570["检测细分距离"] > 0 and _____53C2_6570["检测细分距离"] or _____9ED8_8BA4_68C0_6D4B_7EC6_5206_8DDD_79BB
    local _____5F53_524DX = _____53C2_6570["起点X"]
    local _____5F53_524DY = _____53C2_6570["起点Y"]
    local _____5B9E_9645_6B65_6570 = 0
    do
        local i = 0
        while i < _____53C2_6570["步数"] do
            local _____5F53_524D_6B65_5DF2_79FB_52A8 = 0
            while _____5F53_524D_6B65_5DF2_79FB_52A8 < _____5B9E_9645_5355_6B65_8DDD_79BB do
                local _____672C_6B21_68C0_6D4B_8DDD_79BB = _____5B9E_9645_5355_6B65_8DDD_79BB - _____5F53_524D_6B65_5DF2_79FB_52A8
                if _____672C_6B21_68C0_6D4B_8DDD_79BB > _____68C0_6D4B_7EC6_5206_8DDD_79BB then
                    _____672C_6B21_68C0_6D4B_8DDD_79BB = _____68C0_6D4B_7EC6_5206_8DDD_79BB
                end
                local _____4E0B_4E00_6B65X = _____5F53_524DX + _____672C_6B21_68C0_6D4B_8DDD_79BB * Cos(_____5F27_5EA6)
                local _____4E0B_4E00_6B65Y = _____5F53_524DY + _____672C_6B21_68C0_6D4B_8DDD_79BB * Sin(_____5F27_5EA6)
                if not _____4E0B_4E00_6B65_53EF_901A_884C(_____53C2_6570, _____4E0B_4E00_6B65X, _____4E0B_4E00_6B65Y) then
                    return {["最终X"] = _____5F53_524DX, ["最终Y"] = _____5F53_524DY, ["实际步数"] = _____5B9E_9645_6B65_6570, ["是否提前停止"] = true}
                end
                if not _____5728_53EF_73A9_533A_57DF_5185(_____4E0B_4E00_6B65X, _____4E0B_4E00_6B65Y) then
                    return {["最终X"] = _____5F53_524DX, ["最终Y"] = _____5F53_524DY, ["实际步数"] = _____5B9E_9645_6B65_6570, ["是否提前停止"] = true}
                end
                _____5F53_524DX = _____4E0B_4E00_6B65X
                _____5F53_524DY = _____4E0B_4E00_6B65Y
                _____5F53_524D_6B65_5DF2_79FB_52A8 = _____5F53_524D_6B65_5DF2_79FB_52A8 + _____672C_6B21_68C0_6D4B_8DDD_79BB
            end
            _____5B9E_9645_6B65_6570 = _____5B9E_9645_6B65_6570 + 1
            i = i + 1
        end
    end
    return {["最终X"] = _____5F53_524DX, ["最终Y"] = _____5F53_524DY, ["实际步数"] = _____5B9E_9645_6B65_6570, ["是否提前停止"] = false}
end
return ____exports
