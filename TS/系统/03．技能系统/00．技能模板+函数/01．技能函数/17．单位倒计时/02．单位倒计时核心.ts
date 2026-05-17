/** @noSelfInFile */
/**
 * 单位倒计时系统 - 核心逻辑
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { onTick10ms, offTick10ms, addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { YDUserDataSet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataSet: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string, value: any) => void;
};
const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import type { 单位倒计时实例, 规范化单位倒计时参数 } from "./01．类型";

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitPaused = jass.IsUnitPaused as (unit: any) => boolean;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const R2I = jass.R2I as (value: number) => number;
const DzBindEffect = japi.DzBindEffect as (widget: any, attachPoint: string, effect: any) => void;
const DzUnbindEffect = japi.DzUnbindEffect as (effect: any) => void;
const DzGetColor = japi.DzGetColor as (alpha: number, red: number, green: number, blue: number) => number;
const DzSetEffectVertexColor = japi.DzSetEffectVertexColor as (effect: any, color: number) => void;
const DzSetEffectVisible = japi.DzSetEffectVisible as (effect: any, enable: boolean) => void;
const DzSetEffectScale = japi.DzSetEffectScale as (effect: any, scale: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;

const 模块名 = "单位倒计时";
const 倒计时特效模型 = "resource\\models\\Common\\Progressbar.mdx";
const 倒计时特效绑定点 = "overhead";
const 倒计时周期秒 = 0.01;
const 默认特效Z = 250.0;
const 默认特效朝向 = 270.0;
const 默认特效缩放 = 1.0;
const 默认特效速度 = 1.0;
const 强化2效果ID = 2;
const 强化召唤缩放 = 2.0;
const 原单位延迟击杀毫秒 = 100;
const 倒计时特效延迟销毁毫秒 = 10;

let 下一个单位倒计时ID = 0;
let 已注册中心计时器 = false;
const 倒计时实例表: Record<number, 单位倒计时实例 | undefined> = {};
const 倒计时实例ID表: number[] = [];
const 单位到倒计时ID表: Record<number, number | undefined> = {};
const 延迟击杀单位队列: any[] = [];

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 单位已死亡(this: void, unit: any): boolean {
  if (!单位有效(unit)) return true;
  return IsUnitType(unit, UNIT_TYPE_DEAD);
}

function 删除实例ID(this: void, 实例ID: number): void {
  const index = 倒计时实例ID表.indexOf(实例ID);
  if (index >= 0) 倒计时实例ID表.splice(index, 1);
}

function 尝试关闭中心计时器(this: void): void {
  if (!已注册中心计时器) return;
  if (倒计时实例ID表.length > 0) return;
  已注册中心计时器 = false;
  offTick10ms(驱动单位倒计时);
}

function 确保中心计时器(this: void): void {
  if (已注册中心计时器) return;
  已注册中心计时器 = true;
  onTick10ms(驱动单位倒计时);
}

const 待延迟销毁特效队列: any[] = [];

function on延迟销毁特效(this: void): void {
  const effect = 待延迟销毁特效队列.shift();
  if (effect == null || effect === 0) return;
  DestroyEffect(effect);
}

function 销毁倒计时特效(this: void, effect: any): void {
  if (effect == null || effect === 0) return;
  DzUnbindEffect(effect);
  DzSetEffectVisible(effect, false);
  DzSetEffectScale(effect, 0);
  待延迟销毁特效队列.push(effect);
  addDelayedCallback(10, on延迟销毁特效);
}

function 限制到颜色字节(this: void, value: number): number {
  if (value <= 0) return 0;
  if (value >= 255) return 255;
  return R2I(value);
}

function 设置倒计时特效颜色(this: void, effect: any, 参数: 规范化单位倒计时参数): void {
  if (effect == null || effect === 0) return;
  const color = DzGetColor(
    限制到颜色字节(参数.透明度),
    限制到颜色字节(参数.红),
    限制到颜色字节(参数.绿),
    限制到颜色字节(参数.蓝)
  );
  DzSetEffectVertexColor(effect, color);
}

function 结束单位倒计时实例(this: void, 实例ID: number, 是否到期: boolean): void {
  const 实例 = 倒计时实例表[实例ID];
  if (实例 == null) return;

  倒计时实例表[实例ID] = undefined;
  单位到倒计时ID表[实例.单位句柄ID] = undefined;
  删除实例ID(实例ID);
  销毁倒计时特效(实例.倒计时特效);

  if (是否到期 && 单位有效(实例.单位)) {
    YDUserDataSet("unit", 实例.单位, "Expire", "boolean", true);
    分发单位倒计时到期效果(实例);
  }

  尝试关闭中心计时器();
}

function 执行强化2到期效果(this: void, 实例: 单位倒计时实例): void {
  if (!单位有效(实例.单位)) return;
  if (实例.强化单位类型 == null || 实例.强化单位类型 === 0 || 实例.强化单位类型 === "") {
    debugLogForce(模块名, "强化2跳过：PowerUPunitType 无效");
    return;
  }

  const 召唤物 = 创建召唤物({
    主人单位: 实例.单位,
    单位类型: 实例.强化单位类型,
    X: GetUnitX(实例.单位),
    Y: GetUnitY(实例.单位),
    缩放: 强化召唤缩放,
    持续时间: 实例.强化持续时间,
    模型文件: 实例.强化模型,
    生命值: 实例.强化生命值,
  });

  if (召唤物 != null && 召唤物 !== 0) {
    YDUserDataSet("unit", 实例.单位, "PowerUPUnit", "unit", 召唤物);
  }

  延迟击杀单位队列.push(实例.单位);
  addDelayedCallback(原单位延迟击杀毫秒, on单位倒计时延迟击杀原单位);
}

function 分发单位倒计时到期效果(this: void, 实例: 单位倒计时实例): void {
  if (实例.到期效果ID === 强化2效果ID) {
    执行强化2到期效果(实例);
  }
}

function 推进单个单位倒计时(this: void, 实例: 单位倒计时实例): void {
  if (单位已死亡(实例.单位)) {
    结束单位倒计时实例(实例.ID, false);
    return;
  }

  if (IsUnitPaused(实例.单位)) return;

  实例.已经过时间 += 倒计时周期秒;

  if (实例.已经过时间 >= 实例.持续时间) {
    结束单位倒计时实例(实例.ID, true);
  }
}

function 驱动单位倒计时(this: void): void {
  let index = 0;
  while (index < 倒计时实例ID表.length) {
    const 实例ID = 倒计时实例ID表[index];
    const 实例 = 倒计时实例表[实例ID];
    if (实例 != null) {
      推进单个单位倒计时(实例);
    }
    if (倒计时实例ID表[index] === 实例ID) {
      index++;
    }
  }
}

function on单位倒计时延迟击杀原单位(this: void): void {
  const unit = 延迟击杀单位队列.shift();
  if (!单位有效(unit)) return;
  KillUnit(unit);
}

export function 启动单位倒计时核心(this: void, 参数: 规范化单位倒计时参数): number {
  if (!单位有效(参数.单位)) return 0;
  if (!(参数.持续时间 > 0)) return 0;

  const unitHid = GetHandleId(参数.单位);
  const oldId = 单位到倒计时ID表[unitHid];
  if (oldId != null && oldId !== 0) {
    结束单位倒计时实例(oldId, false);
  }

  const effect = EC_CreateEffect(
    倒计时特效模型,
    参数.X,
    参数.Y,
    默认特效Z,
    默认特效朝向,
    默认特效缩放,
    默认特效速度,
    -1
  );
  if (effect != null && effect !== 0) {
    设置倒计时特效颜色(effect, 参数);
    DzBindEffect(参数.单位, 倒计时特效绑定点, effect);
  }

  const id = ++下一个单位倒计时ID;
  倒计时实例表[id] = {
    ID: id,
    单位: 参数.单位,
    单位句柄ID: unitHid,
    持续时间: 参数.持续时间,
    已经过时间: 0,
    到期效果ID: 参数.到期效果ID,
    倒计时特效: effect,
    红: 参数.红,
    绿: 参数.绿,
    蓝: 参数.蓝,
    透明度: 参数.透明度,
    强化持续时间: 参数.强化持续时间,
    强化生命值: 参数.强化生命值,
    强化模型: 参数.强化模型,
    强化单位类型: 参数.强化单位类型,
  };
  单位到倒计时ID表[unitHid] = id;
  倒计时实例ID表.push(id);
  确保中心计时器();
  return id;
}

export function 取消单位倒计时(this: void, unit: any): void {
  if (!单位有效(unit)) return;
  const id = 单位到倒计时ID表[GetHandleId(unit)];
  if (id != null && id !== 0) {
    结束单位倒计时实例(id, false);
  }
}
