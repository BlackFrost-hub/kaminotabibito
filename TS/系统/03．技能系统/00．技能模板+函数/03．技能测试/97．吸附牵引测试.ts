/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 开始单位组牵引, type 牵引结束原因 } from "../01．技能函数/05．吸附·牵引/index";

const CreateGroup = jass["CreateGroup"] as () => any;
const GroupEnumUnitsInRange = jass["GroupEnumUnitsInRange"] as (whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const DestroyGroup = jass["DestroyGroup"] as (whichGroup: any) => void;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;

const 模块名 = "吸附牵引测试";
const 聊天命令 = "111";
const 最大牵引距离 = 600;

function 吸附牵引测试_结束回调(单位: any, 原因: 牵引结束原因, 牵引ID: number): void {
  debugLogForce(模块名, "牵引结束", "ID=", 牵引ID, " 原因=", 原因, " 单位=", 单位);
}

function 执行吸附测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const group = CreateGroup();
  GroupEnumUnitsInRange(group, GetUnitX(大法师), GetUnitY(大法师), 1000, null);
  开始单位组牵引(group, {
    中心单位: 大法师,
    每秒速度: 220,
    持续时间: 4.0,
    最小距离: 140,
    最大牵引距离,
    检查地形: true,
    禁用碰撞: true,
    暂停单位: false,
    朝向跟随牵引: true,
    外部暂停时中断: true,
    启用闪电效果: true,
    闪电效果代码: "CLPB",
    闪电高度: 60,
    结束回调: 吸附牵引测试_结束回调,
  });
  DestroyGroup(group);

  debugLogForce(模块名, "已开始测试", "输入=" + 聊天命令, " 最大牵引距离=", 最大牵引距离);
}

function on聊天111测试(): void {
  执行吸附测试();
}

注册聊天命令监听(聊天命令, on聊天111测试);
debugLogForce(模块名, "已注册聊天测试", "输入 " + 聊天命令 + " 开始");

export {};
