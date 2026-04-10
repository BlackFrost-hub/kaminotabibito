const jass = require("jass.common");
const MAX_PLAYER_SLOTS = 16;
export function TriggerRegisterAnyUnitEventBJ(trig, whichEvent) {
    for (let index = 0; index < MAX_PLAYER_SLOTS; index++) {
        if (typeof jass.TriggerRegisterPlayerUnitEvent === "function") {
            jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(index), whichEvent, undefined);
        }
    }
}
export function ConditionalTriggerExecute(trig) {
    if (!trig)
        return;
    if (typeof jass.TriggerEvaluate !== "function" || typeof jass.TriggerExecute !== "function")
        return;
    if (jass.TriggerEvaluate(trig)) {
        jass.TriggerExecute(trig);
    }
}
export function TriggerRegisterUnitInRangeSimple(trig, range, whichUnit) {
    if (typeof jass.TriggerRegisterUnitInRange === "function") {
        return jass.TriggerRegisterUnitInRange(trig, whichUnit, range, null);
    }
    return null;
}
