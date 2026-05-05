local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__StringSlice = ____lualib.__TS__StringSlice
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local normalizeFormulaTemplate, denormalizeFormulaTemplate, evaluateFormula, processTemplate, updateSkillTip, matchFormulaToken, isInlineFormulaChar, hasFormulaOperatorOrDigit, processInlineFormulas, jass, EXGetUnitAbility, FORMULA_TOKEN_SKILL_LEVEL, formulaAliases, aliasedAttributeGetters, formulaTokenNames
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.05．动态技能说明.00．常量定义")
local DYNAMIC_SKILL_TIP_ENABLED = ____00_FF0E_5E38_91CF_5B9A_4E49.DYNAMIC_SKILL_TIP_ENABLED
local UNIT_STATE_ATTACK1_BASE = ____00_FF0E_5E38_91CF_5B9A_4E49.UNIT_STATE_ATTACK1_BASE
local UNIT_STATE_ATTACK1_BONUS = ____00_FF0E_5E38_91CF_5B9A_4E49.UNIT_STATE_ATTACK1_BONUS
local UNIT_STATE_ARMOR = ____00_FF0E_5E38_91CF_5B9A_4E49.UNIT_STATE_ARMOR
local OPERATOR_MULTIPLY_CN = ____00_FF0E_5E38_91CF_5B9A_4E49.OPERATOR_MULTIPLY_CN
local OPERATOR_DIVIDE_CN = ____00_FF0E_5E38_91CF_5B9A_4E49.OPERATOR_DIVIDE_CN
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
local isDigit = ____02_FF0E_516C_5F0F_89E3_6790_5668.isDigit
function normalizeFormulaTemplate(self, template)
    local result = template
    for ____, alias in ipairs(formulaAliases) do
        result = replaceAll(nil, result, alias.source, alias.token)
    end
    return result
end
function denormalizeFormulaTemplate(self, template)
    local result = template
    for ____, alias in ipairs(formulaAliases) do
        result = replaceAll(nil, result, alias.token, alias.source)
    end
    return result
end
function evaluateFormula(self, formula, unit, skillLevel)
    if not formula then
        return 0
    end
    local expr = __TS__StringTrim(normalizeFormulaTemplate(nil, formula))
    if expr == "" then
        return 0
    end
    expr = replaceAll(
        nil,
        expr,
        FORMULA_TOKEN_SKILL_LEVEL,
        tostring(skillLevel)
    )
    local sortedAttrs = __TS__ArraySort(
        __TS__ObjectKeys(aliasedAttributeGetters),
        function(____, a, b) return #b - #a end
    )
    for ____, attrName in ipairs(sortedAttrs) do
        local getter = aliasedAttributeGetters[attrName]
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
    template = normalizeFormulaTemplate(nil, template)
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
                    goto __continue34
                end
            end
            result = result .. __TS__StringAccess(template, i)
            i = i + 1
        end
        ::__continue34::
    end
    return denormalizeFormulaTemplate(
        nil,
        processInlineFormulas(nil, result, unit, skillLevel)
    )
end
function updateSkillTip(self, skillInfo)
    local ____skillInfo_1 = skillInfo
    local unit = ____skillInfo_1.unit
    local abilityId = ____skillInfo_1.abilityId
    local template = ____skillInfo_1.template
    local abil = EXGetUnitAbility(nil, unit, abilityId)
    if not abil then
        return
    end
    local currentLevel = jass.GetUnitAbilityLevel(unit, abilityId) or skillInfo.level or 1
    skillInfo.level = currentLevel
    skillInfo.renderedText = processTemplate(nil, template, unit, currentLevel)
end
function matchFormulaToken(self, text, start)
    for ____, token in ipairs(formulaTokenNames) do
        if __TS__StringSlice(text, start, start + #token) == token then
            return token
        end
    end
    return nil
end
function isInlineFormulaChar(self, c)
    return isDigit(nil, c) or c == "." or c == "+" or c == "-" or c == "*" or c == "/" or c == "×" or c == "÷" or c == OPERATOR_MULTIPLY_CN or c == OPERATOR_DIVIDE_CN or c == "脳" or c == "梅" or c == "(" or c == ")"
end
function hasFormulaOperatorOrDigit(self, formula)
    do
        local i = 0
        while i < #formula do
            local c = __TS__StringAccess(formula, i)
            if isDigit(nil, c) or c == "+" or c == "-" or c == "*" or c == "/" or c == "×" or c == "÷" or c == OPERATOR_MULTIPLY_CN or c == OPERATOR_DIVIDE_CN or c == "脳" or c == "梅" then
                return true
            end
            i = i + 1
        end
    end
    return false
end
function processInlineFormulas(self, template, unit, skillLevel)
    local result = ""
    local i = 0
    while i < #template do
        do
            local startToken = matchFormulaToken(nil, template, i)
            if startToken == nil then
                result = result .. __TS__StringAccess(template, i)
                i = i + 1
                goto __continue100
            end
            local ____end = i + #startToken
            while ____end < #template do
                do
                    local nextToken = matchFormulaToken(nil, template, ____end)
                    if nextToken ~= nil then
                        ____end = ____end + #nextToken
                        goto __continue102
                    end
                    if not isInlineFormulaChar(
                        nil,
                        __TS__StringAccess(template, ____end)
                    ) then
                        break
                    end
                    ____end = ____end + 1
                end
                ::__continue102::
            end
            local formula = __TS__StringSlice(template, i, ____end)
            if not hasFormulaOperatorOrDigit(nil, formula) then
                result = result .. __TS__StringAccess(template, i)
                i = i + 1
                goto __continue100
            end
            result = result .. formatNumber(
                nil,
                evaluateFormula(nil, formula, unit, skillLevel)
            )
            i = ____end
        end
        ::__continue100::
    end
    return result
end
jass = require("jass.common")
local heroLevelEventCenter = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心")
local registerHeroLevelListener = heroLevelEventCenter.registerHeroLevelListener
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
EXGetUnitAbility = ____require_result_0.EXGetUnitAbility
local ABILITY_DATA_TIP = ____require_result_0.ABILITY_DATA_TIP
local ABILITY_DATA_UBERTIP = ____require_result_0.ABILITY_DATA_UBERTIP
____exports.ABILITY_DATA_TIP = ABILITY_DATA_TIP
____exports.ABILITY_DATA_UBERTIP = ABILITY_DATA_UBERTIP
local attributeGetters = {
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
FORMULA_TOKEN_SKILL_LEVEL = "__SKILL_LEVEL__"
local FORMULA_TOKEN_STR = "__STR__"
local FORMULA_TOKEN_AGI = "__AGI__"
local FORMULA_TOKEN_INT = "__INT__"
local FORMULA_TOKEN_STR_WHITE = "__STR_WHITE__"
local FORMULA_TOKEN_AGI_WHITE = "__AGI_WHITE__"
local FORMULA_TOKEN_INT_WHITE = "__INT_WHITE__"
local FORMULA_TOKEN_HP = "__HP__"
local FORMULA_TOKEN_HP_MAX = "__HP_MAX__"
local FORMULA_TOKEN_MP = "__MP__"
local FORMULA_TOKEN_MP_MAX = "__MP_MAX__"
local FORMULA_TOKEN_ATTACK = "__ATTACK__"
local FORMULA_TOKEN_ARMOR = "__ARMOR__"
local FORMULA_TOKEN_MOVE_SPEED = "__MOVE_SPEED__"
local FORMULA_TOKEN_LEVEL = "__LEVEL__"
local FORMULA_TOKEN_HERO_LEVEL = "__HERO_LEVEL__"
local FORMULA_TOKEN_XP = "__XP__"
formulaAliases = {
    {source = ATTR_SKILL_LEVEL, token = FORMULA_TOKEN_SKILL_LEVEL},
    {source = ATTR_STR_WHITE, token = FORMULA_TOKEN_STR_WHITE},
    {source = ATTR_AGI_WHITE, token = FORMULA_TOKEN_AGI_WHITE},
    {source = ATTR_INT_WHITE, token = FORMULA_TOKEN_INT_WHITE},
    {source = ATTR_HP_MAX, token = FORMULA_TOKEN_HP_MAX},
    {source = ATTR_MP_MAX, token = FORMULA_TOKEN_MP_MAX},
    {source = ATTR_MOVE_SPEED, token = FORMULA_TOKEN_MOVE_SPEED},
    {source = ATTR_HERO_LEVEL, token = FORMULA_TOKEN_HERO_LEVEL},
    {source = ATTR_ATTACK, token = FORMULA_TOKEN_ATTACK},
    {source = ATTR_ARMOR, token = FORMULA_TOKEN_ARMOR},
    {source = ATTR_LEVEL, token = FORMULA_TOKEN_LEVEL},
    {source = ATTR_STR, token = FORMULA_TOKEN_STR},
    {source = ATTR_AGI, token = FORMULA_TOKEN_AGI},
    {source = ATTR_INT, token = FORMULA_TOKEN_INT},
    {source = ATTR_HP, token = FORMULA_TOKEN_HP},
    {source = ATTR_MP, token = FORMULA_TOKEN_MP},
    {source = ATTR_XP, token = FORMULA_TOKEN_XP}
}
aliasedAttributeGetters = {
    [FORMULA_TOKEN_STR] = attributeGetters[ATTR_STR],
    [FORMULA_TOKEN_AGI] = attributeGetters[ATTR_AGI],
    [FORMULA_TOKEN_INT] = attributeGetters[ATTR_INT],
    [FORMULA_TOKEN_STR_WHITE] = attributeGetters[ATTR_STR_WHITE],
    [FORMULA_TOKEN_AGI_WHITE] = attributeGetters[ATTR_AGI_WHITE],
    [FORMULA_TOKEN_INT_WHITE] = attributeGetters[ATTR_INT_WHITE],
    [FORMULA_TOKEN_HP] = attributeGetters[ATTR_HP],
    [FORMULA_TOKEN_HP_MAX] = attributeGetters[ATTR_HP_MAX],
    [FORMULA_TOKEN_MP] = attributeGetters[ATTR_MP],
    [FORMULA_TOKEN_MP_MAX] = attributeGetters[ATTR_MP_MAX],
    [FORMULA_TOKEN_ATTACK] = attributeGetters[ATTR_ATTACK],
    [FORMULA_TOKEN_ARMOR] = attributeGetters[ATTR_ARMOR],
    [FORMULA_TOKEN_MOVE_SPEED] = attributeGetters[ATTR_MOVE_SPEED],
    [FORMULA_TOKEN_LEVEL] = attributeGetters[ATTR_LEVEL],
    [FORMULA_TOKEN_HERO_LEVEL] = attributeGetters[ATTR_HERO_LEVEL],
    [FORMULA_TOKEN_XP] = attributeGetters[ATTR_XP]
}
local skillRegistry = __TS__New(Map)
local unitHandleMap = __TS__New(Map)
formulaTokenNames = __TS__ArraySort(
    {
        FORMULA_TOKEN_SKILL_LEVEL,
        table.unpack(__TS__ObjectKeys(aliasedAttributeGetters))
    },
    function(____, a, b) return #b - #a end
)
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
        tipType = tipType,
        renderedText = ""
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
    local skillList = unitSkills:get(abilityId)
    local replaced = false
    do
        local i = 0
        while i < #skillList do
            do
                if skillList[i + 1].tipType ~= tipType then
                    goto __continue45
                end
                skillList[i + 1].level = level
                skillList[i + 1].template = template
                skillList[i + 1].unit = unit
                updateSkillTip(nil, skillList[i + 1])
                replaced = true
                break
            end
            ::__continue45::
            i = i + 1
        end
    end
    if not replaced then
        skillList[#skillList + 1] = skillInfo
        updateSkillTip(nil, skillInfo)
    end
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
function ____exports.getDynamicSkillTipText(self, unit, abilityId, tipType)
    if not unit or not abilityId then
        return nil
    end
    local handleId = jass.GetHandleId(unit)
    if not handleId or not skillRegistry:has(handleId) then
        return nil
    end
    local unitSkills = skillRegistry:get(handleId)
    local skillList = unitSkills:get(abilityId)
    if skillList == nil then
        return nil
    end
    do
        local i = 0
        while i < #skillList do
            do
                local skillInfo = skillList[i + 1]
                if skillInfo.tipType ~= tipType then
                    goto __continue61
                end
                if skillInfo.renderedText == "" then
                    updateSkillTip(nil, skillInfo)
                end
                return skillInfo.renderedText or nil
            end
            ::__continue61::
            i = i + 1
        end
    end
    return nil
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
                goto __continue72
            end
            for ____, skillList in __TS__Iterator(unitSkills:values()) do
                for ____, skillInfo in ipairs(skillList) do
                    updateSkillTip(nil, skillInfo)
                end
            end
        end
        ::__continue72::
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
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local _heroLevelListenerBound = false
local _deathListenerBound = false
function ____exports.initDynamicSkillTipSystem(self)
    if not DYNAMIC_SKILL_TIP_ENABLED then
        return
    end
    if not _heroLevelListenerBound then
        _heroLevelListenerBound = true
        registerHeroLevelListener(function(____, unit)
            ____exports.refreshUnitSkillTips(nil, unit)
        end)
    end
    if not _deathListenerBound then
        _deathListenerBound = true
        registerDeathListener(
            nil,
            function(____, dyingUnit)
                ____exports.unregisterDynamicSkillTip(nil, dyingUnit)
            end
        )
    end
end
function ____exports.renderDynamicSkillTemplate(self, template, unit, skillLevel)
    if not template then
        return ""
    end
    return processTemplate(nil, template, unit, skillLevel)
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
