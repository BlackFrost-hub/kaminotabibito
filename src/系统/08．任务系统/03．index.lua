local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____00_FF0E_4EFB_52A1_7CFB_7EDF_4E8C_5206_5F00_5173 = require("系统.08．任务系统.00．任务系统二分开关")
local ENABLE_QUEST_CONFIG_TABLE = ____00_FF0E_4EFB_52A1_7CFB_7EDF_4E8C_5206_5F00_5173.ENABLE_QUEST_CONFIG_TABLE
local ENABLE_QUEST_RUNTIME_CORE = ____00_FF0E_4EFB_52A1_7CFB_7EDF_4E8C_5206_5F00_5173.ENABLE_QUEST_RUNTIME_CORE
local ENABLE_QUEST_UI_MODULE = ____00_FF0E_4EFB_52A1_7CFB_7EDF_4E8C_5206_5F00_5173.ENABLE_QUEST_UI_MODULE
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestDatabase = ____01_FF0E_4EFB_52A1_6570_636E.QuestDatabase
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
do
    local ____export = require("系统.08．任务系统.00．任务系统二分开关")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 注册20个假的主线任务用于测试（状态为进行中，直接显示在UI中）
local function registerDummyMainQuests(self)
    local db = QuestDatabase:getInstance()
    local now = os:time()
    do
        local i = 1
        while i <= 20 do
            local questId = "dummy_main_" .. (i < 10 and "00" .. tostring(i) or (i < 100 and "0" .. tostring(i) or tostring(i)))
            local questDef = {
                id = questId,
                type = QuestType.MAIN,
                title = "测试主线任务 " .. tostring(i),
                description = ("这是第 " .. tostring(i)) .. " 个测试主线任务，用于测试任务UI的显示和刷新。",
                objectives = {{
                    id = questId .. "_obj1",
                    description = "完成目标 1",
                    current = 0,
                    required = 1,
                    completed = false
                }},
                rewards = {{
                    type = "experience",
                    value = 100 * i,
                    description = tostring(100 * i) .. " 经验值"
                }},
                status = QuestStatus.UNDISCOVERED,
                icon = "ReplaceableTextures\\CommandButtons\\BTNScroll.blp",
                createdAt = now,
                updatedAt = now
            }
            db:registerQuest(questDef)
            local activeQuest = __TS__ObjectAssign({}, questDef, {status = QuestStatus.IN_PROGRESS, createdAt = now, updatedAt = now, startTime = now})
            db.globalData.quests:set(questId, activeQuest)
            i = i + 1
        end
    end
end
if ENABLE_QUEST_CONFIG_TABLE then
    require("系统.08．任务系统.00．配置表.index")
end
if ENABLE_QUEST_RUNTIME_CORE then
    require("系统.08．任务系统.01．任务数据")
    local _____4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
    if type(_____4EFB_52A1_7BA1_7406_5668.init) == "function" then
        _____4EFB_52A1_7BA1_7406_5668:init()
    end
    if ENABLE_QUEST_CONFIG_TABLE then
        local ____require_result_0 = require("系统.08．任务系统.04．击杀任务进度")
        local _____521D_59CB_5316_51FB_6740_4EFB_52A1_8FDB_5EA6 = ____require_result_0["初始化击杀任务进度"]
        _____521D_59CB_5316_51FB_6740_4EFB_52A1_8FDB_5EA6()
    end
end
if ENABLE_QUEST_UI_MODULE then
    local manager = require("系统.08．任务系统.02．任务UI拆分.11．任务UI管理器")
    if type(manager.registerHotkey) == "function" then
        manager:registerHotkey()
    end
    if type(manager.initTaskUIForActivePlayers) == "function" then
        manager:initTaskUIForActivePlayers()
    end
end
--- 预留：与 `main` 中 `任务系统.init?.()` 对应；当前初始化已在模块加载时完成。
function ____exports.init(self)
end
return ____exports
