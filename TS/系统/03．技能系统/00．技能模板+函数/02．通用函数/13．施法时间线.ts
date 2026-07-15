/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
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
  施法者: any;
  目标单位?: any;
  目标X?: number;
  目标Y?: number;
  硬直秒: number;
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
  生效前重新面向?: boolean;
  完成后恢复动作?: boolean;
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

export function 启动基础施法时间线(this: void, 参数: 基础施法时间线参数): void {
  const caster = 参数.施法者;
  if (!单位有效(caster) || 参数.on生效 == null) return;

  const 播放台词 = 参数.播放台词;
  if (播放台词 != null) 播放台词();
  面向施法目标(参数);
  开始硬直(caster, 参数.硬直秒);
  if (参数.吟唱条 != null) 显示施法吟唱条(参数.吟唱条);
  播放施法动作(参数);

  if (参数.后续动画延迟毫秒 != null && 参数.后续动画延迟毫秒 > 0) {
    addDelayedCallback(参数.后续动画延迟毫秒, function 基础施法时间线后续动作(this: void): void {
      播放后续施法动作(参数);
    });
  }

  if (参数.重播动作延迟毫秒 != null && 参数.重播动作延迟毫秒 > 0) {
    addDelayedCallback(参数.重播动作延迟毫秒, function 基础施法时间线重播动作(this: void): void {
      播放施法动作(参数);
    });
  }

  addDelayedCallback(R2I(参数.硬直秒 * 1000), function 基础施法时间线生效(this: void): void {
    if (参数.吟唱条 != null) 关闭吟唱条(参数.吟唱条.通道);
    if (!单位有效(caster)) return;
    if (参数.生效前重新面向 !== false) 面向施法目标(参数);
    const on生效 = 参数.on生效;
    on生效();
    if (参数.完成后恢复动作 !== false && 单位有效(caster)) {
      SetUnitTimeScale(caster, 1);
      SetUnitAnimationByIndex(caster, 参数.恢复动画编号 ?? 0);
    }
  });
}
