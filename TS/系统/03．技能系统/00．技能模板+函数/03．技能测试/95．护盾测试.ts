/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (player: any, command: string) => void) => void;
};

import { 开始护盾, 查询单位总护盾值, 护盾类型 } from "../01．技能函数/07．护盾/index";

const 模块名 = "护盾测试";
const 测试命令 = "1001";

function on聊天1001测试(): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  // 3秒物理护盾100 + 30秒通用护盾200，系统自动显示漂浮文字
  开始护盾(大法师, {
    类型: 护盾类型.物理,
    数值: 100,
    持续时间: 3,
    显示护盾条: false,
  });

  开始护盾(大法师, {
    类型: 护盾类型.通用,
    数值: 200,
    持续时间: 30,
    显示护盾条: true,
  });

  const 总护盾 = 查询单位总护盾值(大法师);
  debugLogForce(模块名, "当前总护盾值:", 总护盾);
}

注册聊天命令监听(测试命令, on聊天1001测试);

export {};
