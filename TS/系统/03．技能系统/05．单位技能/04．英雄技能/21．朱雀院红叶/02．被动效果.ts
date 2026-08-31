/** @noSelfInFile */

import {
  朱雀院红叶技能配置,
  朱雀院红叶表现配置,
  朱雀院红叶音效配置,
  朱雀院红叶Buff配置,
  朱雀院红叶被动配置,
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
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
};
const { 创建单位坐标跟随特效, 销毁单位坐标跟随特效, 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number, 动画索引?: number, 面向弧度?: number, RGB?: { 红: number; 绿: number; 蓝: number; 透明度?: number }) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
  创建点特效: (this: void, 参数: any) => any;
};
const { Sound3DII_UnitPlayReuse, Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};

const 英雄单位类型ID = stringToFourCCSafe(朱雀院红叶技能配置.单位类型ID);
const 破绽BuffID = 朱雀院红叶Buff配置.破绽;
const 刀势BuffID = 朱雀院红叶Buff配置.刀势;
const 刀势上限 = 朱雀院红叶被动配置.刀势上限;
const 刀势特效键 = "朱雀院红叶刀势";
const 破绽特效键 = "朱雀院红叶破绽";

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const GetHandleId = jass.GetHandleId as (this: void, unit: any) => number;

//=============================================================================
// A1：按英雄句柄隔离的状态容器 + 统一清理
//=============================================================================

export interface 红叶英雄状态 {
  刀势层数: number;
  技能清理表: Record<string, (this: void) => void>;
}

const 英雄状态表: Record<number, 红叶英雄状态 | undefined> = {};

function 取英雄状态(this: void, 英雄: any): 红叶英雄状态 {
  const id = GetHandleId(英雄);
  let 状态 = 英雄状态表[id];
  if (状态 == null) {
    状态 = { 刀势层数: 0, 技能清理表: {} };
    英雄状态表[id] = 状态;
  }
  return 状态;
}

/** 登记技能清理函数（Q/W/E/R/D 各模块调用；英雄死亡/场景清理统一执行，幂等） */
export function 登记朱雀院清理(this: void, 英雄: any, 名称: string, 清理: (this: void) => void): void {
  if (英雄 == null || 英雄 === 0) return;
  取英雄状态(英雄).技能清理表[名称] = 清理;
}

/** 是否是朱雀院红叶（按单位类型） */
export function 是朱雀院红叶(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return jass.GetUnitTypeId(unit) === 英雄单位类型ID;
}

/** 获取当前刀势层数（0~3） */
export function 获取刀势层数(this: void, 英雄: any): number {
  if (英雄 == null || 英雄 === 0) return 0;
  const 状态 = 英雄状态表[GetHandleId(英雄)];
  return 状态 != null ? 状态.刀势层数 : 0;
}

/** 幂等统一清理：英雄死亡/离场/场景清理入口 */
export function 清理朱雀院红叶状态(this: void, 英雄: any, _原因: string): void {
  if (英雄 == null || 英雄 === 0) return;
  const id = GetHandleId(英雄);
  const 状态 = 英雄状态表[id];
  if (状态 == null) return;
  // 刀势表现与 Buff
  销毁单位坐标跟随特效(英雄, 刀势特效键);
  移除单位指定Buff(英雄, 刀势BuffID);
  // 技能清理表（Q2 壳 / W 招架 / E 剑痕 / D 强化等）
  for (const key in 状态.技能清理表) {
    const 清理 = 状态.技能清理表[key];
    if (清理 != null) 清理();
  }
  delete 英雄状态表[id];
}

//=============================================================================
// A1：破绽（目标标记）
//=============================================================================

interface 破绽目标状态 {
  来源英雄: any;
  到期时间: number;
  到期回调ID: number;
}

const 破绽目标表: Record<number, 破绽目标状态 | undefined> = {};
/** 红叶句柄 -> 目标句柄 -> 冷却到期；独立于会被消费删除的破绽状态。 */
const 破绽斩冷却表: Record<number, Record<number, number | undefined> | undefined> = {};

/** 目标当前是否带有朱雀院红叶的破绽 */
export function 目标有破绽(this: void, 目标: any): boolean {
  if (目标 == null || 目标 === 0) return false;
  return 破绽目标表[GetHandleId(目标)] != null;
}

/** 移除目标破绽（特效/Buff/回调/表项，幂等） */
export function 移除目标破绽(this: void, 目标: any): void {
  if (目标 == null || 目标 === 0) return;
  const id = GetHandleId(目标);
  const 状态 = 破绽目标表[id];
  if (状态 == null) return;
  if (状态.到期回调ID !== 0) removeDelayedCallback(状态.到期回调ID);
  销毁单位坐标跟随特效(目标, 破绽特效键);
  移除单位指定Buff(目标, 破绽BuffID);
  delete 破绽目标表[id];
}

/** 统一施加或刷新破绽（Q/W/E/R 技能命中调用）；刷新持续时间和表现 */
export function 施加朱雀院破绽(this: void, 红叶: any, 目标: any): void {
  if (红叶 == null || 红叶 === 0 || 目标 == null || 目标 === 0) return;
  if (目标 === 红叶) return;
  const id = GetHandleId(目标);
  const 旧状态 = 破绽目标表[id];
  const 首次获得破绽 = 旧状态 == null;
  if (旧状态 != null && 旧状态.到期回调ID !== 0) removeDelayedCallback(旧状态.到期回调ID);
  const 持续毫秒 = 朱雀院红叶被动配置.破绽持续秒 * 1000;
  const 状态: 破绽目标状态 = {
    来源英雄: 红叶,
    到期时间: getGameTime() + 朱雀院红叶被动配置.破绽持续秒,
    到期回调ID: 0,
  };
  状态.到期回调ID = addDelayedCallback(持续毫秒, function 破绽到期(this: void): void {
    const 当前 = 破绽目标表[GetHandleId(目标)];
    if (当前 === 状态) 移除目标破绽(目标);
  });
  破绽目标表[id] = 状态;
  // 表现：目标躯干挂点朱红断刃标记（刷新时先销毁旧表现）
  销毁单位坐标跟随特效(目标, 破绽特效键);
  创建单位坐标跟随特效(
    目标,
    朱雀院红叶表现配置.破绽标记.模型路径,
    破绽特效键,
    朱雀院红叶表现配置.破绽标记.缩放,
    朱雀院红叶表现配置.破绽标记.高度,
    1,
    undefined,
    0,
    朱雀院红叶表现配置.破绽标记.RGB,
  );
  registerManualBuff(目标, 破绽BuffID, 朱雀院红叶被动配置.破绽持续秒, 1, { stack: 1 });
  // 破绽标记音（目标首次获得破绽时一次；刷新已有破绽不播；坐标=目标位置，参数配置驱动）
  if (首次获得破绽) {
    Sound3DII_CooPlayReuse(朱雀院红叶音效配置.破绽标记.路径, jass.GetUnitX(目标), jass.GetUnitY(目标), 朱雀院红叶音效配置.破绽标记.高度, 朱雀院红叶音效配置.破绽标记.裁断距离);
  }
}

//=============================================================================
// A2：刀势（红叶自身 0~3 层）
//=============================================================================

function 刷新刀势表现(this: void, 英雄: any, 层数: number): void {
  // 层数特效互斥：先销毁旧层，再创建当前层
  销毁单位坐标跟随特效(英雄, 刀势特效键);
  移除单位指定Buff(英雄, 刀势BuffID);
  if (层数 <= 0) return;
  const 模型 = 朱雀院红叶表现配置.刀势层数.模型路径[层数 - 1];
  if (模型 != null) {
    创建单位坐标跟随特效(
      英雄,
      模型,
      刀势特效键,
      朱雀院红叶表现配置.刀势层数.缩放,
      朱雀院红叶表现配置.刀势层数.高度,
      1,
      undefined,
      0,
      朱雀院红叶表现配置.刀势层数.RGB,
    );
  }
  registerManualBuff(英雄, 刀势BuffID, 9999, 层数, { stack: 层数 });
}

/** 增加刀势（+层数，最大 3 层；到达上限时播放一次提示） */
export function 增加刀势(this: void, 英雄: any, 层数: number): void {
  if (英雄 == null || 英雄 === 0 || 层数 <= 0) return;
  const 状态 = 取英雄状态(英雄);
  const 原层数 = 状态.刀势层数;
  const 新层数 = 原层数 + 层数 > 刀势上限 ? 刀势上限 : 原层数 + 层数;
  if (新层数 === 原层数) return;
  状态.刀势层数 = 新层数;
  刷新刀势表现(英雄, 新层数);
  if (新层数 >= 刀势上限 && 朱雀院红叶表现配置.满刀势提示.模型路径 !== "") {
    创建点特效({
      模型路径: 朱雀院红叶表现配置.满刀势提示.模型路径,
      RGB: 朱雀院红叶表现配置.满刀势提示.RGB,
      X: jass.GetUnitX(英雄),
      Y: jass.GetUnitY(英雄),
      Z: 朱雀院红叶表现配置.满刀势提示.高度,
      缩放: 朱雀院红叶表现配置.满刀势提示.缩放,
      持续秒: 朱雀院红叶表现配置.满刀势提示.持续秒,
    });
  }
  // 刀势满层音（刀势从 2 层进入 3 层时一次；1→2 层不播；单位绑定，参数配置驱动）
  if (新层数 >= 刀势上限) {
    Sound3DII_UnitPlayReuse(朱雀院红叶音效配置.刀势满层.路径, 英雄, 朱雀院红叶音效配置.刀势满层.裁断距离);
  }
}

/** 尝试消费 1 层刀势（无则 false，技能仍执行基础效果） */
export function 尝试消费一层刀势(this: void, 英雄: any): boolean {
  if (英雄 == null || 英雄 === 0) return false;
  const 状态 = 取英雄状态(英雄);
  if (状态.刀势层数 <= 0) return false;
  状态.刀势层数 = 状态.刀势层数 - 1;
  刷新刀势表现(英雄, 状态.刀势层数);
  return true;
}

/** 消费全部刀势，返回实际消费层数（R 终式用） */
export function 消费全部刀势(this: void, 英雄: any): number {
  if (英雄 == null || 英雄 === 0) return 0;
  const 状态 = 取英雄状态(英雄);
  const 层数 = 状态.刀势层数;
  if (层数 <= 0) return 0;
  状态.刀势层数 = 0;
  刷新刀势表现(英雄, 0);
  return 层数;
}

//=============================================================================
// A2：破绽斩（普攻联动）
//=============================================================================

/** 破绽斩事件回调（D 延长等模块注册；避免模块循环依赖） */
export type 破绽斩事件回调 = (this: void, 红叶: any, 目标: any) => void;
const 破绽斩监听列表: 破绽斩事件回调[] = [];

/** 注册破绽斩事件监听（幂等注册方自行控制） */
export function 注册破绽斩监听(this: void, 回调: 破绽斩事件回调): void {
  破绽斩监听列表.push(回调);
}

function 处理红叶普攻破绽斩(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!是朱雀院红叶(attacker)) return;
  if (snapshot == null) return;
  // 仅红叶本人的正常普攻；技能伤害伪装普攻 / 破绽斩自身造成的技能伤害一律跳过（防递归）
  if (snapshot.isNormalAttack !== true) return;
  if (snapshot.isWrappedSkillDamage === true) return;
  if (target == null || target === 0) return;
  const id = GetHandleId(target);
  const 破绽 = 破绽目标表[id];
  if (破绽 == null) return;
  if (破绽.来源英雄 !== attacker) return;
  const 现在 = getGameTime();
  const 红叶ID = GetHandleId(attacker);
  let 目标冷却表 = 破绽斩冷却表[红叶ID];
  if (目标冷却表 == null) {
    目标冷却表 = {};
    破绽斩冷却表[红叶ID] = 目标冷却表;
  }
  if (现在 < (目标冷却表[id] ?? 0)) return;
  // 破绽斩：以本次普攻实际伤害为基准追加（普攻联动伤害，不触发技能暴击）
  const 追加伤害 = applied * 朱雀院红叶被动配置.破绽斩伤害倍率;
  造成技能伤害({
    来源: attacker,
    目标: target,
    伤害: 追加伤害,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 0,
    标签: "朱雀院红叶-破绽斩",
    伤害形态: "单体",
    参与技能伤害加成: false,
  });
  // 破绽斩表现（候选未迁入则留空不播）
  if (朱雀院红叶表现配置.破绽斩.模型路径 !== "") {
    创建点特效({
      模型路径: 朱雀院红叶表现配置.破绽斩.模型路径,
      RGB: 朱雀院红叶表现配置.破绽斩.RGB,
      X: jass.GetUnitX(target),
      Y: jass.GetUnitY(target),
      Z: 朱雀院红叶表现配置.破绽斩.高度,
      缩放: 朱雀院红叶表现配置.破绽斩.缩放,
      持续秒: 朱雀院红叶表现配置.破绽斩.持续秒,
    });
  }
  // 消费目标破绽 + 同目标内部冷却（防止重新施加后立即再次触发）
  目标冷却表[id] = 现在 + 朱雀院红叶被动配置.破绽斩内部冷却秒;
  移除目标破绽(target);
  // 获得 1 层刀势
  增加刀势(attacker, 1);
  // 破绽斩事件（D 延长等联动）
  for (let i = 0; i < 破绽斩监听列表.length; i++) 破绽斩监听列表[i](attacker, target);
}

//=============================================================================
// 注册入口（懒注册，幂等）
//=============================================================================

let 已注册 = false;
let 死亡监听已注册 = false;

function 确保死亡清理(this: void): void {
  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(function 朱雀院红叶死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
    if (dyingUnit == null || dyingUnit === 0) return;
    const id = GetHandleId(dyingUnit);
    // 目标死亡：清除其破绽（含特效/Buff/回调）
    if (破绽目标表[id] != null) 移除目标破绽(dyingUnit);
    for (const 红叶ID in 破绽斩冷却表) {
      const 目标冷却表 = 破绽斩冷却表[红叶ID as any];
      if (目标冷却表 != null) delete 目标冷却表[id];
    }
    // 红叶死亡：清理自身状态
    if (是朱雀院红叶(dyingUnit)) {
      delete 破绽斩冷却表[id];
      清理朱雀院红叶状态(dyingUnit, "英雄死亡");
    }
  });
}

/** 注册朱雀院红叶被动（普攻破绽斩 + 死亡清理；幂等） */
export function 注册朱雀院红叶被动(this: void): void {
  if (已注册) return;
  已注册 = true;
  确保死亡清理();
  registerAppliedFinalDamageListener(处理红叶普攻破绽斩);
}

// 供 index 副作用导入
export const 朱雀院红叶被动模块 = {
  英雄ID: 朱雀院红叶技能配置.单位类型ID,
  已注册: false,
  注册: 注册朱雀院红叶被动,
} as const;

//=============================================================================
// A8：动作表现辅助（动作索引由配置驱动；0 = 未实机确认不播放）
//=============================================================================

/** 播放红叶施法动作（接收动作槽，索引/持续秒全部配置驱动；0 跳过），持续后恢复 stand；随英雄清理移除恢复回调 */
export function 播放红叶动作(this: void, 英雄: any, 槽: { 索引: number; 持续秒: number }): void {
  const 动作索引 = 槽.索引;
  const 持续秒 = 槽.持续秒;
  if (英雄 == null || 英雄 === 0 || 动作索引 <= 0) return;
  jass.SetUnitAnimationByIndex(英雄, 动作索引);
  if (持续秒 > 0) {
    const 恢复ID = addDelayedCallback(持续秒 * 1000, function 恢复站立动作(this: void): void {
      if (单位存活(英雄)) jass.SetUnitAnimation(英雄, "stand");
    });
    登记朱雀院清理(英雄, "红叶动作-" + 动作索引, function 动作恢复清理(this: void): void {
      removeDelayedCallback(恢复ID);
    });
  }
}
