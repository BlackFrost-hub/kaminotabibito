/**
 * 泄露审计 - 核心统计
 */
const jass = require("jass.common");
export const alive = {};
export const types = ["timer", "group", "trigger", "effect", "rect", "sound", "texttag"];
export const stats = {
    timer: { created: 0, destroyed: 0 },
    group: { created: 0, destroyed: 0 },
    trigger: { created: 0, destroyed: 0 },
    effect: { created: 0, destroyed: 0 },
    rect: { created: 0, destroyed: 0 },
    sound: { created: 0, destroyed: 0 },
    texttag: { created: 0, destroyed: 0 },
};
/**
 * Lua 里同一句柄可能以不同引用传入；用 leakType+稳定字符串 作键，避免 delete 对不上导致假 alive。
 * 禁止 `local j=jass; j.GetHandleId(h)`：TSTL 会编成 `j:GetHandleId(h)`，self 传成 jass 表会崩 → 只用 `(jass as any).GetHandleId(h)`。
 * CreateSound 等若返回 table 包装，GetHandleId 会报错 → 退回 tostring(handle) 作为稳定调试键。
 * 用 TS 的 typeof：Lua 里 table→__TS__TypeOf 为 "object"，userdata 为 "userdata"，不会误判。
 */
export function leakKey(leakType, handle) {
    if (handle == null)
        return `${leakType}:nil`;
    if (typeof handle === "object" && handle !== null) {
        return `${leakType}:obj:${tostring(handle)}`;
    }
    return `${leakType}:${jass.GetHandleId(handle)}`;
}
export function track(type, handle, tag) {
    if (!handle)
        return;
    const s = stats[type];
    s.created++;
    alive[leakKey(type, handle)] = { type, tag, createdIndex: s.created, handleText: tostring(handle) };
}
export function untrack(type, handle) {
    if (!handle)
        return;
    const s = stats[type];
    const key = leakKey(type, handle);
    if (alive[key] != null) {
        delete alive[key];
        s.destroyed++;
    }
}
