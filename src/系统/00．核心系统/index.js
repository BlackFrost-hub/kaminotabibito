/**
 * 核心系统 - 统一导出和初始化入口
 *
 * 说明：
 * - 封装函数已迁移到 lib/扩展函数/封装函数/
 * - 这里仅保留 颜色常量、硬件函数 和 UI函数
 * - 治疗事件已迁移到 04．伤害系统/02．治疗系统/
 */
// ========== 从封装函数重新导出 ==========
require("系统.00．核心系统.08．同步随机种子");
export * from "../../lib/扩展函数/封装函数/index";
// ========== 核心模块导出 ==========
export * from "./01．颜色常量";
export * from "./03．UI函数";
export * from "./01．事件中心/index";
export * from "./05．中心计时器";
export * from "./06．特效绑定系统";
const centerTimer = require("系统.00．核心系统.05．中心计时器");
function expose(name, fn) {
    if (typeof fn !== "function")
        return;
    const g = globalThis;
    if (typeof g[name] === "function")
        return;
    g[name] = fn;
}
function registerCoreGlobals() {
    expose("getServerTime", centerTimer.getServerTime);
    expose("getTime", centerTimer.getTime);
    expose("getGameTime", centerTimer.getGameTime);
    expose("getGameElapsedTime", centerTimer.getGameElapsedTime);
    expose("getGameTimeHMS", centerTimer.getGameTimeHMS);
    expose("getGameTimeFormatted", centerTimer.getGameTimeFormatted);
    expose("getGameTimeString", centerTimer.getGameTimeString);
    expose("getGameTimeStringWithMs", centerTimer.getGameTimeStringWithMs);
    expose("getDateTimeString", centerTimer.getDateTimeString);
    expose("getDateTimeStringWithMs", centerTimer.getDateTimeStringWithMs);
    expose("setGameDifficulty", centerTimer.setGameDifficulty);
    expose("getGameDifficulty", centerTimer.getGameDifficulty);
    expose("addPeriodicCallback", centerTimer.addPeriodicCallback);
    expose("removePeriodicCallback", centerTimer.removePeriodicCallback);
    expose("addDelayedCallback", centerTimer.addDelayedCallback);
    expose("removeDelayedCallback", centerTimer.removeDelayedCallback);
    expose("onSecond", centerTimer.onSecond);
    expose("offSecond", centerTimer.offSecond);
    expose("onTick10ms", centerTimer.onTick10ms);
    expose("offTick10ms", centerTimer.offTick10ms);
    expose("initCenterTimer", centerTimer.initCenterTimer);
}
// ========== 初始化 ==========
// 封装函数由 lib/扩展函数/index.ts 统一加载
// 这里仅加载核心系统特有的模块
require("系统.00．核心系统.01．颜色常量");
require("系统.00．核心系统.02．硬件函数");
require("系统.00．核心系统.02．功能开关.index");
require("系统.00．核心系统.03．UI函数");
require("系统.00．核心系统.01．事件中心.index");
// 中心计时器（自动初始化，顺带注册到全局桥接）
registerCoreGlobals();
// 特效绑定系统（API 纯函数，随 require 加载）
require("系统.00．核心系统.06．特效绑定系统");
// 玩家单位管理器
require("系统.00．核心系统.00．玩家系统.index");
/**
 * 初始化核心系统
 */
export function init() {
}
