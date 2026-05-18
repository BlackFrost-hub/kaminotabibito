/** @noSelfInFile */

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const jass = require("jass.common") as any;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const { isNotUsingInventoryItem } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isNotUsingInventoryItem: (this: void, unit: any) => boolean;
};
const { getObjectPropertyRealSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertyRealSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
};
const { ObjectType } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ObjectType: { ABILITY: number };
};

import { 施法主动技能最小冷却 } from "./01．施法触发常量";
import { 处理战士大衣施法 } from "../../00．物品/06．战士大衣";
import { 处理比安血爪施法 } from "../../00．物品/07．比安血爪";
import { 处理熔岩权杖施法 } from "../../00．物品/04．熔岩权杖";
import { 处理巨魔大剑施法 } from "../../00．物品/09．巨魔大剑";

let 已初始化施法主动技能核心 = false;

function 满足施法主动技能公共前置条件(this: void, 施法单位: any, 技能ID: number): boolean {
  if (施法单位 == null || 施法单位 === 0) return false;
  if (技能ID == null || 技能ID === 0) return false;
  if (!isNotUsingInventoryItem(施法单位)) return false;
  return getObjectPropertyRealSafe(ObjectType.ABILITY, 技能ID, "Cool1") >= 施法主动技能最小冷却;
}

function on施法主动技能生效(this: void, 施法单位: any, 技能ID: number): void {
  if (!满足施法主动技能公共前置条件(施法单位, 技能ID)) return;
  const 目标单位 = GetSpellTargetUnit();
  处理战士大衣施法(施法单位);
  处理比安血爪施法(施法单位);
  if (目标单位 != null && 目标单位 !== 0) {
    处理熔岩权杖施法(施法单位, 目标单位);
    处理巨魔大剑施法(施法单位, 技能ID, 目标单位);
  }
}

export function 初始化施法主动技能核心(this: void): void {
  if (已初始化施法主动技能核心) return;
  已初始化施法主动技能核心 = true;
  registerSpellEffectListener(on施法主动技能生效);
}

export {};
