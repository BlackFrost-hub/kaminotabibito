/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const globals = require('jass.globals') as { udg_Boss?: any; [key: string]: any };

const {
  Boss测试单位存活,
  设置Boss测试单位满血,
  获取Boss测试玩家基准英雄,
  准备Boss测试固定步兵,
  移除Boss测试单位,
  注册Boss测试命令组,
} = require('系统.12．测试系统.00．Boss测试系统.index') as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { SelectUnitForPlayerSingle } = require('lib.扩展函数.BJ函数.index') as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require('lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数') as {
  StarOther_PanCameraToTimedForPlayer: (this: void, player: any, x: number, y: number, duration: number) => void;
};
const { 标记测试Boss跳过死亡结算 } = require('系统.12．测试系统.00．测试系统辅助函数') as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { 应用Boss战启动属性配置 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用') as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 注册安兹被动效果 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.15．被动效果') as {
  注册安兹被动效果: (this: void) => void;
};
const { 获取或创建安兹运行时上下文, 清理安兹运行时上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文') as {
  获取或创建安兹运行时上下文: (this: void, boss: any) => any;
  清理安兹运行时上下文: (this: void, boss: any) => void;
};
const { 启动安兹守护者模式 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．守护者模式') as {
  启动安兹守护者模式: (this: void, context: any) => boolean;
};
const { 释放安兹现实断裂 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.03．现实断裂') as {
  释放安兹现实断裂: (this: void, context: any) => void;
};
const { 释放安兹心脏掌握 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.04．心脏掌握') as {
  释放安兹心脏掌握: (this: void, context: any) => void;
};
const { 释放安兹高阶魔法箭 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.05．高阶魔法箭') as {
  释放安兹高阶魔法箭: (this: void, context: any) => void;
};
const { 释放安兹光辉翠绿体 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.06．光辉翠绿体') as {
  释放安兹光辉翠绿体: (this: void, context: any) => void;
};
const { 释放安兹时间停止 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.07．时间停止') as {
  释放安兹时间停止: (this: void, context: any) => boolean;
};
const { 释放安兹高阶亡灵召唤 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.08．高阶亡灵召唤') as {
  释放安兹高阶亡灵召唤: (this: void, context: any) => boolean;
};
const { 释放安兹天空坠落 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.09．天空坠落') as {
  释放安兹天空坠落: (this: void, context: any) => boolean;
};
const { 释放安兹一切生命的终点 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.10．一切生命的终点') as {
  释放安兹一切生命的终点: (this: void, context: any) => boolean;
};
const { 释放雅儿贝德至尊拦截 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.01．至尊拦截') as {
  释放雅儿贝德至尊拦截: (this: void, context: any, attacker: any) => boolean;
};
const { 释放雅儿贝德黑翼横扫 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.02．黑翼横扫') as {
  释放雅儿贝德黑翼横扫: (this: void, context: any, target: any) => boolean;
};
const { 释放雅儿贝德守护者之职责 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.03．守护者之职责') as {
  释放雅儿贝德守护者之职责: (this: void, context: any) => boolean;
};
const { 释放雅儿贝德守护回归 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.08．守护回归') as {
  释放雅儿贝德守护回归: (this: void, context: any) => boolean;
};
const { 释放雅儿贝德护卫反击 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.09．护卫反击') as {
  释放雅儿贝德护卫反击: (this: void, context: any) => boolean;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;

const 安兹单位ID = stringToFourCCSafe('U007');
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 玩家测试X = -540.6;
const 玩家测试Y = -3055.2;

interface 安兹测试上下文 {
  运行时: any;
  目标单位: any;
  Boss单位: any;
}

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵1: Record<number, any> = {};
const 最近测试步兵2: Record<number, any> = {};

function 获取或创建安兹测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  let boss = 最近测试Boss[pid];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(player, 安兹单位ID, 测试中心X, 测试中心Y, 270);
    最近测试Boss[pid] = boss;
    if (Boss测试单位存活(boss)) SetHeroLevel(boss, 40, false);
  }
  if (Boss测试单位存活(boss)) {
    SetUnitPosition(boss, 测试中心X, 测试中心Y);
    SetUnitFacing(boss, 270);
    设置Boss测试单位满血(boss);
    标记测试Boss跳过死亡结算(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 获取或创建安兹测试步兵(this: void, cache: Record<number, any>, player: any, x: number, y: number): any {
  const pid = GetPlayerId(player);
  const unit = 准备Boss测试固定步兵(cache[pid], x, y, 90);
  cache[pid] = unit;
  return unit;
}

function 创建或获取安兹测试上下文(this: void, player: any): 安兹测试上下文 | undefined {
  const hero = 获取Boss测试玩家基准英雄(player);
  const boss = 获取或创建安兹测试Boss(player);
  if (!Boss测试单位存活(hero) || !Boss测试单位存活(boss)) return undefined;

  SetUnitPosition(hero, 玩家测试X, 玩家测试Y);
  SetUnitFacing(hero, 90);
  设置Boss测试单位满血(hero);
  const target = 获取或创建安兹测试步兵(最近测试步兵1, player, 玩家测试X - 220, 玩家测试Y + 180);
  获取或创建安兹测试步兵(最近测试步兵2, player, 玩家测试X + 220, 玩家测试Y + 180);
  if (!Boss测试单位存活(target)) return undefined;

  注册安兹被动效果();
  应用Boss战启动属性配置(boss);
  设置Boss测试单位满血(boss);
  const runtime = 获取或创建安兹运行时上下文(boss);
  if (runtime == null || !启动安兹守护者模式(runtime)) return undefined;

  const albedo = runtime.雅儿贝德?.单位;
  if (Boss测试单位存活(albedo)) 设置Boss测试单位满血(albedo);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 测试中心X, 测试中心Y, 0.2);
  return { 运行时: runtime, 目标单位: target, Boss单位: boss };
}

function 清理安兹测试上下文(this: void, player: any, context: 安兹测试上下文): void {
  const pid = GetPlayerId(player);
  if (context != null && context.Boss单位 != null) 清理安兹运行时上下文(context.Boss单位);
  移除Boss测试单位(最近测试步兵1[pid]);
  移除Boss测试单位(最近测试步兵2[pid]);
  移除Boss测试单位(最近测试Boss[pid]);
  最近测试步兵1[pid] = undefined;
  最近测试步兵2[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === context?.Boss单位) globals.udg_Boss = null;
}

function 测试安兹现实断裂(this: void, _player: any, context: 安兹测试上下文): void { 释放安兹现实断裂(context.运行时); }
function 测试安兹心脏掌握(this: void, _player: any, context: 安兹测试上下文): void { 释放安兹心脏掌握(context.运行时); }
function 测试安兹高阶魔法箭(this: void, _player: any, context: 安兹测试上下文): void { 释放安兹高阶魔法箭(context.运行时); }
function 测试安兹光辉翠绿体(this: void, _player: any, context: 安兹测试上下文): void { 释放安兹光辉翠绿体(context.运行时); }
function 测试安兹时间停止(this: void, _player: any, context: 安兹测试上下文): void { 释放安兹时间停止(context.运行时); }
function 测试安兹高阶亡灵召唤(this: void, _player: any, context: 安兹测试上下文): void { 释放安兹高阶亡灵召唤(context.运行时); }
function 测试安兹天空坠落(this: void, _player: any, context: 安兹测试上下文): void {
  context.运行时.天空坠落已释放 = false;
  释放安兹天空坠落(context.运行时);
}
function 测试安兹一切生命的终点(this: void, _player: any, context: 安兹测试上下文): void {
  context.运行时.一切生命的终点已释放 = false;
  释放安兹一切生命的终点(context.运行时);
}
function 测试安兹护卫模式(this: void, _player: any, context: 安兹测试上下文): void { 启动安兹守护者模式(context.运行时); }
function 测试雅儿贝德至尊拦截(this: void, _player: any, context: 安兹测试上下文): void {
  if (context.运行时.雅儿贝德 != null) context.运行时.雅儿贝德.上次至尊拦截Ms = 0;
  释放雅儿贝德至尊拦截(context.运行时, context.目标单位);
}
function 测试雅儿贝德黑翼横扫(this: void, _player: any, context: 安兹测试上下文): void {
  释放雅儿贝德黑翼横扫(context.运行时, context.目标单位);
}
function 测试雅儿贝德守护者之职责(this: void, _player: any, context: 安兹测试上下文): void {
  if (context.运行时.雅儿贝德 != null) context.运行时.雅儿贝德.上次守护职责Ms = 0;
  释放雅儿贝德守护者之职责(context.运行时);
}
function 测试雅儿贝德守护回归(this: void, _player: any, context: 安兹测试上下文): void {
  const state = context.运行时.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !Boss测试单位存活(albedo)) return;
  state.上次守护回归Ms = 0;
  SetUnitPosition(albedo, GetUnitX(context.Boss单位) + 1200, GetUnitY(context.Boss单位));
  释放雅儿贝德守护回归(context.运行时);
}
function 测试雅儿贝德护卫反击(this: void, _player: any, context: 安兹测试上下文): void {
  if (context.运行时.雅儿贝德 != null) context.运行时.雅儿贝德.上次护卫反击Ms = 0;
  释放雅儿贝德护卫反击(context.运行时);
}

const 安兹测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: '现实断裂', 执行: 测试安兹现实断裂 },
  { 序号: 2, 名称: '心脏掌握', 执行: 测试安兹心脏掌握 },
  { 序号: 3, 名称: '高阶魔法箭', 执行: 测试安兹高阶魔法箭 },
  { 序号: 4, 名称: '光辉翠绿体', 执行: 测试安兹光辉翠绿体 },
  { 序号: 5, 名称: '时间停止', 执行: 测试安兹时间停止 },
  { 序号: 6, 名称: '高阶亡灵召唤', 执行: 测试安兹高阶亡灵召唤 },
  { 序号: 7, 名称: '天空坠落+护卫联动', 执行: 测试安兹天空坠落 },
  { 序号: 8, 名称: '一切生命的终点+锚点封锁', 执行: 测试安兹一切生命的终点 },
  { 序号: 9, 名称: '启动护卫模式', 执行: 测试安兹护卫模式 },
  { 序号: 10, 名称: '雅儿贝德至尊拦截', 执行: 测试雅儿贝德至尊拦截 },
  { 序号: 11, 名称: '雅儿贝德黑翼横扫', 执行: 测试雅儿贝德黑翼横扫 },
  { 序号: 12, 名称: '雅儿贝德守护者之职责', 执行: 测试雅儿贝德守护者之职责 },
  { 序号: 13, 名称: '雅儿贝德守护回归', 执行: 测试雅儿贝德守护回归 },
  { 序号: 14, 名称: '雅儿贝德护卫反击窗口', 执行: 测试雅儿贝德护卫反击 },
];

注册Boss测试命令组({
  命令单位名: '安兹乌尔恭',
  Boss名称: '安兹乌尔恭（护卫模式）',
  场地: {
    正式中心: { x: 测试中心X, y: 测试中心Y },
    测试空地中心: { x: 测试中心X, y: 测试中心Y },
  },
  创建或获取上下文: 创建或获取安兹测试上下文,
  清理上下文: 清理安兹测试上下文,
  技能命令列表: 安兹测试技能列表,
});

export {};
