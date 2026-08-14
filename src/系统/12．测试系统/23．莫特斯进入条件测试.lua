--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C = ____require_result_1["注册聊天命令前缀监听"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_2.debugLogForce
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local IsQuestItemCompleted = jass.IsQuestItemCompleted
local QuestItemSetCompleted = jass.QuestItemSetCompleted
local _____6D4B_8BD5_547D_4EE4 = "RMXM18"
local _____6A21_5757_540D = "莫特斯进入条件测试"
local function ____on_8BBE_7F6E_83AB_7279_65AF_8FDB_5165_6761_4EF6(player, command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) or command ~= _____6D4B_8BD5_547D_4EE4 then
        return
    end
    local _____4EFB_52A1_8981_6C42 = jglobals.udg_RWXM[18]
    QuestItemSetCompleted(_____4EFB_52A1_8981_6C42, true)
    local _____5DF2_5B8C_6210 = IsQuestItemCompleted(_____4EFB_52A1_8981_6C42) == true
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        "[测试] RWXM[18] 已设置为完成：" .. tostring(_____5DF2_5B8C_6210)
    )
    debugLogForce(
        _____6A21_5757_540D,
        "设置任务要求完成",
        "index",
        18,
        "questItem",
        _____4EFB_52A1_8981_6C42,
        "completed",
        _____5DF2_5B8C_6210
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_8BBE_7F6E_83AB_7279_65AF_8FDB_5165_6761_4EF6)
return ____exports
