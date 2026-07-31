/** @noSelfInFile */
/**
 * 宝箱系统 - 事件注册
 *
 * 功能：
 * 1. 监听单位发布目标命令事件（EVENT_UNIT_ISSUED_TARGET_ORDER）
 * 2. 当目标为可破坏物时，检查是否为可交互目标
 * 3. 如果是，调用核心功能处理
 *
 * 注册方式：通过玩家英雄注册联动，在英雄登记时自动注册命令事件
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => { id: number };
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetTriggerUnit = jass.GetTriggerUnit as () => any;
const GetOrderTargetDestructable = jass.GetOrderTargetDestructable as () => any;
const GetDestructableTypeId = jass.GetDestructableTypeId as (destructable: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;


const { onUnitTargetInteractable, onUnitTargetChestPointOrder, onUnitTargetChestImmediateOrder, isInteractable } = require("系统.06．经济系统.00．宝箱系统.03．宝箱核心") as {
  onUnitTargetInteractable: (this: void, unit: any, target: any) => void;
  onUnitTargetChestPointOrder: (this: void, unit: any, x: number, y: number) => void;
  onUnitTargetChestImmediateOrder: (this: void, unit: any, orderId: number) => void;
  isInteractable: (this: void, destructableType: number) => boolean;
};

const { 宝箱系统开关 } = require("系统.06．经济系统.00．宝箱系统.00．常量定义") as {
  宝箱系统开关: boolean;
};

const { YDLocal5Get } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Get: (ty: string, name: string) => any;
};

const helper = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (_self: any) => void;
  ydlStes_finishChildCleanup: (_self: any) => void;
  ydlStes_skeyIndex: (_self: any) => number;
  ydlStes_registerAfterGetTable: (_self: any, trig: any, eventName: string) => void;
};
const unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitEventTrigger: (this: void, trigger: any, unit: any, eventId: any, once?: boolean) => () => void;
};
const orderEventCenter = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerTargetOrderListener: (
    this: void,
    callback: (unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void,
  ) => void;
  registerPointOrderListener: (
    this: void,
    callback: (unit: any, orderId: number, x: number, y: number) => void,
  ) => void;
  registerImmediateOrderListener: (
    this: void,
    callback: (unit: any, orderId: number) => void,
  ) => void;
};

// ==========================================================================================
// 常量
// ==========================================================================================

const EVENT_UNIT_ISSUED_TARGET_ORDER = 19;
const REG_GUARD = "__syzl_chestSystem_registered";
const TRIG_KEY = "__syzl_chestSystem_trig";
const ATTEMPT_KEY = "__syzl_chestSystem_attempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_SEC = 0.1;
const GLOBAL_ORDER_GUARD = "__syzl_chestSystem_global_target_listener";
const 调试模块 = "宝箱系统-目标指令";

/** STES事件名：单位发布目标命令 */
const STES_EVENT_UNIT_TARGET_ORDER = "单位发布目标命令";
const 已注册宝箱英雄 = new Set<number>();

// ==========================================================================================
// 单位命令事件处理
// ==========================================================================================

/**
 * 处理单位发布目标命令事件
 */
function onUnitIssuedTargetOrder(this: void): void {
  const unit = GetTriggerUnit();
  if (unit == null || unit === 0) {
    debugLogForce(调试模块, "单位特定目标命令跳过", "reason=触发单位为空");
    return;
  }

  const target = GetOrderTargetDestructable();
  if (target == null || target === 0) {
    debugLogForce(调试模块, "单位特定目标命令跳过", "reason=目标可破坏物为空", "unit=", GetHandleId(unit));
    return;
  }

  const unitId = GetHandleId(unit);
  const targetType = GetDestructableTypeId(target);
  const 可交互 = isInteractable(targetType);
  debugLogForce(
    调试模块,
    "单位特定目标命令",
    "unit=",
    unitId,
    "unitType=",
    GetUnitTypeId(unit),
    "registered=",
    已注册宝箱英雄.has(unitId),
    "target=",
    GetHandleId(target),
    "targetType=",
    targetType,
    "interactable=",
    可交互,
  );
  if (!可交互) return;

  onUnitTargetInteractable(unit, target);
}

function onGlobalTargetOrder(this: void, unit: any, orderId: number, _targetUnit: any, _targetItem: any, targetDestructable: any): void {
  if (unit == null || unit === 0 || targetDestructable == null || targetDestructable === 0) return;
  const unitId = GetHandleId(unit);
  const targetType = GetDestructableTypeId(targetDestructable);
  const 已登记 = 已注册宝箱英雄.has(unitId);
  const 可交互 = isInteractable(targetType);
  debugLogForce(
    调试模块,
    "全局目标命令",
    "orderId=",
    orderId,
    "unit=",
    unitId,
    "unitType=",
    GetUnitTypeId(unit),
    "registered=",
    已登记,
    "target=",
    GetHandleId(targetDestructable),
    "targetType=",
    targetType,
    "interactable=",
    可交互,
  );
  if (!已登记 || !可交互) return;

  onUnitTargetInteractable(unit, targetDestructable);
}

function onGlobalPointOrder(this: void, unit: any, _orderId: number, x: number, y: number): void {
  if (unit == null || unit === 0) return;
  const unitId = jass.GetHandleId(unit) as number;
  if (!已注册宝箱英雄.has(unitId)) return;
  onUnitTargetChestPointOrder(unit, x, y);
}

function onGlobalImmediateOrder(this: void, unit: any, orderId: number): void {
  if (unit == null || unit === 0) return;
  const unitId = jass.GetHandleId(unit) as number;
  if (!已注册宝箱英雄.has(unitId)) return;
  onUnitTargetChestImmediateOrder(unit, orderId);
}

// ==========================================================================================
// STES事件注册
// ==========================================================================================

function jassStesHashtable(this: void): any {
  const candidates = [jglobals.STES___HT, jglobals.STES_HT, jglobals.udg_STES___HT, jglobals.udg_STES_HT];
  for (let i = 0; i < candidates.length; i++) {
    const table = candidates[i];
    if (table != null && table !== 0) return table;
  }
  return null;
}

function countOnJassStesTable(this: void, eventName: string): number {
  const ht = jassStesHashtable();
  if (ht == null || ht === 0) return -1;
  return jass.LoadInteger(ht, jass.StringHash(eventName), helper.ydlStes_skeyIndex(undefined));
}

function scheduleRetry(this: void, fn: () => void): void {
  createDelayedCall(RETRY_SEC, fn);
}

/**
 * 注册单位目标命令事件监听
 */
function tryRegisterTargetOrderStes(this: void): void {
  const g = globalThis as any;
  if (g[REG_GUARD]) return;

  if (g[TRIG_KEY] == null) {
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, onUnitIssuedTargetOrder);
    g[TRIG_KEY] = trig;
  }

  helper.ydlStes_registerAfterGetTable(undefined, g[TRIG_KEY], STES_EVENT_UNIT_TARGET_ORDER);

  const count = countOnJassStesTable(STES_EVENT_UNIT_TARGET_ORDER);
  const attempt = ((g[ATTEMPT_KEY] as number) || 0) + 1;
  g[ATTEMPT_KEY] = attempt;

  if (count >= 1 || attempt >= MAX_REG_ATTEMPTS) {
    debugLogForce(调试模块, "STES目标命令监听结果", "count=", count, "attempt=", attempt, "registered=", count >= 1);
    g[REG_GUARD] = true;
    return;
  }

  scheduleRetry(() => {
    tryRegisterTargetOrderStes();
  });
}

function ensureGlobalTargetOrderListener(this: void): void {
  const g = globalThis as any;
  if (g[GLOBAL_ORDER_GUARD]) return;
  g[GLOBAL_ORDER_GUARD] = true;
  orderEventCenter.registerTargetOrderListener(onGlobalTargetOrder);
  orderEventCenter.registerPointOrderListener(onGlobalPointOrder);
  orderEventCenter.registerImmediateOrderListener(onGlobalImmediateOrder);
  debugLogForce(调试模块, "全局命令监听已注册");
}

// ==========================================================================================
// 英雄注册联动
// ==========================================================================================

/**
 * 为英雄注册目标命令事件
 * 当英雄被登记时调用
 */
export function registerChestSystemHero(this: void, hero: any): void {
  if (!宝箱系统开关) return;
  if (!hero) return;

  const heroId = GetHandleId(hero);
  已注册宝箱英雄.add(heroId);
  debugLogForce(调试模块, "登记宝箱英雄", "unit=", heroId, "unitType=", GetUnitTypeId(hero), "registeredCount=", 已注册宝箱英雄.size);
  ensureGlobalTargetOrderListener();

  // 注册单位目标命令事件
  const g = globalThis as any;
  if (g[TRIG_KEY] == null) {
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, onUnitIssuedTargetOrder);
    g[TRIG_KEY] = trig;
  }

  const ev = jass.ConvertUnitEvent(EVENT_UNIT_ISSUED_TARGET_ORDER);
  unitSpecificEventCenter.registerUnitEventTrigger(g[TRIG_KEY], hero, ev);
}

/**
 * 初始化宝箱系统
 */
export function initChestSystem(this: void): void {
  if (!宝箱系统开关) return;
  ensureGlobalTargetOrderListener();
  tryRegisterTargetOrderStes();
}

export { STES_EVENT_UNIT_TARGET_ORDER };

