/** @noSelfInFile */

import { 邪恶之心配置, 获得物品装备ID } from "../07．获得物品/00．公共/00．获得物品配置表";

const { 注册持有型周期效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果") as {
  注册持有型周期效果: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    周期回调: (this: void, unit: any, currentCount: number) => void;
  }) => void;
};
const { 减少生命值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, lowestLife?: number) => number;
};
const { 单位存活, 取当前生命, 取最大生命 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  单位存活: (this: void, unit: any) => boolean;
  取当前生命: (this: void, unit: any) => number;
  取最大生命: (this: void, unit: any) => number;
};

const jass = require("jass.common") as any;
const KillUnit = jass.KillUnit as (unit: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;

function on邪恶之心周期(this: void, unit: any): void {
  const amount = 邪恶之心配置.固定扣血 + 取最大生命(unit) * 邪恶之心配置.最大生命扣血比例;
  减少生命值(unit, amount, false, true, undefined, 1);
  if (!单位存活(unit)) return;
  if (取最大生命(unit) < 邪恶之心配置.死亡最小最大生命 || 取当前生命(unit) < 邪恶之心配置.死亡最小当前生命) {
    KillUnit(unit);
    DisplayTimedTextToPlayer(GetOwningPlayer(unit), 0, 0, 20, 邪恶之心配置.死亡提示);
  }
}

function 初始化邪恶之心(this: void): void {
  if (获得物品装备ID.邪恶之心 === 0) return;
  注册持有型周期效果({
    物品类型ID: 获得物品装备ID.邪恶之心,
    间隔毫秒: 邪恶之心配置.间隔毫秒,
    周期回调: on邪恶之心周期,
  });
}

初始化邪恶之心();

export {};
