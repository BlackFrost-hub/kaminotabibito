const jass = require("jass.common");
const jglobals = require("jass.globals");
const { RAbsBJ } = require("lib.扩展函数.BJ函数.12．数学函数");
const BJ_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息");
function abs(value) {
    return RAbsBJ(value);
}
export function SoHeroHatm(c) {
    if (c == null || c === 0)
        return 0;
    const inventoryAbilityId = 1095658094; // 'AInv'
    if (jass.GetUnitAbilityLevel(c, inventoryAbilityId) <= 0)
        return 0;
    let n = 0;
    for (let i = 0; i <= 5; i++) {
        if (jass.UnitItemInSlot(c, i) != null)
            n++;
    }
    return n;
}
export function GS_news(P, S) {
    if (P == null || P === 0 || S == null)
        return;
    const F = jass.CreateForce();
    if (F == null || F === 0)
        return;
    jass.ForceAddPlayer(F, P);
    QuestMessageBJ(F, jglobals.bj_QUESTMESSAGE_UPDATED ?? 1, S);
    jass.DestroyForce(F);
}
export function GS_DisplayTimedTextToForcetakes(ply, r, str) {
    if (ply == null || ply === 0 || str == null)
        return;
    jass.DisplayTimedTextToPlayer(ply, 0, 0, r, str);
}
export function GS_UnitSector(u1OrU2, u2OrR, rMaybe) {
    let u1 = u1OrU2;
    let u2 = u2OrR;
    let r = rMaybe;
    // 兼容被全局桥接后由 JASS 直接调用时的 self 参数错位：GS_UnitSector(u1, u2, r)
    if (r == null && typeof u2OrR === "number") {
        u1 = this;
        u2 = u1OrU2;
        r = u2OrR;
    }
    if (r == null || r === false || r === "")
        r = 0;
    if (u1 == null || u1 === 0 || u2 == null || u2 === 0)
        return false;
    const angle1 = jass.GetUnitFacing(u1) || 0;
    const dy = (jass.GetUnitY(u1) || 0) - (jass.GetUnitY(u2) || 0);
    const dx = (jass.GetUnitX(u1) || 0) - (jass.GetUnitX(u2) || 0);
    const angle2 = BJ_RADTODEG * jass.Atan2(dy, dx);
    return abs(abs((angle1 - angle2) - 180) - 180) > r;
}
export function GS_Sector(angle1Or2, angle2Maybe) {
    let angle1 = angle1Or2;
    let angle2 = angle2Maybe;
    // 兼容被全局桥接后由 JASS 直接调用时的 self 参数错位：GS_Sector(angle1, angle2)
    if (angle2 == null && typeof this === "number" && typeof angle1Or2 === "number") {
        angle1 = this;
        angle2 = angle1Or2;
    }
    if (angle1 == null || angle1 === false || angle1 === "")
        angle1 = 0;
    if (angle2 == null || angle2 === false || angle2 === "")
        angle2 = 0;
    return abs(abs((angle1 - angle2) - 180) - 180);
}
