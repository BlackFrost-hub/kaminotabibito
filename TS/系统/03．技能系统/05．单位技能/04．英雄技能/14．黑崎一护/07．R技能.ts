/** @noSelfInFile */
// 黑崎一护 R：天锁斩月/解放（A01H）。30 秒卍解：移速 666、Q 强化、普攻缩减Q冷却、A键黑流牙突解锁。
// 源 JASS 真源：技能.j（A01H 段 811-835；卍解启动 Func006T 424-463；倒计时周期 Func008T 396-422）。
// 源 DYCultrams/DYCultramsoff（522 上限突破）迁移为项目移动速度突破系统；倒计时 TextTag 为本地表现不迁移。
// A键监听按玩家注册/注销（计划第 3 节），重复开启不叠加。

import { 黑崎一护技能配置 } from "./00．配置";
import { 获取或创建黑崎一护状态, 获取黑崎一护状态, 设置黑崎一护卍解, 解除黑崎一护A键武装, 武装黑崎一护A键 } from "./01．状态表";
import { 黑崎一护BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/09．黑崎一护";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 注册玩家黑流牙突A键 } from "./08．黑流牙突";

const jass = require("jass.common") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { SOS_SetUnitSpeed, SOS_UnSetUnitSpeed } = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统") as {
  SOS_SetUnitSpeed: (this: void, u: any, speed: number) => void;
  SOS_UnSetUnitSpeed: (this: void, u: any) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, p: any) => number;
const IsUnitAliveBJ = jass.IsUnitAliveBJ as (this: void, unit: any) => boolean;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;

interface R上下文 {
  施法者: any;
  已启动: boolean;
  倒计时回调ID: number;
  Tick数: number;
}

const R上下文表: Record<number, R上下文> = {};

function 获取或创建R上下文(this: void, unit: any): R上下文 {
  const id = GetHandleId(unit);
  let ctx = R上下文表[id];
  if (ctx == null) {
    ctx = { 施法者: unit, 已启动: false, 倒计时回调ID: 0, Tick数: 0 };
    R上下文表[id] = ctx;
  }
  return ctx;
}

function R可释放(this: void, context: R上下文, _caster: any): boolean {
  return context.已启动 !== true;
}

export function 结束卍解(this: void, caster: any): void {
  const record = 获取黑崎一护状态(caster);
  if (record == null || record.卍解 !== true) return;
  设置黑崎一护卍解(caster, false);
  解除黑崎一护A键武装(caster);
  if (record.移速已突破) {
    SOS_UnSetUnitSpeed(caster);
    record.移速已突破 = false;
  }
  const ctx = R上下文表[GetHandleId(caster)];
  if (ctx != null) {
    if (ctx.倒计时回调ID !== 0) removePeriodicCallback(ctx.倒计时回调ID);
    ctx.倒计时回调ID = 0;
    ctx.已启动 = false;
  }
}

function 推进卍解倒计时(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;

  ctx.Tick数 += 1;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster) || ctx.Tick数 >= Math.round(配置.R.持续秒 * 10)) {
    if (caster != null && caster !== 0) 结束卍解(caster);
    else if (ctx.倒计时回调ID !== 0) {
      removePeriodicCallback(ctx.倒计时回调ID);
      ctx.倒计时回调ID = 0;
      ctx.已启动 = false;
    }
  }
}

function 启动卍解(this: void, variable: any): void {
  const ctx = variable as R上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    ctx.已启动 = false;
    return;
  }

  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  设置黑崎一护卍解(caster, true);
  创建点特效({
    模型路径: 配置.R.卍解特效.模型,
    X: x,
    Y: y,
    Z: 配置.R.卍解特效.高度,
    面向角度: 270,
    缩放: 配置.R.卍解特效.缩放,
    持续秒: 配置.R.卍解特效.持续秒,
  });
  Sound3DII_CooPlayReuse(配置.R.卍解音效.路径, x, y, 0, 配置.R.卍解音效.裁断距离);
  registerManualBuff(caster, 黑崎一护BuffID.卍解, 配置.R.持续秒, 0);
  注册玩家黑流牙突A键(caster); // 首次注册后重复调用被忽略，不叠加监听（计划第 3 节）
  武装黑崎一护A键(caster); // 卍解期间 A 键可发起黑流牙突

  ctx.Tick数 = 0;
  ctx.倒计时回调ID = addPeriodicCallback(100, 推进卍解倒计时 as unknown as (this: void, variable?: any) => void, ctx);
}

function 释放解放(this: void, context: R上下文, caster: any, _技能实例ID?: number): void {
  // 卍解未结束时重复释放：先清理旧状态（源行为为直接覆盖）
  if (获取黑崎一护状态(caster)?.卍解 === true) 结束卍解(caster);

  context.施法者 = caster;
  context.已启动 = true;
  context.Tick数 = 0;

  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  Sound3DII_CooPlayReuse(配置.R.起手音效.路径, x, y, 0, 配置.R.起手音效.裁断距离);
  SOS_SetUnitSpeed(caster, 配置.R.移速);
  获取或创建黑崎一护状态(caster).移速已突破 = true;

  addDelayedCallback(
    Math.round(配置.R.卍解延迟秒 * 1000),
    启动卍解 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// ---------------------------------------------------------------------------
// 死亡清理与注册
// ---------------------------------------------------------------------------

let 死亡监听已注册 = false;

function R单位死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  if (jass.GetUnitTypeId(dyingUnit) !== 英雄单位类型ID) return;
  结束卍解(dyingUnit);
}

export function 注册黑崎一护R(this: void): void {
  注册单位技能壳监听({
    名称: "黑崎一护-天锁斩月（R）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.R.技能ID,
    获取或创建上下文: 获取或创建R上下文,
    可释放: R可释放,
    释放技能: 释放解放,
    创建独立技能实例: false,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(R单位死亡清理);
  }
}

注册黑崎一护R();

export {};
