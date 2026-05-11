/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const SquareRoot = jass.SquareRoot as (x: number) => number;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

import { 开始纯跳链, type 跳链结束原因 } from "../01．技能函数/10．跳链/index";

const 模块名 = "跳链测试";
const 测试命令 = "1010";
const 搜索半径 = 900;
const 最大跳数 = 5;
const 每跳最大距离 = 500;
const 初始伤害 = 60;
const 衰减系数 = 0.8;
const 跳跃间隔 = 0.15;
let 已注册 = false;

function 查找最近敌人(来源单位: any, x: number, y: number): any {
  const 候选单位 = getUnitsInRange(x, y, 搜索半径);
  let 最佳目标: any = null;
  let 最佳距离 = 0;

  for (const 单位 of 候选单位) {
    if (单位 === 来源单位) continue;
    if (!isUnitEnemy(单位, 来源单位)) continue;
    const 距离 = SquareRoot((GetUnitX(单位) - x) * (GetUnitX(单位) - x) + (GetUnitY(单位) - y) * (GetUnitY(单位) - y));
    if (最佳目标 == null || 距离 < 最佳距离) {
      最佳目标 = 单位;
      最佳距离 = 距离;
    }
  }

  return 最佳目标;
}

function 跳链测试_每跳回调(单位: any, 数值: number, 当前跳数: number, 跳链ID: number): void {
  debugLogForce(
    模块名,
    "每跳命中",
    "ID=",
    跳链ID,
    " 跳数=",
    当前跳数,
    " 数值=",
    数值,
    " 单位=",
    GetUnitName(单位),
    "#",
    GetHandleId(单位)
  );
}

function 跳链测试_结束回调(原因: 跳链结束原因, 已完成跳数: number, 跳链ID: number): void {
  debugLogForce(模块名, "跳链结束", "ID=", 跳链ID, " 原因=", 原因, " 已完成跳数=", 已完成跳数);
}

function on聊天1010测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const x = GetUnitX(大法师);
  const y = GetUnitY(大法师);
  const 初始目标 = 查找最近敌人(大法师, x, y);
  if (初始目标 == null || 初始目标 === 0) {
    debugLogForce(模块名, "搜索半径内未找到敌方起始目标");
    return;
  }

  const 实例 = 开始纯跳链({
    起始目标: 初始目标,
    来源单位: 大法师,
    模式: "伤害",
    影响目标: "敌方",
    最大跳数,
    每跳最大距离,
    初始数值: 初始伤害,
    每跳衰减系数: 衰减系数,
    跳跃间隔,
    闪电效果代码: "CLPB",
    闪电持续时间: 0.3,
    每跳回调: 跳链测试_每跳回调,
    结束回调: 跳链测试_结束回调,
  });

  if (实例 == null) {
    debugLogForce(模块名, "跳链启动失败");
    return;
  }

  debugLogForce(
    模块名,
    "已启动跳链测试",
    " 命令=", 测试命令,
    " 跳链ID=", 实例.跳链ID,
    " 最大跳数=", 最大跳数,
    " 每跳距离=", 每跳最大距离,
    " 初始伤害=", 初始伤害
  );
}

function 注册聊天1010测试(): void {
  if (已注册) return;
  已注册 = true;
  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1010测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令, "启动纯跳链测试");
}

注册聊天1010测试();

export {};
