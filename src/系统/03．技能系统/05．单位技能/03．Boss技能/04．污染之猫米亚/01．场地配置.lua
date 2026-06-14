--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local ____require_result_0 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local RectContainsUnit = ____require_result_0.RectContainsUnit
____exports["米亚安全域配置表"] = {{
    ["名称"] = "安全域1",
    ["左"] = 12672,
    ["右"] = 13056,
    ["下"] = -7104,
    ["上"] = -6720
}, {
    ["名称"] = "安全域2",
    ["左"] = 12096,
    ["右"] = 12480,
    ["下"] = -8064,
    ["上"] = -7680
}, {
    ["名称"] = "安全域3",
    ["左"] = 12928,
    ["右"] = 13312,
    ["下"] = -8704,
    ["上"] = -8320
}, {
    ["名称"] = "安全域4",
    ["左"] = 13824,
    ["右"] = 14208,
    ["下"] = -7232,
    ["上"] = -6848
}}
____exports["米亚平台中心配置"] = {
    ["名称"] = "平台中心",
    ["左"] = 12736,
    ["右"] = 13408,
    ["下"] = -8000,
    ["上"] = -7360
}
____exports["米亚平台中心X"] = (____exports["米亚平台中心配置"]["左"] + ____exports["米亚平台中心配置"]["右"]) / 2
____exports["米亚平台中心Y"] = (____exports["米亚平台中心配置"]["下"] + ____exports["米亚平台中心配置"]["上"]) / 2
____exports["创建米亚安全域矩形组"] = function()
    local result = {}
    do
        local i = 0
        while i < #____exports["米亚安全域配置表"] do
            local config = ____exports["米亚安全域配置表"][i + 1]
            result[#result + 1] = {
                ["配置"] = config,
                ["矩形"] = Rect(config["左"], config["下"], config["右"], config["上"]),
                ["中心X"] = (config["左"] + config["右"]) / 2,
                ["中心Y"] = (config["下"] + config["上"]) / 2
            }
            i = i + 1
        end
    end
    return result
end
____exports["清理米亚安全域矩形组"] = function(rects)
    if rects == nil then
        return
    end
    do
        local i = 0
        while i < #rects do
            local rect = rects[i + 1]["矩形"]
            if rect ~= nil and rect ~= 0 then
                RemoveRect(rect)
                rects[i + 1]["矩形"] = nil
            end
            i = i + 1
        end
    end
end
____exports["米亚点在矩形配置内"] = function(x, y, rect)
    return x >= rect["左"] and x <= rect["右"] and y >= rect["下"] and y <= rect["上"]
end
____exports["米亚单位在安全域内"] = function(unit, rects)
    if unit == nil or unit == 0 then
        return false
    end
    do
        local i = 0
        while i < #rects do
            local rect = rects[i + 1]["矩形"]
            if rect ~= nil and rect ~= 0 and RectContainsUnit(rect, unit) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
____exports["取米亚单位所在安全域"] = function(unit, rects)
    if unit == nil or unit == 0 then
        return nil
    end
    do
        local i = 0
        while i < #rects do
            local rect = rects[i + 1]["矩形"]
            if rect ~= nil and rect ~= 0 and RectContainsUnit(rect, unit) then
                return rects[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
return ____exports
