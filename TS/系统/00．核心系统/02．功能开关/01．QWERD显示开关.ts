/** @noSelfInFile */

const jass = require("jass.common") as any;

const 获取玩家编号 = jass.GetPlayerId as (whichPlayer: any) => number;
const 显示限时文本 = jass.DisplayTimedTextToPlayer as (
  toPlayer: any,
  x: number,
  y: number,
  duration: number,
  message: string
) => void;
const 获取本地玩家 = jass.GetLocalPlayer as () => any;

const 聊天命令事件中心 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (
    this: void,
    命令: string,
    回调: (this: void, player: any, command: string) => void
  ) => void;
};

const 冷却显示命令 = "-cool";
const 魔法消耗显示命令 = "-cost";
const 动态技能文本命令 = "-动态技能";
const 系统提示前缀 = "|cffffff00『系统提示』：|r";
const 提示持续时间 = 5;

const 冷却显示开关表: Record<number, boolean | undefined> = {};
const 魔法消耗显示开关表: Record<number, boolean | undefined> = {};
const 动态技能文本开关表: Record<number, boolean | undefined> = {};

let 已初始化 = false;

function 读取冷却显示开关(this: void, playerId: number): boolean {
  const value = 冷却显示开关表[playerId];
  return value == null ? true : value;
}

function 读取魔法消耗显示开关(this: void, playerId: number): boolean {
  const value = 魔法消耗显示开关表[playerId];
  return value == null ? true : value;
}

function 读取动态技能文本开关(this: void, playerId: number): boolean {
  const value = 动态技能文本开关表[playerId];
  return value == null ? true : value;
}

function 输出开关提示(this: void, whichPlayer: any, label: string, enabled: boolean): void {
  const 状态文本 = enabled ? "已开启" : "已关闭";
  显示限时文本(whichPlayer, 0, 0.02, 提示持续时间, `${系统提示前缀}${label}${状态文本}`);
}

function 切换冷却显示命令动作(this: void, whichPlayer: any): void {
  const playerId = 获取玩家编号(whichPlayer);
  const nextValue = !读取冷却显示开关(playerId);
  冷却显示开关表[playerId] = nextValue;
  输出开关提示(whichPlayer, "技能冷却显示", nextValue);
}

function 切换魔法消耗显示命令动作(this: void, whichPlayer: any): void {
  const playerId = 获取玩家编号(whichPlayer);
  const nextValue = !读取魔法消耗显示开关(playerId);
  魔法消耗显示开关表[playerId] = nextValue;
  输出开关提示(whichPlayer, "魔法消耗显示", nextValue);
}

function 切换动态技能文本命令动作(this: void, whichPlayer: any): void {
  const playerId = 获取玩家编号(whichPlayer);
  const nextValue = !读取动态技能文本开关(playerId);
  动态技能文本开关表[playerId] = nextValue;
  输出开关提示(whichPlayer, "动态技能文本", nextValue);
}

export function 本地玩家是否开启冷却显示(this: void): boolean {
  const localPlayer = 获取本地玩家();
  if (localPlayer == null || localPlayer === 0) return true;
  return 读取冷却显示开关(获取玩家编号(localPlayer));
}

export function 本地玩家是否开启魔法消耗显示(this: void): boolean {
  const localPlayer = 获取本地玩家();
  if (localPlayer == null || localPlayer === 0) return true;
  return 读取魔法消耗显示开关(获取玩家编号(localPlayer));
}

export function 本地玩家是否开启动态技能文本(this: void): boolean {
  const localPlayer = 获取本地玩家();
  if (localPlayer == null || localPlayer === 0) return true;
  return 读取动态技能文本开关(获取玩家编号(localPlayer));
}

export function 初始化QWERD显示开关(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  聊天命令事件中心.注册聊天命令监听(冷却显示命令, 切换冷却显示命令动作);
  聊天命令事件中心.注册聊天命令监听(魔法消耗显示命令, 切换魔法消耗显示命令动作);
  聊天命令事件中心.注册聊天命令监听(动态技能文本命令, 切换动态技能文本命令动作);
}

export {};
