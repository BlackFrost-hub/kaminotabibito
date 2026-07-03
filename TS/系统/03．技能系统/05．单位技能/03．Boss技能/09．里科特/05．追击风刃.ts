/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 刷新里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC, 取单位间角度 } from "./13．公共工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => { 弹幕ID: number };
};
const { 获取原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  获取原生弹幕: (this: void, 弹幕ID: number) => { 弹幕单位: any } | undefined;
};
const { 设置原生弹幕指定角度飞行 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.06．改向与反弹.00．弹幕改向") as {
  设置原生弹幕指定角度飞行: (this: void, 弹幕ID: number, 朝向角度: number, 新速度?: number) => boolean;
};
const { 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 追击风刃技能ID = stringToFourCC(里科特数值与表现配置.追击风刃.技能槽位);
let 已注册 = false;

function 取追击目标(this: void, boss: any): any {
  const target = GetSpellTargetUnit();
  return 单位有效(target) ? target : 获取Boss技能随机敌对英雄(boss, boss, 里科特数值与表现配置.追击风刃.施法距离 + 300);
}

function 调度追击风刃阶段改向(this: void, context: 里科特运行时上下文, 弹幕ID: number): void {
  const cfg = 里科特数值与表现配置.追击风刃;
  const boss = context.Boss单位;
  const stage = 刷新里科特阶段(context);
  if (stage === 1) return;
  const delay = stage >= 3 ? cfg.P3追踪延迟秒 : cfg.P2回转延迟秒;
  const id = addDelayedCallback(delay * 1000, function 里科特追击风刃延迟改向(this: void): void {
    if (!单位有效(boss)) return;
    const bullet = 获取原生弹幕(弹幕ID);
    if (bullet == null || !单位有效(bullet.弹幕单位)) return;
    if (刷新里科特阶段(context) >= 3) {
      const target = 获取Boss技能随机敌对英雄(boss, boss, 2000);
      if (单位有效(target)) 设置原生弹幕指定角度飞行(弹幕ID, 取单位间角度(bullet.弹幕单位, target), cfg.速度);
      return;
    }
    设置原生弹幕指定角度飞行(弹幕ID, 取单位间角度(bullet.弹幕单位, boss), cfg.速度);
  });
  context.清理.登记延迟回调("里科特-追击风刃改向", id);
}

function 发射追击风刃(this: void, context: 里科特运行时上下文, angle: number): void {
  const boss = context.Boss单位;
  const cfg = 里科特数值与表现配置.追击风刃;
  const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例;
  const bullet = 创建原生弹幕({
    所有者: boss,
    所属玩家: GetOwningPlayer(boss),
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    方向角: angle,
    速度: cfg.速度,
    最大距离: cfg.射程,
    命中半径: cfg.命中半径,
    影响目标: "敌方",
    碰撞消失: false,
    每单位最大命中次数: 1,
    模型: cfg.模型路径,
    缩放: cfg.缩放,
    飞行高度: cfg.飞行高度,
    on命中: function 里科特追击风刃命中(this: void, target: any): void {
      if (!单位有效(target)) return;
      UnitDamageTarget(boss, target, damage, false, false, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
    },
  });
  调度追击风刃阶段改向(context, bullet.弹幕ID);
}

export function 释放里科特追击风刃(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取追击目标(boss);
  if (!单位有效(target)) return;
  const cfg = 里科特数值与表现配置.追击风刃;
  const angle = 取单位间角度(boss, target);
  创建技能提示圈({
    类型: "矩形",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    宽度: cfg.命中半径 * 2,
    长度: cfg.射程,
    朝向: angle,
    持续时间: cfg.前摇秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.前摇秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.前摇秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
    },
    播放台词: function 里科特追击风刃台词(this: void): void {
      播放里科特台词(boss, "追击风刃");
    },
    on生效: function 里科特追击风刃生效(this: void): void {
      发射追击风刃(context, angle);
    },
  });
}

export function 注册里科特追击风刃(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册Boss技能壳监听({
    名称: "05．追击风刃",
    Boss单位类型ID: 里科特单位类型ID,
    技能ID: 追击风刃技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function Boss技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特追击风刃生效(boss, 追击风刃技能ID);
    },
  });
}

function on里科特追击风刃生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 追击风刃技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特追击风刃(context);
}
