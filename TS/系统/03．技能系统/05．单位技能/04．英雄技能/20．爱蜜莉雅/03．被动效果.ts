/** @noSelfInFile */
/**
 * 爱蜜莉雅 - 被动效果：寒意 / 冻结 / 霜裂 / 碎冰（A2）
 *
 * - 寒意：目标层数标记（Buff 层数承载），叠满 爱蜜莉雅被动配置.寒意阈值 触发冻结。
 * - 冻结：真实控制（具名暂停 添加单位暂停(目标, "爱蜜莉雅-冻结")）+ 冰壳特效；冻结结束转霜裂。
 * - 冻结抗性窗口：冻结结束后的 冻结抗性秒 内不再被爱蜜莉雅冻结（防 Q/W/R 无限控制）。
 * - 霜裂：冻结结束后的短期标记；下一次爱蜜莉雅技能命中触发碎冰强化伤害。
 * - 碎冰/冻结同技能实例去重：同一技能实例对同一目标只触发一次（规划约束）。
 * - 目标死亡解除冻结；施法者死亡解除其施放的冻结控制（规划 9.8 清理表）。
 * - 统一命中结算入口：各技能命中调用 结算爱蜜莉雅技能命中 —— 碎冰优先、受控目标增伤、施加寒意。
 */

import { 爱蜜莉雅技能配置, 爱蜜莉雅被动配置, 爱蜜莉雅冰晶配置, 爱蜜莉雅音效配置 } from "./00．配置";
import { 爱蜜莉雅BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/20．爱蜜莉雅";
import {
  创建爱蜜莉雅冰晶,
  移除爱蜜莉雅冰晶,
  查询爱蜜莉雅冰晶,
  登记爱蜜莉雅技能清理,
  清理爱蜜莉雅状态,
} from "./02．公共状态与冰晶";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { Sound3DII_UnitPlayReuse, Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};

const { registerManualBuff, 移除单位指定Buff, 获取单位Buff层数 } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
  获取单位Buff层数: (this: void, unit: any, buffID: string) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力, 单位存活, 取单位ID, 距离平方XY } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  取单位ID: (this: void, unit: any) => number;
  距离平方XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { addDelayedCallback, removeDelayedCallback, getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getGameTime: (this: void) => number;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const 英雄单位类型ID = jass.FourCC(爱蜜莉雅技能配置.单位类型ID) as number;
const 冻结暂停来源 = "爱蜜莉雅-冻结";

//=============================================================================
// 被动目标状态表（按目标句柄）
//=============================================================================

interface 被动目标状态 {
  /** 目标单位引用（施法者死亡解除冻结时使用） */
  目标单位: any;
  寒意层数: number;
  寒意到期: number;
  冻结中: boolean;
  冻结回调ID: number;
  冻结施法者: any;
  /** 冻结结束时刻（用于抗性窗口判定） */
  冻结结束时间: number;
  霜裂到期: number;
  霜裂回调ID: number;
}

const 被动目标表: Record<number, 被动目标状态 | undefined> = {};
/** 冻结去重：目标句柄 → 来源键 → true（同技能实例不重复冻结） */
const 冻结去重表: Record<number, Record<string, boolean | undefined> | undefined> = {};
/** 碎冰去重：目标句柄 → 来源键 → true（同技能实例只触发一次碎冰） */
const 碎冰去重表: Record<number, Record<string, boolean | undefined> | undefined> = {};
let 死亡监听已注册 = false;

function 目标状态(this: void, 目标: any): 被动目标状态 {
  const id = 取单位ID(目标);
  let 状态 = 被动目标表[id];
  if (状态 == null) {
    状态 = {
      目标单位: 目标,
      寒意层数: 0,
      寒意到期: 0,
      冻结中: false,
      冻结回调ID: 0,
      冻结施法者: null,
      冻结结束时间: 0,
      霜裂到期: 0,
      霜裂回调ID: 0,
    };
    被动目标表[id] = 状态;
  }
  return 状态;
}

/** 判断单位是否为爱蜜莉雅 */
export function 是爱蜜莉雅(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return GetUnitTypeId(unit) === 英雄单位类型ID;
}

/** 目标当前是否处于冻结抗性窗口（冻结结束后 冻结抗性秒 内） */
function 处于冻结抗性(this: void, 状态: 被动目标状态): boolean {
  if (状态.冻结结束时间 <= 0) return false;
  return getGameTime() < 状态.冻结结束时间 + 爱蜜莉雅被动配置.冻结抗性秒 * 1000;
}

/** 目标当前是否霜裂（霜裂标记未过期） */
export function 目标处于霜裂(this: void, 目标: any): boolean {
  const 状态 = 被动目标表[取单位ID(目标)];
  if (状态 == null) return false;
  return getGameTime() < 状态.霜裂到期;
}

/** 目标当前是否冻结中 */
export function 目标处于冻结(this: void, 目标: any): boolean {
  const 状态 = 被动目标表[取单位ID(目标)];
  if (状态 == null) return false;
  return 状态.冻结中;
}

//=============================================================================
// 冻结结束 → 霜裂
//=============================================================================

function 施加霜裂(this: void, 目标: any): void {
  if (目标 == null || 目标 === 0 || !单位存活(目标)) return;
  const 状态 = 目标状态(目标);
  状态.霜裂到期 = getGameTime() + 爱蜜莉雅被动配置.霜裂秒 * 1000;
  registerManualBuff(目标, 爱蜜莉雅BuffID.霜裂, 爱蜜莉雅被动配置.霜裂秒, 0);
  if (状态.霜裂回调ID !== 0) removeDelayedCallback(状态.霜裂回调ID);
  状态.霜裂回调ID = addDelayedCallback(爱蜜莉雅被动配置.霜裂秒 * 1000, function 霜裂到期清理(this: void): void {
    状态.霜裂回调ID = 0;
    移除单位指定Buff(目标, 爱蜜莉雅BuffID.霜裂);
  });
}

function 解冻目标(this: void, 目标: any, 状态: 被动目标状态): void {
  if (状态.冻结回调ID !== 0) {
    removeDelayedCallback(状态.冻结回调ID);
    状态.冻结回调ID = 0;
  }
  移除单位暂停(目标, 冻结暂停来源);
  移除单位指定Buff(目标, 爱蜜莉雅BuffID.冻结);
  状态.冻结中 = false;
  状态.冻结结束时间 = getGameTime();
}

function 冻结结束(this: void, 目标: any, 状态: 被动目标状态): void {
  状态.冻结回调ID = 0;
  if (目标 == null || 目标 === 0 || !单位存活(目标)) {
    状态.冻结中 = false;
    return;
  }
  解冻目标(目标, 状态);
  // 冻结解除碎裂音：复用 Q命中 槽（冻结自然到期解除、冰壳碎裂时一次；上方存活校验保证目标有效；死亡解除不播，参数配置驱动）
  Sound3DII_CooPlayReuse(爱蜜莉雅音效配置.Q命中.路径, GetUnitX(目标), GetUnitY(目标), 爱蜜莉雅音效配置.Q命中.高度, 爱蜜莉雅音效配置.Q命中.裁断距离);
  施加霜裂(目标);
}

/** 冻结目标（内部：含抗性窗口与同技能实例去重） */
export function 冻结爱蜜莉雅目标(this: void, 施法者: any, 目标: any, 来源键: string): boolean {
  if (施法者 == null || 目标 == null || 目标 === 0 || !单位存活(目标)) return false;
  const id = 取单位ID(目标);
  const 状态 = 目标状态(目标);
  if (状态.冻结中) return false;
  if (处于冻结抗性(状态)) return false;
  // 同技能实例对同一目标不重复触发冻结（规划约束）
  let 去重 = 冻结去重表[id];
  if (去重 == null) {
    去重 = {};
    冻结去重表[id] = 去重;
  }
  if (去重[来源键] === true) return false;
  去重[来源键] = true;

  // 冻结：具名暂停（真实控制）+ Buff + 冰壳特效 + 结束回调
  添加单位暂停(目标, 冻结暂停来源);
  状态.冻结中 = true;
  状态.冻结施法者 = 施法者;
  registerManualBuff(目标, 爱蜜莉雅BuffID.冻结, 爱蜜莉雅被动配置.冻结秒, 0);
  createTimedUnitEffect(目标, "origin", "Common\\Effect\\Element\\Ice\\sem_shen_du_dong_jie.mdx", 爱蜜莉雅被动配置.冻结秒);
  // 冻结包裹音：目标被冻结的状态建立时一次（冻结中/抗性/同实例去重均已在上方拦截，状态转移单次触发；单位=目标，参数配置驱动）
  Sound3DII_UnitPlayReuse(爱蜜莉雅音效配置.冻结包裹.路径, 目标, 爱蜜莉雅音效配置.冻结包裹.裁断距离);
  状态.冻结回调ID = addDelayedCallback(爱蜜莉雅被动配置.冻结秒 * 1000, function 冻结到期(this: void): void {
    冻结结束(目标, 状态);
  });
  return true;
}

//=============================================================================
// 寒意与碎冰
//=============================================================================

/** 施加一层寒意；叠满阈值触发冻结（返回是否触发冻结） */
export function 施加爱蜜莉雅寒意(this: void, 施法者: any, 目标: any, 来源键: string): boolean {
  if (施法者 == null || 目标 == null || 目标 === 0 || !单位存活(目标)) return false;
  const 状态 = 目标状态(目标);
  const now = getGameTime();
  const 当前层数 = now < 状态.寒意到期 ? 状态.寒意层数 : 0;
  const 新层数 = 当前层数 + 1;
  状态.寒意层数 = 新层数;
  状态.寒意到期 = now + 爱蜜莉雅被动配置.寒意持续秒 * 1000;
  registerManualBuff(目标, 爱蜜莉雅BuffID.寒意, 爱蜜莉雅被动配置.寒意持续秒, 新层数, {
    stack: 新层数,
    sourceUnit: 施法者,
  });
  if (新层数 >= 爱蜜莉雅被动配置.寒意阈值) {
    冻结爱蜜莉雅目标(施法者, 目标, 来源键);
    return true;
  }
  return false;
}

/** 触发碎冰强化伤害（霜裂目标 + 同技能实例去重） */
export function 触发爱蜜莉雅碎冰(this: void, 施法者: any, 目标: any, 来源键: string, 技能ID: number, 技能实例ID: number | undefined): boolean {
  if (施法者 == null || 目标 == null || 目标 === 0 || !单位存活(目标)) return false;
  if (!目标处于霜裂(目标)) return false;
  const id = 取单位ID(目标);
  let 去重 = 碎冰去重表[id];
  if (去重 == null) {
    去重 = {};
    碎冰去重表[id] = 去重;
  }
  if (去重[来源键] === true) return false;
  去重[来源键] = true;

  const 伤害 = 读取单位攻击力(施法者) * 爱蜜莉雅被动配置.碎冰攻击力倍率;
  造成技能伤害({
    来源: 施法者,
    目标,
    伤害,
    伤害类型: DAMAGE_TYPE_COLD,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID,
    技能实例ID,
    标签: "爱蜜莉雅-碎冰",
    伤害形态: "单体",
    参与技能伤害加成: false,
  });
  // 消费霜裂标记
  移除单位指定Buff(目标, 爱蜜莉雅BuffID.霜裂);
  const 状态 = 被动目标表[id];
  if (状态 != null) 状态.霜裂到期 = 0;
  return true;
}

/** 目标是否处于受控状态（冻结/减速/霜裂）——用于伤害增益判定；减速状态由 W/R 区域标记查询 */
export function 目标受控增伤(this: void, 目标: any): boolean {
  if (目标处于冻结(目标) || 目标处于霜裂(目标)) return true;
  // 减速：查询外部减速标记（W/R 区域会登记目标），此处由技能侧传入；默认 false
  return false;
}

export interface 爱蜜莉雅技能命中参数 {
  伤害值: number;
  技能ID: number;
  技能实例ID?: number;
  标签: string;
  伤害类型?: any;
}

/**
 * 统一命中结算入口：各技能命中调用。
 * 顺序：① 霜裂目标优先碎冰（额外强化伤害）→ ② 受控目标伤害增益 → ③ 施加寒意。
 */
export function 结算爱蜜莉雅技能命中(
  this: void,
  施法者: any,
  目标: any,
  来源键: string,
  参数: 爱蜜莉雅技能命中参数,
): boolean {
  if (施法者 == null || 目标 == null || 目标 === 0 || !单位存活(目标)) return false;
  let 伤害 = 参数.伤害值;
  // ① 碎冰（霜裂目标；同技能实例只一次）
  触发爱蜜莉雅碎冰(施法者, 目标, 来源键, 参数.技能ID, 参数.技能实例ID);
  // ② 受控增伤
  if (目标受控增伤(目标)) {
    伤害 = 伤害 * (1 + 爱蜜莉雅被动配置.对受控目标伤害倍率);
  }
  造成技能伤害({
    来源: 施法者,
    目标,
    伤害,
    伤害类型: 参数.伤害类型 ?? DAMAGE_TYPE_COLD,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 参数.技能ID,
    技能实例ID: 参数.技能实例ID,
    标签: 参数.标签,
    伤害形态: "单体",
    参与技能伤害加成: true,
  });
  // ③ 寒意
  施加爱蜜莉雅寒意(施法者, 目标, 来源键);
  return true;
}

//=============================================================================
// 冰晶节点到期辅助（Q 终点 / E 落点 / W D强化 使用）
//=============================================================================

/** 创建场上冰晶节点并在 持续秒 后自动移除（英雄死亡由 A1 统一回收） */
export function 创建爱蜜莉雅场上冰晶(
  this: void,
  英雄: any,
  来源技能: "Q" | "W" | "E",
  X: number,
  Y: number,
  持续秒: number,
): any {
  const 节点 = 创建爱蜜莉雅冰晶(英雄, 来源技能, X, Y);
  if (节点 == null) return null;
  if (持续秒 > 0) {
    const 序号 = 节点.序号;
    const 延迟ID = addDelayedCallback(持续秒 * 1000, function 冰晶到期移除(this: void): void {
      移除爱蜜莉雅冰晶(英雄, 序号);
    });
    const 注销 = 登记爱蜜莉雅技能清理(英雄, "冰晶-" + 序号, function 冰晶清理(this: void): void {
      removeDelayedCallback(延迟ID);
      移除爱蜜莉雅冰晶(英雄, 序号);
    });
    void 注销;
  }
  return 节点;
}

/** 查询距点最近的冰晶节点（用于 Q 穿晶 / R 读取） */
export function 取最近冰晶(this: void, 英雄: any, X: number, Y: number, 最大距离: number): any {
  const 列表 = 查询爱蜜莉雅冰晶(英雄);
  let 最近节点: any = null;
  let 最近距离平方 = 最大距离 * 最大距离;
  for (let i = 0; i < 列表.length; i++) {
    const 节点 = 列表[i];
    const d = 距离平方XY(节点.X, 节点.Y, X, Y);
    if (d <= 最近距离平方) {
      最近距离平方 = d;
      最近节点 = 节点;
    }
  }
  return 最近节点;
}

/** 按序号读取（移除）一枚冰晶并返回其坐标；不存在返回 null */
export function 读取爱蜜莉雅冰晶节点(this: void, 英雄: any, 节点: any): { X: number; Y: number } | null {
  if (节点 == null) return null;
  const 移除结果 = 移除爱蜜莉雅冰晶(英雄, 节点.序号);
  if (移除结果 == null) return null;
  return { X: 移除结果.X, Y: 移除结果.Y };
}

//=============================================================================
// 死亡清理
//=============================================================================

function 确保死亡监听(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(function 爱蜜莉雅被动死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    const id = 取单位ID(dyingUnit);
    // 1) 目标死亡：解冻 + 清理该目标被动状态与去重表
    const 状态 = 被动目标表[id];
    if (状态 != null) {
      解冻目标(dyingUnit, 状态);
      if (状态.霜裂回调ID !== 0) removeDelayedCallback(状态.霜裂回调ID);
      delete 被动目标表[id];
      delete 冻结去重表[id];
      delete 碎冰去重表[id];
      return;
    }
    // 2) 施法者死亡：解除其施放的冻结控制（规划 9.8）
    for (const 目标ID in 被动目标表) {
      const s = 被动目标表[目标ID];
      if (s == null || !s.冻结中 || s.冻结施法者 == null) continue;
      if (取单位ID(s.冻结施法者) === id && s.目标单位 != null) {
        解冻目标(s.目标单位, s);
      }
    }
  });
}

确保死亡监听();

export {};
