--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 恢复计算模块
-- 
-- 功能：计算单位的基础恢复、百分比恢复、总恢复
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("系统.01．单位系统.02．恢复系统.00．恢复常量")
local STRENGTH_TO_LIFE_REGEN = ____require_result_1.STRENGTH_TO_LIFE_REGEN
local INTELLIGENCE_TO_MANA_REGEN = ____require_result_1.INTELLIGENCE_TO_MANA_REGEN
local LIFE_REGEN_PERCENT_CAP = ____require_result_1.LIFE_REGEN_PERCENT_CAP
local MANA_REGEN_PERCENT_CAP = ____require_result_1.MANA_REGEN_PERCENT_CAP
--- 计算基础生命恢复（力量 × 0.32）
function ____exports.calcBaseLifeRegen(self, unit)
    local strength = jass.GetHeroStr(unit, true)
    return strength * STRENGTH_TO_LIFE_REGEN
end
--- 计算基础魔法恢复（智力 × 0.15）
function ____exports.calcBaseManaRegen(self, unit)
    local intelligence = jass.GetHeroInt(unit, true)
    return intelligence * INTELLIGENCE_TO_MANA_REGEN
end
--- 读取单位/玩家属性
local function getAttr(self, unit, attrName)
    local unitValue = YDUserDataGet(
        nil,
        "unit",
        unit,
        attrName,
        "real"
    )
    if unitValue ~= 0 then
        return unitValue
    end
    local player = jass.GetOwningPlayer(unit)
    if player ~= nil then
        return YDUserDataGet(
            nil,
            "player",
            player,
            attrName,
            "real"
        )
    end
    return 0
end
--- 读取玩家属性
local function getPlayerAttr(self, unit, attrName)
    local player = jass.GetOwningPlayer(unit)
    if player == nil then
        return 0
    end
    return YDUserDataGet(
        nil,
        "player",
        player,
        attrName,
        "real"
    )
end
--- 获取百分比生命恢复（应用上限）
function ____exports.getPercentLifeRegen(self, unit)
    local value = getPlayerAttr(nil, unit, "百分比生命回复")
    return math.min(value, LIFE_REGEN_PERCENT_CAP)
end
--- 获取百分比魔法恢复（应用上限）
function ____exports.getPercentManaRegen(self, unit)
    local value = getPlayerAttr(nil, unit, "百分比魔法回复")
    return math.min(value, MANA_REGEN_PERCENT_CAP)
end
--- 计算总生命恢复
-- 
-- 公式：(1 + 增幅) × (百分比恢复 + 固定恢复 + 基础恢复 + 装备加成 + 单位特性)
function ____exports.calcTotalLifeRegen(self, unit, baseRegen, itemBonus, unitMultiplier)
    local fixedRegen = getAttr(nil, unit, "生命恢复")
    local percentRegen = ____exports.getPercentLifeRegen(nil, unit)
    local maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
    local percentRegenValue = maxLife * percentRegen
    local amplify = getPlayerAttr(nil, unit, "生命恢复属性增幅")
    local totalBase = (baseRegen + itemBonus) * unitMultiplier + fixedRegen
    local total = (1 + amplify) * (totalBase + percentRegenValue)
    return total
end
--- 计算总魔法恢复
-- 
-- 公式：百分比恢复 + 固定恢复 + 基础恢复
function ____exports.calcTotalManaRegen(self, unit, baseRegen)
    local fixedRegen = getAttr(nil, unit, "魔法恢复")
    local percentRegen = ____exports.getPercentManaRegen(nil, unit)
    local maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
    local percentRegenValue = maxMana * percentRegen
    return baseRegen + fixedRegen + percentRegenValue
end
--- 计算Boss总生命恢复（无百分比恢复）
function ____exports.calcBossTotalLifeRegen(self, unit)
    local fixedRegen = getAttr(nil, unit, "生命恢复")
    local amplify = getAttr(nil, unit, "生命恢复属性增幅")
    return (1 + amplify) * fixedRegen
end
return ____exports
