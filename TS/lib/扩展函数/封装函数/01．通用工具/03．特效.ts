/** @noSelfInFile */
/**
 * 特效封装函数
 * 创建和管理特效
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};

const effectDestroyCtxByTimerHid: Record<number, any> = {};
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const DzBindEffect = japi.DzBindEffect as (widget: any, attachPoint: string, effect: any) => void;
const DzUnbindEffect = japi.DzUnbindEffect as (effect: any) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;

function onTimedEffectTimerExpire(this: void): void {
  const t = jass.GetExpiredTimer();
  const eff = effectDestroyCtxByTimerHid[jass.GetHandleId(t)];
  delete effectDestroyCtxByTimerHid[jass.GetHandleId(t)];
  if (eff) jass.DestroyEffect(eff);
  safeDestroyTimer(t);
}

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

  const t = jass.CreateTimer();
  if (t) {
    effectDestroyCtxByTimerHid[jass.GetHandleId(t)] = eff;
    safeTimerStart(t, duration, false, onTimedEffectTimerExpire);
  }
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

const boundEffectCtxByTimerHid: Record<number, { key: string; effect: any }> = {};

function onBoundEffectTimerExpire(this: void): void {
  const t = jass.GetExpiredTimer();
  const ctx = boundEffectCtxByTimerHid[jass.GetHandleId(t)];
  delete boundEffectCtxByTimerHid[jass.GetHandleId(t)];
  if (!ctx) return;
  const currentEffect = unitEffectMap.get(ctx.key);
  if (currentEffect === ctx.effect) {
    destroyBoundEffect(ctx.effect);
    unitEffectMap.delete(ctx.key);
  }
  safeDestroyTimer(t);
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
    const t = jass.CreateTimer();
    if (t) {
      boundEffectCtxByTimerHid[jass.GetHandleId(t)] = { key, effect };
      safeTimerStart(t, duration, false, onBoundEffectTimerExpire);
    }
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
