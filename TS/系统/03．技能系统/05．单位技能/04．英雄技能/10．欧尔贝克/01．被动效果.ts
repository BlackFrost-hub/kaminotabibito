/** @noSelfInFile */

/**
 * 欧尔贝克 - 被动效果（E：千枝枪 剑气）
 *
 * 源 JASS：地图全局伤害触发器（________________KllGJTXXT）中 H012 分支。
 * - 欧尔贝克造成伤害时，先消耗 1 次积攒计数（若有 W 积攒）。
 * - 有积攒 60% / 无积攒 20% 的几率发射一道剑气（沿面朝方向飞行的弹幕），
 *   对命中的敌人造成 攻击力 × (100% + 5% × 等级) 物理伤害。
 */

import { 欧尔贝克单位技能配置 } from "./00．配置";
import { 获取欧尔贝克积攒计数, 消耗欧尔贝克积攒 } from "./00B．积攒状态";

const jass = require("jass.common") as any;
const GetRandomReal = jass.GetRandomReal as (this: void, lowBound: number, highBound: number) => number;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    Z轴角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const {
  创建原生弹幕,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { 单位拥有原生Buff, 单位是指定类型 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  单位是指定类型: (this: void, unit: any, typeId: number) => boolean;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const 欧尔贝克单位类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.单位类型ID);
const E技能类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.E技能ID);
const 积攒Buff类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.积攒BuffID);

const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;

/** 已注册标记，防止重复监听 */
let 已注册 = false;

function 是欧尔贝克(this: void, unit: any): boolean {
  return 单位是指定类型(unit, 欧尔贝克单位类型ID);
}

function 释放欧尔贝克剑气(this: void, caster: any, level: number): void {
  const cfg = 欧尔贝克单位技能配置.E;
  const damage = 读取单位攻击力(caster) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level);
  const angle = GetUnitFacing(caster);
  Sound3DII_UnitPlayReuse(cfg.音效路径, caster, cfg.音效裁断距离);
  创建点特效({
    模型路径: cfg.触发特效模型,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    Z: 0,
    持续秒: 0.8,
  });
  创建原生弹幕({
    所有者: caster,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    方向角: angle,
    速度: cfg.弹幕速度,
    最大距离: cfg.弹幕速度 * cfg.弹幕生命秒,
    生命周期: cfg.弹幕生命秒,
    命中半径: cfg.弹幕命中半径,
    影响目标: "敌方",
    碰撞消失: false,
    每单位最大命中次数: 1,
    最大总命中次数: 0,
    伤害值: damage,
    伤害类型: DAMAGE_TYPE_NORMAL,
    攻击类型: ATTACK_TYPE_NORMAL,
    武器类型: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: E技能类型ID,
    技能标签: "欧尔贝克-千枝枪剑气",
    伤害形态: "单体",
    参与技能伤害加成: true,
    模型: cfg.弹幕模型,
    飞行高度: GetUnitFlyHeight(caster) + GetUnitDefaultFlyHeight(caster),
  });
}

function 尝试触发欧尔贝克剑气(this: void, caster: any): void {
  const level = GetUnitAbilityLevel(caster, E技能类型ID);
  if (!(level > 0) || !单位存活(caster)) return;
  const cfg = 欧尔贝克单位技能配置.E;
  const hasBuff = 单位拥有原生Buff(caster, 积攒Buff类型ID);
  const probability = hasBuff ? cfg.积攒触发概率 : cfg.普攻触发概率;
  if (GetRandomReal(0, 1) >= probability) return;
  释放欧尔贝克剑气(caster, level);
}

function on欧尔贝克造成伤害结算(this: void, _target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是欧尔贝克(attacker)) return;
  if (snapshot?.isWrappedSkillDamage === true) return;

  // 源 JASS：造成伤害先消耗 1 次积攒计数
  if (获取欧尔贝克积攒计数(attacker) > 0) {
    消耗欧尔贝克积攒(attacker);
  }

  // E 剑气触发判定（源 JASS 为每次造成伤害判定；普攻为主要触发场景）
  尝试触发欧尔贝克剑气(attacker);
}

export function 注册欧尔贝克被动(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerAppliedFinalDamageListener(on欧尔贝克造成伤害结算);
}

注册欧尔贝克被动();

export {};
