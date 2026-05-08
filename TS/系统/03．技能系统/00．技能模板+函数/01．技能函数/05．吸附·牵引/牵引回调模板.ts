/** @noSelfInFile */
/**
 * 牵引回调模板
 *
 * 为吸附/牵引系统提供可复用的回调工厂函数。
 * 配合 `吸附牵引系统.ts` 的 `开始回调`、`结束回调`、`到达回调` 使用。
 */

const jass = require("jass.common") as any;

const AddSpecialEffect = jass["AddSpecialEffect"] as (modelPath: string, x: number, y: number) => any;
const DestroyEffect = jass["DestroyEffect"] as (effect: any) => void;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;
const UnitDamageTarget = jass["UnitDamageTarget"] as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;
const GroupEnumUnitsInRange = jass["GroupEnumUnitsInRange"] as (g: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass["FirstOfGroup"] as (g: any) => any;
const GroupRemoveUnit = jass["GroupRemoveUnit"] as (g: any, u: any) => void;
const CreateGroup = jass["CreateGroup"] as () => any;
const DestroyGroup = jass["DestroyGroup"] as (g: any) => void;
const IsUnitEnemy = jass["IsUnitEnemy"] as (u: any, p: any) => boolean;
const GetOwningPlayer = jass["GetOwningPlayer"] as (u: any) => any;

const { SFB_setBuff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setBuff: (this: void, sourceUnit: any, u: any, id: number, time: number) => void;
};

import type { 牵引结束原因 } from "./吸附牵引系统";

type 控制类型 = 0 | 1 | 2 | 3 | 5 | 21 | 22 | 23;

// ─── 单功能工厂函数 ──────────────────────────────────────

export function 创建牵引开始特效回调(模型路径: string): (单位: any, 牵引ID: number) => void {
  return function 牵引开始特效回调(单位: any, _牵引ID: number): void {
    const 特效 = AddSpecialEffect(模型路径, GetUnitX(单位), GetUnitY(单位));
    if (特效 != null && 特效 !== 0) {
      DestroyEffect(特效);
    }
  };
}

export function 创建牵引结束特效回调(模型路径: string): (单位: any, 原因: 牵引结束原因, 牵引ID: number) => void {
  return function 牵引结束特效回调(单位: any, _原因: 牵引结束原因, _牵引ID: number): void {
    const 特效 = AddSpecialEffect(模型路径, GetUnitX(单位), GetUnitY(单位));
    if (特效 != null && 特效 !== 0) {
      DestroyEffect(特效);
    }
  };
}

export function 创建牵引结束控制回调(控制ID: 控制类型, 持续时间: number): (单位: any, 原因: 牵引结束原因, 牵引ID: number) => void {
  return function 牵引结束控制回调(单位: any, 原因: 牵引结束原因, _牵引ID: number): void {
    if (原因 === "死亡") return;
    SFB_setBuff(单位, 单位, 控制ID, 持续时间);
  };
}

export function 创建牵引到达特效回调(模型路径: string): (单位: any, 牵引ID: number) => void {
  return function 牵引到达特效回调(单位: any, _牵引ID: number): void {
    const 特效 = AddSpecialEffect(模型路径, GetUnitX(单位), GetUnitY(单位));
    if (特效 != null && 特效 !== 0) {
      DestroyEffect(特效);
    }
  };
}

export function 创建牵引到达伤害回调(半径: number, 伤害: number, 来源?: any): (单位: any, 牵引ID: number) => void {
  return function 牵引到达伤害回调(单位: any, _牵引ID: number): void {
    const 中心X = GetUnitX(单位);
    const 中心Y = GetUnitY(单位);
    const 伤害来源 = 来源 ?? 单位;
    const 所属玩家 = GetOwningPlayer(伤害来源);

    const 枚举组 = CreateGroup();
    GroupEnumUnitsInRange(枚举组, 中心X, 中心Y, 半径, null);
    while (true) {
      const 目标 = FirstOfGroup(枚举组);
      if (目标 == null || 目标 === 0) break;
      GroupRemoveUnit(枚举组, 目标);
      if (IsUnitEnemy(目标, 所属玩家)) {
        UnitDamageTarget(伤害来源, 目标, 伤害, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_NORMAL, jass.WEAPON_TYPE_WHOKNOWS);
      }
    }
    DestroyGroup(枚举组);
  };
}

// ─── 合并工厂函数 ────────────────────────────────────────

export interface 牵引回调选项 {
  开始特效?: string;
  结束特效?: string;
  结束控制?: 控制类型;
  结束控制时间?: number;
  到达特效?: string;
  到达伤害?: number;
  到达伤害来源?: any;
  到达伤害半径?: number;
}

export interface 牵引回调结果 {
  开始回调?: (单位: any, 牵引ID: number) => void;
  结束回调?: (单位: any, 原因: 牵引结束原因, 牵引ID: number) => void;
  到达回调?: (单位: any, 牵引ID: number) => void;
}

export function 创建牵引回调(选项: 牵引回调选项): 牵引回调结果 {
  const 结果: 牵引回调结果 = {};

  if (选项.开始特效) {
    结果.开始回调 = 创建牵引开始特效回调(选项.开始特效);
  }

  const 结束回调列表: Array<(单位: any, 原因: 牵引结束原因, 牵引ID: number) => void> = [];
  if (选项.结束特效) {
    结束回调列表.push(创建牵引结束特效回调(选项.结束特效));
  }
  if (选项.结束控制 != null && 选项.结束控制时间 != null && 选项.结束控制时间 > 0) {
    结束回调列表.push(创建牵引结束控制回调(选项.结束控制, 选项.结束控制时间));
  }
  if (结束回调列表.length > 0) {
    结果.结束回调 = function 合并结束回调(单位: any, 原因: 牵引结束原因, 牵引ID: number): void {
      for (const 回调 of 结束回调列表) {
        回调(单位, 原因, 牵引ID);
      }
    };
  }

  const 到达回调列表: Array<(单位: any, 牵引ID: number) => void> = [];
  if (选项.到达特效) {
    到达回调列表.push(创建牵引到达特效回调(选项.到达特效));
  }
  if (选项.到达伤害 != null && 选项.到达伤害 > 0 && 选项.到达伤害半径 != null && 选项.到达伤害半径 > 0) {
    到达回调列表.push(创建牵引到达伤害回调(选项.到达伤害半径, 选项.到达伤害, 选项.到达伤害来源));
  }
  if (到达回调列表.length > 0) {
    结果.到达回调 = function 合并到达回调(单位: any, 牵引ID: number): void {
      for (const 回调 of 到达回调列表) {
        回调(单位, 牵引ID);
      }
    };
  }

  return 结果;
}

export {};
