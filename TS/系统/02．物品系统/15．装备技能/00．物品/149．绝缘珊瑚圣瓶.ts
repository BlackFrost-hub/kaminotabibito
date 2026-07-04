/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是敌对单位, 取冷却键, 冷却就绪, 进入冷却, 开始通用护盾, 临时受到治疗率, 取最大生命, 第二章后段Boss战利品装备名 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerAppliedFinalHealListener } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerAppliedFinalHealListener: (this: void, cb: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => void) => void;
};

function on绝缘珊瑚圣瓶治疗(this: void, source: any, target: any, amount: number, isItemHeal: boolean): void {
  if (!(amount > 0) || source == null || source === 0 || target == null || target === 0) return;
  if (是敌对单位(source, target)) return;
  if (!单位持有第二章后段Boss战利品(source, 第二章后段Boss战利品装备名.绝缘珊瑚圣瓶)) return;
  const key = 取冷却键(source, "绝缘珊瑚圣瓶");
  if (!冷却就绪(key)) return;
  进入冷却(key, 10);
  开始通用护盾(source, target, 300 + 取最大生命(target) * 0.08, 5, "绝缘珊瑚圣瓶");
  临时受到治疗率(target, 0.12, 5);
}

registerAppliedFinalHealListener(on绝缘珊瑚圣瓶治疗);

export {};
