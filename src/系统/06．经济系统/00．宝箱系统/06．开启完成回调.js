/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const 调试模块 = "宝箱完成回调";
const callbacks = [];
function 安全执行回调(callback, unit, target, progressBar, openTime, chestConfig, ownerUnit) {
    try {
        callback(unit, target, progressBar, openTime, chestConfig, ownerUnit);
    }
    catch (err) {
        debugLogForce(调试模块, "回调执行失败", "err=", err);
    }
}
export function 注册宝箱开启完成回调(callback) {
    if (typeof callback !== "function")
        return;
    callbacks.push(callback);
}
export function 触发宝箱开启完成回调(unit, target, progressBar, openTime, chestConfig, ownerUnit) {
    if (callbacks.length === 0)
        return;
    const current = callbacks.slice();
    for (let i = 0; i < current.length; i++) {
        安全执行回调(current[i], unit, target, progressBar, openTime, chestConfig, ownerUnit);
    }
}
