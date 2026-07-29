--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local fireItemHealEvent, executeSegment, _____505C_6B62_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5, _____5904_7406_88C5_5907_56DE_590D_9632_6296_5230_671F, _____5904_7406_88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5230_671F, ____on_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5, jass, STES_GetTable, YDLocal5Set, getG_SIndex, setG_SIndex, setG_LIndex, _indexStack, ydlStes_skeyIndex, YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex, removePeriodicCallback, getServerTime, calcEquipHealHpMp, YL_UNIT, YL_HP, YL_MP, YL_ITEM, YL_ABIL, _____88C5_5907_56DE_590D_9632_6296_952E_5217_8868, _____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID
function fireItemHealEvent(unit, item, hp, mp, abilId)
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
function executeSegment(unit, item, seg)
    local ____calcEquipHealHpMp_result_9 = calcEquipHealHpMp(nil, seg.tokens, unit)
    local hp = ____calcEquipHealHpMp_result_9.hp
    local mp = ____calcEquipHealHpMp_result_9.mp
    fireItemHealEvent(
        unit,
        item,
        hp,
        mp,
        seg.abilId
    )
end
function _____505C_6B62_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5()
    if _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID)
    _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
end
function _____5904_7406_88C5_5907_56DE_590D_9632_6296_5230_671F(now)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868 do
            if now >= _____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                _G.__EquipHealExecutedKey = nil
            else
                _____88C5_5907_56DE_590D_9632_6296_952E_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_9632_6296_952E_5217_8868[i + 1]
                _____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868)
            table.remove(_____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
end
function _____5904_7406_88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5230_671F(now)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 do
            if now >= _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                executeSegment(_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[i + 1], _____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868[i + 1], _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[i + 1])
            else
                _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[i + 1]
                _____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868[i + 1]
                _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[i + 1]
                _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868)
            table.remove(_____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868)
            table.remove(_____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868)
            table.remove(_____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
end
function ____on_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5()
    local now = getServerTime()
    _____5904_7406_88C5_5907_56DE_590D_9632_6296_5230_671F(now)
    _____5904_7406_88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5230_671F(now)
    if #_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868 <= 0 and #_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 <= 0 then
        _____505C_6B62_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5()
    end
end
jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetItemTypeId = jass.GetItemTypeId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemUse = ____require_result_0.onItemUse
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
STES_GetTable = ____require_result_1.STES_GetTable
local ____require_result_2 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_2.YDLocal5Get
YDLocal5Set = ____require_result_2.YDLocal5Set
local YDLocal7Set = ____require_result_2.YDLocal7Set
getG_SIndex = ____require_result_2.getG_SIndex
setG_SIndex = ____require_result_2.setG_SIndex
setG_LIndex = ____require_result_2.setG_LIndex
_indexStack = ____require_result_2._indexStack
local ____require_result_3 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_3.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_3.ydlStes_finishChildCleanup
local ydlStes_readString5 = ____require_result_3.ydlStes_readString5
local ydlStes_readReal5 = ____require_result_3.ydlStes_readReal5
ydlStes_skeyIndex = ____require_result_3.ydlStes_skeyIndex
local registerStesListener = ____require_result_3.registerStesListener
local ____require_result_4 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
YDLocalExecuteTrigger = ____require_result_4.YDLocalExecuteTrigger
YDTriggerExecuteTrigger = ____require_result_4.YDTriggerExecuteTrigger
saveParentIndex = ____require_result_4.saveParentIndex
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_5.addPeriodicCallback
removePeriodicCallback = ____require_result_5.removePeriodicCallback
getServerTime = ____require_result_5.getServerTime
local itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_6.fourCCToString
local isSpecialUnit = ____require_result_6.isSpecialUnit
local ____require_result_7 = require("系统.02．物品系统.06．装备回复_hot")
local parseEquipHealSegments = ____require_result_7.parseEquipHealSegments
calcEquipHealHpMp = ____require_result_7.calcEquipHealHpMp
local sumHealFromItemData = ____require_result_7.sumHealFromItemData
--- 与地图 STES / JASS `StringHash` 一致
____exports.ITEM_HEAL_STES_EVENT = "物品治疗事件"
YL_UNIT = "ItemHealUnit"
YL_HP = "ItemHealHP"
YL_MP = "ItemHealMP"
YL_ITEM = "Item"
YL_ABIL = "物品技能标识"
--- 对生命/魔法做加法并封顶（不写技能表现，技能可由地图另挂 STES 或 GUI）
local function applyHpMpToUnit(unit, hp, mp)
    if unit == nil or unit == 0 then
        return
    end
    if hp > 0 and jass.UNIT_STATE_LIFE ~= nil and jass.UNIT_STATE_MAX_LIFE ~= nil then
        local cur = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)
        local maxL = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE)
        local nextLife = cur + hp
        jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, nextLife < maxL and nextLife or maxL)
    end
    if mp > 0 and jass.UNIT_STATE_MANA ~= nil and jass.UNIT_STATE_MAX_MANA ~= nil then
        local curM = jass.GetUnitState(unit, jass.UNIT_STATE_MANA)
        local maxM = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA)
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
                    function(n) return fourCCToString(n) end
                )
                if inf.ok then
                    hp = inf.hp
                    mp = inf.mp
                    filledFromItemData = true
                end
            end
            local ____applyHpMpToUnitAndGetApplied_result_8 = applyHpMpToUnitAndGetApplied(unit, hp, mp)
            local hpApplied = ____applyHpMpToUnitAndGetApplied_result_8.hpApplied
            local mpApplied = ____applyHpMpToUnitAndGetApplied_result_8.mpApplied
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
local _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2 = 10
_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868 = {}
_____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868 = {}
_____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID = 0
local function _____786E_4FDD_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5()
    if _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2, ____on_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5)
end
local function _____5B89_6392_88C5_5907_56DE_590D_9632_6296_6E05_7406(key, delaySec)
    _____88C5_5907_56DE_590D_9632_6296_952E_5217_8868[#_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868 + 1] = key
    _____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868[#_____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + delaySec * 1000
    _____786E_4FDD_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5()
end
local function _____5B89_6392_88C5_5907_56DE_590D_5EF6_8FDF_6BB5(unit, item, seg)
    _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 + 1] = unit
    _____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_7269_54C1_5217_8868 + 1] = item
    _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868 + 1] = seg
    _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + seg.waitSec * 1000
    _____786E_4FDD_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5()
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
    local itemId = GetItemTypeId(item)
    local idStr = fourCCToString(itemId)
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
    _____5B89_6392_88C5_5907_56DE_590D_9632_6296_6E05_7406(key, 0.5)
    local segments = parseEquipHealSegments(nil, entry.hot, entry.abilList)
    for ____, seg in ipairs(segments) do
        do
            if seg.abilId == "" then
                goto __continue51
            end
            if seg.waitSec <= 0 then
                executeSegment(unit, item, seg)
            else
                _____5B89_6392_88C5_5907_56DE_590D_5EF6_8FDF_6BB5(unit, item, seg)
            end
        end
        ::__continue51::
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
    onItemUse(function(unit, item)
        onUseItem()
    end)
end
init()
return ____exports
