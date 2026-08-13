--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 格式化工具函数
-- 数字格式化、字符串处理等
local jass = require("jass.common")
--- 格式化数字
-- 规则：≥10 取整数，<10 保留1位小数
-- 
-- @param num 要格式化的数字
-- @returns 格式化后的字符串
function ____exports.formatNumber(self, num)
    if num >= 10 then
        return tostring(
            nil,
            jass:R2I(num)
        )
    else
        return tostring(
            nil,
            jass:R2I(num * 10) / 10
        )
    end
end
--- 格式化数字保留指定小数位
-- 
-- @param num 要格式化的数字
-- @param decimals 小数位数
-- @returns 格式化后的字符串
function ____exports.formatNumberDecimals(self, num, decimals)
    local multiplier = jass:Pow(10, decimals)
    return tostring(
        nil,
        jass:R2I(num * multiplier) / multiplier
    )
end
--- 格式化百分比
-- 
-- @param value 百分比值（0.15 表示 15%）
-- @returns 格式化后的字符串（如 "15%"）
function ____exports.formatPercent(self, value)
    return ____exports.formatNumber(nil, value * 100) .. "%"
end
return ____exports
