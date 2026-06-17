/** @noSelfInFile */
/**
 * 反击系统
 *
 * 支持受到伤害时反击敌人、受到攻击时反击敌人
 * 支持距离条件（大于X码/小于X码）、AOE范围反击、只反击伤害来源
 * 使用 registerAppliedFinalDamageListener 回调防止漏接
 * 使用同类伤害类型检测防止死循环
 */

const jass = require("jass.common") as any;

//=============================================================================
// JASS 函数别名
//=============================================================================

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (e: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;

//=============================================================================
// 依赖模块
//=============================================================================

/** 伤害类型快照接口 */
export interface 伤害类型快照 {
  rawAttackType: any;
  rawDamageType: any;
  rawWeaponType: any;
  isPhysicalDamage: boolean;
  isMagicDamage: boolean;
  isEnhancedDamage: boolean;
  isTrueDamage: boolean;
  isNormalAttack: boolean;
  isSkillAttack: boolean;
  isSkillDamage: boolean;
  isMetalDamage: boolean;
  isWoodDamage: boolean;
  isWaterDamage: boolean;
  isFireDamage: boolean;
  isThunderDamage: boolean;
  isLightDamage: boolean;
  isDarkDamage: boolean;
}

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (target: any, attacker: any, applied: number, snapshot: 伤害类型快照) => void) => void;
};

const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};

const { getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
};

/** 同类伤害类型映射接口 */
interface 同类伤害类型映射 {
  攻击类型: any;
  伤害类型: any;
  武器类型: any;
}

const { 获取同类伤害类型 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.08．同类伤害类型") as {
  获取同类伤害类型: (this: void, snapshot: 伤害类型快照) => 同类伤害类型映射;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

//=============================================================================
// 类型定义
//=============================================================================

/** 反击类型 */
export enum 反击类型 {
  任意伤害 = 0,
  仅攻击 = 1,
}

/** 伤害计算方式 */
export enum 反击伤害类型 {
  固定值 = 0,
  百分比 = 1,
}

/** 距离条件 */
export interface 距离条件 {
  最小距离?: number;
  最大距离?: number;
}

/** 反击参数 */
export interface 反击参数 {
  反击来源: any;
  反击类型: 反击类型;
  伤害计算方式: 反击伤害类型;
  伤害值: number;
  距离条件: 距离条件;
  冷却时间?: number;
  是否AOE: boolean;
  AOE半径?: number;
  只反击来源: boolean;
  反击特效?: string;
  特效附着点?: string;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
}

/** 反击实例 */
interface 反击实例 {
  参数: 反击参数;
  上次反击时间: number;
}

//=============================================================================
// 系统状态
//=============================================================================

/** 反击实例映射：单位handleId -> 反击实例数组 */
const 反击实例映射: Record<number, 反击实例[]> = {};

/** 反击黑名单：记录正在反击的单位handleId，防止死循环 */
const 反击黑名单: Record<number, boolean> = {};

/** 系统是否已初始化 */
let 系统已初始化 = false;

/** 当前正在处理的伤害事件（用于同类伤害检测） */
let 当前伤害类型快照: 伤害类型快照 | null = null;

//=============================================================================
// 工具函数
//=============================================================================

/**
 * 计算两点距离
 */
function 计算两点距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return jass.SquareRoot(dx * dx + dy * dy);
}

/**
 * 检查单位是否在冷却中
 */
function 在冷却中(实例: 反击实例): boolean {
  if (实例.参数.冷却时间 == null || 实例.参数.冷却时间 <= 0) {
    return false;
  }
  const 当前时间 = getGameTime();
  return (当前时间 - 实例.上次反击时间) < 实例.参数.冷却时间;
}

/**
 * 检查距离是否满足条件
 */
function 距离满足条件(距离: number, 条件: 距离条件): boolean {
  if (条件.最小距离 != null && 距离 < 条件.最小距离) {
    return false;
  }
  if (条件.最大距离 != null && 距离 > 条件.最大距离) {
    return false;
  }
  return true;
}

/**
 * 判断是否应该触发反击
 */
function 应该触发反击(实例: 反击实例, 是否普攻: boolean): boolean {
  if (实例.参数.反击类型 === 反击类型.仅攻击) {
    return 是否普攻 === true;
  }
  return true;
}

/**
 * 计算反击伤害值
 */
function 计算反击伤害(实例: 反击实例, 受到伤害: number): number {
  if (实例.参数.伤害计算方式 === 反击伤害类型.百分比) {
    return 受到伤害 * 实例.参数.伤害值;
  }
  return 实例.参数.伤害值;
}

/**
 * 执行反击伤害
 */
function 执行反击伤害(反击来源: any, 目标单位: any, 伤害值: number, 参数: 反击参数): void {
  if (!反击来源 || !目标单位 || 伤害值 <= 0) return;

  const 来源hid = GetHandleId(反击来源);
  反击黑名单[来源hid] = true;

  try {
    UnitDamageTarget(
      反击来源,
      目标单位,
      伤害值,
      false,
      false,
      参数.攻击类型 ?? ATTACK_TYPE_NORMAL,
      参数.伤害类型 ?? DAMAGE_TYPE_NORMAL,
      参数.武器类型 ?? null
    );
  } finally {
    反击黑名单[来源hid] = false;
  }
}

/**
 * 播放反击特效
 */
function 播放反击特效(目标单位: any, 特效路径: string | undefined, 附着点: string | undefined): void {
  if (!特效路径 || !目标单位) return;
  const 实际附着点 = 附着点 ?? "origin";
  const eff = AddSpecialEffectTarget(特效路径, 目标单位, 实际附着点);
  if (eff != null) {
    DestroyEffect(eff);
  }
}

//=============================================================================
// 核心回调（模块级具名函数，用于JASS回调）
//=============================================================================

/**
 * 伤害事件回调 - 在最终伤害应用后触发
 * 使用 registerAppliedFinalDamageListener 确保捕获所有伤害
 */
function onFinalDamageApplied(
  target: any,
  attacker: any,
  applied: number,
  snapshot: 伤害类型快照
): void {
  if (!target || applied <= 0) return;

  const targetHid = GetHandleId(target);
  const 实例列表 = 反击实例映射[targetHid];
  if (!实例列表 || 实例列表.length === 0) return;

  debugLogForce("反击系统", "伤害回调触发 targetHid=", targetHid, "attackerHid=", attacker ? GetHandleId(attacker) : 0, "applied=", applied);

  // 检查来源是否在反击黑名单中（防止死循环）
  if (attacker) {
    const attackerHid = GetHandleId(attacker);
    if (反击黑名单[attackerHid] === true) {
      debugLogForce("反击系统", "跳过黑名单单位 hid=", attackerHid);
      return;
    }
  }

  // 获取当前伤害类型
  const 当前伤害类型 = 获取同类伤害类型(snapshot);
  const isNormalAtk = snapshot.isNormalAttack === true;

  for (const 实例 of 实例列表) {
    const 参数 = 实例.参数;

    // 1. 检查是否应该触发
    if (!应该触发反击(实例, isNormalAtk)) {
      continue;
    }

    // 2. 检查冷却
    if (在冷却中(实例)) {
      continue;
    }

    // 3. 检查伤害类型是否与反击伤害类型相同（同类型不反击，防止死循环）
    if (参数.伤害类型 != null) {
      const 反击伤害类型 = 获取同类伤害类型(snapshot);
      if (反击伤害类型.伤害类型 === 参数.伤害类型) {
        debugLogForce("反击系统", "同类伤害类型，跳过");
        continue;
      }
    }

    // 4. 如果只反击来源
    if (参数.只反击来源) {
      if (!attacker) continue;
      if (!计算距离并检查(实例, target, attacker)) continue;
      执行单次反击(实例, attacker, applied);
      continue;
    }

    // 5. AOE范围反击
    if (参数.是否AOE && 参数.AOE半径 != null && 参数.AOE半径 > 0) {
      执行AOE反击(实例, target, attacker, applied);
      continue;
    }

    // 6. 默认：只反击来源
    if (attacker) {
      if (!计算距离并检查(实例, target, attacker)) continue;
      执行单次反击(实例, attacker, applied);
    }
  }
}

/**
 * 计算距离并检查是否满足条件
 */
function 计算距离并检查(实例: 反击实例, 受伤单位: any, 伤害来源: any): boolean {
  const x1 = GetUnitX(受伤单位);
  const y1 = GetUnitY(受伤单位);
  const x2 = GetUnitX(伤害来源);
  const y2 = GetUnitY(伤害来源);
  const 距离 = 计算两点距离(x1, y1, x2, y2);
  return 距离满足条件(距离, 实例.参数.距离条件);
}

/**
 * 执行单次反击
 */
function 执行单次反击(实例: 反击实例, 目标: any, 受到伤害: number): void {
  const 伤害值 = 计算反击伤害(实例, 受到伤害);

  // 记录反击时间
  const 当前时间 = getGameTime();
  实例.上次反击时间 = 当前时间;

  // 执行伤害
  执行反击伤害(实例.参数.反击来源, 目标, 伤害值, 实例.参数);

  // 播放特效
  if (实例.参数.反击特效) {
    播放反击特效(目标, 实例.参数.反击特效, 实例.参数.特效附着点);
  }

  debugLogForce("反击系统", "单次反击 目标hid=", GetHandleId(目标), "伤害=", 伤害值);
}

/**
 * 执行AOE反击
 */
function 执行AOE反击(实例: 反击实例, 受伤单位: any, 伤害来源: any, 受到伤害: number): void {
  if (!实例.参数.AOE半径 || 实例.参数.AOE半径 <= 0) return;

  const x = GetUnitX(受伤单位);
  const y = GetUnitY(受伤单位);
  const 半径 = 实例.参数.AOE半径;

  debugLogForce("反击系统", "AOE反击 中心x=", x, "y=", y, "半径=", 半径);

  // 获取范围内敌对单位
  const 目标列表 = getEnemyUnitsInRange(受伤单位, x, y, 半径);
  if (!目标列表 || 目标列表.length === 0) return;

  const 伤害值 = 计算反击伤害(实例, 受到伤害);
  const 当前时间 = getGameTime();
  实例.上次反击时间 = 当前时间;

  for (const 目标 of 目标列表) {
    // 跳过受伤单位自身
    if (目标 === 受伤单位) continue;

    // 检查距离条件
    if (!计算距离并检查(实例, 受伤单位, 目标)) continue;

    // 执行伤害
    执行反击伤害(实例.参数.反击来源, 目标, 伤害值, 实例.参数);

    // 播放特效
    if (实例.参数.反击特效) {
      播放反击特效(目标, 实例.参数.反击特效, 实例.参数.特效附着点);
    }

    debugLogForce("反击系统", "AOE反击目标 hid=", GetHandleId(目标), "伤害=", 伤害值);
  }
}

//=============================================================================
// 对外接口
//=============================================================================

/**
 * 初始化系统（注册回调）
 */
function 初始化系统(): void {
  if (系统已初始化) return;
  系统已初始化 = true;
  registerAppliedFinalDamageListener(onFinalDamageApplied);
  debugLogForce("反击系统", "系统已初始化");
}

/**
 * 注册反击
 * @param 参数 反击参数
 * @returns 反击实例ID（单位handleId），失败返回0
 */
export function 注册反击(参数: 反击参数): number {
  if (!参数.反击来源) {
    debugLogForce("反击系统", "错误：反击来源为空");
    return 0;
  }

  // 初始化系统
  初始化系统();

  const 反击来源 = 参数.反击来源;
  const hid = GetHandleId(反击来源);

  // 获取或创建实例列表
  if (!反击实例映射[hid]) {
    反击实例映射[hid] = [];
  }

  const 实例: 反击实例 = {
    参数: {
      ...参数,
      反击类型: 参数.反击类型 ?? 反击类型.任意伤害,
      伤害计算方式: 参数.伤害计算方式 ?? 反击伤害类型.固定值,
      距离条件: 参数.距离条件 ?? {},
      是否AOE: 参数.是否AOE ?? false,
      只反击来源: 参数.只反击来源 ?? true,
    },
    上次反击时间: 0,
  };

  反击实例映射[hid].push(实例);

  debugLogForce("反击系统", "注册成功 单位hid=", hid, "伤害值=", 参数.伤害值, "是否AOE=", 参数.是否AOE);

  return hid;
}

/**
 * 移除单位的所有反击
 * @param 单位 反击来源单位
 */
export function 移除反击(单位: any): void {
  if (!单位) return;
  const hid = GetHandleId(单位);
  反击实例映射[hid] = [];
  debugLogForce("反击系统", "移除反击 单位hid=", hid);
}

/**
 * 移除单位的特定反击（根据索引）
 * @param 单位 反击来源单位
 * @param 索引 反击实例索引
 */
export function 移除特定反击(单位: any, 索引: number): void {
  if (!单位) return;
  const hid = GetHandleId(单位);
  const 列表 = 反击实例映射[hid];
  if (!列表 || 列表.length <= 索引) return;
  列表.splice(索引, 1);
  debugLogForce("反击系统", "移除特定反击 单位hid=", hid, "索引=", 索引);
}

/**
 * 获取单位的反击数量
 * @param 单位 反击来源单位
 * @returns 反击实例数量
 */
export function 获取反击数量(单位: any): number {
  if (!单位) return 0;
  const hid = GetHandleId(单位);
  const 列表 = 反击实例映射[hid];
  return 列表 !== undefined ? 列表.length : 0;
}

//=============================================================================
// 调试接口
//=============================================================================

export {};
