/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
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
const { 释放影骨骸骨召唤, 创建影骨召唤物 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.04．骸骨召唤") as {
  释放影骨骸骨召唤: (this: void, context: any) => void;
  创建影骨召唤物: (this: void, context: any, unitType: number, x: number, y: number, group?: any, canReform?: boolean) => any;
};
const { 影骨莫特斯数值与表现配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置") as {
  影骨莫特斯数值与表现配置: {
    骸骨召唤: { 骷髅盗贼单位类型: string; 召唤偏移半径: number };
  };
};
const { 极坐标X, 极坐标Y } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具") as {
  极坐标X: (this: void, x: number, distance: number, angle: number) => number;
  极坐标Y: (this: void, y: number, distance: number, angle: number) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
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
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const KillUnit = jass.KillUnit as (unit: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 影骨测试Boss: Record<number, any> = {};
const 影骨测试步兵: Record<number, any> = {};
const 影骨测试山丘之王: Record<number, any> = {};

interface 影骨2Kill测试变量 {
  玩家ID: number;
  骷髅列表: any[];
  召唤组: any;
}

const 影骨2Kill测试表: Record<number, 影骨2Kill测试变量 | undefined> = {};

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
  影骨2Kill测试表[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function 准备影骨测试阶段(this: void, context: any, phase: 1 | 2 | 3): void {
  const maxLife = GetUnitStateJapi(context.Boss单位, UNIT_STATE_MAX_LIFE);
  const ratio = phase === 1 ? 1 : phase === 2 ? 0.6 : 0.3;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, maxLife * ratio);
  context.阶段 = phase;
}

function on影骨技能1测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放影骨阴影穿梭(context);
}

function on影骨技能2测试命令(this: void, _player: any, context: any): void {
  if (context != null) {
    准备影骨测试阶段(context, 1);
    释放影骨骸骨召唤(context);
  }
}

function on影骨技能2P2测试命令(this: void, _player: any, context: any): void {
  if (context != null) {
    准备影骨测试阶段(context, 2);
    释放影骨骸骨召唤(context);
  }
}

function on影骨技能2P3测试命令(this: void, _player: any, context: any): void {
  if (context != null) {
    准备影骨测试阶段(context, 3);
    释放影骨骸骨召唤(context);
  }
}

function on影骨技能2Kill延迟击杀(this: void, variable: 影骨2Kill测试变量): void {
  if (variable == null) return;
  for (let i = 0; i < variable.骷髅列表.length; i++) {
    const skeleton = variable.骷髅列表[i];
    if (Boss测试单位存活(skeleton)) KillUnit(skeleton);
  }
  if (影骨2Kill测试表[variable.玩家ID] === variable) 影骨2Kill测试表[variable.玩家ID] = undefined;
}

function on影骨技能2Kill测试命令(this: void, player: any, context: any): void {
  if (context == null || !Boss测试单位存活(context.Boss单位)) return;
  const pid = GetPlayerId(player);
  const previous = 影骨2Kill测试表[pid];
  if (previous != null) {
    previous.召唤组.已重组 = true;
    for (let i = 0; i < previous.骷髅列表.length; i++) {
      const skeleton = previous.骷髅列表[i];
      if (Boss测试单位存活(skeleton)) KillUnit(skeleton);
    }
  }

  const group = {
    ID: (context.下一个召唤组ID || 0) + 1,
    阶段: context.阶段,
    总数: 4,
    死亡数: 0,
    已重组: false,
  };
  context.下一个召唤组ID = group.ID;
  context.当前召唤组 = group;

  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  const skeletons: any[] = [];
  const skeletonTypeId = stringToFourCC(cfg.骷髅盗贼单位类型);
  for (let i = 0; i < group.总数; i++) {
    const angle = GetRandomReal(0, 360);
    const distance = GetRandomReal(80, cfg.召唤偏移半径);
    const x = 极坐标X(GetUnitX(context.Boss单位), distance, angle);
    const y = 极坐标Y(GetUnitY(context.Boss单位), distance, angle);
    const instance = 创建影骨召唤物(context, skeletonTypeId, x, y, group, true);
    if (instance != null && Boss测试单位存活(instance.单位)) skeletons.push(instance.单位);
  }
  group.总数 = skeletons.length;
  if (group.总数 <= 0) return;

  const variable: 影骨2Kill测试变量 = { 玩家ID: pid, 骷髅列表: skeletons, 召唤组: group };
  影骨2Kill测试表[pid] = variable;
  const delayedId = addDelayedCallback(2000, on影骨技能2Kill延迟击杀, variable);
  context.清理.登记延迟回调("影骨测试-2-kill", delayedId);
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
  { 序号: 2, 名称: "骸骨召唤（P1基础，死亡后重组）", 执行: on影骨技能2测试命令 },
  { 序号: 2, 命令: "2-2", 名称: "骸骨召唤（P2，死亡后重组）", 执行: on影骨技能2P2测试命令 },
  { 序号: 2, 命令: "2-3", 名称: "骸骨召唤（P3强化，死亡后不重组）", 执行: on影骨技能2P3测试命令 },
  { 序号: 2, 命令: "2-kill", 名称: "骸骨召唤快速击杀", 执行: on影骨技能2Kill测试命令 },
  { 序号: 3, 名称: "暗影禁锢", 执行: on影骨技能3测试命令 },
  { 序号: 4, 名称: "幽影爆发", 执行: on影骨技能4测试命令 },
  { 序号: 5, 名称: "盗贼的遗产", 执行: on影骨技能5测试命令 },
];

注册Boss测试命令组({
  命令单位名: "莫特斯",
  Boss名称: "影骨莫特斯",
  创建或获取上下文: 创建影骨测试,
  清理上下文: 清理影骨测试,
  技能命令列表: 影骨莫特斯测试技能列表,
});

export {};
