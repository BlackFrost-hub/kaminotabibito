/** @noSelfInFile */
// Saber Q：风王结界三段连击（A0DB/A0DC/A0DD）。
// 源 JASS 真源：主要技能.j（Q1: 238-386/99-324；Q2: 2211-2263/689-821；Q3: 2265-2329/822-1309）。
// 连击按钮切换（UnitAddAbility/UnitRemoveAbility/SetPlayerAbilityAvailable）为同步动作，直接保留。
// Q 命中去重组与连击段数见 01．状态表；整套连击共用命中去重。
// 差异审计：Q2 源创建的 e00D 马甲无技能无指令（纯泄露），不迁移；其余见 Saber迁移计划.md。

import { Saber技能配置 } from "./00．配置";
import { SaberBuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/08．Saber";
import {
  获取或创建Saber状态,
  获取Saber状态,
  SaberQ命中去重添加,
  SaberQ命中去重包含,
  Saber清空Q命中组,
} from "./01．状态表";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始冲锋, 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, u: any, 来源: string) => boolean;
  移除单位暂停: (this: void, u: any, 来源: string) => boolean;
};
const { getCooldownReduction } = require("系统.03．技能系统.01．技能冷却.01．冷却缩减计算") as {
  getCooldownReduction: (this: void, unit: any) => number;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 创建点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const SetUnitTurnSpeed = jass.SetUnitTurnSpeed as (this: void, unit: any, speed: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const IsUnitVisible = jass.IsUnitVisible as (this: void, unit: any, player: any) => boolean;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const EXSetUnitMoveType = japi.EXSetUnitMoveType as (this: void, unit: any, moveType: number) => void;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = Saber技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const Q初段ID = stringToFourCC(配置.Q.初段.技能ID);
const Q连击2ID = stringToFourCC(配置.Q.连击2.技能ID);
const Q连击3ID = stringToFourCC(配置.Q.连击3.技能ID);

// ---------------------------------------------------------------------------
// 工具函数
// ---------------------------------------------------------------------------

function 计算两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG;
}

/** 目标是否位于施法者前方 180 度（源：左右各 90 度判定，含 0/360 跨界归一化）。 */
function 在前方半圆(this: void, caster: any, target: any): boolean {
  const 面向 = GetUnitFacing(caster);
  const 目标角 = 计算两点角度(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target));
  let 差值 = (目标角 - 面向) % 360;
  if (差值 < 0) 差值 += 360;
  return 差值 <= 90 || 差值 >= 270;
}

/** Q 劈砍目标过滤：存活、可见、非古树、非机械、未被本套连击命中过。 */
function 过滤Q劈砍目标(this: void, caster: any, 敌军列表: any[]): any[] {
  const owner = GetOwningPlayer(caster);
  const 结果: any[] = [];
  for (const target of 敌军列表) {
    if (target == null || target === 0) continue;
    if (!单位存活(target)) continue;
    if (IsUnitType(target, UNIT_TYPE_ANCIENT)) continue;
    if (IsUnitType(target, UNIT_TYPE_MECHANICAL)) continue;
    if (!IsUnitVisible(target, owner)) continue;
    if (SaberQ命中去重包含(caster, target)) continue;
    if (!在前方半圆(caster, target)) continue;
    结果.push(target);
  }
  return 结果;
}

/** 源刀光特效点：Saber 位置 +160@(面向+90) 再 +120@面向。 */
function 计算刀光点(this: void, caster: any): { X: number; Y: number } {
  const 面向 = GetUnitFacing(caster);
  const 弧度侧 = (面向 + 90) * bj_DEGTORAD;
  const 中X = GetUnitX(caster) + 配置.Q.初段.刀光.侧向偏移 * Cos(弧度侧);
  const 中Y = GetUnitY(caster) + 配置.Q.初段.刀光.侧向偏移 * Sin(弧度侧);
  const 弧度前 = 面向 * bj_DEGTORAD;
  return {
    X: 中X + 配置.Q.初段.刀光.前向偏移 * Cos(弧度前),
    Y: 中Y + 配置.Q.初段.刀光.前向偏移 * Sin(弧度前),
  };
}

function 播放刀光(this: void, caster: any, 持续秒: number): void {
  const 点 = 计算刀光点(caster);
  创建点特效({
    模型路径: 配置.Q.初段.刀光.模型路径,
    X: 点.X,
    Y: 点.Y,
    Z: 配置.Q.初段.刀光.高度增量 + GetUnitFlyHeight(caster),
    X轴角度: 90,
    Z轴角度: GetUnitFacing(caster),
    动画速度: 配置.Q.初段.刀光.动画速度,
    持续秒,
  });
}

interface 目标表现上下文 {
  target: any;
}

function 恢复Q目标表现(this: void, variable?: any): void {
  const ctx = variable as 目标表现上下文 | undefined;
  if (ctx == null) return;
  const target = ctx.target;
  if (target == null || target === 0 || !单位存活(target)) return;
  SetUnitAnimation(target, "stand");
  SetUnitTimeScale(target, 1.0);
}

/** 命中目标表现：Death 动作 + 时间流速 + 沿角度击退（源：关闭碰撞后 10×10/0.02 秒前移 ≈ 100 码）。 */
function 应用Q目标命中表现(this: void, caster: any, target: any, 角度: number, 击退配置: { 每次距离: number; 间隔秒: number; 次数: number }): void {
  SetUnitAnimation(target, "Death");
  SetUnitTimeScale(target, 配置.Q.初段.劈砍.目标动作时间流速);
  开始击退(target, {
    角度,
    距离: 击退配置.每次距离 * 击退配置.次数,
    持续时间: 击退配置.间隔秒 * 击退配置.次数,
    检查地形: true,
    暂停单位: false,
    禁用碰撞: true,
    主单位死亡时中断: false,
  });
  addDelayedCallback(
    Math.round((击退配置.间隔秒 * 击退配置.次数 + 0.05) * 1000),
    恢复Q目标表现 as unknown as (this: void, variable?: any) => void,
    { target } as 目标表现上下文,
  );
}

interface 劈砍参数 {
  控制秒: number;
  伤害: number;
  命中特效持续秒: number;
  击退配置: { 每次距离: number; 间隔秒: number; 次数: number };
  标签: string;
  技能类型ID: number;
  技能实例ID?: number;
}

/** 前方 180 度半径 300 劈砍：控制 -> 特效 -> 伤害（源顺序固定），命中去重整套连击共用。 */
function 结算Q前方劈砍(this: void, caster: any, 参数: 劈砍参数): void {
  if (!单位存活(caster)) return;
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const 目标列表 = 过滤Q劈砍目标(caster, 获取范围敌军(caster, x, y, 配置.Q.初段.劈砍.半径));
  const 方向 = GetUnitFacing(caster);
  for (const target of 目标列表) {
    SaberQ命中去重添加(caster, target);
    施加眩晕(caster, target, 参数.控制秒, SaberBuffID.风王硬直, "技能");
    registerManualBuff(target, SaberBuffID.风王硬直, 参数.控制秒, 0, { 来源: caster, 标签: 参数.标签 });
    createTimedUnitEffect(target, 配置.Q.初段.劈砍.命中特效.挂点, 配置.Q.初段.劈砍.命中特效.模型路径, 参数.命中特效持续秒);
    if (参数.伤害 > 0) {
      造成单体技能伤害({
        来源: caster,
        目标: target,
        伤害: 参数.伤害,
        伤害类型: DAMAGE_TYPE_NORMAL,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
        来源类型: "单位技能",
        标签: 参数.标签,
        技能ID: 参数.技能类型ID,
        技能实例ID: 参数.技能实例ID,
      });
    }
    应用Q目标命中表现(caster, target, 方向, 参数.击退配置);
  }
}

// ---------------------------------------------------------------------------
// Q 初段 A0DB
// ---------------------------------------------------------------------------

interface Q初段上下文 {
  施法者: any;
  已启动: boolean;
  技能实例ID?: number;
  伤害快照: number;
  方向角度: number;
  目标点X: number;
  目标点Y: number;
}

const Q初段上下文表: Record<number, Q初段上下文> = {};

function 获取或创建Q初段上下文(this: void, caster: any): Q初段上下文 {
  const id = GetHandleId(caster);
  let record = Q初段上下文表[id];
  if (record == null) {
    record = { 施法者: caster, 已启动: false, 伤害快照: 0, 方向角度: 0, 目标点X: 0, 目标点Y: 0 };
    Q初段上下文表[id] = record;
  }
  return record;
}

function Q初段可释放(this: void, _context: Q初段上下文, caster: any): boolean {
  const record = 获取Saber状态(caster);
  if (record != null && record.Q连击 !== 0) return false;
  const ctx = 获取或创建Q初段上下文(caster);
  return !ctx.已启动;
}

function Q1冲锋命中回调(this: void, 移动单位: any, 目标单位: any, _位移ID: number): void {
  if (目标单位 == null || 目标单位 === 0 || !单位存活(目标单位)) return;
  // 源：命中的 tick 将前方目标沿冲锋方向推 40 码
  开始击退(目标单位, {
    角度: GetUnitFacing(移动单位),
    距离: 40,
    持续时间: 0.1,
    检查地形: true,
    暂停单位: false,
    禁用碰撞: false,
  });
}

function Q1命中后劈砍(this: void, variable?: any): void {
  const ctx = variable as Q初段上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (!单位存活(caster)) return;

  播放刀光(caster, 配置.Q.初段.刀光.持续秒);
  结算Q前方劈砍(caster, {
    控制秒: 配置.Q.初段.劈砍.控制秒,
    伤害: ctx.伤害快照 * 配置.Q.初段.劈砍.伤害倍率,
    命中特效持续秒: 配置.Q.初段.劈砍.命中特效.持续秒,
    击退配置: 配置.Q.初段.劈砍.目标击退,
    标签: "Saber-Q-初段劈砍",
    技能类型ID: Q初段ID,
    技能实例ID: ctx.技能实例ID,
  });

  // 源收尾：解除 Saber 暂停、关闭初段、开放连击 2、恢复时间流速
  移除单位暂停(caster, 配置.暂停来源.Q初段);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), Q初段ID, false);
  UnitAddAbility(caster, Q连击2ID);
  SetUnitTimeScale(caster, 1.0);

  // 连击窗口：0.5 秒后仍停留在连击 1 则复位按钮
  addDelayedCallback(
    Math.round(配置.Q.初段.连击窗口秒 * 1000),
    Q初段窗口复位 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
  ctx.已启动 = false;
}

function Q初段窗口复位(this: void, variable?: any): void {
  const ctx = variable as Q初段上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0) return;
  const record = 获取Saber状态(caster);
  if (record == null || record.Q连击 !== 1) return;
  record.Q连击 = 0;
  SetUnitTurnSpeed(caster, 1.0);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), Q初段ID, true);
  UnitRemoveAbility(caster, Q连击2ID);
}

function Q1未命中收尾(this: void, variable?: any): void {
  const ctx = variable as Q初段上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  ctx.已启动 = false;
  if (caster == null || caster === 0 || !单位存活(caster)) return;

  const record = 获取Saber状态(caster);
  if (record != null) record.Q连击 = 0;
  SetUnitTimeScale(caster, 1.0);

  // 源：未命中停止 Q 音效，Q 冷却设置为 4 - 4×冷却缩减（缩减上限 35%）
  let 缩减 = getCooldownReduction(caster);
  if (缩减 > 配置.Q.初段.未命中冷却.冷却缩减上限) 缩减 = 配置.Q.初段.未命中冷却.冷却缩减上限;
  const 目标冷却 = 配置.Q.初段.未命中冷却.基础冷却秒 - 配置.Q.初段.未命中冷却.基础冷却秒 * 缩减;
  技能_设置技能冷却时间(caster, Q初段ID, 目标冷却, 配置.Q.初段.物编冷却秒);
}

function Q1冲锋结束(this: void, 移动单位: any, 原因: string, _位移ID: number, 命中目标?: any): void {
  const record = 获取或创建Q初段上下文(移动单位);
  if (原因 === "死亡" || 原因 === "主单位死亡") {
    record.已启动 = false;
    return;
  }
  if (原因 === "命中" || (命中目标 != null && 命中目标 !== 0)) {
    // 源：命中后 Saber 硬直、动作索引 9、时间流速 2，0.30 秒后劈砍
    添加单位暂停(移动单位, 配置.暂停来源.Q初段);
    SetUnitAnimationByIndex(移动单位, 配置.Q.初段.命中后.动作索引);
    SetUnitTimeScale(移动单位, 配置.Q.初段.命中后.时间流速);
    addDelayedCallback(
      Math.round(配置.Q.初段.命中后.硬直延迟秒 * 1000),
      Q1命中后劈砍 as unknown as (this: void, variable?: any) => void,
      record,
    );
  } else {
    Q1未命中收尾(record);
  }
}

function Q1启动冲锋(this: void, variable?: any): void {
  const ctx = variable as Q初段上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    ctx.已启动 = false;
    return;
  }

  ctx.方向角度 = 计算两点角度(GetUnitX(caster), GetUnitY(caster), ctx.目标点X, ctx.目标点Y);
  Sound3DII_UnitPlayReuse(配置.Q.初段.音效.路径, caster, 配置.Q.初段.音效.裁断距离);
  SetUnitTimeScale(caster, 配置.Q.初段.时间流速);
  SetUnitAnimationByIndex(caster, 配置.Q.初段.动作索引);

  开始冲锋(caster, {
    角度: ctx.方向角度,
    距离: 配置.Q.初段.冲锋.最大距离,
    持续时间: 配置.Q.初段.冲锋.推进间隔秒 * 配置.Q.初段.冲锋.最大推进次数,
    检查地形: true,
    朝向跟随位移: true,
    动画序号: 配置.Q.初段.动作索引,
    命中半径: 配置.Q.初段.冲锋.命中半径,
    只命中敌人: true,
    命中后结束: true,
    命中回调: Q1冲锋命中回调,
    结束回调: Q1冲锋结束,
  });
}

function 释放Q初段(this: void, context: Q初段上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;
  context.已启动 = true;
  context.施法者 = caster;
  context.技能实例ID = 技能实例ID;
  context.伤害快照 = 读取单位攻击力(caster) * 配置.Q.初段.伤害攻击力倍率;
  context.目标点X = GetSpellTargetX();
  context.目标点Y = GetSpellTargetY();

  const record = 获取或创建Saber状态(caster);
  record.Q连击 = 1;

  addDelayedCallback(
    Math.round(配置.Q.初段.起手延迟秒 * 1000),
    Q1启动冲锋 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// ---------------------------------------------------------------------------
// Q 连击 2 A0DC
// ---------------------------------------------------------------------------

interface Q连击2上下文 {
  施法者: any;
  已启动: boolean;
  技能实例ID?: number;
  伤害快照: number;
}

const Q连击2上下文表: Record<number, Q连击2上下文> = {};

function 获取或创建Q连击2上下文(this: void, caster: any): Q连击2上下文 {
  const id = GetHandleId(caster);
  let record = Q连击2上下文表[id];
  if (record == null) {
    record = { 施法者: caster, 已启动: false, 伤害快照: 0 };
    Q连击2上下文表[id] = record;
  }
  return record;
}

function Q连击2可释放(this: void, _context: Q连击2上下文, caster: any): boolean {
  const record = 获取Saber状态(caster);
  return record != null && record.Q连击 === 1;
}

function 沿面向瞬步(this: void, caster: any, 距离: number): void {
  const 弧度 = GetUnitFacing(caster) * bj_DEGTORAD;
  jass.SetUnitX(caster, GetUnitX(caster) + 距离 * Cos(弧度));
  jass.SetUnitY(caster, GetUnitY(caster) + 距离 * Sin(弧度));
}

function Q2第一段劈砍(this: void, variable?: any): void {
  const ctx = variable as Q连击2上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (!单位存活(caster)) return;

  播放刀光(caster, 配置.Q.连击2.第一段.刀光持续秒);
  结算Q前方劈砍(caster, {
    控制秒: 配置.Q.连击2.第一段.控制秒,
    伤害: ctx.伤害快照 * 配置.Q.连击2.第一段.伤害倍率,
    命中特效持续秒: 配置.Q.连击2.第一段.命中特效.持续秒,
    击退配置: 配置.Q.连击2.第一段.目标击退,
    标签: "Saber-Q-连击2第一段",
    技能类型ID: Q连击2ID,
    技能实例ID: ctx.技能实例ID,
  });

  // 过渡：时间流速恢复、动作索引 7、再向前 75
  addDelayedCallback(
    Math.round(配置.Q.连击2.过渡.延迟秒 * 1000),
    Q2过渡 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function Q2过渡(this: void, variable?: any): void {
  const ctx = variable as Q连击2上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (!单位存活(caster)) return;
  SetUnitTimeScale(caster, 1.0);
  SetUnitAnimationByIndex(caster, 配置.Q.连击2.过渡.动作索引);
  沿面向瞬步(caster, 配置.Q.连击2.过渡.前移距离);
  addDelayedCallback(
    Math.round(配置.Q.连击2.第二段.延迟秒 * 1000),
    Q2第二段劈砍 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function Q2第二段劈砍(this: void, variable?: any): void {
  const ctx = variable as Q连击2上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (!单位存活(caster)) return;

  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const 目标列表 = 过滤Q劈砍目标(caster, 获取范围敌军(caster, x, y, 配置.Q.连击2.第二段.半径));
  const 方向 = GetUnitFacing(caster);
  for (const target of 目标列表) {
    SaberQ命中去重添加(caster, target);
    // 源：目标前方 75 创建 e061 风王结界表现（物编缩放 1.5×运行时 1.5）
    const 弧度 = 计算两点角度(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target)) * bj_DEGTORAD;
    创建点特效({
      模型路径: 配置.Q.连击2.第二段.表现特效.模型路径,
      X: GetUnitX(target) + 配置.Q.连击2.第二段.表现特效.目标前方偏移 * Cos(弧度),
      Y: GetUnitY(target) + 配置.Q.连击2.第二段.表现特效.目标前方偏移 * Sin(弧度),
      面向角度: 方向 + 90,
      X轴角度: -90, // e061 物编 maxRoll=-90 的等效
      缩放: 配置.Q.连击2.第二段.表现特效.缩放,
      持续秒: 配置.Q.连击2.第二段.表现特效.持续秒,
    });
    施加眩晕(caster, target, 配置.Q.连击2.第二段.控制秒, SaberBuffID.风王硬直, "技能");
    registerManualBuff(target, SaberBuffID.风王硬直, 配置.Q.连击2.第二段.控制秒, 0, { 来源: caster, 标签: "Saber-Q-连击2第二段" });
    createTimedUnitEffect(target, 配置.Q.连击2.第二段.命中特效.挂点, 配置.Q.连击2.第二段.命中特效.模型路径, 配置.Q.连击2.第二段.命中特效.持续秒);
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害: ctx.伤害快照 * 配置.Q.连击2.第二段.伤害倍率,
      伤害类型: DAMAGE_TYPE_NORMAL,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
      来源类型: "单位技能",
      标签: "Saber-Q-连击2第二段",
      技能ID: Q连击2ID,
      技能实例ID: ctx.技能实例ID,
    });
    应用Q目标命中表现(caster, target, 方向, 配置.Q.连击2.第二段.目标击退);
  }

  // 源收尾：恢复时间流速、添加连击 3、解除 Saber 暂停
  SetUnitTimeScale(caster, 1.0);
  UnitAddAbility(caster, Q连击3ID);
  移除单位暂停(caster, 配置.暂停来源.Q连击2);

  addDelayedCallback(
    Math.round(配置.Q.连击2.连击窗口秒 * 1000),
    Q连击2窗口复位 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
  ctx.已启动 = false;
}

function Q连击2窗口复位(this: void, variable?: any): void {
  const ctx = variable as Q连击2上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0) return;
  const record = 获取Saber状态(caster);
  if (record == null || record.Q连击 !== 2) return;
  record.Q连击 = 0;
  SetUnitTurnSpeed(caster, 1.0);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), Q初段ID, true);
  UnitRemoveAbility(caster, Q连击3ID);
}

function 释放Q连击2(this: void, context: Q连击2上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;
  const record = 获取或创建Saber状态(caster);
  if (record.Q连击 !== 1) return;
  record.Q连击 = 2;

  context.已启动 = true;
  context.施法者 = caster;
  context.技能实例ID = 技能实例ID;
  context.伤害快照 = 读取单位攻击力(caster) * 配置.Q.连击2.伤害攻击力倍率;

  SetUnitTurnSpeed(caster, 0);
  Sound3DII_UnitPlayReuse(配置.Q.连击2.音效.路径, caster, 配置.Q.连击2.音效.裁断距离);
  添加单位暂停(caster, 配置.暂停来源.Q连击2);
  SetUnitTimeScale(caster, 配置.Q.连击2.时间流速);
  UnitRemoveAbility(caster, Q连击2ID);
  SetUnitAnimationByIndex(caster, 配置.Q.连击2.动作索引);
  沿面向瞬步(caster, 配置.Q.连击2.前移距离);

  addDelayedCallback(
    Math.round(配置.Q.连击2.第一段.延迟秒 * 1000),
    Q2第一段劈砍 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// ---------------------------------------------------------------------------
// Q 连击 3 A0DD
// ---------------------------------------------------------------------------

interface Q连击3上下文 {
  施法者: any;
  已启动: boolean;
  技能实例ID?: number;
  伤害快照: number;
  上升回调ID: number;
  上升次数: number;
  下降回调ID: number;
  下降次数: number;
}

const Q连击3上下文表: Record<number, Q连击3上下文> = {};

function 获取或创建Q连击3上下文(this: void, caster: any): Q连击3上下文 {
  const id = GetHandleId(caster);
  let record = Q连击3上下文表[id];
  if (record == null) {
    record = {
      施法者: caster,
      已启动: false,
      伤害快照: 0,
      上升回调ID: 0,
      上升次数: 0,
      下降回调ID: 0,
      下降次数: 0,
    };
    Q连击3上下文表[id] = record;
  }
  return record;
}

function Q连击3可释放(this: void, _context: Q连击3上下文, caster: any): boolean {
  const record = 获取Saber状态(caster);
  return record != null && record.Q连击 === 2;
}

function 推进Q3上升(this: void, variable?: any): void {
  const ctx = variable as Q连击3上下文 | undefined;
  if (ctx == null) return;
  if (ctx.上升次数 >= 配置.Q.连击3.上升.次数) {
    if (ctx.上升回调ID !== 0) removePeriodicCallback(ctx.上升回调ID);
    ctx.上升回调ID = 0;
    return;
  }
  const caster = ctx.施法者;
  if (!单位存活(caster)) {
    if (ctx.上升回调ID !== 0) removePeriodicCallback(ctx.上升回调ID);
    ctx.上升回调ID = 0;
    return;
  }
  ctx.上升次数 += 1;
  SetUnitFlyHeight(caster, GetUnitFlyHeight(caster) + 配置.Q.连击3.上升.每次高度, 0);
}

function 推进Q3下降(this: void, variable?: any): void {
  const ctx = variable as Q连击3上下文 | undefined;
  if (ctx == null) return;
  if (ctx.下降次数 >= 配置.Q.连击3.下降.次数) {
    if (ctx.下降回调ID !== 0) removePeriodicCallback(ctx.下降回调ID);
    ctx.下降回调ID = 0;
    return;
  }
  const caster = ctx.施法者;
  if (!单位存活(caster)) {
    if (ctx.下降回调ID !== 0) removePeriodicCallback(ctx.下降回调ID);
    ctx.下降回调ID = 0;
    return;
  }
  ctx.下降次数 += 1;
  SetUnitFlyHeight(caster, GetUnitFlyHeight(caster) + 配置.Q.连击3.下降.每次高度, 0);
}

function Q3第一段劈砍(this: void, variable?: any): void {
  const ctx = variable as Q连击3上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (!单位存活(caster)) return;
  结算Q前方劈砍(caster, {
    控制秒: 配置.Q.连击3.第一段.控制秒,
    伤害: ctx.伤害快照 * 配置.Q.连击3.第一段.伤害倍率,
    命中特效持续秒: 配置.Q.连击3.第一段.命中特效.持续秒,
    击退配置: 配置.Q.连击3.第一段.目标击退,
    标签: "Saber-Q-连击3第一段",
    技能类型ID: Q连击3ID,
    技能实例ID: ctx.技能实例ID,
  });
  addDelayedCallback(
    Math.round(配置.Q.连击3.过渡.延迟秒 * 1000),
    Q3过渡 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function Q3过渡(this: void, variable?: any): void {
  const ctx = variable as Q连击3上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (!单位存活(caster)) return;
  沿面向瞬步(caster, 配置.Q.连击3.过渡.前移距离);
  SetUnitAnimationByIndex(caster, 配置.Q.连击3.过渡.动作索引);
  ctx.下降次数 = 0;
  ctx.下降回调ID = addPeriodicCallback(
    Math.round(配置.Q.连击3.下降.间隔秒 * 1000),
    推进Q3下降 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
  addDelayedCallback(
    Math.round(配置.Q.连击3.第二段.延迟秒 * 1000),
    Q3第二段劈砍 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function Q3第二段劈砍(this: void, variable?: any): void {
  const ctx = variable as Q连击3上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (!单位存活(caster)) return;

  播放刀光(caster, 配置.Q.连击3.第二段.刀光持续秒);
  结算Q前方劈砍(caster, {
    控制秒: 配置.Q.连击3.第二段.控制秒, // 源 e00D+A0DI 风暴之锤 0.75 秒，迁移为同步控制
    伤害: ctx.伤害快照 * 配置.Q.连击3.第二段.伤害倍率, // 快照×3 = 攻击力×1.5（说明 150%）
    命中特效持续秒: 配置.Q.连击3.第二段.命中特效.持续秒,
    击退配置: 配置.Q.连击3.第二段.目标击退,
    标签: "Saber-Q-连击3第二段",
    技能类型ID: Q连击3ID,
    技能实例ID: ctx.技能实例ID,
  });

  // 源收尾：恢复时间流速、解除暂停
  SetUnitTimeScale(caster, 1.0);
  移除单位暂停(caster, 配置.暂停来源.Q连击3);
  EXSetUnitMoveType(caster, 0x01); // 恢复地面移动类型
  SetUnitFlyHeight(caster, 0, 0);

  addDelayedCallback(
    Math.round(配置.Q.连击3.复位延迟秒 * 1000),
    Q3复位 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
  ctx.已启动 = false;
}

function Q3复位(this: void, variable?: any): void {
  const ctx = variable as Q连击3上下文 | undefined;
  if (ctx == null) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0) return;
  const record = 获取Saber状态(caster);
  if (record == null) return;
  record.Q连击 = 0;
  SetUnitTurnSpeed(caster, 1.0);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), Q初段ID, true);
  UnitRemoveAbility(caster, Q连击3ID);
  Saber清空Q命中组(caster);
}

function 释放Q连击3(this: void, context: Q连击3上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;
  const record = 获取或创建Saber状态(caster);
  if (record.Q连击 !== 2) return;
  record.Q连击 = 3;

  context.已启动 = true;
  context.施法者 = caster;
  context.技能实例ID = 技能实例ID;
  context.伤害快照 = 读取单位攻击力(caster) * 配置.Q.连击3.伤害攻击力倍率;
  context.上升次数 = 0;
  context.下降次数 = 0;

  SetUnitTurnSpeed(caster, 1.0);
  添加单位暂停(caster, 配置.暂停来源.Q连击3);
  Sound3DII_UnitPlayReuse(配置.Q.连击3.音效.路径, caster, 配置.Q.连击3.音效.裁断距离);
  UnitRemoveAbility(caster, Q连击3ID);
  SetPlayerAbilityAvailable(GetOwningPlayer(caster), Q初段ID, true);
  EXSetUnitMoveType(caster, 0x02); // 源 YDWEFlyEnable：启用飞行以上升表现
  SetUnitTimeScale(caster, 配置.Q.连击3.时间流速);
  SetUnitAnimationByIndex(caster, 配置.Q.连击3.动作索引);
  沿面向瞬步(caster, 配置.Q.连击3.前移距离);

  context.上升回调ID = addPeriodicCallback(
    Math.round(配置.Q.连击3.上升.间隔秒 * 1000),
    推进Q3上升 as unknown as (this: void, variable?: any) => void,
    context,
  );
  addDelayedCallback(
    Math.round(配置.Q.连击3.第一段.延迟秒 * 1000),
    Q3第一段劈砍 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let 死亡监听已注册 = false;

function Q单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (jass.GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;

  const record = 获取Saber状态(dyingUnit);
  if (record == null || record.Q连击 === 0) return;
  record.Q连击 = 0;
  Saber清空Q命中组(dyingUnit);

  移除单位暂停(dyingUnit, 配置.暂停来源.Q初段);
  移除单位暂停(dyingUnit, 配置.暂停来源.Q连击2);
  移除单位暂停(dyingUnit, 配置.暂停来源.Q连击3);
  SetPlayerAbilityAvailable(GetOwningPlayer(dyingUnit), Q初段ID, true);
  UnitRemoveAbility(dyingUnit, Q连击2ID);
  UnitRemoveAbility(dyingUnit, Q连击3ID);

  const ctx1 = Q初段上下文表[GetHandleId(dyingUnit)];
  if (ctx1 != null) ctx1.已启动 = false;
  const ctx2 = Q连击2上下文表[GetHandleId(dyingUnit)];
  if (ctx2 != null) ctx2.已启动 = false;
  const ctx3 = Q连击3上下文表[GetHandleId(dyingUnit)];
  if (ctx3 != null) {
    ctx3.已启动 = false;
    if (ctx3.上升回调ID !== 0) removePeriodicCallback(ctx3.上升回调ID);
    if (ctx3.下降回调ID !== 0) removePeriodicCallback(ctx3.下降回调ID);
    ctx3.上升回调ID = 0;
    ctx3.下降回调ID = 0;
  }
}

export function 注册SaberQ(this: void): void {
  注册单位技能壳监听({
    名称: "Saber-风王结界初段（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.Q.初段.技能ID,
    获取或创建上下文: 获取或创建Q初段上下文,
    可释放: Q初段可释放,
    释放技能: 释放Q初段,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 8,
  });
  注册单位技能壳监听({
    名称: "Saber-风王结界连击2（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.Q.连击2.技能ID,
    获取或创建上下文: 获取或创建Q连击2上下文,
    可释放: Q连击2可释放,
    释放技能: 释放Q连击2,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 5,
  });
  注册单位技能壳监听({
    名称: "Saber-风王结界连击3（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.Q.连击3.技能ID,
    获取或创建上下文: 获取或创建Q连击3上下文,
    可释放: Q连击3可释放,
    释放技能: 释放Q连击3,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 5,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(Q单位死亡清理);
  }
}

注册SaberQ();

export {};
