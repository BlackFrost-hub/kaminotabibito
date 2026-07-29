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
const { 获取或创建瑟兰迪尔上下文, 清理瑟兰迪尔上下文, 注册瑟兰迪尔运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文") as {
  获取或创建瑟兰迪尔上下文: (this: void, boss: any) => any;
  清理瑟兰迪尔上下文: (this: void, boss: any) => void;
  注册瑟兰迪尔运行时: (this: void) => void;
};
const { 刷新瑟兰迪尔秩序领域 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.07．秩序领域") as {
  刷新瑟兰迪尔秩序领域: (this: void, context: any) => void;
};
const { 释放瑟兰迪尔执法印记 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.04．执法印记") as {
  释放瑟兰迪尔执法印记: (this: void, context: any, target: any) => boolean;
};
const { 释放瑟兰迪尔月光枷锁效果, 立即打断瑟兰迪尔月光枷锁 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.05．月光枷锁") as {
  释放瑟兰迪尔月光枷锁效果: (this: void, caster: any, target: any) => void;
  立即打断瑟兰迪尔月光枷锁: (this: void, caster: any, target: any) => boolean;
};
const { 释放瑟兰迪尔精灵箭阵 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.06．精灵箭阵") as {
  释放瑟兰迪尔精灵箭阵: (this: void, context: any) => void;
};
const { 释放瑟兰迪尔审判之环 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.08．审判之环") as {
  释放瑟兰迪尔审判之环: (this: void, context: any) => void;
};
const { 释放瑟兰迪尔罪与罚 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.09．罪与罚") as {
  释放瑟兰迪尔罪与罚: (this: void, context: any, target?: any) => void;
};
const { 释放瑟兰迪尔律法召唤 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.10．律法召唤") as {
  释放瑟兰迪尔律法召唤: (this: void, context: any) => void;
};
const { 释放瑟兰迪尔月光灌注 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.11．月光灌注") as {
  释放瑟兰迪尔月光灌注: (this: void, context: any) => void;
};
const { 释放瑟兰迪尔终末审判 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.12．终末审判") as {
  释放瑟兰迪尔终末审判: (this: void, context: any) => void;
};
const { 瑟兰迪尔数值与表现配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置") as {
  瑟兰迪尔数值与表现配置: any;
};
const { 创建单位坐标跟随特效, 销毁单位坐标跟随特效, 创建循环点特效, 停止循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
  创建循环点特效: (this: void, 参数: any) => any;
  停止循环点特效: (this: void, 句柄: any) => void;
};
const { 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
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

const 瑟兰迪尔单位ID = stringToFourCC("N057");
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家Y = -3055.2;
const 秩序领域缩放测试特效键 = "thranduil-order-aura-scale-test";

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;

interface 瑟兰迪尔测试上下文 {
  Boss单位: any;
  运行时: any;
  目标单位: any;
  基准英雄: any;
  审判之环法阵句柄?: any;
}

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};
const 最近测试上下文: Record<number, 瑟兰迪尔测试上下文 | undefined> = {};

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

  const boss = CreateUnit(player, 瑟兰迪尔单位ID, 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 10, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 创建或获取瑟兰迪尔测试(this: void, player: any): 瑟兰迪尔测试上下文 | undefined {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(hero) || !Boss测试单位存活(boss)) return undefined;

  设置Boss测试单位满血(hero);
  const target = 准备Boss测试固定步兵(最近测试步兵[pid], 临时测试场地中心X - 220, 临时测试玩家Y + 180, 90);
  最近测试步兵[pid] = target;
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 临时测试场地中心X + 220, 临时测试玩家Y + 180, 90);
  if (!Boss测试单位存活(target)) return undefined;

  应用Boss战启动属性配置(boss);
  设置Boss测试单位满血(boss);
  注册瑟兰迪尔运行时();
  const runtime = 获取或创建瑟兰迪尔上下文(boss);
  if (runtime == null) return undefined;
  刷新瑟兰迪尔秩序领域(runtime);

  let context = 最近测试上下文[pid];
  if (context == null || context.Boss单位 !== boss) {
    context = { Boss单位: boss, 运行时: runtime, 目标单位: target, 基准英雄: hero };
    最近测试上下文[pid] = context;
  } else {
    context.运行时 = runtime;
    context.目标单位 = target;
    context.基准英雄 = hero;
  }

  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
  return context;
}

function 清理瑟兰迪尔测试(this: void, player: any, context: 瑟兰迪尔测试上下文): void {
  const pid = GetPlayerId(player);
  const cached = 最近测试上下文[pid] ?? context;
  const boss = 最近测试Boss[pid];
  if (cached != null && cached.审判之环法阵句柄 != null) 停止循环点特效(cached.审判之环法阵句柄);
  if (cached != null && cached.基准英雄 != null) 销毁单位坐标跟随特效(cached.基准英雄, 秩序领域缩放测试特效键);
  if (boss != null && boss !== 0) 清理瑟兰迪尔上下文(boss);
  移除Boss测试单位(最近测试步兵[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(boss);
  最近测试上下文[pid] = undefined;
  最近测试步兵[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on瑟兰迪尔技能1测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔月光枷锁效果(context.Boss单位, context.目标单位);
}

function on瑟兰迪尔技能2测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔精灵箭阵(context.运行时);
}

function on瑟兰迪尔技能3测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔审判之环(context.运行时);
}

function on瑟兰迪尔技能4测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔罪与罚(context.运行时, context.目标单位);
}

function on瑟兰迪尔技能5测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔律法召唤(context.运行时);
}

function on瑟兰迪尔技能6测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔月光灌注(context.运行时);
}

function on瑟兰迪尔技能7测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔终末审判(context.运行时);
}

function on瑟兰迪尔技能8测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  立即打断瑟兰迪尔月光枷锁(context.Boss单位, context.目标单位);
}

function on审判之环法阵特效测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  if (context.审判之环法阵句柄 != null) 停止循环点特效(context.审判之环法阵句柄);
  const config = 瑟兰迪尔数值与表现配置.审判之环;
  context.审判之环法阵句柄 = 创建循环点特效({
    模型路径: config.特效,
    X: GetUnitX(context.基准英雄),
    Y: GetUnitY(context.基准英雄),
    缩放: config.法阵缩放,
    顶点颜色: 0xFFFFD060,
    重建间隔秒: config.法阵重建间隔秒,
    单次持续秒: config.法阵单次持续秒,
    总持续秒: config.周期秒,
  });
}

function on秩序领域绑定缩放测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  创建单位坐标跟随特效(context.基准英雄, 瑟兰迪尔数值与表现配置.秩序领域.特效, 秩序领域缩放测试特效键, 1, 50);
}

function on瑟兰迪尔执法印记测试命令(this: void, _player: any, context: 瑟兰迪尔测试上下文): void {
  释放瑟兰迪尔执法印记(context.运行时, context.目标单位);
}

const 瑟兰迪尔测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "月光枷锁", 执行: on瑟兰迪尔技能1测试命令 },
  { 序号: 2, 名称: "精灵箭阵", 执行: on瑟兰迪尔技能2测试命令 },
  { 序号: 3, 名称: "审判之环", 执行: on瑟兰迪尔技能3测试命令 },
  { 序号: 4, 名称: "罪与罚", 执行: on瑟兰迪尔技能4测试命令 },
  { 序号: 5, 名称: "律法召唤", 执行: on瑟兰迪尔技能5测试命令 },
  { 序号: 6, 名称: "月光灌注", 执行: on瑟兰迪尔技能6测试命令 },
  { 序号: 7, 名称: "终末审判", 执行: on瑟兰迪尔技能7测试命令 },
  { 序号: 8, 名称: "月光枷锁立即打断", 执行: on瑟兰迪尔技能8测试命令 },
  { 序号: 9, 名称: "审判之环法阵特效", 执行: on审判之环法阵特效测试命令 },
  { 序号: 10, 名称: "秩序领域绑定缩放", 执行: on秩序领域绑定缩放测试命令 },
  { 序号: 11, 名称: "执法印记", 执行: on瑟兰迪尔执法印记测试命令 },
];

注册Boss测试命令组({
  命令单位名: "瑟兰迪尔",
  Boss名称: "瑟兰迪尔",
  创建或获取上下文: 创建或获取瑟兰迪尔测试,
  清理上下文: 清理瑟兰迪尔测试,
  技能命令列表: 瑟兰迪尔测试技能列表,
});

export {};
