/** @noSelfInFile */

import { 提米诺斯单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { getRealAttr } = require("系统.04．伤害系统.00．伤害计算.01．属性读取") as {
  getRealAttr: (this: void, unit: any, attrName: string, defaultValue?: number) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

const 提米诺斯单位类型ID = stringToFourCCSafe(提米诺斯单位技能配置.单位类型ID);
const E技能类型ID = stringToFourCCSafe(提米诺斯单位技能配置.E技能ID);
let 已注册 = false;

function 提米诺斯光弱点伤害修正(this: void, context: any): number {
  const damage = context?.currentDamage ?? 0;
  const attacker = context?.attacker;
  const target = context?.target;
  if (!(damage > 0) || attacker == null || target == null) return damage;
  if (jass.GetUnitTypeId(attacker) !== 提米诺斯单位类型ID || context?.isLightDamage !== true) return damage;
  if (getRealAttr(target, "光属性抗性", 0) >= 0) return damage;
  const level = jass.GetUnitAbilityLevel(attacker, E技能类型ID) as number;
  if (!(level > 0)) return damage;
  return damage * (1 + level * 提米诺斯单位技能配置.E.光弱点额外增伤);
}

export function 注册提米诺斯被动(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerDamageModifier(提米诺斯光弱点伤害修正, 5);
}

注册提米诺斯被动();

export {};
