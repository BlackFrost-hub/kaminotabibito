/**
 * 泄露审计 - 单位组
 */
const jass = require("jass.common");
import { track, untrack } from "./01．核心统计";
export function createGroup(tag) {
    const g = jass.CreateGroup();
    track("group", g, tag);
    return g;
}
export function destroyGroup(gp) {
    if (!gp)
        return;
    untrack("group", gp);
    jass.DestroyGroup(gp);
}
