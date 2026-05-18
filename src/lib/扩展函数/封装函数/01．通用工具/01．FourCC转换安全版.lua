--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- FourCC 安全封装版
-- 
-- 用于 `@noSelfInFile` 文件，避免直接挂载/调用原始导出时引入 self 形态风险。
local jass = require("jass.common")
local R2I = jass.R2I
local stringByte = string.byte
local stringChar = string.char
--- 将 4 字符字符串转换为 FourCC 数值。
function ____exports.stringToFourCCSafe(s)
    if not s or #s < 4 then
        return 0
    end
    local b1 = stringByte(s, 1)
    local b2 = stringByte(s, 2)
    local b3 = stringByte(s, 3)
    local b4 = stringByte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
--- 将 FourCC 数值转换为 4 字符字符串。
function ____exports.fourCCToStringSafe(fourcc)
    local c1 = stringChar(fourcc % 256)
    local c2 = stringChar(R2I(fourcc / 256) % 256)
    local c3 = stringChar(R2I(fourcc / 65536) % 256)
    local c4 = stringChar(R2I(fourcc / 16777216) % 256)
    return ((tostring(c4) .. tostring(c3)) .. tostring(c2)) .. tostring(c1)
end
____exports.stringToFourCC = ____exports.stringToFourCCSafe
____exports.fourCCToString = ____exports.fourCCToStringSafe
____exports["字符串转FourCC安全版"] = ____exports.stringToFourCCSafe
____exports["FourCC转字符串安全版"] = ____exports.fourCCToStringSafe
return ____exports
