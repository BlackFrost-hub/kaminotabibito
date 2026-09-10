/** @noSelfInFile */
/**
 * 花生成命令（-种花）
 *
 * 用途：在测试玩家英雄身边直接生成一株花（荧光草/星露花/晨曦花/月影花随机一种），
 * 用于验证采集流程与花模型；生成逻辑与 20．世界地图单位缓步创建 的初始化一致
 * （创建物品并注册排泄监听 + 登记采集物品实例）。
 *
 * 只读排查请用 -花诊断；找场上已有的花请用 -跟踪花。
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
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { 登记采集物品实例 } = require("系统.02．物品系统.17．装备采集.02．核心") as {
  登记采集物品实例: (this: void, 物品: any, 物品类型ID: number, 刷新区域名称: string) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (this: void, min: number, max: number) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (this: void, player: any, x: number, y: number, duration: number, text: string) => void;

const 模块名 = "花生成命令";
const 生成命令 = "-种花";
/** 生成点相对英雄的距离范围（码） */
const 最小距离 = 120;
const 最大距离 = 220;

/** 可生成的花（与 06．植物配置表 / 地图物编一致） */
const 可生成花表: { 名称: string; 物品ID: number }[] = [
  { 名称: "荧光草", 物品ID: 0x73687764 }, // "shwd"
  { 名称: "星露花", 物品ID: 0x49304834 }, // "I0H4"
  { 名称: "晨曦花", 物品ID: 0x49304835 }, // "I0H5"
  { 名称: "月影花", 物品ID: 0x49304836 }, // "I0H6"
];

function on种花命令(this: void, player: any, _command: string): void {
  if (!是允许测试玩家(player)) return;

  const hero = getRegisteredPlayerHero(player);
  if (hero == null || hero === 0) {
    debugLogForce(模块名, "未找到当前玩家已注册英雄");
    return;
  }

  const 英雄X = GetUnitX(hero);
  const 英雄Y = GetUnitY(hero);
  const 距离 = GetRandomReal(最小距离, 最大距离);
  const 角度 = GetRandomReal(0, 2 * Math.PI);
  const 落点X = 英雄X + Math.cos(角度) * 距离;
  const 落点Y = 英雄Y + Math.sin(角度) * 距离;

  const 目标 = 可生成花表[Math.floor(GetRandomReal(0, 可生成花表.length))];
  const 物品 = 创建物品并注册排泄监听(目标.物品ID, 落点X, 落点Y);
  if (物品 == null || 物品 === 0) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[种花] 创建失败：" + 目标.名称 + "（物品ID 可能不在物编内）");
    debugLogForce(模块名, "创建失败：目标 =", 目标.名称, "坐标 =", 落点X, 落点Y);
    return;
  }

  登记采集物品实例(物品, 目标.物品ID, "测试.种花");
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[种花] 已在身边生成 " + 目标.名称 + "（" + Math.round(距离) + " 码外）");
  debugLogForce(模块名, "生成完成：", 目标.名称, "坐标 =", Math.round(落点X), Math.round(落点Y));
}

注册聊天命令监听(生成命令, on种花命令);
debugLogForce(模块名, "已注册命令：输入", 生成命令, "在英雄身边生成一株花");

export {};
