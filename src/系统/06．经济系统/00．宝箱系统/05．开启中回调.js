/** @noSelfInFile */
const callbacks = [];
export function 注册宝箱开启中回调(callback) {
    callbacks.push(callback);
}
export function 触发宝箱开启中回调(unit, target, progressBar, openTime, elapsed, chestConfig, ownerUnit) {
    for (const callback of callbacks) {
        callback(unit, target, progressBar, openTime, elapsed, chestConfig, ownerUnit);
    }
}
