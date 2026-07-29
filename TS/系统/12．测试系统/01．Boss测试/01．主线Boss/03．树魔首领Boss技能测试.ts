/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require("jass.common") as any;
const globals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };

const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 获取或创建树魔首领上下文, 清理树魔首领上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.01．运行时上下文") as {
  获取或创建树魔首领上下文: (this: void, boss: any) => any;
  清理树魔首领上下文: (this: void, boss: any) => void;
};
const { 注册树魔首领被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.10．被动效果") as {
  注册树魔首领被动效果: (this: void) => void;
};
const { 初始化树魔首领随从特性, 立即补充树魔首领随从 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.03．随从特性") as {
  初始化树魔首领随从特性: (this: void, context: any) => void;
  立即补充树魔首领随从: (this: void, context: any) => number;
};
const { 释放树魔首领扩散冲击波 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.04．扩散冲击波") as {
  释放树魔首领扩散冲击波: (this: void, context: any) => void;
};
const { 释放树魔首领消耗反击 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.05．消耗反击") as {
  释放树魔首领消耗反击: (this: void, context: any) => void;
};
const { 释放树魔首领远古诅咒 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.06．远古诅咒") as {
  释放树魔首领远古诅咒: (this: void, context: any) => void;
};
const { 释放树魔首领树魔图腾 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.07．树魔图腾") as {
  释放树魔首领树魔图腾: (this: void, context: any) => void;
};
const { 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { Boss测试单位存活, 设置Boss测试单位满血, 获取Boss测试玩家基准英雄, 准备Boss测试固定步兵, 准备Boss测试固定山丘之王, 移除Boss测试单位, 注册Boss测试命令组 } = require("系统.12．测试系统.00．Boss测试系统.index") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};

const 树魔首领单位ID = stringToFourCC("N05S");
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家Y = -3055.2;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const KillUnit = jass.KillUnit as (unit: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};
const 树魔首领测试调试模块 = "树魔首领测试";
let 技能6待检查上下文: any = null;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 最近测试Boss[pid];
  if (Boss测试单位存活(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置Boss测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(player, 树魔首领单位ID, 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 35, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 准备树魔首领测试场景(this: void, player: any, hero: any, boss: any): any {
  const pid = GetPlayerId(player);
  设置Boss测试单位满血(hero);
  最近测试步兵[pid] = 准备Boss测试固定步兵(最近测试步兵[pid], 临时测试场地中心X - 220, 临时测试玩家Y + 180, 90);
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 临时测试场地中心X + 220, 临时测试玩家Y + 180, 90);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
  const context = 获取或创建树魔首领上下文(boss);
  if (context != null) 初始化树魔首领随从特性(context);
  return context;
}

function 创建并初始化树魔首领测试(this: void, player: any): any {
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) return undefined;

  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;

  注册树魔首领被动效果();
  应用Boss战启动属性配置(boss);
  return 准备树魔首领测试场景(player, hero, boss);
}

function 清理树魔首领测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const boss = 最近测试Boss[pid];
  if (boss != null && boss !== 0) 清理树魔首领上下文(boss);
  移除Boss测试单位(最近测试步兵[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(boss);
  最近测试步兵[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on树魔首领技能1测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放树魔首领扩散冲击波(context);
}

function on树魔首领技能2测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放树魔首领消耗反击(context);
}

function on树魔首领技能3测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放树魔首领远古诅咒(context);
}

function on树魔首领技能4测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放树魔首领树魔图腾(context);
}

function on树魔首领技能5测试命令(this: void, _player: any, context: any): void {
  if (context == null) return;
  立即补充树魔首领随从(context);
}

function 记录树魔首领技能6随从状态(this: void, 阶段: string, context: any): number {
  const list: any[] | undefined = context?.随从组?.取单位列表();
  if (list == null) {
    debugLogForce(树魔首领测试调试模块, "命令6", 阶段, "随从列表=nil");
    return 0;
  }

  let 存活数量 = 0;
  debugLogForce(树魔首领测试调试模块, "命令6", 阶段, "列表数量=", list.length, "下次补员Ms=", context.下一次召唤Ms);
  for (let i = 0; i < list.length; i++) {
    const minion = list[i];
    const 存活 = Boss测试单位存活(minion);
    if (存活) 存活数量++;
    debugLogForce(
      树魔首领测试调试模块,
      "命令6",
      阶段,
      "序号=",
      i,
      "句柄=",
      minion == null || minion === 0 ? 0 : GetHandleId(minion),
      "类型=",
      minion == null || minion === 0 ? 0 : GetUnitTypeId(minion),
      "生命=",
      minion == null || minion === 0 ? 0 : GetUnitState(minion, UNIT_STATE_LIFE),
      "存活=",
      存活,
    );
  }
  return 存活数量;
}

function on树魔首领技能6延迟检查(this: void): void {
  const context = 技能6待检查上下文;
  技能6待检查上下文 = null;
  if (context == null || context.随从组 == null) return;
  const 存活数量 = 记录树魔首领技能6随从状态("延迟100ms后", context);
  debugLogForce(树魔首领测试调试模块, "命令6", "延迟检查存活随从数=", 存活数量);
}

function on树魔首领技能6测试命令(this: void, _player: any, context: any): void {
  if (context == null || context.随从组 == null) return;
  记录树魔首领技能6随从状态("击杀前", context);
  context.下一次召唤Ms = 0;
  const list: any[] = context.随从组.取单位列表();
  let 执行击杀数量 = 0;
  for (let i = 0; i < list.length; i++) {
    const minion = list[i];
    if (!Boss测试单位存活(minion)) {
      debugLogForce(树魔首领测试调试模块, "命令6", "跳过非存活随从", "序号=", i);
      continue;
    }
    KillUnit(minion);
    执行击杀数量++;
  }
  debugLogForce(树魔首领测试调试模块, "命令6", "已调用KillUnit数量=", 执行击杀数量);
  技能6待检查上下文 = context;
  addDelayedCallback(100, on树魔首领技能6延迟检查);
}

const 树魔首领测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "扩散冲击波", 执行: on树魔首领技能1测试命令 },
  { 序号: 2, 名称: "消耗反击", 执行: on树魔首领技能2测试命令 },
  { 序号: 3, 名称: "远古诅咒", 执行: on树魔首领技能3测试命令 },
  { 序号: 4, 名称: "树魔图腾", 执行: on树魔首领技能4测试命令 },
  { 序号: 5, 名称: "立即补齐随从编制", 执行: on树魔首领技能5测试命令 },
  { 序号: 6, 名称: "杀死所有随从并暂停补员（测试无从暴怒）", 执行: on树魔首领技能6测试命令 },
];

注册Boss测试命令组({
  命令单位名: "树魔首领",
  Boss名称: "树魔首领",
  创建或获取上下文: 创建并初始化树魔首领测试,
  清理上下文: 清理树魔首领测试,
  技能命令列表: 树魔首领测试技能列表,
});

export {};
