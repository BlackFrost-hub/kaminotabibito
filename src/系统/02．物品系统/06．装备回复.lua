local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 装备回复：使用物品时解析 hot/abilList，按段 **STES「物品治疗事件」** 分发。
-- 
-- 逆天约定（传参与返回值**同时支持**，不互斥）：
-- - **传参 `YDLocal5Set` → 子 `YDLocal5Get`**（父在 `YDLocalExecuteTrigger` 之后写入 `ydl_triggerstep`）：
--   `unit` **ItemHealUnit**，`real` **ItemHealHP** / **ItemHealMP**，`item` **Item**，`string` **物品技能标识**。
-- - **返回值 子 `YDLocal7Set` → 父 `YDLocal1Get`**（须先 `SaveInteger(YDHT,子,SKey_PIndex,父页)`，与 STES_Fire / `fireItemHealEvent` 一致）：
--   键名与上列对应：**ItemHealHP**、**ItemHealMP**、**Item**、**ItemHealUnit**。
--   HP/MP：父传参 **非全 0** 时 7 为**实际加上的量**；**双 0** 且能从使用物品事件 + 装备表推算时 7 为**推算总量**（便于父 `QuestMessage`）。**Item/Unit** 先读 5，缺则回退 `GetManipulatedItem` / `GetManipulatingUnit`（`GetTriggerUnit`）再写回 7。
-- 
-- 父遍历子触发须：`YDLocalExecuteTrigger` → `saveParentIndex` → `YDLocal5Set…` → `YDTriggerExecuteTrigger(false)`。
-- 
-- 不再使用 `udg_TempReal` / `gg_trg_物品治疗触发` 等旧全局。
-- 规则：`.cursor/rules/equipment/heal-hot-format.md` / `heal-use-item.md`
local jass = require("jass.common")
local itemEventCenter = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_GetTable = ____require_result_0.STES_GetTable
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_1.YDLocal5Get
local YDLocal5Set = ____require_result_1.YDLocal5Set
local YDLocal7Set = ____require_result_1.YDLocal7Set
local getG_SIndex = ____require_result_1.getG_SIndex
local setG_SIndex = ____require_result_1.setG_SIndex
local setG_LIndex = ____require_result_1.setG_LIndex
local _indexStack = ____require_result_1._indexStack
local ____require_result_2 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_2.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_2.ydlStes_finishChildCleanup
local ydlStes_readString5 = ____require_result_2.ydlStes_readString5
local ydlStes_readReal5 = ____require_result_2.ydlStes_readReal5
local ydlStes_skeyIndex = ____require_result_2.ydlStes_skeyIndex
local registerStesListener = ____require_result_2.registerStesListener
local ____require_result_3 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
local YDLocalExecuteTrigger = ____require_result_3.YDLocalExecuteTrigger
local YDTriggerExecuteTrigger = ____require_result_3.YDTriggerExecuteTrigger
local saveParentIndex = ____require_result_3.saveParentIndex
local ____require_result_4 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_4.safeTimerStart
local safeDestroyTimer = ____require_result_4.safeDestroyTimer
local itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_5.fourCCToString
local isSpecialUnit = ____require_result_5.isSpecialUnit
local ____require_result_6 = require("系统.02．物品系统.06．装备回复_hot")
local parseEquipHealSegments = ____require_result_6.parseEquipHealSegments
local calcEquipHealHpMp = ____require_result_6.calcEquipHealHpMp
local sumHealFromItemData = ____require_result_6.sumHealFromItemData
--- 与地图 STES / JASS `StringHash` 一致
____exports.ITEM_HEAL_STES_EVENT = "物品治疗事件"
--- YDLocal5 / YDLocal7 同名键（5=传参，7=返回值）
local YL_UNIT = "ItemHealUnit"
local YL_HP = "ItemHealHP"
local YL_MP = "ItemHealMP"
local YL_ITEM = "Item"
local YL_ABIL = "物品技能标识"
--- 对生命/魔法做加法并封顶（不写技能表现，技能可由地图另挂 STES 或 GUI）
local function applyHpMpToUnit(unit, hp, mp)
    if unit == nil or unit == 0 then
        return
    end
    if hp > 0 and jass.UNIT_STATE_LIFE ~= nil and jass.UNIT_STATE_MAX_LIFE ~= nil then
        local cur = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)
        local maxL = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
        local nextLife = cur + hp
        jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, nextLife < maxL and nextLife or maxL)
    end
    if mp > 0 and jass.UNIT_STATE_MANA ~= nil and jass.UNIT_STATE_MAX_MANA ~= nil then
        local curM = jass.GetUnitState(unit, jass.UNIT_STATE_MANA)
        local maxM = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
        local nextMana = curM + mp
        jass.SetUnitState(unit, jass.UNIT_STATE_MANA, nextMana < maxM and nextMana or maxM)
    end
end
--- 治疗前后差值，供 YDLocal7 与父 `YDLocal1Get(real,…)` 对齐手写 JASS 子触发的「有效回复量」语义
local function applyHpMpToUnitAndGetApplied(unit, hp, mp)
    if unit == nil or unit == 0 then
        return {hpApplied = 0, mpApplied = 0}
    end
    local lifeBefore = 0
    local manaBefore = 0
    lifeBefore = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)
    manaBefore = jass.GetUnitState(unit, jass.UNIT_STATE_MANA)
    applyHpMpToUnit(unit, hp, mp)
    local lifeAfter = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)
    local manaAfter = jass.GetUnitState(unit, jass.UNIT_STATE_MANA)
    return {hpApplied = lifeAfter > lifeBefore and lifeAfter - lifeBefore or 0, mpApplied = manaAfter > manaBefore and manaAfter - manaBefore or 0}
end
--- 与 JASS 遍历 `物品治疗事件` 等价：对每张注册的子触发器写入 YDLocal5 后 Execute。
local function fireItemHealEvent(unit, item, hp, mp, abilId)
    local stesHT = STES_GetTable(nil)
    if stesHT == nil or stesHT == 0 then
        return
    end
    local hash = jass.StringHash(____exports.ITEM_HEAL_STES_EVENT)
    local loopIndex = jass.LoadInteger(
        stesHT,
        hash,
        ydlStes_skeyIndex(nil, nil)
    )
    _indexStack[#_indexStack + 1] = getG_SIndex(nil)
    do
        local i = 0
        while i < loopIndex do
            do
                local trg = jass.LoadTriggerHandle(stesHT, hash, i)
                if trg == nil or trg == 0 then
                    goto __continue11
                end
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                YDLocal5Set(nil, "unit", YL_UNIT, unit)
                YDLocal5Set(nil, "real", YL_HP, hp)
                YDLocal5Set(nil, "real", YL_MP, mp)
                YDLocal5Set(nil, "item", YL_ITEM, item)
                YDLocal5Set(nil, "string", YL_ABIL, abilId)
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            ::__continue11::
            i = i + 1
        end
    end
    local prev = #_indexStack > 0 and table.remove(_indexStack) or 0
    setG_SIndex(nil, prev)
    setG_LIndex(nil, prev)
end
--- STES 子触发：读参 →（缺参则从使用物品事件 / 装备表补全）→ 治疗 → 四路 YDLocal7 写回父
local function onItemHealStesChild()
    do
        local ____try, ____error = pcall(function()
            ydlStes_syncTriggerStep(nil, nil)
            local rawHp = ydlStes_readReal5(nil, nil, YL_HP)
            local rawMp = ydlStes_readReal5(nil, nil, YL_MP)
            local unit = YDLocal5Get(nil, "unit", YL_UNIT)
            local item = YDLocal5Get(nil, "item", YL_ITEM)
            ydlStes_readString5(nil, nil, YL_ABIL)
            if unit == nil or unit == 0 then
                unit = jass.GetManipulatingUnit()
                if unit == nil or unit == 0 then
                    unit = jass.GetTriggerUnit()
                end
            end
            if item == nil or item == 0 then
                item = jass.GetManipulatedItem()
            end
            local hp = rawHp
            local mp = rawMp
            local filledFromItemData = false
            if rawHp == 0 and rawMp == 0 and not isSpecialUnit(nil, unit) then
                local inf = sumHealFromItemData(
                    nil,
                    unit,
                    item,
                    itemsData,
                    function(n) return fourCCToString(nil, n) end
                )
                if inf.ok then
                    hp = inf.hp
                    mp = inf.mp
                    filledFromItemData = true
                end
            end
            local ____applyHpMpToUnitAndGetApplied_result_7 = applyHpMpToUnitAndGetApplied(unit, hp, mp)
            local hpApplied = ____applyHpMpToUnitAndGetApplied_result_7.hpApplied
            local mpApplied = ____applyHpMpToUnitAndGetApplied_result_7.mpApplied
            local hp7 = filledFromItemData and hp or hpApplied
            local mp7 = filledFromItemData and mp or mpApplied
            YDLocal7Set(nil, "real", YL_HP, hp7)
            YDLocal7Set(nil, "real", YL_MP, mp7)
            YDLocal7Set(nil, "item", YL_ITEM, item)
            YDLocal7Set(nil, "unit", YL_UNIT, unit)
        end)
        do
            ydlStes_finishChildCleanup(nil, nil)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
local function executeSegment(unit, item, seg)
    local ____calcEquipHealHpMp_result_8 = calcEquipHealHpMp(nil, seg.tokens, unit)
    local hp = ____calcEquipHealHpMp_result_8.hp
    local mp = ____calcEquipHealHpMp_result_8.mp
    fireItemHealEvent(
        unit,
        item,
        hp,
        mp,
        seg.abilId
    )
end
local equipHealDebounceKeyByTimerHid = {}
local equipHealDelayCtxByTimerHid = {}
local function onEquipHealDebounceTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local key = equipHealDebounceKeyByTimerHid[hid]
    __TS__Delete(equipHealDebounceKeyByTimerHid, hid)
    if key ~= nil then
        _G.__EquipHealExecutedKey = nil
    end
    safeDestroyTimer(nil, t)
end
local function onEquipHealDelayTimerExpire()
    local t = jass.GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass.GetHandleId(t)
    local ctx = equipHealDelayCtxByTimerHid[hid]
    __TS__Delete(equipHealDelayCtxByTimerHid, hid)
    if ctx ~= nil then
        executeSegment(ctx.unit, ctx.item, ctx.seg)
    end
    safeDestroyTimer(nil, t)
end
local function onUseItem()
    local unit = jass.GetManipulatingUnit()
    if unit == nil then
        unit = jass.GetTriggerUnit()
    end
    local item = jass.GetManipulatedItem()
    if not unit or not item then
        return
    end
    if isSpecialUnit(nil, unit) then
        return
    end
    local itemId = jass.GetItemTypeId(item)
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
    local debounceTimer = jass.CreateTimer()
    if debounceTimer then
        equipHealDebounceKeyByTimerHid[jass.GetHandleId(debounceTimer)] = key
        safeTimerStart(
            nil,
            debounceTimer,
            0.5,
            false,
            onEquipHealDebounceTimerExpire
        )
    end
    local segments = parseEquipHealSegments(nil, entry.hot, entry.abilList)
    for ____, seg in ipairs(segments) do
        do
            if seg.abilId == "" then
                goto __continue36
            end
            if seg.waitSec <= 0 then
                executeSegment(unit, item, seg)
            else
                local delayTimer = jass.CreateTimer()
                if delayTimer then
                    equipHealDelayCtxByTimerHid[jass.GetHandleId(delayTimer)] = {unit = unit, item = item, seg = seg}
                    safeTimerStart(
                        nil,
                        delayTimer,
                        seg.waitSec,
                        false,
                        onEquipHealDelayTimerExpire
                    )
                end
            end
        end
        ::__continue36::
    end
end
local INIT_KEY = "__EquipHealInited"
local STES_REG_KEY = "__EquipHealStesRegistered"
local function init()
    local glob = _G
    if glob[INIT_KEY] then
        return
    end
    glob[INIT_KEY] = true
    if not glob[STES_REG_KEY] then
        registerStesListener(
            nil,
            ____exports.ITEM_HEAL_STES_EVENT,
            function()
                onItemHealStesChild()
            end
        )
        glob[STES_REG_KEY] = true
    end
    itemEventCenter:onItemUse(function(unit, item)
        onUseItem()
    end)
end
init()
return ____exports
