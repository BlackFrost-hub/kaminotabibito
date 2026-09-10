/** @noSelfInFile */
/**
 * 默洛克渔夫 · 渔获收购结算
 *
 * 挂在任务的「完成后动作」上。任务本身**不写需求物品**，所以玩家点提交必定进入这里，
 * 由本模块自己判断背包里凑得出哪一档订单：
 *   1. 按 订单表 顺序（苛刻→宽松）找第一个完全满足的
 *   2. 命中 → 扣鱼 + 给金币 + 给装备 + 渔夫开口
 *   3. 都不满足 → 渔夫拒绝
 * 这样"奖励是什么"完全不由任务界面公示，玩家只能从渔夫的话里猜。
 */

const jass = require("jass.common") as any;

const { 玩家主副背包持有物品 } = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包") as {
  玩家主副背包持有物品: (this: void, hero: any, itemTypeID: number) => boolean;
};
const { GetItemTypeTotalCountByChargesBJ, ConsumeItemTypeCountByChargesBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  GetItemTypeTotalCountByChargesBJ: (this: void, whichUnit: any, itemTypeId: number) => number;
  ConsumeItemTypeCountByChargesBJ: (this: void, whichUnit: any, itemId: number, needCount: number) => boolean;
};
const { 创建物品并给予单位 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并给予单位: (this: void, unit: any, itemId: number) => any;
};
const { AddGoldWithFeedback } = require("lib.扩展函数.封装函数.01．通用工具.05．玩家工具") as {
  AddGoldWithFeedback: (this: void, params: { delta: number; player?: any; unit?: any }) => void;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};

import { getPlayerFirstHero } from "../../../09．表现系统/02．对话框系统/08．任务奖励执行";

import { 渔夫订单表, 熔岩鱼物品ID列表, 渔夫拒绝对白, 渔夫开场对白, type 渔夫订单 } from "./00．订单配置表";

const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichType: any) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

/** 以渔夫的口吻说话。 */
function 渔夫说话(this: void, 玩家ID: number, 文本: string): void {
  jass.DisplayTimedTextToPlayer(Player(玩家ID), 0, 0, 8, "|cFFFFFF00『默洛克渔夫』：|r" + 文本);
}

function 数量(this: void, 英雄: any, 物品ID: string): number {
  const 类型ID = 解析配置内部ID(物品ID);
  if (类型ID === 0) return 0;
  return GetItemTypeTotalCountByChargesBJ(英雄, 类型ID);
}

/** 指定需求是否全部满足。 */
function 满足指定需求(this: void, 英雄: any, 订单: 渔夫订单): boolean {
  const 需求列表 = 订单.指定需求;
  if (需求列表 == null) return true;
  for (let i = 0; i < 需求列表.length; i++) {
    if (数量(英雄, 需求列表[i].物品ID) < 需求列表[i].数量) return false;
  }
  return true;
}

/** 任意熔岩鱼总数是否够。 */
function 满足任意需求(this: void, 英雄: any, 订单: 渔夫订单): boolean {
  const 需要 = 订单.任意数量 ?? 0;
  if (需要 <= 0) return true;
  let 合计 = 0;
  for (let i = 0; i < 熔岩鱼物品ID列表.length; i++) {
    合计 += 数量(英雄, 熔岩鱼物品ID列表[i]);
  }
  return 合计 >= 需要;
}

function 满足订单(this: void, 英雄: any, 订单: 渔夫订单): boolean {
  return 满足指定需求(英雄, 订单) && 满足任意需求(英雄, 订单);
}

/** 扣掉指定需求。 */
function 消耗指定需求(this: void, 英雄: any, 订单: 渔夫订单): void {
  const 需求列表 = 订单.指定需求;
  if (需求列表 == null) return;
  for (let i = 0; i < 需求列表.length; i++) {
    ConsumeItemTypeCountByChargesBJ(英雄, 解析配置内部ID(需求列表[i].物品ID), 需求列表[i].数量);
  }
}

/** 从任意熔岩鱼里凑数扣，按种类依次扣够为止。 */
function 消耗任意需求(this: void, 英雄: any, 订单: 渔夫订单): void {
  let 还差 = 订单.任意数量 ?? 0;
  if (还差 <= 0) return;
  for (let i = 0; i < 熔岩鱼物品ID列表.length && 还差 > 0; i++) {
    const 物品ID = 熔岩鱼物品ID列表[i];
    const 持有 = 数量(英雄, 物品ID);
    if (持有 <= 0) continue;
    const 扣 = 持有 < 还差 ? 持有 : 还差;
    ConsumeItemTypeCountByChargesBJ(英雄, 解析配置内部ID(物品ID), 扣);
    还差 -= 扣;
  }
}

function 发奖(this: void, 玩家ID: number, 英雄: any, 订单: 渔夫订单): void {
  if (订单.金币 > 0) {
    AddGoldWithFeedback({ delta: 订单.金币, player: Player(玩家ID) });
  }
  if (订单.装备ID != null && 订单.装备ID !== "") {
    const 装备类型ID = 解析配置内部ID(订单.装备ID);
    if (装备类型ID !== 0) 创建物品并给予单位(英雄, 装备类型ID);
  }
}

/**
 * 任务「完成后动作」。签名与项目既有回调一致（编译为 (quest, 玩家ID) 双参调用）。
 */
export function 渔夫收购结算(this: void, 玩家ID: number): void {
  const 玩家 = Player(玩家ID);
  if (玩家 == null || 玩家 === 0) return;

  const 英雄 = getPlayerFirstHero(玩家);
  if (英雄 == null || 英雄 === 0) return;
  if (IsUnitType(英雄, UNIT_TYPE_DEAD)) return;

  渔夫说话(玩家ID, 渔夫开场对白);

  for (let i = 0; i < 渔夫订单表.length; i++) {
    const 订单 = 渔夫订单表[i];
    if (!满足订单(英雄, 订单)) continue;

    消耗指定需求(英雄, 订单);
    消耗任意需求(英雄, 订单);
    发奖(玩家ID, 英雄, 订单);
    渔夫说话(玩家ID, 订单.提交对白);
    return;
  }

  // 一条都凑不齐
  const 拒绝 = 渔夫拒绝对白[GetRandomInt(1, 渔夫拒绝对白.length) - 1];
  渔夫说话(玩家ID, 拒绝);
}

export {};
