/** @noSelfInFile */
/**
 * 落点打击系统 - 共享类型、常量与工具函数
 */

const jass = require("jass.common") as any;

export const AddSpecialEffect = jass.AddSpecialEffect as (path: string, x: number, y: number) => any;
export const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
export const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
export const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;

export const 默认落雷特效 = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl";
export const 默认攻击类型 = jass.ATTACK_TYPE_NORMAL;
export const 默认伤害类型 = jass.DAMAGE_TYPE_NORMAL;
export const 默认武器类型 = jass.WEAPON_TYPE_WHOKNOWS;

export interface 落点信息 {
  X: number;
  Y: number;
  触发延迟: number;
}

export interface 落点打击内部实例 {
  id: number;
  参数: 落点打击参数;
  落点列表: 落点信息[];
  剩余落点数: number;
  命中规则状态: any;
}

export interface 落点打击参数 {
  X: number;
  Y: number;
  延迟时间: number;
  伤害半径: number;
  提示半径?: number;
  伤害值?: number;
  所有者?: any;
  影响目标?: "敌方" | "友方" | "全部";
  落点数量?: number;
  落点间隔?: number;
  随机区域形状?: "圆形" | "矩形";
  随机散布半径?: number;
  随机矩形长度?: number;
  随机矩形宽度?: number;
  随机区域方向角?: number;
  最小落点间距?: number;
  随机取点最大尝试次数?: number;
  每单位最大命中次数?: number;
  提示特效启用?: boolean;
  提示特效动画速度?: number;
  落点特效模型?: string;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  on单次命中?: (this: void, 单位: any, 落点序号: number, 实例ID: number) => void;
  on单次生效?: (this: void, X: number, Y: number, 落点序号: number, 实例ID: number) => void;
  on全部完成?: (this: void, 实例ID: number) => void;
}

export const 落点打击实例表: Record<number, 落点打击内部实例 | undefined> = {};
export let 下一个落点打击ID = 0;

export function 推进下一个落点打击ID(this: void): number {
  下一个落点打击ID += 1;
  return 下一个落点打击ID;
}

export function 单位是否受影响(目标单位: any, 参数: 落点打击参数): boolean {
  const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
    isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
    isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  };

  const 影响目标 = 参数.影响目标 ?? "敌方";
  const 所有者 = 参数.所有者;
  if (影响目标 === "全部") return true;
  if (所有者 == null || 所有者 === 0) return true;
  if (影响目标 === "敌方") return isUnitEnemy(目标单位, 所有者);
  return isUnitAlly(目标单位, 所有者);
}
