/** @noSelfInFile */

const jass = require("jass.common") as any;

const 聊天命令事件中心 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const 首领奖励配置 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index") as {
  瑟兰迪尔奖励池ID: string;
};
const 首领奖励界面 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面") as {
  打开首领奖励选择界面: (this: void, 奖励池ID: string, 玩家: any) => void;
};
const 首领奖励领取状态 = require("系统.02．物品系统.18．首领奖励选择.02．领取状态") as {
  清除首领奖励领取记录: (this: void, 奖励池ID: string, 玩家ID: number) => boolean;
};

const 测试命令 = "brtest";
const 重置测试命令 = "brreset";
const GetPlayerId = jass.GetPlayerId as (玩家: any) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  玩家: any,
  x: number,
  y: number,
  持续时间: number,
  文本: string
) => void;

function 提示(this: void, 玩家: any, 文本: string): void {
  DisplayTimedTextToPlayer(玩家, 0, 0, 8, "[首领奖励测试] " + 文本);
}

function 打开奖励选择测试(this: void, 玩家: any): void {
  首领奖励界面.打开首领奖励选择界面(首领奖励配置.瑟兰迪尔奖励池ID, 玩家);
  提示(玩家, "已打开正式首领奖励界面。");
}

function 重置奖励选择测试领取状态(this: void, 玩家: any): void {
  const 玩家ID = GetPlayerId(玩家);
  const 已清除 = 首领奖励领取状态.清除首领奖励领取记录(首领奖励配置.瑟兰迪尔奖励池ID, 玩家ID);
  提示(玩家, 已清除 ? "已重置本局领取记录，可再次测试。" : "当前没有领取记录。");
}

聊天命令事件中心.注册聊天命令监听(测试命令, 打开奖励选择测试);
聊天命令事件中心.注册聊天命令监听(重置测试命令, 重置奖励选择测试领取状态);

export {};
