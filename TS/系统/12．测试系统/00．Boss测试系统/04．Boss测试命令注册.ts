/** @noSelfInFile */

import type { Boss测试注册配置 } from "./00．Boss测试类型";

const globals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };
const { 设置Boss自动施法开启, Boss自动施法是否开启 } = require("系统.03．技能系统.06．AI自动使用技能.04．Boss自动施法开关") as {
  设置Boss自动施法开启: (this: void, 开启: boolean) => void;
  Boss自动施法是否开启: (this: void) => boolean;
};
const { 记录Boss自动技能启动, 清理Boss自动技能启动上下文, 是否已登记Boss自动技能 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "Boss测试") => any;
  清理Boss自动技能启动上下文: (this: void, unit: any) => void;
  是否已登记Boss自动技能: (this: void, unit: any) => boolean;
};

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};

const jass = require("jass.common") as any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetPlayerName = jass.GetPlayerName as (player: any) => string;

interface Boss测试当前会话 {
  玩家: any;
  配置: Boss测试注册配置;
  上下文: any;
  Boss单位: any;
}

const Boss测试选择命令表: Record<string, Boss测试注册配置 | undefined> = {};
const Boss测试配置列表: Boss测试注册配置[] = [];
const 已注册技能数字命令表: Record<number, boolean | undefined> = {};
const Boss测试玩家ID = 0;
const Boss测试玩家名称 = "WorldEdit";
const Boss测试列表命令 = "Boss列表";
const Boss测试重置命令 = "Boss重置";
const Boss测试清理命令 = "Boss清理";
const Boss测试AI开启命令 = "BossAI开启";
const Boss测试AI关闭命令 = "BossAI关闭";
let 当前Boss测试会话: Boss测试当前会话 | undefined;
let 已注册Boss测试公共命令 = false;

function 发送Boss测试提示(this: void, player: any, Boss名称: string, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 12, "[" + Boss名称 + "测试] " + text);
}

function 生成命令说明(this: void, 配置: Boss测试注册配置): string {
  let text = "";
  const list = 配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    text = text + " " + list[i].序号.toString() + list[i].名称;
  }
  return text + "。";
}

function 是允许Boss测试玩家(this: void, player: any): boolean {
  if (player == null || player === 0) return false;
  if (GetPlayerId(player) !== Boss测试玩家ID) return false;
  const playerName = GetPlayerName(player) ?? "";
  return playerName === Boss测试玩家名称 || playerName === Boss测试玩家名称 + ":";
}

function 清理当前Boss测试会话(this: void): void {
  const session = 当前Boss测试会话;
  当前Boss测试会话 = undefined;
  if (session != null) {
    清理Boss自动技能启动上下文(session.Boss单位);
    session.配置.清理上下文(session.玩家, session.上下文);
  }
  设置Boss自动施法开启(true);
}

function 激活Boss测试配置(this: void, player: any, 配置: Boss测试注册配置): void {
  清理当前Boss测试会话();
  设置Boss自动施法开启(false);
  const context = 配置.创建或获取上下文(player);
  if (context == null) {
    设置Boss自动施法开启(true);
    发送Boss测试提示(player, 配置.Boss名称, "测试场景创建失败。");
    return;
  }
  当前Boss测试会话 = { 玩家: player, 配置, 上下文: context, Boss单位: globals.udg_Boss };
  发送Boss测试提示(player, 配置.Boss名称, "已创建玩家1 Boss 与两个固定步兵靶，自动AI已关闭。输入技能序号：" + 生成命令说明(配置) + " 输入BossAI开启可验证正式AI。");
}

function onBoss测试选择命令(this: void, player: any, command: string): void {
  if (!是允许Boss测试玩家(player)) return;
  const 配置 = Boss测试选择命令表[command];
  if (配置 == null) return;
  激活Boss测试配置(player, 配置);
}

function onBoss测试技能数字命令(this: void, player: any, command: string): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;

  const 序号 = Number(command);
  const list = session.配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    if (item.序号 !== 序号) continue;
    const context = session.配置.创建或获取上下文(player);
    if (context == null) return;
    session.上下文 = context;
    session.Boss单位 = globals.udg_Boss;
    发送Boss测试提示(player, session.配置.Boss名称, "正在测试：" + item.序号.toString() + " " + item.名称 + "。");
    item.执行(player, context);
    return;
  }
  发送Boss测试提示(player, session.配置.Boss名称, "没有技能序号 " + command + "。可用序号：" + 生成命令说明(session.配置));
}

function onBoss测试列表命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  let text = "";
  for (let i = 0; i < Boss测试配置列表.length; i++) {
    text = text + (i > 0 ? "、" : "") + "Boss" + Boss测试配置列表[i].命令单位名;
  }
  发送Boss测试提示(player, "Boss", "可用场景：" + text + "。");
}

function onBoss测试重置命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  激活Boss测试配置(player, session.配置);
}

function onBoss测试清理命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  const Boss名称 = session.配置.Boss名称;
  清理当前Boss测试会话();
  发送Boss测试提示(player, Boss名称, "测试场景已清理。");
}

function onBoss测试AI开启命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  if (Boss自动施法是否开启()) {
    发送Boss测试提示(player, session.配置.Boss名称, "自动AI已经处于开启状态。");
    return;
  }
  const context = session.配置.创建或获取上下文(player);
  if (context != null) {
    session.上下文 = context;
    session.Boss单位 = globals.udg_Boss;
  }
  if (session.Boss单位 == null || session.Boss单位 === 0) {
    发送Boss测试提示(player, session.配置.Boss名称, "自动AI开启失败：找不到当前测试Boss。");
    return;
  }
  if (!是否已登记Boss自动技能(session.Boss单位)) 记录Boss自动技能启动(session.Boss单位, "Boss测试");
  设置Boss自动施法开启(true);
  发送Boss测试提示(player, session.配置.Boss名称, "自动AI已开启，将按正式逻辑自动施法。");
}

function onBoss测试AI关闭命令(this: void, player: any): void {
  if (!是允许Boss测试玩家(player)) return;
  const session = 当前Boss测试会话;
  if (session == null || GetPlayerId(session.玩家) !== GetPlayerId(player)) return;
  if (!Boss自动施法是否开启()) {
    发送Boss测试提示(player, session.配置.Boss名称, "自动AI已经处于关闭状态。");
    return;
  }
  设置Boss自动施法开启(false);
  发送Boss测试提示(player, session.配置.Boss名称, "自动AI已关闭，仅数字命令会主动施法。");
}

function 确保注册Boss测试公共命令(this: void): void {
  if (已注册Boss测试公共命令) return;
  已注册Boss测试公共命令 = true;
  注册聊天命令监听(Boss测试列表命令, onBoss测试列表命令);
  注册聊天命令监听(Boss测试重置命令, onBoss测试重置命令);
  注册聊天命令监听(Boss测试清理命令, onBoss测试清理命令);
  注册聊天命令监听(Boss测试AI开启命令, onBoss测试AI开启命令);
  注册聊天命令监听(Boss测试AI关闭命令, onBoss测试AI关闭命令);
}

export function 注册Boss测试命令组(this: void, 配置: Boss测试注册配置): void {
  确保注册Boss测试公共命令();
  const 选择命令 = "Boss" + 配置.命令单位名;
  if (Boss测试选择命令表[选择命令] == null) {
    Boss测试配置列表.push(配置);
    注册聊天命令监听(选择命令, onBoss测试选择命令);
  }
  Boss测试选择命令表[选择命令] = 配置;

  const list = 配置.技能命令列表;
  for (let i = 0; i < list.length; i++) {
    const item = list[i];
    if (已注册技能数字命令表[item.序号] === true) continue;
    已注册技能数字命令表[item.序号] = true;
    注册聊天命令监听(item.序号.toString(), onBoss测试技能数字命令);
  }
}

export function 清理当前Boss测试(this: void): void {
  清理当前Boss测试会话();
}
