/** @noSelfInFile */

/**
 * 铃仙 - 被动效果（天赋：狂气の月兔 A0GN）
 *
 * 源 JASS：`技能被动.j`，接入 `MNAnyUnitDamaged` 伤害事件。
 *
 * 逻辑：
 * 1. 铃仙本体远程普攻只造成 70% 伤害
 * 2. 铃仙本体和分身的普通攻击额外造成 攻击力×0.25 的魔法伤害
 * 3. 分身的普通攻击伤害只有本体的 16%（即普攻伤害修正为 0.16）
 * 4. 分身的额外魔法伤害只有 攻击力×0.04
 * 5. 额外魔法伤害不触发攻击效果（attack=false）
 * 6. 排除古树/机械/建筑目标
 */

import { 铃仙单位技能配置 } from "./00．配置";
import { 是铃仙本体, 是铃仙分身 } from "./00B．分身与状态管理";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;

const 被动配置 = 铃仙单位技能配置.被动;
const 被动技能ID = stringToFourCCSafe(铃仙单位技能配置.被动技能ID);

let 已注册 = false;

/** 目标排除检查：古树/机械/建筑 */
function 是无效目标(this: void, target: any): boolean {
  if (target == null || target === 0) return true;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return true;
  if (IsUnitType(target, UNIT_TYPE_MECHANICAL)) return true;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return true;
  return false;
}

//=============================================================================
// 一、普攻伤害修正（本体 70%，分身 16%）
//=============================================================================

function 铃仙被动伤害修正(this: void, context: any): number {
  const damage = context?.currentDamage ?? 0;
  if (!(damage > 0)) return damage;

  const attacker = context?.attacker;
  if (attacker == null || attacker === 0) return damage;

  // 仅对铃仙本体或分身生效
  const isMain = 是铃仙本体(attacker);
  const isIllusion = 是铃仙分身(attacker);
  if (!isMain && !isIllusion) return damage;

  // 仅对普通远程攻击生效
  if (context?.isNormalAttack !== true) return damage;
  if (context?.isRangedAttack !== true) return damage;

  // 排除被技能伤害系统包裹的伤害（避免被动二次修正）
  if (context?.isWrappedSkillDamage === true) return damage;

  const target = context?.target;
  if (target == null || target === 0) return damage;
  if (是无效目标(target)) return damage;

  if (isIllusion) {
    // 分身普攻伤害修正为 16%
    return damage * 被动配置.分身普攻伤害比例;
  }

  // 本体普攻伤害修正为 70%
  return damage * 被动配置.普攻伤害比例;
}

//=============================================================================
// 二、额外魔法伤害（最终伤害结算后触发）
//=============================================================================

function 铃仙被动额外魔法伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || attacker == null || attacker === 0 || target == null || target === 0) return;

  // 仅对铃仙本体或分身的普通攻击生效
  const isMain = 是铃仙本体(attacker);
  const isIllusion = 是铃仙分身(attacker);
  if (!isMain && !isIllusion) return;
  if (snapshot?.isNormalAttack !== true) return;
  // 排除被技能伤害系统包裹的伤害（如 Q 的 attack=true 魔法伤害，避免误触发被动）
  if (snapshot?.isWrappedSkillDamage === true) return;

  // 排除无效目标
  if (是无效目标(target)) return;

  // 计算额外魔法伤害
  const attackDamage = 读取单位攻击力(attacker);
  let extraDamage: number;
  if (isIllusion) {
    extraDamage = attackDamage * 被动配置.分身额外魔法倍率;
  } else {
    extraDamage = attackDamage * 被动配置.额外魔法倍率;
  }
  if (!(extraDamage > 0)) return;

  // 额外魔法伤害不触发攻击效果（attack=false）
  造成技能伤害({
    来源: attacker,
    目标: target,
    伤害: extraDamage,
    伤害类型: DAMAGE_TYPE_MAGIC,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 被动技能ID,
    标签: "铃仙-被动额外魔法伤害",
    伤害形态: "单体",
    参与技能伤害加成: true,
  });
}

//=============================================================================
// 三、注册入口
//=============================================================================

export function 注册铃仙被动(this: void): void {
  if (已注册) return;
  已注册 = true;

  // 优先级 100：被动应优先于其他修正
  registerDamageModifier(铃仙被动伤害修正, 100);
  registerAppliedFinalDamageListener(铃仙被动额外魔法伤害);
}

注册铃仙被动();

export {};