/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 释放冰焰双星 } from "./01．冰焰双星";
import { 释放绝对零度领域 } from "./02．绝对零度领域";
import { 切换塞拉形态, 确保塞拉伤害修正 } from "./03．元素转换";
import { 塞拉公共 } from "./00．公共";
import { 创建战斗技能调度器 } from "../../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板";

const {
  巴尔扎罗斯技能数值配置,
  GetUnitX,
  GetUnitY,
  单位有效,
  取单位ID,
  点距离平方,
  取塞拉形态,
  取塞拉技能目标,
  塞拉形态表,
  绝对零度领域状态表,
} = 塞拉公共;

function 塞拉可调度(this: void, context: 巴尔扎罗斯运行时上下文): boolean {
  return 单位有效(context.Boss单位) && 单位有效(context.塞拉);
}

function 取塞拉上下文键(this: void, context: 巴尔扎罗斯运行时上下文): number {
  return 取单位ID(context.塞拉);
}

function 选择塞拉目标(this: void, context: 巴尔扎罗斯运行时上下文): any {
  return 取塞拉技能目标(context);
}

function 塞拉冰焰双星目标有效(this: void, context: 巴尔扎罗斯运行时上下文, target: any): boolean {
  const sera = context.塞拉;
  if (!单位有效(sera) || !单位有效(target)) return false;
  const iceFire = 巴尔扎罗斯技能数值配置.冰焰双星;
  const distanceSq = 点距离平方(GetUnitX(sera), GetUnitY(sera), GetUnitX(target), GetUnitY(target));
  return distanceSq <= iceFire.施法距离 * iceFire.施法距离;
}

export function 初始化巴尔扎罗斯塞拉技能(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.塞拉技能已初始化) return;
  context.塞拉技能已初始化 = true;
  确保塞拉伤害修正();
  if (单位有效(context.塞拉)) {
    const id = 取单位ID(context.塞拉);
    切换塞拉形态(context, "火焰", false);
    context.清理.登记清理("巴尔扎罗斯-塞拉技能状态", function 巴尔扎罗斯塞拉技能状态清理(this: void): void {
      delete 塞拉形态表[id];
      delete 绝对零度领域状态表[id];
    });
  }
  const conversion = 巴尔扎罗斯技能数值配置.元素转换;
  const iceFire = 巴尔扎罗斯技能数值配置.冰焰双星;
  const zero = 巴尔扎罗斯技能数值配置.绝对零度领域;
  创建战斗技能调度器<巴尔扎罗斯运行时上下文>({
    名称: "巴尔扎罗斯-塞拉技能调度",
    清理: context.清理,
    间隔毫秒: 500,
    取上下文列表: function 取塞拉上下文列表(this: void): 巴尔扎罗斯运行时上下文[] { return [context]; },
    取上下文键: 取塞拉上下文键,
    可调度: 塞拉可调度,
    技能列表: [{
      key: "元素转换",
      冷却毫秒: conversion.周期秒 * 1000,
      首次延迟毫秒: conversion.周期秒 * 1000,
      优先级: 30,
      执行: function 执行塞拉元素转换(this: void, skillContext: 巴尔扎罗斯运行时上下文): boolean {
        const next = 取塞拉形态(skillContext) === "火焰" ? "冰霜" : "火焰";
        切换塞拉形态(skillContext, next, true);
        return true;
      },
    }, {
      key: "冰焰双星",
      冷却毫秒: iceFire.冷却秒 * 1000,
      首次延迟毫秒: 0,
      忙碌毫秒: iceFire.施法硬直秒 * 1000,
      优先级: 20,
      选择目标: 选择塞拉目标,
      目标有效: 塞拉冰焰双星目标有效,
      执行: function 执行塞拉冰焰双星(this: void, skillContext: 巴尔扎罗斯运行时上下文, target: any): boolean {
        释放冰焰双星(skillContext, target);
        return true;
      },
    }, {
      key: "绝对零度领域",
      冷却毫秒: zero.冷却秒 * 1000,
      首次延迟毫秒: 0,
      忙碌毫秒: zero.施法硬直秒 * 1000,
      优先级: 10,
      选择目标: 选择塞拉目标,
      目标有效: function 塞拉绝对零度目标有效(this: void, _context: 巴尔扎罗斯运行时上下文, target: any): boolean { return 单位有效(target); },
      执行: function 执行塞拉绝对零度(this: void, skillContext: 巴尔扎罗斯运行时上下文, target: any): boolean {
        释放绝对零度领域(skillContext, target);
        return true;
      },
    }],
  });
}

export function 注册巴尔扎罗斯护卫塞拉(this: void): void {
  确保塞拉伤害修正();
}
