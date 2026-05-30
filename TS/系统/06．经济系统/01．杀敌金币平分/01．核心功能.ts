/** @noSelfInFile */
/**
 * 杀敌金币平分系统 - 核心功能
 *
 * 功能：
 * 1. 击杀者获得金币
 * 2. 范围内友方英雄平分40%金币
 * 3. 播放金币音效、显示漂浮文字
 *
 * 触发条件：死亡单位属于中立敌对(玩家12)或玩家8(粉色)
 */

const jass = require("jass.common") as any;

const { SHARE_RANGE } = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义") as typeof import("./00．常量定义");

const { getObjectPropertyInteger } = require("lib.扩展函数.YDWE函数.index") as {
  getObjectPropertyInteger: (objectType: number, objectId: number | string, property: string) => number;
};

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const { AdjustPlayerStateBJ } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  AdjustPlayerStateBJ: (delta: number, whichPlayer: any, whichPlayerState: any) => void;
};

const { Sound3DII_Mp3PlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_Mp3PlayReuse: (this: void, path: string, player?: any) => void;
};

const 漂浮文字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
};
const CreateFloatTextOnUnit = 漂浮文字模块.CreateFloatTextOnUnit as
  | ((this: void, unit: any, text: string, options?: any) => any)
  | undefined;

const { getUnitOwnerId } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  getUnitOwnerId: (unit: any) => number;
};

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

// ==========================================================================================
// 常量
// ==========================================================================================

const SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav";
const GOLD_R = 255;
const GOLD_G = 215;
const GOLD_B = 0;
const GOLD_FLOAT_DURATION_SEC = 1.25;

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 金币获取回调参数 */
export interface GoldGainParams {
  /** 获得金币的单位 */
  unit: any;
  /** 玩家 */
  player: any;
  /** 基础金币 */
  baseGold: number;
  /** 是否为平分金币 */
  isShared: boolean;
  /** 最终金币（由前一个回调设置） */
  finalGold?: number;
}

/** 金币获取回调 */
export type GoldGainCallback = (params: GoldGainParams) => GoldGainParams | void;

// ==========================================================================================
// 数据存储
// ==========================================================================================

/** 金币获取回调列表 */
const goldGainCallbacks: GoldGainCallback[] = [];

// ==========================================================================================
// 工具函数
// ==========================================================================================

/** 获取单位赏金 */
function getUnitBounty(this: void, unitType: number): number {
  return getObjectPropertyInteger(2, unitType, "bountyplus");
}

/** 检查单位是否为玩家英雄 */
function isPlayerHero(this: void, unit: any): boolean {
  const heroGroup = YDUserDataGet("string", "玩家英雄", "单位组", "group");
  if (!heroGroup || !unit) return false;
  return jass.IsUnitInGroup(unit, heroGroup) === true;
}

/** 获取英雄单位组 */
function getHeroGroup(this: void): any {
  return YDUserDataGet("string", "玩家英雄", "单位组", "group");
}

/** 检查死亡单位是否触发金币平分（中立敌对或玩家8） */
function isValidDyingUnit(this: void, dyingUnit: any): boolean {
  const playerId = getUnitOwnerId(dyingUnit);
  // 玩家12(中立敌对) 或 玩家8(粉色，实际索引为7)
  return playerId === 12 || playerId === 7;
}

// ==========================================================================================
// 金币给予与反馈
// ==========================================================================================

/**
 * 给予玩家金币（带音效和漂浮文字）
 */
function giveGoldToPlayer(this: void, unit: any, player: any, baseGold: number, isShared: boolean): void {
  let params: GoldGainParams = { unit, player, baseGold, isShared };

  // 通知回调，让回调决定最终金币
  for (const cb of goldGainCallbacks) {
    const pcallResult = (pcall as any)(cb, params);
    const success = pcallResult[0];
    const result = pcallResult[1];
    if (success && result != null) {
      params = result;
    }
  }

  const finalGold = params.finalGold ?? baseGold;

  // 给予金币
  AdjustPlayerStateBJ(finalGold, player, jass.PLAYER_STATE_RESOURCE_GOLD);

  // 播放金币音效（函数内部有本地玩家判断）
  Sound3DII_Mp3PlayReuse(SOUND_GOLD, player);

  // 显示漂浮文字
  const text = "+" + finalGold;
  if (typeof CreateFloatTextOnUnit === "function") {
    CreateFloatTextOnUnit(unit, text, {
      size: 12,
      red: GOLD_R,
      green: GOLD_G,
      blue: GOLD_B,
      alpha: 0,
      duration: GOLD_FLOAT_DURATION_SEC,
    });
  }
}

// ==========================================================================================
// 核心逻辑
// ==========================================================================================

/**
 * 处理单位死亡事件
 */
function onUnitDeathHandler(this: void, dyingUnit: any, killer: any): void {
  // 检查死亡单位是否有效
  if (!isValidDyingUnit(dyingUnit)) return;

  // 获取死亡单位赏金
  const dyingUnitType = jass.GetUnitTypeId(dyingUnit);
  if (!dyingUnitType) return;

  const baseBounty = getUnitBounty(dyingUnitType);
  if (baseBounty <= 0) return;

  // 击杀者获得金币
  if (killer != null) {
    const killerPlayer = jass.GetOwningPlayer(killer);
    if (killerPlayer != null) {
      giveGoldToPlayer(killer, killerPlayer, baseBounty, false);
    }
  }

  // 检查击杀者是否为玩家英雄（触发平分）
  if (!isPlayerHero(killer)) return;

  // 计算平分金币（基础赏金的40%）
  const shareGold = jass.R2I(baseBounty / 10) * 4;
  if (shareGold <= 0) return;

  // 获取范围内友方英雄
  const dyingX = jass.GetUnitX(dyingUnit) ?? 0;
  const dyingY = jass.GetUnitY(dyingUnit) ?? 0;
  const killerPlayer = jass.GetOwningPlayer(killer);
  const heroGroup = getHeroGroup();

  if (killerPlayer == null || heroGroup == null) return;

  // 遍历玩家英雄
  const heroCount = jass.BlzGroupGetSize(heroGroup) ?? 0;
  for (let i = 0; i < heroCount; i++) {
    const hero = jass.BlzGroupUnitAt(heroGroup, i);
    if (!hero) continue;

    // 跳过击杀者自己
    if (hero === killer) continue;

    // 检查是否为友方
    if (jass.IsUnitAlly(hero, killerPlayer) !== true) continue;

    // 检查是否在范围内
    const heroX = jass.GetUnitX(hero) ?? 0;
    const heroY = jass.GetUnitY(hero) ?? 0;
    const dx = heroX - dyingX;
    const dy = heroY - dyingY;
    const dist = jass.SquareRoot(dx * dx + dy * dy);
    if (dist > SHARE_RANGE) continue;

    // 给予平分金币
    const heroPlayer = jass.GetOwningPlayer(hero);
    if (heroPlayer == null) continue;

    giveGoldToPlayer(hero, heroPlayer, shareGold, true);
  }
}

// ==========================================================================================
// 回调注册
// ==========================================================================================

/**
 * 注册金币获取回调
 * 回调可以返回更新后的params传递给下一个回调
 * @param cb 回调函数
 */
export function registerGoldGainCallback(cb: GoldGainCallback): void {
  goldGainCallbacks.push(cb);
}

// ==========================================================================================
// 初始化
// ==========================================================================================

let _initialized = false;

/**
 * 初始化杀敌金币平分系统
 */
export function initGoldShareSystem(this: void): void {
  if (_initialized) return;
  _initialized = true;

  registerDeathListener(onUnitDeathHandler);
}

// 自动初始化
initGoldShareSystem();

export {};
