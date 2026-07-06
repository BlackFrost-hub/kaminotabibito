/** @noSelfInFile */
/**
 * 形状区域 - 胶囊形 / 线段宽度区域
 *
 * 说明：
 * 1. 形状等价于“中间一段线 + 两端半圆”。
 * 2. 适合检测“沿路径扫过、但到结算时只看是否仍停留在路径宽度内”的目标。
 * 3. 先以线段中点粗筛，再做投影精判。
 */

const jass = require("jass.common") as any;
import type { 英雄技能距离修正上下文 } from "../../04．机制组件/11．技能属性修正";

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 按英雄技能距离修正上下文修正距离 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index") as {
  按英雄技能距离修正上下文修正距离: (this: void, 基础距离: number, 上下文: any, 默认用途?: string) => number;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const CreateGroup = jass.CreateGroup as () => any;
const GroupAddUnit = jass.GroupAddUnit as (whichGroup: any, whichUnit: any) => void;

export interface 胶囊区域参数 {
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  宽度: number;
  英雄技能距离修正?: 英雄技能距离修正上下文;
  单位筛选?: (this: void, 单位: any) => boolean;
  包含边界?: boolean;
}

function 计算平方根(值: number): number {
  return jass.SquareRoot(值) as number;
}

function 计算坐标距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return 计算平方根(dx * dx + dy * dy);
}

function 单位是否在线段宽度区域内部(
  单位: any,
  起点X: number,
  起点Y: number,
  终点X: number,
  终点Y: number,
  半宽: number,
  包含边界: boolean
): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (半宽 <= 0) return false;

  const 线段X = 终点X - 起点X;
  const 线段Y = 终点Y - 起点Y;
  const 线段长度平方 = 线段X * 线段X + 线段Y * 线段Y;
  if (线段长度平方 <= 0.0001) {
    const dx = GetUnitX(单位) - 起点X;
    const dy = GetUnitY(单位) - 起点Y;
    const 距离平方 = dx * dx + dy * dy;
    const 半宽平方 = 半宽 * 半宽;
    return 包含边界 ? 距离平方 <= 半宽平方 : 距离平方 < 半宽平方;
  }

  const 点X = GetUnitX(单位);
  const 点Y = GetUnitY(单位);
  const 到起点X = 点X - 起点X;
  const 到起点Y = 点Y - 起点Y;
  let 投影比例 = (到起点X * 线段X + 到起点Y * 线段Y) / 线段长度平方;
  if (投影比例 < 0) {
    投影比例 = 0;
  } else if (投影比例 > 1) {
    投影比例 = 1;
  }

  const 最近点X = 起点X + 线段X * 投影比例;
  const 最近点Y = 起点Y + 线段Y * 投影比例;
  const dx = 点X - 最近点X;
  const dy = 点Y - 最近点Y;
  const 距离平方 = dx * dx + dy * dy;
  const 半宽平方 = 半宽 * 半宽;

  if (包含边界) {
    return 距离平方 <= 半宽平方;
  }
  return 距离平方 < 半宽平方;
}

export function 单位是否在胶囊区域(
  单位: any,
  起点X: number,
  起点Y: number,
  终点X: number,
  终点Y: number,
  宽度: number,
  包含边界: boolean = true
): boolean {
  return 单位是否在线段宽度区域内部(
    单位,
    起点X,
    起点Y,
    终点X,
    终点Y,
    宽度 / 2,
    包含边界
  );
}

export function 获取胶囊区域单位(参数: 胶囊区域参数): any[] {
  if (参数.宽度 <= 0) {
    return [];
  }

  const 原线段长度 = 计算坐标距离(参数.起点X, 参数.起点Y, 参数.终点X, 参数.终点Y);
  const 线段长度 = 按英雄技能距离修正上下文修正距离(原线段长度, 参数.英雄技能距离修正, "胶囊长度");
  const 方向X = 原线段长度 > 0 ? (参数.终点X - 参数.起点X) / 原线段长度 : 0;
  const 方向Y = 原线段长度 > 0 ? (参数.终点Y - 参数.起点Y) / 原线段长度 : 0;
  const 终点X = 参数.起点X + 方向X * 线段长度;
  const 终点Y = 参数.起点Y + 方向Y * 线段长度;
  const 中心X = (参数.起点X + 终点X) / 2;
  const 中心Y = (参数.起点Y + 终点Y) / 2;
  const 粗筛半径 = 线段长度 / 2 + 参数.宽度 / 2;
  const 候选单位 = getUnitsInRange(中心X, 中心Y, 粗筛半径);
  const 结果: any[] = [];

  for (const 单位 of 候选单位) {
    if (!单位是否在胶囊区域(
      单位,
      参数.起点X,
      参数.起点Y,
      终点X,
      终点Y,
      参数.宽度,
      参数.包含边界 ?? true
    )) {
      continue;
    }

    if (参数.单位筛选 != null && !参数.单位筛选(单位)) {
      continue;
    }

    结果.push(单位);
  }

  return 结果;
}

export function 创建胶囊单位组(参数: 胶囊区域参数): any {
  const 单位组 = CreateGroup();
  const 单位列表 = 获取胶囊区域单位(参数);

  for (const 单位 of 单位列表) {
    GroupAddUnit(单位组, 单位);
  }

  return 单位组;
}

export {};
