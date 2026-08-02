/** @noSelfInFile */

import { 造成技能伤害, type 技能伤害来源类型, type 技能伤害形态 } from "../../../04．伤害系统/08．技能伤害系统";
import { 计算组合技能伤害, type 组合技能伤害参数 } from "./21．组合技能伤害";

export interface Boss技能伤害公共参数 {
  来源: any;
  目标: any;
  伤害类型: any;
  伤害形态?: 技能伤害形态;
  attack?: boolean;
  ranged?: boolean;
  attackType?: any;
  weaponType?: any;
  技能ID?: number;
  技能实例ID?: number;
  标签?: string;
  来源类型?: 技能伤害来源类型;
  参与技能伤害加成?: boolean;
  isDamageTransfer?: boolean;
}

export interface Boss技能伤害执行参数 extends Boss技能伤害公共参数 {
  伤害公式: 组合技能伤害参数;
}

export interface Boss技能预计算伤害提交参数 extends Boss技能伤害公共参数 {
  伤害: number;
}

export type Boss定形技能伤害执行参数 = Omit<Boss技能伤害执行参数, "伤害形态">;
export type Boss定形预计算伤害提交参数 = Omit<Boss技能预计算伤害提交参数, "伤害形态">;

export interface Boss技能伤害执行结果 {
  是否造成伤害: boolean;
  伤害: number;
}

function 提交Boss技能伤害结果(this: void, 参数: Boss技能伤害公共参数, 伤害: number): Boss技能伤害执行结果 {
  if (!(伤害 > 0)) return { 是否造成伤害: false, 伤害 };
  const 是否造成伤害 = 造成技能伤害({
    来源: 参数.来源,
    目标: 参数.目标,
    伤害,
    伤害类型: 参数.伤害类型,
    attack: 参数.attack,
    ranged: 参数.ranged,
    attackType: 参数.attackType,
    weaponType: 参数.weaponType,
    来源类型: 参数.来源类型 ?? "Boss技能",
    技能ID: 参数.技能ID,
    技能实例ID: 参数.技能实例ID,
    标签: 参数.标签,
    伤害形态: 参数.伤害形态,
    参与技能伤害加成: 参数.参与技能伤害加成,
    isDamageTransfer: 参数.isDamageTransfer,
  });
  return { 是否造成伤害, 伤害 };
}

export function 提交预计算Boss技能伤害(this: void, 参数: Boss技能预计算伤害提交参数): Boss技能伤害执行结果 {
  return 提交Boss技能伤害结果(参数, 参数.伤害);
}

export function 提交预计算Boss单体技能伤害(this: void, 参数: Boss定形预计算伤害提交参数): Boss技能伤害执行结果 {
  return 提交预计算Boss技能伤害({ ...参数, 伤害形态: "单体" });
}

export function 提交预计算BossAOE技能伤害(this: void, 参数: Boss定形预计算伤害提交参数): Boss技能伤害执行结果 {
  return 提交预计算Boss技能伤害({ ...参数, 伤害形态: "AOE" });
}

export function 执行Boss技能伤害(this: void, 参数: Boss技能伤害执行参数): Boss技能伤害执行结果 {
  const 伤害 = 计算组合技能伤害(参数.来源, 参数.目标, 参数.伤害公式);
  return 提交Boss技能伤害结果(参数, 伤害);
}

export function 执行Boss单体技能伤害(this: void, 参数: Boss定形技能伤害执行参数): Boss技能伤害执行结果 {
  return 执行Boss技能伤害({ ...参数, 伤害形态: "单体" });
}

export function 执行BossAOE技能伤害(this: void, 参数: Boss定形技能伤害执行参数): Boss技能伤害执行结果 {
  return 执行Boss技能伤害({ ...参数, 伤害形态: "AOE" });
}
