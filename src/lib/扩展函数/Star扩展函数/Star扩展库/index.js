export * from "./00．镜头函数";
export * from "./01．SDR调试计时器";
import * as cameraFunc from "./00．镜头函数";
import * as sdrDebug from "./01．SDR调试计时器";
function expose(name, fn) {
    if (typeof fn !== "function")
        return;
    const g = globalThis;
    if (typeof g[name] === "function")
        return;
    g[name] = fn;
}
export function registerBridge() {
    expose("PanCameraToTimedUnitForPlayer", cameraFunc.PanCameraToTimedUnitForPlayer);
    expose("SDR_DebugTimer", sdrDebug.SDR_DebugTimer);
}
