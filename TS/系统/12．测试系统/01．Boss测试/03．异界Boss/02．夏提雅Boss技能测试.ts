/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const globals = require('jass.globals') as { udg_Boss?: any; [key: string]: any };

const {
  Boss测试单位存活,
  设置Boss测试单位满血,
  获取Boss测试玩家基准英雄,
  准备Boss测试固定步兵,
  准备Boss测试固定山丘之王,
  移除Boss测试单位,
  注册Boss测试命令组,
} = require('系统.12．测试系统.00．Boss测试系统.index') as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
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
const { 注册夏提雅被动效果 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.17．被动效果') as {
  注册夏提雅被动效果: (this: void) => void;
};
const { 获取或创建夏提雅运行时上下文, 清理夏提雅运行时上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文') as {
  获取或创建夏提雅运行时上下文: (this: void, boss: any) => any;
  清理夏提雅运行时上下文: (this: void, boss: any) => void;
};
const { 创建夏提雅鲜血印记 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.04．鲜血印记') as {
  创建夏提雅鲜血印记: (this: void, context: any, x: number, y: number) => any;
};
const { 释放夏提雅滴管穿心 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.05．滴管穿心') as {
  释放夏提雅滴管穿心: (this: void, context: any, target: any) => boolean;
};
const { 释放夏提雅血月轮舞 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.06．血月轮舞') as {
  释放夏提雅血月轮舞: (this: void, context: any, target: any) => boolean;
};
const { 释放夏提雅净化投枪 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.07．净化投枪') as {
  释放夏提雅净化投枪: (this: void, context: any, target: any) => boolean;
};
const { 释放夏提雅鲜血回收 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.08．鲜血回收') as {
  释放夏提雅鲜血回收: (this: void, context: any) => boolean;
};
const { 启动夏提雅英灵战乙女阶段 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女') as {
  启动夏提雅英灵战乙女阶段: (this: void, context: any, target: any) => boolean;
};
const { 释放夏提雅镜像夹击 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.10．镜像夹击') as {
  释放夏提雅镜像夹击: (this: void, context: any, target: any) => boolean;
};
const { 释放夏提雅真祖血宴 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.11．真祖血宴') as {
  释放夏提雅真祖血宴: (this: void, context: any) => boolean;
};
const { 释放夏提雅血月终舞 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.12．血月终舞') as {
  释放夏提雅血月终舞: (this: void, context: any, target: any) => boolean;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const 夏提雅单位ID = stringToFourCCSafe('U009');
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 玩家测试X = -540.6;
const 玩家测试Y = -3055.2;

interface 夏提雅测试上下文 {
  运行时: any;
  目标单位: any;
  Boss单位: any;
}

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};

function 获取或创建夏提雅测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  let boss = 最近测试Boss[pid];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(player, 夏提雅单位ID, 测试中心X, 测试中心Y, 270);
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

function 获取或创建夏提雅测试步兵(this: void, cache: Record<number, any>, player: any, x: number, y: number): any {
  const pid = GetPlayerId(player);
  const unit = 准备Boss测试固定步兵(cache[pid], x, y, 90);
  cache[pid] = unit;
  return unit;
}

function 创建或获取夏提雅测试上下文(this: void, player: any): 夏提雅测试上下文 | undefined {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  const boss = 获取或创建夏提雅测试Boss(player);
  if (!Boss测试单位存活(hero) || !Boss测试单位存活(boss)) return undefined;

  设置Boss测试单位满血(hero);
  const target = 获取或创建夏提雅测试步兵(最近测试步兵, player, 玩家测试X - 220, 玩家测试Y + 180);
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 玩家测试X + 220, 玩家测试Y + 180, 90);
  if (!Boss测试单位存活(target)) return undefined;

  注册夏提雅被动效果();
  应用Boss战启动属性配置(boss);
  设置Boss测试单位满血(boss);
  const runtime = 获取或创建夏提雅运行时上下文(boss);
  if (runtime == null) return undefined;

  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 测试中心X, 测试中心Y, 0.2);
  return { 运行时: runtime, 目标单位: target, Boss单位: boss };
}

function 清理夏提雅测试上下文(this: void, player: any, context: 夏提雅测试上下文): void {
  const pid = GetPlayerId(player);
  if (context != null && context.Boss单位 != null) 清理夏提雅运行时上下文(context.Boss单位);
  移除Boss测试单位(最近测试步兵[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(最近测试Boss[pid]);
  最近测试步兵[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === context?.Boss单位) globals.udg_Boss = null;
}

function 创建夏提雅测试血印(this: void, context: 夏提雅测试上下文): void {
  const x = GetUnitX(context.Boss单位);
  const y = GetUnitY(context.Boss单位);
  创建夏提雅鲜血印记(context.运行时, x - 260, y - 120);
  创建夏提雅鲜血印记(context.运行时, x + 260, y - 120);
  创建夏提雅鲜血印记(context.运行时, x, y + 260);
}

function 测试夏提雅滴管穿心(this: void, _player: any, context: 夏提雅测试上下文): void {
  释放夏提雅滴管穿心(context.运行时, context.目标单位);
}
function 测试夏提雅血月轮舞(this: void, _player: any, context: 夏提雅测试上下文): void {
  释放夏提雅血月轮舞(context.运行时, context.目标单位);
}
function 测试夏提雅净化投枪(this: void, _player: any, context: 夏提雅测试上下文): void {
  释放夏提雅净化投枪(context.运行时, context.目标单位);
}
function 测试夏提雅鲜血回收(this: void, _player: any, context: 夏提雅测试上下文): void {
  context.运行时.阶段 = 'P1鲜血女武神';
  创建夏提雅测试血印(context);
  释放夏提雅鲜血回收(context.运行时);
}
function 测试夏提雅英灵战乙女(this: void, _player: any, context: 夏提雅测试上下文): void {
  context.运行时.阶段 = 'P2英灵战乙女';
  启动夏提雅英灵战乙女阶段(context.运行时, context.目标单位);
}
function 测试夏提雅镜像夹击(this: void, _player: any, context: 夏提雅测试上下文): void {
  context.运行时.阶段 = 'P2英灵战乙女';
  启动夏提雅英灵战乙女阶段(context.运行时, context.目标单位);
  释放夏提雅镜像夹击(context.运行时, context.目标单位);
}
function 测试夏提雅真祖血宴(this: void, _player: any, context: 夏提雅测试上下文): void {
  context.运行时.阶段 = 'P3真祖血宴';
  context.运行时.P3转阶段已处理 = false;
  创建夏提雅测试血印(context);
  释放夏提雅真祖血宴(context.运行时);
}
function 测试夏提雅血月终舞(this: void, _player: any, context: 夏提雅测试上下文): void {
  context.运行时.阶段 = 'P3真祖血宴';
  context.运行时.P3转阶段已处理 = true;
  context.运行时.血月终舞已释放 = false;
  释放夏提雅血月终舞(context.运行时, context.目标单位);
}
function 准备夏提雅血之复生(this: void, _player: any, context: 夏提雅测试上下文): void {
  context.运行时.阶段 = 'P3真祖血宴';
  context.运行时.已触发复生 = false;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, 1);
}

const 夏提雅测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: '滴管穿心', 执行: 测试夏提雅滴管穿心 },
  { 序号: 2, 名称: '血月轮舞', 执行: 测试夏提雅血月轮舞 },
  { 序号: 3, 名称: '净化投枪', 执行: 测试夏提雅净化投枪 },
  { 序号: 4, 名称: '鲜血回收', 执行: 测试夏提雅鲜血回收 },
  { 序号: 5, 名称: 'P2英灵战乙女', 执行: 测试夏提雅英灵战乙女 },
  { 序号: 6, 名称: 'P2镜像夹击', 执行: 测试夏提雅镜像夹击 },
  { 序号: 7, 名称: 'P3真祖血宴', 执行: 测试夏提雅真祖血宴 },
  { 序号: 8, 名称: 'P3血月终舞', 执行: 测试夏提雅血月终舞 },
  { 序号: 9, 名称: '血之复生触发准备（攻击致死）', 执行: 准备夏提雅血之复生 },
];

注册Boss测试命令组({
  命令单位名: '夏提雅',
  Boss名称: '夏提雅',
  场地: {
    正式中心: { x: 测试中心X, y: 测试中心Y },
    测试空地中心: { x: 测试中心X, y: 测试中心Y },
  },
  创建或获取上下文: 创建或获取夏提雅测试上下文,
  清理上下文: 清理夏提雅测试上下文,
  技能命令列表: 夏提雅测试技能列表,
});

export {};
