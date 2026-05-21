/**
 * 泄露审计 - 触发器
 */
const jass = require("jass.common");
import { track, untrack } from "./01．核心统计";
export function createTrigger(tag) {
    const trg = jass.CreateTrigger();
    track("trigger", trg, tag);
    return trg;
}
export function destroyTrigger(trg) {
    if (!trg)
        return;
    untrack("trigger", trg);
    jass.DestroyTrigger(trg);
}
