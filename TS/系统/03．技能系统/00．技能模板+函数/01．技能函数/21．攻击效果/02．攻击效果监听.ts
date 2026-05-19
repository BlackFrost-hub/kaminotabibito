/** @noSelfInFile */

const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (
    this: void,
    cb: (
      this: void,
      unit: any,
      damage: number,
      damageType: number,
      fromDotTickBatch?: boolean,
      source?: any,
      isNormalAttack?: boolean
    ) => void,
    intervalSeconds?: number
  ) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (
    this: void,
    cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void
  ) => void;
};

import {
  攻击效果是否在冷却中,
  攻击效果进入冷却,
  攻击效果开始执行,
  攻击效果结束执行,
} from "./01．攻击效果状态";

export interface 普攻攻击效果上下文 {
  source: any;
  target: any;
  damage: number;
  damageType: number;
  fromDotTickBatch: boolean;
  isNormalAttack: boolean;
  snapshot?: any;
}

export interface 最终伤害攻击效果上下文 {
  source: any;
  target: any;
  applied: number;
  snapshot: any;
}

export interface 普攻攻击效果监听参数 {
  名称: string;
  冷却毫秒?: number;
  条件?: (this: void, ctx: 普攻攻击效果上下文) => boolean;
  命中后: (this: void, ctx: 普攻攻击效果上下文) => void;
}

export interface 最终伤害攻击效果监听参数 {
  名称: string;
  冷却毫秒?: number;
  条件?: (this: void, ctx: 最终伤害攻击效果上下文) => boolean;
  命中后: (this: void, ctx: 最终伤害攻击效果上下文) => void;
}

const 普攻监听列表: 普攻攻击效果监听参数[] = [];
const 最终伤害监听列表: 最终伤害攻击效果监听参数[] = [];
let 普攻监听已注册 = false;
let 最终伤害监听已注册 = false;

function 确保普攻监听已注册(this: void): void {
  if (普攻监听已注册) return;
  普攻监听已注册 = true;
  registerDamageCallback(on普攻攻击效果伤害事件);
}

function 确保最终伤害监听已注册(this: void): void {
  if (最终伤害监听已注册) return;
  最终伤害监听已注册 = true;
  registerAppliedFinalDamageListener(on最终伤害攻击效果事件);
}

function on普攻攻击效果伤害事件(
  this: void,
  target: any,
  damage: number,
  damageType: number,
  fromDotTickBatch?: boolean,
  source?: any,
  isNormalAttack?: boolean,
): void {
  if (target == null || target === 0) return;
  if (!(damage > 0)) return;
  if (fromDotTickBatch === true) return;

  const ctx: 普攻攻击效果上下文 = {
    source: source ?? null,
    target,
    damage,
    damageType,
    fromDotTickBatch: false,
    isNormalAttack: isNormalAttack === true,
  };
  dispatch普攻攻击效果监听器(ctx);
}

function on最终伤害攻击效果事件(
  this: void,
  target: any,
  attacker: any,
  applied: number,
  snapshot: any,
): void {
  if (target == null || target === 0) return;
  if (!(applied > 0)) return;

  const ctx: 最终伤害攻击效果上下文 = {
    source: attacker ?? null,
    target,
    applied,
    snapshot,
  };
  dispatch最终伤害监听器(ctx);
}

function dispatch普攻攻击效果监听器(this: void, ctx: 普攻攻击效果上下文): void {
  for (let i = 0; i < 普攻监听列表.length; i++) {
    const 实例 = 普攻监听列表[i];
    if (实例 == null) continue;
    if (实例.条件 != null && 实例.条件(ctx) === false) continue;
    if (ctx.isNormalAttack !== true) continue;
    if (攻击效果是否在冷却中(实例.名称, ctx.source, 实例.冷却毫秒 ?? 0)) continue;
    if (!攻击效果开始执行(实例.名称, ctx.source)) continue;

    try {
      攻击效果进入冷却(实例.名称, ctx.source);
      实例.命中后(ctx);
    } finally {
      攻击效果结束执行(实例.名称, ctx.source);
    }
  }
}

function dispatch最终伤害监听器(this: void, ctx: 最终伤害攻击效果上下文): void {
  for (let i = 0; i < 最终伤害监听列表.length; i++) {
    const 实例 = 最终伤害监听列表[i];
    if (实例 == null) continue;
    if (实例.条件 != null && 实例.条件(ctx) === false) continue;
    if (攻击效果是否在冷却中(实例.名称, ctx.source, 实例.冷却毫秒 ?? 0)) continue;
    if (!攻击效果开始执行(实例.名称, ctx.source)) continue;

    try {
      攻击效果进入冷却(实例.名称, ctx.source);
      实例.命中后(ctx);
    } finally {
      攻击效果结束执行(实例.名称, ctx.source);
    }
  }
}

export function 注册普攻攻击效果监听(this: void, 参数: 普攻攻击效果监听参数): void {
  if (参数 == null || !参数.名称 || 参数.命中后 == null) return;
  普攻监听列表.push(参数);
  确保普攻监听已注册();
}

export function 注册最终伤害攻击效果监听(this: void, 参数: 最终伤害攻击效果监听参数): void {
  if (参数 == null || !参数.名称 || 参数.命中后 == null) return;
  最终伤害监听列表.push(参数);
  确保最终伤害监听已注册();
}

export {};
