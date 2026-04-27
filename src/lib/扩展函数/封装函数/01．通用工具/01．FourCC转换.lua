--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 将 4 字符字符串转换为 FourCC 数字（用于物品/单位 ID）
function ____exports.stringToFourCC(self, s)
    local b1 = string:byte(s, 1)
    local b2 = string:byte(s, 2)
    local b3 = string:byte(s, 3)
    local b4 = string:byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
--- 将 FourCC 数字转换为 4 字符字符串
function ____exports.fourCCToString(self, fourcc)
    local c1 = string:char(fourcc % 256)
    local c2 = string:char(math.floor(fourcc / 256) % 256)
    local c3 = string:char(math.floor(fourcc / 65536) % 256)
    local c4 = string:char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
return ____exports
