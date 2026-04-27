const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

export function ModifyGateBJ(gateOperation: number, d: any): void {
    if (!d) return;

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

export function GetUnitsInRectMatching(r: any, filter: any): any {
    const g = jass.CreateGroup();
    if (!g) return null;
    jass.GroupEnumUnitsInRect(g, r, filter);
    if (filter) {
        jass.DestroyBoolExpr(filter);
    }
    return g;
}

export function ForGroupBJ(whichGroup: any, callback: any): void {
    const wantDestroy = !!jglobals.bj_wantDestroyGroup;
    jglobals.bj_wantDestroyGroup = false;
    jass.ForGroup(whichGroup, callback);
    if (wantDestroy) {
        jass.DestroyGroup(whichGroup);
    }
}

export function GetPlayersAll(): any {
    return jglobals.bj_FORCE_ALL_PLAYERS;
}

export function GetRandomDirectionDeg(): number {
    return jass.GetRandomReal(0, 360);
}

export function GetSpellAbilityId(): number {
    return jass.GetSpellAbilityId();
}

export function OrderIdToString(orderId: number): string {
    const c1 = orderId % 256;
    const c2 = jass.R2I(orderId / 256) % 256;
    const c3 = jass.R2I(orderId / 256 / 256) % 256;
    const c4 = jass.R2I(orderId / 256 / 256 / 256) % 256;
    return String.fromCharCode(c1, c2, c3, c4);
}

export let lastCreatedEffect: any = null;

export function AddSpecialEffectTargetUnitBJ(attachPointName: string, targetWidget: any, modelName: string): any {
    lastCreatedEffect = jass.AddSpecialEffectTarget(modelName, targetWidget, attachPointName);
    return lastCreatedEffect;
}

export function OperatorDegreeMultiply(a: number, b: number): number {
    return a * b;
}

export function OperatorRealAdd(a: number, b: number): number {
    return a + b;
}

export function OperatorRealMultiply(a: number, b: number): number {
    return a * b;
}

/**
 * 字符串转命令ID
 * 对应JASS: String2OrderIdBJ
 * 先尝试OrderId，若为0再尝试UnitId
 */
export function String2OrderIdBJ(orderIdString: string): number {
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

export {};
