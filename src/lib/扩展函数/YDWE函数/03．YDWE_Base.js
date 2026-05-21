const jass = require("jass.common");
const jglobals = require("jass.globals");
const DEFAULT_BJ_PI = 3.141592653589793;
const DEFAULT_BJ_DEGTORAD = DEFAULT_BJ_PI / 180;
const DEFAULT_BJ_RADTODEG = 180 / DEFAULT_BJ_PI;
function bjDegToRad() {
    const v = jglobals.bj_DEGTORAD;
    return typeof v === "number" ? v : DEFAULT_BJ_DEGTORAD;
}
function bjRadToDeg() {
    const v = jglobals.bj_RADTODEG;
    return typeof v === "number" ? v : DEFAULT_BJ_RADTODEG;
}
export function OperatorDegreeAdd(a, b) {
    return a + b;
}
export function OperatorDegreeSubtract(a, b) {
    return a - b;
}
export function OperatorDegreeMultiply(a, b) {
    return a * b;
}
export function OperatorDegreeDivide(a, b) {
    return a / b;
}
export function OperatorRadianAdd(a, b) {
    return a + b;
}
export function OperatorRadianSubtract(a, b) {
    return a - b;
}
export function OperatorRadianMultiply(a, b) {
    return a * b;
}
export function OperatorRadianDivide(a, b) {
    return a / b;
}
export function OperatorIntegerAdd(a, b) {
    return a + b;
}
export function OperatorIntegerSubtract(a, b) {
    return a - b;
}
export function OperatorIntegerMultiply(a, b) {
    return a * b;
}
export function OperatorIntegerDivide(a, b) {
    return jass.R2I(a / b);
}
export function OperatorRealAdd(a, b) {
    return a + b;
}
export function OperatorRealSubtract(a, b) {
    return a - b;
}
export function OperatorRealMultiply(a, b) {
    return a * b;
}
export function OperatorRealDivide(a, b) {
    return a / b;
}
function applyOp(a, op, b) {
    if (op === "+")
        return a + b;
    if (op === "-")
        return a - b;
    if (op === "*")
        return a * b;
    if (op === "/")
        return a / b;
    return a;
}
export function YDWEOperatorInt3(a1, op1, a2, op2, a3) {
    if (op2 === "*" || op2 === "/") {
        return jass.R2I(applyOp(a1, op1, applyOp(a2, op2, a3)));
    }
    return jass.R2I(applyOp(applyOp(a1, op1, a2), op2, a3));
}
export function YDWEOperatorReal3(a1, op1, a2, op2, a3) {
    if (op2 === "*" || op2 === "/") {
        return applyOp(a1, op1, applyOp(a2, op2, a3));
    }
    return applyOp(applyOp(a1, op1, a2), op2, a3);
}
export function YDWEOperatorString3(a1, a2, a3) {
    return a1 + a2 + a3;
}
/** 将「以度为单位的实数」转为弧度（与常见 YDWE 角度语义一致） */
export function YDWER2Rad(a) {
    return a * bjDegToRad();
}
/** 将「以弧度为单位的实数」转为度 */
export function YDWER2Deg(a) {
    return a * bjRadToDeg();
}
/** 度 → 弧度（实数） */
export function YDWEDeg2R(deg) {
    return deg * bjDegToRad();
}
/** 弧度（已是实数形式）原样返回；与 GUI「弧度型 real」透传一致 */
export function YDWERad2R(rad) {
    return rad;
}
export function YDWEInitHashtable() {
    return jass.InitHashtable();
}
export function YDWEIsTriggerEventId(eventid) {
    return eventid === jass.GetTriggerEventId();
}
export function YDWEH2I(handle) {
    return jass.GetHandleId(handle);
}
export function YDWEGetUnitID(a) {
    return YDWEH2I(a);
}
export function YDWEGetItemID(a) {
    return YDWEH2I(a);
}
export function YDWEGetPlayerID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTimerID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTriggerID(a) {
    return YDWEH2I(a);
}
export function YDWEGetGroupID(a) {
    return YDWEH2I(a);
}
export function YDWEGetLocationID(a) {
    return YDWEH2I(a);
}
export function YDWEGetMultiboardID(a) {
    return YDWEH2I(a);
}
export function YDWEGetMultiboardItemID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTextTagID(a) {
    return YDWEH2I(a);
}
export function YDWEGetLightningID(a) {
    return YDWEH2I(a);
}
export function YDWEGetRegionID(a) {
    return YDWEH2I(a);
}
export function YDWEGetRectID(a) {
    return YDWEH2I(a);
}
export function YDWEGetLeaderboardID(a) {
    return YDWEH2I(a);
}
export function YDWEGetEffectID(a) {
    return YDWEH2I(a);
}
export function YDWEGetDestructableID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTriggerConditionID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTriggerActionID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTriggerEventID(a) {
    return YDWEH2I(a);
}
export function YDWEGetForceID(a) {
    return YDWEH2I(a);
}
export function YDWEGetBoolexprID(a) {
    return YDWEH2I(a);
}
export function YDWEGetSoundID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTimerDialogID(a) {
    return YDWEH2I(a);
}
export function YDWEGetTrackableID(a) {
    return YDWEH2I(a);
}
export function YDWEGetDialogID(a) {
    return YDWEH2I(a);
}
export function YDWEGetButtonID(a) {
    return YDWEH2I(a);
}
export function YDWEConvert(a) {
    return a;
}
export function YDWEGetUnitTypeID(a) {
    return a;
}
export function YDWEGetAbilityTypeID(a) {
    return a;
}
export function YDWEGetItemTypeID(a) {
    return a;
}
export function YDWEConverUnitcodeToInt(a) {
    return a;
}
export function YDWEConverItemcodeToInt(a) {
    return a;
}
export function YDWEConverAbilcodeToInt(a) {
    return a;
}
export function YDWEConverOrdercodeToInt(a) {
    return a;
}
export function YDWEUOrderId2OrderId(a) {
    return a;
}
export function YDWEPOrderId2OrderId(a) {
    return a;
}
export function YDWEDOrderId2OrderId(a) {
    return a;
}
export function YDWEIOrderId2OrderId(a) {
    return a;
}
export function YDWENOrderId2OrderId(a) {
    return a;
}
export function YDWEI2UnitId(a) {
    return a;
}
export function YDWEI2ItemId(a) {
    return a;
}
