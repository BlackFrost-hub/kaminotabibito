/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, gateOperation: number, d: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const IsDestructableInvulnerable = jass.IsDestructableInvulnerable as (destructable: any) => boolean;
const SetDestructableInvulnerable = jass.SetDestructableInvulnerable as (destructable: any, flag: boolean) => void;
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN as number;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 地精钥匙物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";

function 是否为地精钥匙(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 地精钥匙物品ID;
}

export function 处理地精钥匙使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为地精钥匙(上下文.物品)) return;
  const 大门 = 上下文.目标可破坏物;
  if (大门 == null || 大门 === 0) return;
  if (IsDestructableInvulnerable(大门)) return;
  ModifyGateBJ(bj_GATEOPERATION_OPEN, 大门);
  SetDestructableInvulnerable(大门, true);
}

export {};
