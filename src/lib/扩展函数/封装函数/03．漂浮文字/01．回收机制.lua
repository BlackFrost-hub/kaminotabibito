local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 漂浮文字 - 回收机制
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.05．泄露审计.index")
local LeakWatcher = ____require_result_0.LeakWatcher
____exports.floatTextQueue = {}
____exports.floatTextRecycleTimer = nil
____exports.RECYCLE_TICK = 0.05
function ____exports.ensureFloatTextRecycleTimer(self)
    if ____exports.floatTextRecycleTimer ~= nil then
        return
    end
    if type(jass.TimerStart) ~= "function" then
        return
    end
    local ____temp_3
    if LeakWatcher and type(LeakWatcher.createTimer) == "function" then
        ____temp_3 = LeakWatcher:createTimer("float_text_recycle")
    else
        local ____this_2
        ____this_2 = jass
        local ____opt_1 = ____this_2.CreateTimer
        if ____opt_1 ~= nil then
            ____opt_1 = ____opt_1(____this_2)
        end
        ____temp_3 = ____opt_1
    end
    ____exports.floatTextRecycleTimer = ____temp_3
    if ____exports.floatTextRecycleTimer == nil then
        return
    end
    jass.TimerStart(
        ____exports.floatTextRecycleTimer,
        ____exports.RECYCLE_TICK,
        true,
        function()
            do
                local i = #____exports.floatTextQueue - 1
                while i >= 0 do
                    local it = ____exports.floatTextQueue[i + 1]
                    it.ticksLeft = it.ticksLeft - 1
                    if it.ticksLeft <= 0 then
                        local tt = it.tt
                        if tt then
                            if LeakWatcher and type(LeakWatcher.destroyTextTag) == "function" then
                                LeakWatcher:destroyTextTag(tt)
                            elseif type(jass.DestroyTextTag) == "function" then
                                jass.DestroyTextTag(tt)
                            end
                        end
                        __TS__ArraySplice(____exports.floatTextQueue, i, 1)
                    end
                    i = i - 1
                end
            end
            if #____exports.floatTextQueue == 0 then
                local t = ____exports.floatTextRecycleTimer
                ____exports.floatTextRecycleTimer = nil
                if LeakWatcher and type(LeakWatcher.destroyTimer) == "function" then
                    LeakWatcher:destroyTimer(t)
                elseif type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
            end
        end
    )
end
return ____exports
