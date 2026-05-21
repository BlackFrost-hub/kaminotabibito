/** @noSelfInFile */
const callbacks = [];
export function 注册宝箱准备开启回调(callback) {
    callbacks.push(callback);
}
export function 触发宝箱准备开启回调(unit, target, progressBar, openTime, chestConfig, ownerUnit) {
    for (const callback of callbacks) {
        callback(unit, target, progressBar, openTime, chestConfig, ownerUnit);
    }
}
