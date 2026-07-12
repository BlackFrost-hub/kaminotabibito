/** @noSelfInFile */

import { 创建句柄上下文托管器 } from "../../04．机制组件/09．装备通用机制/24．句柄上下文托管";
import { 注册持有型范围光环, type 范围光环目标类型, type 范围光环去重类型 } from "./01．范围光环";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

export interface 数值光环效果定义 {
  key: string;
  计算总值: (this: void, target: any, 总层数: number, 已应用值: number) => number;
  应用差值: (this: void, target: any, 差值: number) => void;
}

export interface 数值光环Buff配置 {
  BuffID: string;
  持续秒: number;
  取显示值?: (this: void, target: any, 总层数: number, 来源: any, 已应用值表: Record<string, number | undefined>) => number;
  取附加参数?: (this: void, target: any, 总层数: number, 来源: any, 已应用值表: Record<string, number | undefined>) => any;
  自定义同步?: (this: void, target: any, 总层数: number, 来源: any, 已应用值表: Record<string, number | undefined>) => void;
  自定义移除?: (this: void, target: any) => void;
  归零移除?: boolean;
}

export interface 数值Buff范围光环参数 {
  状态ID: string;
  物品类型ID: number;
  间隔毫秒: number;
  半径: number;
  目标类型: 范围光环目标类型;
  去重类型?: 范围光环去重类型;
  排除无敌?: boolean;
  最小生命值?: number;
  最大层数?: number;
  额外筛选?: (this: void, target: any, holder: any) => boolean;
  数值效果列表: 数值光环效果定义[];
  Buff?: 数值光环Buff配置;
}

interface 数值光环目标状态 {
  总层数: number;
  持有者贡献表: Record<number, number | undefined>;
  持有者表: Record<number, any>;
  已应用值表: Record<string, number | undefined>;
}

function 取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

export function 注册数值Buff范围光环(this: void, 参数: 数值Buff范围光环参数): void {
  const 托管器 = 创建句柄上下文托管器<数值光环目标状态>(参数.状态ID);

  function 取或建状态(this: void, target: any): 数值光环目标状态 {
    const old = 托管器.读取(target);
    if (old != null) return old;
    const next: 数值光环目标状态 = {
      总层数: 0,
      持有者贡献表: {},
      持有者表: {},
      已应用值表: {},
    };
    托管器.写入(target, next);
    return next;
  }

  function 取来源(this: void, 状态: 数值光环目标状态, 优先来源?: any): any {
    const preferredId = 取句柄ID(优先来源);
    if (preferredId !== 0 && (状态.持有者贡献表[preferredId] ?? 0) > 0) return 优先来源;
    for (const key in 状态.持有者表) {
      const holder = 状态.持有者表[key];
      if (holder != null && holder !== 0 && (状态.持有者贡献表[key] ?? 0) > 0) return holder;
    }
    return undefined;
  }

  function 计算总层数(this: void, 状态: 数值光环目标状态): number {
    let total = 0;
    for (const key in 状态.持有者贡献表) total += 状态.持有者贡献表[key] ?? 0;
    if (参数.最大层数 != null && total > 参数.最大层数) return 参数.最大层数;
    return total;
  }

  function 同步Buff(this: void, target: any, 状态: 数值光环目标状态, 来源: any): void {
    const buff = 参数.Buff;
    if (buff == null) return;
    if (状态.总层数 <= 0) {
      if (buff.自定义移除 != null) buff.自定义移除(target);
      else if (buff.归零移除 !== false) 移除单位指定Buff(target, buff.BuffID);
      return;
    }
    if (buff.自定义同步 != null) {
      buff.自定义同步(target, 状态.总层数, 来源, 状态.已应用值表);
      return;
    }
    if (buff.持续秒 <= 0) return;
    const effectValue = buff.取显示值 == null ? 状态.总层数 : buff.取显示值(target, 状态.总层数, 来源, 状态.已应用值表);
    const extras = buff.取附加参数 == null ? undefined : buff.取附加参数(target, 状态.总层数, 来源, 状态.已应用值表);
    registerManualBuff(target, buff.BuffID, buff.持续秒, effectValue, extras);
  }

  function 同步目标(this: void, target: any, 优先来源?: any): void {
    const 状态 = 托管器.读取(target);
    if (状态 == null) return;
    状态.总层数 = 计算总层数(状态);
    for (let i = 0; i < 参数.数值效果列表.length; i++) {
      const effect = 参数.数值效果列表[i];
      const oldValue = 状态.已应用值表[effect.key] ?? 0;
      const nextValue = 状态.总层数 > 0 ? effect.计算总值(target, 状态.总层数, oldValue) : 0;
      const delta = nextValue - oldValue;
      if (delta !== 0) effect.应用差值(target, delta);
      状态.已应用值表[effect.key] = nextValue;
    }
    const source = 取来源(状态, 优先来源);
    同步Buff(target, 状态, source);
    if (状态.总层数 <= 0) 托管器.清空(target);
    else 托管器.写入(target, 状态);
  }

  function 设置持有者贡献(this: void, target: any, holder: any, count: number): void {
    const holderId = 取句柄ID(holder);
    if (holderId === 0) return;
    const 状态 = 取或建状态(target);
    状态.持有者贡献表[holderId] = count > 0 ? count : 1;
    状态.持有者表[holderId] = holder;
    同步目标(target, holder);
  }

  function 移除持有者贡献(this: void, target: any, holder: any): void {
    const holderId = 取句柄ID(holder);
    const 状态 = 托管器.读取(target);
    if (holderId === 0 || 状态 == null) return;
    delete 状态.持有者贡献表[holderId];
    delete 状态.持有者表[holderId];
    同步目标(target);
  }

  注册持有型范围光环({
    物品类型ID: 参数.物品类型ID,
    间隔毫秒: 参数.间隔毫秒,
    半径: 参数.半径,
    目标类型: 参数.目标类型,
    去重类型: 参数.去重类型,
    排除无敌: 参数.排除无敌,
    最小生命值: 参数.最小生命值,
    额外筛选: 参数.额外筛选,
    应用目标效果: 设置持有者贡献,
    同步目标效果: 设置持有者贡献,
    移除目标效果: 移除持有者贡献,
  });
}
