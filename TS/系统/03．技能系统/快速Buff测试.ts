/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const Player = jass.Player as (id: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const CreateTimer = jass.CreateTimer as () => any;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, handler: () => void) => void;
const R2SW = jass.R2SW as (value: number, width: number, precision: number) => string;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  player: any, x: number, y: number, duration: number, message: string
) => void;

const { SFB_施加通用Buff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_施加通用Buff: (this: void, 来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 启用测试 = false;

function 调试输出(message: string, duration: number = 5): void {
  debugLogForce("快速Buff测试", message);
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

  调试输出("目标单位: " + 单位名 + " (handleId=" + hid + ", x=" + R2SW(x, 0, 1) + ", y=" + R2SW(y, 0, 1) + ")");
  调试输出("正在施加眩晕Buff (id=0, 持续3秒)...");

  SFB_施加通用Buff(目标单位, 目标单位, 0, 3.0);

  调试输出("眩晕Buff已施加！请观察单位是否被眩晕。");
}

function 启动快速Buff测试(): void {
  const t = GetExpiredTimer();
  if (t != null) DestroyTimer(t);

  调试输出("=== 快速Buff系统测试开始 ===");
  调试输出("正在对 gg_unit_Hamg_0002 施加眩晕...");
  测试_眩晕目标();
}

if (启用测试) {
  const 启动计时器 = CreateTimer();
  TimerStart(启动计时器, 1.0, false, 启动快速Buff测试);
}

export {};
