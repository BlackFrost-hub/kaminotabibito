local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
--- 装备回复：单位使用物品时，若装备数据有 hot 且 abilList 为 A08C/A0LF/A002/A015/A0B8 之一，则设 udg_TempReal/udg_TempReal2/udg_TempUnit/udg_TempString(匹配的技能 id) 并执行 gg_trg_HealItemEffect
-- 仅对玩家1-7(Player0-6)和中立敌对(Player13)生效
-- 经验：引擎会对一次使用物品派发两次 USE_ITEM 事件，防重须用 globalThis 存 key，详见 .cursor/rules/equip-heal-use-item.md
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.装备.装备数据").default
local HEAL_ABIL_IDS = {
    "A08C",
    "A0LF",
    "A002",
    "A015",
    "A0B8"
}
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
local function parseHot(self, hotStr)
    local hp = 0
    local mp = 0
    local parts = __TS__StringSplit(hotStr, ";")
    for ____, p in ipairs(parts) do
        local s = __TS__StringTrim(p)
        local sl = #s
        if sl >= 3 and (__TS__StringSubstring(s, sl - 2, sl) == "hp" or __TS__StringSubstring(s, sl - 2, sl) == "HP") then
            local n = __TS__ParseInt(
                __TS__StringSubstring(s, 0, sl - 2),
                10
            ) or 0
            hp = hp + n
        elseif sl >= 3 and (__TS__StringSubstring(s, sl - 2, sl) == "mp" or __TS__StringSubstring(s, sl - 2, sl) == "MP") then
            local n = __TS__ParseInt(
                __TS__StringSubstring(s, 0, sl - 2),
                10
            ) or 0
            mp = mp + n
        end
    end
    return {hp = hp, mp = mp}
end
--- 返回 abilList 中第一个匹配的 HEAL_ABIL_IDS 项，否则返回 ""
local function getMatchedHealAbilId(self, abilList)
    if not abilList or type(abilList) ~= "string" then
        return ""
    end
    local list = __TS__ArrayMap(
        __TS__StringSplit(abilList, ","),
        function(____, x) return __TS__StringTrim(x) end
    )
    for ____, id in ipairs(HEAL_ABIL_IDS) do
        if __TS__ArrayIndexOf(list, id) >= 0 then
            return id
        end
    end
    return ""
end
local function onUseItem(self)
    local ____this_1
    ____this_1 = jass
    local ____opt_0 = ____this_1.GetManipulatingUnit
    if ____opt_0 ~= nil then
        ____opt_0 = ____opt_0(____this_1)
    end
    local ____opt_0_4 = ____opt_0
    if ____opt_0_4 == nil then
        local ____this_3
        ____this_3 = jass
        local ____opt_2 = ____this_3.GetTriggerUnit
        if ____opt_2 ~= nil then
            ____opt_2 = ____opt_2(____this_3)
        end
        ____opt_0_4 = ____opt_2
    end
    local unit = ____opt_0_4
    local ____this_6
    ____this_6 = jass
    local ____opt_5 = ____this_6.GetManipulatedItem
    if ____opt_5 ~= nil then
        ____opt_5 = ____opt_5(____this_6)
    end
    local item = ____opt_5
    if not unit or not item then
        return
    end
    if type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    local IsUnitIllusionBJ = jass.IsUnitIllusionBJ
    if type(IsUnitIllusionBJ) == "function" and IsUnitIllusionBJ(nil, unit) then
        return
    end
    local ____temp_7
    if type(jass.GetItemTypeId) == "function" then
        ____temp_7 = jass.GetItemTypeId(item)
    else
        ____temp_7 = 0
    end
    local itemId = ____temp_7
    local idStr = fourCCToString(nil, itemId)
    local entry = itemsData[idStr]
    local matchedAbilId = getMatchedHealAbilId(nil, entry.abilList)
    if not entry or not entry.hot or not matchedAbilId then
        return
    end
    local ____parseHot_result_8 = parseHot(nil, entry.hot)
    local hp = ____parseHot_result_8.hp
    local mp = ____parseHot_result_8.mp
    if hp <= 0 and mp <= 0 then
        return
    end
    local glob = _G
    local key = (tostring(unit) .. "_") .. idStr
    if glob.__EquipHealExecutedKey == key then
        return
    end
    glob.__EquipHealExecutedKey = key
    local ____this_10
    ____this_10 = jass
    local ____opt_9 = ____this_10.CreateTimer
    if ____opt_9 ~= nil then
        ____opt_9 = ____opt_9(____this_10)
    end
    local timer = ____opt_9
    if timer and type(jass.TimerStart) == "function" then
        jass.TimerStart(
            timer,
            0.5,
            false,
            function()
                glob.__EquipHealExecutedKey = nil
            end
        )
    end
    g.udg_TempReal = hp
    g.udg_TempReal2 = mp
    g.udg_TempUnit = unit
    g.udg_TempString[0] = matchedAbilId
    local trig = g.gg_trg_HealItemEffect
    if trig and type(jass.TriggerExecute) == "function" then
        jass.TriggerExecute(trig)
    end
end
local INIT_KEY = "__EquipHealInited"
local function init(self)
    if g[INIT_KEY] then
        return
    end
    g[INIT_KEY] = true
    local ____jass_EVENT_PLAYER_UNIT_USE_ITEM_11 = jass.EVENT_PLAYER_UNIT_USE_ITEM
    if ____jass_EVENT_PLAYER_UNIT_USE_ITEM_11 == nil then
        ____jass_EVENT_PLAYER_UNIT_USE_ITEM_11 = 35
    end
    local useItemEv = ____jass_EVENT_PLAYER_UNIT_USE_ITEM_11
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 6 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                useItemEv,
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
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, nil)
    end
    jass.TriggerAddAction(trig, onUseItem)
end
init(nil)
return ____exports
