/** @noSelfInFile */
/**
 * Jump system test.
 *
 * 输入 "1098"：让大法师朝向跳跃1000距离，3秒持续，300高度
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 开始跳跃 } from "../01．技能函数/03．跳跃·击飞/index";

const GetUnitFacing = jass["GetUnitFacing"] as (u: any) => number;

const 模块名 = "跳跃测试";
const 测试命令 = "1098";

function on聊天测试(): void {
  const testUnit = g.gg_unit_Hamg_0002;
  if (testUnit == null || testUnit === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  const angle = GetUnitFacing(testUnit);
  debugLogForce(模块名, "开始跳跃", "角度=" + angle);

  开始跳跃(testUnit, {
    角度: angle,
    距离: 1000,
    持续时间: 3.0,
    跳跃高度: 300,
    朝向跟随跳跃: false,
  });
}

注册聊天命令监听(测试命令, on聊天测试);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "让大法师跳跃1000距离");

export {};
