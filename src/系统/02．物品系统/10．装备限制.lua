local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_0.fourCCToString
local isHeroUnit = ____require_result_0.isHeroUnit
local isSpecialUnit = ____require_result_0.isSpecialUnit
--- 与 `11．装备系统.ts` 相同：`require("jass.globals")` 得到 `g`，GUI 变量一律 `g.udg_Xxx`（如 `g.udg_TempIsAdd`、`g.udg_TempHp`）
local g = require("jass.globals")
--- 地图 Jass：`set udg_Itmeboolean = true` → 此处 `g.udg_Itmeboolean`；为 true/1 时不做装备限制
local function isEquipLimitDisabledByJass(self)
    local v = g.udg_Itmeboolean
    return v == true or v == 1
end
local itemsData = require("系统.02．物品系统.01．装备数据").default or ({})
--- 与装备系统共用：装备限制 UnitRemoveItem 前设为 true，装备系统 DROP 时跳过扣属性
____exports.equipShared = {skipNextDrop = false}
local ONE_PER_SLOT = {
    "主武器",
    "副武器",
    "衣服",
    "鞋子",
    "裤子",
    "头盔",
    "灵魂"
}
local TWO_HANDED = "双手武器"
local CONFLICT_WITH_TWO_HANDED = {"主武器", "副武器"}
local PREFIX = "|cffffff00『系统提示』：|r"
local COLOR_TYPE = "|cff00ff00"
local COLOR_NAME = "|cff00bfff"
local COLOR_ERR = "|cffff0000"
local function getEntry(self, itemTypeId)
    local id = fourCCToString(nil, itemTypeId)
    return itemsData[id]
end
local function safeGetItemTypeId(self, it)
    local a = jass.GetItemTypeId(it)
    if type(a) == "number" then
        return a
    end
    return nil
end
local function safeUnitItemInSlot(self, unit, slot)
    local a = jass.UnitItemInSlot(unit, slot)
    if a then
        return a
    end
    return nil
end
--- 仅判断：该拾取是否会被装备限制拒绝（true=允许保留，false=会被丢出）。供装备系统在加属性前调用。
-- 事件触发时物品可能尚未入背包，故把“当前拾取的这件”也计入数量。
function ____exports.equipLimitWouldAllowPickup(self, unit, item)
    if isEquipLimitDisabledByJass(nil) then
        return true
    end
    if not unit or not item then
        return true
    end
    local pickedTypeId = safeGetItemTypeId(nil, item)
    if pickedTypeId == nil then
        return true
    end
    local entry = getEntry(nil, pickedTypeId)
    if not entry then
        return true
    end
    local pickedSlotType = entry.type
    local onlyOne = entry.onlyone == true or entry.onlyone == "TRUE"
    local sameIdCount = 0
    local sameSlotTypeCount = 0
    local hasTwoHanded = false
    local hasMain = false
    local hasSub = false
    do
        local i = 0
        while i <= 5 do
            do
                local it = safeUnitItemInSlot(nil, unit, i)
                if not it or it == item then
                    goto __continue14
                end
                local itTypeId = safeGetItemTypeId(nil, it)
                if itTypeId == nil then
                    goto __continue14
                end
                local e = getEntry(nil, itTypeId)
                if not e then
                    goto __continue14
                end
                if itTypeId == pickedTypeId then
                    sameIdCount = sameIdCount + 1
                end
                if pickedSlotType ~= nil and e.type == pickedSlotType then
                    sameSlotTypeCount = sameSlotTypeCount + 1
                end
                if e.type == TWO_HANDED then
                    hasTwoHanded = true
                end
                if e.type == "主武器" then
                    hasMain = true
                end
                if e.type == "副武器" then
                    hasSub = true
                end
            end
            ::__continue14::
            i = i + 1
        end
    end
    sameIdCount = sameIdCount + 1
    sameSlotTypeCount = sameSlotTypeCount + 1
    if pickedSlotType == "主武器" then
        hasMain = true
    end
    if pickedSlotType == "副武器" then
        hasSub = true
    end
    if pickedSlotType == TWO_HANDED then
        hasTwoHanded = true
    end
    local msg = ""
    if pickedSlotType == TWO_HANDED then
        if hasMain or hasSub then
            msg = "x"
        end
    elseif pickedSlotType and __TS__ArrayIndexOf(CONFLICT_WITH_TWO_HANDED, pickedSlotType) >= 0 then
        if hasTwoHanded then
            msg = "x"
        end
    end
    if msg == "" and onlyOne and sameIdCount > 1 then
        msg = "x"
    end
    if msg == "" and pickedSlotType and __TS__ArrayIndexOf(ONE_PER_SLOT, pickedSlotType) >= 0 and sameSlotTypeCount > 1 then
        msg = "x"
    end
    return msg == ""
end
local function onPickup(self)
    if isEquipLimitDisabledByJass(nil) then
        return
    end
    local ____opt_1 = jass.GetManipulatingUnit
    local ____temp_5 = ____opt_1 and ____opt_1(jass)
    if ____temp_5 == nil then
        local ____opt_3 = jass.GetTriggerUnit
        ____temp_5 = ____opt_3 and ____opt_3(jass)
    end
    local unit = ____temp_5
    local ____opt_6 = jass.GetManipulatedItem
    local item = ____opt_6 and ____opt_6(jass)
    if not unit or not item then
        return
    end
    if not isHeroUnit(nil, unit) then
        return
    end
    if isSpecialUnit(nil, unit) then
        return
    end
    local pickedTypeId = safeGetItemTypeId(nil, item)
    if pickedTypeId == nil then
        return
    end
    local entry = getEntry(nil, pickedTypeId)
    if not entry then
        return
    end
    local pickedSlotType = entry.type
    local onlyOne = entry.onlyone == true or entry.onlyone == "TRUE"
    local name = entry.name ~= nil and tostring(entry.name) or ""
    local function stripColor(____, s)
        local out = ""
        local i = 0
        while i < #s do
            do
                if __TS__StringSubstring(s, i, i + 2) == "|r" then
                    i = i + 2
                    goto __continue40
                end
                if __TS__StringSubstring(s, i, i + 2) == "|c" and i + 10 <= #s then
                    local hex = true
                    do
                        local j = i + 2
                        while j < i + 10 and hex do
                            hex = (string.find(
                                "0123456789aAbBcCdDeEfF",
                                __TS__StringAccess(s, j),
                                nil,
                                true
                            ) or 0) - 1 >= 0
                            j = j + 1
                        end
                    end
                    if hex then
                        i = i + 10
                        goto __continue40
                    end
                end
                out = out .. __TS__StringAccess(s, i)
                i = i + 1
            end
            ::__continue40::
        end
        return out
    end
    name = __TS__StringTrim(stripColor(nil, name))
    local nameColored = ((COLOR_NAME .. "『") .. name) .. "』|r"
    local msg = ""
    local player = jass.Player(0)
    local p = jass.GetOwningPlayer(unit)
    if p then
        player = p
    end
    local sameIdCount = 0
    local sameSlotTypeCount = 0
    local hasTwoHanded = false
    local hasMain = false
    local hasSub = false
    do
        local i = 0
        while i <= 5 do
            do
                local it = safeUnitItemInSlot(nil, unit, i)
                if not it then
                    goto __continue48
                end
                local itTypeId = safeGetItemTypeId(nil, it)
                if itTypeId == nil then
                    goto __continue48
                end
                local e = getEntry(nil, itTypeId)
                if not e then
                    goto __continue48
                end
                if itTypeId == pickedTypeId then
                    sameIdCount = sameIdCount + 1
                end
                if pickedSlotType ~= nil and e.type == pickedSlotType then
                    sameSlotTypeCount = sameSlotTypeCount + 1
                end
                if e.type == TWO_HANDED then
                    hasTwoHanded = true
                end
                if e.type == "主武器" then
                    hasMain = true
                end
                if e.type == "副武器" then
                    hasSub = true
                end
            end
            ::__continue48::
            i = i + 1
        end
    end
    if pickedSlotType == TWO_HANDED then
        if hasMain or hasSub then
            msg = (PREFIX .. COLOR_ERR) .. "双手武器与主武器/副武器不能同时装备！|r"
        end
    elseif pickedSlotType and __TS__ArrayIndexOf(CONFLICT_WITH_TWO_HANDED, pickedSlotType) >= 0 then
        if hasTwoHanded then
            msg = (PREFIX .. COLOR_ERR) .. "双手武器与主武器/副武器不能同时装备！|r"
        end
    end
    if msg == "" and onlyOne and sameIdCount > 1 then
        msg = (((PREFIX .. COLOR_ERR) .. "该物品") .. nameColored) .. "只能装备一件！|r"
    end
    if msg == "" and pickedSlotType and __TS__ArrayIndexOf(ONE_PER_SLOT, pickedSlotType) >= 0 and sameSlotTypeCount > 1 then
        msg = (((((PREFIX .. COLOR_TYPE) .. pickedSlotType) .. "|r物品：") .. nameColored) .. COLOR_ERR) .. "只能装备一件！|r"
    end
    if msg == "" then
        return
    end
    ____exports.equipShared.skipNextDrop = true
    jass.UnitRemoveItem(unit, item)
    jass.DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        msg
    )
end
local function isHeroCond(self)
    local ____opt_8 = jass.GetTriggerUnit
    local ____temp_12 = ____opt_8 and ____opt_8(jass)
    if ____temp_12 == nil then
        local ____this_11
        ____this_11 = jass
        local ____opt_10 = ____this_11.GetManipulatingUnit
        if ____opt_10 ~= nil then
            ____opt_10 = ____opt_10(____this_11)
        end
        ____temp_12 = ____opt_10
    end
    local u = ____temp_12
    return isHeroUnit(nil, u)
end
local function init(self)
    local trig = jass.CreateTrigger()
    local eventId = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    do
        local i = 0
        while i < 4 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                eventId,
                nil
            )
            i = i + 1
        end
    end
    local cond = jass.Condition
    if type(cond) == "function" then
        jass.TriggerAddCondition(
            trig,
            cond(nil, isHeroCond)
        )
    end
    jass.TriggerAddAction(trig, onPickup)
end
init(nil)
return ____exports
