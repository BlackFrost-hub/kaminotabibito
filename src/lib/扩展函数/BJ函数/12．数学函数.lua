local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local jass = require("jass.common")
local DEFAULT_BJ_PI = 3.141592653589793
local DEFAULT_BJ_RADTODEG = 180 / DEFAULT_BJ_PI
local DEFAULT_BJ_DEGTORAD = DEFAULT_BJ_PI / 180
--- 与 Blizzard.j `bj_PI` 对齐的工程常量
local BJ_PI = DEFAULT_BJ_PI
--- 弧度 → 角度乘数（Blizzard.j `bj_RADTODEG` = 180/bj_PI）
local BJ_RADTODEG = DEFAULT_BJ_RADTODEG
--- 角度 → 弧度乘数（Blizzard.j `bj_DEGTORAD` = bj_PI/180）
local BJ_DEGTORAD = DEFAULT_BJ_DEGTORAD
--- 余弦（角度）
function ____exports.CosBJ(self, degrees)
    return jass.Cos(degrees * BJ_DEGTORAD)
end
--- 正弦（角度）
function ____exports.SinBJ(self, degrees)
    return jass.Sin(degrees * BJ_DEGTORAD)
end
--- 正切（角度）
function ____exports.TanBJ(self, degrees)
    local rad = degrees * BJ_DEGTORAD
    return jass.Sin(rad) / jass.Cos(rad)
end
--- 反余弦（返回角度）
function ____exports.AcosBJ(self, value)
    return jass.Acos(value) * BJ_RADTODEG
end
--- 反正弦（返回角度）
function ____exports.AsinBJ(self, value)
    return jass.Asin(value) * BJ_RADTODEG
end
--- 反正切（返回角度）
function ____exports.AtanBJ(self, value)
    return jass.Atan(value) * BJ_RADTODEG
end
--- 反正切2（返回角度）
function ____exports.Atan2BJ(self, y, x)
    return jass.Atan2(y, x) * BJ_RADTODEG
end
--- 实数绝对值 - RAbsBJ
function ____exports.RAbsBJ(self, a)
    return a < 0 and -a or a
end
--- 实数符号 - RSignBJ（返回 ±1）
function ____exports.RSignBJ(self, a)
    return a < 0 and -1 or (a > 0 and 1 or 0)
end
--- 整数绝对值 - IAbsBJ
function ____exports.IAbsBJ(self, a)
    local ia = jass.R2I(a)
    return ia < 0 and __TS__Number(-ia) or ia
end
--- 整数符号 - ISignBJ（返回 ±1）
function ____exports.ISignBJ(self, a)
    local ia = jass.R2I(a)
    return ia < 0 and -1 or (ia > 0 and 1 or 0)
end
--- 随机百分比 (0-100) - GetRandomPercentageBJ
function ____exports.GetRandomPercentageBJ(self)
    return jass.GetRandomReal(0, 100)
end
--- 整数取模 - ModuloInteger
function ____exports.ModuloInteger(self, dividend, divisor)
    local d = jass.R2I(divisor)
    if d == 0 then
        return 0
    end
    return jass.R2I(dividend) % d
end
--- 实数取模 - ModuloReal
function ____exports.ModuloReal(self, dividend, divisor)
    if divisor == 0 then
        return 0
    end
    return dividend % divisor
end
--- 两点之间角度 - AngleBetweenPoints（返回角度）
-- 对应 Blizzard.j: AngleBetweenPoints
function ____exports.AngleBetweenPoints(self, locA, locB)
    if locA == nil or locB == nil then
        return 0
    end
    local dx = jass.GetLocationX(locB) - jass.GetLocationX(locA)
    local dy = jass.GetLocationY(locB) - jass.GetLocationY(locA)
    return jass.Atan2(dy, dx) * BJ_RADTODEG
end
--- 两点之间距离 - DistanceBetweenPoints
-- 对应 Blizzard.j: DistanceBetweenPoints
function ____exports.DistanceBetweenPoints(self, locA, locB)
    if locA == nil or locB == nil then
        return 0
    end
    local dx = jass.GetLocationX(locB) - jass.GetLocationX(locA)
    local dy = jass.GetLocationY(locB) - jass.GetLocationY(locA)
    return jass.SquareRoot(dx * dx + dy * dy)
end
--- 整数最大值 - IMaxBJ
function ____exports.IMaxBJ(self, a, b)
    return a >= b and a or b
end
--- 整数最小值 - IMinBJ
function ____exports.IMinBJ(self, a, b)
    return a <= b and a or b
end
--- 实数最大值 - RMaxBJ
function ____exports.RMaxBJ(self, a, b)
    return a < b and b or a
end
--- 实数最小值 - RMinBJ
function ____exports.RMinBJ(self, a, b)
    return a < b and a or b
end
--- 百分比转整数 - PercentToInt
function ____exports.PercentToInt(self, percentage, max)
    return jass.R2I(percentage * 0.01 * max)
end
--- 百分比转255 - PercentTo255
function ____exports.PercentTo255(self, percentage)
    return ____exports.PercentToInt(nil, percentage, 255)
end
return ____exports
