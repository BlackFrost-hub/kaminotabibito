local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local getMaxMovespeed2Info, jass, itemsData, fourCCToString
function getMaxMovespeed2Info(self, unit, ignoreItem)
    local max = 0
    local name = ""
    local count = 0
    if type(jass.UnitItemInSlot) ~= "function" then
        return {value = 0, name = "", count = 0}
    end
    if type(jass.GetItemTypeId) ~= "function" then
        return {value = 0, name = "", count = 0}
    end
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue8
                repeat
                    local item = jass.UnitItemInSlot(unit, slot)
                    if not item then
                        __continue8 = true
                        break
                    end
                    if ignoreItem and item == ignoreItem then
                        __continue8 = true
                        break
                    end
                    local tid = jass.GetItemTypeId(item)
                    local idStr = fourCCToString(nil, tid)
                    local entry = itemsData[idStr]
                    local typ = entry and entry.type
                    if typ == "任务" or typ == "药剂" or typ == "食品" then
                        __continue8 = true
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
                    __continue8 = true
                until true
                if not __continue8 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return {value = max, name = name, count = count}
end
jass = require("jass.common")
itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_0 = require("系统.00．核心系统.01．封装函数")
fourCCToString = ____require_result_0.fourCCToString
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
    jass.udg_TempUnit[1] = unit
    if oldSpeed ~= 0 then
        jass.udg_TempReal[1] = -oldSpeed
        jass.ExecuteFunc("movespeed2")
    end
    if newSpeed ~= 0 then
        jass.udg_TempReal[1] = newSpeed
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
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return
    end
    local eventId = jass.GetTriggerEventId()
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_7 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_7 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_7 = 38
    end
    local isPickup = eventId == ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_7
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_8 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_8 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_8 = 39
    end
    local isDrop = eventId == ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_8
    local ____temp_9
    if type(jass.GetManipulatedItem) == "function" then
        ____temp_9 = jass.GetManipulatedItem()
    else
        ____temp_9 = nil
    end
    local manipulated = ____temp_9
    local newSpeed = isDrop and getMaxMovespeed2(nil, unit, manipulated) or getMaxMovespeed2(nil, unit)
    local key = getUnitKey(nil, unit)
    local cur = applied[key] ~= nil and applied[key] or 0
    if isPickup and newSpeed <= cur then
        return
    end
    applyMovespeed2(nil, unit, newSpeed)
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_10 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_10 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_10 = 38
    end
    local pickup = ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_10
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_11 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_11 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_11 = 39
    end
    local drop = ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_11
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
    local ____this_13
    ____this_13 = jass
    local ____opt_12 = ____this_13.Player
    if ____opt_12 ~= nil then
        ____opt_12 = ____opt_12(____this_13, 13)
    end
    local p13 = ____opt_12
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, pickup, nil)
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, drop, nil)
    end
    jass.TriggerAddAction(trig, onItemChange)
end
init(nil)
____exports.getMaxMovespeed2Info = getMaxMovespeed2Info
return ____exports
