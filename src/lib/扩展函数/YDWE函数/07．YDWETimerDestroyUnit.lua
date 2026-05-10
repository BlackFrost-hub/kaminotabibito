local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 延时删除单位
-- 
-- 使用中心计时器，延迟删除指定单位
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_0.onTick10ms
local RemoveUnit = jass.RemoveUnit
local _pendingUnits = {}
local _unitRecycleRegistered = false
local function _tickUnitRecycle()
    do
        local i = #_pendingUnits - 1
        while i >= 0 do
            local entry = _pendingUnits[i + 1]
            entry.ticksLeft = entry.ticksLeft - 1
            if entry.ticksLeft <= 0 then
                if entry.unit ~= nil then
                    RemoveUnit(entry.unit)
                end
                __TS__ArraySplice(_pendingUnits, i, 1)
            end
            i = i - 1
        end
    end
end
--- 延时删除单位（使用中心计时器）
-- 
-- @param duration 延迟秒数
-- @param unit 单位句柄
function ____exports.YDWETimerDestroyUnit(duration, unit)
    if not unit then
        return
    end
    if duration <= 0 then
        RemoveUnit(unit)
        return
    end
    if not _unitRecycleRegistered then
        _unitRecycleRegistered = true
        onTick10ms(_tickUnitRecycle)
    end
    local ticks = math.ceil(duration / 0.01)
    _pendingUnits[#_pendingUnits + 1] = {unit = unit, ticksLeft = ticks}
end
return ____exports
