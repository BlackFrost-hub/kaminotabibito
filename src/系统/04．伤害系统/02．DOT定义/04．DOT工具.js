const jass = require("jass.common");
// ========== 虚拟分区：HandleId ==========
/** Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。 */
export function unitHid(u) {
    if (u == null || u === 0)
        return 0;
    if (typeof jass.GetHandleId !== "function")
        return 0;
    return jass.GetHandleId(u);
}
// ========== 虚拟分区：Hid 表读写 ==========
/** pairs 迭代可能混用 number / string 键，不合并会导致「同目标两行状态」或 onDamage 读不到 cur、乘积误判。 */
export function tabRowForHid(tab, hid) {
    if (hid === 0)
        return null;
    const n = tab[hid];
    if (n != null)
        return n;
    return tab[`${hid}`];
}
export function tabSetHid(tab, hid, state) {
    if (hid === 0)
        return;
    delete tab[`${hid}`];
    tab[hid] = state;
}
export function tabDeleteHid(tab, hid) {
    if (hid === 0)
        return;
    delete tab[hid];
    delete tab[`${hid}`];
}
export function collectHidsInTab(tab) {
    const seen = {};
    const out = [];
    for (const k in tab) {
        const kn = typeof k === "number" ? k : parseInt(`${k}`, 10);
        if (isNaN(kn) || kn === 0)
            continue;
        if (seen[kn])
            continue;
        seen[kn] = true;
        out.push(kn);
    }
    return out;
}
// ========== 虚拟分区：DotState 校验/展示 ==========
/** stateByType 槽位应为 DotState 表；若被污染为数字等则剔除，避免 cur.remaining 报错 */
export function isValidDotStateRow(v) {
    return v != null && typeof v === "object" && typeof v.remaining === "number" && typeof v.effect === "number";
}
export function getDotSourceDisplayName(u) {
    if (u == null || u === 0)
        return "未知";
    if (typeof jass.GetUnitName === "function") {
        const n = jass.GetUnitName(u);
        if (n !== undefined && n !== null && `${n}` !== "")
            return `${n}`;
    }
    return "未知";
}
