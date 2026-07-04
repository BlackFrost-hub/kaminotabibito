/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取或创建影骨莫特斯上下文, 刷新影骨盗贼遗产Buff, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC } from "./11．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建交互宝箱 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.12．交互宝箱桥接") as {
  创建交互宝箱: (this: void, 参数: any) => any;
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 盗贼遗产技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.盗贼的遗产);
let 已注册盗贼遗产 = false;

interface 影骨遗产宝箱变量 {
  context: 影骨莫特斯运行时上下文;
  X: number;
  Y: number;
}

interface 影骨遗产宝箱延迟上下文 {
  context: 影骨莫特斯运行时上下文;
  index: number;
}

const 影骨遗产宝箱延迟上下文表: Record<number, 影骨遗产宝箱延迟上下文 | undefined> = {};

function 给Boss叠加盗贼遗产(this: void, context: 影骨莫特斯运行时上下文): void {
  context.已开启遗产宝箱数 += 1;
  const bonus = 读取单位攻击力(context.Boss单位) * 影骨莫特斯数值与表现配置.盗贼的遗产.每个宝箱Boss攻击提高;
  临时调整攻击(context.Boss单位, bonus);
  刷新影骨盗贼遗产Buff(context);
}

function 开启影骨宝箱(this: void, context: 影骨莫特斯运行时上下文, x: number, y: number): void {
  给Boss叠加盗贼遗产(context);
  AddSpecialEffect(影骨莫特斯表现配置.宝箱出现, x, y);
}

function 影骨遗产宝箱开启中(this: void, opener: any, _chest: any, _elapsed: number, _config: any, variable: 影骨遗产宝箱变量): void {
  if (variable == null || !单位有效(opener)) return;
  const context = variable.context;
  if (单位有效(context.Boss单位)) IssueTargetOrder(context.Boss单位, "attack", opener);
  for (let i = 0; i < context.幽影召唤物.length; i++) {
    const summon = context.幽影召唤物[i];
    if (单位有效(summon)) IssueTargetOrder(summon, "attack", opener);
  }
}

function 影骨遗产宝箱开启完成(this: void, opener: any, _chest: any, _config: any, variable: 影骨遗产宝箱变量): void {
  if (variable == null || !单位有效(opener)) return;
  开启影骨宝箱(variable.context, variable.X, variable.Y);
}

function 创建影骨宝箱(this: void, context: 影骨莫特斯运行时上下文, index: number): void {
  const point = 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱点[index];
  if (point == null) return;
  AddSpecialEffect(影骨莫特斯表现配置.宝箱出现, point.X, point.Y);
  创建交互宝箱({
    清理: context.清理,
    名称: "影骨-盗贼遗产宝箱",
    可破坏物ID: 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱可破坏物ID,
    X: point.X,
    Y: point.Y,
    朝向: point.朝向,
    变量: { context, X: point.X, Y: point.Y } as 影骨遗产宝箱变量,
    on开启中: 影骨遗产宝箱开启中,
    on开启完成: 影骨遗产宝箱开启完成,
  });
}

function 执行影骨遗产宝箱延迟生成(this: void, index: number): void {
  const variable = 影骨遗产宝箱延迟上下文表[index];
  if (variable == null) return;
  delete 影骨遗产宝箱延迟上下文表[index];
  创建影骨宝箱(variable.context, variable.index);
}

function 影骨遗产宝箱延迟生成1(this: void): void {
  执行影骨遗产宝箱延迟生成(0);
}

function 影骨遗产宝箱延迟生成2(this: void): void {
  执行影骨遗产宝箱延迟生成(1);
}

function 影骨遗产宝箱延迟生成3(this: void): void {
  执行影骨遗产宝箱延迟生成(2);
}

function 影骨遗产宝箱延迟生成4(this: void): void {
  执行影骨遗产宝箱延迟生成(3);
}

function 取影骨遗产宝箱延迟回调(this: void, index: number): ((this: void) => void) | undefined {
  if (index === 0) return 影骨遗产宝箱延迟生成1;
  if (index === 1) return 影骨遗产宝箱延迟生成2;
  if (index === 2) return 影骨遗产宝箱延迟生成3;
  if (index === 3) return 影骨遗产宝箱延迟生成4;
  return undefined;
}

function 注册影骨遗产宝箱延迟生成(this: void, context: 影骨莫特斯运行时上下文, index: number): void {
  const callback = 取影骨遗产宝箱延迟回调(index);
  if (callback == null) return;
  影骨遗产宝箱延迟上下文表[index] = { context, index };
  const id = addDelayedCallback(index * 500, callback);
  context.清理.登记延迟回调("影骨-盗贼遗产宝箱", id);
}

export function 释放影骨盗贼遗产(this: void, context: 影骨莫特斯运行时上下文): void {
  if (context.遗产宝箱已生成) return;
  context.遗产宝箱已生成 = true;
  播放影骨莫特斯台词(context.Boss单位, "盗贼的遗产");
  const count = 影骨莫特斯数值与表现配置.盗贼的遗产.宝箱数量;
  for (let i = 0; i < count; i++) {
    注册影骨遗产宝箱延迟生成(context, i);
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
  注册单位技能壳监听({
    名称: "07．盗贼的遗产",
    单位类型ID: 影骨单位类型ID,
    技能ID: 盗贼遗产技能ID,
    获取或创建上下文: 获取或创建影骨莫特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 影骨莫特斯运行时上下文, boss: any): void {
      on影骨盗贼遗产施法(boss, 盗贼遗产技能ID);
    },
  });
}
