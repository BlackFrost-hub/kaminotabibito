--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
return ____exports
