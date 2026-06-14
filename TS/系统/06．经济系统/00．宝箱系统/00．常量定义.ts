/** @noSelfInFile */
/**
 * 宝箱系统 - 常量定义
 */

function stringToFourCC(this: void, s: string): number {
  const a = s.length > 0 ? s.charCodeAt(0) : 0;
  const b = s.length > 1 ? s.charCodeAt(1) : 0;
  const c = s.length > 2 ? s.charCodeAt(2) : 0;
  const d = s.length > 3 ? s.charCodeAt(3) : 0;
  return a * 16777216 + b * 65536 + c * 256 + d;
}

export interface ScoreRange {
  min: number;
  max: number;
}

export type DropMode =
  | { type: "score"; range: ScoreRange; always?: string }
  | { type: "pool"; items: string; always?: string }
  | { type: "mixed"; range: ScoreRange; items: string; always?: string };

export interface ChestOwnerConfig {
  单位类型: string;
  准备开启搜索半径: number;
  开启完成搜索半径: number;
}

export interface 宝箱高级掉落等级池候选 {
  池名: string;
  权重: number;
  广播等级文本: string;
}

export type 宝箱高级掉落动作 =
  | { type: "创建物品"; 物品: string }
  | { type: "创建物品二选一"; 物品1: string; 物品2: string }
  | { type: "按装备等级随机创建"; 候选等级池: 宝箱高级掉落等级池候选[] }
  | { type: "对开启者施加效果"; 保留当前生命比例?: number; BuffID?: number; Buff持续时间?: number }
  | { type: "发送广播提示"; 文本前缀: string };

export interface 宝箱高级掉落段 {
  最小值: number;
  最大值: number;
  动作: 宝箱高级掉落动作[];
}

export interface 宝箱高级掉落配置 {
  随机段: 宝箱高级掉落段[];
}

export type 宝箱首领奖励打开范围 = "开启者" | "所有玩家英雄";

export interface ChestTypeConfig {
  destructableType: string;
  openTime: number;
  name: string;
  picks?: number;
  dropMode?: DropMode;
  /** 配置后，宝箱开启完成不直接掉装备，而是打开首领奖励选择 UI。 */
  首领奖励池ID?: string;
  /** 默认只给开启者打开；Boss 死亡奖励宝箱可配置成所有玩家英雄。 */
  首领奖励打开范围?: 宝箱首领奖励打开范围;
  主人配置?: ChestOwnerConfig;
  高级掉落?: 宝箱高级掉落配置;
}

export const 宝箱系统开关 = true;

export const CHEST_TYPES: ChestTypeConfig[] = [
  {
    destructableType: "LTbr",
    openTime: 3.0,
    name: "盗贼宝箱",
    picks: 1,
    dropMode: { type: "score", range: { min: 100, max: 500 } },
    主人配置: { 单位类型: "hfoo", 准备开启搜索半径: 3000, 开启完成搜索半径: 2500 },//这里单位类型测试用，改成步兵
    高级掉落: { 随机段: [
      { 最小值: 1, 最大值: 30, 动作: [{ type: "创建物品", 物品: "火把" }, { type: "创建物品二选一", 物品1: "盗贼神符（护甲）", 物品2: "盗贼神符（魔抗）" }] },
      { 最小值: 31, 最大值: 55, 动作: [{ type: "创建物品", 物品: "金币" }] },
      { 最小值: 56, 最大值: 80, 动作: [{ type: "按装备等级随机创建", 候选等级池: [{ 池名: "D+级物品池", 权重: 330, 广播等级文本: "D+级" }, { 池名: "D++级物品池", 权重: 220, 广播等级文本: "D++级" }, { 池名: "C-级物品池", 权重: 105, 广播等级文本: "C-级" }, { 池名: "C级物品池", 权重: 88, 广播等级文本: "C级" }, { 池名: "C+级物品池", 权重: 87, 广播等级文本: "C+级" }, { 池名: "C++级物品池", 权重: 70, 广播等级文本: "C++级" }, { 池名: "B-级物品", 权重: 100, 广播等级文本: "B-级" }] }, { type: "发送广播提示", 文本前缀: "通过盗贼宝箱开到了" }] },
      { 最小值: 81, 最大值: 90, 动作: [{ type: "创建物品", 物品: "帝国货币" }] },
      { 最小值: 91, 最大值: 100, 动作: [{ type: "对开启者施加效果", 保留当前生命比例: 0.3, BuffID: 0, Buff持续时间: 1.5 }] },
    ] },
  },
  { destructableType: "B003", openTime: 3.0, name: "普通宝箱", picks: 1, dropMode: { type: "score", range: { min: 100, max: 500 } } },
  { destructableType: "BR01", openTime: 3.0, name: "首领奖励宝箱" },
  { destructableType: "LTbx", openTime: 3.0, name: "木桶", picks: 1, dropMode: { type: "pool", items: "初心戒指:1.5;初始生命药水:1;初始魔法药水:2", always: "精灵铁剑" } },
];

const _chestTypeIds = new Set<number>();
for (const config of CHEST_TYPES) {
  _chestTypeIds.add(stringToFourCC(config.destructableType));
}

const _chestConfigMap = new Map<number, ChestTypeConfig>();
for (const config of CHEST_TYPES) {
  _chestConfigMap.set(stringToFourCC(config.destructableType), config);
}

export function isChestType(this: void, destructableTypeId: number): boolean {
  return _chestTypeIds.has(destructableTypeId);
}

export function getChestConfig(this: void, destructableTypeId: number): ChestTypeConfig | undefined {
  return _chestConfigMap.get(destructableTypeId);
}

export function getChestConfigByString(this: void, destructableType: string): ChestTypeConfig | undefined {
  return _chestConfigMap.get(stringToFourCC(destructableType));
}

export const DEFAULT_OPEN_TIME = 3.0;
export const INTERACT_RANGE = 150.0;
export const UPDATE_INTERVAL = 0.05;
export const PROGRESS_BAR_SCALE = 3.0;
export const PROGRESS_BAR_HEIGHT_OFFSET = 233.0;

export const YDLOCAL_VAR_OPENER = "开启者";
export const YDLOCAL_VAR_CHEST = "被开启的宝箱";
export const YDLOCAL_VAR_PRE_OPENER = "预开启者";
export const YDLOCAL_VAR_PRE_CHEST = "被预开启的宝箱";

export const TEXT_OPENING = (name: string) => `正在开启${name}...`;
export const TEXT_SUCCESS = (name: string) => `${name}已开启！`;
export const TEXT_INTERRUPTED = (name: string) => `${name}开启中断`;
