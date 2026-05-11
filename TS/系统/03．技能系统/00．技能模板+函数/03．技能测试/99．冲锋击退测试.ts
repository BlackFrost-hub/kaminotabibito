/** @noSelfInFile */
/**
 * 冲锋/击退系统测试
 *
 * 开局 2 秒后，直接击退 `gg_unit_Hamg_0002` 一次。
 * 这是临时测试文件，后续不用时可直接移除并从 `index.ts` 取消导出。
 */

const jass = require("jass.common") as any;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;
const PauseUnit = jass.PauseUnit as (whichUnit: any, flag: boolean) => void;
const g = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (this: void, delaySec: number, callback: () => { id: number } | unknown) => unknown;
};

import { 开始击退 } from "../01．技能函数/02．冲锋·击退/index";

let 当前测试单位: any | undefined;

function 恢复测试单位暂停(): void {
  const 测试单位 = 当前测试单位;
  if (测试单位 != null && 测试单位 !== 0) {
    PauseUnit(测试单位, false);
  }
}

function 暂停测试单位(): void {
  const 测试单位 = 当前测试单位;
  if (测试单位 != null && 测试单位 !== 0) {
    PauseUnit(测试单位, true);
    createDelayedCall(0.03, 恢复测试单位暂停);
  }
}

function 执行冲锋击退测试(): void {
  const 测试单位 = g.gg_unit_Hamg_0002;
  if (测试单位 == null || 测试单位 === 0) {
    return;
  }

  当前测试单位 = 测试单位;
  const 击退角度 = GetUnitFacing(测试单位) + 180.0;

  开始击退(测试单位, {
    角度: 击退角度,
    距离: 1000,
    持续时间: 3.0,
    检查地形: true,
    朝向跟随位移: false,
    禁用碰撞: true,
  });

  createDelayedCall(1.8, 暂停测试单位);
}

const 启用测试 = false;

if (启用测试) {
  createDelayedCall(2.0, 执行冲锋击退测试);
}

export {};
