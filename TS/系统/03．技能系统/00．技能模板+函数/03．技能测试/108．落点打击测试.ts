/** @noSelfInFile */
/**
 * 落点打击测试
 *
 * 输入"1008"后，以 `gg_unit_Hamg_0002` 前方矩形区域为范围，
 * 1.5秒后触发 3 段落雷，在前方 800、半宽 150 的矩形内随机，
 * 对 250 半径敌人造成 30 伤害，同一个单位最多命中 1 次。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 创建落点打击 } from "../01．技能函数/14．落点打击/index";

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

const 模块名 = "落点打击测试";
const 测试命令 = "1008";
const 矩形前方长度 = 800;
const 矩形半宽 = 150;
const 延迟时间 = 1.5;
const 落点数量 = 3;
const 落点间隔 = 0.3;
const 伤害半径 = 250;
const 伤害值 = 30;
let 已注册 = false;

function 取前方目标点X(单位: any, 距离: number): number {
  const 朝向 = GetUnitFacing(单位) * jass.bj_DEGTORAD;
  return GetUnitX(单位) + (Cos(朝向) as number) * 距离;
}

function 取前方目标点Y(单位: any, 距离: number): number {
  const 朝向 = GetUnitFacing(单位) * jass.bj_DEGTORAD;
  return GetUnitY(单位) + (Sin(朝向) as number) * 距离;
}

function 落点打击测试_单次生效(X: number, Y: number, 落点序号: number, 实例ID: number): void {
  debugLogForce(模块名, "落点生效：实例ID=", 实例ID, "序号=", 落点序号, "坐标=(", X, ",", Y, ")");
}

function 落点打击测试_命中(单位: any, 落点序号: number, 实例ID: number): void {
  debugLogForce(模块名, "命中单位：实例ID=", 实例ID, "序号=", 落点序号, "目标坐标=(", GetUnitX(单位), ",", GetUnitY(单位), ")");
}

function 落点打击测试_全部完成(实例ID: number): void {
  debugLogForce(模块名, "落点打击结束：实例ID=", 实例ID);
}

function on聊天1008测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const 朝向角 = GetUnitFacing(大法师);
  const 矩形中心X = 取前方目标点X(大法师, 矩形前方长度 * 0.5);
  const 矩形中心Y = 取前方目标点Y(大法师, 矩形前方长度 * 0.5);
  const 实例ID = 创建落点打击({
    X: 矩形中心X,
    Y: 矩形中心Y,
    延迟时间,
    伤害半径,
    提示半径: 伤害半径,
    伤害值,
    所有者: 大法师,
    影响目标: "敌方",
    落点数量,
    落点间隔,
    随机区域形状: "矩形",
    随机矩形长度: 矩形前方长度,
    随机矩形宽度: 矩形半宽 * 2,
    随机区域方向角: 朝向角,
    最小落点间距: 150,
    每单位最大命中次数: 1,
    on单次生效: 落点打击测试_单次生效,
    on单次命中: 落点打击测试_命中,
    on全部完成: 落点打击测试_全部完成,
  });

  if (实例ID <= 0) {
    debugLogForce(模块名, "落点打击创建失败");
    return;
  }

  debugLogForce(
    模块名,
    "已启动测试：实例ID=",
    实例ID,
    "矩形中心=(",
    矩形中心X,
    ",",
    矩形中心Y,
    ") 延迟=",
    延迟时间,
    " 数量=",
    落点数量,
    " 间隔=",
    落点间隔,
    " 前方长度=",
    矩形前方长度,
    " 半宽=",
    矩形半宽,
    " 伤害半径=",
    伤害半径,
    " 伤害=",
    伤害值
  );
}

function 注册聊天测试(): void {
  if (已注册) {
    return;
  }
  已注册 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天1008测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令, "触发延迟落雷打击");
}

注册聊天测试();

export {};
