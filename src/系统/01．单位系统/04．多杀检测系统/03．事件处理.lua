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
local YDLocal5Get = ____require_result_1.YDLocal5Get
local ____require_result_2 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_2.ydlStes_syncTriggerStep
local ____require_result_3 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local CountUnitsInGroup = ____require_result_3.CountUnitsInGroup
local function dbg(self, msg)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[多杀STES] " .. msg)
    end
end
--- 触发"OnMultiKill"事件
-- 供JASS端调用，启动多杀监控
-- 
-- JASS端参数（通过 YDLocal5Set 传递）：
-- - effectSource (unit): 推荐传地图里预先放置的「隐藏锚点单位」——不参与 killGroup 清怪，只作本路监控的唯一键
--   （stopMultiKillMonitor / addToKillGroup 等均按此句柄查找）。可选；未传时 Lua 退化为 killGroup 内第一个单位，仅兜底。
-- - killGroup (group): 被监控的单位组（必传）
-- - killWindow (real): 伤害计数时间窗（秒），与 killThreshold 配合；缺省由调用方或核心内默认值处理
-- - killThreshold (integer): 时间窗内计几次玩家伤害后放行击杀；缺省同理
-- - DiyEvent (boolean): 是否触发自定义事件
-- - DiyEventString (string): 自定义事件名称
-- - Finish (boolean): 传入核心实例；若后续接「组灭后显示锚点」等表现，应对 effectSource（多为隐藏单位）调用 ShowUnit
-- - EffectID (integer): 效果ID
-- - HealAmount (real): 治疗量
-- - HealTarget (unit): 治疗目标
-- - HealSource (unit): 治疗来源
function ____exports.fireMultiKillEvent(self)
    dbg(nil, "========== fireMultiKillEvent 被调用 ==========")
    ydlStes_syncTriggerStep(nil, nil)
    dbg(nil, "ydlStes_syncTriggerStep 执行完成")
    local effectSource = YDLocal5Get(nil, "unit", "effectSource")
    local killGroup = YDLocal5Get(nil, "group", "killGroup")
    local diyEvent = YDLocal5Get(nil, "boolean", "DiyEvent") or false
    local diyEventString = YDLocal5Get(nil, "string", "DiyEventString") or ""
    local finish = YDLocal5Get(nil, "boolean", "Finish") or false
    local effectID = YDLocal5Get(nil, "integer", "EffectID") or 0
    local healAmount = YDLocal5Get(nil, "real", "HealAmount") or 0
    local healTarget = YDLocal5Get(nil, "unit", "HealTarget")
    local healSource = YDLocal5Get(nil, "unit", "HealSource")
    local resolvedEffectSource = effectSource
    if resolvedEffectSource == nil or resolvedEffectSource == 0 then
        resolvedEffectSource = jass.FirstOfGroup(killGroup)
        if resolvedEffectSource ~= nil and resolvedEffectSource ~= 0 then
            dbg(nil, "effectSource 未传，已用 killGroup 内第一个单位作为 effectSource")
        end
    end
    dbg(nil, "参数读取结果:")
    dbg(nil, (("  effectSource=" .. ((effectSource == 0 or effectSource == nil) and "nil/0" or "有效")) .. " → 使用=") .. ((resolvedEffectSource == 0 or resolvedEffectSource == nil) and "nil/0" or "有效"))
    dbg(nil, "  killGroup=" .. ((killGroup == 0 or killGroup == nil) and "nil/0" or "有效"))
    dbg(
        nil,
        "  diyEvent=" .. tostring(diyEvent)
    )
    dbg(
        nil,
        ("  diyEventString=\"" .. tostring(diyEventString)) .. "\""
    )
    dbg(
        nil,
        "  finish=" .. tostring(finish)
    )
    dbg(
        nil,
        "  effectID=" .. tostring(effectID)
    )
    dbg(
        nil,
        "  healAmount=" .. tostring(healAmount)
    )
    dbg(nil, "  healTarget=" .. ((healTarget == 0 or healTarget == nil) and "nil/0" or "有效"))
    dbg(nil, "  healSource=" .. ((healSource == 0 or healSource == nil) and "nil/0" or "有效"))
    local killWindow = YDLocal5Get(nil, "real", "killWindow")
    local killThreshold = YDLocal5Get(nil, "integer", "killThreshold")
    dbg(nil, "【关键参数检查】")
    local ____dbg_5 = dbg
    local ____temp_4
    if killWindow ~= nil and killWindow ~= 0 then
        ____temp_4 = killWindow
    else
        ____temp_4 = "nil/0"
    end
    ____dbg_5(
        nil,
        "  killWindow=" .. tostring(____temp_4)
    )
    local ____dbg_7 = dbg
    local ____temp_6
    if killThreshold ~= nil and killThreshold ~= 0 then
        ____temp_6 = killThreshold
    else
        ____temp_6 = "nil/0"
    end
    ____dbg_7(
        nil,
        "  killThreshold=" .. tostring(____temp_6)
    )
    local ____dbg_9 = dbg
    local ____temp_8
    if killGroup ~= 0 and killGroup ~= nil and type(jass.CountUnitsInGroup) == "function" then
        ____temp_8 = jass.CountUnitsInGroup(killGroup)
    else
        ____temp_8 = "N/A"
    end
    ____dbg_9(
        nil,
        "  killGroup内单位数=" .. tostring(____temp_8)
    )
    if killGroup == nil or killGroup == 0 then
        dbg(nil, "错误: killGroup 为空，无法启动监控")
        return
    end
    dbg(nil, "调用 startMultiKillMonitor...")
    local ____startMultiKillMonitor_14 = startMultiKillMonitor
    local ____resolvedEffectSource_12 = resolvedEffectSource
    local ____killGroup_13 = killGroup
    local ____temp_10
    if killThreshold ~= nil and killThreshold ~= 0 then
        ____temp_10 = killThreshold
    else
        ____temp_10 = 3
    end
    local ____temp_11
    if killWindow ~= nil and killWindow ~= 0 then
        ____temp_11 = killWindow
    else
        ____temp_11 = 3
    end
    ____startMultiKillMonitor_14(nil, {
        effectSource = ____resolvedEffectSource_12,
        killGroup = ____killGroup_13,
        killThreshold = ____temp_10,
        killWindow = ____temp_11,
        diyEvent = diyEvent,
        diyEventString = diyEventString,
        finish = finish,
        effectID = effectID,
        healAmount = healAmount,
        healTarget = healTarget,
        healSource = healSource
    })
    dbg(nil, "startMultiKillMonitor 调用完成")
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
