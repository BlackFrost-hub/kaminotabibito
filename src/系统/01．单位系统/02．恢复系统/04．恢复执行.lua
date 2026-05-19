--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 恢复执行模块
-- 
-- 功能：周期性执行单位恢复
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local YDUserDataSet = ____require_result_0.YDUserDataSet
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local forEachUnitInGroup = ____require_result_1.forEachUnitInGroup
local ____require_result_2 = require("系统.01．单位系统.02．恢复系统.01．恢复计算")
local calcBaseLifeRegen = ____require_result_2.calcBaseLifeRegen
local calcBaseManaRegen = ____require_result_2.calcBaseManaRegen
local calcTotalLifeRegen = ____require_result_2.calcTotalLifeRegen
local calcTotalManaRegen = ____require_result_2.calcTotalManaRegen
local calcBossTotalLifeRegen = ____require_result_2.calcBossTotalLifeRegen
local getPercentLifeRegen = ____require_result_2.getPercentLifeRegen
local getPercentManaRegen = ____require_result_2.getPercentManaRegen
local ____require_result_3 = require("系统.01．单位系统.02．恢复系统.02．装备恢复效果")
local calcItemLifeRegenBonus = ____require_result_3.calcItemLifeRegenBonus
local ____require_result_4 = require("系统.01．单位系统.02．恢复系统.03．单位恢复特性")
local getUnitLifeRegenMultiplier = ____require_result_4.getUnitLifeRegenMultiplier
local ____require_result_5 = require("系统.01．单位系统.02．恢复系统.00．恢复常量")
local REGEN_THRESHOLD = ____require_result_5.REGEN_THRESHOLD
local PERCENT_REGEN_THRESHOLD = ____require_result_5.PERCENT_REGEN_THRESHOLD
--- 执行单位生命恢复
local function applyLifeRegen(self, unit, regen)
    if regen <= 0 then
        return
    end
    local currentLife = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)
    local maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
    local lifeGap = maxLife - currentLife
    local actualRegen = regen < lifeGap and regen or lifeGap
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
    local manaGap = maxMana - currentMana
    local actualRegen = regen < manaGap and regen or manaGap
    if actualRegen <= 0 then
        return
    end
    jass.SetUnitState(unit, jass.UNIT_STATE_MANA, currentMana + actualRegen)
end
--- 处理玩家英雄恢复
-- 与 JASS 源代码逻辑完全一致
function ____exports.processPlayerHeroRegen(self, unit)
    local player = jass.GetOwningPlayer(unit)
    if player == nil then
        return
    end
    local baseLifeRegen = calcBaseLifeRegen(nil, unit)
    local itemBonus = calcItemLifeRegenBonus(nil, unit)
    baseLifeRegen = baseLifeRegen + itemBonus
    local unitMultiplier = getUnitLifeRegenMultiplier(nil, unit)
    baseLifeRegen = baseLifeRegen * unitMultiplier
    local equipBonus = YDUserDataGet(
        nil,
        "player",
        player,
        "生命恢复",
        "real"
    ) or 0
    local totalFixedLifeRegen = equipBonus + baseLifeRegen
    local percentLifeRegen = getPercentLifeRegen(nil, unit)
    local lifeRegenAmplify = YDUserDataGet(
        nil,
        "player",
        player,
        "生命恢复属性增幅",
        "real"
    ) or 0
    local maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
    local totalLifeRegen = (1 + lifeRegenAmplify) * (maxLife * percentLifeRegen + totalFixedLifeRegen)
    YDUserDataSet(
        nil,
        "player",
        player,
        "总生命恢复",
        "real",
        totalLifeRegen
    )
    local percentLifeRegenForDisplay = getPercentLifeRegen(nil, unit)
    local baseManaRegen = calcBaseManaRegen(nil, unit)
    local equipManaBonus = YDUserDataGet(
        nil,
        "player",
        player,
        "魔法恢复",
        "real"
    ) or 0
    local totalFixedManaRegen = equipManaBonus + baseManaRegen
    local percentManaRegen = getPercentManaRegen(nil, unit)
    local maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA)
    local totalManaRegen = 1 * (maxMana * percentManaRegen + totalFixedManaRegen)
    YDUserDataSet(
        nil,
        "player",
        player,
        "总生命恢复",
        "real",
        totalLifeRegen
    )
    YDUserDataSet(
        nil,
        "player",
        player,
        "总魔法恢复",
        "real",
        totalManaRegen
    )
    YDUserDataSet(
        nil,
        "player",
        player,
        "生命恢复%",
        "real",
        percentLifeRegenForDisplay
    )
    YDUserDataSet(
        nil,
        "player",
        player,
        "魔法恢复%",
        "real",
        percentManaRegen
    )
    if totalLifeRegen > REGEN_THRESHOLD or percentLifeRegen >= PERCENT_REGEN_THRESHOLD then
        applyLifeRegen(nil, unit, totalLifeRegen)
    end
    if totalManaRegen > REGEN_THRESHOLD or percentManaRegen >= PERCENT_REGEN_THRESHOLD then
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
        forEachUnitInGroup(
            nil,
            heroGroup,
            function(____, unit)
                if unit ~= nil then
                    ____exports.processPlayerHeroRegen(nil, unit)
                end
            end
        )
    end
    local bossGroup = getBossGroup(nil)
    if bossGroup ~= nil then
        forEachUnitInGroup(
            nil,
            bossGroup,
            function(____, unit)
                if unit ~= nil then
                    ____exports.processBossRegen(nil, unit)
                end
            end
        )
    end
end
--- 是否已注册到中心计时器
local _registered = false
--- 注册恢复系统到中心计时器
local function registerToCenterTimer(self)
    if _registered then
        return
    end
    _registered = true
    local ____G_6 = _G
    local onSecond = ____G_6.onSecond
    onSecond(____exports.onRegenTimer)
end
registerToCenterTimer(nil)
return ____exports
