/** @noSelfInFile */
/**
 * 宝箱系统 - 核心功能
 *
 * 功能：
 * 1. 玩家右键点击可交互目标，自动移动到范围内开始开启
 * 2. 显示进度条和提示文字
 * 3. 开启成功触发STES事件
 * 4. 移动/攻击/施法会中断开启
 *
 * 支持任意可交互目标类型（通过INTERACTABLE_TYPES配置）
 */

const japi = require("jass.japi") as any;

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const DzUnitDisableAttack = japi.DzUnitDisableAttack as (this: void, unit: any, disabled: boolean) => void;
const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const { ceil, forEachSorted } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  ceil: (this: void, value: number) => number;
  forEachSorted: <K extends number | string, V>(this: void, map: Map<K, V>, callback: (key: K, value: V) => void) => void;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};
const BJ_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;

const {
  CHEST_TYPES,
  DEFAULT_OPEN_TIME,
  INTERACT_RANGE,
  UPDATE_INTERVAL,
  PROGRESS_BAR_HEIGHT_OFFSET,
  YDLOCAL_VAR_OPENER,
  YDLOCAL_VAR_CHEST,
  YDLOCAL_VAR_PRE_OPENER,
  YDLOCAL_VAR_PRE_CHEST,
  isChestType,
  getChestConfig,
} = require("系统.06．经济系统.00．宝箱系统.00．常量定义") as typeof import("./00．常量定义");
const { 触发宝箱准备开启回调 } = require("系统.06．经济系统.00．宝箱系统.04．准备开启回调") as {
  触发宝箱准备开启回调: (this: void, unit: any, target: any, progressBar: any, openTime: number, chestConfig: any, ownerUnit?: any) => void;
};
const { 触发宝箱开启中回调 } = require("系统.06．经济系统.00．宝箱系统.05．开启中回调") as {
  触发宝箱开启中回调: (this: void, unit: any, target: any, progressBar: any, openTime: number, elapsed: number, chestConfig: any, ownerUnit?: any) => void;
};
const { 触发宝箱开启完成回调 } = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调") as {
  触发宝箱开启完成回调: (this: void, unit: any, target: any, progressBar: any, openTime: number, chestConfig: any, ownerUnit?: any) => void;
};
const { 创建进度条特效, 销毁进度条特效 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.进度条特效") as {
  创建进度条特效: (this: void, 单位: any, 选项?: { 高度偏移?: number; 缩放?: number; 动画序号?: number; 动画速度?: number }) => any;
  销毁进度条特效: (this: void, 进度条单位: any) => void;
};
const { 广播单位类型提示 } = require("系统.06．经济系统.00．宝箱系统.07．主人广播") as {
  广播单位类型提示: (this: void, 单位类型ID: number, 文本: string, 持续时间?: number) => void;
};

const { dropItemsFromChest } = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置") as {
  dropItemsFromChest: (this: void, destructableType: string, x: number, y: number) => any[];
};
const { dropItemsFromChestConfig } = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置") as {
  dropItemsFromChestConfig: (this: void, config: any, x: number, y: number, opener?: any, ownerUnit?: any, highRoll?: number) => any[];
};
const { 查找宝箱主人 } = require("系统.06．经济系统.00．宝箱系统.08．宝箱主人") as {
  查找宝箱主人: (this: void, 配置: any, 参考单位: any, 阶段: "准备开启" | "开启完成") => any | undefined;
};
const { 触发宝箱首领奖励 } = require("系统.06．经济系统.00．宝箱系统.10．首领奖励宝箱") as {
  触发宝箱首领奖励: (this: void, cfg: any, 开启者: any, 宝箱?: any) => boolean;
};

const 漂浮文字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
};
const CreateFloatTextOnUnit = 漂浮文字模块.CreateFloatTextOnUnit as
  | ((this: void, unit: any, text: string, options?: any) => any)
  | undefined;
const ORDER_MOVE = 851971;
const ORDER_SMART = 851986;
const ORDER_ATTACK = 851983;
const ORDER_STOP = 851972;
const ORDER_HOLD_POSITION = 851993;

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 开启数据 */
interface OpenData {
  unit: any;
  target: any;
  progressBar: any;
  openTime: number;
  elapsed: number;
  chestConfig?: any;
  ownerUnit?: any;
  highRoll?: number;
}

/** 移动数据 */
interface MoveData {
  unit: any;
  target: any;
  targetX: number;
  targetY: number;
}

// ==========================================================================================
// 数据存储
// ==========================================================================================

/** 正在开启的单位映射 */
const openingMap = new Map<number, OpenData>();

/** 正在移动的单位映射 */
const movingMap = new Map<number, MoveData>();

// ==========================================================================================
// 工具函数
// ==========================================================================================

/** 计算两点角度 */
function angleBetweenPoints(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return jass.Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG;
}

/** 显示漂浮文字 */
function showTextTag(this: void, unit: any, text: string, red: number, green: number, blue: number): void {
  if (typeof CreateFloatTextOnUnit === "function") {
    CreateFloatTextOnUnit(unit, text, {
      size: 10,
      red,
      green,
      blue,
      alpha: 0,
      duration: 1.0,
      speedY: 0.03,
    });
  }
}

/** 获取单位HandleId */
function getUnitId(this: void, unit: any): number {
  if (!unit) return 0;
  return jass.GetHandleId(unit);
}

/**
 * 检查可破坏物是否为宝箱
 */
function isInteractable(this: void, destructableType: number): boolean {
  return isChestType(destructableType);
}

/**
 * 获取宝箱的开启时间
 */
function getOpenTime(this: void, destructableType: number): number {
  const config = getChestConfig(destructableType);
  return config?.openTime ?? DEFAULT_OPEN_TIME;
}

function isSamePoint(this: void, ax: number, ay: number, bx: number, by: number): boolean {
  return ax <= bx + 1 && ax >= bx - 1 && ay <= by + 1 && ay >= by - 1;
}

export function onUnitTargetChestPointOrder(this: void, unit: any, x: number, y: number): void {
  if (!unit) return;

  const unitId = getUnitId(unit);
  if (unitId === 0) return;

  const movingData = movingMap.get(unitId);
  if (movingData != null) {
    if (isSamePoint(x, y, movingData.targetX, movingData.targetY)) {
      return;
    }
    movingMap.delete(unitId);
    return;
  }

  const openingData = openingMap.get(unitId);
  if (openingData != null) {
    interruptOpening(unit);
  }
}

export function onUnitTargetChestImmediateOrder(this: void, unit: any, orderId: number): void {
  if (!unit) return;

  if (orderId !== ORDER_STOP && orderId !== ORDER_HOLD_POSITION) {
    return;
  }

  const unitId = getUnitId(unit);
  if (unitId === 0) return;

  const movingData = movingMap.get(unitId);
  if (movingData != null) {
    movingMap.delete(unitId);
  }

  const openingData = openingMap.get(unitId);
  if (openingData != null) {
    interruptOpening(unit);
  }
}

// ==========================================================================================
// STES事件触发
// ==========================================================================================

function fireStesEvent(this: void, _eventName: string, _opener: any, _target: any): void {}

// ==========================================================================================
// 开启核心逻辑
// ==========================================================================================

function cleanupOpening(this: void, data: OpenData, interrupted: boolean): void {
  DzUnitDisableAttack(data.unit, false);

  if (data.progressBar) {
    销毁进度条特效(data.progressBar);
  }

  if (interrupted) {
    const cfg = getChestConfig(jass.GetDestructableTypeId(data.target));
    showTextTag(data.unit, "宝箱打开失败...", 85, 10, 10);
  }

  const unitId = getUnitId(data.unit);
  if (unitId !== 0) {
    openingMap.delete(unitId);
  }
}

function startOpening(this: void, unit: any, target: any, openTime: number): void {
  jass.IssueImmediateOrder(unit, "stop");

  if (openTime <= 0) openTime = 1.0;
  const speed = 1.0 / openTime;

  const unitX = jass.GetUnitX(unit);
  const unitY = jass.GetUnitY(unit);
  const progressBar = 创建进度条特效(unit, {
    高度偏移: PROGRESS_BAR_HEIGHT_OFFSET,
    动画序号: 0,
    动画速度: speed,
  });

  DzUnitDisableAttack(unit, true);

  const targetX = jass.GetDestructableX(target);
  const targetY = jass.GetDestructableY(target);
  const angle = angleBetweenPoints(unitX, unitY, targetX, targetY);
  jass.SetUnitFacing(unit, angle);

  const config = getChestConfig(jass.GetDestructableTypeId(target));
  const highRoll = config?.高级掉落 ? GetRandomInt(1, 100) : undefined;
  if (config != null && highRoll != null) {
  }
  const ownerUnit = config ? 查找宝箱主人(config, target, "准备开启") : undefined;
  const chestName = config?.name ?? "宝箱";

  showTextTag(unit, "开启宝箱中...", 100, 100, 0);

  const data: OpenData = {
    unit,
    target,
    progressBar,
    openTime,
    elapsed: 0,
    chestConfig: config,
    ownerUnit,
    highRoll,
  };

  const unitId = getUnitId(unit);
  if (unitId !== 0) {
    openingMap.set(unitId, data);
  }

  触发宝箱准备开启回调(unit, target, progressBar, openTime, config, ownerUnit);

  ensureRegisteredToCenterTimer();
}

// ==========================================================================================
// 中心计时器集成
// ==========================================================================================

let _registeredToCenterTimer = false;
let _tickCounter = 0;
const CENTER_TIMER_TICKS = ceil(UPDATE_INTERVAL / 0.01);

function updateAllOpening(this: void): void {
  forEachSorted(openingMap, (unitId, data) => {
    const currentOrder = jass.GetUnitCurrentOrder(data.unit);
    const completed = data.elapsed >= data.openTime;
    const interrupted = currentOrder === ORDER_SMART || currentOrder === ORDER_ATTACK || currentOrder === ORDER_STOP || currentOrder === ORDER_HOLD_POSITION;
    if (!completed && !interrupted) {
      触发宝箱开启中回调(data.unit, data.target, data.progressBar, data.openTime, data.elapsed, data.chestConfig, data.ownerUnit);
    }

    if (completed || interrupted) {
    if (completed) {
        const cfg = data.chestConfig ?? getChestConfig(jass.GetDestructableTypeId(data.target));
        const ownerUnit = cfg ? 查找宝箱主人(cfg, data.target, "开启完成") : undefined;
        const chestName = cfg?.name ?? "宝箱";
        showTextTag(data.unit, "宝箱被打开了...", 100, 100, 0);

        cleanupOpening(data, false);

        触发宝箱开启完成回调(data.unit, data.target, data.progressBar, data.openTime, cfg, ownerUnit);

        if (cfg) {
          const dropX = jass.GetDestructableX(data.target);
          const dropY = jass.GetDestructableY(data.target);
          const 首领奖励已接管 = 触发宝箱首领奖励(cfg, data.unit, data.target);
          if (首领奖励已接管) {
          } else {
            dropItemsFromChestConfig(cfg, dropX, dropY, data.unit, ownerUnit, data.highRoll);
          }
        }

        // 开启成功后处理宝箱（杀死可破坏物）
        if (data.target) {
            jass.KillDestructable(data.target);
        }
    }
      if (!completed) {
        cleanupOpening(data, true);
      }
      return;
    }

    data.elapsed += UPDATE_INTERVAL;
  });

  forEachSorted(movingMap, (unitId, data) => {
    const currentOrder = jass.GetUnitCurrentOrder(data.unit);
    const inRange = jass.IsUnitInRangeXY(data.unit, data.targetX, data.targetY, INTERACT_RANGE);
    const orderChanged = currentOrder !== ORDER_MOVE && currentOrder !== ORDER_SMART;
    if (inRange) {
      const targetType = jass.GetDestructableTypeId(data.target);
      if (targetType && isInteractable(targetType)) {
        const openTime = getOpenTime(targetType);
        startOpening(data.unit, data.target, openTime);
      }
      movingMap.delete(unitId);
    } else if (orderChanged) {
      movingMap.delete(unitId);
    }
  });
}

function onChestCenterTimerTick(this: void): void {
  if (openingMap.size === 0 && movingMap.size === 0) return;

  _tickCounter = _tickCounter + 1;
  if (_tickCounter >= CENTER_TIMER_TICKS) {
    _tickCounter = 0;
    updateAllOpening();
  }
}

function ensureRegisteredToCenterTimer(this: void): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

const { onTick10ms } = globalThis as unknown as {
    onTick10ms: (this: void, callback: () => void) => void;
  };

  onTick10ms(onChestCenterTimerTick);
}

// ==========================================================================================
// 公开接口
// ==========================================================================================

/**
 * 处理单位对可交互目标的命令
 * @param unit 触发单位
 * @param target 目标可破坏物
 */
export function onUnitTargetInteractable(this: void, unit: any, target: any): void {
  if (!unit || !target) {
    return;
  }

  const targetType = jass.GetDestructableTypeId(target);
  if (!isInteractable(targetType)) {
    return;
  }

  const openTime = getOpenTime(targetType);

  const targetX = jass.GetDestructableX(target);
  const targetY = jass.GetDestructableY(target);

  const inRange = jass.IsUnitInRangeXY(unit, targetX, targetY, INTERACT_RANGE);

  if (!inRange) {
    jass.IssuePointOrder(unit, "move", targetX, targetY);

    const data: MoveData = {
      unit,
      target,
      targetX,
      targetY,
    };

    const unitId = getUnitId(unit);
    if (unitId !== 0) {
      movingMap.set(unitId, data);
    }

    ensureRegisteredToCenterTimer();
  } else {
    startOpening(unit, target, openTime);
  }
}

/**
 * 检查单位是否正在开启
 */
export function isUnitOpening(this: void, unit: any): boolean {
  if (!unit) return false;
  const unitId = getUnitId(unit);
  return unitId !== 0 ? openingMap.has(unitId) : false;
}

/**
 * 中断单位开启
 */
export function interruptOpening(this: void, unit: any): void {
  if (!unit) return;
  const unitId = getUnitId(unit);
  const data = unitId !== 0 ? openingMap.get(unitId) : null;
  if (data != null) {
    cleanupOpening(data, true);
  }
}

// 兼容旧接口名
export const onUnitTargetChest = onUnitTargetInteractable;
export const isUnitOpeningChest = isUnitOpening;
export const interruptChestOpening = interruptOpening;

export {
  YDLOCAL_VAR_OPENER,
  YDLOCAL_VAR_CHEST,
  YDLOCAL_VAR_PRE_OPENER,
  YDLOCAL_VAR_PRE_CHEST,
  isInteractable,
  getOpenTime,
};

