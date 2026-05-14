/** @noSelfInFile */
/**
 * 广播提示消息测试
 *
 * 输入 1025：只给触发玩家发送单位头像提示。
 * 输入 1026：给全体玩家广播单位头像提示。
 * 输入 1027：给触发玩家连续发送多条自定义头像提示，测试槽位队列和覆盖。
 */

const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const 广播提示 = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
  发送单位提示给玩家: (this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number) => void;
  发送头像提示给玩家: (this: void, 目标玩家: any, 头像路径: string, 文本: string, 持续时间?: number) => void;
};

const 模块名 = "广播提示消息测试";
const 单人命令 = "1025";
const 全体命令 = "1026";
const 连发命令 = "1027";
const 备用头像路径 = "UI\\xiaoxi\\UInotice.tga";

const 广播单位提示 = 广播提示.广播单位提示;
const 发送单位提示给玩家 = 广播提示.发送单位提示给玩家;
const 发送头像提示给玩家 = 广播提示.发送头像提示给玩家;

function 取测试单位(this: void): any {
  return g.gg_unit_Hamg_0002;
}

function 测试单位有效(this: void): boolean {
  const 大法师 = 取测试单位();
  if (大法师 != null && 大法师 !== 0) return true;
  debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002，无法测试单位头像提示");
  return false;
}

function on聊天1025测试(this: void, player: any): void {
  if (!测试单位有效()) return;
  发送单位提示给玩家(player, 取测试单位(), "|cffffcc33单人单位头像提示：只有你应该看到这条。|r", 3000);
  debugLogForce(模块名, "已触发单人广播提示测试");
}

function on聊天1026测试(this: void): void {
  if (!测试单位有效()) return;
  广播单位提示(取测试单位(), "|cff66ccff全体广播提示：所有玩家都应该看到这条。|r", 3000);
  debugLogForce(模块名, "已触发全体广播提示测试");
}

function on聊天1027测试(this: void, player: any): void {
  for (let i = 1; i <= 7; i++) {
    发送头像提示给玩家(player, 备用头像路径, "|cff99ff99连续头像提示 #" + i.toString() + "|r", 1800);
  }
  debugLogForce(模块名, "已触发连续广播提示测试");
}

注册聊天命令监听(单人命令, on聊天1025测试);
注册聊天命令监听(全体命令, on聊天1026测试);
注册聊天命令监听(连发命令, on聊天1027测试);
debugLogForce(模块名, "已注册测试：输入", 单人命令, "单人；", 全体命令, "全体；", 连发命令, "连发");

export {};
