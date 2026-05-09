local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local clampMin, tostringCompat
local buffPoolMod = require("系统.05．Buff系统.00．Buff系统")
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
function clampMin(value, min)
    return value < min and min or value
end
function tostringCompat(value)
    if value == nil then
        return "nil"
    end
    return "" .. tostring(value)
end
local _____6570_5B66_8FD0_7B97 = require("lib.扩展函数.封装函数.01．通用工具.07．数学运算")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_0.debugLog
local setDebug = ____require_result_0.setDebug
local MAX_SLOTS = 20
local jass = require("jass.common")
local round = _____6570_5B66_8FD0_7B97.round
setDebug(nil, "BuffUI.VM", false)
local function tooltipIntStr(n)
    if type(n) ~= "number" or not __TS__NumberIsFinite(__TS__Number(n)) then
        return "0"
    end
    return tostring(jass:R2I(clampMin(n, 0)))
end
local TIP_COLOR_BODY = "|cfffff2d9"
local TIP_COLOR_SOURCE = "|cffffd700"
local function formatDotTooltip(template, durationForDisplay, dps, sourceName, intervalSec)
    local rem = type(durationForDisplay) == "number" and __TS__NumberIsFinite(__TS__Number(durationForDisplay)) and clampMin(durationForDisplay, 0) or 0
    local dpsN = type(dps) == "number" and __TS__NumberIsFinite(__TS__Number(dps)) and dps or 0
    local intv = type(intervalSec) == "number" and __TS__NumberIsFinite(__TS__Number(intervalSec)) and intervalSec > 0 and intervalSec or 1
    local rStr = tooltipIntStr(rem)
    local dStr = tooltipIntStr(dpsN)
    local iStr = tooltipIntStr(intv)
    local s = template
    s = table.concat(
        __TS__StringSplit(s, "持续时间"),
        rStr or ","
    )
    s = table.concat(
        __TS__StringSplit(s, "interval"),
        iStr or ","
    )
    s = table.concat(
        __TS__StringSplit(s, "damage"),
        dStr or ","
    )
    local src = sourceName ~= nil and sourceName ~= "" and sourceName or "未知"
    return (((((TIP_COLOR_BODY .. s) .. "|r\n") .. TIP_COLOR_SOURCE) .. "buff来源为「") .. src) .. "」|r"
end
local function formatBuffRemainOneDecimal(rem)
    if type(rem) ~= "number" or not __TS__NumberIsFinite(__TS__Number(rem)) then
        return "0.0"
    end
    local scaled = round(clampMin(rem, 0) * 10)
    local intPart = jass:R2I(scaled / 10)
    local fracPart = scaled % 10
    return (tostring(intPart) .. ".") .. tostring(fracPart)
end
local function isUnitValid(unit)
    return not not (unit and unit ~= 0)
end
function ____exports.buildBuffBarViewModel(unit)
    local slots = {}
    do
        local i = 0
        while i < MAX_SLOTS do
            slots[#slots + 1] = {visible = false, iconPath = "", remainText = "", tooltipText = ""}
            i = i + 1
        end
    end
    if not unit or not isUnitValid(unit) then
        debugLog(
            nil,
            "BuffUI.VM",
            "return-empty",
            "reason=invalid-unit",
            "unit=" .. tostringCompat(unit)
        )
        return {slots = slots}
    end
    local inBuffPool = buffPoolMod.isUnitInBuffPool(unit)
    if not inBuffPool then
        debugLog(
            nil,
            "BuffUI.VM",
            "return-empty",
            "reason=not-in-buff-pool",
            "unit=" .. tostringCompat(unit)
        )
        return {slots = slots}
    end
    local ids = buffPoolMod.getBuffIdsOnUnit(unit)
    debugLog(
        nil,
        "BuffUI.VM",
        "unit=" .. tostringCompat(unit),
        "inPool=" .. tostringCompat(inBuffPool),
        "idsLen=" .. tostring(#ids)
    )
    local rows = {}
    do
        local i = 0
        while i < #ids do
            local bid = ids[i + 1]
            local rt = buffPoolMod.getBuffRuntime(unit, bid)
            if rt then
                rows[#rows + 1] = {
                    id = bid,
                    state = {
                        effect = rt.effect,
                        remaining = rt.remaining,
                        iconRemaining = buffPoolMod.getDotIconDisplayRemaining(unit, bid, rt.remaining),
                        sourceName = rt.sourceName,
                        _dotParsedDuration = rt._dotParsedDuration
                    },
                    iconOverride = rt.iconOverride
                }
            end
            i = i + 1
        end
    end
    local buffs = buffTableMod.buffs
    __TS__ArraySort(
        rows,
        function(____, a, b)
            local ____opt_1 = buffs[a.id]
            local pa = ____opt_1 and ____opt_1.priority or 0
            local ____opt_3 = buffs[b.id]
            local pb = ____opt_3 and ____opt_3.priority or 0
            if pa ~= pb then
                return pb - pa
            end
            return a.id < b.id and -1 or 1
        end
    )
    do
        local i = 0
        while i < MAX_SLOTS and i < #rows do
            do
                local row = rows[i + 1]
                local meta = buffs[row.id]
                local iconPath = row.iconOverride and row.iconOverride ~= "" and row.iconOverride or (meta and meta.icon or "")
                if iconPath == "" then
                    goto __continue20
                end
                local pd = row.state._dotParsedDuration
                local durationForTip = type(pd) == "number" and __TS__NumberIsFinite(__TS__Number(pd)) and pd > 0 and pd or row.state.remaining
                local tooltipText
                if meta ~= nil then
                    tooltipText = formatDotTooltip(
                        meta.tooltip,
                        durationForTip,
                        row.state.effect,
                        row.state.sourceName,
                        meta.interval
                    )
                else
                    local ____temp_8 = (((((((TIP_COLOR_BODY .. row.id) .. " 剩余 ") .. tooltipIntStr(row.state.remaining)) .. " 秒，伤害/秒 ") .. tooltipIntStr(row.state.effect)) .. "|r\n") .. TIP_COLOR_SOURCE) .. "buff来源为「"
                    local ____temp_7
                    if row.state.sourceName and row.state.sourceName ~= "" then
                        ____temp_7 = row.state.sourceName
                    else
                        ____temp_7 = "未知"
                    end
                    tooltipText = (____temp_8 .. tostring(____temp_7)) .. "」|r"
                end
                local remainStr = formatBuffRemainOneDecimal(row.state.iconRemaining)
                local remainText = ("|cffffffff" .. remainStr) .. "|r"
                slots[i + 1] = {visible = true, iconPath = iconPath, remainText = remainText, tooltipText = tooltipText}
            end
            ::__continue20::
            i = i + 1
        end
    end
    local visibleCount = 0
    do
        local i = 0
        while i < #slots do
            if slots[i + 1].visible == true then
                visibleCount = visibleCount + 1
            end
            i = i + 1
        end
    end
    debugLog(
        nil,
        "BuffUI.VM",
        "unit=" .. tostringCompat(unit),
        "rowsLen=" .. tostring(#rows),
        "visible=" .. tostring(visibleCount)
    )
    return {slots = slots}
end
function ____exports.getMaxSlots()
    return MAX_SLOTS
end
return ____exports
