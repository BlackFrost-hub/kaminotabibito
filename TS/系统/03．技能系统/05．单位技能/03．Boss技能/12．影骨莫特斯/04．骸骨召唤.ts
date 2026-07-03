/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取或创建影骨莫特斯上下文, 刷新影骨莫特斯阶段, type 影骨莫特斯运行时上下文, type 影骨召唤组 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 极坐标X, 极坐标Y, 取单位ID } from "./11．公共工具";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const GetPlayerState = jass.GetPlayerState as (whichPlayer: any, whichPlayerState: any) => number;
const SetPlayerState = jass.SetPlayerState as (whichPlayer: any, whichPlayerState: any, value: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 创建战斗内拾取物 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物") as {
  创建战斗内拾取物: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 影骨莫特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.10．影骨莫特斯") as {
  影骨莫特斯BuffID: { 骸骨符咒: string; 暗影强化: string };
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 骸骨召唤技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.骸骨召唤);
const 骷髅盗贼ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骷髅盗贼单位类型);
const 骸骨战士ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骸骨战士单位类型);

let 已注册骸骨召唤 = false;
let 已注册骷髅偷窃 = false;
const 影骨召唤物上下文表: Record<number, 影骨莫特斯运行时上下文 | undefined> = {};

function 登记影骨召唤物(this: void, unit: any, context: 影骨莫特斯运行时上下文): void {
  const id = 取单位ID(unit);
  if (id !== 0) 影骨召唤物上下文表[id] = context;
}

function 清除影骨召唤物登记(this: void, unit: any): void {
  const id = 取单位ID(unit);
  if (id !== 0) delete 影骨召唤物上下文表[id];
}

function on影骨骷髅偷窃修正(this: void, damageContext: any): number {
  const attacker = damageContext.attacker;
  const target = damageContext.target;
  const context = 影骨召唤物上下文表[取单位ID(attacker)];
  if (context == null || !单位有效(attacker) || !单位有效(target) || damageContext.isNormalAttack !== true) return damageContext.currentDamage;
  const owner = GetOwningPlayer(target);
  const gold = GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD);
  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  const stolen = cfg.偷金币固定值 + gold * cfg.偷金币当前比例;
  const nextGold = gold - stolen;
  SetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD, nextGold > 0 ? nextGold : 0);
  if (gold < GetUnitState(target, UNIT_STATE_MAX_LIFE)) {
    return damageContext.currentDamage + 读取单位攻击力(context.Boss单位) * cfg.贫血惩罚Boss攻击力比例 + GetUnitState(target, UNIT_STATE_MAX_LIFE) * cfg.贫血惩罚目标最大生命比例;
  }
  return damageContext.currentDamage;
}

function 确保骷髅偷窃修正(this: void): void {
  if (已注册骷髅偷窃) return;
  已注册骷髅偷窃 = true;
  registerDamageModifier(on影骨骷髅偷窃修正, 50);
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
    可拾取单位列表: function 影骨符咒可拾取单位(this: void): any[] {
      return 获取Boss技能敌对英雄列表(context.Boss单位);
    },
    on拾取: function 影骨符咒拾取(this: void, hero: any): void {
      AddSpecialEffect(影骨莫特斯表现配置.骸骨符咒拾取, GetUnitX(hero), GetUnitY(hero));
      registerManualBuff(hero, 影骨莫特斯BuffID.骸骨符咒, 12, 1, { sourceName: "影骨-骸骨符咒" });
    },
  });
}

function 尝试重组骸骨战士(this: void, context: 影骨莫特斯运行时上下文, group: 影骨召唤组): void {
  if (group.已重组 || group.阶段 >= 3 || group.死亡数 < group.总数) return;
  group.已重组 = true;
  const id = addDelayedCallback(影骨莫特斯数值与表现配置.骸骨召唤.重组延迟秒 * 1000, function 影骨骸骨战士重组(this: void): void {
    if (!单位有效(context.Boss单位)) return;
    const angle = GetRandomReal(0, 360);
    const x = 极坐标X(GetUnitX(context.Boss单位), 影骨莫特斯数值与表现配置.骸骨召唤.召唤偏移半径, angle);
    const y = 极坐标Y(GetUnitY(context.Boss单位), 影骨莫特斯数值与表现配置.骸骨召唤.召唤偏移半径, angle);
    创建影骨召唤物(context, 骸骨战士ID, x, y, undefined, false);
    AddSpecialEffect(影骨莫特斯表现配置.骸骨战士重组, x, y);
  });
  context.清理.登记延迟回调("影骨-骸骨重组", id);
}

export function 创建影骨召唤物(this: void, context: 影骨莫特斯运行时上下文, unitType: number, x: number, y: number, group?: 影骨召唤组, canReform: boolean = true): any {
  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "影骨-骷髅召唤物",
    主人单位: context.Boss单位,
    所属玩家: GetOwningPlayer(context.Boss单位),
    单位类型: unitType,
    X: x,
    Y: y,
    朝向: GetRandomReal(0, 360),
    最大生命: unitType === 骸骨战士ID ? cfg.骸骨战士生命值 : cfg.骷髅生命值,
    持续时间: unitType === 骸骨战士ID ? cfg.骸骨战士持续秒 : cfg.骷髅持续秒,
    on死亡: function 影骨召唤物死亡(this: void, unit: any): void {
      清除影骨召唤物登记(unit);
      创建骸骨符咒(context, GetUnitX(unit), GetUnitY(unit));
      if (group != null && canReform) {
        group.死亡数 += 1;
        尝试重组骸骨战士(context, group);
      }
    },
    on销毁: function 影骨召唤物销毁(this: void, unit: any): void {
      清除影骨召唤物登记(unit);
    },
  });
  if (instance != null && instance.单位 != null) {
    登记影骨召唤物(instance.单位, context);
    if (context.幽影爆发中) registerManualBuff(instance.单位, 影骨莫特斯BuffID.暗影强化, 影骨莫特斯数值与表现配置.幽影爆发.持续秒, 1, { sourceName: "影骨-暗影强化" });
    const target = 获取Boss技能随机敌对英雄(context.Boss单位);
    if (单位有效(target)) IssueTargetOrder(instance.单位, "attack", target);
    AddSpecialEffect(影骨莫特斯表现配置.骷髅出生, x, y);
  }
  return instance;
}

function 召唤影骨骷髅(this: void, context: 影骨莫特斯运行时上下文, group: 影骨召唤组, count: number): void {
  for (let i = 0; i < count; i++) {
    const angle = GetRandomReal(0, 360);
    const dist = GetRandomReal(80, 影骨莫特斯数值与表现配置.骸骨召唤.召唤偏移半径);
    const x = 极坐标X(GetUnitX(context.Boss单位), dist, angle);
    const y = 极坐标Y(GetUnitY(context.Boss单位), dist, angle);
    AddSpecialEffect(影骨莫特斯表现配置.骸骨召唤预警, x, y);
    创建影骨召唤物(context, 骷髅盗贼ID, x, y, group, true);
  }
}

function 释放影骨骸骨召唤(this: void, context: 影骨莫特斯运行时上下文): void {
  播放影骨莫特斯台词(context.Boss单位, "骸骨召唤");
  const group: 影骨召唤组 = {
    ID: ++context.下一个召唤组ID,
    阶段: 刷新影骨莫特斯阶段(context),
    总数: 4,
    死亡数: 0,
    已重组: false,
  };
  context.当前召唤组 = group;
  召唤影骨骷髅(context, group, 2);
  context.清理.登记延迟回调("影骨-骸骨召唤2", addDelayedCallback(1000, function 影骨骸骨召唤第二段(this: void): void { 召唤影骨骷髅(context, group, 1); }));
  context.清理.登记延迟回调("影骨-骸骨召唤3", addDelayedCallback(2000, function 影骨骸骨召唤第三段(this: void): void { 召唤影骨骷髅(context, group, 1); }));
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
  registerSpellEffectListener(on影骨骸骨召唤施法);
}
