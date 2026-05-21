import { DOT_TYPE_TO_BUFF_ID, getBuffRuntimeByHid } from "../../05．Buff系统/00．Buff系统";
import { collectActiveDotPairs, deleteDotState, getDotState, ignoredTargetFlat, isValidDotStateRow, makeDotFlatKey, } from "./04．DOT工具";
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
    // 提取 deps 方法到局部变量，避免 TSTL 生成冒号调用
    const dotTypes = deps.dotTypes;
    const notifyBuffPool = deps.notifyBuffPool;
    const removeDotTicksForTargetHid = deps.removeDotTicksForTargetHid;
    function syncDotRemainingFromBuffPool() {
        // 使用 collectActiveDotPairs 获取排序后的活跃 DOT 对
        const pairs = collectActiveDotPairs();
        for (let pi = 0; pi < pairs.length; pi++) {
            const { typeId, hid } = pairs[pi];
            const buffID = DOT_TYPE_TO_BUFF_ID[typeId];
            if (buffID == null || buffID === "")
                continue;
            const state = getDotState(typeId, hid);
            if (state == null || !isValidDotStateRow(state)) {
                deleteDotState(typeId, hid);
                continue;
            }
            const rt = getBuffRuntimeByHid(hid, buffID);
            if (rt == null || rt.remaining <= 0) {
                const cfg = dotTypes.find(c => c.id === typeId);
                if (cfg != null && typeof cfg.onEnd === "function") {
                    const uref = state._dotUnitRef;
                    cfg.onEnd(uref != null ? uref : hid, state);
                }
                notifyBuffPool(typeId, hid, null);
                deleteDotState(typeId, hid);
                removeDotTicksForTargetHid(typeId, hid);
                // 清除忽略标记
                const key = makeDotFlatKey(typeId, hid);
                delete ignoredTargetFlat[key];
                continue;
            }
            // 同步 remaining 和 effect
            state.remaining = rt.remaining;
            state.effect = rt.effect;
            if (rt.sourceName !== undefined)
                state.sourceName = rt.sourceName;
            if (rt._dotParsedDuration !== undefined)
                state._dotParsedDuration = rt._dotParsedDuration;
            // 写回扁平存储
            const key = makeDotFlatKey(typeId, hid);
            ignoredTargetFlat[key] = true;
        }
    }
    function clearDotByBuffPoolExpire(buffID, hid) {
        const typeId = dotTypeIdFromBuffId(buffID);
        if (typeId == null || hid === 0)
            return;
        const state = getDotState(typeId, hid);
        if (state != null && isValidDotStateRow(state)) {
            const cfg = dotTypes.find(c => c.id === typeId);
            if (cfg != null && typeof cfg.onEnd === "function") {
                const uref = state._dotUnitRef;
                cfg.onEnd(uref != null ? uref : hid, state);
            }
        }
        deleteDotState(typeId, hid);
        // 清除忽略标记
        const key = makeDotFlatKey(typeId, hid);
        delete ignoredTargetFlat[key];
        removeDotTicksForTargetHid(typeId, hid);
    }
    return {
        syncDotRemainingFromBuffPool,
        clearDotByBuffPoolExpire,
    };
}
