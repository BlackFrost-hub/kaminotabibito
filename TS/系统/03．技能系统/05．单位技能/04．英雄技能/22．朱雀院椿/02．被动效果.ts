/** @noSelfInFile */

import {
  朱雀院椿技能配置,
  朱雀院椿表现配置,
  朱雀院椿Buff配置,
  朱雀院椿被动配置,
} from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, id: string) => number;
};
const { getGameTime, addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getGameTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerPlayerHeroListener } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院椿技能配置.单位类型ID);
const VF场BuffID = 朱雀院椿Buff配置.VF场;
const VF残缺BuffID = 朱雀院椿Buff配置.VF残缺;
const 反击准备BuffID = 朱雀院椿Buff配置.反击准备;
const 一刀BuffID = 朱雀院椿Buff配置.一刀守势;
const 二刀BuffID = 朱雀院椿Buff配置.二刀攻势;
const 决斗BuffID = 朱雀院椿Buff配置.决斗距离;
const 被动配置 = 朱雀院椿被动配置;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, unit: any) => number;

//=============================================================================
// A1：按英雄句柄隔离的状态容器
//=============================================================================

export type 椿姿态 = "一刀" | "二刀";

export interface 椿英雄状态 {
  VF当前: number;
  VF残缺: boolean;
  反击准备到期: number;
  反击准备方向: number;
  反击准备来源: any;
  姿态: 椿姿态;
  决斗距离到期: number;
  决斗距离方向: number;
  VF恢复冷却到期: number;
  姿态锁: boolean;
  技能清理表: Record<string, (this: void) => void>;
}

const 英雄状态表: Record<number, 椿英雄状态 | undefined> = {};

function 取英雄状态(this: void, 英雄: any): 椿英雄状态 {
  const id = GetHandleId(英雄);
  let 状态 = 英雄状态表[id];
  if (状态 == null) {
    状态 = {
      VF当前: 被动配置.VF上限,
      VF残缺: false,
      反击准备到期: 0,
      反击准备方向: 0,
      反击准备来源: null,
      姿态: "一刀",
      决斗距离到期: 0,
      决斗距离方向: 0,
      VF恢复冷却到期: 0,
      姿态锁: false,
      技能清理表: {},
    };
    英雄状态表[id] = 状态;
    // 首次建状态：初始 VF 完整 + 初始一刀姿态（Buff 表自带特效；此前无调用方，新建/复活椿零防护）
    刷新VF表现(英雄, 状态);
    registerManualBuff(英雄, 一刀BuffID, 9999, 1, { stack: 1 });
  }
  return 状态;
}

/** 是否是朱雀院椿 */
export function 是朱雀院椿(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return jass.GetUnitTypeId(unit) === 英雄单位类型ID;
}

/** 登记技能清理函数（Q/W/E/R/D 模块调用；死亡/场景清理统一执行，幂等） */
export function 登记椿清理(this: void, 英雄: any, 名称: string, 清理: (this: void) => void): void {
  if (英雄 == null || 英雄 === 0) return;
  取英雄状态(英雄).技能清理表[名称] = 清理;
}

/** 幂等统一清理：死亡/复活重置/重复初始化/场景清理 */
export function 清理朱雀院椿状态(this: void, 英雄: any, _原因: string): void {
  if (英雄 == null || 英雄 === 0) return;
  const id = GetHandleId(英雄);
  const 状态 = 英雄状态表[id];
  if (状态 == null) return;
  移除单位指定Buff(英雄, VF场BuffID);
  移除单位指定Buff(英雄, VF残缺BuffID);
  移除单位指定Buff(英雄, 反击准备BuffID);
  移除单位指定Buff(英雄, 一刀BuffID);
  移除单位指定Buff(英雄, 二刀BuffID);
  移除单位指定Buff(英雄, 决斗BuffID);
  for (const key in 状态.技能清理表) {
    const 清理 = 状态.技能清理表[key];
    if (清理 != null) 清理();
  }
  delete 英雄状态表[id];
}

//=============================================================================
// A1：VF 场（真实伤害修改入口吸收；优先级低于招架，招架先化解）
//=============================================================================

export function 获取VF(this: void, 英雄: any): number {
  if (英雄 == null || 英雄 === 0) return 0;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null ? 状态.VF当前 : 0;
}

function 刷新VF表现(this: void, 英雄: any, 状态: 椿英雄状态): void {
  const 残缺 = 状态.VF当前 <= 0 || 状态.VF当前 < 被动配置.VF上限 * 被动配置.VF残缺阈值;
  状态.VF残缺 = 残缺;
  移除单位指定Buff(英雄, VF场BuffID);
  移除单位指定Buff(英雄, VF残缺BuffID);
  // 特效由 Buff 表 effect 字段统一管理（此前手动 createUnitEffect + Buff 双层特效）
  if (状态.VF当前 > 0) {
    if (残缺) {
      registerManualBuff(英雄, VF残缺BuffID, 9999, 1, { stack: 1 });
    } else {
      registerManualBuff(英雄, VF场BuffID, 9999, 状态.VF当前, { stack: 1 });
    }
  }
}

/** 初始化/重置 VF 到上限（死亡重置/复活/场景清理后重建状态时调用） */
export function 初始化VF(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 取英雄状态(英雄);
  状态.VF当前 = 被动配置.VF上限;
  状态.VF残缺 = false;
  刷新VF表现(英雄, 状态);
}

/** 恢复 VF（内部冷却：任何入口都不能靠攻速无限回满）；成功返回 true */
export function 恢复VF(this: void, 英雄: any, 量: number): boolean {
  if (英雄 == null || 英雄 === 0 || 量 <= 0) return false;
  const 状态 = 取英雄状态(英雄);
  const 现在 = getGameTime();
  if (现在 < 状态.VF恢复冷却到期) return false;
  状态.VF恢复冷却到期 = 现在 + 被动配置.VF恢复冷却秒;
  状态.VF当前 = 状态.VF当前 + 量 > 被动配置.VF上限 ? 被动配置.VF上限 : 状态.VF当前 + 量;
  刷新VF表现(英雄, 状态);
  return true;
}

/** 扣除 VF（二刀持续消耗等）；返回扣除后的剩余 */
export function 扣除VF(this: void, 英雄: any, 量: number): number {
  if (英雄 == null || 英雄 === 0 || 量 <= 0) return 0;
  const 状态 = 取英雄状态(英雄);
  状态.VF当前 = 状态.VF当前 - 量 < 0 ? 0 : 状态.VF当前 - 量;
  刷新VF表现(英雄, 状态);
  return 状态.VF当前;
}

// VF 伤害吸收修改器：优先级 40（低于招架 60，招架先化解，化解后余伤为 0 不再吸收）
let VF修改器ID = 0;

function 注册VF吸收(this: void): void {
  if (VF修改器ID !== 0) return;
  VF修改器ID = registerDamageModifier(function VF伤害吸收(this: void, context: any): number {
    const 单位 = context != null ? context.target : null;
    if (!是朱雀院椿(单位)) return context.currentDamage;
    // 取英雄状态：新建/复活英雄在注册回调未覆盖的路径（如未走英雄注册直接受击）也能完整初始化
    const 状态 = 取英雄状态(单位);
    if (状态.VF当前 <= 0) return context.currentDamage;
    if (context.currentDamage <= 0) return context.currentDamage;
    const 吸收 = context.currentDamage > 状态.VF当前 ? 状态.VF当前 : context.currentDamage;
    状态.VF当前 = 状态.VF当前 - 吸收;
    刷新VF表现(单位, 状态);
    // 只吸收不超过剩余的部分，超出继续结算
    return context.currentDamage - 吸收;
  }, 40);
}

//=============================================================================
// A1：反击准备（W 招架 / E 精确回锋 创建；普攻/Q/E 各消费一次）
//=============================================================================

export interface 反击准备数据 {
  方向: number;
  来源: any;
}

export function 有反击准备(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null && getGameTime() <= 状态.反击准备到期;
}

/** 创建反击准备（1.2s 窗口；刷新时重置到期；Buff 同步） */
export function 创建反击准备(this: void, 英雄: any, 方向: number, 来源: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 取英雄状态(英雄);
  状态.反击准备到期 = getGameTime() + 被动配置.反击准备持续秒;
  状态.反击准备方向 = 方向;
  状态.反击准备来源 = 来源 != null && 来源 !== 0 ? 来源 : null;
  registerManualBuff(英雄, 反击准备BuffID, 被动配置.反击准备持续秒, 1, { stack: 1 });
}

/** 消费反击准备（普攻/Q/E 各最多一次；无或过期返回 null） */
export function 消费反击准备(this: void, 英雄: any): 反击准备数据 | null {
  if (英雄 == null || 英雄 === 0) return null;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  if (状态 == null) return null;
  if (getGameTime() > 状态.反击准备到期) return null;
  状态.反击准备到期 = 0;
  移除单位指定Buff(英雄, 反击准备BuffID);
  return { 方向: 状态.反击准备方向, 来源: 状态.反击准备来源 };
}

//=============================================================================
// A1：一刀/二刀姿态（互斥；D 模块切换，Q/W/E/R 读取快照）
//=============================================================================

export function 获取姿态(this: void, 英雄: any): 椿姿态 {
  if (英雄 == null || 英雄 === 0) return "一刀";
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null ? 状态.姿态 : "一刀";
}

/** 设置姿态（互斥 Buff/特效；切换前由 D 模块校验可切换性） */
export function 设置姿态(this: void, 英雄: any, 姿态: 椿姿态): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 取英雄状态(英雄);
  if (状态.姿态 === 姿态) return;
  状态.姿态 = 姿态;
  移除单位指定Buff(英雄, 一刀BuffID);
  移除单位指定Buff(英雄, 二刀BuffID);
  // 姿态特效由 Buff 表 effect 字段统一管理（此前手动 createUnitEffect + Buff 双层特效）
  if (姿态 === "一刀") {
    registerManualBuff(英雄, 一刀BuffID, 9999, 1, { stack: 1 });
  } else {
    registerManualBuff(英雄, 二刀BuffID, 9999, 1, { stack: 1 });
  }
}

/** R 蓄力期间锁定姿态（D 不得中途改写本次 R 分支） */
export function 锁定姿态(this: void, 英雄: any, 锁定: boolean): void {
  if (英雄 == null || 英雄 === 0) return;
  取英雄状态(英雄).姿态锁 = 锁定;
}

export function 姿态是否锁定(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null && 状态.姿态锁;
}

//=============================================================================
// A1：决斗距离（E 建立；R 读取）
//=============================================================================

/** 设置决斗距离（默认 2.5s，供 R 读取方向） */
export function 设置决斗距离(this: void, 英雄: any, 方向: number, 持续秒: number): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 取英雄状态(英雄);
  状态.决斗距离到期 = getGameTime() + 持续秒;
  状态.决斗距离方向 = 方向;
  registerManualBuff(英雄, 决斗BuffID, 持续秒, 1, { stack: 1 });
}

export function 有决斗距离(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null && getGameTime() <= 状态.决斗距离到期;
}

export function 获取决斗距离方向(this: void, 英雄: any): number {
  if (英雄 == null || 英雄 === 0) return 0;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null && getGameTime() <= 状态.决斗距离到期 ? 状态.决斗距离方向 : 0;
}

/** 清除决斗距离（R 终式读取方向后消费） */
export function 清除决斗距离(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  if (状态 == null) return;
  状态.决斗距离到期 = 0;
  移除单位指定Buff(英雄, 决斗BuffID);
}

//=============================================================================
// A2：普攻反击斩（反击准备期间的第一次普攻）
//=============================================================================

function 处理椿普攻反击斩(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!是朱雀院椿(attacker)) return;
  if (snapshot == null) return;
  // 仅椿本人的正常普攻；技能伤害伪装普攻 / 反击斩自身造成的技能伤害一律跳过（防递归）
  if (snapshot.isNormalAttack !== true) return;
  if (snapshot.isWrappedSkillDamage === true) return;
  if (target == null || target === 0) return;
  const 状态 = 英雄状态表[GetHandleId(attacker)];
  if (状态 == null) return;
  if (getGameTime() > 状态.反击准备到期) return;
  // 消费反击准备
  状态.反击准备到期 = 0;
  移除单位指定Buff(attacker, 反击准备BuffID);
  // 反击斩：以本次普攻实际伤害为基准追加（普攻联动，不触发技能暴击）
  const 追加伤害 = applied * 被动配置.反击斩伤害倍率;
  造成技能伤害({
    来源: attacker,
    目标: target,
    伤害: 追加伤害,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 0,
    标签: "朱雀院椿-反击斩",
    伤害形态: "单体",
    参与技能伤害加成: false,
  });
  // 姿态收益：一刀偏 VF 恢复；二刀偏第二道斩光
  if (状态.姿态 === "一刀") {
    恢复VF(attacker, 被动配置.反击斩恢复VF);
  } else {
    造成技能伤害({
      来源: attacker,
      目标: target,
      伤害: applied * 被动配置.二刀反击斩额外倍率,
      伤害类型: DAMAGE_TYPE_NORMAL,
      攻击类型: ATTACK_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: 0,
      标签: "朱雀院椿-反击斩二刀",
      伤害形态: "单体",
      参与技能伤害加成: false,
    });
  }
}

//=============================================================================
// 注册入口（懒注册，幂等）
//=============================================================================

let 已注册 = false;
let 死亡监听已注册 = false;

function 确保死亡清理(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(function 朱雀院椿死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    if (是朱雀院椿(dyingUnit)) 清理朱雀院椿状态(dyingUnit, "英雄死亡");
  });
}

/** 注册朱雀院椿被动（VF 吸收 + 普攻反击斩 + 死亡清理；幂等） */
export function 注册朱雀院椿被动(this: void): void {
  if (已注册) return;
  已注册 = true;
  确保死亡清理();
  registerPlayerHeroListener(function 椿英雄注册初始化(this: void, _player: any, hero: any): void {
    // 英雄创建/选择即显式初始化（VF 满 + 初始一刀 Buff/特效），不依赖技能首次访问
    if (是朱雀院椿(hero)) 初始化VF(hero);
  });
  注册VF吸收();
  registerAppliedFinalDamageListener(处理椿普攻反击斩);
}

//=============================================================================
// A8：动作表现辅助（动作索引由配置驱动；0 = 未实机确认不播放）
//=============================================================================

/** 播放椿施法动作（接收动作槽，索引/持续秒全部配置驱动；0 跳过），持续后恢复 stand；随英雄清理移除恢复回调 */
export function 播放椿动作(this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }): void {
  const 动作索引 = 槽.索引;
  const 持续秒 = 槽.持续秒;
  if (英雄 == null || 英雄 === 0 || 动作索引 <= 0) return;
  jass.SetUnitAnimationByIndex(英雄, 动作索引);
  if (持续秒 > 0) {
    const 恢复ID = addDelayedCallback(持续秒 * 1000, function 恢复站立动作(this: void): void {
      if (单位存活(英雄)) jass.SetUnitAnimation(英雄, "stand");
    });
    登记椿清理(英雄, "椿动作-" + 动作索引, function 动作恢复清理(this: void): void {
      removeDelayedCallback(恢复ID);
    });
  }
}

export const 朱雀院椿被动模块 = {
  英雄ID: 朱雀院椿技能配置.单位类型ID,
  注册: 注册朱雀院椿被动,
} as const;
