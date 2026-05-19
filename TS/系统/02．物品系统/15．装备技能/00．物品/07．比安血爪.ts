/** @noSelfInFile */
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

import { 比安血爪物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 比安血爪配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";
import { 施加临时附加攻击 } from "../03．主动技能/02．施法触发/02．临时附加攻击";

function 单位持有比安血爪(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (比安血爪物品ID <= 0) return false;
  return UnitHasItemOfTypeBJ(单位, 比安血爪物品ID) === true;
}

export function 处理比安血爪施法(this: void, 施法单位: any): void {
  if (!单位持有比安血爪(施法单位)) return;
  施加临时附加攻击(施法单位, 比安血爪配置.附加攻击, 比安血爪配置.持续时间);
}

export {};
