local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
--- 装备恢复效果配置表
-- 
-- key: 游戏内装备名|内部物体ID
-- value: 恢复效果配置
____exports.ITEM_REGEN_EFFECTS = {["熊王腰带|I0BR"] = {type = "life_percent", value = 0.12}}
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local UnitItemInSlot = jass.UnitItemInSlot
local GetItemTypeId = jass.GetItemTypeId
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local function _____63D0_53D6_5185_90E8_7269_4F53ID(_____914D_7F6E_952E_540D)
    local _____7247_6BB5_5217_8868 = __TS__StringSplit(_____914D_7F6E_952E_540D, "|")
    return _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868] or _____914D_7F6E_952E_540D
end
--- 检查单位是否拥有指定物品
local function hasItem(unit, _____914D_7F6E_952E_540D)
    local targetItemId = stringToFourCC(_____63D0_53D6_5185_90E8_7269_4F53ID(_____914D_7F6E_952E_540D))
    do
        local i = 0
        while i < 6 do
            local item = UnitItemInSlot(unit, i)
            if item ~= nil then
                local itemTypeId = GetItemTypeId(item)
                if itemTypeId == targetItemId then
                    return true
                end
            end
            i = i + 1
        end
    end
    return false
end
--- 计算装备提供的生命恢复加成
-- 
-- @param unit 目标单位
-- @returns 生命恢复加成值
function ____exports.calcItemLifeRegenBonus(unit)
    local totalBonus = 0
    local maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(____exports.ITEM_REGEN_EFFECTS),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local itemIdStr = ____value[1]
        local effect = ____value[2]
        do
            if not hasItem(unit, itemIdStr) then
                goto __continue10
            end
            if effect.type == "life_percent" then
                totalBonus = totalBonus + maxLife * effect.value
            elseif effect.type == "life_fixed" then
                totalBonus = totalBonus + effect.value
            end
        end
        ::__continue10::
    end
    return totalBonus
end
--- 计算装备提供的魔法恢复加成
-- 
-- @param unit 目标单位
-- @returns 魔法恢复加成值
function ____exports.calcItemManaRegenBonus(unit)
    local totalBonus = 0
    local maxMana = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(____exports.ITEM_REGEN_EFFECTS),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local itemIdStr = ____value[1]
        local effect = ____value[2]
        do
            if not hasItem(unit, itemIdStr) then
                goto __continue17
            end
            if effect.type == "mana_percent" then
                totalBonus = totalBonus + maxMana * effect.value
            elseif effect.type == "mana_fixed" then
                totalBonus = totalBonus + effect.value
            end
        end
        ::__continue17::
    end
    return totalBonus
end
return ____exports
