/** @noSelfInFile */

import { 单位间距离平方 as 距离平方, 取单位ID } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 创建单位坐标跟随特效, 获取单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  获取单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetHandleId = jass.GetHandleId as (unit: any) => number;

const 领域特效键 = "thranduil-order-aura";
const 攻速属性ID = 10;
const 秩序领域影响层数表: Record<number, number | undefined> = {};
const 秩序领域影响单位表: Record<number, any | undefined> = {};
const 秩序领域来源名称表: Record<number, string | undefined> = {};
const 秩序领域特效缩放表: Record<number, number | undefined> = {};

function 确保Boss自身领域表现(this: void, boss: any): void {
  const config = 瑟兰迪尔数值与表现配置.秩序领域;
  const bossId = 取单位ID(boss);
  let effect = 获取单位坐标跟随特效(boss, 领域特效键);
  if (effect != null && effect !== 0 && 秩序领域特效缩放表[bossId] !== config.特效缩放) {
    销毁单位坐标跟随特效(boss, 领域特效键);
    effect = null;
  }
  if (effect == null || effect === 0) {
    effect = 创建单位坐标跟随特效(boss, config.特效, 领域特效键, config.特效缩放, 50);
  }
  if (effect != null && effect !== 0) {
    秩序领域特效缩放表[bossId] = config.特效缩放;
  }
}

function 调整秩序领域影响层数(this: void, unit: any, delta: number): void {
  if (delta === 0 || unit == null || unit === 0) return;
  SGSS_SetState(unit, 攻速属性ID, -瑟兰迪尔数值与表现配置.秩序领域.攻击速度降低 * delta);
}

function 同步秩序领域影响(this: void, next: Record<number, number | undefined>): void {
  const config = 瑟兰迪尔数值与表现配置.秩序领域;
  for (const id in 秩序领域影响层数表) {
    if (next[id] == null) next[id] = 0;
  }
  for (const id in next) {
    const oldCount = 秩序领域影响层数表[id] ?? 0;
    const newCount = next[id] ?? 0;
    const unit = 秩序领域影响单位表[id];
    if (oldCount !== newCount) {
      调整秩序领域影响层数(unit, newCount - oldCount);
    }
    if (newCount > 0) {
      秩序领域影响层数表[id] = newCount;
      registerManualBuff(unit, config.BuffID, config.Tick秒 + 0.3, config.攻击速度降低 * 100, {
        sourceName: 秩序领域来源名称表[id],
        iconOverride: "BuffIcon\\Boss\\Thranduil\\zhixulingyu.blp",
      });
    } else {
      移除单位指定Buff(unit, config.BuffID);
      delete 秩序领域影响层数表[id];
      delete 秩序领域影响单位表[id];
      delete 秩序领域来源名称表[id];
    }
  }
}

export function 刷新瑟兰迪尔秩序领域(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.秩序领域;
  const boss = context.Boss单位;
  if (boss == null || boss === 0) return;

  确保Boss自身领域表现(boss);
  const next: Record<number, number | undefined> = {};
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const radius2 = config.半径 * config.半径;
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (距离平方(boss, target) <= radius2) {
      const targetId = 取单位ID(target);
      if (targetId === 0) continue;
      next[targetId] = 1;
      秩序领域影响单位表[targetId] = target;
      秩序领域来源名称表[targetId] = GetUnitName(boss);
    }
  }
  同步秩序领域影响(next);
}

export function 清理瑟兰迪尔秩序领域(this: void, boss: any): void {
  if (boss != null && boss !== 0) {
    delete 秩序领域特效缩放表[取单位ID(boss)];
    销毁单位坐标跟随特效(boss, 领域特效键);
  }
  const next: Record<number, number | undefined> = {};
  同步秩序领域影响(next);
}
