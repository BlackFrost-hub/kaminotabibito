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
const { EC_CreateEffect, EC_GetPointZ } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
  EC_GetPointZ: (this: void, x: number, y: number) => number;
};

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const DzBindEffect = japi.DzBindEffect as (widget: any, attachPoint: string, effect: any) => void;
const DzUnbindEffect = japi.DzUnbindEffect as (effect: any) => void;
const EXSetEffectXY = (japi as any).EXSetEffectXY as ((effect: any, x: number, y: number) => void) | undefined;
const EXSetEffectX = (japi as any).EXSetEffectX as ((effect: any, x: number) => void) | undefined;
const EXSetEffectY = (japi as any).EXSetEffectY as ((effect: any, y: number) => void) | undefined;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const EXEffectMatRotateX = japi.EXEffectMatRotateX as (effect: any, angle: number) => void;
const EXEffectMatRotateY = japi.EXEffectMatRotateY as (effect: any, angle: number) => void;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, angle: number) => void;
const EXEffectMatScale = japi.EXEffectMatScale as (effect: any, x: number, y: number, z: number) => void;
const DzSetEffectScale = japi.DzSetEffectScale as (effect: any, scale: number) => void;
const DzSetEffectAnimation = (japi as any)["DzSetEffectAnimation"] as ((effect: any, animationIndex: number, flag: number) => void) | undefined;
const DzGetColor = japi.DzGetColor as (alpha: number, red: number, green: number, blue: number) => number;
const DzSetEffectVertexColor = japi.DzSetEffectVertexColor as (effect: any, color: number) => void;

function 规范化特效模型路径(modelPath: string): string {
  if (modelPath.indexOf("imports\\") === 0) return modelPath.substring(8);
  if (modelPath.indexOf("imports/") === 0) return modelPath.substring(8);
  return modelPath;
}

function 安全设置特效坐标(this: void, effect: any, x: number, y: number): void {
  if (effect == null || effect === 0) return;
  if (EXSetEffectXY != null) {
    EXSetEffectXY(effect, x, y);
    return;
  }
  if (EXSetEffectX != null) EXSetEffectX(effect, x);
  if (EXSetEffectY != null) EXSetEffectY(effect, y);
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
  return EC_CreateEffect(规范化特效模型路径(modelPath), x, y, z, 0, 1, 1, duration);
}

export function createTimedUnitEffect(
  unit: any,
  attachPoint: string,
  modelPath: string,
  duration: number = 2,
): any {
  if (unit == null || unit === 0 || modelPath === "") return null;
  const effect = AddSpecialEffectTarget(规范化特效模型路径(modelPath), unit, attachPoint);
  if (effect == null || effect === 0) return null;
  安排定时销毁特效(effect, duration);
  return effect;
}

export interface 点特效参数 extends 特效XYZ轴旋转参数 {
  模型路径: string;
  X: number;
  Y: number;
  Z?: number;
  /** 原生特效朝向角度；不填写时保持默认 0 度。 */
  面向角度?: number;
  持续秒?: number;
  缩放?: number;
  动画速度?: number;
  动画索引?: number;
  顶点颜色?: number;
  RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number };
  红?: number;
  绿?: number;
  蓝?: number;
  透明度?: number;
}

export type 单位脚下点特效参数 = Omit<点特效参数, "X" | "Y">;

export interface 特效XYZ轴旋转参数 {
  X轴角度?: number;
  Y轴角度?: number;
  Z轴角度?: number;
}

export function 设置特效XYZ轴旋转(effect: any, 参数: 特效XYZ轴旋转参数): void {
  if (effect == null || effect === 0 || 参数 == null) return;
  const x = 参数.X轴角度 ?? 0;
  const y = 参数.Y轴角度 ?? 0;
  const z = 参数.Z轴角度 ?? 0;
  if (x !== 0) EXEffectMatRotateX(effect, x);
  if (y !== 0) EXEffectMatRotateY(effect, y);
  if (z !== 0) EXEffectMatRotateZ(effect, z);
}

export function 创建点特效(参数: 点特效参数): any {
  if (参数.模型路径 == null || 参数.模型路径 === "") return null;
  const duration = 参数.持续秒 != null && 参数.持续秒 > 0 ? 参数.持续秒 : -1;
  const effect = EC_CreateEffect(
    规范化特效模型路径(参数.模型路径),
    参数.X,
    参数.Y,
    参数.Z ?? 0,
    参数.面向角度 ?? 0,
    参数.缩放 ?? 1,
    参数.动画速度 ?? 1,
    duration,
  );
  if (effect == null || effect === 0) return null;
  设置特效XYZ轴旋转(effect, 参数);
  if (参数.动画索引 != null && DzSetEffectAnimation != null) {
    DzSetEffectAnimation(effect, 参数.动画索引, 0);
  }
  const color = 取特效顶点颜色(参数);
  if (color != null) DzSetEffectVertexColor(effect, color);
  return effect;
}

/** 销毁由创建点特效创建的常驻点特效。 */
export function 销毁点特效(this: void, effect: any): void {
  if (effect == null || effect === 0) return;
  DestroyEffect(effect);
}

export interface 逐段直线路径点特效参数 extends Omit<点特效参数, 'X' | 'Y'> {
  起点X: number;
  起点Y: number;
  方向弧度: number;
  路径长度: number;
  段间距: number;
  铺设间隔秒?: number;
  存活条件?: (this: void) => boolean;
}

export interface 逐段直线路径点特效句柄 {
  readonly ID: number;
  停止(): void;
}

class 逐段直线路径点特效实现 implements 逐段直线路径点特效句柄 {
  readonly ID: number;
  private readonly 参数: 逐段直线路径点特效参数;
  private 下一个距离 = 0;
  private 下次铺设毫秒 = 0;
  private 已停止 = false;

  constructor(ID: number, 参数: 逐段直线路径点特效参数) {
    this.ID = ID;
    this.参数 = 参数;
  }

  启动(): void {
    this.创建下一段();
    if (!this.已停止) this.下次铺设毫秒 = getServerTime() + this.取铺设间隔毫秒();
  }

  推进(当前毫秒: number): void {
    if (this.已停止) return;
    if (this.参数.存活条件 != null && !this.参数.存活条件()) {
      this.停止();
      return;
    }
    if (当前毫秒 < this.下次铺设毫秒) return;
    this.创建下一段();
    if (!this.已停止) this.下次铺设毫秒 = 当前毫秒 + this.取铺设间隔毫秒();
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    移除逐段直线路径点特效(this);
  }

  是否已停止(): boolean {
    return this.已停止;
  }

  private 创建下一段(): void {
    const 路径长度 = this.参数.路径长度 > 0 ? this.参数.路径长度 : 0;
    const 当前距离 = this.下一个距离 > 路径长度 ? 路径长度 : this.下一个距离;
    创建点特效({
      ...this.参数,
      X: this.参数.起点X + Cos(this.参数.方向弧度) * 当前距离,
      Y: this.参数.起点Y + Sin(this.参数.方向弧度) * 当前距离,
    });
    if (当前距离 >= 路径长度) {
      this.停止();
      return;
    }
    const 段间距 = this.参数.段间距 > 0 ? this.参数.段间距 : 128;
    this.下一个距离 = 当前距离 + 段间距;
    if (this.下一个距离 > 路径长度) this.下一个距离 = 路径长度;
  }

  private 取铺设间隔毫秒(): number {
    const 秒 = this.参数.铺设间隔秒 != null && this.参数.铺设间隔秒 > 0 ? this.参数.铺设间隔秒 : 0.06;
    return 秒 * 1000;
  }
}

const 活跃逐段直线路径点特效列表: 逐段直线路径点特效实现[] = [];
let 下一个逐段直线路径点特效ID = 0;
let 逐段直线路径点特效回调ID = 0;

function 确保逐段直线路径点特效Tick(): void {
  if (逐段直线路径点特效回调ID !== 0) return;
  逐段直线路径点特效回调ID = addPeriodicCallback(10, 逐段直线路径点特效Tick);
}

function 停止逐段直线路径点特效Tick(): void {
  if (逐段直线路径点特效回调ID === 0) return;
  removePeriodicCallback(逐段直线路径点特效回调ID);
  逐段直线路径点特效回调ID = 0;
}

function 移除逐段直线路径点特效(实例: 逐段直线路径点特效实现): void {
  const 索引 = 活跃逐段直线路径点特效列表.indexOf(实例);
  if (索引 >= 0) 活跃逐段直线路径点特效列表.splice(索引, 1);
  if (活跃逐段直线路径点特效列表.length === 0) 停止逐段直线路径点特效Tick();
}

function 逐段直线路径点特效Tick(this: void): void {
  const 当前毫秒 = getServerTime();
  let 索引 = 0;
  while (索引 < 活跃逐段直线路径点特效列表.length) {
    const 实例 = 活跃逐段直线路径点特效列表[索引];
    实例.推进(当前毫秒);
    if (活跃逐段直线路径点特效列表[索引] === 实例) 索引 += 1;
  }
}

export function 创建逐段直线路径点特效(参数: 逐段直线路径点特效参数): 逐段直线路径点特效句柄 {
  const 实例 = new 逐段直线路径点特效实现(++下一个逐段直线路径点特效ID, 参数);
  活跃逐段直线路径点特效列表.push(实例);
  实例.启动();
  if (!实例.是否已停止()) 确保逐段直线路径点特效Tick();
  return 实例;
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

export interface 循环点特效参数 extends 特效XYZ轴旋转参数 {
  模型路径: string;
  X: number;
  Y: number;
  Z?: number;
  缩放?: number;
  动画速度?: number;
  顶点颜色?: number;
  RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number };
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
  if (参数.RGB != null) {
    return DzGetColor(
      限制到颜色字节(参数.RGB.透明度 ?? 255),
      限制到颜色字节(参数.RGB.红),
      限制到颜色字节(参数.RGB.绿),
      限制到颜色字节(参数.RGB.蓝),
    );
  }
  if (参数.红 == null || 参数.绿 == null || 参数.蓝 == null) return undefined;
  const alpha = 限制到颜色字节(参数.透明度 ?? 255);
  const red = 限制到颜色字节(参数.红);
  const green = 限制到颜色字节(参数.绿);
  const blue = 限制到颜色字节(参数.蓝);
  return DzGetColor(alpha, red, green, blue);
}

function 销毁循环点特效句柄(this: void, effect: any): void {
  if (effect == null || effect === 0) return;
  安全设置特效坐标(effect, 0, 0);
  EXSetEffectSize(effect, 0.00);
  DestroyEffect(effect);
}

function 创建循环点特效一次(this: void, 记录: 循环点特效记录): any {
  const 参数 = 记录.参数;
  const effect = EC_CreateEffect(
    规范化特效模型路径(参数.模型路径),
    参数.X,
    参数.Y,
    参数.Z ?? 0,
    0,
    参数.缩放 ?? 1,
    参数.动画速度 ?? 1,
    -1,
  );
  if (effect == null || effect === 0) return null;
  设置特效XYZ轴旋转(effect, 参数);
  const color = 取特效顶点颜色(参数);
  if (color != null) DzSetEffectVertexColor(effect, color);
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
  if (effect == null || effect === 0) return;
  DzUnbindEffect(effect);
  DzSetEffectScale(effect, 0);
  安排定时销毁特效(effect, 0.01);
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

  const effect = EC_CreateEffect(规范化特效模型路径(modelPath), GetUnitX(unit), GetUnitY(unit), 0, 0, scale, 1, -1);
  if (!effect) return null;
  DzBindEffect(unit, attachPoint, effect);
  Dz绑定单位特效表.set(key, effect);
  return effect;
}

export function 设置Dz绑定特效缩放(effect: any, scale: number): void {
  if (effect == null || effect === 0) return;
  DzSetEffectScale(effect, scale);
  EXSetEffectSize(effect, scale);
  EXEffectMatScale(effect, scale, scale, scale);
}

/** 安全设置普通特效实例缩放，不要求特效使用 Dz 绑定。 */
export function 设置特效缩放(effect: any, scale: number): void {
  if (effect == null || effect === 0 || scale <= 0) return;
  EXSetEffectSize(effect, scale);
}

/** 使用 DzGetColor 组装完整 ARGB，避免手算颜色遗漏 Alpha 或通道错位。 */
export function 设置特效颜色(effect: any, red: number, green: number, blue: number, alpha: number = 255): void {
  if (effect == null || effect === 0) return;
  DzSetEffectVertexColor(effect, DzGetColor(alpha, red, green, blue));
}

function 单位可坐标跟随(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 销毁单位坐标跟随特效记录(this: void, key: string, record: any): void {
  const effect = record == null ? null : record.effect;
  if (effect != null && effect !== 0) {
    安全设置特效坐标(effect, 0, 0);
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
    let x = GetUnitX(record.unit);
    let y = GetUnitY(record.unit);
    if (record.面向跟随 === true) {
      const 面向弧度 = GetUnitFacing(record.unit) * 0.017453292519943295;
      if (record.前方偏移距离 != null && record.前方偏移距离 > 0) {
        x = x + Cos(面向弧度) * record.前方偏移距离;
        y = y + Sin(面向弧度) * record.前方偏移距离;
      }
      EXEffectMatRotateZ(record.effect, 面向弧度);
    }
    安全设置特效坐标(record.effect, x, y);
    EXSetEffectZ(record.effect, EC_GetPointZ(x, y) + record.height);
  }
  if (单位坐标跟随特效数量 <= 0) {
    停止单位坐标跟随特效Tick();
  }
}

function 确保单位坐标跟随特效Tick(this: void): void {
  if (单位坐标跟随特效回调ID > 0) return;
  单位坐标跟随特效回调ID = addPeriodicCallback(单位坐标跟随特效间隔毫秒, on单位坐标跟随特效Tick);
}

export function 创建单位坐标跟随特效(unit: any, modelPath: string, effectKey: string = "default", scale: number = 1, height: number = 单位坐标跟随特效默认高度, animSpeed?: number, 动画索引?: number, 面向弧度: number = 0, RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number }, 面向跟随单位?: boolean, 前方偏移距离?: number): any {
  if (!单位可坐标跟随(unit) || modelPath === "") return null;
  const key = getUnitEffectKey(unit, effectKey);
  if (key === "") return null;

  const existingRecord = 单位坐标跟随特效表[key];
  if (existingRecord) {
    销毁单位坐标跟随特效记录(key, existingRecord);
  }

  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  const effect = EC_CreateEffect(规范化特效模型路径(modelPath), x, y, height, 面向弧度, scale, animSpeed ?? 1, -1);
  if (!effect) return null;
  安全设置特效坐标(effect, x, y);
  EXSetEffectZ(effect, EC_GetPointZ(x, y) + height);
  if (动画索引 != null && DzSetEffectAnimation != null) {
    DzSetEffectAnimation(effect, 动画索引, 0);
  }
  if (RGB != null) {
    DzSetEffectVertexColor(effect, DzGetColor(RGB.透明度 ?? 255, RGB.红, RGB.绿, RGB.蓝));
  }
  if (面向跟随单位 === true) {
    EXEffectMatRotateZ(effect, GetUnitFacing(unit) * 0.017453292519943295);
  }
  单位坐标跟随特效表[key] = { unit, effect, scale, height, animSpeed, 面向跟随: 面向跟随单位 === true, 前方偏移距离: 前方偏移距离 ?? 0 };
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
