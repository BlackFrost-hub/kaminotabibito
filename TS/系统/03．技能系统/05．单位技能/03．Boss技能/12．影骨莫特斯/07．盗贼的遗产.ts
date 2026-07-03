/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取或创建影骨莫特斯上下文, 刷新影骨盗贼遗产Buff, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC } from "./11．公共工具";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetPlayerState = jass.GetPlayerState as (whichPlayer: any, whichPlayerState: any) => number;
const SetPlayerState = jass.SetPlayerState as (whichPlayer: any, whichPlayerState: any, value: number) => void;
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．物品技能工具") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 影骨莫特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.10．影骨莫特斯") as {
  影骨莫特斯BuffID: { 阴影陷阱眩晕: string };
};
const { GS_Suspend } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  GS_Suspend: (this: void, unit: any, duration: number) => void;
};

const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 盗贼遗产技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.盗贼的遗产);
let 已注册盗贼遗产 = false;

function 给Boss叠加盗贼遗产(this: void, context: 影骨莫特斯运行时上下文): void {
  context.已开启遗产宝箱数 += 1;
  const bonus = 读取单位攻击力(context.Boss单位) * 影骨莫特斯数值与表现配置.盗贼的遗产.每个宝箱Boss攻击提高;
  临时调整攻击(context.Boss单位, bonus);
  刷新影骨盗贼遗产Buff(context);
}

function 宝箱奖励金币(this: void, opener: any): void {
  const owner = GetOwningPlayer(opener);
  const gold = GetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD);
  SetPlayerState(owner, PLAYER_STATE_RESOURCE_GOLD, gold + GetRandomInt(180, 520));
}

function 宝箱陷阱(this: void, opener: any, x: number, y: number): void {
  if (!单位有效(opener)) return;
  AddSpecialEffect(影骨莫特斯表现配置.宝箱出现, x, y);
  const life = GetUnitState(opener, UNIT_STATE_LIFE);
  SetUnitState(opener, UNIT_STATE_LIFE, life > 300 ? life - 300 : 1);
  GS_Suspend(opener, 1.5);
  registerManualBuff(opener, 影骨莫特斯BuffID.阴影陷阱眩晕, 1.5, 1, { sourceName: "影骨-宝箱陷阱" });
}

function 开启影骨宝箱(this: void, context: 影骨莫特斯运行时上下文, opener: any, x: number, y: number): void {
  给Boss叠加盗贼遗产(context);
  const roll = GetRandomInt(1, 100);
  if (roll <= 30) {
    AddSpecialEffect(影骨莫特斯表现配置.骸骨符咒拾取, x, y);
  } else if (roll <= 55) {
    if (单位有效(opener)) 宝箱奖励金币(opener);
  } else if (roll <= 90) {
    AddSpecialEffect(影骨莫特斯表现配置.宝箱出现, x, y);
  } else {
    宝箱陷阱(opener, x, y);
  }
}

function 创建影骨宝箱(this: void, context: 影骨莫特斯运行时上下文, index: number): void {
  const point = 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱点[index];
  if (point == null) return;
  AddSpecialEffect(影骨莫特斯表现配置.宝箱出现, point.X, point.Y);
  创建可攻击机制单位({
    清理: context.清理,
    名称: "影骨-盗贼遗产宝箱",
    主人单位: context.Boss单位,
    所属玩家: GetOwningPlayer(context.Boss单位),
    单位类型: 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱单位类型,
    模型路径: 影骨莫特斯表现配置.盗贼遗产宝箱,
    X: point.X,
    Y: point.Y,
    朝向: point.朝向,
    最大生命: 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱生命值,
    on死亡: function 影骨宝箱开启(this: void, _unit: any, killer: any): void {
      开启影骨宝箱(context, killer, point.X, point.Y);
    },
  });
}

function 释放影骨盗贼遗产(this: void, context: 影骨莫特斯运行时上下文): void {
  if (context.遗产宝箱已生成) return;
  context.遗产宝箱已生成 = true;
  播放影骨莫特斯台词(context.Boss单位, "盗贼的遗产");
  const count = 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱数量;
  for (let i = 0; i < count; i++) {
    const id = addDelayedCallback(i * 500, function 影骨盗贼遗产宝箱延迟(this: void): void {
      创建影骨宝箱(context, i);
    });
    context.清理.登记延迟回调("影骨-盗贼遗产宝箱", id);
  }
}

function on影骨盗贼遗产施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 盗贼遗产技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context != null) 释放影骨盗贼遗产(context);
}

export function 注册影骨莫特斯盗贼的遗产(this: void): void {
  if (已注册盗贼遗产) return;
  已注册盗贼遗产 = true;
  registerSpellEffectListener(on影骨盗贼遗产施法);
}
