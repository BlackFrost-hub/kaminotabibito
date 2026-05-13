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
function ____exports.OperatorRealMultiply(value, addValue, multiplier)
    local _____5B89_5168_503C = value or 0
    if not addValue or type(addValue.value) ~= "number" then
        return
    end
    if not multiplier or type(multiplier.value) ~= "number" then
        return
    end
    if _____5B89_5168_503C >= 0 then
        addValue.value = addValue.value + _____5B89_5168_503C
    else
        multiplier.value = multiplier.value * (1 + _____5B89_5168_503C)
    end
end
--- 抗性减伤计算（乘法叠加）
-- 
-- @param resist 抗性值
-- @param multiplier 乘法叠加引用对象
function ____exports.OperatorResistReduction(resist, multiplier)
    local _____5B89_5168_6297_6027 = resist or 0
    if not multiplier or type(multiplier.value) ~= "number" then
        return
    end
    multiplier.value = multiplier.value * (1 - _____5B89_5168_6297_6027)
end
--- 创建可变数值容器
-- 用于传递引用
function ____exports.createValueHolder(initialValue)
    if initialValue == nil then
        initialValue = 0
    end
    return {value = initialValue or 0}
end
--- 四舍五入到最近整数。
function ____exports.round(value)
    local _____5B89_5168_503C = value or 0
    if _____5B89_5168_503C >= 0 then
        return jass.R2I(_____5B89_5168_503C + 0.5)
    end
    return __TS__Number(-jass.R2I(-_____5B89_5168_503C + 0.5))
end
--- 向上取整到整数。
function ____exports.ceil(value)
    local _____5B89_5168_503C = value or 0
    local truncated = jass.R2I(_____5B89_5168_503C)
    if _____5B89_5168_503C > 0 and truncated < _____5B89_5168_503C then
        return truncated + 1
    end
    return truncated
end
function ____exports.clampMin(value, minValue)
    local _____5B89_5168_6700_5C0F_503C = minValue or 0
    local _____5B89_5168_503C = value or _____5B89_5168_6700_5C0F_503C
    return _____5B89_5168_503C < _____5B89_5168_6700_5C0F_503C and _____5B89_5168_6700_5C0F_503C or _____5B89_5168_503C
end
function ____exports.clampRange(value, minValue, maxValue)
    local _____5B89_5168_6700_5C0F_503C = minValue or 0
    local _____5B89_5168_6700_5927_503C = maxValue or _____5B89_5168_6700_5C0F_503C
    local _____5B89_5168_503C = value or _____5B89_5168_6700_5C0F_503C
    if _____5B89_5168_503C < _____5B89_5168_6700_5C0F_503C then
        return _____5B89_5168_6700_5C0F_503C
    end
    if _____5B89_5168_503C > _____5B89_5168_6700_5927_503C then
        return _____5B89_5168_6700_5927_503C
    end
    return _____5B89_5168_503C
end
function ____exports.max(a, b)
    local _____5B89_5168A = a or 0
    local _____5B89_5168B = b or 0
    return _____5B89_5168A >= _____5B89_5168B and _____5B89_5168A or _____5B89_5168B
end
function ____exports.min(a, b)
    local _____5B89_5168A = a or 0
    local _____5B89_5168B = b or 0
    return _____5B89_5168A <= _____5B89_5168B and _____5B89_5168A or _____5B89_5168B
end
return ____exports
