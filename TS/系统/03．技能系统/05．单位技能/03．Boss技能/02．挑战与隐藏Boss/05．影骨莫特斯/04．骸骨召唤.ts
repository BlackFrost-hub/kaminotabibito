/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取或创建影骨莫特斯上下文, type 影骨莫特斯运行时上下文, type 影骨召唤组 } from "./01．运行时上下文";
import { 影骨莫特斯模型动画配置, 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置, 影骨莫特斯音效配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 极坐标X, 极坐标Y, 取单位ID } from "./11．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 计算组合技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
import { 创建召唤物组状态 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/03．召唤物组状态管理";
import { 施加临时属性效果 } from "../../../../00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果";
import type { 临时属性效果实例, 临时属性效果项 } from "../../../../00．技能模板+函数/01．技能函数/20．物品辅助/19．临时属性效果";
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const GetPlayerState = jass.GetPlayerState as (whichPlayer: any, whichPlayerState: any) => number;
const SetPlayerState = jass.SetPlayerState as (whichPlayer: any, whichPlayerState: any, value: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 创建战斗内拾取物 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物") as {
  创建战斗内拾取物: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对目标列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对目标列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { registerDamageBaseModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageBaseModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerDamageTypeConversion } = require("系统.04．伤害系统.00．伤害计算.07．伤害类型转换") as {
  registerDamageTypeConversion: (this: void, callback: (this: void, context: any) => any, priority?: number) => number;
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; effect2?: number; remaining: number } | null;
};
const { 影骨莫特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.04．影骨莫特斯") as {
  影骨莫特斯BuffID: { 骸骨符咒: string; 暗影强化: string };
};
const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 骸骨召唤技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.骸骨召唤);
const 骷髅盗贼ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骷髅盗贼单位类型);
const 骸骨战士ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骸骨战士单位类型);

interface 影骨符咒变量 {
  context: 影骨莫特斯运行时上下文;
}

interface 影骨召唤物变量 {
  context: 影骨莫特斯运行时上下文;
}

interface 影骨召唤组变量 {
  context: 影骨莫特斯运行时上下文;
  阶段: 影骨莫特斯运行时上下文["阶段"];
  允许重组: boolean;
  重组已安排: boolean;
}

interface 影骨骸骨重组变量 {
  context: 影骨莫特斯运行时上下文;
}

let 已注册骸骨召唤 = false;

function 随机取影骨音效路径(this: void, list: readonly string[]): string {
  const count = list.length;
  if (count <= 0) return "";
  if (count === 1) return list[0];
  return list[GetRandomInt(0, count - 1)];
}
let 已注册骷髅偷窃 = false;
let 已注册骷髅伤害转换 = false;
const 影骨召唤物上下文表: Record<number, 影骨莫特斯运行时上下文 | undefined> = {};
const 骸骨符咒属性效果表: Record<number, 临时属性效果实例 | undefined> = {};

function 登记影骨召唤物(this: void, unit: any, context: 影骨莫特斯运行时上下文): void {
  const id = 取单位ID(unit);
  if (id !== 0) 影骨召唤物上下文表[id] = context;
}

function 清除影骨召唤物登记(this: void, unit: any): void {
  const id = 取单位ID(unit);
  if (id !== 0) delete 影骨召唤物上下文表[id];
}

function on影骨骷髅偷窃修正(this: void, damageContext: any): number {
  const attacker = damageContext.originalAttacker != null && damageContext.originalAttacker !== 0 ? damageContext.originalAttacker : damageContext.attacker;
  const target = damageContext.target;
  const context = 影骨召唤物上下文表[取单位ID(attacker)];
  if (context == null || !单位有效(attacker) || !单位有效(target) || damageContext.isNormalAttack !== true) return damageContext.currentDamage;
  const owner = GetOwningPlayer(target);
  const gold = GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD);
  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  const stolen = cfg.偷金币固定值 + gold * cfg.偷金币当前比例;
  const nextGold = gold - stolen;
  SetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD, nextGold > 0 ? nextGold : 0);
  if (gold < GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)) {
    return damageContext.currentDamage + 计算组合技能伤害(attacker, target, {
      来源最大生命比例: cfg.贫血惩罚小弟最大生命比例,
      总倍率: cfg.贫血惩罚伤害倍率,
    });
  }
  return damageContext.currentDamage;
}

function 确保骷髅偷窃修正(this: void): void {
  if (已注册骷髅偷窃) return;
  已注册骷髅偷窃 = true;
  registerDamageBaseModifier(on影骨骷髅偷窃修正, 50);
}

function on影骨骷髅伤害类型转换(this: void, damageContext: any): any {
  const attacker = damageContext.originalAttacker != null && damageContext.originalAttacker !== 0 ? damageContext.originalAttacker : damageContext.attacker;
  if (!单位有效(attacker) || damageContext.isNormalAttack !== true) return undefined;
  if (damageContext.rawDamageType !== DAMAGE_TYPE_NORMAL) return undefined;
  const context = 影骨召唤物上下文表[取单位ID(attacker)];
  if (context == null || !context.幽影爆发中) return undefined;
  const empowered = getBuffRuntime(attacker, 影骨莫特斯BuffID.暗影强化);
  if (empowered == null) return undefined;
  return {
    reapplyDamage: {
      damageType: DAMAGE_TYPE_SHADOW_STRIKE,
      attack: true,
      ranged: damageContext.isRangedAttack === true,
      attackType: damageContext.rawAttackType,
      weaponType: damageContext.rawWeaponType,
    },
  };
}

function 确保骷髅伤害类型转换(this: void): void {
  if (已注册骷髅伤害转换) return;
  已注册骷髅伤害转换 = true;
  registerDamageTypeConversion(on影骨骷髅伤害类型转换, 60);
}

function 清除骸骨符咒属性效果(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  const id = GetHandleId(unit) || 0;
  if (id === 0) return;
  const effect = 骸骨符咒属性效果表[id];
  delete 骸骨符咒属性效果表[id];
  if (effect != null) effect.清除();
}

function on骸骨符咒Buff移除(this: void, unit: any, _buffID: string, _row: any): void {
  清除骸骨符咒属性效果(unit);
}

function 施加骸骨符咒属性效果(this: void, unit: any): void {
  if (!单位有效(unit)) return;
  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  清除骸骨符咒属性效果(unit);
  const 魔抗属性类型 = IsUnitType(unit, UNIT_TYPE_HERO) ? "玩家属性" : "单位属性";
  const 属性项: 临时属性效果项[] = [{
    类型: "护甲",
    数值: cfg.符咒护甲提升,
  }, {
    类型: 魔抗属性类型,
    属性名: "魔抗",
    数值: cfg.符咒魔抗提升,
  }];
  const effect = 施加临时属性效果(unit, cfg.符咒Buff持续秒 * 1000, 属性项);
  const id = GetHandleId(unit) || 0;
  if (id !== 0 && effect.是否激活()) 骸骨符咒属性效果表[id] = effect;
}

function 影骨符咒可拾取单位(this: void, variable: 影骨符咒变量): any[] {
  if (variable == null || !单位有效(variable.context.Boss单位)) return [];
  return 获取Boss技能敌对目标列表(variable.context.Boss单位);
}

function 影骨符咒拾取(this: void, hero: any, _实例: any, _variable: 影骨符咒变量): void {
  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  创建点特效({ 模型路径: 影骨莫特斯表现配置.骸骨符咒拾取, X: GetUnitX(hero), Y: GetUnitY(hero), 持续秒: 影骨莫特斯数值与表现配置.骸骨召唤.瞬时特效持续秒 });
  registerManualBuff(hero, 影骨莫特斯BuffID.骸骨符咒, cfg.符咒Buff持续秒, cfg.符咒护甲提升, {
    effectValue2: cfg.符咒魔抗提升,
    sourceName: "影骨-骸骨符咒",
    onRemove: on骸骨符咒Buff移除,
  });
  施加骸骨符咒属性效果(hero);
}

function 创建骸骨符咒(this: void, context: 影骨莫特斯运行时上下文, x: number, y: number): void {
  创建战斗内拾取物({
    清理: context.清理,
    名称: "影骨-骸骨符咒",
    X: x,
    Y: y,
    模型路径: 影骨莫特斯表现配置.骸骨符咒掉落,
    持续秒: 影骨莫特斯数值与表现配置.骸骨召唤.符咒持续秒,
    拾取半径: 影骨莫特斯数值与表现配置.骸骨召唤.符咒拾取半径,
    变量: { context } as 影骨符咒变量,
    可拾取单位列表: 影骨符咒可拾取单位,
    on拾取: 影骨符咒拾取,
  });
}

function 影骨骸骨战士重组(this: void, variable: 影骨骸骨重组变量): void {
  if (variable == null || !单位有效(variable.context.Boss单位)) return;
  const context = variable.context;
  const angle = GetRandomReal(0, 360);
  const x = 极坐标X(GetUnitX(context.Boss单位), 影骨莫特斯数值与表现配置.骸骨召唤.召唤偏移半径, angle);
  const y = 极坐标Y(GetUnitY(context.Boss单位), 影骨莫特斯数值与表现配置.骸骨召唤.召唤偏移半径, angle);
  创建影骨召唤物(context, 骸骨战士ID, x, y);
  创建点特效({ 模型路径: 影骨莫特斯表现配置.骸骨战士重组, X: x, Y: y, 持续秒: 影骨莫特斯数值与表现配置.骸骨召唤.瞬时特效持续秒 });
  播放Boss坐标音效(随机取影骨音效路径(影骨莫特斯音效配置.骸骨召唤.骸骨战士重组列表), x, y, 影骨莫特斯音效配置.默认裁断距离);
}

function 影骨召唤物死亡(this: void, unit: any, _killer: any, _group: 影骨召唤组, variable?: any): void {
  清除影骨召唤物登记(unit);
  const groupVariable = variable as 影骨召唤组变量 | undefined;
  if (groupVariable == null) return;
  const context = groupVariable.context;
  创建骸骨符咒(context, GetUnitX(unit), GetUnitY(unit));
}

function 影骨召唤组全部死亡(this: void, _group: 影骨召唤组, variable?: any): void {
  const groupVariable = variable as 影骨召唤组变量 | undefined;
  if (groupVariable == null || !groupVariable.允许重组 || groupVariable.重组已安排 || groupVariable.阶段 >= 3) return;
  const context = groupVariable.context;
  if (!单位有效(context.Boss单位)) return;
  groupVariable.重组已安排 = true;
  const id = addDelayedCallback(影骨莫特斯数值与表现配置.骸骨召唤.重组延迟秒 * 1000, 影骨骸骨战士重组, { context } as 影骨骸骨重组变量);
  context.清理.登记延迟回调("影骨-骸骨重组", id);
}

function 影骨召唤物销毁(this: void, unit: any, variable: 影骨召唤物变量): void {
  清除影骨召唤物登记(unit);
}

export function 创建影骨召唤物(this: void, context: 影骨莫特斯运行时上下文, unitType: number, x: number, y: number, group?: 影骨召唤组): any {
  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  const bossMaxLife = GetUnitStateJapi(context.Boss单位, UNIT_STATE_MAX_LIFE);
  const 最大生命 = unitType === 骸骨战士ID
    ? cfg.骸骨战士生命值 + bossMaxLife * cfg.骸骨战士Boss最大生命比例
    : cfg.骷髅生命值 + bossMaxLife * cfg.骷髅Boss最大生命比例;
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "影骨-骷髅召唤物",
    主人单位: context.Boss单位,
    所属玩家: GetOwningPlayer(context.Boss单位),
    单位类型: unitType,
    X: x,
    Y: y,
    朝向: GetRandomReal(0, 360),
    最大生命,
    持续时间: unitType === 骸骨战士ID ? cfg.骸骨战士持续秒 : cfg.骷髅持续秒,
    变量: { context } as 影骨召唤物变量,
    on销毁: 影骨召唤物销毁,
  });
  if (instance != null && instance.单位 != null) {
    登记影骨召唤物(instance.单位, context);
    if (group != null) group.登记(instance.单位);
    if (context.幽影爆发中) registerManualBuff(instance.单位, 影骨莫特斯BuffID.暗影强化, 影骨莫特斯数值与表现配置.幽影爆发.持续秒, 1, { sourceName: "影骨-暗影强化" });
    const target = 获取Boss技能随机敌对英雄(context.Boss单位);
    if (单位有效(target)) IssueTargetOrder(instance.单位, "attack", target);
    创建点特效({ 模型路径: 影骨莫特斯表现配置.骷髅出生, X: x, Y: y, 持续秒: cfg.瞬时特效持续秒 });
  }
  return instance;
}

export function 创建影骨召唤组(this: void, context: 影骨莫特斯运行时上下文, 阶段: 影骨莫特斯运行时上下文["阶段"] = context.阶段, 允许重组: boolean = true, 预期数量: number = 4): 影骨召唤组 {
  const groupVariable: 影骨召唤组变量 = {
    context,
    阶段,
    允许重组,
    重组已安排: false,
  };
  const group = 创建召唤物组状态({
    清理: context.清理,
    名称: "影骨-骸骨召唤组",
    变量: groupVariable,
    on单位死亡: 影骨召唤物死亡,
    on全部死亡: 影骨召唤组全部死亡,
  });
  group.开始批次(预期数量);
  return group;
}

function 召唤影骨骷髅(this: void, context: 影骨莫特斯运行时上下文, group: 影骨召唤组, count: number): void {
  let soundX = GetUnitX(context.Boss单位);
  let soundY = GetUnitY(context.Boss单位);
  for (let i = 0; i < count; i++) {
    const angle = GetRandomReal(0, 360);
    const dist = GetRandomReal(80, 影骨莫特斯数值与表现配置.骸骨召唤.召唤偏移半径);
    const x = 极坐标X(GetUnitX(context.Boss单位), dist, angle);
    const y = 极坐标Y(GetUnitY(context.Boss单位), dist, angle);
    if (i === 0) {
      soundX = x;
      soundY = y;
    }
    创建点特效({ 模型路径: 影骨莫特斯表现配置.骸骨召唤预警, X: x, Y: y, 持续秒: 影骨莫特斯数值与表现配置.骸骨召唤.瞬时特效持续秒 });
    创建影骨召唤物(context, 骷髅盗贼ID, x, y, group);
  }
  播放Boss坐标音效(影骨莫特斯音效配置.骸骨召唤.骷髅盗贼出生, soundX, soundY, 影骨莫特斯音效配置.默认裁断距离);
}

export function 释放影骨骸骨召唤(this: void, context: 影骨莫特斯运行时上下文): 影骨召唤组 | undefined {
  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return undefined;
  if (context.骸骨召唤组合执行器 == null) {
    context.骸骨召唤组合执行器 = 创建固定组合技能执行器<影骨莫特斯运行时上下文>({
      名称: "影骨莫特斯-骸骨召唤",
      清理: context.清理,
      互斥组: "影骨莫特斯骸骨召唤",
    });
  }
  if (context.骸骨召唤组合执行器.是否运行中()) return undefined;
  const group = 创建影骨召唤组(context, context.阶段, true, 4);
  const 执行ID = context.骸骨召唤组合执行器.开始({
    key: "骸骨召唤",
    单位: boss,
    上下文: context,
    最大持续毫秒: 3000,
    阶段列表: 创建固定时间轴阶段列表([{
      时点毫秒: 1000,
      名称: "骸骨召唤第二批",
      执行: function 影骨骸骨召唤第二批(this: void): void {
        召唤影骨骷髅(context, group, 1);
      },
    }, {
      时点毫秒: 2000,
      名称: "骸骨召唤第三批",
      执行: function 影骨骸骨召唤第三批(this: void): void {
        召唤影骨骷髅(context, group, 1);
        group.结束批次();
      },
    }]),
  });
  if (执行ID === 0) {
    group.销毁();
    return undefined;
  }
  启动基础施法时间线({
    名称: "影骨-骸骨召唤",
    施法者: boss,
    硬直秒: 3,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: 影骨莫特斯模型动画配置.战斗待机编号,
    吟唱条: {
      通道: "常规技能",
      总时长: 3,
      颜色ID: 4,
      标题文本: "骸骨召唤",
      提示文本: "莫特斯正在分批唤醒骸骨盗贼",
    },
    清理: context.清理,
    播放台词: function 影骨骸骨召唤台词(this: void): void {
      播放影骨莫特斯台词(boss, "骸骨召唤");
    },
    on生效: function 影骨骸骨召唤时间线生效(this: void): void {},
  });
  context.当前召唤组 = group;
  召唤影骨骷髅(context, group, 2);
  return group;
}

function on影骨骸骨召唤施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 骸骨召唤技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context != null) 释放影骨骸骨召唤(context);
}

export function 注册影骨莫特斯骸骨召唤(this: void): void {
  if (已注册骸骨召唤) return;
  已注册骸骨召唤 = true;
  确保骷髅偷窃修正();
  确保骷髅伤害类型转换();
  注册单位技能壳监听({
    名称: "04．骸骨召唤",
    单位类型ID: 影骨单位类型ID,
    技能ID: 骸骨召唤技能ID,
    获取或创建上下文: 获取或创建影骨莫特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 影骨莫特斯运行时上下文, boss: any): void {
      on影骨骸骨召唤施法(boss, 骸骨召唤技能ID);
    },
  });
}
