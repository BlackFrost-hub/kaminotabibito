/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 施加隐身, 移除隐身, 单位是否隐身中 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.15．隐身.隐身系统") as {
  施加隐身: (this: void, unit: any, params: { 持续时间: number; 破隐固定额外伤害?: number; 破隐伤害倍率?: number; 破隐额外暗属性伤害倍率?: number; 来源单位?: any }) => number;
  移除隐身: (this: void, unit: any) => boolean;
  单位是否隐身中: (this: void, unit: any) => boolean;
};
const { 施加移速提升Buff, 清除单位指定Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加移速提升Buff: (this: void, source: any, target: any, params: {
    持续时间: number;
    固定移速?: number;
    基础移速百分比?: number;
    当前移速百分比?: number;
    BuffID?: string;
    sourceName?: string;
  }) => boolean;
  清除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 潜行状态参数 {
  单位: any;
  来源单位?: any;
  名称?: string;
  持续秒数: number;
  固定移速?: number;
  基础移速百分比?: number;
  当前移速百分比?: number;
  移速BuffID?: string;
  破隐固定额外伤害?: number;
  破隐伤害倍率?: number;
  破隐额外暗属性伤害倍率?: number;
  on开始?: (this: void, 状态: 潜行状态实例) => void;
  on结束?: (this: void, 状态: 潜行状态实例, 原因: 潜行结束原因) => void;
}

export type 潜行结束原因 = "到期" | "破隐" | "刷新覆盖" | "手动移除";

export interface 潜行状态实例 {
  readonly 单位: any;
  readonly 单位ID: number;
  readonly 名称: string;
  readonly 移速BuffID: string;
  移除(this: void, 原因?: 潜行结束原因): void;
}

interface 潜行状态记录 extends 潜行状态实例 {
  参数: 潜行状态参数;
  到期回调ID: number;
  已结束: boolean;
}

const 默认潜行移速BuffID = "C033";
const 潜行状态表: Record<number, 潜行状态记录 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 结束潜行记录(this: void, record: 潜行状态记录, 原因: 潜行结束原因): void {
  if (record.已结束) return;
  record.已结束 = true;
  if (record.到期回调ID !== 0) removeDelayedCallback(record.到期回调ID);
  delete 潜行状态表[record.单位ID];

  移除隐身(record.单位);
  清除单位指定Buff(record.单位, record.移速BuffID);

  if (record.参数.on结束 != null) record.参数.on结束(record, 原因);
}

function 创建潜行记录(this: void, 参数: 潜行状态参数, 单位ID: number): 潜行状态记录 {
  const 名称 = 参数.名称 ?? "潜行状态";
  const 移速BuffID = 参数.移速BuffID ?? 默认潜行移速BuffID;
  const record: 潜行状态记录 = {
    单位: 参数.单位,
    单位ID,
    名称,
    移速BuffID,
    参数,
    到期回调ID: 0,
    已结束: false,
    移除: function 移除潜行状态(this: void, 原因?: 潜行结束原因): void {
      结束潜行记录(record, 原因 ?? "手动移除");
    },
  };
  return record;
}

export function 施加潜行状态(this: void, 参数: 潜行状态参数): 潜行状态实例 | null {
  if (参数.单位 == null || 参数.单位 === 0 || !(参数.持续秒数 > 0)) return null;
  const unitId = 取单位ID(参数.单位);
  if (unitId === 0) return null;

  const old = 潜行状态表[unitId];
  if (old != null) 结束潜行记录(old, "刷新覆盖");

  施加隐身(参数.单位, {
    持续时间: 参数.持续秒数,
    破隐固定额外伤害: 参数.破隐固定额外伤害 ?? 0,
    破隐伤害倍率: 参数.破隐伤害倍率 ?? 1,
    破隐额外暗属性伤害倍率: 参数.破隐额外暗属性伤害倍率 ?? 0,
    来源单位: 参数.来源单位 ?? 参数.单位,
  });

  if ((参数.固定移速 ?? 0) > 0 || (参数.基础移速百分比 ?? 0) > 0 || (参数.当前移速百分比 ?? 0) > 0) {
    施加移速提升Buff(参数.来源单位 ?? 参数.单位, 参数.单位, {
      持续时间: 参数.持续秒数,
      固定移速: 参数.固定移速,
      基础移速百分比: 参数.基础移速百分比,
      当前移速百分比: 参数.当前移速百分比,
      BuffID: 参数.移速BuffID ?? 默认潜行移速BuffID,
      sourceName: 参数.名称 ?? "潜行",
    });
  }

  const record = 创建潜行记录(参数, unitId);
  record.到期回调ID = addDelayedCallback(参数.持续秒数 * 1000, function on潜行状态到期(this: void): void {
    if (潜行状态表[unitId] === record) 结束潜行记录(record, "到期");
  });
  潜行状态表[unitId] = record;

  if (参数.on开始 != null) 参数.on开始(record);
  return record;
}

export function 移除潜行状态(this: void, 单位: any, 原因?: 潜行结束原因): boolean {
  const unitId = 取单位ID(单位);
  if (unitId === 0) return false;
  const record = 潜行状态表[unitId];
  if (record == null) {
    移除隐身(单位);
    return false;
  }
  结束潜行记录(record, 原因 ?? "手动移除");
  return true;
}

export function 单位是否潜行中(this: void, 单位: any): boolean {
  const unitId = 取单位ID(单位);
  if (unitId === 0) return false;
  return 潜行状态表[unitId] != null || 单位是否隐身中(单位);
}

export {};
