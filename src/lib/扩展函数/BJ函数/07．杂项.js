const jass = require("jass.common");
const jglobals = require("jass.globals");
export function ModifyGateBJ(gateOperation, d) {
    if (!d)
        return;
    const CLOSE = jglobals.bj_GATEOPERATION_CLOSE;
    const OPEN = jglobals.bj_GATEOPERATION_OPEN;
    const DESTROY = jglobals.bj_GATEOPERATION_DESTROY;
    if (gateOperation === CLOSE) {
        if (jass.GetDestructableLife(d) <= 0) {
            jass.DestructableRestoreLife(d, jass.GetDestructableMaxLife(d), true);
        }
        jass.SetDestructableAnimation(d, "stand");
        return;
    }
    if (gateOperation === OPEN) {
        if (jass.GetDestructableLife(d) > 0) {
            jass.KillDestructable(d);
        }
        jass.SetDestructableAnimation(d, "death alternate");
        return;
    }
    if (gateOperation === DESTROY) {
        if (jass.GetDestructableLife(d) > 0) {
            jass.KillDestructable(d);
        }
        jass.SetDestructableAnimation(d, "death");
    }
}
export function GetUnitsInRectMatching(r, filter) {
    const g = jass.CreateGroup();
    if (!g)
        return null;
    jass.GroupEnumUnitsInRect(g, r, filter);
    if (filter) {
        jass.DestroyBoolExpr(filter);
    }
    return g;
}
export function ForGroupBJ(whichGroup, callback) {
    const wantDestroy = !!jglobals.bj_wantDestroyGroup;
    jglobals.bj_wantDestroyGroup = false;
    jass.ForGroup(whichGroup, callback);
    if (wantDestroy) {
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
    return jass.GetSpellAbilityId();
}
export function OrderIdToString(orderId) {
    const c1 = orderId % 256;
    const c2 = jass.R2I(orderId / 256) % 256;
    const c3 = jass.R2I(orderId / 256 / 256) % 256;
    const c4 = jass.R2I(orderId / 256 / 256 / 256) % 256;
    return String.fromCharCode(c1, c2, c3, c4);
}
export let lastCreatedEffect = null;
export function AddSpecialEffectTargetUnitBJ(attachPointName, targetWidget, modelName) {
    lastCreatedEffect = jass.AddSpecialEffectTarget(modelName, targetWidget, attachPointName);
    return lastCreatedEffect;
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
/**
 * 字符串转命令ID
 * 对应JASS: String2OrderIdBJ
 * 先尝试OrderId，若为0再尝试UnitId
 */
export function String2OrderIdBJ(orderIdString) {
    // Check to see if it's a generic order.
    let orderId = 0;
    orderId = jass.OrderId(orderIdString);
    if (orderId !== 0) {
        return orderId;
    }
    // Check to see if it's a (train) unit order.
    orderId = jass.UnitId(orderIdString);
    if (orderId !== 0) {
        return orderId;
    }
    // Unrecognized - return 0
    return 0;
}
