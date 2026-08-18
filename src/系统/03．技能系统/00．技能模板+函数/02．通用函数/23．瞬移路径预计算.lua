--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local IsTerrainPathable = jass.IsTerrainPathable
local PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
--- 沿角度缓步模拟路径，返回最终可瞬移落点。
-- 
-- @param startX 起点X
-- @param startY 起点Y
-- @param 角度 前进方向（BJ 角度制，与 两点角度 同口径）
-- @param 步长 每步前进距离
-- @param 最大步数 最多模拟步数（步长×最大步数 = 最大路径长度）
____exports["计算瞬移路径"] = function(startX, startY, _____89D2_5EA6, _____6B65_957F, _____6700_5927_6B65_6570)
    local _____5F27_5EA6 = _____89D2_5EA6 * (3.14159265358979 / 180)
    local dx = _____6B65_957F * math.cos(_____5F27_5EA6)
    local dy = _____6B65_957F * math.sin(_____5F27_5EA6)
    local _____5F53_524DX = startX
    local _____5F53_524DY = startY
    do
        local i = 1
        while i <= _____6700_5927_6B65_6570 do
            local _____4E0B_4E00_6B65X = _____5F53_524DX + dx
            local _____4E0B_4E00_6B65Y = _____5F53_524DY + dy
            if IsTerrainPathable(_____4E0B_4E00_6B65X, _____4E0B_4E00_6B65Y, PATHING_TYPE_WALKABILITY) then
                return {X = _____5F53_524DX, Y = _____5F53_524DY, ["撞墙"] = true, ["实际步数"] = i - 1}
            end
            _____5F53_524DX = _____4E0B_4E00_6B65X
            _____5F53_524DY = _____4E0B_4E00_6B65Y
            i = i + 1
        end
    end
    return {X = _____5F53_524DX, Y = _____5F53_524DY, ["撞墙"] = false, ["实际步数"] = _____6700_5927_6B65_6570}
end
--- 坐标是否可步行通行（单点快速判定）
____exports["坐标可步行通行"] = function(x, y)
    return not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end
return ____exports
