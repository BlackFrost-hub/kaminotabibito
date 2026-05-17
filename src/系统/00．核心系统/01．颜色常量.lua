local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- 重置代码
____exports.COLOR = {RESET = "|r"}
--- 装备等级颜色映射
local _____88C5_5907_7B49_7EA7_989C_8272_6620_5C04 = {
    ["E-"] = "|cffC0C0C0",
    E = "|cffFFFFFF",
    ["D-"] = "|cff3399FF",
    D = "|cff0070DD",
    ["D+"] = "|cff0070DD",
    ["D++"] = "|cff800080",
    ["C-"] = "|cffA335EE",
    C = "|cffA335EE",
    ["C+"] = "|cffA335EE",
    ["C++"] = "|cffFF8000",
    ["B-"] = "|cffFF8000",
    B = "|cffFF8000",
    ["B+"] = "|cffFFD700",
    ["B++"] = "|cffFF0000",
    A = "|cffFF0000",
    ["A+"] = "|cffFF66CC",
    ["A++"] = "|cff66FFFF",
    S = "|cff00FFFF",
    SS = "|cff00FFCC",
    SSS = "|cffFF66FF"
}
local _____5F69_8679_989C_8272_5E8F_5217 = {
    "|cffFF0000",
    "|cffFF8000",
    "|cffFFD700",
    "|cff00FF00",
    "|cff00FFFF",
    "|cff3399FF",
    "|cffCC66FF"
}
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
--- 装备等级取颜色代码
____exports["装备等级颜色代码"] = function(____, level)
    return _____88C5_5907_7B49_7EA7_989C_8272_6620_5C04[level] or "|cffFFFFFF"
end
--- 装备等级文本着色
____exports["装备等级颜色文本"] = function(____, text, level)
    return (____exports["装备等级颜色代码"](nil, level) .. text) .. ____exports.COLOR.RESET
end
--- 去掉文本中的颜色代码，保留纯文字与换行控制
____exports["去除颜色代码"] = function(____, text)
    if text == nil or text == "" then
        return ""
    end
    local result = ""
    local i = 0
    while i < #text do
        do
            if __TS__StringSubstring(text, i, i + 2) == "|r" then
                i = i + 2
                goto __continue8
            end
            if __TS__StringSubstring(text, i, i + 2) == "|c" and i + 10 <= #text then
                i = i + 10
                goto __continue8
            end
            result = result .. __TS__StringSubstring(text, i, i + 1)
            i = i + 1
        end
        ::__continue8::
    end
    return result
end
--- 是否为彩色显示的高阶等级
____exports["是否彩虹装备等级"] = function(____, level)
    return level == "S" or level == "SS" or level == "SSS"
end
--- 逐字彩色文本
____exports["彩虹颜色文本"] = function(____, text)
    local plainText = ____exports["去除颜色代码"](nil, text)
    if plainText == "" then
        return ""
    end
    local result = ""
    local colorIndex = 0
    local i = 0
    while i < #plainText do
        local char = __TS__StringSubstring(plainText, i, i + 1)
        if char ~= " " and char ~= "『" and char ~= "』" and char ~= "《" and char ~= "》" and char ~= "（" and char ~= "）" and char ~= "[" and char ~= "]" then
            result = result .. (_____5F69_8679_989C_8272_5E8F_5217[colorIndex % #_____5F69_8679_989C_8272_5E8F_5217 + 1] .. char) .. ____exports.COLOR.RESET
            colorIndex = colorIndex + 1
        else
            result = result .. char
        end
        i = i + 1
    end
    return result
end
--- 装备等级显示文本
____exports["装备等级显示文本"] = function(____, text, level)
    if ____exports["是否彩虹装备等级"](nil, level) then
        return ____exports["彩虹颜色文本"](nil, text)
    end
    return ____exports["装备等级颜色文本"](nil, text, level)
end
--- 按装备等级给物品名着色
____exports["装备名字颜色文本"] = function(____, text, level)
    local plainText = ____exports["去除颜色代码"](nil, text)
    if ____exports["是否彩虹装备等级"](nil, level) then
        return ____exports["彩虹颜色文本"](nil, plainText)
    end
    return ____exports["装备等级颜色文本"](nil, plainText, level)
end
return ____exports
