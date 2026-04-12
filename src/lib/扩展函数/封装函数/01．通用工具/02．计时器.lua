--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 计时器封装函数
-- 自动创建/销毁计时器
local jass = require("jass.common")
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
    local ____this_1
    ____this_1 = jass
    local ____opt_0 = ____this_1.CreateTimer
    if ____opt_0 ~= nil then
        ____opt_0 = ____opt_0(____this_1)
    end
    local t = ____opt_0
    if not t then
        callback(nil)
        return nil
    end
    if type(jass.TimerStart) ~= "function" then
        callback(nil)
        return nil
    end
    if periodic then
        jass.TimerStart(
            t,
            delaySec,
            true,
            function()
                callback(nil)
            end
        )
    else
        jass.TimerStart(
            t,
            delaySec,
            false,
            function()
                callback(nil)
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
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
    if type(jass.PauseTimer) == "function" then
        jass.PauseTimer(t)
    end
    if type(jass.DestroyTimer) == "function" then
        jass.DestroyTimer(t)
    end
end
return ____exports
