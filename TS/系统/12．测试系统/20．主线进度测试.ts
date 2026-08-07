/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, player: any) => boolean;
};
const { 注册聊天命令前缀监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令前缀监听: (
    this: void,
    前缀: string,
    回调: (this: void, player: any, command: string) => void,
  ) => void;
};
const { 写入剧情进度, 读取剧情进度 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文") as {
  写入剧情进度: (this: void, 进度: number) => void;
  读取剧情进度: (this: void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  text: string,
) => void;

const 主线进度命令前缀 = "进度";
const 模块名 = "主线进度测试";
const 主线进度最小值 = 0;
const 主线进度最大值 = 50;

function 发送测试提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 6, "[测试] " + text);
}

function 解析主线进度(this: void, command: string): number | undefined {
  if (command.substring(0, 主线进度命令前缀.length) !== 主线进度命令前缀) return undefined;

  const text = command.substring(主线进度命令前缀.length).trim();
  if (text === "") return undefined;

  const progress = Number(text);
  if (progress !== progress || progress < 主线进度最小值 || progress > 主线进度最大值 || progress !== Math.floor(progress)) return undefined;
  return progress;
}

function on主线进度命令(this: void, player: any, command: string): void {
  if (!是允许测试玩家(player)) return;

  const progress = 解析主线进度(command);
  if (progress == null) {
    发送测试提示(player, "命令格式：进度+数字，范围 0-50，例如：进度15");
    debugLogForce(模块名, "命令格式无效或超出范围", "command", command, "范围", "0-50");
    return;
  }

  const previousProgress = 读取剧情进度();
  写入剧情进度(progress);
  发送测试提示(player, "主线剧情进度已设置为 " + progress + "（原进度 " + previousProgress + "）");
  debugLogForce(模块名, "设置主线剧情进度", "command", command, "previousProgress", previousProgress, "progress", progress);
}

注册聊天命令前缀监听(主线进度命令前缀, on主线进度命令);

export {};
