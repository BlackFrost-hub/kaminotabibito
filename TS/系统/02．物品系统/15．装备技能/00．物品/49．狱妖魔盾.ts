/** @noSelfInFile */

const { 快照单位组 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.07．单位组工具") as {
  快照单位组: (this: void, group: any) => any[];
};
const { 获取玩家英雄单位组 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
};
const { 开始护盾, 护盾类型, 查询单位标签护盾值, 充能单位标签护盾, 移除单位标签护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number };
  查询单位标签护盾值: (this: void, unit: any, tag: string) => number;
  充能单位标签护盾: (this: void, unit: any, tag: string, amount: number, maxValue: number, params?: any) => number;
  移除单位标签护盾: (this: void, unit: any, tag: string) => void;
};
const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
    获取回调?: (this: void, unit: any, currentCount: number) => void;
    丢弃回调?: (this: void, unit: any, currentCount: number) => void;
    初始单位列表?: (this: void) => any[];
  }) => void;
};

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示, 设置物品CD } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import {
  是否为使用物品,
  单位持有物品,
  单位是英雄,
  单位存活,
  取当前生命,
  取单位X,
  取单位Y,
  取最大生命,
  获取范围敌人,
  造成强化伤害,
  施加眩晕,
  击退远离来源,
} from "../05．物品使用/00．公共/02．物品使用工具";
const { 减少生命值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, 最低保留生命?: number) => number;
};

const 狱妖魔盾配置 = 物品使用数值配置.狱妖魔盾;
const 狱妖魔盾物品ID = 物品使用装备ID.狱妖魔盾;
const 狱妖魔盾护盾标签 = "装备:狱妖魔盾";
const 狱妖魔盾主动技能壳ID = "IN03";

let 已初始化 = false;

function on丢弃狱妖魔盾(this: void, 单位: any): void {
  移除单位标签护盾(单位, 狱妖魔盾护盾标签);
}

function 取狱妖魔盾冷却键(this: void, 单位: any): string {
  return 取装备冷却键(单位, "狱妖魔盾", "物品使用");
}

function 尝试充能狱妖魔盾(this: void, 单位: any): void {
  if (装备冷却中(取狱妖魔盾冷却键(单位))) return;
  if (!单位存活(单位) || !单位持有物品(单位, 狱妖魔盾物品ID)) {
    on丢弃狱妖魔盾(单位);
    return;
  }

  const maxLife = 取最大生命(单位);
  const currentLife = 取当前生命(单位);
  const maxShield = maxLife * 狱妖魔盾配置.最大护盾比例;
  const currentShield = 查询单位标签护盾值(单位, 狱妖魔盾护盾标签);
  let amount = maxLife * 狱妖魔盾配置.生命吸取比例;
  const shieldRoom = maxShield - currentShield;
  if (amount > shieldRoom) amount = shieldRoom;
  const canPayLife = currentLife - 1;
  if (amount > canPayLife) amount = canPayLife;
  if (!(amount > 0)) return;

  const paidLife = -减少生命值(单位, amount, true, false, undefined, 1);
  if (!(paidLife > 0)) return;
  const added = 充能单位标签护盾(单位, 狱妖魔盾护盾标签, paidLife, maxShield, {
    类型: 护盾类型.通用,
    数值: paidLife,
    持续时间: 0,
    来源单位: 单位,
    显示护盾条: true,
    可驱散: false,
  });
  if (!(added > 0) && 查询单位标签护盾值(单位, 狱妖魔盾护盾标签) <= 0) {
    开始护盾(单位, { 类型: 护盾类型.通用, 数值: paidLife, 持续时间: 0, 来源单位: 单位, 标签: 狱妖魔盾护盾标签 });
  }
}

function 获取当前玩家英雄列表(this: void): any[] {
  const 玩家英雄单位组 = 获取玩家英雄单位组();
  if (玩家英雄单位组 == null || 玩家英雄单位组 === 0) return [];
  return 快照单位组(玩家英雄单位组);
}

function on狱妖魔盾充能Tick(this: void, 单位: any): void {
  if (!单位是英雄(单位)) return;
  尝试充能狱妖魔盾(单位);
}

function 开始狱妖魔盾冷却(this: void, 单位: any, 物品: any): void {
  const 冷却秒数 = 狱妖魔盾配置.冷却毫秒 / 1000;
  进入装备冷却并显示(取狱妖魔盾冷却键(单位), 冷却秒数, 单位, "狱妖魔盾");
  设置物品CD({
    unit: 单位,
    item: 物品,
    秒数: 冷却秒数,
    范围: "主动",
    主动技能ID: 狱妖魔盾主动技能壳ID,
    主动最大冷却秒数: 冷却秒数,
  });
}

export function 初始化狱妖魔盾持有充能(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  注册持有型周期效果({
    物品类型ID: 狱妖魔盾物品ID,
    间隔毫秒: 狱妖魔盾配置.充能间隔毫秒,
    周期回调: on狱妖魔盾充能Tick,
    丢弃回调: on丢弃狱妖魔盾,
    初始单位列表: 获取当前玩家英雄列表,
  });
}

export function 处理狱妖魔盾使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为使用物品(上下文.物品, 狱妖魔盾物品ID)) return;
  const 单位 = 上下文.施法单位;
  if (!单位是英雄(单位)) return;
  if (装备冷却中(取狱妖魔盾冷却键(单位))) return;

  const shieldValue = 查询单位标签护盾值(单位, 狱妖魔盾护盾标签);
  if (!(shieldValue > 0)) return;

  const x = 上下文.目标X !== 0 ? 上下文.目标X : 取单位X(单位);
  const y = 上下文.目标Y !== 0 ? 上下文.目标Y : 取单位Y(单位);
  const enemies = 获取范围敌人(单位, x, y, 狱妖魔盾配置.爆发半径);
  for (const enemy of enemies) {
    造成强化伤害(单位, enemy, shieldValue * 狱妖魔盾配置.爆发倍率);
    施加眩晕(单位, enemy, 狱妖魔盾配置.眩晕时间);
    击退远离来源(单位, enemy, 250, 0.5);
  }
  移除单位标签护盾(单位, 狱妖魔盾护盾标签);
  开始狱妖魔盾冷却(单位, 上下文.物品);
}

export {};
