/** @noSelfInFile */
/**
 * 回旋回收弹幕测试
 *
 * 输入 "1015"：
 * - 从 gg_unit_Hamg_0002 面向方向发射回旋弹幕。
 * - 去程和回程分别造成伤害，最终回调打印结束。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 创建回旋回收弹幕 } from "../01．技能函数/01．弹幕/03．回旋回收/index";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;

const 模块名 = "回旋回收弹幕测试";
const 测试命令 = "1015";

function 回旋回收_结束(this: void): void {
  debugLogForce(模块名, "回旋回收弹幕完整结束");
}

function on聊天1015测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  创建回旋回收弹幕({
    施法者: 大法师,
    距离: 850,
    速度: 620,
    曲线偏移: 260,
    命中半径: 110,
    去程伤害: 40,
    回程伤害: 65,
    去程每单位最大命中次数: 1,
    回程每单位最大命中次数: 1,
    回程锁定施法者: true,
    模型: "Abilities\\Spells\\Human\\StormBolt\\StormBoltMissile.mdl",
    on结束: 回旋回收_结束,
  });

  debugLogForce(模块名, "已发射回旋回收弹幕", "起点=(", GetUnitX(大法师), ",", GetUnitY(大法师), ")");
}

注册聊天命令监听(测试命令, on聊天1015测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "发射回旋回收弹幕");

export {};
