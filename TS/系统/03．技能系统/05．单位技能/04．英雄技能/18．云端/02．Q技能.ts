/** @noSelfInFile */
// 云端 Q：冰火魔剑（A0KN）。随机火/冰剑，冲锋至目标后结算单体伤害 + 灼烧/减速。
// 源 JASS 真源：Q技能.j（入口 140-190；冲锋周期 Func015T 50-138；灼烧周期 Func006Func010T 4-24；震屏清理 Func008T 26-48）。
// 冲突口径：灼烧次数源实际 2 次（tick3 即停），介绍明确"3 次额外伤害"——按介绍取 3 次（差异审计见计划）。
// 源马甲（e07G 换模型 finalfield）与源未初始化的朝向变量 b 按 5.3 节修正：锁存目标位置后计算朝向。

import { 云端技能配置 } from "./00．配置";
import { 云端BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/18．云端";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { registerSpellEndcastListener } from "../../../../00．核心系统/01．事件中心/08．技能事件中心";

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
const { 开始跳跃 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.03．对外接口") as {
  开始跳跃: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, source: any, target: any, reduceRatio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { GS_Suspend } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  GS_Suspend: (this: void, u: any, time: number) => void;
};
const { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动") as {
  CameraSetEQNoiseForPlayer: (this: void, whichPlayer: any, magnitude: number) => void;
  CameraClearNoiseForPlayer: (this: void, whichPlayer: any) => void;
};
// 源 PlaySoundOnUnitBJ(gg_snd_effect_sound / gg_snd_effect_sound13)：照源用 jglobals 全局音效句柄 + BJ 封装播放
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
// IsUnitAliveBJ / GetRandomDirectionDeg 是 Blizzard.j 函数，从 BJ 函数库取（jass.common 取到的是 nil）
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, unit: any) => boolean;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const Player = jass.Player as (this: void, id: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const SquareRoot = jass.SquareRoot as (this: void, x: number) => number;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 秒转毫秒, 向下取整整数 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算") as {
  秒转毫秒: (this: void, seconds: number) => number;
  向下取整整数: (this: void, value: number) => number;
};

const 配置 = 云端技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const Q类型ID = stringToFourCCSafe(配置.Q.技能ID);

interface Q上下文 {
  施法者: any;
  目标: any;
  分支: "火" | "冰";
  伤害快照: number;
  技能实例ID?: number;
  灼烧回调ID: number;
  灼烧次数: number;
  已启动: boolean;
}

const Q上下文表: Record<number, Q上下文> = {};

function 获取或创建Q上下文(this: void, unit: any): Q上下文 {
  const id = GetHandleId(unit);
  let ctx = Q上下文表[id];
  if (ctx == null) {
    ctx = {
      施法者: unit,
      目标: null,
      分支: "火",
      伤害快照: 0,
      灼烧回调ID: 0,
      灼烧次数: 0,
      已启动: false,
    };
    Q上下文表[id] = ctx;
  }
  return ctx;
}

function Q可释放(this: void, context: Q上下文, _caster: any): boolean {
  return context.已启动 !== true;
}

function 全员震屏(this: void, 强度: number): void {
  // 源：ConvertedPlayer(1..10) 全员震动，同步 API 所有玩家调用顺序一致
  for (let i = 0; i < 10; i++) {
    CameraSetEQNoiseForPlayer(Player(i), 强度);
  }
}

function 全员清除震屏(this: void, _variable: any): void {
  for (let i = 0; i < 10; i++) {
    CameraClearNoiseForPlayer(Player(i));
  }
}

function 推进Q灼烧(this: void, variable: any): void {
  const ctx = variable as Q上下文;
  if (ctx == null) return;
  ctx.灼烧次数 += 1;
  const caster = ctx.施法者;
  const target = ctx.目标;
  // 介绍口径：每秒一次共 3 次（源 tick 计数提前停止只结算 2 次，差异审计见计划）
  if (ctx.灼烧次数 > 配置.Q.火.灼烧.次数) {
    if (ctx.灼烧回调ID !== 0) removePeriodicCallback(ctx.灼烧回调ID);
    ctx.灼烧回调ID = 0;
    return;
  }
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) return;
  if (target == null || target === 0 || !IsUnitAliveBJ(target)) return;
  造成单体技能伤害({
    来源: caster,
    目标: target,
    伤害: ctx.伤害快照 * 配置.Q.火.灼烧.单次比例,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
    来源类型: "单位技能",
    标签: "云端-Q火剑灼烧",
    技能ID: Q类型ID,
    技能实例ID: ctx.技能实例ID,
  });
}

function 结算Q命中(this: void, ctx: Q上下文): void {
  const caster = ctx.施法者;
  const target = ctx.目标;

  // 源：到达后移除临时能力、恢复路径与无敌（TS：A0KL/A0KK 为球体视觉壳不迁移；硬直由 GS_Suspend(0) 释放）
  GS_Suspend(caster, 0);
  SetUnitInvulnerable(caster, false);

  if (target == null || target === 0 || !IsUnitAliveBJ(target)) {
    ctx.已启动 = false; // 目标失效：只恢复状态不结算（计划第 11 节）
    return;
  }

  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  if (ctx.分支 === "火") {
    const 火音效句柄 = (jglobals as any)[配置.Q.火.音效.全局音效键];
    if (火音效句柄 != null) PlaySoundOnUnitBJ(火音效句柄, 100, caster);
    创建点特效({ 模型路径: 配置.Q.火.命中特效.模型, X: tx, Y: ty, Z: 配置.Q.火.命中特效.高度, 面向角度: 270, 缩放: 配置.Q.火.命中特效.缩放, 持续秒: 配置.Q.火.命中特效.持续秒 });
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害: ctx.伤害快照,
      伤害类型: DAMAGE_TYPE_FIRE,
      attack: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
      来源类型: "单位技能",
      标签: "云端-Q火剑",
      技能ID: Q类型ID,
      技能实例ID: ctx.技能实例ID,
    });
    开始跳跃(target, {
      角度: GetRandomDirectionDeg(),
      距离: 配置.Q.目标跳跃.距离,
      持续时间: 配置.Q.目标跳跃.持续时间秒,
      跳跃高度: 配置.Q.目标跳跃.跳跃高度,
    });
    createTimedUnitEffect(target, "origin", 配置.Q.火.灼烧挂点模型, 配置.Q.火.灼烧挂点持续秒);
    registerManualBuff(target, 云端BuffID.火剑灼烧, 配置.Q.火.灼烧挂点持续秒, 0);
    // 重复释放/二次命中前先移除旧灼烧回调：防止旧周期回调与新实例共享同一 ctx 导致灼烧次数双涨与伤害翻倍
    if (ctx.灼烧回调ID !== 0) {
      removePeriodicCallback(ctx.灼烧回调ID);
      ctx.灼烧回调ID = 0;
    }
    ctx.灼烧次数 = 0;
    ctx.灼烧回调ID = addPeriodicCallback(
      秒转毫秒(配置.Q.火.灼烧.间隔秒),
      推进Q灼烧 as unknown as (this: void, variable?: any) => void,
      ctx,
    );
  } else {
    创建点特效({ 模型路径: 配置.Q.冰.命中特效.模型, X: tx, Y: ty, Z: 配置.Q.冰.命中特效.高度, 面向角度: 270, 缩放: 配置.Q.冰.命中特效.缩放, 持续秒: 配置.Q.冰.命中特效.持续秒 });
    造成单体技能伤害({
      来源: caster,
      目标: target,
      伤害: ctx.伤害快照,
      伤害类型: DAMAGE_TYPE_COLD,
      attack: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
      来源类型: "单位技能",
      标签: "云端-Q冰剑",
      技能ID: Q类型ID,
      技能实例ID: ctx.技能实例ID,
    });
    开始跳跃(target, {
      角度: GetRandomDirectionDeg(),
      距离: 配置.Q.目标跳跃.距离,
      持续时间: 配置.Q.目标跳跃.持续时间秒,
      跳跃高度: 配置.Q.目标跳跃.跳跃高度,
    });
    施加减速(caster, target, 配置.Q.冰.减速比例, 配置.Q.冰.减速持续秒, "云端-冰剑", "技能");
    registerManualBuff(target, 云端BuffID.冰剑减速, 配置.Q.冰.减速持续秒, 0);
  }

  全员震屏(配置.Q.摄像机震动强度);
  addDelayedCallback(
    秒转毫秒(配置.Q.震动清除延迟秒),
    全员清除震屏 as unknown as (this: void, variable?: any) => void,
    null,
  );
  ctx.已启动 = false;
}

function Q冲锋结束(this: void, 移动单位: any, _原因: string, _位移ID: number): void {
  const ctx = Q上下文表[GetHandleId(移动单位)];
  if (ctx == null || ctx.已启动 !== true) return;
  结算Q命中(ctx);
}

function 释放Q冰火魔剑(this: void, context: Q上下文, caster: any, 技能实例ID?: number): void {
  const target = GetSpellTargetUnit();
  if (target == null || target === 0) {
    return;
  }

  // 同步入口一次确定：随机分支、目标锁存、伤害快照（计划 5.2/5.3）
  const 分支 = GetRandomInt(1, 2) === 1 ? "火" : "冰";
  const 等级 = GetUnitAbilityLevel(caster, Q类型ID);
  const 伤害快照 = 读取单位攻击力(caster) * (配置.Q.伤害公式.基础倍率 + 配置.Q.伤害公式.每级加成 * 等级);

  context.施法者 = caster;
  context.目标 = target;
  context.分支 = 分支;
  context.伤害快照 = 伤害快照;
  context.技能实例ID = 技能实例ID;
  context.灼烧次数 = 0;
  context.已启动 = true;

  GS_Suspend(caster, 配置.Q.硬直秒); // 源：GS_Suspend(0.75) 自动到期释放
  SetUnitInvulnerable(caster, true);
  SetUnitAnimation(caster, 配置.Q.动作名);

  // 护场表现（源技能马甲换模型 finalfield，按物编壳参数转直接特效）
  const sx = GetUnitX(caster);
  const sy = GetUnitY(caster);
  const 角度 = Atan2(GetUnitY(target) - sy, GetUnitX(target) - sx) * bj_RADTODEG;
  const 颜色 = 分支 === "火" ? 配置.Q.火.颜色 : 配置.Q.冰.颜色;
  创建点特效({
    模型路径: 配置.Q.护场特效.模型,
    X: sx,
    Y: sy,
    Z: 0,
    面向角度: 角度,
    缩放: 配置.Q.护场特效.缩放,
    持续秒: 配置.Q.护场特效.持续秒,
    红: 颜色.红,
    绿: 颜色.绿,
    蓝: 颜色.蓝,
    透明度: 颜色.透明度,
  });

  // 冲锋至目标 85 码内：源 0.02s × 40 码 = 2000 码/秒
  const dx = GetUnitX(target) - sx;
  const dy = GetUnitY(target) - sy;
  const 距离 = SquareRoot(dx * dx + dy * dy) - 配置.Q.冲锋.命中距离码;
  if (距离 <= 0) {
    结算Q命中(context);
    return;
  }
  const 速度 = 配置.Q.冲锋.每Tick距离 / 配置.Q.冲锋.Tick间隔秒;
  const 移动音效句柄 = (jglobals as any)[配置.Q.冲锋.移动音效.全局音效键];
  if (移动音效句柄 != null) PlaySoundOnUnitBJ(移动音效句柄, 100, caster);
  开始冲锋(caster, {
    角度,
    距离,
    持续时间: 距离 / 速度,
    检查地形: true,
    禁用碰撞: true,
    动画序号: 配置.Q.冲锋.动作索引,
    结束回调: Q冲锋结束,
  });

  // 移动阶段分支拖尾（源每 tick 创建，TS 由冲锋路径上的周期性直接特效近似：冲锋时长内按 tick 间隔铺点）
  const 拖尾参数 = 分支 === "火" ? 配置.Q.火.移动特效 : 配置.Q.冰.移动特效;
  const 拖尾次数 = 向下取整整数(距离 / 配置.Q.冲锋.每Tick距离);
  for (let i = 1; i <= 拖尾次数; i++) {
    const px = sx + CosDeg(角度) * (i * 配置.Q.冲锋.每Tick距离);
    const py = sy + SinDeg(角度) * (i * 配置.Q.冲锋.每Tick距离);
    // 延迟铺点与冲锋同步推进（每 tick 间隔一个特效，自动销毁）
    addDelayedCallback(
      秒转毫秒(i * 配置.Q.冲锋.Tick间隔秒),
      Q铺拖尾 as unknown as (this: void, variable?: any) => void,
      { 模型: 拖尾参数.模型, X: px, Y: py, 高度: 拖尾参数.高度, 缩放: 拖尾参数.缩放, 持续秒: 拖尾参数.持续秒 },
    );
  }
}

const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;

function CosDeg(this: void, 角度: number): number {
  return Cos(角度 * bj_DEGTORAD);
}

function SinDeg(this: void, 角度: number): number {
  return Sin(角度 * bj_DEGTORAD);
}

function Q铺拖尾(this: void, variable: any): void {
  const p = variable as { 模型: string; X: number; Y: number; 高度: number; 缩放: number; 持续秒: number };
  if (p == null) return;
  创建点特效({ 模型路径: p.模型, X: p.X, Y: p.Y, Z: p.高度, 面向角度: 270, 缩放: p.缩放, 持续秒: p.持续秒 });
}

/**
 * 施法中断清理（SPELL_ENDCAST 触发，正常结算后已启动=false 幂等跳过）。
 * 冲锋被取消/打断时只恢复本技能状态：不结算伤害、不启动灼烧、不移除他人暂停。
 * GS_Suspend 为具名暂停来源（只清本技能硬直），SetUnitInvulnerable 恢复 Q 自己给的冲锋无敌。
 */
function 云端Q中断清理(this: void, 施法单位: any, 技能ID数值: number): void {
  if (技能ID数值 !== Q类型ID) return;
  const ctx = Q上下文表[GetHandleId(施法单位)];
  if (ctx == null || ctx.已启动 !== true) return;
  ctx.已启动 = false;
  const caster = ctx.施法者;
  if (caster != null && caster !== 0) {
    GS_Suspend(caster, 0);
    SetUnitInvulnerable(caster, false);
  }
}

export function 注册云端Q(this: void): void {
  注册单位技能壳监听({
    名称: "云端-冰火魔剑（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.Q.技能ID,
    获取或创建上下文: 获取或创建Q上下文,
    可释放: Q可释放,
    释放技能: 释放Q冰火魔剑,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 6,
  });
  registerSpellEndcastListener(云端Q中断清理);
}

注册云端Q();

export {};
