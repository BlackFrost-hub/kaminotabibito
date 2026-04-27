--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001 = require("系统.09．表现系统.02．对话框系统.16．对话框同步状态")
local setActivePlayerId = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.setActivePlayerId
local japi = require("jass.japi")
local jass = require("jass.common")
____exports.DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav"
--- 对话框系统固定为 4 个玩家槽位：P1~P4。
____exports.MAX_PLAYERS = 4
____exports.TOC_PATH = "ui\\StarGameUI.toc"
____exports.TAG_BASE_MAIN = 1024
____exports.TAG_BASE_PORTRAIT = 1125
____exports.DEFAULT_FONT = "UI\\uizt.ttf"
____exports.DEFAULT_TITLE_FONT_SIZE = 0.018
____exports.DEFAULT_BODY_FONT_SIZE = 0.012
____exports.DEFAULT_BG_TEX = "UI\\wenbenkuang.blp"
____exports.DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp"
--- ~ 键 VK_OEM_3（192）；注册须走数字 VK，见 `封装函数/04．硬件输入/04．键盘函数` 中 registerKeyBindToTrigger
____exports.KEY_SKIP_DIALOG = 192
____exports.g_states = {}
____exports.g_questCallbacksByPlayer = {}
function ____exports.dzShow(self, f, b)
    if f and f ~= 0 then
        japi.DzFrameShow(f, b)
    end
end
function ____exports.dzSetText(self, f, s)
    if f and f ~= 0 then
        japi.DzFrameSetText(f, s)
    end
end
function ____exports.dzSetTexture(self, f, path)
    if f and f ~= 0 then
        japi.DzFrameSetTexture(f, path, 0)
    end
end
function ____exports.dzSetAlpha(self, f, a)
    if f and f ~= 0 then
        japi.DzFrameSetAlpha(f, a)
    end
end
function ____exports.dzSetPriority(self, f, p)
    if f and f ~= 0 then
        pcall(function () return japi.DzFrameSetPriority(f, p) end
        )
    end
end
function ____exports.dzSetAbsPoint(self, f, point, x, y)
    if f and f ~= 0 then
        japi.DzFrameSetAbsolutePoint(f, point, x, y)
    end
end
function ____exports.dzSetSize(self, f, w, h)
    if f and f ~= 0 then
        japi.DzFrameSetSize(f, w, h)
    end
end
function ____exports.dzClearPoints(self, f)
    if f and f ~= 0 then
        japi.DzFrameClearAllPoints(f)
    end
end
function ____exports.dzSetEnable(self, f, b)
    if f and f ~= 0 then
        japi.DzFrameSetEnable(f, b)
    end
end
function ____exports.dzSetFont(self, f, font, size)
    if f and f ~= 0 then
        japi.DzFrameSetFont(f, font, size, 0)
    end
end
function ____exports.dzCreate(self, template, tag)
    local gameUI = japi.DzGetGameUI()
    if not gameUI or gameUI == 0 then
        return 0
    end
    return japi.DzCreateFrame(template, gameUI, tag)
end
function ____exports.dzGetLocalPlayer(self)
    return jass.GetLocalPlayer()
end
function ____exports.dzGetPlayerId(self, p)
    return jass.GetPlayerId(p)
end
function ____exports.dzPlayer(self, index)
    return jass.Player(index)
end
function ____exports.dzTimerCreate(self)
    return jass.CreateTimer()
end
function ____exports.dzTimerStart(self, t, timeout, periodic, cb)
    if t then
        jass.TimerStart(t, timeout, periodic, cb)
    end
end
function ____exports.dzTimerPause(self, t)
    if t then
        jass.PauseTimer(t)
    end
end
function ____exports.dzLoadToc(self)
    japi.DzLoadToc(____exports.TOC_PATH)
end
local g_tocLoaded = false
function ____exports.dzLoadTocOnce(self)
    if g_tocLoaded then
        return
    end
    g_tocLoaded = true
    ____exports.dzLoadToc(nil)
end
--- 联机：~ / DzSync 交错时保证 g_questCallbacksByPlayer 与 queue[0].questCallbacks 同源；否则接受/拒绝 resolve 不对称 → 掉线
function ____exports.syncQuestCallbacksTableFromQueueHead(self, state)
    if #state.queue == 0 then
        return
    end
    local e = state.queue[1]
    if not e.isQuest or not e.questCallbacks then
        return
    end
    ____exports.g_questCallbacksByPlayer[state.playerId + 1] = {onAccept = e.questCallbacks.onAccept, onReject = e.questCallbacks.onReject}
    setActivePlayerId(nil, state.playerId)
end
--- 在玩家队列中找第一个任务行（不要求必须是队首）。
-- ~ 键跳过后队首可能仍是普通行（本地视觉快进不修改队列），
-- 接受/拒绝时需要从整个队列里找到任务行来执行回调。
function ____exports.findFirstQuestEntryIndex(self, state)
    do
        local i = 0
        while i < #state.queue do
            if state.queue[i + 1].isQuest and state.queue[i + 1].questCallbacks then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
____exports.japi = japi
____exports.jass = jass
return ____exports
