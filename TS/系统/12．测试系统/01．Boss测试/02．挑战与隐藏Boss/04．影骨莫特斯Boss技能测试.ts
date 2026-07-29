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
const { Boss测试单位存活, 设置Boss测试单位满血, 获取Boss测试玩家基准英雄, 准备Boss测试固定步兵, 准备Boss测试固定山丘之王, 移除Boss测试单位, 注册Boss测试命令组 } = require("系统.12．测试系统.00．Boss测试系统.index") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};

const { 获取或创建影骨莫特斯上下文, 清理影骨莫特斯上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文") as {
  获取或创建影骨莫特斯上下文: (this: void, boss: any) => any;
  清理影骨莫特斯上下文: (this: void, boss: any) => void;
};
const { 注册影骨莫特斯被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.10．被动效果") as {
  注册影骨莫特斯被动效果: (this: void) => void;
};
const { 释放影骨暗影禁锢 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.05．暗影禁锢") as {
  释放影骨暗影禁锢: (this: void, context: any, target: any) => void;
};
const { 释放影骨阴影穿梭 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.03．阴影穿梭") as {
  释放影骨阴影穿梭: (this: void, context: any) => void;
};
const { 释放影骨骸骨召唤 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.04．骸骨召唤") as {
  释放影骨骸骨召唤: (this: void, context: any) => void;
};
const { 释放影骨幽影爆发 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.06．幽影爆发") as {
  释放影骨幽影爆发: (this: void, context: any) => void;
};
const { 释放影骨盗贼遗产 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.07．盗贼的遗产") as {
  释放影骨盗贼遗产: (this: void, context: any) => void;
};

const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家Y = -3055.2;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;

const 影骨测试Boss: Record<number, any> = {};
const 影骨测试步兵: Record<number, any> = {};
const 影骨测试山丘之王: Record<number, any> = {};

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 影骨测试Boss[pid];
  if (Boss测试单位存活(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置Boss测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(player, stringToFourCC("N01Y"), 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    影骨测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 42, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 准备测试场景(this: void, player: any, boss: any): void {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  if (hero != null && hero !== 0) {
    设置Boss测试单位满血(hero);
  }
  影骨测试步兵[pid] = 准备Boss测试固定步兵(影骨测试步兵[pid], 临时测试场地中心X - 220, 临时测试玩家Y + 180, 90);
  影骨测试山丘之王[pid] = 准备Boss测试固定山丘之王(影骨测试山丘之王[pid], 临时测试场地中心X + 220, 临时测试玩家Y + 180, 90);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
}

function 启动Boss测试链路(this: void, boss: any): void {
  应用Boss战启动属性配置(boss);
}

function 创建影骨测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;
  注册影骨莫特斯被动效果();
  准备测试场景(player, boss);
  启动Boss测试链路(boss);
  return 获取或创建影骨莫特斯上下文(boss);
}

function 清理影骨测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const boss = 影骨测试Boss[pid];
  if (boss != null && boss !== 0) 清理影骨莫特斯上下文(boss);
  移除Boss测试单位(影骨测试步兵[pid]);
  移除Boss测试单位(影骨测试山丘之王[pid]);
  移除Boss测试单位(boss);
  影骨测试步兵[pid] = undefined;
  影骨测试山丘之王[pid] = undefined;
  影骨测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on影骨技能1测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放影骨阴影穿梭(context);
}

function on影骨技能2测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放影骨骸骨召唤(context);
}

function on影骨技能3测试命令(this: void, player: any, context: any): void {
  const target = 影骨测试步兵[GetPlayerId(player)];
  if (context != null && Boss测试单位存活(target)) 释放影骨暗影禁锢(context, target);
}

function on影骨技能4测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放影骨幽影爆发(context);
}

function on影骨技能5测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放影骨盗贼遗产(context);
}

const 影骨莫特斯测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "阴影穿梭", 执行: on影骨技能1测试命令 },
  { 序号: 2, 名称: "骸骨召唤", 执行: on影骨技能2测试命令 },
  { 序号: 3, 名称: "暗影禁锢", 执行: on影骨技能3测试命令 },
  { 序号: 4, 名称: "幽影爆发", 执行: on影骨技能4测试命令 },
  { 序号: 5, 名称: "盗贼的遗产", 执行: on影骨技能5测试命令 },
];

注册Boss测试命令组({
  命令单位名: "影骨莫特斯",
  Boss名称: "影骨莫特斯",
  创建或获取上下文: 创建影骨测试,
  清理上下文: 清理影骨测试,
  技能命令列表: 影骨莫特斯测试技能列表,
});

export {};
