/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 刷新里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置, 里科特音效配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, 播放里科特施法维持动作, stringToFourCC, 取坐标角度, 极坐标X, 极坐标Y, 点到线段距离平方 } from "./13．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const CreateUnit = jass.CreateUnit as (id: any, unitid: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;
const SetUnitScale = jass.SetUnitScale as (whichUnit: any, scaleX: number, scaleY: number, scaleZ: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (whichUnit: any, red: number, green: number, blue: number, alpha: number) => void;
const UnitAddAbility = jass.UnitAddAbility as (whichUnit: any, abilityId: number) => boolean;
const SetUnitPathing = jass.SetUnitPathing as (whichUnit: any, flag: boolean) => void;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { createTimedEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 里科特BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特") as {
  里科特BuffID: { 湮灭锁定: string };
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};

interface 湮灭投影 {
  context: 里科特运行时上下文;
  投影: any;
  目标: any;
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  朝向: number;
  剩余跳数: number;
  周期ID: number;
}

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 湮灭之炮技能ID = stringToFourCC(里科特数值与表现配置.湮灭之炮.技能槽位);
const 蝗虫技能ID = stringToFourCC("Aloc");
let 已注册 = false;

function 播放限时点特效(this: void, model: string, x: number, y: number, duration: number): void {
  if (model === "") return;
  createTimedEffect(model, x, y, 0, duration);
}

function 创建湮灭投影单位(this: void, boss: any, x: number, y: number, face: number): any {
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const projection = CreateUnit(GetOwningPlayer(boss), stringToFourCC(cfg.投影单位类型), x, y, face);
  if (projection == null || projection === 0) return projection;
  UnitAddAbility(projection, 蝗虫技能ID);
  SetUnitPathing(projection, false);
  SetUnitScale(projection, cfg.投影缩放, cfg.投影缩放, cfg.投影缩放);
  SetUnitVertexColor(projection, 160, 210, 255, cfg.投影透明度);
  播放限时点特效(cfg.出现特效路径, x, y, cfg.出现特效持续秒);
  return projection;
}

function 创建湮灭之炮预警(this: void, data: 湮灭投影): void {
  const cfg = 里科特数值与表现配置.湮灭之炮;
  创建技能提示圈({
    类型: "矩形",
    X: data.起点X,
    Y: data.起点Y,
    宽度: 180,
    长度: cfg.射程,
    朝向: data.朝向,
    持续时间: cfg.tick秒,
    来源单位: data.context.Boss单位,
  });
}

function 结算湮灭之炮一跳(this: void, data: 湮灭投影): void {
  const boss = data.context.Boss单位;
  if (!单位有效(boss) || data.剩余跳数 <= 0) {
    removePeriodicCallback(data.周期ID);
    if (data.投影 != null && data.投影 !== 0) RemoveUnit(data.投影);
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  创建湮灭之炮预警(data);
  播放限时点特效(里科特数值与表现配置.湮灭之炮.射线特效路径, data.终点X, data.终点Y, 里科特数值与表现配置.湮灭之炮.射线持续秒);

  const heroes = 获取Boss技能敌对英雄列表(boss);
  const damage = 读取单位攻击力(boss) * 里科特数值与表现配置.湮灭之炮.每跳Boss攻击力比例;
  const radius2 = 90 * 90;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dist2 = 点到线段距离平方(GetUnitX(hero), GetUnitY(hero), data.起点X, data.起点Y, data.终点X, data.终点Y);
    if (dist2 <= radius2) {
      造成AOE技能伤害({
        技能ID: 湮灭之炮技能ID,
        来源: boss,
        目标: hero,
        伤害: damage,
        attack: false,
        ranged: false,
        attackType: ATTACK_TYPE_MAGIC,
        伤害类型: DAMAGE_TYPE_MAGIC,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
      });
    }
  }
}

function 开始湮灭投影炮击(this: void, data: 湮灭投影): void {
  const cfg = 里科特数值与表现配置.湮灭之炮;
  播放Boss坐标音效(里科特音效配置.湮灭之炮.射线开火, data.起点X, data.起点Y, 里科特音效配置.默认裁断距离);
  data.剩余跳数 = cfg.锁定持续秒 / cfg.tick秒;
  data.周期ID = addPeriodicCallback(cfg.tick秒 * 1000, function 里科特湮灭投影周期炮击(this: void): void {
    结算湮灭之炮一跳(data);
  });
  data.context.清理.登记周期回调("里科特-湮灭之炮周期", data.周期ID);
}

function 调度单个湮灭投影(this: void, context: 里科特运行时上下文, target: any): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target)) return;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const angle = 取坐标角度(GetUnitX(boss), GetUnitY(boss), GetUnitX(target), GetUnitY(target));
  const px = 极坐标X(GetUnitX(target), angle, cfg.投影距离);
  const py = 极坐标Y(GetUnitY(target), angle, cfg.投影距离);
  const face = 取坐标角度(px, py, GetUnitX(target), GetUnitY(target));
  const projection = 创建湮灭投影单位(boss, px, py, face);
  const delay = 刷新里科特阶段(context) >= 2 ? cfg.P2锁定前延迟秒 : cfg.锁定前延迟秒;
  if (单位有效(projection)) 播放里科特施法维持动作(projection, delay + cfg.锁定持续秒, cfg.动画速度);
  播放Boss坐标音效(里科特音效配置.湮灭之炮.投影锁定, px, py, 里科特音效配置.默认裁断距离);
  const data: 湮灭投影 = {
    context,
    投影: projection,
    目标: target,
    起点X: px,
    起点Y: py,
    终点X: 极坐标X(px, face, cfg.射程),
    终点Y: 极坐标Y(py, face, cfg.射程),
    朝向: face,
    剩余跳数: 0,
    周期ID: 0,
  };
  if (projection != null && projection !== 0) context.清理.登记单位("里科特-湮灭投影", projection);
  registerManualBuff(target, 里科特BuffID.湮灭锁定, cfg.锁定前延迟秒 + cfg.锁定持续秒, 1, { sourceName: "里科特-湮灭锁定" });
  创建技能提示圈({
    类型: "矩形",
    X: px,
    Y: py,
    宽度: 180,
    长度: cfg.射程,
    朝向: face,
    持续时间: 刷新里科特阶段(context) >= 2 ? cfg.P2锁定前延迟秒 : cfg.锁定前延迟秒,
    来源单位: boss,
  });
  const id = addDelayedCallback(delay * 1000, function 里科特湮灭投影延迟开炮(this: void): void {
    开始湮灭投影炮击(data);
  });
  context.清理.登记延迟回调("里科特-湮灭投影开炮", id);
}

function 调度P3眩晕炮(this: void, context: 里科特运行时上下文): void {
  if (刷新里科特阶段(context) < 3) return;
  const boss = context.Boss单位;
  const target = 获取Boss技能随机敌对英雄(boss, boss, 2000);
  if (!单位有效(target)) return;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  创建技能提示圈({
    类型: "圆形",
    X: GetUnitX(target),
    Y: GetUnitY(target),
    半径: cfg.P3眩晕炮半径,
    持续时间: cfg.P3眩晕炮延迟秒,
    来源单位: boss,
  });
  const id = addDelayedCallback(cfg.P3眩晕炮延迟秒 * 1000, function 里科特P3湮灭眩晕炮结算(this: void): void {
    if (!单位有效(boss) || !单位有效(target)) return;
    const heroes = 获取Boss技能敌对英雄列表(boss);
    const cx = GetUnitX(target);
    const cy = GetUnitY(target);
    const radius2 = cfg.P3眩晕炮半径 * cfg.P3眩晕炮半径;
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      if (!单位有效(hero)) continue;
      const dx = GetUnitX(hero) - cx;
      const dy = GetUnitY(hero) - cy;
      if (dx * dx + dy * dy <= radius2) 施加眩晕(boss, hero, cfg.P3眩晕秒);
    }
  });
  context.清理.登记延迟回调("里科特-P3湮灭眩晕炮", id);
}

export function 释放里科特湮灭之炮(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 里科特数值与表现配置.湮灭之炮;
  const castDuration = 刷新里科特阶段(context) >= 2 ? cfg.P2锁定前延迟秒 : cfg.锁定前延迟秒;
  播放里科特施法维持动作(boss, castDuration, cfg.动画速度);
  播放里科特台词(boss, "湮灭之炮");
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) 调度单个湮灭投影(context, heroes[i]);
  调度P3眩晕炮(context);
}

function on里科特湮灭之炮施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 湮灭之炮技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特湮灭之炮(context);
}

export function 注册里科特湮灭之炮(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "07．湮灭之炮",
    单位类型ID: 里科特单位类型ID,
    技能ID: 湮灭之炮技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特湮灭之炮施法(boss, 湮灭之炮技能ID);
    },
  });
}
