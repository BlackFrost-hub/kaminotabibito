/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const Player = jass.Player as (id: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  player: any, x: number, y: number, duration: number, message: string
) => void;

const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => void;
};
const { SFB_setBuff, SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setBuff: (this: void, sourceUnit: any, u: any, id: number, time: number) => void;
  SFB_setSlow: (this: void, sourceUnit: any, u: any, as: number, ms: number, time: number) => void;
};

import { 创建区域效果 } from "./01．技能函数/04．区域效果/区域效果";

const 启用测试 = true;
let 当前测试单位: any | undefined;

function 显示区域测试文本(message: string, duration: number): void {
  DisplayTimedTextToPlayer(Player(0), 0, 0, duration, message);
}

function 区域效果测试_进入(单位: any): void {
  const 测试单位 = 当前测试单位;
  if (测试单位 == null || 测试单位 === 0 || 单位 == null || 单位 === 0 || 单位 === 测试单位) {
    return;
  }
  SFB_setSlow(测试单位, 单位, 0, 30, 1);
  显示区域测试文本("进入区域，减速1秒", 3);
}

function 区域效果测试_离开(单位: any): void {
  const 测试单位 = 当前测试单位;
  if (测试单位 == null || 测试单位 === 0 || 单位 == null || 单位 === 0 || 单位 === 测试单位) {
    return;
  }
  SFB_setBuff(测试单位, 单位, 0, 1);
  显示区域测试文本("离开区域，眩晕1秒", 3);
}

function 区域效果测试_销毁(): void {
  显示区域测试文本("区域效果已结束", 3);
}

function 区域效果测试_创建(): void {
  const 测试单位 = 当前测试单位;
  if (测试单位 == null || 测试单位 === 0) {
    return;
  }

  创建区域效果({
    X: GetUnitX(测试单位),
    Y: GetUnitY(测试单位),
    半径: 400,
    持续时间: 10,
    检测间隔: 1,
    影响目标: "全部",
    所有者: 测试单位,
    周期伤害: 50,
    on进入: 区域效果测试_进入,
    on离开: 区域效果测试_离开,
    on销毁: 区域效果测试_销毁,
  });

  显示区域测试文本("区域效果测试：完整效果已创建", 5);
}

if (启用测试) {
  const 测试单位 = g.gg_unit_Hamg_0002;
  if (测试单位) {
    当前测试单位 = 测试单位;
    createDelayedCall(2.0, 区域效果测试_创建);
  }
}

export {};
