local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- 数值漂浮文字
-- 
-- 目标：替代旧 JASS CombatNumbers 的 STES/YDLocal 写法。
-- - 直接 TS/Lua 调用，不走 STES。
-- - 默认跳过 0。
-- - 支持正负号、后缀、小数位。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字")
local CreateFloatTextOnUnit = ____require_result_0.CreateFloatTextOnUnit
local CreateFloatTextAtPoint = ____require_result_0.CreateFloatTextAtPoint
local R2I = jass.R2I
local _____9ED8_8BA4_6B63_6570_989C_8272_7EA2 = 100
local _____9ED8_8BA4_6B63_6570_989C_8272_7EFF = 255
local _____9ED8_8BA4_6B63_6570_989C_8272_84DD = 100
local _____9ED8_8BA4_8D1F_6570_989C_8272_7EA2 = 255
local _____9ED8_8BA4_8D1F_6570_989C_8272_7EFF = 80
local _____9ED8_8BA4_8D1F_6570_989C_8272_84DD = 80
local _____9ED8_8BA4_5927_5C0F = 10
local _____9ED8_8BA4_6301_7EED_65F6_95F4 = 1
local _____9ED8_8BA4_4E0A_98D8_901F_5EA6 = 0.07
local _____6700_5927_5C0F_6570_4F4D_6570 = 4
local function _____6570_5B57_8F6C_5B57_7B26_4E32(value)
    return tostring(nil, value)
end
local function _____9650_5236_5C0F_6570_4F4D_6570(decimalPlaces)
    if decimalPlaces <= 0 then
        return 0
    end
    if decimalPlaces > _____6700_5927_5C0F_6570_4F4D_6570 then
        return _____6700_5927_5C0F_6570_4F4D_6570
    end
    return R2I(decimalPlaces)
end
local function _____5341_7684_6574_6570_6B21_65B9(count)
    local result = 1
    do
        local i = 0
        while i < count do
            result = result * 10
            i = i + 1
        end
    end
    return result
end
local function _____7EDD_5BF9_503C(value)
    return value < 0 and -value or value
end
local function _____8865_9F50_5C0F_6570_4F4D(value, places)
    local text = _____6570_5B57_8F6C_5B57_7B26_4E32(value)
    while #text < places do
        text = "0" .. text
    end
    return text
end
____exports["格式化数值漂浮文字"] = function(value, options)
    local _____540E_7F00 = options and options["后缀"] or options and options.suffix or ""
    local ____temp_9 = options and options["显示正号"]
    if ____temp_9 == nil then
        ____temp_9 = options and options.showPlus
    end
    local ____temp_9_10 = ____temp_9
    if ____temp_9_10 == nil then
        ____temp_9_10 = true
    end
    local _____663E_793A_6B63_53F7 = ____temp_9_10
    local _____5C0F_6570_4F4D_6570 = _____9650_5236_5C0F_6570_4F4D_6570(options and options["小数位数"] or options and options.decimalPlaces or 0)
    local sign = value < 0 and "-" or (_____663E_793A_6B63_53F7 and "+" or "")
    local absValue = _____7EDD_5BF9_503C(value)
    if _____5C0F_6570_4F4D_6570 <= 0 then
        return (sign .. _____6570_5B57_8F6C_5B57_7B26_4E32(R2I(absValue))) .. _____540E_7F00
    end
    local scale = _____5341_7684_6574_6570_6B21_65B9(_____5C0F_6570_4F4D_6570)
    local scaled = R2I(absValue * scale + 0.5)
    local integerPart = R2I(scaled / scale)
    local decimalPart = scaled - integerPart * scale
    return (((sign .. _____6570_5B57_8F6C_5B57_7B26_4E32(integerPart)) .. ".") .. _____8865_9F50_5C0F_6570_4F4D(decimalPart, _____5C0F_6570_4F4D_6570)) .. _____540E_7F00
end
local function _____53D6_6570_503C_6F02_6D6E_6587_5B57_6837_5F0F(options)
    local isNegative = options["数值"] < 0
    return {
        size = options["大小"] or options.size or _____9ED8_8BA4_5927_5C0F,
        red = options["红"] or options.red or (isNegative and _____9ED8_8BA4_8D1F_6570_989C_8272_7EA2 or _____9ED8_8BA4_6B63_6570_989C_8272_7EA2),
        green = options["绿"] or options.green or (isNegative and _____9ED8_8BA4_8D1F_6570_989C_8272_7EFF or _____9ED8_8BA4_6B63_6570_989C_8272_7EFF),
        blue = options["蓝"] or options.blue or (isNegative and _____9ED8_8BA4_8D1F_6570_989C_8272_84DD or _____9ED8_8BA4_6B63_6570_989C_8272_84DD),
        alpha = options["透明度"] or options.alpha or 0,
        duration = options["持续时间"] or options.duration or _____9ED8_8BA4_6301_7EED_65F6_95F4,
        speedX = options.speedX or 0,
        speedY = options["上飘速度"] or options.speedY or _____9ED8_8BA4_4E0A_98D8_901F_5EA6,
        height = options["高度"] or options.height or 0
    }
end
____exports["显示数值漂浮文字"] = function(options)
    local ____options__96F6_503C_9690_85CF_15 = options["零值隐藏"]
    if ____options__96F6_503C_9690_85CF_15 == nil then
        ____options__96F6_503C_9690_85CF_15 = options.hideZero
    end
    local ____options__96F6_503C_9690_85CF_15_16 = ____options__96F6_503C_9690_85CF_15
    if ____options__96F6_503C_9690_85CF_15_16 == nil then
        ____options__96F6_503C_9690_85CF_15_16 = true
    end
    local _____96F6_503C_9690_85CF = ____options__96F6_503C_9690_85CF_15_16
    if _____96F6_503C_9690_85CF and options["数值"] == 0 then
        return nil
    end
    local text = ____exports["格式化数值漂浮文字"](options["数值"], options)
    local style = _____53D6_6570_503C_6F02_6D6E_6587_5B57_6837_5F0F(options)
    local ____options__5355_4F4D_17 = options["单位"]
    if ____options__5355_4F4D_17 == nil then
        ____options__5355_4F4D_17 = options.unit
    end
    local unit = ____options__5355_4F4D_17
    if unit ~= nil and unit ~= 0 then
        return CreateFloatTextOnUnit(unit, text, style)
    end
    local x = options.X or options.x or 0
    local y = options.Y or options.y or 0
    return CreateFloatTextAtPoint(x, y, text, style)
end
____exports["显示单位数值漂浮文字"] = function(unit, value, options)
    return ____exports["显示数值漂浮文字"](__TS__ObjectAssign({}, options or ({}), {["单位"] = unit, ["数值"] = value}))
end
____exports["显示坐标数值漂浮文字"] = function(x, y, value, options)
    return ____exports["显示数值漂浮文字"](__TS__ObjectAssign({}, options or ({}), {X = x, Y = y, ["数值"] = value}))
end
return ____exports
