/** @noSelfInFile */

import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 获取或创建卡瑟拉上下文, type 卡瑟拉运行时上下文 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, stringToFourCC, 取单位间角度, 取坐标角度, 距离XY, 角度差, 极坐标X, 极坐标Y } from "./14．公共工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { 满足属性抗性门槛 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.13．属性抗性门槛") as {
  满足属性抗性门槛: (this: void, unit: any, type: string, threshold: number, applyLimit?: boolean) => boolean;
};
const { 施加战斗视野压制 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.10．战斗视野压制") as {
  施加战斗视野压制: (this: void, 参数: any) => void;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlType: number, duration: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉") as {
  卡瑟拉BuffID: { 墨汁遮蔽: string };
};

interface 墨汁区域 {
  context: 卡瑟拉运行时上下文;
  起点X: number;
  起点Y: number;
  方向角: number;
  剩余跳数: number;
  周期ID: number;
}

const 卡瑟拉单位类型ID = stringToFourCC(卡瑟拉单位技能配置.单位ID);
const 墨汁喷吐技能ID = stringToFourCC(卡瑟拉数值与表现配置.墨汁喷吐.技能槽位);
let 已注册 = false;

function 取墨汁喷吐目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位有效(spellTarget)) return spellTarget;
  return 获取Boss技能随机敌对英雄(boss, boss, 1400);
}

function 播放墨汁地面特效(this: void, context: 卡瑟拉运行时上下文, x: number, y: number): void {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const model: string = cfg.墨汁残留模型路径;
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  context.清理.登记特效("卡瑟拉-墨汁地面残留", effect);
  const id = addDelayedCallback(cfg.残留秒 * 1000, function 卡瑟拉墨汁残留特效销毁(this: void): void {
    DestroyEffect(effect);
  });
  context.清理.登记延迟回调("卡瑟拉-墨汁残留特效销毁", id);
}

function 单位在墨汁扇形内(this: void, unit: any, area: 墨汁区域): boolean {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const ux = GetUnitX(unit);
  const uy = GetUnitY(unit);
  if (距离XY(ux, uy, area.起点X, area.起点Y) > cfg.扇形半径) return false;
  const angle = 取坐标角度(area.起点X, area.起点Y, ux, uy);
  return 角度差(angle, area.方向角) <= cfg.扇形角度 * 0.5;
}

function 结算墨汁区域一跳(this: void, area: 墨汁区域): void {
  const boss = area.context.Boss单位;
  if (!单位有效(boss) || area.剩余跳数 <= 0) {
    removePeriodicCallback(area.周期ID);
    return;
  }
  area.剩余跳数 = area.剩余跳数 - 1;
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const affected: any[] = [];
  const baseDamage = 读取单位攻击力(boss) * cfg.每秒Boss攻击力比例;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero) || !单位在墨汁扇形内(hero, area)) continue;
    const resisted = 满足属性抗性门槛(hero, "水", cfg.水抗门槛, true);
    const factor = resisted ? cfg.达标效果倍率 : 1;
    UnitDamageTarget(boss, hero, baseDamage * factor, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS);
    施加快速控制Buff(boss, hero, 2, cfg.tick秒 * factor);
    registerManualBuff(hero, 卡瑟拉BuffID.墨汁遮蔽, cfg.tick秒 + 0.2, factor, { sourceName: "卡瑟拉-墨汁遮蔽" });
    affected.push(hero);
  }
  if (affected.length > 0) {
    施加战斗视野压制({
      名称: "卡瑟拉-墨汁视野压制",
      来源单位: boss,
      目标列表: affected,
      持续时间: cfg.tick秒 + 0.2,
      视野减少值: cfg.视野降低,
      BuffID: 卡瑟拉BuffID.墨汁遮蔽,
      叠加键: "卡瑟拉-墨汁遮蔽",
    });
  }
}

function 开始墨汁残留区域(this: void, context: 卡瑟拉运行时上下文, x: number, y: number, angle: number): void {
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const area: 墨汁区域 = {
    context,
    起点X: x,
    起点Y: y,
    方向角: angle,
    剩余跳数: cfg.残留秒 / cfg.tick秒,
    周期ID: 0,
  };
  area.周期ID = addPeriodicCallback(cfg.tick秒 * 1000, function 卡瑟拉墨汁残留周期(this: void): void {
    结算墨汁区域一跳(area);
  });
  context.清理.登记周期回调("卡瑟拉-墨汁残留周期", area.周期ID);
}

function 释放卡瑟拉墨汁喷吐(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取墨汁喷吐目标(boss);
  if (!单位有效(target)) return;
  const cfg = 卡瑟拉数值与表现配置.墨汁喷吐;
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  const angle = 取单位间角度(boss, target);
  const effectX = 极坐标X(bx, angle, cfg.扇形半径 * 0.45);
  const effectY = 极坐标Y(by, angle, cfg.扇形半径 * 0.45);
  播放卡瑟拉台词(boss, "墨汁喷吐");
  创建技能提示圈({
    类型: "扇形",
    X: bx,
    Y: by,
    半径: cfg.扇形半径,
    角度: cfg.扇形角度,
    朝向: angle,
    持续时间: cfg.持续秒,
    来源单位: boss,
  });
  播放墨汁地面特效(context, effectX, effectY);
  const area: 墨汁区域 = {
    context,
    起点X: bx,
    起点Y: by,
    方向角: angle,
    剩余跳数: cfg.持续秒 / cfg.tick秒,
    周期ID: 0,
  };
  area.周期ID = addPeriodicCallback(cfg.tick秒 * 1000, function 卡瑟拉墨汁喷吐周期(this: void): void {
    结算墨汁区域一跳(area);
  });
  context.清理.登记周期回调("卡瑟拉-墨汁喷吐周期", area.周期ID);
  const id = addDelayedCallback(cfg.持续秒 * 1000, function 卡瑟拉墨汁残留开始(this: void): void {
    开始墨汁残留区域(context, bx, by, angle);
  });
  context.清理.登记延迟回调("卡瑟拉-墨汁残留开始", id);
}

function on卡瑟拉墨汁喷吐施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 墨汁喷吐技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 卡瑟拉单位类型ID) return;
  const context = 获取或创建卡瑟拉上下文(castingUnit);
  if (context == null) return;
  释放卡瑟拉墨汁喷吐(context);
}

export function 注册卡瑟拉墨汁喷吐(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册Boss技能壳监听({
    名称: "05．墨汁喷吐",
    Boss单位类型ID: 卡瑟拉单位类型ID,
    技能ID: 墨汁喷吐技能ID,
    获取或创建上下文: 获取或创建卡瑟拉上下文,
    释放技能: function Boss技能壳监听释放(this: void, _context: 卡瑟拉运行时上下文, boss: any): void {
      on卡瑟拉墨汁喷吐施法(boss, 墨汁喷吐技能ID);
    },
  });
}
