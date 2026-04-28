--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 计时器封装函数
-- 自动创建/销毁计时器
-- 
-- - createDelayedCall：走中心计时器的一次性延迟，优先用于“纯延迟后执行”的逻辑。
-- - withTimer：内部 CreateTimer，适合「只要延迟、不需要先登记句柄」的场景。
-- - runTimerOnce：调用方已 CreateTimer（并可能先写入哈希表），再一次性 TimerStart + 结束后销毁。
--   与中心计时器无关：变长间隔、每实例独立结束时间（如音效时长）仍应用独立 timer。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.07．数学运算")
local ceil = ____require_result_0.ceil
local ____require_result_1 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_1.safeTimerStart
local safeDestroyTimer = ____require_result_1.safeDestroyTimer
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local removeDelayedCallback = ____require_result_2.removeDelayedCallback
--- 通过中心计时器安排一次性延迟回调。
-- 适用于“不需要真实 JASS timer 句柄”的延迟执行、注册重试、延迟初始化等场景。
function ____exports.createDelayedCall(self, delaySec, callback)
    local delayMs = delaySec <= 0 and 0 or ceil(nil, delaySec * 1000)
    return {id = addDelayedCallback(nil, delayMs, callback)}
end
function ____exports.cancelDelayedCall(self, handle)
    if handle == nil then
        return
    end
    removeDelayedCallback(
        nil,
        type(handle) == "number" and handle or handle.id
    )
end
--- 在已有计时器句柄上启动一次性回调，触发后销毁该计时器。
-- 回调内可使用 GetExpiredTimer()，与手写 TimerStart(..., false, ...) 等价，仅收敛重复代码。
-- 
-- @param timer 已创建的计时器；为 null 时直接同步执行 callback（与 withTimer 行为一致）
function ____exports.runTimerOnce(self, timer, delaySec, callback)
    if not timer then
        callback(nil)
        return
    end
    safeTimerStart(
        nil,
        timer,
        delaySec,
        false,
        function()
            callback(nil)
            safeDestroyTimer(nil, timer)
        end
    )
end
--- 延迟执行回调（自动创建/销毁计时器）
-- 
-- @param delaySec 延迟秒数
-- @param callback 回调函数
-- @param periodic 是否重复执行（默认 false）
-- @param name 调试用名称（可选）
-- @returns 计时器句柄（periodic=true 时可用，用于停止），不需要可忽略
function ____exports.withTimer(self, delaySec, callback, periodic, name)
    if periodic == nil then
        periodic = false
    end
    local t = jass.CreateTimer()
    if not t then
        callback(nil)
        return nil
    end
    if periodic then
        safeTimerStart(
            nil,
            t,
            delaySec,
            true,
            function()
                callback(nil)
            end
        )
    else
        safeTimerStart(
            nil,
            t,
            delaySec,
            false,
            function()
                callback(nil)
                safeDestroyTimer(nil, t)
            end
        )
    end
    return t
end
--- 停止并销毁指定的周期性计时器
-- 
-- @param t 计时器句柄（withTimer 返回的）
function ____exports.stopTimer(self, t)
    if not t then
        return
    end
    jass.PauseTimer(t)
    safeDestroyTimer(nil, t)
end
return ____exports
