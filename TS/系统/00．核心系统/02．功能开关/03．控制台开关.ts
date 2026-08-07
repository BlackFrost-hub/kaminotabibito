/** @noSelfInFile */

const jass = require("jass.common") as any;
const runtime = require("jass.runtime") as { console: boolean };

const 获取玩家编号 = jass.GetPlayerId as (whichPlayer: any) => number;
const 获取玩家名称 = jass.GetPlayerName as (whichPlayer: any) => string;
const 获取玩家对象 = jass.Player as (playerId: number) => any;
const 显示限时文本 = jass.DisplayTimedTextToPlayer as (
  toPlayer: any,
  x: number,
  y: number,
  duration: number,
  message: string
) => void;

const 聊天命令事件中心 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (
    this: void,
    命令: string,
    回调: (this: void, player: any, command: string) => void
  ) => void;
};

const 控制台切换命令 = "-console";
const 控制台开启命令 = "-console-on";
const 控制台关闭命令 = "-console-off";
const 管理员玩家编号 = 0;
const 默认开启控制台玩家名称 = "WorldEdit";
const 默认开启控制台备用玩家名称 = "九条艾莉莎";
const 提示持续时间 = 5;
const 系统提示前缀 = "|cffffff00[System]|r ";

function 是控制台管理员(this: void, whichPlayer: any): boolean {
  return whichPlayer != null && whichPlayer !== 0 && 获取玩家编号(whichPlayer) === 管理员玩家编号;
}

function 是否默认开启控制台(this: void): boolean {
  const playerName = 获取玩家名称(获取玩家对象(管理员玩家编号)) ?? "";
  return playerName === 默认开启控制台玩家名称
    || playerName === 默认开启控制台玩家名称 + ":"
    || playerName === 默认开启控制台备用玩家名称
    || playerName === 默认开启控制台备用玩家名称 + ":";
}

function 输出控制台状态(this: void, whichPlayer: any): void {
  const 状态 = runtime.console === true ? "ON" : "OFF";
  显示限时文本(whichPlayer, 0, 0.02, 提示持续时间, 系统提示前缀 + "console=" + 状态);
}

function 设置控制台(this: void, whichPlayer: any, enabled: boolean): void {
  if (!是控制台管理员(whichPlayer)) return;
  runtime.console = enabled;
  输出控制台状态(whichPlayer);
}

function 切换控制台命令(this: void, whichPlayer: any, command: string): void {
  if (!是控制台管理员(whichPlayer)) return;
  runtime.console = runtime.console !== true;
  输出控制台状态(whichPlayer);
}

function 开启控制台命令(this: void, whichPlayer: any, command: string): void {
  设置控制台(whichPlayer, true);
}

function 关闭控制台命令(this: void, whichPlayer: any, command: string): void {
  设置控制台(whichPlayer, false);
}

let 已初始化 = false;

export function 初始化控制台开关(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  runtime.console = 是否默认开启控制台();

  聊天命令事件中心.注册聊天命令监听(控制台切换命令, 切换控制台命令);
  聊天命令事件中心.注册聊天命令监听(控制台开启命令, 开启控制台命令);
  聊天命令事件中心.注册聊天命令监听(控制台关闭命令, 关闭控制台命令);
}

export {};
