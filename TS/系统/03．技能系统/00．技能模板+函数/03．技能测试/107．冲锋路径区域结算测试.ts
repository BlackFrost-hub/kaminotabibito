/** @noSelfInFile */
/**
 * 冲锋路径区域结算测试
 *
 * 输入"1007"后，`gg_unit_Hamg_0002` 会先播放 `attack` 动作并硬直 1 秒，
 * 之后沿当前面向冲锋 800 码，持续 0.4 秒。
 * 冲锋结束后，对整条 800 码路径上“半径 200”的敌方单位造成 200 伤害。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 开始冲锋并在结束时结算路径区域 } from "../01．技能函数/02．冲锋·击退/index";
import { 开始技能前摇, 创建冲锋路径前摇提示 } from "../00．技能模板/01．多阶段技能编排/index";
import { 开始硬直 } from "../02．通用函数/01．控制与Buff";

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as ((u: any, index: number) => void) | undefined;

const 模块名 = "冲锋路径区域结算测试";
const 测试命令 = "1007";
const 冲锋距离 = 800;
const 路径半径 = 200;
const 路径宽度 = 路径半径 * 2;
const 前摇时间 = 1.0;
const 冲锋路径前摇提示 = 创建冲锋路径前摇提示(冲锋距离, 路径宽度, 前摇时间);
let 已注册 = false;

function 取朝向终点X(x: number, 朝向角: number, 距离: number): number {
  return x + (jass.Cos(朝向角 * jass.bj_DEGTORAD) as number) * 距离;
}

function 取朝向终点Y(y: number, 朝向角: number, 距离: number): number {
  return y + (jass.Sin(朝向角 * jass.bj_DEGTORAD) as number) * 距离;
}

function 冲锋路径区域_结束日志(单位: any, 原因: string, 位移ID: number): void {
  debugLogForce(模块名, "冲锋结束，原因=", 原因, "位移ID=", 位移ID, "终点=(", GetUnitX(单位), ",", GetUnitY(单位), ")");
}

function 冲锋路径区域_命中日志(_移动单位: any, 目标单位: any, 位移ID: number, 原因: string): void {
  debugLogForce(模块名, "路径命中：位移ID=", 位移ID, "原因=", 原因, "目标=(", GetUnitX(目标单位), ",", GetUnitY(目标单位), ")");
}

function 执行冲锋路径斩杀(大法师: any): void {
  const 起点X = GetUnitX(大法师);
  const 起点Y = GetUnitY(大法师);
  const 朝向角 = GetUnitFacing(大法师);
  const 目标X = 取朝向终点X(起点X, 朝向角, 冲锋距离);
  const 目标Y = 取朝向终点Y(起点Y, 朝向角, 冲锋距离);

  const 位移ID = 开始冲锋并在结束时结算路径区域(大法师, {
    目标X,
    目标Y,
    距离: 冲锋距离,
    持续时间: 0.4,
    检查地形: true,
    朝向跟随位移: true,
    禁用碰撞: true,
    结束回调: 冲锋路径区域_结束日志,
  }, {
    区域形状: "胶囊",
    宽度: 路径宽度,
    伤害值: 200,
    影响目标: "敌方",
    仅完成时结算: true,
    命中回调: 冲锋路径区域_命中日志,
  });

  if (位移ID <= 0) {
    debugLogForce(模块名, "冲锋启动失败：无法解析冲锋目标");
    return;
  }

  debugLogForce(
    模块名,
    "已启动测试：位移ID=",
    位移ID,
    "起点=(",
    起点X,
    ",",
    起点Y,
    ") 斩杀终点=(",
    目标X,
    ",",
    目标Y,
    ") 路径长度=",
    冲锋距离,
    " 路径半径=",
    路径半径,
    " 伤害=200"
  );
}

function 前摇开始_播放施法动作(单位: any, 前摇ID: number): void {
  开始硬直(单位, 前摇时间);
  debugLogForce(模块名, "前摇开始：前摇ID=", 前摇ID, "先硬直，再由前摇模块零秒后播放动作=attack 硬直=", 前摇时间);
}

function 前摇结束_恢复待机动作(单位: any, 原因: string, 前摇ID: number): void {
  if (typeof SetUnitAnimationByIndex === "function") {
    SetUnitAnimationByIndex(单位, 0);
  }
  debugLogForce(模块名, "前摇结束：前摇ID=", 前摇ID, "原因=", 原因);
}

function on聊天1007测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const 前摇ID = 开始技能前摇(大法师, {
    持续时间: 前摇时间,
    施法动作名: "attack",
    创建提示特效: 冲锋路径前摇提示.创建提示特效,
    销毁提示特效: 冲锋路径前摇提示.销毁提示特效,
    开始回调: 前摇开始_播放施法动作,
    完成后执行: 执行冲锋路径斩杀,
    结束回调: 前摇结束_恢复待机动作,
  });

  if (前摇ID <= 0) {
    debugLogForce(模块名, "前摇启动失败");
    return;
  }

  debugLogForce(模块名, "已启动测试：前摇ID=", 前摇ID, "attack 1秒后执行冲锋路径斩杀");
}

function 注册聊天测试(): void {
  if (已注册) return;
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1007测试);

  debugLogForce(模块名, "已注册测试：输入", 测试命令, "触发 attack前摇1秒 + 冲锋路径斩杀");
}

注册聊天测试();

export {};
