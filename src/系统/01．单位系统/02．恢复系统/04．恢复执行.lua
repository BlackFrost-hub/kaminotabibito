--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 恢复执行模块
-- 
-- 功能：周期性执行单位恢复
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("系统.01．单位系统.02．恢复系统.01．恢复计算")
local calcBaseLifeRegen = ____require_result_1.calcBaseLifeRegen
local calcBaseManaRegen = ____require_result_1.calcBaseManaRegen
local calcTotalLifeRegen = ____require_result_1.calcTotalLifeRegen
local calcTotalManaRegen = ____require_result_1.calcTotalManaRegen
local calcBossTotalLifeRegen = ____require_result_1.calcBossTotalLifeRegen
local getPercentLifeRegen = ____require_result_1.getPercentLifeRegen
local ____require_result_2 = require("系统.01．单位系统.02．恢复系统.02．装备恢复效果")
local calcItemLifeRegenBonus = ____require_result_2.calcItemLifeRegenBonus
local ____require_result_3 = require("系统.01．单位系统.02．恢复系统.03．单位恢复特性")
local getUnitLifeRegenMultiplier = ____require_result_3.getUnitLifeRegenMultiplier
local ____require_result_4 = require("系统.01．单位系统.02．恢复系统.00．恢复常量")
local REGEN_THRESHOLD = ____require_result_4.REGEN_THRESHOLD
local PERCENT_REGEN_THRESHOLD = ____require_result_4.PERCENT_REGEN_THRESHOLD
--- 执行单位生命恢复
local function applyLifeRegen(self, unit, regen)
    if regen <= 0 then
        return
    end
    local currentLife = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)
    local maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
    local actualRegen = math.min(regen, maxLife - currentLife)
    if actualRegen <= 0 then
        return
    end
    jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife + actualRegen)
end
--- 执行单位魔法恢复
local function applyManaRegen(self, unit, regen)
    if regen <= 0 then
        return
    end
    local currentMana = jass.GetUnitState(unit, jass.UNIT_STATE_MANA)
    local maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
    local actualRegen = math.min(regen, maxMana - currentMana)
    if actualRegen <= 0 then
        return
    end
    jass.SetUnitState(unit, jass.UNIT_STATE_MANA, currentMana + actualRegen)
end
--- 处理玩家英雄恢复
function ____exports.processPlayerHeroRegen(self, unit)
    local baseLifeRegen = calcBaseLifeRegen(nil, unit)
    local baseManaRegen = calcBaseManaRegen(nil, unit)
    local itemBonus = calcItemLifeRegenBonus(nil, unit)
    local unitMultiplier = getUnitLifeRegenMultiplier(nil, unit)
    local totalLifeRegen = calcTotalLifeRegen(
        nil,
        unit,
        baseLifeRegen,
        itemBonus,
        unitMultiplier
    )
    local totalManaRegen = calcTotalManaRegen(nil, unit, baseManaRegen)
    local player = jass.GetOwningPlayer(unit)
    if player ~= nil then
    end
    local percentLifeRegen = getPercentLifeRegen(nil, unit)
    if totalLifeRegen > REGEN_THRESHOLD or percentLifeRegen >= PERCENT_REGEN_THRESHOLD then
        applyLifeRegen(nil, unit, totalLifeRegen)
    end
    if totalManaRegen > REGEN_THRESHOLD then
        applyManaRegen(nil, unit, totalManaRegen)
    end
end
--- 处理Boss单位恢复
function ____exports.processBossRegen(self, unit)
    local totalLifeRegen = calcBossTotalLifeRegen(nil, unit)
    if totalLifeRegen > REGEN_THRESHOLD then
        applyLifeRegen(nil, unit, totalLifeRegen)
    end
end
--- 获取玩家英雄组
local function getPlayerHeroGroup(self)
    return YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
end
--- 获取动漫Boss单位组
local function getBossGroup(self)
    return YDUserDataGet(
        nil,
        "string",
        "动漫Boss",
        "单位组",
        "group"
    )
end
--- 每秒恢复处理主函数
function ____exports.onRegenTimer(self)
    local heroGroup = getPlayerHeroGroup(nil)
    if heroGroup ~= nil then
        jass.ForGroup(
            heroGroup,
            function()
                local unit = jass.GetEnumUnit()
                if unit ~= nil then
                    ____exports.processPlayerHeroRegen(nil, unit)
                end
            end
        )
    end
    local bossGroup = getBossGroup(nil)
    if bossGroup ~= nil then
        jass.ForGroup(
            bossGroup,
            function()
                local unit = jass.GetEnumUnit()
                if unit ~= nil then
                    ____exports.processBossRegen(nil, unit)
                end
            end
        )
    end
end
return ____exports
