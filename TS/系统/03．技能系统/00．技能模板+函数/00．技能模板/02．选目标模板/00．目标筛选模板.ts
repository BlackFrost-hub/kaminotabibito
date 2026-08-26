/** @noSelfInFile */
/**
 * 技能模板 - 目标筛选模板
 *
 * 说明：
 * 1. 这是技能层的“选谁”模板，不负责伤害、位移、特效。
 * 2. 底层仍复用现有范围查询与敌友判断，避免每个技能自己重写筛选流程。
 * 3. 适合单目标、最近目标、最远目标、血量最低/最高、主目标+副目标这类常用技能选择。
 */
import type { 英雄技能距离修正上下文 } from "../../04．机制组件/11．技能属性修正";

const jass = require("jass.common") as any;
const { 按英雄技能距离修正上下文修正距离 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index") as {
  按英雄技能距离修正上下文修正距离: (this: void, 基础距离: number, 上下文: any, 默认用途?: string) => number;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isValidUnit, isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { 获取扇形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域") as {
  获取扇形区域单位: (this: void, 参数: {
    X: number;
    Y: number;
    半径: number;
    方向角: number;
    扇形角度: number;
    英雄技能距离修正?: any;
    单位筛选?: (this: void, 单位: any) => boolean;
    包含边界?: boolean;
  }) => any[];
};

const { 获取矩形区域单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域") as {
  获取矩形区域单位: (this: void, 参数: {
    X: number;
    Y: number;
    长度: number;
    宽度: number;
    方向角: number;
    英雄技能距离修正?: any;
    单位筛选?: (this: void, 单位: any) => boolean;
    包含边界?: boolean;
  }) => any[];
};

export type 技能筛选影响目标 = "敌方" | "友方" | "全部";
export type 技能筛选条件 = (单位: any) => boolean;

export interface 范围目标筛选参数 {
  X: number;
  Y: number;
  半径: number;
  英雄技能距离修正?: 英雄技能距离修正上下文;
  来源单位?: any;
  影响目标?: 技能筛选影响目标;
  排除单位?: any;
  自定义条件?: 技能筛选条件;
}

export interface 主目标副目标筛选参数 extends 范围目标筛选参数 {
  主目标: any;
  副目标数量: number;
}

export interface 主目标副目标筛选结果 {
  主目标: any;
  副目标列表: any[];
}

export interface 扇形目标筛选参数 extends 范围目标筛选参数 {
  方向角: number;
  扇形角度: number;
  包含边界?: boolean;
}

export interface 矩形目标筛选参数 extends 范围目标筛选参数 {
  长度: number;
  宽度: number;
  方向角: number;
  包含边界?: boolean;
}

function 计算平方距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return dx * dx + dy * dy;
}

function 单位满足技能筛选条件(单位: any, 参数: 范围目标筛选参数): boolean {
  if (!isValidUnit(单位)) return false;
  if (参数.排除单位 != null && 参数.排除单位 !== 0 && 单位 === 参数.排除单位) return false;

  const 影响目标 = 参数.影响目标 ?? "全部";
  if (影响目标 === "敌方") {
    if (参数.来源单位 == null || 参数.来源单位 === 0) return false;
    if (!isUnitEnemy(单位, 参数.来源单位)) return false;
  } else if (影响目标 === "友方") {
    if (参数.来源单位 == null || 参数.来源单位 === 0) return false;
    if (!isUnitAlly(单位, 参数.来源单位)) return false;
  }

  const 自定义条件 = 参数.自定义条件;
  if (自定义条件 != null && !自定义条件(单位)) return false;
  return true;
}

function 获取筛选后单位列表(参数: 范围目标筛选参数): any[] {
  if (参数.半径 <= 0) return [];
  const 半径 = 按英雄技能距离修正上下文修正距离(参数.半径, 参数.英雄技能距离修正, "效果半径");
  const 单位列表 = getUnitsInRange(参数.X, 参数.Y, 半径);
  const 结果: any[] = [];
  for (const 单位 of 单位列表) {
    if (单位满足技能筛选条件(单位, 参数)) {
      结果.push(单位);
    }
  }
  return 结果;
}

export function 获取范围内单位组(参数: 范围目标筛选参数): any[] {
  return 获取筛选后单位列表(参数);
}

export function 选择范围内最近目标(参数: 范围目标筛选参数): any {
  const 单位列表 = 获取筛选后单位列表(参数);
  let 最佳目标: any = null;
  let 最佳距离平方 = 0;

  for (const 单位 of 单位列表) {
    const 距离平方 = 计算平方距离(参数.X, 参数.Y, GetUnitX(单位), GetUnitY(单位));
    if (最佳目标 == null || 距离平方 < 最佳距离平方) {
      最佳目标 = 单位;
      最佳距离平方 = 距离平方;
    }
  }
  return 最佳目标;
}

export function 选择范围内最远目标(参数: 范围目标筛选参数): any {
  const 单位列表 = 获取筛选后单位列表(参数);
  let 最佳目标: any = null;
  let 最佳距离平方 = 0;

  for (const 单位 of 单位列表) {
    const 距离平方 = 计算平方距离(参数.X, 参数.Y, GetUnitX(单位), GetUnitY(单位));
    if (最佳目标 == null || 距离平方 > 最佳距离平方) {
      最佳目标 = 单位;
      最佳距离平方 = 距离平方;
    }
  }
  return 最佳目标;
}

export function 选择范围内血量最低目标(参数: 范围目标筛选参数): any {
  const 单位列表 = 获取筛选后单位列表(参数);
  let 最佳目标: any = null;
  let 最低血量 = 0;

  for (const 单位 of 单位列表) {
    const 当前血量 = GetUnitState(单位, UNIT_STATE_LIFE);
    if (最佳目标 == null || 当前血量 < 最低血量) {
      最佳目标 = 单位;
      最低血量 = 当前血量;
    }
  }
  return 最佳目标;
}

export function 选择范围内血量最高目标(参数: 范围目标筛选参数): any {
  const 单位列表 = 获取筛选后单位列表(参数);
  let 最佳目标: any = null;
  let 最高血量 = 0;

  for (const 单位 of 单位列表) {
    const 当前血量 = GetUnitState(单位, UNIT_STATE_LIFE);
    if (最佳目标 == null || 当前血量 > 最高血量) {
      最佳目标 = 单位;
      最高血量 = 当前血量;
    }
  }
  return 最佳目标;
}

export function 选择主目标和副目标(参数: 主目标副目标筛选参数): 主目标副目标筛选结果 {
  const 结果: 主目标副目标筛选结果 = {
    主目标: 参数.主目标,
    副目标列表: [],
  };
  if (参数.主目标 == null || 参数.主目标 === 0) return 结果;
  if (参数.副目标数量 <= 0) return 结果;

  const 副目标筛选参数: 范围目标筛选参数 = {
    X: 参数.X,
    Y: 参数.Y,
    半径: 参数.半径,
    英雄技能距离修正: 参数.英雄技能距离修正,
    来源单位: 参数.来源单位,
    影响目标: 参数.影响目标,
    排除单位: 参数.主目标,
    自定义条件: 参数.自定义条件,
  };
  const 候选单位 = 获取筛选后单位列表(副目标筛选参数);
  候选单位.sort((a, b) => {
    return 计算平方距离(参数.X, 参数.Y, GetUnitX(a), GetUnitY(a))
      - 计算平方距离(参数.X, 参数.Y, GetUnitX(b), GetUnitY(b));
  });

  let 已添加数量 = 0;
  for (const 单位 of 候选单位) {
    结果.副目标列表.push(单位);
    已添加数量 += 1;
    if (已添加数量 >= 参数.副目标数量) {
      break;
    }
  }
  return 结果;
}

export function 选择扇形区域内最近目标(参数: 扇形目标筛选参数): any {
  const 单位列表 = 获取扇形区域单位({
    X: 参数.X,
    Y: 参数.Y,
    半径: 参数.半径,
    方向角: 参数.方向角,
    扇形角度: 参数.扇形角度,
    英雄技能距离修正: 参数.英雄技能距离修正,
    包含边界: 参数.包含边界,
    单位筛选: function (单位: any): boolean {
      return 单位满足技能筛选条件(单位, 参数);
    },
  });
  let 最佳目标: any = null;
  let 最佳距离平方 = 0;

  for (const 单位 of 单位列表) {
    const 距离平方 = 计算平方距离(参数.X, 参数.Y, GetUnitX(单位), GetUnitY(单位));
    if (最佳目标 == null || 距离平方 < 最佳距离平方) {
      最佳目标 = 单位;
      最佳距离平方 = 距离平方;
    }
  }
  return 最佳目标;
}

export function 选择矩形区域内最近目标(参数: 矩形目标筛选参数): any {
  const 单位列表 = 获取矩形区域内单位组(参数);
  let 最佳目标: any = null;
  let 最佳距离平方 = 0;

  for (const 单位 of 单位列表) {
    const 距离平方 = 计算平方距离(参数.X, 参数.Y, GetUnitX(单位), GetUnitY(单位));
    if (最佳目标 == null || 距离平方 < 最佳距离平方) {
      最佳目标 = 单位;
      最佳距离平方 = 距离平方;
    }
  }
  return 最佳目标;
}

export function 获取矩形区域内单位组(参数: 矩形目标筛选参数): any[] {
  return 获取矩形区域单位({
    X: 参数.X,
    Y: 参数.Y,
    长度: 参数.长度,
    宽度: 参数.宽度,
    方向角: 参数.方向角,
    英雄技能距离修正: 参数.英雄技能距离修正,
    包含边界: 参数.包含边界,
    单位筛选: function (单位: any): boolean {
      return 单位满足技能筛选条件(单位, 参数);
    },
  });
}

export const 技能筛选范围单位 = 获取范围内单位组;
export const 技能筛选最近目标 = 选择范围内最近目标;
export const 技能筛选最远目标 = 选择范围内最远目标;
export const 技能筛选最低血量目标 = 选择范围内血量最低目标;
export const 技能筛选最高血量目标 = 选择范围内血量最高目标;
export const 技能筛选主目标和副目标 = 选择主目标和副目标;
export const 技能筛选扇形区域最近目标 = 选择扇形区域内最近目标;
export const 技能筛选矩形区域最近目标 = 选择矩形区域内最近目标;
export const 技能筛选矩形区域单位组 = 获取矩形区域内单位组;
