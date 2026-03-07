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
    local ____this_1
    ____this_1 = _G
    local ____opt_0 = ____this_1.print
    if ____opt_0 ~= nil then
        _G.print("[装备提取] EquipExtract_CreateByLevel 被调用")
    end
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        "[装备提取] 执行中"
    )
    _seedCnt = _seedCnt + 1
    math.randomseed(_seedCnt)
    local ____opt_2 = jass.YDLocal1Get
    local inputMin = ____opt_2 and ____opt_2(jass, "integer", "EquipExtract_MinScore")
    local ____opt_4 = jass.YDLocal1Get
    local inputMax = ____opt_4 and ____opt_4(jass, "integer", "EquipExtract_MaxScore")
    local minS = type(inputMin) == "number" and inputMin or (__TS__Number(g.udg_TempScoreMin) or 0)
    local maxS = type(inputMax) == "number" and inputMax or (__TS__Number(g.udg_TempScoreMax) or 0)
    if minS <= 0 and maxS <= 0 then
        minS = 200
        maxS = 250
    end
    local candidates = getItemsByScoreRange(nil, minS, maxS)
    local ____this_7
    ____this_7 = jass
    local ____opt_6 = ____this_7.STES_GetTriggerPlayer
    if ____opt_6 ~= nil then
        ____opt_6 = ____opt_6(____this_7)
    end
    local ____opt_6_10 = ____opt_6
    if ____opt_6_10 == nil then
        local ____opt_8 = jass.GetTriggerPlayer
        ____opt_6_10 = ____opt_8 and ____opt_8(jass)
    end
    local ____opt_6_10_11 = ____opt_6_10
    if ____opt_6_10_11 == nil then
        ____opt_6_10_11 = jass.Player(0)
    end
    local player = ____opt_6_10_11
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
            local ____temp_12 = {arr[j + 1], arr[i + 1]}
            arr[i + 1] = ____temp_12[1]
            arr[j + 1] = ____temp_12[2]
            i = i - 1
        end
    end
    local itemId = arr[1]
    g.udg_TempItemType = type(itemId) == "string" and #itemId == 4 and stringToFourCC(nil, itemId) or 0
    local ____this_14
    ____this_14 = _G
    local ____opt_13 = ____this_14.print
    if ____opt_13 ~= nil then
        ____opt_13(
            ____this_14,
            (("TempItemType=" .. tostring(g.udg_TempItemType)) .. " itemId=") .. itemId
        )
    end
    if DEBUG then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            10,
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
    local ____opt_15 = jass.GetTriggerPlayer
    local ____temp_17 = ____opt_15 and ____opt_15(jass)
    if ____temp_17 == nil then
        ____temp_17 = jass.Player(0)
    end
    local player = ____temp_17
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
    local evtTrig = jass.CreateTrigger()
    jass.TriggerAddAction(
        evtTrig,
        function() return EquipExtract_CreateByLevel(nil) end
    )
    local ____jass_STES_Register_18 = jass.STES_Register
    if ____jass_STES_Register_18 == nil then
        ____jass_STES_Register_18 = g.STES_Register
    end
    local ____jass_STES_Register_18_19 = ____jass_STES_Register_18
    if ____jass_STES_Register_18_19 == nil then
        ____jass_STES_Register_18_19 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_18_19
    if type(STES_Reg) == "function" then
        STES_Reg(evtTrig, "提取物品事件")
        dbg(nil, "已通过 STES_Register 注册事件 提取物品事件")
    else
        g.udg_RegTrigger = evtTrig
        g.udg_RegEventStr = "提取物品事件"
        jass.ExecuteFunc("Bridge_STES_Register")
        dbg(nil, "已通过桥接注册 STES 事件 提取物品事件")
    end
end
init(nil)
____exports.EquipExtract_CreateByLevel = EquipExtract_CreateByLevel
return ____exports
