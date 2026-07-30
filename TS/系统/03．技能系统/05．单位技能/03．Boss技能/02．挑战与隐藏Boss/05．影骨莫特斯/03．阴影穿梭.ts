/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取影骨莫特斯上下文, 获取或创建影骨莫特斯上下文, 设置影骨背刺准备, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置, 影骨莫特斯音效配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, 播放影骨莫特斯限时动作, 开始影骨莫特斯常规施法, stringToFourCC, 极坐标X, 极坐标Y, 两点角度, 目标正面朝向来源 } from "./11．公共工具";
import { 执行战斗自身位移到坐标 } from "../../../../00．技能模板+函数/02．通用函数/20．位移技能限制";
import { 立即设置单位朝向 } from "../../../../00．技能模板+函数/02．通用函数/00．单位动画等待";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, target: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const SetUnitVertexColor = jass.SetUnitVertexColor as (unit: any, red: number, green: number, blue: number, alpha: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 阴影穿梭技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.阴影穿梭);
let 已注册阴影穿梭 = false;
let 已注册背刺修正 = false;

interface 影骨待穿梭数据 {
  context: 影骨莫特斯运行时上下文;
  target: any;
}

function on影骨背刺伤害修正(this: void, damageContext: any): number {
  const boss = damageContext.attacker;
  if (!单位有效(boss) || damageContext.isNormalAttack !== true || damageContext.isSkillAttack === true || damageContext.isSkillDamage === true) {
    return damageContext.currentDamage;
  }
  if (GetUnitTypeId(boss) !== 影骨单位类型ID) return damageContext.currentDamage;
  const context = 获取影骨莫特斯上下文(boss);
  if (context == null || !context.背刺准备) return damageContext.currentDamage;
  设置影骨背刺准备(context, false);
  const cfg = 影骨莫特斯数值与表现配置.阴影穿梭;
  let damage = damageContext.currentDamage * cfg.背刺伤害倍率;
  const 正面命中 = 目标正面朝向来源(boss, damageContext.target, cfg.背刺角度);
  if (正面命中) damage *= cfg.正面减伤比例;
  if (单位有效(damageContext.target)) {
    const effect = AddSpecialEffectTarget(影骨莫特斯表现配置.背刺命中, damageContext.target, "chest");
    if (effect != null && effect !== 0) DestroyEffect(effect);
    播放Boss坐标音效(影骨莫特斯音效配置.阴影穿梭.背刺命中, GetUnitX(damageContext.target), GetUnitY(damageContext.target), 影骨莫特斯音效配置.默认裁断距离);

    if (!正面命中) {
      创建点特效({
        模型路径: 影骨莫特斯表现配置.背刺命中血月,
        X: GetUnitX(damageContext.target),
        Y: GetUnitY(damageContext.target),
        持续秒: 0.8,
      });
    }
  }
  return damage;
}

function 确保影骨背刺修正(this: void): void {
  if (已注册背刺修正) return;
  已注册背刺修正 = true;
  registerDamageModifier(on影骨背刺伤害修正, 48);
}

function 影骨阴影穿梭进入无敌(this: void, variable?: any): void {
  const data = variable as 影骨待穿梭数据 | undefined;
  if (data == null) return;
  const boss = data.context.Boss单位;
  if (单位有效(boss)) SetUnitInvulnerable(boss, true);
}

function 影骨阴影穿梭完成(this: void, variable?: any): void {
  const data = variable as 影骨待穿梭数据 | undefined;
  if (data == null) return;
  const context = data.context;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = data.target;
  if (!单位有效(target)) {
    SetUnitInvulnerable(boss, false);
    SetUnitVertexColor(boss, 255, 255, 255, 255);
    return;
  }
  const angle = GetRandomReal(0, 360);
  const distance = 影骨莫特斯数值与表现配置.阴影穿梭.出现距离;
  const x = 极坐标X(GetUnitX(target), distance, angle);
  const y = 极坐标Y(GetUnitY(target), distance, angle);
  if (!执行战斗自身位移到坐标(boss, x, y)) {
    SetUnitInvulnerable(boss, false);
    SetUnitVertexColor(boss, 255, 255, 255, 255);
    return;
  }
  创建点特效({
    模型路径: 影骨莫特斯表现配置.阴影穿梭落点,
    X: x,
    Y: y,
    持续秒: 影骨莫特斯数值与表现配置.阴影穿梭.瞬时特效持续秒,
  });
  播放Boss坐标音效(影骨莫特斯音效配置.阴影穿梭.落点闪现, x, y, 影骨莫特斯音效配置.默认裁断距离);
  SetUnitInvulnerable(boss, false);
  SetUnitVertexColor(boss, 255, 255, 255, 255);
  立即设置单位朝向(boss, 两点角度(x, y, GetUnitX(target), GetUnitY(target)));
  设置影骨背刺准备(context, true);
  IssueTargetOrder(boss, "attackonce", target);
}

export function 释放影骨阴影穿梭(this: void, context: 影骨莫特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 影骨莫特斯数值与表现配置.阴影穿梭;
  const target = 获取Boss技能随机敌对英雄(boss);
  if (!单位有效(target)) return;
  立即设置单位朝向(boss, 两点角度(GetUnitX(boss), GetUnitY(boss), GetUnitX(target), GetUnitY(target)));
  开始影骨莫特斯常规施法(boss, cfg.消失秒, "阴影穿梭", "莫特斯即将从锁定目标附近现身");
  播放影骨莫特斯限时动作(boss, cfg.动画编号, cfg.动画速度, cfg.动画播放秒);
  播放影骨莫特斯台词(boss, "阴影穿梭");
  创建点特效({ 模型路径: 影骨莫特斯表现配置.阴影穿梭残影, X: GetUnitX(boss), Y: GetUnitY(boss), 持续秒: cfg.瞬时特效持续秒 });
  播放Boss坐标音效(影骨莫特斯音效配置.阴影穿梭.消失残影, GetUnitX(boss), GetUnitY(boss), 影骨莫特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 影骨莫特斯音效配置.怪物拟声.标识,
    音效路径列表: 影骨莫特斯音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: 影骨莫特斯音效配置.默认裁断距离,
    冷却Ms: 影骨莫特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 影骨莫特斯音效配置.怪物拟声.关键机制触发概率百分比,
  });
  SetUnitVertexColor(boss, 255, 255, 255, 80);
  const data: 影骨待穿梭数据 = { context, target };
  const invulnerableDelay = cfg.消失秒 > cfg.无敌秒 ? cfg.消失秒 - cfg.无敌秒 : 0;
  const invulnerableId = addDelayedCallback(invulnerableDelay * 1000, 影骨阴影穿梭进入无敌, data);
  context.清理.登记延迟回调("影骨-阴影穿梭进入无敌", invulnerableId);
  const completeId = addDelayedCallback(cfg.消失秒 * 1000, 影骨阴影穿梭完成, data);
  context.清理.登记延迟回调("影骨-阴影穿梭", completeId);
  context.清理.登记清理("影骨-阴影穿梭恢复可见", function 阴影穿梭恢复可见(this: void): void {
    if (!单位有效(boss)) return;
    SetUnitInvulnerable(boss, false);
    SetUnitVertexColor(boss, 255, 255, 255, 255);
  });
}

function on影骨阴影穿梭施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 阴影穿梭技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context == null) return;
  释放影骨阴影穿梭(context);
}

export function 注册影骨莫特斯阴影穿梭(this: void): void {
  if (已注册阴影穿梭) return;
  已注册阴影穿梭 = true;
  确保影骨背刺修正();
  注册单位技能壳监听({
    名称: "03．阴影穿梭",
    单位类型ID: 影骨单位类型ID,
    技能ID: 阴影穿梭技能ID,
    获取或创建上下文: 获取或创建影骨莫特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 影骨莫特斯运行时上下文, boss: any): void {
      on影骨阴影穿梭施法(boss, 阴影穿梭技能ID);
    },
  });
}
