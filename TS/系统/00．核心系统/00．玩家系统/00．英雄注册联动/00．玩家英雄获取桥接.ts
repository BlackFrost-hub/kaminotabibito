/** @noSelfInFile */
/**
 * 玩家系统 - 英雄注册联动 - 玩家英雄获取桥接
 *
 * JASS 侧：
 * - 传参：YDLocal5Set(unit, "英雄", someHero)
 * - 触发：STES_Fire("玩家英雄注册")
 *
 * Lua 侧职责：
 * - 从传入单位中筛选玩家 1-5 操作的英雄
 * - 写入 YDUserData("player", whichPlayer, "英雄", "unit")
 * - 在拿到英雄时，把英雄注册到各个依赖它的联动模块
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => { id: number };
};

const C = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("../00．常量");

const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
  YDUserDataSet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string, value: any) => void;
};

const { YDLocal5Get } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Get: (ty: string, name: string) => any;
};

const helper = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (_self: any) => void;
  ydlStes_finishChildCleanup: (_self: any) => void;
  ydlStes_skeyIndex: (_self: any) => number;
  ydlStes_registerAfterGetTable: (_self: any, trig: any, eventName: string) => void;
};

const moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.01．移速龙卷特效") as {
  registerMoveSpeedTornadoHero: (whichHero: any) => void;
};

const outOfCombat = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.02．脱战计时") as {
  initOutOfCombat: () => void;
};

const petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.03．背包满移交宠物") as {
  registerPetItemHandoffHero: (whichHero: any) => void;
};

const chestSystem = require("系统.06．经济系统.00．宝箱系统.02．事件注册") as {
  registerChestSystemHero: (whichHero: any) => void;
};

const dynamicSkillText = require("系统.03．技能系统.07．动态技能文本.index") as {
  registerDynamicSkillTextHero: (this: void, whichHero: any) => void;
};

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

const REG_GUARD = "__syzl_playerHeroRegister_registered";
const TRIG_KEY = "__syzl_playerHeroRegister_trig";
const ATTEMPT_KEY = "__syzl_playerHeroRegister_attempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_SEC = 0.1;

function jassStesHashtable(): any {
  const candidates = [jglobals.STES___HT, jglobals.STES_HT, jglobals.udg_STES___HT, jglobals.udg_STES_HT];
  for (let i = 0; i < candidates.length; i++) {
    const table = candidates[i];
    if (table != null && table !== 0) return table;
  }
  return null;
}

function countOnJassStesTable(eventName: string): number {
  const ht = jassStesHashtable();
  if (ht == null || ht === 0) return -1;
  return jass.LoadInteger(ht, jass.StringHash(eventName), helper.ydlStes_skeyIndex(undefined));
}

/**
 * 只接受玩家 1-5 当前操作的英雄，且排除电脑玩家。
 * 这里是整条"英雄注册联动"链路的第一层筛选。
 */
function isPlayableHero(whichUnit: any): boolean {
  if (whichUnit == null || whichUnit === 0) return false;
  if (jass.IsUnitType(whichUnit, jass.UNIT_TYPE_HERO) !== true) return false;

  const owner = jass.GetOwningPlayer(whichUnit);
  if (owner == null || owner === 0) return false;

  if (jass.GetPlayerController(owner) === jass.MAP_CONTROL_COMPUTER) return false;

  const playerId = (jass.GetPlayerId(owner) as number) || -1;
  return playerId >= 0 && playerId <= 4;
}

function invokeUiAttrOnPlayerHeroRegistered(whichPlayer: any, whichHero: any): void {
  const mod = require("系统.09．表现系统.03．UI属性系统.02．面板渲染") as {
    onPlayerHeroRegistered?: (this: void, w: any, h: any) => void;
  };
  const cb = mod.onPlayerHeroRegistered;
  if (typeof cb !== "function") return;
  cb(whichPlayer, whichHero);
}

const uiRegisteredPlayers = new Set<number>();

const dialogSystem = require("系统.09．表现系统.02．对话框系统.00．对话框渲染核心") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

const buffUISystem = require("系统.05．Buff系统.02．BuffUI") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

const taskUISystem = require("系统.08．任务系统.02．任务UI拆分.11．任务UI管理器") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => boolean;
};
const threatPanelSystem = require("系统.09．表现系统.05．仇恨面板.index") as {
  onPlayerHeroRegistered?: (this: void, whichPlayer: any, whichHero: any) => void;
};

const selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  initPlayerSelectionCenter?: (this: void, whichPlayer: any) => void;
  seedSoleSelectedUnitForPlayer?: (this: void, whichPlayer: any, whichUnit: any) => void;
};
const initPlayerSelectionCenter = selectionCenterSystem.initPlayerSelectionCenter as
  | ((this: void, whichPlayer: any) => void)
  | undefined;
const seedSoleSelectedUnitForPlayer = selectionCenterSystem.seedSoleSelectedUnitForPlayer as
  | ((this: void, whichPlayer: any, whichUnit: any) => void)
  | undefined;

function invokeSelectionCenterInit(whichPlayer: any): void {
  if (typeof initPlayerSelectionCenter !== "function") return;
  initPlayerSelectionCenter(whichPlayer);
}

function invokeSelectionCenterSeed(whichPlayer: any, whichUnit: any): void {
  if (typeof seedSoleSelectedUnitForPlayer !== "function") return;
  seedSoleSelectedUnitForPlayer(whichPlayer, whichUnit);
}

function registerHeroDependents(whichHero: any): void {
  if (typeof moveTornado.registerMoveSpeedTornadoHero === "function") {
    moveTornado.registerMoveSpeedTornadoHero(whichHero);
  }
  if (typeof petItemHandoff.registerPetItemHandoffHero === "function") {
    petItemHandoff.registerPetItemHandoffHero(whichHero);
  }
  if (typeof chestSystem.registerChestSystemHero === "function") {
    chestSystem.registerChestSystemHero(whichHero);
  }
  if (typeof dynamicSkillText.registerDynamicSkillTextHero === "function") {
    dynamicSkillText.registerDynamicSkillTextHero(whichHero);
  }
  const owner = jass.GetOwningPlayer(whichHero);
  if (owner != null && owner !== 0) {
    const playerId = jass.GetPlayerId(owner);
    debugLog("Bridge", "registerHeroDependents pid=" + playerId + " has=" + uiRegisteredPlayers.has(playerId));

    invokeSelectionCenterInit(owner);
    invokeSelectionCenterSeed(owner, whichHero);

    if (!uiRegisteredPlayers.has(playerId)) {
      let taskUiReady = true;

      invokeUiAttrOnPlayerHeroRegistered(owner, whichHero);

      if (typeof dialogSystem.onPlayerHeroRegistered === "function") {
        dialogSystem.onPlayerHeroRegistered(owner, whichHero);
      }

      if (typeof buffUISystem.onPlayerHeroRegistered === "function") {
        buffUISystem.onPlayerHeroRegistered(owner, whichHero);
      }

      if (typeof taskUISystem.onPlayerHeroRegistered === "function") {
        taskUiReady = taskUISystem.onPlayerHeroRegistered(owner, whichHero) === true;
      }

      if (typeof threatPanelSystem.onPlayerHeroRegistered === "function") {
        threatPanelSystem.onPlayerHeroRegistered(owner, whichHero);
      }

      if (taskUiReady) {
        uiRegisteredPlayers.add(playerId);
      }
    }
  }
}

function registerPlayerHero(whichPlayer: any, whichHero: any): void {
  if (whichPlayer == null || whichPlayer === 0 || whichHero == null || whichHero === 0) return;
  YDUserDataSet("player", whichPlayer, C.YD_ATTR_PLAYER_HERO_UNIT, "unit", whichHero);
  registerHeroDependents(whichHero);
}

export function getRegisteredPlayerHero(this: void, whichPlayer: any): any {
  if (whichPlayer == null || whichPlayer === 0) return null;
  return YDUserDataGet("player", whichPlayer, C.YD_ATTR_PLAYER_HERO_UNIT, "unit");
}

function registerSingleHero(whichHero: any): void {
  if (!isPlayableHero(whichHero)) return;

  const owner = jass.GetOwningPlayer(whichHero);
  if (owner == null || owner === 0) return;
  registerPlayerHero(owner, whichHero);
}

function runRegisterPlayerHero(): void {
  helper.ydlStes_syncTriggerStep(undefined);
  try {
    registerSingleHero(YDLocal5Get("unit", C.STES_PARAM_HERO_UNIT));
  } finally {
    helper.ydlStes_finishChildCleanup(undefined);
  }
}

function runRegisterPlayerHeroTriggerAction(): void {
  runRegisterPlayerHero();
}

function scheduleRetry(fn: () => void): void {
  createDelayedCall(RETRY_SEC, fn);
}

function tryRegisterPlayerHeroStes(): void {
  const g = globalThis as any;
  if (g[REG_GUARD]) return;

  if (g[TRIG_KEY] == null) {
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, runRegisterPlayerHeroTriggerAction);
    g[TRIG_KEY] = trig;
  }

  helper.ydlStes_registerAfterGetTable(undefined, g[TRIG_KEY], C.STES_EVENT_REGISTER_PLAYER_HERO);

  const count = countOnJassStesTable(C.STES_EVENT_REGISTER_PLAYER_HERO);
  const attempt = ((g[ATTEMPT_KEY] as number) || 0) + 1;
  g[ATTEMPT_KEY] = attempt;

  if (count >= 1 || attempt >= MAX_REG_ATTEMPTS) {
    g[REG_GUARD] = true;
    return;
  }

  scheduleRetry(() => {
    tryRegisterPlayerHeroStes();
  });
}

export function initPlayerHeroGetBridge(): void {
  if (typeof outOfCombat.initOutOfCombat === "function") {
    outOfCombat.initOutOfCombat();
  }
  tryRegisterPlayerHeroStes();
}

export {};
