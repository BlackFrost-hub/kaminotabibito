const jass = require("jass.common");
const jglobals = require("jass.globals");
export function GetUnitCurrentOrder(unit) {
    if (typeof jass.GetUnitCurrentOrder === "function") {
        return jass.GetUnitCurrentOrder(unit);
    }
    return 0;
}
export function IsUnitDeadBJ(whichUnit) {
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) <= 0;
}
export function IsUnitAliveBJ(whichUnit) {
    return !IsUnitDeadBJ(whichUnit);
}
export function GetHeroStatBJ(whichStat, whichHero, includeBonuses) {
    if (whichStat === jglobals.bj_HEROSTAT_STR) {
        return jass.GetHeroStr(whichHero, includeBonuses);
    }
    else if (whichStat === jglobals.bj_HEROSTAT_AGI) {
        return jass.GetHeroAgi(whichHero, includeBonuses);
    }
    else if (whichStat === jglobals.bj_HEROSTAT_INT) {
        return jass.GetHeroInt(whichHero, includeBonuses);
    }
    return 0;
}
export function ModifyHeroStat(whichStat, whichHero, modifyMethod, value) {
    if (modifyMethod === jglobals.bj_MODIFYMETHOD_ADD) {
        jass.SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) + value);
    }
    else if (modifyMethod === jglobals.bj_MODIFYMETHOD_SUB) {
        jass.SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) - value);
    }
    else if (modifyMethod === jglobals.bj_MODIFYMETHOD_SET) {
        jass.SetHeroStat(whichHero, whichStat, value);
    }
}
export function SetUnitFacingToFaceUnitTimed(whichUnit, target, duration) {
    const angle = jglobals.bj_RADTODEG * jass.Atan2(jass.GetUnitY(target) - jass.GetUnitY(whichUnit), jass.GetUnitX(target) - jass.GetUnitX(whichUnit));
    jass.SetUnitFacingTimed(whichUnit, angle, duration);
}
