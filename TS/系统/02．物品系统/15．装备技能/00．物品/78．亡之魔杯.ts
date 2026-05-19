/** @noSelfInFile */

import { 亡之魔杯配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { doManaRegen } = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复") as {
  doManaRegen: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean) => number;
};
const { 取当前魔法, 取最大魔法 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  取当前魔法: (this: void, unit: any) => number;
  取最大魔法: (this: void, unit: any) => number;
};

function on亡之魔杯周期(this: void, unit: any): void {
  const gain = (取最大魔法(unit) - 取当前魔法(unit)) * 亡之魔杯配置.恢复缺失魔法比例;
  if (!(gain > 0)) return;
  doManaRegen(unit, gain, false, true);
}

function 初始化亡之魔杯(this: void): void {
  if (获得物品装备ID.亡之魔杯 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.亡之魔杯,
    间隔毫秒: 亡之魔杯配置.间隔毫秒,
    周期回调: on亡之魔杯周期,
  });
}

初始化亡之魔杯();

export {};
