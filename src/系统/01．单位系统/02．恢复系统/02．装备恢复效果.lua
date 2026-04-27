local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
--- 装备恢复效果配置表
-- 
-- key: 物品ID（字符串形式，如 'I0BR'）
-- value: 恢复效果配置
____exports.ITEM_REGEN_EFFECTS = {I0BR = {type = "life_percent", value = 0.12}}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
--- 检查单位是否拥有指定物品
local function hasItem(self, unit, itemIdStr)
    local targetItemId = stringToFourCC(nil, itemIdStr)
    do
        local i = 0
        while i < 6 do
            local item = jass.UnitItemInSlot(unit, i)
            if item ~= nil then
                local itemTypeId = jass.GetItemTypeId(item)
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
function ____exports.calcItemLifeRegenBonus(self, unit)
    local totalBonus = 0
    local maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
    for ____, ____value in ipairs(__TS__ObjectEntries(____exports.ITEM_REGEN_EFFECTS)) do
        local itemIdStr = ____value[1]
        local effect = ____value[2]
        do
            if not hasItem(nil, unit, itemIdStr) then
                goto __continue8
            end
            if effect.type == "life_percent" then
                totalBonus = totalBonus + maxLife * effect.value
            elseif effect.type == "life_fixed" then
                totalBonus = totalBonus + effect.value
            end
        end
        ::__continue8::
    end
    return totalBonus
end
--- 计算装备提供的魔法恢复加成
-- 
-- @param unit 目标单位
-- @returns 魔法恢复加成值
function ____exports.calcItemManaRegenBonus(self, unit)
    local totalBonus = 0
    local maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
    for ____, ____value in ipairs(__TS__ObjectEntries(____exports.ITEM_REGEN_EFFECTS)) do
        local itemIdStr = ____value[1]
        local effect = ____value[2]
        do
            if not hasItem(nil, unit, itemIdStr) then
                goto __continue14
            end
            if effect.type == "mana_percent" then
                totalBonus = totalBonus + maxMana * effect.value
            elseif effect.type == "mana_fixed" then
                totalBonus = totalBonus + effect.value
            end
        end
        ::__continue14::
    end
    return totalBonus
end
return ____exports
