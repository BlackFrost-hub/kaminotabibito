/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const R2I = jass.R2I as (value: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export type 失去资源类型 = "生命" | "魔法";

export interface 失去资源属性事件 {
  单位: any;
  旧档位: number;
  新档位: number;
  缺失比例: number;
  满档比例: number;
}

export interface 失去资源属性转换参数 {
  名称?: string;
  单位: any;
  资源类型: 失去资源类型;
  满档缺失比例: number;
  档位数量?: number;
  检查间隔毫秒?: number;
  on档位变化: (this: void, event: 失去资源属性事件) => void;
}

export interface 失去资源属性转换控制器 {
  readonly 名称: string;
  读取档位(): number;
  刷新(): number;
  停止(): void;
}

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取资源比例(this: void, 单位: any, 类型: 失去资源类型): number {
  const current = GetUnitState(单位, 类型 === "生命" ? UNIT_STATE_LIFE : UNIT_STATE_MANA);
  const max = GetUnitState(单位, 类型 === "生命" ? UNIT_STATE_MAX_LIFE : UNIT_STATE_MAX_MANA);
  if (max <= 0) return 0;
  const missing = max - current;
  if (missing <= 0) return 0;
  return missing / max;
}

class 失去资源属性转换实现 implements 失去资源属性转换控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 失去资源属性转换参数;
  private 当前档位 = 0;
  private 已停止 = false;

  constructor(名称: string, 参数: 失去资源属性转换参数, 控制器ID: number) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.控制器ID = 控制器ID;
    this.刷新();
    失去资源属性转换表[this.控制器ID] = this;
    确保失去资源属性转换Tick(参数.检查间隔毫秒 ?? 200);
  }

  读取档位(): number {
    return this.当前档位;
  }

  刷新(): number {
    if (this.已停止) return this.当前档位;
    if (!单位有效(this.参数.单位)) {
      this.设置档位(0, 0);
      return this.当前档位;
    }
    const ratio = 取资源比例(this.参数.单位, this.参数.资源类型);
    const maxRatio = this.参数.满档缺失比例 > 0 ? this.参数.满档缺失比例 : 1;
    let normalized = ratio / maxRatio;
    if (normalized < 0) normalized = 0;
    if (normalized > 1) normalized = 1;
    const 档位数量 = this.参数.档位数量 != null && this.参数.档位数量 > 0 ? this.参数.档位数量 : 100;
    const 新档位 = R2I(normalized * 档位数量);
    this.设置档位(新档位, ratio);
    return this.当前档位;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 失去资源属性转换表[this.控制器ID];
    尝试停止失去资源属性转换Tick();
    if (this.当前档位 !== 0) {
      this.设置档位(0, 0);
    }
  }

  private 设置档位(新档位: number, 缺失比例: number): void {
    if (新档位 === this.当前档位) return;
    const 旧档位 = this.当前档位;
    this.当前档位 = 新档位;
    this.参数.on档位变化({ 单位: this.参数.单位, 旧档位, 新档位, 缺失比例, 满档比例: this.参数.满档缺失比例 });
  }
}

const 失去资源属性转换表: Record<number, 失去资源属性转换实现> = {};
let 失去资源属性转换计数 = 0;
let 失去资源属性转换TickID = 0;

function 确保失去资源属性转换Tick(this: void, interval: number): void {
  if (失去资源属性转换TickID !== 0) return;
  失去资源属性转换TickID = addPeriodicCallback(interval, on失去资源属性转换Tick);
}

function 尝试停止失去资源属性转换Tick(this: void): void {
  for (const key in 失去资源属性转换表) {
    if (失去资源属性转换表[key] != null) return;
  }
  if (失去资源属性转换TickID !== 0) {
    removePeriodicCallback(失去资源属性转换TickID);
    失去资源属性转换TickID = 0;
  }
}

export function 创建失去资源属性转换(this: void, 参数: 失去资源属性转换参数): 失去资源属性转换控制器 {
  失去资源属性转换计数 += 1;
  return new 失去资源属性转换实现(参数.名称 ?? "失去资源属性转换", 参数, 失去资源属性转换计数);
}

function on失去资源属性转换Tick(this: void): void {
  for (const key in 失去资源属性转换表) {
    const 控制器 = 失去资源属性转换表[key];
    if (控制器 != null) 控制器.刷新();
  }
}
