/** @noSelfInFile */
/**
 * 通用函数 - 单位组便捷工具
 *
 * 提供单位组快照、伤害、Buff、过滤、排序等常用操作。
 * 统一收敛重复的 `快照单位组` 逻辑，并集成快速Buff系统。
 */

const jass = require("jass.common") as any;

const { SFB_setBuff, SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setBuff: (sourceUnit: any, u: any, id: number, time: number) => void;
  SFB_setSlow: (sourceUnit: any, u: any, as: number, ms: number, time: number) => void;
};
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};

export interface 单位组伤害标记选项 {
  来源类型?: "单位技能" | "Boss技能" | "召唤物技能" | "其他";
  技能ID?: number;
  技能实例ID?: number;
  技能标签?: string;
  参与技能伤害加成?: boolean;
}

// ─── 单位组快照 ──────────────────────────────────────────

const ForGroup = jass["ForGroup"] as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass["GetEnumUnit"] as () => any;

let 快照缓存: any[] = [];

function 收集成员(): void {
  const 单位 = GetEnumUnit();
  if (单位 != null && 单位 !== 0) {
    快照缓存.push(单位);
  }
}

/**
 * 将 JASS 单位组转为数组快照。
 * 使用 ForGroup + GetEnumUnit，与旧 JASS 模板兼容。
 */
export function 快照单位组(单位组: any): any[] {
  if (单位组 == null || 单位组 === 0) return [];
  快照缓存 = [];
  ForGroup(单位组, 收集成员);
  const 结果 = 快照缓存;
  快照缓存 = [];
  return 结果;
}

// ─── 单位组造成伤害 ──────────────────────────────────────

/**
 * 对单位组内所有单位造成伤害
 * @param 单位列表 单位数组（可用 快照单位组 或 getUnitsInRange 的返回值）
 * @param 来源 伤害来源单位
 * @param 伤害值 伤害数值
 * @param 伤害类型 可选，默认 DAMAGE_TYPE_NORMAL
 */
export function 单位组造成伤害(
  单位列表: any[],
  来源: any,
  伤害值: number,
  伤害类型?: any,
  标记?: 单位组伤害标记选项
): void {
  if (!单位列表 || 单位列表.length === 0) return;
  if (伤害值 <= 0) return;
  const 类型 = 伤害类型 ?? jass.DAMAGE_TYPE_NORMAL;
  for (const 单位 of 单位列表) {
    造成AOE技能伤害({
      来源: 来源 ?? 单位,
      目标: 单位,
      伤害: 伤害值,
      伤害类型: 类型,
      ranged: false,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: 标记?.来源类型 ?? "单位技能",
      技能ID: 标记?.技能ID,
      技能实例ID: 标记?.技能实例ID,
      标签: 标记?.技能标签,
      参与技能伤害加成: 标记?.参与技能伤害加成,
    });
  }
}

// ─── 单位组施加控制 Buff ─────────────────────────────────

/**
 * Buff 类型枚举
 * 0=击晕, 1=冰冻, 2=沉默, 3=变形, 5=缴械, 21=硬直, 22=暂停, 23=EX暂停
 */
export type 控制类型 = 0 | 1 | 2 | 3 | 5 | 21 | 22 | 23;

/**
 * 对单位组内所有单位施加控制 Buff
 * @param 单位列表 单位数组
 * @param 来源 Buff来源单位（用于BuffUI显示）
 * @param 控制ID Buff类型
 * @param 持续时间 秒
 */
export function 单位组施加控制(
  单位列表: any[],
  来源: any,
  控制ID: 控制类型,
  持续时间: number
): void {
  if (!单位列表 || 单位列表.length === 0) return;
  if (持续时间 <= 0) return;
  for (const 单位 of 单位列表) {
    SFB_setBuff(来源, 单位, 控制ID, 持续时间);
  }
}

/**
 * 对单位组内所有单位施加减速
 * @param 单位列表 单位数组
 * @param 来源 Buff来源单位
 * @param 降低攻速 百分比
 * @param 降低移速 百分比
 * @param 持续时间 秒
 */
export function 单位组施加减速(
  单位列表: any[],
  来源: any,
  降低攻速: number,
  降低移速: number,
  持续时间: number
): void {
  if (!单位列表 || 单位列表.length === 0) return;
  if (持续时间 <= 0) return;
  for (const 单位 of 单位列表) {
    SFB_setSlow(来源, 单位, 降低攻速, 降低移速, 持续时间);
  }
}

// ─── 单位组过滤 ─────────────────────────────────────────

/**
 * 按条件过滤单位数组
 * @param 单位列表 单位数组
 * @param 条件 过滤函数，返回 true 保留
 */
export function 单位组过滤(单位列表: any[], 条件: (单位: any) => boolean): any[] {
  if (!单位列表) return [];
  const 结果: any[] = [];
  for (const 单位 of 单位列表) {
    if (条件(单位)) 结果.push(单位);
  }
  return 结果;
}

/**
 * 只保留敌方单位
 */
export function 过滤敌方(单位列表: any[], 所有者: any): any[] {
  return 单位组过滤(单位列表, (u) => jass.IsUnitEnemy(u, 所有者));
}

/**
 * 只保留友方单位（不含自身）
 */
export function 过滤友方排除自身(单位列表: any[], 所有者: any): any[] {
  return 单位组过滤(单位列表, (u) => u !== 所有者 && jass.IsUnitAlly(u, 所有者));
}

// ─── 单位组排序 ─────────────────────────────────────────

/**
 * 按距离指定坐标从近到远排序
 */
export function 单位组按距离排序(单位列表: any[], 中心X: number, 中心Y: number): any[] {
  if (!单位列表) return [];
  const 拷贝 = [...单位列表];
  拷贝.sort((a, b) => {
    const dxA = jass.GetUnitX(a) - 中心X;
    const dyA = jass.GetUnitY(a) - 中心Y;
    const dxB = jass.GetUnitX(b) - 中心X;
    const dyB = jass.GetUnitY(b) - 中心Y;
    return (dxA * dxA + dyA * dyA) - (dxB * dxB + dyB * dyB);
  });
  return 拷贝;
}

/**
 * 按生命值从低到高排序
 */
export function 单位组按生命排序(单位列表: any[]): any[] {
  if (!单位列表) return [];
  const 拷贝 = [...单位列表];
  拷贝.sort((a, b) => {
    return (jass.GetUnitState(a, jass.UNIT_STATE_LIFE) as number)
      - (jass.GetUnitState(b, jass.UNIT_STATE_LIFE) as number);
  });
  return 拷贝;
}

export {};
