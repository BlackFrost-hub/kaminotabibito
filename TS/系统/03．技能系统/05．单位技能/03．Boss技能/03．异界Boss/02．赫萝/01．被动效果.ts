/** @noSelfInFile */

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { 是否黑天 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态") as {
  是否黑天: (this: void) => boolean;
};
const { 转四位ID } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
};
const { 赫萝单位技能配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.02．赫萝.00．配置") as {
  赫萝单位技能配置: {
    单位ID: string;
    检查间隔Ms: number;
    黑夜单位状态值: number;
    白天单位状态值: number;
    黑夜移速: number;
    白天移速: number;
  };
};

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichType: number) => boolean;
const SetUnitStateJapi = japi.SetUnitState as (whichUnit: any, whichUnitState: number, value: number) => void;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (whichUnit: any, newSpeed: number) => void;
const ConvertUnitState = jass.ConvertUnitState as (state: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as number;

const 赫萝单位类型ID = 转四位ID(赫萝单位技能配置.单位ID);
const 赫萝昼夜被动单位表: Record<number, any | undefined> = {};
let 赫萝昼夜被动定时器ID = 0;

function 获取句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 应用赫萝昼夜状态(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  if (IsUnitType(unit, UNIT_TYPE_DEAD)) return;
  if (GetUnitTypeId(unit) !== 赫萝单位类型ID) return;

  if (是否黑天()) {
    SetUnitStateJapi(unit, ConvertUnitState(0x25), 赫萝单位技能配置.黑夜单位状态值);
    SetUnitMoveSpeed(unit, 赫萝单位技能配置.黑夜移速);
  } else {
    SetUnitStateJapi(unit, ConvertUnitState(0x25), 赫萝单位技能配置.白天单位状态值);
    SetUnitMoveSpeed(unit, 赫萝单位技能配置.白天移速);
  }
}

function 处理赫萝昼夜被动Tick(this: void): void {
  const keys = Object.keys(赫萝昼夜被动单位表);
  for (let i = 0; i < keys.length; i++) {
    const handleId = Number(keys[i]) || 0;
    if (handleId <= 0) continue;

    const unit = 赫萝昼夜被动单位表[handleId];
    if (unit == null || unit === 0 || IsUnitType(unit, UNIT_TYPE_DEAD)) {
      delete 赫萝昼夜被动单位表[handleId];
      continue;
    }

    应用赫萝昼夜状态(unit);
  }

  if (Object.keys(赫萝昼夜被动单位表).length === 0 && 赫萝昼夜被动定时器ID !== 0) {
    removePeriodicCallback(赫萝昼夜被动定时器ID);
    赫萝昼夜被动定时器ID = 0;
  }
}

function 确保赫萝昼夜被动定时器(this: void): void {
  if (赫萝昼夜被动定时器ID !== 0) return;
  赫萝昼夜被动定时器ID = addPeriodicCallback(赫萝单位技能配置.检查间隔Ms, 处理赫萝昼夜被动Tick);
}

export function 启动赫萝昼夜被动(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  if (GetUnitTypeId(unit) !== 赫萝单位类型ID) return;

  const handleId = 获取句柄ID(unit);
  if (handleId === 0) return;

  赫萝昼夜被动单位表[handleId] = unit;
  确保赫萝昼夜被动定时器();
  应用赫萝昼夜状态(unit);
}

export function 停止赫萝昼夜被动(this: void, unit: any): void {
  const handleId = 获取句柄ID(unit);
  if (handleId === 0) return;

  delete 赫萝昼夜被动单位表[handleId];
  if (Object.keys(赫萝昼夜被动单位表).length === 0 && 赫萝昼夜被动定时器ID !== 0) {
    removePeriodicCallback(赫萝昼夜被动定时器ID);
    赫萝昼夜被动定时器ID = 0;
  }
}
