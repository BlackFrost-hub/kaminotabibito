/** @noSelfInFile */
/**
 * 弹道跳链
 *
 * 与纯跳链不同：每一跳都会创建一个真实飞行弹幕，命中后再寻找下一跳目标。
 */

import { 创建原生弹幕, 销毁原生弹幕, 获取原生弹幕 } from "../01．TS原生弹幕/03．对外接口";

const jass = require("jass.common") as any;
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { isUnitEnemy, isSameUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isSameUnit: (this: void, unitA: any, unitB: any) => boolean;
};

const GetHandleId = jass.GetHandleId as (this: void, h: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, u: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, u: any) => number;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 弹道跳链参数 {
  施法者: any;
  初始目标: any;
  跳跃次数: number;
  搜索半径: number;
  弹幕速度: number;
  每跳延迟?: number;
  /** 默认复用同一个弹幕；需要旧表现时传“重建弹幕”。 */
  弹跳模式?: "复用弹幕" | "重建弹幕";
  命中半径?: number;
  伤害值?: number;
  每跳伤害系数?: number;
  每单位只命中一次?: boolean;
  弹幕单位类型?: number;
  模型?: string;
  附着特效模型?: string;
  on结束?: (this: void) => void;
}

interface 弹道跳链状态 {
  参数: 弹道跳链参数;
  已跳次数: number;
  当前伤害: number;
  当前目标: any;
  已命中单位: Record<number, true | undefined>;
  已结束: boolean;
}

interface 弹道跳链延迟发射上下文 {
  到期时间毫秒: number;
  状态: 弹道跳链状态;
  起点单位: any;
  目标单位: any;
  弹幕ID?: number;
}

const 延迟发射任务列表: 弹道跳链延迟发射上下文[] = [];
let 延迟发射扫描回调ID = 0;

function 取句柄ID(this: void, h: any): number {
  return h != null && h !== 0 ? (GetHandleId(h) || 0) : 0;
}

function 计算距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

function 目标已命中(this: void, 状态: 弹道跳链状态, 单位: any): boolean {
  if (状态.参数.每单位只命中一次 !== true) return false;
  return 状态.已命中单位[取句柄ID(单位)] === true;
}

function 标记目标命中(this: void, 状态: 弹道跳链状态, 单位: any): void {
  状态.已命中单位[取句柄ID(单位)] = true;
}

function 结束弹道跳链(this: void, 状态: 弹道跳链状态): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  if (状态.参数.on结束 != null) 状态.参数.on结束();
}

function 选择下一跳目标(this: void, 状态: 弹道跳链状态, 当前目标: any): any {
  const x = GetUnitX(当前目标);
  const y = GetUnitY(当前目标);
  const 候选 = getUnitsInRange(x, y, 状态.参数.搜索半径);
  let 最佳目标: any = null;
  let 最佳距离 = 0;

  for (let i = 0; i < 候选.length; i++) {
    const 单位 = 候选[i];
    if (isSameUnit(单位, 当前目标)) continue;
    if (!isUnitEnemy(单位, 状态.参数.施法者)) continue;
    if (目标已命中(状态, 单位)) continue;

    const d = 计算距离(x, y, GetUnitX(单位), GetUnitY(单位));
    if (最佳目标 == null || d < 最佳距离) {
      最佳目标 = 单位;
      最佳距离 = d;
    }
  }

  return 最佳目标;
}

function 当前筛选目标(this: void, 状态: 弹道跳链状态, 单位: any): boolean {
  return isSameUnit(单位, 状态.当前目标);
}

function 继续复用弹幕到目标(this: void, 状态: 弹道跳链状态, 弹幕ID: number, 目标单位: any): void {
  if (状态.已结束) return;
  const 实例 = 获取原生弹幕(弹幕ID);
  if (实例 == null || 实例.已结束) return;

  状态.当前目标 = 目标单位;
  实例.参数.指定目标 = 目标单位;
  实例.参数.目标筛选 = function 弹道跳链复用目标筛选(this: void, 单位: any): boolean {
    return 当前筛选目标(状态, 单位);
  };
  实例.当前速度 = 状态.参数.弹幕速度;
}

function 添加弹道跳链延迟发射任务(this: void, 上下文: 弹道跳链延迟发射上下文): void {
  延迟发射任务列表.push(上下文);
  if (延迟发射扫描回调ID === 0) {
    延迟发射扫描回调ID = addPeriodicCallback(10, on弹道跳链延迟发射扫描);
  }
}

function 安排发射到目标(this: void, 状态: 弹道跳链状态, 起点单位: any, 目标单位: any): void {
  if (状态.已结束) return;
  const 延迟 = 状态.参数.每跳延迟 ?? 0;
  if (延迟 <= 0) {
    发射到目标(状态, 起点单位, 目标单位);
    return;
  }

  添加弹道跳链延迟发射任务({
    到期时间毫秒: getServerTime() + 延迟 * 1000,
    状态,
    起点单位,
    目标单位,
  });
}

function 安排复用弹幕到目标(this: void, 状态: 弹道跳链状态, 弹幕ID: number, 目标单位: any): void {
  if (状态.已结束) return;
  const 延迟 = 状态.参数.每跳延迟 ?? 0;
  if (延迟 <= 0) {
    继续复用弹幕到目标(状态, 弹幕ID, 目标单位);
    return;
  }

  const 实例 = 获取原生弹幕(弹幕ID);
  if (实例 != null && !实例.已结束) {
    实例.当前速度 = 0;
    状态.当前目标 = null;
  }

  添加弹道跳链延迟发射任务({
    到期时间毫秒: getServerTime() + 延迟 * 1000,
    状态,
    起点单位: null,
    目标单位,
    弹幕ID,
  });
}

function 执行弹道跳链延迟发射任务(this: void, 上下文: 弹道跳链延迟发射上下文): void {
  if (上下文.状态.已结束) return;
  if (上下文.弹幕ID != null) {
    继续复用弹幕到目标(上下文.状态, 上下文.弹幕ID, 上下文.目标单位);
    return;
  }
  发射到目标(上下文.状态, 上下文.起点单位, 上下文.目标单位);
}

function on弹道跳链延迟发射扫描(this: void): void {
  const 当前时间毫秒 = getServerTime();
  const 到期任务: 弹道跳链延迟发射上下文[] = [];
  for (let i = 延迟发射任务列表.length - 1; i >= 0; i--) {
    const 上下文 = 延迟发射任务列表[i];
    if (当前时间毫秒 < 上下文.到期时间毫秒) {
      continue;
    }
    延迟发射任务列表.splice(i, 1);
    到期任务.unshift(上下文);
  }
  for (let i = 0; i < 到期任务.length; i++) {
    执行弹道跳链延迟发射任务(到期任务[i]);
  }
  if (延迟发射任务列表.length === 0 && 延迟发射扫描回调ID !== 0) {
    removePeriodicCallback(延迟发射扫描回调ID);
    延迟发射扫描回调ID = 0;
  }
}

function 发射到目标(this: void, 状态: 弹道跳链状态, 起点单位: any, 目标单位: any): void {
  if (状态.已结束) return;
  状态.当前目标 = 目标单位;
  const 复用弹幕 = 状态.参数.弹跳模式 !== "重建弹幕";
  创建原生弹幕({
    所有者: 状态.参数.施法者,
    X: GetUnitX(起点单位),
    Y: GetUnitY(起点单位),
    弹幕单位类型: 状态.参数.弹幕单位类型,
    模型: 状态.参数.模型,
    附着特效模型: 状态.参数.附着特效模型,
    速度: 状态.参数.弹幕速度,
    轨迹类型: "追踪",
    指定目标: 目标单位,
    命中半径: 状态.参数.命中半径 ?? 64,
    伤害值: 状态.当前伤害,
    伤害形态: 状态.参数.跳跃次数 > 1 ? "AOE" : "单体",
    碰撞消失: !复用弹幕,
    最大距离: 状态.参数.搜索半径 * 2,
    生命周期: 3,
    目标筛选: function 弹道跳链目标筛选(this: void, 单位: any): boolean {
      return 当前筛选目标(状态, 单位);
    },
    on命中: function 弹道跳链命中(this: void, 命中单位: any, 弹幕ID: number): void {
      标记目标命中(状态, 命中单位);
      状态.已跳次数 += 1;
      if (状态.已跳次数 >= 状态.参数.跳跃次数) {
        结束弹道跳链(状态);
        if (复用弹幕) 销毁原生弹幕(弹幕ID, "完成");
        return;
      }

      const 系数 = 状态.参数.每跳伤害系数 ?? 1;
      状态.当前伤害 = 状态.当前伤害 * 系数;
      const 下一目标 = 选择下一跳目标(状态, 命中单位);
      if (下一目标 == null || 下一目标 === 0) {
        结束弹道跳链(状态);
        if (复用弹幕) 销毁原生弹幕(弹幕ID, "完成");
        return;
      }
      if (复用弹幕) {
        安排复用弹幕到目标(状态, 弹幕ID, 下一目标);
      } else {
        安排发射到目标(状态, 命中单位, 下一目标);
      }
    },
    on结束: function 弹道跳链弹幕结束(this: void): void {
      return;
    },
  });
}

export function 开始弹道跳链(this: void, 参数: 弹道跳链参数): void {
  if (参数.施法者 == null || 参数.施法者 === 0) return;
  if (参数.初始目标 == null || 参数.初始目标 === 0) return;
  if (参数.跳跃次数 <= 0) return;

  const 状态: 弹道跳链状态 = {
    参数,
    已跳次数: 0,
    当前伤害: 参数.伤害值 ?? 0,
    当前目标: 参数.初始目标,
    已命中单位: {},
    已结束: false,
  };
  发射到目标(状态, 参数.施法者, 参数.初始目标);
}
