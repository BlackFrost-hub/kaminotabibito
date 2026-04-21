local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__StringSlice = ____lualib.__TS__StringSlice
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local evaluateFormula, processTemplate, updateSkillTip, EXGetUnitAbility, EXSetAbilityDataString, attributeGetters
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.05．动态技能说明.00．常量定义")
local DYNAMIC_SKILL_TIP_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.DYNAMIC_SKILL_TIP_ENABLED
local EVENT_ID_HERO_LEVEL = ____00_FF0E_5E38_91CF_5B9A_4E49.EVENT_ID_HERO_LEVEL
local PLAYER_COUNT = ____00_FF0E_5E38_91CF_5B9A_4E49.PLAYER_COUNT
local UNIT_STATE_ATTACK1_BASE = ____00_FF0E_5E38_91CF_5B9A_4E49.UNIT_STATE_ATTACK1_BASE
local UNIT_STATE_ATTACK1_BONUS = ____00_FF0E_5E38_91CF_5B9A_4E49.UNIT_STATE_ATTACK1_BONUS
local UNIT_STATE_ARMOR = ____00_FF0E_5E38_91CF_5B9A_4E49.UNIT_STATE_ARMOR
local BRACKET_LEFT_EN = ____00_FF0E_5E38_91CF_5B9A_4E49.BRACKET_LEFT_EN
local BRACKET_RIGHT_EN = ____00_FF0E_5E38_91CF_5B9A_4E49.BRACKET_RIGHT_EN
local BRACKET_LEFT_CN = ____00_FF0E_5E38_91CF_5B9A_4E49.BRACKET_LEFT_CN
local BRACKET_RIGHT_CN = ____00_FF0E_5E38_91CF_5B9A_4E49.BRACKET_RIGHT_CN
local ATTR_SKILL_LEVEL = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_SKILL_LEVEL
local ATTR_STR = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_STR
local ATTR_AGI = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_AGI
local ATTR_INT = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_INT
local ATTR_STR_WHITE = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_STR_WHITE
local ATTR_AGI_WHITE = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_AGI_WHITE
local ATTR_INT_WHITE = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_INT_WHITE
local ATTR_HP = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_HP
local ATTR_HP_MAX = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_HP_MAX
local ATTR_MP = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_MP
local ATTR_MP_MAX = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_MP_MAX
local ATTR_ATTACK = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_ATTACK
local ATTR_ARMOR = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_ARMOR
local ATTR_MOVE_SPEED = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_MOVE_SPEED
local ATTR_LEVEL = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_LEVEL
local ATTR_HERO_LEVEL = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_HERO_LEVEL
local ATTR_XP = ____00_FF0E_5E38_91CF_5B9A_4E49.ATTR_XP
local ____02_FF0E_516C_5F0F_89E3_6790_5668 = require("系统.03．技能系统.05．动态技能说明.02．公式解析器")
local safeEval = ____02_FF0E_516C_5F0F_89E3_6790_5668.safeEval
local replaceAll = ____02_FF0E_516C_5F0F_89E3_6790_5668.replaceAll
local indexOfChar = ____02_FF0E_516C_5F0F_89E3_6790_5668.indexOfChar
local formatNumber = ____02_FF0E_516C_5F0F_89E3_6790_5668.formatNumber
function evaluateFormula(self, formula, unit, skillLevel)
    if not formula then
        return 0
    end
    local expr = __TS__StringTrim(formula)
    if expr == "" then
        return 0
    end
    expr = replaceAll(
        nil,
        expr,
        ATTR_SKILL_LEVEL,
        tostring(skillLevel)
    )
    local sortedAttrs = __TS__ArraySort(
        __TS__ObjectKeys(attributeGetters),
        function(____, a, b) return #b - #a end
    )
    for ____, attrName in ipairs(sortedAttrs) do
        local getter = attributeGetters[attrName]
        local value = getter(nil, unit)
        expr = replaceAll(
            nil,
            expr,
            attrName,
            tostring(value)
        )
    end
    do
        local function ____catch(_e)
            return true, 0
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            local result = safeEval(nil, expr)
            return true, __TS__NumberIsFinite(__TS__Number(result)) and result or 0
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
function processTemplate(self, template, unit, skillLevel)
    local result = ""
    local i = 0
    while i < #template do
        do
            if __TS__StringAccess(template, i) == BRACKET_LEFT_EN or __TS__StringAccess(template, i) == BRACKET_LEFT_CN then
                local isOpenBracket = __TS__StringAccess(template, i) == BRACKET_LEFT_EN
                local closeBracket = isOpenBracket and BRACKET_RIGHT_EN or BRACKET_RIGHT_CN
                local endIdx = indexOfChar(nil, template, closeBracket, i + 1)
                if endIdx > i + 1 then
                    local formula = __TS__StringSlice(template, i + 1, endIdx)
                    local value = evaluateFormula(nil, formula, unit, skillLevel)
                    result = result .. formatNumber(nil, value)
                    i = endIdx + 1
                    goto __continue27
                end
            end
            result = result .. __TS__StringAccess(template, i)
            i = i + 1
        end
        ::__continue27::
    end
    return result
end
function updateSkillTip(self, skillInfo)
    local ____skillInfo_2 = skillInfo
    local unit = ____skillInfo_2.unit
    local abilityId = ____skillInfo_2.abilityId
    local level = ____skillInfo_2.level
    local template = ____skillInfo_2.template
    local tipType = ____skillInfo_2.tipType
    local abil = EXGetUnitAbility(nil, unit, abilityId)
    if not abil then
        return
    end
    local tipText = processTemplate(nil, template, unit, level)
    EXSetAbilityDataString(
        nil,
        abil,
        level,
        tipType,
        tipText
    )
end
--- 动态技能说明系统 - 核心功能
-- 
-- 功能：注册动态技能说明、公式解析、自动刷新
-- 后续接手者：开关 DYNAMIC_SKILL_TIP_ENABLED 在常量文件
local jass = require("jass.common")
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
EXGetUnitAbility = ____require_result_0.EXGetUnitAbility
EXSetAbilityDataString = ____require_result_0.EXSetAbilityDataString
local ABILITY_DATA_TIP = ____require_result_0.ABILITY_DATA_TIP
local ABILITY_DATA_UBERTIP = ____require_result_0.ABILITY_DATA_UBERTIP
____exports.ABILITY_DATA_TIP = ABILITY_DATA_TIP
____exports.ABILITY_DATA_UBERTIP = ABILITY_DATA_UBERTIP
attributeGetters = {
    [ATTR_STR] = function(____, u) return jass.GetHeroStr(u, true) or 0 end,
    [ATTR_AGI] = function(____, u) return jass.GetHeroAgi(u, true) or 0 end,
    [ATTR_INT] = function(____, u) return jass.GetHeroInt(u, true) or 0 end,
    [ATTR_STR_WHITE] = function(____, u) return jass.GetHeroStr(u, false) or 0 end,
    [ATTR_AGI_WHITE] = function(____, u) return jass.GetHeroAgi(u, false) or 0 end,
    [ATTR_INT_WHITE] = function(____, u) return jass.GetHeroInt(u, false) or 0 end,
    [ATTR_HP] = function(____, u) return jass.GetUnitState(u, jass.UNIT_STATE_LIFE) or 0 end,
    [ATTR_HP_MAX] = function(____, u) return jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) or 0 end,
    [ATTR_MP] = function(____, u) return jass.GetUnitState(u, jass.UNIT_STATE_MANA) or 0 end,
    [ATTR_MP_MAX] = function(____, u) return jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) or 0 end,
    [ATTR_ATTACK] = function(____, u) return (jass.GetUnitState(
        u,
        jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE)
    ) or 0) + (jass.GetUnitState(
        u,
        jass.ConvertUnitState(UNIT_STATE_ATTACK1_BONUS)
    ) or 0) end,
    [ATTR_ARMOR] = function(____, u) return jass.GetUnitState(
        u,
        jass.ConvertUnitState(UNIT_STATE_ARMOR)
    ) or 0 end,
    [ATTR_MOVE_SPEED] = function(____, u) return jass.GetUnitMoveSpeed(u) or 0 end,
    [ATTR_LEVEL] = function(____, u) return jass.GetHeroLevel(u) or 0 end,
    [ATTR_HERO_LEVEL] = function(____, u) return jass.GetHeroLevel(u) or 0 end,
    [ATTR_XP] = function(____, u) return jass.GetHeroXP(u) or 0 end
}
local skillRegistry = __TS__New(Map)
local unitHandleMap = __TS__New(Map)
function ____exports.registerDynamicSkillTip(self, unit, abilityId, template, level, tipType)
    if level == nil then
        level = 1
    end
    if tipType == nil then
        tipType = ABILITY_DATA_TIP
    end
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return false
    end
    if not unit or not abilityId or not template then
        return false
    end
    local handleId = jass.GetHandleId(unit)
    if not handleId then
        return false
    end
    local abil = EXGetUnitAbility(nil, unit, abilityId)
    if not abil then
        return false
    end
    local skillInfo = {
        unit = unit,
        abilityId = abilityId,
        level = level,
        template = template,
        tipType = tipType
    }
    if not skillRegistry:has(handleId) then
        skillRegistry:set(
            handleId,
            __TS__New(Map)
        )
        unitHandleMap:set(handleId, unit)
    end
    local unitSkills = skillRegistry:get(handleId)
    if not unitSkills:has(abilityId) then
        unitSkills:set(abilityId, {})
    end
    local ____temp_1 = unitSkills:get(abilityId)
    ____temp_1[#____temp_1 + 1] = skillInfo
    updateSkillTip(nil, skillInfo)
    return true
end
function ____exports.unregisterDynamicSkillTip(self, unit, abilityId)
    if not unit then
        return false
    end
    local handleId = jass.GetHandleId(unit)
    if not handleId or not skillRegistry:has(handleId) then
        return false
    end
    local unitSkills = skillRegistry:get(handleId)
    if abilityId == nil then
        skillRegistry:delete(handleId)
        unitHandleMap:delete(handleId)
        return true
    end
    if unitSkills:has(abilityId) then
        unitSkills:delete(abilityId)
        if unitSkills.size == 0 then
            skillRegistry:delete(handleId)
            unitHandleMap:delete(handleId)
        end
        return true
    end
    return false
end
function ____exports.refreshUnitSkillTips(self, unit)
    if not unit then
        return
    end
    local handleId = jass.GetHandleId(unit)
    if not handleId or not skillRegistry:has(handleId) then
        return
    end
    local unitSkills = skillRegistry:get(handleId)
    for ____, skillList in __TS__Iterator(unitSkills:values()) do
        for ____, skillInfo in ipairs(skillList) do
            updateSkillTip(nil, skillInfo)
        end
    end
end
function ____exports.refreshAllSkillTips(self)
    for ____, ____value in __TS__Iterator(skillRegistry) do
        local handleId = ____value[1]
        local unitSkills = ____value[2]
        do
            local unit = unitHandleMap:get(handleId)
            if not unit then
                goto __continue53
            end
            for ____, skillList in __TS__Iterator(unitSkills:values()) do
                for ____, skillInfo in ipairs(skillList) do
                    updateSkillTip(nil, skillInfo)
                end
            end
        end
        ::__continue53::
    end
end
function ____exports.registerSkillTip(self, unit, abilityId, template, level)
    if level == nil then
        level = 1
    end
    return ____exports.registerDynamicSkillTip(
        nil,
        unit,
        abilityId,
        template,
        level,
        ABILITY_DATA_TIP
    )
end
function ____exports.registerSkillUbertip(self, unit, abilityId, template, level)
    if level == nil then
        level = 1
    end
    return ____exports.registerDynamicSkillTip(
        nil,
        unit,
        abilityId,
        template,
        level,
        ABILITY_DATA_UBERTIP
    )
end
function ____exports.registerSkillTips(self, unit, abilityId, tipTemplate, ubertipTemplate, level)
    if level == nil then
        level = 1
    end
    local success1 = ____exports.registerSkillTip(
        nil,
        unit,
        abilityId,
        tipTemplate,
        level
    )
    local success2 = ____exports.registerSkillUbertip(
        nil,
        unit,
        abilityId,
        ubertipTemplate,
        level
    )
    return success1 or success2
end
local levelUpTrigger = nil
local ____require_result_3 = require("系统.01．单位系统.03．单位死亡事件.01．核心功能")
local registerDeathListener = ____require_result_3.registerDeathListener
function ____exports.initDynamicSkillTipSystem(self)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    if not levelUpTrigger then
        levelUpTrigger = jass.CreateTrigger()
        local ____jass_EVENT_PLAYER_HERO_LEVEL_4 = jass.EVENT_PLAYER_HERO_LEVEL
        if ____jass_EVENT_PLAYER_HERO_LEVEL_4 == nil then
            ____jass_EVENT_PLAYER_HERO_LEVEL_4 = EVENT_ID_HERO_LEVEL
        end
        local levelEventId = ____jass_EVENT_PLAYER_HERO_LEVEL_4
        do
            local i = 0
            while i < PLAYER_COUNT do
                playerUnitEvent.registerPlayerUnitEventById(levelUpTrigger, i, levelEventId)
                i = i + 1
            end
        end
        jass.TriggerAddAction(
            levelUpTrigger,
            function()
                local unit = jass.GetTriggerUnit()
                ____exports.refreshUnitSkillTips(nil, unit)
            end
        )
    end
    registerDeathListener(
        nil,
        function(____, dyingUnit)
            ____exports.unregisterDynamicSkillTip(nil, dyingUnit)
        end
    )
end
function ____exports.registerAttributeGetter(self, attrName, getter)
    attributeGetters[attrName] = getter
end
function ____exports.unregisterAttributeGetter(self, attrName)
    if rawget(attributeGetters, attrName) ~= nil then
        __TS__Delete(attributeGetters, attrName)
        return true
    end
    return false
end
function ____exports.getSupportedAttributes(self)
    return __TS__ObjectKeys(attributeGetters)
end
function ____exports.getRegisteredSkillCount(self, unit)
    if not unit then
        return 0
    end
    local handleId = jass.GetHandleId(unit)
    if not handleId or not skillRegistry:has(handleId) then
        return 0
    end
    local unitSkills = skillRegistry:get(handleId)
    local count = 0
    for ____, skillList in __TS__Iterator(unitSkills:values()) do
        count = count + #skillList
    end
    return count
end
function ____exports.getTotalRegisteredCount(self)
    local count = 0
    for ____, unitSkills in __TS__Iterator(skillRegistry:values()) do
        for ____, skillList in __TS__Iterator(unitSkills:values()) do
            count = count + #skillList
        end
    end
    return count
end
return ____exports
