/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const SetUnitX = jass.SetUnitX as (whichUnit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (whichUnit: any, y: number) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export interface 方向抵抗牵引清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
  登记周期回调?(名称: string, 回调ID: number): void;
}

export interface 方向抵抗牵引参数 {
  名称?: string;
  目标单位列表?: any[];
  目标单位提供器?: (this: void) => any[] | undefined;
  中心单位?: any;
  中心X?: number;
  中心Y?: number;
  持续秒: number;
  每秒拉力速度: number;
  抵抗方向角度: number;
  抵抗夹角?: number;
  抵抗后拉力倍率?: number;
  启用方向抵抗?: boolean;
  Tick毫秒?: number;
  最大执行次数?: number;
  最小位移识别?: number;
  到达距离?: number;
  清理篮子?: 方向抵抗牵引清理篮子;
  过滤单位?: (this: void, 单位: any) => boolean;
  on结束?: (this: void) => void;
}

export interface 方向抵抗牵引控制器 {
  readonly 名称: string;
  停止(): void;
}

interface 单位位置记录 {
  x: number;
  y: number;
}

const 角度转弧度 = 0.017453292519943295;
const 弧度转角度 = 57.29577951308232;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true && GetUnitState(单位, UNIT_STATE_LIFE) > 0.405;
}

function 角度差(this: void, a: number, b: number): number {
  let diff = a - b;
  while (diff > 180) diff -= 360;
  while (diff < -180) diff += 360;
  return diff < 0 ? -diff : diff;
}

function 取中心(this: void, 参数: 方向抵抗牵引参数): { x: number; y: number } | undefined {
  if (单位有效(参数.中心单位)) return { x: GetUnitX(参数.中心单位), y: GetUnitY(参数.中心单位) };
  if (参数.中心X != null && 参数.中心Y != null) return { x: 参数.中心X, y: 参数.中心Y };
  return undefined;
}

class 方向抵抗牵引控制器实现 implements 方向抵抗牵引控制器 {
  readonly 名称: string;
  private 参数: 方向抵抗牵引参数;
  private 周期回调ID = 0;
  private 已停止 = false;
  private 运行毫秒 = 0;
  private 已执行次数 = 0;
  private 位置记录: Record<number, 单位位置记录 | undefined> = {};

  constructor(名称: string, 参数: 方向抵抗牵引参数) {
    this.名称 = 名称;
    this.参数 = 参数;
  }

  设置周期回调ID(id: number): void {
    this.周期回调ID = id;
  }

  Tick(): void {
    if (this.已停止) return;
    if (this.参数.最大执行次数 != null && this.已执行次数 >= this.参数.最大执行次数) {
      this.停止();
      if (this.参数.on结束 != null) this.参数.on结束();
      return;
    }
    const tick毫秒 = this.参数.Tick毫秒 ?? 20;
    this.运行毫秒 += tick毫秒;
    if (this.运行毫秒 >= this.参数.持续秒 * 1000) {
      this.停止();
      if (this.参数.on结束 != null) this.参数.on结束();
      return;
    }

    const 中心 = 取中心(this.参数);
    if (中心 == null) return;
    const 每Tick拉力 = this.参数.每秒拉力速度 * tick毫秒 / 1000;
    const 启用方向抵抗 = this.参数.启用方向抵抗 !== false;
    const 抵抗夹角 = this.参数.抵抗夹角 ?? 45;
    const 抵抗倍率 = this.参数.抵抗后拉力倍率 ?? 0.25;
    const 最小位移识别 = this.参数.最小位移识别 ?? 2;
    const 到达距离 = this.参数.到达距离 ?? 32;

    const 目标单位列表 = (this.参数.目标单位提供器 != null
      ? this.参数.目标单位提供器()
      : this.参数.目标单位列表) ?? [];
    for (let i = 0; i < 目标单位列表.length; i++) {
      const 单位 = 目标单位列表[i];
      if (!单位有效(单位)) continue;
      if (this.参数.过滤单位 != null && !this.参数.过滤单位(单位)) continue;

      const x = GetUnitX(单位);
      const y = GetUnitY(单位);
      const id = jass.GetHandleId(单位) || 0;
      const 上次 = this.位置记录[id];
      let 拉力倍率 = 1;
      if (启用方向抵抗 && 上次 != null) {
        const mx = x - 上次.x;
        const my = y - 上次.y;
        if (mx * mx + my * my >= 最小位移识别 * 最小位移识别) {
          const 移动角度 = Atan2(my, mx) * 弧度转角度;
          if (角度差(移动角度, this.参数.抵抗方向角度) <= 抵抗夹角) 拉力倍率 = 抵抗倍率;
        }
      }

      const dx = 中心.x - x;
      const dy = 中心.y - y;
      const 距离 = SquareRoot(dx * dx + dy * dy);
      if (距离 > 到达距离) {
        const 拉力角度 = Atan2(dy, dx);
        const 位移 = 每Tick拉力 * 拉力倍率;
        SetUnitX(单位, x + Cos(拉力角度) * 位移);
        SetUnitY(单位, y + Sin(拉力角度) * 位移);
      }
      this.位置记录[id] = { x: GetUnitX(单位), y: GetUnitY(单位) };
    }
    this.已执行次数 += 1;
    if (this.参数.最大执行次数 != null && this.已执行次数 >= this.参数.最大执行次数) {
      this.停止();
      if (this.参数.on结束 != null) this.参数.on结束();
    }
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.周期回调ID !== 0) {
      removePeriodicCallback(this.周期回调ID);
      this.周期回调ID = 0;
    }
    this.位置记录 = {};
  }
}

export function 开始方向抵抗牵引(this: void, 参数: 方向抵抗牵引参数): 方向抵抗牵引控制器 {
  const 名称 = 参数.名称 ?? "方向抵抗牵引";
  const 控制器 = new 方向抵抗牵引控制器实现(名称, 参数);
  const tick毫秒 = 参数.Tick毫秒 ?? 20;
  const id = addPeriodicCallback(tick毫秒, function 方向抵抗牵引Tick(this: void): void {
    控制器.Tick();
  });
  控制器.设置周期回调ID(id);
  if (参数.清理篮子 != null) {
    if (参数.清理篮子.登记周期回调 != null) 参数.清理篮子.登记周期回调(`${名称}-周期`, id);
    else 参数.清理篮子.登记清理(`${名称}-停止`, function 停止方向抵抗牵引(this: void): void {
      控制器.停止();
    });
  }
  return 控制器;
}
