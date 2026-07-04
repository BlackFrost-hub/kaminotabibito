/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 显示物品栏物品冷却 } = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示") as {
  显示物品栏物品冷却: (this: void, hero: any, item: any, durationMs: number) => void;
};

const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 模块名 = "物品栏被动冷却UI测试";
const 测试命令 = "wpuicd";
const 测试槽位 = 0;
const 测试冷却毫秒 = 6000;

let 已初始化 = false;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 当前毫秒(this: void): number {
  return os.clock() * 1000;
}

function 是本地玩家(this: void, player: any): boolean {
  if (!句柄有效(player)) return false;
  return GetPlayerId(GetLocalPlayer()) === GetPlayerId(player);
}

function 单位有效(this: void, unit: any): boolean {
  return 句柄有效(unit) && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 获取玩家测试英雄(this: void, player: any): any {
  const registeredHero = getRegisteredPlayerHero(player);
  if (单位有效(registeredHero)) return registeredHero;

  const presetHero = globals.gg_unit_Hamg_0002;
  if (单位有效(presetHero) && GetPlayerId(GetOwningPlayer(presetHero)) === GetPlayerId(player)) return presetHero;
  return null;
}

function on测试命令(this: void, player: any, _command: string): void {
  const hero = 获取玩家测试英雄(player);
  if (!单位有效(hero)) {
    debugLogForce(模块名, "未找到玩家英雄");
    return;
  }
  const item = UnitItemInSlot(hero, 测试槽位);
  if (!句柄有效(item)) {
    debugLogForce(模块名, "英雄第1格没有物品");
    return;
  }

  if (是本地玩家(player)) {
    显示物品栏物品冷却(hero, item, 测试冷却毫秒);
  }
  debugLogForce(模块名, "已触发第1格物品UI冷却测试", "英雄ID", GetHandleId(hero), "秒", 测试冷却毫秒 / 1000);
}

function 初始化物品栏被动冷却UI测试(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  注册聊天命令监听(测试命令, on测试命令);
}

初始化物品栏被动冷却UI测试();

export {};
