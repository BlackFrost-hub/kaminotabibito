--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示玩家槽数"]
local _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["每玩家广播提示槽数"]
local _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15 = ____00_FF0E_5E38_91CF_5B9A_4E49["取广播提示槽索引"]
local _____5E7F_64AD_63D0_793A_80CC_666F_8D34_56FE = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示背景贴图"]
local _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示默认头像"]
local _____5E7F_64AD_63D0_793A_5B57_4F53 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示字体"]
local _____5E7F_64AD_63D0_793A_5BBD_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示宽度"]
local _____5E7F_64AD_63D0_793A_9AD8_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示高度"]
local _____5E7F_64AD_63D0_793A_5934_50CF_5927_5C0F = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示头像大小"]
local _____5E7F_64AD_63D0_793A_6587_5B57_5BBD_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示文字宽度"]
local _____5E7F_64AD_63D0_793A_6587_5B57_9AD8_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示文字高度"]
local _____5E7F_64AD_63D0_793A_8D77_59CBX = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示起始X"]
local _____5E7F_64AD_63D0_793A_57FA_51C6Y = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示基准Y"]
local _____5E7F_64AD_63D0_793A_69FD_95F4_8DDDY = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示槽间距Y"]
local _____5E7F_64AD_63D0_793A_6700_5927_900F_660E_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示最大透明度"]
local _____5E7F_64AD_63D0_793A_4F18_5148_7EA7 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示优先级"]
local _____5E27_70B9_5DE6 = ____00_FF0E_5E38_91CF_5B9A_4E49["帧点左"]
local _____5E27_70B9_53F3 = ____00_FF0E_5E38_91CF_5B9A_4E49["帧点右"]
local _____6587_672C_5DE6_5BF9_9F50 = ____00_FF0E_5E38_91CF_5B9A_4E49["文本左对齐"]
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameShow = japi.DzFrameShow
____exports["广播提示槽帧表"] = {}
local _____5DF2_521B_5EFA_5E7F_64AD_63D0_793AUI = false
local function _____53D6_69FD_4F4DY(_____69FD_4F4DID)
    return _____5E7F_64AD_63D0_793A_57FA_51C6Y - _____69FD_4F4DID * _____5E7F_64AD_63D0_793A_69FD_95F4_8DDDY
end
local function _____521B_5EFA_80CC_666F_5E27(_____540D_79F0, _____7236_7EA7)
    return DzCreateFrameByTagName(
        "BACKDROP",
        _____540D_79F0,
        _____7236_7EA7,
        "template",
        0
    )
end
local function _____521B_5EFA_6587_672C_5E27(_____540D_79F0, _____7236_7EA7)
    return DzCreateFrameByTagName(
        "TEXT",
        _____540D_79F0,
        _____7236_7EA7,
        "template",
        0
    )
end
local function _____521B_5EFA_5355_69FD(_____73A9_5BB6ID, _____69FD_4F4DID, _____6E38_620FUI)
    local _____5E8F_53F7 = _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15(_____73A9_5BB6ID, _____69FD_4F4DID)
    local root = _____521B_5EFA_80CC_666F_5E27(
        (("BroadcastNoticeRoot_P" .. tostring(_____73A9_5BB6ID)) .. "_S") .. tostring(_____69FD_4F4DID),
        _____6E38_620FUI
    )
    if root == 0 then
        return nil
    end
    local icon = _____521B_5EFA_80CC_666F_5E27(
        (("BroadcastNoticeIcon_P" .. tostring(_____73A9_5BB6ID)) .. "_S") .. tostring(_____69FD_4F4DID),
        root
    )
    local text = _____521B_5EFA_6587_672C_5E27(
        (("BroadcastNoticeText_P" .. tostring(_____73A9_5BB6ID)) .. "_S") .. tostring(_____69FD_4F4DID),
        root
    )
    if icon == 0 or text == 0 then
        return nil
    end
    DzFrameSetAbsolutePoint(
        root,
        _____5E27_70B9_5DE6,
        _____5E7F_64AD_63D0_793A_8D77_59CBX,
        _____53D6_69FD_4F4DY(_____69FD_4F4DID)
    )
    DzFrameSetSize(root, _____5E7F_64AD_63D0_793A_5BBD_5EA6, _____5E7F_64AD_63D0_793A_9AD8_5EA6)
    DzFrameSetTexture(root, _____5E7F_64AD_63D0_793A_80CC_666F_8D34_56FE, 0)
    DzFrameSetAlpha(root, 0)
    DzFrameSetPriority(root, _____5E7F_64AD_63D0_793A_4F18_5148_7EA7)
    DzFrameSetSize(icon, _____5E7F_64AD_63D0_793A_5934_50CF_5927_5C0F, _____5E7F_64AD_63D0_793A_5934_50CF_5927_5C0F)
    DzFrameSetTexture(icon, _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF, 0)
    DzFrameSetPoint(
        icon,
        _____5E27_70B9_5DE6,
        root,
        _____5E27_70B9_5DE6,
        0.006,
        0
    )
    DzFrameSetPriority(icon, _____5E7F_64AD_63D0_793A_4F18_5148_7EA7 + 1)
    DzFrameSetSize(text, _____5E7F_64AD_63D0_793A_6587_5B57_5BBD_5EA6, _____5E7F_64AD_63D0_793A_6587_5B57_9AD8_5EA6)
    DzFrameSetText(text, "")
    DzFrameSetFont(text, _____5E7F_64AD_63D0_793A_5B57_4F53, 0.0115, 0)
    DzFrameSetTextAlignment(text, -1)
    DzFrameSetTextAlignment(text, _____6587_672C_5DE6_5BF9_9F50)
    DzFrameSetPoint(
        text,
        _____5E27_70B9_5DE6,
        icon,
        _____5E27_70B9_53F3,
        0.006,
        0
    )
    DzFrameSetPriority(text, _____5E7F_64AD_63D0_793A_4F18_5148_7EA7 + 2)
    DzFrameShow(icon, true)
    DzFrameShow(text, true)
    DzFrameShow(root, false)
    DzFrameSetAlpha(root, _____5E7F_64AD_63D0_793A_6700_5927_900F_660E_5EA6)
    local _____5E27_7EC4 = {root = root, icon = icon, text = text}
    ____exports["广播提示槽帧表"][_____5E8F_53F7 + 1] = _____5E27_7EC4
    return _____5E27_7EC4
end
____exports["创建全部广播提示槽"] = function()
    if _____5DF2_521B_5EFA_5E7F_64AD_63D0_793AUI then
        return
    end
    _____5DF2_521B_5EFA_5E7F_64AD_63D0_793AUI = true
    local _____6E38_620FUI = DzGetGameUI()
    if _____6E38_620FUI == 0 then
        return
    end
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            do
                local _____69FD_4F4DID = 0
                while _____69FD_4F4DID < _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 do
                    _____521B_5EFA_5355_69FD(_____73A9_5BB6ID, _____69FD_4F4DID, _____6E38_620FUI)
                    _____69FD_4F4DID = _____69FD_4F4DID + 1
                end
            end
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
return ____exports
