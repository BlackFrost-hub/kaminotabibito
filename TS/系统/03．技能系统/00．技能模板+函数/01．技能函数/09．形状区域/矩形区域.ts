/** @noSelfInFile */
/**
 * 形状区域 - 矩形 / 条形区域
 *
 * 说明：
 * 1. 支持“中心点 + 朝向 + 长宽”的普通矩形判定。
 * 2. 支持“起点 -> 终点 + 宽度”的条形区域判定，适合路径落地统一结算。
 * 3. 先做圆形粗筛，再做局部坐标精判。
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

export interface 矩形区域参数 {
  X: number;
  Y: number;
  长度: number;
  宽度: number;
  方向角: number;
  英雄技能距离修正?: 英雄技能距离修正上下文;
  单位筛选?: (this: void, 单位: any) => boolean;
  包含边界?: boolean;
}

export interface 条形区域参数 {
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  宽度: number;
  英雄技能距离修正?: 英雄技能距离修正上下文;
  单位筛选?: (this: void, 单位: any) => boolean;
  包含边界?: boolean;
}

function 绝对值(值: number): number {
  return 值 < 0 ? -值 : 值;
}

function 计算平方根(值: number): number {
  return jass.SquareRoot(值) as number;
}

function 计算坐标距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return 计算平方根(dx * dx + dy * dy);
}

function 计算矩形粗筛半径(长度: number, 宽度: number): number {
  const 半长 = 长度 / 2;
  const 半宽 = 宽度 / 2;
  return 计算平方根(半长 * 半长 + 半宽 * 半宽);
}

function 计算方向单位向量(方向角: number): { X: number; Y: number } {
  return {
    X: jass.Cos(方向角 * jass.bj_DEGTORAD) as number,
    Y: jass.Sin(方向角 * jass.bj_DEGTORAD) as number,
  };
}

function 单位是否在已归一矩形区域(
  单位: any,
  中心X: number,
  中心Y: number,
  半长: number,
  半宽: number,
  方向X: number,
  方向Y: number,
  包含边界: boolean
): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (半长 <= 0 || 半宽 <= 0) return false;

  const 单位X = GetUnitX(单位);
  const 单位Y = GetUnitY(单位);
  const dx = 单位X - 中心X;
  const dy = 单位Y - 中心Y;

  const 前向投影 = dx * 方向X + dy * 方向Y;
  const 侧向投影 = dx * (-方向Y) + dy * 方向X;
  const 绝对前向 = 绝对值(前向投影);
  const 绝对侧向 = 绝对值(侧向投影);

  if (包含边界) {
    return 绝对前向 <= 半长 && 绝对侧向 <= 半宽;
  }
  return 绝对前向 < 半长 && 绝对侧向 < 半宽;
}

export function 单位是否在矩形区域(
  单位: any,
  X: number,
  Y: number,
  长度: number,
  宽度: number,
  方向角: number,
  包含边界: boolean = true
): boolean {
  if (长度 <= 0 || 宽度 <= 0) return false;

  const 半长 = 长度 / 2;
  const 半宽 = 宽度 / 2;
  const 方向 = 计算方向单位向量(方向角);

  return 单位是否在已归一矩形区域(
    单位,
    X,
    Y,
    半长,
    半宽,
    方向.X,
    方向.Y,
    包含边界
  );
}

export function 获取矩形区域单位(参数: 矩形区域参数): any[] {
  if (参数.长度 <= 0 || 参数.宽度 <= 0) {
    return [];
  }

  const 长度 = 按英雄技能距离修正上下文修正距离(参数.长度, 参数.英雄技能距离修正, "矩形长度");
  const 粗筛半径 = 计算矩形粗筛半径(长度, 参数.宽度);
  const 候选单位 = getUnitsInRange(参数.X, 参数.Y, 粗筛半径);
  const 结果: any[] = [];

  for (const 单位 of 候选单位) {
    if (!单位是否在矩形区域(
      单位,
      参数.X,
      参数.Y,
      长度,
      参数.宽度,
      参数.方向角,
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

export function 创建矩形单位组(参数: 矩形区域参数): any {
  const 单位组 = CreateGroup();
  const 单位列表 = 获取矩形区域单位(参数);

  for (const 单位 of 单位列表) {
    GroupAddUnit(单位组, 单位);
  }

  return 单位组;
}

export function 单位是否在条形区域(
  单位: any,
  起点X: number,
  起点Y: number,
  终点X: number,
  终点Y: number,
  宽度: number,
  包含边界: boolean = true
): boolean {
  if (宽度 <= 0) return false;

  const 长度 = 计算坐标距离(起点X, 起点Y, 终点X, 终点Y);
  if (长度 <= 0) {
    return false;
  }

  const 中心X = (起点X + 终点X) / 2;
  const 中心Y = (起点Y + 终点Y) / 2;
  const 方向X = (终点X - 起点X) / 长度;
  const 方向Y = (终点Y - 起点Y) / 长度;

  return 单位是否在已归一矩形区域(
    单位,
    中心X,
    中心Y,
    长度 / 2,
    宽度 / 2,
    方向X,
    方向Y,
    包含边界
  );
}

export function 获取条形区域单位(参数: 条形区域参数): any[] {
  if (参数.宽度 <= 0) {
    return [];
  }

  const 原长度 = 计算坐标距离(参数.起点X, 参数.起点Y, 参数.终点X, 参数.终点Y);
  const 长度 = 按英雄技能距离修正上下文修正距离(原长度, 参数.英雄技能距离修正, "直线长度");
  if (长度 <= 0) {
    return [];
  }

  const 方向X = 原长度 > 0 ? (参数.终点X - 参数.起点X) / 原长度 : 0;
  const 方向Y = 原长度 > 0 ? (参数.终点Y - 参数.起点Y) / 原长度 : 0;
  const 终点X = 参数.起点X + 方向X * 长度;
  const 终点Y = 参数.起点Y + 方向Y * 长度;
  const 中心X = (参数.起点X + 终点X) / 2;
  const 中心Y = (参数.起点Y + 终点Y) / 2;
  const 粗筛半径 = 计算矩形粗筛半径(长度, 参数.宽度);
  const 候选单位 = getUnitsInRange(中心X, 中心Y, 粗筛半径);
  const 结果: any[] = [];

  for (const 单位 of 候选单位) {
    if (!单位是否在条形区域(
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

export function 创建条形单位组(参数: 条形区域参数): any {
  const 单位组 = CreateGroup();
  const 单位列表 = 获取条形区域单位(参数);

  for (const 单位 of 单位列表) {
    GroupAddUnit(单位组, 单位);
  }

  return 单位组;
}

export {};
