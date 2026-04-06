--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_4EFB_52A1STES_914D_7F6E_8868 = require("系统.08．任务系统.04．任务STES配置表")
local QUEST_STES_OBJECTIVE_ROWS = ____04_FF0E_4EFB_52A1STES_914D_7F6E_8868.QUEST_STES_OBJECTIVE_ROWS
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.questManager
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
--- 注册简单的 STES 桥接事件（用于任务接受/完成等单事件）
-- 
-- @param eventName STES 事件名
-- @param onEvent 事件回调
-- @param debugMsg 调试信息前缀
function ____exports.registerSimpleSTESBridgeEvent(self, eventName, onEvent, debugMsg)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.ExecuteFunc) ~= "function" then
        debugPrint(nil, ("JASS API 不完整，无法注册" .. debugMsg) .. "事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
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
        end
    )
    g.udg_RegTrigger = trig
    g.udg_RegEventStr = eventName
    jass.ExecuteFunc("Bridge_STES_Register")
    debugPrint(nil, "已通过 Bridge_STES_Register 注册 " .. eventName)
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
    local ____opt_2 = questDB.globalData
    if ____opt_2 ~= nil then
        ____opt_2 = ____opt_2.quests:get(row.questId)
    end
    local quest = ____opt_2
    if not quest then
        debugPrint(nil, (("[任务STES] 未接任务 questId=" .. row.questId) .. " event=") .. eventKey)
        return
    end
    local obj = quest.objectives:find(function(____, o) return o.id == row.objectiveId end)
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
            local __continue31
            repeat
                local row = QUEST_STES_OBJECTIVE_ROWS[eventKey]
                if not row then
                    __continue31 = true
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
                __continue31 = true
            until true
            if not __continue31 then
                break
            end
        end
    end
end
init(nil)
return ____exports
