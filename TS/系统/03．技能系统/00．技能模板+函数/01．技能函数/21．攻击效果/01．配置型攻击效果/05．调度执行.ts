/** @noSelfInFile */

import type { 配置型攻击效果配置, 配置型攻击效果上下文 } from "./00．类型定义";
import { 执行配置型持续伤害 } from "./04．持续伤害执行";
import {
  执行配置型单体伤害,
  执行配置型额外伤害,
  执行配置型范围伤害,
  执行配置型低血斩杀,
  执行配置型范围击飞,
  配置型概率函数,
} from "./03．瞬时执行";
import { 配置型临时修改攻速, 配置型播放目标特效, 配置型播放单位坐标特效 } from "./01．基础工具";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 施加单体护甲降低Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.01．debuff.04．护甲降低") as {
  施加单体护甲降低Buff: (this: void, source: any, target: any, params: {
    持续时间: number;
    护甲: number;
    叠加键?: string;
  }) => boolean;
};

interface 配置型临时属性记录 {
  unit: any;
  type: "攻速";
  value: number;
}

const 配置型临时属性队列: 配置型临时属性记录[] = [];

function 绝对值(this: void, value: number): number {
  return value < 0 ? -value : value;
}

function on配置型临时属性结束(this: void): void {
  const record = 配置型临时属性队列.shift();
  if (record == null) return;
  配置型临时修改攻速(record.unit, record.value);
}

function 执行配置型临时攻速(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): void {
  const value = 配置.攻速加成 ?? 0;
  if (value === 0) return;
  配置型临时修改攻速(ctx.source, value);
  配置型临时属性队列.push({ unit: ctx.source, type: "攻速", value: -value });
  addDelayedCallback((配置.持续时间 ?? 2) * 1000, on配置型临时属性结束);
  执行配置型范围伤害(配置, ctx);
}

function 执行配置型护甲削减(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): void {
  const value = 绝对值(配置.固定伤害 ?? 0);
  if (!(value > 0)) return;
  施加单体护甲降低Buff(ctx.source, ctx.target, {
    持续时间: 配置.持续时间 ?? 5,
    护甲: value,
    叠加键: 配置.护甲降低叠加键,
  });
}

export function 执行配置型攻击效果配置(
  this: void,
  配置: 配置型攻击效果配置,
  ctx: 配置型攻击效果上下文,
  概率通过: 配置型概率函数,
): void {
  if (配置.特效 != null && 配置.特效 !== "") 配置型播放目标特效(ctx.target, 配置.特效);
  if (配置.点特效 != null && 配置.点特效 !== "") 配置型播放单位坐标特效(ctx.target, 配置.点特效, 配置.点特效缩放);

  if (配置.自定义执行 != null) {
    配置.自定义执行(ctx);
    return;
  }

  if (配置.效果类型 === "反击伤害") 执行配置型单体伤害(配置, ctx);
  else if (配置.效果类型 === "额外伤害") 执行配置型额外伤害(配置, ctx, 概率通过);
  else if (配置.效果类型 === "范围伤害") 执行配置型范围伤害(配置, ctx);
  else if (配置.效果类型 === "持续伤害") 执行配置型持续伤害(配置, ctx);
  else if (配置.效果类型 === "低血斩杀") 执行配置型低血斩杀(配置, ctx);
  else if (配置.效果类型 === "范围击飞") 执行配置型范围击飞(配置, ctx);
  else if (配置.效果类型 === "临时攻速") 执行配置型临时攻速(配置, ctx);
  else if (配置.效果类型 === "护甲削减") 执行配置型护甲削减(配置, ctx);
  else if (配置.效果类型 === "资源偷取") 执行配置型额外伤害(配置, ctx, 概率通过);
}

export {};
