/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { onTick10ms, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: (this: void) => void) => void;
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, whichUnit: any, whichUnitState: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichUnitType: any) => boolean;
const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;

const 单位排泄延迟毫秒 = 20000;
const 死亡生命阈值 = 0.405;

interface 待排泄单位 {
  handleId: number;
  unit: any;
  dueTimeMs: number;
}

const 已登记单位表: Record<number, true | undefined> = {};
const 已进入排泄队列: Record<number, true | undefined> = {};
const 待排泄单位列表: 待排泄单位[] = [];

let 已注册单位死亡监听 = false;
let 已注册单位排泄Tick = false;

function 单位是否仍为尸体(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_DEAD)) return true;
  return GetUnitState(unit, jass.UNIT_STATE_LIFE) <= 死亡生命阈值;
}

function on单位排泄Tick(this: void): void {
  const now = getServerTime();
  for (let i = 待排泄单位列表.length - 1; i >= 0; i--) {
    const entry = 待排泄单位列表[i];
    if (now < entry.dueTimeMs) continue;

    delete 已进入排泄队列[entry.handleId];
    if (单位是否仍为尸体(entry.unit)) {
      RemoveUnit(entry.unit);
    }
    待排泄单位列表.splice(i, 1);
  }
}

function on已登记单位死亡(this: void, dyingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  const handleId = GetHandleId(dyingUnit);
  if (handleId === 0) return;
  if (已登记单位表[handleId] !== true) return;

  delete 已登记单位表[handleId];
  if (已进入排泄队列[handleId] === true) return;
  已进入排泄队列[handleId] = true;
  待排泄单位列表.push({
    handleId,
    unit: dyingUnit,
    dueTimeMs: getServerTime() + 单位排泄延迟毫秒,
  });
}

function 确保单位排泄初始化(this: void): void {
  if (!已注册单位死亡监听) {
    已注册单位死亡监听 = true;
    registerDeathListener(on已登记单位死亡);
  }
  if (!已注册单位排泄Tick) {
    已注册单位排泄Tick = true;
    onTick10ms(on单位排泄Tick);
  }
}

export function 登记单位排泄(unit: any): any {
  if (unit == null || unit === 0) return unit;
  确保单位排泄初始化();
  const handleId = GetHandleId(unit);
  if (handleId === 0) return unit;

  // 句柄可能被引擎复用；重新登记时必须先清掉同 handleId 的旧延迟排泄条目，
  // 否则旧尸体的排泄任务可能会把新创建的单位误删掉。
  for (let i = 待排泄单位列表.length - 1; i >= 0; i--) {
    if (待排泄单位列表[i].handleId === handleId) {
      待排泄单位列表.splice(i, 1);
    }
  }

  已登记单位表[handleId] = true;
  delete 已进入排泄队列[handleId];
  return unit;
}

export function 取消单位排泄登记(unit: any): any {
  if (unit == null || unit === 0) return unit;
  const handleId = GetHandleId(unit);
  if (handleId === 0) return unit;

  delete 已登记单位表[handleId];
  delete 已进入排泄队列[handleId];
  for (let i = 待排泄单位列表.length - 1; i >= 0; i--) {
    if (待排泄单位列表[i].handleId === handleId) {
      待排泄单位列表.splice(i, 1);
    }
  }
  return unit;
}

export function 立即移除单位并取消排泄登记(unit: any): void {
  if (unit == null || unit === 0) return;
  取消单位排泄登记(unit);
  RemoveUnit(unit);
}

// 兼容旧命名：这里不是“额外注册事件监听”，只是登记到单位排泄表
export const 注册单位排泄监听 = 登记单位排泄;
export const 注销单位排泄监听 = 取消单位排泄登记;
export const 立即移除单位并注销排泄监听 = 立即移除单位并取消排泄登记;
