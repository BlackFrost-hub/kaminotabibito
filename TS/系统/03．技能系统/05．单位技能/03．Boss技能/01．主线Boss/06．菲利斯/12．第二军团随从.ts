/** @noSelfInFile */

import { 菲利斯单位技能配置 } from "./00．配置";
import { 菲利斯数值与表现配置 } from "./02．数值与表现配置";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as { udg_Boss?: any };

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { getServerTime, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 获取Boss护卫列表 } = require("系统.01．单位系统.10．护卫系统.index") as {
  获取Boss护卫列表: (this: void, boss: any, 只返回存活?: boolean) => any[];
};
const { 获取Boss技能最近敌对英雄, 获取Boss技能敌对目标列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对目标列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, unit: any, buffID: string, duration: number, effect: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.05．菲利斯") as {
  菲利斯BuffID: { 护主盾阵: string; 腐蚀迟滞: string };
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (
    this: void,
    sourceUnit: any,
    target: any,
    attackSpeedRatio: number,
    moveSpeedRatio: number,
    durationSec: number,
    effectSourceName?: string,
    effectSourceType?: "装备" | "技能",
  ) => void;
};
const { 开始充能, 停止充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, options: any) => number;
  停止充能: (this: void, chargeId: number) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs?: number) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animationName: string) => void;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 菲利斯单位类型ID = stringToFourCCSafe(菲利斯单位技能配置.单位ID);
const 第二军团护卫类型ID = stringToFourCCSafe("n063");
const 第二军团术士类型ID = stringToFourCCSafe("n062");

interface 术士施法记录 {
  术士单位: any;
  目标X: number;
  目标Y: number;
  充能ID: number;
}

interface 菲利斯第二军团状态 {
  Boss单位: any;
  Boss句柄ID: number;
  护主盾阵层数: number;
  术士下次可施法Ms: number;
  当前术士施法: 术士施法记录 | undefined;
}

let 当前状态: 菲利斯第二军团状态 | undefined;
let 已注册 = false;

function 取句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 单位存活(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (GetUnitTypeId(unit) === 0 || IsUnitType(unit, UNIT_TYPE_DEAD) === true) return false;
  return GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 单位类型是菲利斯(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 菲利斯单位类型ID;
}

function 获取或创建状态(this: void, boss: any, now: number): 菲利斯第二军团状态 {
  const bossId = 取句柄ID(boss);
  if (当前状态 != null && 当前状态.Boss单位 === boss) return 当前状态;
  if (当前状态 != null) 清理状态(当前状态);
  当前状态 = {
    Boss单位: boss,
    Boss句柄ID: bossId,
    护主盾阵层数: 0,
    术士下次可施法Ms: now + 菲利斯数值与表现配置.第二军团术士.首次施法延迟秒 * 1000,
    当前术士施法: undefined,
  };
  return 当前状态;
}

function 清理术士施法(this: void, state: 菲利斯第二军团状态): void {
  const record = state.当前术士施法;
  if (record == null) return;
  state.当前术士施法 = undefined;
}

function 中断术士施法(this: void, state: 菲利斯第二军团状态): void {
  const record = state.当前术士施法;
  if (record == null) return;
  if (record.充能ID > 0 && 停止充能(record.充能ID)) return;
  清理术士施法(state);
}

function 清理状态(this: void, state: 菲利斯第二军团状态): void {
  中断术士施法(state);
  if (单位存活(state.Boss单位) || state.Boss单位 != null) {
    移除单位指定Buff(state.Boss单位, 菲利斯BuffID.护主盾阵);
  }
  if (当前状态 === state) 当前状态 = undefined;
}

function 获取有效护卫列表(this: void, boss: any): any[] {
  const cfg = 菲利斯数值与表现配置.第二军团护卫;
  const result: any[] = [];
  const guards = 获取Boss护卫列表(boss, true);
  const range2 = cfg.生效范围 * cfg.生效范围;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  for (let i = 0; i < guards.length; i++) {
    const guard = guards[i];
    if (!单位存活(guard) || GetUnitTypeId(guard) !== 第二军团护卫类型ID) continue;
    const dx = GetUnitX(guard) - bossX;
    const dy = GetUnitY(guard) - bossY;
    if (dx * dx + dy * dy <= range2) result.push(guard);
  }
  return result;
}

function 刷新护主盾阵(this: void, state: 菲利斯第二军团状态): void {
  const boss = state.Boss单位;
  const cfg = 菲利斯数值与表现配置.第二军团护卫;
  if (!单位存活(boss)) return;
  const guards = 获取有效护卫列表(boss);
  const layer = guards.length < cfg.最大层数 ? guards.length : cfg.最大层数;
  state.护主盾阵层数 = layer;
  if (layer <= 0) {
    移除单位指定Buff(boss, 菲利斯BuffID.护主盾阵);
    return;
  }

  const buffDuration = cfg.检查间隔毫秒 / 1000 + 0.15;
  registerManualBuff(boss, 菲利斯BuffID.护主盾阵, buffDuration, layer * cfg.每层直接减伤比例, {
    sourceName: "菲利斯-护主盾阵",
    stack: layer,
  });

  for (let i = 0; i < guards.length; i++) {
    创建点特效({
      模型路径: cfg.守护特效路径,
      X: GetUnitX(guards[i]),
      Y: GetUnitY(guards[i]),
      缩放: cfg.守护特效缩放,
      持续秒: cfg.守护特效持续秒,
    });
    创建点特效({
      模型路径: cfg.守护特效路径,
      X: GetUnitX(boss),
      Y: GetUnitY(boss),
      缩放: cfg.守护特效缩放,
      持续秒: cfg.守护特效持续秒,
    });
  }
}

function 菲利斯护主盾阵伤害修正(this: void, context: any): number {
  if (context == null || 当前状态 == null || context.target !== 当前状态.Boss单位) {
    return context != null ? context.currentDamage : 0;
  }
  if (context.isDamageTransfer === true) return context.currentDamage;
  const currentDamage = Number(context.currentDamage);
  if (!(currentDamage > 0)) return currentDamage;
  const runtime = getBuffRuntime(context.target, 菲利斯BuffID.护主盾阵);
  if (runtime == null) return currentDamage;
  const ratio = Number(runtime.effect) || 0;
  if (!(ratio > 0)) return currentDamage;
  return currentDamage * (ratio < 1 ? 1 - ratio : 0);
}

function 获取有效术士(this: void, boss: any): any {
  const guards = 获取Boss护卫列表(boss, true);
  for (let i = 0; i < guards.length; i++) {
    if (单位存活(guards[i]) && GetUnitTypeId(guards[i]) === 第二军团术士类型ID) return guards[i];
  }
  return null;
}

function 术士充能完成回调(this: void, warlock: any, chargeId: number): void {
  const state = 当前状态;
  if (state == null) return;
  const record = state.当前术士施法;
  if (record == null || record.充能ID !== chargeId || record.术士单位 !== warlock) return;

  清理术士施法(state);
  if (单位存活(warlock)) SetUnitAnimation(warlock, "stand");
  if (!单位存活(state.Boss单位) || !单位存活(warlock)) return;
  结算腐蚀法阵(state, record);
}

function 术士充能结束回调(
  this: void,
  warlock: any,
  reason: "完成" | "中断" | "死亡" | "主单位死亡",
  chargeId: number,
): void {
  const state = 当前状态;
  if (state == null) return;
  const record = state.当前术士施法;
  if (record == null || record.充能ID !== chargeId || record.术士单位 !== warlock) return;

  清理术士施法(state);
  if (reason !== "完成" && 单位存活(warlock)) SetUnitAnimation(warlock, "stand");
}

function 开始腐蚀法阵施法(this: void, state: 菲利斯第二军团状态, warlock: any, target: any, now: number): void {
  const cfg = 菲利斯数值与表现配置.第二军团术士;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);

  const chargeId = 开始充能(warlock, {
    持续时间: cfg.施法秒,
    主单位: state.Boss单位,
    主单位死亡时中断: true,
    强制硬直: true,
    显示进度条特效: true,
    进度条特效动画速度: cfg.施法秒 > 0 ? 1 / cfg.施法秒 : 1,
    充能完成回调: 术士充能完成回调,
    结束回调: 术士充能结束回调,
  });
  if (chargeId <= 0) return;

  SetUnitAnimation(warlock, "Spell");
  创建点特效({
    模型路径: cfg.法阵预警特效路径,
    X: targetX,
    Y: targetY,
    缩放: cfg.法阵预警缩放,
    持续秒: cfg.法阵预警持续秒,
  });
  广播单位提示(warlock, "第二军团术士施放腐蚀法阵（1秒后在法阵原位置爆炸，离开法阵即可躲避！）", cfg.广播持续时间Ms);

  state.当前术士施法 = {
    术士单位: warlock,
    目标X: targetX,
    目标Y: targetY,
    充能ID: chargeId,
  };
  state.术士下次可施法Ms = now + cfg.共享冷却秒 * 1000;
}

function 结算腐蚀法阵(this: void, state: 菲利斯第二军团状态, record: 术士施法记录): void {
  const boss = state.Boss单位;
  const cfg = 菲利斯数值与表现配置.第二军团术士;
  const warlock = record.术士单位;
  if (!单位存活(boss) || !单位存活(warlock)) return;

  创建点特效({
    模型路径: cfg.爆炸特效路径,
    X: record.目标X,
    Y: record.目标Y,
    缩放: cfg.爆炸缩放,
    持续秒: cfg.爆炸持续秒,
  });

  const targets = 获取Boss技能敌对目标列表(boss);
  const radius2 = cfg.爆炸半径 * cfg.爆炸半径;
  const attack = 读取单位攻击力(warlock) * cfg.术士攻击力比例;
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位存活(target)) continue;
    const dx = GetUnitX(target) - record.目标X;
    const dy = GetUnitY(target) - record.目标Y;
    if (dx * dx + dy * dy > radius2) continue;
    const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
    const damage = attack + (maxLife > 0 ? maxLife * cfg.目标最大生命比例 : 0);
    if (damage > 0) {
      造成AOE技能伤害({
        来源: warlock,
        目标: target,
        伤害: damage,
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
        标签: "菲利斯-腐蚀法阵",
      });
    }
    if (!单位存活(target)) continue;
    施加快速减速Buff(warlock, target, cfg.减速比例, cfg.减速比例, cfg.减速持续秒, "菲利斯-腐蚀法阵", "技能");
    registerManualBuff(target, 菲利斯BuffID.腐蚀迟滞, cfg.减速持续秒, cfg.减速比例, {
      sourceName: "菲利斯-腐蚀法阵",
      stack: 1,
    });
  }
}

function 驱动术士(this: void, state: 菲利斯第二军团状态, now: number): void {
  if (state.当前术士施法 != null || now < state.术士下次可施法Ms) return;
  const warlock = 获取有效术士(state.Boss单位);
  if (!单位存活(warlock)) return;
  const target = 获取Boss技能最近敌对英雄(state.Boss单位);
  if (!单位存活(target)) return;
  开始腐蚀法阵施法(state, warlock, target, now);
}

export function 立即触发菲利斯第二军团随从测试(this: void, boss: any): boolean {
  if (!单位类型是菲利斯(boss) || !单位存活(boss)) return false;

  const now = getServerTime();
  const state = 获取或创建状态(boss, now);
  state.术士下次可施法Ms = now;
  刷新护主盾阵(state);
  if (state.当前术士施法 != null) return true;

  驱动术士(state, now);
  return state.当前术士施法 != null;
}

function 菲利斯第二军团Tick(this: void): void {
  const globalBoss = jglobals.udg_Boss;
  let boss = 单位类型是菲利斯(globalBoss) ? globalBoss : null;
  if (boss == null && 当前状态 != null && 单位类型是菲利斯(当前状态.Boss单位)) boss = 当前状态.Boss单位;
  if (!单位类型是菲利斯(boss) || !单位存活(boss)) {
    if (当前状态 != null) 清理状态(当前状态);
    return;
  }

  const now = getServerTime();
  const state = 获取或创建状态(boss, now);
  刷新护主盾阵(state);
  驱动术士(state, now);
}

function on菲利斯第二军团单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (当前状态 == null) return;
  if (当前状态.Boss单位 === dyingUnit) {
    清理状态(当前状态);
    return;
  }
  if (当前状态.当前术士施法 != null && 当前状态.当前术士施法.术士单位 === dyingUnit) {
    中断术士施法(当前状态);
  }
}

export function 注册菲利斯第二军团随从效果(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerDamageModifier(菲利斯护主盾阵伤害修正, 50);
  registerDeathListener(on菲利斯第二军团单位死亡);
  addPeriodicCallback(菲利斯数值与表现配置.第二军团护卫.检查间隔毫秒, 菲利斯第二军团Tick);
}
