--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
local handleObjectiveUpdated = _____4EFB_52A1_7BA1_7406_5668.handleObjectiveUpdated
--- 任务系统 - "目标更新"事件桥接
-- 
-- 设计目标：
-- - JASS 端在"任务目标进度更新"时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
-- - TS / Lua 端在这里统一接收事件，根据全局变量更新任务目标进度。
-- 
-- 约定：
-- - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
-- - Lua 侧流程：
--   1) 创建 Trigger 并设置回调；
--   2) 写入 jass.globals.udg_RegTrigger = trig；
--   3) 写入 jass.globals.udg_RegEventStr = "LuaEvent_QuestObjectiveUpdate"；
--   4) jass.ExecuteFunc("Bridge_STES_Register") 交给 JASS 侧调用 STES_Register。
-- 
-- 触发前需设置的全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
-- - udg_ObjectiveId: 目标ID字符串
-- - udg_Progress: 当前进度值
local jass = require("jass.common")
local g = require("jass.globals")
local function debugPrint(self, msg)
end
local function registerObjectiveUpdateEvent(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.ExecuteFunc) ~= "function" then
        debugPrint(nil, "JASS API 不完整，无法注册目标更新事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            debugPrint(nil, "目标更新事件触发，调用任务管理器...")
            do
                local function ____catch(____error)
                    debugPrint(
                        nil,
                        "处理目标更新事件时出错: " .. tostring(____error)
                    )
                end
                local ____try, ____hasReturned = pcall(function()
                    handleObjectiveUpdated(nil)
                end)
                if not ____try then
                    ____catch(____hasReturned)
                end
            end
        end
    )
    g.udg_RegTrigger = trig
    g.udg_RegEventStr = "LuaEvent_QuestObjectiveUpdate"
    jass.ExecuteFunc("Bridge_STES_Register")
    debugPrint(nil, "已通过 Bridge_STES_Register 注册 LuaEvent_QuestObjectiveUpdate")
end
local function init(self)
    registerObjectiveUpdateEvent(nil)
end
init(nil)
return ____exports
