/** @noSelfInFile */

import { 狱生面具配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 获取范围敌人, 取单位X, 取单位Y, 取最大魔法, 取最大生命, 取当前生命, 取当前魔法, 造成暗影伤害, 执行治疗 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  获取范围敌人: (this: void, source: any, x: number, y: number, radius: number) => any[];
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  取最大魔法: (this: void, unit: any) => number;
  取最大生命: (this: void, unit: any) => number;
  取当前生命: (this: void, unit: any) => number;
  取当前魔法: (this: void, unit: any) => number;
  造成暗影伤害: (this: void, source: any, target: any, damage: number) => void;
  执行治疗: (this: void, source: any, target: any, heal: number, mana?: number) => void;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

type 强化狱生面具延迟记录 = {
  来源单位: any;
  目标单位: any;
  到期时间: number;
};

const 强化狱生面具延迟队列: 强化狱生面具延迟记录[] = [];
let 已注册强化狱生面具延迟处理 = false;

function 单位已死亡(this: void, unit: any): boolean {
  return unit == null || unit === 0 || IsUnitType(unit, UNIT_TYPE_DEAD) === true;
}

function 创建强化狱生面具延迟记录(this: void, source: any, target: any): void {
  强化狱生面具延迟队列.push({
    来源单位: source,
    目标单位: target,
    到期时间: getServerTime() + 狱生面具配置.强化延迟毫秒,
  });
}

function on强化狱生面具延迟结算(this: void): void {
  const now = getServerTime();
  for (let i = 强化狱生面具延迟队列.length - 1; i >= 0; i--) {
    const record = 强化狱生面具延迟队列[i];
    if (record == null || now < record.到期时间) continue;
    强化狱生面具延迟队列.splice(i, 1);
    if (record.来源单位 == null || record.来源单位 === 0 || 单位已死亡(record.来源单位)) continue;
    if (!单位已死亡(record.目标单位)) continue;
    const heal = (取最大生命(record.来源单位) - 取当前生命(record.来源单位)) * 狱生面具配置.强化恢复比例;
    const mana = (取最大魔法(record.来源单位) - 取当前魔法(record.来源单位)) * 狱生面具配置.强化恢复比例;
    执行治疗(record.来源单位, record.来源单位, heal, mana);
  }
}

function 确保注册强化狱生面具延迟处理(this: void): void {
  if (已注册强化狱生面具延迟处理) return;
  已注册强化狱生面具延迟处理 = true;
  addPeriodicCallback(100, on强化狱生面具延迟结算);
}

function on狱生面具强化周期(this: void, unit: any): void {
  const consumed = -减少魔法值(unit, 取最大魔法(unit) * 狱生面具配置.最大魔法消耗比例, false, false);
  if (!(consumed > 0)) return;
  const damage = consumed * 狱生面具配置.强化伤害倍率;
  const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), 狱生面具配置.作用范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    造成暗影伤害(unit, target, damage);
    创建强化狱生面具延迟记录(unit, target);
  }
}

function 初始化狱生面具强化(this: void): void {
  if (获得物品装备ID.狱生面具强化 === 0) return;
  确保注册强化狱生面具延迟处理();
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.狱生面具强化,
    间隔毫秒: 狱生面具配置.间隔毫秒,
    周期回调: on狱生面具强化周期,
  });
}

初始化狱生面具强化();

export {};
