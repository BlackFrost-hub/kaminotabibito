--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local handleQuestAccepted = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.handleQuestAccepted
--- 任务系统 - “接受任务”事件桥接（预备版）
-- 
-- 设计目标：
-- - JASS 端在“玩家接受任务”时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
-- - TS / Lua 端在这里统一接收事件，后续可以根据全局变量（任务 ID 等）更新任务数据。
-- 
-- 约定（当前支持的签名）：
-- - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
-- - 因此 Lua 侧需要：
--   1) 创建 Trigger，并把回调挂到上面；
--   2) 把该 Trigger 写入 jass.globals 的 udg_RegTrigger；
--   3) 把事件名写入 udg_RegEventStr，比如 "LuaEvent_QuestAccepted"；
--   4) 调用 jass.ExecuteFunc("Bridge_STES_Register")，由 JASS 侧函数执行 STES_Register。
-- 
-- 未来扩展：
-- - 你可以在 JASS 里在触发事件前，写入更多全局变量（如 udg_QuestId、udg_QuestState 等），
--   本文件会从 jass.globals 里读取这些全局变量来判断“接受的是哪个任务”。
-- 
-- 相关模块（对照填表 / STES 多事件）：
-- - 任务STES配置表.ts + 任务STES桥接.ts：按「事件名字符串」批量注册 STES，驱动目标进度，
--   与「单事件 LuaEvent_QuestAccepted」互补；Excel 列说明写在配置表头注释里。
local jass = require("jass.common")
local g = require("jass.globals")
--- 简单的调试输出，方便验证管道是否通畅
local function debugPrint(self, msg)
end
--- 使用 Bridge_STES_Register 注册一个自定义事件。
-- 
-- 当前 Bridge_STES_Register 的 JASS 侧实现：
--   function Bridge_STES_Register takes nothing returns nothing
--       call STES_Register(udg_RegTrigger, udg_RegEventStr)
--   endfunction
-- 
-- 因此这里严格按该签名设置全局变量再 ExecuteFunc。
local function registerQuestAcceptedEvent(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.ExecuteFunc) ~= "function" then
        debugPrint(nil, "JASS API 不完整，无法注册任务接受事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            debugPrint(nil, "任务接受事件触发，调用任务管理器...")
            do
                local function ____catch(____error)
                    debugPrint(
                        nil,
                        "处理任务接受事件时出错: " .. tostring(____error)
                    )
                end
                local ____try, ____hasReturned = pcall(function()
                    handleQuestAccepted(nil)
                end)
                if not ____try then
                    ____catch(____hasReturned)
                end
            end
        end
    )
    g.udg_RegTrigger = trig
    g.udg_RegEventStr = "LuaEvent_QuestAccepted"
    jass.ExecuteFunc("Bridge_STES_Register")
    debugPrint(nil, "已通过 Bridge_STES_Register 注册 LuaEvent_QuestAccepted")
end
local function init(self)
    registerQuestAcceptedEvent(nil)
end
init(nil)
return ____exports
