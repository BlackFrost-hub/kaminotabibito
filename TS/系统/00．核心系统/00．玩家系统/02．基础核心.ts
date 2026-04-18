/**
 * 玩家单位管理器 - 基础核心
 *
 * 职责：
 * - 向 `中心计时器` 注册周期 tick
 * - 按顺序调用各功能模块的同步入口
 */

const { onTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (callback: () => void) => void;
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

export function initPlayerUnitManager(): void {
  if (_inited) return;
  _inited = true;

  if (typeof heroLinkage.initPetItemHandoff === "function") {
    heroLinkage.initPetItemHandoff();
  }
  if (typeof heroLinkage.initPlayerHeroGetBridge === "function") {
    heroLinkage.initPlayerHeroGetBridge();
  }

  onTick10ms(() => {
    _tickCounter++;
    if (_tickCounter >= C.EXEC_EVERY_TICKS) {
      _tickCounter = 0;
      runAllFeatureSyncs();
    }
  });
}

export {};
