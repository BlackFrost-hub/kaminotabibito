local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_56DE_6536_673A_5236 = require("lib.扩展函数.封装函数.03．漂浮文字.01．回收机制")
local floatTextQueue = ____01_FF0E_56DE_6536_673A_5236.floatTextQueue
local ensureFloatTextRecycleTimer = ____01_FF0E_56DE_6536_673A_5236.ensureFloatTextRecycleTimer
local RECYCLE_TICK = ____01_FF0E_56DE_6536_673A_5236.RECYCLE_TICK
--- 漂浮文字 - 创建漂浮文字
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.05．泄露审计.index")
local LeakWatcher = ____require_result_0.LeakWatcher
local ____require_result_1 = require("lib.扩展函数.BJ函数.12．数学函数")
local RMaxBJ = ____require_result_1.RMaxBJ
--- 创建漂浮文字
-- 
-- @param targetUnit 目标单位（指定则忽略坐标）
-- @param x X坐标（当targetUnit为null时使用）
-- @param y Y坐标（当targetUnit为null时使用）
-- @param options 文字配置选项
-- @returns 创建的漂浮文字句柄
function ____exports.CreateFloatText(targetUnit, x, y, options)
    local ____options_2 = options
    local text = ____options_2.text
    local size = ____options_2.size
    if size == nil then
        size = 10
    end
    local red = ____options_2.red
    if red == nil then
        red = 255
    end
    local green = ____options_2.green
    if green == nil then
        green = 255
    end
    local blue = ____options_2.blue
    if blue == nil then
        blue = 255
    end
    local alpha = ____options_2.alpha
    if alpha == nil then
        alpha = 0
    end
    local duration = ____options_2.duration
    if duration == nil then
        duration = 1
    end
    local speedX = ____options_2.speedX
    if speedX == nil then
        speedX = 0
    end
    local speedY = ____options_2.speedY
    if speedY == nil then
        speedY = 0.07
    end
    local height = ____options_2.height
    if height == nil then
        height = 0
    end
    local permanent = ____options_2.permanent
    if permanent == nil then
        permanent = false
    end
    local ____temp_3
    if LeakWatcher and type(LeakWatcher.createTextTag) == "function" then
        ____temp_3 = LeakWatcher:createTextTag("float_text")
    else
        ____temp_3 = jass:CreateTextTag()
    end
    local textTag = ____temp_3
    if not textTag then
        return nil
    end
    local sizeToHeight = size * 0.0023
    jass:SetTextTagText(textTag, text, sizeToHeight)
    jass:SetTextTagColor(
        textTag,
        red,
        green,
        blue,
        alpha
    )
    if targetUnit then
        jass:SetTextTagPosUnit(textTag, targetUnit, height)
    else
        jass:SetTextTagPos(textTag, x, y, height)
    end
    jass:SetTextTagVisibility(textTag, true)
    if speedX ~= 0 or speedY ~= 0 then
        jass:SetTextTagVelocity(textTag, speedX, speedY)
    end
    if not permanent and duration > 0 then
        jass:SetTextTagLifespan(textTag, duration)
        jass:SetTextTagFadepoint(textTag, duration - 0.5)
        local ticks = RMaxBJ(
            1,
            jass:R2I(duration / RECYCLE_TICK + 0.999)
        )
        floatTextQueue[#floatTextQueue + 1] = {tt = textTag, ticksLeft = ticks}
        ensureFloatTextRecycleTimer()
    end
    _G.lastCreatedTextTag = textTag
    return textTag
end
--- 创建漂浮文字（简化版，仅单位）
function ____exports.CreateFloatTextOnUnit(unit, text, options)
    return ____exports.CreateFloatText(
        unit,
        0,
        0,
        __TS__ObjectAssign({text = text}, options)
    )
end
--- 创建漂浮文字（简化版，仅坐标）
function ____exports.CreateFloatTextAtPoint(x, y, text, options)
    return ____exports.CreateFloatText(
        nil,
        x,
        y,
        __TS__ObjectAssign({text = text}, options)
    )
end
return ____exports
