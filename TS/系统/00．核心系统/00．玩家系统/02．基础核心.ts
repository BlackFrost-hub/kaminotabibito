/**
 * 玩家单位管理器 — 基础核心
 *
 * 职责：
 * - 向 `中心计时器` 注册周期 tick
 * - 按顺序调用各「功能」模块的同步入口（后续在此追加更多 sync 即可）
 *
 * 关于 `require` vs 全局：
 * - 若已通过 `00．全局桥接` / `registerBridge` 把 `YDUserDataGet`、`ForGroupBJ` 等挂到 Lua `_G`，
 *   理论上可写 `(globalThis as any).YDUserDataGet(...)`，但会依赖**加载顺序**与**名字是否与桥接一致**。
 * - 推荐仍用 `require("lib...")` / `require("系统...")`：模块边界清晰、IDE 可跳转、且不赌谁先执行。
 */

const { onTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (callback: () => void) => void;
};

const C = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("./00．常量");

const moveFx = require("系统.00．核心系统.00．玩家系统.03．移速龙卷特效") as {
  syncTornadoSpeedEffectsByHeroGroup: () => void;
};

let _inited = false;
let _tickCounter = 0;

function runAllFeatureSyncs(): void {
  if (typeof moveFx.syncTornadoSpeedEffectsByHeroGroup === "function") {
    moveFx.syncTornadoSpeedEffectsByHeroGroup();
  }
}

export function initPlayerUnitManager(): void {
  if (_inited) return;
  _inited = true;

  onTick10ms(() => {
    _tickCounter++;
    if (_tickCounter >= C.EXEC_EVERY_TICKS) {
      _tickCounter = 0;
      runAllFeatureSyncs();
    }
  });
}

export {};
