/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
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
const IsQuestItemCompleted = jass.IsQuestItemCompleted as (this: void, 任务要求: any) => boolean;
const QuestItemSetCompleted = jass.QuestItemSetCompleted as (this: void, 任务要求: any, 已完成: boolean) => void;

const 测试命令 = "RMXM18";
const 模块名 = "莫特斯进入条件测试";

function on设置莫特斯进入条件(this: void, player: any, command: string): void {
  if (!是允许测试玩家(player) || command !== 测试命令) return;

  const 任务要求 = jglobals.udg_RWXM[18];
  QuestItemSetCompleted(任务要求, true);
  const 已完成 = IsQuestItemCompleted(任务要求) === true;
  DisplayTimedTextToPlayer(player, 0, 0, 6, "[测试] RWXM[18] 已设置为完成：" + tostring(已完成));
  debugLogForce(模块名, "设置任务要求完成", "index", 18, "questItem", 任务要求, "completed", 已完成);
}

注册聊天命令前缀监听(测试命令, on设置莫特斯进入条件);

export {};
