export * from "./00．极坐标投影";
import * as gsExt from "./00．极坐标投影";
function expose(name, fn) {
    if (typeof fn !== "function")
        return;
    const g = globalThis;
    if (typeof g[name] === "function")
        return;
    g[name] = fn;
}
export function registerBridge() {
    expose("GS_PolarProjectionBJ", gsExt.GS_PolarProjectionBJ);
}
