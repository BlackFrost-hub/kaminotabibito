--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 吟唱条系统 - 数字格式化
local jass = require("jass.common")
local R2I = jass.R2I
____exports["取整小数"] = function(n)
    return R2I(n)
end
____exports["四舍五入到一位小数"] = function(n)
    return R2I(n * 10 + 0.5)
end
____exports["格式化一位小数"] = function(n)
    local _____5341_500D_503C = ____exports["四舍五入到一位小数"](n)
    local _____6574_6570_90E8_5206 = R2I(_____5341_500D_503C / 10)
    local _____5C0F_6570_90E8_5206 = tostring(_____5341_500D_503C - _____6574_6570_90E8_5206 * 10)
    if #_____5C0F_6570_90E8_5206 <= 0 then
        _____5C0F_6570_90E8_5206 = "0"
    end
    return (tostring(_____6574_6570_90E8_5206) .. ".") .. _____5C0F_6570_90E8_5206
end
____exports["格式化已过秒"] = function(_____5DF2_8FC7_65F6_95F4)
    return ____exports["格式化一位小数"](_____5DF2_8FC7_65F6_95F4)
end
____exports["格式化剩余秒"] = function(_____603B_65F6_957F, _____5DF2_8FC7_65F6_95F4)
    local _____5269_4F59 = _____603B_65F6_957F - _____5DF2_8FC7_65F6_95F4
    if _____5269_4F59 < 0 then
        return "0.0"
    end
    return ____exports["格式化一位小数"](_____5269_4F59)
end
return ____exports
