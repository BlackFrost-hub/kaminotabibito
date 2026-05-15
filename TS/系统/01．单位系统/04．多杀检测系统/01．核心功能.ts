/**
 * ==========================================================================================
 * 多杀检测系统（同步击杀系统）- 核心功能
 * ==========================================================================================
 *
 * 【系统功能】
 * 实现单位组的同步击杀机制：当组内不同单位在指定时间窗口内受到致命伤害达到阈值时，
 * 组内所有单位一起死亡。
 *
 * 【核心机制】
 * 1. 全局计数器：整个单位组共享一个伤害计数器（hitCount）
 * 2. 时间窗口：在 killWindow 秒内累计不同单位的致命伤害
 * 3. 去重机制：同一单位连续受到致命伤害只算一次（防止快速连击错误计数）
 * 4. 窗口重置：时间窗口过期后计数器自动重置
 * 5. 触发击杀：达到 killThreshold 阈值时，组内所有单位一起死亡
 * 6. 排除自然死亡：只计算有凶手单位的击杀（玩家/敌人造成的伤害）
 *
 * 【使用场景】
 * - 需要多个单位同时死亡的剧情/机制
 * - 防止玩家逐个击杀，要求在一定时间内同时击杀所有目标
 *
 * 【JASS 调用方式】
 * 1. 通过 STES "OnMultiKill" 事件启动监控
 * 2. 参数通过 YDLocal5Set 传递：
 *    - killGroup: 要监控的单位组
 *    - killWindow: 时间窗口（秒，默认3）
 *    - killThreshold: 击杀阈值（默认3）
 *    - effectSource: 逻辑锚点单位（推荐用隐藏单位）
 *
 * 【注意事项】
 * 1. effectSource：多杀系统的来源标识（如分裂后隐藏的母体单位），用于区分多路监控
 * 2. finish：与 effectSource 配套使用，为 true 时组内单位全死后会显示 effectSource
 * 3. 同一单位组不能重叠（后启动的会覆盖先启动的）
 * 4. 系统使用中心计时器获取时间，支持毫秒精度
 *
 * 【示例】
 * // JASS 端调用示例
 * call YDLocal5Set(group, "killGroup", GetUnitsInRectAll(gg_rct_Area))
 * call YDLocal5Set(real, "killWindow", 3.00)
 * call YDLocal5Set(integer, "killThreshold", 3)
 * call YDLocal5Set(unit, "effectSource", gg_unit_hfoo_0001)
 * call STES_Trigger("OnMultiKill")
 *
 * ==========================================================================================
 */

const jass = require("jass.common") as any;

import {
  MULTI_KILL_SYSTEM_ENABLED,
} from "./00．常量定义";

const {
  YDUserDataGet,
  YDUserDataSet,
  YDUserDataClear,
} = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, key: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, key: any, attr: string, value: any) => void;
  YDUserDataClear: (tableType: string, key: any, attr: string, valueType: string) => void;
};

const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (callback: (unit: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void) => void;
};

const { YDWESetEventDamage } = require("lib.扩展函数.封装函数.06．伤害函数.02．伤害事件数据") as {
  YDWESetEventDamage: (amount: number) => boolean;
};

const { GroupAddGroup } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  GroupAddGroup: (source: any, dest: any) => void;
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

export interface MultiKillConfig {
  effectSource: any;
  killGroup: any;
  killThreshold?: number;
  killWindow?: number;
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
  killThreshold: number;
  killWindow: number;
  hitCount: number;           // 全局伤害计数（整个组共享）
  firstHitTime: number;       // 首次受到伤害的时间
  lastHitUnit: any;           // 上一次受到伤害的单位（防止同一单位重复计数）
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
let groupUnitMap: Map<number, MonitorInstance> = new Map();
let damageCallbackRegistered = false;

// ==========================================================================================
// 导入成功回调
// ==========================================================================================

const { onMultiKillSuccess } = require("系统.01．单位系统.04．多杀检测系统.04．成功回调") as {
  onMultiKillSuccess: (instance: MonitorInstance) => void;
};

// ==========================================================================================
// 辅助函数
// ==========================================================================================

function getGameTime(): number {
const { getServerTime } = globalThis as unknown as {
    getServerTime: () => number;
  };
  // 直接使用服务器时间（毫秒），转换为秒
  // 即使不在对战平台，默认也是2015年的时间戳
  return getServerTime() / 1000;
}

function getUnitId(unit: any): number {
  if (unit == null || unit === 0) return 0;
  return (jass.GetHandleId(unit) as number) || 0;
}

function killAllInGroup(instance: MonitorInstance): void {
  if (instance.killGroup == null) return;
    const group = instance.killGroup;
  let unit = jass.FirstOfGroup(group);
  while (unit != null) {
    jass.GroupRemoveUnit(group, unit);
    groupUnitMap.delete(getUnitId(unit));
    jass.KillUnit(unit);
    unit = jass.FirstOfGroup(group);
  }
  if (instance.isOwnKillGroup) {
    jass.DestroyGroup(group);
  }
  instance.killGroup = null;

  // 调用成功回调（触发治疗效果事件、显示 effectSource 等）
  onMultiKillSuccess(instance);
}

function removeGroupMonitor(instance: MonitorInstance): void {
  if (instance.killGroup != null) {
    let unit = jass.FirstOfGroup(instance.killGroup);
    while (unit != null) {
      groupUnitMap.delete(getUnitId(unit));
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

// ==========================================================================================
// 核心逻辑：伤害处理
// ==========================================================================================

function onUnitDamage(
  targetUnit: any,
  damage: number,
  damageType: number,
  fromDotTickBatch?: boolean,
  sourceUnit?: any,
  isNormalAttack?: boolean
): void {
  // 检查目标单位是否在监控列表中
  const instance = groupUnitMap.get(getUnitId(targetUnit));
  if (instance == null) return;

  // 必须有凶手单位（排除自然死亡/系统击杀）
  if (sourceUnit == null || sourceUnit === 0) {
    return;
  }

  // 检查是否是致命伤害（伤害 >= 当前生命值）
  const isFatal = damage >= jass.GetUnitState(targetUnit, jass.UNIT_STATE_LIFE);

  // 非致命伤害：正常通过，不干预
  if (!isFatal) {
    return;
  }

  const now = getGameTime();

  // 检查时间窗口是否过期
  if (instance.firstHitTime > 0) {
    const timeElapsed = now - instance.firstHitTime;
    if (timeElapsed > instance.killWindow) {
      // 时间窗口过期，重置计数
      instance.hitCount = 0;
      instance.firstHitTime = now;
      instance.lastHitUnit = null;
    }
  }

  // 检查是否是同一单位的重复致命伤害
  if (instance.lastHitUnit === targetUnit) {
    // 同一单位连续受到致命伤害，免疫
    YDWESetEventDamage(0);
    return;
  }

  // 首次受到致命伤害，启动时间窗口
  if (instance.firstHitTime === 0) {
    instance.firstHitTime = now;
  }

  // 增加致命伤害计数（不同单位）
  instance.hitCount++;
  instance.lastHitUnit = targetUnit;

  // 检查是否达到阈值
  if (instance.hitCount >= instance.killThreshold) {
    // 击杀组内所有单位（killAllInGroup 内部会触发效果事件）
    killAllInGroup(instance);
    // 清理监控
    removeGroupMonitor(instance);
    // 允许这次致命伤害通过（击杀当前单位）
  } else {
    // 未达到阈值，免疫致命伤害
    YDWESetEventDamage(0);
  }
}

// ==========================================================================================
// API函数
// ==========================================================================================

export function startMultiKillMonitor(config: MultiKillConfig): void {
  if (!MULTI_KILL_SYSTEM_ENABLED) return;
  if (config.killGroup == null || config.killGroup === 0) {
    return;
  }

  // 检查阈值和窗口参数
  const killThreshold = config.killThreshold ?? 3;
  const killWindow = config.killWindow ?? 3.0;

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
    killThreshold: killThreshold,
    killWindow: killWindow,
    hitCount: 0,
    firstHitTime: 0,
    lastHitUnit: null,
    diyEvent: config.diyEvent ?? false,
    diyEventString: config.diyEventString ?? "",
    finish: config.finish ?? false,
    effectID: config.effectID ?? 0,
    healAmount: config.healAmount ?? 0,
    healTarget: config.healTarget ?? null,
    healSource: config.healSource ?? null,
  };

  // 注册单位到监控映射
  const tempGroup = jass.CreateGroup();
  GroupAddGroup(instance.killGroup, tempGroup);
  let unit = jass.FirstOfGroup(tempGroup);
  while (unit != null) {
    groupUnitMap.set(getUnitId(unit), instance);
    jass.GroupRemoveUnit(tempGroup, unit);
    unit = jass.FirstOfGroup(tempGroup);
  }
  jass.DestroyGroup(tempGroup);

  groupMonitors.push(instance);

  // 注册伤害回调（只注册一次）
  if (!damageCallbackRegistered) {
    registerDamageCallback(onUnitDamage);
    damageCallbackRegistered = true;
  }
}

/** @param effectSource 启动监控时传入的锚点单位（通常为 JASS 侧隐藏单位） */
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
  groupUnitMap.set(getUnitId(unit), instance);
}

export function removeFromKillGroup(effectSource: any, unit: any): void {
  const instance = groupMonitors.find((m) => m.effectSource === effectSource);
  if (instance == null || instance.killGroup == null) return;
  jass.GroupRemoveUnit(instance.killGroup, unit);
  groupUnitMap.delete(getUnitId(unit));
}

export function isMultiKillMonitored(unit: any): boolean {
  return groupUnitMap.has(getUnitId(unit));
}

export function getMultiKillMonitorCount(): number {
  return groupMonitors.length;
}

export {};
