--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示玩家槽数"]
local _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["每玩家广播提示槽数"]
local _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15 = ____00_FF0E_5E38_91CF_5B9A_4E49["取广播提示槽索引"]
local _____5E7F_64AD_63D0_793A_72B6_6001__9690_85CF = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_隐藏"]
local _____5E7F_64AD_63D0_793A_72B6_6001__6ED1_5165 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_滑入"]
local _____5E7F_64AD_63D0_793A_9ED8_8BA4_505C_7559_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示默认停留毫秒"]
local _____5E7F_64AD_63D0_793A_8D77_59CBX = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示起始X"]
local _____5E7F_64AD_63D0_793A_57FA_51C6Y = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示基准Y"]
local _____5E7F_64AD_63D0_793A_69FD_95F4_8DDDY = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示槽间距Y"]
local ____02_FF0EUI_521B_5EFA = require("系统.09．表现系统.06．广播提示消息.02．UI创建")
local _____5E7F_64AD_63D0_793A_69FD_5E27_8868 = ____02_FF0EUI_521B_5EFA["广播提示槽帧表"]
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetAlpha = japi.DzFrameSetAlpha
____exports["广播提示槽状态表"] = {}
local _____73A9_5BB6_4E0B_4E00_4E2A_69FD_4F4D_8868 = {}
local function _____53D6_69FD_4F4DY(_____69FD_4F4DID)
    return _____5E7F_64AD_63D0_793A_57FA_51C6Y - _____69FD_4F4DID * _____5E7F_64AD_63D0_793A_69FD_95F4_8DDDY
end
local function _____53D6_5B89_5168_6301_7EED_65F6_95F4(_____6301_7EED_65F6_95F4)
    if _____6301_7EED_65F6_95F4 == nil or _____6301_7EED_65F6_95F4 <= 0 then
        return _____5E7F_64AD_63D0_793A_9ED8_8BA4_505C_7559_6BEB_79D2
    end
    return _____6301_7EED_65F6_95F4
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
                            iconPath = ""
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
    DzFrameSetTexture(_____5E27_7EC4.icon, _____72B6_6001.iconPath, 0)
    DzFrameSetText(_____5E27_7EC4.text, _____72B6_6001.text)
    DzFrameSetAbsolutePoint(
        _____5E27_7EC4.root,
        3,
        _____5E7F_64AD_63D0_793A_8D77_59CBX,
        _____53D6_69FD_4F4DY(_____72B6_6001.slotId)
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
    _____72B6_6001.durationMs = _____53D6_5B89_5168_6301_7EED_65F6_95F4(_____6301_7EED_65F6_95F4)
    _____72B6_6001.x = _____5E7F_64AD_63D0_793A_8D77_59CBX
    _____72B6_6001.alpha = 0
    _____72B6_6001.text = _____6587_672C
    _____72B6_6001.iconPath = _____5934_50CF_8DEF_5F84
    _____5199_5165_69FD_5E27_5185_5BB9(_____5E8F_53F7, _____72B6_6001)
end
return ____exports
