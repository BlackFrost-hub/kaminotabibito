--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
function ____exports.GetUnitCurrentOrder(self, unit)
    if type(jass.GetUnitCurrentOrder) == "function" then
        return jass.GetUnitCurrentOrder(unit)
    end
    return 0
end
function ____exports.IsUnitDeadBJ(self, whichUnit)
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) <= 0
end
function ____exports.IsUnitAliveBJ(self, whichUnit)
    return not ____exports.IsUnitDeadBJ(nil, whichUnit)
end
function ____exports.GetHeroStatBJ(self, whichStat, whichHero, includeBonuses)
    if whichStat == jglobals.bj_HEROSTAT_STR then
        return jass.GetHeroStr(whichHero, includeBonuses)
    elseif whichStat == jglobals.bj_HEROSTAT_AGI then
        return jass.GetHeroAgi(whichHero, includeBonuses)
    elseif whichStat == jglobals.bj_HEROSTAT_INT then
        return jass.GetHeroInt(whichHero, includeBonuses)
    end
    return 0
end
function ____exports.ModifyHeroStat(self, whichStat, whichHero, modifyMethod, value)
    if modifyMethod == jglobals.bj_MODIFYMETHOD_ADD then
        jass.SetHeroStat(
            whichHero,
            whichStat,
            ____exports.GetHeroStatBJ(nil, whichStat, whichHero, false) + value
        )
    elseif modifyMethod == jglobals.bj_MODIFYMETHOD_SUB then
        jass.SetHeroStat(
            whichHero,
            whichStat,
            ____exports.GetHeroStatBJ(nil, whichStat, whichHero, false) - value
        )
    elseif modifyMethod == jglobals.bj_MODIFYMETHOD_SET then
        jass.SetHeroStat(whichHero, whichStat, value)
    end
end
function ____exports.SetUnitFacingToFaceUnitTimed(self, whichUnit, target, duration)
    local angle = jglobals.bj_RADTODEG * jass.Atan2(
        jass.GetUnitY(target) - jass.GetUnitY(whichUnit),
        jass.GetUnitX(target) - jass.GetUnitX(whichUnit)
    )
    jass.SetUnitFacingTimed(whichUnit, angle, duration)
end
return ____exports
