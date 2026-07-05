/** @noSelfInFile */

const jass = require("jass.common") as any;
import { 造成技能伤害, type 技能伤害来源类型, type 技能伤害形态, type 装备技能伤害类型 } from "./08．技能伤害系统";
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export const 持续伤害属性名 = "持续伤害";

export function 读取持续伤害加成(this: void, source: any): number {
  if (source == null || source === 0) return 0;
  const owner = jass.GetOwningPlayer(source);
  if (owner == null) return 0;
  const value = Number(YDUserDataGetSafe("player", owner, 持续伤害属性名, "real")) || 0;
  return value > -0.95 ? value : -0.95;
}

export function 计算持续伤害最终值(this: void, source: any, amount: number): number {
  if (!(amount > 0)) return 0;
  const finalAmount = amount * (1 + 读取持续伤害加成(source));
  return finalAmount > 0 ? finalAmount : 0;
}

export interface 持续伤害选项 {
  来源类型?: 技能伤害来源类型;
  装备技能类型?: 装备技能伤害类型;
  伤害形态?: 技能伤害形态;
  参与技能伤害加成?: boolean;
  技能ID?: number;
  技能实例ID?: number;
  标签?: string;
}

export function 造成持续伤害(
  this: void,
  source: any,
  target: any,
  amount: number,
  damageType: any,
  ranged: boolean = false,
  attackType: any = ATTACK_TYPE_NORMAL,
  weaponType: any = WEAPON_TYPE_WHOKNOWS,
  选项?: 持续伤害选项
): boolean {
  const finalAmount = 计算持续伤害最终值(source, amount);
  if (!(finalAmount > 0)) return false;
  return 造成技能伤害({
    来源: source,
    目标: target,
    伤害: finalAmount,
    伤害类型: damageType,
    attack: false,
    ranged,
    attackType,
    weaponType,
    来源类型: 选项?.来源类型 ?? 选项?.装备技能类型 ?? "单位技能",
    装备技能类型: 选项?.装备技能类型,
    技能ID: 选项?.技能ID,
    技能实例ID: 选项?.技能实例ID,
    标签: 选项?.标签,
    伤害形态: 选项?.伤害形态 ?? "单体",
    参与技能伤害加成: 选项?.参与技能伤害加成,
  });
}

export {};
