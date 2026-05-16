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

const moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.01．移速龙卷特效") as {
  syncTornadoSpeedEffectsByRegisteredHeroes?: (this: void) => void;
};
const heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  initPlayerHeroGetBridge?: (this: void) => void;
};
const petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.03．背包满移交宠物") as {
  initPetItemHandoff?: (this: void) => void;
  初始化宠物移交?: (this: void) => void;
};
const heroRevive = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.04．英雄复活系统") as {
  初始化英雄复活?: (this: void) => void;
};
const syncTornadoSpeedEffectsByRegisteredHeroes = moveTornado.syncTornadoSpeedEffectsByRegisteredHeroes;
const initPlayerHeroGetBridge = heroBridge.initPlayerHeroGetBridge;
const initPetItemHandoff = petItemHandoff.initPetItemHandoff ?? petItemHandoff.初始化宠物移交;

let _inited = false;
let _tickCounter = 0;

function runAllFeatureSyncs(): void {
  if (typeof syncTornadoSpeedEffectsByRegisteredHeroes === "function") {
    syncTornadoSpeedEffectsByRegisteredHeroes();
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

  if (typeof initPetItemHandoff === "function") {
    initPetItemHandoff();
  }
  if (typeof initPlayerHeroGetBridge === "function") {
    initPlayerHeroGetBridge();
  }
  if (typeof heroRevive.初始化英雄复活 === "function") {
    heroRevive.初始化英雄复活();
  }

  onTick10ms(onPlayerUnitManagerTick);
}

export {};
