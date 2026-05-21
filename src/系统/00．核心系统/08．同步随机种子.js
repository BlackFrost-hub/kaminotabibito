/** @noSelfInFile */
/**
 * 同步随机种子
 *
 * 只在地图启动时设置一次 JASS 随机种子，避免每局都从同一条随机序列开头开始。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const CreateTimer = jass.CreateTimer;
const DestroyTimer = jass.DestroyTimer;
const TimerStart = jass.TimerStart;
const SetRandomSeed = jass.SetRandomSeed;
const R2I = jass.R2I;
const DzAPI_Map_GetGameStartTime = japi.DzAPI_Map_GetGameStartTime;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const 调试模块 = "同步随机种子";
const 最大种子 = 2147483647;
const 最多等待日志次数 = 6;
let 已设置 = false;
let 重试计时器 = null;
let 等待日志次数 = 0;
function 输出日志(...args) {
    debugLogForce(调试模块, ...args);
}
function 取同步种子() {
    const startTime = DzAPI_Map_GetGameStartTime();
    if (startTime == null || startTime <= 0)
        return 0;
    let seed = R2I(startTime);
    if (seed <= 0)
        return 0;
    if (seed > 最大种子) {
        seed = seed % 最大种子;
    }
    return seed > 0 ? seed : 1;
}
function 销毁重试计时器() {
    if (!重试计时器)
        return;
    DestroyTimer(重试计时器);
    重试计时器 = null;
}
function 尝试设置同步随机种子() {
    if (已设置)
        return true;
    const seed = 取同步种子();
    if (seed <= 0) {
        if (等待日志次数 < 最多等待日志次数) {
            等待日志次数++;
            输出日志("等待有效启动时间", "第", 等待日志次数, "次");
        }
        return false;
    }
    SetRandomSeed(seed);
    已设置 = true;
    销毁重试计时器();
    输出日志("已设置", "seed=", seed);
    return true;
}
function on同步随机种子重试() {
    尝试设置同步随机种子();
}
function 启动同步随机种子() {
    if (尝试设置同步随机种子())
        return;
    if (重试计时器)
        return;
    重试计时器 = CreateTimer();
    TimerStart(重试计时器, 0.10, true, on同步随机种子重试);
}
启动同步随机种子();
export {};
