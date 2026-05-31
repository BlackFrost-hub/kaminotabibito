/** @noSelfInFile */
/**
 * 特效封装函数
 * 创建和管理特效
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const DzBindEffect = japi.DzBindEffect as (widget: any, attachPoint: string, effect: any) => void;
const DzUnbindEffect = japi.DzUnbindEffect as (effect: any) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;

const 特效销毁检查间隔毫秒 = 10;
const 定时销毁特效列表: any[] = [];
const 定时销毁特效到期毫秒列表: number[] = [];
const 绑定特效销毁键列表: string[] = [];
const 绑定特效销毁特效列表: any[] = [];
const 绑定特效销毁到期毫秒列表: number[] = [];
let 特效销毁检查回调ID = 0;

/**
 * 创建特效并在指定时间后自动销毁
 * @param modelPath 特效模型路径
 * @param x x坐标
 * @param y y坐标
 * @param z z坐标，可选，默认 0
 * @param duration 持续时间秒数，默认 2 秒
 * @returns 特效句柄
 */
export function createTimedEffect(
  modelPath: string,
  x: number,
  y: number,
  z: number = 0,
  duration: number = 2
): any {
  const eff = jass.AddSpecialEffect(modelPath, x, y);
  if (!eff) return null;

  if (z !== 0) {
    japi.EXSetEffectZ(eff, z);
  }

  安排定时销毁特效(eff, duration);
  return eff;
}

const unitEffectMap: Map<string, any> = new Map();

function getUnitEffectHandleId(unit: any): number {
  if (!unit) return 0;
  return jass.GetHandleId(unit);
}

function getUnitEffectKey(unit: any, effectKey: string): string {
  const handleId = getUnitEffectHandleId(unit);
  if (!handleId) return "";
  return `${handleId}:${effectKey}`;
}

function destroyBoundEffect(effect: any): void {
  if (!effect) return;
  jass.DestroyEffect(effect);
}

function 停止特效销毁检查(this: void): void {
  if (特效销毁检查回调ID <= 0) return;
  removePeriodicCallback(特效销毁检查回调ID);
  特效销毁检查回调ID = 0;
}

function 确保特效销毁检查(this: void): void {
  if (特效销毁检查回调ID > 0) return;
  特效销毁检查回调ID = addPeriodicCallback(特效销毁检查间隔毫秒, on特效销毁检查);
}

function 安排定时销毁特效(this: void, effect: any, duration: number): void {
  定时销毁特效列表.push(effect);
  定时销毁特效到期毫秒列表.push(getServerTime() + duration * 1000);
  确保特效销毁检查();
}

function 安排绑定特效销毁检查(this: void, key: string, effect: any, duration: number): void {
  绑定特效销毁键列表.push(key);
  绑定特效销毁特效列表.push(effect);
  绑定特效销毁到期毫秒列表.push(getServerTime() + duration * 1000);
  确保特效销毁检查();
}

function 处理定时特效销毁(this: void, now: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 定时销毁特效列表.length; i++) {
    const effect = 定时销毁特效列表[i];
    if (now >= 定时销毁特效到期毫秒列表[i]) {
      if (effect) jass.DestroyEffect(effect);
    } else {
      定时销毁特效列表[writeIndex] = effect;
      定时销毁特效到期毫秒列表[writeIndex] = 定时销毁特效到期毫秒列表[i];
      writeIndex += 1;
    }
  }
  for (let i = 定时销毁特效列表.length - 1; i >= writeIndex; i--) {
    定时销毁特效列表.pop();
    定时销毁特效到期毫秒列表.pop();
  }
}

function 处理绑定特效销毁(this: void, now: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 绑定特效销毁键列表.length; i++) {
    const key = 绑定特效销毁键列表[i];
    const effect = 绑定特效销毁特效列表[i];
    if (now >= 绑定特效销毁到期毫秒列表[i]) {
      const currentEffect = unitEffectMap.get(key);
      if (currentEffect === effect) {
        destroyBoundEffect(effect);
        unitEffectMap.delete(key);
      }
    } else {
      绑定特效销毁键列表[writeIndex] = key;
      绑定特效销毁特效列表[writeIndex] = effect;
      绑定特效销毁到期毫秒列表[writeIndex] = 绑定特效销毁到期毫秒列表[i];
      writeIndex += 1;
    }
  }
  for (let i = 绑定特效销毁键列表.length - 1; i >= writeIndex; i--) {
    绑定特效销毁键列表.pop();
    绑定特效销毁特效列表.pop();
    绑定特效销毁到期毫秒列表.pop();
  }
}

function on特效销毁检查(this: void): void {
  const now = getServerTime();
  处理定时特效销毁(now);
  处理绑定特效销毁(now);
  if (定时销毁特效列表.length <= 0 && 绑定特效销毁键列表.length <= 0) {
    停止特效销毁检查();
  }
}

/**
 * 在单位上创建绑定特效
 * @param unit 目标单位
 * @param attachPoint 绑定点，如 "overhead"、"origin"、"chest"
 * @param modelPath 特效模型路径
 * @param duration 持续时间；不传则常驻，直到手动销毁
 * @returns 特效句柄；创建失败返回 null
 */
export function createUnitEffect(unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey: string = "default"): any {
  if (!unit) return null;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return null;

  const existingEffect = unitEffectMap.get(key);
  if (existingEffect) {
    destroyBoundEffect(existingEffect);
  }

  const effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint);
  if (!effect) return null;
  unitEffectMap.set(key, effect);

  if (duration != null && duration > 0) {
    安排绑定特效销毁检查(key, effect, duration);
  }

  return effect;
}

/**
 * 销毁单位上的绑定特效
 * @param unit 目标单位
 */
export function destroyUnitEffect(unit: any, effectKey: string = "default"): void {
  if (!unit) return;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return;

  const effect = unitEffectMap.get(key);
  if (effect) {
    destroyBoundEffect(effect);
  }
  unitEffectMap.delete(key);
}

const Dz绑定单位特效表: Map<string, any> = new Map();

function 隐藏并销毁Dz绑定特效(effect: any): void {
  if (!effect) return;
  DzUnbindEffect(effect);
  EXSetEffectSize(effect, 0);
  DestroyEffect(effect);
}

export function 创建Dz绑定单位特效(unit: any, attachPoint: string, modelPath: string, effectKey: string = "default"): any {
  if (!unit || modelPath === "") return null;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return null;

  const existingEffect = Dz绑定单位特效表.get(key);
  if (existingEffect) {
    隐藏并销毁Dz绑定特效(existingEffect);
  }

  const effect = AddSpecialEffect(modelPath, GetUnitX(unit), GetUnitY(unit));
  if (!effect) return null;
  DzBindEffect(unit, attachPoint, effect);
  Dz绑定单位特效表.set(key, effect);
  return effect;
}

export function 是否已有Dz绑定单位特效(unit: any, effectKey: string = "default"): boolean {
  if (!unit) return false;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return false;
  const effect = Dz绑定单位特效表.get(key);
  return effect != null && effect !== 0;
}

export function 销毁Dz绑定单位特效(unit: any, effectKey: string = "default"): void {
  if (!unit) return;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return;

  const effect = Dz绑定单位特效表.get(key);
  if (effect) {
    隐藏并销毁Dz绑定特效(effect);
  }
  Dz绑定单位特效表.delete(key);
}
