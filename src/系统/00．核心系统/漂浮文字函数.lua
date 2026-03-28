local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- 漂浮文字系统 - 创建各种浮动文字效果
-- 
-- 功能：
-- - 可附着单位（自动跟随）
-- - 可固定坐标
-- - 自定义颜色、透明度、大小
-- - 自定义移动速度
-- - 自动销毁（存在时间）
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.泄露审计")
local LeakWatcher = ____require_result_0.LeakWatcher
local floatTextQueue = {}
local floatTextRecycleTimer = nil
local RECYCLE_TICK = 0.05
local function ensureFloatTextRecycleTimer(self)
    if floatTextRecycleTimer ~= nil then
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
    floatTextRecycleTimer = ____temp_3
    if floatTextRecycleTimer == nil then
        return
    end
    jass.TimerStart(
        floatTextRecycleTimer,
        RECYCLE_TICK,
        true,
        function()
            do
                local i = #floatTextQueue - 1
                while i >= 0 do
                    local it = floatTextQueue[i + 1]
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
                        __TS__ArraySplice(floatTextQueue, i, 1)
                    end
                    i = i - 1
                end
            end
            if #floatTextQueue == 0 then
                local t = floatTextRecycleTimer
                floatTextRecycleTimer = nil
                if LeakWatcher and type(LeakWatcher.destroyTimer) == "function" then
                    LeakWatcher:destroyTimer(t)
                elseif type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
            end
        end
    )
end
____exports.lastCreatedTextTag = nil
--- 创建漂浮文字
-- 
-- @param targetUnit 目标单位（指定则忽略坐标）
-- @param x X坐标（当targetUnit为null时使用）
-- @param y Y坐标（当targetUnit为null时使用）
-- @param options 文字配置选项
-- @returns 创建的漂浮文字句柄
function ____exports.CreateFloatText(self, targetUnit, x, y, options)
    local ____options_4 = options
    local text = ____options_4.text
    local size = ____options_4.size
    if size == nil then
        size = 10
    end
    local red = ____options_4.red
    if red == nil then
        red = 255
    end
    local green = ____options_4.green
    if green == nil then
        green = 255
    end
    local blue = ____options_4.blue
    if blue == nil then
        blue = 255
    end
    local alpha = ____options_4.alpha
    if alpha == nil then
        alpha = 0
    end
    local duration = ____options_4.duration
    if duration == nil then
        duration = 1
    end
    local speedX = ____options_4.speedX
    if speedX == nil then
        speedX = 0
    end
    local speedY = ____options_4.speedY
    if speedY == nil then
        speedY = 0.07
    end
    local height = ____options_4.height
    if height == nil then
        height = 0
    end
    local permanent = ____options_4.permanent
    if permanent == nil then
        permanent = false
    end
    local ____temp_6
    if LeakWatcher and type(LeakWatcher.createTextTag) == "function" then
        ____temp_6 = LeakWatcher:createTextTag("float_text")
    else
        local ____temp_5
        if type(jass.CreateTextTag) == "function" then
            ____temp_5 = jass.CreateTextTag()
        else
            ____temp_5 = nil
        end
        ____temp_6 = ____temp_5
    end
    local textTag = ____temp_6
    if not textTag then
        return nil
    end
    local sizeToHeight = size * 0.0023
    if type(jass.SetTextTagText) == "function" then
        jass.SetTextTagText(textTag, text, sizeToHeight)
    end
    if type(jass.SetTextTagColor) == "function" then
        jass.SetTextTagColor(
            textTag,
            red,
            green,
            blue,
            alpha
        )
    end
    if targetUnit and type(jass.SetTextTagPosUnit) == "function" then
        jass.SetTextTagPosUnit(textTag, targetUnit, height)
    elseif type(jass.SetTextTagPos) == "function" then
        jass.SetTextTagPos(textTag, x, y, height)
    end
    if type(jass.SetTextTagVisibility) == "function" then
        jass.SetTextTagVisibility(textTag, true)
    end
    if (speedX ~= 0 or speedY ~= 0) and type(jass.SetTextTagVelocity) == "function" then
        jass.SetTextTagVelocity(textTag, speedX, speedY)
    end
    if not permanent and duration > 0 then
        if type(jass.SetTextTagLifespan) == "function" then
            jass.SetTextTagLifespan(textTag, duration)
        end
        if type(jass.SetTextTagFadepoint) == "function" then
            jass.SetTextTagFadepoint(textTag, duration - 0.5)
        end
        local ticks = math.max(
            1,
            math.floor(duration / RECYCLE_TICK + 0.999)
        )
        floatTextQueue[#floatTextQueue + 1] = {tt = textTag, ticksLeft = ticks}
        ensureFloatTextRecycleTimer(nil)
    end
    ____exports.lastCreatedTextTag = textTag
    return textTag
end
--- 创建漂浮文字（简化版，仅单位）
function ____exports.CreateFloatTextOnUnit(self, unit, text, options)
    return ____exports.CreateFloatText(
        nil,
        unit,
        0,
        0,
        __TS__ObjectAssign({text = text}, options)
    )
end
--- 创建漂浮文字（简化版，仅坐标）
function ____exports.CreateFloatTextAtPoint(self, x, y, text, options)
    return ____exports.CreateFloatText(
        nil,
        nil,
        x,
        y,
        __TS__ObjectAssign({text = text}, options)
    )
end
--- 销毁漂浮文字
function ____exports.DestroyFloatText(self, textTag)
    if not textTag then
        return
    end
    if LeakWatcher and type(LeakWatcher.destroyTextTag) == "function" then
        LeakWatcher:destroyTextTag(textTag)
    elseif type(jass.DestroyTextTag) == "function" then
        jass.DestroyTextTag(textTag)
    end
end
--- 设置漂浮文字文字内容
function ____exports.SetFloatTextText(self, textTag, text)
    if textTag then
        jass.SetTextTagText(textTag, text, 0)
    end
end
--- 设置漂浮文字颜色
function ____exports.SetFloatTextColor(self, textTag, red, green, blue, alpha)
    if textTag then
        jass.SetTextTagColor(
            textTag,
            red,
            green,
            blue,
            alpha
        )
    end
end
--- 设置漂浮文字位置（固定坐标）
function ____exports.SetFloatTextPosition(self, textTag, x, y, height)
    if textTag then
        jass.SetTextTagPos(textTag, x, y, height)
    end
end
--- 设置漂浮文字速度
function ____exports.SetFloatTextVelocity(self, textTag, speedX, speedY)
    if textTag then
        jass.SetTextTagVelocity(textTag, speedX, speedY)
    end
end
return ____exports
