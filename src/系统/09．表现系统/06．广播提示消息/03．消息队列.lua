local ____lualib = require("lualib_bundle")
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示玩家槽数"]
local _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["每玩家广播提示槽数"]
local _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15 = ____00_FF0E_5E38_91CF_5B9A_4E49["取广播提示槽索引"]
local _____53D6_5E7F_64AD_63D0_793A_69FD_4F4DY = ____00_FF0E_5E38_91CF_5B9A_4E49["取广播提示槽位Y"]
local _____5E7F_64AD_63D0_793A_72B6_6001__9690_85CF = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_隐藏"]
local _____5E7F_64AD_63D0_793A_72B6_6001__6ED1_5165 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_滑入"]
local _____5E7F_64AD_63D0_793A_9ED8_8BA4_505C_7559_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示默认停留毫秒"]
local _____5E7F_64AD_63D0_793A_8D77_59CBX = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示起始X"]
local _____5E7F_64AD_63D0_793A_5BBD_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示宽度"]
local _____5E7F_64AD_63D0_793A_9AD8_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示高度"]
local _____5E7F_64AD_63D0_793A_6587_5B57_5BBD_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示文字宽度"]
local _____5E7F_64AD_63D0_793A_6587_5B57_9AD8_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示文字高度"]
local ____02_FF0EUI_521B_5EFA = require("系统.09．表现系统.06．广播提示消息.02．UI创建")
local _____5E7F_64AD_63D0_793A_69FD_5E27_8868 = ____02_FF0EUI_521B_5EFA["广播提示槽帧表"]
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local DzFrameSetSize = japi.DzFrameSetSize
____exports["广播提示槽状态表"] = {}
local _____73A9_5BB6_4E0B_4E00_4E2A_69FD_4F4D_8868 = {}
local function _____53D6_5B89_5168_6301_7EED_65F6_95F4(_____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 == nil or _____6301_7EED_65F6_95F4 <= 0 then
        return _____5E7F_64AD_63D0_793A_9ED8_8BA4_505C_7559_6BEB_79D2
    end
    return _____6301_7EED_65F6_95F4
end
local function _____8BA1_7B97_5E7F_64AD_6587_672C_53EF_89C1_957F_5EA6(_____6587_672C)
    local _____53EF_89C1_957F_5EA6 = 0
    local i = 0
    while i < #_____6587_672C do
        do
            local _____5F53_524D_5B57_7B26 = __TS__StringCharAt(_____6587_672C, i)
            if _____5F53_524D_5B57_7B26 == "|" then
                local _____4E0B_4E00_4E2A_5B57_7B26 = __TS__StringCharAt(_____6587_672C, i + 1)
                if _____4E0B_4E00_4E2A_5B57_7B26 == "c" or _____4E0B_4E00_4E2A_5B57_7B26 == "C" then
                    i = i + 10
                    goto __continue5
                end
                if _____4E0B_4E00_4E2A_5B57_7B26 == "r" or _____4E0B_4E00_4E2A_5B57_7B26 == "R" then
                    i = i + 2
                    goto __continue5
                end
            end
            if _____5F53_524D_5B57_7B26 == "\n" then
                i = i + 1
                goto __continue5
            end
            _____53EF_89C1_957F_5EA6 = _____53EF_89C1_957F_5EA6 + 1
            i = i + 1
        end
        ::__continue5::
    end
    return _____53EF_89C1_957F_5EA6
end
local function _____6309_53EF_89C1_957F_5EA6_63D2_5165_6362_884C(_____6587_672C, _____6BCF_884C_5B57_7B26_6570, _____6700_5927_884C_6570)
    local _____7ED3_679C = ""
    local _____5F53_524D_884C_957F_5EA6 = 0
    local _____884C_6570 = 1
    local i = 0
    while i < #_____6587_672C do
        do
            local _____5F53_524D_5B57_7B26 = __TS__StringCharAt(_____6587_672C, i)
            if _____5F53_524D_5B57_7B26 == "|" then
                local _____4E0B_4E00_4E2A_5B57_7B26 = __TS__StringCharAt(_____6587_672C, i + 1)
                if _____4E0B_4E00_4E2A_5B57_7B26 == "c" or _____4E0B_4E00_4E2A_5B57_7B26 == "C" then
                    _____7ED3_679C = _____7ED3_679C .. __TS__StringSubstring(_____6587_672C, i, i + 10)
                    i = i + 10
                    goto __continue11
                end
                if _____4E0B_4E00_4E2A_5B57_7B26 == "r" or _____4E0B_4E00_4E2A_5B57_7B26 == "R" then
                    _____7ED3_679C = _____7ED3_679C .. __TS__StringSubstring(_____6587_672C, i, i + 2)
                    i = i + 2
                    goto __continue11
                end
            end
            if _____5F53_524D_5B57_7B26 == "\n" then
                _____7ED3_679C = _____7ED3_679C .. _____5F53_524D_5B57_7B26
                _____5F53_524D_884C_957F_5EA6 = 0
                if _____884C_6570 < _____6700_5927_884C_6570 then
                    _____884C_6570 = _____884C_6570 + 1
                end
                i = i + 1
                goto __continue11
            end
            if _____5F53_524D_884C_957F_5EA6 >= _____6BCF_884C_5B57_7B26_6570 and _____884C_6570 < _____6700_5927_884C_6570 then
                _____7ED3_679C = _____7ED3_679C .. "\n"
                _____5F53_524D_884C_957F_5EA6 = 0
                _____884C_6570 = _____884C_6570 + 1
            end
            _____7ED3_679C = _____7ED3_679C .. _____5F53_524D_5B57_7B26
            _____5F53_524D_884C_957F_5EA6 = _____5F53_524D_884C_957F_5EA6 + 1
            i = i + 1
        end
        ::__continue11::
    end
    return {["文本"] = _____7ED3_679C, ["行数"] = _____884C_6570}
end
local function _____8BA1_7B97_5E7F_64AD_6587_672C_5E03_5C40(_____6587_672C, _____6301_7EED_65F6_95F4)
    local _____53EF_89C1_957F_5EA6 = _____8BA1_7B97_5E7F_64AD_6587_672C_53EF_89C1_957F_5EA6(_____6587_672C)
    local _____6307_5B9A_6301_7EED_65F6_95F4 = _____53D6_5B89_5168_6301_7EED_65F6_95F4(_____6301_7EED_65F6_95F4)
    if _____53EF_89C1_957F_5EA6 <= 26 then
        return {
            ["文本"] = _____6587_672C,
            ["可见长度"] = _____53EF_89C1_957F_5EA6,
            ["行数"] = 1,
            rootWidth = _____5E7F_64AD_63D0_793A_5BBD_5EA6,
            rootHeight = _____5E7F_64AD_63D0_793A_9AD8_5EA6,
            textWidth = _____5E7F_64AD_63D0_793A_6587_5B57_5BBD_5EA6,
            textHeight = _____5E7F_64AD_63D0_793A_6587_5B57_9AD8_5EA6,
            durationMs = _____6307_5B9A_6301_7EED_65F6_95F4
        }
    end
    if _____53EF_89C1_957F_5EA6 <= 64 then
        local _____683C_5F0F_5316_7ED3_679C = _____6309_53EF_89C1_957F_5EA6_63D2_5165_6362_884C(_____6587_672C, 30, 2)
        return {
            ["文本"] = _____683C_5F0F_5316_7ED3_679C["文本"],
            ["可见长度"] = _____53EF_89C1_957F_5EA6,
            ["行数"] = _____683C_5F0F_5316_7ED3_679C["行数"],
            rootWidth = 0.285,
            rootHeight = 0.05,
            textWidth = 0.235,
            textHeight = 0.032,
            durationMs = _____6307_5B9A_6301_7EED_65F6_95F4 > _____5E7F_64AD_63D0_793A_9ED8_8BA4_505C_7559_6BEB_79D2 and _____6307_5B9A_6301_7EED_65F6_95F4 or 4200
        }
    end
    local _____683C_5F0F_5316_7ED3_679C = _____6309_53EF_89C1_957F_5EA6_63D2_5165_6362_884C(_____6587_672C, 32, 3)
    return {
        ["文本"] = _____683C_5F0F_5316_7ED3_679C["文本"],
        ["可见长度"] = _____53EF_89C1_957F_5EA6,
        ["行数"] = _____683C_5F0F_5316_7ED3_679C["行数"],
        rootWidth = 0.325,
        rootHeight = 0.066,
        textWidth = 0.275,
        textHeight = 0.048,
        durationMs = _____6307_5B9A_6301_7EED_65F6_95F4 > _____5E7F_64AD_63D0_793A_9ED8_8BA4_505C_7559_6BEB_79D2 and _____6307_5B9A_6301_7EED_65F6_95F4 or 5600
    }
end
____exports["初始化广播提示消息状态"] = function()
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            _____73A9_5BB6_4E0B_4E00_4E2A_69FD_4F4D_8868[_____73A9_5BB6ID + 1] = 0
            do
                local _____69FD_4F4DID = 0
                while _____69FD_4F4DID < _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 do
                    local _____5E8F_53F7 = _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15(_____73A9_5BB6ID, _____69FD_4F4DID)
                    if ____exports["广播提示槽状态表"][_____5E8F_53F7 + 1] == nil then
                        ____exports["广播提示槽状态表"][_____5E8F_53F7 + 1] = {
                            active = false,
                            playerId = _____73A9_5BB6ID,
                            slotId = _____69FD_4F4DID,
                            state = _____5E7F_64AD_63D0_793A_72B6_6001__9690_85CF,
                            elapsedMs = 0,
                            durationMs = _____5E7F_64AD_63D0_793A_9ED8_8BA4_505C_7559_6BEB_79D2,
                            x = _____5E7F_64AD_63D0_793A_8D77_59CBX,
                            alpha = 0,
                            text = "",
                            iconPath = "",
                            rootWidth = _____5E7F_64AD_63D0_793A_5BBD_5EA6,
                            rootHeight = _____5E7F_64AD_63D0_793A_9AD8_5EA6,
                            textWidth = _____5E7F_64AD_63D0_793A_6587_5B57_5BBD_5EA6,
                            textHeight = _____5E7F_64AD_63D0_793A_6587_5B57_9AD8_5EA6
                        }
                    end
                    _____69FD_4F4DID = _____69FD_4F4DID + 1
                end
            end
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
local function _____5199_5165_69FD_5E27_5185_5BB9(_____5E8F_53F7, _____72B6_6001)
    local _____5E27_7EC4 = _____5E7F_64AD_63D0_793A_69FD_5E27_8868[_____5E8F_53F7 + 1]
    if _____5E27_7EC4 == nil then
        return
    end
    DzFrameSetSize(_____5E27_7EC4.root, _____72B6_6001.rootWidth, _____72B6_6001.rootHeight)
    DzFrameSetSize(_____5E27_7EC4.text, _____72B6_6001.textWidth, _____72B6_6001.textHeight)
    DzFrameSetTexture(_____5E27_7EC4.icon, _____72B6_6001.iconPath, 0)
    DzFrameSetText(_____5E27_7EC4.text, _____72B6_6001.text)
    DzFrameSetAbsolutePoint(
        _____5E27_7EC4.root,
        3,
        _____5E7F_64AD_63D0_793A_8D77_59CBX,
        _____53D6_5E7F_64AD_63D0_793A_69FD_4F4DY(_____72B6_6001.slotId)
    )
    DzFrameSetAlpha(_____5E27_7EC4.root, 0)
end
____exports["入队头像提示"] = function(_____73A9_5BB6ID, _____5934_50CF_8DEF_5F84, _____6587_672C, _____6301_7EED_65F6_95F4)
    if _____73A9_5BB6ID < 0 or _____73A9_5BB6ID >= _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 then
        return
    end
    if _____6587_672C == nil or _____6587_672C == "" then
        return
    end
    local _____5E03_5C40 = _____8BA1_7B97_5E7F_64AD_6587_672C_5E03_5C40(_____6587_672C, _____6301_7EED_65F6_95F4)
    local _____5F53_524D_69FD_4F4D = _____73A9_5BB6_4E0B_4E00_4E2A_69FD_4F4D_8868[_____73A9_5BB6ID + 1] or 0
    local _____5E8F_53F7 = _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15(_____73A9_5BB6ID, _____5F53_524D_69FD_4F4D)
    local _____4E0B_4E00_4E2A_69FD_4F4D = _____5F53_524D_69FD_4F4D + 1 >= _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 and 0 or _____5F53_524D_69FD_4F4D + 1
    _____73A9_5BB6_4E0B_4E00_4E2A_69FD_4F4D_8868[_____73A9_5BB6ID + 1] = _____4E0B_4E00_4E2A_69FD_4F4D
    local _____72B6_6001 = ____exports["广播提示槽状态表"][_____5E8F_53F7 + 1]
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001.active = true
    _____72B6_6001.playerId = _____73A9_5BB6ID
    _____72B6_6001.slotId = _____5F53_524D_69FD_4F4D
    _____72B6_6001.state = _____5E7F_64AD_63D0_793A_72B6_6001__6ED1_5165
    _____72B6_6001.elapsedMs = 0
    _____72B6_6001.durationMs = _____5E03_5C40.durationMs
    _____72B6_6001.x = _____5E7F_64AD_63D0_793A_8D77_59CBX
    _____72B6_6001.alpha = 0
    _____72B6_6001.text = _____5E03_5C40["文本"]
    _____72B6_6001.iconPath = _____5934_50CF_8DEF_5F84
    _____72B6_6001.rootWidth = _____5E03_5C40.rootWidth
    _____72B6_6001.rootHeight = _____5E03_5C40.rootHeight
    _____72B6_6001.textWidth = _____5E03_5C40.textWidth
    _____72B6_6001.textHeight = _____5E03_5C40.textHeight
    _____5199_5165_69FD_5E27_5185_5BB9(_____5E8F_53F7, _____72B6_6001)
end
return ____exports
