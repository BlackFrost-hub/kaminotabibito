local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Number = ____lualib.__TS__Number
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local Set = ____lualib.Set
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
--- 物品加工系统（篝火 h00C）
-- 
-- 触发：
-- - 玩家1-4（Player(0..3)）单位拾取物品：EVENT_PLAYER_UNIT_PICKUP_ITEM
-- 
-- 规则：
-- - 只有“篝火单位（h00C）”拾取物品才进入加工/烤焦逻辑
-- - 玩家从篝火取回物品：表现为“其他单位拾取该 item”，此时取消对应计时器
-- 
-- recipe 格式：
--   h00C:加工秒数->结果:超时秒数
--   结果支持多项，用 ; 分隔；支持概率：20%I036*1；支持数量：I02H*2
--   示例：
--   - h00C:10->I02H*2:5
--   - h00C:20->I034*1;20%I036*1:5
local jass = require("jass.common")
local itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_0 = require("系统.00．核心系统.01．封装函数")
local withTimer = ____require_result_0.withTimer
local stopTimer = ____require_result_0.stopTimer
local createTimedEffect = ____require_result_0.createTimedEffect
local ____require_result_1 = require("系统.00．核心系统.03．漂浮文字函数")
local CreateFloatTextAtPoint = ____require_result_1.CreateFloatTextAtPoint
local ____require_result_2 = require("系统.00．核心系统.01．封装函数")
local stringToFourCC = ____require_result_2.stringToFourCC
local fourCCToString = ____require_result_2.fourCCToString
local CAMPFIRE_ID = 1747988547
local EFFECT_FIREBOMB = "war3mapImported\\Firebomb.mdl"
local itemState = __TS__New(Map)
local campfireItems = __TS__New(Map)
local function isCampfire(self, u)
    return type(jass.GetUnitTypeId) == "function" and jass.GetUnitTypeId(u) == CAMPFIRE_ID
end
--- 使用 01．封装函数.ts 中的 stringToFourCC
local function fourCCToInt(self, id)
    return stringToFourCC(nil, id)
end
--- 使用 01．封装函数.ts 中的 fourCCToString
local function getItemIdStr(self, item)
    local ____temp_3
    if type(jass.GetItemTypeId) == "function" then
        ____temp_3 = jass.GetItemTypeId(item)
    else
        ____temp_3 = 0
    end
    local itemId = ____temp_3
    return fourCCToString(nil, itemId)
end
local function getItemNameSafe(self, item)
    local ____temp_4
    if type(jass.GetItemName) == "function" then
        ____temp_4 = jass.GetItemName(item)
    else
        ____temp_4 = "物品"
    end
    return ____temp_4
end
local function getItemChargesSafe(self, item)
    if type(jass.GetItemCharges) ~= "function" then
        return 1
    end
    local n = jass.GetItemCharges(item)
    local ____TS__Number_result_5 = __TS__Number(n)
    if ____TS__Number_result_5 == nil then
        ____TS__Number_result_5 = 0
    end
    local v = math.floor(____TS__Number_result_5) or 0
    return v > 0 and v or 1
end
local function setItemChargesSafe(self, item, n)
    if not item then
        return
    end
    if type(jass.SetItemCharges) ~= "function" then
        return
    end
    local v = math.floor(n) or 1
    jass.SetItemCharges(item, v > 0 and v or 1)
end
local function getUnitXY(self, u)
    local ____temp_6
    if type(jass.GetUnitX) == "function" then
        ____temp_6 = jass.GetUnitX(u)
    else
        ____temp_6 = 0
    end
    local x = ____temp_6
    local ____temp_7
    if type(jass.GetUnitY) == "function" then
        ____temp_7 = jass.GetUnitY(u)
    else
        ____temp_7 = 0
    end
    local y = ____temp_7
    return {x = x, y = y}
end
local function floatBurnText(self, campfire, itemName)
    local ____getUnitXY_result_8 = getUnitXY(nil, campfire)
    local x = ____getUnitXY_result_8.x
    local y = ____getUnitXY_result_8.y
    CreateFloatTextAtPoint(
        nil,
        x,
        y,
        itemName .. "被烤焦了！",
        {
            red = 255,
            green = 0,
            blue = 0,
            alpha = 0,
            duration = 3,
            speedY = 0.07,
            size = 10,
            height = 50
        }
    )
end
local function playFinishEffect(self, campfire)
    if type(jass.AddSpecialEffect) ~= "function" then
        return
    end
    local ____getUnitXY_result_9 = getUnitXY(nil, campfire)
    local x = ____getUnitXY_result_9.x
    local y = ____getUnitXY_result_9.y
    createTimedEffect(
        nil,
        EFFECT_FIREBOMB,
        x,
        y,
        0,
        2
    )
end
local function getRecipeForItem(self, item)
    local idStr = getItemIdStr(nil, item)
    local entry = itemsData[idStr]
    local recipe = entry and entry.recipe and entry.recipe or nil
    if not recipe then
        return nil
    end
    local prefix = "h00C:"
    if (string.find(recipe, prefix, nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(recipe, #prefix)
    local arrowIdx = (string.find(rest, "->", nil, true) or 0) - 1
    local colonIdx = -1
    do
        local i = #rest - 1
        while i >= 0 do
            if __TS__StringSubstring(rest, i, i + 1) == ":" then
                colonIdx = i
                break
            end
            i = i - 1
        end
    end
    if arrowIdx < 0 or colonIdx < 0 or colonIdx <= arrowIdx + 2 then
        return nil
    end
    local cookStr = __TS__StringTrim(__TS__StringSubstring(rest, 0, arrowIdx))
    local resultsStr = __TS__StringTrim(__TS__StringSubstring(rest, arrowIdx + 2, colonIdx))
    local timeoutStr = __TS__StringTrim(__TS__StringSubstring(rest, colonIdx + 1))
    local cookSec = math.floor(__TS__ParseFloat(cookStr) or 0)
    local timeoutSec = math.floor(__TS__ParseFloat(timeoutStr) or 0)
    if cookSec <= 0 then
        return nil
    end
    local rawOpts = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(resultsStr, ";"),
            function(____, s) return __TS__StringTrim(s) end
        ),
        function(____, s) return s ~= "" end
    )
    if #rawOpts == 0 then
        return nil
    end
    local opts = {}
    for ____, raw in ipairs(rawOpts) do
        local s = raw
        local prob = nil
        local pctIdx = (string.find(s, "%", nil, true) or 0) - 1
        if pctIdx > 0 then
            local p = __TS__ParseFloat(__TS__StringTrim(__TS__StringSubstring(s, 0, pctIdx)))
            if not __TS__NumberIsNaN(__TS__Number(p)) and p > 0 then
                prob = p
            end
            s = __TS__StringTrim(__TS__StringSubstring(s, pctIdx + 1))
        end
        local starIdx = (string.find(s, "*", nil, true) or 0) - 1
        local idPart = __TS__StringTrim(starIdx >= 0 and __TS__StringSubstring(s, 0, starIdx) or s)
        local qtyPart = __TS__StringTrim(starIdx >= 0 and __TS__StringSubstring(s, starIdx + 1) or "")
        local qty = math.floor(__TS__ParseFloat(qtyPart) or 1)
        local itemId = fourCCToInt(nil, idPart)
        if itemId ~= 0 and qty > 0 then
            opts[#opts + 1] = {prob = prob, itemId = itemId, qty = qty}
        end
    end
    if #opts == 0 then
        return nil
    end
    return {cookSec = cookSec, timeoutSec = timeoutSec, results = opts}
end
local function pickResult(self, results)
    local sumExplicit = 0
    local unspecified = 0
    for ____, r in ipairs(results) do
        if type(r.prob) == "number" then
            sumExplicit = sumExplicit + r.prob
        else
            unspecified = unspecified + 1
        end
    end
    local base = 0
    if unspecified > 0 then
        local remain = 100 - sumExplicit
        base = remain > 0 and remain / unspecified or 0
    end
    local total = 0
    local weights = {}
    do
        local i = 0
        while i < #results do
            local w = type(results[i + 1].prob) == "number" and results[i + 1].prob or base
            local ww = w > 0 and w or 0
            weights[i + 1] = ww
            total = total + ww
            i = i + 1
        end
    end
    if total <= 0 then
        local idx = math.random(1, #results)
        return results[idx]
    end
    local roll = math.random() * total
    do
        local i = 0
        while i < #results do
            roll = roll - weights[i + 1]
            if roll <= 0 then
                return results[i + 1]
            end
            i = i + 1
        end
    end
    return results[#results]
end
local function createItemAtCampfire(self, campfire, itemId)
    local ____getUnitXY_result_10 = getUnitXY(nil, campfire)
    local x = ____getUnitXY_result_10.x
    local y = ____getUnitXY_result_10.y
    if type(jass.CreateItem) ~= "function" then
        return nil
    end
    return jass.CreateItem(itemId, x, y)
end
local function tryGiveItemToCampfire(self, campfire, item)
    if not item then
        return false
    end
    if type(jass.UnitAddItem) ~= "function" then
        return false
    end
    return not not jass.UnitAddItem(campfire, item)
end
local function stopAndDestroyTimer(self, t)
    if not t then
        return
    end
    stopTimer(nil, t)
end
local function untrackItem(self, item)
    local st = itemState:get(item)
    if not st then
        return
    end
    if st.cookTimer then
        stopAndDestroyTimer(nil, st.cookTimer)
    end
    if st.burnTimer then
        stopAndDestroyTimer(nil, st.burnTimer)
    end
    itemState:delete(item)
    local set = campfireItems:get(st.campfire)
    if set then
        set:delete(item)
        if set.size == 0 then
            campfireItems:delete(st.campfire)
        end
    end
end
local function startBurnTimer(self, item, campfire, sec)
    local ____this_12
    ____this_12 = jass
    local ____opt_11 = ____this_12.CreateTimer
    if ____opt_11 ~= nil then
        ____opt_11 = ____opt_11(____this_12)
    end
    local t = ____opt_11
    if not t or type(jass.TimerStart) ~= "function" then
        return
    end
    local st = itemState:get(item)
    if st then
        st.burnTimer = t
    end
    jass.TimerStart(
        t,
        sec,
        false,
        function()
            if not itemState:has(item) then
                return
            end
            local name = getItemNameSafe(nil, item)
            floatBurnText(nil, campfire, name)
            if type(jass.RemoveItem) == "function" then
                jass.RemoveItem(item)
            end
            untrackItem(nil, item)
        end
    )
end
local function startCookTimer(self, item, campfire, recipe)
    local ____this_14
    ____this_14 = jass
    local ____opt_13 = ____this_14.CreateTimer
    if ____opt_13 ~= nil then
        ____opt_13 = ____opt_13(____this_14)
    end
    local t = ____opt_13
    if not t or type(jass.TimerStart) ~= "function" then
        return
    end
    local st = itemState:get(item)
    if st then
        st.cookTimer = t
    end
    jass.TimerStart(
        t,
        recipe.cookSec,
        false,
        function()
            if not itemState:has(item) then
                return
            end
            playFinishEffect(nil, campfire)
            local chosen = pickResult(nil, recipe.results)
            local inputCharges = getItemChargesSafe(nil, item)
            if type(jass.RemoveItem) == "function" then
                jass.RemoveItem(item)
            end
            untrackItem(nil, item)
            local timeout = recipe.timeoutSec > 0 and recipe.timeoutSec or 0
            local remaining = chosen.qty * inputCharges
            while remaining > 0 do
                local it = createItemAtCampfire(nil, campfire, chosen.itemId)
                if not it then
                    break
                end
                setItemChargesSafe(nil, it, remaining)
                local ok = tryGiveItemToCampfire(nil, campfire, it)
                if not ok then
                    local roll = math.random(1, 100)
                    if roll > 20 and type(jass.RemoveItem) == "function" then
                        jass.RemoveItem(it)
                    end
                else
                    itemState:set(it, {campfire = campfire, stage = "done"})
                    local set = campfireItems:get(campfire)
                    if not set then
                        set = __TS__New(Set)
                        campfireItems:set(campfire, set)
                    end
                    set:add(it)
                    if timeout > 0 then
                        startBurnTimer(nil, it, campfire, timeout)
                    end
                end
                remaining = 0
            end
        end
    )
end
local function onAnyPickup(self)
    local ____temp_15
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_15 = jass.GetTriggerUnit()
    else
        ____temp_15 = nil
    end
    local u = ____temp_15
    local ____temp_16
    if type(jass.GetManipulatedItem) == "function" then
        ____temp_16 = jass.GetManipulatedItem()
    else
        ____temp_16 = nil
    end
    local item = ____temp_16
    if not u or not item then
        return
    end
    if not isCampfire(nil, u) then
        if itemState:has(item) then
            untrackItem(nil, item)
        end
        return
    end
    if itemState:has(item) then
        return
    end
    local recipe = getRecipeForItem(nil, item)
    local campfire = u
    itemState:set(item, {campfire = campfire, stage = "raw"})
    local set = campfireItems:get(campfire)
    if not set then
        set = __TS__New(Set)
        campfireItems:set(campfire, set)
    end
    set:add(item)
    if not recipe then
        startBurnTimer(nil, item, campfire, 15)
    else
        startCookTimer(nil, item, campfire, recipe)
    end
end
local function onAnyDeath(self)
    local ____temp_17
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_17 = jass.GetTriggerUnit()
    else
        ____temp_17 = nil
    end
    local u = ____temp_17
    if not u or not isCampfire(nil, u) then
        return
    end
    local set = campfireItems:get(u)
    if not set then
        return
    end
    for ____, it in __TS__Iterator(set) do
        untrackItem(nil, it)
    end
    campfireItems:delete(u)
end
____exports["init物品加工"] = function(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_18 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_18 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_18 = 18
    end
    local pickEv = ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_18
    local trigPick = jass.CreateTrigger()
    do
        local i = 0
        while i <= 3 do
            if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
                jass.TriggerRegisterPlayerUnitEvent(
                    trigPick,
                    jass.Player(i),
                    pickEv,
                    nil
                )
            end
            i = i + 1
        end
    end
    jass.TriggerAddAction(trigPick, onAnyPickup)
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_19 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_19 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_19 = 19
    end
    local dropEv = ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_19
    local trigDrop = jass.CreateTrigger()
    do
        local i = 0
        while i <= 3 do
            if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
                jass.TriggerRegisterPlayerUnitEvent(
                    trigDrop,
                    jass.Player(i),
                    dropEv,
                    nil
                )
            end
            i = i + 1
        end
    end
    jass.TriggerAddAction(
        trigDrop,
        function()
            local ____temp_20
            if type(jass.GetManipulatingUnit) == "function" then
                ____temp_20 = jass.GetManipulatingUnit()
            else
                ____temp_20 = nil
            end
            local unit = ____temp_20
            local ____temp_21
            if type(jass.GetManipulatedItem) == "function" then
                ____temp_21 = jass.GetManipulatedItem()
            else
                ____temp_21 = nil
            end
            local item = ____temp_21
            if unit and item and isCampfire(nil, unit) and itemState:has(item) then
                untrackItem(nil, item)
            end
        end
    )
    local trigDeath = jass.CreateTrigger()
    if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
        local ____jass_EVENT_PLAYER_UNIT_DEATH_22 = jass.EVENT_PLAYER_UNIT_DEATH
        if ____jass_EVENT_PLAYER_UNIT_DEATH_22 == nil then
            ____jass_EVENT_PLAYER_UNIT_DEATH_22 = 56
        end
        local ev = ____jass_EVENT_PLAYER_UNIT_DEATH_22
        do
            local i = 0
            while i < 16 do
                jass.TriggerRegisterPlayerUnitEvent(
                    trigDeath,
                    jass.Player(i),
                    ev,
                    nil
                )
                i = i + 1
            end
        end
    end
    jass.TriggerAddAction(trigDeath, onAnyDeath)
end
____exports["init物品加工"](nil)
return ____exports
