/** @noSelfInFile */

const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
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
  周期回调: (this: void, unit: any, currentCount: number) => void;
  获取回调?: (this: void, unit: any, currentCount: number) => void;
  丢弃回调?: (this: void, unit: any, currentCount: number) => void;
  初始单位列表?: (this: void) => any[];
}

export interface 持有型周期效果控制器 {
  获取单位列表(this: void): any[];
  获取单位数量(this: void): number;
}

type 持有型周期效果状态 = {
  单位: any;
  数量: number;
};

type 持有型周期效果实例 = 持有型周期效果参数 & 持有型周期效果控制器 & {
  下次触发时间: number;
  单位状态: Record<number, 持有型周期效果状态 | undefined>;
};

const 持有型周期效果实例表: 持有型周期效果实例[] = [];
const 已注册监听物品类型: Record<number, boolean | undefined> = {};
let 已注册持有型周期效果中心 = false;

function 获取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 数字升序排序(this: void, a: number, b: number): number {
  return a - b;
}

function 获取有序单位状态ID列表(this: void, 状态表: Record<number, 持有型周期效果状态 | undefined>): number[] {
  const ids: number[] = [];
  for (const unitKey in 状态表) {
    const unitId = Number(unitKey);
    if (!isNaN(unitId)) ids.push(unitId);
  }
  ids.sort(数字升序排序);
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

  配置.单位状态[unitId] = { 单位: unit, 数量: 1 };
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
  配置.单位状态[unitId] = { 单位: unit, 数量: 1 };
}

function on持有型周期效果Tick(this: void): void {
  const now = getServerTime();
  for (let i = 0; i < 持有型周期效果实例表.length; i++) {
    const 配置 = 持有型周期效果实例表[i];
    if (now < 配置.下次触发时间) continue;
    配置.下次触发时间 = now + 配置.间隔毫秒;

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
      配置.周期回调(状态.单位, 1);
    }

    for (let j = 0; j < 待清理.length; j++) {
      delete 配置.单位状态[待清理[j]];
    }
  }
}

function 确保持有型周期效果中心已注册(this: void): void {
  if (已注册持有型周期效果中心) return;
  已注册持有型周期效果中心 = true;
  addPeriodicCallback(100, on持有型周期效果Tick);
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
    配置.单位状态[unitId] = { 单位: unit, 数量: 1 };
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
  };
}

export function 注册持有型周期效果(this: void, 参数: 持有型周期效果参数): 持有型周期效果控制器 | null {
  if (参数 == null || 参数.物品类型ID === 0 || 参数.间隔毫秒 <= 0 || 参数.周期回调 == null) return null;
  确保持有型周期效果中心已注册();

  const 配置 = {
    ...参数,
    下次触发时间: getServerTime() + 参数.间隔毫秒,
    单位状态: {},
  } as 持有型周期效果实例;
  const 控制器 = 创建持有型周期效果控制器(配置);
  配置.获取单位列表 = 控制器.获取单位列表;
  配置.获取单位数量 = 控制器.获取单位数量;
  持有型周期效果实例表.push(配置);
  补登记初始单位(配置);

  if (已注册监听物品类型[参数.物品类型ID] !== true) {
    已注册监听物品类型[参数.物品类型ID] = true;
    监听指定物品获取丢弃(参数.物品类型ID, on持有型周期效果获取, on持有型周期效果丢弃);
  }
  return 控制器;
}

export {};
