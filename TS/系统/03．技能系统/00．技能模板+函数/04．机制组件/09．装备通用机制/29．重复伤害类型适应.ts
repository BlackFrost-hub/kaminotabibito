/** @noSelfInFile */

import { 创建单位时限数值 } from "./16．单位时限数值";

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { 单位持有装备, 取装备冷却键, 装备冷却就绪, 进入装备冷却并显示 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却") as any;

export interface 重复伤害类型适应事件 {
  单位: any;
  攻击者: any;
  伤害类型: number;
  原伤害: number;
  修正后伤害: number;
  上下文: any;
}

export interface 重复伤害类型适应参数 {
  名称?: string;
  装备名: string;
  记录持续秒: number;
  重复伤害倍率: number;
  冷却秒数?: number;
  优先级?: number;
  过滤伤害?: (this: void, context: any) => boolean;
  on适应?: (this: void, event: 重复伤害类型适应事件) => void;
}

export interface 重复伤害类型适应控制器 {
  readonly 名称: string;
  清空(this: void, unit?: any): void;
  停止(this: void): void;
}

function 取伤害类型(this: void, context: any): number {
  if (context.isPhysicalDamage === true) return 1;
  if (context.isMagicDamage === true) return 2;
  if (context.isTrueDamage === true) return 3;
  if (context.isMetalDamage === true) return 4;
  if (context.isWoodDamage === true) return 5;
  if (context.isWaterDamage === true) return 6;
  if (context.isFireDamage === true) return 7;
  if (context.isThunderDamage === true) return 8;
  if (context.isLightDamage === true) return 9;
  if (context.isDarkDamage === true) return 10;
  return 0;
}

export function 创建重复伤害类型适应(this: void, 参数: 重复伤害类型适应参数): 重复伤害类型适应控制器 {
  const 名称 = 参数.名称 ?? 参数.装备名;
  const 记录 = 创建单位时限数值(名称 + "-伤害类型");
  let 已停止 = false;
  const 修正器ID = registerDamageModifier(function 重复伤害类型适应修正(this: void, context: any): number {
    const current = context.currentDamage;
    const unit = context.target;
    if (已停止 || !(current > 0) || unit == null || unit === 0 || !单位持有装备(unit, 参数.装备名)) return current;
    if (参数.过滤伤害 != null && !参数.过滤伤害(context)) return current;
    const type = 取伤害类型(context);
    if (type === 0) return current;
    const cooldownKey = 取装备冷却键(unit, 名称, "重复伤害类型适应");
    if (!装备冷却就绪(cooldownKey)) return current;
    if (记录.读取(unit) !== type) {
      记录.写入(unit, type, 参数.记录持续秒);
      return current;
    }
    记录.清空(unit);
    if ((参数.冷却秒数 ?? 0) > 0) 进入装备冷却并显示(cooldownKey, 参数.冷却秒数, unit, 参数.装备名);
    const result = current * 参数.重复伤害倍率;
    参数.on适应?.({ 单位: unit, 攻击者: context.attacker, 伤害类型: type, 原伤害: current, 修正后伤害: result, 上下文: context });
    return result;
  }, 参数.优先级 ?? 32);
  return {
    名称,
    清空: function 清空(this: void, unit?: any): void { 记录.清空(unit); },
    停止: function 停止(this: void): void { if (!已停止) { 已停止 = true; 记录.清空(); unregisterDamageModifier(修正器ID); } },
  };
}

export {};
