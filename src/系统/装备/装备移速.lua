local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local fourCCToString, getMaxMovespeed2Info, jass, itemsData, ____debug
function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
function getMaxMovespeed2Info(self, unit, ignoreItem)
    local max = 0
    local name = ""
    local count = 0
    if type(jass.UnitItemInSlot) ~= "function" then
        ____debug(nil, "no UnitItemInSlot")
        return {value = 0, name = "", count = 0}
    end
    if type(jass.GetItemTypeId) ~= "function" then
        ____debug(nil, "no GetItemTypeId")
        return {value = 0, name = "", count = 0}
    end
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue11
                repeat
                    local item = jass.UnitItemInSlot(unit, slot)
                    if not item then
                        __continue11 = true
                        break
                    end
                    if ignoreItem and item == ignoreItem then
                        __continue11 = true
                        break
                    end
                    local tid = jass.GetItemTypeId(item)
                    local idStr = fourCCToString(nil, tid)
                    local entry = itemsData[idStr]
                    local typ = entry and entry.type
                    if typ == "任务" or typ == "药剂" or typ == "食品" then
                        __continue11 = true
                        break
                    end
                    local v = entry and entry.movespeed2
                    if type(v) == "number" and v > 0 then
                        count = count + 1
                    end
                    if type(v) == "number" and v > max then
                        max = v
                        name = (entry and entry.name) ~= nil and __TS__StringTrim(tostring(entry.name)) or "" or "未知"
                    end
                    __continue11 = true
                until true
                if not __continue11 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return {value = max, name = name, count = count}
end
jass = require("jass.common")
local g = require("jass.globals")
itemsData = require("系统.装备.装备数据").default
local DEBUG_MS2 = false
____debug = function(____, ...)
    if not DEBUG_MS2 then
        return
    end
    _G.print("[ms2]", ...)
end
--- 单位已应用的 movespeed2 值（仅用于 SGSS 先减后加）
local applied = {}
local function getUnitKey(self, unit)
    return tostring(unit)
end
local function getMaxMovespeed2(self, unit, ignoreItem)
    local info = getMaxMovespeed2Info(nil, unit, ignoreItem)
    return info.value
end
local function applyMovespeed2(self, unit, newSpeed)
    local key = getUnitKey(nil, unit)
    local oldSpeed = applied[key] ~= nil and applied[key] or 0
    if newSpeed == oldSpeed then
        return
    end
    ____debug(
        nil,
        "apply",
        "key=" .. key,
        "old=" .. tostring(oldSpeed),
        "new=" .. tostring(newSpeed)
    )
    g.udg_TempUnit = unit
    if oldSpeed ~= 0 then
        g.udg_TempReal = -oldSpeed
        ____debug(
            nil,
            "ExecuteFunc movespeed2",
            "delta=" .. tostring(-oldSpeed)
        )
        jass.ExecuteFunc("movespeed2")
    end
    if newSpeed ~= 0 then
        g.udg_TempReal = newSpeed
        ____debug(
            nil,
            "ExecuteFunc movespeed2",
            "delta=" .. tostring(newSpeed)
        )
        jass.ExecuteFunc("movespeed2")
    end
    applied[key] = newSpeed
end
local function onItemChange(self)
    local unit = jass.GetManipulatingUnit()
    if not unit then
        return
    end
    if type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    local IsUnitIllusionBJ = jass.IsUnitIllusionBJ
    if type(IsUnitIllusionBJ) == "function" then
        if IsUnitIllusionBJ(nil, unit) or IsUnitIllusionBJ(nil, jass, unit) or IsUnitIllusionBJ(nil, nil, unit) then
            return
        end
    end
    local eventId = jass.GetTriggerEventId()
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6 = 38
    end
    local isPickup = eventId == ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7 = 39
    end
    local isDrop = eventId == ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7
    local ____temp_8
    if type(jass.GetManipulatedItem) == "function" then
        ____temp_8 = jass.GetManipulatedItem()
    else
        ____temp_8 = nil
    end
    local manipulated = ____temp_8
    local newSpeed = isDrop and getMaxMovespeed2(nil, unit, manipulated) or getMaxMovespeed2(nil, unit)
    local key = getUnitKey(nil, unit)
    local cur = applied[key] ~= nil and applied[key] or 0
    ____debug(
        nil,
        "evt",
        isPickup and "pickup" or "drop",
        "key=" .. key,
        "cur=" .. tostring(cur),
        "calc=" .. tostring(newSpeed)
    )
    if isPickup and newSpeed <= cur then
        ____debug(nil, "skip pickup (<=cur)")
        return
    end
    applyMovespeed2(nil, unit, newSpeed)
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9 = 38
    end
    local pickup = ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10 = 39
    end
    local drop = ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10
    do
        local i = 0
        while i <= 7 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                pickup,
                nil
            )
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                drop,
                nil
            )
            i = i + 1
        end
    end
    local ____this_12
    ____this_12 = jass
    local ____opt_11 = ____this_12.Player
    if ____opt_11 ~= nil then
        ____opt_11 = ____opt_11(____this_12, 13)
    end
    local p13 = ____opt_11
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, pickup, nil)
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, drop, nil)
    end
    jass.TriggerAddAction(trig, onItemChange)
end
init(nil)
____exports.getMaxMovespeed2Info = getMaxMovespeed2Info
return ____exports
