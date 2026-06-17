/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 层数衰减配置 {
  等待秒: number;
  间隔秒: number;
  每次减少层数?: number;
  加速条件?: (this: void, 单位: any) => boolean;
  加速等待秒?: number;
  加速间隔秒?: number;
}

export interface 层数表现档位 {
  键: string;
  最小层数: number;
  最大层数?: number;
}

export interface 层数变化事件 {
  单位: any;
  旧层数: number;
  新层数: number;
  原因: string;
}

export interface 可配置层数状态配置 {
  状态ID: string;
  最大层数: number;
  初始层数?: number;
  衰减?: 层数衰减配置;
  表现档位?: 层数表现档位[];
  on层数变化?: (this: void, 事件: 层数变化事件) => void;
  on清空?: (this: void, 单位: any, 原因: string) => void;
  on表现变化?: (this: void, 单位: any, 旧表现键: string, 新表现键: string, 当前层数: number) => void;
}

export interface 可配置层数状态控制器 {
  readonly 配置: 可配置层数状态配置;
  增加(单位: any, 层数?: number, 原因?: string): number;
  设置(单位: any, 层数: number, 原因?: string): number;
  减少(单位: any, 层数?: number, 原因?: string): number;
  清空(单位: any, 原因?: string): void;
  取层数(单位: any): number;
  销毁(): void;
}

interface 单位层数状态 {
  单位: any;
  层数: number;
  表现键: string;
  衰减模式: string;
  下次衰减Ms: number;
}

let 层数状态驱动ID = 0;
let 层数状态控制器计数 = 0;
const 层数状态控制器表: Record<number, 可配置层数状态实现> = {};

function 限制层数(this: void, value: number, max: number): number {
  if (value <= 0) return 0;
  if (value >= max) return max;
  return value;
}

function 取表现键(this: void, 配置: 可配置层数状态配置, 层数: number): string {
  if (层数 <= 0 || 配置.表现档位 == null) return "";
  for (let i = 0; i < 配置.表现档位.length; i++) {
    const 档位 = 配置.表现档位[i];
    const 最大层数 = 档位.最大层数 == null ? 配置.最大层数 : 档位.最大层数;
    if (层数 >= 档位.最小层数 && 层数 <= 最大层数) return 档位.键;
  }
  return "";
}

function 取当前衰减模式(this: void, 单位: any, 配置: 层数衰减配置): string {
  if (配置.加速条件 != null && 配置.加速条件(单位)) return "加速";
  return "普通";
}

function 取衰减等待Ms(this: void, 配置: 层数衰减配置, 模式: string): number {
  if (模式 === "加速" && 配置.加速等待秒 != null) return 配置.加速等待秒 * 1000;
  return 配置.等待秒 * 1000;
}

function 取衰减间隔Ms(this: void, 配置: 层数衰减配置, 模式: string): number {
  if (模式 === "加速" && 配置.加速间隔秒 != null) return 配置.加速间隔秒 * 1000;
  return 配置.间隔秒 * 1000;
}

function 确保层数状态驱动(this: void): void {
  if (层数状态驱动ID !== 0) return;
  层数状态驱动ID = addPeriodicCallback(200, on层数状态Tick);
}

function 尝试停止层数状态驱动(this: void): void {
  for (const key in 层数状态控制器表) {
    if (层数状态控制器表[key] != null) return;
  }
  if (层数状态驱动ID !== 0) {
    removePeriodicCallback(层数状态驱动ID);
    层数状态驱动ID = 0;
  }
}

function on层数状态Tick(this: void): void {
  const now = getServerTime();
  for (const key in 层数状态控制器表) {
    const 控制器 = 层数状态控制器表[key];
    if (控制器 != null) 控制器.推进衰减(now);
  }
}

class 可配置层数状态实现 implements 可配置层数状态控制器 {
  readonly 配置: 可配置层数状态配置;
  readonly 控制器ID: number;
  private 状态表: Record<number, 单位层数状态> = {};

  constructor(配置: 可配置层数状态配置) {
    this.配置 = 配置;
    this.控制器ID = ++层数状态控制器计数;
    层数状态控制器表[this.控制器ID] = this;
    确保层数状态驱动();
  }

  增加(单位: any, 层数: number = 1, 原因: string = "增加"): number {
    return this.设置(单位, this.取层数(单位) + 层数, 原因);
  }

  减少(单位: any, 层数: number = 1, 原因: string = "减少"): number {
    return this.设置(单位, this.取层数(单位) - 层数, 原因);
  }

  设置(单位: any, 层数: number, 原因: string = "设置"): number {
    if (单位 == null || 单位 === 0) return 0;
    const 单位ID = GetHandleId(单位);
    const 旧状态 = this.状态表[单位ID];
    const 旧层数 = 旧状态 == null ? 0 : 旧状态.层数;
    const 新层数 = 限制层数(层数, this.配置.最大层数);
    if (旧层数 === 新层数) return 新层数;

    if (新层数 <= 0) {
      this.清空(单位, 原因);
      return 0;
    }

    const 表现键 = 取表现键(this.配置, 新层数);
    const 状态 = 旧状态 ?? this.创建空状态(单位);
    const 旧表现键 = 状态.表现键;
    状态.层数 = 新层数;
    状态.表现键 = 表现键;
    this.刷新衰减时间(状态, getServerTime());
    this.状态表[单位ID] = 状态;
    this.触发变化(单位, 旧层数, 新层数, 原因);
    this.触发表现变化(单位, 旧表现键, 表现键, 新层数);
    return 新层数;
  }

  清空(单位: any, 原因: string = "清空"): void {
    if (单位 == null || 单位 === 0) return;
    const 单位ID = GetHandleId(单位);
    const 状态 = this.状态表[单位ID];
    if (状态 == null) return;
    const 旧层数 = 状态.层数;
    const 旧表现键 = 状态.表现键;
    delete this.状态表[单位ID];
    this.触发变化(单位, 旧层数, 0, 原因);
    this.触发表现变化(单位, 旧表现键, "", 0);
    if (this.配置.on清空 != null) this.配置.on清空(单位, 原因);
  }

  取层数(单位: any): number {
    if (单位 == null || 单位 === 0) return 0;
    const 状态 = this.状态表[GetHandleId(单位)];
    return 状态 == null ? 0 : 状态.层数;
  }

  销毁(): void {
    for (const key in this.状态表) {
      const 状态 = this.状态表[key];
      if (状态 != null) {
        this.清空(状态.单位, "控制器销毁");
      }
    }
    delete 层数状态控制器表[this.控制器ID];
    尝试停止层数状态驱动();
  }

  推进衰减(now: number): void {
    const 衰减 = this.配置.衰减;
    if (衰减 == null) return;
    for (const key in this.状态表) {
      const 状态 = this.状态表[key];
      if (状态 == null) continue;
      const 单位 = 状态.单位;
      if (单位 == null || 单位 === 0 || IsUnitType(单位, UNIT_TYPE_DEAD)) {
        this.清空(单位, "单位失效");
        continue;
      }

      const 当前模式 = 取当前衰减模式(单位, 衰减);
      if (当前模式 !== 状态.衰减模式) {
        状态.衰减模式 = 当前模式;
        状态.下次衰减Ms = now + 取衰减等待Ms(衰减, 当前模式);
        continue;
      }
      if (now < 状态.下次衰减Ms) continue;

      const 减少层数 = 衰减.每次减少层数 == null ? 1 : 衰减.每次减少层数;
      this.设置(单位, 状态.层数 - 减少层数, 当前模式 === "加速" ? "加速衰减" : "衰减");
      const 新状态 = this.状态表[key];
      if (新状态 != null) {
        新状态.衰减模式 = 当前模式;
        新状态.下次衰减Ms = now + 取衰减间隔Ms(衰减, 当前模式);
      }
    }
  }

  private 创建空状态(单位: any): 单位层数状态 {
    return {
      单位,
      层数: 0,
      表现键: "",
      衰减模式: "普通",
      下次衰减Ms: 0,
    };
  }

  private 刷新衰减时间(状态: 单位层数状态, now: number): void {
    const 衰减 = this.配置.衰减;
    if (衰减 == null) return;
    const 模式 = 取当前衰减模式(状态.单位, 衰减);
    状态.衰减模式 = 模式;
    状态.下次衰减Ms = now + 取衰减等待Ms(衰减, 模式);
  }

  private 触发变化(单位: any, 旧层数: number, 新层数: number, 原因: string): void {
    if (this.配置.on层数变化 == null) return;
    this.配置.on层数变化({ 单位, 旧层数, 新层数, 原因 });
  }

  private 触发表现变化(单位: any, 旧表现键: string, 新表现键: string, 当前层数: number): void {
    if (旧表现键 === 新表现键 || this.配置.on表现变化 == null) return;
    this.配置.on表现变化(单位, 旧表现键, 新表现键, 当前层数);
  }
}

export function 创建可配置层数状态(this: void, 配置: 可配置层数状态配置): 可配置层数状态控制器 {
  return new 可配置层数状态实现(配置);
}
