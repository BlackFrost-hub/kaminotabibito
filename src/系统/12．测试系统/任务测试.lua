--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.questManager
local ____03_FF0E_4EFB_52A1UI = require("系统.08．任务系统.03．任务UI")
local taskUI = ____03_FF0E_4EFB_52A1UI.taskUI
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local registerKeyDown = ____04_FF0E_786C_4EF6_51FD_6570.registerKeyDown
local KEY_LETTER = ____04_FF0E_786C_4EF6_51FD_6570.KEY_LETTER
--- 任务系统测试
local jass = require("jass.common")
local function debugPrint(self, msg)
    local pr = _G.print
    if pr ~= nil then
        pr("[QuestTest] " .. msg)
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            8,
            "[任务测试] " .. msg
        )
    end
end
--- 测试任务接受和完成
function ____exports.testQuestAcceptComplete(self)
    debugPrint(nil, "开始任务接受/完成测试...")
    local playerId = 0
    questManager:resetPlayerQuests(playerId)
    do
        local i = 1
        while i <= 20 do
            local id = "main_" .. (i < 10 and "00" .. tostring(i) or (i < 100 and "0" .. tostring(i) or "" .. tostring(i)))
            local success = questManager:onQuestAccepted(playerId, id)
            if not success then
                debugPrint(
                    nil,
                    ((("✗ 玩家 " .. tostring(playerId)) .. " 接受任务 ") .. id) .. " 失败"
                )
            end
            i = i + 1
        end
    end
    local completeOrder = {"main_003", "main_002", "main_001"}
    for ____, questId in ipairs(completeOrder) do
        questManager:updateQuestObjective(playerId, questId, "obj1", 5)
        questManager:updateQuestObjective(playerId, questId, "obj2", 1)
        local completeSuccess = questManager:onQuestCompleted(playerId, questId)
        if completeSuccess then
            debugPrint(
                nil,
                (("✓ 玩家 " .. tostring(playerId)) .. " 成功完成任务 ") .. questId
            )
        else
            debugPrint(
                nil,
                ((("✗ 玩家 " .. tostring(playerId)) .. " 完成任务 ") .. questId) .. " 失败"
            )
        end
    end
    local activeQuests = questManager:getPlayerQuests(playerId, QuestType.MAIN)
    debugPrint(
        nil,
        ((("玩家 " .. tostring(playerId)) .. " 进行中的主线任务: ") .. tostring(#activeQuests)) .. " 个（期望 17 个，main_04~main_20）"
    )
    debugPrint(nil, "任务接受/完成测试完成（完成 01~03，其余进行中）")
end
--- 测试UI显示
function ____exports.testUI(self)
    debugPrint(nil, "测试任务UI...")
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil or lp == 0 then
                return
            end
            taskUI:show(0)
            debugPrint(nil, "任务UI已显示")
        end
    )
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local timer = jass.CreateTimer()
        jass.TimerStart(
            timer,
            3,
            false,
            function()
                pcall(function ()
                        if type(jass.GetLocalPlayer) ~= "function" then
                            return
                        end
                        local lp = jass.GetLocalPlayer()
                        if lp == nil or lp == 0 then
                            return
                        end
                        taskUI:hide()
                        debugPrint(nil, "任务UI已隐藏")
                    end
                )
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(timer)
                end
            end
        )
    end
end
--- 测试任务数据
function ____exports.testQuestData(self)
    debugPrint(nil, "测试任务数据...")
    local quest = questDB:getQuest("main_001")
    if quest then
        debugPrint(nil, ((("找到任务: " .. quest.title) .. " (") .. quest.type) .. ")")
        debugPrint(nil, "描述: " .. quest.description)
        debugPrint(
            nil,
            "目标数量: " .. tostring(#quest.objectives)
        )
        debugPrint(
            nil,
            "奖励数量: " .. tostring(#quest.rewards)
        )
    else
        debugPrint(nil, "未找到测试任务")
    end
    local allQuests = questDB:getAllQuests()
    debugPrint(
        nil,
        "总任务数量: " .. tostring(#allQuests)
    )
    local mainQuests = questDB:getQuestsByType(QuestType.MAIN)
    local sideQuests = questDB:getQuestsByType(QuestType.SIDE)
    local dailyQuests = questDB:getQuestsByType(QuestType.DAILY)
    debugPrint(
        nil,
        "主线任务: " .. tostring(#mainQuests)
    )
    debugPrint(
        nil,
        "支线任务: " .. tostring(#sideQuests)
    )
    debugPrint(
        nil,
        "小任务: " .. tostring(#dailyQuests)
    )
end
--- 运行所有测试
function ____exports.runAllTests(self)
    debugPrint(nil, "===== 开始任务系统测试 =====")
    ____exports.testQuestData(nil)
    ____exports.testQuestAcceptComplete(nil)
    ____exports.testUI(nil)
    debugPrint(nil, "===== 任务系统测试完成 =====")
end
function ____exports.registerTestCommand(self)
    if type(registerKeyDown) == "function" then
        registerKeyDown(
            nil,
            KEY_LETTER.Y,
            function(____, player, key)
                local ____temp_2
                if type(jass.GetPlayerId) == "function" then
                    ____temp_2 = jass.GetPlayerId
                else
                    ____temp_2 = nil
                end
                local getPid = ____temp_2
                local ____temp_3
                if getPid and player then
                    ____temp_3 = getPid(player)
                else
                    ____temp_3 = 0
                end
                local playerId = ____temp_3
                if playerId == 0 then
                    ____exports.testQuestData(nil)
                    ____exports.testQuestAcceptComplete(nil)
                    ____exports.testUI(nil)
                end
            end
        )
        debugPrint(nil, "已注册测试命令: Y 运行任务系统测试")
    end
end
____exports.registerTestCommand(nil)
return ____exports
