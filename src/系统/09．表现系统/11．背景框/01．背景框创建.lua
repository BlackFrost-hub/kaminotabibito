--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.01．UI工具.01．帧创建")
local createFrame = ____01_FF0E_5E27_521B_5EFA.createFrame
local ____02_FF0E_4F4D_7F6E_5C3A_5BF8 = require("系统.09．表现系统.01．UI工具.02．位置尺寸")
local setFramePosition = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePosition
local setFrameSize = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFrameSize
local ____03_FF0E_5185_5BB9_8BBE_7F6E = require("系统.09．表现系统.01．UI工具.03．内容设置")
local setFrameTexture = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameTexture
local ____05_FF0E_5E27_63A7_5236 = require("系统.09．表现系统.01．UI工具.05．帧控制")
local hideFrame = ____05_FF0E_5E27_63A7_5236.hideFrame
local showFrame = ____05_FF0E_5E27_63A7_5236.showFrame
local destroyFrame = ____05_FF0E_5E27_63A7_5236.destroyFrame
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
local FramePoint = ____00_FF0E_7C7B_578B_5B9A_4E49.FramePoint
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzGetGameUI = japi.DzGetGameUI
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local _____8D34_56FE_6570_91CF = 8
local _____6BCF_5F20_8D34_56FE_5BBD_5EA6 = 0.2
local _____6BCF_5F20_8D34_56FE_9AD8_5EA6 = 0.3053724
local _____4E0A_6392Y = 0.4473138
local _____4E0B_6392Y = 0.1526862
local _____6BB5_843DX = 0.309792
local _____6BB5_843D_95F4_8DDD = 0.0882192
local _____6BB5_843D_5BBD_5EA6 = 0.3741664
local _____6BB5_843D_9AD8_5EA6 = 0.0882186
local _____9ED8_8BA4_5B57_4F53_6587_4EF6 = "war3mapImported\\uizt.ttf"
local _____9ED8_8BA4_5B57_4F53_5927_5C0F = 1
local function _____8BA1_7B97_8D34_56FEX(_____7D22_5F15)
    if _____7D22_5F15 >= 1 and _____7D22_5F15 <= 4 then
        return -0.1 + 0.2 * _____7D22_5F15
    end
    return -0.9 + 0.2 * _____7D22_5F15
end
local function _____8BA1_7B97_8D34_56FEY(_____7D22_5F15)
    if _____7D22_5F15 >= 1 and _____7D22_5F15 <= 4 then
        return _____4E0A_6392Y
    end
    return _____4E0B_6392Y
end
____exports["创建背景框"] = function(config)
    local _____6BB5_843D_6570 = config and config["段落数量"] or 4
    local _____5B57_4F53 = config and config["字体文件"] or _____9ED8_8BA4_5B57_4F53_6587_4EF6
    local _____5B57_53F7 = config and config["字体大小"] or _____9ED8_8BA4_5B57_4F53_5927_5C0F
    local ____temp_8 = config and config["初始可见"]
    if ____temp_8 == nil then
        ____temp_8 = false
    end
    local _____53EF_89C1 = ____temp_8
    local _____4F18_5148_7EA7 = config and config["优先级"] or 3
    local _____6587_5B57_5217_8868 = config and config["段落文字"]
    local _____4E3B_80CC_666F = createFrame(
        nil,
        {
            type = FrameType.BACKDROP,
            name = "BJtietu",
            parent = DzGetGameUI(),
            template = "template",
            visible = _____53EF_89C1
        }
    )
    if _____4E3B_80CC_666F == nil then
        return nil
    end
    DzFrameSetPriority(_____4E3B_80CC_666F, _____4F18_5148_7EA7)
    local _____8D34_56FE_7EC4 = {}
    do
        local i = 0
        while i < _____8D34_56FE_6570_91CF do
            local _____7D22_5F15 = i + 1
            local _____8D34_56FE = createFrame(
                nil,
                {
                    type = FrameType.BACKDROP,
                    name = "BJtietu_map" .. tostring(_____7D22_5F15),
                    parent = _____4E3B_80CC_666F,
                    template = "template",
                    visible = true
                }
            )
            if _____8D34_56FE ~= nil then
                local _____8DEF_5F84 = ("war3mapImported\\BJtietu0" .. tostring(_____7D22_5F15)) .. ".tga"
                setFrameTexture(nil, _____8D34_56FE, _____8DEF_5F84)
                local pos = {
                    point = FramePoint.CENTER,
                    x = _____8BA1_7B97_8D34_56FEX(_____7D22_5F15),
                    y = _____8BA1_7B97_8D34_56FEY(_____7D22_5F15)
                }
                setFramePosition(nil, _____8D34_56FE, pos)
                setFrameSize(nil, _____8D34_56FE, {width = _____6BCF_5F20_8D34_56FE_5BBD_5EA6, height = _____6BCF_5F20_8D34_56FE_9AD8_5EA6})
            end
            _____8D34_56FE_7EC4[i + 1] = _____8D34_56FE or 0
            i = i + 1
        end
    end
    local _____6BB5_843D_7EC4 = {}
    do
        local i = 0
        while i < _____6BB5_843D_6570 do
            local _____7D22_5F15 = i + 1
            local _____6BB5_843D = createFrame(
                nil,
                {
                    type = FrameType.TEXT,
                    name = "BJtietu_text" .. tostring(_____7D22_5F15),
                    parent = _____4E3B_80CC_666F,
                    template = "template",
                    visible = true
                }
            )
            if _____6BB5_843D ~= nil then
                local y = 0.5293128 - _____6BB5_843D_95F4_8DDD * _____7D22_5F15
                local pos = {point = FramePoint.CENTER, x = _____6BB5_843DX, y = y}
                setFramePosition(nil, _____6BB5_843D, pos)
                setFrameSize(nil, _____6BB5_843D, {width = _____6BB5_843D_5BBD_5EA6, height = _____6BB5_843D_9AD8_5EA6})
                DzFrameSetFont(_____6BB5_843D, _____5B57_4F53, _____5B57_53F7, 0)
                local _____521D_59CB_6587_5B57 = _____6587_5B57_5217_8868 ~= nil and (_____6587_5B57_5217_8868[i + 1] or "") or ""
                DzFrameSetText(_____6BB5_843D, _____521D_59CB_6587_5B57)
            end
            _____6BB5_843D_7EC4[i + 1] = _____6BB5_843D or 0
            i = i + 1
        end
    end
    return {["主背景"] = _____4E3B_80CC_666F, ["贴图组"] = _____8D34_56FE_7EC4, ["段落组"] = _____6BB5_843D_7EC4}
end
____exports["设置段落文字"] = function(_____5B9E_4F8B, _____6BB5_843D_7D22_5F15, _____6587_5B57)
    local _____6BB5_843D_5E27 = _____5B9E_4F8B["段落组"][_____6BB5_843D_7D22_5F15 + 1]
    if _____6BB5_843D_5E27 ~= 0 and _____6BB5_843D_5E27 ~= nil then
        DzFrameSetText(_____6BB5_843D_5E27, _____6587_5B57)
    end
end
____exports["设置背景框透明度"] = function(_____5B9E_4F8B, alpha)
    DzFrameSetAlpha(_____5B9E_4F8B["主背景"], alpha)
end
____exports["显示背景框"] = function(_____5B9E_4F8B)
    showFrame(nil, _____5B9E_4F8B["主背景"])
end
____exports["隐藏背景框"] = function(_____5B9E_4F8B)
    hideFrame(nil, _____5B9E_4F8B["主背景"])
end
____exports["销毁背景框"] = function(_____5B9E_4F8B)
    do
        local i = 0
        while i < #_____5B9E_4F8B["段落组"] do
            local _____6BB5_843D_5E27 = _____5B9E_4F8B["段落组"][i + 1]
            if _____6BB5_843D_5E27 ~= 0 and _____6BB5_843D_5E27 ~= nil then
                destroyFrame(nil, _____6BB5_843D_5E27)
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #_____5B9E_4F8B["贴图组"] do
            local _____8D34_56FE_5E27 = _____5B9E_4F8B["贴图组"][i + 1]
            if _____8D34_56FE_5E27 ~= 0 and _____8D34_56FE_5E27 ~= nil then
                destroyFrame(nil, _____8D34_56FE_5E27)
            end
            i = i + 1
        end
    end
    destroyFrame(nil, _____5B9E_4F8B["主背景"])
end
return ____exports
