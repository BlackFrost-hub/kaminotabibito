/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const { registerCritRateModifier } = require("系统.04．伤害系统.06．暴击系统.01．暴击核心") as {
  registerCritRateModifier: (this: void, callback: (this: void, context: any) => number) => void;
};
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 森魔连弩物品ID = stringToFourCCSafe(resolveItemIdByName("森魔连弩"));

function 目标生命比例高于八成(this: void, target: any): boolean {
  const 最大生命 = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  if (最大生命 <= 0) return false;
  return GetUnitState(target, UNIT_STATE_LIFE) > 最大生命 * 0.8;
}

function 森魔连弩暴击率修正(this: void, context: any): number {
  if (森魔连弩物品ID === 0) return context.暴击率;
  if (context.isNormalAttack !== true || context.isRangedAttack !== true) return context.暴击率;
  if (!目标生命比例高于八成(context.target)) return context.暴击率;
  if (!UnitHasItemOfTypeBJ(context.暴击归属单位, 森魔连弩物品ID)) return context.暴击率;
  return 1;
}

export function init森魔连弩暴击(this: void): void {
  registerCritRateModifier(森魔连弩暴击率修正);
}

init森魔连弩暴击();

export {};
