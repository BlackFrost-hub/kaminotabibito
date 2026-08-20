/** @noSelfInFile */

/**
 * 欧尔贝克 - Q：横一字斩 / 十字斩
 *
 * 源 JASS：OEBR 触发器 A0IY 分支。
 * - 施法后 0.35 秒施法硬直（硬直暂停系统），期间以 2 倍速播放 attack 起手动作。
 * - 硬直结束后沿施法方向冲锋（速度按源 JASS ×1.5）。
 * - 伤害分两段：冲锋路径 300 码内敌人实时命中；终点面向前方 270°（±135°）扇形 300 码内结算。
 *   全程共享去重表，每个独立敌人整次 Q 只结算一次伤害（路径或扇形二选一）。
 * - 若施法时拥有 W「积攒」Buff：消耗积攒 → 十字斩（眩晕 1.5 秒）；否则为横一字斩（眩晕 0.75 秒）。
 */

import { 欧尔贝克单位技能配置 } from "./00．配置";
import { 播放欧尔贝克单位音效, 播放欧尔贝克配置动作 } from "./00A．表现工具";
import { 欧尔贝克BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/17．欧尔贝克";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, 来源: string) => boolean;
  移除单位暂停: (this: void, unit: any, 来源: string) => boolean;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活, 两点角度, 距离XY, 极坐标X, 极坐标Y, 角度差绝对值 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  距离XY: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
  角度差绝对值: (this: void, a: number, b: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    面向角度?: number;
    Z轴角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 单位拥有原生Buff, 单位是指定类型 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  单位是指定类型: (this: void, unit: any, typeId: number) => boolean;
};
const { 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const Q技能ID = stringToFourCCSafe(欧尔贝克单位技能配置.Q技能ID);
const 欧尔贝克单位类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.单位类型ID);
const 积攒Buff类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.积攒BuffID);
/** 冲锋速度 = 源 JASS（20 码/0.03125s） × 1.5 倍 */
const 冲刺每秒速度 = (欧尔贝克单位技能配置.Q.冲刺步距 / 0.03125) * 欧尔贝克单位技能配置.Q.冲刺速度倍率;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

interface 结算上下文 {
  施法者: any;
  起点X: number;
  起点Y: number;
  方向角: number;
  伤害值: number;
  十字斩: boolean;
  命中范围: number;
  扇形半角: number;
  /** 全程伤害去重：路径命中与终点扇形共享，每个敌人整次 Q 只结算一次 */
  已命中: Record<number, boolean>;
}

/** 目标类型过滤：排除建筑/机械/古树等无效目标（路径与扇形共用） */
function 是有效伤害目标(this: void, 上下文: 结算上下文, target: any): boolean {
  if (target == null || target === 0 || target === 上下文.施法者) return false;
  if (!单位存活(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_MECHANICAL)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  if (!isUnitEnemy(target, 上下文.施法者)) return false;
  return true;
}

/** 是否已计入本次 Q 的去重表 */
function 已命中过(this: void, 上下文: 结算上下文, target: any): boolean {
  return 上下文.已命中[GetHandleId(target)] === true;
}

/** 记录去重并结算：眩晕 + 技能伤害（AOE 形态） */
function 结算Q单体伤害(this: void, 上下文: 结算上下文, target: any): void {
  if (已命中过(上下文, target)) return;
  上下文.已命中[GetHandleId(target)] = true;

  const cfg = 欧尔贝克单位技能配置.Q;
  const 眩晕秒 = 上下文.十字斩 ? cfg.十字眩晕秒 : cfg.眩晕秒;
  施加眩晕(上下文.施法者, target, 眩晕秒, 上下文.十字斩 ? "十字斩" : "横一字斩", "技能");
  造成技能伤害({
    来源: 上下文.施法者,
    目标: target,
    伤害: 上下文.伤害值,
    伤害类型: DAMAGE_TYPE_NORMAL,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: Q技能ID,
    标签: 上下文.十字斩 ? "欧尔贝克-十字斩" : "欧尔贝克-横一字斩",
    伤害形态: "AOE",
    参与技能伤害加成: true,
  });
}

/** 冲锋路径命中回调：冲锋系统已按“命中伤害”结算过伤害，这里只记去重表并施加眩晕 */
function onQ路径命中(this: void, 移动单位: any, 目标: any): void {
  const 上下文 = onQ冲锋结束上下文;
  if (上下文 == null || 上下文.施法者 !== 移动单位) return;
  if (!是有效伤害目标(上下文, 目标)) return;
  if (已命中过(上下文, 目标)) return;
  上下文.已命中[GetHandleId(目标)] = true;

  const cfg = 欧尔贝克单位技能配置.Q;
  const 眩晕秒 = 上下文.十字斩 ? cfg.十字眩晕秒 : cfg.眩晕秒;
  施加眩晕(上下文.施法者, 目标, 眩晕秒, 上下文.十字斩 ? "十字斩" : "横一字斩", "技能");
}

/** 冲锋命中过滤：冲锋系统已排除自身与死亡单位，这里补类型过滤 */
function Q命中过滤(this: void, 移动单位: any, 目标: any): boolean {
  const 上下文 = onQ冲锋结束上下文;
  if (上下文 == null || 上下文.施法者 !== 移动单位) return false;
  if (!是有效伤害目标(上下文, 目标)) return false;
  // 已被路径结算过的目标不再参与后续判定
  return !已命中过(上下文, 目标);
}

function 结算Q落点(this: void, 上下文: 结算上下文): void {
  const cfg = 欧尔贝克单位技能配置.Q;
  const 施法者 = 上下文.施法者;
  const casterX = GetUnitX(施法者);
  const casterY = GetUnitY(施法者);

  创建点特效({
    模型路径: cfg.冲刺特效模型,
    X: casterX,
    Y: casterY,
    面向角度: 上下文.方向角,
    缩放: cfg.冲刺特效缩放X,
    持续秒: cfg.冲刺特效持续秒,
  });
  创建点特效({
    模型路径: cfg.落点特效模型,
    X: casterX,
    Y: casterY,
    Z: 0,
    缩放: cfg.落点特效缩放X,
    持续秒: cfg.落点特效持续秒,
  });
  if (上下文.十字斩) {
    创建点特效({
      模型路径: cfg.冲刺特效模型,
      X: 极坐标X(casterX, 上下文.方向角, 125),
      Y: 极坐标Y(casterY, 上下文.方向角, 125),
      Z: 175,
      面向角度: 上下文.方向角,
      缩放: cfg.冲刺特效缩放X,
      持续秒: cfg.冲刺特效持续秒,
    });
  }

  // 终点扇形结算：面向前方 270°（±135°）、300 码内且未被路径结算过的敌人
  const targets = getUnitsInRange(casterX, casterY, 上下文.命中范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!是有效伤害目标(上下文, target)) continue;
    if (已命中过(上下文, target)) continue;
    const 指向目标角度 = 两点角度(casterX, casterY, GetUnitX(target), GetUnitY(target));
    if (角度差绝对值(指向目标角度, 上下文.方向角) > 上下文.扇形半角) continue;
    结算Q单体伤害(上下文, target);
  }
}

function onQ冲锋结束(this: void, caster: any, reason: string, _位移ID: number): void {
  if (!单位存活(caster)) return;
  if (reason !== "完成" && reason !== "撞墙") return;
  const 上下文 = onQ冲锋结束上下文;
  if (上下文 == null || 上下文.施法者 !== caster) return;
  onQ冲锋结束上下文 = undefined;
  结算Q落点(上下文);
}

let onQ冲锋结束上下文: 结算上下文 | undefined;

/** 施法硬直来源（硬直暂停系统，可追踪可清理） */
const Q施法硬直来源 = "欧尔贝克Q施法硬直";

function on欧尔贝克Q(this: void, caster: any, abilityId: number): void {
  if (abilityId !== Q技能ID) return;
  if (!单位是指定类型(caster, 欧尔贝克单位类型ID)) return;

  const cfg = 欧尔贝克单位技能配置.Q;
  const level = GetUnitAbilityLevel(caster, Q技能ID);
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  const 方向角 = 两点角度(startX, startY, targetX, targetY);
  const 距离 = 距离XY(startX, startY, targetX, targetY);
  const 伤害值 = 读取单位攻击力(caster) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level);

  const 十字斩 = 单位拥有原生Buff(caster, 积攒Buff类型ID);
  if (十字斩) {
    UnitRemoveAbility(caster, 积攒Buff类型ID);
    移除单位指定Buff(caster, 欧尔贝克BuffID.积攒);
    播放欧尔贝克单位音效(caster, cfg.十字全局音效键);
  } else {
    播放欧尔贝克单位音效(caster, cfg.全局音效键);
  }

  // 施法硬直：先暂停，再播放 2 倍速 attack 起手动作
  添加单位暂停(caster, Q施法硬直来源);
  播放欧尔贝克配置动作(caster, 3, 2.0);

  addDelayedCallback(cfg.施法硬直秒 * 1000, () => {
    // 到时先解除硬直，再启动冲锋（避免与冲锋自身暂停冲突导致位移中断）
    移除单位暂停(caster, Q施法硬直来源);
    if (!单位存活(caster)) return;

    onQ冲锋结束上下文 = {
      施法者: caster,
      起点X: startX,
      起点Y: startY,
      方向角,
      伤害值,
      十字斩,
      命中范围: cfg.命中范围,
      扇形半角: cfg.扇形半角,
      已命中: {},
    };
    开始冲锋(caster, {
      角度: 方向角,
      距离,
      每秒速度: 冲刺每秒速度,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      朝向跟随位移: true,
      // 冲锋过程保持 2 倍速 attack 动作
      动画序号: 3,
      开始回调: (移动单位: any) => {
        播放欧尔贝克配置动作(移动单位, 3, 2.0);
      },
      // 路径伤害：沿途 300 码内敌人实时命中（每敌一次，与终点扇形共享去重）
      命中半径: cfg.命中范围,
      只命中敌人: true,
      允许重复命中: false,
      命中伤害: 伤害值,
      攻击类型: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_NORMAL,
      武器类型: WEAPON_TYPE_WHOKNOWS,
      技能伤害标记: {
        来源类型: "单位技能",
        技能ID: Q技能ID,
        标签: 十字斩 ? "欧尔贝克-十字斩" : "欧尔贝克-横一字斩",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      },
      命中过滤: Q命中过滤,
      命中回调: onQ路径命中,
      结束回调: onQ冲锋结束,
    });
  });
}

registerSpellEffectListener(on欧尔贝克Q);

export {};
