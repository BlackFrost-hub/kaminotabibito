/** @noSelfInFile */

const { registerHealCallback } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerHealCallback: (this: void, cb: (source: any, target: any, amount: number, isItemHeal: boolean) => number) => void;
};

import { 处理黑牧杖治疗 } from "../../00．物品/03．黑牧杖";

let 已初始化治疗触发主动技能核心 = false;

function 处理治疗触发主动技能(this: void, 来源: any, 目标: any, 治疗量: number, 是否物品治疗: boolean): number {
  return 处理黑牧杖治疗(来源, 目标, 治疗量, 是否物品治疗);
}

export function 初始化治疗触发主动技能核心(this: void): void {
  if (已初始化治疗触发主动技能核心) return;
  已初始化治疗触发主动技能核心 = true;
  registerHealCallback(处理治疗触发主动技能);
}

export {};
