--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____624B_518CUI, _____662F_5426_6253_5F00
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.07．游戏说明手册.00．常量定义")
local FRAME_EVENT_MOUSE_CLICK = ____00_FF0E_5E38_91CF_5B9A_4E49.FRAME_EVENT_MOUSE_CLICK
local FRAME_EVENT_MOUSE_ENTER = ____00_FF0E_5E38_91CF_5B9A_4E49.FRAME_EVENT_MOUSE_ENTER
local FRAME_EVENT_MOUSE_LEAVE = ____00_FF0E_5E38_91CF_5B9A_4E49.FRAME_EVENT_MOUSE_LEAVE
local ____02_FF0E_5185_5BB9_6570_636E = require("系统.09．表现系统.07．游戏说明手册.02．内容数据")
local _____6E38_620F_8BF4_660E_9875_9762 = ____02_FF0E_5185_5BB9_6570_636E["游戏说明页面"]
local ____03_FF0E_624B_518CUI_521B_5EFA = require("系统.09．表现系统.07．游戏说明手册.03．手册UI创建")
local _____8BBE_7F6E_624B_518C_5E27_663E_793A = ____03_FF0E_624B_518CUI_521B_5EFA["设置手册帧显示"]
local ____04_FF0E_7FFB_9875_52A8_753B = require("系统.09．表现系统.07．游戏说明手册.04．翻页动画")
local _____5F00_59CB_7FFB_9875_52A8_753B = ____04_FF0E_7FFB_9875_52A8_753B["开始翻页动画"]
local _____662F_5426_6B63_5728_7FFB_9875 = ____04_FF0E_7FFB_9875_52A8_753B["是否正在翻页"]
local _____505C_6B62_7FFB_9875_52A8_753B = ____04_FF0E_7FFB_9875_52A8_753B["停止翻页动画"]
____exports["关闭游戏说明手册"] = function()
    if _____624B_518CUI == nil then
        return
    end
    _____662F_5426_6253_5F00 = false
    _____505C_6B62_7FFB_9875_52A8_753B()
    _____8BBE_7F6E_624B_518C_5E27_663E_793A(_____624B_518CUI, false)
end
---
-- @noSelfInFile
local japi = require("jass.japi")
local ____Frame_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local DzFrameSetText = japi.DzFrameSetText
local DzFrameShow = japi.DzFrameShow
_____624B_518CUI = nil
local _____5F53_524D_9875 = 0
_____662F_5426_6253_5F00 = false
local function _____6709_6548_5E27(frame)
    return frame ~= nil and frame ~= 0
end
local function _____89C4_8303_9875_7801(pageIndex)
    if #_____6E38_620F_8BF4_660E_9875_9762 <= 0 then
        return 0
    end
    if pageIndex < 0 then
        return #_____6E38_620F_8BF4_660E_9875_9762 - 1
    end
    if pageIndex >= #_____6E38_620F_8BF4_660E_9875_9762 then
        return 0
    end
    return pageIndex
end
local function _____6E32_67D3_5F53_524D_9875()
    if _____624B_518CUI == nil then
        return
    end
    local page = _____6E38_620F_8BF4_660E_9875_9762[_____5F53_524D_9875 + 1]
    if page == nil then
        return
    end
    DzFrameSetText(_____624B_518CUI.titleText, page["标题"])
    DzFrameSetText(_____624B_518CUI.bodyText, page["正文"])
end
local function _____7FFB_9875_7ED3_675F()
    _____5F53_524D_9875 = _____89C4_8303_9875_7801(_____5F53_524D_9875 + 1)
    _____6E32_67D3_5F53_524D_9875()
end
local function onNextEnter()
    if _____624B_518CUI == nil or not _____662F_5426_6253_5F00 or _____662F_5426_6B63_5728_7FFB_9875() then
        return
    end
    DzFrameShow(_____624B_518CUI.indicator, true)
    DzFrameShow(_____624B_518CUI.hintText, true)
end
local function onNextLeave()
    if _____624B_518CUI == nil then
        return
    end
    DzFrameShow(_____624B_518CUI.indicator, false)
    DzFrameShow(_____624B_518CUI.hintText, false)
end
local function onNextClick()
    if _____624B_518CUI == nil or not _____662F_5426_6253_5F00 or _____662F_5426_6B63_5728_7FFB_9875() then
        return
    end
    DzFrameShow(_____624B_518CUI.indicator, false)
    DzFrameShow(_____624B_518CUI.hintText, false)
    _____5F00_59CB_7FFB_9875_52A8_753B(_____7FFB_9875_7ED3_675F)
end
local function onCloseClick()
    ____exports["关闭游戏说明手册"]()
end
____exports["初始化手册交互"] = function(ui)
    _____624B_518CUI = ui
    if _____6709_6548_5E27(ui.nextHotspot) then
        ____Frame_5DE5_5177.frameSetScriptByCode(ui.nextHotspot, FRAME_EVENT_MOUSE_ENTER, onNextEnter, false)
        ____Frame_5DE5_5177.frameSetScriptByCode(ui.nextHotspot, FRAME_EVENT_MOUSE_LEAVE, onNextLeave, false)
        ____Frame_5DE5_5177.frameSetScriptByCode(ui.nextHotspot, FRAME_EVENT_MOUSE_CLICK, onNextClick, false)
    end
    if _____6709_6548_5E27(ui.closeHotspot) then
        ____Frame_5DE5_5177.frameSetScriptByCode(ui.closeHotspot, FRAME_EVENT_MOUSE_CLICK, onCloseClick, false)
    end
end
____exports["打开游戏说明手册"] = function()
    if _____624B_518CUI == nil then
        return
    end
    _____662F_5426_6253_5F00 = true
    _____6E32_67D3_5F53_524D_9875()
    _____8BBE_7F6E_624B_518C_5E27_663E_793A(_____624B_518CUI, true)
end
____exports["切换游戏说明手册"] = function()
    if _____662F_5426_6253_5F00 then
        ____exports["关闭游戏说明手册"]()
    else
        ____exports["打开游戏说明手册"]()
    end
end
return ____exports
