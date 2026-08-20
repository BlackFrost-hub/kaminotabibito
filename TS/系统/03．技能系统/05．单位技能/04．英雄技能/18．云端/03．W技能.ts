/** @noSelfInFile */
// 云端 W：光暗魔剑（A0KO）。光/暗交替的路径范围 AOE：光剑伤害+友军治疗，暗剑伤害+眩晕。
// 源 JASS 真源：W.j（入口 125-181；路径周期 Func016Func002T 36-81；光分支 Func008A 23-34；暗分支 Func012A 12-17）。
// 冲突口径（计划 6.2.7/6.3）：源延迟回调重读共享 MJ 造成视觉/伤害错位，TS 在施法入口锁存本次分支；
// 首发按介绍口径为光剑。e005 不存在于物编省略；e031/A065 治疗马甲由 doHeal 替代。

import { 云端技能配置 } from "./00．配置";
import { 消耗云端W模式 } from "./01．状态表";
import { 云端BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/18．云端";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 秒转毫秒 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";
import { 获取坐标范围单位按筛选 } from "../../../00．技能模板+函数/02．通用函数/02．单位与范围";
import { registerSpellEndcastListener } from "../../../../00．核心系统/01．事件中心/08．技能事件中心";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
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
const { 创建点特效, 销毁点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  销毁点特效: (this: void, effect: any) => void;
};
// IsUnitAliveBJ 是 Blizzard.j 函数，从 BJ 函数库取（jass.common 取到的是 nil）
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, unit: any) => boolean;
};

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetHeroInt = jass.GetHeroInt as (this: void, unit: any, includeBonuses: boolean) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, p: any) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const DzSetEffectPos = japi.DzSetEffectPos as (this: void, effect: any, x: number, y: number, z: number) => void;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const 配置 = 云端技能配置;
const 英雄单位类型ID = 配置.单位类型ID;
const W类型ID = stringToFourCCSafe(配置.W.技能ID);

interface W上下文 {
  施法者: any;
  模式: "光剑" | "暗剑";
  伤害快照: number;
  起点X: number;
  起点Y: number;
  角度: number;
  Tick数: number;
  已命中组: Record<number, boolean>;
  路径特效: any;
  回调ID: number;
  技能实例ID?: number;
  已启动: boolean;
}

const W上下文表: Record<number, W上下文> = {};

function 获取或创建W上下文(this: void, unit: any): W上下文 {
  const id = GetHandleId(unit);
  let ctx = W上下文表[id];
  if (ctx == null) {
    ctx = {
      施法者: unit,
      模式: "光剑",
      伤害快照: 0,
      起点X: 0,
      起点Y: 0,
      角度: 0,
      Tick数: 0,
      已命中组: {},
      路径特效: null,
      回调ID: 0,
      已启动: false,
    };
    W上下文表[id] = ctx;
  }
  return ctx;
}

function W可释放(this: void, context: W上下文, _caster: any): boolean {
  return context.已启动 !== true;
}

function 结束W路径(this: void, ctx: W上下文): void {
  if (ctx.回调ID !== 0) removePeriodicCallback(ctx.回调ID);
  ctx.回调ID = 0;
  if (ctx.路径特效 != null && ctx.路径特效 !== 0) 销毁点特效(ctx.路径特效);
  ctx.路径特效 = null;
  ctx.已命中组 = {};
  ctx.已启动 = false;
  const caster = ctx.施法者;
  if (caster != null && caster !== 0) {
    GS_Suspend(caster, 0);
    SetUnitInvulnerable(caster, false);
    SetUnitTimeScale(caster, 1);
  }
}

function 结算W范围(this: void, ctx: W上下文, x: number, y: number): void {
  const caster = ctx.施法者;
  const owner = GetOwningPlayer(caster);
  const 单位列表 = 获取坐标范围单位按筛选(x, y, 配置.W.路径.结算半径码, caster, {
    要求有效单位: true,
    允许建筑: false,
    允许机械: true,
    允许古树: true,
    允许无敌: true, // 源语义 IsUnitAliveBJ+非建筑，不排除无敌单位
  });
  for (let i = 0; i < 单位列表.length; i++) {
    const u = 单位列表[i];
    if (u == null || u === 0) continue;
    if (ctx.已命中组[GetHandleId(u)] === true) continue;
    ctx.已命中组[GetHandleId(u)] = true;
    const 是敌人 = IsUnitEnemy(u, owner);
    if (ctx.模式 === "光剑") {
        if (是敌人) {
          造成单体技能伤害({
            来源: caster,
            目标: u,
            伤害: ctx.伤害快照,
            伤害类型: DAMAGE_TYPE_DIVINE,
            attack: false,
            attackType: ATTACK_TYPE_NORMAL,
            weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
            来源类型: "单位技能",
            标签: "云端-W光剑",
            技能ID: W类型ID,
            技能实例ID: ctx.技能实例ID,
          });
        } else {
          // 源：e031 马甲 A065 holybolt（SH×35%）→ 统一治疗封装（计划 6.3）
          doHeal({
            HealSource: caster,
            HealTarget: u,
            HealAmount: ctx.伤害快照 * 配置.W.光剑.治疗比例,
            ItemHeal: false,
            HealEffect: true,
          });
        }
      } else if (是敌人) {
        造成单体技能伤害({
          来源: caster,
          目标: u,
          伤害: ctx.伤害快照,
          伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
          attack: false,
          attackType: ATTACK_TYPE_NORMAL,
          weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
          来源类型: "单位技能",
          标签: "云端-W暗剑",
          技能ID: W类型ID,
          技能实例ID: ctx.技能实例ID,
        });
        施加眩晕(caster, u, 配置.W.暗剑.眩晕秒, "云端-暗剑", "技能");
        registerManualBuff(u, 云端BuffID.暗剑眩晕, 配置.W.暗剑.眩晕秒, 0);
      }
  }
}

function 推进W路径(this: void, variable: any): void {
  const ctx = variable as W上下文;
  if (ctx == null || ctx.已启动 !== true) return;

  ctx.Tick数 += 1;
  if (ctx.Tick数 > 配置.W.路径.最大Tick数) {
    结束W路径(ctx);
    return;
  }

  const rad = ctx.角度 * bj_DEGTORAD;
  const x = ctx.起点X + Cos(rad) * (配置.W.路径.每Tick距离 * ctx.Tick数);
  const y = ctx.起点Y + Sin(rad) * (配置.W.路径.每Tick距离 * ctx.Tick数);

  if (ctx.路径特效 != null && ctx.路径特效 !== 0) DzSetEffectPos(ctx.路径特效, x, y, 0);

  const 分支 = ctx.模式 === "光剑" ? 配置.W.光剑 : 配置.W.暗剑;
  for (let i = 0; i < 分支.路径特效.length; i++) {
    const p = 分支.路径特效[i];
    创建点特效({ 模型路径: p.模型, X: x, Y: y, Z: p.高度, 面向角度: 270, 缩放: p.缩放, 持续秒: p.持续秒 });
  }

  if (ctx.施法者 != null && ctx.施法者 !== 0 && IsUnitAliveBJ(ctx.施法者)) {
    结算W范围(ctx, x, y);
  }
}

function 启动W路径(this: void, variable: any): void {
  const ctx = variable as W上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    结束W路径(ctx);
    return;
  }
  ctx.Tick数 = 0;
  ctx.回调ID = addPeriodicCallback(
    秒转毫秒(配置.W.路径.Tick间隔秒),
    推进W路径 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function 释放W光暗魔剑(this: void, context: W上下文, caster: any, 技能实例ID?: number): void {
  const sx = GetUnitX(caster);
  const sy = GetUnitY(caster);
  const tx = GetSpellTargetX();
  const ty = GetSpellTargetY();
  const 角度 = Atan2(ty - sy, tx - sx) * bj_RADTODEG;

  // 施法入口锁存本次分支并切换下一发（禁止延迟回调读共享状态，计划 6.2.7）
  const 模式 = 消耗云端W模式(caster);
  const 等级 = GetUnitAbilityLevel(caster, W类型ID);
  const 伤害快照 = 读取单位攻击力(caster) * 配置.W.伤害公式.攻击力倍率 + GetHeroInt(caster, true) * (配置.W.伤害公式.智力每级系数 * 等级);

  context.施法者 = caster;
  context.模式 = 模式;
  context.伤害快照 = 伤害快照;
  context.起点X = sx;
  context.起点Y = sy;
  context.角度 = 角度;
  context.Tick数 = 0;
  context.已命中组 = {};
  context.技能实例ID = 技能实例ID;
  context.已启动 = true;

  GS_Suspend(caster, 配置.W.硬直秒);
  SetUnitInvulnerable(caster, true);
  SetUnitTimeScale(caster, 配置.W.时间流速);
  SetUnitAnimation(caster, 配置.W.动作名);

  // 路径表现（源马甲 yy 换模型 infernoarmor/arcanewave）
  const 分支 = 模式 === "光剑" ? 配置.W.光剑 : 配置.W.暗剑;
  context.路径特效 = 创建点特效({
    模型路径: 分支.起手特效.模型,
    X: sx,
    Y: sy,
    Z: 0,
    面向角度: 角度,
    缩放: 分支.起手特效.缩放,
  });
  // 护场表现（源马甲 q 换模型 finalfield，分支颜色）
  创建点特效({
    模型路径: 配置.W.护场特效.模型,
    X: sx,
    Y: sy,
    Z: 0,
    面向角度: 角度,
    缩放: 配置.W.护场特效.缩放,
    持续秒: 配置.W.护场特效.持续秒,
    红: 分支.护场颜色.红,
    绿: 分支.护场颜色.绿,
    蓝: 分支.护场颜色.蓝,
    透明度: 分支.护场颜色.透明度,
  });

  addDelayedCallback(
    秒转毫秒(配置.W.路径.启动延迟秒),
    启动W路径 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

/**
 * 施法中断清理（SPELL_ENDCAST 触发，正常结束路径已启动=false 幂等跳过）。
 * 复用 `结束W路径`：移除路径回调、销毁路径特效、复位已命中组/已启动、
 * 恢复 GS_Suspend/无敌/时间缩放。不提前结算路径伤害。
 */
function 云端W中断清理(this: void, 施法单位: any, 技能ID数值: number): void {
  if (技能ID数值 !== W类型ID) return;
  const ctx = W上下文表[GetHandleId(施法单位)];
  if (ctx == null || ctx.已启动 !== true) return;
  结束W路径(ctx);
}

export function 注册云端W(this: void): void {
  注册单位技能壳监听({
    名称: "云端-光暗魔剑（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.W.技能ID,
    获取或创建上下文: 获取或创建W上下文,
    可释放: W可释放,
    释放技能: 释放W光暗魔剑,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 3,
  });
  registerSpellEndcastListener(云端W中断清理);
}

注册云端W();

export {};
