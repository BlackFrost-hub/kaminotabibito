local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
--- 装备回复：单位使用物品时解析 hot 字段，支持多段（+分隔）、百分比(%hp/%hpLost/%mp)、固定值、wait延迟。
-- 规则详见 .cursor/rules/equip-heal-hot-format.md
-- 防重复事件见 .cursor/rules/equip-heal-use-item.md
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_0 = require("系统.00．核心系统.01．封装函数")
local fourCCToString = ____require_result_0.fourCCToString
--- 解析 hot 字符串和 abilList，返回每段的信息
local function parseSegments(self, hotStr, abilList)
    local segments = __TS__StringSplit(hotStr, "+")
    local abilIds = __TS__ArrayMap(
        __TS__StringSplit(abilList, ","),
        function(____, x) return __TS__StringTrim(x) end
    )
    local result = {}
    do
        local i = 0
        while i < #segments do
            do
                local __continue5
                repeat
                    local seg = __TS__StringTrim(segments[i + 1])
                    if seg == "" then
                        __continue5 = true
                        break
                    end
                    local tokens = __TS__ArrayFilter(
                        __TS__ArrayMap(
                            __TS__StringSplit(seg, ";"),
                            function(____, x) return __TS__StringTrim(x) end
                        ),
                        function(____, x) return x ~= "" end
                    )
                    local waitSec = 0
                    for ____, t in ipairs(tokens) do
                        local waitIdx = (string.find(t, ":wait", nil, true) or 0) - 1
                        if waitIdx >= 0 then
                            local w = __TS__ParseFloat(__TS__StringSubstring(t, waitIdx + 5)) or 0
                            if w > waitSec then
                                waitSec = w
                            end
                        end
                    end
                    result[#result + 1] = {tokens = tokens, abilId = abilIds[i + 1] or "", waitSec = waitSec}
                    __continue5 = true
                until true
                if not __continue5 then
                    break
                end
            end
            i = i + 1
        end
    end
    return result
end
--- 根据 token 列表和单位，计算 TempReal[1]=HP、TempReal[2]=MP，token 中 :waitN 后缀在此忽略（已提取）
local function calcHpMp(self, tokens, unit)
    local hp = 0
    local mp = 0
    local ____temp_1
    if type(jass.GetUnitState) == "function" then
        ____temp_1 = jass.GetUnitState(
            unit,
            jass.ConvertUnitState(1)
        )
    else
        ____temp_1 = 0
    end
    local maxHp = ____temp_1
    local ____temp_2
    if type(jass.GetWidgetLife) == "function" then
        ____temp_2 = jass.GetWidgetLife(unit)
    else
        ____temp_2 = 0
    end
    local curHp = ____temp_2
    local ____temp_3
    if type(jass.GetUnitState) == "function" then
        ____temp_3 = jass.GetUnitState(
            unit,
            jass.ConvertUnitState(3)
        )
    else
        ____temp_3 = 0
    end
    local maxMp = ____temp_3
    local lostHp = maxHp - curHp
    for ____, rawToken in ipairs(tokens) do
        local waitIdx = (string.find(rawToken, ":wait", nil, true) or 0) - 1
        local t = __TS__StringTrim(waitIdx >= 0 and __TS__StringSubstring(rawToken, 0, waitIdx) or rawToken)
        local tl = string.lower(t)
        if __TS__StringEndsWith(tl, "hplost") then
            local prefix = __TS__StringSubstring(t, 0, #t - 6)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                hp = hp + lostHp * pct
            else
                hp = hp + (__TS__ParseFloat(prefix) or 0)
            end
        elseif __TS__StringEndsWith(tl, "hp") then
            local prefix = __TS__StringSubstring(t, 0, #t - 2)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                hp = hp + maxHp * pct
            else
                hp = hp + (__TS__ParseFloat(prefix) or 0)
            end
        elseif __TS__StringEndsWith(tl, "mp") then
            local prefix = __TS__StringSubstring(t, 0, #t - 2)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                mp = mp + maxMp * pct
            else
                mp = mp + (__TS__ParseFloat(prefix) or 0)
            end
        end
    end
    return {hp = hp, mp = mp}
end
--- 立即执行一段的赋值+TriggerExecute
local function executeSegment(self, unit, seg)
    local ____calcHpMp_result_4 = calcHpMp(nil, seg.tokens, unit)
    local hp = ____calcHpMp_result_4.hp
    local mp = ____calcHpMp_result_4.mp
    local ____temp_6
    if g.udg_TempReal ~= nil then
        ____temp_6 = g.udg_TempReal
    else
        local ____temp_5 = {}
        g.udg_TempReal = ____temp_5
        ____temp_6 = ____temp_5
    end
    local tr = ____temp_6
    tr[1] = hp
    tr[2] = mp
    jass.udg_TempUnit[1] = unit
    g.udg_TempString[0] = seg.abilId
    local trig = g.gg_trg_HealItemEffect
    if trig and type(jass.TriggerExecute) == "function" then
        jass.TriggerExecute(trig)
    end
end
local function onUseItem(self)
    local ____this_8
    ____this_8 = jass
    local ____opt_7 = ____this_8.GetManipulatingUnit
    if ____opt_7 ~= nil then
        ____opt_7 = ____opt_7(____this_8)
    end
    local ____opt_7_11 = ____opt_7
    if ____opt_7_11 == nil then
        local ____this_10
        ____this_10 = jass
        local ____opt_9 = ____this_10.GetTriggerUnit
        if ____opt_9 ~= nil then
            ____opt_9 = ____opt_9(____this_10)
        end
        ____opt_7_11 = ____opt_9
    end
    local unit = ____opt_7_11
    local ____this_13
    ____this_13 = jass
    local ____opt_12 = ____this_13.GetManipulatedItem
    if ____opt_12 ~= nil then
        ____opt_12 = ____opt_12(____this_13)
    end
    local item = ____opt_12
    if not unit or not item then
        return
    end
    if type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return
    end
    local ____temp_14
    if type(jass.GetItemTypeId) == "function" then
        ____temp_14 = jass.GetItemTypeId(item)
    else
        ____temp_14 = 0
    end
    local itemId = ____temp_14
    local idStr = fourCCToString(nil, itemId)
    local entry = itemsData[idStr]
    if not entry or not entry.hot or not entry.abilList then
        return
    end
    local glob = _G
    local key = (tostring(unit) .. "_") .. idStr
    if glob.__EquipHealExecutedKey == key then
        return
    end
    glob.__EquipHealExecutedKey = key
    local ____this_16
    ____this_16 = jass
    local ____opt_15 = ____this_16.CreateTimer
    if ____opt_15 ~= nil then
        ____opt_15 = ____opt_15(____this_16)
    end
    local clearTimer = ____opt_15
    if clearTimer and type(jass.TimerStart) == "function" then
        local ct = clearTimer
        jass.TimerStart(
            ct,
            0.5,
            false,
            function()
                glob.__EquipHealExecutedKey = nil
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(ct)
                end
            end
        )
    end
    local segments = parseSegments(nil, entry.hot, entry.abilList)
    for ____, seg in ipairs(segments) do
        do
            local __continue36
            repeat
                if seg.abilId == "" then
                    __continue36 = true
                    break
                end
                if seg.waitSec <= 0 then
                    executeSegment(nil, unit, seg)
                else
                    local ____this_18
                    ____this_18 = jass
                    local ____opt_17 = ____this_18.CreateTimer
                    if ____opt_17 ~= nil then
                        ____opt_17 = ____opt_17(____this_18)
                    end
                    local delayTimer = ____opt_17
                    if delayTimer and type(jass.TimerStart) == "function" then
                        local dt = delayTimer
                        local capturedSeg = seg
                        local capturedUnit = unit
                        jass.TimerStart(
                            dt,
                            seg.waitSec,
                            false,
                            function()
                                executeSegment(nil, capturedUnit, capturedSeg)
                                if type(jass.DestroyTimer) == "function" then
                                    jass.DestroyTimer(dt)
                                end
                            end
                        )
                    end
                end
                __continue36 = true
            until true
            if not __continue36 then
                break
            end
        end
    end
end
local INIT_KEY = "__EquipHealInited"
local function init(self)
    if g[INIT_KEY] then
        return
    end
    g[INIT_KEY] = true
    local ____jass_EVENT_PLAYER_UNIT_USE_ITEM_19 = jass.EVENT_PLAYER_UNIT_USE_ITEM
    if ____jass_EVENT_PLAYER_UNIT_USE_ITEM_19 == nil then
        ____jass_EVENT_PLAYER_UNIT_USE_ITEM_19 = 35
    end
    local useItemEv = ____jass_EVENT_PLAYER_UNIT_USE_ITEM_19
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
    local ____this_21
    ____this_21 = jass
    local ____opt_20 = ____this_21.Player
    if ____opt_20 ~= nil then
        ____opt_20 = ____opt_20(____this_21, 13)
    end
    local p13 = ____opt_20
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, nil)
    end
    jass.TriggerAddAction(trig, onUseItem)
end
init(nil)
return ____exports
