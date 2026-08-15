/** @noSelfInFile */
// 塞拉斯 E 属性提升（A0JX）与 R 知识与旅行的学者（A0JY）。
// E 增伤已在 01．状态表 的「塞拉斯魔法技能增幅倍率」统一入口生效（元素魔法结算时读取）。
// R：智力加成按 A0JY 等级动态结算；魔法穿透与旅行经验待公共系统落地（见 00．配置 待查注释）。

import { 塞拉斯技能配置 } from "./00．配置";

const jass = require("jass.common") as any;

const { registerPlayerHeroListener, getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetHeroInt = jass.GetHeroInt as (this: void, hero: any, includeBonuses: boolean) => number;
const SetHeroInt = jass.SetHeroInt as (this: void, hero: any, value: number, permanent: boolean) => void;
const Player = jass.Player as (this: void, playerId: number) => any;

const 配置 = 塞拉斯技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const R类型ID = 配置.R.技能类型ID;
const 智力检查间隔毫秒 = 1000;

// 已施加的智力加成（英雄句柄ID -> 加成值），用于等级变化时差量调整
const 已施加智力加成: Record<number, number | undefined> = {};

function 取句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return (jass.GetHandleId as (this: void, h: any) => number)(unit) || 0;
}

function 计算R智力加成(this: void, 技能等级: number): number {
  if (技能等级 <= 0) return 0;
  const 低段 = 配置.R.智力;
  const 低段等级 = 技能等级 < 低段.低段上限等级 ? 技能等级 : 低段.低段上限等级;
  const 高段等级 = 技能等级 > 低段.低段上限等级 ? 技能等级 - 低段.低段上限等级 : 0;
  return 低段等级 * 低段.低段每级加值 + 高段等级 * 低段.高段每级加值;
}

function 同步R智力加成(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  if (GetUnitTypeId(hero) !== 英雄单位类型ID) return;
  const hid = 取句柄ID(hero);
  if (hid === 0) return;

  const 技能等级 = GetUnitAbilityLevel(hero, R类型ID);
  const 目标加成 = 计算R智力加成(技能等级);
  const 当前加成 = 已施加智力加成[hid] ?? 0;
  if (目标加成 === 当前加成) return;

  // 差量调整：永久= false（绿字加成），随记录回收
  SetHeroInt(hero, GetHeroInt(hero, true) - 当前加成 + 目标加成, false);
  已施加智力加成[hid] = 目标加成;
}

function R智力周期检查(this: void): void {
  for (let i = 0; i < 16; i++) {
    const player = Player(i);
    if (player == null || player === 0) continue;
    const hero = getRegisteredPlayerHero(player);
    if (hero == null || hero === 0) continue;
    同步R智力加成(hero);
  }
}

function R单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  const hid = 取句柄ID(dyingUnit);
  if (hid !== 0) delete 已施加智力加成[hid];
}

function 英雄替换时重算(this: void, _player: any, hero: any): void {
  同步R智力加成(hero);
}

export function 注册塞拉斯属性被动(this: void): void {
  registerPlayerHeroListener(英雄替换时重算);
  registerDeathListener(R单位死亡);
  addPeriodicCallback(智力检查间隔毫秒, R智力周期检查 as unknown as (this: void, variable?: any) => void);
}

注册塞拉斯属性被动();

export const 塞拉斯属性被动状态 = {
  已完成设计: true,
  已完成实现: true,
  E增伤: "由 01．状态表 塞拉斯魔法技能增幅倍率 统一入口生效，(10+3×A0JX等级)%",
  R智力: "等级1-10每级+8，11-15每级+15，周期差量结算",
  R魔法穿透: "待查：项目暂无魔法穿透接口，不生效",
  R旅行经验: "待查：项目暂无旅行经验公共系统，按迁移计划暂停该分支",
} as const;
