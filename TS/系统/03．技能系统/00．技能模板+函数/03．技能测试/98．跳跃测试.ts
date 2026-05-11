/** @noSelfInFile */
/**
 * Jump system temporary test.
 *
 * Flow:
 * 1. After 2s, make `gg_unit_Hamg_0002` jump once.
 * 2. After 1.8s, pause the unit.
 * 3. After 0.5s, unpause the unit.
 * 4. Verify jump resumes instead of ending.
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => unknown) => unknown;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (module: string, ...args: any[]) => void;
};

import { 开始跳跃 } from "../01．技能函数/03．跳跃·击飞/index";

const GetUnitFacing = jass["GetUnitFacing"] as (u: any) => number;
const PauseUnit = jass["PauseUnit"] as (u: any, flag: boolean) => void;

function runJumpTest(): void {
  debugLogForce("jump-test", "run");

  const testUnit = g.gg_unit_Hamg_0002;
  if (testUnit == null || testUnit === 0) {
    debugLogForce("jump-test", "unit-missing", "gg_unit_Hamg_0002");
    return;
  }

  const angle = GetUnitFacing(testUnit) + 180.0;
  debugLogForce("jump-test", "start-jump", "angle=" + angle);

  开始跳跃(testUnit, {
    角度: angle,
    距离: 1000,
    持续时间: 3.0,
    跳跃高度: 300,
    朝向跟随跳跃: false,
  });

  createDelayedCall(1.8, onPauseTestUnit);
}

function onPauseTestUnit(): void {
  const testUnit = g.gg_unit_Hamg_0002;
  if (testUnit == null || testUnit === 0) {
    return;
  }

  debugLogForce("jump-test", "pause");
  PauseUnit(testUnit, true);
  createDelayedCall(0.5, onResumeTestUnit);
}

function onResumeTestUnit(): void {
  const testUnit = g.gg_unit_Hamg_0002;
  if (testUnit == null || testUnit === 0) {
    return;
  }

  debugLogForce("jump-test", "resume");
  PauseUnit(testUnit, false);
}

const 启用测试 = true;

if (启用测试) {
  debugLogForce("jump-test", "loaded", "delay=2.0");
  createDelayedCall(4.0, runJumpTest);
}

export {};
