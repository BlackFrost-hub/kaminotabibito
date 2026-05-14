/** @noSelfInFile */
/**
 * 动态扇形测试
 *
 * 输入"1006"后，以 `gg_unit_Hamg_0002` 当前朝向创建一个动态扇形波前，
 * 每 0.02 秒从近到远扫过一次，对扇形敌人各造成 100 伤害。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 创建动态扇形 } from "../01．技能函数/09．形状区域/index";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;

const 模块名 = "动态扇形测试";
const 测试命令 = "1006";

function on聊天1006测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  创建动态扇形({
    X: GetUnitX(大法师),
    Y: GetUnitY(大法师),
    方向角: GetUnitFacing(大法师),
    扇形角度: 90,
    起始半径: 0,
    结束半径: 512,
    变化时间: 1.0,
    检测间隔: 0.02,
    影响目标: "敌方",
    所有者: 大法师,
    伤害值: 100,
    只命中新增范围: true,
    允许重复命中: false,
    显示提示特效: true,
    on周期: 动态扇形测试_周期,
    on销毁: 动态扇形测试_销毁,
  });

  debugLogForce(模块名, "已创建动态扇形：90度，0→512，1秒，每个敌方单位100伤害");
}

function 动态扇形测试_周期(当前命中单位: any[], 当前半径: number, 上次半径: number): void {
  if (当前命中单位.length <= 0) {
    return;
  }
  debugLogForce(模块名, "周期命中：", 当前命中单位.length, "个单位，半径=", 上次半径, "→", 当前半径);
}

function 动态扇形测试_销毁(): void {
  debugLogForce(模块名, "动态扇形效果已结束");
}

注册聊天命令监听(测试命令, on聊天1006测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "触发动态扇形伤害");

export {};
