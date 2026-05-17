/** @noSelfInFile */
/**
 * 贝塞尔显式改向测试
 *
 * 输入 "1193"：
 * - 发射一枚明显弯曲的贝塞尔弹幕。
 *
 * 输入 "1194"：
 * - 把当前弹幕切成直线，并在上一次测试目标角基础上继续 +135 度。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import {
  创建二阶贝塞尔加速度抛物线轨迹,
  创建原生弹幕,
  设置原生弹幕指定角度飞行,
  type 原生弹幕结束原因,
} from "../01．技能函数/01．弹幕/01．TS原生弹幕/index";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;

const 模块名 = "贝塞尔显式改向测试";
const 发射命令 = "133";
const 改向命令 = "134";

let 最近弹幕ID = 0;
let 最近测试目标面向 = 0;

function 投影X(this: void, x: number, angle: number, distance: number): number {
  return x + (Cos(angle * jass.bj_DEGTORAD) as number) * distance;
}

function 投影Y(this: void, y: number, angle: number, distance: number): number {
  return y + (Sin(angle * jass.bj_DEGTORAD) as number) * distance;
}

function on结束(this: void, 原因: 原生弹幕结束原因, 弹幕ID: number): void {
  debugLogForce(模块名, "结束", "弹幕ID=", 弹幕ID, "原因=", 原因);
  if (弹幕ID === 最近弹幕ID) {
    最近弹幕ID = 0;
    最近测试目标面向 = 0;
  }
}

function on聊天发射(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const face = GetUnitFacing(大法师);
  const startX = 投影X(GetUnitX(大法师), face, 80);
  const startY = 投影Y(GetUnitY(大法师), face, 80);
  const endX = 投影X(GetUnitX(大法师), face, 1000);
  const endY = 投影Y(GetUnitY(大法师), face, 1000);
  const controlX = 投影X(GetUnitX(大法师), face + 90, 520);
  const controlY = 投影Y(GetUnitY(大法师), face + 90, 520);

  const 实例 = 创建原生弹幕({
    所有者: 大法师,
    X: startX,
    Y: startY,
    方向角: face,
    速度: 0,
    生命周期: 10,
    模型: "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
    轨迹采样器: 创建二阶贝塞尔加速度抛物线轨迹(
      startX, startY, 60,
      controlX, controlY,
      endX, endY, 60,
      240,
      320,
    ),
    on结束,
  });

  最近弹幕ID = 实例.弹幕ID;
  最近测试目标面向 = face;
  debugLogForce(模块名, "已发射", "弹幕ID=", 最近弹幕ID, "输入", 改向命令, "可改向");
}

function on聊天改向(): void {
  if (最近弹幕ID <= 0) {
    debugLogForce(模块名, "当前无可改向弹幕，请先输入", 发射命令);
    return;
  }

  最近测试目标面向 += 135;
  const 新面向 = 最近测试目标面向;
  const ok = 设置原生弹幕指定角度飞行(最近弹幕ID, 新面向, 220);
  debugLogForce(模块名, "已显式改向", "弹幕ID=", 最近弹幕ID, "新面向=", 新面向, "成功=", ok);
}

注册聊天命令监听(发射命令, on聊天发射);
注册聊天命令监听(改向命令, on聊天改向);
debugLogForce(模块名, "已注册测试：", 发射命令, "发射；", 改向命令, "改向");

export {};
