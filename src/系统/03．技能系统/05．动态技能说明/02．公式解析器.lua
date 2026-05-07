local ____lualib = require("lualib_bundle")
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__StringSubstr = ____lualib.__TS__StringSubstr
local __TS__StringSlice = ____lualib.__TS__StringSlice
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local parseExpression, parseNumber, parseFactor, parseTerm, parseAddSub, parsePos, parseExpr
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.05．动态技能说明.00．常量定义")
local OPERATOR_MULTIPLY_CN = ____00_FF0E_5E38_91CF_5B9A_4E49.OPERATOR_MULTIPLY_CN
local OPERATOR_DIVIDE_CN = ____00_FF0E_5E38_91CF_5B9A_4E49.OPERATOR_DIVIDE_CN
local OPERATOR_MULTIPLY_EN = ____00_FF0E_5E38_91CF_5B9A_4E49.OPERATOR_MULTIPLY_EN
local OPERATOR_DIVIDE_EN = ____00_FF0E_5E38_91CF_5B9A_4E49.OPERATOR_DIVIDE_EN
local DECIMAL_MULTIPLIER = ____00_FF0E_5E38_91CF_5B9A_4E49.DECIMAL_MULTIPLIER
--- 检查字符是否为数字
function ____exports.isDigit(self, c)
    return c >= "0" and c <= "9"
end
function parseExpression(self, expr)
    parsePos = 0
    parseExpr = expr
    return parseAddSub(nil)
end
function parseNumber(self)
    local start = parsePos
    while parsePos < #parseExpr and (__TS__StringAccess(parseExpr, parsePos) == "." or ____exports.isDigit(
        nil,
        __TS__StringAccess(parseExpr, parsePos)
    )) do
        parsePos = parsePos + 1
    end
    local numStr = __TS__StringSlice(parseExpr, start, parsePos)
    return __TS__ParseFloat(numStr) or 0
end
function parseFactor(self)
    if parsePos >= #parseExpr then
        return 0
    end
    if __TS__StringAccess(parseExpr, parsePos) == "(" then
        parsePos = parsePos + 1
        local result = parseTerm(nil)
        if parsePos < #parseExpr and __TS__StringAccess(parseExpr, parsePos) == ")" then
            parsePos = parsePos + 1
        end
        return result
    end
    if __TS__StringAccess(parseExpr, parsePos) == "+" or __TS__StringAccess(parseExpr, parsePos) == "-" then
        local sign = __TS__StringAccess(parseExpr, parsePos) == "+" and 1 or -1
        parsePos = parsePos + 1
        return sign * parseFactor(nil)
    end
    return parseNumber(nil)
end
function parseTerm(self)
    local result = parseFactor(nil)
    while parsePos < #parseExpr and (__TS__StringAccess(parseExpr, parsePos) == OPERATOR_MULTIPLY_EN or __TS__StringAccess(parseExpr, parsePos) == OPERATOR_DIVIDE_EN) do
        local op = __TS__StringAccess(parseExpr, parsePos)
        parsePos = parsePos + 1
        local right = parseFactor(nil)
        result = op == OPERATOR_MULTIPLY_EN and result * right or result / right
    end
    return result
end
function parseAddSub(self)
    local result = parseTerm(nil)
    while parsePos < #parseExpr and (__TS__StringAccess(parseExpr, parsePos) == "+" or __TS__StringAccess(parseExpr, parsePos) == "-") do
        local op = __TS__StringAccess(parseExpr, parsePos)
        parsePos = parsePos + 1
        local right = parseTerm(nil)
        result = op == "+" and result + right or result - right
    end
    return result
end
--- 动态技能说明系统 - 公式解析器
-- 
-- 提供安全的数学表达式解析和计算功能
-- 支持：+ - * / × ÷ ( ) 和数字
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local round = ____require_result_0.round
--- 移除字符串中的所有空格
function ____exports.removeAllSpaces(self, s)
    local result = ""
    do
        local i = 0
        while i < #s do
            local c = __TS__StringAccess(s, i)
            if c ~= " " and c ~= "\t" and c ~= "\n" and c ~= "\r" then
                result = result .. c
            end
            i = i + 1
        end
    end
    return result
end
--- 检查表达式是否只包含合法字符
function ____exports.isValidExpression(self, expr)
    do
        local i = 0
        while i < #expr do
            local c = __TS__StringAccess(expr, i)
            if not ____exports.isDigit(nil, c) and c ~= "." and c ~= "+" and c ~= "-" and c ~= OPERATOR_MULTIPLY_EN and c ~= OPERATOR_DIVIDE_EN and c ~= OPERATOR_MULTIPLY_CN and c ~= OPERATOR_DIVIDE_CN and c ~= "(" and c ~= ")" then
                return false
            end
            i = i + 1
        end
    end
    return true
end
--- 标准化表达式：将 × ÷ 转换为 * /
function ____exports.normalizeExpression(self, expr)
    local result = ""
    do
        local i = 0
        while i < #expr do
            local c = __TS__StringAccess(expr, i)
            if c == OPERATOR_MULTIPLY_CN or c == "×" then
                result = result .. OPERATOR_MULTIPLY_EN
            elseif c == OPERATOR_DIVIDE_CN or c == "÷" then
                result = result .. OPERATOR_DIVIDE_EN
            else
                result = result .. c
            end
            i = i + 1
        end
    end
    return result
end
--- 全局替换字符串
function ____exports.replaceAll(self, str, search, replace)
    local result = ""
    local i = 0
    while i < #str do
        if __TS__StringSubstr(str, i, #search) == search then
            result = result .. replace
            i = i + #search
        else
            result = result .. __TS__StringAccess(str, i)
            i = i + 1
        end
    end
    return result
end
--- 查找字符在字符串中的位置
function ____exports.indexOfChar(self, str, char, start)
    if start == nil then
        start = 0
    end
    do
        local i = start
        while i < #str do
            if __TS__StringAccess(str, i) == char then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
parsePos = 0
parseExpr = ""
--- 安全的数学表达式求值
function ____exports.safeEval(self, expr)
    expr = ____exports.removeAllSpaces(nil, expr)
    expr = ____exports.normalizeExpression(nil, expr)
    if not ____exports.isValidExpression(nil, expr) then
        return 0
    end
    return parseExpression(nil, expr)
end
--- 格式化数字：整数不显示小数，浮点数最多2位
function ____exports.formatNumber(self, value)
    if not __TS__NumberIsFinite(__TS__Number(value)) then
        return "0"
    end
    local intValue = jass.R2I(value)
    if intValue == value then
        return tostring(intValue)
    end
    local rounded = round(value * DECIMAL_MULTIPLIER) / DECIMAL_MULTIPLIER
    local intRounded = jass.R2I(rounded)
    if intRounded == rounded then
        return tostring(intRounded)
    end
    return tostring(rounded)
end
return ____exports
