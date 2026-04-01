--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local handleQuestCompleted = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.handleQuestCompleted
--- 任务系统 - “完成任务”事件桥接（预备版）
-- 
-- 设计目标：
-- - JASS 端在“玩家完成任务”时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
-- - TS / Lua 端在这里统一接收事件，后续可以根据全局变量（任务 ID、完成状态等）更新任务数据。
-- 
-- 约定：
-- - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
-- - Lua 侧流程：
--   1) 创建 Trigger 并设置回调；
--   2) 写入 jass.globals.udg_RegTrigger = trig；
--   3) 写入 jass.globals.udg_RegEventStr = "LuaEvent_QuestCompleted"；
--   4) jass.ExecuteFunc("Bridge_STES_Register") 交给 JASS 侧调用 STES_Register。
local jass = require("jass.common")
local g = require("jass.globals")
local function debugPrint(self, msg)
end
local function registerQuestCompletedEvent(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.ExecuteFunc) ~= "function" then
        debugPrint(nil, "JASS API 不完整，无法注册任务完成事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            debugPrint(nil, "任务完成事件触发，调用任务管理器...")
            do
                local function ____catch(____error)
                    debugPrint(
                        nil,
                        "处理任务完成事件时出错: " .. tostring(____error)
                    )
                end
                local ____try, ____hasReturned = pcall(function()
                    handleQuestCompleted(nil)
                end)
                if not ____try then
                    ____catch(____hasReturned)
                end
            end
        end
    )
    g.udg_RegTrigger = trig
    g.udg_RegEventStr = "LuaEvent_QuestCompleted"
    jass.ExecuteFunc("Bridge_STES_Register")
    debugPrint(nil, "已通过 Bridge_STES_Register 注册 LuaEvent_QuestCompleted")
end
local function init(self)
    registerQuestCompletedEvent(nil)
end
init(nil)
return ____exports
