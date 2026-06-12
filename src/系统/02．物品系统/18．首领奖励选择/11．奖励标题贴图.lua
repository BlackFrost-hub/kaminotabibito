--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.01．UI工具.01．帧创建")
local _____521B_5EFA_5E27 = ____01_FF0E_5E27_521B_5EFA.createFrame
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FramePoint = ____00_FF0E_7C7B_578B_5B9A_4E49.FramePoint
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
local ____02_FF0E_4F4D_7F6E_5C3A_5BF8 = require("系统.09．表现系统.01．UI工具.02．位置尺寸")
local _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePointRelative
local _____8BBE_7F6E_5E27_5C3A_5BF8 = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFrameSize
local ____03_FF0E_5185_5BB9_8BBE_7F6E = require("系统.09．表现系统.01．UI工具.03．内容设置")
local _____8BBE_7F6E_5E27_8D34_56FE = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameTexture
---
-- @noSelfInFile
local japi = require("jass.japi")
local _____6218_5229_54C1_9009_62E9_8D34_56FE = "UI\\BossReward\\text_loot_select_256x64.tga"
local ____F7_6253_5F00_5173_95ED_8D34_56FE = "UI\\BossReward\\text_f7_toggle_256x64.tga"
____exports["创建首领奖励标题贴图"] = function(_____7236_5E27, _____540E_7F00)
    local _____6218_5229_54C1_6807_9898 = _____521B_5EFA_5E27(nil, {
        type = FrameType.BACKDROP,
        name = "首领奖励战利品选择标题" .. _____540E_7F00,
        parent = _____7236_5E27,
        template = "template",
        visible = true
    }) or 0
    if _____6218_5229_54C1_6807_9898 ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            _____6218_5229_54C1_6807_9898,
            FramePoint.CENTER,
            _____7236_5E27,
            FramePoint.CENTER,
            -0.1,
            0.125
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____6218_5229_54C1_6807_9898, {width = 0.096, height = 0.024})
        _____8BBE_7F6E_5E27_8D34_56FE(nil, _____6218_5229_54C1_6807_9898, _____6218_5229_54C1_9009_62E9_8D34_56FE)
        japi.DzFrameSetPriority(_____6218_5229_54C1_6807_9898, 40)
    end
    local ____F7_63D0_793A = _____521B_5EFA_5E27(nil, {
        type = FrameType.BACKDROP,
        name = "首领奖励F7打开关闭标题" .. _____540E_7F00,
        parent = _____7236_5E27,
        template = "template",
        visible = true
    }) or 0
    if ____F7_63D0_793A ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            ____F7_63D0_793A,
            FramePoint.CENTER,
            _____7236_5E27,
            FramePoint.CENTER,
            0.1,
            0.125
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, ____F7_63D0_793A, {width = 0.096, height = 0.024})
        _____8BBE_7F6E_5E27_8D34_56FE(nil, ____F7_63D0_793A, ____F7_6253_5F00_5173_95ED_8D34_56FE)
        japi.DzFrameSetPriority(____F7_63D0_793A, 40)
    end
end
return ____exports
