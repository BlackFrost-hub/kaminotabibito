/** @noSelfInFile */
/**
 * 原生弹幕直线测试
 *
 * 输入 "1011"：
 * - 从 gg_unit_Hamg_0002 前方 80 码发射 eaaa 默认弹幕马甲。
 * - 普通直线弹幕按单位当前面向推进。
 * - 穿透路径，对路径上的每个敌人最多造成一次伤害。
 * - 测试命中单位回调、到达目标点回调、结束回调。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 创建原生弹幕, type 原生弹幕结束原因 } from "../01．技能函数/01．弹幕/01．TS原生弹幕/index";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

const 模块名 = "原生弹幕直线测试";
const 测试命令 = "1011";

function 取前方X(this: void, 单位: any, 距离: number): number {
  const 朝向 = GetUnitFacing(单位) * jass.bj_DEGTORAD;
  return GetUnitX(单位) + (Cos(朝向) as number) * 距离;
}

function 取前方Y(this: void, 单位: any, 距离: number): number {
  const 朝向 = GetUnitFacing(单位) * jass.bj_DEGTORAD;
  return GetUnitY(单位) + (Sin(朝向) as number) * 距离;
}

function 直线弹幕_命中单位(this: void, 目标单位: any, 弹幕ID: number): void {
  debugLogForce(模块名, "命中单位", "弹幕ID=", 弹幕ID, "目标=", GetUnitName(目标单位), "#", GetHandleId(目标单位));
}

function 直线弹幕_到达目标点(this: void, 弹幕ID: number, 原因: "完成" | "距离结束"): void {
  debugLogForce(模块名, "到达目标点", "弹幕ID=", 弹幕ID, "原因=", 原因);
}

function 直线弹幕_结束(this: void, 原因: 原生弹幕结束原因, 弹幕ID: number): void {
  debugLogForce(模块名, "结束", "弹幕ID=", 弹幕ID, "原因=", 原因);
}

function on聊天1011测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const 起点X = 取前方X(大法师, 80);
  const 起点Y = 取前方Y(大法师, 80);
  const 实例 = 创建原生弹幕({
    所有者: 大法师,
    X: 起点X,
    Y: 起点Y,
    方向角: GetUnitFacing(大法师),
    速度: 650,
    最大距离: 900,
    命中半径: 96,
    碰撞消失: false,
    每单位最大命中次数: 1,
    伤害值: 35,
    伤害形态: "AOE",
    影响目标: "敌方",
    模型: "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
    飞行高度: 75,
    on命中单位: 直线弹幕_命中单位,
    on到达目标点: 直线弹幕_到达目标点,
    on结束: 直线弹幕_结束,
  });

  debugLogForce(模块名, "已发射直线弹幕", "弹幕ID=", 实例.弹幕ID, "起点=(", 起点X, ",", 起点Y, ")");
}

注册聊天命令监听(测试命令, on聊天1011测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "发射原生直线弹幕");

export {};
