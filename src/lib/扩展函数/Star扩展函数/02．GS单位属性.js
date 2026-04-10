const jass = require("jass.common");
const jglobals = require("jass.globals");
const HS = typeof jass.InitHashtable === "function" ? jass.InitHashtable() : null;
function hid(h) {
    return typeof jass.GetHandleId === "function" ? (jass.GetHandleId(h) || 0) : 0;
}
function loadReal(handle, parent, child) {
    if (!handle || typeof jass.LoadReal !== "function")
        return 0;
    return jass.LoadReal(handle, parent, child) || 0;
}
function saveReal(handle, parent, child, value) {
    if (!handle || typeof jass.SaveReal !== "function")
        return;
    jass.SaveReal(handle, parent, child, value);
}
export function GS_LoadUintProperty(u, i) {
    if (!u)
        return 0;
    if (i === 0)
        return jass.GetUnitState(u, jass.UNIT_STATE_LIFE) || 0;
    if (i === 1)
        return jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) || 0;
    if (i === 2)
        return jass.GetUnitState(u, jass.ConvertUnitState(0x12)) || 0;
    if (i === 3)
        return jass.GetUnitState(u, jass.ConvertUnitState(0x20)) || 0;
    if (i === 4)
        return jass.GetUnitState(u, jass.ConvertUnitState(0x51)) || 0;
    if (i === 5)
        return jass.GetUnitMoveSpeed(u) || 0;
    return loadReal(HS, hid(u), i);
}
export function GS_LoadUintProperty_B(u, i) {
    return GS_LoadUintProperty(u, i);
}
export function GS_Unit_Pry_change(u, i, r) {
    if (!u || r === 0)
        return;
    const uid = hid(u);
    let hp = 0;
    if (i === 0) {
        hp = jass.GetUnitLifePercent(u) || 0;
        jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) + (r * (1 + loadReal(HS, uid, 15))));
        if (typeof jass.SetUnitLifePercentBJ === "function")
            jass.SetUnitLifePercentBJ(u, hp);
        return;
    }
    if (i === 1) {
        hp = jass.GetUnitManaPercent(u) || 0;
        jass.SetUnitState(u, jass.UNIT_STATE_MAX_MANA, jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) + r);
        if (typeof jass.SetUnitManaPercentBJ === "function")
            jass.SetUnitManaPercentBJ(u, hp);
        return;
    }
    if (i === 2) {
        jass.SetUnitState(u, jass.ConvertUnitState(0x12), jass.GetUnitState(u, jass.ConvertUnitState(0x12)) + (r * (1 + loadReal(HS, uid, 16))));
        return;
    }
    if (i === 3) {
        jass.SetUnitState(u, jass.ConvertUnitState(0x20), jass.GetUnitState(u, jass.ConvertUnitState(0x20)) + (r * (1 + loadReal(HS, uid, 17))));
        return;
    }
    if (i === 4) {
        jass.SetUnitState(u, jass.ConvertUnitState(0x51), jass.GetUnitState(u, jass.ConvertUnitState(0x51)) + r);
        return;
    }
    if (i === 5) {
        const ms = loadReal(HS, uid, i) + r;
        saveReal(HS, uid, i, ms);
        jass.SetUnitMoveSpeed(u, jass.GetUnitDefaultMoveSpeed(u) * (1 + ms));
        return;
    }
    if (i === 13) {
        hp = jass.GetUnitLifePercent(u) || 0;
        jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, (jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r));
        if (typeof jass.SetUnitLifePercentBJ === "function")
            jass.SetUnitLifePercentBJ(u, hp);
        saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
        return;
    }
    if (i === 14) {
        if (r < 0) {
            jass.SetUnitState(u, jass.ConvertUnitState(0x12), (jass.GetUnitState(u, jass.ConvertUnitState(0x12)) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r));
        }
        else {
            jass.SetUnitState(u, jass.ConvertUnitState(0x12), (jass.GetUnitState(u, jass.ConvertUnitState(0x12)) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r) + 1);
        }
        saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
        return;
    }
    if (i === 15) {
        jass.SetUnitState(u, jass.ConvertUnitState(0x20), (jass.GetUnitState(u, jass.ConvertUnitState(0x20)) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r));
        saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
        return;
    }
    if (i === 16) {
        if (typeof jass.ModifyHeroStat === "function") {
            jass.ModifyHeroStat(jglobals.bj_HEROSTAT_STR, u, jglobals.bj_MODIFYMETHOD_ADD, Math.floor(r));
        }
        GS_Unit_Pry_change(u, 0, r * 5);
        return;
    }
    if (i === 17) {
        if (typeof jass.ModifyHeroStat === "function") {
            jass.ModifyHeroStat(jglobals.bj_HEROSTAT_AGI, u, jglobals.bj_MODIFYMETHOD_ADD, Math.floor(r));
        }
        GS_Unit_Pry_change(u, 2, r * 0.3);
        GS_Unit_Pry_change(u, 3, r);
        return;
    }
    if (i === 18) {
        if (typeof jass.ModifyHeroStat === "function") {
            jass.ModifyHeroStat(jglobals.bj_HEROSTAT_INT, u, jglobals.bj_MODIFYMETHOD_ADD, Math.floor(r));
        }
        GS_Unit_Pry_change(u, 5, r * 0.5);
        return;
    }
    saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
}
export function GS_UnitPry(u, change, ptytype, r) {
    if (change === 1)
        r = 0 - r;
    GS_Unit_Pry_change(u, ptytype, r);
}
export function GS_UnitPryB(u, change, ptytype, r) {
    GS_UnitPry(u, change, ptytype, r);
}
