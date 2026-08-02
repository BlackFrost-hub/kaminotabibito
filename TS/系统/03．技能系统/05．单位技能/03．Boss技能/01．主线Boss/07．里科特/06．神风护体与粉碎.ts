/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import {
  获取或创建里科特上下文,
  获取全部里科特上下文,
  增加里科特神风印记,
  取里科特神风印记,
  清除里科特神风印记,
  type 里科特运行时上下文,
} from "./01．运行时上下文";
import { 里科特数值与表现配置, 里科特音效配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, 播放里科特限时动作, stringToFourCC } from "./13．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 创建条件伤害修正 } from "../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正";
import { 执行Boss单体技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { createTimedEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 里科特BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特") as {
  里科特BuffID: { 神风印记: string; 神风护体: string };
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 神风护体技能ID = stringToFourCC(里科特数值与表现配置.神风护体.技能槽位);
let 已注册 = false;

function 取里科特上下文ByBoss(this: void, boss: any): 里科特运行时上下文 | undefined {
  const contexts = 获取全部里科特上下文();
  for (let i = 0; i < contexts.length; i++) {
    if (contexts[i].Boss单位 === boss) return contexts[i];
  }
  return undefined;
}

function 设置神风护体层数(this: void, context: 里科特运行时上下文): void {
  const cfg = 里科特数值与表现配置.神风护体;
  context.神风护体层数 = cfg.基础层数;
  registerManualBuff(context.Boss单位, 里科特BuffID.神风护体, cfg.持续秒, cfg.基础层数, {
    stack: cfg.基础层数,
    sourceName: "里科特-神风护体",
  });
}

function 更新神风护体层数Buff(this: void, context: 里科特运行时上下文): void {
  const cfg = 里科特数值与表现配置.神风护体;
  if (context.神风护体层数 <= 0) {
    移除单位指定Buff(context.Boss单位, 里科特BuffID.神风护体);
    return;
  }
  registerManualBuff(context.Boss单位, 里科特BuffID.神风护体, cfg.持续秒, context.神风护体层数, {
    stack: context.神风护体层数,
    sourceName: "里科特-神风护体",
  });
}

function 记录神风印记(this: void, context: 里科特运行时上下文, attacker: any): void {
  if (!单位有效(attacker)) return;
  const cfg = 里科特数值与表现配置.神风护体;
  const stack = 增加里科特神风印记(context, attacker, 1);
  registerManualBuff(attacker, 里科特BuffID.神风印记, cfg.持续秒 + 0.5, stack, {
    stack,
    sourceName: "里科特-神风印记",
  });
}

function 结算单个神风粉碎(this: void, context: 里科特运行时上下文, target: any): void {
  if (!单位有效(target)) return;
  const stack = 取里科特神风印记(context, target);
  if (stack <= 0) return;
  const cfg = 里科特数值与表现配置.神风护体;
  const stun = cfg.粉碎基础眩晕秒 + cfg.粉碎每层眩晕秒 * stack;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const damageResult = 执行Boss单体技能伤害({
    技能ID: 神风护体技能ID,
    来源: context.Boss单位,
    目标: target,
    伤害公式: {
      目标最大生命比例: cfg.粉碎每层最大生命比例 * stack,
    },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_MAGIC,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  });
  施加眩晕(context.Boss单位, target, stun);
  播放Boss坐标音效(里科特音效配置.神风护体.粉碎清算, targetX, targetY, 里科特音效配置.默认裁断距离);
  createTimedEffect(cfg.粉碎特效路径, targetX, targetY, 0, 1);
  if (damageResult.是否造成伤害) {
    createTimedEffect(cfg.粉碎伤害特效路径, targetX, targetY, 0, cfg.粉碎伤害特效持续秒);
  }
  清除里科特神风印记(context, target);
  移除单位指定Buff(target, 里科特BuffID.神风印记);
}

function 结算神风粉碎(this: void, context: 里科特运行时上下文): void {
  const cfg = 里科特数值与表现配置.神风护体;
  播放里科特限时动作(context.Boss单位, cfg.粉碎动画编号, 1, cfg.粉碎动画原始时长秒);
  播放里科特台词(context.Boss单位, "粉碎");
  for (const key in context.神风印记表) {
    const stack = context.神风印记表[key];
    if (stack == null || stack <= 0) continue;
    const target = context.神风印记单位表[key];
    if (target != null) 结算单个神风粉碎(context, target);
  }
  context.神风印记表 = {};
  context.神风印记单位表 = {};
}

function 取里科特神风护体上下文(this: void, damageContext: any): 里科特运行时上下文 | undefined {
  const context = 取里科特上下文ByBoss(damageContext.target);
  if (context == null || context.神风护体层数 <= 0 || !单位有效(context.Boss单位)) return undefined;
  return context;
}

function on里科特神风护体受伤条件(this: void, damageContext: any): boolean {
  return 取里科特神风护体上下文(damageContext) != null;
}

function on里科特神风护体伤害修正(this: void, damageContext: any): number {
  const context = 取里科特神风护体上下文(damageContext);
  if (context == null) return damageContext.currentDamage;
  context.神风护体层数 = context.神风护体层数 - 1;
  记录神风印记(context, damageContext.attacker);
  更新神风护体层数Buff(context);
  return damageContext.currentDamage * (1 - 里科特数值与表现配置.神风护体.受击减伤比例);
}

function on里科特神风护体施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 神风护体技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特神风护体(context);
}

export function 释放里科特神风护体(this: void, context: 里科特运行时上下文): boolean {
  if (!单位有效(context.Boss单位)) return false;
  const cfg = 里科特数值与表现配置.神风护体;
  播放Boss坐标音效(里科特音效配置.神风护体.展开, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 里科特音效配置.默认裁断距离);
  设置神风护体层数(context);
  const boss = context.Boss单位;
  启动基础施法时间线({
    名称: "里科特-神风护体",
    施法者: boss,
    硬直秒: cfg.施法硬直秒,
    生效延迟秒: cfg.持续秒,
    动画编号: 8,
    动画速度: cfg.动画速度,
    后续动画编号: 9,
    后续动画速度: 1,
    后续动画延迟毫秒: cfg.施法动作原始时长秒 * 1000 / cfg.动画速度,
    恢复动画编号: 3,
    完成后恢复动作: false,
    清理: context.清理,
    播放台词: function 里科特神风护体台词(this: void): void {
      播放里科特台词(boss, "神风护体");
    },
    on生效: function 里科特神风护体结束(this: void): void {
      if (!单位有效(boss)) return;
      context.神风护体层数 = 0;
      移除单位指定Buff(boss, 里科特BuffID.神风护体);
      结算神风粉碎(context);
    },
    on结束: function 里科特神风护体时间线结束(this: void, 原因: any): void {
      if (原因 === "完成") return;
      context.神风护体层数 = 0;
      移除单位指定Buff(boss, 里科特BuffID.神风护体);
    },
  });
  return true;
}

export function 注册里科特神风护体与粉碎(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "06．神风护体与粉碎",
    单位类型ID: 里科特单位类型ID,
    技能ID: 神风护体技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特神风护体施法(boss, 神风护体技能ID);
    },
  });
  创建条件伤害修正({
    名称: "里科特-神风护体受伤修正",
    优先级: 70,
    条件: on里科特神风护体受伤条件,
    修正: on里科特神风护体伤害修正,
  });
}
