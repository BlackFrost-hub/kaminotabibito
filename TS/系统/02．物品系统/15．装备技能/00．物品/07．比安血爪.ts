/** @noSelfInFile */
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

import { 比安血爪物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 比安血爪配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

function 单位持有比安血爪(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (比安血爪物品ID <= 0) return false;
  return UnitHasItemOfTypeBJ(单位, 比安血爪物品ID) === true;
}

export function 处理比安血爪施法(this: void, 施法单位: any): void {
  if (!单位持有比安血爪(施法单位)) return;
  施加临时属性效果(施法单位, 比安血爪配置.持续时间 * 1000, [{ 类型: "攻击", 数值: 比安血爪配置.附加攻击 }]);
}

export {};
