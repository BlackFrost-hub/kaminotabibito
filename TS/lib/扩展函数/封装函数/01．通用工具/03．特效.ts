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
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const DzBindEffect = japi.DzBindEffect as (widget: any, attachPoint: string, effect: any) => void;
const DzUnbindEffect = japi.DzUnbindEffect as (effect: any) => void;
const DzSetEffectPos = japi.DzSetEffectPos as (effect: any, x: number, y: number, z: number) => void;
const EXSetEffectXY = japi.EXSetEffectXY as (effect: any, x: number, y: number) => void;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const EXSetEffectSpeed = japi.EXSetEffectSpeed as (effect: any, speed: number) => void;
const EXEffectMatScale = japi.EXEffectMatScale as ((effect: any, x: number, y: number, z: number) => void) | undefined;
const DzSetEffectScale = japi.DzSetEffectScale as ((effect: any, scale: number) => void) | undefined;
const DzGetColor = japi.DzGetColor as ((alpha: number, red: number, green: number, blue: number) => number) | undefined;
const DzSetEffectVertexColor = japi.DzSetEffectVertexColor as ((effect: any, color: number) => void) | undefined;

function 规范化特效模型路径(modelPath: string): string {
  if (modelPath.indexOf("imports\\") === 0) return modelPath.substring(8);
  if (modelPath.indexOf("imports/") === 0) return modelPath.substring(8);
  return modelPath;
}

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
  const eff = jass.AddSpecialEffect(规范化特效模型路径(modelPath), x, y);
  if (!eff) return null;

  if (z !== 0) {
    japi.EXSetEffectZ(eff, z);
  }

  安排定时销毁特效(eff, duration);
  return eff;
}

export interface 点特效参数 {
  模型路径: string;
  X: number;
  Y: number;
  Z?: number;
  持续秒?: number;
  缩放?: number;
  动画速度?: number;
  顶点颜色?: number;
  红?: number;
  绿?: number;
  蓝?: number;
  透明度?: number;
}

export type 单位脚下点特效参数 = Omit<点特效参数, "X" | "Y">;

export function 创建点特效(参数: 点特效参数): any {
  if (参数.模型路径 == null || 参数.模型路径 === "") return null;
  const effect = AddSpecialEffect(规范化特效模型路径(参数.模型路径), 参数.X, 参数.Y);
  if (effect == null || effect === 0) return null;
  if (参数.Z != null && 参数.Z !== 0) EXSetEffectZ(effect, 参数.Z);
  设置Dz绑定特效缩放(effect, 参数.缩放 ?? 1);
  if (参数.动画速度 != null) EXSetEffectSpeed(effect, 参数.动画速度);
  const color = 取特效顶点颜色(参数);
  if (color != null && typeof DzSetEffectVertexColor === "function") {
    DzSetEffectVertexColor(effect, color);
  }
  if (参数.持续秒 != null && 参数.持续秒 > 0) {
    安排定时销毁特效(effect, 参数.持续秒);
  }
  return effect;
}

export function 创建单位脚下点特效(unit: any, 参数: 单位脚下点特效参数): any {
  if (unit == null || unit === 0) return null;
  return 创建点特效({
    ...参数,
    X: GetUnitX(unit),
    Y: GetUnitY(unit),
  });
}

export function 创建持续点法阵(参数: 循环点特效参数): 循环点特效句柄 {
  return 创建循环点特效(参数);
}

export interface 循环点特效参数 {
  模型路径: string;
  X: number;
  Y: number;
  Z?: number;
  缩放?: number;
  动画速度?: number;
  顶点颜色?: number;
  红?: number;
  绿?: number;
  蓝?: number;
  透明度?: number;
  重建间隔秒?: number;
  单次持续秒?: number;
  总持续秒?: number;
  存活条件?: (this: void) => boolean;
}

export interface 循环点特效句柄 {
  readonly id: number;
}

interface 循环点特效记录 {
  id: number;
  参数: 循环点特效参数;
  当前特效: any;
  下次重建毫秒: number;
  结束毫秒: number;
  已停止: boolean;
}

const 循环点特效检查间隔毫秒 = 100;
const 循环点特效表: Record<number, 循环点特效记录 | undefined> = {};
let 循环点特效数量 = 0;
let 循环点特效回调ID = 0;
let 下一个循环点特效ID = 0;

function 限制到颜色字节(this: void, value: number): number {
  if (value < 0) return 0;
  if (value > 255) return 255;
  return jass.R2I(value);
}

function 取特效顶点颜色(this: void, 参数: 循环点特效参数): number | undefined {
  if (参数.顶点颜色 != null) return 参数.顶点颜色;
  if (参数.红 == null || 参数.绿 == null || 参数.蓝 == null) return undefined;
  const alpha = 限制到颜色字节(参数.透明度 ?? 255);
  const red = 限制到颜色字节(参数.红);
  const green = 限制到颜色字节(参数.绿);
  const blue = 限制到颜色字节(参数.蓝);
  if (typeof DzGetColor === "function") {
    return DzGetColor(alpha, red, green, blue);
  }
  return alpha * 16777216 + red * 65536 + green * 256 + blue;
}

function 销毁循环点特效句柄(this: void, effect: any): void {
  if (effect == null || effect === 0) return;
  EXSetEffectXY(effect, 0, 0);
  EXSetEffectSize(effect, 0.00);
  DestroyEffect(effect);
}

function 创建循环点特效一次(this: void, 记录: 循环点特效记录): any {
  const 参数 = 记录.参数;
  const effect = AddSpecialEffect(规范化特效模型路径(参数.模型路径), 参数.X, 参数.Y);
  if (effect == null || effect === 0) return null;
  if (参数.Z != null && 参数.Z !== 0) EXSetEffectZ(effect, 参数.Z);
  设置Dz绑定特效缩放(effect, 参数.缩放 ?? 1);
  if (参数.动画速度 != null) EXSetEffectSpeed(effect, 参数.动画速度);
  const color = 取特效顶点颜色(参数);
  if (color != null && typeof DzSetEffectVertexColor === "function") {
    DzSetEffectVertexColor(effect, color);
  }
  return effect;
}

function 停止循环点特效Tick(this: void): void {
  if (循环点特效回调ID <= 0) return;
  removePeriodicCallback(循环点特效回调ID);
  循环点特效回调ID = 0;
}

function 确保循环点特效Tick(this: void): void {
  if (循环点特效回调ID > 0) return;
  循环点特效回调ID = addPeriodicCallback(循环点特效检查间隔毫秒, on循环点特效Tick);
}

function 移除循环点特效记录(this: void, id: any, 记录: 循环点特效记录): void {
  销毁循环点特效句柄(记录.当前特效);
  if (循环点特效表[id] != null) {
    delete 循环点特效表[id];
    循环点特效数量 -= 1;
  }
}

function on循环点特效Tick(this: void): void {
  const now = getServerTime();
  for (const idText in 循环点特效表) {
    const id = idText as any;
    const 记录 = 循环点特效表[id];
    if (记录 == null) continue;
    const 参数 = 记录.参数;
    const alive = 参数.存活条件 == null || 参数.存活条件();
    if (记录.已停止 || !alive || (记录.结束毫秒 > 0 && now >= 记录.结束毫秒)) {
      移除循环点特效记录(id, 记录);
      continue;
    }
    if (now >= 记录.下次重建毫秒) {
      销毁循环点特效句柄(记录.当前特效);
      记录.当前特效 = 创建循环点特效一次(记录);
      记录.下次重建毫秒 = now + (参数.重建间隔秒 ?? 3) * 1000;
    } else if (参数.单次持续秒 != null && 参数.单次持续秒 > 0 && now >= 记录.下次重建毫秒 - ((参数.重建间隔秒 ?? 3) - 参数.单次持续秒) * 1000) {
      销毁循环点特效句柄(记录.当前特效);
      记录.当前特效 = null;
    }
  }
  if (循环点特效数量 <= 0) {
    停止循环点特效Tick();
  }
}

export function 创建循环点特效(参数: 循环点特效参数): 循环点特效句柄 {
  const id = ++下一个循环点特效ID;
  const now = getServerTime();
  const interval = 参数.重建间隔秒 != null && 参数.重建间隔秒 > 0 ? 参数.重建间隔秒 : 3;
  const 记录: 循环点特效记录 = {
    id,
    参数,
    当前特效: null,
    下次重建毫秒: now + interval * 1000,
    结束毫秒: 参数.总持续秒 != null && 参数.总持续秒 > 0 ? now + 参数.总持续秒 * 1000 : 0,
    已停止: false,
  };
  记录.当前特效 = 创建循环点特效一次(记录);
  循环点特效表[id] = 记录;
  循环点特效数量 += 1;
  确保循环点特效Tick();
  return { id };
}

export function 停止循环点特效(句柄: 循环点特效句柄 | number | null | undefined): void {
  if (句柄 == null) return;
  const id = typeof 句柄 === "number" ? 句柄 : 句柄.id;
  const 记录 = 循环点特效表[id];
  if (记录 == null) return;
  记录.已停止 = true;
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

  const effect = jass.AddSpecialEffectTarget(规范化特效模型路径(modelPath), unit, attachPoint);
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
const 单位坐标跟随特效表: Record<string, any | undefined> = {};
let 单位坐标跟随特效数量 = 0;
let 单位坐标跟随特效回调ID = 0;
const 单位坐标跟随特效间隔毫秒 = 30;
const 单位坐标跟随特效默认高度 = 50;

function 解绑后归零尺寸并销毁Dz绑定特效(effect: any): void {
  if (!effect) return;
  DzUnbindEffect(effect);
  EXSetEffectXY(effect, 0, 0);
  EXSetEffectSize(effect, 0.00);
  DestroyEffect(effect);
}

export function 销毁Dz绑定特效句柄(effect: any): void {
  解绑后归零尺寸并销毁Dz绑定特效(effect);
}

export function 创建Dz绑定单位特效(unit: any, attachPoint: string, modelPath: string, effectKey: string = "default", scale: number = 1): any {
  if (!unit || modelPath === "") return null;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return null;

  const existingEffect = Dz绑定单位特效表.get(key);
  if (existingEffect) {
    解绑后归零尺寸并销毁Dz绑定特效(existingEffect);
  }

  const effect = AddSpecialEffect(规范化特效模型路径(modelPath), GetUnitX(unit), GetUnitY(unit));
  if (!effect) return null;
  DzBindEffect(unit, attachPoint, effect);
  设置Dz绑定特效缩放(effect, scale);
  Dz绑定单位特效表.set(key, effect);
  return effect;
}

export function 设置Dz绑定特效缩放(effect: any, scale: number): void {
  if (effect == null || effect === 0) return;
  if (typeof DzSetEffectScale === "function") {
    DzSetEffectScale(effect, scale);
  }
  EXSetEffectSize(effect, scale);
  if (typeof EXEffectMatScale === "function") {
    EXEffectMatScale(effect, scale, scale, scale);
  }
}

function 单位可坐标跟随(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 销毁单位坐标跟随特效记录(this: void, key: string, record: any): void {
  const effect = record == null ? null : record.effect;
  if (effect != null && effect !== 0) {
    EXSetEffectXY(effect, 0, 0);
    EXSetEffectSize(effect, 0.00);
    DestroyEffect(effect);
  }
  if (单位坐标跟随特效表[key] != null) {
    delete 单位坐标跟随特效表[key];
    单位坐标跟随特效数量 -= 1;
  }
}

function 停止单位坐标跟随特效Tick(this: void): void {
  if (单位坐标跟随特效回调ID <= 0) return;
  removePeriodicCallback(单位坐标跟随特效回调ID);
  单位坐标跟随特效回调ID = 0;
}

function on单位坐标跟随特效Tick(this: void): void {
  for (const key in 单位坐标跟随特效表) {
    const record = 单位坐标跟随特效表[key];
    if (record == null) continue;
    if (!单位可坐标跟随(record.unit)) {
      销毁单位坐标跟随特效记录(key, record);
      continue;
    }
    DzSetEffectPos(record.effect, GetUnitX(record.unit), GetUnitY(record.unit), record.height);
  }
  if (单位坐标跟随特效数量 <= 0) {
    停止单位坐标跟随特效Tick();
  }
}

function 确保单位坐标跟随特效Tick(this: void): void {
  if (单位坐标跟随特效回调ID > 0) return;
  单位坐标跟随特效回调ID = addPeriodicCallback(单位坐标跟随特效间隔毫秒, on单位坐标跟随特效Tick);
}

export function 创建单位坐标跟随特效(unit: any, modelPath: string, effectKey: string = "default", scale: number = 1, height: number = 单位坐标跟随特效默认高度, animSpeed?: number): any {
  if (!单位可坐标跟随(unit) || modelPath === "") return null;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return null;

  const existingRecord = 单位坐标跟随特效表[key];
  if (existingRecord) {
    销毁单位坐标跟随特效记录(key, existingRecord);
  }

  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  const effect = AddSpecialEffect(规范化特效模型路径(modelPath), x, y);
  if (!effect) return null;
  DzSetEffectPos(effect, x, y, height);
  if (animSpeed != null) {
    EXSetEffectSpeed(effect, animSpeed);
  }
  设置Dz绑定特效缩放(effect, scale);
  单位坐标跟随特效表[key] = { unit, effect, scale, height, animSpeed };
  单位坐标跟随特效数量 += 1;
  确保单位坐标跟随特效Tick();
  return effect;
}

export function 获取单位坐标跟随特效(unit: any, effectKey: string = "default"): any {
  if (!unit) return null;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return null;
  const record = 单位坐标跟随特效表[key];
  return record == null ? null : record.effect;
}

export function 销毁单位坐标跟随特效(unit: any, effectKey: string = "default"): void {
  if (!unit) return;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return;
  const record = 单位坐标跟随特效表[key];
  if (record) {
    销毁单位坐标跟随特效记录(key, record);
  }
  if (单位坐标跟随特效数量 <= 0) {
    停止单位坐标跟随特效Tick();
  }
}

export function 是否已有Dz绑定单位特效(unit: any, effectKey: string = "default"): boolean {
  if (!unit) return false;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return false;
  const effect = Dz绑定单位特效表.get(key);
  return effect != null && effect !== 0;
}

export function 获取Dz绑定单位特效(unit: any, effectKey: string = "default"): any {
  if (!unit) return null;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return null;
  return Dz绑定单位特效表.get(key) ?? null;
}

export function 销毁Dz绑定单位特效(unit: any, effectKey: string = "default"): void {
  if (!unit) return;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return;

  const effect = Dz绑定单位特效表.get(key);
  if (effect) {
    解绑后归零尺寸并销毁Dz绑定特效(effect);
  }
  Dz绑定单位特效表.delete(key);
}
