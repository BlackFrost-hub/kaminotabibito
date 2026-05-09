local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local onAutoRegisterNeutralAggressive, initAutoRegister, jass, playerUnitEvent, aiUnitRegistry, unitCreatedTrigger
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.00．常量定义")
local AI_SKILL_SYSTEM_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.AI_SKILL_SYSTEM_ENABLED
local AI_CHECK_INTERVAL = ____00_FF0E_5E38_91CF_5B9A_4E49.AI_CHECK_INTERVAL
local AI_PLAYER_COUNT = ____00_FF0E_5E38_91CF_5B9A_4E49.AI_PLAYER_COUNT
local AI_PLAYER_NEUTRAL_AGGRESSIVE = ____00_FF0E_5E38_91CF_5B9A_4E49.AI_PLAYER_NEUTRAL_AGGRESSIVE
local TARGET_TYPE_NONE = ____00_FF0E_5E38_91CF_5B9A_4E49.TARGET_TYPE_NONE
local TARGET_TYPE_POINT = ____00_FF0E_5E38_91CF_5B9A_4E49.TARGET_TYPE_POINT
local TARGET_TYPE_UNIT = ____00_FF0E_5E38_91CF_5B9A_4E49.TARGET_TYPE_UNIT
local ____02_FF0E_5DE5_5177_51FD_6570 = require("系统.03．技能系统.06．AI自动使用技能.02．工具函数")
local getHandleId = ____02_FF0E_5DE5_5177_51FD_6570.getHandleId
local getGameTime = ____02_FF0E_5DE5_5177_51FD_6570.getGameTime
local getUnitMana = ____02_FF0E_5DE5_5177_51FD_6570.getUnitMana
local getUnitLevel = ____02_FF0E_5DE5_5177_51FD_6570.getUnitLevel
local getSkillCooldown = ____02_FF0E_5DE5_5177_51FD_6570.getSkillCooldown
local isValidUnit = ____02_FF0E_5DE5_5177_51FD_6570.isValidUnit
local isUnitDead = ____02_FF0E_5DE5_5177_51FD_6570.isUnitDead
function ____exports.registerAIUnit(unit)
    if not unit then
        return false
    end
    local handleId = getHandleId(nil, unit)
    if not handleId then
        return false
    end
    if not aiUnitRegistry:has(handleId) then
        aiUnitRegistry:set(
            handleId,
            {
                unit = unit,
                skills = __TS__New(Map)
            }
        )
    end
    return true
end
function ____exports.autoRegisterNeutralAggressive(unit)
    if not unit then
        return
    end
    local owner = jass.GetOwningPlayer(unit)
    local neutralAggressive = jass.Player(AI_PLAYER_NEUTRAL_AGGRESSIVE)
    if owner == neutralAggressive then
        local isHero = jass.IsUnitType(unit, jass.UNIT_TYPE_HERO)
        if not isHero then
            ____exports.registerAIUnit(unit)
        end
    end
end
function onAutoRegisterNeutralAggressive()
    ____exports.autoRegisterNeutralAggressive(jass.GetTriggerUnit())
end
function initAutoRegister()
    if not unitCreatedTrigger then
        unitCreatedTrigger = jass.CreateTrigger()
        local enterRegionEvent = jass.EVENT_PLAYER_UNIT_SUMMON
        do
            local i = 0
            while i < AI_PLAYER_COUNT do
                playerUnitEvent.registerPlayerUnitEventById(unitCreatedTrigger, i, enterRegionEvent)
                i = i + 1
            end
        end
        local neutralAggressive = jass.Player(AI_PLAYER_NEUTRAL_AGGRESSIVE)
        playerUnitEvent.registerPlayerUnitEvent(unitCreatedTrigger, neutralAggressive, enterRegionEvent)
        jass.TriggerAddAction(unitCreatedTrigger, onAutoRegisterNeutralAggressive)
    end
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local ____G_0 = _G
local addPeriodicCallback = ____G_0.addPeriodicCallback
aiUnitRegistry = __TS__New(Map)
local aiCheckRegistered = false
unitCreatedTrigger = nil
local function clampMinInt(value, minValue)
    local intValue = jass.R2I(value)
    return intValue < minValue and minValue or intValue
end
function ____exports.registerAISkill(unit, config)
    if not unit or not config.abilityId then
        return false
    end
    local handleId = getHandleId(nil, unit)
    if not handleId then
        return false
    end
    if not aiUnitRegistry:has(handleId) then
        aiUnitRegistry:set(
            handleId,
            {
                unit = unit,
                skills = __TS__New(Map)
            }
        )
    end
    aiUnitRegistry:get(handleId).skills:set(config.abilityId, {config = config, lastCastTime = 0})
    return true
end
function ____exports.registerAISkills(unit, configs)
    local count = 0
    for ____, config in ipairs(configs) do
        if ____exports.registerAISkill(unit, config) then
            count = count + 1
        end
    end
    return count
end
function ____exports.unregisterAISkill(unit, abilityId)
    if not unit then
        return false
    end
    local handleId = getHandleId(nil, unit)
    if not handleId or not aiUnitRegistry:has(handleId) then
        return false
    end
    local unitInfo = aiUnitRegistry:get(handleId)
    if abilityId == nil then
        aiUnitRegistry:delete(handleId)
        return true
    end
    if unitInfo.skills:has(abilityId) then
        unitInfo.skills:delete(abilityId)
        if unitInfo.skills.size == 0 then
            aiUnitRegistry:delete(handleId)
        end
        return true
    end
    return false
end
function ____exports.unregisterAIUnit(unit)
    if not unit then
        return false
    end
    local handleId = getHandleId(nil, unit)
    if not handleId or not aiUnitRegistry:has(handleId) then
        return false
    end
    aiUnitRegistry:delete(handleId)
    return true
end
local function canCastSkill(unit, skillInfo)
    local ____skillInfo_1 = skillInfo
    local config = ____skillInfo_1.config
    if not isValidUnit(nil, unit) or isUnitDead(nil, unit) then
        return false
    end
    if getUnitLevel(nil, unit) < config.minLevel then
        return false
    end
    if getUnitMana(nil, unit) < (config.manaCost or 0) then
        return false
    end
    local currentTime = getGameTime(nil)
    if currentTime - skillInfo.lastCastTime < (config.cooldown or 0) then
        return false
    end
    if getSkillCooldown(nil, unit, config.abilityId) > 0 then
        return false
    end
    return true
end
local function findBestTarget(unit, skillInfo)
    local ____skillInfo_2 = skillInfo
    local config = ____skillInfo_2.config
    if config.targetType == TARGET_TYPE_NONE then
        return true
    end
    if config.targetType == TARGET_TYPE_POINT and config.pointCondition then
        return config:pointCondition(unit)
    end
    return nil
end
local function castSkill(unit, skillInfo, target)
    local ____skillInfo_3 = skillInfo
    local config = ____skillInfo_3.config
    do
        local function ____catch(_e)
            return true, false
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            if config.targetType == TARGET_TYPE_NONE then
                if config.orderId ~= 0 then
                    jass.IssueImmediateOrderById(unit, config.orderId)
                end
            elseif config.targetType == TARGET_TYPE_POINT then
                local point = target
                if point ~= nil and point ~= nil and config.orderId ~= 0 then
                    jass.IssuePointOrderById(unit, config.orderId, point.x, point.y)
                end
            elseif config.targetType == TARGET_TYPE_UNIT then
                if target ~= nil and target ~= nil and isValidUnit(nil, target) and config.orderId ~= 0 then
                    jass.IssueTargetOrderById(unit, config.orderId, target)
                end
            end
            skillInfo.lastCastTime = getGameTime(nil)
            return true, true
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
local function updateAIUnit(unitInfo)
    local ____unitInfo_4 = unitInfo
    local unit = ____unitInfo_4.unit
    local skills = ____unitInfo_4.skills
    if not isValidUnit(nil, unit) or isUnitDead(nil, unit) then
        return
    end
    local sortedSkills = __TS__ArraySort(
        __TS__ArrayFrom(skills:values()),
        function(____, a, b) return b.config.priority - a.config.priority end
    )
    for ____, skillInfo in ipairs(sortedSkills) do
        do
            if not canCastSkill(unit, skillInfo) then
                goto __continue45
            end
            local target = findBestTarget(unit, skillInfo)
            if target then
                castSkill(unit, skillInfo, target)
                break
            end
        end
        ::__continue45::
    end
end
local function onAICheck()
    for ____, unitInfo in __TS__Iterator(aiUnitRegistry:values()) do
        updateAIUnit(unitInfo)
    end
end
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local function onAIDeath(dyingUnit)
    ____exports.unregisterAIUnit(dyingUnit)
end
function ____exports.initAISkillSystem()
    if not AI_SKILL_SYSTEM_ENABLED then
        return
    end
    if not aiCheckRegistered then
        aiCheckRegistered = true
        addPeriodicCallback(
            clampMinInt(AI_CHECK_INTERVAL * 1000, 1),
            onAICheck
        )
    end
    registerDeathListener(onAIDeath)
    initAutoRegister()
end
function ____exports.getAIUnitCount()
    return aiUnitRegistry.size
end
function ____exports.getAISkillCount(unit)
    if not unit then
        return 0
    end
    local handleId = getHandleId(nil, unit)
    if not handleId or not aiUnitRegistry:has(handleId) then
        return 0
    end
    return aiUnitRegistry:get(handleId).skills.size
end
function ____exports.isSystemEnabled()
    return AI_SKILL_SYSTEM_ENABLED
end
return ____exports
