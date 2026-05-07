/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const Player = jass.Player as (id: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  player: any, x: number, y: number, duration: number, message: string
) => void;

const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => void) => void;
};
const { SFB_setBuff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setBuff: (this: void, sourceUnit: any, u: any, id: number, time: number) => void;
};

const 启用测试 = false;

function 调试输出(message: string, duration: number = 5): void {
  for (let pi = 0; pi < 4; pi++) {
    DisplayTimedTextToPlayer(Player(pi), 0, 0, duration, "[快速Buff测试] " + message);
  }
}

function 测试_眩晕目标(): void {
  const 目标单位 = g.gg_unit_Hamg_0002;

  if (目标单位 == null || 目标单位 === 0) {
    调试输出("错误: gg_unit_Hamg_0002 不存在！请检查地图中是否有该预置单位。", 10);
    return;
  }

  const 单位名 = GetUnitName(目标单位);
  const hid = GetHandleId(目标单位);
  const x = GetUnitX(目标单位);
  const y = GetUnitY(目标单位);

  调试输出("目标单位: " + 单位名 + " (handleId=" + hid + ", x=" + x.toFixed(1) + ", y=" + y.toFixed(1) + ")");
  调试输出("正在施加眩晕Buff (id=0, 持续3秒)...");

  SFB_setBuff(null, 目标单位, 0, 3.0);

  调试输出("眩晕Buff已施加！请观察单位是否被眩晕。");
}

if (启用测试) {
  调试输出("=== 快速Buff系统测试开始 ===");

  调试输出("将在 0.1 秒后对 gg_unit_Hamg_0002 施加眩晕...");
  createDelayedCall(0.1, 测试_眩晕目标);
}

export {};
