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

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { String2OrderIdBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  String2OrderIdBJ: (orderIdString: string) => number;
};

const {
  CHEST_TYPES,
  DEFAULT_OPEN_TIME,
  INTERACT_RANGE,
  UPDATE_INTERVAL,
  PROGRESS_BAR_SCALE,
  PROGRESS_BAR_HEIGHT_OFFSET,
  EVENT_PLAYER_PREPARE_OPEN_CHEST,
  EVENT_CHEST_OPENED,
  YDLOCAL_VAR_OPENER,
  YDLOCAL_VAR_CHEST,
  YDLOCAL_VAR_PRE_OPENER,
  YDLOCAL_VAR_PRE_CHEST,
  TEXT_OPENING,
  TEXT_SUCCESS,
  TEXT_INTERRUPTED,
  isChestType,
  getChestConfig,
} = require("系统.06．经济系统.00．宝箱系统.00．常量定义") as typeof import("./00．常量定义");

const { dropItemsFromChest } = require("系统.06．经济系统.00．宝箱系统.01．宝箱掉落配置") as {
  dropItemsFromChest: (destructableType: string, x: number, y: number) => any[];
};

const { STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_GetTable: (self: any) => any;
};

const {
  YDLocalExecuteTrigger,
  saveParentIndex,
  YDTriggerExecuteTrigger,
} = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (trg: any) => void;
  saveParentIndex: (trg: any) => void;
  YDTriggerExecuteTrigger: (trg: any, flag: boolean) => void;
};

const { YDLocal5Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (type: string, name: string, value: any) => void;
};

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const { CreateFloatTextOnUnit } = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextOnUnit: (unit: any, text: string, options?: any) => any;
};

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

/** 进度条单位类型缓存 */
let _progressBarUnitType: number = 0;

function getProgressBarUnitType(this: void): number {
  if (_progressBarUnitType !== 0) return _progressBarUnitType;
  const code = YDUserDataGet("string", "施法进度条", "单位类型", "unitcode");
  if (typeof code === "number" && code !== 0) {
    _progressBarUnitType = code;
  }
  return _progressBarUnitType;
}

/** 计算两点角度 */
function angleBetweenPoints(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
}

/** 显示漂浮文字 */
function showTextTag(this: void, unit: any, text: string, red: number, green: number, blue: number): void {
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

// ==========================================================================================
// STES事件触发
// ==========================================================================================

function fireStesEvent(this: void, eventName: string, opener: any, target: any): void {
    const ht = STES_GetTable(undefined);
    if (!ht) return;

    const hash = jass.StringHash(eventName);
    const skeyIndex = jass.StringHash("index");
    const count = jass.LoadInteger(ht, hash, skeyIndex);

    for (let i = 0; i < count; i++) {
        const trg = jass.LoadTriggerHandle(ht, hash, i);
        if (trg) {
            // 先设置变量，再执行触发器
            if (eventName === EVENT_CHEST_OPENED) {
                YDLocal5Set("unit", YDLOCAL_VAR_OPENER, opener);
                YDLocal5Set("destructable", YDLOCAL_VAR_CHEST, target);
            } else if (eventName === EVENT_PLAYER_PREPARE_OPEN_CHEST) {
                YDLocal5Set("unit", YDLOCAL_VAR_PRE_OPENER, opener);
                YDLocal5Set("destructable", YDLOCAL_VAR_PRE_CHEST, target);
            }

            YDLocalExecuteTrigger(trg);
            saveParentIndex(trg);
            YDTriggerExecuteTrigger(trg, false);
        }
    }
}

// ==========================================================================================
// 开启核心逻辑
// ==========================================================================================

function cleanupOpening(this: void, data: OpenData, interrupted: boolean): void {
  jass.DzUnitDisableAttack(data.unit, false);

  if (data.progressBar) {
    jass.RemoveUnit(data.progressBar);
  }

  if (interrupted) {
    const cfg = getChestConfig(jass.GetDestructableTypeId(data.target));
    showTextTag(data.unit, TEXT_INTERRUPTED(cfg?.name ?? "宝箱"), 85, 10, 10);
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
  const progressType = getProgressBarUnitType();
  const progressBar = jass.CreateUnit(jass.Player(4), progressType, unitX, unitY, 0);

  if (progressBar) {
    jass.SetUnitTimeScale(progressBar, speed);
    jass.SetUnitScale(progressBar, PROGRESS_BAR_SCALE, PROGRESS_BAR_SCALE, PROGRESS_BAR_SCALE);
    const flyHeight = jass.GetUnitFlyHeight(unit) + PROGRESS_BAR_HEIGHT_OFFSET;
    jass.SetUnitFlyHeight(progressBar, flyHeight, 0);
  }

  jass.DzUnitDisableAttack(unit, true);

  const targetX = jass.GetDestructableX(target);
  const targetY = jass.GetDestructableY(target);
  const angle = angleBetweenPoints(unitX, unitY, targetX, targetY);
  jass.SetUnitFacing(unit, angle);

  const config = getChestConfig(jass.GetDestructableTypeId(target));
  const chestName = config?.name ?? "宝箱";

  fireStesEvent(EVENT_PLAYER_PREPARE_OPEN_CHEST, unit, target);
  showTextTag(unit, TEXT_OPENING(chestName), 100, 100, 0);

  const data: OpenData = {
    unit,
    target,
    progressBar,
    openTime,
    elapsed: 0,
  };

  const unitId = getUnitId(unit);
  if (unitId !== 0) {
    openingMap.set(unitId, data);
  }

  ensureRegisteredToCenterTimer();
}

// ==========================================================================================
// 中心计时器集成
// ==========================================================================================

let _registeredToCenterTimer = false;
let _tickCounter = 0;
const CENTER_TIMER_TICKS = Math.ceil(UPDATE_INTERVAL / 0.01);

function updateAllOpening(this: void): void {
  for (const [unitId, data] of openingMap) {
    const currentOrder = jass.GetUnitCurrentOrder(data.unit);
    const smartOrder = String2OrderIdBJ("smart");
    const attackOrder = String2OrderIdBJ("attack");

    const completed = data.elapsed >= data.openTime;
    const interrupted = currentOrder === smartOrder || currentOrder === attackOrder;

    if (completed || interrupted) {
    if (completed) {
        const cfg = getChestConfig(jass.GetDestructableTypeId(data.target));
        const chestName = cfg?.name ?? "宝箱";
        showTextTag(data.unit, TEXT_SUCCESS(chestName), 100, 100, 0);

        // TS端执行掉落
        const targetTypeStr = cfg?.destructableType;
        if (targetTypeStr) {
            const x = jass.GetDestructableX(data.target);
            const y = jass.GetDestructableY(data.target);
            dropItemsFromChest(targetTypeStr, x, y);
        }

        // 触发STES事件（JASS端可监听）
        fireStesEvent(EVENT_CHEST_OPENED, data.unit, data.target);

        // 开启成功后处理宝箱（杀死可破坏物）
        if (data.target) {
            jass.KillDestructable(data.target);
        }
    }
      cleanupOpening(data, !completed && interrupted);
      continue;
    }

    data.elapsed += UPDATE_INTERVAL;

    if (data.progressBar) {
      const unitX = jass.GetUnitX(data.unit);
      const unitY = jass.GetUnitY(data.unit);
      jass.SetUnitX(data.progressBar, unitX);
      jass.SetUnitY(data.progressBar, unitY);
    }
  }

  for (const [unitId, data] of movingMap) {
    const currentOrder = jass.GetUnitCurrentOrder(data.unit);
    const moveOrder = String2OrderIdBJ("move");

    const inRange = jass.IsUnitInRangeXY(data.unit, data.targetX, data.targetY, INTERACT_RANGE);
    const orderChanged = currentOrder !== moveOrder;

    if (inRange || orderChanged) {
      if (inRange) {
        const targetType = jass.GetDestructableTypeId(data.target);
        if (targetType && isInteractable(targetType)) {
          const openTime = getOpenTime(targetType);
          startOpening(data.unit, data.target, openTime);
        }
      }
      movingMap.delete(unitId);
    }
  }
}

function ensureRegisteredToCenterTimer(this: void): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

  const { onTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
    onTick10ms: (callback: () => void) => void;
  };

  onTick10ms(() => {
    if (openingMap.size === 0 && movingMap.size === 0) return;

    _tickCounter = _tickCounter + 1;
    if (_tickCounter >= CENTER_TIMER_TICKS) {
      _tickCounter = 0;
      updateAllOpening();
    }
  });
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
  if (!unit || !target) return;

  const targetType = jass.GetDestructableTypeId(target);
  if (!isInteractable(targetType)) return;

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
  EVENT_PLAYER_PREPARE_OPEN_CHEST as STES_EVENT_PREPARE,
  EVENT_CHEST_OPENED as STES_EVENT_OPENED,
  YDLOCAL_VAR_OPENER,
  YDLOCAL_VAR_CHEST,
  YDLOCAL_VAR_PRE_OPENER,
  YDLOCAL_VAR_PRE_CHEST,
  isInteractable,
  getOpenTime,
};
