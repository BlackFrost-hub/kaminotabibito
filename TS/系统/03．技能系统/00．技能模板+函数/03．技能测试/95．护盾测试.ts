/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 开始护盾, 移除单位标签护盾, 查询单位总护盾值, 查询单位可显示护盾值, 护盾类型 } from "../01．技能函数/07．护盾/index";

const 模块名 = "护盾测试";
const 测试命令 = "1001";
const 火护盾标签 = "test_fire_shield";
const 暗护盾标签 = "test_dark_shield";
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const { 注册单位头顶血条 } = require("系统.09．表现系统.13．单位头顶血条.index") as {
  注册单位头顶血条: (this: void, unit: any) => void;
};

function on聊天1001测试(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  debugLogForce(模块名, "1001开始：调用注册单位头顶血条", "unit", GetHandleId(大法师));
  注册单位头顶血条(大法师);
  debugLogForce(模块名, "1001已调用注册单位头顶血条", "unit", GetHandleId(大法师));

  移除单位标签护盾(大法师, 火护盾标签);
  移除单位标签护盾(大法师, 暗护盾标签);

  // 大法师约 1100 血，使用小额火 + 暗护盾测试头顶血条属性护盾多色分段。
  开始护盾(大法师, {
    类型: 护盾类型.火,
    数值: 120,
    持续时间: 30,
    显示护盾条: true,
    标签: 火护盾标签,
  });

  开始护盾(大法师, {
    类型: 护盾类型.暗,
    数值: 160,
    持续时间: 30,
    显示护盾条: true,
    标签: 暗护盾标签,
  });

  const 总护盾 = 查询单位总护盾值(大法师);
  const 可显示护盾 = 查询单位可显示护盾值(大法师);
  debugLogForce(模块名, "当前护盾值:", "总护盾", 总护盾, "可显示护盾", 可显示护盾);
}

注册聊天命令监听(测试命令, on聊天1001测试);

export {};
