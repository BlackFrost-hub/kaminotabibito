const _print = globalThis.print;
const DEBUG_FLAGS = {};
export function setDebug(module, on) {
    DEBUG_FLAGS[module] = on;
}
export function isDebug(module) {
    return DEBUG_FLAGS[module] === true;
}
export function debugLog(module, ...args) {
    if (!isDebug(module))
        return;
    if (!_print)
        return;
    const prefix = "[" + module + "] ";
    _print(prefix, ...args);
}
export function debugLogForce(module, ...args) {
    if (!_print)
        return;
    const prefix = "[" + module + "] ";
    _print(prefix, ...args);
}
