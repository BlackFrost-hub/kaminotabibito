/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (
    this: void,
    target: any,
    buffID: string,
    durationSec: number,
    effectValue: number,
    extras?: {
      sourceName?: string;
      iconOverride?: string;
      effectModelOverride?: string;
      onRemove?: (this: void, unit: any, buffID: string, row: { effect: number }) => void;
    }
  ) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { matchUnitFilter, isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  matchUnitFilter: (this: void, targetUnit: any, sourceUnit: any, options: 护甲降低范围筛选) => boolean;
  isValidUnit: (this: void, unit: any) => boolean;
};
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const 默认护甲降低BuffID = "C032";
const 护甲属性ID = 2;

interface 护甲降低运行状态 {
  数值: number;
  到期时间: number;
  版本: number;
}

interface 护甲降低聚合状态 {
  单位: any;
  BuffID: string;
  总数值: number;
  栈表: Record<string, 护甲降低运行状态 | undefined>;
}

interface 护甲降低到期记录 {
  单位: any;
  BuffID: string;
  叠加键: string;
  到期时间: number;
  版本: number;
}

export interface 护甲降低范围筛选 {
  仅敌人?: boolean;
  仅友军?: boolean;
  排除自身?: boolean;
  要求有效单位?: boolean;
  允许建筑?: boolean;
  允许机械?: boolean;
  允许古树?: boolean;
  允许无敌?: boolean;
  允许死亡?: boolean;
  自定义条件?: (targetUnit: any, sourceUnit?: any) => boolean;
}

export interface 护甲降低Buff参数 {
  BuffID?: string;
  持续时间: number;
  护甲: number;
  叠加键?: string;
  图标路径?: string;
  特效路径?: string;
}

export interface 范围护甲降低Buff参数 extends 护甲降低Buff参数 {
  x?: number;
  y?: number;
  中心单位?: any;
  范围: number;
  筛选?: 护甲降低范围筛选;
}

const 护甲降低状态表: Record<string, 护甲降低聚合状态 | undefined> = {};
const 护甲降低到期队列: 护甲降低到期记录[] = [];
let 下一个护甲降低叠加ID = 0;

function 取单位键(this: void, 单位: any, BuffID: string): string {
  if (单位 == null || 单位 === 0 || BuffID === "") return "";
  return GetHandleId(单位) + "|" + BuffID;
}

function 取有效BuffID(this: void, BuffID: string | undefined): string {
  return BuffID != null && BuffID !== "" ? BuffID : 默认护甲降低BuffID;
}

function 取叠加键(this: void, 叠加键: string | undefined): string {
  if (叠加键 != null && 叠加键 !== "") return 叠加键;
  下一个护甲降低叠加ID = 下一个护甲降低叠加ID + 1;
  return "护甲降低#" + 下一个护甲降低叠加ID;
}

function 调整单位护甲(this: void, 单位: any, 数值: number): void {
  if (单位 == null || 单位 === 0 || 数值 === 0) return;
  SGSS_SetState(单位, 护甲属性ID, 数值);
}

function on护甲降低移除(this: void, 单位: any, BuffID: string, _row: { effect: number }): void {
  const key = 取单位键(单位, BuffID);
  if (key === "") return;

  const 状态 = 护甲降低状态表[key];
  delete 护甲降低状态表[key];
  if (状态 == null) return;

  调整单位护甲(单位, 状态.总数值);
}

function 刷新护甲降低显示Buff(this: void, 状态: 护甲降低聚合状态, 来源名称?: string, 图标路径?: string, 特效路径?: string): void {
  const now = getServerTime();
  let 总数值 = 0;
  let 最晚到期 = 0;
  for (const 叠加键 in 状态.栈表) {
    const 栈 = 状态.栈表[叠加键];
    if (栈 == null) continue;
    总数值 = 总数值 + 栈.数值;
    if (栈.到期时间 > 最晚到期) 最晚到期 = 栈.到期时间;
  }

  状态.总数值 = 总数值;
  if (!(总数值 > 0) || !(最晚到期 > now)) {
    delete 护甲降低状态表[取单位键(状态.单位, 状态.BuffID)];
    移除单位指定Buff(状态.单位, 状态.BuffID);
    return;
  }

  registerManualBuff(状态.单位, 状态.BuffID, (最晚到期 - now) / 1000, 总数值, {
    sourceName: 来源名称,
    iconOverride: 图标路径,
    effectModelOverride: 特效路径,
    onRemove: on护甲降低移除,
  });
}

function 处理护甲降低到期(this: void): void {
  const now = getServerTime();
  let index = 0;
  while (index < 护甲降低到期队列.length) {
    const 记录 = 护甲降低到期队列[index];
    if (记录 == null || 记录.到期时间 > now) {
      index++;
      continue;
    }
    护甲降低到期队列.splice(index, 1);

    const key = 取单位键(记录.单位, 记录.BuffID);
    if (key === "") continue;
    const 状态 = 护甲降低状态表[key];
    if (状态 == null) continue;
    const 栈 = 状态.栈表[记录.叠加键];
    if (栈 == null || 栈.版本 !== 记录.版本) continue;

    delete 状态.栈表[记录.叠加键];
    调整单位护甲(记录.单位, 栈.数值);
    刷新护甲降低显示Buff(状态);
  }
}

export function 施加单体护甲降低Buff(this: void, 来源单位: any, 目标单位: any, 参数: 护甲降低Buff参数): boolean {
  if (来源单位 == null || 来源单位 === 0) return false;
  if (目标单位 == null || 目标单位 === 0) return false;
  if (!(参数.持续时间 > 0) || !(参数.护甲 > 0)) return false;
  if (!isValidUnit(目标单位)) return false;

  const BuffID = 取有效BuffID(参数.BuffID);
  const key = 取单位键(目标单位, BuffID);
  if (key === "") return false;

  let 状态 = 护甲降低状态表[key];
  if (状态 == null) {
    状态 = { 单位: 目标单位, BuffID, 总数值: 0, 栈表: {} };
    护甲降低状态表[key] = 状态;
  }

  const 叠加键 = 取叠加键(参数.叠加键);
  const 旧状态 = 状态.栈表[叠加键];
  const 旧值 = 旧状态 != null ? 旧状态.数值 : 0;
  const 生效护甲 = 参数.护甲;
  const 差值 = 生效护甲 - 旧值;
  if (差值 !== 0) {
    调整单位护甲(目标单位, -差值);
  }

  const 版本 = 旧状态 != null ? 旧状态.版本 + 1 : 1;
  const 到期时间 = getServerTime() + 参数.持续时间 * 1000;
  状态.栈表[叠加键] = { 数值: 生效护甲, 到期时间, 版本 };
  状态.总数值 = 状态.总数值 + 差值;

  刷新护甲降低显示Buff(状态, GetUnitName(来源单位), 参数.图标路径, 参数.特效路径);

  护甲降低到期队列.push({ 单位: 目标单位, BuffID, 叠加键, 到期时间, 版本 });
  addDelayedCallback(参数.持续时间 * 1000, 处理护甲降低到期);

  return true;
}

export function 施加范围护甲降低Buff(this: void, 来源单位: any, 参数: 范围护甲降低Buff参数): number {
  if (来源单位 == null || 来源单位 === 0) return 0;
  if (!(参数.范围 > 0)) return 0;

  const 中心单位 = 参数.中心单位 != null && 参数.中心单位 !== 0 ? 参数.中心单位 : 来源单位;
  const x = 参数.x != null ? 参数.x : GetUnitX(中心单位);
  const y = 参数.y != null ? 参数.y : GetUnitY(中心单位);
  const 单位列表 = getUnitsInRange(x, y, 参数.范围);
  const 筛选 = 参数.筛选 ?? { 仅敌人: true, 排除自身: false };
  let 成功数量 = 0;

  for (let i = 0; i < 单位列表.length; i++) {
    const 目标单位 = 单位列表[i];
    if (!matchUnitFilter(目标单位, 来源单位, 筛选)) continue;
    if (施加单体护甲降低Buff(来源单位, 目标单位, 参数)) {
      成功数量 = 成功数量 + 1;
    }
  }

  return 成功数量;
}

export {};
