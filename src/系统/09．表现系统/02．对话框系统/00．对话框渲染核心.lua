--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.02．对话框系统.02．对话框业务逻辑")
local createNormalDialogEntry = ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.createNormalDialogEntry
local createQuestDialogEntry = ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.createQuestDialogEntry
local ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001 = require("系统.09．表现系统.02．对话框系统.10．对话框渲染-Dz与状态")
local DEFAULT_BODY_FONT_SIZE = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_BODY_FONT_SIZE
local DEFAULT_TITLE_FONT_SIZE = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_TITLE_FONT_SIZE
local dzGetLocalPlayer = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzGetLocalPlayer
local dzGetPlayerId = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzGetPlayerId
local dzLoadTocOnce = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzLoadTocOnce
local dzSetTexture = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetTexture
local dzShow = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzShow
local g_states = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.g_states
local MAX_PLAYERS = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.MAX_PLAYERS
local ____11_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27 = require("系统.09．表现系统.02．对话框系统.11．对话框渲染-创建帧")
local createDialogFrames = ____11_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27.createDialogFrames
local ____12_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406 = require("系统.09．表现系统.02．对话框系统.12．对话框渲染-播放与状态管理")
local clearState = ____12_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.clearState
local enqueue = ____12_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.enqueue
local ensureState = ____12_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.ensureState
local setQuestSyncHandlersBinder = ____12_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.setQuestSyncHandlersBinder
local ____13_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_4EFB_52A1_56DE_8C03_4E0E_547D_4E2D = require("系统.09．表现系统.02．对话框系统.13．对话框渲染-任务回调与命中")
local bindQuestSyncHandlersImpl = ____13_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_4EFB_52A1_56DE_8C03_4E0E_547D_4E2D.bindQuestSyncHandlersImpl
local initSkipKeyListener = ____13_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_4EFB_52A1_56DE_8C03_4E0E_547D_4E2D.initSkipKeyListener
setQuestSyncHandlersBinder(nil, bindQuestSyncHandlersImpl)
function ____exports.initDialogSystem(self)
    dzLoadTocOnce(nil)
    initSkipKeyListener(nil)
end
--- 玩家英雄注册回调。
-- 为注册英雄的玩家创建对话框UI。
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    local jass = require("jass.common")
    local playerId = jass.GetPlayerId(whichPlayer)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, playerId)
    if not state.initialized then
        state.frames = createDialogFrames(nil, playerId)
        state.initialized = true
    end
    bindQuestSyncHandlersImpl(nil, state)
end
function ____exports.displayText(self, p, title, text, duration, titleFontSize, bodyFontSize)
    if duration <= 0 then
        duration = 1
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    enqueue(
        nil,
        state,
        createNormalDialogEntry(
            nil,
            title,
            text,
            duration,
            "",
            "",
            "",
            titleFontSize or DEFAULT_TITLE_FONT_SIZE,
            bodyFontSize or DEFAULT_BODY_FONT_SIZE
        )
    )
end
function ____exports.displayTextEx(self, p, title, text, duration, leftPortrait, midPortrait, rightPortrait, titleFontSize, bodyFontSize)
    if duration <= 0 then
        duration = 1
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    enqueue(
        nil,
        state,
        createNormalDialogEntry(
            nil,
            title,
            text,
            duration,
            leftPortrait,
            midPortrait,
            rightPortrait,
            titleFontSize or DEFAULT_TITLE_FONT_SIZE,
            bodyFontSize or DEFAULT_BODY_FONT_SIZE
        )
    )
end
function ____exports.clearDialog(self, p)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = g_states[pid + 1]
    if not state then
        return
    end
    clearState(nil, state)
end
function ____exports.setDialogShowable(self, p, visible)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    state.canShow = visible
    local localPlayer = dzGetLocalPlayer(nil)
    if localPlayer ~= p then
        return
    end
    if not visible and state.initialized then
        do
            local i = 0
            while i < 9 do
                dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
        dzShow(nil, state.frames[12], false)
        dzShow(nil, state.frames[13], false)
        do
            local i = 101
            while i < 104 do
                dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
    end
end
function ____exports.setDialogBGTexture(self, p, path)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = g_states[pid + 1]
    if not state or not state.initialized then
        return
    end
    dzSetTexture(nil, state.frames[1], path)
end
function ____exports.setDialogTitleTexture(self, p, path)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = g_states[pid + 1]
    if not state or not state.initialized then
        return
    end
    dzSetTexture(nil, state.frames[2], path)
end
function ____exports.isDialogActive(self, p)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return false
    end
    local state = g_states[pid + 1]
    return not not state and state.isActive
end
function ____exports.setDialogFinishCallback(self, p, callback)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    state.onFinish = callback
end
function ____exports.displayQuest(self, p, title, text, onAccept, onReject, acceptText, rejectText)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    enqueue(
        nil,
        state,
        createQuestDialogEntry(
            nil,
            title,
            text,
            DEFAULT_TITLE_FONT_SIZE,
            DEFAULT_BODY_FONT_SIZE,
            {onAccept = onAccept, onReject = onReject},
            acceptText,
            rejectText
        )
    )
end
return ____exports
