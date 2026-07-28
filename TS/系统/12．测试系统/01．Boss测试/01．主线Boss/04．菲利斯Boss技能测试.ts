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
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const {
  Boss测试单位存活,
  设置Boss测试单位满血,
  获取Boss测试玩家基准英雄,
  准备Boss测试固定步兵,
  移除Boss测试单位,
  注册Boss测试命令组,
} = require("系统.12．测试系统.00．Boss测试系统.index") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};

const { 获取或创建菲利斯上下文, 清理菲利斯上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.01．运行时上下文") as {
  获取或创建菲利斯上下文: (this: void, boss: any) => any;
  清理菲利斯上下文: (this: void, boss: any) => void;
};
const { 注册菲利斯被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.10．被动效果") as {
  注册菲利斯被动效果: (this: void) => void;
};
const { 释放菲利斯剑魂杀 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.04．剑魂杀") as {
  释放菲利斯剑魂杀: (this: void, context: any) => void;
};
const { 释放菲利斯剑气灵斩 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.05．剑气灵斩") as {
  释放菲利斯剑气灵斩: (this: void, context: any) => void;
};
const { 释放菲利斯全力封印斩 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.06．全力封印斩") as {
  释放菲利斯全力封印斩: (this: void, context: any) => void;
};
const { 释放菲利斯异形化 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.07．异形化") as {
  释放菲利斯异形化: (this: void, context: any) => void;
};

const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家Y = -3055.2;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;

const 菲利斯测试Boss: Record<number, any> = {};
const 菲利斯测试步兵1: Record<number, any> = {};
const 菲利斯测试步兵2: Record<number, any> = {};

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 菲利斯测试Boss[pid];
  if (Boss测试单位存活(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置Boss测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(player, stringToFourCC("N05T"), 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    菲利斯测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 38, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 准备测试场景(this: void, player: any, boss: any): void {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  if (hero != null && hero !== 0) {
    SetUnitPosition(hero, 临时测试场地中心X, 临时测试玩家Y);
    SetUnitFacing(hero, 90);
    设置Boss测试单位满血(hero);
  }
  菲利斯测试步兵1[pid] = 准备Boss测试固定步兵(菲利斯测试步兵1[pid], 临时测试场地中心X - 220, 临时测试玩家Y + 180, 90);
  菲利斯测试步兵2[pid] = 准备Boss测试固定步兵(菲利斯测试步兵2[pid], 临时测试场地中心X + 220, 临时测试玩家Y + 180, 90);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
}

function 启动Boss测试链路(this: void, boss: any): void {
  应用Boss战启动属性配置(boss);
}

function 创建菲利斯测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;
  注册菲利斯被动效果();
  准备测试场景(player, boss);
  启动Boss测试链路(boss);
  return 获取或创建菲利斯上下文(boss);
}

function 清理菲利斯测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const boss = 菲利斯测试Boss[pid];
  if (boss != null && boss !== 0) 清理菲利斯上下文(boss);
  移除Boss测试单位(菲利斯测试步兵1[pid]);
  移除Boss测试单位(菲利斯测试步兵2[pid]);
  移除Boss测试单位(boss);
  菲利斯测试步兵1[pid] = undefined;
  菲利斯测试步兵2[pid] = undefined;
  菲利斯测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on菲利斯技能1测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放菲利斯剑魂杀(context);
}

function on菲利斯技能2测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放菲利斯剑气灵斩(context);
}

function on菲利斯技能3测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放菲利斯全力封印斩(context);
}

function on菲利斯技能4测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放菲利斯异形化(context);
}

const 菲利斯测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "剑魂杀", 执行: on菲利斯技能1测试命令 },
  { 序号: 2, 名称: "剑气灵斩", 执行: on菲利斯技能2测试命令 },
  { 序号: 3, 名称: "全力封印斩", 执行: on菲利斯技能3测试命令 },
  { 序号: 4, 名称: "异形化", 执行: on菲利斯技能4测试命令 },
];

注册Boss测试命令组({
  命令单位名: "菲利斯",
  Boss名称: "菲利斯",
  创建或获取上下文: 创建菲利斯测试,
  清理上下文: 清理菲利斯测试,
  技能命令列表: 菲利斯测试技能列表,
});

export {};
