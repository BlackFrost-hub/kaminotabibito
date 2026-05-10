/** @noSelfInFile */
/**
 * 动态范围测试
 *
 * 输入"dt"后，以 gg_unit_Hamg_0002 位置为中心，从 100→1000 扩散，伤害 100。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => any;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 创建动态范围 } from "./01．技能函数/04．区域效果/动态范围";

const 模块名 = "动态范围测试";
const 测试命令 = "dt";
let 已注册 = false;

function on聊天测试(): void {
  const 来源单位 = g.gg_unit_Hamg_0002;
  if (来源单位 == null || 来源单位 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  创建动态范围({
    X: GetUnitX(来源单位),
    Y: GetUnitY(来源单位),
    起始半径: 100,
    结束半径: 1000,
    变化时间: 3,
    检测间隔: 0.5,
    影响目标: "敌方",
    所有者: 来源单位,
    伤害值: 100,
    on周期: 动态范围测试_周期,
    on销毁: 动态范围测试_销毁,
  });

  debugLogForce(模块名, "已创建动态范围：100→1000，3秒扩散，每0.5秒伤害100");
}

function 动态范围测试_周期(单位列表: any[], 当前半径: number): void {
  debugLogForce(模块名, "周期触发：当前半径=" + 当前半径 + "，命中=" + 单位列表.length + "个单位");
}

function 动态范围测试_销毁(): void {
  debugLogForce(模块名, "动态范围效果已结束");
}

function 注册聊天测试(): void {
  if (已注册) return;
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天测试);

  debugLogForce(模块名, "已注册测试：输入", 测试命令, "触发动态范围扩散");
}

注册聊天测试();

export {};
