/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import type { 机制清理篮子 } from "../04．机制组件/06．机制清理/01．机制清理篮子";
import type { 主动技能流程控制器, 主动技能流程结束原因 } from "../00．技能模板/04．主动技能流程模板/00．流程生命周期";

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 创建主动技能流程生命周期 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.04．主动技能流程模板.00．流程生命周期") as {
  创建主动技能流程生命周期: (this: void, 参数: any) => 主动技能流程控制器;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const {
  显示常规技能吟唱条,
  显示大招吟唱条,
  显示场地常驻AOE吟唱条,
  显示致命惩罚吟唱条,
  关闭吟唱条,
} = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  显示大招吟唱条: (this: void, 参数: any) => void;
  显示场地常驻AOE吟唱条: (this: void, 参数: any) => void;
  显示致命惩罚吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, timeScale: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const R2I = jass.R2I as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const EXSetUnitFacing = japi.EXSetUnitFacing as ((unit: any, angle: number) => void) | undefined;
const BJ_RADTODEG = 57.29577951308232;
const BJ_DEGTORAD = 0.017453292519943295;

export type 施法吟唱条通道 = "常规技能" | "大招" | "场地常驻AOE" | "致命惩罚";

export interface 施法时间线吟唱条参数 {
  通道: 施法吟唱条通道;
  总时长: number;
  颜色ID: number;
  标题文本: string;
  提示文本?: string;
}

export interface 基础施法时间线参数 {
  名称?: string;
  施法者: any;
  目标单位?: any;
  目标X?: number;
  目标Y?: number;
  硬直秒: number;
  /**
   * 生效回调的延迟。默认等于硬直秒；当动作/预警长于实际硬直时，允许两者独立配置。
   */
  生效延迟秒?: number;
  /** 生效回调执行后保持流程运行的时长；用于跳跃/后摇等需要延迟完成的技能。 */
  完成延迟毫秒?: number;
  动画编号?: number;
  动画名?: string;
  动画速度?: number;
  后续动画编号?: number;
  后续动画名?: string;
  后续动画速度?: number;
  后续动画延迟毫秒?: number;
  恢复动画编号?: number;
  重播动作延迟毫秒?: number;
  吟唱条?: 施法时间线吟唱条参数;
  播放台词?: (this: void) => void;
  on生效: (this: void) => void;
  on结束?: (this: void, 原因: 主动技能流程结束原因) => void;
  清理?: 机制清理篮子;
  施法者死亡时取消?: boolean;
  目标失效时取消?: boolean;
  生效前重新面向?: boolean;
  完成后恢复动作?: boolean;
  取消后恢复动作?: boolean;
}

interface 基础施法时间线运行时 {
  参数: 基础施法时间线参数;
  控制器?: 主动技能流程控制器;
  后续动作回调ID: number;
  重播动作回调ID: number;
  生效回调ID: number;
  完成回调ID: number;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取目标X(this: void, 参数: 基础施法时间线参数): number | undefined {
  if (参数.目标单位 != null && 参数.目标单位 !== 0) return GetUnitX(参数.目标单位);
  return 参数.目标X;
}

function 取目标Y(this: void, 参数: 基础施法时间线参数): number | undefined {
  if (参数.目标单位 != null && 参数.目标单位 !== 0) return GetUnitY(参数.目标单位);
  return 参数.目标Y;
}

function 面向施法目标(this: void, 参数: 基础施法时间线参数): void {
  const caster = 参数.施法者;
  if (!单位有效(caster)) return;
  const targetX = 取目标X(参数);
  const targetY = 取目标Y(参数);
  if (targetX == null || targetY == null) return;
  const angle = Atan2(targetY - GetUnitY(caster), targetX - GetUnitX(caster)) * BJ_RADTODEG;
  SetUnitFacing(caster, angle);
  if (EXSetUnitFacing != null) EXSetUnitFacing(caster, angle * BJ_DEGTORAD);
}

function 播放施法动作(this: void, 参数: 基础施法时间线参数): void {
  const caster = 参数.施法者;
  if (!单位有效(caster)) return;
  SetUnitTimeScale(caster, 参数.动画速度 ?? 1);
  if (参数.动画编号 != null) {
    SetUnitAnimationByIndex(caster, 参数.动画编号);
  } else if (参数.动画名 != null && 参数.动画名 !== "") {
    SetUnitAnimation(caster, 参数.动画名);
  }
}

function 播放后续施法动作(this: void, 参数: 基础施法时间线参数): void {
  const caster = 参数.施法者;
  if (!单位有效(caster)) return;
  SetUnitTimeScale(caster, 参数.后续动画速度 ?? 参数.动画速度 ?? 1);
  if (参数.后续动画编号 != null) {
    SetUnitAnimationByIndex(caster, 参数.后续动画编号);
  } else if (参数.后续动画名 != null && 参数.后续动画名 !== "") {
    SetUnitAnimation(caster, 参数.后续动画名);
  }
}

function 显示施法吟唱条(this: void, 参数: 施法时间线吟唱条参数): void {
  if (参数.通道 === "大招") {
    显示大招吟唱条(参数);
  } else if (参数.通道 === "场地常驻AOE") {
    显示场地常驻AOE吟唱条(参数);
  } else if (参数.通道 === "致命惩罚") {
    显示致命惩罚吟唱条(参数);
  } else {
    显示常规技能吟唱条(参数);
  }
}

function 移除时间线延迟回调(this: void, 运行时: 基础施法时间线运行时): void {
  if (运行时.后续动作回调ID !== 0) removeDelayedCallback(运行时.后续动作回调ID);
  if (运行时.重播动作回调ID !== 0) removeDelayedCallback(运行时.重播动作回调ID);
  if (运行时.生效回调ID !== 0) removeDelayedCallback(运行时.生效回调ID);
  if (运行时.完成回调ID !== 0) removeDelayedCallback(运行时.完成回调ID);
  运行时.后续动作回调ID = 0;
  运行时.重播动作回调ID = 0;
  运行时.生效回调ID = 0;
  运行时.完成回调ID = 0;
}

function 恢复时间线施法动作(this: void, 参数: 基础施法时间线参数): void {
  const caster = 参数.施法者;
  if (!单位有效(caster)) return;
  SetUnitTimeScale(caster, 1);
  SetUnitAnimationByIndex(caster, 参数.恢复动画编号 ?? 0);
}

function 基础施法时间线停止(this: void, _原因: 主动技能流程结束原因, variable?: any): void {
  const 运行时 = variable as 基础施法时间线运行时 | undefined;
  if (运行时 == null) return;
  移除时间线延迟回调(运行时);
  if (运行时.参数.吟唱条 != null) 关闭吟唱条(运行时.参数.吟唱条.通道);
  if (运行时.参数.取消后恢复动作 !== false) 恢复时间线施法动作(运行时.参数);
}

function 基础施法时间线结束(this: void, 原因: 主动技能流程结束原因, variable?: any): void {
  const 运行时 = variable as 基础施法时间线运行时 | undefined;
  if (运行时?.参数.on结束 != null) 运行时.参数.on结束(原因);
}

function 基础施法时间线后续动作(this: void, variable?: any): void {
  const 运行时 = variable as 基础施法时间线运行时 | undefined;
  if (运行时 == null) return;
  运行时.后续动作回调ID = 0;
  if (运行时.控制器?.是否结束()) return;
  if (!单位有效(运行时.参数.施法者)) {
    运行时.控制器?.停止("死亡");
    return;
  }
  播放后续施法动作(运行时.参数);
}

function 基础施法时间线重播动作(this: void, variable?: any): void {
  const 运行时 = variable as 基础施法时间线运行时 | undefined;
  if (运行时 == null) return;
  运行时.重播动作回调ID = 0;
  if (运行时.控制器?.是否结束()) return;
  if (!单位有效(运行时.参数.施法者)) {
    运行时.控制器?.停止("死亡");
    return;
  }
  播放施法动作(运行时.参数);
}

function 基础施法时间线完成(this: void, variable?: any): void {
  const 运行时 = variable as 基础施法时间线运行时 | undefined;
  if (运行时 == null) return;
  运行时.完成回调ID = 0;
  if (运行时.控制器?.是否结束()) return;
  运行时.控制器?.完成();
}

function 基础施法时间线生效(this: void, variable?: any): void {
  const 运行时 = variable as 基础施法时间线运行时 | undefined;
  if (运行时 == null) return;
  运行时.生效回调ID = 0;
  const 参数 = 运行时.参数;
  const 控制器 = 运行时.控制器;
  if (控制器 == null || 控制器.是否结束()) return;

  if (参数.吟唱条 != null) 关闭吟唱条(参数.吟唱条.通道);
  if (!单位有效(参数.施法者)) {
    控制器.停止("死亡");
    return;
  }
  if (参数.目标失效时取消 === true && 参数.目标单位 != null && 参数.目标单位 !== 0 && !单位有效(参数.目标单位)) {
    控制器.停止("目标失效");
    return;
  }

  if (参数.生效前重新面向 !== false) 面向施法目标(参数);
  参数.on生效();
  if (参数.完成后恢复动作 !== false) 恢复时间线施法动作(参数);
  const 完成延迟毫秒 = 参数.完成延迟毫秒;
  if (完成延迟毫秒 != null && 完成延迟毫秒 > 0) {
    运行时.完成回调ID = addDelayedCallback(完成延迟毫秒, 基础施法时间线完成, 运行时);
    return;
  }
  控制器.完成();
}

export function 启动基础施法时间线(this: void, 参数: 基础施法时间线参数): 主动技能流程控制器 {
  const 运行时: 基础施法时间线运行时 = {
    参数,
    后续动作回调ID: 0,
    重播动作回调ID: 0,
    生效回调ID: 0,
    完成回调ID: 0,
  };
  const 控制器 = 创建主动技能流程生命周期({
    名称: 参数.名称 ?? "基础施法时间线",
    施法者: 参数.施法者,
    目标: 参数.目标单位,
    清理: 参数.清理,
    施法者死亡时取消: 参数.施法者死亡时取消,
    目标死亡时取消: 参数.目标失效时取消 === true,
    变量: 运行时,
    on停止: 基础施法时间线停止,
    on结束: 基础施法时间线结束,
  });
  运行时.控制器 = 控制器;
  if (控制器.是否结束() || 参数.on生效 == null) return 控制器;

  const 播放台词 = 参数.播放台词;
  if (播放台词 != null) 播放台词();
  面向施法目标(参数);
  if (参数.硬直秒 > 0) 开始硬直(参数.施法者, 参数.硬直秒);
  if (参数.吟唱条 != null) 显示施法吟唱条(参数.吟唱条);
  播放施法动作(参数);

  if (参数.后续动画延迟毫秒 != null && 参数.后续动画延迟毫秒 > 0) {
    运行时.后续动作回调ID = addDelayedCallback(参数.后续动画延迟毫秒, 基础施法时间线后续动作, 运行时);
  }
  if (参数.重播动作延迟毫秒 != null && 参数.重播动作延迟毫秒 > 0) {
    运行时.重播动作回调ID = addDelayedCallback(参数.重播动作延迟毫秒, 基础施法时间线重播动作, 运行时);
  }
  const 生效延迟秒 = 参数.生效延迟秒 ?? 参数.硬直秒;
  运行时.生效回调ID = addDelayedCallback(R2I(生效延迟秒 * 1000), 基础施法时间线生效, 运行时);
  return 控制器;
}
