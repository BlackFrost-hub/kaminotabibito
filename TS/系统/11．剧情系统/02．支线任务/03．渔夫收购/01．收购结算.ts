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

// 注意：不要 require「09．表现系统/02．对话框系统/03．任务状态」——它反向依赖 02．任务配置表，
// 而本模块是被 00．支线交互配置（任务配置表的依赖）加载的，会形成加载环，导致整张任务配置表加载失败。
// 这里只用两个叶子模块：任务数据（questDB）+ 任务管理器（questManager）。
const { questDB } = require("系统.08．任务系统.01．任务数据") as {
  questDB: any;
};
const { questManager } = require("系统.08．任务系统.02．任务管理器") as {
  questManager: any;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const { 玩家主副背包持有物品 } = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包") as {
  玩家主副背包持有物品: (this: void, hero: any, itemTypeID: number) => boolean;
};
const { GetItemTypeTotalCountByChargesBJ, ConsumeItemTypeCountByChargesBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  GetItemTypeTotalCountByChargesBJ: (this: void, whichUnit: any, itemTypeId: number) => number;
  ConsumeItemTypeCountByChargesBJ: (this: void, whichUnit: any, itemId: number, needCount: number) => boolean;
};
const { 创建物品并给予单位, 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并给予单位: (this: void, unit: any, itemId: number) => any;
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { AddGoldWithFeedback } = require("lib.扩展函数.封装函数.01．通用工具.05．玩家工具") as {
  // 定义侧 05．玩家工具.ts 无 @noSelfInFile（生成 (self, params)）：断言不带 this，让 TSTL 补 nil self。
  AddGoldWithFeedback: (params: { delta: number; player?: any; unit?: any }) => void;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};

import { getPlayerFirstHero } from "../../../09．表现系统/02．对话框系统/08．任务奖励执行";

import { 渔夫订单表, 熔岩鱼物品ID列表, 渔夫拒绝对白, 渔夫开场对白, 渔夫收购任务ID, type 渔夫订单 } from "./00．订单配置表";

const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
// BJ 包装在 lib.扩展函数.BJ函数（1 基槽位，内部转 jass.UnitItemInSlot）；
// jass 表上并没有 UnitItemInSlotBJ，直接取会得到 nil。
const { UnitItemInSlotBJ } = require("lib.扩展函数.BJ函数.index") as {
  UnitItemInSlotBJ: (this: void, whichUnit: any, itemSlot: number) => any;
};
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

/** 取英雄的副背包马甲单位（与 Ctrl 切包同一份数据）。 */
function 取副背包马甲(this: void, 英雄: any): any {
  const 玩家 = GetOwningPlayer(英雄);
  if (玩家 == null || 玩家 === 0) return null;
  const 马甲 = YDUserDataGetSafe("player", 玩家, "切换背包辅助", "unit");
  if (马甲 == null || 马甲 === 0 || 马甲 === 英雄) return null;
  return 马甲;
}

/** 统计主背包 + 副背包马甲的空闲格数。 */
function 统计空闲格数(this: void, 英雄: any): number {
  let 空闲 = 0;
  for (let slot = 1; slot <= 6; slot++) {
    const 主 = UnitItemInSlotBJ(英雄, slot);
    if (主 == null || 主 === 0) 空闲 += 1;
  }
  const 马甲 = 取副背包马甲(英雄);
  if (马甲 != null) {
    for (let slot = 1; slot <= 6; slot++) {
      const 副 = UnitItemInSlotBJ(马甲, slot);
      if (副 == null || 副 === 0) 空闲 += 1;
    }
  }
  return 空闲;
}

/**
 * 背包感知的装备发放：
 *   1. 先塞英雄主背包（原生 6 格，触发拾取结算）；
 *   2. 放不下 → 塞副背包马甲（Ctrl 可切到的那 6 格）；
 *   3. 都满 → 掉在英雄脚下。绝不让奖励静默销毁。
 * （原生 UnitAddItem 只写英雄 6 格——这就是此前"有格却发不出"的原因。）
 */
function 发放装备到背包(this: void, 玩家ID: number, 英雄: any, 装备类型ID: number): void {
  const 物品 = 创建物品并给予单位(英雄, 装备类型ID);
  if (物品 != null && 物品 !== 0) return;

  const 马甲 = 取副背包马甲(英雄);
  if (马甲 != null) {
    const 副物品 = 创建物品并给予单位(马甲, 装备类型ID);
    if (副物品 != null && 副物品 !== 0) {
      渔夫说话(玩家ID, "主包满了，东西塞你副包了——Ctrl 切换看看。");
      return;
    }
  }

  创建物品并注册排泄监听(装备类型ID, GetUnitX(英雄), GetUnitY(英雄));
  渔夫说话(玩家ID, "背包全满了。东西放你脚边了，自己捡。");
}

function 发奖(this: void, 玩家ID: number, 英雄: any, 订单: 渔夫订单): void {
  if (订单.金币 > 0) {
    AddGoldWithFeedback({ delta: 订单.金币, player: Player(玩家ID) });
  }
  if (订单.装备ID != null && 订单.装备ID !== "") {
    const 装备类型ID = 解析配置内部ID(订单.装备ID);
    if (装备类型ID !== 0) {
      发放装备到背包(玩家ID, 英雄, 装备类型ID);
    }
  }
}

/** 成功提交目标次数：满 15 次任务才算真正完成。 */
export const 渔获收购目标次数 = 15;

/** 成功提交计数（与任务状态一致，全队共享，一局内有效）。 */
let 成功提交次数 = 0;

/**
 * 任务「完成后动作」。签名与项目既有回调一致（编译为 (quest, 玩家ID) 双参调用）。
 */
export function 渔夫收购结算(this: void, 玩家ID: number): void {
  // 提交流程在此前已把任务置为完成态（setQuestState 2）。这里按结果改写状态：
  //   未满 15 次 → 拉回「已接取」(1)，玩家可继续提交；
  //   满 15 次   → 保持完成态 (2)，之后点击进入完成对话。
  const 收尾 = (): void => {
    if (成功提交次数 >= 渔获收购目标次数) return;
    // 拉回「已接取」：acceptQuest 遇到完成态会拒接，所以先清掉完成标记。
    const 任务键 = String(渔夫收购任务ID);
    const globalData = (questDB as any).globalData;
    if (globalData != null && globalData.completedQuests != null) globalData.completedQuests.delete(任务键);
    questManager.onQuestAccepted(玩家ID, 任务键);
  };

  const 玩家 = Player(玩家ID);
  if (玩家 == null || 玩家 === 0) return;

  const 英雄 = getPlayerFirstHero(玩家);
  if (英雄 == null || 英雄 === 0) return;
  if (IsUnitType(英雄, UNIT_TYPE_DEAD)) return;

  渔夫说话(玩家ID, 渔夫开场对白);

  // 前置：主/副背包一格都没有时，拒绝收鱼（不消耗、不计数），否则奖励会无处安放。
  if (统计空闲格数(英雄) <= 0) {
    渔夫说话(玩家ID, "你背包塞得死死的。先腾出一格，再来把鱼给我。");
    收尾();
    return;
  }

  for (let i = 0; i < 渔夫订单表.length; i++) {
    const 订单 = 渔夫订单表[i];
    if (!满足订单(英雄, 订单)) continue;

    消耗指定需求(英雄, 订单);
    消耗任意需求(英雄, 订单);
    发奖(玩家ID, 英雄, 订单);
    成功提交次数 += 1;
    渔夫说话(玩家ID, 订单.提交对白);
    if (成功提交次数 >= 渔获收购目标次数) {
      渔夫说话(玩家ID, "……十五次了。你这双手，比我的还懂这片水。\\n渔民：行了，以后不用再给我送鱼了——拿着这些，该干嘛干嘛去。");
    }
    收尾();
    return;
  }

  // 一条都凑不齐：保持已接取态，随时可以再交。
  const 拒绝 = 渔夫拒绝对白[GetRandomInt(1, 渔夫拒绝对白.length) - 1];
  渔夫说话(玩家ID, 拒绝);
  收尾();
}

export {};
