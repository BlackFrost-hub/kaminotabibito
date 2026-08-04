/** @noSelfInFile */
/**
 * 宝箱掉落配置 - 掉落执行器
 */

import type { ChestTypeConfig, DropMode, 宝箱高级掉落动作, 宝箱高级掉落配置, 宝箱高级掉落等级池候选 } from "./00．常量定义";

const jass = require("jass.common") as any;
const { getChestConfigByString } = require("系统.06．经济系统.00．宝箱系统.00．常量定义") as {
  getChestConfigByString: (this: void, type: string) => ChestTypeConfig | undefined;
};
const { items } = require("系统.02．物品系统.01．装备数据") as {
  items: Record<string, { name?: string; score?: number; level?: string }>;
};
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { 按物品池名随机装备ID } = require("系统.02．物品系统.14．按等级随机装备") as {
  按物品池名随机装备ID: (this: void, 物品池名: string) => string | undefined;
};
const { 广播提示玩家槽数 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义") as {
  广播提示玩家槽数: number;
};
const { 发送头像提示给玩家 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送头像提示给玩家: (this: void, 目标玩家: any, 头像路径: string, 文本: string, 持续时间?: number) => void;
};
const { SFB_setBuff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setBuff: (this: void, sourceUnit: any, u: any, id: number, time: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; 持续秒?: number; 缩放?: number }) => any;
};
const { 装备等级显示文本, 装备名字颜色文本 } = require("系统.00．核心系统.01．颜色常量") as {
  装备等级显示文本: (this: void, _?: undefined, text?: string, level?: string) => string;
  装备名字颜色文本: (this: void, _?: undefined, text?: string, level?: string) => string;
};
const { setLastCreatedItem } = require("系统.02．物品系统.09．装备排泄") as {
  setLastCreatedItem: (this: void, item: any) => void;
};

const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const CreateItem = jass.CreateItem as (itemid: number, x: number, y: number) => any;
const GetWidgetLife = jass.GetWidgetLife as (widget: any) => number;
const SetWidgetLife = jass.SetWidgetLife as (widget: any, newLife: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetPlayerName = jass.GetPlayerName as (whichPlayer: any) => string;
const Player = jass.Player as (playerIndex: number) => any;

const 喇叭路径 = "UI\\xiaoxi\\UInotice.tga";
const 装备系统消息持续毫秒 = 6500;

function stringToFourCC(this: void, s: string): number {
  if (s == null || s.length < 4) return 0;
  const a = s.length > 0 ? s.charCodeAt(0) : 0;
  const b = s.length > 1 ? s.charCodeAt(1) : 0;
  const c = s.length > 2 ? s.charCodeAt(2) : 0;
  const d = s.length > 3 ? s.charCodeAt(3) : 0;
  return a * 16777216 + b * 65536 + c * 256 + d;
}

interface 物品池条目 {
  id: string;
  weight: number;
}

interface 掉落偏移 {
  dx: number;
  dy: number;
}

interface 高级掉落执行上下文 {
  开启者?: any;
  宝箱主人?: any;
  宝箱配置?: ChestTypeConfig;
  x: number;
  y: number;
  指定主随机?: number;
  最近装备物品ID?: string;
  最近装备等级文本?: string;
}

const itemAliasMap = new Map<string, string>();

const DROP_OFFSETS: 掉落偏移[] = [
  { dx: 0, dy: 0 },
  { dx: 18, dy: 0 },
  { dx: -18, dy: 0 },
  { dx: 0, dy: 18 },
  { dx: 0, dy: -18 },
  { dx: 12, dy: 12 },
  { dx: -12, dy: 12 },
  { dx: 12, dy: -12 },
  { dx: -12, dy: -12 },
];

function 标准化物品别名(this: void, name: string): string {
  let result = "";
  for (let i = 0; i < name.length; i++) {
    const ch = name.charAt(i);
    if (ch === "|") {
      const next = name.charAt(i + 1);
      if (next === "r" || next === "R") {
        i = i + 1;
        continue;
      }
      if (next === "c" || next === "C") {
        i = i + 9;
        continue;
      }
    }
    result += ch;
  }
  return result.trim();
}

function 注册物品别名(this: void, alias: string, itemId: string): void {
  const normalized = 标准化物品别名(alias);
  if (!normalized) return;
  if (!itemAliasMap.has(normalized)) {
    itemAliasMap.set(normalized, itemId);
  }
}

for (const [itemId, data] of Object.entries(items)) {
  itemAliasMap.set(itemId, itemId);
  if (data?.name) {
    注册物品别名(data.name, itemId);
  }
}

function 按名字查找物品ID(this: void, name: string): string | undefined {
  const normalized = 标准化物品别名(name);
  for (const [itemId, data] of Object.entries(items)) {
    if (标准化物品别名(data?.name ?? "") === normalized) {
      return itemId;
    }
  }
  return undefined;
}

function 解析掉落物品ID(this: void, token: string): string {
  const trimmed = token.trim();
  if (!trimmed) return trimmed;
  if (trimmed.length === 4 && items[trimmed] != null) {
    return trimmed;
  }
  return resolveItemIdByName(trimmed) ?? itemAliasMap.get(标准化物品别名(trimmed)) ?? 按名字查找物品ID(trimmed) ?? trimmed;
}

function randomReal01(this: void): number {
  return GetRandomReal(0.0, 1.0) || 0.0;
}

function randomInt(this: void, min: number, max: number): number {
  return GetRandomInt(min, max) || min;
}

function 解析物品池(this: void, poolStr: string): 物品池条目[] {
  const entries: 物品池条目[] = [];
  const parts = poolStr.split(";");
  for (const part of parts) {
    const trimmed = part.trim();
    if (!trimmed) continue;
    if (trimmed.includes(":")) {
      const splitParts = trimmed.split(":");
      const id = 解析掉落物品ID(splitParts[0] ?? "");
      const parsedWeight = parseFloat(splitParts[1] ?? "");
      const weight = parsedWeight > 0 ? parsedWeight : 1;
      entries.push({ id, weight });
    } else {
      const id = 解析掉落物品ID(trimmed);
      entries.push({ id, weight: 1 });
    }
  }
  return entries;
}

function 按权重抽取可重复(this: void, pool: 物品池条目[], picks: number): string[] {
  const result: string[] = [];
  let totalWeight = 0;
  for (const entry of pool) {
    totalWeight = totalWeight + entry.weight;
  }
  if (totalWeight <= 0) return result;

  for (let i = 0; i < picks; i++) {
    let r = randomReal01() * totalWeight;
    for (const entry of pool) {
      r = r - entry.weight;
      if (r <= 0) {
        result.push(entry.id);
        break;
      }
    }
  }
  return result;
}

function 按均匀抽取不重复(this: void, pool: 物品池条目[], picks: number): string[] {
  const shuffled = [...pool];
  for (let i = shuffled.length - 1; i >= 1; i--) {
      const j = randomInt(1, i + 1) - 1;
    const t = shuffled[i];
    shuffled[i] = shuffled[j];
    shuffled[j] = t;
  }
  const count = picks < shuffled.length ? picks : shuffled.length;
  return shuffled.slice(0, count).map(entry => entry.id);
}

function 按分数筛选物品(this: void, min: number, max: number): string[] {
  const result: string[] = [];
  const entries = Object.entries(items).sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0));
  for (const [itemId, data] of entries) {
    const score = data?.score;
    if (score == null) continue;
    if (score < min || score > max) continue;
    result.push(itemId);
  }
  return result;
}

function 解析必掉物品(this: void, alwaysStr: string | undefined): string[] {
  if (!alwaysStr) return [];
  const result = alwaysStr
    .split(";")
    .map(s => 解析掉落物品ID(s))
    .filter(itemId => items[itemId] != null);
  return result;
}

function 按掉落模式执行(this: void, dropMode: DropMode, picks: number): string[] {
  const result: string[] = [];

  if ("always" in dropMode && dropMode.always) {
    result.push(...解析必掉物品(dropMode.always));
  }

  switch (dropMode.type) {
    case "pool": {
      const pool = 解析物品池(dropMode.items);
      if (pool.length > 0 && picks > 0) {
        const hasWeight = pool.some(entry => entry.weight !== 1);
        const drawn = hasWeight ? 按权重抽取可重复(pool, picks) : 按均匀抽取不重复(pool, picks);
        result.push(...drawn);
      }
      break;
    }
    case "mixed": {
      let pool = 解析物品池(dropMode.items);
      if (pool.length > 0) {
        pool = pool.filter(entry => {
          const score = items[entry.id]?.score;
          return score != null && score >= dropMode.range.min && score <= dropMode.range.max;
        });
      }
      if (pool.length > 0 && picks > 0) {
        result.push(...按权重抽取可重复(pool, picks));
      }
      break;
    }
    case "score": {
      const itemIds = 按分数筛选物品(dropMode.range.min, dropMode.range.max);
      if (itemIds.length > 0 && picks > 0) {
        const pool = itemIds.map(id => ({ id, weight: 1 }));
        result.push(...按均匀抽取不重复(pool, picks));
      }
      break;
    }
  }

  return result;
}

function 按权重抽取等级池(this: void, 候选等级池: 宝箱高级掉落等级池候选[]): 宝箱高级掉落等级池候选 | undefined {
  let 总权重 = 0;
  for (const 候选 of 候选等级池) {
    总权重 = 总权重 + 候选.权重;
  }
  if (总权重 <= 0) return undefined;

  let r = randomReal01() * 总权重;
  for (const 候选 of 候选等级池) {
    r = r - 候选.权重;
    if (r <= 0) {
      return 候选;
    }
  }
  return 候选等级池[候选等级池.length - 1];
}

function 广播宝箱装备消息(this: void, 动作: { 文本前缀: string }, 上下文: 高级掉落执行上下文): void {
  if (!上下文.开启者 || !上下文.最近装备物品ID || !上下文.最近装备等级文本) {
    return;
  }
  const 装备名 = items[上下文.最近装备物品ID]?.name ?? 上下文.最近装备物品ID;
  const 玩家名 = GetPlayerName(GetOwningPlayer(上下文.开启者));
  const 等级Key = String(上下文.最近装备等级文本 || "").trim();
  const 等级文本 = 装备等级显示文本(undefined, 等级Key, 等级Key);
  const 装备文本 = 装备名字颜色文本(undefined, 装备名, 等级Key);
  const 文本 = `${玩家名}${动作.文本前缀}${等级文本}装备『${装备文本}』`;
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    发送头像提示给玩家(Player(玩家ID), 喇叭路径, 文本, 装备系统消息持续毫秒);
  }
}

function 执行高级掉落动作(this: void, 动作: 宝箱高级掉落动作, 结果: string[], 上下文: 高级掉落执行上下文): void {
  switch (动作.type) {
    case "创建物品": {
      const itemId = 解析掉落物品ID(动作.物品);
      if (items[itemId] != null) {
        结果.push(itemId);
      }
      return;
    }
    case "创建物品二选一": {
      const roll = randomInt(1, 2);
      const itemId = 解析掉落物品ID(roll === 1 ? 动作.物品1 : 动作.物品2);
      if (items[itemId] != null) {
        结果.push(itemId);
      }
      return;
    }
    case "按装备等级随机创建": {
      const 候选等级池 = 按权重抽取等级池(动作.候选等级池);
      if (!候选等级池) return;
      const itemId = 按物品池名随机装备ID(候选等级池.池名);
      if (!itemId || items[itemId] == null) return;
      结果.push(itemId);
      上下文.最近装备物品ID = itemId;
      上下文.最近装备等级文本 = 候选等级池.广播等级文本;
      return;
    }
    case "对开启者施加效果": {
      if (!上下文.开启者) return;
      if (动作.命中特效模型路径 != null) {
        创建点特效({
          模型路径: 动作.命中特效模型路径,
          X: 上下文.x,
          Y: 上下文.y,
          持续秒: 动作.命中特效持续秒,
          缩放: 动作.命中特效缩放,
        });
      }
      if (动作.保留当前生命比例 != null) {
        const 当前生命 = GetWidgetLife(上下文.开启者);
        SetWidgetLife(上下文.开启者, 当前生命 * 动作.保留当前生命比例);
      }
      if (动作.BuffID != null && 动作.Buff持续时间 != null) {
        SFB_setBuff(上下文.开启者, 上下文.开启者, 动作.BuffID, 动作.Buff持续时间);
      }
      if (动作.自定义BuffID != null && 动作.Buff持续时间 != null) {
        registerManualBuff(上下文.开启者, 动作.自定义BuffID, 动作.Buff持续时间, 1, {
          sourceName: 动作.自定义Buff来源名称,
        });
      }
      return;
    }
    case "发送广播提示": {
      广播宝箱装备消息(动作, 上下文);
      return;
    }
  }
}

function 执行高级掉落(this: void, config: ChestTypeConfig, 上下文: 高级掉落执行上下文): string[] {
  const 高级掉落 = config.高级掉落;
  if (!高级掉落) return [];
  const roll = 上下文.指定主随机 != null ? 上下文.指定主随机 : randomInt(1, 100);

  for (const 掉落段 of 高级掉落.随机段) {
    if (roll < 掉落段.最小值 || roll > 掉落段.最大值) continue;
    const result: string[] = [];
    for (const 动作 of 掉落段.动作) {
      执行高级掉落动作(动作, result, 上下文);
    }
    return result;
  }

  return [];
}

export function 执行宝箱掉落(config: ChestTypeConfig, opener?: any, ownerUnit?: any, 指定主随机?: number, x: number = 0, y: number = 0): string[] {
  if (config.高级掉落) {
    return 执行高级掉落(config, {
      开启者: opener,
      宝箱主人: ownerUnit,
      宝箱配置: config,
      x,
      y,
      指定主随机,
    });
  }
  if (config.dropMode == null) return [];
  return 按掉落模式执行(config.dropMode, config.picks ?? 0);
}

export function 按可破坏物掉落(destructableType: string, opener?: any, ownerUnit?: any, 指定主随机?: number, x: number = 0, y: number = 0): string[] {
  const config = getChestConfigByString(destructableType);
  if (!config) {
    return [];
  }
  return 执行宝箱掉落(config, opener, ownerUnit, 指定主随机, x, y);
}

export function 按宝箱配置掉落(config: ChestTypeConfig, opener?: any, ownerUnit?: any, 指定主随机?: number, x: number = 0, y: number = 0): string[] {
  return 执行宝箱掉落(config, opener, ownerUnit, 指定主随机, x, y);
}

export function 创建掉落物品(itemId: string, x: number, y: number): any {
  if (!items[itemId]) {
  }
  const item = CreateItem(stringToFourCC(itemId), x, y);

  if (item) {
    setLastCreatedItem(item);
  }

  return item;
}

function 获取掉落偏移(this: void, index: number): 掉落偏移 {
  return DROP_OFFSETS[index % DROP_OFFSETS.length] ?? DROP_OFFSETS[0];
}

export function 宝箱位置掉落(destructableType: string, x: number, y: number, opener?: any, ownerUnit?: any, 指定主随机?: number): any[] {
  const itemIds = 按可破坏物掉落(destructableType, opener, ownerUnit, 指定主随机, x, y);
  const createdItems: any[] = [];
  for (let i = 0; i < itemIds.length; i++) {
    const offset = 获取掉落偏移(i);
    const item = 创建掉落物品(itemIds[i], x + offset.dx, y + offset.dy);
    if (item) createdItems.push(item);
  }
  return createdItems;
}

export function 宝箱配置掉落(config: ChestTypeConfig, x: number, y: number, opener?: any, ownerUnit?: any, 指定主随机?: number): any[] {
  const itemIds = 按宝箱配置掉落(config, opener, ownerUnit, 指定主随机, x, y);
  const createdItems: any[] = [];
  for (let i = 0; i < itemIds.length; i++) {
    const offset = 获取掉落偏移(i);
    const item = 创建掉落物品(itemIds[i], x + offset.dx, y + offset.dy);
    if (item) createdItems.push(item);
  }
  return createdItems;
}

export {
  执行宝箱掉落 as executeChestDrop,
  按可破坏物掉落 as dropItemsByDestructable,
  按宝箱配置掉落 as dropItemsByChestConfig,
  创建掉落物品 as createDropItem,
  宝箱位置掉落 as dropItemsFromChest,
  宝箱配置掉落 as dropItemsFromChestConfig,
};
