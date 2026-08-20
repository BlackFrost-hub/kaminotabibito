/** @noSelfInFile */
// 黑崎一护 D：瞬步（A01I）。灵压缩放距离的位移技能，开启 2 秒连携窗口；可飞向未结束的月牙。
// 源 JASS 真源：技能.j（A01I 段 836-865；连携关闭 Func010T 465-481）。
// 源 YDWETimerPatternRushSlide 迁移为项目冲锋封装（含地形检查，计划第 4 节禁止无条件 SetUnitX/Y）。
// 5% 最大魔法消耗由统一魔耗系统处理，技能文件不重复扣除（计划第 4 节）。

import { 黑崎一护技能配置 } from "./00．配置";
import { 获取或创建黑崎一护状态, 开启瞬步连携, 关闭瞬步连携, 月牙是否飞行中 } from "./01．状态表";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 秒转毫秒 } from "../../../00．技能模板+函数/02．通用函数/24．整数与时间换算";

const jass = require("jass.common") as any;

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (this: void, x: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;

interface D上下文 {
  连携窗口回调ID: number;
}

const D上下文表: Record<number, D上下文> = {};

function 获取或创建D上下文(this: void, unit: any): D上下文 {
  const id = GetHandleId(unit);
  let ctx = D上下文表[id];
  if (ctx == null) {
    ctx = { 连携窗口回调ID: 0 };
    D上下文表[id] = ctx;
  }
  return ctx;
}

function 关闭瞬步连携窗口(this: void, variable: any): void {
  const unit = variable as any;
  if (unit == null || unit === 0) return;
  关闭瞬步连携(unit);
  const ctx = D上下文表[GetHandleId(unit)];
  if (ctx != null) ctx.连携窗口回调ID = 0;
}

function 释放瞬步(this: void, context: D上下文, caster: any, _技能实例ID?: number): void {
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  Sound3DII_CooPlayReuse(配置.D.音效.路径, x, y, 0, 配置.D.音效.裁断距离);

  const 最大魔法 = GetUnitState(caster, UNIT_STATE_MAX_MANA);
  const 瞬步距离 = 配置.D.基础距离 + (最大魔法 / 1000) * 配置.D.每千魔法加成距离;

  let 目标X: number;
  let 目标Y: number;
  const record = 获取或创建黑崎一护状态(caster);
  if (月牙是否飞行中(caster)) {
    // 源：月牙天冲尚未结束时，瞬步飞向月牙当前位置（无法越过地形由冲锋封装保证）
    目标X = record.月牙X;
    目标Y = record.月牙Y;
  } else {
    const tx = GetSpellTargetX();
    const ty = GetSpellTargetY();
    const dx = tx - x;
    const dy = ty - y;
    // 源与技能说明：目标点只决定方向，始终瞬步完整距离。
    const 角度 = Atan2(dy, dx) * bj_RADTODEG;
    目标X = x + MathCos(角度) * 瞬步距离;
    目标Y = y + MathSin(角度) * 瞬步距离;
  }

  const 位移X = 目标X - x;
  const 位移Y = 目标Y - y;
  const 实际位移距离 = SquareRoot(位移X * 位移X + 位移Y * 位移Y);

  开始冲锋(caster, {
    目标X,
    目标Y,
    距离: 实际位移距离,
    持续时间: 配置.D.冲锋持续时间秒,
    检查地形: true,
    禁用碰撞: true,
  });

  // 源：瞬步后 2 秒连携窗口
  开启瞬步连携(caster);
  if (context.连携窗口回调ID !== 0) removeDelayedCallback(context.连携窗口回调ID);
  context.连携窗口回调ID = addDelayedCallback(
    秒转毫秒(配置.D.连携窗口秒),
    关闭瞬步连携窗口 as unknown as (this: void, variable?: any) => void,
    caster,
  );
}

const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;

function MathCos(this: void, 角度: number): number {
  return Cos(角度 * bj_DEGTORAD);
}

function MathSin(this: void, 角度: number): number {
  return Sin(角度 * bj_DEGTORAD);
}

export function 注册黑崎一护D(this: void): void {
  注册单位技能壳监听({
    名称: "黑崎一护-瞬步（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.D.技能ID,
    获取或创建上下文: 获取或创建D上下文,
    释放技能: 释放瞬步,
    创建独立技能实例: false,
  });
}

注册黑崎一护D();

export {};
