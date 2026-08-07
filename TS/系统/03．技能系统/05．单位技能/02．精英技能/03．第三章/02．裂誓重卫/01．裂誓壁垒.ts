/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";
import { 裂誓重卫配置 } from "./00．配置";
import {
  创建封印守卫战单位常驻特效,
  创建封印守卫战点特效,
  取两点方向角,
  取单位X,
  取单位Y,
  取单位距离平方,
  取单位面向,
  取最近玩家英雄,
  读取单位攻击力,
  读取封印守卫战敌人列表,
  读取封印守卫战敌人记录,
  读取封印守卫战核心,
  读取封印守卫战玩家英雄列表,
  命令攻击目标,
  封印守卫战单位存活,
  销毁封印守卫战单位常驻特效,
} from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/01．共享";

const jass = require("jass.common") as any;
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 封印守卫战BuffID } = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战") as {
  封印守卫战BuffID: { 裂誓保护: string };
};

const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const 重卫护盾特效键 = "封印守卫战-裂誓重卫护盾";

function 角度差(this: void, first: number, second: number): number {
  let diff = first - second;
  while (diff < -180) diff += 360;
  while (diff > 180) diff -= 360;
  return diff < 0 ? -diff : diff;
}

export function 初始化裂誓重卫机制(this: void, record: 封印守卫战敌人记录): void {
  创建封印守卫战单位常驻特效(record.单位, 裂誓重卫配置.护盾特效, 重卫护盾特效键);
}

export function 修正裂誓重卫减伤(this: void, context: any): number {
  const targetRecord = 读取封印守卫战敌人记录(context?.target);
  if (targetRecord == null) return context.currentDamage;
  if (targetRecord.类型 === "裂誓重卫") {
    if (!封印守卫战单位存活(context.attacker)) return context.currentDamage;
    const attackAngle = 取两点方向角(
      取单位X(targetRecord.单位),
      取单位Y(targetRecord.单位),
      取单位X(context.attacker),
      取单位Y(context.attacker),
    );
    if (角度差(attackAngle, 取单位面向(targetRecord.单位)) <= 裂誓重卫配置.正面角度 * 0.5) {
      return context.currentDamage * (1 - 裂誓重卫配置.正面减伤比例);
    }
    return context.currentDamage;
  }
  const list = 读取封印守卫战敌人列表();
  for (let i = 0; i < list.length; i++) {
    const protector = list[i];
    if (protector.类型 !== "裂誓重卫" || !封印守卫战单位存活(protector.单位)) continue;
    if (取单位距离平方(protector.单位, targetRecord.单位) <= 裂誓重卫配置.保护范围 * 裂誓重卫配置.保护范围) {
      return context.currentDamage * (1 - 裂誓重卫配置.保护减伤比例);
    }
  }
  return context.currentDamage;
}

function 刷新裂誓保护Buff(this: void, protector: 封印守卫战敌人记录): void {
  const list = 读取封印守卫战敌人列表();
  const duration = (裂誓重卫配置.AI刷新毫秒 + 300) / 1000;
  for (let i = 0; i < list.length; i++) {
    const target = list[i];
    if (target.类型 === "裂誓重卫" || !封印守卫战单位存活(target.单位)) continue;
    if (取单位距离平方(protector.单位, target.单位) > 裂誓重卫配置.保护范围 * 裂誓重卫配置.保护范围) continue;
    registerManualBuff(target.单位, 封印守卫战BuffID.裂誓保护, duration, 裂誓重卫配置.保护减伤比例, {
      sourceUnit: protector.单位,
      effectSourceName: "裂誓重卫-裂誓保护",
      effectSourceType: "技能",
    });
  }
}

function 释放裂誓重卫盾击(this: void, record: 封印守卫战敌人记录): number {
  const heroes = 读取封印守卫战玩家英雄列表();
  const damage = 读取单位攻击力(record.单位) * 裂誓重卫配置.盾击攻击力比例;
  let hitCount = 0;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!封印守卫战单位存活(hero)) continue;
    if (取单位距离平方(record.单位, hero) > 裂誓重卫配置.盾击范围 * 裂誓重卫配置.盾击范围) continue;
    if (造成AOE技能伤害({
      来源: record.单位,
      目标: hero,
      伤害: damage,
      伤害类型: DAMAGE_TYPE_NORMAL,
      来源类型: "单位技能",
      标签: "封印守卫战-裂誓重卫盾击",
      参与技能伤害加成: false,
    })) hitCount += 1;
    开始击退(hero, {
      来源单位: record.单位,
      主单位: record.单位,
      距离: 裂誓重卫配置.击退距离,
      持续时间: 裂誓重卫配置.击退持续秒,
      检查地形: true,
      暂停单位: false,
      禁用碰撞: true,
    });
  }
  创建封印守卫战点特效({
    模型路径: 裂誓重卫配置.盾击特效,
    X: 取单位X(record.单位),
    Y: 取单位Y(record.单位),
    Z: 0,
    缩放: 0.8,
    持续秒: 2,
  });
  return hitCount;
}

export function 刷新裂誓重卫AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 裂誓重卫配置.AI刷新毫秒;
  刷新裂誓保护Buff(record);
  const hero = 取最近玩家英雄(record.单位, 700);
  if (封印守卫战单位存活(hero)) {
    record.当前目标 = hero;
    if (当前毫秒 >= record.下次技能毫秒
      && 取单位距离平方(record.单位, hero) <= 裂誓重卫配置.盾击范围 * 裂誓重卫配置.盾击范围) {
      释放裂誓重卫盾击(record);
      record.下次技能毫秒 = 当前毫秒 + 裂誓重卫配置.盾击冷却毫秒;
    }
    命令攻击目标(record.单位, hero);
    return;
  }
  const core = 读取封印守卫战核心();
  if (封印守卫战单位存活(core)) {
    record.当前目标 = core;
    命令攻击目标(record.单位, core);
  }
}

export function 清理裂誓重卫机制(this: void, record: 封印守卫战敌人记录): void {
  销毁封印守卫战单位常驻特效(record.单位, 重卫护盾特效键);
}
