local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local formatTime, setFrameAnimateOffset, showFrame, setFrameText, destroyFrame, updateAllCastBars, ensureRegisteredToCenterTimer, japi, UPDATE_INTERVAL, castBarDataMap, _registeredToCenterTimer, _tickCounter, CENTER_TIMER_TICKS
function formatTime(time)
    local intPart = math.floor(time)
    local decPart = math.floor((time - intPart) * 10)
    return (tostring(intPart) .. ".") .. tostring(decPart)
end
function setFrameAnimateOffset(frame, offset)
    if type(japi.DzFrameSetAnimateOffset) ~= "function" then
        return
    end
    japi.DzFrameSetAnimateOffset(frame, offset)
end
function showFrame(frame, show)
    if type(japi.DzFrameShow) ~= "function" then
        return
    end
    japi.DzFrameShow(frame, show)
end
function setFrameText(frame, text)
    if type(japi.DzFrameSetText) ~= "function" then
        return
    end
    japi.DzFrameSetText(frame, text)
end
function destroyFrame(frame)
    if type(japi.DzDestroyFrame) ~= "function" then
        return
    end
    japi.DzDestroyFrame(frame)
end
function updateAllCastBars()
    local deltaTime = UPDATE_INTERVAL
    for ____, ____value in __TS__Iterator(castBarDataMap) do
        local handleId = ____value[1]
        local data = ____value[2]
        data.elapsedTime = data.elapsedTime + deltaTime
        data.progress = data.elapsedTime / data.totalTime
        local animOffset = 1 - data.progress
        setFrameAnimateOffset(data.foreground, animOffset)
        local remaining = data.totalTime - data.elapsedTime
        setFrameText(
            data.countdown,
            formatTime(math.max(0, remaining))
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
            castBarDataMap:delete(handleId)
        end
    end
end
function ensureRegisteredToCenterTimer()
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
    local onTick10ms = ____require_result_4.onTick10ms
    onTick10ms(
        nil,
        function()
            if castBarDataMap.size == 0 then
                return
            end
            _tickCounter = _tickCounter + 1
            if _tickCounter >= CENTER_TIMER_TICKS then
                _tickCounter = 0
                updateAllCastBars()
            end
        end
    )
end
--- 技能吟唱条系统 - 核心功能
-- 
-- 功能：创建并显示吟唱进度条UI，支持多种颜色主题
-- 不依赖YDLocal存储数据，使用Map存储数据，使用中心计时器
-- 
-- STES子触发模式（与装备提取一致）：
--   JASS端通过 STES_Fire("注册吟唱条") 触发，Lua端作为子触发读取参数：
--   - 颜色ID (integer): 1-7 对应不同颜色
--   - sj (real): 吟唱总时间（秒）
--   - string (string): 自定义提示文本（可选）
-- 
-- 也可通过 showCastBar() 直接从Lua端调用
local jass = require("jass.common")
japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.07．技能吟唱条.00．常量定义")
local CAST_BAR_ENABLED = ____require_result_0.CAST_BAR_ENABLED
UPDATE_INTERVAL = ____require_result_0.UPDATE_INTERVAL
local BAR_POS_X = ____require_result_0.BAR_POS_X
local BAR_POS_Y = ____require_result_0.BAR_POS_Y
local TEXT_OFFSET_X = ____require_result_0.TEXT_OFFSET_X
local TEXT_OFFSET_Y = ____require_result_0.TEXT_OFFSET_Y
local PROGRESS_OFFSET_X = ____require_result_0.PROGRESS_OFFSET_X
local PROGRESS_OFFSET_Y = ____require_result_0.PROGRESS_OFFSET_Y
local SYMBOL_OFFSET_X = ____require_result_0.SYMBOL_OFFSET_X
local COUNTDOWN_OFFSET_X = ____require_result_0.COUNTDOWN_OFFSET_X
local TIP_OFFSET_X = ____require_result_0.TIP_OFFSET_X
local DEFAULT_COLOR_ID = ____require_result_0.DEFAULT_COLOR_ID
local FOREGROUND_MODELS = ____require_result_0.FOREGROUND_MODELS
local BACKGROUND_MODELS = ____require_result_0.BACKGROUND_MODELS
local DEFAULT_CAST_TEXT = ____require_result_0.DEFAULT_CAST_TEXT
local DEFAULT_TIP_TEXT = ____require_result_0.DEFAULT_TIP_TEXT
local EVENT_NAME_CAST_BAR = ____require_result_0.EVENT_NAME_CAST_BAR
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_1.STES_Register
local ____require_result_2 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_2.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_2.ydlStes_finishChildCleanup
local ydlStes_coerceOptionalNumber = ____require_result_2.ydlStes_coerceOptionalNumber
local ydlStes_skeyIndex = ____require_result_2.ydlStes_skeyIndex
local ydlStes_registerAfterGetTable = ____require_result_2.ydlStes_registerAfterGetTable
local ydlStes_readInteger5 = ____require_result_2.ydlStes_readInteger5
local ydlStes_readReal5 = ____require_result_2.ydlStes_readReal5
local ydlStes_readString5 = ____require_result_2.ydlStes_readString5
castBarDataMap = __TS__New(Map)
--- 获取下一个可用的句柄ID
local nextHandleId = 1
local function getNextHandleId(self)
    local ____nextHandleId_3 = nextHandleId
    nextHandleId = ____nextHandleId_3 + 1
    return ____nextHandleId_3
end
--- 获取指定颜色ID的前景模型路径
local function getForegroundModel(colorId)
    return FOREGROUND_MODELS[colorId] or FOREGROUND_MODELS[DEFAULT_COLOR_ID]
end
--- 获取指定颜色ID的背景模型路径
local function getBackgroundModel(colorId)
    return BACKGROUND_MODELS[colorId] or BACKGROUND_MODELS[DEFAULT_COLOR_ID]
end
--- 创建帧
local function createFrame(tagName, name, parent)
    if type(japi.DzCreateFrameByTagName) ~= "function" then
        return nil
    end
    return japi.DzCreateFrameByTagName(
        tagName,
        name,
        parent,
        "template",
        0
    )
end
--- 设置帧的绝对位置
local function setFrameAbsolutePoint(frame, x, y)
    if type(japi.DzFrameSetAbsolutePoint) ~= "function" then
        return
    end
    japi.DzFrameSetAbsolutePoint(frame, 4, x, y)
end
--- 设置帧的相对位置
local function setFramePoint(frame, parent, offsetX, offsetY)
    if type(japi.DzFrameSetPoint) ~= "function" then
        return
    end
    japi.DzFrameSetPoint(
        frame,
        4,
        parent,
        4,
        offsetX,
        offsetY
    )
end
--- 设置帧模型
local function setFrameModel(frame, modelPath)
    if type(japi.DzFrameSetModel) ~= "function" then
        return
    end
    japi.DzFrameSetModel(frame, modelPath, 0, 0)
end
--- 设置帧动画
local function setFrameAnimate(frame, animId, autoPlay)
    if type(japi.DzFrameSetAnimate) ~= "function" then
        return
    end
    japi.DzFrameSetAnimate(frame, animId, autoPlay)
end
--- 设置帧优先级
local function setFramePriority(frame, priority)
    if type(japi.DzFrameSetPriority) ~= "function" then
        return
    end
    japi.DzFrameSetPriority(frame, priority)
end
--- 获取游戏UI
local function getGameUI()
    if type(japi.DzGetGameUI) ~= "function" then
        return nil
    end
    return japi.DzGetGameUI()
end
--- 创建吟唱条UI
local function createCastBar(colorId, totalTime, customString)
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
--- 启动吟唱条
local function startCastBar(colorId, totalTime, customString)
    local data = createCastBar(colorId, totalTime, customString)
    if not data then
        return
    end
    local handleId = getNextHandleId(nil)
    castBarDataMap:set(handleId, data)
    ensureRegisteredToCenterTimer()
end
_registeredToCenterTimer = false
_tickCounter = 0
CENTER_TIMER_TICKS = math.ceil(UPDATE_INTERVAL / 0.01)
local REG_GUARD = "__syzl_castBar_registered"
local TRIG_KEY = "__syzl_castBar_trig"
local ATTEMPT_KEY = "__syzl_castBarRegAttempt"
local MAX_REG_ATTEMPTS = 30
local RETRY_SEC = 0.1
local function onCastBarEvent()
    if not CAST_BAR_ENABLED then
        return
    end
    ydlStes_syncTriggerStep(nil, nil)
    local colorId = ydlStes_readInteger5(nil, nil, "颜色ID") or DEFAULT_COLOR_ID
    local totalTime = ydlStes_readReal5(nil, nil, "sj") or 1
    local customString = ydlStes_readString5(nil, nil, "string") or ""
    ydlStes_finishChildCleanup(nil, nil)
    startCastBar(colorId, totalTime, customString)
end
local function jassStesHashtable()
    local jg = jglobals
    local cands = {jg.STES___HT, jg.STES_HT, jg.udg_STES___HT, jg.udg_STES_HT}
    do
        local i = 0
        while i < #cands do
            local t = cands[i + 1]
            if t ~= nil and t ~= 0 then
                return t
            end
            i = i + 1
        end
    end
    return nil
end
local function countOnJassStesTable(eventName)
    local ht = jassStesHashtable()
    if ht == nil or ht == 0 then
        return -1
    end
    if type(jass.StringHash) ~= "function" or type(jass.LoadInteger) ~= "function" then
        return -1
    end
    local h = jass.StringHash(eventName)
    return jass.LoadInteger(
        ht,
        h,
        ydlStes_skeyIndex(nil, nil)
    )
end
local function scheduleRetry(fn)
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
        fn(nil)
        return
    end
    local tm = jass.CreateTimer()
    jass.TimerStart(
        tm,
        RETRY_SEC,
        false,
        function()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(tm)
            end
            fn(nil)
        end
    )
end
local function tryRegisterCastBarStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        g[REG_GUARD] = true
        return
    end
    if STES_Register == nil then
        g[REG_GUARD] = true
        return
    end
    if g[TRIG_KEY] == nil then
        local trig = jass.CreateTrigger()
        jass.TriggerAddAction(trig, onCastBarEvent)
        g[TRIG_KEY] = trig
    end
    local trig = g[TRIG_KEY]
    ydlStes_registerAfterGetTable(nil, nil, trig, EVENT_NAME_CAST_BAR)
    local jCount = countOnJassStesTable(EVENT_NAME_CAST_BAR)
    local attempt = g[ATTEMPT_KEY] or 0
    g[ATTEMPT_KEY] = attempt + 1
    if jCount >= 1 then
        g[REG_GUARD] = true
        return
    end
    if g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS then
        g[REG_GUARD] = true
        return
    end
    scheduleRetry(function()
        tryRegisterCastBarStes()
    end)
end
local _initialized = false
--- 初始化技能吟唱条系统
function ____exports.init()
    if _initialized then
        return
    end
    if not CAST_BAR_ENABLED then
        return
    end
    _initialized = true
    tryRegisterCastBarStes()
end
--- 手动触发吟唱条（供Lua/TS直接调用）
-- 
-- @param colorId 颜色ID (1-7)
-- @param totalTime 吟唱总时间（秒）
-- @param customString 自定义提示文本（可选）
function ____exports.showCastBar(colorId, totalTime, customString)
    if not CAST_BAR_ENABLED then
        return
    end
    startCastBar(colorId or DEFAULT_COLOR_ID, totalTime, customString or "")
end
return ____exports
