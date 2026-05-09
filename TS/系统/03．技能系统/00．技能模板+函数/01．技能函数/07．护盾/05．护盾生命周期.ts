/** @noSelfInFile */
/**
 * 护盾生命周期管理
 *
 * 职责：
 * - 使用中心计时器推进护盾剩余时间
 * - 处理护盾到期
 * - 处理单位死亡时清理护盾
 */

import { 护盾实例, 护盾类型 } from "./01．护盾类型";
import { 获取单位护盾实例列表, 删除护盾实例, 取句柄ID, 删除单位所有护盾, 获取所有活动护盾实例 } from "./02．护盾实例";
import { 删除护盾条 } from "./06．护盾条表现";
import { 显示护盾到期漂浮文字 } from "./08．护盾回调模板";

const jass = require("jass.common") as any;

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (callback: (dyingUnit: any, killingUnit: any) => void) => void;
};

// ==========================================================================================
// JASS 函数别名
// ==========================================================================================

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (u: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;

// ==========================================================================================
// 常量
// ==========================================================================================

const TICK_INTERVAL = 0.02; // 与充能系统一致，每2 tick = 0.02秒
const CENTER_TIMER_TICKS = 2;
const UNIT_ALIVE_LIFE = 0.405;

// ==========================================================================================
// 状态
// ==========================================================================================

let 已注册计时器 = false;
let tick计数 = 0;

// ==========================================================================================
// 工具函数
// ==========================================================================================

function 单位存活(u: any): boolean {
  if (u == null || u === 0) return false;
  if (GetUnitTypeId(u) === 0) return false;
  if (IsUnitType(u, jass.UNIT_TYPE_DEAD)) return false;
  return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

// ==========================================================================================
// 生命周期推进
// ==========================================================================================

function 处理护盾到期(实例: 护盾实例, 原因: "到期" | "单位死亡"): void {
  const 单位 = 实例.单位;

  // 删除实例
  删除护盾实例(实例.id);

  // 到期时自动显示漂浮文字
  if (原因 === "到期") {
    显示护盾到期漂浮文字(单位, 实例.类型);
  }

  // 触发到期回调
  if (原因 === "到期" && typeof 实例.到期回调 === "function") {
    实例.到期回调(单位, 实例.id);
  }

  // 触发结束回调
  if (typeof 实例.结束回调 === "function") {
    实例.结束回调(单位, 实例.id, 原因);
  }
}

function on护盾系统Tick(): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;

  // 收集需要处理的实例（避免遍历时修改）
  const 到期列表: { 实例: 护盾实例; 原因: "到期" | "单位死亡" }[] = [];

  // 遍历所有护盾
  const 活动护盾 = 获取所有活动护盾实例();
  for (const 实例 of 活动护盾) {
    // 检查单位是否存活
    if (!单位存活(实例.单位)) {
      到期列表.push({ 实例, 原因: "单位死亡" });
      continue;
    }

    // 推进时间（永久护盾跳过）
    if (实例.总持续时间 > 0) {
      实例.剩余时间 -= TICK_INTERVAL;
      if (实例.剩余时间 <= 0) {
        到期列表.push({ 实例, 原因: "到期" });
      }
    }
  }

  // 处理到期/死亡
  for (const { 实例, 原因 } of 到期列表) {
    处理护盾到期(实例, 原因);
  }
}

// ==========================================================================================
// 单位死亡处理
// ==========================================================================================

function on单位死亡(dyingUnit: any, _killingUnit: any): void {
  const 单位ID = 取句柄ID(dyingUnit);
  if (单位ID === 0) return;

  const 删除列表 = 删除单位所有护盾(单位ID);
  for (const 实例 of 删除列表) {
    if (typeof 实例.结束回调 === "function") {
      实例.结束回调(dyingUnit, 实例.id, "单位死亡");
    }
  }

  删除护盾条(dyingUnit);
}

// ==========================================================================================
// 初始化
// ==========================================================================================

let 已初始化 = false;

export function 初始化护盾生命周期(): void {
  if (已初始化) return;
  已初始化 = true;

  // 注册中心计时器
  if (!已注册计时器) {
    已注册计时器 = true;
    onTick10ms(on护盾系统Tick);
  }

  // 注册单位死亡事件
  registerDeathListener(on单位死亡);
}

export {};
