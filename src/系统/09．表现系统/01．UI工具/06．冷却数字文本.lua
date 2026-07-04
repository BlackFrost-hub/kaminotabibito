--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameShow = japi.DzFrameShow
____exports["冷却数字字体"] = "UI\\uizt.ttf"
____exports["冷却数字白金颜色码"] = "fffff2d8"
____exports["冷却数字阴影颜色码"] = "ff101010"
____exports["技能冷却数字层"] = {{
    ["后缀"] = "Shadow",
    ["偏移X"] = -0.0012,
    ["偏移Y"] = -0.0012,
    ["颜色码"] = ____exports["冷却数字阴影颜色码"],
    r = 16,
    g = 16,
    b = 16,
    a = 255,
    ["优先级偏移"] = -1
}, {
    ["后缀"] = "Text",
    ["偏移X"] = 0,
    ["偏移Y"] = 0,
    ["颜色码"] = ____exports["冷却数字白金颜色码"],
    r = 255,
    g = 242,
    b = 216,
    a = 255,
    ["优先级偏移"] = 0
}}
____exports["英雄栏冷却数字层"] = {
    {
        ["后缀"] = "BottomShadow",
        ["偏移X"] = 0.0014,
        ["偏移Y"] = -0.0018,
        ["颜色码"] = "ff080808",
        r = 8,
        g = 8,
        b = 8,
        a = 255,
        ["优先级偏移"] = -2
    },
    {
        ["后缀"] = "LeftOutline",
        ["偏移X"] = -0.0011,
        ["偏移Y"] = 0,
        ["颜色码"] = "ff3a2a18",
        r = 58,
        g = 42,
        b = 24,
        a = 255,
        ["优先级偏移"] = -1
    },
    {
        ["后缀"] = "RightOutline",
        ["偏移X"] = 0.0011,
        ["偏移Y"] = 0,
        ["颜色码"] = "ff3a2a18",
        r = 58,
        g = 42,
        b = 24,
        a = 255,
        ["优先级偏移"] = -1
    },
    {
        ["后缀"] = "Shadow",
        ["偏移X"] = -0.0014,
        ["偏移Y"] = -0.0014,
        ["颜色码"] = ____exports["冷却数字阴影颜色码"],
        r = 16,
        g = 16,
        b = 16,
        a = 255,
        ["优先级偏移"] = -1
    },
    {
        ["后缀"] = "Text",
        ["偏移X"] = 0,
        ["偏移Y"] = 0,
        ["颜色码"] = ____exports["冷却数字白金颜色码"],
        r = 255,
        g = 242,
        b = 216,
        a = 255,
        ["优先级偏移"] = 0
    }
}
local function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
____exports["包装冷却数字颜色"] = function(text, _____989C_8272_7801)
    if text == "" then
        return ""
    end
    if _____989C_8272_7801 == "" then
        return text
    end
    return (("|c" .. _____989C_8272_7801) .. text) .. "|r"
end
____exports["创建冷却数字文本组"] = function(_____914D_7F6E)
    local _____7236_7EA7 = _____914D_7F6E["父级"] or DzGetGameUI()
    if not _____53E5_67C4_6709_6548(_____7236_7EA7) then
        return nil
    end
    local _____5BBD_5EA6 = _____914D_7F6E["宽度"] or 0.042
    local _____9AD8_5EA6 = _____914D_7F6E["高度"] or 0.02
    local _____5B57_4F53_5927_5C0F = _____914D_7F6E["字体大小"] or 0.02
    local _____4F18_5148_7EA7 = _____914D_7F6E["优先级"] or 9001
    local _____5BF9_9F50 = _____914D_7F6E["对齐"] or 8
    local _____5C42_5217_8868 = _____914D_7F6E["层"] or ____exports["技能冷却数字层"]
    local _____6846_4F53_5217_8868 = {}
    do
        local i = 0
        while i < #_____5C42_5217_8868 do
            local _____5C42 = _____5C42_5217_8868[i + 1]
            local frame = DzCreateFrameByTagName(
                "TEXT",
                _____914D_7F6E["名称前缀"] .. _____5C42["后缀"],
                _____7236_7EA7,
                "template",
                0
            )
            if not _____53E5_67C4_6709_6548(frame) then
                return nil
            end
            DzFrameSetSize(frame, _____5BBD_5EA6, _____9AD8_5EA6)
            DzFrameSetText(frame, "")
            DzFrameSetFont(frame, ____exports["冷却数字字体"], _____5B57_4F53_5927_5C0F, 0)
            DzFrameSetTextAlignment(frame, -1)
            DzFrameSetTextAlignment(frame, _____5BF9_9F50)
            DzFrameSetTextColor(
                frame,
                _____5C42.r,
                _____5C42.g,
                _____5C42.b,
                _____5C42.a
            )
            DzFrameSetPriority(frame, _____4F18_5148_7EA7 + _____5C42["优先级偏移"])
            DzFrameShow(frame, false)
            _____6846_4F53_5217_8868[#_____6846_4F53_5217_8868 + 1] = frame
            i = i + 1
        end
    end
    return {
        ["框体列表"] = _____6846_4F53_5217_8868,
        ["层列表"] = _____5C42_5217_8868,
        ["主文本框体"] = _____6846_4F53_5217_8868[#_____6846_4F53_5217_8868] or 0,
        ["宽度"] = _____5BBD_5EA6,
        ["高度"] = _____9AD8_5EA6,
        ["字体大小"] = _____5B57_4F53_5927_5C0F,
        ["优先级"] = _____4F18_5148_7EA7,
        ["对齐"] = _____5BF9_9F50
    }
end
____exports["设置冷却数字文本锚点"] = function(_____6587_672C_7EC4, relativeFrame, point, relativePoint, x, y)
    if _____6587_672C_7EC4 == nil or not _____53E5_67C4_6709_6548(relativeFrame) then
        return
    end
    do
        local i = 0
        while i < #_____6587_672C_7EC4["框体列表"] do
            do
                local frame = _____6587_672C_7EC4["框体列表"][i + 1]
                local _____5C42 = _____6587_672C_7EC4["层列表"][i + 1]
                if not _____53E5_67C4_6709_6548(frame) or _____5C42 == nil then
                    goto __continue14
                end
                DzFrameSetPoint(
                    frame,
                    point,
                    relativeFrame,
                    relativePoint,
                    x + _____5C42["偏移X"],
                    y + _____5C42["偏移Y"]
                )
            end
            ::__continue14::
            i = i + 1
        end
    end
end
____exports["设置冷却数字文本"] = function(_____6587_672C_7EC4, text)
    if _____6587_672C_7EC4 == nil then
        return
    end
    do
        local i = 0
        while i < #_____6587_672C_7EC4["框体列表"] do
            do
                local frame = _____6587_672C_7EC4["框体列表"][i + 1]
                local _____5C42 = _____6587_672C_7EC4["层列表"][i + 1]
                if not _____53E5_67C4_6709_6548(frame) or _____5C42 == nil then
                    goto __continue19
                end
                DzFrameSetText(
                    frame,
                    ____exports["包装冷却数字颜色"](text, _____5C42["颜色码"])
                )
            end
            ::__continue19::
            i = i + 1
        end
    end
end
____exports["显示冷却数字文本"] = function(_____6587_672C_7EC4, visible)
    if _____6587_672C_7EC4 == nil then
        return
    end
    do
        local i = 0
        while i < #_____6587_672C_7EC4["框体列表"] do
            local frame = _____6587_672C_7EC4["框体列表"][i + 1]
            if _____53E5_67C4_6709_6548(frame) then
                DzFrameShow(frame, visible)
            end
            i = i + 1
        end
    end
end
return ____exports
