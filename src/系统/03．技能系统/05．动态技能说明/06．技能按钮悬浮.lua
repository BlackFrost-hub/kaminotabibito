local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringSlice = ____lualib.__TS__StringSlice
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWESetUnitAbilityDataString = ____require_result_0.YDWESetUnitAbilityDataString
local getObjectProperty = ____require_result_0.getObjectProperty
local ObjectType = ____require_result_0.ObjectType
local ABILITY_DATA_UBERTIP = ____require_result_0.ABILITY_DATA_UBERTIP
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local getSoleSelectedUnitForPlayer = ____require_result_1.getSoleSelectedUnitForPlayer
local commandBarAbility = require("系统.03．技能系统.05．动态技能说明.07．命令卡技能槽位")
local heroSkillRecord = require("系统.03．技能系统.05．动态技能说明.05．英雄技能记录")
local SLOT_ROW = 2
local UPDATE_INTERVAL_MS = 1000
local SLOT_KEYS = {"Q技能", "W技能", "E技能", "R技能"}
local SLOT_COLUMNS = {0, 1, 2, 3}
local periodicInstalled = false
local function replaceAllText(text, search, replacement)
    if search == "" then
        return text
    end
    return table.concat(
        __TS__StringSplit(text, search),
        replacement or ","
    )
end
local function getSelectedRegisteredHeroForLocalPlayer()
    local localPlayer = jass.GetLocalPlayer()
    if not localPlayer or localPlayer == 0 then
        return nil
    end
    local playerId = jass.GetPlayerId(localPlayer)
    local selectedUnit = getSoleSelectedUnitForPlayer(nil, playerId)
    if not selectedUnit or selectedUnit == 0 then
        return nil
    end
    if jass.GetOwningPlayer(selectedUnit) ~= localPlayer then
        return nil
    end
    if jass.IsUnitType(selectedUnit, jass.UNIT_TYPE_HERO) ~= true then
        return nil
    end
    return selectedUnit
end
local function resolveAbilityIdBySlot(column)
    return commandBarAbility["读取命令卡按钮能力Id"](column, SLOT_ROW)
end
local function extractCurrentLevelSegment(template, level)
    if not template then
        return ""
    end
    if level <= 1 then
        local nextMarker = (string.find(template, "等级 2", nil, true) or 0) - 1
        return nextMarker >= 0 and __TS__StringTrim(__TS__StringSlice(template, 0, nextMarker)) or __TS__StringTrim(template)
    end
    local currentMarker = "等级 " .. tostring(level)
    local currentStart = (string.find(template, currentMarker, nil, true) or 0) - 1
    if currentStart < 0 then
        return __TS__StringTrim(template)
    end
    local nextLevel = level + 1
    local nextStart = -1
    while nextLevel <= 20 and nextStart < 0 do
        nextStart = (string.find(
            template,
            "等级 " .. tostring(nextLevel),
            math.max(currentStart + #currentMarker + 1, 1),
            true
        ) or 0) - 1
        nextLevel = nextLevel + 1
    end
    return __TS__StringTrim(nextStart >= 0 and __TS__StringSlice(template, currentStart, nextStart) or __TS__StringSlice(template, currentStart))
end
local function renderTooltipText(hero, rawTemplate, level)
    local result = extractCurrentLevelSegment(rawTemplate, level)
    if result == "" then
        return ""
    end
    local intelligence = jass.GetHeroInt(hero, true) or 0
    local intTimes3 = tostring(intelligence * 3)
    local intTimes3AndLevel = tostring(intelligence * 3 * level)
    result = replaceAllText(result, "智力×3×技能等级", intTimes3AndLevel)
    result = replaceAllText(result, "智力x3x技能等级", intTimes3AndLevel)
    result = replaceAllText(result, "智力*3*技能等级", intTimes3AndLevel)
    result = replaceAllText(result, "智力×3", intTimes3)
    result = replaceAllText(result, "智力x3", intTimes3)
    result = replaceAllText(result, "智力*3", intTimes3)
    result = replaceAllText(
        result,
        "技能等级",
        tostring(level)
    )
    return result
end
local function getHeroSlotAbility(hero, slotKey)
    if not hero or hero == 0 then
        return 0
    end
    if slotKey == SLOT_KEYS[1] then
        return heroSkillRecord.getHeroRecordedSkill(hero, "Q")
    end
    if slotKey == SLOT_KEYS[2] then
        return heroSkillRecord.getHeroRecordedSkill(hero, "W")
    end
    if slotKey == SLOT_KEYS[3] then
        return heroSkillRecord.getHeroRecordedSkill(hero, "E")
    end
    if slotKey == SLOT_KEYS[4] then
        return heroSkillRecord.getHeroRecordedSkill(hero, "R")
    end
    return 0
end
local function refreshOneSlot(hero, slotKey, column)
    if not hero or hero == 0 then
        return
    end
    local abilityId = resolveAbilityIdBySlot(column)
    if abilityId == 0 then
        abilityId = getHeroSlotAbility(hero, slotKey)
    end
    if abilityId == 0 then
        return
    end
    local level = jass.GetUnitAbilityLevel(hero, abilityId) or 0
    if level <= 0 then
        return
    end
    local rawTemplate = getObjectProperty(nil, ObjectType.ABILITY, abilityId, "Researchubertip") or ""
    if rawTemplate == "" then
        return
    end
    local renderedText = renderTooltipText(hero, rawTemplate, level)
    if renderedText == "" then
        return
    end
    YDWESetUnitAbilityDataString(
        nil,
        hero,
        abilityId,
        level,
        ABILITY_DATA_UBERTIP,
        renderedText
    )
end
local function refreshHeroQWER(hero)
    refreshOneSlot(hero, SLOT_KEYS[1], SLOT_COLUMNS[1])
    refreshOneSlot(hero, SLOT_KEYS[2], SLOT_COLUMNS[2])
    refreshOneSlot(hero, SLOT_KEYS[3], SLOT_COLUMNS[3])
    refreshOneSlot(hero, SLOT_KEYS[4], SLOT_COLUMNS[4])
end
local function onPeriodicUpdate()
    local hero = getSelectedRegisteredHeroForLocalPlayer()
    if not hero or hero == 0 then
        return
    end
    refreshHeroQWER(hero)
end
function ____exports.initSkillButtonHover(self)
    if periodicInstalled then
        return
    end
    periodicInstalled = true
    local ____G_2 = _G
    local addPeriodicCallback = ____G_2.addPeriodicCallback
    addPeriodicCallback(UPDATE_INTERVAL_MS, onPeriodicUpdate)
end
function ____exports.onPlayerHeroRegistered(self, whichPlayer, whichHero)
    if not whichPlayer or whichPlayer == 0 or not whichHero or whichHero == 0 then
        return
    end
end
return ____exports
