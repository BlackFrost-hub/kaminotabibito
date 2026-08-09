/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 注册聊天命令监听, 注册聊天命令前缀监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
  注册聊天命令前缀监听: (this: void, 前缀: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

interface 物品数据 {
  name?: string;
  type?: string;
  score?: number;
  [key: string]: string | number | boolean | undefined;
}

const 装备数据模块 = require("系统.02．物品系统.01．装备数据") as {
  default?: Record<string, 物品数据>;
  items?: Record<string, 物品数据>;
};
const 装备数据: Record<string, 物品数据> = 装备数据模块.default ?? 装备数据模块.items ?? {};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  text: string,
) => void;

const 模块名 = "物品评分测试";
const 物品评分命令前缀 = "物品+";
const 物品内部ID命令前缀 = "WP";
const 随机6000分装备命令 = "djcs";
const 默认随机目标评分 = 6000;
const 评分浮动范围 = 500;
const 批量创建数量 = 10;
const 装备类型表: Record<string, boolean> = {
  "主武器": true,
  "副武器": true,
  "双手武器": true,
  "衣服": true,
  "裤子": true,
  "头盔": true,
  "鞋子": true,
  "灵魂": true,
  "道具/戒指/饰品": true,
};
const 批量创建偏移: readonly [number, number][] = [
  [-144, -48],
  [-48, -48],
  [48, -48],
  [144, -48],
  [-96, 48],
  [0, 48],
  [96, 48],
  [-96, 144],
  [0, 144],
  [96, 144],
];

function 是有效句柄(this: void, value: any): boolean {
  return value != null && value !== 0;
}

function 是装备类型(this: void, type: string | undefined): boolean {
  return type != null && 装备类型表[type] === true;
}

function 按评分筛选装备(this: void, 最低评分: number, 最高评分: number): string[] {
  const result: string[] = [];
  for (const itemId in 装备数据) {
    if (itemId.length !== 4) continue;
    const data = 装备数据[itemId];
    if (data == null || !是装备类型(data.type)) continue;
    if (typeof data.score !== "number") continue;
    if (data.score < 最低评分 || data.score > 最高评分) continue;
    result.push(itemId);
  }
  result.sort();
  return result;
}

function 随机取物品(this: void, 候选物品: string[]): string | undefined {
  if (候选物品.length <= 0) return undefined;
  const index = GetRandomInt(1, 候选物品.length) - 1;
  return 候选物品[index];
}

function 解析目标评分(this: void, command: string): number | undefined {
  if (command.substring(0, 物品评分命令前缀.length) !== 物品评分命令前缀) return undefined;
  const text = command.substring(物品评分命令前缀.length).trim();
  if (text === "") return undefined;
  const score = Number(text);
  if (score !== score || score <= 0) return undefined;
  return score;
}

function 解析物品内部ID(this: void, command: string): string | undefined {
  if (command.substring(0, 物品内部ID命令前缀.length) !== 物品内部ID命令前缀) return undefined;
  const itemId = command.substring(物品内部ID命令前缀.length);
  return itemId.length === 4 ? itemId : undefined;
}

function 创建物品(this: void, itemId: string, x: number, y: number): boolean {
  const itemTypeId = stringToFourCCSafe(itemId);
  if (itemTypeId === 0) return false;
  const item = 创建物品并注册排泄监听(itemTypeId, x, y);
  return 是有效句柄(item);
}

function 获取测试英雄(this: void, player: any): any {
  const hero = getRegisteredPlayerHero(player);
  if (是有效句柄(hero)) return hero;
  return null;
}

function 发送失败提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 6, "[物品测试] " + text);
  debugLogForce(模块名, text);
}

function 创建单件评分装备(this: void, player: any, 目标评分: number): void {
  const hero = 获取测试英雄(player);
  if (!是有效句柄(hero)) {
    发送失败提示(player, "未找到该玩家的注册英雄。");
    return;
  }

  const 候选物品 = 按评分筛选装备(目标评分 - 评分浮动范围, 目标评分 + 评分浮动范围);
  const itemId = 随机取物品(候选物品);
  if (itemId == null) {
    发送失败提示(player, "评分 " + 目标评分 + " 附近没有可创建的装备。");
    return;
  }

  const created = 创建物品(itemId, GetUnitX(hero), GetUnitY(hero));
  const data = 装备数据[itemId];
  if (!created) {
    发送失败提示(player, "创建装备失败：" + itemId + "。");
    return;
  }

  const name = data?.name ?? itemId;
  const score = data?.score ?? 0;
  DisplayTimedTextToPlayer(player, 0, 0, 6, "[物品测试] 已创建 " + name + "，评分 " + score + "（目标 " + 目标评分 + "+/-" + 评分浮动范围 + "）。");
  debugLogForce(模块名, "创建单件装备", "itemId", itemId, "name", name, "score", score, "target", 目标评分);
}

function 创建十件随机评分装备(this: void, player: any): void {
  const hero = 获取测试英雄(player);
  if (!是有效句柄(hero)) {
    发送失败提示(player, "未找到该玩家的注册英雄。");
    return;
  }

  const 候选物品 = 按评分筛选装备(默认随机目标评分 - 评分浮动范围, 默认随机目标评分 + 评分浮动范围);
  if (候选物品.length <= 0) {
    发送失败提示(player, "评分 " + 默认随机目标评分 + " 附近没有可创建的装备。");
    return;
  }

  const heroX = GetUnitX(hero);
  const heroY = GetUnitY(hero);
  let createdCount = 0;
  let createdNames = "";
  const pool = 候选物品.slice();
  for (let i = 0; i < 批量创建数量; i++) {
    const source = pool.length > 0 ? pool : 候选物品;
    const sourceIndex = GetRandomInt(1, source.length) - 1;
    const itemId = source[sourceIndex];
    if (pool.length > 0) pool.splice(sourceIndex, 1);
    const offset = 批量创建偏移[i];
    if (!创建物品(itemId, heroX + offset[0], heroY + offset[1])) continue;

    createdCount++;
    const data = 装备数据[itemId];
    const name = data?.name ?? itemId;
    if (createdNames !== "") createdNames = createdNames + "、";
    createdNames = createdNames + name + "（" + (data?.score ?? 0) + "）";
  }

  DisplayTimedTextToPlayer(player, 0, 0, 10, "[物品测试] djcs 已创建 " + createdCount + "/" + 批量创建数量 + " 件 6000+/-" + 评分浮动范围 + " 装备：" + createdNames);
  debugLogForce(模块名, "批量创建装备", "count", createdCount, "target", 默认随机目标评分, "range", 评分浮动范围);
}

function on物品评分命令(this: void, player: any, command: string): void {
  if (!是允许测试玩家(player)) return;
  const 目标评分 = 解析目标评分(command);
  if (目标评分 == null) {
    发送失败提示(player, "命令格式：物品+评分，例如 物品+6000。");
    return;
  }
  创建单件评分装备(player, 目标评分);
}

function on随机6000分装备命令(this: void, player: any, _command: string): void {
  if (!是允许测试玩家(player)) return;
  创建十件随机评分装备(player);
}

function on物品内部ID命令(this: void, player: any, command: string): void {
  if (!是允许测试玩家(player)) return;

  const itemId = 解析物品内部ID(command);
  if (itemId == null) {
    发送失败提示(player, "命令格式：WP加4位物品内部ID，例如 WPe0XX。");
    return;
  }

  const hero = 获取测试英雄(player);
  if (!是有效句柄(hero)) {
    发送失败提示(player, "未找到该玩家的注册英雄。");
    return;
  }

  if (!创建物品(itemId, GetUnitX(hero), GetUnitY(hero))) {
    发送失败提示(player, "创建物品失败：" + itemId + "。");
    return;
  }

  DisplayTimedTextToPlayer(player, 0, 0, 6, "[物品测试] 已在注册英雄脚下创建物品 " + itemId + "。");
  debugLogForce(模块名, "按内部ID创建物品", "itemId", itemId);
}

注册聊天命令前缀监听(物品评分命令前缀, on物品评分命令);
注册聊天命令前缀监听(物品内部ID命令前缀, on物品内部ID命令);
注册聊天命令监听(随机6000分装备命令, on随机6000分装备命令);

export {};
