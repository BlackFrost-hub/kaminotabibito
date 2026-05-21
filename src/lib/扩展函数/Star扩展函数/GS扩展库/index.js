export * from "./00．极坐标投影";
export * from "./01．通用GS函数";
import * as gsExt from "./00．极坐标投影";
import * as gsCommon from "./01．通用GS函数";
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
    expose("SoHeroHatm", gsCommon.SoHeroHatm);
    expose("GS_news", gsCommon.GS_news);
    expose("GS_DisplayTimedTextToForcetakes", gsCommon.GS_DisplayTimedTextToForcetakes);
    expose("GS_UnitSector", gsCommon.GS_UnitSector);
    expose("GS_Sector", gsCommon.GS_Sector);
}
