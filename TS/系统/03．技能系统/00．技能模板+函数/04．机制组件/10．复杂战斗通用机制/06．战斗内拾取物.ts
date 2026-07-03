/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const EXSetEffectXY = japi.EXSetEffectXY as ((effect: any, x: number, y: number) => void) | undefined;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 战斗内拾取物参数 {
  清理?: 机制清理篮子;
  名称: string;
  X: number;
  Y: number;
  模型路径: string;
  高度?: number;
  缩放?: number;
  持续秒?: number;
  拾取半径: number;
  可拾取单位列表: any[] | ((this: void, 变量?: any) => any[]);
  吸附目标?: any;
  吸附速度?: number;
  吸附半径?: number;
  Tick间隔毫秒?: number;
  变量?: any;
  on拾取?: (this: void, 拾取者: any, 实例: 战斗内拾取物实例, 变量?: any) => void;
  on吸收?: (this: void, 吸附目标: any, 实例: 战斗内拾取物实例, 变量?: any) => void;
  on过期?: (this: void, 实例: 战斗内拾取物实例, 变量?: any) => void;
  on销毁?: (this: void, 实例: 战斗内拾取物实例, 原因: 战斗内拾取物结束原因, 变量?: any) => void;
}

export type 战斗内拾取物结束原因 = "拾取" | "吸收" | "过期" | "手动销毁";

export interface 战斗内拾取物实例 {
  readonly ID: number;
  readonly 特效: any;
  取X(): number;
  取Y(): number;
  移动到(x: number, y: number): void;
  销毁(原因?: 战斗内拾取物结束原因): void;
}

const 拾取物表: Record<number, 战斗内拾取物实现 | undefined> = {};
let 下一个拾取物ID = 0;
let 拾取物驱动ID = 0;

function 距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

function 确保驱动(this: void, 间隔毫秒: number): void {
  if (拾取物驱动ID !== 0) return;
  拾取物驱动ID = addPeriodicCallback(间隔毫秒, on拾取物Tick);
}

function 尝试停止驱动(this: void): void {
  for (const key in 拾取物表) {
    if (拾取物表[key] != null) return;
  }
  if (拾取物驱动ID !== 0) {
    removePeriodicCallback(拾取物驱动ID);
    拾取物驱动ID = 0;
  }
}

function on拾取物Tick(this: void): void {
  const now = getServerTime();
  for (const key in 拾取物表) {
    const 实例 = 拾取物表[key];
    if (实例 != null) 实例.推进(now);
  }
}

class 战斗内拾取物实现 implements 战斗内拾取物实例 {
  readonly ID: number;
  readonly 特效: any;
  private 参数: 战斗内拾取物参数;
  private x: number;
  private y: number;
  private 到期时间 = 0;
  private 已销毁 = false;

  constructor(ID: number, 参数: 战斗内拾取物参数, 特效: any) {
    this.ID = ID;
    this.参数 = 参数;
    this.特效 = 特效;
    this.x = 参数.X;
    this.y = 参数.Y;
    if (参数.持续秒 != null && 参数.持续秒 > 0) this.到期时间 = getServerTime() + 参数.持续秒 * 1000;
    拾取物表[ID] = this;
  }

  取X(): number {
    return this.x;
  }

  取Y(): number {
    return this.y;
  }

  移动到(x: number, y: number): void {
    this.x = x;
    this.y = y;
    if (typeof EXSetEffectXY === "function") EXSetEffectXY(this.特效, x, y);
  }

  销毁(原因: 战斗内拾取物结束原因 = "手动销毁"): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    delete 拾取物表[this.ID];
    if (this.特效 != null && this.特效 !== 0) DestroyEffect(this.特效);
    if (this.参数.on销毁 != null) this.参数.on销毁(this, 原因, this.参数.变量);
    尝试停止驱动();
  }

  推进(now: number): void {
    if (this.已销毁) return;
    if (this.到期时间 > 0 && now >= this.到期时间) {
      if (this.参数.on过期 != null) this.参数.on过期(this, this.参数.变量);
      this.销毁("过期");
      return;
    }
    if (this.推进吸附()) return;
    this.检查拾取();
  }

  private 读取可拾取单位(): any[] {
    const raw = this.参数.可拾取单位列表;
    return typeof raw === "function" ? raw(this.参数.变量) : raw;
  }

  private 检查拾取(): void {
    const units = this.读取可拾取单位();
    const radius = this.参数.拾取半径;
    for (let i = 0; i < units.length; i++) {
      const unit = units[i];
      if (unit == null || unit === 0) continue;
      if (距离(this.x, this.y, GetUnitX(unit), GetUnitY(unit)) <= radius) {
        if (this.参数.on拾取 != null) this.参数.on拾取(unit, this, this.参数.变量);
        this.销毁("拾取");
        return;
      }
    }
  }

  private 推进吸附(): boolean {
    const target = this.参数.吸附目标;
    if (target == null || target === 0) return false;
    const tx = GetUnitX(target);
    const ty = GetUnitY(target);
    const dist = 距离(this.x, this.y, tx, ty);
    if (dist <= (this.参数.吸附半径 ?? this.参数.拾取半径)) {
      if (this.参数.on吸收 != null) this.参数.on吸收(target, this, this.参数.变量);
      this.销毁("吸收");
      return true;
    }
    const speed = this.参数.吸附速度 ?? 0;
    if (speed <= 0 || dist <= 0) return false;
    const step = speed * ((this.参数.Tick间隔毫秒 ?? 50) / 1000);
    const ratio = step >= dist ? 1 : step / dist;
    this.移动到(this.x + (tx - this.x) * ratio, this.y + (ty - this.y) * ratio);
    return false;
  }
}

export function 创建战斗内拾取物(this: void, 参数: 战斗内拾取物参数): 战斗内拾取物实例 | undefined {
  if (参数.模型路径 == null || 参数.模型路径 === "") return undefined;
  const effect = AddSpecialEffect(参数.模型路径, 参数.X, 参数.Y);
  if (effect == null || effect === 0) return undefined;
  if (参数.高度 != null && typeof EXSetEffectZ === "function") EXSetEffectZ(effect, 参数.高度);
  if (参数.缩放 != null && typeof EXSetEffectSize === "function") EXSetEffectSize(effect, 参数.缩放);
  const 实例 = new 战斗内拾取物实现(++下一个拾取物ID, 参数, effect);
  确保驱动(参数.Tick间隔毫秒 ?? 50);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 + "#" + String(实例.ID), function 战斗内拾取物清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}
