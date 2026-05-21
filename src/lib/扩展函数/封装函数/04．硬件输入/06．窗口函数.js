/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 窗口函数
 *
 * 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
 */
const japi = require("jass.japi");
// -------------------- 窗口 --------------------
export function getWindowWidth() {
    return japi.DzGetWindowWidth();
}
export function getWindowHeight() {
    return japi.DzGetWindowHeight();
}
export function getWindowX() {
    return japi.DzGetWindowX();
}
export function getWindowY() {
    return japi.DzGetWindowY();
}
export function isWindowActive() {
    return !!japi.DzIsWindowActive();
}
export function getClientHeight() {
    return japi.DzGetClientHeight?.() || 0;
}
