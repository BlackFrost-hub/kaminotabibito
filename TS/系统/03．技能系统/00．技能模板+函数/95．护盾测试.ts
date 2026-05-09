/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 开始护盾, 查询单位总护盾值, 护盾类型 } from "./01．技能函数/07．护盾/index";

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;

const 模块名 = "护盾测试";
const 测试命令 = "1001";
let 已注册 = false;

function on聊天1001测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  // 3秒物理护盾100 + 30秒通用护盾200，系统自动显示漂浮文字
  开始护盾(大法师, {
    类型: 护盾类型.物理,
    数值: 100,
    持续时间: 3,
    显示护盾条: false,
  });

  开始护盾(大法师, {
    类型: 护盾类型.通用,
    数值: 200,
    持续时间: 30,
    显示护盾条: true,
  });

  const 总护盾 = 查询单位总护盾值(大法师);
  debugLogForce(模块名, "当前总护盾值:", 总护盾);
}

function 注册聊天测试(): void {
  if (已注册) return;
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1001测试);

  debugLogForce(模块名, "已注册测试：输入", 测试命令, "添加100通用+100物理护盾");
}

注册聊天测试();

export {};
