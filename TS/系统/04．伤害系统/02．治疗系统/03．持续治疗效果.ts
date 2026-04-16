/**
 * 持续治疗效果（HOT）系统
 *
 * 功能：通过中心计时器实现每秒恢复生命和魔法
 *
 * 优化：使用中心计时器的 onSecond 回调，避免为每个单位创建独立计时器
 *
 * 后续接手者注意：
 * 1. 直接调用 doHeal 执行治疗，不需要通过STES事件
 * 2. Buff ID列表可根据需要扩展
 */

const jass = require("jass.common") as any;

const { UnitHasBuffBJ, IsUnitDeadBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  UnitHasBuffBJ: (unit: any, buffId: number) => boolean;
  IsUnitDeadBJ: (unit: any) => boolean;
};

const { IsUnitPausedBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as {
  IsUnitPausedBJ: (unit: any) => boolean;
};

const {
  YDUserDataGet,
  YDUserDataSet,
  YDUserDataClear,
} = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, key: any, attr: string, valueType: string) => any;
  YDUserDataSet: (tableType: string, key: any, attr: string, value: any) => void;
  YDUserDataClear: (tableType: string, key: any, attr: string, valueType: string) => void;
};

const { onSecond, offSecond } = require("系统.00．核心系统.05．中心计时器") as {
  onSecond: (callback: () => void) => void;
  offSecond: (callback: () => void) => void;
};

// 导入核心治疗功能
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    ItemHeal: boolean;
    HealEffect: boolean;
  }) => number;
};

// 导入魔法恢复功能
const { doManaRegen } = require("系统.04．伤害系统.02．治疗系统.05．魔法恢复") as {
  doManaRegen: (target: any, amount: number, showEffect?: boolean) => number;
};

//=============================================================================
// 一、常量配置
//=============================================================================

/** 持续恢复相关Buff ID（没有这些Buff时效果结束） */
const HOT_BUFF_IDS = [
  0x4249726D, // 'BIrm' - 恢复魔法
  0x42497267, // 'BIrg' - 恢复生命
  0x4249726C, // 'BIrl' - 恢复
  0x4272656A, // 'Brej' - 再生
];

/** YDUserData属性名 */
const ATTR_COUNTDOWN = "持续恢复倒计时";
const ATTR_TICK_HP = "hotTickHP";
const ATTR_TICK_MP = "hotTickMP";
const ATTR_SOURCE = "hotSource";

/** 系统开关 */
const HOT_SYSTEM_ENABLED = true;

//=============================================================================
// 二、辅助函数
//=============================================================================

/**
 * 检查单位是否有任意一个持续恢复Buff
 */
function hasAnyHotBuff(unit: any): boolean {
  for (const buffId of HOT_BUFF_IDS) {
    if (UnitHasBuffBJ(unit, buffId)) return true;
  }
  return false;
}

//=============================================================================
// 三、HOT单位管理
//=============================================================================

/** 正在受HOT效果影响的单位集合 */
const hotUnits: Set<any> = new Set();

/** 是否已注册中心计时器回调 */
let registeredToCenterTimer = false;

/** 中心计时器回调引用（用于注销） */
let hotTickCallback: (() => void) | null = null;

/**
 * 中心计时器每秒回调
 * 遍历所有HOT单位，执行恢复逻辑
 */
function onHotTick(): void {
  const toRemove: any[] = [];

  for (const target of hotUnits) {
    // 检查单位是否被暂停（暂停则跳过本次）
    if (IsUnitPausedBJ(target)) {
      continue;
    }

    // 减少持续恢复倒计时
    const countdown = YDUserDataGet("unit", target, ATTR_COUNTDOWN, "real") - 1.0;
    YDUserDataSet("unit", target, ATTR_COUNTDOWN, countdown);

    // 获取恢复量和来源
    const tickHP = YDUserDataGet("unit", target, ATTR_TICK_HP, "real");
    const tickMP = YDUserDataGet("unit", target, ATTR_TICK_MP, "real");
    const source = YDUserDataGet("unit", target, ATTR_SOURCE, "unit");

    // 执行生命恢复（直接调用 doHeal，TS参数传参）
    if (tickHP > 0) {
      doHeal({
        HealSource: source,
        HealTarget: target,
        HealAmount: tickHP,
        ItemHeal: true,
        HealEffect: false, // HOT通常不播放特效
      });
    }

    // 执行魔法恢复
    if (tickMP > 0) {
      doManaRegen(target, tickMP, false);
    }

    // 检查结束条件
    const shouldEnd =
      !hasAnyHotBuff(target) ||
      countdown <= 0 ||
      IsUnitDeadBJ(target);

    if (shouldEnd) {
      toRemove.push(target);
    }
  }

  // 清理结束的单位
  for (const target of toRemove) {
    stopHot(target);
  }
}

/**
 * 注册中心计时器回调（延迟注册，只在有HOT单位时才运行）
 */
function ensureCenterTimerRegistered(): void {
  if (registeredToCenterTimer) return;

  hotTickCallback = onHotTick;
  onSecond(hotTickCallback);
  registeredToCenterTimer = true;
}

/**
 * 注销中心计时器回调（没有HOT单位时停止运行）
 */
function unregisterCenterTimerIfNeeded(): void {
  if (!registeredToCenterTimer) return;
  if (hotUnits.size > 0) return;

  if (hotTickCallback) {
    offSecond(hotTickCallback);
    hotTickCallback = null;
  }
  registeredToCenterTimer = false;
}

//=============================================================================
// 四、主功能函数
//=============================================================================

/**
 * 启动持续治疗效果
 *
 * @param target 目标单位
 * @param source 来源单位
 * @param tickHP 每秒恢复生命量
 * @param tickMP 每秒恢复魔法量
 * @param duration 持续时间（秒）
 */
export function startHot(
  target: any,
  source: any,
  tickHP: number,
  tickMP: number,
  duration: number
): void {
  if (!HOT_SYSTEM_ENABLED) return;
  if (target == null) return;
  if (duration <= 0) return;

  // 设置倒计时和恢复量
  YDUserDataSet("unit", target, ATTR_COUNTDOWN, duration);
  YDUserDataSet("unit", target, ATTR_TICK_HP, tickHP);
  YDUserDataSet("unit", target, ATTR_TICK_MP, tickMP);
  YDUserDataSet("unit", target, ATTR_SOURCE, source);

  // 添加到HOT单位集合
  const isNew = !hotUnits.has(target);
  hotUnits.add(target);

  // 确保中心计时器回调已注册
  if (isNew) {
    ensureCenterTimerRegistered();
  }
}

/**
 * 停止持续治疗效果
 */
export function stopHot(target: any): void {
  if (target == null) return;

  // 从HOT单位集合移除
  hotUnits.delete(target);

  // 清理YDUserData
  YDUserDataClear("unit", target, ATTR_COUNTDOWN, "real");
  YDUserDataClear("unit", target, ATTR_TICK_HP, "real");
  YDUserDataClear("unit", target, ATTR_TICK_MP, "real");
  YDUserDataClear("unit", target, ATTR_SOURCE, "unit");

  // 如果没有HOT单位了，注销中心计时器回调
  unregisterCenterTimerIfNeeded();
}

/**
 * 检查单位是否正在受HOT效果影响
 */
export function isHotActive(target: any): boolean {
  return hotUnits.has(target);
}

/**
 * 获取当前HOT单位数量
 */
export function getHotUnitCount(): number {
  return hotUnits.size;
}

//=============================================================================
// 五、STES事件触发函数（供Lua/JASS端调用）
//=============================================================================

const { STES_Fire } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Fire: (self: any, name: string) => void;
};

const { YDLocal5Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (ty: string, name: string, value: any) => void;
};

/** STES事件名称 */
export const HOT_EVENT_NAME = "持续治疗效果";

/**
 * 触发"持续治疗效果"事件
 * 供Lua端/JASS端调用，启动持续恢复效果
 *
 * @param target 目标单位
 * @param source 来源单位
 * @param tickHP 每秒恢复生命量
 * @param tickMP 每秒恢复魔法量
 * @param duration 持续时间（秒，可选，默认从YDUserData读取或使用tickHP）
 */
export function fireHotEvent(
  target: any,
  source: any,
  tickHP: number,
  tickMP: number,
  duration?: number
): void {
  YDLocal5Set("unit", "HealTarget", target);
  YDLocal5Set("unit", "HealSource", source);
  YDLocal5Set("real", "hotTickHP", tickHP);
  YDLocal5Set("real", "hotTickMP", tickMP);
  if (duration != null) {
    YDUserDataSet("unit", target, ATTR_COUNTDOWN, duration);
  }
  STES_Fire(null, HOT_EVENT_NAME);
}

//=============================================================================
// 六、STES事件处理
//=============================================================================

/** 触发器实例 */
let hotTrigger: any = null;

/**
 * STES事件处理函数
 * 接收参数：HealTarget, HealSource, hotTickHP, hotTickMP
 */
function onHotEvent(): void {
  const { YDLocal1Get } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
    YDLocal1Get: (ty: string, name: string) => any;
  };

  const target = YDLocal1Get("unit", "HealTarget");
  const source = YDLocal1Get("unit", "HealSource");
  const tickHP = YDLocal1Get("real", "hotTickHP");
  const tickMP = YDLocal1Get("real", "hotTickMP");

  // 获取持续时间（从YDUserData读取，或使用tickHP作为默认值）
  let duration = YDUserDataGet("unit", target, ATTR_COUNTDOWN, "real");
  if (duration <= 0) {
    duration = tickHP > 0 ? tickHP : 10; // 默认10秒
  }

  startHot(target, source, tickHP, tickMP, duration);
}

//=============================================================================
// 七、初始化
//=============================================================================

/**
 * 初始化持续治疗效果系统
 */
export function initHotSystem(): void {
  if (!HOT_SYSTEM_ENABLED) return;
  if (hotTrigger != null) return;

  hotTrigger = jass.CreateTrigger();
  jass.TriggerAddAction(hotTrigger, onHotEvent);

  // 注册到STES
  const { STES_Register } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
    STES_Register: (trg: any, name: string) => void;
  };
  STES_Register(hotTrigger, HOT_EVENT_NAME);
}

/**
 * 检查系统是否已初始化
 */
export function isHotSystemInitialized(): boolean {
  return hotTrigger != null;
}

export {};
