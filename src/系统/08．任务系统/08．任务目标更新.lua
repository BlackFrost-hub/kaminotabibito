--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local handleObjectiveUpdated = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.handleObjectiveUpdated
--- 任务系统 - "目标更新"事件桥接
-- 
-- 设计目标：
-- - 直接调用 STES_Register 注册自定义事件 Quest.ObjectiveUpdate
-- - TS / Lua 端在这里统一接收事件，更新任务目标进度
-- 
-- 触发时通过全局变量传递参数：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
-- - udg_ObjectiveId: 目标ID字符串
-- - udg_Progress: 当前进度值
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_0.STES_Register
local function debugPrint(self, msg)
end
local function registerObjectiveUpdateEvent(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" then
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
    STES_Register(trig, "任务目标更新")
    debugPrint(nil, "已注册 任务目标更新 事件")
end
local function init(self)
    registerObjectiveUpdateEvent(nil)
end
init(nil)
return ____exports
