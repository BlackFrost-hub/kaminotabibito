const jass = require("jass.common");
const jglobals = require("jass.globals");
export function ModifyGateBJ(gateOperation, d) {
    if (!d)
        return;
    if (typeof jass.GetDestructableLife !== "function" ||
        typeof jass.GetDestructableMaxLife !== "function" ||
        typeof jass.SetDestructableAnimation !== "function")
        return;
    const CLOSE = jglobals.bj_GATEOPERATION_CLOSE;
    const OPEN = jglobals.bj_GATEOPERATION_OPEN;
    const DESTROY = jglobals.bj_GATEOPERATION_DESTROY;
    if (gateOperation === CLOSE) {
        if (jass.GetDestructableLife(d) <= 0 && typeof jass.DestructableRestoreLife === "function") {
            jass.DestructableRestoreLife(d, jass.GetDestructableMaxLife(d), true);
        }
        jass.SetDestructableAnimation(d, "stand");
        return;
    }
    if (gateOperation === OPEN) {
        if (jass.GetDestructableLife(d) > 0 && typeof jass.KillDestructable === "function") {
            jass.KillDestructable(d);
        }
        jass.SetDestructableAnimation(d, "death alternate");
        return;
    }
    if (gateOperation === DESTROY) {
        if (jass.GetDestructableLife(d) > 0 && typeof jass.KillDestructable === "function") {
            jass.KillDestructable(d);
        }
        jass.SetDestructableAnimation(d, "death");
    }
}
export function GetUnitsInRectMatching(r, filter) {
    if (typeof jass.CreateGroup !== "function")
        return null;
    const g = jass.CreateGroup();
    if (!g)
        return null;
    if (typeof jass.GroupEnumUnitsInRect === "function") {
        jass.GroupEnumUnitsInRect(g, r, filter);
    }
    if (filter && typeof jass.DestroyBoolExpr === "function") {
        jass.DestroyBoolExpr(filter);
    }
    return g;
}
export function ForGroupBJ(whichGroup, callback) {
    const wantDestroy = !!jglobals.bj_wantDestroyGroup;
    jglobals.bj_wantDestroyGroup = false;
    if (typeof jass.ForGroup === "function") {
        jass.ForGroup(whichGroup, callback);
    }
    if (wantDestroy && typeof jass.DestroyGroup === "function") {
        jass.DestroyGroup(whichGroup);
    }
}
export function GetPlayersAll() {
    return jglobals.bj_FORCE_ALL_PLAYERS;
}
export function GetRandomDirectionDeg() {
    return jass.GetRandomReal(0, 360);
}
export function GetSpellAbilityId() {
    if (typeof jass.GetSpellAbilityId === "function") {
        return jass.GetSpellAbilityId();
    }
    return 0;
}
export function OrderIdToString(orderId) {
    const c1 = orderId % 256;
    const c2 = Math.floor(orderId / 256) % 256;
    const c3 = Math.floor(orderId / 256 / 256) % 256;
    const c4 = Math.floor(orderId / 256 / 256 / 256) % 256;
    return String.fromCharCode(c1, c2, c3, c4);
}
export let lastCreatedEffect = null;
export function AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName) {
    if (typeof jass.AddSpecialEffectTarget === "function") {
        lastCreatedEffect = jass.AddSpecialEffectTarget(modelName, targetWidget, attachPointName);
        return lastCreatedEffect;
    }
    return null;
}
export function OperatorDegreeMultiply(a, b) {
    return a * b;
}
export function OperatorRealAdd(a, b) {
    return a + b;
}
export function OperatorRealMultiply(a, b) {
    return a * b;
}
export function IMaxBJ(a, b) {
    return a >= b ? a : b;
}
export function IMinBJ(a, b) {
    return a <= b ? a : b;
}
