local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local mod = require("系统.装备.装备数据")
local itemsData = mod.items or mod.default or ({})
local _seedCnt = 0
local DEBUG = true
local ITEM_TRIGGER = "tret"
local function stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function getItemsByScoreRange(self, minScore, maxScore)
    local min = minScore or 0
    local max = maxScore or 0
    local result = {}
    for ____, id in ipairs(__TS__ObjectKeys(itemsData)) do
        do
            local __continue4
            repeat
                if type(id) ~= "string" or #id ~= 4 then
                    __continue4 = true
                    break
                end
                local entry = itemsData[id]
                if not entry then
                    __continue4 = true
                    break
                end
                local score = entry.score
                if score ~= nil and score >= min and score <= max then
                    result[#result + 1] = id
                end
                __continue4 = true
            until true
            if not __continue4 then
                break
            end
        end
    end
    return result
end
local function EquipExtract_CreateByLevel(self)
    _seedCnt = _seedCnt + 1
    math.randomseed(_seedCnt)
    local minS = __TS__Number(g.udg_TempScoreMin) or 0
    local maxS = __TS__Number(g.udg_TempScoreMax) or 0
    if minS <= 0 and maxS <= 0 then
        minS = 200
        maxS = 250
    end
    local candidates = getItemsByScoreRange(nil, minS, maxS)
    local ____this_1
    ____this_1 = jass
    local ____opt_0 = ____this_1.STES_GetTriggerPlayer
    if ____opt_0 ~= nil then
        ____opt_0 = ____opt_0(____this_1)
    end
    local ____opt_0_4 = ____opt_0
    if ____opt_0_4 == nil then
        local ____opt_2 = jass.GetTriggerPlayer
        ____opt_0_4 = ____opt_2 and ____opt_2(jass)
    end
    local ____opt_0_4_5 = ____opt_0_4
    if ____opt_0_4_5 == nil then
        ____opt_0_4_5 = jass.Player(0)
    end
    local player = ____opt_0_4_5
    if #candidates == 0 then
        g.udg_TempItemType = 0
        if DEBUG then
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                8,
                (("TempItemType=0 无候选 min=" .. tostring(minS)) .. " max=") .. tostring(maxS)
            )
        end
        return
    end
    local arr = __TS__ArraySlice(candidates)
    do
        local i = #arr - 1
        while i > 0 do
            local j = math.floor(math.random() * (i + 1))
            local ____temp_6 = {arr[j + 1], arr[i + 1]}
            arr[i + 1] = ____temp_6[1]
            arr[j + 1] = ____temp_6[2]
            i = i - 1
        end
    end
    local itemId = arr[1]
    g.udg_TempItemType = type(itemId) == "string" and #itemId == 4 and stringToFourCC(nil, itemId) or 0
    if DEBUG then
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            (("TempItemType=" .. tostring(g.udg_TempItemType)) .. " itemId=") .. itemId
        )
    end
end
local function dbg(self, msg)
    if DEBUG then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            10,
            "[装备提取] " .. msg
        )
    end
end
local function onTrigger(self)
    local evt = jass.GetTriggerEventId()
    local ____opt_7 = jass.GetTriggerPlayer
    local ____temp_9 = ____opt_7 and ____opt_7(jass)
    if ____temp_9 == nil then
        ____temp_9 = jass.Player(0)
    end
    local player = ____temp_9
    if evt == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM then
        if DEBUG then
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                8,
                "拾取事件被触发"
            )
        end
        local item = jass.GetManipulatedItem()
        local tid = jass.GetItemTypeId(item)
        if tid ~= stringToFourCC(nil, ITEM_TRIGGER) then
            return
        end
        if DEBUG then
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                8,
                "物品ID正确"
            )
        end
    end
    EquipExtract_CreateByLevel(nil)
end
local function init(self)
    _G.EquipExtract_CreateByLevel = EquipExtract_CreateByLevel
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i < 4 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
                nil
            )
            i = i + 1
        end
    end
    jass.TriggerAddAction(trig, onTrigger)
end
init(nil)
____exports.EquipExtract_CreateByLevel = EquipExtract_CreateByLevel
return ____exports
