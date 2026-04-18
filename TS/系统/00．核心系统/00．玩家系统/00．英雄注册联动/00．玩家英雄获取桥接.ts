/**
 * 玩家系统 - 英雄注册联动 - 玩家英雄获取桥接
 *
 * JASS 侧：
 * - 传参：YDLocal5Set(group, "dwz", someGroup)
 * - 触发：STES_Fire("玩家英雄注册")
 *
 * Lua 侧职责：
 * - 从传入单位组中筛选玩家 1-5 操作的英雄
 * - 写入 YDUserData("player", whichPlayer, "英雄", "unit")
 * - 在拿到英雄时，把英雄注册到各个依赖它的联动模块
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const C = require("系统.00．核心系统.00．玩家系统.00．常量") as typeof import("../00．常量");

const { YDUserDataSet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
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

const moveTornado = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．移速龙卷特效") as {
  registerMoveSpeedTornadoHero: (whichHero: any) => void;
};

const petItemHandoff = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.02．背包满移交宠物") as {
  registerPetItemHandoffHero: (whichHero: any) => void;
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
  if (typeof jass.StringHash !== "function" || typeof jass.LoadInteger !== "function") return -1;
  return jass.LoadInteger(ht, jass.StringHash(eventName), helper.ydlStes_skeyIndex(undefined));
}

/**
 * 只接受玩家 1-5 当前操作的英雄。
 * 这里是整条“英雄注册联动”链路的第一层筛选。
 */
function isPlayableHero(whichUnit: any): boolean {
  if (whichUnit == null || whichUnit === 0) return false;
  if (typeof jass.IsUnitType !== "function" || typeof jass.GetOwningPlayer !== "function" || typeof jass.GetPlayerId !== "function") return false;
  if (jass.IsUnitType(whichUnit, jass.UNIT_TYPE_HERO) !== true) return false;

  const owner = jass.GetOwningPlayer(whichUnit);
  if (owner == null || owner === 0) return false;

  const playerId = (jass.GetPlayerId(owner) as number) || -1;
  return playerId >= 0 && playerId <= 4;
}

/**
 * 在英雄登记完成后，把它继续分发给依赖英雄注册结果的子模块。
 */
function registerHeroDependents(whichHero: any): void {
  if (typeof moveTornado.registerMoveSpeedTornadoHero === "function") {
    moveTornado.registerMoveSpeedTornadoHero(whichHero);
  }
  if (typeof petItemHandoff.registerPetItemHandoffHero === "function") {
    petItemHandoff.registerPetItemHandoffHero(whichHero);
  }
}

/**
 * 为单个玩家登记英雄：
 * 1. 写入玩家侧 YDUserData
 * 2. 触发后续联动模块注册
 */
function registerPlayerHero(whichPlayer: any, whichHero: any): void {
  if (whichPlayer == null || whichPlayer === 0 || whichHero == null || whichHero === 0) return;
  YDUserDataSet("player", whichPlayer, C.YD_ATTR_PLAYER_HERO_UNIT, "unit", whichHero);
  registerHeroDependents(whichHero);
}

/**
 * 从 JASS 传入的单位组里找出玩家 1-5 的英雄，并逐个完成登记。
 */
function registerHeroesFromGroup(heroGroup: any): void {
  if (heroGroup == null || heroGroup === 0) return;
  if (typeof jass.ForGroup !== "function" || typeof jass.GetEnumUnit !== "function") return;
  if (typeof jass.GetOwningPlayer !== "function" || typeof jass.GetPlayerId !== "function" || typeof jass.Player !== "function") return;

  const heroByPlayer: Record<number, any> = {};

  jass.ForGroup(heroGroup, () => {
    const whichUnit = jass.GetEnumUnit();
    if (!isPlayableHero(whichUnit)) return;

    const owner = jass.GetOwningPlayer(whichUnit);
    const playerId = (jass.GetPlayerId(owner) as number) || -1;
    if (playerId < 0 || playerId > 4) return;
    if (heroByPlayer[playerId] == null) heroByPlayer[playerId] = whichUnit;
  });

  for (let playerId = 0; playerId <= 4; playerId++) {
    const hero = heroByPlayer[playerId];
    if (hero == null) continue;
    registerPlayerHero(jass.Player(playerId), hero);
  }
}

/**
 * STES 子触发真正执行的核心入口。
 */
function runRegisterPlayerHero(): void {
  helper.ydlStes_syncTriggerStep(undefined);
  try {
    registerHeroesFromGroup(YDLocal5Get("group", C.STES_PARAM_HERO_GROUP));
  } finally {
    helper.ydlStes_finishChildCleanup(undefined);
  }
}

/**
 * 由于 STES 表绑定时机可能晚于 Lua 模块加载，这里用短延迟重试注册。
 */
function scheduleRetry(fn: () => void): void {
  if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function") {
    fn();
    return;
  }

  const timer = jass.CreateTimer();
  jass.TimerStart(timer, RETRY_SEC, false, () => {
    if (typeof jass.DestroyTimer === "function") jass.DestroyTimer(timer);
    fn();
  });
}

/**
 * 向 JASS 侧 STES 表注册“玩家英雄注册”监听。
 */
function tryRegisterPlayerHeroStes(): void {
  const g = globalThis as any;
  if (g[REG_GUARD]) return;

  if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") {
    g[REG_GUARD] = true;
    return;
  }

  if (g[TRIG_KEY] == null) {
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, () => {
      runRegisterPlayerHero();
    });
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

/**
 * 玩家系统初始化时调用，建立 JASS -> Lua 的玩家英雄注册桥接。
 */
export function initPlayerHeroGetBridge(): void {
  tryRegisterPlayerHeroStes();
}

export {};
