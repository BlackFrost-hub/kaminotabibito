/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 内部工具
 */
const jass = require("jass.common");
const japi = require("jass.japi");
// -------------------- 内部工具：注入/查找 --------------------
/**
 * @deprecated 仅保留给历史兼容；新代码禁止用：TSTL 会对「取出再调」编成 f(nil,...) 导致 JAPI 参数错位。
 * 请改用 `const japi = require("jass.japi"); japi.DzXxx(...)` 直接点号调用。
 */
export function japiFn(name) {
    const f = japi[name];
    return typeof f === "function" ? f : null;
}
// -------------------- 存在性检查 --------------------
export function has(name) {
    return typeof japi[name] === "function";
}
export function isHardwareAPIAvailable() {
    return true;
}
export function createTriggerOrNull() {
    return jass.CreateTrigger();
}
/**
 * `sync=false` 的底层注册在本项目环境里必须先包一层本地玩家判断。
 *
 * - 传 `playerId`：只对该本地玩家执行注册
 * - 不传 `playerId`：任意本地玩家都执行注册
 */
export function runFalseLocalRegistration(register, playerId) {
    const lp = jass.GetLocalPlayer();
    if (lp == null)
        return;
    if (playerId != null && jass.GetPlayerId(lp) !== playerId)
        return;
    register();
}
