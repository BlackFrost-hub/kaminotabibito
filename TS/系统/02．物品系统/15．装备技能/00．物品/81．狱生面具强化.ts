/** @noSelfInFile */

import { 狱生面具配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";
import { 记录或刷新延迟死亡结算, 单位是否死亡或无效 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/07．死亡结算模板";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 获取单位当前持有指定物品数量 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听") as {
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 获取范围敌人, 取单位X, 取单位Y, 取最大魔法, 取最大生命, 取当前生命, 取当前魔法, 造成暗影伤害 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  获取范围敌人: (this: void, source: any, x: number, y: number, radius: number) => any[];
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  取最大魔法: (this: void, unit: any) => number;
  取最大生命: (this: void, unit: any) => number;
  取当前生命: (this: void, unit: any) => number;
  取当前魔法: (this: void, unit: any) => number;
  造成暗影伤害: (this: void, source: any, target: any, damage: number) => void;
  执行治疗: (this: void, source: any, target: any, heal: number, mana?: number) => void;
};

function 单位已死亡(this: void, unit: any): boolean {
  return 单位是否死亡或无效(unit);
}

function 单位持有狱生面具强化(this: void, unit: any): boolean {
  return 获取单位当前持有指定物品数量(unit, 获得物品装备ID.狱生面具强化) > 0;
}

function on狱生面具强化击杀结算(this: void, 上下文: any): void {
  const source = 上下文.来源单位;
  const heal = (取最大生命(source) - 取当前生命(source)) * 狱生面具配置.强化恢复比例;
  const mana = (取最大魔法(source) - 取当前魔法(source)) * 狱生面具配置.强化恢复比例;
  doHeal({
    HealSource: source,
    HealTarget: source,
    HealAmount: heal,
    HealManaAmount: mana,
    ItemHeal: true,
    HealEffect: true,
    ManaEffect: true,
  });
}

function 记录狱生面具强化目标(this: void, source: any, target: any): void {
  记录或刷新延迟死亡结算({
    key前缀: "狱生面具强化",
    来源单位: source,
    目标单位: target,
    延迟毫秒: 狱生面具配置.强化延迟毫秒,
    来源有效性检查: function 狱生面具强化来源仍有效(this: void, 上下文): boolean {
      return 单位持有狱生面具强化(上下文.来源单位);
    },
    on目标死亡: on狱生面具强化击杀结算,
  });
}

function on狱生面具强化周期(this: void, unit: any): void {
  const consumed = -减少魔法值(unit, 取最大魔法(unit) * 狱生面具配置.最大魔法消耗比例, true, false);
  if (!(consumed > 0)) return;
  const damage = consumed * 狱生面具配置.强化伤害倍率;
  const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), 狱生面具配置.作用范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (单位已死亡(target)) continue;
    记录狱生面具强化目标(unit, target);
    造成暗影伤害(unit, target, damage);
  }
}

function 初始化狱生面具强化(this: void): void {
  if (获得物品装备ID.狱生面具强化 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.狱生面具强化,
    间隔毫秒: 狱生面具配置.间隔毫秒,
    周期回调: on狱生面具强化周期,
  });
}

初始化狱生面具强化();

export {};
