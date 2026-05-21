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

const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};

const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用") as {
  applyEquipStatsTS: (this: void, unit: any, stats: { name: string; value: number }[]) => Record<string, number>;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const R2I = jass.R2I as (value: number) => number;

const 默认视野变化BuffID = "C035";
// 实际视野由 SGSS 的 ASV1..ASVU 固定技能池实现，按 50 视野一档同步；C035 只负责临时视野 Buff 表现。
const 视野变化技能倍率 = 50;

export interface 视野变化Buff参数 {
  BuffID?: string;
  持续时间: number;
  视野值: number;
  叠加键?: string;
  图标路径?: string;
  特效路径?: string;
}

interface 视野变化运行状态 {
  数值: number;
  到期时间: number;
  版本: number;
}

interface 视野变化聚合状态 {
  单位: any;
  BuffID: string;
  总数值: number;
  栈表: Record<string, 视野变化运行状态 | undefined>;
  来源名称?: string;
  图标路径?: string;
  特效路径?: string;
}

interface 视野变化到期记录 {
  单位: any;
  BuffID: string;
  叠加键: string;
  到期时间: number;
  版本: number;
}

const 视野变化状态表: Record<string, 视野变化聚合状态 | undefined> = {};
const 视野变化到期队列: 视野变化到期记录[] = [];
let 下一个视野变化叠加ID = 0;

function 取单位键(this: void, 单位: any, BuffID: string): string {
  if (单位 == null || 单位 === 0 || BuffID === "") return "";
  return GetHandleId(单位) + "|" + BuffID;
}

function 取有效BuffID(this: void, BuffID: string | undefined): string {
  return BuffID != null && BuffID !== "" ? BuffID : 默认视野变化BuffID;
}

function 取叠加键(this: void, 叠加键: string | undefined): string {
  if (叠加键 != null && 叠加键 !== "") return 叠加键;
  下一个视野变化叠加ID = 下一个视野变化叠加ID + 1;
  return "视野变化#" + 下一个视野变化叠加ID;
}

function 规范化视野值(this: void, 数值: number): number {
  if (数值 > 0) return R2I(数值 / 视野变化技能倍率 + 0.5) * 视野变化技能倍率;
  if (数值 < 0) return -R2I(-数值 / 视野变化技能倍率 + 0.5) * 视野变化技能倍率;
  return 0;
}

function 调整单位视野(this: void, 单位: any, 数值: number): void {
  if (单位 == null || 单位 === 0 || 数值 === 0) return;
  applyEquipStatsTS(单位, [{ name: "视野", value: 数值 }]);
}

function on视野变化移除(this: void, 单位: any, BuffID: string, _row: { effect: number }): void {
  const key = 取单位键(单位, BuffID);
  if (key === "") return;

  const 状态 = 视野变化状态表[key];
  delete 视野变化状态表[key];
  if (状态 == null) return;

  调整单位视野(单位, -状态.总数值);
}

function 刷新视野变化显示Buff(this: void, 状态: 视野变化聚合状态): void {
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
  if (!(总数值 !== 0) || !(最晚到期 > now)) {
    delete 视野变化状态表[取单位键(状态.单位, 状态.BuffID)];
    移除单位指定Buff(状态.单位, 状态.BuffID);
    return;
  }

  registerManualBuff(状态.单位, 状态.BuffID, (最晚到期 - now) / 1000, 总数值, {
    sourceName: 状态.来源名称,
    iconOverride: 状态.图标路径,
    effectModelOverride: 状态.特效路径,
    onRemove: on视野变化移除,
  });
}

function 处理视野变化到期(this: void): void {
  const now = getServerTime();
  let index = 0;
  while (index < 视野变化到期队列.length) {
    const 记录 = 视野变化到期队列[index];
    if (记录 == null || 记录.到期时间 > now) {
      index = index + 1;
      continue;
    }
    视野变化到期队列.splice(index, 1);

    const key = 取单位键(记录.单位, 记录.BuffID);
    if (key === "") continue;
    const 状态 = 视野变化状态表[key];
    if (状态 == null) continue;
    const 栈 = 状态.栈表[记录.叠加键];
    if (栈 == null || 栈.版本 !== 记录.版本) continue;

    delete 状态.栈表[记录.叠加键];
    调整单位视野(记录.单位, -栈.数值);
    刷新视野变化显示Buff(状态);
  }
}

export function 施加视野变化Buff(this: void, 来源单位: any, 目标单位: any, 参数: 视野变化Buff参数): boolean {
  if (目标单位 == null || 目标单位 === 0) return false;
  if (!(参数.持续时间 > 0) || 参数.视野值 === 0) return false;

  const BuffID = 取有效BuffID(参数.BuffID);
  const key = 取单位键(目标单位, BuffID);
  if (key === "") return false;

  let 状态 = 视野变化状态表[key];
  if (状态 == null) {
    状态 = { 单位: 目标单位, BuffID, 总数值: 0, 栈表: {} };
    视野变化状态表[key] = 状态;
  }

  const 叠加键 = 取叠加键(参数.叠加键);
  const 旧状态 = 状态.栈表[叠加键];
  const 旧值 = 旧状态 != null ? 旧状态.数值 : 0;
  const 生效视野值 = 规范化视野值(参数.视野值);
  if (生效视野值 === 0) return false;
  const 差值 = 生效视野值 - 旧值;
  if (差值 !== 0) {
    调整单位视野(目标单位, 差值);
  }

  const 版本 = 旧状态 != null ? 旧状态.版本 + 1 : 1;
  const 到期时间 = getServerTime() + 参数.持续时间 * 1000;
  状态.栈表[叠加键] = { 数值: 生效视野值, 到期时间, 版本 };
  状态.总数值 = 状态.总数值 + 差值;
  状态.来源名称 = 来源单位 != null && 来源单位 !== 0 ? GetUnitName(来源单位) : undefined;
  状态.图标路径 = 参数.图标路径;
  状态.特效路径 = 参数.特效路径;

  刷新视野变化显示Buff(状态);

  视野变化到期队列.push({ 单位: 目标单位, BuffID, 叠加键, 到期时间, 版本 });
  addDelayedCallback(参数.持续时间 * 1000, 处理视野变化到期);

  return true;
}

export function 移除单位视野变化Buff(this: void, 单位: any): boolean {
  return 移除单位指定Buff(单位, 默认视野变化BuffID);
}

export {};
