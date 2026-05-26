--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_0.GetPlayersAll
local ____require_result_1 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_1.QuestMessageBJ
do
    local ____23_FF0E_738B_5BAB_95E8_536B_652F_7EBF_53D1_73B0 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.23．王宫门卫支线发现")
    ____exports["王宫门卫支线发现剧情片段"] = ____23_FF0E_738B_5BAB_95E8_536B_652F_7EBF_53D1_73B0["王宫门卫支线发现剧情片段"]
end
local QuestSetDiscovered = jass.QuestSetDiscovered
local bj_QUESTMESSAGE_DISCOVERED = jglobals.bj_QUESTMESSAGE_DISCOVERED
____exports["执行王宫门卫支线发现"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
    local ____opt_2 = jglobals.udg_RW
    if ____opt_2 ~= nil then
        ____opt_2 = ____opt_2[8]
    end
    local quest = ____opt_2
    if quest == nil or quest == 0 then
        return
    end
    QuestSetDiscovered(quest, true)
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_DISCOVERED,
        "|cffffff00发现支线任务：|r王宫门卫的额外委托。"
    )
end
____exports["王宫门卫支线发现剧情动作注册表"] = {["JLC精灵城_王宫门卫2支线发现"] = ____exports["执行王宫门卫支线发现"]}
return ____exports
