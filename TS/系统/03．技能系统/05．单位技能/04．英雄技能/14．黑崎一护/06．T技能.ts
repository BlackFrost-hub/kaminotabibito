/** @noSelfInFile */
// 黑崎一护 T：地蹦裂击（A01J）。0.75 秒准备（可按 S 打断）+ 3 秒区域减速与自身减伤。
// 源 JASS 真源：技能.j（A01J 段 866-891；准备 Func007T 604-640；S键注册 Func003T 552-602；周期 Func005T 516-550；S键动作 Func003Func003 491-510）。
// 冲突口径：源准备为 0.15+0.55=0.70 秒，按介绍“0.75秒准备”对齐为 0.15+0.60；
// 源周期内减速使用已销毁单位组（悬挂句柄，实际不生效），TS 按介绍每周期重新选取 500 码敌军刷新减速；
// 源“敌人打断”按 udg_MFXG Buff 数组判定（全局变量不可反查），TS 以“存在其他暂停占用（被控）”为等效判定（差异审计见计划）。

import { 黑崎一护技能配置 } from "./00．配置";
import { 黑崎一护是否卍解 } from "./01．状态表";
import { 黑崎一护BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/09．黑崎一护";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加减速: (this: void, source: any, target: any, reduceRatio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { GS_Suspend, 单位是否存在其他暂停占用 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  GS_Suspend: (this: void, u: any, time: number) => void;
  单位是否存在其他暂停占用: (this: void, u: any, 自身来源: string) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { registerSyncHardwareKey } = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (this: void, key: number | string, status: number, callback: (this: void, event: { player: any; key: number; status: number }) => void) => any;
};
const { KEY, KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY: { S: number };
  KEY_STATE: { DOWN: number };
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, p: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const IsUnitAliveBJ = jass.IsUnitAliveBJ as (this: void, unit: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;

const 配置 = 黑崎一护技能配置;
const 英雄单位类型ID = 配置.单位类型ID;

interface T上下文 {
  施法者: any;
  已启动: boolean;
  周期回调ID: number;
  Tick数: number;
  减伤已加: boolean;
  技能实例ID?: number;
}

const T上下文表: Record<number, T上下文> = {};
let 当前进行中的T: T上下文 | null = null;

function 获取或创建T上下文(this: void, unit: any): T上下文 {
  const id = GetHandleId(unit);
  let ctx = T上下文表[id];
  if (ctx == null) {
    ctx = {
      施法者: unit,
      已启动: false,
      周期回调ID: 0,
      Tick数: 0,
      减伤已加: false,
    };
    T上下文表[id] = ctx;
  }
  return ctx;
}

function T可释放(this: void, context: T上下文, _caster: any): boolean {
  return context.已启动 !== true;
}

function 调整玩家受伤减少(this: void, caster: any, 增量: number): void {
  const player = GetOwningPlayer(caster);
  const 当前值 = Number(YDUserDataGetSafe("player", player, "受到伤害减少", "real")) || 0;
  YDUserDataSetSafe("player", player, "受到伤害减少", "real", 当前值 + 增量);
}

function 刷新T区域减速(this: void, ctx: T上下文): void {
  const caster = ctx.施法者;
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  创建点特效({ 模型路径: 配置.T.周期.踩地特效.模型, X: x, Y: y, Z: 0, 面向角度: 270, 缩放: 配置.T.周期.踩地特效.缩放, 持续秒: 配置.T.周期.踩地特效.持续秒 });
  创建点特效({ 模型路径: 配置.T.周期.裂地特效.模型, X: x, Y: y, Z: 0, 面向角度: 270, 缩放: 配置.T.周期.裂地特效.缩放, 持续秒: 配置.T.周期.裂地特效.持续秒 });
  const 敌军 = 获取范围敌军(caster, x, y, 配置.T.半径码);
  if (敌军 == null) return;
  for (let i = 0; i < 敌军.length; i++) {
    const target = 敌军[i];
    if (target == null || target === 0) continue;
    施加减速(caster, target, 配置.T.周期.减速比例, 配置.T.周期.减速持续秒, "黑崎一护-地蹦裂击", "技能");
    registerManualBuff(target, 黑崎一护BuffID.地蹦裂击减速, 配置.T.周期.减速持续秒, 0);
  }
}

function 结束T(this: void, ctx: T上下文): void {
  if (ctx.周期回调ID !== 0) removePeriodicCallback(ctx.周期回调ID);
  ctx.周期回调ID = 0;
  ctx.已启动 = false;
  const caster = ctx.施法者;
  if (caster != null && caster !== 0) {
    SetUnitTimeScale(caster, 1);
    if (ctx.减伤已加) 调整玩家受伤减少(caster, -配置.T.受伤减少比例);
    ctx.减伤已加 = false;
  }
  if (当前进行中的T === ctx) 当前进行中的T = null;
}

function 推进T周期(this: void, variable: any): void {
  const ctx = variable as T上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    结束T(ctx);
    return;
  }

  ctx.Tick数 += 1;
  if (ctx.Tick数 >= 配置.T.周期.次数) {
    结束T(ctx);
    return;
  }

  刷新T区域减速(ctx);

  // 敌人打断判定：被其他系统控制（暂停占用）时打断；卍解且血量高于阈值免打断
  if (单位是否存在其他暂停占用(caster, 配置.暂停来源.T施法硬直)) {
    const 免打断 = 黑崎一护是否卍解(caster)
      && GetUnitState(caster, UNIT_STATE_LIFE) >= GetUnitState(caster, UNIT_STATE_MAX_LIFE) * 配置.T.卍解免打断血量阈值;
    if (!免打断) {
      ctx.Tick数 = 配置.T.周期.次数; // 下一 tick 立即收尾（源：循环实数置满）
    }
  }
}

function T进入主阶段(this: void, variable: any): void {
  const ctx = variable as T上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    结束T(ctx);
    return;
  }
  SetUnitTimeScale(caster, 0); // 源：主阶段动作冻结
  ctx.Tick数 = 0;
  ctx.周期回调ID = addPeriodicCallback(
    Math.round(配置.T.周期.间隔秒 * 1000),
    推进T周期 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function T完成准备(this: void, variable: any): void {
  const ctx = variable as T上下文;
  if (ctx == null || ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0 || !IsUnitAliveBJ(caster)) {
    结束T(ctx);
    return;
  }
  SetUnitAnimationByIndex(caster, 配置.T.动作索引);
  调整玩家受伤减少(caster, 配置.T.受伤减少比例);
  ctx.减伤已加 = true;
  registerManualBuff(caster, 黑崎一护BuffID.地蹦裂击防御, 配置.T.周期.间隔秒 * 配置.T.周期.次数 + 0.75, 0);
  addDelayedCallback(
    Math.round(配置.T.准备第二延迟秒 * 1000),
    T进入主阶段 as unknown as (this: void, variable?: any) => void,
    ctx,
  );
}

function 释放地蹦裂击(this: void, context: T上下文, caster: any, 技能实例ID?: number): void {
  context.施法者 = caster;
  context.已启动 = true;
  context.Tick数 = 0;
  context.减伤已加 = false;
  context.技能实例ID = 技能实例ID;
  当前进行中的T = context;

  GS_Suspend(caster, 配置.T.硬直持续秒); // 源：GS_Suspend 3.5 秒硬直

  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const 敌军 = 获取范围敌军(caster, x, y, 配置.T.半径码);
  if (敌军 != null) {
    for (let i = 0; i < 敌军.length; i++) {
      const target = 敌军[i];
      if (target == null || target === 0) continue;
      施加减速(caster, target, 配置.T.周期.减速比例, 配置.T.周期.减速持续秒, "黑崎一护-地蹦裂击", "技能");
      registerManualBuff(target, 黑崎一护BuffID.地蹦裂击减速, 配置.T.周期.减速持续秒, 0);
    }
  }

  addDelayedCallback(
    Math.round(配置.T.准备第一延迟秒 * 1000),
    T完成准备 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// ---------------------------------------------------------------------------
// S 键自行打断：单一同步入口，只放行当前进行中 T 的所有者（计划第 4 节：独立输入路径）
// ---------------------------------------------------------------------------

function S键打断回调(this: void, event: { player: any; key: number; status: number }): void {
  if (当前进行中的T == null || event == null || event.player == null || event.player === 0) return;
  const ctx = 当前进行中的T;
  if (ctx.已启动 !== true) return;
  const caster = ctx.施法者;
  if (caster == null || caster === 0) return;
  if (GetPlayerId(GetOwningPlayer(caster)) !== GetPlayerId(event.player)) return;
  // 源：S 键打断 → 时间流速恢复、立即进入收尾
  ctx.Tick数 = 配置.T.周期.次数;
  if (ctx.周期回调ID === 0) 结束T(ctx); // 尚在主阶段前按下 S：直接收尾
}

let S键监听已注册 = false;

export function 注册黑崎一护T(this: void): void {
  注册单位技能壳监听({
    名称: "黑崎一护-地蹦裂击（T）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.T.技能ID,
    获取或创建上下文: 获取或创建T上下文,
    可释放: T可释放,
    释放技能: 释放地蹦裂击,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 5,
  });
  if (!S键监听已注册) {
    S键监听已注册 = true;
    registerSyncHardwareKey(KEY.S, KEY_STATE.DOWN, S键打断回调);
  }
}

注册黑崎一护T();

export {};
