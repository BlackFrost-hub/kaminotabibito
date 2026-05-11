/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (module: string, ...args: any[]) => void;
};

import { 开始无敌帧 } from "../02．通用函数/index";

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;

const 模块名 = "无敌帧测试";
const 测试开关 = true;
const 测试命令 = "112";
const 测试持续时间 = 3.0;
let 已注册 = false;

function 执行无敌帧测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  开始无敌帧(大法师, 测试持续时间);
  debugLogForce(模块名, "已对 gg_unit_Hamg_0002 施加无敌", "持续秒数=", 测试持续时间);
}

function on聊天112测试(): void {
  执行无敌帧测试();
}

function 注册聊天112测试(): void {
  if (!测试开关 || 已注册) return;
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天112测试);

  debugLogForce(模块名, "已注册聊天测试", "输入", 测试命令, "对 gg_unit_Hamg_0002 施加 3 秒无敌");
}

注册聊天112测试();

export {};
