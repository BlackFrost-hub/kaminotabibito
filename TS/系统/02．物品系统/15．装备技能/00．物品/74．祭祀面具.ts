/** @noSelfInFile */

import { 祭祀面具配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

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
const { 单位存活, 取当前魔法, 取最大魔法 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  单位存活: (this: void, unit: any) => boolean;
  取当前魔法: (this: void, unit: any) => number;
  取最大魔法: (this: void, unit: any) => number;
};

const jass = require("jass.common") as any;
const KillUnit = jass.KillUnit as (unit: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;

function on祭祀面具周期(this: void, unit: any): void {
  const amount = 祭祀面具配置.固定扣蓝 + 取最大魔法(unit) * 祭祀面具配置.最大魔法扣蓝比例;
  减少魔法值(unit, amount, true, true);
  if (!单位存活(unit)) return;
  if (取最大魔法(unit) < 祭祀面具配置.死亡最小最大魔法 || 取当前魔法(unit) < 祭祀面具配置.死亡最小当前魔法) {
    KillUnit(unit);
    DisplayTimedTextToPlayer(GetOwningPlayer(unit), 0, 0, 20, 祭祀面具配置.死亡提示);
  }
}

function 初始化祭祀面具(this: void): void {
  if (获得物品装备ID.祭祀面具 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.祭祀面具,
    间隔毫秒: 祭祀面具配置.间隔毫秒,
    周期回调: on祭祀面具周期,
  });
}

初始化祭祀面具();

export {};
