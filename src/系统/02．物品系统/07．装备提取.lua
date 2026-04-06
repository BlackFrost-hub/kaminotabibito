local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local mod = require("系统.02．物品系统.01．装备数据")
local ____require_result_0 = require("系统.00．核心系统.01．封装函数")
local stringToFourCC = ____require_result_0.stringToFourCC
local itemsData = mod.items or mod.default or ({})
local _seedCnt = 0
local DEBUG = false
local ITEM_TRIGGER = "tret"
local function getItemsByScoreRange(self, minScore, maxScore)
    local min = minScore or 0
    local max = maxScore or 0
    local result = {}
    for ____, id in ipairs(__TS__ObjectKeys(itemsData)) do
        do
            local __continue3
            repeat
                if type(id) ~= "string" or #id ~= 4 then
                    __continue3 = true
                    break
                end
                local entry = itemsData[id]
                if not entry then
                    __continue3 = true
                    break
                end
                local score = entry.score
                if score ~= nil and score >= min and score <= max then
                    result[#result + 1] = id
                end
                __continue3 = true
            until true
            if not __continue3 then
                break
            end
        end
    end
    return result
end
local function EquipExtract_CreateByLevel(self)
    local ____this_2
    ____this_2 = _G
    local ____opt_1 = ____this_2.print
    if ____opt_1 ~= nil then
        ____opt_1(____this_2, "[装备提取] EquipExtract_CreateByLevel 被调用")
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
    local ____opt_3 = jass.YDLocal1Get
    local inputMin = ____opt_3 and ____opt_3(jass, "integer", "EquipExtract_MinScore")
    local ____opt_5 = jass.YDLocal1Get
    local inputMax = ____opt_5 and ____opt_5(jass, "integer", "EquipExtract_MaxScore")
    local minS = type(inputMin) == "number" and inputMin or (__TS__Number(g.udg_TempScoreMin) or 0)
    local maxS = type(inputMax) == "number" and inputMax or (__TS__Number(g.udg_TempScoreMax) or 0)
    if minS <= 0 and maxS <= 0 then
        minS = 200
        maxS = 250
    end
    local candidates = getItemsByScoreRange(nil, minS, maxS)
    local ____this_8
    ____this_8 = jass
    local ____opt_7 = ____this_8.STES_GetTriggerPlayer
    if ____opt_7 ~= nil then
        ____opt_7 = ____opt_7(____this_8)
    end
    local ____opt_7_11 = ____opt_7
    if ____opt_7_11 == nil then
        local ____opt_9 = jass.GetTriggerPlayer
        ____opt_7_11 = ____opt_9 and ____opt_9(jass)
    end
    local ____opt_7_11_12 = ____opt_7_11
    if ____opt_7_11_12 == nil then
        ____opt_7_11_12 = jass.Player(0)
    end
    local player = ____opt_7_11_12
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
            local ____temp_13 = {arr[j + 1], arr[i + 1]}
            arr[i + 1] = ____temp_13[1]
            arr[j + 1] = ____temp_13[2]
            i = i - 1
        end
    end
    local itemId = arr[1]
    g.udg_TempItemType = type(itemId) == "string" and #itemId == 4 and stringToFourCC(nil, itemId) or 0
    local ____this_15
    ____this_15 = _G
    local ____opt_14 = ____this_15.print
    if ____opt_14 ~= nil then
        ____opt_14(
            ____this_15,
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
local function onTrigger(self)
    local evt = jass.GetTriggerEventId()
    local ____opt_16 = jass.GetTriggerPlayer
    local ____temp_18 = ____opt_16 and ____opt_16(jass)
    if ____temp_18 == nil then
        ____temp_18 = jass.Player(0)
    end
    local player = ____temp_18
    if evt == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM then
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
    local ____jass_STES_Register_19 = jass.STES_Register
    if ____jass_STES_Register_19 == nil then
        ____jass_STES_Register_19 = g.STES_Register
    end
    local ____jass_STES_Register_19_20 = ____jass_STES_Register_19
    if ____jass_STES_Register_19_20 == nil then
        ____jass_STES_Register_19_20 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_19_20
    if type(STES_Reg) == "function" then
        STES_Reg(evtTrig, "提取物品事件")
        if DEBUG then
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                10,
                "[装备提取] 已通过 STES_Register 注册事件 提取物品事件"
            )
        end
    else
        g.udg_RegTrigger = evtTrig
        g.udg_RegEventStr = "提取物品事件"
        jass.ExecuteFunc("Bridge_STES_Register")
    end
end
init(nil)
____exports.EquipExtract_CreateByLevel = EquipExtract_CreateByLevel
return ____exports
