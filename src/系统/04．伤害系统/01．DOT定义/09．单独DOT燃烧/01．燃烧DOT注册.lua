--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0EDOT_914D_7F6E = require("系统.04．伤害系统.01．DOT定义.01．DOT配置")
local getDotBuffRow = ____01_FF0EDOT_914D_7F6E.getDotBuffRow
local dotEffectModelFromBuffRow = ____01_FF0EDOT_914D_7F6E.dotEffectModelFromBuffRow
local ____02_FF0EDOT_89E3_6790 = require("系统.04．伤害系统.01．DOT定义.02．DOT解析")
local parseStandardDotBuff = ____02_FF0EDOT_89E3_6790.parseStandardDotBuff
local function _____89E3_6790_71C3_70E7Buff(buffStr)
    return parseStandardDotBuff(
        nil,
        buffStr,
        "Burn",
        function(____, damagePerSec, duration, attackOnly) return {damagePerSec = damagePerSec, duration = duration, attackOnly = attackOnly} end,
        true
    )
end
local function _____53D6_6700_4F18_71C3_70E7Dot(unit, getBestDotFromUnit)
    return getBestDotFromUnit(
        unit,
        _____89E3_6790_71C3_70E7Buff,
        function(parsed) return parsed.damagePerSec * parsed.duration end
    )
end
____exports["注册燃烧DOT"] = function(deps)
    local registerDotType = deps.registerDotType
    local getBestDotFromUnitFn = deps.getBestDotFromUnit
    registerDotType(
        nil,
        {
            id = "burn",
            debuffDotEnemyNoStructure = true,
            parseBuff = function(____, buffStr) return _____89E3_6790_71C3_70E7Buff(buffStr) end,
            getBestFromUnit = function(____, unit)
                local getBestDotFromUnit = getBestDotFromUnitFn
                return getBestDotFromUnit(
                    nil,
                    unit,
                    function(buffStr) return _____89E3_6790_71C3_70E7Buff(buffStr) end,
                    function(parsed) return parsed.damagePerSec * parsed.duration end
                )
            end,
            computeAmount = function(____, _target, parsed) return parsed.damagePerSec or 0 end,
            damageType = require("jass.common").DAMAGE_TYPE_FIRE,
            effectModel = dotEffectModelFromBuffRow(
                nil,
                getDotBuffRow(nil, "burn")
            ),
            effectDuration = 0.75
        }
    )
end
return ____exports
