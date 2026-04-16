local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 漂浮文字 - 回收机制
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.05．泄露审计.index")
local LeakWatcher = ____require_result_0.LeakWatcher
____exports.floatTextQueue = {}
--- 是否已注册到中心计时器
local _registeredToCenterTimer = false
--- tick计数器（每5个10毫秒=0.05秒执行一次）
local _tickCounter = 0
____exports.RECYCLE_TICK = 0.05
function ____exports.ensureFloatTextRecycleTimer(self)
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
    local onTick10ms = ____require_result_1.onTick10ms
    onTick10ms(
        nil,
        function()
            if #____exports.floatTextQueue == 0 then
                return
            end
            _tickCounter = _tickCounter + 1
            if _tickCounter >= 5 then
                _tickCounter = 0
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
            end
        end
    )
end
return ____exports
