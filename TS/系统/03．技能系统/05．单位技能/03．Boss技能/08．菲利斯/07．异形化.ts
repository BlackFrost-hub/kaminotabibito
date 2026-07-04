/** @noSelfInFile */

import { 菲利斯单位技能配置 } from "./00．配置";
import { 获取全部菲利斯上下文, 获取或创建菲利斯上下文, 菲利斯运行时上下文 } from "./01．运行时上下文";
import { 菲利斯数值与表现配置 } from "./02．数值与表现配置";
import { 释放菲利斯剑气灵斩 } from "./05．剑气灵斩";
import { 播放菲利斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 取难度, 距离平方XY } from "./11．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { remaining: number } | null;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯") as {
  菲利斯BuffID: { 异形化: string; 魔力汲取: string };
};
const { 开始牵引 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.吸附牵引系统") as {
  开始牵引: (this: void, unit: any, 参数: any) => number;
};
const { 执行非伤害生命移除 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除") as {
  执行非伤害生命移除: (this: void, 参数: any) => number;
};
const { 创建点特效, createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};

const 菲利斯单位类型ID = stringToFourCC(菲利斯单位技能配置.单位ID);
const 异形化技能ID = stringToFourCC(菲利斯数值与表现配置.异形化.技能槽位);
let 异形化已注册 = false;
let 异形化伤害监听已注册 = false;

function 更新魔法显示(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  const maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA);
  if (maxMana > 0) {
    const shown = context.当前魔法充能 > maxMana ? maxMana : context.当前魔法充能;
    SetUnitState(boss, UNIT_STATE_MANA, shown);
  }
  registerManualBuff(boss, 菲利斯BuffID.魔力汲取, 2.0, context.当前魔法充能, { sourceName: "菲利斯-魔力汲取" });
}

function 累计异形化魔法(this: void, context: 菲利斯运行时上下文, amount: number): void {
  if (!(amount > 0)) return;
  context.当前魔法充能 += amount;
  if (context.当前魔法充能 > 菲利斯数值与表现配置.异形化.魔法阈值) {
    context.当前魔法充能 = 菲利斯数值与表现配置.异形化.魔法阈值;
  }
  更新魔法显示(context);
}

function on菲利斯最终伤害充能(this: void, _target: any, attacker: any, applied: number): void {
  if (!(applied > 0) || !单位有效(attacker)) return;
  const contexts = 获取全部菲利斯上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (context.Boss单位 !== attacker) continue;
    const cfg = 菲利斯数值与表现配置.异形化;
    累计异形化魔法(context, applied * (cfg.伤害回魔基础比例 + cfg.伤害回魔每难度追加比例 * 取难度()));
    return;
  }
}

function 异形化伤害修正(this: void, damageContext: any): number {
  if (damageContext == null) return 0;
  const cfg = 菲利斯数值与表现配置.异形化;
  const list = 获取全部菲利斯上下文();
  for (let i = 0; i < list.length; i++) {
    const context = list[i];
    if (!context.异形化中 || getServerTime() >= context.异形化结束Ms) continue;
    const boss = context.Boss单位;
    if (!单位有效(boss)) continue;
    if (damageContext.attacker === boss) return damageContext.currentDamage * (1 + cfg.造成和受到伤害提高);
    if (damageContext.target === boss) {
      if (damageContext.isLightDamage === true) context.异形化结束Ms -= cfg.光伤缩短秒 * 1000;
      return damageContext.currentDamage * (1 + cfg.造成和受到伤害提高);
    }
  }
  return damageContext.currentDamage;
}

function 结束异形化(this: void, context: 菲利斯运行时上下文): void {
  context.异形化中 = false;
  context.异形化结束Ms = 0;
}

function 异形化Tick(this: void, context: 菲利斯运行时上下文, callbackID: number): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.异形化;
  if (!单位有效(boss) || context.清理.已清理() || getServerTime() >= context.异形化结束Ms || getBuffRuntime(boss, 菲利斯BuffID.异形化) == null) {
    removePeriodicCallback(callbackID);
    结束异形化(context);
    return;
  }
  创建技能提示圈({
    类型: "圆形",
    锚点单位: boss,
    半径: cfg.近身扣血半径,
    持续时间: cfg.Tick秒,
  });
  创建技能提示圈({
    类型: "双环",
    锚点单位: boss,
    半径: cfg.牵引半径,
    持续时间: cfg.Tick秒,
  });
  创建点特效({ 模型路径: cfg.周期波动特效路径, X: GetUnitX(boss), Y: GetUnitY(boss), 缩放: 1.0, 持续秒: cfg.特效持续秒 });

  const heroes = 获取Boss技能敌对英雄列表(boss);
  const near2 = cfg.近身扣血半径 * cfg.近身扣血半径;
  const pull2 = cfg.牵引半径 * cfg.牵引半径;
  const damageRatio = cfg.近身扣血目标最大生命基础比例 + cfg.近身扣血每难度追加比例 * 取难度();
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const distance2 = 距离平方XY(GetUnitX(boss), GetUnitY(boss), GetUnitX(hero), GetUnitY(hero));
    if (distance2 <= near2) {
      执行非伤害生命移除({
        目标: hero,
        数值: GetUnitState(hero, UNIT_STATE_MAX_LIFE) * damageRatio,
        不致死: true,
        显示特效: false,
      });
      createUnitEffect(hero, "origin", cfg.近身命中特效路径, cfg.特效持续秒, "菲利斯-异形化近身命中");
    } else if (distance2 <= pull2) {
      开始牵引(hero, {
        中心单位: boss,
        主单位: boss,
        持续时间: cfg.牵引持续秒,
        每秒速度: cfg.牵引每秒速度,
        最小距离: cfg.牵引最小距离,
        闪电效果代码: cfg.牵引闪电代码,
        闪电高度: 80,
        检查地形: true,
        禁用碰撞: false,
        暂停单位: false,
      });
    }
  }
}

function 启动异形化状态(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.异形化;
  context.当前魔法充能 = 0;
  更新魔法显示(context);
  context.异形化中 = true;
  context.异形化结束Ms = getServerTime() + cfg.持续秒 * 1000;
  registerManualBuff(boss, 菲利斯BuffID.异形化, cfg.持续秒, cfg.造成和受到伤害提高, { sourceName: "菲利斯-异形化" });
  创建点特效({ 模型路径: cfg.爆发柱特效路径, X: GetUnitX(boss), Y: GetUnitY(boss), 缩放: 1.75, 持续秒: cfg.特效持续秒 });
  createUnitEffect(boss, "origin", cfg.持续气场特效路径, cfg.持续秒, "菲利斯-异形化持续气场");
  释放菲利斯剑气灵斩(context);

  let tickID = 0;
  tickID = addPeriodicCallback(cfg.Tick秒 * 1000, function 菲利斯异形化Tick回调(this: void): void {
    异形化Tick(context, tickID);
  });
  context.清理.登记周期回调("菲利斯-异形化Tick", tickID);
}

export function 释放菲利斯异形化(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 菲利斯数值与表现配置.异形化;
  const available = context.当前魔法充能 > GetUnitState(boss, UNIT_STATE_MANA)
    ? context.当前魔法充能
    : GetUnitState(boss, UNIT_STATE_MANA);
  if (available < cfg.魔法阈值 || context.异形化中) return;

  启动基础施法时间线({
    施法者: boss,
    目标X: GetUnitX(boss),
    目标Y: GetUnitY(boss),
    硬直秒: 0.25,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "大招",
      总时长: 0.25,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 菲利斯异形化台词(this: void): void {
      播放菲利斯台词(boss, "异形化");
    },
    on生效: function 菲利斯异形化生效(this: void): void {
      启动异形化状态(context);
    },
  });
}

export function 注册菲利斯异形化(this: void): void {
  if (!异形化伤害监听已注册) {
    异形化伤害监听已注册 = true;
    registerAppliedFinalDamageListener(on菲利斯最终伤害充能);
    registerDamageModifier(异形化伤害修正, 60);
  }
  if (异形化已注册) return;
  异形化已注册 = true;
  注册单位技能壳监听({
    名称: "07．异形化",
    单位类型ID: 菲利斯单位类型ID,
    技能ID: 异形化技能ID,
    获取或创建上下文: 获取或创建菲利斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 菲利斯运行时上下文, boss: any): void {
      on菲利斯异形化生效(boss, 异形化技能ID);
    },
  });
}

function on菲利斯异形化生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 异形化技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 菲利斯单位类型ID) return;
  const context = 获取或创建菲利斯上下文(castingUnit);
  if (context == null) return;
  释放菲利斯异形化(context);
}

