--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local ____index = require("系统.08．任务系统.02．任务管理器.index")
local questManager = ____index.questManager
local ____05_FF0E_4EFB_52A1STES_914D_7F6E_8868 = require("系统.08．任务系统.05．任务STES配置表")
local QUEST_STES_OBJECTIVE_ROWS = ____05_FF0E_4EFB_52A1STES_914D_7F6E_8868.QUEST_STES_OBJECTIVE_ROWS
--- 任务系统 — STES 多事件注册与回调（配置见 `05．任务STES配置表.ts`）
-- 
-- =============================================================================
-- 传参方式（与 `05．BuffJASS桥接` / `07．装备提取` 一致：YDLocal5 子触发、中文变量名）
-- =============================================================================
-- 父触发在 `YDLocalExecuteTrigger` + `YDTriggerExecuteTrigger` 之前写入子触发传参区：
-- 
-- | YDLocal 类型 | 变量名 | 说明 |
-- |--------------|--------|------|
-- | boolean | **任务使用预设玩家编号** | `true`：使用下列整数；`false` 或未写：从 **STES_GetTriggerPlayer** / **GetTriggerPlayer** 推断 |
-- | integer | **任务玩家编号** | 仅在上一项为 `true` 时有效，War3 玩家 ID **0–15** |
-- 
-- Lua 入口先 **`YDLocalExecuteTrigger(GetTriggeringTrigger())`**（见 `ydlStes_syncTriggerStep`）再读参；**`finally`** 里
-- **`ydlStes_finishChildCleanup`**（父页 `G_SIndex`/`G_LIndex` + `clearStar_PIndex`）。
-- 
-- （已废弃：依赖 **`udg_QuestPlayerId`** 全局；请改在触发前 **`YDLocal5Set`** 上述变量。）
-- 
-- =============================================================================
-- 运行时
-- =============================================================================
-- 地图触发 STES 事件名 → 对应 Trigger → 闭包内 `eventKey` 查 `QUEST_STES_OBJECTIVE_ROWS`
-- → 解析玩家 → **`questManager.updateQuestObjective`**。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_0.STES_Register
local ____require_result_1 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_1.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_1.ydlStes_finishChildCleanup
local ydlStes_readBoolean5 = ____require_result_1.ydlStes_readBoolean5
local ydlStes_readInteger5 = ____require_result_1.ydlStes_readInteger5
local ydlStes_registerAfterGetTable = ____require_result_1.ydlStes_registerAfterGetTable
--- 与地图 YDLocal5Set 对齐
local YL_BOOL_USE_PRESET_PLAYER = "任务使用预设玩家编号"
local YL_INT_PLAYER_ID = "任务玩家编号"
local function debugPrint(self, _msg)
end
--- 从触发器关联玩家取 ID（未用预设编号时）
local function resolvePlayerIdFromTrigger()
    local pl = nil
    if type(jass.STES_GetTriggerPlayer) == "function" then
        pl = jass.STES_GetTriggerPlayer()
    end
    if pl == nil and type(jass.GetTriggerPlayer) == "function" then
        pl = jass.GetTriggerPlayer()
    end
    if pl ~= nil and type(jass.GetPlayerId) == "function" then
        local id = jass.GetPlayerId(pl)
        if type(id) == "number" and id >= 0 and id < 16 then
            return id
        end
    end
    return nil
end
--- 先 **`syncYdlTriggerStepForChild`** 再调用本函数。
-- - **任务使用预设玩家编号** = true → **任务玩家编号** 须在 0–15。
-- - 否则走触发器玩家。
local function resolveTaskStesPlayerId()
    if ydlStes_readBoolean5(nil, nil, YL_BOOL_USE_PRESET_PLAYER) then
        local id = ydlStes_readInteger5(nil, nil, YL_INT_PLAYER_ID)
        if id >= 0 and id < 16 then
            return id
        end
        return nil
    end
    return resolvePlayerIdFromTrigger()
end
local function findObjective(self, quest, objectiveId)
    local list = quest.objectives
    do
        local i = 0
        while i < #list do
            local o = list[i + 1]
            if o.id == objectiveId then
                return o
            end
            i = i + 1
        end
    end
    return nil
end
local function applyObjectiveRow(self, playerId, eventKey, row)
    local quest = questDB:getQuest(row.questId)
    if not quest then
        debugPrint(nil, (("[任务STES] 未找到任务 questId=" .. row.questId) .. " event=") .. eventKey)
        return
    end
    local obj = findObjective(nil, quest, row.objectiveId)
    if not obj then
        debugPrint(nil, (("[任务STES] 无目标 objectiveId=" .. row.objectiveId) .. " event=") .. eventKey)
        return
    end
    local next
    if row.mode == "set" then
        next = row.amount
    else
        next = obj.current + row.amount
    end
    questManager:updateQuestObjective(playerId, row.questId, row.objectiveId, next)
end
local function runStesObjectiveCallback(self, eventKey)
    do
        local function ____catch(e)
            debugPrint(
                nil,
                (("[任务STES] 处理异常 event=" .. eventKey) .. " ") .. tostring(e)
            )
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            ydlStes_syncTriggerStep(nil, nil)
            local row = QUEST_STES_OBJECTIVE_ROWS[eventKey]
            if not row then
                debugPrint(nil, "[任务STES] 未配置的事件: " .. eventKey)
                return true
            end
            local playerId = resolveTaskStesPlayerId()
            if playerId == nil then
                debugPrint(nil, "[任务STES] 无法解析玩家 event=" .. eventKey)
                return true
            end
            applyObjectiveRow(nil, playerId, eventKey, row)
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        do
            ydlStes_finishChildCleanup(nil, nil)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
local function registerOneStesEvent(self, trigger, eventName)
    if STES_Register == nil then
        debugPrint(nil, "STES_Register 不可用，无法注册 " .. eventName)
        return
    end
    ydlStes_registerAfterGetTable(nil, nil, trigger, eventName)
end
--- 注册简单 STES 回调（无任务表、无 objective 逻辑时可用）。
-- 同样做 YDLocal 同步与父页恢复，便于父触发里已写 YDLocal5 时读参一致。
function ____exports.registerSimpleSTESBridgeEvent(self, eventName, onEvent, debugMsg)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        debugPrint(nil, ("JASS API 不完整，无法注册" .. debugMsg) .. "事件")
        return
    end
    if STES_Register == nil then
        debugPrint(nil, ("STES_Register 不可用，无法注册" .. debugMsg) .. "事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            do
                pcall(function()
                    ydlStes_syncTriggerStep(nil, nil)
                    debugPrint(nil, debugMsg .. "事件触发...")
                    do
                        local function ____catch(____error)
                            debugPrint(
                                nil,
                                (("处理" .. debugMsg) .. "事件时出错: ") .. tostring(____error)
                            )
                        end
                        local ____try, ____hasReturned = pcall(function()
                            onEvent(nil)
                        end)
                        if not ____try then
                            ____catch(____hasReturned)
                        end
                    end
                end)
                do
                    ydlStes_finishChildCleanup(nil, nil)
                end
            end
        end
    )
    ydlStes_registerAfterGetTable(nil, nil, trig, eventName)
    debugPrint(nil, ("已注册 " .. eventName) .. " 事件")
end
local function init(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        debugPrint(nil, "[任务STES] JASS API 不完整，跳过注册")
        return
    end
    if STES_Register == nil then
        debugPrint(nil, "[任务STES] STES_Register 不可用，跳过注册")
        return
    end
    for eventKey in pairs(QUEST_STES_OBJECTIVE_ROWS) do
        do
            local row = QUEST_STES_OBJECTIVE_ROWS[eventKey]
            if not row then
                goto __continue39
            end
            local trig = jass.CreateTrigger()
            local key = eventKey
            jass.TriggerAddAction(
                trig,
                function()
                    runStesObjectiveCallback(nil, key)
                end
            )
            registerOneStesEvent(nil, trig, key)
        end
        ::__continue39::
    end
end
init(nil)
return ____exports
