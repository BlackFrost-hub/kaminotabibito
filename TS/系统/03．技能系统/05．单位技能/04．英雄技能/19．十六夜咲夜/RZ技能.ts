/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 两点角度, 极坐标X, 极坐标Y, 单位存活, 播放咲夜单位音效 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { registerSyncHardwareKey } = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (this: void, key: number, status: number, callback: (this: void, event: { player: any }) => void) => any;
};
const { KEY, KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY: { Z: number };
  KEY_STATE: { DOWN: number };
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 执行战斗自身传送到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};

interface RZ监听上下文 { 占位: boolean; }
interface RZ上下文 {
  施法者: any;
  目标: any;
  序号: number;
  来源: string;
  原X: number;
  原Y: number;
  保持原位: boolean;
  输入开放: boolean;
  已结束: boolean;
  冻结单位: any[];
}

const RZ活动表: Record<number, RZ上下文 | undefined> = {};
let RZ序号 = 0;

function 获取RZ监听上下文(this: void, _caster: any): RZ监听上下文 { return { 占位: true }; }

function RZ解除冻结(this: void, context: RZ上下文): void {
  for (let i = 0; i < context.冻结单位.length; i++) 移除单位暂停(context.冻结单位[i], context.来源);
  context.冻结单位 = [];
}

function RZ关闭输入(this: void, variable?: any): void {
  const context = variable as RZ上下文 | undefined;
  if (context == null) return;
  context.输入开放 = false;
  const playerId = jass.GetPlayerId(jass.GetOwningPlayer(context.施法者)) as number;
  if (RZ活动表[playerId] === context) delete RZ活动表[playerId];
}

function RZ第一阶段(this: void, variable?: any): void {
  const context = variable as RZ上下文 | undefined;
  if (context == null || context.已结束 || !单位存活(context.施法者) || !单位存活(context.目标)) return;
  const targetFacing = jass.GetUnitFacing(context.目标) as number;
  const landingX = 极坐标X(jass.GetUnitX(context.目标), 配置.RZ.目标偏移, targetFacing + 75);
  const landingY = 极坐标Y(jass.GetUnitY(context.目标), 配置.RZ.目标偏移, targetFacing + 75);
  执行战斗自身传送到坐标(context.施法者, landingX, landingY);
  const facing = 两点角度(landingX, landingY, jass.GetUnitX(context.目标), jass.GetUnitY(context.目标));
  jass.SetUnitFacing(context.施法者, context.保持原位 ? facing : targetFacing);
  jass.SetUnitAnimation(context.施法者, context.保持原位 ? "attack" : "spell");
}

function RZ交换结算(this: void, variable?: any): void {
  const context = variable as RZ上下文 | undefined;
  if (context == null || context.已结束) return;
  context.已结束 = true;
  RZ解除冻结(context);
  if (单位存活(context.目标)) {
    jass.SetUnitX(context.目标, context.原X);
    jass.SetUnitY(context.目标, context.原Y);
  }
  if (!context.保持原位 && 单位存活(context.施法者)) 执行战斗自身传送到坐标(context.施法者, context.原X, context.原Y);
  移除单位暂停(context.施法者, context.来源);
  jass.SetUnitTimeScale(context.施法者, 1);
  jass.SetUnitAnimation(context.施法者, "stand");
}

function onRZ同步Z键(this: void, event: { player: any }): void {
  if (event.player == null || event.player === 0) return;
  const context = RZ活动表[jass.GetPlayerId(event.player) as number];
  if (context != null && context.输入开放 && !context.已结束 && jass.GetOwningPlayer(context.施法者) === event.player) context.保持原位 = true;
}

function 释放十六夜咲夜RZ(this: void, _listener: RZ监听上下文, caster: any): void {
  const target = jass.GetSpellTargetUnit();
  if (!单位存活(target)) return;
  RZ序号 += 1;
  const context: RZ上下文 = {
    施法者: caster,
    目标: target,
    序号: RZ序号,
    来源: `十六夜咲夜-RZ:${RZ序号}`,
    原X: jass.GetUnitX(caster),
    原Y: jass.GetUnitY(caster),
    保持原位: false,
    输入开放: true,
    已结束: false,
    冻结单位: [],
  };
  const group = jass.CreateGroup();
  jass.GroupEnumUnitsInRange(group, jass.GetUnitX(target), jass.GetUnitY(target), 配置.RZ.时停半径, null);
  while (true) {
    const unit = jass.FirstOfGroup(group);
    if (unit == null || unit === 0) break;
    jass.GroupRemoveUnit(group, unit);
    if (unit === caster || !单位存活(unit) || jass.IsUnitType(unit, jass.UNIT_TYPE_TAUREN)) continue;
    添加单位暂停(unit, context.来源);
    context.冻结单位.push(unit);
  }
  jass.DestroyGroup(group);
  添加单位暂停(caster, context.来源);
  jass.SetUnitAnimation(caster, "spell");
  RZ活动表[jass.GetPlayerId(jass.GetOwningPlayer(caster)) as number] = context;
  播放咲夜单位音效("gg_snd_ManaShieldCaster1", caster);
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RZ", caster);
  addDelayedCallback(配置.RZ.第一阶段秒 * 1000, RZ第一阶段, context);
  addDelayedCallback(配置.RZ.交换结算秒 * 1000, RZ交换结算, context);
  addDelayedCallback(配置.RZ.输入窗口秒 * 1000, RZ关闭输入, context);
}

export function 注册十六夜咲夜RZ(this: void): void {
  registerSyncHardwareKey(KEY.Z, KEY_STATE.DOWN, onRZ同步Z键);
  注册单位技能壳监听({ 名称: "十六夜咲夜-调换魔法（RZ）", 单位类型ID: 配置.英雄单位类型ID, 技能ID: 配置.技能.RZ.类型ID, 获取或创建上下文: 获取RZ监听上下文, 释放技能: 释放十六夜咲夜RZ, 创建独立技能实例: false });
}

注册十六夜咲夜RZ();

export {};
