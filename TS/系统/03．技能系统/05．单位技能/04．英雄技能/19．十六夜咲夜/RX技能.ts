/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 创建直线飞刀, 创建咲夜单位壳, 安全移除单位壳, 极坐标X, 极坐标Y, 单位存活, 播放咲夜单位音效, type 直线飞刀状态 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 造成单体技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 执行战斗自身传送到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, duration: number, effect: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 十六夜咲夜BuffID } = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜") as {
  十六夜咲夜BuffID: { 完美女仆反击窗口: string };
};

interface RX监听上下文 { 占位: boolean; }
interface RX预备飞刀 { 单位: any; X: number; Y: number; 角度: number; }
interface RX上下文 {
  施法者: any;
  技能实例ID?: number;
  序号: number;
  已触发: boolean;
  已结束: boolean;
  预备飞刀: RX预备飞刀[];
  目标: any;
  暂停来源: string;
  反击特效: any;
}

const RX活动表: Record<number, RX上下文 | undefined> = {};
let RX序号 = 0;
let RX伤害修正已注册 = false;

function 获取RX监听上下文(this: void, _caster: any): RX监听上下文 { return { 占位: true }; }

function 清理RX(this: void, context: RX上下文, 结束伤害实例: boolean): void {
  if (context.已结束) return;
  context.已结束 = true;
  const casterId = jass.GetHandleId(context.施法者) as number;
  if (RX活动表[casterId] === context) delete RX活动表[casterId];
  for (let i = 0; i < context.预备飞刀.length; i++) 安全移除单位壳(context.预备飞刀[i].单位);
  context.预备飞刀 = [];
  if (context.目标 != null && context.目标 !== 0) {
    移除单位暂停(context.目标, context.暂停来源);
    jass.SetUnitVertexColor(context.目标, 255, 255, 255, 255);
  }
  if (context.反击特效 != null && context.反击特效 !== 0) jass.DestroyEffect(context.反击特效);
  移除单位指定Buff(context.施法者, 十六夜咲夜BuffID.完美女仆反击窗口);
  if (结束伤害实例) 结束独立技能伤害实例(context.技能实例ID);
}

function RX飞刀命中(this: void, target: any, state: 直线飞刀状态): "继续" {
  const data = state.自定义数据 as { 伤害: number; 技能实例ID?: number };
  造成单体技能伤害({
    来源: state.参数.施法者,
    目标: target,
    伤害: data.伤害,
    伤害类型: jass.DAMAGE_TYPE_ENHANCED,
    attack: true,
    ranged: true,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    标签: "十六夜咲夜-RX-完美女仆",
    技能ID: 配置.技能.RX.类型ID,
    技能实例ID: data.技能实例ID,
  });
  return "继续";
}

function RX释放三圈飞刀(this: void, variable?: any): void {
  const context = variable as RX上下文 | undefined;
  if (context == null || context.已结束 || !context.已触发) return;
  if (!单位存活(context.施法者) || !单位存活(context.目标)) {
    清理RX(context, true);
    return;
  }
  const damage = 读取单位攻击力(context.施法者) * 配置.RX.伤害攻击力倍率;
  let remaining = context.预备飞刀.length;
  const records = context.预备飞刀;
  context.预备飞刀 = [];
  for (let i = 0; i < records.length; i++) {
    const record = records[i];
    安全移除单位壳(record.单位);
    const state = 创建直线飞刀({
      施法者: context.施法者,
      单位类型ID: 配置.单位壳.蓝刀,
      X: record.X,
      Y: record.Y,
      角度: 两点角度(record.X, record.Y, jass.GetUnitX(context.目标), jass.GetUnitY(context.目标)),
      周期毫秒: 配置.RX.飞刀周期毫秒,
      每Tick位移: 配置.RX.飞刀每Tick位移,
      最大距离: 配置.RX.飞刀最大距离,
      命中半径: 配置.RX.命中半径,
      命中去重: true,
      命中回调: RX飞刀命中,
      结束回调: function RX单刀结束(this: void): void {
        remaining -= 1;
        if (remaining <= 0) 结束独立技能伤害实例(context.技能实例ID);
      },
    });
    if (state == null) remaining -= 1;
    else state.自定义数据 = { 伤害: damage, 技能实例ID: context.技能实例ID };
  }
  移除单位暂停(context.目标, context.暂停来源);
  jass.SetUnitVertexColor(context.目标, 255, 255, 255, 255);
  context.目标 = null;
  const casterId = jass.GetHandleId(context.施法者) as number;
  if (RX活动表[casterId] === context) delete RX活动表[casterId];
  context.已结束 = true;
  if (context.反击特效 != null && context.反击特效 !== 0) jass.DestroyEffect(context.反击特效);
  if (remaining <= 0) 结束独立技能伤害实例(context.技能实例ID);
}

interface RX创建圈参数 { 上下文: RX上下文; 圈序号: number; }

function RX创建一圈(this: void, variable?: any): void {
  const params = variable as RX创建圈参数 | undefined;
  if (params == null || params.上下文.已结束 || !params.上下文.已触发 || !单位存活(params.上下文.目标)) return;
  const context = params.上下文;
  const centerX = jass.GetUnitX(context.目标) as number;
  const centerY = jass.GetUnitY(context.目标) as number;
  const radius = 配置.RX.第一圈半径 + params.圈序号 * 配置.RX.圈半径增量;
  for (let i = 0; i < 配置.RX.每圈飞刀数; i++) {
    const angle = i * (360 / 配置.RX.每圈飞刀数);
    const x = 极坐标X(centerX, radius, angle);
    const y = 极坐标Y(centerY, radius, angle);
    const shell = 创建咲夜单位壳(context.施法者, 配置.单位壳.蓝刀, x, y, 两点角度(x, y, centerX, centerY));
    if (shell == null || shell === 0) continue;
    jass.SetUnitVertexColor(shell, 255, 255, 255, 122);
    context.预备飞刀.push({ 单位: shell, X: x, Y: y, 角度: angle });
  }
  播放咲夜单位音效("gg_snd_PossessionMissileHit1", context.施法者);
}

function RX解除攻击者暂停(this: void, variable?: any): void {
  const context = variable as RX上下文 | undefined;
  if (context != null && !context.已结束 && context.目标 != null && context.目标 !== 0) 移除单位暂停(context.目标, context.暂停来源);
}

function RX执行反击(this: void, variable?: any): void {
  const context = variable as RX上下文 | undefined;
  if (context == null || context.已结束 || !context.已触发 || !单位存活(context.施法者) || !单位存活(context.目标)) {
    if (context != null) 清理RX(context, true);
    return;
  }
  const attacker = context.目标;
  const facing = jass.GetUnitFacing(attacker) as number;
  执行战斗自身传送到坐标(context.施法者, 极坐标X(jass.GetUnitX(attacker), 配置.RX.瞬移偏移, facing + 180), 极坐标Y(jass.GetUnitY(attacker), 配置.RX.瞬移偏移, facing + 180));
  添加单位暂停(attacker, context.暂停来源);
  jass.SetUnitVertexColor(attacker, 255, 255, 255, 120);
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RX", context.施法者);
  for (let circle = 0; circle < 配置.RX.圈数; circle++) {
    addDelayedCallback((circle + 1) * 配置.RX.圈延迟秒 * 1000, RX创建一圈, { 上下文: context, 圈序号: circle } as RX创建圈参数);
  }
  addDelayedCallback(配置.RX.攻击者时停秒 * 1000, RX解除攻击者暂停, context);
  addDelayedCallback((配置.RX.圈数 * 配置.RX.圈延迟秒 + 0.02) * 1000, RX释放三圈飞刀, context);
}

function RX伤害修正(this: void, damage: any): number {
  const target = damage != null ? damage.target : null;
  if (target == null || target === 0) return damage != null ? damage.currentDamage : 0;
  const context = RX活动表[jass.GetHandleId(target) as number];
  if (context == null || context.已结束 || context.已触发 || damage.attacker == null || damage.attacker === 0) return damage.currentDamage;
  const dx = jass.GetUnitX(target) - jass.GetUnitX(damage.attacker);
  const dy = jass.GetUnitY(target) - jass.GetUnitY(damage.attacker);
  if (dx * dx + dy * dy < 配置.RX.最小触发距离 * 配置.RX.最小触发距离) return damage.currentDamage;
  context.已触发 = true;
  context.目标 = damage.attacker;
  移除单位指定Buff(context.施法者, 十六夜咲夜BuffID.完美女仆反击窗口);
  addDelayedCallback(1, RX执行反击, context);
  return 0;
}

function RX窗口结束(this: void, variable?: any): void {
  const context = variable as RX上下文 | undefined;
  if (context != null && !context.已触发) 清理RX(context, true);
}

function 释放十六夜咲夜RX(this: void, _listener: RX监听上下文, caster: any, 技能实例ID?: number): void {
  RX序号 += 1;
  const old = RX活动表[jass.GetHandleId(caster) as number];
  if (old != null) 清理RX(old, true);
  const context: RX上下文 = {
    施法者: caster,
    技能实例ID,
    序号: RX序号,
    已触发: false,
    已结束: false,
    预备飞刀: [],
    目标: null,
    暂停来源: `十六夜咲夜-RX:${RX序号}`,
    反击特效: jass.AddSpecialEffectTarget("war3mapImported\\Time Rune.mdx", caster, "origin"),
  };
  RX活动表[jass.GetHandleId(caster) as number] = context;
  registerManualBuff(caster, 十六夜咲夜BuffID.完美女仆反击窗口, 配置.RX.反击窗口秒, 0, { sourceUnit: caster });
  addDelayedCallback(配置.RX.反击窗口秒 * 1000, RX窗口结束, context);
}

export function 注册十六夜咲夜RX(this: void): void {
  if (!RX伤害修正已注册) {
    RX伤害修正已注册 = true;
    registerDamageModifier(RX伤害修正, 2000);
  }
  注册单位技能壳监听({ 名称: "十六夜咲夜-完美女仆（RX）", 单位类型ID: 配置.英雄单位类型ID, 技能ID: 配置.技能.RX.类型ID, 获取或创建上下文: 获取RX监听上下文, 释放技能: 释放十六夜咲夜RX, 创建独立技能实例: true, 独立技能来源类型: "单位技能", 技能实例持续时间秒: 6 });
}

注册十六夜咲夜RX();

export {};
