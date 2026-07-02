/** @noSelfInFile */

import { 创建可配置层数状态, 可配置层数状态控制器, 可配置层数状态配置 } from "./01．可配置层数状态";

const jass = require("jass.common") as any;

const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export interface 战斗节奏层数清理篮子 {
  登记清理(名称: string, 清理: (this: void) => void): void;
  登记周期回调?(名称: string, 回调ID: number): void;
}

export interface 战斗节奏层数参数 extends 可配置层数状态配置 {
  单位: any;
  名称?: string;
  叠层间隔毫秒: number;
  检查间隔毫秒?: number;
  脱战清空?: boolean;
  清理篮子?: 战斗节奏层数清理篮子;
  判断战斗状态: (this: void, 单位: any) => boolean;
  on获得层数?: (this: void, 当前层数: number) => void;
}

export interface 战斗节奏层数控制器 {
  readonly 名称: string;
  读取当前层数(): number;
  刷新(): number;
  停止(): void;
}

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

class 战斗节奏层数控制器实现 implements 战斗节奏层数控制器 {
  readonly 名称: string;
  private 参数: 战斗节奏层数参数;
  private 层数控制器: 可配置层数状态控制器;
  private 周期回调ID = 0;
  private 已停止 = false;
  private 下次叠层毫秒 = 0;

  constructor(名称: string, 参数: 战斗节奏层数参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.层数控制器 = 创建可配置层数状态(参数);
  }

  设置周期回调ID(id: number): void {
    this.周期回调ID = id;
  }

  读取当前层数(): number {
    return this.层数控制器.取层数(this.参数.单位);
  }

  刷新(): number {
    if (this.已停止) return this.读取当前层数();
    const 单位 = this.参数.单位;
    if (!单位有效(单位)) {
      this.层数控制器.清空(单位, "单位失效");
      return 0;
    }

    const 在战斗 = this.参数.判断战斗状态(单位);
    if (!在战斗) {
      this.下次叠层毫秒 = 0;
      if (this.参数.脱战清空 !== false) this.层数控制器.清空(单位, "脱离战斗");
      return this.读取当前层数();
    }

    if (this.下次叠层毫秒 <= 0) {
      this.下次叠层毫秒 = this.参数.叠层间隔毫秒;
      return this.读取当前层数();
    }

    this.下次叠层毫秒 -= this.参数.检查间隔毫秒 ?? 200;
    if (this.下次叠层毫秒 > 0) return this.读取当前层数();

    const 当前层数 = this.层数控制器.增加(单位, 1, "战斗节奏叠层");
    this.下次叠层毫秒 = this.参数.叠层间隔毫秒;
    if (this.参数.on获得层数 != null) this.参数.on获得层数(当前层数);
    return 当前层数;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    if (this.周期回调ID !== 0) {
      removePeriodicCallback(this.周期回调ID);
      this.周期回调ID = 0;
    }
    this.层数控制器.销毁();
  }
}

export function 创建战斗节奏层数(this: void, 参数: 战斗节奏层数参数): 战斗节奏层数控制器 {
  const 名称 = 参数.名称 ?? 参数.状态ID ?? "战斗节奏层数";
  const 控制器 = new 战斗节奏层数控制器实现(名称, 参数);
  控制器.刷新();
  const 间隔 = 参数.检查间隔毫秒 ?? 200;
  if (间隔 > 0) {
    const id = addPeriodicCallback(间隔, function 战斗节奏层数Tick(this: void): void {
      控制器.刷新();
    });
    控制器.设置周期回调ID(id);
    if (参数.清理篮子 != null) {
      if (参数.清理篮子.登记周期回调 != null) 参数.清理篮子.登记周期回调(`${名称}-周期刷新`, id);
      else 参数.清理篮子.登记清理(`${名称}-停止`, function 停止战斗节奏层数(this: void): void {
        控制器.停止();
      });
    }
  }
  return 控制器;
}
