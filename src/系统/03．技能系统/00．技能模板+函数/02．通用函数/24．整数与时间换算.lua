--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 整数与时间换算
-- 
-- 职责单一：为英雄技能层提供明确的取整与秒转毫秒语义，避免各英雄重复写
-- `Math.round(秒 * 1000)` 或本地公式，也避免直接引入 Lua 数学库。
-- 
-- 语义说明：
-- - `jass.R2I` 是向零截断（对正数 = floor，对负数 = ceil 方向）。
-- - 本文件所有取整函数按数学定义实现（四舍五入/向下/向上），正负数均正确。
-- - 秒转毫秒统一使用四舍五入，与阿伦劳特等既有本地实现（R2I(秒*1000+0.5)）语义一致。
local jass = require("jass.common")
local R2I = jass.R2I
--- 四舍五入整数。
-- 正数：R2I(x + 0.5) = floor(x + 0.5)；负数：R2I(x - 0.5) = ceil(x - 0.5)。
-- 例：1.5→2，2.4→2，-1.5→-2，-1.4→-1。
____exports["四舍五入整数"] = function(value)
    return value >= 0 and R2I(value + 0.5) or R2I(value - 0.5)
end
--- 向下取整整数。
-- 正数：R2I = floor；负数且非整数：R2I(value) - 1。
-- 例：2.9→2，-1.5→-2，-2.0→-2。
____exports["向下取整整数"] = function(value)
    local _____622A_65AD = R2I(value)
    if value >= 0 then
        return _____622A_65AD
    end
    return _____622A_65AD == value and _____622A_65AD or _____622A_65AD - 1
end
--- 向上取整整数。
-- 恒等式：ceil(x) = -floor(-x)。
-- 例：2.1→3，-1.5→-1，2.0→2。
____exports["向上取整整数"] = function(value)
    return -____exports["向下取整整数"](-value)
end
--- 秒转毫秒（四舍五入）。
-- 例：0.5→500，0.033→33。
____exports["秒转毫秒"] = function(seconds)
    return ____exports["四舍五入整数"](seconds * 1000)
end
--- 秒转毫秒并保证不小于最小值（默认 0）。
-- 常用于计时器延迟，避免负数或零值导致异常调度；传入 最小值=1 可杜绝零延迟。
____exports["秒转正毫秒"] = function(seconds, _____6700_5C0F_503C)
    if _____6700_5C0F_503C == nil then
        _____6700_5C0F_503C = 0
    end
    local _____6BEB_79D2 = ____exports["秒转毫秒"](seconds)
    return _____6BEB_79D2 < _____6700_5C0F_503C and _____6700_5C0F_503C or _____6BEB_79D2
end
--- 秒数转 Tick 数（按固定驱动间隔毫秒四舍五入）。
-- 仅用于"固定间隔周期回调推进的 Tick 计数"阈值判断（如每秒 10 次 → 周期毫秒=100），
-- 不得用于时间换算；调用方必须先确认周期回调间隔恒定，否则按真实驱动间隔计算。
-- 例：持续秒=8、周期毫秒=100 → 四舍五入(8*1000/100)=80 Tick。
____exports["秒转Tick数"] = function(_____79D2, _____5468_671F_6BEB_79D2)
    return ____exports["四舍五入整数"](_____79D2 * 1000 / _____5468_671F_6BEB_79D2)
end
return ____exports
