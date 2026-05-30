--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 主线引导框架
-- 
-- DzFrame UI 创建、frame 句柄模块变量
-- UI 全局创建，不放 GetLocalPlayer 内创建
local japi = require("jass.japi")
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetText = japi.DzFrameSetText
local DzFrameShow = japi.DzFrameShow
local DzGetGameUI = japi.DzGetGameUI
local FRAME_POINT_CENTER = 4
local BTN_ICON_TEXTURE = "ReplaceableTextures\\CommandButtons\\BTNStaffOfPurification.blp"
local TEXTBOX_TEXTURE = "war3mapImported\\wenbenkuang.blp"
____exports["帧"] = {
    ["主线任务"] = 0,
    ["任务提示"] = 0,
    ["放大效果"] = 0,
    ["文本框"] = 0,
    ["提示文本"] = 0,
    ["按钮"] = 0
}
--- 创建主线引导 UI 帧树
-- 全局创建，不放 GetLocalPlayer 内
____exports["创建主线引导帧"] = function()
    local gameUI = DzGetGameUI()
    ____exports["帧"]["主线任务"] = DzCreateFrameByTagName(
        "BACKDROP",
        "主线任务",
        gameUI,
        "template",
        0
    )
    DzFrameSetAbsolutePoint(____exports["帧"]["主线任务"], FRAME_POINT_CENTER, 0.2, 0.5573046)
    DzFrameSetSize(____exports["帧"]["主线任务"], 0.03, 0.03)
    DzFrameSetTexture(____exports["帧"]["主线任务"], BTN_ICON_TEXTURE, 0)
    ____exports["帧"]["任务提示"] = DzCreateFrameByTagName(
        "TEXT",
        "任务提示",
        ____exports["帧"]["主线任务"],
        "template",
        0
    )
    DzFrameSetAbsolutePoint(____exports["帧"]["任务提示"], FRAME_POINT_CENTER, 0.21, 0.55)
    DzFrameSetSize(____exports["帧"]["任务提示"], 0.055, 0.056)
    DzFrameSetText(____exports["帧"]["任务提示"], "|cffffff00主线引导|r")
    DzFrameShow(____exports["帧"]["任务提示"], true)
    ____exports["帧"]["放大效果"] = DzCreateFrameByTagName(
        "BACKDROP",
        "放大效果",
        ____exports["帧"]["主线任务"],
        "template",
        0
    )
    DzFrameSetAbsolutePoint(____exports["帧"]["放大效果"], FRAME_POINT_CENTER, 0.07, 0.55)
    DzFrameSetSize(____exports["帧"]["放大效果"], 0.04, 0.04)
    DzFrameSetTexture(____exports["帧"]["放大效果"], BTN_ICON_TEXTURE, 0)
    DzFrameShow(____exports["帧"]["放大效果"], false)
    ____exports["帧"]["文本框"] = DzCreateFrameByTagName(
        "BACKDROP",
        "主线任务文本框",
        ____exports["帧"]["主线任务"],
        "template",
        0
    )
    DzFrameSetTexture(____exports["帧"]["文本框"], TEXTBOX_TEXTURE, 0)
    DzFrameSetSize(____exports["帧"]["文本框"], 0.1, 0.1)
    DzFrameSetPoint(
        ____exports["帧"]["文本框"],
        FRAME_POINT_CENTER,
        ____exports["帧"]["主线任务"],
        FRAME_POINT_CENTER,
        0,
        0
    )
    DzFrameShow(____exports["帧"]["文本框"], false)
    ____exports["帧"]["提示文本"] = DzCreateFrameByTagName(
        "TEXT",
        "主线任务提示文本",
        ____exports["帧"]["文本框"],
        "template",
        0
    )
    DzFrameSetSize(____exports["帧"]["提示文本"], 0.03, 0.03)
    DzFrameSetPoint(
        ____exports["帧"]["提示文本"],
        FRAME_POINT_CENTER,
        ____exports["帧"]["文本框"],
        FRAME_POINT_CENTER,
        0,
        0
    )
    DzFrameSetText(____exports["帧"]["提示文本"], "")
end
--- 创建可点击按钮并注册 sync=true 回调
-- 按钮覆盖在主图标上
____exports["创建主线引导按钮"] = function(onClick)
    local DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode
    local FRAME_EVENT_MOUSE_CLICK = 1
    ____exports["帧"]["按钮"] = DzCreateFrameByTagName(
        "GLUETEXTBUTTON",
        "主线按钮",
        ____exports["帧"]["主线任务"],
        "template",
        0
    )
    DzFrameSetAbsolutePoint(____exports["帧"]["按钮"], FRAME_POINT_CENTER, 0.2, 0.5573046)
    DzFrameSetSize(____exports["帧"]["按钮"], 0.03, 0.03)
    DzFrameSetScriptByCode(____exports["帧"]["按钮"], FRAME_EVENT_MOUSE_CLICK, onClick, true)
end
return ____exports
