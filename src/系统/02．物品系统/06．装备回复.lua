--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local applyItemHeal, executeSegment, _____505C_6B62_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5, _____5904_7406_88C5_5907_56DE_590D_9632_6296_5230_671F, _____5904_7406_88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5230_671F, ____on_88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5, doHealItemEffectById, removePeriodicCallback, getServerTime, calcEquipHealHpMp, _____88C5_5907_56DE_590D_9632_6296_952E_5217_8868, _____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868, _____88C5_5907_56DE_590D_5EF6_8FDF_5230_671F_6BEB_79D2_5217_8868, _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_56DE_8C03ID
function applyItemHeal(unit, hp, mp, abilId, hotDuration)
    doHealItemEffectById(
        abilId,
        unit,
        hp,
        mp,
        hotDuration
    )
end
function executeSegment(unit, seg, hotDuration)
    local ____calcEquipHealHpMp_result_7 = calcEquipHealHpMp(nil, seg.tokens, unit)
    local hp = ____calcEquipHealHpMp_result_7.hp
    local mp = ____calcEquipHealHpMp_result_7.mp
    applyItemHeal(
        unit,
        hp,
        mp,
        seg.abilId,
        hotDuration
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
                executeSegment(_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[i + 1], _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[i + 1], _____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868[i + 1])
            else
                _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[i + 1]
                _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[i + 1]
                _____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868[writeIndex + 1] = _____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868[i + 1]
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
            table.remove(_____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868)
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
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____4E34_65F6_73A9_5BB6_5C5E_6027 = ____require_result_1["临时玩家属性"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____707C_70ED_4F7F_7528BuffID = "C075"
local _____707C_70ED_4F7F_7528_6301_7EED_79D2 = 30
local _____707C_70ED_4F7F_7528_706B_4F24_52A0_6210 = 0.3
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.05．物品治疗效果")
doHealItemEffectById = ____require_result_3.doHealItemEffectById
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
removePeriodicCallback = ____require_result_4.removePeriodicCallback
getServerTime = ____require_result_4.getServerTime
local itemsData = require("系统.02．物品系统.01．装备数据").default
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_5.fourCCToString
local isSpecialUnit = ____require_result_5.isSpecialUnit
local ____require_result_6 = require("系统.02．物品系统.06．装备回复_hot")
local parseEquipHealSegments = ____require_result_6.parseEquipHealSegments
calcEquipHealHpMp = ____require_result_6.calcEquipHealHpMp
local _____88C5_5907_56DE_590D_8BA1_65F6_68C0_67E5_95F4_9694_6BEB_79D2 = 10
_____88C5_5907_56DE_590D_9632_6296_952E_5217_8868 = {}
_____88C5_5907_56DE_590D_9632_6296_5230_671F_6BEB_79D2_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868 = {}
_____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868 = {}
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
local function _____5B89_6392_88C5_5907_56DE_590D_5EF6_8FDF_6BB5(unit, seg, hotDuration)
    _____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_5355_4F4D_5217_8868 + 1] = unit
    _____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_6BB5_5217_8868 + 1] = seg
    _____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868[#_____88C5_5907_56DE_590D_5EF6_8FDF_6301_7EED_65F6_95F4_5217_8868 + 1] = hotDuration
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
                executeSegment(unit, seg, entry.hotDuration)
            else
                _____5B89_6392_88C5_5907_56DE_590D_5EF6_8FDF_6BB5(unit, seg, entry.hotDuration)
            end
        end
        ::__continue34::
    end
    if entry.useBuff == _____707C_70ED_4F7F_7528BuffID then
        _____4E34_65F6_73A9_5BB6_5C5E_6027(unit, "火属性伤害", _____707C_70ED_4F7F_7528_706B_4F24_52A0_6210, _____707C_70ED_4F7F_7528_6301_7EED_79D2)
        registerManualBuff(
            unit,
            _____707C_70ED_4F7F_7528BuffID,
            _____707C_70ED_4F7F_7528_6301_7EED_79D2,
            _____707C_70ED_4F7F_7528_706B_4F24_52A0_6210 * 100,
            {effectSourceName = "烤熔岩灵鱼", effectSourceType = "食品"}
        )
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
