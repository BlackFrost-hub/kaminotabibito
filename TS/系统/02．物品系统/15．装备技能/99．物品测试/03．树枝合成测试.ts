/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const Player = jass.Player as (index: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

const 模块名 = "树枝合成测试";
const 树枝测试命令 = "tree4";
const 树枝物品名 = "树枝";
const 树枝创建偏移: readonly [number, number][] = [
  [-48, -32],
  [48, -32],
  [-48, 32],
  [48, 32],
];

function 是玩家1(this: void, player: any): boolean {
  return player != null && player !== 0 && GetPlayerId(player) === 0;
}

function 创建四个树枝(this: void, player: any, _command: string): void {
  if (!是玩家1(player)) return;

  const hero = getRegisteredPlayerHero(Player(0));
  if (hero == null || hero === 0) {
    debugLogForce(模块名, "未找到玩家1注册英雄");
    return;
  }

  const rawId = 按名字反查物品ID(树枝物品名);
  const itemTypeId = stringToFourCCSafe(rawId);
  if (itemTypeId === 0) {
    debugLogForce(模块名, "未找到树枝物品ID", 树枝物品名, rawId);
    return;
  }

  const heroX = GetUnitX(hero);
  const heroY = GetUnitY(hero);
  let createdCount = 0;
  for (let i = 0; i < 树枝创建偏移.length; i++) {
    const offset = 树枝创建偏移[i];
    const item = 创建物品并注册排泄监听(itemTypeId, heroX + offset[0], heroY + offset[1]);
    if (item != null && item !== 0) createdCount++;
  }
  debugLogForce(模块名, "已在玩家1注册英雄脚下创建树枝", "数量", createdCount);
}

注册聊天命令监听(树枝测试命令, 创建四个树枝);

export {};
