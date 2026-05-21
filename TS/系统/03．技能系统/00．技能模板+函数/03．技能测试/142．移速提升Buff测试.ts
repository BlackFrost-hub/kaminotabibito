/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 施加移速提升Buff, 清除单位移速提升Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加移速提升Buff: (this: void, source: any, target: any, params: {
    持续时间: number;
    固定移速?: number;
    基础移速百分比?: number;
    当前移速百分比?: number;
  }) => boolean;
  清除单位移速提升Buff: (this: void, unit: any) => boolean;
};
const { 获取单位突破移速 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.03．移动速度") as {
  获取单位突破移速: (this: void, unit: any) => number;
};

const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (unit: any) => number;
const GetUnitMoveSpeed = jass.GetUnitMoveSpeed as (unit: any) => number;

const 模块名 = "移速提升Buff测试";
const 测试命令 = "1044";
const 清除命令 = "1045";
const 测试持续秒 = 5;

let 最近测试单位: any = null;
let 测试前当前移速 = 0;
let 测试前突破移速 = 0;

function 绝对值(this: void, value: number): number {
  return value < 0 ? -value : value;
}

function 记录单位移速(this: void, 标签: string, 单位: any): void {
  if (单位 == null || 单位 === 0) {
    debugLogForce(模块名, 标签, "单位无效");
    return;
  }
  debugLogForce(
    模块名,
    标签,
    "基础=", GetUnitDefaultMoveSpeed(单位),
    "当前=", GetUnitMoveSpeed(单位),
    "突破=", 获取单位突破移速(单位)
  );
}

function on移速提升Buff到期检查(this: void): void {
  const 单位 = 最近测试单位;
  if (单位 == null || 单位 === 0) return;

  const 当前移速 = GetUnitMoveSpeed(单位);
  const 突破移速 = 获取单位突破移速(单位);
  记录单位移速("到期后", 单位);

  if (绝对值(当前移速 - 测试前当前移速) <= 1 && 绝对值(突破移速 - 测试前突破移速) <= 1) {
    debugLogForce(模块名, "[PASS] 移速已回落", "当前=", 当前移速, "突破=", 突破移速);
  } else {
    debugLogForce(模块名, "[CHECK] 移速未回到测试前值，可能有其他移速效果", "测试前当前=", 测试前当前移速, "测试前突破=", 测试前突破移速);
  }
}

function on聊天1044移速提升测试(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  最近测试单位 = 大法师;
  测试前当前移速 = GetUnitMoveSpeed(大法师);
  测试前突破移速 = 获取单位突破移速(大法师);

  记录单位移速("施加前", 大法师);
  const ok = 施加移速提升Buff(大法师, 大法师, {
    持续时间: 测试持续秒,
    固定移速: 100,
    基础移速百分比: 0.5,
    当前移速百分比: 0.5,
  });
  debugLogForce(模块名, "施加结果=", ok, "持续秒=", 测试持续秒, "固定=100 基础%=0.5 当前%=0.5");
  记录单位移速("施加后", 大法师);
  addDelayedCallback((测试持续秒 * 1000) + 500, on移速提升Buff到期检查);
}

function on聊天1045清除移速提升(this: void): void {
  const 大法师 = g.gg_unit_Hamg_0002;
  if (大法师 == null || 大法师 === 0) {
    debugLogForce(模块名, "未找到 gg_unit_Hamg_0002");
    return;
  }

  const ok = 清除单位移速提升Buff(大法师);
  debugLogForce(模块名, "手动清除结果=", ok);
  记录单位移速("手动清除后", 大法师);
}

注册聊天命令监听(测试命令, on聊天1044移速提升测试);
注册聊天命令监听(清除命令, on聊天1045清除移速提升);
debugLogForce(模块名, "已注册测试：输入", 测试命令, "施加5秒移速提升，输入", 清除命令, "手动清除");

export {};
