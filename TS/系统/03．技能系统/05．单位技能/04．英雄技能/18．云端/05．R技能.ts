/** @noSelfInFile */
// 云端 R：暗黑制裁魔剑（A0KM）。3 秒硬直演出：退后冲刺→突进冲刺→目标升空 25 tick→结算暗伤+眩晕,敏捷翻倍保留至结算后 5 秒。
// 源 JASS 真源：R.j（入口 291-344；第一段 Func024T 243-289；第二段 Func008T 194-241；升空准备 Func009T 132-192；
// 升空周期 Func016T 73-130；结算 Func006T 22-71；敏捷回收 Func013T 4-20）。
// 同步/本地边界（计划 8.3）：暂停/无敌/敏捷/飞行高度/跳跃/伤害/眩晕全部同步；摄像机仅施法者拥有玩家本地。
// e03U 按物编参数转直接特效；e0BF 不存在于物编且无逻辑省略；A0KL 球体视觉壳省略（差异审计见计划）。

import { 云端技能配置 } from "./00．配置";
import { 云端BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/18．云端";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 两点角度, 距离XY } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 秒转毫秒 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
void 开始冲锋;
// 源两段冲刺 YDWETimerPatternRushSlide 均带 DeathCoilSpecialArt 尾迹,用冲锋残影表现模板模拟
const { 开始冲锋并附带残影表现 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.冲锋残影表现") as {
  开始冲锋并附带残影表现: (this: void, unit: any, params: any, 表现参数: any) => number;
};
const { 开始跳跃 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口") as {
  开始跳跃: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { GS_Suspend } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  GS_Suspend: (this: void, u: any, time: number) => void;
};
const { ModifyHeroStat, IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  ModifyHeroStat: (this: void, whichStat: number, whichHero: any, modifyMethod: number, value: number) => void;
  IsUnitAliveBJ: (this: void, unit: any) => boolean;
};
const {
  GetRandomDirectionDeg,
  SetCameraTargetControllerNoZForPlayer,
  SetCameraFieldForPlayer,
  ResetToGameCameraForPlayer,
} = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
  SetCameraTargetControllerNoZForPlayer: (this: void, p: any, u: any, xoff: number, yoff: number, inheritOrientation: boolean) => void;
  SetCameraFieldForPlayer: (this: void, p: any, field: any, value: number, duration: number) => void;
  ResetToGameCameraForPlayer: (this: void, p: any, duration: number) => void;
};
const { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动") as {
  CameraSetEQNoiseForPlayer: (this: void, whichPlayer: any, magnitude: number) => void;
  CameraClearNoiseForPlayer: (this: void, whichPlayer: any) => void;
};
// 源 PlaySoundOnUnitBJ(gg_snd_YD_R, 100, 施法者)：照源用 jglobals 全局音效句柄 + BJ 封装播放
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { CreateFloatTextOnUnit } = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetHeroAgi = jass.GetHeroAgi as (this: void, unit: any, includeBonuses: boolean) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const Player = jass.Player as (this: void, id: number) => any;
// IsUnitAliveBJ / GetRandomDirectionDeg / SetCameraTargetControllerNoZForPlayer 是 Blizzard.j 函数,
// 已从 lib.扩展函数.BJ函数 取（jass.common 只有 common.j native,从 jass 取运行时为 nil）
const PauseUnit = jass.PauseUnit as (this: void, unit: any, flag: boolean) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE as any;
const CAMERA_FIELD_FARZ = jass.CAMERA_FIELD_FARZ as any;
const CAMERA_FIELD_ANGLE_OF_ATTACK = jass.CAMERA_FIELD_ANGLE_OF_ATTACK as any;
const CAMERA_FIELD_FIELD_OF_VIEW = jass.CAMERA_FIELD_FIELD_OF_VIEW as any;
const CAMERA_FIELD_ROLL = jass.CAMERA_FIELD_ROLL as any;
const CAMERA_FIELD_ROTATION = jass.CAMERA_FIELD_ROTATION as any;
const CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const bj_HEROSTAT_AGI = jass.bj_HEROSTAT_AGI as number;
const bj_MODIFYMETHOD_ADD = jass.bj_MODIFYMETHOD_ADD as number;
const bj_MODIFYMETHOD_SUB = jass.bj_MODIFYMETHOD_SUB as number;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const 配置 = 云端技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const R类型ID = stringToFourCCSafe(配置.R.技能ID);
const 飞行技能类型ID = stringToFourCCSafe(配置.R.飞行技能ID);

interface R上下文 {
  施法者: any;
  目标: any;
  伤害快照: number;
  敏捷增量: number;
  敏捷已撤销: boolean;
  升空回调ID: number;
  SS: number;
  已清理: boolean;
  技能实例ID?: number;
}

const R上下文表: Record<number, R上下文> = {};

function 获取或创建R上下文(this: void, unit: any): R上下文 {
  const id = GetHandleId(unit);
  let ctx = R上下文表[id];
  if (ctx == null) {
    ctx = {
      施法者: unit,
      目标: null,
      伤害快照: 0,
      敏捷增量: 0,
      敏捷已撤销: false,
      升空回调ID: 0,
      SS: 0,
      已清理: false,
    };
    R上下文表[id] = ctx;
  }
  return ctx;
}

function R可释放(this: void, context: R上下文, _caster: any): boolean {
  return context.已清理 !== false || context.升空回调ID === 0;
}

function 全员震屏R(this: void, 强度: number): void {
  for (let i = 0; i < 10; i++) CameraSetEQNoiseForPlayer(Player(i), 强度);
}

function 全员清除震屏R(this: void, _variable: any): void {
  for (let i = 0; i < 10; i++) CameraClearNoiseForPlayer(Player(i));
}

function 撤销R敏捷(this: void, ctx: R上下文): void {
  if (ctx.敏捷已撤销) return;
  ctx.敏捷已撤销 = true;
  const caster = ctx.施法者;
  if (caster != null && caster !== 0) {
    ModifyHeroStat(bj_HEROSTAT_AGI, caster, bj_MODIFYMETHOD_SUB, ctx.敏捷增量);
  }
}

function 恢复R双方状态(this: void, ctx: R上下文): void {
  const caster = ctx.施法者;
  const target = ctx.目标;
  if (caster != null && caster !== 0) {
    GS_Suspend(caster, 0);
    SetUnitInvulnerable(caster, false);
    SetUnitTimeScale(caster, 1);
  }
  if (target != null && target !== 0) {
    PauseUnit(target, false);
    SetUnitInvulnerable(target, false);
    SetUnitFlyHeight(target, 0, 0);
  }
}

/** 全阶段统一清理（死亡/目标失效/正常结束共用,计划第 11 节）。 */
function 清理R全部(this: void, ctx: R上下文, 撤销敏捷: boolean): void {
  if (ctx.已清理) return;
  ctx.已清理 = true;
  if (ctx.升空回调ID !== 0) removePeriodicCallback(ctx.升空回调ID);
  ctx.升空回调ID = 0;
  恢复R双方状态(ctx);
  if (撤销敏捷) 撤销R敏捷(ctx);
  const caster = ctx.施法者;
  if (caster != null && caster !== 0) {
    const owner = GetOwningPlayer(caster);
    if (GetLocalPlayer() === owner) {
      ResetToGameCameraForPlayer(owner, 0.5);
      SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 3600, 0.5);
    }
  }
  全员清除震屏R(null);
}

function R结算(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null || ctx.已清理) return;
  const caster = ctx.施法者;
  const target = ctx.目标;
  const 目标有效 = target != null && target !== 0 && IsUnitAliveBJ(target);

  // 恢复双方状态（同步）
  ctx.已清理 = true; // 结算即视为演出清理完成,后续只剩敏捷回收
  if (ctx.升空回调ID !== 0) removePeriodicCallback(ctx.升空回调ID);
  ctx.升空回调ID = 0;
  恢复R双方状态(ctx);

  if (caster != null && caster !== 0 && IsUnitAliveBJ(caster) && 目标有效) {
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害: ctx.伤害快照,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      attack: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
      来源类型: "单位技能",
      标签: "云端-R暗黑制裁",
      技能ID: R类型ID,
      技能实例ID: ctx.技能实例ID,
    });
    施加眩晕(caster, target, 配置.R.眩晕秒, "云端-暗黑制裁", "技能");
    registerManualBuff(target, 云端BuffID.暗黑制裁眩晕, 配置.R.眩晕秒, 0);
  }

  if (caster != null && caster !== 0) {
    const owner = GetOwningPlayer(caster);
    if (GetLocalPlayer() === owner) {
      ResetToGameCameraForPlayer(owner, 0.5);
      SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 3600, 0.5);
    }
  }
  全员清除震屏R(null);

  // 结算后敏捷再保留 5 秒（计划 8.2.10：只撤销本实例增量）
  addDelayedCallback(
    秒转毫秒(配置.R.阶段.敏捷保留秒),
    R敏捷回收 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function R敏捷回收(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null) return;
  撤销R敏捷(ctx);
}

function R坠落表现(this: void, ctx: R上下文): void {
  const target = ctx.目标;
  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  // 源 e03U（DoomTarget/缩放1.5）按物编参数转直接特效,Z=400（计划 8.4）
  创建点特效({
    模型路径: 配置.R.坠落.表现模型,
    X: tx,
    Y: ty,
    Z: 配置.R.坠落.表现高度,
    面向角度: GetRandomDirectionDeg(),
    缩放: 配置.R.坠落.表现缩放,
    持续秒: 配置.R.坠落.表现持续秒,
  });
  开始跳跃(target, {
    角度: GetRandomDirectionDeg(),
    距离: 配置.R.坠落.跳跃.距离,
    持续时间: 配置.R.坠落.跳跃.持续时间秒,
    跳跃高度: 配置.R.坠落.跳跃.跳跃高度,
  });
  全员震屏R(配置.R.坠落.震屏强度);
  addDelayedCallback(
    秒转毫秒(配置.R.阶段.结算延迟秒),
    R结算 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function 推进R升空(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null || ctx.已清理) return;
  const caster = ctx.施法者;
  const target = ctx.目标;

  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    清理R全部(ctx, true);
    return;
  }
  if (target == null || target === 0 || !IsUnitAliveBJ(target)) {
    // 目标失效：不再设置飞行高度/伤害,恢复状态并撤销敏捷（计划第 11 节）
    清理R全部(ctx, true);
    return;
  }

  if (ctx.SS >= 配置.R.升空.最大Tick数) {
    if (ctx.升空回调ID !== 0) removePeriodicCallback(ctx.升空回调ID);
    ctx.升空回调ID = 0;
    R坠落表现(ctx);
    return;
  }

  ctx.SS += 1;
  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  SetUnitAnimation(target, "Death");
  SetUnitFlyHeight(target, 配置.R.升空.每Tick高度 * ctx.SS, 0);

  const owner = GetOwningPlayer(caster);
  if (GetLocalPlayer() === owner) {
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_ZOFFSET, 配置.R.升空.每Tick高度 * ctx.SS, 0);
  }

  for (let i = 0; i < 配置.R.升空.特效.length; i++) {
    const p = 配置.R.升空.特效[i];
    const z = (p as any).跟随SS === true ? 配置.R.升空.特效基础高度 * ctx.SS : p.高度;
    创建点特效({ 模型路径: p.模型, X: tx, Y: ty, Z: z, 面向角度: 270, 缩放: p.缩放, 持续秒: p.持续秒 });
  }
}

function R升空准备(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null || ctx.已清理) return;
  const caster = ctx.施法者;
  const target = ctx.目标;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    清理R全部(ctx, true);
    return;
  }
  if (target == null || target === 0 || !IsUnitAliveBJ(target)) {
    清理R全部(ctx, true);
    return;
  }

  PauseUnit(target, true);
  SetUnitInvulnerable(target, true);
  SetUnitTimeScale(caster, 1);
  SetUnitAnimation(caster, "Stand Cinematic");

  const owner = GetOwningPlayer(caster);
  if (GetLocalPlayer() === owner) {
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 1500, 1);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_ANGLE_OF_ATTACK, 335, 1);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_ROTATION, 108 * bj_DEGTORAD + GetUnitFacing(caster) * bj_DEGTORAD, 1);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_FIELD_OF_VIEW, 50, 1);
  }

  // 源：临时加/移除 Amrf 允许设置飞行高度
  UnitAddAbility(target, 飞行技能类型ID);
  UnitRemoveAbility(target, 飞行技能类型ID);

  全员震屏R(配置.R.升空.震屏强度);

  ctx.SS = 0;
  ctx.升空回调ID = addPeriodicCallback(
    秒转毫秒(配置.R.升空.Tick间隔秒),
    推进R升空 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function R第二段冲刺(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null || ctx.已清理) return;
  const caster = ctx.施法者;
  const target = ctx.目标;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster) || target == null || target === 0 || !IsUnitAliveBJ(target)) {
    清理R全部(ctx, true);
    return;
  }

  PauseUnit(target, true);
  SetUnitInvulnerable(target, true);

  // 源第二段：朝目标方向,距离 = 200 + 实时两者距离
  const 实时距离 = 距离XY(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target));
  const 角度 = 两点角度(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target));
  开始冲锋并附带残影表现(caster, {
    角度,
    距离: 配置.R.冲刺.第二段.基础距离 + 实时距离,
    持续时间: 配置.R.冲刺.第二段.持续时间秒,
    检查地形: true,
    禁用碰撞: true,
  }, {
    残影模型: 配置.R.冲刺.尾迹模型,
    动画名: 配置.R.冲刺.动作名,
    动画速度: 配置.R.冲刺.第一段流速,
  });

  addDelayedCallback(
    秒转毫秒(配置.R.阶段.升空准备延迟秒),
    R升空准备 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function R第一段冲刺(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null || ctx.已清理) return;
  const caster = ctx.施法者;
  const target = ctx.目标;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster) || target == null || target === 0 || !IsUnitAliveBJ(target)) {
    清理R全部(ctx, true);
    return;
  }

  PauseUnit(target, true);
  SetUnitInvulnerable(target, true);

  // 源第一段：朝目标反向退后 400（AngleBetweenPoints(b, a)）
  const 角度 = 两点角度(GetUnitX(target), GetUnitY(target), GetUnitX(caster), GetUnitY(caster));
  开始冲锋并附带残影表现(caster, {
    角度,
    距离: 配置.R.冲刺.第一段.距离,
    持续时间: 配置.R.冲刺.第一段.持续时间秒,
    检查地形: true,
    禁用碰撞: true,
  }, {
    残影模型: 配置.R.冲刺.尾迹模型,
    动画名: 配置.R.冲刺.动作名,
    动画速度: 配置.R.冲刺.第一段流速,
  });

  addDelayedCallback(
    秒转毫秒(配置.R.阶段.第二段延迟秒),
    R第二段冲刺 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function 释放R暗黑制裁(this: void, context: R上下文, caster: any, 技能实例ID?: number): void {
  const target = GetSpellTargetUnit();
  if (target == null || target === 0) {
    return;
  }

  // t=0 锁存（计划 8.2）
  const 等级 = GetUnitAbilityLevel(caster, R类型ID);
  const 伤害快照 = 读取单位攻击力(caster) * (配置.R.伤害公式.基础倍率 + 配置.R.伤害公式.每级加成 * 等级);
  const 敏捷增量 = GetHeroAgi(caster, false); // 源：基础敏捷立即翻倍,记录本实例增量

  context.施法者 = caster;
  context.目标 = target;
  context.伤害快照 = 伤害快照;
  context.敏捷增量 = 敏捷增量;
  context.敏捷已撤销 = false;
  context.升空回调ID = 0;
  context.SS = 0;
  context.已清理 = false;
  context.技能实例ID = 技能实例ID;

  GS_Suspend(caster, 配置.R.硬直秒);
  SetUnitInvulnerable(caster, true);
  PauseUnit(target, true);
  SetUnitInvulnerable(target, true);
  ModifyHeroStat(bj_HEROSTAT_AGI, caster, bj_MODIFYMETHOD_ADD, 敏捷增量);
  registerManualBuff(caster, 云端BuffID.暗黑敏捷翻倍, 配置.R.硬直秒 + 1.75 + 1.25 + 配置.R.阶段.结算延迟秒 + 配置.R.阶段.敏捷保留秒, 敏捷增量);

  SetUnitTimeScale(caster, 1);
  SetUnitAnimation(caster, 配置.R.起手动作名);

  // 源入口喊话漂浮字（TRIGSTR_188=“魔攻↑”,施法者头顶,蓝色）
  CreateFloatTextOnUnit(caster, 配置.R.起手漂浮字.文本, {
    size: 配置.R.起手漂浮字.尺寸,
    red: 0,
    green: 0,
    blue: 255,
    alpha: 配置.R.起手漂浮字.透明度,
    duration: 配置.R.起手漂浮字.持续秒,
    speedY: 配置.R.起手漂浮字.上浮速度,
    height: 配置.R.起手漂浮字.高度,
  });

  // 本地摄像机演出（仅施法者拥有玩家,不参与同步结算,计划 8.3）
  const owner = GetOwningPlayer(caster);
  if (GetLocalPlayer() === owner) {
    SetCameraTargetControllerNoZForPlayer(owner, caster, 0, 0, false);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_TARGET_DISTANCE, 2000, 1);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_FARZ, 10000, 0);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_ANGLE_OF_ATTACK, 345, 1);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_FIELD_OF_VIEW, 30, 1);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_ROLL, 0, 0);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_ROTATION, 90 * bj_DEGTORAD + GetUnitFacing(caster) * bj_DEGTORAD, 1);
    SetCameraFieldForPlayer(owner, CAMERA_FIELD_ZOFFSET, 100, 0);
  }

  // 源时序：镜头块之后播起手音效 PlaySoundOnUnitBJ(gg_snd_YD_R, 100, 施法者)
  const r音效句柄 = (jglobals as any)[配置.R.起手音效.全局音效键];
  if (r音效句柄 != null) PlaySoundOnUnitBJ(r音效句柄, 100, caster);

  addDelayedCallback(
    秒转毫秒(配置.R.阶段.第一段延迟秒),
    R第一段冲刺 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let 死亡监听已注册 = false;

function R单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (jass.GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  const ctx = R上下文表[GetHandleId(dyingUnit)];
  if (ctx == null || ctx.已清理) return;
  清理R全部(ctx, true);
}

export function 注册云端R(this: void): void {
  注册单位技能壳监听({
    名称: "云端-暗黑制裁魔剑（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.R.技能ID,
    获取或创建上下文: 获取或创建R上下文,
    可释放: R可释放,
    释放技能: 释放R暗黑制裁,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 12,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(R单位死亡清理);
  }
}

注册云端R();

export {};
