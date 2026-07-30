/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 单位停留清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
  登记周期回调?(名称: string, 回调ID: number): void;
}

export interface 单位停留状态 {
  目标单位: any;
  已持续毫秒: number;
  是否已触发: boolean;
}

export interface 单位停留触发参数 {
  名称?: string;
  中心单位?: any;
  半径: number;
  需求持续毫秒: number;
  检查间隔毫秒?: number;
  离开后重置?: boolean;
  只触发一次?: boolean;
  单位列表?: any[];
  读取单位列表?: (this: void) => any[];
  过滤单位?: (this: void, 单位: any) => boolean;
  清理篮子?: 单位停留清理篮子;
  on进入?: (this: void, 单位: any) => void;
  on离开?: (this: void, 单位: any, 已持续毫秒: number) => void;
  on触发?: (this: void, 状态: 单位停留状态) => void;
  on刷新完成?: (this: void, 范围内状态列表: 单位停留状态[]) => void;
}

export interface 单位停留触发控制器 {
  readonly 名称: string;
  刷新(): void;
  读取状态(单位: any): 单位停留状态 | undefined;
  停止(): void;
}

interface 内部停留状态 {
  目标单位: any;
  进入毫秒: number;
  已持续毫秒: number;
  是否已触发: boolean;
  当前在范围内: boolean;
}

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 两点距离平方(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return dx * dx + dy * dy;
}

function 读取单位列表(this: void, 参数: 单位停留触发参数): any[] {
  if (参数.读取单位列表 != null) return 参数.读取单位列表();
  return 参数.单位列表 ?? [];
}

class 单位停留触发控制器实现 implements 单位停留触发控制器 {
  readonly 名称: string;
  private 参数: 单位停留触发参数;
  private 周期回调ID = 0;
  private 已停止 = false;
  private 状态表: Record<number, 内部停留状态> = {};

  constructor(名称: string, 参数: 单位停留触发参数) {
    this.名称 = 名称;
    this.参数 = 参数;
  }

  设置周期回调ID(id: number): void {
    this.周期回调ID = id;
  }

  刷新(): void {
    if (this.已停止) return;
    const 中心单位 = this.参数.中心单位;
    if (!单位有效(中心单位)) {
      this.清空全部("中心失效");
      return;
    }

    const now = getServerTime();
    const centerX = GetUnitX(中心单位);
    const centerY = GetUnitY(中心单位);
    const 半径平方 = this.参数.半径 * this.参数.半径;
    const 已访问表: Record<number, true> = {};
    const 范围内状态列表: 单位停留状态[] = [];
    const 列表 = 读取单位列表(this.参数);

    for (let i = 0; i < 列表.length; i++) {
      const 单位 = 列表[i];
      if (!单位有效(单位)) continue;
      if (this.参数.过滤单位 != null && !this.参数.过滤单位(单位)) continue;
      const 单位ID = GetHandleId(单位);
      已访问表[单位ID] = true;
      const 在范围内 = 两点距离平方(GetUnitX(单位), GetUnitY(单位), centerX, centerY) <= 半径平方;
      const 状态 = this.状态表[单位ID];
      if (!在范围内) {
        if (状态 != null && 状态.当前在范围内) this.处理离开(单位ID, 状态);
        continue;
      }
      if (状态 == null) {
        const 新状态: 内部停留状态 = {
          目标单位: 单位,
          进入毫秒: now,
          已持续毫秒: 0,
          是否已触发: false,
          当前在范围内: true,
        };
        this.状态表[单位ID] = 新状态;
        if (this.参数.on进入 != null) this.参数.on进入(单位);
        范围内状态列表.push({
          目标单位: 单位,
          已持续毫秒: 新状态.已持续毫秒,
          是否已触发: false,
        });
        continue;
      }
      状态.当前在范围内 = true;
      状态.已持续毫秒 = now - 状态.进入毫秒;
      if (!状态.是否已触发 && 状态.已持续毫秒 >= this.参数.需求持续毫秒) {
        状态.是否已触发 = true;
        if (this.参数.on触发 != null) {
          this.参数.on触发({
            目标单位: 单位,
            已持续毫秒: 状态.已持续毫秒,
            是否已触发: true,
          });
        }
        if (this.参数.只触发一次 === true) {
          delete this.状态表[单位ID];
        }
      }
      范围内状态列表.push({
        目标单位: 单位,
        已持续毫秒: 状态.已持续毫秒,
        是否已触发: 状态.是否已触发,
      });
    }

    for (const key in this.状态表) {
      if (已访问表[key as any] === true) continue;
      const 状态 = this.状态表[key];
      if (状态 != null) this.处理离开(Number(key), 状态);
    }
    if (this.参数.on刷新完成 != null) this.参数.on刷新完成(范围内状态列表);
  }

  读取状态(单位: any): 单位停留状态 | undefined {
    if (!单位有效(单位)) return undefined;
    const 状态 = this.状态表[GetHandleId(单位)];
    if (状态 == null) return undefined;
    return {
      目标单位: 状态.目标单位,
      已持续毫秒: 状态.已持续毫秒,
      是否已触发: 状态.是否已触发,
    };
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.周期回调ID !== 0) {
      removePeriodicCallback(this.周期回调ID);
      this.周期回调ID = 0;
    }
    this.状态表 = {};
  }

  private 处理离开(单位ID: number, 状态: 内部停留状态): void {
    if (this.参数.on离开 != null) this.参数.on离开(状态.目标单位, 状态.已持续毫秒);
    if (this.参数.离开后重置 !== false) delete this.状态表[单位ID];
    else 状态.当前在范围内 = false;
  }

  private 清空全部(_原因: string): void {
    for (const key in this.状态表) {
      const 状态 = this.状态表[key];
      if (状态 != null && this.参数.on离开 != null) {
        this.参数.on离开(状态.目标单位, 状态.已持续毫秒);
      }
    }
    this.状态表 = {};
  }
}

export function 创建单位停留触发器(this: void, 参数: 单位停留触发参数): 单位停留触发控制器 {
  const 名称 = 参数.名称 ?? "单位停留触发器";
  const 控制器 = new 单位停留触发控制器实现(名称, 参数);
  控制器.刷新();
  const 间隔 = 参数.检查间隔毫秒 ?? 100;
  if (间隔 > 0) {
    const id = addPeriodicCallback(间隔, function 单位停留触发器Tick(this: void): void {
      控制器.刷新();
    });
    控制器.设置周期回调ID(id);
    if (参数.清理篮子 != null) {
      if (参数.清理篮子.登记周期回调 != null) 参数.清理篮子.登记周期回调(`${名称}-周期刷新`, id);
      else 参数.清理篮子.登记清理(`${名称}-停止`, function 停止单位停留触发器(this: void): void {
        控制器.停止();
      });
    }
  }
  return 控制器;
}
