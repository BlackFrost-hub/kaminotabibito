/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { 发送头像提示给玩家, 发送单位提示给玩家, 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  发送头像提示给玩家: (this: void, targetPlayer: any, iconPath: string, text: string, duration?: number) => void;
  发送单位提示给玩家: (this: void, targetPlayer: any, sourceUnit: any, text: string, duration?: number) => void;
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const centerTimer = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;

const 广播测试模块名 = "广播提示消息测试";
const 默认测试头像 = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp";

interface 广播测试套件上下文 {
  player: any;
  hero: any;
  burstIndex: number;
}

let 当前广播测试套件: 广播测试套件上下文 | undefined;

function 写测试日志(this: void, ...args: any[]): void {
  debugLogForce(广播测试模块名, ...args);
}

function 取命令触发英雄(this: void, player: any): any {
  return getRegisteredPlayerHero(player);
}

function 发送默认头像短消息(this: void, player: any): void {
  发送头像提示给玩家(player, 默认测试头像, "短消息测试：这是一条紧凑广播。", 3000);
}

function 发送默认头像长消息(this: void, player: any): void {
  发送头像提示给玩家(
    player,
    默认测试头像,
    "长消息测试：这条广播用于验证两行布局、停留时长拉长，以及短消息槽位间距不会被整体撑开。",
    undefined,
  );
}

function 发送默认头像超长消息(this: void, player: any): void {
  发送头像提示给玩家(
    player,
    默认测试头像,
    "超长消息测试：这条广播会模拟剧情里比较长的说明文本，用来验证自动换行、较高背景、较长停留时长，以及在文本带颜色码时仍然不会把整条广播直接冲出背景区域。",
    undefined,
  );
}

function 发送单位头像单播(this: void, player: any, hero: any): void {
  if (hero == null || hero === 0) {
    写测试日志("未找到已注册玩家英雄，单位头像单播改用默认头像");
    发送头像提示给玩家(player, 默认测试头像, "单位头像单播测试：当前未找到注册英雄，已退回默认头像。", 3000);
    return;
  }
  发送单位提示给玩家(player, hero, "单位头像单播测试：这条消息应该使用你当前英雄的头像。", 3200);
}

function 发送单位头像全体广播(this: void, player: any, hero: any): void {
  if (hero == null || hero === 0) {
    写测试日志("未找到已注册玩家英雄，无法执行全体单位头像广播");
    发送头像提示给玩家(player, 默认测试头像, "全体广播测试失败：当前未找到注册英雄。", 3000);
    return;
  }
  广播单位提示(hero, "全体广播测试：这条消息应使用英雄头像，并向所有测试玩家槽广播。", 3600);
}

function 执行连续短消息第1条(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  ctx.burstIndex = 1;
  发送头像提示给玩家(ctx.player, 默认测试头像, "连续短消息 1/5", 2600);
  centerTimer.addDelayedCallback(180, 执行连续短消息第2条);
}

function 执行连续短消息第2条(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  ctx.burstIndex = 2;
  发送头像提示给玩家(ctx.player, 默认测试头像, "连续短消息 2/5", 2600);
  centerTimer.addDelayedCallback(180, 执行连续短消息第3条);
}

function 执行连续短消息第3条(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  ctx.burstIndex = 3;
  发送头像提示给玩家(ctx.player, 默认测试头像, "连续短消息 3/5", 2600);
  centerTimer.addDelayedCallback(180, 执行连续短消息第4条);
}

function 执行连续短消息第4条(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  ctx.burstIndex = 4;
  发送头像提示给玩家(ctx.player, 默认测试头像, "连续短消息 4/5", 2600);
  centerTimer.addDelayedCallback(180, 执行连续短消息第5条);
}

function 执行连续短消息第5条(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  ctx.burstIndex = 5;
  发送头像提示给玩家(ctx.player, 默认测试头像, "连续短消息 5/5", 2600);
}

function 启动连续短消息测试(this: void, player: any): void {
  当前广播测试套件 = {
    player,
    hero: 取命令触发英雄(player),
    burstIndex: 0,
  };
  执行连续短消息第1条();
}

function 广播测试全套_步骤2(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  发送默认头像长消息(ctx.player);
  centerTimer.addDelayedCallback(700, 广播测试全套_步骤3);
}

function 广播测试全套_步骤3(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  发送默认头像超长消息(ctx.player);
  centerTimer.addDelayedCallback(700, 广播测试全套_步骤4);
}

function 广播测试全套_步骤4(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  发送单位头像单播(ctx.player, ctx.hero);
  centerTimer.addDelayedCallback(700, 广播测试全套_步骤5);
}

function 广播测试全套_步骤5(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  发送单位头像全体广播(ctx.player, ctx.hero);
  centerTimer.addDelayedCallback(700, 广播测试全套_步骤6);
}

function 广播测试全套_步骤6(this: void): void {
  const ctx = 当前广播测试套件;
  if (ctx == null) return;
  执行连续短消息第1条();
}

function 运行广播测试全套(this: void, player: any): void {
  当前广播测试套件 = {
    player,
    hero: 取命令触发英雄(player),
    burstIndex: 0,
  };
  写测试日志("开始广播测试全套", "playerId=", GetPlayerId(player), "hero=", 当前广播测试套件.hero);
  发送默认头像短消息(player);
  centerTimer.addDelayedCallback(700, 广播测试全套_步骤2);
}

function onChatBmsg1(this: void, player: any): void {
  发送默认头像短消息(player);
}

function onChatBmsg2(this: void, player: any): void {
  发送默认头像长消息(player);
}

function onChatBmsg3(this: void, player: any): void {
  发送默认头像超长消息(player);
}

function onChatBmsg4(this: void, player: any): void {
  启动连续短消息测试(player);
}

function onChatBmsg5(this: void, player: any): void {
  发送单位头像单播(player, 取命令触发英雄(player));
}

function onChatBmsg6(this: void, player: any): void {
  发送单位头像全体广播(player, 取命令触发英雄(player));
}

function onChatBmsgAll(this: void, player: any): void {
  运行广播测试全套(player);
}

function 注册广播提示消息测试命令(this: void): void {
  注册聊天命令监听("bmsg1", onChatBmsg1);
  注册聊天命令监听("bmsg2", onChatBmsg2);
  注册聊天命令监听("bmsg3", onChatBmsg3);
  注册聊天命令监听("bmsg4", onChatBmsg4);
  注册聊天命令监听("bmsg5", onChatBmsg5);
  注册聊天命令监听("bmsg6", onChatBmsg6);
  注册聊天命令监听("bmsgall", onChatBmsgAll);
  写测试日志("已注册测试命令", "bmsg1/bmsg2/bmsg3/bmsg4/bmsg5/bmsg6/bmsgall");
}

注册广播提示消息测试命令();

export {};
