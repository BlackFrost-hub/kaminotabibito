/** @noSelfInFile */

const jass = require("jass.common") as any;

import { 首领奖励池配置 } from "./00．类型定义";
import { 查找首领奖励池 } from "./01．奖励配置表";
import { 是否已领取首领奖励 } from "./02．领取状态";
import { 领取首领奖励选择 } from "./03．奖励发放";
import { 发放首领奖励装备 } from "./08．奖励物品发放";

export interface 首领奖励待选择记录 {
  奖励池ID: string;
  玩家ID: number;
  玩家: any;
}

export interface 首领奖励自动发放结果 {
  已处理: boolean;
  奖励池ID: string;
  装备名列表: string[];
  成功数量: number;
  失败原因: string;
}

const 待选择记录表: Record<number, 首领奖励待选择记录 | undefined> = {};

const GetPlayerId = jass.GetPlayerId as (玩家: any) => number;
const GetRandomInt = jass.GetRandomInt as (最小值: number, 最大值: number) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (玩家: any, x: number, y: number, 持续时间: number, 文本: string) => void;

function 提示玩家(this: void, 玩家: any, 文本: string): void {
  if (玩家 == null || 玩家 === 0) return;
  DisplayTimedTextToPlayer(玩家, 0, 0, 8, "|cffffcc00[首领奖励]|r " + 文本);
}

function 获取玩家ID(this: void, 玩家: any): number {
  if (玩家 == null || 玩家 === 0) return -1;
  return GetPlayerId(玩家);
}

function 随机取出奖励装备名(this: void, 奖励池: 首领奖励池配置): string[] {
  const 候选: string[] = [];
  for (let 序号 = 0; 序号 < 奖励池.选项.length; 序号++) {
    候选.push(奖励池.选项[序号].装备名);
  }

  const 结果: string[] = [];
  const 需要数量 = 奖励池.可选数量;
  for (let 次数 = 0; 次数 < 需要数量 && 候选.length > 0; 次数++) {
    const 索引 = GetRandomInt(1, 候选.length) - 1;
    结果.push(候选[索引]);
    候选.splice(索引, 1);
  }
  return 结果;
}

export function 记录首领奖励待选择(this: void, 奖励池ID: string, 玩家: any): void {
  const 玩家ID = 获取玩家ID(玩家);
  if (玩家ID < 0) return;
  if (是否已领取首领奖励(奖励池ID, 玩家ID)) {
    delete 待选择记录表[玩家ID];
    return;
  }
  待选择记录表[玩家ID] = { 奖励池ID, 玩家ID, 玩家 };
}

export function 清除首领奖励待选择(this: void, 奖励池ID: string, 玩家ID: number): void {
  const 记录 = 待选择记录表[玩家ID];
  if (记录 == null || 记录.奖励池ID !== 奖励池ID) return;
  delete 待选择记录表[玩家ID];
}

export function 获取首领奖励待选择记录(this: void, 玩家: any): 首领奖励待选择记录 | null {
  const 玩家ID = 获取玩家ID(玩家);
  if (玩家ID < 0) return null;
  const 记录 = 待选择记录表[玩家ID];
  if (记录 == null) return null;
  if (是否已领取首领奖励(记录.奖励池ID, 玩家ID)) {
    delete 待选择记录表[玩家ID];
    return null;
  }
  记录.玩家 = 玩家;
  return 记录;
}

export function 自动随机发放首领奖励待选择(
  this: void,
  玩家: any,
  原因文本: string
): 首领奖励自动发放结果 {
  const 记录 = 获取首领奖励待选择记录(玩家);
  if (记录 == null) {
    return { 已处理: false, 奖励池ID: "", 装备名列表: [], 成功数量: 0, 失败原因: "" };
  }

  const 奖励池 = 查找首领奖励池(记录.奖励池ID);
  if (奖励池 == null) {
    delete 待选择记录表[记录.玩家ID];
    return { 已处理: true, 奖励池ID: 记录.奖励池ID, 装备名列表: [], 成功数量: 0, 失败原因: "奖励池不存在" };
  }

  const 装备名列表 = 随机取出奖励装备名(奖励池);
  const 发放结果 = 领取首领奖励选择(记录.奖励池ID, 记录.玩家ID, 装备名列表);
  if (发放结果 !== "成功") {
    delete 待选择记录表[记录.玩家ID];
    return { 已处理: true, 奖励池ID: 记录.奖励池ID, 装备名列表, 成功数量: 0, 失败原因: 发放结果 };
  }

  let 成功数量 = 0;
  for (let 序号 = 0; 序号 < 装备名列表.length; 序号++) {
    if (发放首领奖励装备(玩家, 装备名列表[序号])) 成功数量++;
  }
  delete 待选择记录表[记录.玩家ID];
  提示玩家(玩家, 原因文本 + "，已自动随机领取：" + 装备名列表.join("、"));
  return { 已处理: true, 奖励池ID: 记录.奖励池ID, 装备名列表, 成功数量, 失败原因: "" };
}

export function 自动随机发放旧待选择首领奖励(this: void, 玩家: any, 新奖励池ID: string): void {
  const 记录 = 获取首领奖励待选择记录(玩家);
  if (记录 == null || 记录.奖励池ID === 新奖励池ID) return;
  自动随机发放首领奖励待选择(玩家, "新的首领奖励已出现，上一份奖励尚未选择");
}

