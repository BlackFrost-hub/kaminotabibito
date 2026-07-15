/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 获取或创建瑟兰迪尔上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 瑟兰迪尔单位技能配置 } from "./00．配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { stringToFourCC, 单位存活 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 创建点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { 播放限时单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  播放限时单位动画: (this: void, 参数: any) => any;
};
const { 获取Boss技能应攻击目标, 获取Boss技能最近敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能应攻击目标: (this: void, boss: any) => { targetRef: any } | null;
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const R2I = jass.R2I as (value: number) => number;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const DzSetEffectVertexColor = japi.DzSetEffectVertexColor as ((effect: any, color: number) => void) | undefined;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const BJ_RADTODEG = 57.29577951308232;
const 瑟兰迪尔单位类型ID = stringToFourCC(瑟兰迪尔单位技能配置.单位ID);
const 罪与罚技能ID = stringToFourCC(瑟兰迪尔数值与表现配置.罪与罚.技能槽位);
let 罪与罚已注册 = false;

function 造成伤害(this: void, boss: any, target: any, amount: number, damageType: any): void {
  if (!单位有效(boss) || !单位有效(target) || amount <= 0) return;
  造成单体技能伤害({
    技能ID: 罪与罚技能ID,
    来源: boss,
    目标: target,
    伤害: amount,
    attack: false,
    ranged: false,
    attackType: jass.ATTACK_TYPE_NORMAL,
    伤害类型: damageType,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
  });
}

function 播放点名特效(this: void, target: any, duration: number): void {
  createTimedUnitEffect(target, "origin", "Common\\Effect\\Element\\Light\\protectionaura.mdx", duration);
}

function 让单位面向目标(this: void, caster: any, target: any): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const angle = Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * BJ_RADTODEG;
  SetUnitFacing(caster, angle);
}

function 挂Buff(this: void, boss: any, target: any, buffID: string, duration: number, value: number, icon: string, effect?: string): void {
  registerManualBuff(target, buffID, duration, value, {
    sourceName: GetUnitName(boss),
    iconOverride: icon,
    effectModelOverride: effect,
  });
}

function 取象限名称(this: void, type: number): string {
  if (type === 1) return "红";
  if (type === 2) return "蓝";
  if (type === 3) return "绿";
  return "金";
}

function 取象限法阵颜色(this: void, type: number, config: any): number {
  if (type === 1) return config.施法法阵红色;
  if (type === 2) return config.施法法阵蓝色;
  if (type === 3) return config.施法法阵绿色;
  return config.施法法阵金色;
}

function 播放施法法阵(this: void, boss: any, type: number, config: any): void {
  if (!单位有效(boss)) return;
  创建点特效({
    模型路径: config.施法法阵特效,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    缩放: config.施法法阵缩放,
    顶点颜色: 取象限法阵颜色(type, config),
    持续秒: config.施法硬直秒 + 0.5,
  });
}

function 结算周期伤害(this: void, boss: any, target: any, times: number, damage: number, damageType: any): void {
  for (let i = 1; i <= times; i++) {
    addDelayedCallback(i * 1000, function 瑟兰迪尔罪与罚周期伤害(this: void): void {
      造成伤害(boss, target, damage, damageType);
    });
  }
}

export function 释放瑟兰迪尔罪与罚(this: void, context: 瑟兰迪尔运行时上下文, target?: any): void {
  const config = 瑟兰迪尔数值与表现配置.罪与罚;
  const boss = context.Boss单位;
  const threatTarget = 获取Boss技能应攻击目标(boss);
  const actualTarget = target ?? threatTarget?.targetRef ?? 获取Boss技能最近敌对英雄(boss);
  if (!单位有效(boss) || !单位有效(actualTarget)) return;
  const type = GetRandomInt(1, 4);
  const 象限名称 = 取象限名称(type);
  if (context.罪与罚组合执行器 == null) {
    context.罪与罚组合执行器 = 创建固定组合技能执行器<瑟兰迪尔运行时上下文>({
      名称: "瑟兰迪尔-罪与罚",
      清理: context.清理,
      互斥组: "瑟兰迪尔罪与罚",
    });
  }
  const 执行ID = context.罪与罚组合执行器.开始({
    key: "罪与罚",
    单位: boss,
    上下文: context,
    最大持续毫秒: R2I((config.施法硬直秒 + config.延迟秒) * 1000) + 1000,
    阶段列表: 创建固定时间轴阶段列表([{
      时点毫秒: R2I(config.施法硬直秒 * 1000),
      名称: "罪与罚点名开始",
      执行: function 瑟兰迪尔罪与罚点名开始(this: void): void {
        关闭吟唱条("常规技能");
        if (!单位有效(boss) || !单位有效(actualTarget)) return;
        让单位面向目标(boss, actualTarget);
        Sound3DII_CooPlayReuse(config.点名音效, GetUnitX(actualTarget), GetUnitY(actualTarget), 0, config.点名音效裁断距离);
        播放点名特效(actualTarget, config.延迟秒);
      },
    }, {
      时点毫秒: R2I((config.施法硬直秒 + config.延迟秒) * 1000),
      名称: "罪与罚结算",
      执行: function 瑟兰迪尔罪与罚结算(this: void): void {
        if (!单位有效(boss) || !单位有效(actualTarget)) return;
        让单位面向目标(boss, actualTarget);
        const maxLife = GetUnitState(actualTarget, UNIT_STATE_MAX_LIFE);
        if (type === 1) {
          挂Buff(boss, actualTarget, config.红惩罚BuffID, config.惩罚持续秒, 0, "BuffIcon\\Boss\\Thranduil\\lieyanzhuoshao.blp", config.红特效);
          挂Buff(boss, actualTarget, config.红增益BuffID, config.增益持续秒, 0.35, "BuffIcon\\Boss\\Thranduil\\nuhuozhangkong.blp", config.红特效);
          结算周期伤害(boss, actualTarget, config.惩罚持续秒, maxLife * 0.05, jass.DAMAGE_TYPE_FIRE);
        } else if (type === 2) {
          挂Buff(boss, actualTarget, config.蓝惩罚BuffID, config.惩罚持续秒, 0.7, "BuffIcon\\Boss\\Thranduil\\shendudongjie.blp", config.蓝惩罚特效);
          挂Buff(boss, actualTarget, config.蓝增益BuffID, config.增益持续秒, 0.4, "BuffIcon\\Boss\\Thranduil\\bingshuangbihu.blp", config.蓝增益特效);
        } else if (type === 3) {
          挂Buff(boss, actualTarget, config.绿惩罚BuffID, config.惩罚持续秒, 0, "BuffIcon\\Boss\\Thranduil\\zhimingdusu.blp", config.绿惩罚特效);
          挂Buff(boss, actualTarget, config.绿增益BuffID, config.增益持续秒, 0, "BuffIcon\\Boss\\Thranduil\\duyefanzhuan.blp", config.绿增益特效);
          结算周期伤害(boss, actualTarget, config.惩罚持续秒, maxLife * 0.04, jass.DAMAGE_TYPE_POISON);
        } else {
          const mana = GetUnitState(actualTarget, UNIT_STATE_MANA);
          const maxMana = GetUnitState(actualTarget, UNIT_STATE_MAX_MANA);
          const damage = maxMana > 0 ? (maxMana - mana) * 2 : 200;
          挂Buff(boss, actualTarget, config.黄惩罚BuffID, config.惩罚持续秒, 0, "BuffIcon\\Boss\\Thranduil\\molifanshi.blp");
          挂Buff(boss, actualTarget, config.黄增益BuffID, config.增益持续秒, 0, "BuffIcon\\Boss\\Thranduil\\aoshuchaozai.blp", config.黄增益特效);
          结算周期伤害(boss, actualTarget, config.惩罚持续秒, damage, jass.DAMAGE_TYPE_MIND);
        }
      },
    }]),
    结束回调: function 瑟兰迪尔罪与罚组合结束(this: void, event): void {
      if (event.原因 !== "完成") 关闭吟唱条("常规技能");
    },
  });
  if (执行ID === 0) return;
  播放瑟兰迪尔台词(boss, "罪与罚");
  让单位面向目标(boss, actualTarget);
  开始硬直(boss, config.施法硬直秒);
  播放施法法阵(boss, type, config);
  显示常规技能吟唱条({
    总时长: config.施法硬直秒,
    颜色ID: config.吟唱条颜色ID,
    标题文本: config.吟唱条标题文本 + "：" + 象限名称,
    提示文本: "常规技能：即将赐予" + 象限名称 + "象限",
  });
  播放限时单位动画({
    单位: boss,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    持续秒: config.施法硬直秒,
    重播时点秒列表: [config.动画重播延迟Ms / 1000],
    恢复动画编号: config.恢复动画编号,
    恢复动画速度: config.恢复动画速度,
  });
}

export function 注册瑟兰迪尔罪与罚(this: void): void {
  if (罪与罚已注册) return;
  罪与罚已注册 = true;
  注册单位技能壳监听({
    名称: "瑟兰迪尔罪与罚",
    单位类型ID: 瑟兰迪尔单位类型ID,
    技能ID: 罪与罚技能ID,
    获取或创建上下文: 获取或创建瑟兰迪尔上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 瑟兰迪尔运行时上下文, boss: any): void {
      on瑟兰迪尔罪与罚生效(boss, 罪与罚技能ID);
    },
  });
}

function on瑟兰迪尔罪与罚生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 罪与罚技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 瑟兰迪尔单位类型ID) return;
  const target = GetSpellTargetUnit();
  const context = 获取或创建瑟兰迪尔上下文(castingUnit);
  if (context == null) return;
  释放瑟兰迪尔罪与罚(context, target);
}
