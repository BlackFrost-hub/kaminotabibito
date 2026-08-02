/** @noSelfInFile */

import type { 技能阶段链结束原因 } from "../01．多阶段技能编排/06．技能阶段链执行器";
import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

export type 主动技能流程结束原因 = 技能阶段链结束原因 | "目标失效" | "清理";

export interface 主动技能流程生命周期参数 {
  名称: string;
  施法者: any;
  目标?: any;
  清理?: 机制清理篮子;
  施法者死亡时取消?: boolean;
  目标死亡时取消?: boolean;
  变量?: any;
  on停止?: (this: void, 原因: 主动技能流程结束原因, 变量?: any) => void;
  on结束?: (this: void, 原因: 主动技能流程结束原因, 变量?: any) => void;
}

export interface 主动技能流程控制器 {
  停止(this: void, 原因?: 主动技能流程结束原因): boolean;
  结束(this: void, 原因: 主动技能流程结束原因): boolean;
  完成(this: void): boolean;
  是否结束(this: void): boolean;
  读取结束原因(this: void): 主动技能流程结束原因 | undefined;
}

const 活跃流程列表: 主动技能流程生命周期实现[] = [];
let 已注册死亡监听 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 移除活跃流程(this: void, 实例: 主动技能流程生命周期实现): void {
  for (let i = 活跃流程列表.length - 1; i >= 0; i--) {
    if (活跃流程列表[i] === 实例) {
      活跃流程列表.splice(i, 1);
      break;
    }
  }
}

function 确保死亡监听(this: void): void {
  if (已注册死亡监听) return;
  已注册死亡监听 = true;
  registerDeathListener(on主动技能流程单位死亡);
}

function on主动技能流程单位死亡(this: void, dyingUnit: any): void {
  for (let i = 活跃流程列表.length - 1; i >= 0; i--) {
    const 实例 = 活跃流程列表[i];
    if (实例 != null) 实例.处理单位死亡(dyingUnit);
  }
}

function on主动技能流程清理(this: void, variable?: any): void {
  const 实例 = variable as 主动技能流程生命周期实现 | undefined;
  if (实例 != null) 实例.停止("清理");
}

class 主动技能流程生命周期实现 {
  private 参数: 主动技能流程生命周期参数;
  private 已结束值 = false;
  private 结束原因?: 主动技能流程结束原因;

  constructor(参数: 主动技能流程生命周期参数) {
    this.参数 = 参数;

    if (参数.清理?.已清理()) {
      this.结束内部("清理", false);
      return;
    }
    if (参数.施法者死亡时取消 !== false && !单位有效(参数.施法者)) {
      this.结束内部("死亡", false);
      return;
    }
    if (参数.目标死亡时取消 === true && 参数.目标 != null && 参数.目标 !== 0 && !单位有效(参数.目标)) {
      this.结束内部("目标失效", false);
      return;
    }

    活跃流程列表.push(this);
    确保死亡监听();
    if (参数.清理 != null) {
      参数.清理.登记清理(参数.名称 + "-停止流程", on主动技能流程清理, this);
    }
  }

  停止(原因: 主动技能流程结束原因 = "中断"): boolean {
    return this.结束内部(原因, true);
  }

  结束(原因: 主动技能流程结束原因): boolean {
    return this.结束内部(原因, false);
  }

  完成(): boolean {
    return this.结束内部("完成", false);
  }

  是否结束(): boolean {
    return this.已结束值;
  }

  读取结束原因(): 主动技能流程结束原因 | undefined {
    return this.结束原因;
  }

  处理单位死亡(dyingUnit: any): void {
    if (this.已结束值) return;
    if (this.参数.施法者死亡时取消 !== false && dyingUnit === this.参数.施法者) {
      this.停止("死亡");
      return;
    }
    if (this.参数.目标死亡时取消 === true && dyingUnit === this.参数.目标) {
      this.停止("目标失效");
    }
  }

  private 结束内部(原因: 主动技能流程结束原因, 调用停止回调: boolean): boolean {
    if (this.已结束值) return false;
    this.已结束值 = true;
    this.结束原因 = 原因;
    移除活跃流程(this);

    if (调用停止回调 && this.参数.on停止 != null) {
      this.参数.on停止(原因, this.参数.变量);
    }
    if (this.参数.on结束 != null) {
      this.参数.on结束(原因, this.参数.变量);
    }
    return true;
  }
}

export function 创建主动技能流程生命周期(
  this: void,
  参数: 主动技能流程生命周期参数,
): 主动技能流程控制器 {
  const 实例 = new 主动技能流程生命周期实现(参数);
  return {
    停止: function 主动技能流程控制器停止(this: void, 原因?: 主动技能流程结束原因): boolean {
      return 实例.停止(原因);
    },
    结束: function 主动技能流程控制器结束(this: void, 原因: 主动技能流程结束原因): boolean {
      return 实例.结束(原因);
    },
    完成: function 主动技能流程控制器完成(this: void): boolean {
      return 实例.完成();
    },
    是否结束: function 主动技能流程控制器是否结束(this: void): boolean {
      return 实例.是否结束();
    },
    读取结束原因: function 主动技能流程控制器读取结束原因(this: void): 主动技能流程结束原因 | undefined {
      return 实例.读取结束原因();
    },
  };
}

export {};
