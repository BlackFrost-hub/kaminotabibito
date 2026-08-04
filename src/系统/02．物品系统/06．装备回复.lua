--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local applyItemHeal, executeSegment, _____505C_6B62_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5, _____5904_7406_88C5_5907_56DE_590D_9632_6296_5230_671F, _____5904_7406_88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5230_671F, ____on_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5, doHealItemEffectById, removePeriodicCallback, getServerTime, calcEquipHealHpMp, _____88C5_5907_56DE_590D_9632_6296_952E_5217_8868, _____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID
function applyItemHeal(unit, hp, mp, abilId)
    doHealItemEffectById(abilId, unit, hp, mp)
end
function executeSegment(unit, seg)
    local ____calcEquipHealHpMp_result_5 = calcEquipHealHpMp(nil, seg.tokens, unit)
    local hp = ____calcEquipHealHpMp_result_5.hp
    local mp = ____calcEquipHealHpMp_result_5.mp
    applyItemHeal(unit, hp, mp, seg.abilId)
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
                executeSegment(_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[i + 1], _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[i + 1])
            else
                _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[i + 1]
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
--- 装备回复：使用物品时解析 hot/abilList，直接调用 TS 回复逻辑。
-- 立即段直接执行，延迟段交给本地计时检查；回复量统一由治疗系统结算。
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemUse = ____require_result_0.onItemUse
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.05．物品治疗效果")
doHealItemEffectById = ____require_result_1.doHealItemEffectById
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
removePeriodicCallback = ____require_result_2.removePeriodicCallback
getServerTime = ____require_result_2.getServerTime
local itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_3.fourCCToString
local isSpecialUnit = ____require_result_3.isSpecialUnit
local ____require_result_4 = require("系统.02．物品系统.06．装备回复_hot")
local parseEquipHealSegments = ____require_result_4.parseEquipHealSegments
calcEquipHealHpMp = ____require_result_4.calcEquipHealHpMp
local _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2 = 10
_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868 = {}
_____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 = {}
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
local function _____5B89_6392_88C5_5907_56DE_590D_5EF6_8FDF_6BB5(unit, seg)
    _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 + 1] = unit
    _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868 + 1] = seg
    _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + seg.waitSec * 1000
    _____786E_4FDD_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5()
end
local function onUseItem(eventUnit, eventItem)
    local unit = eventUnit
    if unit == nil then
        unit = jass.GetManipulatingUnit()
    end
    if unit == nil then
        unit = jass.GetTriggerUnit()
    end
    local item = eventItem
    if item == nil then
        item = jass.GetManipulatedItem()
    end
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
                goto __continue34
            end
            if seg.waitSec <= 0 then
                executeSegment(unit, seg)
            else
                _____5B89_6392_88C5_5907_56DE_590D_5EF6_8FDF_6BB5(unit, seg)
            end
        end
        ::__continue34::
    end
end
local INIT_KEY = "__EquipHealInited"
local function onItemUseEvent(unit, item)
    onUseItem(unit, item)
end
local function init()
    local glob = _G
    if glob[INIT_KEY] then
        return
    end
    glob[INIT_KEY] = true
    onItemUse(onItemUseEvent)
end
init()
return ____exports
