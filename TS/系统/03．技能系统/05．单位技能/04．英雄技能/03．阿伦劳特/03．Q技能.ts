/** @noSelfInFile */

/**
 * 阿伦劳特 - Q：神圣之光 / 裁决制裁（A0D7）
 *
 * 源 JASS：JASS\部分地图编辑器GUI的英雄jass代码\阿劳伦特\主要技能.j 的 A0D7 分支。
 * 最终口径以技能介绍图片为准（阿劳伦特迁移计划 3.2 / 4）：
 * - 施法距离 700、范围 500、消耗 75 + 10% 魔法（百分比魔耗由项目统一魔耗系统处理，本文件不重复扣除）。
 * - 光形态：友军治疗 = 攻击力 × 200%（主目标 ×135%）；敌人光属性魔法伤害 = 攻击力 × 200%，主目标眩晕 0.5 秒。
 * - 暗形态：友军 3 秒内 +20% 最大攻击力（B019 裁决制裁，到期回滚）；主目标为合法友军时抽取 25% 最大生命/魔法，
 *   弹道命中后按 1:2 恢复自身；敌人暗属性魔法伤害 = 攻击力 × 200%（主目标 ×125%），裁决审判时主目标额外 + 自身最大生命 × 8%。
 */

import { 阿伦劳特单位技能配置 } from "./00．配置";
import {
  是阿伦劳特英雄,
  是光形态,
  是暗形态,
  是有效目标,
  拥有裁决审判,
  添加原生Buff持续,
  两点角度,
  两点距离,
} from "./00B．形态与状态管理";

import { 阿伦劳特BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/13．阿伦劳特";

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 创建点特效, 销毁点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  销毁点特效: (this: void, effect: any) => void;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};

const Q技能ID = stringToFourCCSafe(阿伦劳特单位技能配置.Q技能ID);
const 裁决制裁BuffID = stringToFourCCSafe(阿伦劳特单位技能配置.裁决制裁BuffID);

const DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as any;

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const R2I = jass.R2I as (this: void, value: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const EXSetEffectXY = (japi as any).EXSetEffectXY as ((this: void, effect: any, x: number, y: number) => void) | undefined;

const 角度转弧度 = 0.0174532925199433;

function 秒转毫秒(this: void, 秒: number): number {
  return R2I(秒 * 1000 + 0.5);
}

// =============================================================================
// 光形态：神圣之光（H00F）
// =============================================================================

function 光形态Q(this: void, 施法者: any, 目标单位: any, 目标X: number, 目标Y: number): void {
  const cfg = 阿伦劳特单位技能配置.Q;
  const 施法者玩家 = GetOwningPlayer(施法者);
  // 治疗量 / 伤害量 = 攻击力 × 光倍率（200%）
  const 攻击力 = 读取单位攻击力(施法者);
  const 伤害量 = 攻击力 * cfg.光倍率;

  const 单位列表 = getUnitsInRange(目标X, 目标Y, cfg.范围);
  for (let i = 0; i < 单位列表.length; i++) {
    const 目标 = 单位列表[i];
    if (!是有效目标(目标)) continue;

    if (IsUnitEnemy(目标, 施法者玩家) === true) {
      // 敌人：光属性魔法伤害 + 特效；主目标眩晕
      造成技能伤害({
        来源: 施法者,
        目标,
        伤害: 伤害量,
        伤害类型: DAMAGE_TYPE_DIVINE,
        attack: false,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: Q技能ID,
        标签: "阿伦劳特-Q-神圣之光",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
      createTimedUnitEffect(目标, "overhead", cfg.光敌人特效, cfg.光敌人特效持续秒);
      if (目标 === 目标单位) {
        施加眩晕(施法者, 目标, cfg.光主目标眩晕秒, "阿伦劳特-Q-神圣之光", "技能");
      }
    } else {
      // 友军：治疗；主目标 ×135%
      let 治疗值 = 伤害量;
      if (目标 === 目标单位) 治疗值 *= cfg.光主目标治疗倍率;
      doHeal({
        HealSource: 施法者,
        HealTarget: 目标,
        HealAmount: 治疗值,
        ItemHeal: false,
        HealEffect: true,
      });
    }
  }
}

// =============================================================================
// 暗形态：裁决制裁（H00G）
// =============================================================================

interface 暗抽取弹道上下文 {
  施法者: any;
  弹道特效: any;
  当前X: number;
  当前Y: number;
  抽取值HP: number;
  抽取值MP: number;
  剩余tick: number;
  回调ID: number;
}

/** 弹道命中后按 1:2 恢复施法者生命/魔法 */
function 结算暗抽取恢复(this: void, 施法者: any, 抽取值HP: number, 抽取值MP: number): void {
  const cfg = 阿伦劳特单位技能配置.Q;
  if (施法者 == null || 施法者 === 0 || !单位存活(施法者)) return;
  doHeal({
    HealSource: 施法者,
    HealTarget: 施法者,
    HealAmount: 抽取值HP * cfg.抽取恢复倍率,
    HealManaAmount: 抽取值MP * cfg.抽取恢复倍率,
    ItemHeal: false,
    HealEffect: true,
    ManaEffect: true,
  });
}

/**
 * 暗形态抽取弹道：AnnihilationMissile.mdl 从目标点飞向施法者。
 * 每 0.02 秒移动 20 码，最多 80 次；到达施法者后销毁并结算恢复，超时只销毁特效。
 */
function 开始暗抽取(this: void, 施法者: any, 目标单位: any, 目标X: number, 目标Y: number): void {
  const cfg = 阿伦劳特单位技能配置.Q;
  if (!单位存活(目标单位)) return;

  const 抽取值HP = GetUnitState(目标单位, UNIT_STATE_MAX_LIFE) * cfg.抽取最大生命比例;
  const 抽取值MP = GetUnitState(目标单位, UNIT_STATE_MAX_MANA) * cfg.抽取最大魔法比例;

  // 立即扣除目标生命/魔法（允许目标死亡）
  SetUnitState(目标单位, UNIT_STATE_LIFE, GetUnitState(目标单位, UNIT_STATE_LIFE) - 抽取值HP);
  SetUnitState(目标单位, UNIT_STATE_MANA, GetUnitState(目标单位, UNIT_STATE_MANA) - 抽取值MP);

  // 从目标点创建飞向施法者的弹道特效（缩放 2，Z = 目标飞行高度 + 100）
  const 弹道特效 = 创建点特效({
    模型路径: cfg.暗抽取弹道特效,
    X: 目标X,
    Y: 目标Y,
    Z: GetUnitFlyHeight(目标单位) + cfg.暗抽取弹道高度偏移,
    缩放: cfg.暗抽取弹道缩放,
  });
  if (弹道特效 == null || 弹道特效 === 0) {
    // 特效创建失败时不丢治疗，直接按原时点结算恢复
    结算暗抽取恢复(施法者, 抽取值HP, 抽取值MP);
    return;
  }

  const 上下文: 暗抽取弹道上下文 = {
    施法者,
    弹道特效,
    当前X: 目标X,
    当前Y: 目标Y,
    抽取值HP,
    抽取值MP,
    剩余tick: cfg.暗抽取弹道最大tick,
    回调ID: 0,
  };
  上下文.回调ID = addPeriodicCallback(20, 推进暗抽取弹道, 上下文);
}

function 推进暗抽取弹道(this: void, variable?: any): void {
  const ctx = variable as 暗抽取弹道上下文;
  if (ctx == null || ctx.回调ID === 0) return;
  const cfg = 阿伦劳特单位技能配置.Q;
  if (ctx.剩余tick <= 0 || ctx.施法者 == null || ctx.施法者 === 0) {
    removePeriodicCallback(ctx.回调ID);
    销毁点特效(ctx.弹道特效);
    return;
  }
  ctx.剩余tick -= 1;

  const 施法者X = GetUnitX(ctx.施法者);
  const 施法者Y = GetUnitY(ctx.施法者);
  // 到达施法者：销毁并结算恢复（源 IsUnitInRangeLoc 25 判定）
  if (两点距离(ctx.当前X, ctx.当前Y, 施法者X, 施法者Y) <= 25) {
    removePeriodicCallback(ctx.回调ID);
    销毁点特效(ctx.弹道特效);
    结算暗抽取恢复(ctx.施法者, ctx.抽取值HP, ctx.抽取值MP);
    return;
  }

  const 角度 = 两点角度(ctx.当前X, ctx.当前Y, 施法者X, 施法者Y);
  ctx.当前X += Cos(角度 * 角度转弧度) * cfg.暗抽取弹道每tick距离;
  ctx.当前Y += Sin(角度 * 角度转弧度) * cfg.暗抽取弹道每tick距离;
  if (EXSetEffectXY != null) EXSetEffectXY(ctx.弹道特效, ctx.当前X, ctx.当前Y);
}

interface 暗友军加攻到期上下文 {
  目标: any;
  加攻值: number;
}

function 暗友军加攻到期(this: void, variable?: any): void {
  const ctx = variable as 暗友军加攻到期上下文;
  if (ctx == null || ctx.目标 == null || ctx.目标 === 0) return;
  临时调整攻击(ctx.目标, -ctx.加攻值);
  移除单位指定Buff(ctx.目标, 阿伦劳特BuffID.裁决制裁);
}

function 暗形态Q(this: void, 施法者: any, 目标单位: any, 目标X: number, 目标Y: number): void {
  const cfg = 阿伦劳特单位技能配置.Q;
  const 施法者玩家 = GetOwningPlayer(施法者);
  // 伤害量 = 攻击力 × 暗倍率（200%）
  const 攻击力 = 读取单位攻击力(施法者);
  const 伤害量 = 攻击力 * cfg.暗倍率;
  const 裁决审判激活 = 拥有裁决审判(施法者);

  const 单位列表 = getUnitsInRange(目标X, 目标Y, cfg.范围);
  for (let i = 0; i < 单位列表.length; i++) {
    const 目标 = 单位列表[i];
    if (!是有效目标(目标)) continue;

    if (IsUnitEnemy(目标, 施法者玩家) === true) {
      // 敌人：暗属性魔法伤害；主目标 ×125%，裁决审判时额外 + 自身最大生命 ×8%
      let 伤害 = 伤害量;
      if (目标 === 目标单位) {
        伤害 *= cfg.暗主目标倍率;
        if (裁决审判激活) {
          伤害 += GetUnitState(施法者, UNIT_STATE_MAX_LIFE) * cfg.裁决审判额外生命比例;
        }
      }
      造成技能伤害({
        来源: 施法者,
        目标,
        伤害,
        伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
        attack: false,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "单位技能",
        技能ID: Q技能ID,
        标签: "阿伦劳特-Q-裁决制裁",
        伤害形态: "AOE",
        参与技能伤害加成: true,
      });
      createTimedUnitEffect(目标, "origin", cfg.暗敌人特效, cfg.暗敌人特效持续秒);
    } else {
      // 友军：3 秒内 +20% 最大攻击力（基于友军自身攻击力），到期回滚
      const 加攻值 = 读取单位攻击力(目标) * cfg.暗友军加攻比例;
      if (加攻值 > 0) {
        临时调整攻击(目标, 加攻值);
        registerManualBuff(目标, 阿伦劳特BuffID.裁决制裁, cfg.暗友军加攻持续秒, 加攻值);
        addDelayedCallback(秒转毫秒(cfg.暗友军加攻持续秒), 暗友军加攻到期, { 目标, 加攻值 });
      }
      添加原生Buff持续(目标, 裁决制裁BuffID, cfg.暗友军加攻持续秒);

      // 主目标若为合法友军（非自己、非中立被动、存活）：抽取生命/魔法供自身恢复
      if (目标 === 目标单位 && 目标 !== 施法者 && GetOwningPlayer(目标) !== PLAYER_NEUTRAL_PASSIVE) {
        开始暗抽取(施法者, 目标, 目标X, 目标Y);
      }
    }
  }
}

// =============================================================================
// 入口
// =============================================================================

function on阿伦劳特Q(this: void, 施法者: any, 技能ID数值: number): void {
  if (技能ID数值 !== Q技能ID) return;
  if (!是阿伦劳特英雄(施法者)) return;

  const 目标单位 = GetSpellTargetUnit();
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();

  if (是光形态(施法者)) {
    光形态Q(施法者, 目标单位, 目标X, 目标Y);
  } else if (是暗形态(施法者)) {
    暗形态Q(施法者, 目标单位, 目标X, 目标Y);
  }
}

registerSpellEffectListener(on阿伦劳特Q);

export {};
