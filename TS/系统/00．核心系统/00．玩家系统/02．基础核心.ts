/** @noSelfInFile */
/**
 * 玩家单位管理器 - 基础核心
 * 职责：
 * - 向中心计时器注册周期tick（每10ms）
 * - 按间隔调用各功能同步（如移速龙卷特效）
 * 接入：由index.ts在启动时require并调用initPlayerUnitManager()
 */

const { onTick10ms } = globalThis as unknown as {
  onTick10ms: (this: void, callback: () => void) => void;
};

const C = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("./00．常量");

const heroLinkage = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.index") as {
  syncTornadoSpeedEffectsByRegisteredHeroes: () => void;
  initPlayerHeroGetBridge: () => void;
  initPetItemHandoff: () => void;
};

let _inited = false;
let _tickCounter = 0;

function runAllFeatureSyncs(): void {
  if (typeof heroLinkage.syncTornadoSpeedEffectsByRegisteredHeroes === "function") {
    heroLinkage.syncTornadoSpeedEffectsByRegisteredHeroes();
  }
}

function onPlayerUnitManagerTick(this: void): void {
  _tickCounter++;
  if (_tickCounter >= C.EXEC_EVERY_TICKS) {
    _tickCounter = 0;
    runAllFeatureSyncs();
  }
}

export function initPlayerUnitManager(): void {
  if (_inited) return;
  _inited = true;

  if (typeof heroLinkage.initPetItemHandoff === "function") {
    heroLinkage.initPetItemHandoff();
  }
  if (typeof heroLinkage.initPlayerHeroGetBridge === "function") {
    heroLinkage.initPlayerHeroGetBridge();
  }

  onTick10ms(onPlayerUnitManagerTick);
}

export {};
