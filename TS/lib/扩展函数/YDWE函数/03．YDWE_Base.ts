const jass = require("jass.common") as any;

export function OperatorDegreeAdd(a: number, b: number): number {
    return a + b;
}

export function OperatorDegreeSubtract(a: number, b: number): number {
    return a - b;
}

export function OperatorDegreeMultiply(a: number, b: number): number {
    return a * b;
}

export function OperatorDegreeDivide(a: number, b: number): number {
    return a / b;
}

export function OperatorRadianAdd(a: number, b: number): number {
    return a + b;
}

export function OperatorRadianSubtract(a: number, b: number): number {
    return a - b;
}

export function OperatorRadianMultiply(a: number, b: number): number {
    return a * b;
}

export function OperatorRadianDivide(a: number, b: number): number {
    return a / b;
}

export function OperatorIntegerAdd(a: number, b: number): number {
    return a + b;
}

export function OperatorIntegerSubtract(a: number, b: number): number {
    return a - b;
}

export function OperatorIntegerMultiply(a: number, b: number): number {
    return a * b;
}

export function OperatorIntegerDivide(a: number, b: number): number {
    return Math.floor(a / b);
}

export function OperatorRealAdd(a: number, b: number): number {
    return a + b;
}

export function OperatorRealSubtract(a: number, b: number): number {
    return a - b;
}

export function OperatorRealMultiply(a: number, b: number): number {
    return a * b;
}

export function OperatorRealDivide(a: number, b: number): number {
    return a / b;
}

function applyOp(a: number, op: string, b: number): number {
    if (op === "+") return a + b;
    if (op === "-") return a - b;
    if (op === "*") return a * b;
    if (op === "/") return a / b;
    return a;
}

export function YDWEOperatorInt3(a1: number, op1: string, a2: number, op2: string, a3: number): number {
    if (op2 === "*" || op2 === "/") {
        return Math.floor(applyOp(a1, op1, applyOp(a2, op2, a3)));
    }
    return Math.floor(applyOp(applyOp(a1, op1, a2), op2, a3));
}

export function YDWEOperatorReal3(a1: number, op1: string, a2: number, op2: string, a3: number): number {
    if (op2 === "*" || op2 === "/") {
        return applyOp(a1, op1, applyOp(a2, op2, a3));
    }
    return applyOp(applyOp(a1, op1, a2), op2, a3);
}

export function YDWEOperatorString3(a1: string, a2: string, a3: string): string {
    return a1 + a2 + a3;
}

export function YDWER2Rad(a: number): number {
    return a;
}

export function YDWER2Deg(a: number): number {
    return a;
}

export function YDWEDeg2R(a: number): number {
    return a;
}

export function YDWERad2R(a: number): number {
    return a;
}

export function YDWEInitHashtable(): any {
    return jass.InitHashtable();
}

export function YDWEIsTriggerEventId(eventid: number): boolean {
    return eventid === jass.GetTriggerEventId();
}

export function YDWEH2I(handle: any): number {
    return jass.GetHandleId(handle);
}

export function YDWEGetUnitID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetItemID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetPlayerID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTimerID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTriggerID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetGroupID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetLocationID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetMultiboardID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetMultiboardItemID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTextTagID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetLightningID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetRegionID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetRectID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetLeaderboardID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetEffectID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetDestructableID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTriggerConditionID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTriggerActionID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTriggerEventID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetForceID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetBoolexprID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetSoundID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTimerDialogID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetTrackableID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetDialogID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEGetButtonID(a: any): number {
    return YDWEH2I(a);
}

export function YDWEConvert(a: any): any {
    return a;
}

export function YDWEGetUnitTypeID(a: any): any {
    return a;
}

export function YDWEGetAbilityTypeID(a: any): any {
    return a;
}

export function YDWEGetItemTypeID(a: any): any {
    return a;
}

export function YDWEConverUnitcodeToInt(a: any): any {
    return a;
}

export function YDWEConverItemcodeToInt(a: any): any {
    return a;
}

export function YDWEConverAbilcodeToInt(a: any): any {
    return a;
}

export function YDWEConverOrdercodeToInt(a: any): any {
    return a;
}

export function YDWEUOrderId2OrderId(a: any): any {
    return a;
}

export function YDWEPOrderId2OrderId(a: any): any {
    return a;
}

export function YDWEDOrderId2OrderId(a: any): any {
    return a;
}

export function YDWEIOrderId2OrderId(a: any): any {
    return a;
}

export function YDWENOrderId2OrderId(a: any): any {
    return a;
}

export function YDWEI2UnitId(a: any): any {
    return a;
}

export function YDWEI2ItemId(a: any): any {
    return a;
}

export {};
