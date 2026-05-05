--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.04．翻页UI预研.00．常量定义")
local PAGE_TEST_CENTER_X = ____00_FF0E_5E38_91CF_5B9A_4E49.PAGE_TEST_CENTER_X
local PAGE_TEST_CENTER_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.PAGE_TEST_CENTER_Y
local PAGE_TEST_FLIP_DURATION = ____00_FF0E_5E38_91CF_5B9A_4E49.PAGE_TEST_FLIP_DURATION
local PAGE_TEST_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.PAGE_TEST_HEIGHT
local PAGE_TEST_HOTSPOT_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.PAGE_TEST_HOTSPOT_HEIGHT
local PAGE_TEST_HOTSPOT_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.PAGE_TEST_HOTSPOT_WIDTH
local PAGE_TEST_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.PAGE_TEST_WIDTH
local ____01_FF0E_8D44_6E90_5B9A_4E49 = require("系统.09．表现系统.04．翻页UI预研.01．资源定义")
local PAGE_TEST_BASE_TEXTURE = ____01_FF0E_8D44_6E90_5B9A_4E49.PAGE_TEST_BASE_TEXTURE
local PAGE_TEST_FLIP_TEXTURES = ____01_FF0E_8D44_6E90_5B9A_4E49.PAGE_TEST_FLIP_TEXTURES
local PAGE_TEST_INDICATOR_TEXTURE = ____01_FF0E_8D44_6E90_5B9A_4E49.PAGE_TEST_INDICATOR_TEXTURE
local jass = require("jass.common")
local japi = require("jass.japi")
local ____Frame_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local pageBaseFrame = nil
local pageFlipFrames = {}
local pageIndicatorFrame = nil
local pageHotspotFrame = nil
local pageHotspotHintTextFrame = nil
local pageBodyTextFrame = nil
local pageTestInitDone = false
local pageFlipTimer = nil
local pageFlipAnimating = false
local pageFlipTargetPlayerId = -1
local pageFlipFrameIndex = 0
local pageBodyTextPageIndex = 0
local pageBodyTextPendingPageIndex = 0
local PAGE_BASE_PRIORITY = 0
local PAGE_FLIP_PRIORITY_START = 1000
local PAGE_INDICATOR_PRIORITY = 2000
local PAGE_HOTSPOT_PRIORITY = 3000
local PAGE_HOTSPOT_HINT_COLOR_R = 201
local PAGE_HOTSPOT_HINT_COLOR_G = 160
local PAGE_HOTSPOT_HINT_COLOR_B = 103
local PAGE_HOTSPOT_HINT_COLOR_A = 255
local PAGE_HOTSPOT_HINT_OFFSET_X = 0
local PAGE_HOTSPOT_HINT_OFFSET_Y = 0
local PAGE_HOTSPOT_HINT_TEXT = "点击右下角翻页"
local PAGE_BODY_TEXT_PAGE_1 = "这是第一页的正文测试文本。\n\n用于确认底座正文区域的排版位置是否正确。"
local PAGE_BODY_TEXT_PAGE_2 = "这是第二页的正文测试文本。\n\n翻页动画结束后，正文会切换到这一页的内容。"
local PAGE_BODY_TEXTS = {PAGE_BODY_TEXT_PAGE_1, PAGE_BODY_TEXT_PAGE_2}
local PAGE_BODY_TEXT_PRIORITY = 100
local PAGE_BODY_TEXT_FONT = "UI\\uizt.ttf"
local PAGE_BODY_TEXT_FONT_SIZE = 0.0126
local PAGE_BODY_TEXT_WIDTH = 0.24
local PAGE_BODY_TEXT_HEIGHT = 0.28
local PAGE_BODY_TEXT_OFFSET_X = 0.052
local PAGE_BODY_TEXT_OFFSET_Y = -0.085
local PAGE_EVENT_MOUSE_CLICK = 1
local PAGE_EVENT_MOUSE_ENTER = 2
local PAGE_EVENT_MOUSE_LEAVE = 3
local function isLocalRenderTargetPlayer(self)
    local localPlayer = jass.GetLocalPlayer()
    if not localPlayer or localPlayer == 0 then
        return false
    end
    return jass.GetPlayerId(localPlayer) == pageFlipTargetPlayerId
end
local function showFrameLocal(self, frame, visible)
    if not frame or frame == 0 then
        return
    end
    if not isLocalRenderTargetPlayer(nil) then
        return
    end
    japi.DzFrameShow(frame, visible)
end
local function showIndicatorLocal(self, visible)
    if not pageIndicatorFrame or pageIndicatorFrame == 0 then
        return
    end
    japi.DzFrameShow(pageIndicatorFrame, visible)
end
local function hideAllFlipFramesLocal(self)
    do
        local i = 0
        while i < #pageFlipFrames do
            showFrameLocal(nil, pageFlipFrames[i + 1], false)
            i = i + 1
        end
    end
end
local function stopPageFlipTimer(self)
    if not pageFlipTimer or pageFlipTimer == 0 then
        return
    end
    jass.PauseTimer(pageFlipTimer)
end
local function getPageBodyText(self, pageIndex)
    return PAGE_BODY_TEXTS[pageIndex + 1] or PAGE_BODY_TEXTS[1]
end
local function applyCurrentPageBodyTextLocal(self)
    if not pageBodyTextFrame or pageBodyTextFrame == 0 then
        return
    end
    if not isLocalRenderTargetPlayer(nil) then
        return
    end
    japi.DzFrameSetText(
        pageBodyTextFrame,
        getPageBodyText(nil, pageBodyTextPageIndex)
    )
end
local function onPageFlipTimerTick(self)
    if not pageFlipAnimating then
        stopPageFlipTimer(nil)
        return
    end
    if pageFlipFrameIndex >= #PAGE_TEST_FLIP_TEXTURES then
        pageFlipAnimating = false
        pageBodyTextPageIndex = pageBodyTextPendingPageIndex
        applyCurrentPageBodyTextLocal(nil)
        hideAllFlipFramesLocal(nil)
        stopPageFlipTimer(nil)
        return
    end
    hideAllFlipFramesLocal(nil)
    showFrameLocal(nil, pageFlipFrames[pageFlipFrameIndex + 1], true)
    pageFlipFrameIndex = pageFlipFrameIndex + 1
end
local function startPageFlipForPlayer(self, player)
    if pageFlipAnimating then
        return
    end
    if not pageBaseFrame or pageBaseFrame == 0 then
        return
    end
    if #pageFlipFrames <= 0 then
        return
    end
    if not pageFlipTimer or pageFlipTimer == 0 then
        return
    end
    pageFlipAnimating = true
    pageFlipTargetPlayerId = jass.GetPlayerId(player)
    pageBodyTextPendingPageIndex = pageBodyTextPageIndex == 0 and 1 or 0
    hideAllFlipFramesLocal(nil)
    showIndicatorLocal(nil, false)
    showFrameLocal(nil, pageFlipFrames[1], true)
    pageFlipFrameIndex = 1
    local frameCount = #PAGE_TEST_FLIP_TEXTURES
    if frameCount <= 0 then
        pageFlipAnimating = false
        return
    end
    jass.TimerStart(pageFlipTimer, PAGE_TEST_FLIP_DURATION / frameCount, true, onPageFlipTimerTick)
end
local function ensurePageFlipTimer(self)
    if pageFlipTimer and pageFlipTimer ~= 0 then
        return
    end
    pageFlipTimer = jass.CreateTimer()
end
local function onPageHotspotEnter(self)
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer and localPlayer ~= 0 then
        pageFlipTargetPlayerId = jass.GetPlayerId(localPlayer)
    end
    if not pageFlipAnimating and #pageFlipFrames > 0 then
        hideAllFlipFramesLocal(nil)
        showFrameLocal(nil, pageFlipFrames[1], true)
    end
    showIndicatorLocal(nil, true)
end
local function onPageHotspotLeave(self)
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer and localPlayer ~= 0 then
        pageFlipTargetPlayerId = jass.GetPlayerId(localPlayer)
    end
    if not pageFlipAnimating then
        hideAllFlipFramesLocal(nil)
    end
    showIndicatorLocal(nil, false)
end
local function onPageHotspotClick(self)
    local player = jass.GetLocalPlayer()
    if not player or player == 0 then
        return
    end
    startPageFlipForPlayer(nil, player)
end
local function createSizedBackdropFrame(self, name, texture, priority)
    local parent = japi.DzGetGameUI()
    if not parent or parent == 0 then
        return nil
    end
    local frame = japi.DzCreateFrameByTagName(
        "BACKDROP",
        name,
        parent,
        "template",
        0
    )
    if not frame or frame == 0 then
        return nil
    end
    japi.DzFrameSetSize(frame, PAGE_TEST_WIDTH, PAGE_TEST_HEIGHT)
    japi.DzFrameSetAbsolutePoint(frame, 4, PAGE_TEST_CENTER_X, PAGE_TEST_CENTER_Y)
    japi.DzFrameSetTexture(frame, texture, 0)
    japi.DzFrameSetPriority(frame, priority)
    return frame
end
local function createPageBaseFrame(self)
    return createSizedBackdropFrame(nil, "PageFlipUiResearchBase", PAGE_TEST_BASE_TEXTURE, PAGE_BASE_PRIORITY)
end
local function createPageIndicatorFrame(self)
    local frame = createSizedBackdropFrame(nil, "PageFlipUiResearchIndicator", PAGE_TEST_INDICATOR_TEXTURE, PAGE_INDICATOR_PRIORITY)
    if not frame or frame == 0 then
        return nil
    end
    japi.DzFrameShow(frame, false)
    return frame
end
local function createPageFlipFrames(self)
    local frames = {}
    do
        local i = 0
        while i < #PAGE_TEST_FLIP_TEXTURES do
            do
                local frame = createSizedBackdropFrame(
                    nil,
                    "PageFlipUiResearchOverlay" .. tostring(i + 1),
                    PAGE_TEST_FLIP_TEXTURES[i + 1],
                    PAGE_FLIP_PRIORITY_START + i
                )
                if not frame or frame == 0 then
                    goto __continue45
                end
                japi.DzFrameShow(frame, false)
                frames[#frames + 1] = frame
            end
            ::__continue45::
            i = i + 1
        end
    end
    return frames
end
local function createPageHotspotFrame(self)
    local parent = japi.DzGetGameUI()
    if not parent or parent == 0 then
        return nil
    end
    if not pageBaseFrame or pageBaseFrame == 0 then
        return nil
    end
    local frame = japi.DzCreateFrameByTagName(
        "GLUETEXTBUTTON",
        "PageFlipUiResearchHotspot",
        parent,
        "template",
        0
    )
    if not frame or frame == 0 then
        return nil
    end
    japi.DzFrameSetSize(frame, PAGE_TEST_HOTSPOT_WIDTH, PAGE_TEST_HOTSPOT_HEIGHT)
    japi.DzFrameSetPoint(
        frame,
        8,
        pageBaseFrame,
        8,
        0,
        0
    )
    japi.DzFrameSetText(frame, "")
    japi.DzFrameSetAlpha(frame, 0)
    japi.DzFrameSetPriority(frame, PAGE_HOTSPOT_PRIORITY)
    return frame
end
local function createPageHotspotHintFrame(self, hotspotFrame)
    local parent = japi.DzGetGameUI()
    if not parent or parent == 0 then
        return nil
    end
    local hintFrame = japi.DzCreateFrameByTagName(
        "TEXT",
        "PageFlipUiResearchHotspotHint",
        parent,
        "template",
        0
    )
    if hintFrame and hintFrame ~= 0 then
        japi.DzFrameSetSize(hintFrame, PAGE_TEST_HOTSPOT_WIDTH, PAGE_TEST_HOTSPOT_HEIGHT)
        japi.DzFrameSetPoint(
            hintFrame,
            4,
            hotspotFrame,
            4,
            PAGE_HOTSPOT_HINT_OFFSET_X,
            PAGE_HOTSPOT_HINT_OFFSET_Y
        )
        japi.DzFrameSetTextAlignment(hintFrame, -1)
        japi.DzFrameSetTextAlignment(hintFrame, 18)
        japi.DzFrameSetTextColor(
            hintFrame,
            PAGE_HOTSPOT_HINT_COLOR_R,
            PAGE_HOTSPOT_HINT_COLOR_G,
            PAGE_HOTSPOT_HINT_COLOR_B,
            PAGE_HOTSPOT_HINT_COLOR_A
        )
        japi.DzFrameSetPriority(hintFrame, PAGE_HOTSPOT_PRIORITY - 1)
    end
    return hintFrame
end
local function createPageBodyTextFrame(self, baseFrame)
    local parent = japi.DzGetGameUI()
    if not parent or parent == 0 then
        return nil
    end
    local textFrame = japi.DzCreateFrameByTagName(
        "TEXT",
        "PageFlipUiResearchBodyText",
        parent,
        "template",
        0
    )
    if not textFrame or textFrame == 0 then
        return nil
    end
    japi.DzFrameSetSize(textFrame, PAGE_BODY_TEXT_WIDTH, PAGE_BODY_TEXT_HEIGHT)
    japi.DzFrameSetPoint(
        textFrame,
        0,
        baseFrame,
        0,
        PAGE_BODY_TEXT_OFFSET_X,
        PAGE_BODY_TEXT_OFFSET_Y
    )
    japi.DzFrameSetTextAlignment(textFrame, -1)
    japi.DzFrameSetTextAlignment(textFrame, 0)
    japi.DzFrameSetFont(textFrame, PAGE_BODY_TEXT_FONT, PAGE_BODY_TEXT_FONT_SIZE, 0)
    japi.DzFrameSetTextColor(
        textFrame,
        80,
        48,
        24,
        255
    )
    japi.DzFrameSetPriority(textFrame, PAGE_BODY_TEXT_PRIORITY)
    return textFrame
end
local function bindPageHotspotEvents(self, frame)
    local frameSetScriptByCode = ____Frame_5DE5_5177.frameSetScriptByCode
    if type(frameSetScriptByCode) ~= "function" then
        return
    end
    frameSetScriptByCode(
        nil,
        frame,
        PAGE_EVENT_MOUSE_ENTER,
        onPageHotspotEnter,
        false
    )
    frameSetScriptByCode(
        nil,
        frame,
        PAGE_EVENT_MOUSE_LEAVE,
        onPageHotspotLeave,
        false
    )
    frameSetScriptByCode(
        nil,
        frame,
        PAGE_EVENT_MOUSE_CLICK,
        onPageHotspotClick,
        false
    )
end
function ____exports.initPageFlipUiResearchTest(self)
    if pageTestInitDone then
        return
    end
    pageTestInitDone = true
    ensurePageFlipTimer(nil)
    pageBaseFrame = createPageBaseFrame(nil)
    pageIndicatorFrame = createPageIndicatorFrame(nil)
    pageFlipFrames = createPageFlipFrames(nil)
    pageHotspotFrame = createPageHotspotFrame(nil)
    if not pageBaseFrame or pageBaseFrame == 0 then
        return
    end
    pageBodyTextFrame = createPageBodyTextFrame(nil, pageBaseFrame)
    if pageHotspotFrame and pageHotspotFrame ~= 0 then
        pageHotspotHintTextFrame = createPageHotspotHintFrame(nil, pageHotspotFrame)
        bindPageHotspotEvents(nil, pageHotspotFrame)
    end
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer and localPlayer ~= 0 then
        japi.DzFrameShow(pageBaseFrame, false)
        if pageHotspotFrame and pageHotspotFrame ~= 0 then
            japi.DzFrameShow(pageHotspotFrame, false)
        end
        if pageBodyTextFrame and pageBodyTextFrame ~= 0 then
            japi.DzFrameShow(pageBodyTextFrame, false)
        end
        applyCurrentPageBodyTextLocal(nil)
        if pageHotspotHintTextFrame and pageHotspotHintTextFrame ~= 0 then
            japi.DzFrameSetText(pageHotspotHintTextFrame, PAGE_HOTSPOT_HINT_TEXT)
            japi.DzFrameShow(pageHotspotHintTextFrame, false)
        end
    end
end
return ____exports
