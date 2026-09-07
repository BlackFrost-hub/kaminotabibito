/** @noSelfInFile */

import {
  朱雀院椿技能配置,
  朱雀院椿表现配置,
  朱雀院椿Buff配置,
  朱雀院椿被动配置,
  朱雀院椿音效配置,
  朱雀院椿读条配置,
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
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number, 动画索引?: number, 面向弧度?: number, RGB?: any) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 创建世界坐标进度UI, 更新世界坐标进度UI, 销毁世界坐标进度UI } = require("系统.09．表现系统.15．世界坐标进度UI.01．世界坐标进度UI") as {
  创建世界坐标进度UI: (this: void, 参数: any) => any;
  更新世界坐标进度UI: (this: void, ui: any, 当前值: number, 立即更新?: boolean) => void;
  销毁世界坐标进度UI: (this: void, ui: any) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院椿技能配置.单位类型ID);
const VF场BuffID = 朱雀院椿Buff配置.VF场;
const VF残缺BuffID = 朱雀院椿Buff配置.VF残缺;
const 反击准备BuffID = 朱雀院椿Buff配置.反击准备;
const 一刀BuffID = 朱雀院椿Buff配置.一刀守势;
const 二刀BuffID = 朱雀院椿Buff配置.二刀攻势;
const 被动配置 = 朱雀院椿被动配置;

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, unit: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;

//=============================================================================
// A1：按英雄句柄隔离的状态容器
//=============================================================================

export type 椿姿态 = "一刀" | "二刀";

export interface 椿英雄状态 {
  VF当前: number;
  VF残缺: boolean;
  /** VF 归零后首次透传实际伤害是否已告警（一次性日志防刷屏） */
  VF归零透传已告警: boolean;
  /** 护盾特效是否已展开（首次受击吸收后 true；之后保持显示直到 VF 归零） */
  护盾已展开: boolean;
  /** VF 常驻世界坐标读条句柄（随 VF 变化实时更新；清理时销毁） */
  VF读条UI: any;
  反击准备到期: number;
  反击准备方向: number;
  反击准备来源: any;
  姿态: 椿姿态;
  决斗距离到期: number;
  决斗距离方向: number;
  /** E 冲锋命中的决斗目标单位（R 锁定时特效锚点＝该单位脚下；存活为优先，死亡退到快照点） */
  决斗距离目标单位: any;
  /** E 释放时的施法目标点快照（决斗目标死亡时兜底） */
  决斗距离目标X: number;
  决斗距离目标Y: number;
  VF恢复冷却到期: number;
  姿态锁: boolean;
  技能清理表: Record<string, (this: void) => void>;
}

const 英雄状态表: Record<number, 椿英雄状态 | undefined> = {};
const VF特效键 = "朱雀院椿VF场";
const 姿态特效键 = "朱雀院椿姿态";

function 取英雄状态(this: void, 英雄: any): 椿英雄状态 {
  const id = GetHandleId(英雄);
  let 状态 = 英雄状态表[id];
  if (状态 == null) {
    状态 = {
      VF当前: 被动配置.VF上限,
      VF残缺: false,
      VF归零透传已告警: false,
      护盾已展开: false,
      VF读条UI: null,
      反击准备到期: 0,
      反击准备方向: 0,
      反击准备来源: null,
      姿态: "一刀",
      决斗距离到期: 0,
      决斗距离方向: 0,
      决斗距离目标单位: null,
      决斗距离目标X: 0,
      决斗距离目标Y: 0,
      VF恢复冷却到期: 0,
      姿态锁: false,
      技能清理表: {},
    };
    英雄状态表[id] = 状态;
    // 首次建状态：初始 VF 完整 + 初始一刀姿态（Buff 表自带特效；此前无调用方，新建/复活椿零防护）
    刷新VF表现(英雄, 状态);
    debugLogForce("椿-被动", "Buff", "操作", "施加", "目标", GetHandleId(英雄), "Buff", 一刀BuffID);
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
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", VF场BuffID);
  移除单位指定Buff(英雄, VF场BuffID);
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", VF残缺BuffID);
  移除单位指定Buff(英雄, VF残缺BuffID);
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", 反击准备BuffID);
  移除单位指定Buff(英雄, 反击准备BuffID);
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", 一刀BuffID);
  移除单位指定Buff(英雄, 一刀BuffID);
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", 二刀BuffID);
  移除单位指定Buff(英雄, 二刀BuffID);
  // 删除英雄状态表[id] 之前先销毁 VF 读条
  销毁单位坐标跟随特效(英雄, VF特效键);
  销毁单位坐标跟随特效(英雄, 姿态特效键);
  if (状态.VF读条UI != null) {
    销毁世界坐标进度UI(状态.VF读条UI);
    状态.VF读条UI = null;
  }
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
  // 跳变判定：上一次刷新的 VF残缺 标记覆盖"无（VF归零）/残缺"两种旧状态，本次回到完整即为跳变
  const 之前残缺 = 状态.VF残缺;
  状态.VF残缺 = 残缺;
  if (残缺 !== 之前残缺) {
    debugLogForce("椿-被动", "VF", "状态", 残缺 ? "残缺进入" : "残缺恢复", "玩家", GetPlayerId(GetOwningPlayer(英雄)) + 1, "当前VF", 状态.VF当前);
  }
  移除单位指定Buff(英雄, VF场BuffID);
  移除单位指定Buff(英雄, VF残缺BuffID);
  // VF 常驻读条：创建一次，此后随每次刷新同步数值（与技能读条同锚点，屏幕 Y 偏移置上方并行显示）
  if (状态.VF读条UI == null) {
    状态.VF读条UI = 创建世界坐标进度UI({
      X: GetUnitX(英雄),
      Y: GetUnitY(英雄),
      Z: 0,
      跟随单位: 英雄,
      跟随Z偏移: 朱雀院椿读条配置.跟随Z偏移,
      屏幕Y偏移: 朱雀院椿读条配置.VF读条.屏幕Y偏移,
      最大值: 被动配置.VF上限,
      当前值: 状态.VF当前,
      标题: 朱雀院椿读条配置.VF读条.标题,
      数值后缀: 朱雀院椿读条配置.VF读条.数值后缀,
      类型: 朱雀院椿读条配置.VF读条.UI类型 as any,
      平滑过渡秒: 0.05,
      初始显示: true,
    });
  } else {
    更新世界坐标进度UI(状态.VF读条UI, 状态.VF当前);
  }
  // 护盾特效手动管理：开局不显示；首次受击吸收后展开（残缺切换破损版）；VF 归零销毁
  if (状态.VF当前 <= 0) {
    if (状态.护盾已展开) {
      销毁单位坐标跟随特效(英雄, VF特效键);
      状态.护盾已展开 = false;
    }
  } else if (状态.护盾已展开) {
    销毁单位坐标跟随特效(英雄, VF特效键);
    创建单位坐标跟随特效(
      英雄,
      残缺 ? 朱雀院椿表现配置.VF残缺.模型路径 : 朱雀院椿表现配置.VF完整.模型路径,
      VF特效键,
      残缺 ? 朱雀院椿表现配置.VF残缺.缩放 : 朱雀院椿表现配置.VF完整.缩放,
      残缺 ? 朱雀院椿表现配置.VF残缺.高度 : 朱雀院椿表现配置.VF完整.高度,
      1,
      undefined,
      0,
      残缺 ? 朱雀院椿表现配置.VF残缺.RGB : 朱雀院椿表现配置.VF完整.RGB,
    );
  }
  if (状态.VF当前 > 0) {
    if (残缺) {
      registerManualBuff(英雄, VF残缺BuffID, 9999, 1, { stack: 1 });
    } else {
      registerManualBuff(英雄, VF场BuffID, 9999, 状态.VF当前, { stack: 1 });
      // VF 场展开音：仅"无/残缺→完整"跳变且护盾已展开时播一次（常规刷新/初始化满 VF 不播；单位=施法者，参数配置驱动）
      if (之前残缺 && 状态.护盾已展开) {
        Sound3DII_UnitPlayReuse(朱雀院椿音效配置.VF展开.路径, 英雄, 朱雀院椿音效配置.VF展开.裁断距离);
      }
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
  if (现在 < 状态.VF恢复冷却到期) {
    debugLogForce("椿-被动", "VF", "操作", "恢复失败", "原因", "内部冷却", "玩家", GetPlayerId(GetOwningPlayer(英雄)) + 1, "量", 量);
    return false;
  }
  状态.VF恢复冷却到期 = 现在 + 被动配置.VF恢复冷却秒;
  状态.VF当前 = 状态.VF当前 + 量 > 被动配置.VF上限 ? 被动配置.VF上限 : 状态.VF当前 + 量;
  刷新VF表现(英雄, 状态);
  debugLogForce("椿-被动", "VF", "操作", "恢复", "玩家", GetPlayerId(GetOwningPlayer(英雄)) + 1, "量", 量, "当前VF", 状态.VF当前);
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
    if (状态.VF当前 <= 0) {
      // 彻底归零：透传真实伤害。首次透传打一次告警（防止每次挨打刷屏；归零后不再反复打）
      if (!状态.VF归零透传已告警) {
        状态.VF归零透传已告警 = true;
        debugLogForce("椿-被动", "VF", "状态", "归零透传", "玩家", GetPlayerId(GetOwningPlayer(单位)) + 1, "第一次余伤", context.currentDamage, "剩余VF", 状态.VF当前);
      }
      return context.currentDamage;
    }
    if (context.currentDamage <= 0) return context.currentDamage;
    const 吸收 = context.currentDamage > 状态.VF当前 ? 状态.VF当前 : context.currentDamage;
    状态.VF当前 = 状态.VF当前 - 吸收;
    if (!状态.护盾已展开) 状态.护盾已展开 = true;
    刷新VF表现(单位, 状态);
    debugLogForce("椿-被动", "VF", "操作", "吸收", "玩家", GetPlayerId(GetOwningPlayer(单位)) + 1, "吸收", 吸收, "剩余VF", 状态.VF当前, "余伤", context.currentDamage - 吸收);
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
  状态.反击准备到期 = getGameTime() + 被动配置.反击准备持续秒 * 1000;
  状态.反击准备方向 = 方向;
  状态.反击准备来源 = 来源 != null && 来源 !== 0 ? 来源 : null;
  debugLogForce("椿-被动", "Buff", "操作", "施加", "目标", GetHandleId(英雄), "Buff", 反击准备BuffID);
  registerManualBuff(英雄, 反击准备BuffID, 被动配置.反击准备持续秒, 1, { stack: 1 });
}

/** 消费反击准备（普攻/Q/E 各最多一次；无或过期返回 null） */
export function 消费反击准备(this: void, 英雄: any): 反击准备数据 | null {
  if (英雄 == null || 英雄 === 0) return null;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  if (状态 == null) return null;
  if (getGameTime() > 状态.反击准备到期) return null;
  状态.反击准备到期 = 0;
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", 反击准备BuffID);
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
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", 一刀BuffID);
  移除单位指定Buff(英雄, 一刀BuffID);
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(英雄), "Buff", 二刀BuffID);
  移除单位指定Buff(英雄, 二刀BuffID);
  // 姿态特效由 Buff 表 effect 字段统一管理（此前手动 createUnitEffect + Buff 双层特效）
  if (姿态 === "一刀") {
    debugLogForce("椿-被动", "Buff", "操作", "施加", "目标", GetHandleId(英雄), "Buff", 一刀BuffID);
    registerManualBuff(英雄, 一刀BuffID, 9999, 1, { stack: 1 });
  } else {
    debugLogForce("椿-被动", "Buff", "操作", "施加", "目标", GetHandleId(英雄), "Buff", 二刀BuffID);
    registerManualBuff(英雄, 二刀BuffID, 9999, 1, { stack: 1 });
  }
  // 姿态光环特效手动管理：切姿态时更新（开局初始一刀不显示；D 切换/到期回刀时可见）
  销毁单位坐标跟随特效(英雄, 姿态特效键);
  创建单位坐标跟随特效(
    英雄,
    姿态 === "一刀" ? 朱雀院椿表现配置.D一刀守势.模型路径 : 朱雀院椿表现配置.D二刀攻势.模型路径,
    姿态特效键,
    姿态 === "一刀" ? 朱雀院椿表现配置.D一刀守势.缩放 : 朱雀院椿表现配置.D二刀攻势.缩放,
    姿态 === "一刀" ? 朱雀院椿表现配置.D一刀守势.高度 : 朱雀院椿表现配置.D二刀攻势.高度,
    1,
    undefined,
    0,
    姿态 === "一刀" ? 朱雀院椿表现配置.D一刀守势.RGB : 朱雀院椿表现配置.D二刀攻势.RGB,
  );
}

/** R 蓄力期间锁定姿态（D 不得中途改写本次 R 分支） */
export function 锁定姿态(this: void, 英雄: any, 锁定: boolean): void {
  if (英雄 == null || 英雄 === 0) return;
  取英雄状态(英雄).姿态锁 = 锁定;
  debugLogForce("椿-被动", "状态", "姿态锁", "玩家", GetPlayerId(GetOwningPlayer(英雄)) + 1, "锁定", 锁定);
}

export function 姿态是否锁定(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null && 状态.姿态锁;
}

//=============================================================================
// A1：决斗距离（E 建立；R 读取）
//=============================================================================

/** 设置决斗距离（默认 2.5s，供 R 读取方向/锚点）；规划明确该状态不进玩家 Buff 栏，仅维护内部数据 */
export function 设置决斗距离(this: void, 英雄: any, 方向: number, 持续秒: number, 目标单位?: any, 兜底X?: number, 兜底Y?: number): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 取英雄状态(英雄);
  状态.决斗距离到期 = getGameTime() + 持续秒 * 1000;
  状态.决斗距离方向 = 方向;
  状态.决斗距离目标单位 = 目标单位 ?? null;
  状态.决斗距离目标X = 兜底X ?? 0;
  状态.决斗距离目标Y = 兜底Y ?? 0;
  debugLogForce("椿-被动", "状态", "决斗距离建立", "玩家", GetPlayerId(GetOwningPlayer(英雄)) + 1, "方向", 方向, "持续秒", 持续秒, "目标单位", 目标单位 ?? "-");
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

/** 获取决斗距离的特效锚点：目标单位存活 → 该单位脚下；死亡 → E 目标点快照兜底；均无 → null */
export function 获取决斗距离锚点(this: void, 英雄: any): { X: number; Y: number } | null {
  if (英雄 == null || 英雄 === 0) return null;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  if (状态 == null || getGameTime() > 状态.决斗距离到期) return null;
  const 单位 = 状态.决斗距离目标单位;
  if (单位 != null && 单位 !== 0 && 单位存活(单位)) {
    return { X: GetUnitX(单位), Y: GetUnitY(单位) };
  }
  if (状态.决斗距离目标X !== 0 || 状态.决斗距离目标Y !== 0) {
    return { X: 状态.决斗距离目标X, Y: 状态.决斗距离目标Y };
  }
  return null;
}

/** 清除决斗距离（R 终式读取方向后消费） */
export function 清除决斗距离(this: void, 英雄: any): void {
  if (英雄 == null || 英雄 === 0) return;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  if (状态 == null) return;
  状态.决斗距离到期 = 0;
  debugLogForce("椿-被动", "状态", "决斗距离消费", "玩家", GetPlayerId(GetOwningPlayer(英雄)) + 1);
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
  if (getGameTime() > 状态.反击准备到期) {
    // 过期后第一次普攻告警一次（到期归零后不再重复；正常普攻不产生任何反击斩日志）
    if (状态.反击准备到期 > 0) {
      状态.反击准备到期 = 0;
      debugLogForce("椿-被动", "状态", "反击准备过期", "玩家", GetPlayerId(GetOwningPlayer(attacker)) + 1, "目标", GetUnitName(target), "handle", target);
    }
    return;
  }
  // 消费反击准备
  状态.反击准备到期 = 0;
  debugLogForce("椿-被动", "Buff", "操作", "移除", "目标", GetHandleId(attacker), "Buff", 反击准备BuffID);
  移除单位指定Buff(attacker, 反击准备BuffID);
  const 反击方向 = 两点角度(GetUnitX(attacker), GetUnitY(attacker), GetUnitX(target), GetUnitY(target));
  创建点特效({
    模型路径: 朱雀院椿表现配置.普攻反击斩.模型路径,
    RGB: 朱雀院椿表现配置.普攻反击斩.RGB,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    Z: 朱雀院椿表现配置.普攻反击斩.高度,
    面向角度: 反击方向,
    缩放: 朱雀院椿表现配置.普攻反击斩.缩放,
    持续秒: 朱雀院椿表现配置.普攻反击斩.持续秒,
  });
  创建点特效({
    模型路径: 朱雀院椿表现配置.命中星爆.模型路径,
    RGB: 朱雀院椿表现配置.命中星爆.RGB,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    Z: 朱雀院椿表现配置.命中星爆.高度,
    面向角度: 反击方向,
    缩放: 朱雀院椿表现配置.命中星爆.缩放,
    持续秒: 朱雀院椿表现配置.命中星爆.持续秒,
  });
  // 反击斩：以本次普攻实际伤害为基准追加（普攻联动，不触发技能暴击）
  const 追加伤害 = applied * 被动配置.反击斩伤害倍率;
  debugLogForce("椿-被动", "命中", "标签", "朱雀院椿-反击斩", "玩家", GetPlayerId(GetOwningPlayer(attacker)) + 1, "目标", GetUnitName(target), "handle", target, "X", Math.floor(GetUnitX(target)), "Y", Math.floor(GetUnitY(target)), "伤害", 追加伤害);
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
    debugLogForce("椿-被动", "命中", "标签", "朱雀院椿-反击斩二刀", "玩家", GetPlayerId(GetOwningPlayer(attacker)) + 1, "目标", GetUnitName(target), "handle", target, "X", Math.floor(GetUnitX(target)), "Y", Math.floor(GetUnitY(target)), "伤害", applied * 被动配置.二刀反击斩额外倍率);
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
    if (是朱雀院椿(dyingUnit)) {
      debugLogForce("椿-被动", "回调", "类型", "死亡", "单位", GetHandleId(dyingUnit), "玩家", GetPlayerId(GetOwningPlayer(dyingUnit)) + 1);
      清理朱雀院椿状态(dyingUnit, "英雄死亡");
    }
  });
}

/** 注册朱雀院椿被动（VF 吸收 + 普攻反击斩 + 死亡清理；幂等） */
export function 注册朱雀院椿被动(this: void): void {
  debugLogForce("椿-被动", "注册", "名称", "注册朱雀院椿被动");
  if (已注册) return;
  已注册 = true;
  确保死亡清理();
  registerPlayerHeroListener(function 椿英雄注册初始化(this: void, _player: any, hero: any): void {
    if (hero == null || hero === 0) return;
    // 英雄创建/选择即显式初始化（VF 满 + 初始一刀 Buff/特效），不依赖技能首次访问
    if (是朱雀院椿(hero)) {
      debugLogForce("椿-被动", "回调", "类型", "英雄注册", "单位", GetHandleId(hero), "玩家", GetPlayerId(GetOwningPlayer(hero)) + 1);
      初始化VF(hero);
    }
  });
  注册VF吸收();
  registerAppliedFinalDamageListener(处理椿普攻反击斩);
}

//=============================================================================
// A8：动作表现辅助（动作索引由配置驱动；0 = 未实机确认不播放）
//=============================================================================

/** 播放椿施法动作（接收动作槽，索引/持续秒/播放速度全部配置驱动；0 跳过），持续后恢复 stand；随英雄清理移除恢复回调 */
export function 播放椿动作(this: void, 英雄: any, 槽: { 索引: number; 持续秒: number; 播放速度?: number }): void {
  const 动作索引 = 槽.索引;
  const 持续秒 = 槽.持续秒;
  if (英雄 == null || 英雄 === 0 || 动作索引 <= 0) return;
  jass.SetUnitAnimationByIndex(英雄, 动作索引);
  const 播放速度 = 槽.播放速度 != null && 槽.播放速度 > 0 ? 槽.播放速度 : 1;
  if (播放速度 !== 1) jass.SetUnitTimeScale(英雄, 播放速度);
  if (持续秒 > 0) {
    const 恢复ID = addDelayedCallback(持续秒 * 1000, function 恢复站立动作(this: void): void {
      if (单位存活(英雄)) {
        if (播放速度 !== 1) jass.SetUnitTimeScale(英雄, 1.0);
        jass.SetUnitAnimation(英雄, "stand");
      }
    });
    登记椿清理(英雄, "椿动作-" + 动作索引, function 动作恢复清理(this: void): void {
      removeDelayedCallback(恢复ID);
      if (播放速度 !== 1 && 单位存活(英雄)) jass.SetUnitTimeScale(英雄, 1.0);
    });
  }
}

export const 朱雀院椿被动模块 = {
  英雄ID: 朱雀院椿技能配置.单位类型ID,
  注册: 注册朱雀院椿被动,
} as const;
