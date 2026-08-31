local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local getHandleIdSafe, _____53D6_7269_54C1_52A0_5DE5_884C_53F7, _____521B_5EFA_7269_54C1_52A0_5DE5UI, _____9500_6BC1_7269_54C1_52A0_5DE5UI, _____5237_65B0_7269_54C1_52A0_5DE5UI, _____5904_7406_70E4_7126_5230_671F, _____5904_7406_52A0_5DE5_5230_671F, getItemNameSafe, getItemChargesSafe, setItemChargesSafe, getUnitXY, floatBurnText, playFinishEffect, pickResult, createItemAtCampfire, tryGiveItemToCampfire, _____505C_6B62_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5, _____786E_4FDD_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5, _____53D6_6D88_7269_54C1_52A0_5DE5_4EFB_52A1, _____53D6_6D88_7269_54C1_52A0_5DE5_4EFB_52A1_5F15_7528, _____5B89_6392_7269_54C1_52A0_5DE5_4EFB_52A1, ____on_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5, untrackItem, startBurnTimer, jass, R2I, addPeriodicCallback, removePeriodicCallback, getServerTime, createTimedEffect, CreateFloatTextAtPoint, _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C, _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI, _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI, _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI, EFFECT_FIREBOMB, _____52A0_5DE5UI_57FA_7840_9AD8_5EA6, _____52A0_5DE5UI_5C4F_5E55_884C_8DDD, itemState, campfireItems, _____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2, _____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868, _____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868, _____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868, _____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868, _____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868, _____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868, _____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868, _____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_56DE_8C03ID, _____4E0B_4E00_4E2A_7269_54C1_52A0_5DE5_4EFB_52A1ID, _____6B63_5728_5C06_52A0_5DE5_4EA7_7269_653E_56DE_7BDD_706B
function getHandleIdSafe(handle)
    if not handle then
        return 0
    end
    return jass.GetHandleId(handle) or 0
end
function _____53D6_7269_54C1_52A0_5DE5_884C_53F7(item)
    local itemId = getHandleIdSafe(item)
    local state = itemState[itemId]
    return state and state["行号"] or 0
end
function _____521B_5EFA_7269_54C1_52A0_5DE5UI(item, campfire, maximum, current, title)
    if not (maximum > 0) then
        return nil
    end
    local ____getUnitXY_result_9 = getUnitXY(campfire)
    local x = ____getUnitXY_result_9.x
    local y = ____getUnitXY_result_9.y
    return _____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI({
        X = x,
        Y = y,
        Z = _____52A0_5DE5UI_57FA_7840_9AD8_5EA6,
        ["屏幕Y偏移"] = _____53D6_7269_54C1_52A0_5DE5_884C_53F7(item) * _____52A0_5DE5UI_5C4F_5E55_884C_8DDD,
        ["最大值"] = maximum,
        ["当前值"] = current,
        ["标题"] = title,
        ["数值后缀"] = "秒",
        ["类型"] = "自然",
        ["平滑过渡秒"] = 0.05,
        ["初始显示"] = true,
        ["雾中可见"] = false
    })
end
function _____9500_6BC1_7269_54C1_52A0_5DE5UI(state)
    if state == nil or state.UI == nil then
        return
    end
    _____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI(state.UI)
    state.UI = nil
end
function _____5237_65B0_7269_54C1_52A0_5DE5UI(item, now, ____type)
    local state = itemState[getHandleIdSafe(item)]
    if state == nil or state.UI == nil or state["开始毫秒"] == nil or state["到期毫秒"] == nil then
        return
    end
    if ____type == "cook" then
        local elapsed = (now - state["开始毫秒"]) / 1000
        _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state.UI, elapsed)
        return
    end
    local remaining = (state["到期毫秒"] - now) / 1000
    _____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI(state.UI, remaining > 0 and remaining or 0)
end
function _____5904_7406_70E4_7126_5230_671F(item, campfire)
    local itemId = getHandleIdSafe(item)
    if itemId == 0 or not itemState[itemId] then
        return
    end
    local name = getItemNameSafe(item)
    floatBurnText(campfire, name)
    jass.RemoveItem(item)
    untrackItem(item)
end
function _____5904_7406_52A0_5DE5_5230_671F(item, campfire, timeoutSec, results)
    local itemId = getHandleIdSafe(item)
    if itemId == 0 or not itemState[itemId] then
        return
    end
    local state = itemState[itemId]
    local oldRow = state and state["行号"] or 0
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
                itemState[itemId] = {item = it, campfire = campfire, stage = "done", ["行号"] = oldRow}
                local items = campfireItems[campfireId]
                if not items then
                    items = {}
                    campfireItems[campfireId] = items
                end
                items[#items + 1] = itemId
            end
            if timeout > 0 then
                startBurnTimer(it, campfire, timeout)
            end
        end
        remaining = 0
    end
end
function getItemNameSafe(item)
    return jass.GetItemName(item)
end
function getItemChargesSafe(item)
    local n = jass.GetItemCharges(item)
    local ____TS__Number_result_12 = __TS__Number(n)
    if ____TS__Number_result_12 == nil then
        ____TS__Number_result_12 = 0
    end
    local v = R2I(____TS__Number_result_12) or 0
    return v > 0 and v or 1
end
function setItemChargesSafe(item, n)
    if not item then
        return
    end
    local v = R2I(n) or 1
    jass.SetItemCharges(item, v > 0 and v or 1)
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
    local ____getUnitXY_result_13 = getUnitXY(campfire)
    local x = ____getUnitXY_result_13.x
    local y = ____getUnitXY_result_13.y
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
    local ____getUnitXY_result_14 = getUnitXY(campfire)
    local x = ____getUnitXY_result_14.x
    local y = ____getUnitXY_result_14.y
    createTimedEffect(
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
    local ____getUnitXY_result_15 = getUnitXY(campfire)
    local x = ____getUnitXY_result_15.x
    local y = ____getUnitXY_result_15.y
    return _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(itemId, x, y)
end
function tryGiveItemToCampfire(campfire, item)
    if not item then
        return false
    end
    _____6B63_5728_5C06_52A0_5DE5_4EA7_7269_653E_56DE_7BDD_706B = true
    local success = not not jass.UnitAddItem(campfire, item)
    _____6B63_5728_5C06_52A0_5DE5_4EA7_7269_653E_56DE_7BDD_706B = false
    return success
end
function _____505C_6B62_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5()
    if _____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_56DE_8C03ID)
    _____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
end
function _____786E_4FDD_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5()
    if _____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2, ____on_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5)
end
function _____53D6_6D88_7269_54C1_52A0_5DE5_4EFB_52A1(taskId)
    if not (taskId > 0) then
        return
    end
    do
        local i = 0
        while i < #_____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868 do
            if _____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868[i + 1] == taskId then
                _____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868[i + 1] = 0
                return
            end
            i = i + 1
        end
    end
end
function _____53D6_6D88_7269_54C1_52A0_5DE5_4EFB_52A1_5F15_7528(t)
    if not t then
        return
    end
    _____53D6_6D88_7269_54C1_52A0_5DE5_4EFB_52A1(t)
end
function _____5B89_6392_7269_54C1_52A0_5DE5_4EFB_52A1(_____7C7B_578B, item, campfire, delaySec, timeoutSec, results)
    _____4E0B_4E00_4E2A_7269_54C1_52A0_5DE5_4EFB_52A1ID = _____4E0B_4E00_4E2A_7269_54C1_52A0_5DE5_4EFB_52A1ID + 1
    _____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868[#_____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868 + 1] = _____4E0B_4E00_4E2A_7269_54C1_52A0_5DE5_4EFB_52A1ID
    _____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868[#_____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868 + 1] = _____7C7B_578B
    _____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868[#_____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868 + 1] = item
    _____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868[#_____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868 + 1] = campfire
    _____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868[#_____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868 + 1] = timeoutSec
    _____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868[#_____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868 + 1] = results
    _____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868[#_____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + delaySec * 1000
    _____786E_4FDD_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5()
    return _____4E0B_4E00_4E2A_7269_54C1_52A0_5DE5_4EFB_52A1ID
end
function ____on_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868 do
            do
                local taskId = _____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868[i + 1]
                if not (taskId > 0) then
                    goto __continue87
                end
                if now >= _____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                    if _____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868[i + 1] == "burn" then
                        _____5904_7406_70E4_7126_5230_671F(_____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868[i + 1], _____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868[i + 1])
                    else
                        _____5904_7406_52A0_5DE5_5230_671F(_____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868[i + 1], _____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868[i + 1], _____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868[i + 1], _____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868[i + 1])
                    end
                else
                    _____5237_65B0_7269_54C1_52A0_5DE5UI(_____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868[i + 1], now, _____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868[i + 1])
                    _____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868[writeIndex + 1] = taskId
                    _____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868[writeIndex + 1] = _____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868[i + 1]
                    _____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868[writeIndex + 1] = _____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868[i + 1]
                    _____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868[writeIndex + 1] = _____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868[i + 1]
                    _____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868[writeIndex + 1] = _____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868[i + 1]
                    _____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868[writeIndex + 1] = _____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868[i + 1]
                    _____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868[i + 1]
                    writeIndex = writeIndex + 1
                end
            end
            ::__continue87::
            i = i + 1
        end
    end
    do
        local i = #_____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868)
            table.remove(_____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868)
            table.remove(_____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868)
            table.remove(_____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868)
            table.remove(_____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868)
            table.remove(_____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868)
            table.remove(_____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
    if #_____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868 <= 0 then
        _____505C_6B62_7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5()
    end
end
function untrackItem(item)
    local itemId = getHandleIdSafe(item)
    if itemId == 0 then
        return
    end
    local st = itemState[itemId]
    if not st then
        return
    end
    _____9500_6BC1_7269_54C1_52A0_5DE5UI(st)
    if st.cookTimer then
        _____53D6_6D88_7269_54C1_52A0_5DE5_4EFB_52A1_5F15_7528(st.cookTimer)
    end
    if st.burnTimer then
        _____53D6_6D88_7269_54C1_52A0_5DE5_4EFB_52A1_5F15_7528(st.burnTimer)
    end
    itemState[itemId] = nil
    local campfireId = getHandleIdSafe(st.campfire)
    local items = campfireItems[campfireId]
    if items then
        do
            local i = 0
            while i < #items do
                if items[i + 1] == itemId then
                    __TS__ArraySplice(items, i, 1)
                    break
                end
                i = i + 1
            end
        end
        if #items == 0 then
            campfireItems[campfireId] = nil
        end
    end
end
function startBurnTimer(item, campfire, sec)
    local st = itemState[getHandleIdSafe(item)]
    if st == nil then
        return
    end
    _____9500_6BC1_7269_54C1_52A0_5DE5UI(st)
    local startMs = getServerTime()
    st["开始毫秒"] = startMs
    st["到期毫秒"] = startMs + sec * 1000
    if sec > 0 then
        st.UI = _____521B_5EFA_7269_54C1_52A0_5DE5UI(
            item,
            campfire,
            sec,
            sec,
            st.stage == "done" and "烧烤失败" or getItemNameSafe(item)
        )
    end
    local taskId = _____5B89_6392_7269_54C1_52A0_5DE5_4EFB_52A1(
        "burn",
        item,
        campfire,
        sec,
        0,
        {}
    )
    st.burnTimer = taskId
end
jass = require("jass.common")
R2I = jass.R2I
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemPickup = ____require_result_1.onItemPickup
local onItemDrop = ____require_result_1.onItemDrop
local itemRelatedFns = require("lib.扩展函数.物品相关函数.index")
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
createTimedEffect = ____require_result_2.createTimedEffect
local _____6F02_6D6E_6587_5B57_6A21_5757 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
CreateFloatTextAtPoint = _____6F02_6D6E_6587_5B57_6A21_5757.CreateFloatTextAtPoint
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_3.stringToFourCC
local ____require_result_4 = require("lib.扩展函数.物品相关函数.index")
_____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_4["创建物品并注册排泄监听"]
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local ____require_result_6 = require("系统.09．表现系统.15．世界坐标进度UI.index")
_____521B_5EFA_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_6["创建世界坐标进度UI"]
_____66F4_65B0_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_6["更新世界坐标进度UI"]
_____9500_6BC1_4E16_754C_5750_6807_8FDB_5EA6UI = ____require_result_6["销毁世界坐标进度UI"]
local CAMPFIRE_ID = 1747988547
EFFECT_FIREBOMB = "war3mapImported\\Firebomb.mdl"
local CAMPFIRE_EVENT_PLAYER_IDS = {0, 1, 2, 3}
_____52A0_5DE5UI_57FA_7840_9AD8_5EA6 = 100
_____52A0_5DE5UI_5C4F_5E55_884C_8DDD = 0.01
itemState = {}
campfireItems = {}
_____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2 = 10
_____7269_54C1_52A0_5DE5_4EFB_52A1ID_5217_8868 = {}
_____7269_54C1_52A0_5DE5_4EFB_52A1_7C7B_578B_5217_8868 = {}
_____7269_54C1_52A0_5DE5_4EFB_52A1_7269_54C1_5217_8868 = {}
_____7269_54C1_52A0_5DE5_4EFB_52A1_7BDD_706B_5217_8868 = {}
_____7269_54C1_52A0_5DE5_4EFB_52A1_8D85_65F6_79D2_5217_8868 = {}
_____7269_54C1_52A0_5DE5_4EFB_52A1_7ED3_679C_5217_8868 = {}
_____7269_54C1_52A0_5DE5_4EFB_52A1_5230_671F_6BEB_79D2_5217_8868 = {}
_____7269_54C1_52A0_5DE5_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
_____4E0B_4E00_4E2A_7269_54C1_52A0_5DE5_4EFB_52A1ID = 0
_____6B63_5728_5C06_52A0_5DE5_4EA7_7269_653E_56DE_7BDD_706B = false
local function _____5206_914D_7269_54C1_52A0_5DE5_884C_53F7(campfireId)
    local items = campfireItems[campfireId]
    if items == nil or #items == 0 then
        return 0
    end
    local row = 0
    while true do
        local occupied = false
        do
            local i = 0
            while i < #items do
                local state = itemState[items[i + 1]]
                if state ~= nil and state["行号"] == row then
                    occupied = true
                    break
                end
                i = i + 1
            end
        end
        if not occupied then
            return row
        end
        row = row + 1
    end
end
local function isCampfire(u)
    return jass.GetUnitTypeId(u) == CAMPFIRE_ID
end
--- 使用 01．封装函数.ts 中的 stringToFourCC
local function fourCCToInt(id)
    return stringToFourCC(id)
end
local function getRecipeForItem(item)
    local entry = itemRelatedFns.getItemDataEntry(item)
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
    local cookSec = R2I(__TS__ParseFloat(cookStr) or 0)
    local timeoutSec = R2I(__TS__ParseFloat(timeoutStr) or 0)
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
        local qty = R2I(__TS__ParseFloat(qtyPart) or 1)
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
    local st = itemState[getHandleIdSafe(item)]
    if st == nil then
        return
    end
    _____9500_6BC1_7269_54C1_52A0_5DE5UI(st)
    local startMs = getServerTime()
    st["开始毫秒"] = startMs
    st["到期毫秒"] = startMs + recipe.cookSec * 1000
    st.UI = _____521B_5EFA_7269_54C1_52A0_5DE5UI(
        item,
        campfire,
        recipe.cookSec,
        0,
        getItemNameSafe(item)
    )
    local taskId = _____5B89_6392_7269_54C1_52A0_5DE5_4EFB_52A1(
        "cook",
        item,
        campfire,
        recipe.cookSec,
        recipe.timeoutSec,
        recipe.results
    )
    st.cookTimer = taskId
end
local function onAnyPickup(u, item)
    if not u or not item then
        return
    end
    if _____6B63_5728_5C06_52A0_5DE5_4EA7_7269_653E_56DE_7BDD_706B and isCampfire(u) then
        return
    end
    if not isCampfire(u) then
        local itemId = getHandleIdSafe(item)
        if itemId ~= 0 and itemState[itemId] then
            untrackItem(item)
        end
        return
    end
    local itemId = getHandleIdSafe(item)
    local campfireId = getHandleIdSafe(u)
    if itemId == 0 or campfireId == 0 then
        return
    end
    if itemState[itemId] then
        return
    end
    local recipe = getRecipeForItem(item)
    local campfire = u
    local items = campfireItems[campfireId]
    if not items then
        items = {}
        campfireItems[campfireId] = items
    end
    local _____884C_53F7 = _____5206_914D_7269_54C1_52A0_5DE5_884C_53F7(campfireId)
    itemState[itemId] = {item = item, campfire = campfire, stage = "raw", ["行号"] = _____884C_53F7}
    items[#items + 1] = itemId
    if not recipe then
        startBurnTimer(item, campfire, 15)
    else
        startCookTimer(item, campfire, recipe)
    end
end
local function _____5904_7406_7269_54C1_4E22_5F03_4E8B_4EF6(unit, item)
    local itemId = getHandleIdSafe(item)
    if unit and item and isCampfire(unit) and itemId ~= 0 and itemState[itemId] then
        untrackItem(item)
    end
end
local function onCampfireDeath(dyingUnit)
    if not dyingUnit or not isCampfire(dyingUnit) then
        return
    end
    local campfireId = getHandleIdSafe(dyingUnit)
    local items = campfireItems[campfireId]
    if not items then
        return
    end
    local itemIds = __TS__ArraySlice(items)
    do
        local i = 0
        while i < #itemIds do
            local st = itemState[itemIds[i + 1]]
            if st then
                untrackItem(st.item)
            end
            i = i + 1
        end
    end
    campfireItems[campfireId] = nil
end
____exports["init物品加工"] = function()
    onItemPickup(onAnyPickup)
    onItemDrop(_____5904_7406_7269_54C1_4E22_5F03_4E8B_4EF6)
    registerDeathListener(onCampfireDeath)
end
____exports["init物品加工"]()
return ____exports
