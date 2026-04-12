--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 重置代码
____exports.COLOR = {RESET = "|r"}
--- 品质颜色映射
local QUALITY_COLORS = {
    common = "|cffffffff",
    uncommon = "|cff1eff00",
    rare = "|cff0070dd",
    epic = "|cffa335ee",
    legendary = "|cffff8000",
    mythic = "|cffe6cc80"
}
--- 元素颜色映射
local ELEMENT_COLORS = {
    fire = "|cffff4444",
    ice = "|cff44ffff",
    lightning = "|cffffd700",
    poison = "|cff44ff44",
    dark = "|cff8800ff",
    light = "|cfffff8dc",
    earth = "|cff8b4513",
    wind = "|cff40e0d0"
}
--- 品质颜色快捷函数
function ____exports.qualityColor(self, text, quality)
    return (QUALITY_COLORS[quality] .. text) .. ____exports.COLOR.RESET
end
--- 元素颜色快捷函数
function ____exports.elementColor(self, text, element)
    return (ELEMENT_COLORS[element] .. text) .. ____exports.COLOR.RESET
end
return ____exports
