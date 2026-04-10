import { collectHidsInTab, isValidDotStateRow, tabDeleteHid, tabRowForHid } from "./04．DOT工具";
// ========== 虚拟分区：buffID -> dotTypeId 映射 ==========
const BUFF_ID_TO_DOT_TYPE = {
    D001: "antiHeal",
    D002: "burn",
    D003: "poison",
    D004: "trollCurse",
};
function dotTypeIdFromBuffId(buffID) {
    return BUFF_ID_TO_DOT_TYPE[buffID] ?? null;
}
// ========== 虚拟分区：创建同步器 ==========
export function createDotStateSync(deps) {
    function syncDotRemainingFromBuffPool() {
        const buffM = require("系统.05．Buff系统.00．Buff系统");
        const map = buffM.DOT_TYPE_TO_BUFF_ID;
        if (map == null || typeof buffM.getBuffRuntimeByHid !== "function")
            return;
        for (const typeId in deps.stateByType) {
            const tab = deps.stateByType[typeId];
            if (tab == null)
                continue;
            const buffID = map[typeId];
            if (buffID == null || buffID === "")
                continue;
            const hids = collectHidsInTab(tab);
            for (let hi = 0; hi < hids.length; hi++) {
                const kn = hids[hi];
                const v = tabRowForHid(tab, kn);
                if (v == null || !isValidDotStateRow(v)) {
                    tabDeleteHid(tab, kn);
                    continue;
                }
                const rt = buffM.getBuffRuntimeByHid(kn, buffID);
                if (rt == null || rt.remaining <= 0) {
                    const cfg = deps.dotTypes.find(c => c.id === typeId);
                    if (cfg != null && typeof cfg.onEnd === "function") {
                        const uref = v._dotUnitRef;
                        cfg.onEnd(uref != null ? uref : kn, v);
                    }
                    deps.notifyBuffPool(typeId, kn, null);
                    tabDeleteHid(tab, kn);
                    deps.removeDotTicksForTargetHid(typeId, kn);
                    continue;
                }
                v.remaining = rt.remaining;
                v.effect = rt.effect;
                if (rt.sourceName !== undefined)
                    v.sourceName = rt.sourceName;
                if (rt._dotParsedDuration !== undefined)
                    v._dotParsedDuration = rt._dotParsedDuration;
            }
        }
    }
    function clearDotByBuffPoolExpire(buffID, hid) {
        const typeId = dotTypeIdFromBuffId(buffID);
        if (typeId == null || hid === 0)
            return;
        const tab = deps.stateByType[typeId];
        if (tab == null)
            return;
        const v = tabRowForHid(tab, hid);
        if (v != null && isValidDotStateRow(v)) {
            const cfg = deps.dotTypes.find(c => c.id === typeId);
            if (cfg != null && typeof cfg.onEnd === "function") {
                const uref = v._dotUnitRef;
                cfg.onEnd(uref != null ? uref : hid, v);
            }
        }
        tabDeleteHid(tab, hid);
        deps.removeDotTicksForTargetHid(typeId, hid);
    }
    return {
        syncDotRemainingFromBuffPool,
        clearDotByBuffPoolExpire,
    };
}
