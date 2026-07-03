/** @noSelfInFile */

const { 减少生命值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, lowestLife?: number) => number;
};

export interface 非伤害生命移除参数 {
  目标: any;
  数值: number;
  不致死?: boolean;
  最低生命?: number;
  显示文字?: boolean;
  显示特效?: boolean;
  特效路径?: string;
}

export function 执行非伤害生命移除(this: void, 参数: 非伤害生命移除参数): number {
  if (参数.目标 == null || 参数.目标 === 0 || !(参数.数值 > 0)) return 0;
  const lowest = 参数.不致死 === false ? 0 : (参数.最低生命 ?? 1);
  return 减少生命值(参数.目标, 参数.数值, 参数.显示文字 !== false, 参数.显示特效 === true, 参数.特效路径, lowest);
}

export function 按比例移除当前生命(this: void, 目标: any, 比例: number, 不致死: boolean = true): number {
  const jass = require("jass.common") as any;
  const life = jass.GetUnitState(目标, jass.UNIT_STATE_LIFE) as number;
  return 执行非伤害生命移除({ 目标, 数值: life * 比例, 不致死 });
}

export function 按比例移除最大生命(this: void, 目标: any, 比例: number, 不致死: boolean = true): number {
  const jass = require("jass.common") as any;
  const maxLife = jass.GetUnitState(目标, jass.UNIT_STATE_MAX_LIFE) as number;
  return 执行非伤害生命移除({ 目标, 数值: maxLife * 比例, 不致死 });
}

