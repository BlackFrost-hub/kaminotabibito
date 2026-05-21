/** @noSelfInFile */

import { 守护之盾配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
    获取回调?: (this: void, unit: any, currentCount: number) => void;
    丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 获取单位当前持有指定物品数量 } = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index") as {
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};
const { 变更资源值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  变更资源值: (this: void, target: any, amount: number, type: "life" | "mana", showText?: boolean, showEffect?: boolean, effectPath?: string, lowestValue?: number) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, cb: (this: void, context: any) => number, priority?: number) => number;
};
const { 临时调整攻击, 单位存活 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
  单位存活: (this: void, unit: any) => boolean;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (id: number) => any;
const IsUnitAlly = jass.IsUnitAlly as (unit: any, player: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;

const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

type 守护之盾攻击状态 = {
  当前加成: number;
};

const 守护之盾攻击状态表: Record<number, 守护之盾攻击状态 | undefined> = {};
const 守护之盾持有者列表: any[] = [];
const 守护之盾持有者表: Record<number, any | undefined> = {};
let 已注册守护之盾伤害修正 = false;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取单位护甲(this: void, unit: any): number {
  return GetUnitStateJapi(unit, ConvertUnitState(0x20));
}

function 加入守护之盾持有者(this: void, unit: any): void {
  const id = 取单位ID(unit);
  if (id === 0 || 守护之盾持有者表[id] != null) return;
  守护之盾持有者表[id] = unit;
  守护之盾持有者列表.push(unit);
}

function 移除守护之盾持有者(this: void, unit: any): void {
  const id = 取单位ID(unit);
  if (id === 0) return;
  delete 守护之盾持有者表[id];
  for (let i = 守护之盾持有者列表.length - 1; i >= 0; i--) {
    if (取单位ID(守护之盾持有者列表[i]) === id) {
      守护之盾持有者列表.splice(i, 1);
    }
  }
}

function 取或创建守护之盾攻击状态(this: void, unit: any): 守护之盾攻击状态 {
  const id = 取单位ID(unit);
  const state = 守护之盾攻击状态表[id];
  if (state != null) return state;
  const nextState: 守护之盾攻击状态 = { 当前加成: 0 };
  守护之盾攻击状态表[id] = nextState;
  return nextState;
}

function 清理守护之盾攻击加成(this: void, unit: any): void {
  const id = 取单位ID(unit);
  if (id === 0) return;
  const state = 守护之盾攻击状态表[id];
  if (state != null && state.当前加成 !== 0) {
    临时调整攻击(unit, -state.当前加成);
  }
  delete 守护之盾攻击状态表[id];
}

function on守护之盾攻击同步(this: void, unit: any, currentCount: number): void {
  if (!单位存活(unit) || currentCount <= 0) {
    清理守护之盾攻击加成(unit);
    return;
  }
  const state = 取或创建守护之盾攻击状态(unit);
  const nextBonus = 取单位护甲(unit) * 守护之盾配置.防转攻比例 * currentCount;
  const delta = nextBonus - state.当前加成;
  if (delta !== 0) {
    临时调整攻击(unit, delta);
    state.当前加成 = nextBonus;
  }
}

function on守护之盾丢弃(this: void, unit: any): void {
  清理守护之盾攻击加成(unit);
  移除守护之盾持有者(unit);
}

function on守护之盾获得(this: void, unit: any, currentCount: number): void {
  if (currentCount > 0) {
    加入守护之盾持有者(unit);
  }
}

function on守护之盾失去(this: void, unit: any, currentCount: number): void {
  if (currentCount <= 0) {
    on守护之盾丢弃(unit);
  }
}

function 取转移承受者(this: void, target: any): any | null {
  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  const owner = GetOwningPlayer(target);
  for (let i = 0; i < 守护之盾持有者列表.length; i++) {
    const holder = 守护之盾持有者列表[i];
    if (holder == null || holder === 0 || holder === target) continue;
    if (!单位存活(holder)) continue;
    if (!IsUnitAlly(holder, owner)) continue;
    if (获取单位当前持有指定物品数量(holder, 获得物品装备ID.守护之盾) <= 0) continue;
    const dx = GetUnitX(holder) - tx;
    const dy = GetUnitY(holder) - ty;
    if (dx * dx + dy * dy <= 守护之盾配置.转移半径 * 守护之盾配置.转移半径) {
      return holder;
    }
  }
  return null;
}

function on守护之盾伤害修正(this: void, context: any): number {
  if (!(context.currentDamage >= 1)) return context.currentDamage;
  if (context.isTrueDamage === true) return context.currentDamage;
  const target = context.target;
  if (target == null || target === 0 || !单位存活(target)) return context.currentDamage;
  const holder = 取转移承受者(target);
  if (holder == null) return context.currentDamage;
  const transfer = context.currentDamage * 守护之盾配置.转移比例;
  if (!(transfer > 0)) return context.currentDamage;
  变更资源值(holder, -transfer, "life", true, true, undefined, 0);
  return context.currentDamage - transfer;
}

function 初始化守护之盾(this: void): void {
  if (获得物品装备ID.守护之盾 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.守护之盾,
    间隔毫秒: 守护之盾配置.攻击同步间隔毫秒,
    周期回调: on守护之盾攻击同步,
    获取回调: on守护之盾获得,
    丢弃回调: on守护之盾丢弃,
  });
  if (!已注册守护之盾伤害修正) {
    已注册守护之盾伤害修正 = true;
    registerDamageModifier(on守护之盾伤害修正, 35);
  }
}

初始化守护之盾();

export {};
