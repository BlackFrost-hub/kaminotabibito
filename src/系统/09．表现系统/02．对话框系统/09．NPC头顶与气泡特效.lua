local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArraySome = ____lualib.__TS__ArraySome
local ____exports = {}
local cancelBubbleEffectSchedule, removeDelayedCallback, MAX_PLAYERS, BUBBLE_EFFECT_PATH, NPC_BUBBLE_EFFECT_KEY, g_bubbleEffects, g_bubbleScheduleTaskIds, g_npcUnits, g_bubbleScheduleNpcUnit
local ____01_FF0E_5BF9_8BDD_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.01．对话配置表")
local _____5BF9_8BDDNPC_914D_7F6E_5217_8868 = ____01_FF0E_5BF9_8BDD_914D_7F6E_8868["对话NPC配置列表"]
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local _____4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_4EFB_52A1_914D_7F6E_8868["任务配置列表"]
local ____03_FF0E_7279_6548 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____03_FF0E_7279_6548.createUnitEffect
local destroyUnitEffect = ____03_FF0E_7279_6548.destroyUnitEffect
local ____09_FF0EYDUserData_5B89_5168_7248 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____09_FF0EYDUserData_5B89_5168_7248.YDWEAngleBetweenUnitsSafe
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
local ____g_npc_914D_7F6E_671D_5411_5217_8868 = {}
local g_npcOccupiedBy = __TS__New(Map)
local g_npcPromptEffectByHandle = __TS__New(Map)
local SetUnitFacing = jass.SetUnitFacing
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
    if npc == nil then
        return false
    end
    if npc["任务ID"] == nil then
        return false
    end
    local rid = npc["任务ID"]
    local hasDialog = __TS__ArraySome(
        _____5BF9_8BDDNPC_914D_7F6E_5217_8868,
        function(____, d) return d["对话ID"] == rid end
    )
    local hasEnabledQuest = __TS__ArraySome(
        _____4EFB_52A1_914D_7F6E_5217_8868,
        function(____, q) return q["任务ID"] == rid and q["启用"] ~= false end
    )
    if npc["类型"] == "任务" then
        return true
    end
    return hasDialog or hasEnabledQuest
end
function ____exports.tryAttachQuestMarkerForConfigNpc(self, unit, npcConfig)
    if not unit or npcConfig == nil or not npcConfigQualifiesForQuestMarker(nil, npcConfig) then
        return
    end
    if npcConfig["类型"] == "对话" then
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
        local ____switch55 = playerId
        local ____cond55 = ____switch55 == 0
        if ____cond55 then
            g_bubbleScheduleTaskIds[playerId + 1] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP0)
            return
        end
        ____cond55 = ____cond55 or ____switch55 == 1
        if ____cond55 then
            g_bubbleScheduleTaskIds[playerId + 1] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP1)
            return
        end
        ____cond55 = ____cond55 or ____switch55 == 2
        if ____cond55 then
            g_bubbleScheduleTaskIds[playerId + 1] = addDelayedCallback(delay * 1000, bubbleScheduleCallbackP2)
            return
        end
        ____cond55 = ____cond55 or ____switch55 == 3
        if ____cond55 then
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
____exports["让对话NPC面向玩家单位"] = function(_____73A9_5BB6ID, ____NPC_5355_4F4D, _____73A9_5BB6_5355_4F4D, _____914D_7F6E_671D_5411)
    if _____73A9_5BB6ID < 0 or _____73A9_5BB6ID >= MAX_PLAYERS then
        return
    end
    if not ____NPC_5355_4F4D or not _____73A9_5BB6_5355_4F4D or _____914D_7F6E_671D_5411 == nil then
        return
    end
    ____g_npc_914D_7F6E_671D_5411_5217_8868[_____73A9_5BB6ID + 1] = _____914D_7F6E_671D_5411
    SetUnitFacing(
        ____NPC_5355_4F4D,
        YDWEAngleBetweenUnitsSafe(____NPC_5355_4F4D, _____73A9_5BB6_5355_4F4D)
    )
end
____exports["恢复对话NPC配置朝向"] = function(_____73A9_5BB6ID)
    if _____73A9_5BB6ID < 0 or _____73A9_5BB6ID >= MAX_PLAYERS then
        return
    end
    local ____NPC_5355_4F4D = g_npcUnits[_____73A9_5BB6ID + 1]
    local _____914D_7F6E_671D_5411 = ____g_npc_914D_7F6E_671D_5411_5217_8868[_____73A9_5BB6ID + 1]
    ____g_npc_914D_7F6E_671D_5411_5217_8868[_____73A9_5BB6ID + 1] = nil
    if not ____NPC_5355_4F4D or _____914D_7F6E_671D_5411 == nil then
        return
    end
    SetUnitFacing(____NPC_5355_4F4D, _____914D_7F6E_671D_5411)
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
