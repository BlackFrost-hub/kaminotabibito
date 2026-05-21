--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- FourCC 转换函数
-- 统一转发到安全版，避免不同调用形态下出现 self/nil 错位。
local _____5B89_5168_7248_6A21_5757 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
____exports.stringToFourCC = _____5B89_5168_7248_6A21_5757.stringToFourCCSafe
____exports.fourCCToString = _____5B89_5168_7248_6A21_5757.fourCCToStringSafe
return ____exports
