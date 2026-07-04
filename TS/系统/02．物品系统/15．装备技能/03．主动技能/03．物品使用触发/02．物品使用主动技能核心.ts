/** @noSelfInFile */

const { 注册物品技能事件监听 } = require("系统.00．核心系统.01．事件中心.13．物品技能事件中心") as {
  注册物品技能事件监听: (this: void, callback: (this: void, 上下文: any) => void) => void;
};

const jass = require("jass.common") as any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

import type { 物品技能事件上下文 } from "./01．物品使用触发常量";
import * as 主动技能物品ID from "../00．公共/01．主动技能物品ID";
import { 处理破血之戒使用 } from "../../00．物品/05．破血之戒";
import { 处理远古毒咒护符使用 } from "../../00．物品/10．远古毒咒护符";
import { 处理史莱姆粘液瓶使用 } from "../../00．物品/11．史莱姆粘液瓶";
import { 处理地精钥匙使用 } from "../../00．物品/12．地精钥匙";
import { 处理祭祀之杖使用 } from "../../00．物品/13．祭祀之杖";
import { 处理幽冥法杖使用 } from "../../00．物品/14．幽冥法杖";
import { 处理熔岩恶魔之灵眼使用 } from "../../00．物品/15．熔岩恶魔之灵眼";
import { 处理暗幽亡戒使用 } from "../../00．物品/16．暗幽亡戒";
import { 处理使者魔炉使用 } from "../../00．物品/17．使者魔炉";
import { 处理汭冥血杖使用 } from "../../00．物品/18．汭冥血杖";
import { 处理汭冥血杖强化使用 } from "../../00．物品/19．汭冥血杖强化";
import { 处理使者精神魔杖使用 } from "../../00．物品/20．使者精神魔杖";
import { 处理史诗远古魔刃使用 } from "../../00．物品/21．史诗远古魔刃";
import { 处理焰虚宝珠使用 } from "../../00．物品/22．焰虚宝珠";
import { 处理先祖之狱杖使用 } from "../../00．物品/23．先祖之狱杖";
import { 处理咆哮之心使用 } from "../../00．物品/24．咆哮之心";
import { 处理指挥之剑使用 } from "../../00．物品/25．指挥之剑";
import { 处理使者魔轮使用 } from "../../00．物品/26．使者魔轮";

let 已初始化物品主动技能核心 = false;

function 施法单位是英雄(this: void, 上下文: 物品技能事件上下文): boolean {
  const 单位 = 上下文.施法单位;
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_HERO) === true;
}

function on物品主动技能生效(this: void, 上下文: 物品技能事件上下文): void {
  if (!施法单位是英雄(上下文)) return;
  if (上下文.物品 == null || 上下文.物品 === 0) return;
  const 物品类型ID = GetItemTypeId(上下文.物品);
  switch (物品类型ID) {
    case 主动技能物品ID.破血之戒物品ID:
      处理破血之戒使用(上下文);
      break;
    case 主动技能物品ID.远古毒咒护符物品ID:
      处理远古毒咒护符使用(上下文);
      break;
    case 主动技能物品ID.史莱姆粘液瓶物品ID:
      处理史莱姆粘液瓶使用(上下文);
      break;
    case 主动技能物品ID.地精钥匙物品ID:
      处理地精钥匙使用(上下文);
      break;
    case 主动技能物品ID.祭祀之杖物品ID:
      处理祭祀之杖使用(上下文);
      break;
    case 主动技能物品ID.幽冥法杖物品ID:
      处理幽冥法杖使用(上下文);
      break;
    case 主动技能物品ID.熔岩恶魔之灵眼物品ID:
      处理熔岩恶魔之灵眼使用(上下文);
      break;
    case 主动技能物品ID.暗幽亡戒物品ID:
      处理暗幽亡戒使用(上下文);
      break;
    case 主动技能物品ID.使者魔炉物品ID:
      处理使者魔炉使用(上下文);
      break;
    case 主动技能物品ID.汭冥血杖物品ID:
      处理汭冥血杖使用(上下文);
      break;
    case 主动技能物品ID.汭冥血杖强化物品ID:
      处理汭冥血杖强化使用(上下文);
      break;
    case 主动技能物品ID.使者精神魔杖物品ID:
      处理使者精神魔杖使用(上下文);
      break;
    case 主动技能物品ID.史诗远古魔刃物品ID:
      处理史诗远古魔刃使用(上下文);
      break;
    case 主动技能物品ID.焰虚宝珠物品ID:
      处理焰虚宝珠使用(上下文);
      break;
    case 主动技能物品ID.先祖之狱杖物品ID:
      处理先祖之狱杖使用(上下文);
      break;
    case 主动技能物品ID.咆哮之心物品ID:
      处理咆哮之心使用(上下文);
      break;
    case 主动技能物品ID.指挥之剑物品ID:
      处理指挥之剑使用(上下文);
      break;
    case 主动技能物品ID.使者魔轮物品ID:
      处理使者魔轮使用(上下文);
      break;
  }
}

export function 初始化物品主动技能核心(this: void): void {
  if (已初始化物品主动技能核心) return;
  已初始化物品主动技能核心 = true;
  注册物品技能事件监听(on物品主动技能生效);
}

export {};
