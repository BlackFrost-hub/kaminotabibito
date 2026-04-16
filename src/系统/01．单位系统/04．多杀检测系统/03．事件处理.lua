--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.01．单位系统.04．多杀检测系统.00．常量定义")
local MULTI_KILL_SYSTEM_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTI_KILL_SYSTEM_ENABLED
local MULTI_KILL_EVENT = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTI_KILL_EVENT
local ____01_FF0E_6838_5FC3_529F_80FD = require("系统.01．单位系统.04．多杀检测系统.01．核心功能")
local startMultiKillMonitor = ____01_FF0E_6838_5FC3_529F_80FD.startMultiKillMonitor
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_0.STES_Register
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal1Get = ____require_result_1.YDLocal1Get
--- 触发"OnMultiKill"事件
-- 供JASS端调用，启动多杀监控
-- 
-- JASS端参数（通过YDLocal传递）：
-- - effectSource (unit): 效果来源单位
-- - killGroup (group): 击杀组（必传）
-- - DiyEvent (boolean): 是否触发自定义事件
-- - DiyEventString (string): 自定义事件名称
-- - Finish (boolean): 结束时是否显示来源单位
-- - EffectID (integer): 效果ID
-- - HealAmount (real): 治疗量
-- - HealTarget (unit): 治疗目标
-- - HealSource (unit): 治疗来源
function ____exports.fireMultiKillEvent(self)
    local effectSource = YDLocal1Get(nil, "unit", "effectSource")
    local killGroup = YDLocal1Get(nil, "group", "killGroup")
    local diyEvent = YDLocal1Get(nil, "boolean", "DiyEvent") or false
    local diyEventString = YDLocal1Get(nil, "string", "DiyEventString") or ""
    local finish = YDLocal1Get(nil, "boolean", "Finish") or false
    local effectID = YDLocal1Get(nil, "integer", "EffectID") or 0
    local healAmount = YDLocal1Get(nil, "real", "HealAmount") or 0
    local healTarget = YDLocal1Get(nil, "unit", "HealTarget")
    local healSource = YDLocal1Get(nil, "unit", "HealSource")
    startMultiKillMonitor(nil, {
        effectSource = effectSource,
        killGroup = killGroup,
        diyEvent = diyEvent,
        diyEventString = diyEventString,
        finish = finish,
        effectID = effectID,
        healAmount = healAmount,
        healTarget = healTarget,
        healSource = healSource
    })
end
local multiKillTrigger = nil
local function onMultiKillEvent(self)
    ____exports.fireMultiKillEvent(nil)
end
function ____exports.initMultiKillSystem(self)
    if not MULTI_KILL_SYSTEM_ENABLED then
        return
    end
    if multiKillTrigger ~= nil then
        return
    end
    multiKillTrigger = jass.CreateTrigger()
    jass.TriggerAddAction(multiKillTrigger, onMultiKillEvent)
    STES_Register(multiKillTrigger, MULTI_KILL_EVENT)
end
function ____exports.isMultiKillSystemInitialized(self)
    return multiKillTrigger ~= nil
end
return ____exports
