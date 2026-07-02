/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export interface 点名分摊清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
  登记延迟回调?(名称: string, 回调ID: number): void;
}

export interface 点名分摊结算结果 {
  点名目标: any;
  分摊单位列表: any[];
  分摊人数: number;
  中心X: number;
  中心Y: number;
}

export interface 点名分摊结算参数 {
  名称?: string;
  点名目标: any;
  参与单位列表: any[];
  分摊半径: number;
  延迟秒?: number;
  延迟毫秒?: number;
  包含点名目标?: boolean;
  清理篮子?: 点名分摊清理篮子;
  过滤单位?: (this: void, 单位: any) => boolean;
  on锁定?: (this: void, 点名目标: any, 中心X: number, 中心Y: number) => void;
  on结算: (this: void, 结果: 点名分摊结算结果) => void;
}

export interface 点名分摊结算控制器 {
  readonly 名称: string;
  readonly 延迟回调ID: number;
  取消: (this: void) => void;
}

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 两点距离平方(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return dx * dx + dy * dy;
}

function 取延迟毫秒(this: void, 参数: 点名分摊结算参数): number {
  if (参数.延迟毫秒 != null) {
    const 延迟 = math.floor(参数.延迟毫秒);
    return 延迟 > 0 ? 延迟 : 0;
  }
  if (参数.延迟秒 != null) {
    const 延迟 = math.floor(参数.延迟秒 * 1000);
    return 延迟 > 0 ? 延迟 : 0;
  }
  return 0;
}

class 点名分摊结算控制器实现 implements 点名分摊结算控制器 {
  readonly 名称: string;
  readonly 延迟回调ID: number;
  private 已取消 = false;
  readonly 取消: (this: void) => void;

  constructor(名称: string, 延迟回调ID: number) {
    this.名称 = 名称;
    this.延迟回调ID = 延迟回调ID;
    const self = this;
    this.取消 = function 取消点名分摊结算控制器(this: void): void {
      if (self.已取消) return;
      self.已取消 = true;
      if (self.延迟回调ID !== 0) removeDelayedCallback(self.延迟回调ID);
    };
  }
}

export function 创建点名分摊结算(this: void, 参数: 点名分摊结算参数): 点名分摊结算控制器 {
  const 名称 = 参数.名称 ?? "点名分摊结算";
  const 目标 = 参数.点名目标;
  const 初始X = 单位有效(目标) ? GetUnitX(目标) : 0;
  const 初始Y = 单位有效(目标) ? GetUnitY(目标) : 0;
  if (参数.on锁定 != null) 参数.on锁定(目标, 初始X, 初始Y);

  let 控制器: 点名分摊结算控制器实现;
  const 延迟回调ID = addDelayedCallback(取延迟毫秒(参数), function 点名分摊延迟结算(this: void): void {
    if (控制器 == null) return;
    if ((控制器 as any).已取消 === true) return;
    if (!单位有效(目标)) {
      参数.on结算({
        点名目标: 目标,
        分摊单位列表: [],
        分摊人数: 0,
        中心X: 初始X,
        中心Y: 初始Y,
      });
      return;
    }

    const 中心X = GetUnitX(目标);
    const 中心Y = GetUnitY(目标);
    const 半径平方 = 参数.分摊半径 * 参数.分摊半径;
    const 分摊单位列表: any[] = [];
    for (let i = 0; i < 参数.参与单位列表.length; i++) {
      const 单位 = 参数.参与单位列表[i];
      if (!单位有效(单位)) continue;
      if (单位 === 目标 && 参数.包含点名目标 === false) continue;
      if (参数.过滤单位 != null && !参数.过滤单位(单位)) continue;
      if (两点距离平方(GetUnitX(单位), GetUnitY(单位), 中心X, 中心Y) <= 半径平方) {
        分摊单位列表.push(单位);
      }
    }
    参数.on结算({
      点名目标: 目标,
      分摊单位列表,
      分摊人数: 分摊单位列表.length,
      中心X,
      中心Y,
    });
  });

  控制器 = new 点名分摊结算控制器实现(名称, 延迟回调ID);
  if (参数.清理篮子 != null) {
    if (参数.清理篮子.登记延迟回调 != null) {
      参数.清理篮子.登记延迟回调(`${名称}-延迟结算`, 延迟回调ID);
    } else {
      参数.清理篮子.登记清理(`${名称}-取消`, function 取消点名分摊结算(this: void): void {
        控制器.取消();
      });
    }
  }
  return 控制器;
}
