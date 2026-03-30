local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local _____4EFB_52A1STES_914D_7F6E_8868 = require("系统.08．任务系统.任务STES配置表")
local QUEST_STES_OBJECTIVE_ROWS = _____4EFB_52A1STES_914D_7F6E_8868.QUEST_STES_OBJECTIVE_ROWS
local _____4EFB_52A1_6570_636E = require("系统.08．任务系统.任务数据")
local questDB = _____4EFB_52A1_6570_636E.questDB
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.任务管理器")
local questManager = _____4EFB_52A1_7BA1_7406_5668.questManager
--- 任务系统 — STES 多事件注册与回调（配置见 任务STES配置表.ts）
-- 
-- 启动时：遍历 QUEST_STES_OBJECTIVE_ROWS 的每个「事件名 → 配置」，为每个事件名单独
-- CreateTrigger + STES_Register（或 Bridge_STES_Register），与 02．物品系统/07．装备提取.ts
-- 单事件注册方式相同，只是这里批量注册。
-- 
-- 运行时：地图触发 STES 事件「某字符串」→ 对应 Trigger 执行 → 根据闭包里的 eventKey 查表
-- → 解析玩家 → 调用 questDB + questManager 更新目标进度。
-- 
-- 玩家 ID 解析顺序（与装备提取类似，便于对照其它系统）：
-- 1) 若 jass.globals.udg_QuestPlayerId 已设为 0–11，优先使用（地图可在触发前写入）；
-- 2) 否则 STES_GetTriggerPlayer（若存在）→ GetTriggerPlayer → 取 GetPlayerId。
local jass = require("jass.common")
local g = require("jass.globals")
local function debugPrint(self, _msg)
end
--- 与装备提取一致：优先直接 STES_Register，否则走全局桥接（每次一对 trigger+string）。
local function registerOneStesEvent(self, trigger, eventName)
    local ____jass_STES_Register_0 = jass.STES_Register
    if ____jass_STES_Register_0 == nil then
        ____jass_STES_Register_0 = g.STES_Register
    end
    local ____jass_STES_Register_0_1 = ____jass_STES_Register_0
    if ____jass_STES_Register_0_1 == nil then
        ____jass_STES_Register_0_1 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_0_1
    if type(STES_Reg) == "function" then
        STES_Reg(nil, trigger, eventName)
    else
        g.udg_RegTrigger = trigger
        g.udg_RegEventStr = eventName
        if type(jass.ExecuteFunc) == "function" then
            jass.ExecuteFunc("Bridge_STES_Register")
        end
    end
end
local function resolveQuestPlayerId(self)
    local fromGlobal = g.udg_QuestPlayerId
    if type(fromGlobal) == "number" and fromGlobal >= 0 and fromGlobal < 16 then
        return fromGlobal
    end
    local pl = nil
    if type(jass.STES_GetTriggerPlayer) == "function" then
        pl = jass.STES_GetTriggerPlayer()
    end
    if pl == nil and type(jass.GetTriggerPlayer) == "function" then
        pl = jass.GetTriggerPlayer()
    end
    if pl ~= nil and type(jass.GetPlayerId) == "function" then
        local id = jass.GetPlayerId(pl)
        if type(id) == "number" and id >= 0 then
            return id
        end
    end
    return nil
end
local function applyObjectiveRow(self, playerId, eventKey, row)
    local pdata = questDB:getPlayerData(playerId)
    if not pdata then
        debugPrint(
            nil,
            (("[任务STES] 无玩家数据 playerId=" .. tostring(playerId)) .. " event=") .. eventKey
        )
        return
    end
    local quest = pdata.quests:get(row.questId)
    if not quest then
        debugPrint(nil, (("[任务STES] 玩家未接任务 questId=" .. row.questId) .. " event=") .. eventKey)
        return
    end
    local obj = __TS__ArrayFind(
        quest.objectives,
        function(____, o) return o.id == row.objectiveId end
    )
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
local function onStesObjectiveEvent(self, eventKey)
    local row = QUEST_STES_OBJECTIVE_ROWS[eventKey]
    if not row then
        debugPrint(nil, "[任务STES] 未配置的事件: " .. eventKey)
        return
    end
    local playerId = resolveQuestPlayerId(nil)
    if playerId == nil then
        debugPrint(nil, "[任务STES] 无法解析玩家 event=" .. eventKey)
        return
    end
    do
        local function ____catch(e)
            debugPrint(
                nil,
                (("[任务STES] 处理异常 event=" .. eventKey) .. " ") .. tostring(e)
            )
        end
        local ____try, ____hasReturned = pcall(function()
            applyObjectiveRow(nil, playerId, eventKey, row)
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
end
local function init(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
        debugPrint(nil, "[任务STES] JASS API 不完整，跳过注册")
        return
    end
    for eventKey in pairs(QUEST_STES_OBJECTIVE_ROWS) do
        do
            local __continue27
            repeat
                local row = QUEST_STES_OBJECTIVE_ROWS[eventKey]
                if not row then
                    __continue27 = true
                    break
                end
                local trig = jass.CreateTrigger()
                local key = eventKey
                jass.TriggerAddAction(
                    trig,
                    function()
                        onStesObjectiveEvent(nil, key)
                    end
                )
                registerOneStesEvent(nil, trig, key)
                __continue27 = true
            until true
            if not __continue27 then
                break
            end
        end
    end
end
init(nil)
return ____exports
