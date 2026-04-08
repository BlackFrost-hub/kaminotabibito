--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local frameSetScriptByCode = ____04_FF0E_786C_4EF6_51FD_6570.frameSetScriptByCode
local ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3 = require("系统.09．表现系统.01．对话框系统.01．对话框渲染核心")
local dzShow = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzShow
local dzGetLocalPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzGetLocalPlayer
local dzPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzPlayer
local onDialogEnd = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.onDialogEnd
--- 接受按钮底图
local ACCEPT_BG_IDX = 5
--- 接受按钮命中层
local ACCEPT_BTN_IDX = 6
--- 拒绝按钮底图
local REJECT_BG_IDX = 7
--- 拒绝按钮命中层
local REJECT_BTN_IDX = 8
--- 接受按钮文字标签
local ACCEPT_LABEL_IDX = 9
--- 拒绝按钮文字标签
local REJECT_LABEL_IDX = 10
--- 显示/隐藏任务接受拒绝按钮
-- 
-- @param state 玩家对话框状态
-- @param visible 是否显示
function ____exports.showQuestButtons(self, state, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[ACCEPT_BG_IDX + 1], visible)
    dzShow(nil, state.frames[ACCEPT_BTN_IDX + 1], visible)
    dzShow(nil, state.frames[ACCEPT_LABEL_IDX + 1], visible)
    dzShow(nil, state.frames[REJECT_BG_IDX + 1], visible)
    dzShow(nil, state.frames[REJECT_BTN_IDX + 1], visible)
    dzShow(nil, state.frames[REJECT_LABEL_IDX + 1], visible)
end
--- 隐藏任务按钮
-- 
-- @param state 玩家对话框状态
function ____exports.hideQuestButtons(self, state)
    ____exports.showQuestButtons(nil, state, false)
end
--- 检查任务按钮是否显示
-- 
-- @param state 玩家对话框状态
function ____exports.areQuestButtonsVisible(self, state)
    local entry = state.queue[1]
    return (entry and entry.isQuest) == true
end
--- 注册任务按钮回调
-- 
-- @param state 玩家对话框状态
-- @param callbacks 接受/拒绝回调
function ____exports.registerQuestCallbacks(self, state, callbacks)
    frameSetScriptByCode(
        nil,
        state.frames[ACCEPT_BTN_IDX + 1],
        1,
        function()
            table.remove(state.queue, 1)
            ____exports.hideQuestButtons(nil, state)
            onDialogEnd(nil, state.playerId)
            callbacks:onAccept()
        end,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[REJECT_BTN_IDX + 1],
        1,
        function()
            table.remove(state.queue, 1)
            ____exports.hideQuestButtons(nil, state)
            onDialogEnd(nil, state.playerId)
            callbacks:onReject()
        end,
        true
    )
end
--- 清除任务按钮回调（设置为无操作）
-- 
-- @param state 玩家对话框状态
function ____exports.clearQuestCallbacks(self, state)
    frameSetScriptByCode(
        nil,
        state.frames[ACCEPT_BTN_IDX + 1],
        1,
        function()
        end,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[REJECT_BTN_IDX + 1],
        1,
        function()
        end,
        true
    )
end
--- 创建任务对话框条目
-- 
-- @param title 任务标题
-- @param text 任务描述
-- @param callbacks 接受/拒绝回调
-- @param titleFontSize 标题字体大小
-- @param bodyFontSize 正文字体大小
function ____exports.createQuestEntry(self, title, text, callbacks, titleFontSize, bodyFontSize)
    return {
        title = title,
        text = text,
        waitTime = 0,
        leftTex = "",
        midTex = "",
        rightTex = "",
        titleFontSize = titleFontSize,
        bodyFontSize = bodyFontSize,
        isQuest = true,
        questCallbacks = callbacks
    }
end
--- 检查当前条目是否为任务
-- 
-- @param state 玩家对话框状态
function ____exports.isQuestMode(self, state)
    local entry = state.queue[1]
    return (entry and entry.isQuest) == true
end
--- 获取当前任务的回调（如果存在）
-- 
-- @param state 玩家对话框状态
function ____exports.getQuestCallbacks(self, state)
    local entry = state.queue[1]
    return entry and entry.questCallbacks
end
return ____exports
