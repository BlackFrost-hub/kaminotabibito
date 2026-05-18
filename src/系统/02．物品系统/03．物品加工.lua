local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Delete = ____lualib.__TS__Delete
local Set = ____lualib.Set
local __TS__Number = ____lualib.__TS__Number
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local ____exports = {}
local getHandleIdSafe, onBurnTimerExpire, getItemNameSafe, getItemChargesSafe, setItemChargesSafe, getUnitXY, floatBurnText, playFinishEffect, pickResult, createItemAtCampfire, tryGiveItemToCampfire, stopAndDestroyTimer, untrackItem, startBurnTimer, jass, safeTimerStart, safeDestroyTimer, stopTimer, createTimedEffect, CreateFloatTextAtPoint, setLastCreatedItem, EFFECT_FIREBOMB, itemState, campfireItems, burnTimerCtxByHid
function getHandleIdSafe(handle)
    if not handle then
        return 0
    end
    return jass.GetHandleId(handle) or 0
end
function onBurnTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = burnTimerCtxByHid[hid]
    __TS__Delete(burnTimerCtxByHid, hid)
    if not ctx then
        return
    end
    local item = ctx.item
    local campfire = ctx.campfire
    local itemId = getHandleIdSafe(item)
    if itemId == 0 or not itemState:has(itemId) then
        return
    end
    local name = getItemNameSafe(item)
    floatBurnText(campfire, name)
    jass.RemoveItem(item)
    untrackItem(item)
    safeDestroyTimer(nil, t)
end
function getItemNameSafe(item)
    return jass.GetItemName(item)
end
function getItemChargesSafe(item)
    local n = jass.GetItemCharges(item)
    local ____jass_R2I_6 = jass.R2I
    local ____TS__Number_result_5 = __TS__Number(n)
    if ____TS__Number_result_5 == nil then
        ____TS__Number_result_5 = 0
    end
    local v = ____jass_R2I_6(jass, ____TS__Number_result_5) or 0
    local ____temp_7
    if v > 0 then
        ____temp_7 = v
    else
        ____temp_7 = 1
    end
    return ____temp_7
end
function setItemChargesSafe(item, n)
    if not item then
        return
    end
    local v = jass.R2I(n) or 1
    local ____self_10 = jass
    local ____self_10_SetItemCharges_11 = ____self_10.SetItemCharges
    local ____item_9 = item
    local ____temp_8
    if v > 0 then
        ____temp_8 = v
    else
        ____temp_8 = 1
    end
    ____self_10_SetItemCharges_11(____self_10, ____item_9, ____temp_8)
end
function getUnitXY(u)
    local x = jass.GetUnitX(u)
    local y = jass.GetUnitY(u)
    return {x = x, y = y}
end
function floatBurnText(campfire, itemName)
    if type(CreateFloatTextAtPoint) ~= "function" then
        return
    end
    local ____getUnitXY_result_12 = getUnitXY(campfire)
    local x = ____getUnitXY_result_12.x
    local y = ____getUnitXY_result_12.y
    CreateFloatTextAtPoint(x, y, itemName .. "被烤焦了！", {
        red = 255,
        green = 0,
        blue = 0,
        alpha = 0,
        duration = 3,
        speedY = 0.07,
        size = 10,
        height = 50
    })
end
function playFinishEffect(campfire)
    local ____getUnitXY_result_13 = getUnitXY(campfire)
    local x = ____getUnitXY_result_13.x
    local y = ____getUnitXY_result_13.y
    createTimedEffect(
        nil,
        EFFECT_FIREBOMB,
        x,
        y,
        0,
        2
    )
end
function pickResult(results)
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
        local idx = jass.GetRandomInt(1, #results)
        return results[idx]
    end
    local roll = jass.GetRandomReal(0, 1) * total
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
function createItemAtCampfire(campfire, itemId)
    local ____getUnitXY_result_17 = getUnitXY(campfire)
    local x = ____getUnitXY_result_17.x
    local y = ____getUnitXY_result_17.y
    local item = jass.CreateItem(itemId, x, y)
    if item then
        setLastCreatedItem(nil, item)
    end
    return item
end
function tryGiveItemToCampfire(campfire, item)
    if not item then
        return false
    end
    return not not jass.UnitAddItem(campfire, item)
end
function stopAndDestroyTimer(t)
    if not t then
        return
    end
    stopTimer(nil, t)
    jass.DestroyTimer(t)
end
function untrackItem(item)
    local itemId = getHandleIdSafe(item)
    if itemId == 0 then
        return
    end
    local st = itemState:get(itemId)
    if not st then
        return
    end
    if st.cookTimer then
        stopAndDestroyTimer(st.cookTimer)
    end
    if st.burnTimer then
        stopAndDestroyTimer(st.burnTimer)
    end
    itemState:delete(itemId)
    local campfireId = getHandleIdSafe(st.campfire)
    local set = campfireItems:get(campfireId)
    if set then
        set:delete(itemId)
        if set.size == 0 then
            campfireItems:delete(campfireId)
        end
    end
end
function startBurnTimer(item, campfire, sec)
    local st = itemState:get(getHandleIdSafe(item))
    local t = jass.CreateTimer()
    if not t then
        return
    end
    burnTimerCtxByHid[jass.GetHandleId(t)] = {item = item, campfire = campfire}
    safeTimerStart(
        nil,
        t,
        sec,
        false,
        onBurnTimerExpire
    )
    if st then
        st.burnTimer = t
    end
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
safeTimerStart = ____require_result_0.safeTimerStart
safeDestroyTimer = ____require_result_0.safeDestroyTimer
local itemEventCenter = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local itemRelatedFns = require("lib.扩展函数.物品相关函数.index")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local withTimer = ____require_result_1.withTimer
stopTimer = ____require_result_1.stopTimer
createTimedEffect = ____require_result_1.createTimedEffect
local _____6F02_6D6E_6587_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
CreateFloatTextAtPoint = _____6F02_6D6E_6587_5B57_6A21_5757.CreateFloatTextAtPoint
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_2.stringToFourCC
local ____require_result_3 = require("系统.02．物品系统.09．装备排泄")
setLastCreatedItem = ____require_result_3.setLastCreatedItem
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_4.registerDeathListener
local CAMPFIRE_ID = 1747988547
EFFECT_FIREBOMB = "war3mapImported\\Firebomb.mdl"
local CAMPFIRE_EVENT_PLAYER_IDS = {0, 1, 2, 3}
itemState = __TS__New(Map)
campfireItems = __TS__New(Map)
burnTimerCtxByHid = {}
local cookTimerCtxByHid = {}
local function onCookTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = cookTimerCtxByHid[hid]
    __TS__Delete(cookTimerCtxByHid, hid)
    if not ctx then
        return
    end
    local item = ctx.item
    local campfire = ctx.campfire
    local timeoutSec = ctx.timeoutSec
    local results = ctx.results
    local itemId = getHandleIdSafe(item)
    if itemId == 0 or not itemState:has(itemId) then
        return
    end
    playFinishEffect(campfire)
    local chosen = pickResult(results)
    local inputCharges = getItemChargesSafe(item)
    jass.RemoveItem(item)
    untrackItem(item)
    local timeout = timeoutSec > 0 and timeoutSec or 0
    local remaining = chosen.qty * inputCharges
    while remaining > 0 do
        local it = createItemAtCampfire(campfire, chosen.itemId)
        if not it then
            break
        end
        setItemChargesSafe(it, remaining)
        local ok = tryGiveItemToCampfire(campfire, it)
        if not ok then
            local roll = jass.GetRandomInt(1, 100)
            if roll > 20 then
                jass.RemoveItem(it)
            end
        else
            local itemId = getHandleIdSafe(it)
            local campfireId = getHandleIdSafe(campfire)
            if itemId ~= 0 and campfireId ~= 0 then
                itemState:set(itemId, {item = it, campfire = campfire, stage = "done"})
                local set = campfireItems:get(campfireId)
                if not set then
                    set = __TS__New(Set)
                    campfireItems:set(campfireId, set)
                end
                set:add(itemId)
            end
            if timeout > 0 then
                startBurnTimer(it, campfire, timeout)
            end
        end
        remaining = 0
    end
end
local function isCampfire(u)
    return jass.GetUnitTypeId(u) == CAMPFIRE_ID
end
--- 使用 01．封装函数.ts 中的 stringToFourCC
local function fourCCToInt(id)
    return stringToFourCC(nil, id)
end
local function getRecipeForItem(item)
    local entry = itemRelatedFns.getItemDataEntry(item)
    local ____temp_14
    if entry and entry.recipe then
        ____temp_14 = entry.recipe
    else
        ____temp_14 = nil
    end
    local recipe = ____temp_14
    if not recipe then
        return nil
    end
    local prefix = "h00C:"
    if recipe:indexOf(prefix) ~= 0 then
        return nil
    end
    local rest = recipe:substring(#prefix)
    local arrowIdx = rest:indexOf("->")
    local colonIdx = -1
    do
        local i = rest.length - 1
        while i >= 0 do
            if rest:substring(i, i + 1) == ":" then
                colonIdx = i
                break
            end
            i = i - 1
        end
    end
    if arrowIdx < 0 or colonIdx < 0 or colonIdx <= arrowIdx + 2 then
        return nil
    end
    local cookStr = rest:substring(0, arrowIdx):trim()
    local resultsStr = rest:substring(arrowIdx + 2, colonIdx):trim()
    local timeoutStr = rest:substring(colonIdx + 1):trim()
    local cookSec = jass.R2I(__TS__ParseFloat(cookStr) or 0)
    local timeoutSec = jass.R2I(__TS__ParseFloat(timeoutStr) or 0)
    if cookSec <= 0 then
        return nil
    end
    local rawOpts = resultsStr:split(";"):map(function(s) return __TS__StringTrim(s) end):filter(function(s) return s ~= "" end)
    if rawOpts.length == 0 then
        return nil
    end
    local opts = {}
    for ____, raw in __TS__Iterator(rawOpts) do
        local s = raw
        local prob = nil
        local pctIdx = s:indexOf("%")
        if pctIdx > 0 then
            local p = __TS__ParseFloat(s:substring(0, pctIdx):trim())
            if not __TS__NumberIsNaN(__TS__Number(p)) and p > 0 then
                prob = p
            end
            s = s:substring(pctIdx + 1):trim()
        end
        local starIdx = s:indexOf("*")
        local ____temp_15
        if starIdx >= 0 then
            ____temp_15 = s:substring(0, starIdx)
        else
            ____temp_15 = s
        end
        local idPart = ____temp_15:trim()
        local ____temp_16
        if starIdx >= 0 then
            ____temp_16 = s:substring(starIdx + 1)
        else
            ____temp_16 = ""
        end
        local qtyPart = ____temp_16:trim()
        local qty = jass.R2I(__TS__ParseFloat(qtyPart) or 1)
        local itemId = fourCCToInt(idPart)
        if itemId ~= 0 and qty > 0 then
            opts[#opts + 1] = {prob = prob, itemId = itemId, qty = qty}
        end
    end
    if #opts == 0 then
        return nil
    end
    return {cookSec = cookSec, timeoutSec = timeoutSec, results = opts}
end
local function startCookTimer(item, campfire, recipe)
    local t = jass.CreateTimer()
    if not t then
        return
    end
    local st = itemState:get(getHandleIdSafe(item))
    if st then
        st.cookTimer = t
    end
    cookTimerCtxByHid[jass.GetHandleId(t)] = {item = item, campfire = campfire, timeoutSec = recipe.timeoutSec, results = recipe.results}
    safeTimerStart(
        nil,
        t,
        recipe.cookSec,
        false,
        onCookTimerExpire
    )
end
local function onAnyPickup()
    local u = jass.GetTriggerUnit()
    local item = jass.GetManipulatedItem()
    if not u or not item then
        return
    end
    if not isCampfire(u) then
        local itemId = getHandleIdSafe(item)
        if itemId ~= 0 and itemState:has(itemId) then
            untrackItem(item)
        end
        return
    end
    local itemId = getHandleIdSafe(item)
    local campfireId = getHandleIdSafe(u)
    if itemId == 0 or campfireId == 0 then
        return
    end
    if itemState:has(itemId) then
        return
    end
    local recipe = getRecipeForItem(item)
    local campfire = u
    itemState:set(itemId, {item = item, campfire = campfire, stage = "raw"})
    local set = campfireItems:get(campfireId)
    if not set then
        set = __TS__New(Set)
        campfireItems:set(campfireId, set)
    end
    set:add(itemId)
    if not recipe then
        startBurnTimer(item, campfire, 15)
    else
        startCookTimer(item, campfire, recipe)
    end
end
local function onCampfireDeath(dyingUnit)
    if not dyingUnit or not isCampfire(dyingUnit) then
        return
    end
    local campfireId = getHandleIdSafe(dyingUnit)
    local set = campfireItems:get(campfireId)
    if not set then
        return
    end
    local itemIds = __TS__ArrayFrom(set:values())
    do
        local i = 0
        while i < #itemIds do
            local st = itemState:get(itemIds[i + 1])
            if st then
                untrackItem(st.item)
            end
            i = i + 1
        end
    end
    campfireItems:delete(campfireId)
end
____exports["init物品加工"] = function()
    itemEventCenter:onItemPickup(function(unit, item)
        onAnyPickup()
    end)
    itemEventCenter:onItemDrop(function(unit, item)
        local itemId = getHandleIdSafe(item)
        if unit and item and isCampfire(unit) and itemId ~= 0 and itemState:has(itemId) then
            untrackItem(item)
        end
    end)
    registerDeathListener(onCampfireDeath)
end
____exports["init物品加工"]()
return ____exports
