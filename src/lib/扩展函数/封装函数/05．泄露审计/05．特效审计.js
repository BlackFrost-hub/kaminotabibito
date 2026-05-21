/**
 * 泄露审计 - 特效
 */
const jass = require("jass.common");
import { track, untrack } from "./01．核心统计";
/** 创建特效：你可以先用原生创建好 effect，再传进来 trackEffect(tag, effect) */
export function trackEffect(tag, eff) {
    track("effect", eff, tag);
}
export function destroyEffect(eff) {
    if (!eff)
        return;
    untrack("effect", eff);
    jass.DestroyEffect(eff);
}
