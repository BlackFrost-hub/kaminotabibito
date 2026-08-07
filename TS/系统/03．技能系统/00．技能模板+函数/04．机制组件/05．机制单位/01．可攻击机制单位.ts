/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;

const { 创建召唤物 } = require("../../01．技能函数/11．召唤物/index") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
};

export type 可攻击机制单位结束原因 = "被击杀" | "自然到期" | "主动销毁" | "机制清理" | "单位失效";

export interface 可攻击机制单位参数 {
  清理?: 机制清理篮子;
  名称?: string;
  单位名称?: string;
  主人单位?: any;
  所属玩家?: any;
  单位类型?: string | number;
  模型路径?: string;
  模型文件?: string;
  X: number;
  Y: number;
  朝向?: number;
  最大生命?: number;
  生命值?: number;
  攻击力?: number;
  攻击间隔?: number;
  攻击范围?: number;
  索敌范围?: number;
  护甲?: number;
  固定站桩?: boolean;
  禁止普攻?: boolean;
  禁用路径?: boolean;
  生命值受小怪倍率?: boolean;
  飞行高度?: number;
  缩放?: number;
  透明度?: number;
  红?: number;
  绿?: number;
  蓝?: number;
  普攻弹道模型?: string;
  普攻弹道弧度?: number;
  普攻弹道速度?: number;
  普攻弹道自导?: boolean;
  持续时间?: number;
  变量?: any;
  on死亡?: (this: void, 单位: any, 击杀者: any, 变量?: any) => void;
  on被击杀?: (this: void, 单位: any, 击杀者: any, 变量?: any) => void;
  on自然到期?: (this: void, 单位: any, 变量?: any) => void;
  on销毁?: (this: void, 单位: any, 变量?: any) => void;
  on结束?: (this: void, 单位: any, 原因: 可攻击机制单位结束原因, 击杀者?: any, 变量?: any) => void;
}

export interface 可攻击机制单位实例 {
  readonly 单位: any;
  readonly ID: number;
  是否存活(): boolean;
  处理单位失效(): void;
  销毁(原因?: "主动销毁" | "机制清理"): void;
}

const 机制单位表: Record<number, 可攻击机制单位实现 | undefined> = {};
let 已注册机制单位死亡监听 = false;

function 确保机制单位死亡监听(this: void): void {
  if (已注册机制单位死亡监听) return;
  已注册机制单位死亡监听 = true;
  registerDeathListener(on可攻击机制单位死亡);
}

function 尝试取消机制单位死亡监听(this: void): void {
  for (const key in 机制单位表) {
    if (机制单位表[key] != null) return;
  }
  if (已注册机制单位死亡监听) {
    unregisterDeathListener(on可攻击机制单位死亡);
    已注册机制单位死亡监听 = false;
  }
}

function on可攻击机制单位死亡(this: void, 死亡单位: any, 击杀者: any): void {
  if (死亡单位 == null || 死亡单位 === 0) return;
  const 实例 = 机制单位表[GetHandleId(死亡单位)];
  if (实例 != null) 实例.处理死亡(击杀者);
}

function on可攻击机制单位自然到期(this: void, variable?: any): void {
  const 实例 = variable as 可攻击机制单位实现 | undefined;
  if (实例 != null) 实例.标记自然到期();
}

class 可攻击机制单位实现 implements 可攻击机制单位实例 {
  readonly 单位: any;
  readonly ID: number;
  private 参数: 可攻击机制单位参数;
  private 已经销毁 = false;
  private 已经死亡 = false;
  private 已经触发结束回调 = false;
  private 自然到期已标记 = false;
  private 自然到期回调ID = 0;

  constructor(单位: any, 参数: 可攻击机制单位参数) {
    this.单位 = 单位;
    this.ID = GetHandleId(单位);
    this.参数 = 参数;
    机制单位表[this.ID] = this;
    确保机制单位死亡监听();
    if (参数.持续时间 != null && 参数.持续时间 > 0) {
      this.自然到期回调ID = addDelayedCallback(参数.持续时间 * 1000, on可攻击机制单位自然到期, this);
    }
  }

  是否存活(): boolean {
    return !this.已经销毁 && !this.已经死亡 && isValidUnit(this.单位);
  }

  标记自然到期(): void {
    if (this.已经死亡 || this.已经销毁) return;
    this.自然到期已标记 = true;
    this.自然到期回调ID = 0;
  }

  private 取消自然到期回调(): void {
    if (this.自然到期回调ID !== 0) {
      removeDelayedCallback(this.自然到期回调ID);
      this.自然到期回调ID = 0;
    }
  }

  private 完成结束(原因: 可攻击机制单位结束原因, 击杀者?: any, 是否死亡事件: boolean = false): void {
    if (this.已经触发结束回调) return;
    this.已经触发结束回调 = true;
    if (是否死亡事件 && this.参数.on死亡 != null) this.参数.on死亡(this.单位, 击杀者, this.参数.变量);
    if (原因 === "被击杀" && this.参数.on被击杀 != null) {
      this.参数.on被击杀(this.单位, 击杀者, this.参数.变量);
    } else if (原因 === "自然到期" && this.参数.on自然到期 != null) {
      this.参数.on自然到期(this.单位, this.参数.变量);
    }
    if (this.参数.on结束 != null) this.参数.on结束(this.单位, 原因, 击杀者, this.参数.变量);
    尝试取消机制单位死亡监听();
  }

  处理死亡(击杀者: any): void {
    if (this.已经死亡 || this.已经销毁) return;
    this.已经死亡 = true;
    this.取消自然到期回调();
    delete 机制单位表[this.ID];
    this.完成结束(this.自然到期已标记 ? "自然到期" : "被击杀", 击杀者, true);
  }

  处理单位失效(): void {
    if (this.已经死亡 || this.已经销毁 || isValidUnit(this.单位)) return;
    this.已经死亡 = true;
    this.取消自然到期回调();
    delete 机制单位表[this.ID];
    this.完成结束(this.自然到期已标记 ? "自然到期" : "单位失效");
  }

  销毁(原因: "主动销毁" | "机制清理" = "主动销毁"): void {
    if (this.已经销毁) return;
    this.已经销毁 = true;
    this.取消自然到期回调();
    delete 机制单位表[this.ID];
    if (this.参数.on销毁 != null) this.参数.on销毁(this.单位, this.参数.变量);
    this.完成结束(原因);
    if (this.单位 != null && this.单位 !== 0) RemoveUnit(this.单位);
  }
}

export function 创建可攻击机制单位(this: void, 参数: 可攻击机制单位参数): 可攻击机制单位实例 | undefined {
  const unit = 创建召唤物({
    主人单位: 参数.主人单位,
    所属玩家: 参数.所属玩家,
    单位类型: 参数.单位类型,
    单位名称: 参数.单位名称 ?? 参数.名称,
    模型路径: 参数.模型文件 ?? 参数.模型路径,
    X: 参数.X,
    Y: 参数.Y,
    朝向: 参数.朝向,
    生命值: 参数.生命值 ?? 参数.最大生命,
    攻击力: 参数.攻击力,
    攻击间隔: 参数.攻击间隔,
    攻击范围: 参数.攻击范围,
    索敌范围: 参数.索敌范围,
    护甲: 参数.护甲,
    固定站桩: 参数.固定站桩,
    禁止普攻: 参数.禁止普攻,
    禁用路径: 参数.禁用路径,
    生命值受小怪倍率: 参数.生命值受小怪倍率 === false ? false : true,
    飞行高度: 参数.飞行高度,
    缩放: 参数.缩放,
    透明度: 参数.透明度,
    红: 参数.红,
    绿: 参数.绿,
    蓝: 参数.蓝,
    普攻弹道模型: 参数.普攻弹道模型,
    普攻弹道弧度: 参数.普攻弹道弧度,
    普攻弹道速度: 参数.普攻弹道速度,
    普攻弹道自导: 参数.普攻弹道自导,
    持续时间: 参数.持续时间,
  });
  if (unit == null || unit === 0) return undefined;

  const 实例 = new 可攻击机制单位实现(unit, 参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 ?? "可攻击机制单位", function 可攻击机制单位清理回调(this: void): void {
      实例.销毁("机制清理");
    });
  }
  return 实例;
}
