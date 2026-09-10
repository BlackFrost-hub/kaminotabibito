/** @noSelfInFile */
/**
 * 跟踪花传送命令（-跟踪花）
 *
 * 功能：把玩家英雄瞬移到一株"花"采集物旁边（荧光草/星露花/晨曦花/月影花）。
 * - 只找花物品，不找聚灵花单位（植物配置表里的 nsea 单位不在目标内）；
 * - 搜索范围：06．植物配置表 随机物品配置引用的全部刷新区域（动态矩形注册表惰性注册）；
 * - 落点 = 花的位置沿"花→英雄原位置"方向偏移 120 码（英雄原位置必然可达，避免卡进地形）；
 * - 传送后镜头立即切到落点；找不到花时给出提示（可能已被采集或尚未刷新）。
 */

const jass = require("jass.common") as any;
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { safeEnumItemsInRect } = require("系统.00．核心系统.07．联机安全工具") as {
  safeEnumItemsInRect: (rect: any, filter: any, action: () => void) => void;
};
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};
const { 世界地图植物随机物品配置表 } = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.06．植物配置表") as {
  世界地图植物随机物品配置表: { 矩形区域名称: string }[];
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const GetEnumItem = jass.GetEnumItem as (this: void) => any;
const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const GetItemX = jass.GetItemX as (this: void, item: any) => number;
const GetItemY = jass.GetItemY as (this: void, item: any) => number;
const IsItemVisible = jass.IsItemVisible as (this: void, item: any) => boolean;
const PanCameraToTimedForPlayer = jass.PanCameraToTimedForPlayer as (this: void, player: any, x: number, y: number, duration: number) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (this: void, player: any, x: number, y: number, duration: number, text: string) => void;

const 模块名 = "跟踪花传送命令";
const 传送命令 = "-跟踪花";
/** 落点与花的距离（码） */
const 落点偏移距离 = 120;

/** 花物品ID → 显示名（与 06．植物配置表 / 01．装备数据 一致） */
const 花物品ID表: Record<number, string> = {
  [0x73687764]: "荧光草", // "shwd"
  [0x49304834]: "星露花", // "I0H4"
  [0x49304835]: "晨曦花", // "I0H5"
  [0x49304836]: "月影花", // "I0H6"
};

interface 花候选 {
  物品: any;
  名称: string;
  X: number;
  Y: number;
}

/** 从配置表提取去重后的刷新区域名称 */
function 取花刷新区域名称列表(this: void): string[] {
  const 区域名集合 = new Set<string>();
  for (const 配置 of 世界地图植物随机物品配置表) {
    if (配置.矩形区域名称 != null && 配置.矩形区域名称 !== "") {
      区域名集合.add(配置.矩形区域名称);
    }
  }
  const 列表: string[] = [];
  区域名集合.forEach((名称) => 列表.push(名称));
  return 列表;
}

/** 在单个区域内收集花物品候选 */
function 收集区域内花候选(this: void, 区域名称: string, 结果: 花候选[]): void {
  const rect = 获取矩形区域(区域名称);
  if (rect == null || rect === 0) return;

  safeEnumItemsInRect(rect, null, () => {
    const item = GetEnumItem();
    if (item == null || item === 0) return;
    if (!IsItemVisible(item)) return;
    const typeId = GetItemTypeId(item);
    const 名称 = 花物品ID表[typeId];
    if (名称 == null) return;
    结果.push({ 物品: item, 名称, X: GetItemX(item), Y: GetItemY(item) });
  });
}

/** 沿"花 → 英雄原位置"方向取落点（英雄原位置必然可达） */
function 取传送落点(this: void, 花X: number, 花Y: number, 英雄X: number, 英雄Y: number): { x: number; y: number } {
  let dx = 英雄X - 花X;
  let dy = 英雄Y - 花Y;
  const 长度 = Math.sqrt(dx * dx + dy * dy);
  if (长度 < 1) {
    dx = 0;
    dy = -1;
  } else {
    dx = dx / 长度;
    dy = dy / 长度;
  }
  return { x: 花X + dx * 落点偏移距离, y: 花Y + dy * 落点偏移距离 };
}

function on跟踪花命令(this: void, player: any, _command: string): void {
  if (!是允许测试玩家(player)) return;

  const hero = getRegisteredPlayerHero(player);
  if (hero == null || hero === 0) {
    debugLogForce(模块名, "未找到当前玩家已注册英雄");
    return;
  }

  // 收集全部刷新区域内的花候选
  const 候选列表: 花候选[] = [];
  const 区域名列表 = 取花刷新区域名称列表();
  for (let i = 0; i < 区域名列表.length; i++) {
    收集区域内花候选(区域名列表[i], 候选列表);
  }

  if (候选列表.length <= 0) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[跟踪花] 场上当前没有找到任何花（可能已被采集，等待刷新后重试）");
    debugLogForce(模块名, "未找到花物品：搜索区域 =", 区域名列表.join(" / "));
    return;
  }

  // 随机挑一株花，瞬移英雄到花旁边
  const 目标 = 候选列表[Math.floor(Math.random() * 候选列表.length)];
  const 英雄X = GetUnitX(hero);
  const 英雄Y = GetUnitY(hero);
  const 落点 = 取传送落点(目标.X, 目标.Y, 英雄X, 英雄Y);

  SetUnitX(hero, 落点.x);
  SetUnitY(hero, 落点.y);
  PanCameraToTimedForPlayer(player, 目标.X, 目标.Y, 0);

  DisplayTimedTextToPlayer(
    player,
    0,
    0,
    8,
    "[跟踪花] 已传送到 " + 目标.名称 + " 旁边（共发现 " + 候选列表.length + " 株，坐标 " + Math.round(目标.X) + ", " + Math.round(目标.Y) + "）",
  );
  debugLogForce(模块名, "传送完成：目标 =", 目标.名称, "落点 =", Math.round(落点.x), Math.round(落点.y), "候选数 =", 候选列表.length);
}

注册聊天命令监听(传送命令, on跟踪花命令);
debugLogForce(模块名, "已注册命令：输入", 传送命令, "把玩家英雄瞬移到一株花旁边");

export {};
