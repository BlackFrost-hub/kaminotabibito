--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3 = require("系统.09．表现系统.01．对话框系统.01．对话框渲染核心")
local MAX_PLAYERS = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.MAX_PLAYERS
local DEFAULT_TITLE_FONT_SIZE = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.DEFAULT_TITLE_FONT_SIZE
local DEFAULT_BODY_FONT_SIZE = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.DEFAULT_BODY_FONT_SIZE
local ensureState = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.ensureState
local initAllStates = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.initAllStates
local getState = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.getState
local dzGetPlayerId = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzGetPlayerId
local dzGetLocalPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzGetLocalPlayer
local showDialogFrames = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.showDialogFrames
local clearState = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.clearState
local dzSetTexture = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzSetTexture
local ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60 = require("系统.09．表现系统.04．NPC对话状态池")
local setFinishCallback = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.setFinishCallback
local ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.01．对话框系统.05．对话框业务逻辑")
local initTypingCallbacks = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.initTypingCallbacks
local playEntry = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.playEntry
local enqueue = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.enqueue
local ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846 = require("系统.09．表现系统.01．对话框系统.04．任务对话框")
local createQuestEntry = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.createQuestEntry
initTypingCallbacks(nil)
--- 初始化对话框系统
function ____exports.initDialogSystem(self)
    initAllStates(nil)
end
--- 为指定玩家添加一条对话（无立绘）
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
        title,
        text,
        duration,
        "",
        "",
        "",
        titleFontSize or DEFAULT_TITLE_FONT_SIZE,
        bodyFontSize or DEFAULT_BODY_FONT_SIZE
    )
end
--- 为指定玩家添加一条对话（带立绘）
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
        title,
        text,
        duration,
        leftPortrait,
        midPortrait,
        rightPortrait,
        titleFontSize or DEFAULT_TITLE_FONT_SIZE,
        bodyFontSize or DEFAULT_BODY_FONT_SIZE
    )
end
--- 清除指定玩家的全部对话队列
function ____exports.clearDialog(self, p)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = getState(nil, pid)
    if not state then
        return
    end
    clearState(nil, state)
end
--- 设置指定玩家是否显示对话框
function ____exports.setDialogShowable(self, p, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    if localPlayer ~= p then
        return
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    state.canShow = visible
    if not visible and state.initialized then
        showDialogFrames(nil, state, false)
    end
end
--- 设置对话框背景贴图
function ____exports.setDialogBGTexture(self, p, path)
    local localPlayer = dzGetLocalPlayer(nil)
    if localPlayer ~= p then
        return
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = getState(nil, pid)
    if not state or not state.initialized then
        return
    end
    dzSetTexture(nil, state.frames[1], path)
end
--- 设置对话框标题栏贴图
function ____exports.setDialogTitleTexture(self, p, path)
    local localPlayer = dzGetLocalPlayer(nil)
    if localPlayer ~= p then
        return
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = getState(nil, pid)
    if not state or not state.initialized then
        return
    end
    dzSetTexture(nil, state.frames[2], path)
end
--- 查询对话框是否正在显示
function ____exports.isDialogActive(self, p)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return false
    end
    local state = getState(nil, pid)
    if not state then
        return false
    end
    return state.isActive
end
--- 注册对话结束回调
function ____exports.setDialogFinishCallback(self, p, callback)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    setFinishCallback(nil, pid, callback)
end
--- 显示任务对话框
function ____exports.displayQuest(self, p, title, text, onAccept, onReject)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    local entry = createQuestEntry(
        nil,
        title,
        text,
        {onAccept = onAccept, onReject = onReject},
        DEFAULT_TITLE_FONT_SIZE,
        DEFAULT_BODY_FONT_SIZE
    )
    local wasEmpty = #state.queue == 0
    local ____state_queue_0 = state.queue
    ____state_queue_0[#____state_queue_0 + 1] = entry
    if wasEmpty then
        playEntry(nil, state)
    end
end
do
    local ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60 = require("系统.09．表现系统.04．NPC对话状态池")
    ____exports.setDialogNpcUnit = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.setDialogNpcUnit
    ____exports.isNpcOccupied = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.isNpcOccupied
    ____exports.tryOccupyNpc = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.tryOccupyNpc
end
return ____exports
