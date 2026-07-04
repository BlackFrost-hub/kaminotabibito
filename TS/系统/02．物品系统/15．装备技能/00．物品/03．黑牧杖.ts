/** @noSelfInFile */
const jass = require("jass.common") as any;

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { getEnemyUnitsInRange, isValidUnit, isUnitEnemy } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
  isValidUnit: (this: void, unit: any) => boolean;
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 造成装备伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  造成装备伤害: (this: void, source: any, target: any, amount: number, damageType: any) => void;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemType: number) => boolean;
};

import { 黑牧杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 黑牧杖配置 } from "../03．主动技能/01．治疗触发/00．治疗触发配置";
import { 黑牧杖最小治疗触发值 } from "../03．主动技能/01．治疗触发/01．治疗触发常量";

function 单位是否持有黑牧杖(this: void, unit: any): boolean {
  if (!isValidUnit(unit)) return false;
  if (黑牧杖物品ID <= 0) return false;
  return UnitHasItemOfTypeBJ(unit, 黑牧杖物品ID) === true;
}

function 对敌人造成黑牧杖伤害(this: void, 施法者: any, 目标: any): void {
  if (!isValidUnit(施法者) || !isValidUnit(目标)) return;
  造成装备伤害(施法者, 目标, 黑牧杖配置.伤害值, DAMAGE_TYPE_SHADOW_STRIKE);
  createTimedEffect(黑牧杖配置.特效路径, GetUnitX(目标), GetUnitY(目标), 0, 1);
}

export function 处理黑牧杖治疗(this: void, _来源: any, 目标: any, 治疗量: number, _是否物品治疗: boolean): number {
  if (!isValidUnit(目标) || 治疗量 <= 黑牧杖最小治疗触发值) return 治疗量;
  if (!单位是否持有黑牧杖(目标)) return 治疗量;

  const 敌人列表 = getEnemyUnitsInRange(目标, GetUnitX(目标), GetUnitY(目标), 黑牧杖配置.作用范围);
  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (!isValidUnit(敌人)) continue;
    if (!isUnitEnemy(敌人, 目标)) continue;
    对敌人造成黑牧杖伤害(目标, 敌人);
  }

  return 治疗量;
}

export {};
