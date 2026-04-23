--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- KK扩展API - 工具函数
local japi = require("jass.japi")
--- 计算ARGB颜色值
-- 
-- @param a 透明度 (0-255)
-- @param r 红色 (0-255)
-- @param g 绿色 (0-255)
-- @param b 蓝色 (0-255)
-- @returns ARGB颜色整数
function ____exports.DzGetColor2(self, a, r, g, b)
    return 16777216 * a + 65536 * r + 256 * g + b
end
--- 打开QQ群链接
-- 
-- @param url QQ群链接
-- @returns 是否成功打开
function ____exports.DzOpenQQGroupUrl(self, url)
    return japi.DzOpenQQGroupUrl(url) or false
end
return ____exports
