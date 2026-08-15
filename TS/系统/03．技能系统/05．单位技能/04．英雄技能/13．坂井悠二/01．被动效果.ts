/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";

const jass = require("jass.common") as any;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerPlayerHeroListener, getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (
    this: void,
    cb: (this: void, unit: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void,
    intervalSeconds?: number,
  ) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 单位存活, 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  读取单位攻击力: (this: void, unit: any) => number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const Player = jass.Player as (this: void, playerId: number) => any;

const 被动配置 = 坂井悠二技能配置.Q.被动;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const 已应用坂井悠二被动: Record<number, any | undefined> = {};

function 是坂井悠二(this: void, hero: any): boolean {
  return hero != null && hero !== 0 && GetUnitTypeId(hero) === 英雄单位类型ID;
}

function 清理坂井悠二被动状态(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  移除单位指定Buff(hero, 坂井悠二BuffID.D暗属性加成);
  移除单位指定Buff(hero, 坂井悠二BuffID.D期间状态);
}

function 更新坂井悠二被动状态(this: void, player: any, hero: any): void {
  if (player == null || player === 0) return;
  const playerId = (jass.GetPlayerId as (this: void, p: any) => number)(player);
  const prev = 已应用坂井悠二被动[playerId];
  if (prev === hero) return;
  if (prev != null && prev !== 0) 清理坂井悠二被动状态(prev);
  delete 已应用坂井悠二被动[playerId];
  if (!是坂井悠二(hero)) return;
  已应用坂井悠二被动[playerId] = hero;
}

function 初始化已有坂井悠二被动状态(this: void): void {
  for (let i = 0; i < 16; i++) {
    const player = Player(i);
    更新坂井悠二被动状态(player, getRegisteredPlayerHero(player));
  }
}

function 处理坂井悠二普通攻击额外伤害(
  this: void,
  target: any,
  damage: number,
  _damageType: number,
  _fromDotTickBatch?: boolean,
  source?: any,
  isNormalAttack?: boolean,
): void {
  if (source == null || source === 0) return;
  if (!单位存活(source)) return;
  if (!单位存活(target)) return;
  if (GetUnitTypeId(source) !== 英雄单位类型ID) return;
  if (!isNormalAttack) return;

  const 倍率 = 被动配置.攻击力倍率;
  if (倍率 <= 0) return;

  const 攻击力 = 读取单位攻击力(source);
  if (攻击力 <= 0) return;
  const 额外伤害 = 攻击力 * 倍率;
  if (额外伤害 <= 0) return;

  造成单体技能伤害({
    来源: source,
    目标: target,
    伤害: 额外伤害,
    伤害类型: jass.DAMAGE_TYPE_MAGIC,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "普攻强化",
    标签: "坂井悠二-Q被动-暗魔法伤害",
  });
  void damage;
}

function 处理坂井悠二死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!是坂井悠二(dyingUnit)) return;
  清理坂井悠二被动状态(dyingUnit);
}

export function 注册坂井悠二被动(this: void): void {
  registerPlayerHeroListener(更新坂井悠二被动状态);
  registerDeathListener(处理坂井悠二死亡);
  registerDamageCallback(处理坂井悠二普通攻击额外伤害);
  初始化已有坂井悠二被动状态();
}

注册坂井悠二被动();
