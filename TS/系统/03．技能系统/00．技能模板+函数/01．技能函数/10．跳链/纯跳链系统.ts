/** @noSelfInFile */
/**
 * 纯跳链系统
 *
 * 说明：
 * 1. 用于闪电链、治疗波、跳火等“不需要飞行物”的链式技能。
 * 2. 核心职责是：命中当前目标、查找下一跳、控制跳数/距离/衰减。
 * 3. 闪电表现独立于弹幕系统，不依赖飞行轨迹。
 */

const jass = require("jass.common") as any;

const CreateTimer = jass.CreateTimer as () => any;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;

const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};

import { 创建单位绑定闪电 } from "./单位绑定闪电";

const { isUnitEnemy, isUnitAlly, isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isValidUnit: (this: void, unit: any) => boolean;
};

const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    ItemHeal: boolean;
    HealEffect: boolean;
    HealEffectPath?: string;
  }) => number;
};

const { 选择范围内最近目标 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.02．选目标模板.00．目标筛选模板") as {
  选择范围内最近目标: (this: void, 参数: {
    X: number;
    Y: number;
    半径: number;
    来源单位?: any;
    影响目标?: "敌方" | "友方" | "全部";
    自定义条件?: (this: void, 单位: any) => boolean;
  }) => any;
};

export type 跳链模式 = "伤害" | "治疗";
export type 跳链结束原因 = "完成" | "无有效目标" | "初始目标无效" | "中断";
export type 跳链影响目标 = "敌方" | "友方" | "全部";
export type 跳链目标筛选 = (单位: any, 当前目标: any, 已完成跳数: number) => boolean;
export type 跳链每跳回调 = (单位: any, 数值: number, 当前跳数: number, 跳链ID: number) => void;
export type 跳链结束回调 = (原因: 跳链结束原因, 已完成跳数: number, 跳链ID: number) => void;

export interface 纯跳链参数 {
  起始目标: any;
  来源单位?: any;
  模式?: 跳链模式;
  影响目标?: 跳链影响目标;
  最大跳数: number;
  每跳最大距离: number;
  初始数值: number;
  每跳衰减系数?: number;
  允许重复命中?: boolean;
  跳跃间隔?: number;
  闪电效果代码?: string;
  闪电持续时间?: number;
  治疗特效路径?: string;
  目标筛选?: 跳链目标筛选;
  每跳回调?: 跳链每跳回调;
  结束回调?: 跳链结束回调;
}

export interface 纯跳链实例 {
  readonly 跳链ID: number;
  中断(): void;
}

interface 纯跳链内部实例 {
  id: number;
  参数: 纯跳链参数;
  当前目标: any;
  上一跳目标?: any;
  当前数值: number;
  已完成跳数: number;
  已命中单位: Record<number, true | undefined>;
  下一跳定时器?: any;
  待执行下一目标?: any;
  已结束: boolean;
}

const 默认闪电效果代码 = "CLPB";
// 约定规则：
// 跳链层默认闪电持续时间与底层单位绑定闪电保持一致，
// 默认值使用 0.8 秒；即使外部传入更短时间，底层也会强制提升到 0.8 秒。
const 活跃跳链映射: Record<number, 纯跳链内部实例 | undefined> = {};
const 定时器跳链映射: Record<number, number | undefined> = {};
let 下一个跳链ID = 0;


function 取句柄ID(handle: any): number {
  return handle != null && handle !== 0 ? (GetHandleId(handle) || 0) : 0;
}

function 单位满足影响目标(单位: any, 来源单位: any, 影响目标: 跳链影响目标): boolean {
  if (影响目标 === "全部") return true;
  if (来源单位 == null || 来源单位 === 0) return true;
  if (影响目标 === "敌方") {
    return isUnitEnemy(单位, 来源单位);
  }
  return isUnitAlly(单位, 来源单位);
}

function 单位可作为跳链目标(实例: 纯跳链内部实例, 单位: any, 当前目标: any): boolean {
  if (!isValidUnit(单位)) return false;
  if (单位 == null || 单位 === 0) return false;
  if (单位 === 当前目标) return false;
  const 单位ID = 取句柄ID(单位);
  if (单位ID <= 0) return false;
  if (实例.参数.允许重复命中 !== true && 实例.已命中单位[单位ID] === true) {
    return false;
  }

  const 模式 = 实例.参数.模式 ?? "伤害";
  const 影响目标 = 实例.参数.影响目标 ?? (模式 === "治疗" ? "友方" : "敌方");
  if (!单位满足影响目标(单位, 实例.参数.来源单位, 影响目标)) {
    return false;
  }

  const 目标筛选 = 实例.参数.目标筛选;
  if (目标筛选 != null && !目标筛选(单位, 当前目标, 实例.已完成跳数)) {
    return false;
  }
  return true;
}

function 查找下一跳目标(实例: 纯跳链内部实例, 当前目标: any): any {
  const x = GetUnitX(当前目标);
  const y = GetUnitY(当前目标);
  const 模式 = 实例.参数.模式 ?? "伤害";
  const 影响目标 = 实例.参数.影响目标 ?? (模式 === "治疗" ? "友方" : "敌方");
  return 选择范围内最近目标({
    X: x,
    Y: y,
    半径: 实例.参数.每跳最大距离,
    来源单位: 实例.参数.来源单位,
    影响目标,
    自定义条件: function (单位: any): boolean {
      return 单位可作为跳链目标(实例, 单位, 当前目标);
    },
  });
}

function 创建跳链闪电(起点单位: any, 终点单位: any, 效果代码: string, 持续时间: number): void {
  创建单位绑定闪电({
    效果代码,
    起点单位,
    终点单位,
    持续时间,
    起点高度偏移: 60,
    终点高度偏移: 60,
    任一死亡时销毁: true,
  });
}

function 结束跳链实例(实例: 纯跳链内部实例, 原因: 跳链结束原因): void {
  if (实例.已结束) return;
  实例.已结束 = true;

  if (实例.下一跳定时器 != null && 实例.下一跳定时器 !== 0) {
    const 定时器ID = 取句柄ID(实例.下一跳定时器);
    if (定时器ID > 0) {
      delete 定时器跳链映射[定时器ID];
    }
    safeDestroyTimer(实例.下一跳定时器);
    实例.下一跳定时器 = undefined;
  }

  delete 活跃跳链映射[实例.id];
  const 结束回调 = 实例.参数.结束回调;
  if (结束回调 != null) {
    结束回调(原因, 实例.已完成跳数, 实例.id);
  }
}

function 执行当前一跳(实例: 纯跳链内部实例): void {
  if (实例.已结束) return;
  const 当前目标 = 实例.当前目标;
  if (!isValidUnit(当前目标)) {
    结束跳链实例(实例, 实例.已完成跳数 > 0 ? "完成" : "初始目标无效");
    return;
  }

  if (实例.上一跳目标 != null) {
    创建跳链闪电(
      实例.上一跳目标,
      当前目标,
      实例.参数.闪电效果代码 ?? 默认闪电效果代码,
      实例.参数.闪电持续时间 != null && 实例.参数.闪电持续时间 > 0 ? 实例.参数.闪电持续时间 : 0.8
    );
  } else if (实例.参数.来源单位 != null && 实例.参数.来源单位 !== 0) {
    创建跳链闪电(
      实例.参数.来源单位,
      当前目标,
      实例.参数.闪电效果代码 ?? 默认闪电效果代码,
      实例.参数.闪电持续时间 != null && 实例.参数.闪电持续时间 > 0 ? 实例.参数.闪电持续时间 : 0.8
    );
  }

  const 模式 = 实例.参数.模式 ?? "伤害";
  if (模式 === "治疗") {
    doHeal({
      HealSource: 实例.参数.来源单位 ?? 当前目标,
      HealTarget: 当前目标,
      HealAmount: 实例.当前数值,
      ItemHeal: false,
      HealEffect: false,
      HealEffectPath: 实例.参数.治疗特效路径,
    });
  } else {
    UnitDamageTarget(
      实例.参数.来源单位 ?? 当前目标,
      当前目标,
      实例.当前数值,
      false,
      false,
      ATTACK_TYPE_NORMAL,
      DAMAGE_TYPE_NORMAL,
      WEAPON_TYPE_WHOKNOWS
    );
  }

  const 当前目标ID = 取句柄ID(当前目标);
  if (当前目标ID > 0) {
    实例.已命中单位[当前目标ID] = true;
  }
  实例.已完成跳数 += 1;

  const 每跳回调 = 实例.参数.每跳回调;
  if (每跳回调 != null) {
    每跳回调(当前目标, 实例.当前数值, 实例.已完成跳数, 实例.id);
  }

  if (实例.已完成跳数 >= 实例.参数.最大跳数) {
    结束跳链实例(实例, "完成");
    return;
  }

  const 下一目标 = 查找下一跳目标(实例, 当前目标);
  if (下一目标 == null || 下一目标 === 0) {
    结束跳链实例(实例, 实例.已完成跳数 > 0 ? "完成" : "无有效目标");
    return;
  }

  const 衰减 = 实例.参数.每跳衰减系数 != null && 实例.参数.每跳衰减系数 > 0
    ? 实例.参数.每跳衰减系数
    : 1.0;
  实例.上一跳目标 = 当前目标;
  实例.当前目标 = 下一目标;
  实例.当前数值 = 实例.当前数值 * 衰减;

  const 跳跃间隔 = 实例.参数.跳跃间隔 != null && 实例.参数.跳跃间隔 > 0
    ? 实例.参数.跳跃间隔
    : 0;
  if (跳跃间隔 <= 0) {
    执行当前一跳(实例);
    return;
  }

  const timer = CreateTimer();
  if (timer == null || timer === 0) {
    执行当前一跳(实例);
    return;
  }
  const 定时器ID = 取句柄ID(timer);
  if (定时器ID <= 0) {
    safeDestroyTimer(timer);
    执行当前一跳(实例);
    return;
  }
  实例.下一跳定时器 = timer;
  定时器跳链映射[定时器ID] = 实例.id;
  safeTimerStart(timer, 跳跃间隔, false, on纯跳链下一跳到时);
}

function on纯跳链下一跳到时(): void {
  const timer = GetExpiredTimer();
  if (timer == null || timer === 0) return;
  const 定时器ID = 取句柄ID(timer);
  const 跳链ID = 定时器跳链映射[定时器ID];
  delete 定时器跳链映射[定时器ID];
  safeDestroyTimer(timer);

  if (跳链ID == null || 跳链ID <= 0) return;
  const 实例 = 活跃跳链映射[跳链ID];
  if (实例 == null || 实例.已结束) return;
  实例.下一跳定时器 = undefined;
  执行当前一跳(实例);
}

class 纯跳链实例实现 implements 纯跳链实例 {
  readonly 跳链ID: number;

  constructor(跳链ID: number) {
    this.跳链ID = 跳链ID;
  }

  中断(): void {
    const 实例 = 活跃跳链映射[this.跳链ID];
    if (实例 == null) return;
    结束跳链实例(实例, "中断");
  }
}

export function 开始纯跳链(参数: 纯跳链参数): 纯跳链实例 | null {
  if (参数.起始目标 == null || 参数.起始目标 === 0) return null;
  if (参数.最大跳数 <= 0) return null;
  if (参数.每跳最大距离 <= 0) return null;
  if (参数.初始数值 <= 0) return null;
  if (!isValidUnit(参数.起始目标)) return null;

  const 模式 = 参数.模式 ?? "伤害";
  const 影响目标 = 参数.影响目标 ?? (模式 === "治疗" ? "友方" : "敌方");
  if (!单位满足影响目标(参数.起始目标, 参数.来源单位, 影响目标)) {
    return null;
  }
  if (参数.目标筛选 != null && !参数.目标筛选(参数.起始目标, 参数.起始目标, 0)) {
    return null;
  }

  下一个跳链ID += 1;
  const 跳链ID = 下一个跳链ID;
  const 实例: 纯跳链内部实例 = {
    id: 跳链ID,
    参数,
    当前目标: 参数.起始目标,
    上一跳目标: undefined,
    当前数值: 参数.初始数值,
    已完成跳数: 0,
    已命中单位: {},
    下一跳定时器: undefined,
    待执行下一目标: undefined,
    已结束: false,
  };
  活跃跳链映射[跳链ID] = 实例;
  执行当前一跳(实例);
  return 活跃跳链映射[跳链ID] != null ? new 纯跳链实例实现(跳链ID) : null;
}

export function 停止纯跳链(跳链ID: number): boolean {
  const 实例 = 活跃跳链映射[跳链ID];
  if (实例 == null) return false;
  结束跳链实例(实例, "中断");
  return true;
}
