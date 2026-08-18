/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 创建咲夜单位壳, 安全移除单位壳, 单位存活, 获取咲夜现存飞刀, 播放咲夜单位音效, 播放咲夜坐标音效, 注册咲夜周期任务, 移除咲夜周期任务, type 咲夜飞刀控制器 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};

interface RR监听上下文 { 二段: boolean; }
interface RR候选 {
  施法者: any;
  序号: number;
  完美空间: boolean;
}
interface RR单位记录 {
  单位: any;
}
interface RR飞刀记录 {
  控制器: 咲夜飞刀控制器;
}
interface RR单位全局状态 {
  单位: any;
  原移动速度: number;
  原攻击间隔: number;
  缓速计数: number;
  完美计数: number;
}
interface RR飞刀全局状态 {
  控制器: 咲夜飞刀控制器;
  原速度: number;
  缓速计数: number;
  完美计数: number;
}
interface RR区域上下文 {
  施法者: any;
  世界单位: any;
  X: number;
  Y: number;
  来源: string;
  完美空间: boolean;
  Tick: number;
  周期ID: number;
  单位记录: Record<number, RR单位记录 | undefined>;
  飞刀记录: Record<number, RR飞刀记录 | undefined>;
  枚举组: any;
  已结束: boolean;
}

const RR候选表: Record<number, RR候选 | undefined> = {};
const 咲夜世界计数: Record<number, number | undefined> = {};
const RR单位全局状态表: Record<number, RR单位全局状态 | undefined> = {};
const RR飞刀全局状态表: Record<number, RR飞刀全局状态 | undefined> = {};
let RR候选自增序号 = 0;
const 攻击间隔状态 = jass.ConvertUnitState(0x25);
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitStateJapi = japi.SetUnitState as (this: void, unit: any, state: any, value: number) => void;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, duration: number, effect: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 十六夜咲夜BuffID } = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜") as {
  十六夜咲夜BuffID: { 个人空间时间缓速: string; 完美空间时间停止: string; 咲夜的世界: string };
};

export function 十六夜咲夜处于咲夜世界(this: void, caster: any): boolean {
  return caster != null && caster !== 0 && (咲夜世界计数[jass.GetHandleId(caster) as number] ?? 0) > 0;
}

function 获取RR一段上下文(this: void, _caster: any): RR监听上下文 { return { 二段: false }; }
function 获取RR二段上下文(this: void, _caster: any): RR监听上下文 { return { 二段: true }; }

function RR单位在区域(this: void, context: RR区域上下文, unit: any): boolean {
  const dx = jass.GetUnitX(unit) - context.X;
  const dy = jass.GetUnitY(unit) - context.Y;
  return dx * dx + dy * dy <= 800 * 800;
}

function RR刷新单位全局状态(this: void, state: RR单位全局状态): void {
  if (state.完美计数 > 0) {
    jass.SetUnitTimeScale(state.单位, 0);
    return;
  }
  if (state.缓速计数 > 0) {
    jass.SetUnitMoveSpeed(state.单位, state.原移动速度 * 0.5);
    if (state.原攻击间隔 > 0) SetUnitStateJapi(state.单位, 攻击间隔状态, state.原攻击间隔 * 2);
    jass.SetUnitTimeScale(state.单位, 0.5);
    return;
  }
  jass.SetUnitMoveSpeed(state.单位, state.原移动速度);
  if (state.原攻击间隔 > 0) SetUnitStateJapi(state.单位, 攻击间隔状态, state.原攻击间隔);
  jass.SetUnitTimeScale(state.单位, 1);
}

function RR进入单位(this: void, context: RR区域上下文, unit: any): void {
  const id = jass.GetHandleId(unit) as number;
  if (context.单位记录[id] != null) return;
  const record: RR单位记录 = { 单位: unit };
  context.单位记录[id] = record;
  let global = RR单位全局状态表[id];
  if (global == null) {
    global = { 单位: unit, 原移动速度: jass.GetUnitMoveSpeed(unit), 原攻击间隔: GetUnitStateJapi(unit, 攻击间隔状态), 缓速计数: 0, 完美计数: 0 };
    RR单位全局状态表[id] = global;
  }
  if (context.完美空间) {
    global.完美计数 += 1;
    添加单位暂停(unit, context.来源);
    registerManualBuff(unit, 十六夜咲夜BuffID.完美空间时间停止, 5.2, 0, { sourceUnit: context.施法者 });
  } else {
    global.缓速计数 += 1;
    registerManualBuff(unit, 十六夜咲夜BuffID.个人空间时间缓速, 5.2, 0, { sourceUnit: context.施法者 });
  }
  RR刷新单位全局状态(global);
}

function RR离开单位(this: void, context: RR区域上下文, record: RR单位记录): void {
  const id = jass.GetHandleId(record.单位) as number;
  const global = RR单位全局状态表[id];
  if (context.完美空间) {
    移除单位暂停(record.单位, context.来源);
    if (global != null) global.完美计数 = Math.max(0, global.完美计数 - 1);
  } else if (global != null) global.缓速计数 = Math.max(0, global.缓速计数 - 1);
  if (global != null) {
    RR刷新单位全局状态(global);
    if (global.完美计数 <= 0) 移除单位指定Buff(record.单位, 十六夜咲夜BuffID.完美空间时间停止);
    if (global.缓速计数 <= 0) 移除单位指定Buff(record.单位, 十六夜咲夜BuffID.个人空间时间缓速);
    if (global.完美计数 <= 0 && global.缓速计数 <= 0) delete RR单位全局状态表[id];
  }
  delete context.单位记录[id];
}

function RR进入飞刀(this: void, context: RR区域上下文, knife: 咲夜飞刀控制器): void {
  const id = jass.GetHandleId(knife.单位) as number;
  if (context.飞刀记录[id] != null) return;
  const record: RR飞刀记录 = { 控制器: knife };
  context.飞刀记录[id] = record;
  let global = RR飞刀全局状态表[id];
  if (global == null) {
    global = { 控制器: knife, 原速度: knife.取每Tick位移(), 缓速计数: 0, 完美计数: 0 };
    RR飞刀全局状态表[id] = global;
  }
  if (context.完美空间) {
    global.完美计数 += 1;
    添加单位暂停(knife.单位, context.来源);
  } else {
    global.缓速计数 += 1;
    knife.设置每Tick位移(global.原速度 * 0.4);
  }
}

function RR离开飞刀(this: void, context: RR区域上下文, record: RR飞刀记录): void {
  const id = jass.GetHandleId(record.控制器.单位) as number;
  const global = RR飞刀全局状态表[id];
  if (context.完美空间) {
    移除单位暂停(record.控制器.单位, context.来源);
    if (global != null) global.完美计数 = Math.max(0, global.完美计数 - 1);
  } else if (global != null) global.缓速计数 = Math.max(0, global.缓速计数 - 1);
  if (global != null) {
    if (global.缓速计数 > 0) record.控制器.设置每Tick位移(global.原速度 * 0.4);
    else record.控制器.设置每Tick位移(global.原速度);
    if (global.完美计数 <= 0 && global.缓速计数 <= 0) delete RR飞刀全局状态表[id];
  }
  delete context.飞刀记录[id];
}

function 结束RR区域(this: void, context: RR区域上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.周期ID !== 0) 移除咲夜周期任务(context.周期ID);
  for (const key in context.单位记录) {
    const record = context.单位记录[key as unknown as number];
    if (record != null) RR离开单位(context, record);
  }
  for (const key in context.飞刀记录) {
    const record = context.飞刀记录[key as unknown as number];
    if (record != null) RR离开飞刀(context, record);
  }
  if (context.完美空间) {
    const id = jass.GetHandleId(context.施法者) as number;
    const count = 咲夜世界计数[id] ?? 0;
    if (count <= 1) delete 咲夜世界计数[id];
    else 咲夜世界计数[id] = count - 1;
    if (count <= 1) 移除单位指定Buff(context.施法者, 十六夜咲夜BuffID.咲夜的世界);
  }
  if (context.枚举组 != null && context.枚举组 !== 0) jass.DestroyGroup(context.枚举组);
  安全移除单位壳(context.世界单位);
  播放咲夜坐标音效("gg_snd_BlinkBirth1", context.X, context.Y);
}

function 推进RR区域(this: void, variable?: any): void {
  const context = variable as RR区域上下文 | undefined;
  if (context == null || context.已结束) return;
  context.Tick += 1;
  if (!单位存活(context.施法者) || context.Tick >= 50) {
    结束RR区域(context);
    return;
  }
  const inside: Record<number, boolean | undefined> = {};
  jass.GroupClear(context.枚举组);
  jass.GroupEnumUnitsInRange(context.枚举组, context.X, context.Y, 800, null);
  while (true) {
    const unit = jass.FirstOfGroup(context.枚举组);
    if (unit == null || unit === 0) break;
    jass.GroupRemoveUnit(context.枚举组, unit);
    if (unit === context.施法者 || unit === context.世界单位 || !单位存活(unit) || jass.IsUnitType(unit, jass.UNIT_TYPE_TAUREN)) continue;
    inside[jass.GetHandleId(unit) as number] = true;
    RR进入单位(context, unit);
  }
  for (const key in context.单位记录) {
    const record = context.单位记录[key as unknown as number];
    if (record != null && inside[jass.GetHandleId(record.单位) as number] !== true) RR离开单位(context, record);
  }
  const knives = 获取咲夜现存飞刀(context.施法者, context.X, context.Y, 800);
  const knifeInside: Record<number, boolean | undefined> = {};
  for (let i = 0; i < knives.length; i++) {
    knifeInside[jass.GetHandleId(knives[i].单位) as number] = true;
    RR进入飞刀(context, knives[i]);
  }
  for (const key in context.飞刀记录) {
    const record = context.飞刀记录[key as unknown as number];
    if (record != null && knifeInside[jass.GetHandleId(record.控制器.单位) as number] !== true) RR离开飞刀(context, record);
  }
}

function 启动RR区域(this: void, caster: any, perfect: boolean, sequence: number): void {
  const x = jass.GetUnitX(caster) as number;
  const y = jass.GetUnitY(caster) as number;
  const world = 创建咲夜单位壳(caster, 配置.单位壳.咲夜的世界, x, y, 0);
  if (world == null || world === 0) return;
  jass.SetUnitScale(world, 1, 1, 1);
  if (!perfect) jass.SetUnitVertexColor(world, 255, 255, 125, 255);
  else {
    const id = jass.GetHandleId(caster) as number;
    咲夜世界计数[id] = (咲夜世界计数[id] ?? 0) + 1;
    registerManualBuff(caster, 十六夜咲夜BuffID.咲夜的世界, 5.2, 0, { sourceUnit: caster });
  }
  const context: RR区域上下文 = {
    施法者: caster,
    世界单位: world,
    X: x,
    Y: y,
    来源: `十六夜咲夜-RR:${sequence}`,
    完美空间: perfect,
    Tick: 0,
    周期ID: 0,
    单位记录: {},
    飞刀记录: {},
    枚举组: jass.CreateGroup(),
    已结束: false,
  };
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RR", caster);
  播放咲夜坐标音效(perfect ? "gg_snd_PossessionMissileHit1" : "gg_snd_FlameStrikeTargetWaveNonLoop1", x, y);
  推进RR区域(context);
  context.周期ID = 注册咲夜周期任务(100, 推进RR区域, context);
}

function 结算RR候选(this: void, variable?: any): void {
  const candidate = variable as RR候选 | undefined;
  if (candidate == null) return;
  const id = jass.GetHandleId(candidate.施法者) as number;
  if (RR候选表[id] !== candidate) return;
  delete RR候选表[id];
  if (单位存活(candidate.施法者)) 启动RR区域(candidate.施法者, candidate.完美空间, candidate.序号);
}

function 释放RR(this: void, listener: RR监听上下文, caster: any): void {
  const id = jass.GetHandleId(caster) as number;
  if (listener.二段) {
    const candidate = RR候选表[id];
    if (candidate != null) candidate.完美空间 = true;
    return;
  }
  RR候选自增序号 += 1;
  const candidate: RR候选 = { 施法者: caster, 序号: RR候选自增序号, 完美空间: false };
  RR候选表[id] = candidate;
  addDelayedCallback(600, 结算RR候选, candidate);
}

export function 注册十六夜咲夜RR(this: void): void {
  注册单位技能壳监听({ 名称: "十六夜咲夜-个人空间（RR）", 单位类型ID: 配置.英雄单位类型ID, 技能ID: 配置.技能.RR.类型ID, 获取或创建上下文: 获取RR一段上下文, 释放技能: 释放RR, 创建独立技能实例: false });
  注册单位技能壳监听({ 名称: "十六夜咲夜-完美空间（RR二段）", 单位类型ID: 配置.英雄单位类型ID, 技能ID: 配置.技能.RR.二段类型ID, 获取或创建上下文: 获取RR二段上下文, 释放技能: 释放RR, 创建独立技能实例: false });
}

注册十六夜咲夜RR();

export {};
