local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local getMaxMovespeed2Info, jass, itemsData, fourCCToString
function getMaxMovespeed2Info(self, unit, ignoreItem)
    local max = 0
    local name = ""
    local count = 0
    do
        local slot = 0
        while slot <= 5 do
            do
                local item = jass:UnitItemInSlot(unit, slot)
                if not item then
                    goto __continue6
                end
                if ignoreItem and item == ignoreItem then
                    goto __continue6
                end
                local tid = jass:GetItemTypeId(item)
                local idStr = fourCCToString(nil, tid)
                local entry = itemsData[idStr]
                local typ = entry and entry.type
                if typ == "任务" or typ == "药剂" or typ == "食品" then
                    goto __continue6
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
            ::__continue6::
            slot = slot + 1
        end
    end
    return {value = max, name = name, count = count}
end
jass = require("jass.common")
local itemEventCenter = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
fourCCToString = ____require_result_0.fourCCToString
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local ____require_result_2 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local IsUnitIllusionBJ = ____require_result_2.IsUnitIllusionBJ
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
local function getUnitKey(self, unit)
    return tostring(nil, unit)
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
    if oldSpeed ~= 0 then
        SGSS_SetState(nil, unit, 9, -oldSpeed)
    end
    if newSpeed ~= 0 then
        SGSS_SetState(nil, unit, 9, newSpeed)
    end
    applied[key] = newSpeed
end
local function onItemChange(self, unit, item, isPickup)
    if unit == nil or unit == 0 then
        return
    end
    if jass:IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if IsUnitIllusionBJ(nil, unit) then
        return
    end
    local isDrop = not isPickup
    local newSpeed = isDrop and getMaxMovespeed2(nil, unit, item) or getMaxMovespeed2(nil, unit)
    local key = getUnitKey(nil, unit)
    local cur = applied[key] ~= nil and applied[key] or 0
    if isPickup and newSpeed <= cur then
        return
    end
    applyMovespeed2(nil, unit, newSpeed)
end
local function init(self)
    itemEventCenter:onItemPickup(function(____, unit, item)
        onItemChange(nil, unit, item, true)
    end)
    itemEventCenter:onItemDrop(function(____, unit, item)
        onItemChange(nil, unit, item, false)
    end)
end
init(nil)
____exports.getMaxMovespeed2Info = getMaxMovespeed2Info
return ____exports
