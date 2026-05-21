/** @noSelfInFile */

const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 快照单位组 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.07．单位组工具") as {
  快照单位组: (this: void, group: any) => any[];
};
const { 开始护盾, 护盾类型, 查询单位标签护盾值, 充能单位标签护盾, 移除单位标签护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number };
  查询单位标签护盾值: (this: void, unit: any, tag: string) => number;
  充能单位标签护盾: (this: void, unit: any, tag: string, amount: number, maxValue: number, params?: any) => number;
  移除单位标签护盾: (this: void, unit: any, tag: string) => void;
};

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import {
  是否为使用物品,
  单位持有物品,
  单位是英雄,
  取句柄ID,
  单位存活,
  取当前生命,
  取单位X,
  取单位Y,
  取最大生命,
  设置生命,
  获取范围敌人,
  造成强化伤害,
  施加眩晕,
  击退远离来源,
} from "../05．物品使用/00．公共/02．物品使用工具";

const 狱妖魔盾配置 = 物品使用数值配置.狱妖魔盾;
const 狱妖魔盾物品ID = 物品使用装备ID.狱妖魔盾;
const 狱妖魔盾护盾标签 = "装备:狱妖魔盾";

const 持有者列表: any[] = [];
const 持有者表: Record<number, any | undefined> = {};
const 冷却到期表: Record<number, number | undefined> = {};
let 已初始化 = false;
let 已注册充能计时器 = false;

function 获取玩家英雄单位组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function 加入持有者(this: void, 单位: any): void {
  const id = 取句柄ID(单位);
  if (id === 0 || 持有者表[id] != null) return;
  持有者表[id] = 单位;
  持有者列表.push(单位);
}

function 移除持有者(this: void, 单位: any): void {
  const id = 取句柄ID(单位);
  if (id === 0) return;
  delete 持有者表[id];
  for (let i = 持有者列表.length - 1; i >= 0; i--) {
    if (取句柄ID(持有者列表[i]) === id) {
      持有者列表.splice(i, 1);
    }
  }
  移除单位标签护盾(单位, 狱妖魔盾护盾标签);
}

function on拾取狱妖魔盾(this: void, 单位: any, 物品: any): void {
  if (!是否为使用物品(物品, 狱妖魔盾物品ID)) return;
  if (!单位是英雄(单位)) return;
  加入持有者(单位);
}

function on丢弃狱妖魔盾(this: void, 单位: any, 物品: any): void {
  if (!是否为使用物品(物品, 狱妖魔盾物品ID)) return;
  if (!单位是英雄(单位)) return;
  移除持有者(单位);
}

function 尝试充能狱妖魔盾(this: void, 单位: any): void {
  const id = 取句柄ID(单位);
  if (id === 0) return;
  const 冷却到期 = 冷却到期表[id] ?? 0;
  if (冷却到期 > getServerTime()) return;
  if (!单位存活(单位) || !单位持有物品(单位, 狱妖魔盾物品ID)) {
    移除持有者(单位);
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

  设置生命(单位, currentLife - amount);
  const added = 充能单位标签护盾(单位, 狱妖魔盾护盾标签, amount, maxShield, {
    类型: 护盾类型.通用,
    数值: amount,
    持续时间: 0,
    来源单位: 单位,
    显示护盾条: true,
    可驱散: false,
  });
  if (!(added > 0) && 查询单位标签护盾值(单位, 狱妖魔盾护盾标签) <= 0) {
    开始护盾(单位, { 类型: 护盾类型.通用, 数值: amount, 持续时间: 0, 来源单位: 单位, 标签: 狱妖魔盾护盾标签 });
  }
}

function 补登记现有持有者(this: void): void {
  const 玩家英雄单位组 = 获取玩家英雄单位组();
  if (玩家英雄单位组 == null || 玩家英雄单位组 === 0) return;

  const 单位列表 = 快照单位组(玩家英雄单位组);
  for (let i = 0; i < 单位列表.length; i++) {
    const 单位 = 单位列表[i];
    if (!单位是英雄(单位)) continue;
    if (!单位持有物品(单位, 狱妖魔盾物品ID)) continue;
    加入持有者(单位);
  }
}

function on狱妖魔盾充能Tick(this: void): void {
  补登记现有持有者();
  for (let i = 持有者列表.length - 1; i >= 0; i--) {
    尝试充能狱妖魔盾(持有者列表[i]);
  }
}

function 开始狱妖魔盾冷却(this: void, 单位: any): void {
  const id = 取句柄ID(单位);
  if (id === 0) return;
  冷却到期表[id] = getServerTime() + 狱妖魔盾配置.冷却毫秒;
}

export function 初始化狱妖魔盾持有充能(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  onItemPickup(on拾取狱妖魔盾);
  onItemDrop(on丢弃狱妖魔盾);
  if (!已注册充能计时器) {
    已注册充能计时器 = true;
    addPeriodicCallback(狱妖魔盾配置.充能间隔毫秒, on狱妖魔盾充能Tick);
  }
}

export function 处理狱妖魔盾使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为使用物品(上下文.物品, 狱妖魔盾物品ID)) return;
  const 单位 = 上下文.施法单位;
  if (!单位是英雄(单位)) return;
  const id = 取句柄ID(单位);
  if (id === 0) return;
  const 冷却到期 = 冷却到期表[id] ?? 0;
  if (冷却到期 > getServerTime()) return;

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
  开始狱妖魔盾冷却(单位);
}

export {};
