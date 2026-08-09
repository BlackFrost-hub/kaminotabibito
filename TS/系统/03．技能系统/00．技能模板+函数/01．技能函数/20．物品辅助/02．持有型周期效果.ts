/** @noSelfInFile */

import type { 自适应共享周期驱动 } from "../../04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 创建自适应共享周期驱动 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器") as {
  创建自适应共享周期驱动: (this: void, 参数: any) => 自适应共享周期驱动;
};
const {
  监听指定物品获取丢弃,
  获取单位当前持有指定物品数量,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  监听指定物品获取丢弃: (
    this: void,
    itemTypeId: number,
    获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
    丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
  ) => void;
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;

export interface 持有型周期效果参数 {
  物品类型ID: number;
  间隔毫秒: number;
  按单位独立计时?: boolean;
  周期回调: (this: void, unit: any, currentCount: number) => void;
  获取回调?: (this: void, unit: any, currentCount: number) => void;
  丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  初始单位列表?: (this: void) => any[];
}

export interface 持有型周期效果控制器 {
  获取单位列表(this: void): any[];
  获取单位数量(this: void): number;
  读取单位下次触发剩余毫秒(this: void, unit: any): number;
}

type 持有型周期效果状态 = {
  单位: any;
  数量: number;
  下次触发时间: number;
};

type 持有型周期效果实例 = 持有型周期效果参数 & 持有型周期效果控制器 & {
  下次触发时间: number;
  单位状态: Record<number, 持有型周期效果状态 | undefined>;
};

const 持有型周期效果实例表: 持有型周期效果实例[] = [];
const 已注册监听物品类型: Record<number, boolean | undefined> = {};
let 持有型周期效果驱动: 自适应共享周期驱动 | undefined;

function 获取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 按升序插入数字(this: void, 数字列表: number[], 数字: number): void {
  let 插入位置 = 数字列表.length;
  for (let i = 0; i < 数字列表.length; i++) {
    if (数字 < 数字列表[i]) {
      插入位置 = i;
      break;
    }
  }
  数字列表.splice(插入位置, 0, 数字);
}

function 获取有序单位状态ID列表(this: void, 状态表: Record<number, 持有型周期效果状态 | undefined>): number[] {
  const ids: number[] = [];
  for (const unitKey in 状态表) {
    const unitId = Number(unitKey);
    if (!isNaN(unitId)) 按升序插入数字(ids, unitId);
  }
  return ids;
}

function 处理获得(this: void, 配置: 持有型周期效果实例, unit: any, _item: any, currentCount: number, previousCount: number): void {
  const unitId = 获取单位ID(unit);
  if (unitId === 0) return;
  if (currentCount <= 0) {
    delete 配置.单位状态[unitId];
    if (previousCount > 0) {
      配置.丢弃回调?.(unit, previousCount);
    }
    return;
  }

  配置.单位状态[unitId] = {
    单位: unit,
    数量: 1,
    下次触发时间: getServerTime() + 配置.间隔毫秒,
  };
  if (previousCount <= 0) {
    配置.获取回调?.(unit, 1);
  }
}

function 处理丢弃(this: void, 配置: 持有型周期效果实例, unit: any, _item: any, currentCount: number, previousCount: number): void {
  const unitId = 获取单位ID(unit);
  if (unitId === 0) return;
  if (currentCount <= 0) {
    delete 配置.单位状态[unitId];
    if (previousCount > 0) {
      配置.丢弃回调?.(unit, previousCount);
    }
    return;
  }
  const 原状态 = 配置.单位状态[unitId];
  配置.单位状态[unitId] = {
    单位: unit,
    数量: 1,
    下次触发时间: 原状态?.下次触发时间 ?? getServerTime() + 配置.间隔毫秒,
  };
}

function on持有型周期效果Tick(this: void, now: number): void {
  for (let i = 0; i < 持有型周期效果实例表.length; i++) {
    const 配置 = 持有型周期效果实例表[i];
    if (配置.按单位独立计时 !== true) {
      if (now < 配置.下次触发时间) continue;
      配置.下次触发时间 = now + 配置.间隔毫秒;
    }

    const 待清理: number[] = [];
    const 单位ID列表 = 获取有序单位状态ID列表(配置.单位状态);
    for (let unitIndex = 0; unitIndex < 单位ID列表.length; unitIndex++) {
      const unitId = 单位ID列表[unitIndex];
      const 状态 = 配置.单位状态[unitId];
      if (状态 == null || 状态.单位 == null || 状态.单位 === 0) {
        待清理.push(unitId);
        continue;
      }

      const currentCount = 获取单位当前持有指定物品数量(状态.单位, 配置.物品类型ID);
      if (currentCount <= 0) {
        待清理.push(unitId);
        配置.丢弃回调?.(状态.单位, 状态.数量);
        continue;
      }

      状态.数量 = 1;
      if (配置.按单位独立计时 === true) {
        if (now < 状态.下次触发时间) continue;
        状态.下次触发时间 = now + 配置.间隔毫秒;
      }
      配置.周期回调(状态.单位, 1);
    }

    for (let j = 0; j < 待清理.length; j++) {
      delete 配置.单位状态[待清理[j]];
    }
  }
}

function 取持有型周期效果建议检查间隔(this: void, _nowMs: number): number {
  let 最短间隔 = 0;
  for (let i = 0; i < 持有型周期效果实例表.length; i++) {
    const 间隔 = 持有型周期效果实例表[i].间隔毫秒;
    if (间隔 > 0 && (最短间隔 === 0 || 间隔 < 最短间隔)) 最短间隔 = 间隔;
  }
  return 最短间隔;
}

function 确保持有型周期效果中心已注册(this: void): void {
  if (持有型周期效果驱动 == null) {
    持有型周期效果驱动 = 创建自适应共享周期驱动({
      名称: "持有型周期效果驱动",
      最大检查间隔毫秒: 100,
      取建议检查间隔毫秒: 取持有型周期效果建议检查间隔,
      onTick: on持有型周期效果Tick,
    });
  }
  持有型周期效果驱动.刷新();
}

function on持有型周期效果获取(this: void, unit: any, item: any, currentCount: number, previousCount: number): void {
  if (item == null || item === 0) return;
  const itemTypeId = GetItemTypeId(item);
  for (let i = 0; i < 持有型周期效果实例表.length; i++) {
    const 配置 = 持有型周期效果实例表[i];
    if (配置.物品类型ID === itemTypeId) {
      处理获得(配置, unit, item, currentCount, previousCount);
    }
  }
}

function on持有型周期效果丢弃(this: void, unit: any, item: any, currentCount: number, previousCount: number): void {
  if (item == null || item === 0) return;
  const itemTypeId = GetItemTypeId(item);
  for (let i = 0; i < 持有型周期效果实例表.length; i++) {
    const 配置 = 持有型周期效果实例表[i];
    if (配置.物品类型ID === itemTypeId) {
      处理丢弃(配置, unit, item, currentCount, previousCount);
    }
  }
}

function 补登记初始单位(this: void, 配置: 持有型周期效果实例): void {
  if (配置.初始单位列表 == null) return;
  const 单位列表 = 配置.初始单位列表();
  if (单位列表 == null) return;
  for (let i = 0; i < 单位列表.length; i++) {
    const unit = 单位列表[i];
    const unitId = 获取单位ID(unit);
    if (unitId === 0) continue;
    const currentCount = 获取单位当前持有指定物品数量(unit, 配置.物品类型ID);
    if (currentCount <= 0) continue;
    配置.单位状态[unitId] = {
      单位: unit,
      数量: 1,
      下次触发时间: getServerTime() + 配置.间隔毫秒,
    };
    配置.获取回调?.(unit, 1);
  }
}

function 创建持有型周期效果控制器(this: void, 配置: 持有型周期效果实例): 持有型周期效果控制器 {
  return {
    获取单位列表: function 获取持有型周期效果单位列表(this: void): any[] {
      const result: any[] = [];
      const ids = 获取有序单位状态ID列表(配置.单位状态);
      for (let i = 0; i < ids.length; i++) {
        const 状态 = 配置.单位状态[ids[i]];
        if (状态 != null && 状态.单位 != null && 状态.单位 !== 0) {
          result.push(状态.单位);
        }
      }
      return result;
    },
    获取单位数量: function 获取持有型周期效果单位数量(this: void): number {
      return 获取有序单位状态ID列表(配置.单位状态).length;
    },
    读取单位下次触发剩余毫秒: function 读取持有型周期效果单位剩余毫秒(this: void, unit: any): number {
      const unitId = 获取单位ID(unit);
      const 单位状态 = 配置.单位状态[unitId];
      if (unitId === 0 || 单位状态 == null) return 0;
      const 触发时间 = 配置.按单位独立计时 === true
        ? 单位状态.下次触发时间
        : 配置.下次触发时间;
      const 剩余毫秒 = 触发时间 - getServerTime();
      return 剩余毫秒 > 0 ? 剩余毫秒 : 0;
    },
  };
}

export function 注册持有型周期效果(this: void, 参数: 持有型周期效果参数): 持有型周期效果控制器 | null {
  if (参数 == null || 参数.物品类型ID === 0 || 参数.间隔毫秒 <= 0 || 参数.周期回调 == null) return null;

  const 配置 = {
    ...参数,
    下次触发时间: getServerTime() + 参数.间隔毫秒,
    单位状态: {},
  } as 持有型周期效果实例;
  const 控制器 = 创建持有型周期效果控制器(配置);
  配置.获取单位列表 = 控制器.获取单位列表;
  配置.获取单位数量 = 控制器.获取单位数量;
  配置.读取单位下次触发剩余毫秒 = 控制器.读取单位下次触发剩余毫秒;
  持有型周期效果实例表.push(配置);
  确保持有型周期效果中心已注册();
  补登记初始单位(配置);

  if (已注册监听物品类型[参数.物品类型ID] !== true) {
    已注册监听物品类型[参数.物品类型ID] = true;
    监听指定物品获取丢弃(参数.物品类型ID, on持有型周期效果获取, on持有型周期效果丢弃);
  }
  return 控制器;
}

export {};
