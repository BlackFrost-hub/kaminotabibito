/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

export interface 延迟死亡结算上下文 {
  key: string;
  来源单位: any;
  目标单位: any;
  当前时间毫秒: number;
}

export interface 延迟死亡结算参数 {
  key前缀: string;
  来源单位: any;
  目标单位: any;
  延迟毫秒: number;
  检查间隔毫秒?: number;
  来源有效性检查?: (this: void, 上下文: 延迟死亡结算上下文) => boolean;
  on目标死亡: (this: void, 上下文: 延迟死亡结算上下文) => void;
}

interface 延迟死亡结算记录 {
  key: string;
  来源单位: any;
  目标单位: any;
  到期时间: number;
  检查间隔毫秒: number;
  驱动ID: number;
  来源有效性检查?: (this: void, 上下文: 延迟死亡结算上下文) => boolean;
  on目标死亡: (this: void, 上下文: 延迟死亡结算上下文) => void;
}

const 延迟死亡结算队列: 延迟死亡结算记录[] = [];

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 单位是否死亡或无效(this: void, unit: any): boolean {
  return unit == null || unit === 0 || IsUnitType(unit, UNIT_TYPE_DEAD) === true;
}

function 生成延迟死亡结算key(this: void, 参数: 延迟死亡结算参数): string {
  const 来源ID = 取单位句柄ID(参数.来源单位);
  const 目标ID = 取单位句柄ID(参数.目标单位);
  if (来源ID === 0 || 目标ID === 0) return "";
  return 参数.key前缀 + ":" + 来源ID + ":" + 目标ID;
}

function 构建上下文(this: void, 记录: 延迟死亡结算记录, now: number): 延迟死亡结算上下文 {
  return {
    key: 记录.key,
    来源单位: 记录.来源单位,
    目标单位: 记录.目标单位,
    当前时间毫秒: now,
  };
}

function 来源仍有效(this: void, 记录: 延迟死亡结算记录, now: number): boolean {
  if (单位是否死亡或无效(记录.来源单位)) return false;
  if (记录.来源有效性检查 == null) return true;
  return 记录.来源有效性检查(构建上下文(记录, now));
}

function 停止延迟死亡结算记录(this: void, 记录: 延迟死亡结算记录): void {
  if (记录.驱动ID !== 0) {
    removePeriodicCallback(记录.驱动ID);
    记录.驱动ID = 0;
  }
  const index = 延迟死亡结算队列.indexOf(记录);
  if (index >= 0) 延迟死亡结算队列.splice(index, 1);
}

function 更新延迟死亡结算驱动(this: void, 记录: 延迟死亡结算记录, 检查间隔毫秒: number): void {
  const interval = 检查间隔毫秒 > 0 ? 检查间隔毫秒 : 100;
  if (记录.驱动ID !== 0 && 记录.检查间隔毫秒 === interval) return;
  if (记录.驱动ID !== 0) removePeriodicCallback(记录.驱动ID);
  记录.检查间隔毫秒 = interval;
  记录.驱动ID = addPeriodicCallback(interval, on延迟死亡结算Tick, 记录);
}

function on延迟死亡结算Tick(this: void, variable?: any): void {
  const 记录 = variable as 延迟死亡结算记录 | undefined;
  if (记录 == null || 记录.驱动ID === 0) return;
  const now = getServerTime();
  if (!来源仍有效(记录, now)) {
    停止延迟死亡结算记录(记录);
    return;
  }
  if (单位是否死亡或无效(记录.目标单位)) {
    记录.on目标死亡(构建上下文(记录, now));
    停止延迟死亡结算记录(记录);
    return;
  }
  if (now >= 记录.到期时间) 停止延迟死亡结算记录(记录);
}

export function 记录或刷新延迟死亡结算(this: void, 参数: 延迟死亡结算参数): void {
  if (参数 == null || 参数.on目标死亡 == null) return;
  if (参数.延迟毫秒 <= 0) return;
  if (单位是否死亡或无效(参数.来源单位) || 单位是否死亡或无效(参数.目标单位)) return;

  const key = 生成延迟死亡结算key(参数);
  if (key === "") return;
  const 到期时间 = getServerTime() + 参数.延迟毫秒;

  for (let i = 0; i < 延迟死亡结算队列.length; i++) {
    const 记录 = 延迟死亡结算队列[i];
    if (记录 == null || 记录.key !== key) continue;
    记录.到期时间 = 到期时间;
    记录.来源有效性检查 = 参数.来源有效性检查;
    记录.on目标死亡 = 参数.on目标死亡;
    if (参数.检查间隔毫秒 != null) 更新延迟死亡结算驱动(记录, 参数.检查间隔毫秒);
    return;
  }

  const 记录: 延迟死亡结算记录 = {
    key,
    来源单位: 参数.来源单位,
    目标单位: 参数.目标单位,
    到期时间,
    检查间隔毫秒: 0,
    驱动ID: 0,
    来源有效性检查: 参数.来源有效性检查,
    on目标死亡: 参数.on目标死亡,
  };
  延迟死亡结算队列.push(记录);
  更新延迟死亡结算驱动(记录, 参数.检查间隔毫秒 ?? 100);
}
