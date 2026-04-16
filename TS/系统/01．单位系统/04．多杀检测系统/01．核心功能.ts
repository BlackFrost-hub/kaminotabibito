/**
 * 多杀检测系统 - 核心逻辑
 *
 * 功能：监控单位组，组内任意单位死亡即击杀组内所有单位并触发效果
 *
 * 后续接手者注意：
 * 1. 使用单位死亡事件的回调，避免为每个单位创建独立触发器
 * 2. JASS端通过 STES "OnMultiKill" 事件启动监控
 */

const jass = require("jass.common") as any;

import {
  MULTI_KILL_SYSTEM_ENABLED,
} from "./00．常量定义";

import { fireMultiKillEffectEvent, EffectEventParams } from "./02．STES事件触发";

const {
  YDUserDataGet,
  YDUserDataSet,
  YDUserDataClear,
} = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, key: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, key: any, attr: string, value: any) => void;
  YDUserDataClear: (tableType: string, key: any, attr: string, valueType: string) => void;
};

const { registerDeathListener } = require("系统.01．单位系统.03．单位死亡事件.01．核心功能") as {
  registerDeathListener: (callback: (dyingUnit: any, killingUnit: any) => void) => void;
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

export interface MultiKillConfig {
  effectSource: any;
  killGroup: any;
  diyEvent?: boolean;
  diyEventString?: string;
  finish?: boolean;
  effectID?: number;
  healAmount?: number;
  healTarget?: any;
  healSource?: any;
}

interface MonitorInstance {
  effectSource: any;
  killGroup: any;
  isOwnKillGroup: boolean;
  diyEvent: boolean;
  diyEventString: string;
  finish: boolean;
  effectID: number;
  healAmount: number;
  healTarget: any;
  healSource: any;
}

// ==========================================================================================
// 全局存储
// ==========================================================================================

let groupMonitors: MonitorInstance[] = [];

let groupUnitMap: Map<any, MonitorInstance> = new Map();

let deathCallbackRegistered = false;

// ==========================================================================================
// 辅助函数
// ==========================================================================================

function buildEffectParams(instance: MonitorInstance): EffectEventParams {
  return {
    effectID: instance.effectID,
    healAmount: instance.healAmount,
    healTarget: instance.healTarget,
    healSource: instance.healSource,
    diyEvent: instance.diyEvent,
    diyEventString: instance.diyEventString,
  };
}

function killAllInGroup(instance: MonitorInstance): void {
  if (instance.killGroup == null) return;
  const group = instance.killGroup;
  let unit = jass.FirstOfGroup(group);
  while (unit != null) {
    jass.GroupRemoveUnit(group, unit);
    groupUnitMap.delete(unit);
    YDUserDataSet("unit", unit, "killer", true);
    jass.KillUnit(unit);
    unit = jass.FirstOfGroup(group);
  }
  if (instance.isOwnKillGroup) {
    jass.DestroyGroup(group);
  }
  instance.killGroup = null;
}

// ==========================================================================================
// 核心逻辑
// ==========================================================================================

function onUnitDeath(dyingUnit: any, killingUnit: any): void {
  const instance = groupUnitMap.get(dyingUnit);
  if (instance == null) return;

  if (instance.killGroup == null) return;

  jass.GroupRemoveUnit(instance.killGroup, dyingUnit);
  groupUnitMap.delete(dyingUnit);

  killAllInGroup(instance);

  const isKiller = YDUserDataGet("unit", dyingUnit, "killer", "boolean");
  if (!isKiller && killingUnit != null) {
    fireMultiKillEffectEvent(buildEffectParams(instance));
  }

  if (instance.finish) {
    jass.ShowUnit(instance.effectSource, true);
  }

  removeGroupMonitor(instance);
}

// ==========================================================================================
// API函数
// ==========================================================================================

export function startMultiKillMonitor(config: MultiKillConfig): void {
  if (!MULTI_KILL_SYSTEM_ENABLED) return;
  if (config.killGroup == null) return;

  const existingIdx = groupMonitors.findIndex(
    (m) => m.effectSource === config.effectSource
  );
  if (existingIdx >= 0) {
    removeGroupMonitor(groupMonitors[existingIdx]);
  }

  const instance: MonitorInstance = {
    effectSource: config.effectSource,
    killGroup: config.killGroup,
    isOwnKillGroup: false,
    diyEvent: config.diyEvent ?? false,
    diyEventString: config.diyEventString ?? "",
    finish: config.finish ?? false,
    effectID: config.effectID ?? 0,
    healAmount: config.healAmount ?? 0,
    healTarget: config.healTarget ?? null,
    healSource: config.healSource ?? null,
  };

  const tempGroup = jass.CreateGroup();
  jass.GroupAddGroup(instance.killGroup, tempGroup);
  let unit = jass.FirstOfGroup(tempGroup);
  while (unit != null) {
    groupUnitMap.set(unit, instance);
    jass.GroupRemoveUnit(tempGroup, unit);
    unit = jass.FirstOfGroup(tempGroup);
  }
  jass.DestroyGroup(tempGroup);

  groupMonitors.push(instance);

  if (!deathCallbackRegistered) {
    registerDeathListener(onUnitDeath);
    deathCallbackRegistered = true;
  }
}

function removeGroupMonitor(instance: MonitorInstance): void {
  if (instance.killGroup != null) {
    let unit = jass.FirstOfGroup(instance.killGroup);
    while (unit != null) {
      groupUnitMap.delete(unit);
      YDUserDataClear("unit", unit, "killer", "boolean");
      jass.GroupRemoveUnit(instance.killGroup, unit);
      unit = jass.FirstOfGroup(instance.killGroup);
    }
    if (instance.isOwnKillGroup) {
      jass.DestroyGroup(instance.killGroup);
    }
    instance.killGroup = null;
  }
  const idx = groupMonitors.indexOf(instance);
  if (idx >= 0) {
    groupMonitors.splice(idx, 1);
  }
}

export function stopMultiKillMonitor(effectSource: any): void {
  const instance = groupMonitors.find((m) => m.effectSource === effectSource);
  if (instance != null) {
    removeGroupMonitor(instance);
  }
}

export function addToKillGroup(effectSource: any, unit: any): void {
  const instance = groupMonitors.find((m) => m.effectSource === effectSource);
  if (instance == null) return;
  if (instance.killGroup == null) {
    instance.killGroup = jass.CreateGroup();
    instance.isOwnKillGroup = true;
  }
  jass.GroupAddUnit(instance.killGroup, unit);
  groupUnitMap.set(unit, instance);
}

export function removeFromKillGroup(effectSource: any, unit: any): void {
  const instance = groupMonitors.find((m) => m.effectSource === effectSource);
  if (instance == null || instance.killGroup == null) return;
  jass.GroupRemoveUnit(instance.killGroup, unit);
  groupUnitMap.delete(unit);
}

export function isMultiKillMonitored(unit: any): boolean {
  return groupUnitMap.has(unit);
}

export function getMultiKillMonitorCount(): number {
  return groupMonitors.length;
}

export {};
