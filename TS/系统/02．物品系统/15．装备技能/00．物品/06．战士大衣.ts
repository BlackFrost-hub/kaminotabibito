/** @noSelfInFile */
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

import { 战士大衣物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 战士大衣配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";
import { 施加临时附加攻击 } from "../03．主动技能/02．施法触发/02．临时附加攻击";

function 单位持有战士大衣(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (战士大衣物品ID <= 0) return false;
  return UnitHasItemOfTypeBJ(单位, 战士大衣物品ID) === true;
}

export function 处理战士大衣施法(this: void, 施法单位: any): void {

  if (!单位持有战士大衣(施法单位)) return;
  施加临时附加攻击(施法单位, 战士大衣配置.附加攻击, 战士大衣配置.持续时间);
}

export {};
