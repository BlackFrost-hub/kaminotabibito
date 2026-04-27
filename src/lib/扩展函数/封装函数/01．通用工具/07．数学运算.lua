local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- 数学运算工具函数
-- 加法/乘法叠加等通用计算
local jass = require("jass.common")
--- 加法/乘法叠加计算
-- 正数：加法叠加（累加到 addValue）
-- 负数：乘法叠加（累乘到 multiplier）
-- 
-- @param value 属性值
-- @param addValue 加法叠加引用对象
-- @param multiplier 乘法叠加引用对象
function ____exports.OperatorRealMultiply(self, value, addValue, multiplier)
    if value >= 0 then
        addValue.value = addValue.value + value
    else
        multiplier.value = multiplier.value * (1 + value)
    end
end
--- 抗性减伤计算（乘法叠加）
-- 
-- @param resist 抗性值
-- @param multiplier 乘法叠加引用对象
function ____exports.OperatorResistReduction(self, resist, multiplier)
    multiplier.value = multiplier.value * (1 - resist)
end
--- 创建可变数值容器
-- 用于传递引用
function ____exports.createValueHolder(self, initialValue)
    if initialValue == nil then
        initialValue = 0
    end
    return {value = initialValue}
end
--- 四舍五入到最近整数。
function ____exports.round(self, value)
    if value >= 0 then
        return jass.R2I(value + 0.5)
    end
    return __TS__Number(-jass.R2I(-value + 0.5))
end
--- 向上取整到整数。
function ____exports.ceil(self, value)
    local truncated = jass.R2I(value)
    if value > 0 and truncated < value then
        return truncated + 1
    end
    return truncated
end
function ____exports.clampMin(self, value, minValue)
    return value < minValue and minValue or value
end
function ____exports.clampRange(self, value, minValue, maxValue)
    if value < minValue then
        return minValue
    end
    if value > maxValue then
        return maxValue
    end
    return value
end
function ____exports.max(self, a, b)
    return a >= b and a or b
end
function ____exports.min(self, a, b)
    return a <= b and a or b
end
return ____exports
