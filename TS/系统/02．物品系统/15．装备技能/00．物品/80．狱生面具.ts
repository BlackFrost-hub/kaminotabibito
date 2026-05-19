/** @noSelfInFile */

import { 狱生面具配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const { 获取范围敌人, 取单位X, 取单位Y, 取最大魔法, 造成暗影伤害, 执行治疗 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  获取范围敌人: (this: void, source: any, x: number, y: number, radius: number) => any[];
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  取最大魔法: (this: void, unit: any) => number;
  造成暗影伤害: (this: void, source: any, target: any, damage: number) => void;
  执行治疗: (this: void, source: any, target: any, heal: number, mana?: number) => void;
};

function on狱生面具周期(this: void, unit: any): void {
  const consumed = -减少魔法值(unit, 取最大魔法(unit) * 狱生面具配置.最大魔法消耗比例, false, false);
  if (!(consumed > 0)) return;
  const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), 狱生面具配置.作用范围);
  for (let i = 0; i < targets.length; i++) {
    造成暗影伤害(unit, targets[i], consumed);
  }
  执行治疗(unit, unit, consumed, 0);
}

function 初始化狱生面具(this: void): void {
  if (获得物品装备ID.狱生面具 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.狱生面具,
    间隔毫秒: 狱生面具配置.间隔毫秒,
    周期回调: on狱生面具周期,
  });
}

初始化狱生面具();

export {};
