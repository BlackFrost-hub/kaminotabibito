/** @noSelfInFile */

import type { 机制清理篮子 } from "../../03．技能系统/00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";

export interface Boss阶段阈值配置 {
  P2生命比例?: number;
  P3生命比例?: number;
  P4生命比例?: number;
}

interface Boss阶段状态 {
  单位: any;
  阶段阈值: Boss阶段阈值配置;
  读取阶段序号: (this: void, 上下文: any) => number;
  上下文: any;
}

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, type: any) => boolean;
const 阶段状态表: Record<number, Boss阶段状态 | undefined> = {};

function 清理Boss阶段状态(this: void, 变量?: any): void {
  const 状态 = 变量 as Boss阶段状态;
  const id = GetHandleId(状态.单位);
  if (阶段状态表[id] === 状态) delete 阶段状态表[id];
}

export function 注册Boss阶段状态(
  this: void, 单位: any, 阶段阈值: Boss阶段阈值配置,
  读取阶段序号: (this: void, 上下文: any) => number, 上下文: any, 清理: 机制清理篮子,
): void {
  if (单位 == null || 单位 === 0) return;
  const 状态: Boss阶段状态 = { 单位, 阶段阈值, 读取阶段序号, 上下文 };
  阶段状态表[GetHandleId(单位)] = 状态;
  清理.登记清理("Boss阶段状态", 清理Boss阶段状态, 状态);
}

/** 读取实际已进入阶段，不从回血后的生命值反推阶段。 */
export function 读取Boss当前阶段阈值(this: void, 单位: any): number | undefined {
  if (单位 == null || 单位 === 0 || GetUnitTypeId(单位) === 0 || IsUnitType(单位, jass.UNIT_TYPE_DEAD)) return undefined;
  const 状态 = 阶段状态表[GetHandleId(单位)];
  if (状态 == null || 状态.单位 !== 单位) return undefined;
  const 阶段 = 状态.读取阶段序号(状态.上下文);
  if (阶段 >= 4 && 状态.阶段阈值.P4生命比例 != null) return 状态.阶段阈值.P4生命比例;
  if (阶段 >= 3 && 状态.阶段阈值.P3生命比例 != null) return 状态.阶段阈值.P3生命比例;
  if (阶段 >= 2 && 状态.阶段阈值.P2生命比例 != null) return 状态.阶段阈值.P2生命比例;
  return 1;
}

/** 数字阶段上下文共用此读取器；特殊阶段只在注册处转换一次。 */
export function 读取Boss阶段序号(this: void, 上下文: { 阶段: number }): number {
  return 上下文.阶段;
}
