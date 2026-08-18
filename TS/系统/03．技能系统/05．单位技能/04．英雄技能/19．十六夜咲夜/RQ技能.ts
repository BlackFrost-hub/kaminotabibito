/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 创建咲夜单位壳, 安全移除单位壳, 极坐标X, 极坐标Y, 单位存活, 播放咲夜单位音效, 注册咲夜周期任务, 移除咲夜周期任务 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 执行战斗自身传送到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, duration: number, effect: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 十六夜咲夜BuffID } = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜") as {
  十六夜咲夜BuffID: { 夜雾幻影目标封锁: string; 夜雾幻影无敌免控: string };
};

interface RQ监听上下文 { 占位: boolean; }
interface RQ上下文 {
  施法者: any;
  目标: any;
  技能实例ID?: number;
  来源: string;
  攻击力快照: number;
  飞刀: any[];
  分身: any[];
  追踪周期ID: number;
  已释放飞刀: boolean;
  已结束: boolean;
}

let RQ序号 = 0;

function 获取RQ监听上下文(this: void, _caster: any): RQ监听上下文 { return { 占位: true }; }

function RQ清理(this: void, context: RQ上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.追踪周期ID !== 0) 移除咲夜周期任务(context.追踪周期ID);
  for (let i = 0; i < context.飞刀.length; i++) 安全移除单位壳(context.飞刀[i]);
  for (let i = 0; i < context.分身.length; i++) 安全移除单位壳(context.分身[i]);
  context.飞刀 = [];
  context.分身 = [];
  if (context.目标 != null && context.目标 !== 0) {
    移除单位暂停(context.目标, context.来源);
    jass.SetUnitTimeScale(context.目标, 1);
    jass.SetUnitVertexColor(context.目标, 255, 255, 255, 255);
    移除单位指定Buff(context.目标, 十六夜咲夜BuffID.夜雾幻影目标封锁);
  }
  if (context.施法者 != null && context.施法者 !== 0) {
    移除单位暂停(context.施法者, context.来源);
    jass.SetUnitInvulnerable(context.施法者, false);
    jass.SetUnitTimeScale(context.施法者, 1);
    jass.ShowUnit(context.施法者, true);
    jass.SetUnitAnimation(context.施法者, "stand");
    移除单位指定Buff(context.施法者, 十六夜咲夜BuffID.夜雾幻影无敌免控);
  }
  结束独立技能伤害实例(context.技能实例ID);
}

function RQ创建飞刀排(this: void, context: RQ上下文, centerX: number, centerY: number, facing: number, count: number, typeId: number): void {
  for (let i = 0; i < count; i++) {
    const side = (i - (count - 1) * 0.5) * 15;
    const x = 极坐标X(极坐标X(centerX, 70, facing), side, facing + 90);
    const y = 极坐标Y(极坐标Y(centerY, 70, facing), side, facing + 90);
    const knife = 创建咲夜单位壳(context.施法者, typeId, x, y, facing);
    if (knife != null && knife !== 0) context.飞刀.push(knife);
  }
}

function RQ第一轮(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束 || !单位存活(context.施法者) || !单位存活(context.目标)) return;
  const facing = 两点角度(jass.GetUnitX(context.施法者), jass.GetUnitY(context.施法者), jass.GetUnitX(context.目标), jass.GetUnitY(context.目标));
  RQ创建飞刀排(context, jass.GetUnitX(context.施法者), jass.GetUnitY(context.施法者), facing, 配置.RQ.第一轮数量, 配置.单位壳.蓝刀);
  播放咲夜单位音效("gg_snd_CharmTarget1", context.施法者);
}

function RQ封锁目标(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束 || !单位存活(context.目标)) return;
  添加单位暂停(context.目标, context.来源);
  jass.SetUnitTimeScale(context.目标, 0);
  jass.SetUnitVertexColor(context.目标, 255, 255, 255, 122);
  registerManualBuff(context.目标, 十六夜咲夜BuffID.夜雾幻影目标封锁, 配置.RQ.最终结算秒, 0, { sourceUnit: context.施法者 });
}

interface RQ分身参数 { 上下文: RQ上下文; 序号: number; }

function RQ创建四向分身(this: void, variable?: any): void {
  const params = variable as RQ分身参数 | undefined;
  if (params == null || params.上下文.已结束 || !单位存活(params.上下文.目标)) return;
  const context = params.上下文;
  const angle = 45 + params.序号 * 90;
  const targetX = jass.GetUnitX(context.目标) as number;
  const targetY = jass.GetUnitY(context.目标) as number;
  const x = 极坐标X(targetX, 配置.RQ.分身距离, angle);
  const y = 极坐标Y(targetY, 配置.RQ.分身距离, angle);
  const facing = 两点角度(x, y, targetX, targetY);
  const clone = 创建咲夜单位壳(context.施法者, 配置.单位壳.侧向分身, x, y, facing);
  if (clone != null && clone !== 0) {
    jass.SetUnitTimeScale(clone, 2);
    jass.SetUnitAnimation(clone, "attack");
    context.分身.push(clone);
  }
  RQ创建飞刀排(context, x, y, facing, 配置.RQ.每分身飞刀数, 配置.单位壳.飞行蓝刀);
}

function RQ创建上空分身(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束 || !单位存活(context.目标)) return;
  const targetX = jass.GetUnitX(context.目标) as number;
  const targetY = jass.GetUnitY(context.目标) as number;
  const highClone = 创建咲夜单位壳(context.施法者, 配置.单位壳.高空分身, targetX, targetY, jass.GetRandomReal(0, 360));
  if (highClone != null && highClone !== 0) {
    jass.SetUnitFlyHeight(highClone, jass.GetUnitFlyHeight(context.目标) + 500, 0);
    jass.SetUnitTimeScale(highClone, 0.5);
    jass.SetUnitAnimation(highClone, "morph");
    context.分身.push(highClone);
  }
  for (let i = 0; i < 配置.RQ.上空飞刀数; i++) {
    const angle = i * 36;
    const knife = 创建咲夜单位壳(context.施法者, 配置.单位壳.环绕蓝刀, 极坐标X(targetX, 250, angle), 极坐标Y(targetY, 250, angle), angle + 180);
    if (knife != null && knife !== 0) {
      jass.SetUnitFlyHeight(knife, jass.GetUnitFlyHeight(context.目标) + 500, 0);
      context.飞刀.push(knife);
    }
  }
}

function RQ本体移位(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束 || !单位存活(context.施法者) || !单位存活(context.目标)) return;
  const angle = jass.GetUnitFacing(context.目标) + 180;
  const x = 极坐标X(jass.GetUnitX(context.目标), 配置.RQ.分身距离, angle);
  const y = 极坐标Y(jass.GetUnitY(context.目标), 配置.RQ.分身距离, angle);
  jass.ShowUnit(context.施法者, true);
  执行战斗自身传送到坐标(context.施法者, x, y);
  jass.SetUnitFacing(context.施法者, angle);
  jass.SetUnitAnimation(context.施法者, "throw");
}

function RQ恢复本体(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束) return;
  移除单位暂停(context.施法者, context.来源);
  jass.SetUnitTimeScale(context.施法者, 1);
  jass.SetUnitAnimation(context.施法者, "stand");
}

function RQ推进飞刀(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束 || !context.已释放飞刀 || !单位存活(context.目标)) return;
  for (let i = context.飞刀.length - 1; i >= 0; i--) {
    const knife = context.飞刀[i];
    if (!单位存活(knife)) {
      context.飞刀.splice(i, 1);
      continue;
    }
    const x = jass.GetUnitX(knife) as number;
    const y = jass.GetUnitY(knife) as number;
    const tx = jass.GetUnitX(context.目标) as number;
    const ty = jass.GetUnitY(context.目标) as number;
    const dx = tx - x;
    const dy = ty - y;
    if (dx * dx + dy * dy <= 配置.RQ.飞刀追踪步长 * 配置.RQ.飞刀追踪步长) {
      安全移除单位壳(knife);
      context.飞刀.splice(i, 1);
      continue;
    }
    const angle = 两点角度(x, y, tx, ty);
    jass.SetUnitX(knife, 极坐标X(x, 配置.RQ.飞刀追踪步长, angle));
    jass.SetUnitY(knife, 极坐标Y(y, 配置.RQ.飞刀追踪步长, angle));
    jass.SetUnitFacing(knife, angle);
    if (jass.GetUnitFlyHeight(knife) > jass.GetUnitFlyHeight(context.目标)) jass.SetUnitFlyHeight(knife, Math.max(jass.GetUnitFlyHeight(context.目标), jass.GetUnitFlyHeight(knife) - 18), 0);
  }
}

function RQ释放飞刀(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束) return;
  context.已释放飞刀 = true;
  for (let i = 0; i < context.分身.length; i++) 安全移除单位壳(context.分身[i]);
  context.分身 = [];
  context.追踪周期ID = 注册咲夜周期任务(配置.RQ.飞刀追踪周期毫秒, RQ推进飞刀, context);
}

function RQ最终结算(this: void, variable?: any): void {
  const context = variable as RQ上下文 | undefined;
  if (context == null || context.已结束) return;
  if (单位存活(context.施法者) && 单位存活(context.目标)) {
    const hitEffect = jass.AddSpecialEffect("war3mapImported\\bloodex.mdx", jass.GetUnitX(context.目标), jass.GetUnitY(context.目标));
    if (hitEffect != null && hitEffect !== 0) jass.DestroyEffect(hitEffect);
    造成单体技能伤害({
      来源: context.施法者,
      目标: context.目标,
      伤害: context.攻击力快照 * 配置.RQ.最终伤害攻击力倍率,
      伤害类型: jass.DAMAGE_TYPE_NORMAL,
      attack: false,
      ranged: false,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
      来源类型: "单位技能",
      标签: "十六夜咲夜-RQ-夜雾幻影杀人鬼",
      技能ID: 配置.技能.RQ.类型ID,
      技能实例ID: context.技能实例ID,
    });
  }
  RQ清理(context);
}

function 释放十六夜咲夜RQ(this: void, _listener: RQ监听上下文, caster: any, 技能实例ID?: number): void {
  const target = jass.GetSpellTargetUnit();
  if (!单位存活(target)) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  RQ序号 += 1;
  const context: RQ上下文 = {
    施法者: caster,
    目标: target,
    技能实例ID,
    来源: `十六夜咲夜-RQ:${RQ序号}`,
    攻击力快照: 读取单位攻击力(caster),
    飞刀: [],
    分身: [],
    追踪周期ID: 0,
    已释放飞刀: false,
    已结束: false,
  };
  添加单位暂停(caster, context.来源);
  jass.SetUnitInvulnerable(caster, true);
  jass.SetUnitAnimationByIndex(caster, 2);
  jass.SetUnitTimeScale(caster, 2.5);
  registerManualBuff(caster, 十六夜咲夜BuffID.夜雾幻影无敌免控, 配置.RQ.最终结算秒, 0, { sourceUnit: caster });
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RQ1", caster);
  addDelayedCallback(配置.RQ.第一轮延迟秒 * 1000, RQ第一轮, context);
  addDelayedCallback(配置.RQ.封锁延迟秒 * 1000, RQ封锁目标, context);
  for (let i = 0; i < 配置.RQ.四向分身数; i++) addDelayedCallback((配置.RQ.四向开始秒 + i * 配置.RQ.四向间隔秒) * 1000, RQ创建四向分身, { 上下文: context, 序号: i } as RQ分身参数);
  addDelayedCallback(配置.RQ.上空分身秒 * 1000, RQ创建上空分身, context);
  addDelayedCallback(配置.RQ.本体移位秒 * 1000, RQ本体移位, context);
  addDelayedCallback(配置.RQ.本体恢复秒 * 1000, RQ恢复本体, context);
  addDelayedCallback(配置.RQ.飞刀释放秒 * 1000, RQ释放飞刀, context);
  addDelayedCallback(配置.RQ.最终结算秒 * 1000, RQ最终结算, context);
}

export function 注册十六夜咲夜RQ(this: void): void {
  注册单位技能壳监听({ 名称: "十六夜咲夜-夜雾幻影杀人鬼（RQ）", 单位类型ID: 配置.英雄单位类型ID, 技能ID: 配置.技能.RQ.类型ID, 获取或创建上下文: 获取RQ监听上下文, 释放技能: 释放十六夜咲夜RQ, 创建独立技能实例: true, 独立技能来源类型: "单位技能", 技能实例持续时间秒: 12 });
}

注册十六夜咲夜RQ();

export {};
