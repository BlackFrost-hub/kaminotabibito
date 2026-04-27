--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- FourCC 转换函数
-- 用于物品/单位 ID 的字符串与数字转换
local jass = require("jass.common")
--- 将 4 字符字符串转换为 FourCC 数字（用于物品/单位 ID）
function ____exports.stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
--- 将 FourCC 数字转换为 4 字符字符串
function ____exports.fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(jass.R2I(fourcc / 256) % 256)
    local c3 = string.char(jass.R2I(fourcc / 65536) % 256)
    local c4 = string.char(jass.R2I(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
return ____exports
