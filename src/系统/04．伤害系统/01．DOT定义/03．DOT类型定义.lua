local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__ParseInt = ____lualib.__TS__ParseInt
local ____exports = {}
local ____01_FF0EDOT_914D_7F6E = require("系统.04．伤害系统.01．DOT定义.01．DOT配置")
local getDotBuffRow = ____01_FF0EDOT_914D_7F6E.getDotBuffRow
local ____02_FF0EDOT_89E3_6790 = require("系统.04．伤害系统.01．DOT定义.02．DOT解析")
local parseStandardDotBuff = ____02_FF0EDOT_89E3_6790.parseStandardDotBuff
local readNumberFromString = ____02_FF0EDOT_89E3_6790.readNumberFromString
local jass = require("jass.common")
function ____exports.registerBuiltInDotTypes(deps)
    local registerDotType = deps.registerDotType
    local getBestDotFromUnit = deps.getBestDotFromUnit
    local getTargetRegenHP = deps.getTargetRegenHP
    local getUnitMaxHp = deps.getUnitMaxHp
    local dotEffectModelFromBuffRow = deps.dotEffectModelFromBuffRow
    local function parseAntiHealBuff(buffStr)
        return parseStandardDotBuff(
            buffStr,
            "AntiHeal",
            function(effectPct, duration, attackOnly) return {effectPct = effectPct, duration = duration, attackOnly = attackOnly} end,
            false
        )
    end
    local function getBestAntiHealFromUnit(unit)
        return getBestDotFromUnit(
            unit,
            parseAntiHealBuff,
            function(parsed) return parsed.effectPct * parsed.duration end
        )
    end
    registerDotType({
        id = "antiHeal",
        debuffDotEnemyNoStructure = true,
        parseBuff = parseAntiHealBuff,
        getBestFromUnit = getBestAntiHealFromUnit,
        computeAmount = function(target, parsed)
            local regenHP = getTargetRegenHP(target)
            return regenHP * (parsed.effectPct / 100)
        end,
        damageType = jass.DAMAGE_TYPE_MIND,
        effectModel = dotEffectModelFromBuffRow(getDotBuffRow("antiHeal")),
        effectDuration = 0.8
    })
    local function parseBurnBuff(buffStr)
        return parseStandardDotBuff(
            buffStr,
            "Burn",
            function(damagePerSec, duration, attackOnly) return {damagePerSec = damagePerSec, duration = duration, attackOnly = attackOnly} end,
            true
        )
    end
    local function getBestBurnFromUnit(unit)
        return getBestDotFromUnit(
            unit,
            parseBurnBuff,
            function(parsed) return parsed.damagePerSec * parsed.duration end
        )
    end
    registerDotType({
        id = "burn",
        debuffDotEnemyNoStructure = true,
        parseBuff = parseBurnBuff,
        getBestFromUnit = getBestBurnFromUnit,
        computeAmount = function(_target, parsed) return parsed.damagePerSec or 0 end,
        damageType = jass.DAMAGE_TYPE_FIRE,
        effectModel = dotEffectModelFromBuffRow(getDotBuffRow("burn")),
        effectDuration = 0.75
    })
    local function parsePoisonBuff(buffStr)
        return parseStandardDotBuff(
            buffStr,
            "Poison",
            function(damagePerSec, duration, attackOnly) return {damagePerSec = damagePerSec, duration = duration, attackOnly = attackOnly} end,
            true
        )
    end
    local function getBestPoisonFromUnit(unit)
        return getBestDotFromUnit(
            unit,
            parsePoisonBuff,
            function(parsed) return parsed.damagePerSec * parsed.duration end
        )
    end
    registerDotType({
        id = "poison",
        debuffDotEnemyNoStructure = true,
        parseBuff = parsePoisonBuff,
        getBestFromUnit = getBestPoisonFromUnit,
        computeAmount = function(_target, parsed) return parsed.damagePerSec or 0 end,
        damageType = jass.DAMAGE_TYPE_ACID,
        effectModel = dotEffectModelFromBuffRow(getDotBuffRow("poison")),
        effectDuration = 0.8
    })
    local function parseTrollCurseBuff(buffStr)
        if not buffStr or type(buffStr) ~= "string" then
            return nil
        end
        local s = __TS__StringTrim(buffStr)
        if (string.find(s, "Buff:", nil, true) or 0) - 1 == 0 then
            s = __TS__StringSubstring(s, 5)
        end
        local attackOnly = false
        local rest
        if (string.find(s, "attack:curse", nil, true) or 0) - 1 == 0 then
            attackOnly = true
            rest = __TS__StringSubstring(s, 13)
        elseif (string.find(s, "dmg:curse", nil, true) or 0) - 1 == 0 then
            rest = __TS__StringSubstring(s, 9)
        else
            return nil
        end
        local numEnd = 0
        while numEnd < #rest do
            local c = __TS__StringCharAt(rest, numEnd)
            if c >= "0" and c <= "9" then
                numEnd = numEnd + 1
            else
                break
            end
        end
        local pctMaxHpPerSec = numEnd > 0 and (__TS__ParseInt(
            __TS__StringSubstring(rest, 0, numEnd),
            10
        ) or 0) or 0
        local pctPos = (string.find(rest, "%MaxHP", nil, true) or 0) - 1
        if pctPos < 0 or pctPos ~= numEnd then
            return nil
        end
        local timeIdx = (string.find(rest, "time", nil, true) or 0) - 1
        if timeIdx < 0 then
            return nil
        end
        local duration = readNumberFromString(rest, timeIdx + 4)
        if duration <= 0 or pctMaxHpPerSec <= 0 then
            return nil
        end
        return {pctMaxHpPerSec = pctMaxHpPerSec, duration = duration, attackOnly = attackOnly}
    end
    local function getBestTrollCurseFromUnit(unit)
        return getBestDotFromUnit(
            unit,
            parseTrollCurseBuff,
            function(parsed) return parsed.pctMaxHpPerSec * parsed.duration end
        )
    end
    registerDotType({
        id = "trollCurse",
        debuffDotEnemyNoStructure = true,
        parseBuff = parseTrollCurseBuff,
        getBestFromUnit = getBestTrollCurseFromUnit,
        computeAmount = function(target, parsed)
            local maxHp = getUnitMaxHp(target)
            return maxHp * (parsed.pctMaxHpPerSec / 100)
        end,
        damageType = jass.DAMAGE_TYPE_NORMAL,
        effectModel = dotEffectModelFromBuffRow(getDotBuffRow("trollCurse")),
        effectDuration = 0.8
    })
end
return ____exports
