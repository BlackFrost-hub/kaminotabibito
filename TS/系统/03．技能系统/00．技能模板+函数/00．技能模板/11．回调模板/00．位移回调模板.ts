/** @noSelfInFile */
/**
 * 位移回调模板
 *
 * 为冲锋/击退系统提供可复用的回调工厂函数。
 * 配合 `击退系统.ts` 的 `开始回调`、`结束回调`、`命中回调` 使用。
 */

const jass = require("jass.common") as any;

const AddSpecialEffect = jass["AddSpecialEffect"] as (modelPath: string, x: number, y: number) => any;
const DestroyEffect = jass["DestroyEffect"] as (effect: any) => void;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;

const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};

const { SFB_setBuff, SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setBuff: (this: void, sourceUnit: any, u: any, id: number, time: number) => void;
  SFB_setSlow: (this: void, sourceUnit: any, u: any, as: number, ms: number, time: number) => void;
};

import type { 位移结束原因 } from "../../01．技能函数/02．冲锋·击退/击退系统";

type 控制类型 = 0 | 1 | 2 | 3 | 5 | 21 | 22 | 23;

export interface 位移伤害标记选项 {
  来源类型?: "单位技能" | "Boss技能" | "召唤物技能" | "其他";
  技能ID?: number;
  技能实例ID?: number;
  技能标签?: string;
  参与技能伤害加成?: boolean;
}

// ─── 单功能工厂函数 ──────────────────────────────────────

export function 创建位移开始特效回调(模型路径: string): (单位: any, ID: number) => void {
  return function 位移开始特效回调(单位: any, _ID: number): void {
    const 特效 = AddSpecialEffect(模型路径, GetUnitX(单位), GetUnitY(单位));
    if (特效 != null && 特效 !== 0) {
      DestroyEffect(特效);
    }
  };
}

export function 创建位移结束特效回调(模型路径: string): (单位: any, 原因: 位移结束原因, ID: number) => void {
  return function 位移结束特效回调(单位: any, _原因: 位移结束原因, _ID: number): void {
    const 特效 = AddSpecialEffect(模型路径, GetUnitX(单位), GetUnitY(单位));
    if (特效 != null && 特效 !== 0) {
      DestroyEffect(特效);
    }
  };
}

export function 创建位移结束伤害回调(伤害: number, 来源?: any, 标记?: 位移伤害标记选项): (单位: any, 原因: 位移结束原因, ID: number) => void {
  return function 位移结束伤害回调(单位: any, 原因: 位移结束原因, _ID: number): void {
    if (原因 === "死亡" || 原因 === "主单位死亡") return;
    const 伤害来源 = 来源 ?? 单位;
    造成单体技能伤害({
      来源: 伤害来源,
      目标: 单位,
      伤害,
      伤害类型: jass.DAMAGE_TYPE_NORMAL,
      ranged: false,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: 标记?.来源类型 ?? "单位技能",
      技能ID: 标记?.技能ID,
      技能实例ID: 标记?.技能实例ID,
      标签: 标记?.技能标签,
      参与技能伤害加成: 标记?.参与技能伤害加成,
    });
  };
}

export function 创建位移结束控制回调(控制ID: 控制类型, 持续时间: number): (单位: any, 原因: 位移结束原因, ID: number) => void {
  return function 位移结束控制回调(单位: any, 原因: 位移结束原因, _ID: number): void {
    if (原因 === "死亡" || 原因 === "主单位死亡") return;
    SFB_setBuff(单位, 单位, 控制ID, 持续时间);
  };
}

export function 创建命中特效回调(模型路径: string): (移动单位: any, 目标单位: any, ID: number) => void {
  return function 命中特效回调(_移动单位: any, 目标单位: any, _ID: number): void {
    const 特效 = AddSpecialEffect(模型路径, GetUnitX(目标单位), GetUnitY(目标单位));
    if (特效 != null && 特效 !== 0) {
      DestroyEffect(特效);
    }
  };
}

export function 创建命中控制回调(控制ID: 控制类型, 持续时间: number): (移动单位: any, 目标单位: any, ID: number) => void {
  return function 命中控制回调(移动单位: any, 目标单位: any, _ID: number): void {
    SFB_setBuff(移动单位, 目标单位, 控制ID, 持续时间);
  };
}

// ─── 合并工厂函数 ────────────────────────────────────────

export interface 位移回调选项 {
  开始特效?: string;
  结束特效?: string;
  结束伤害?: number;
  结束伤害来源?: any;
  结束伤害标记?: 位移伤害标记选项;
  结束控制?: 控制类型;
  结束控制时间?: number;
  命中特效?: string;
  命中控制?: 控制类型;
  命中控制时间?: number;
}

export interface 位移回调结果 {
  开始回调?: (单位: any, ID: number) => void;
  结束回调?: (单位: any, 原因: 位移结束原因, ID: number, 命中目标?: any) => void;
  命中回调?: (移动单位: any, 目标单位: any, ID: number) => void;
}

export function 创建位移回调(选项: 位移回调选项): 位移回调结果 {
  const 结果: 位移回调结果 = {};

  if (选项.开始特效) {
    结果.开始回调 = 创建位移开始特效回调(选项.开始特效);
  }

  const 结束回调列表: Array<(单位: any, 原因: 位移结束原因, ID: number) => void> = [];
  if (选项.结束特效) {
    结束回调列表.push(创建位移结束特效回调(选项.结束特效));
  }
  if (选项.结束伤害 != null && 选项.结束伤害 > 0) {
    结束回调列表.push(创建位移结束伤害回调(选项.结束伤害, 选项.结束伤害来源, 选项.结束伤害标记));
  }
  if (选项.结束控制 != null && 选项.结束控制时间 != null && 选项.结束控制时间 > 0) {
    结束回调列表.push(创建位移结束控制回调(选项.结束控制, 选项.结束控制时间));
  }
  if (结束回调列表.length > 0) {
    结果.结束回调 = function 合并结束回调(单位: any, 原因: 位移结束原因, ID: number): void {
      for (const 回调 of 结束回调列表) {
        回调(单位, 原因, ID);
      }
    };
  }

  const 命中回调列表: Array<(移动单位: any, 目标单位: any, ID: number) => void> = [];
  if (选项.命中特效) {
    命中回调列表.push(创建命中特效回调(选项.命中特效));
  }
  if (选项.命中控制 != null && 选项.命中控制时间 != null && 选项.命中控制时间 > 0) {
    命中回调列表.push(创建命中控制回调(选项.命中控制, 选项.命中控制时间));
  }
  if (命中回调列表.length > 0) {
    结果.命中回调 = function 合并命中回调(移动单位: any, 目标单位: any, ID: number): void {
      for (const 回调 of 命中回调列表) {
        回调(移动单位, 目标单位, ID);
      }
    };
  }

  return 结果;
}

export {};
