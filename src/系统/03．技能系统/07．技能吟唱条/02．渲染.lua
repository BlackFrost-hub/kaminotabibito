local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 技能吟唱条系统 - 渲染层
-- 
-- 职责：
-- - 吟唱条 Frame 工具封装（DzFrame 系列）
-- - 创建 / 每帧更新 / 销毁 UI 帧
-- - 吟唱条数据存储（Map）与中心计时器驱动
-- 
-- 不包含：生命周期入口、STES 输入注册。
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local ceil = ____require_result_0.ceil
local max = ____require_result_0.max
local forEachSorted = ____require_result_0.forEachSorted
local ____require_result_1 = require("系统.03．技能系统.07．技能吟唱条.00．常量定义")
local UPDATE_INTERVAL = ____require_result_1.UPDATE_INTERVAL
local BAR_POS_X = ____require_result_1.BAR_POS_X
local BAR_POS_Y = ____require_result_1.BAR_POS_Y
local TEXT_OFFSET_X = ____require_result_1.TEXT_OFFSET_X
local TEXT_OFFSET_Y = ____require_result_1.TEXT_OFFSET_Y
local PROGRESS_OFFSET_X = ____require_result_1.PROGRESS_OFFSET_X
local PROGRESS_OFFSET_Y = ____require_result_1.PROGRESS_OFFSET_Y
local SYMBOL_OFFSET_X = ____require_result_1.SYMBOL_OFFSET_X
local COUNTDOWN_OFFSET_X = ____require_result_1.COUNTDOWN_OFFSET_X
local TIP_OFFSET_X = ____require_result_1.TIP_OFFSET_X
local DEFAULT_COLOR_ID = ____require_result_1.DEFAULT_COLOR_ID
local FOREGROUND_MODELS = ____require_result_1.FOREGROUND_MODELS
local BACKGROUND_MODELS = ____require_result_1.BACKGROUND_MODELS
local DEFAULT_CAST_TEXT = ____require_result_1.DEFAULT_CAST_TEXT
local DEFAULT_TIP_TEXT = ____require_result_1.DEFAULT_TIP_TEXT
--- 吟唱条数据 Map：句柄ID -> 数据
____exports.castBarDataMap = __TS__New(Map)
local nextHandleId = 1
local function getNextHandleId()
    local ____nextHandleId_2 = nextHandleId
    nextHandleId = ____nextHandleId_2 + 1
    return ____nextHandleId_2
end
local function formatTime(time)
    local intPart = jass.R2I(time)
    local decPart = jass.R2I((time - intPart) * 10)
    return (tostring(intPart) .. ".") .. tostring(decPart)
end
local function getForegroundModel(colorId)
    return FOREGROUND_MODELS[colorId] or FOREGROUND_MODELS[DEFAULT_COLOR_ID]
end
local function getBackgroundModel(colorId)
    return BACKGROUND_MODELS[colorId] or BACKGROUND_MODELS[DEFAULT_COLOR_ID]
end
local function createFrame(tagName, name, parent)
    return japi.DzCreateFrameByTagName(
        tagName,
        name,
        parent,
        "template",
        0
    )
end
local function setFrameAbsolutePoint(frame, x, y)
    japi.DzFrameSetAbsolutePoint(frame, 4, x, y)
end
local function setFramePoint(frame, parent, offsetX, offsetY)
    japi.DzFrameSetPoint(
        frame,
        4,
        parent,
        4,
        offsetX,
        offsetY
    )
end
local function setFrameModel(frame, modelPath)
    japi.DzFrameSetModel(frame, modelPath, 0, 0)
end
local function setFrameAnimateOffset(frame, offset)
    japi.DzFrameSetAnimateOffset(frame, offset)
end
local function setFrameAnimate(frame, animId, autoPlay)
    japi.DzFrameSetAnimate(frame, animId, autoPlay)
end
local function showFrame(frame, show)
    japi.DzFrameShow(frame, show)
end
local function setFrameText(frame, text)
    japi.DzFrameSetText(frame, text)
end
local function setFramePriority(frame, priority)
    japi.DzFrameSetPriority(frame, priority)
end
local function destroyFrame(frame)
    japi.DzDestroyFrame(frame)
end
local function getGameUI()
    return japi.DzGetGameUI()
end
--- 每 tick 推进所有吟唱条，完成时销毁帧并从 Map 移除
local function updateAllCastBars()
    local deltaTime = UPDATE_INTERVAL
    forEachSorted(
        nil,
        ____exports.castBarDataMap,
        function(handleId, data)
            data.elapsedTime = data.elapsedTime + deltaTime
            data.progress = data.elapsedTime / data.totalTime
            local animOffset = 1 - data.progress
            setFrameAnimateOffset(data.foreground, animOffset)
            local remaining = data.totalTime - data.elapsedTime
            setFrameText(
                data.countdown,
                formatTime(max(nil, 0, remaining))
            )
            if data.elapsedTime >= data.totalTime then
                showFrame(data.foreground, false)
                destroyFrame(data.background)
                destroyFrame(data.textDisplay)
                destroyFrame(data.progressFrame)
                destroyFrame(data.symbol)
                destroyFrame(data.countdown)
                destroyFrame(data.tip)
                destroyFrame(data.foreground)
                ____exports.castBarDataMap:delete(handleId)
            end
        end
    )
end
--- 创建吟唱条 UI 帧组
local function createCastBarUI(colorId, totalTime, customString)
    local gameUI = getGameUI()
    if not gameUI then
        return nil
    end
    local prevUI = _G.__lastCastBarUI
    if prevUI then
        showFrame(prevUI, false)
    end
    local foreground = createFrame("SPRITE", "吟唱条前景", gameUI)
    if not foreground then
        return nil
    end
    setFrameModel(
        foreground,
        getForegroundModel(colorId)
    )
    setFrameAbsolutePoint(foreground, BAR_POS_X, BAR_POS_Y)
    setFrameAnimate(foreground, 0, false)
    setFrameAnimateOffset(foreground, 1)
    showFrame(foreground, true)
    _G.__lastCastBarUI = foreground
    local background = createFrame("SPRITE", "吟唱条背景", foreground)
    if background then
        setFrameModel(
            background,
            getBackgroundModel(colorId)
        )
        setFrameAbsolutePoint(background, BAR_POS_X, BAR_POS_Y)
        setFramePriority(background, 0)
    end
    local textDisplay = createFrame("TEXT", "吟唱条文本", foreground)
    if textDisplay then
        setFramePoint(textDisplay, foreground, TEXT_OFFSET_X, TEXT_OFFSET_Y)
        setFrameText(textDisplay, DEFAULT_CAST_TEXT)
        setFramePriority(textDisplay, 2)
    end
    local progressFrame = createFrame("TEXT", "吟唱条进度", foreground)
    if progressFrame then
        setFramePoint(progressFrame, foreground, PROGRESS_OFFSET_X, PROGRESS_OFFSET_Y)
        setFrameText(progressFrame, "0.0")
        setFramePriority(progressFrame, 2)
    end
    local symbol = createFrame("TEXT", "吟唱条符号", foreground)
    if symbol then
        setFramePoint(symbol, foreground, SYMBOL_OFFSET_X, PROGRESS_OFFSET_Y)
        setFrameText(symbol, "/")
        setFramePriority(symbol, 2)
    end
    local countdown = createFrame("TEXT", "吟唱条时间", foreground)
    if countdown then
        setFramePoint(countdown, foreground, COUNTDOWN_OFFSET_X, PROGRESS_OFFSET_Y)
        setFrameText(
            countdown,
            formatTime(totalTime)
        )
        setFramePriority(countdown, 2)
    end
    local tip = createFrame("TEXT", "吟唱条文本提示", foreground)
    if tip then
        setFramePoint(tip, foreground, TIP_OFFSET_X, PROGRESS_OFFSET_Y)
        setFrameText(tip, customString or DEFAULT_TIP_TEXT)
        setFramePriority(tip, 2)
    end
    return {
        totalTime = totalTime,
        elapsedTime = 0,
        progress = 0,
        foreground = foreground,
        background = background,
        textDisplay = textDisplay,
        progressFrame = progressFrame,
        symbol = symbol,
        countdown = countdown,
        tip = tip
    }
end
local _registeredToCenterTimer = false
local _tickCounter = 0
local CENTER_TIMER_TICKS = ceil(nil, UPDATE_INTERVAL / 0.01)
local function onCastBarCenterTimerTick()
    if ____exports.castBarDataMap.size == 0 then
        return
    end
    _tickCounter = _tickCounter + 1
    if _tickCounter >= CENTER_TIMER_TICKS then
        _tickCounter = 0
        updateAllCastBars()
    end
end
local function ensureRegisteredToCenterTimer()
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____G_3 = _G
    local onTick10ms = ____G_3.onTick10ms
    onTick10ms(nil, onCastBarCenterTimerTick)
end
--- 创建 UI + 入表 + 确保 tick 已注册
function ____exports.startCastBar(colorId, totalTime, customString)
    local data = createCastBarUI(colorId, totalTime, customString)
    if not data then
        return
    end
    local handleId = getNextHandleId()
    ____exports.castBarDataMap:set(handleId, data)
    ensureRegisteredToCenterTimer()
end
return ____exports
