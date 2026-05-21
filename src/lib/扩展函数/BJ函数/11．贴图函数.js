const jass = require("jass.common");
const jglobals = require("jass.globals");
// ===========================================================================
// 最后创建的贴图（Blizzard.j）
// ===========================================================================
export let bj_lastCreatedUbersplat = jglobals.bj_lastCreatedUbersplat ?? null;
export function CreateUbersplatBJ(file, where, red, green, blue, alpha, forcePaused, noBirthTime) {
    if (where == null || where === 0)
        return null;
    const x = jass.GetLocationX(where);
    const y = jass.GetLocationY(where);
    bj_lastCreatedUbersplat = jass.CreateUbersplat(x, y, red, green, blue, alpha, forcePaused, noBirthTime);
    return bj_lastCreatedUbersplat;
}
export function ShowUbersplatBJ(flag, whichUbersplat) {
    if (whichUbersplat == null || whichUbersplat === 0)
        return;
    jass.ShowUbersplat(whichUbersplat, flag);
}
export function GetLastCreatedUbersplat() {
    return bj_lastCreatedUbersplat;
}
