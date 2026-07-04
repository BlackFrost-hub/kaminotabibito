local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local fourCCToStringCompat, normalizeMovespeed2, getMaxMovespeed2Info, jass, GetItemTypeId, GetUnitDefaultMoveSpeed, itemsData, R2I, stringChar
function fourCCToStringCompat(four)
    local c1 = stringChar(four % 256)
    local c2 = stringChar(R2I(four / 256) % 256)
    local c3 = stringChar(R2I(four / 65536) % 256)
    local c4 = stringChar(R2I(four / 16777216) % 256)
    return ((tostring(c4) .. tostring(c3)) .. tostring(c2)) .. tostring(c1)
end
function normalizeMovespeed2(unit, value)
    if not (value > 0) then
        return 0
    end
    if value < 1 then
        return GetUnitDefaultMoveSpeed(unit) * value
    end
    return value
end
function getMaxMovespeed2Info(unit, ignoreItem)
    local max = 0
    local name = ""
    local count = 0
    do
        local slot = 0
        while slot <= 5 do
            do
                local item = jass.UnitItemInSlot(unit, slot)
                if not item then
                    goto __continue10
                end
                if ignoreItem and item == ignoreItem then
                    goto __continue10
                end
                local tid = GetItemTypeId(item)
                local idStr = fourCCToStringCompat(tid)
                local entry = itemsData[idStr]
                local typ = entry and entry.type
                if typ == "任务" or typ == "药剂" or typ == "食品" then
                    goto __continue10
                end
                local v = entry and entry.movespeed2
                if type(v) == "number" and v > 0 then
                    count = count + 1
                end
                if type(v) == "number" and v > max then
                    max = v
                    name = (entry and entry.name) ~= nil and __TS__StringTrim(tostring(entry.name)) or "" or "未知"
                end
            end
            ::__continue10::
            slot = slot + 1
        end
    end
    return {value = max, name = name, count = count}
end
jass = require("jass.common")
GetItemTypeId = jass.GetItemTypeId
GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_0.onItemPickup
local onItemDrop = ____require_result_0.onItemDrop
itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local ____require_result_2 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local IsUnitIllusionBJ = ____require_result_2.IsUnitIllusionBJ
R2I = jass.R2I
stringChar = string.char
--- 单位已应用的 movespeed2 值（仅用于 SGSS 先减后加）
local applied = {}
local EQUIP_SPEED_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    13
}
local function getUnitKey(unit)
    return tostring(unit)
end
local function getMaxMovespeed2(unit, ignoreItem)
    local info = getMaxMovespeed2Info(unit, ignoreItem)
    return normalizeMovespeed2(unit, info.value)
end
local function applyMovespeed2(unit, newSpeed)
    local key = getUnitKey(unit)
    local oldSpeed = applied[key] ~= nil and applied[key] or 0
    if newSpeed == oldSpeed then
        return
    end
    if oldSpeed ~= 0 then
        SGSS_SetState(unit, 9, -oldSpeed)
    end
    if newSpeed ~= 0 then
        SGSS_SetState(unit, 9, newSpeed)
    end
    applied[key] = newSpeed
end
local function onItemChange(unit, item, isPickup)
    if unit == nil or unit == 0 then
        return
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if IsUnitIllusionBJ(nil, unit) then
        return
    end
    local isDrop = not isPickup
    local newSpeed = isDrop and getMaxMovespeed2(unit, item) or getMaxMovespeed2(unit)
    local key = getUnitKey(unit)
    local cur = applied[key] ~= nil and applied[key] or 0
    if isPickup and newSpeed <= cur then
        return
    end
    applyMovespeed2(unit, newSpeed)
end
local function init()
    onItemPickup(function(unit, item)
        onItemChange(unit, item, true)
    end)
    onItemDrop(function(unit, item)
        onItemChange(unit, item, false)
    end)
end
init()
____exports.getMaxMovespeed2Info = getMaxMovespeed2Info
return ____exports
