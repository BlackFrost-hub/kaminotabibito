/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const { 开始硬直, 调整单位硬直时间 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
  调整单位硬直时间: (this: void, unit: any, 操作类型: number, 时间值: number) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animationName: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, animationIndex: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, timeScale: number) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const EXSetUnitFacing = japi.EXSetUnitFacing as ((this: void, unit: any, angle: number) => void) | undefined;

const RAD_TO_DEG = 57.29577951308232;
const DEG_TO_RAD = 0.017453292519943295;

export type 持续施法发射结束原因 = "完成" | "中断" | "施法者死亡";
export type 持续施法发射面向模式 = "锁定初始方向" | "持续追踪目标" | "不处理";

export interface 持续施法发射回调上下文 {
  ID: number;
  施法者: any;
  已进行秒: number;
  进度: number;
  当前朝向: number;
  发射次数: number;
}

export interface 持续施法发射参数 {
  施法者: any;
  总持续秒: number;
  Tick间隔毫秒?: number;
  目标单位?: any;
  目标X?: number;
  目标Y?: number;
  面向模式?: 持续施法发射面向模式;
  动画序列?: number;
  动画名?: string;
  动画速度?: number;
  结束后恢复动画?: boolean;
  硬直?: boolean;
  中断时解除硬直?: boolean;
  发射开始秒: number;
  发射结束秒: number;
  发射间隔秒: number;
  on开始?: (this: void, 上下文: 持续施法发射回调上下文) => void;
  onTick?: (this: void, 上下文: 持续施法发射回调上下文) => void;
  on发射?: (this: void, 上下文: 持续施法发射回调上下文) => void;
  on结束?: (this: void, 上下文: 持续施法发射回调上下文, 原因: 持续施法发射结束原因) => void;
}

interface 持续施法发射实例 {
  ID: number;
  参数: 持续施法发射参数;
  开始毫秒: number;
  结束毫秒: number;
  发射开始毫秒: number;
  发射结束毫秒: number;
  发射间隔毫秒: number;
  下次发射毫秒: number;
  发射次数: number;
  锁定朝向: number;
  已结束: boolean;
}

const 持续施法发射实例表: Record<number, 持续施法发射实例 | undefined> = {};
let 持续施法发射ID序号 = 0;
let 持续施法发射驱动ID = 0;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取目标X(this: void, 参数: 持续施法发射参数): number | undefined {
  if (单位有效(参数.目标单位)) return GetUnitX(参数.目标单位);
  return 参数.目标X;
}

function 取目标Y(this: void, 参数: 持续施法发射参数): number | undefined {
  if (单位有效(参数.目标单位)) return GetUnitY(参数.目标单位);
  return 参数.目标Y;
}

function 计算朝向(this: void, 参数: 持续施法发射参数, 默认朝向: number): number {
  const caster = 参数.施法者;
  if (!单位有效(caster)) return 默认朝向;
  const targetX = 取目标X(参数);
  const targetY = 取目标Y(参数);
  if (targetX == null || targetY == null) return 默认朝向;
  return Atan2(targetY - GetUnitY(caster), targetX - GetUnitX(caster)) * RAD_TO_DEG;
}

function 设置朝向(this: void, unit: any, facing: number): void {
  if (!单位有效(unit)) return;
  SetUnitFacing(unit, facing);
  if (EXSetUnitFacing != null) EXSetUnitFacing(unit, facing * DEG_TO_RAD);
}

function 播放持续施法动画(this: void, 参数: 持续施法发射参数): void {
  const caster = 参数.施法者;
  if (!单位有效(caster)) return;
  SetUnitTimeScale(caster, 参数.动画速度 ?? 1);
  if (参数.动画序列 != null) {
    SetUnitAnimationByIndex(caster, 参数.动画序列);
    return;
  }
  if (参数.动画名 != null && 参数.动画名 !== "") {
    SetUnitAnimation(caster, 参数.动画名);
  }
}

function 取上下文(this: void, 实例: 持续施法发射实例, now: number): 持续施法发射回调上下文 {
  const elapsedMs = now - 实例.开始毫秒;
  const totalMs = 实例.结束毫秒 - 实例.开始毫秒;
  const 已进行秒 = elapsedMs > 0 ? elapsedMs / 1000 : 0;
  let 进度 = totalMs > 0 ? elapsedMs / totalMs : 1;
  if (进度 < 0) 进度 = 0;
  if (进度 > 1) 进度 = 1;
  return {
    ID: 实例.ID,
    施法者: 实例.参数.施法者,
    已进行秒,
    进度,
    当前朝向: 取当前朝向(实例),
    发射次数: 实例.发射次数,
  };
}

function 取当前朝向(this: void, 实例: 持续施法发射实例): number {
  const 参数 = 实例.参数;
  if (参数.面向模式 === "不处理") return GetUnitFacing(参数.施法者);
  if (参数.面向模式 === "持续追踪目标") return 计算朝向(参数, 实例.锁定朝向);
  return 实例.锁定朝向;
}

function 结束持续施法发射实例(this: void, 实例: 持续施法发射实例, 原因: 持续施法发射结束原因): void {
  if (实例.已结束) return;
  实例.已结束 = true;
  delete 持续施法发射实例表[实例.ID];

  const caster = 实例.参数.施法者;
  if (原因 !== "完成" && 实例.参数.中断时解除硬直 === true && 单位有效(caster)) {
    调整单位硬直时间(caster, 1, 9999);
  }
  if (实例.参数.结束后恢复动画 !== false && 单位有效(caster)) {
    SetUnitTimeScale(caster, 1);
    SetUnitAnimationByIndex(caster, 0);
  }

  const on结束 = 实例.参数.on结束;
  if (on结束 != null) on结束(取上下文(实例, getServerTime()), 原因);
}

function 驱动持续施法发射(this: void): void {
  const now = getServerTime();
  let hasActive = false;

  for (const key in 持续施法发射实例表) {
    const 实例 = 持续施法发射实例表[key as unknown as number];
    if (实例 == null || 实例.已结束) continue;
    hasActive = true;

    const caster = 实例.参数.施法者;
    if (!单位有效(caster)) {
      结束持续施法发射实例(实例, "施法者死亡");
      continue;
    }

    const facing = 取当前朝向(实例);
    if (实例.参数.面向模式 !== "不处理") 设置朝向(caster, facing);

    const ctx = 取上下文(实例, now);
    const onTick = 实例.参数.onTick;
    if (onTick != null) onTick(ctx);

    const on发射 = 实例.参数.on发射;
    while (
      on发射 != null &&
      now >= 实例.下次发射毫秒 &&
      实例.下次发射毫秒 <= 实例.发射结束毫秒
    ) {
      实例.发射次数 += 1;
      on发射(取上下文(实例, now));
      实例.下次发射毫秒 += 实例.发射间隔毫秒;
      if (实例.发射间隔毫秒 <= 0) break;
    }

    if (now >= 实例.结束毫秒) {
      结束持续施法发射实例(实例, "完成");
    }
  }

  if (!hasActive && 持续施法发射驱动ID > 0) {
    removePeriodicCallback(持续施法发射驱动ID);
    持续施法发射驱动ID = 0;
  }
}

function 确保持续施法发射驱动(this: void, intervalMs: number): void {
  if (持续施法发射驱动ID > 0) return;
  持续施法发射驱动ID = addPeriodicCallback(intervalMs, 驱动持续施法发射);
}

export function 启动持续施法发射(this: void, 参数: 持续施法发射参数): number {
  const caster = 参数.施法者;
  if (!单位有效(caster)) return 0;

  const now = getServerTime();
  const totalMs = 参数.总持续秒 > 0 ? 参数.总持续秒 * 1000 : 0;
  if (totalMs <= 0) return 0;

  const fireStartMs = 参数.发射开始秒 > 0 ? 参数.发射开始秒 * 1000 : 0;
  const fireEndMs = 参数.发射结束秒 > 参数.发射开始秒 ? 参数.发射结束秒 * 1000 : fireStartMs;
  const fireIntervalMs = 参数.发射间隔秒 > 0 ? 参数.发射间隔秒 * 1000 : 100;
  const lockedFacing = 计算朝向(参数, GetUnitFacing(caster));
  const id = ++持续施法发射ID序号;

  const 实例: 持续施法发射实例 = {
    ID: id,
    参数,
    开始毫秒: now,
    结束毫秒: now + totalMs,
    发射开始毫秒: now + fireStartMs,
    发射结束毫秒: now + fireEndMs,
    发射间隔毫秒: fireIntervalMs,
    下次发射毫秒: now + fireStartMs,
    发射次数: 0,
    锁定朝向: lockedFacing,
    已结束: false,
  };

  持续施法发射实例表[id] = 实例;
  if (参数.面向模式 !== "不处理") 设置朝向(caster, lockedFacing);
  if (参数.硬直 !== false) 开始硬直(caster, 参数.总持续秒);
  播放持续施法动画(参数);

  const on开始 = 参数.on开始;
  if (on开始 != null) on开始(取上下文(实例, now));

  const intervalMs = 参数.Tick间隔毫秒 != null && 参数.Tick间隔毫秒 > 0 ? 参数.Tick间隔毫秒 : 30;
  确保持续施法发射驱动(intervalMs);
  return id;
}

export function 停止持续施法发射(this: void, ID: number, 原因: 持续施法发射结束原因 = "中断"): boolean {
  const 实例 = 持续施法发射实例表[ID];
  if (实例 == null) return false;
  结束持续施法发射实例(实例, 原因);
  return true;
}

export function 单位是否正在持续施法发射(this: void, unit: any): boolean {
  if (!单位有效(unit)) return false;
  for (const key in 持续施法发射实例表) {
    const 实例 = 持续施法发射实例表[key as unknown as number];
    if (实例 != null && 实例.参数.施法者 === unit && !实例.已结束) return true;
  }
  return false;
}

export {};
