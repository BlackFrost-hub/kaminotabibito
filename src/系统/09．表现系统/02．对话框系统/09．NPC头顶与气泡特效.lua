local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
local cancelBubbleEffectSchedule, removeDelayedCallback, MAX_PLAYERS, BUBBLE_EFFECT_PATH, NPC_BUBBLE_EFFECT_KEY, g_bubbleEffects, g_bubbleScheduleTaskIds, g_npcUnits, g_bubbleScheduleNpcUnit
local ____01_FF0E_5BF9_8BDD_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.01．对话配置表")
local DIALOG_NPC_CONFIGS = ____01_FF0E_5BF9_8BDD_914D_7F6E_8868.DIALOG_NPC_CONFIGS
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local QUEST_CONFIGS = ____02_FF0E_4EFB_52A1_914D_7F6E_8868.QUEST_CONFIGS
local ____03_FF0E_7279_6548 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____03_FF0E_7279_6548.createUnitEffect
local destroyUnitEffect = ____03_FF0E_7279_6548.destroyUnitEffect
function cancelBubbleEffectSchedule(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    local taskId = g_bubbleScheduleTaskIds[playerId + 1]
    if taskId ~= nil then
        removeDelayedCallback(taskId)
        g_bubbleScheduleTaskIds[playerId + 1] = nil
    end
    g_bubbleScheduleNpcUnit[playerId + 1] = nil
end
function ____exports.createBubbleEffect(self, playerId, npcUnit)
    cancelBubbleEffectSchedule(nil, playerId)
    ____exports.destroyBubbleEffect(nil, playerId)
    g_npcUnits[playerId + 1] = npcUnit
    if not npcUnit then
        return
    end
    if createUnitEffect(
        npcUnit,
        "overhead",
        BUBBLE_EFFECT_PATH,
        nil,
        NPC_BUBBLE_EFFECT_KEY
    ) then
        g_bubbleEffects[playerId + 1] = npcUnit
    end
end
function ____exports.destroyBubbleEffect(self, playerId)
    cancelBubbleEffectSchedule(nil, playerId)
    local bubbleUnit = g_bubbleEffects[playerId + 1]
    if bubbleUnit then
        destroyUnitEffect(bubbleUnit, NPC_BUBBLE_EFFECT_KEY)
    end
    g_bubbleEffects[playerId + 1] = nil
end
--- NPC 头顶叹号/问号 + qipao 气泡
-- 对话期间会在问号/叹号和气泡之间切换
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
removeDelayedCallback = ____require_result_0.removeDelayedCallback
MAX_PLAYERS = 4
BUBBLE_EFFECT_PATH = "resource\\models\\qipao.mdx"
local NPC_OVERHEAD_BLUE_EXCL = "resource\\models\\exclamation\\bluetanhao.mdx"
local NPC_OVERHEAD_YELLOW_EXCL = "resource\\models\\exclamation\\yellowtanhao.mdx"
local NPC_OVERHEAD_GRAY_QUESTION = "resource\\models\\exclamation\\huisewenhao.mdx"
local NPC_PROMPT_EFFECT_KEY = "npc_prompt"
NPC_BUBBLE_EFFECT_KEY = "npc_bubble"
g_bubbleEffects = {}
g_bubbleScheduleTaskIds = {}
g_npcUnits = {}
local g_npcOccupiedBy = __TS__New(Map)
local g_npcPromptEffectByHandle = __TS__New(Map)
local function npcPromptHandleKey(self, unit)
    if not unit then
        return 0
    end
    local id = jass.GetUnitTypeId(unit)
    if id ~= nil and id ~= 0 then
        return id
    end
    return jass.GetHandleId(unit)
end
--- 占用表 key：用 GetHandleId（同类型多 NPC 需独立占用，不能用 UnitTypeId）
local function npcOccupationKey(self, unit)
    if not unit then
        return 0
    end
    return jass.GetHandleId(unit)
end
local function dzGetPlayerId(self, p)
    return jass.GetPlayerId(p)
end
--- 兼容旧调用点：标记切换已改为即时执行，目前没有待取消的任务。
function ____exports.cancelPendingNpcMarkerSchedules(self, _npcUnit)
    return
end
local function destroyNpcPromptEffectInternal(self, unit)
    local key = npcPromptHandleKey(nil, unit)
    if key == 0 then
        return false
    end
    local hadQuestMarker = g_npcPromptEffectByHandle:get(key) == true
    destroyUnitEffect(unit, NPC_PROMPT_EFFECT_KEY)
    g_npcPromptEffectByHandle:delete(key)
    return hadQuestMarker
end
local function attachNpcPromptEffect(self, unit, modelPath)
    if not unit or modelPath == "" then
        return
    end
    local key = npcPromptHandleKey(nil, unit)
    if key == 0 then
        return
    end
    destroyNpcPromptEffectInternal(nil, unit)
    if createUnitEffect(
        unit,
        "overhead",
        modelPath,
        nil,
        NPC_PROMPT_EFFECT_KEY
    ) then
        g_npcPromptEffectByHandle:set(key, true)
    end
end
local function npcConfigQualifiesForQuestMarker(self, npc)
    if npc.requireID == nil then
        return false
    end
    local rid = npc.requireID
    local hasDialog = __TS__ArraySome(
        DIALOG_NPC_CONFIGS,
        function(____, d) return d.requireid == rid end
    )
    local hasEnabledQuest = __TS__ArraySome(
        QUEST_CONFIGS,
        function(____, q) return q.requireID == rid and q.enabled ~= false end
    )
    if npc.requireType == "任务" then
        return true
    end
    return hasDialog or hasEnabledQuest
end
function ____exports.tryAttachQuestMarkerForConfigNpc(self, unit, npcConfig)
    if not unit or not npcConfigQualifiesForQuestMarker(nil, npcConfig) then
        return
    end
    if npcConfig.requireType == "对话" then
        attachNpcPromptEffect(nil, unit, NPC_OVERHEAD_BLUE_EXCL)
    else
        attachNpcPromptEffect(nil, unit, NPC_OVERHEAD_YELLOW_EXCL)
    end
end
function ____exports.attachQuestMarkerToUnit(self, unit)
    attachNpcPromptEffect(nil, unit, NPC_OVERHEAD_YELLOW_EXCL)
end
function ____exports.setNpcQuestPromptAcceptedState(self, npcUnit)
    attachNpcPromptEffect(nil, npcUnit, NPC_OVERHEAD_GRAY_QUESTION)
end
____exports.BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY = 0.85
function ____exports.scheduleGrayQuestMarkerAfterBubbleFade(self, npcUnit)
    if not npcUnit then
        return
    end
    local key = npcPromptHandleKey(nil, npcUnit)
    if key == 0 then
        return
    end
    ____exports.setNpcQuestPromptAcceptedState(nil, npcUnit)
end
function ____exports.scheduleYellowQuestMarkerAfterBubbleFade(self, npcUnit)
    if not npcUnit then
        return
    end
    local key = npcPromptHandleKey(nil, npcUnit)
    if key == 0 then
        return
    end
    ____exports.attachQuestMarkerToUnit(nil, npcUnit)
end
function ____exports.removeQuestMarkerAfterNpcTriggered(self, npcUnit)
    ____exports.cancelPendingNpcMarkerSchedules(nil, npcUnit)
    return destroyNpcPromptEffectInternal(nil, npcUnit)
end
local function npcUnitsSameForBubble(self, a, b)
    if a == b then
        return true
    end
    if not a or not b then
        return false
    end
    local ha = jass.GetHandleId(a)
    local hb = jass.GetHandleId(b)
    if ha ~= 0 and ha == hb then
        return true
    end
    return false
end
function ____exports.shouldSkipNewBubbleSchedule(self, playerId, npcUnit)
    if playerId < 0 or playerId >= MAX_PLAYERS or not npcUnit then
        return false
    end
    if not npcUnitsSameForBubble(nil, g_npcUnits[playerId + 1], npcUnit) then
        return false
    end
    if g_bubbleEffects[playerId + 1] then
        return true
    end
    if g_bubbleScheduleTaskIds[playerId + 1] ~= nil then
        return true
    end
    return false
end
--- 延迟气泡回调的 npcUnit 快照（避免闭包捕获 handle）
g_bubbleScheduleNpcUnit = {}
local function runBubbleScheduleForPlayer(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    local npcUnit = g_bubbleScheduleNpcUnit[playerId + 1]
    g_bubbleScheduleNpcUnit[playerId + 1] = nil
    g_bubbleScheduleTaskIds[playerId + 1] = nil
    local uNow = g_npcUnits[playerId + 1]
    if not npcUnitsSameForBubble(nil, uNow, npcUnit) then
        return
    end
    if not uNow or g_npcOccupiedBy:get(npcOccupationKey(nil, uNow)) ~= playerId then
        return
    end
    ____exports.createBubbleEffect(nil, playerId, uNow)
end
local function bubbleScheduleCallbackP0(self)
    runBubbleScheduleForPlayer(nil, 0)
end
local function bubbleScheduleCallbackP1(self)
    runBubbleScheduleForPlayer(nil, 1)
end
local function bubbleScheduleCallbackP2(self)
    runBubbleScheduleForPlayer(nil, 2)
end
local function bubbleScheduleCallbackP3(self)
    runBubbleScheduleForPlayer(nil, 3)
end
local function startBubbleScheduleTask(self, playerId, delay)
    repeat
        local ____switch54 = playerId
        local ____cond54 = ____switch54 == 0
        if ____cond54 then
            g_bubbleScheduleTaskIds[playerId + 1] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP0)
            return
        end
        ____cond54 = ____cond54 or ____switch54 == 1
        if ____cond54 then
            g_bubbleScheduleTaskIds[playerId + 1] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP1)
            return
        end
        ____cond54 = ____cond54 or ____switch54 == 2
        if ____cond54 then
            g_bubbleScheduleTaskIds[playerId + 1] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP2)
            return
        end
        ____cond54 = ____cond54 or ____switch54 == 3
        if ____cond54 then
            g_bubbleScheduleTaskIds[playerId + 1] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP3)
            return
        end
        do
            return
        end
    until true
end
function ____exports.scheduleBubbleEffectAfterOverheadClear(self, playerId, npcUnit, waitForOverheadClearDelay)
    if playerId < 0 or playerId >= MAX_PLAYERS or not npcUnit then
        return
    end
    cancelBubbleEffectSchedule(nil, playerId)
    if not waitForOverheadClearDelay then
        ____exports.createBubbleEffect(nil, playerId, npcUnit)
        return
    end
    g_bubbleScheduleNpcUnit[playerId + 1] = npcUnit
    startBubbleScheduleTask(nil, playerId, ____exports.BUBBLE_CREATE_AFTER_OVERHEAD_CLEAR_DELAY)
end
function ____exports.releaseNpcOccupation(self, playerId)
    local npcUnit = g_npcUnits[playerId + 1]
    if npcUnit then
        local key = npcOccupationKey(nil, npcUnit)
        if key ~= 0 and g_npcOccupiedBy:get(key) == playerId then
            g_npcOccupiedBy:delete(key)
        end
    end
    g_npcUnits[playerId + 1] = nil
end
function ____exports.getNpcUnit(self, playerId)
    return g_npcUnits[playerId + 1]
end
function ____exports.tryOccupyNpc(self, p, npcUnit)
    if not npcUnit then
        return false
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return false
    end
    local key = npcOccupationKey(nil, npcUnit)
    if key == 0 then
        return false
    end
    local occupiedBy = g_npcOccupiedBy:get(key)
    if occupiedBy ~= nil and occupiedBy ~= pid then
        return false
    end
    g_npcOccupiedBy:set(key, pid)
    g_npcUnits[pid + 1] = npcUnit
    return true
end
function ____exports.setDialogNpcUnit(self, p, npcUnit)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    g_npcUnits[pid + 1] = npcUnit
end
return ____exports
