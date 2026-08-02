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
const { 创建测试中心平移映射, 按测试映射平移XY坐标 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  创建测试中心平移映射: (this: void, 正式中心X: number, 正式中心Y: number, 测试中心X: number, 测试中心Y: number) => any;
  按测试映射平移XY坐标: (this: void, 点: any, 映射: any) => any;
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
const { 获取或创建影骨莫特斯上下文, 清理影骨莫特斯上下文, 设置影骨莫特斯测试阶段 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文") as {
  获取或创建影骨莫特斯上下文: (this: void, boss: any) => any;
  清理影骨莫特斯上下文: (this: void, boss: any) => void;
  设置影骨莫特斯测试阶段: (this: void, context: any, 阶段: 1 | 2 | 3) => void;
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
const { 释放影骨骸骨召唤, 创建影骨召唤组, 创建影骨召唤物 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.04．骸骨召唤") as {
  释放影骨骸骨召唤: (this: void, context: any) => 影骨骸骨召唤测试组 | undefined;
  创建影骨召唤组: (this: void, context: any, 阶段?: 1 | 2 | 3, 允许重组?: boolean, 预期数量?: number) => 影骨骸骨召唤测试组;
  创建影骨召唤物: (this: void, context: any, unitType: number, x: number, y: number, group?: 影骨骸骨召唤测试组) => any;
};
const { 影骨莫特斯数值与表现配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.02．数值与表现配置") as {
  影骨莫特斯数值与表现配置: {
    骸骨召唤: { 骷髅盗贼单位类型: string; 召唤偏移半径: number };
    幽影爆发: { 召唤中心X: number; 召唤中心Y: number };
    盗贼的遗产: { 宝箱点: any[] };
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
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const KillUnit = jass.KillUnit as (unit: any) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 影骨测试Boss: Record<number, any> = {};
const 影骨测试步兵: Record<number, any> = {};
const 影骨测试山丘之王: Record<number, any> = {};

interface 影骨测试玩家英雄快照 {
  单位: any;
  X: number;
  Y: number;
  朝向: number;
}

const 影骨测试玩家英雄快照表: Record<number, 影骨测试玩家英雄快照 | undefined> = {};

interface 影骨2Kill测试变量 {
  玩家ID: number;
  骷髅列表: any[];
  召唤组: 影骨骸骨召唤测试组;
}

interface 影骨骸骨召唤测试组 {
  ID: number;
  开始批次(预期登记数量?: number): void;
  结束批次(): void;
  取单位列表(): any[];
  取总登记数量(): number;
  销毁(): void;
}

interface 影骨幽影爆发伤害测试变量 {
  来源单位: any;
  目标单位: any;
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
  if (hero != null) {
    if (影骨测试玩家英雄快照表[pid] == null) {
      影骨测试玩家英雄快照表[pid] = {
        单位: hero,
        X: GetUnitX(hero),
        Y: GetUnitY(hero),
        朝向: GetUnitFacing(hero),
      };
    }
    SetUnitPosition(hero, 临时测试场地中心X, 临时测试玩家Y);
    SetUnitFacing(hero, 90);
    设置Boss测试单位满血(hero);
  }
  影骨测试步兵[pid] = 准备Boss测试固定步兵(影骨测试步兵[pid], 临时测试场地中心X - 220, 临时测试玩家Y + 180, 90);
  影骨测试山丘之王[pid] = 准备Boss测试固定山丘之王(影骨测试山丘之王[pid], 临时测试场地中心X + 220, 临时测试玩家Y + 180, 90);
  SelectUnitForPlayerSingle(hero != null && hero !== 0 ? hero : boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
}

function 启动Boss测试链路(this: void, boss: any): void {
  应用Boss战启动属性配置(boss);
}

function 应用影骨盗贼遗产测试坐标(this: void, context: any): void {
  const cfg = 影骨莫特斯数值与表现配置;
  const 映射 = 创建测试中心平移映射(
    cfg.幽影爆发.召唤中心X,
    cfg.幽影爆发.召唤中心Y,
    临时测试场地中心X,
    临时测试场地中心Y,
  );
  const 测试宝箱点: any[] = [];
  for (let i = 0; i < cfg.盗贼的遗产.宝箱点.length; i++) {
    const 正式宝箱点 = cfg.盗贼的遗产.宝箱点[i];
    const 测试宝箱点坐标 = 按测试映射平移XY坐标(正式宝箱点, 映射);
    测试宝箱点.push({ X: 测试宝箱点坐标.X, Y: 测试宝箱点坐标.Y, 朝向: 正式宝箱点.朝向 });
  }
  context.遗产宝箱点 = 测试宝箱点;
}

function 创建影骨测试(this: void, player: any): any {
  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;
  注册影骨莫特斯被动效果();
  准备测试场景(player, boss);
  启动Boss测试链路(boss);
  const context = 获取或创建影骨莫特斯上下文(boss);
  if (context != null) 应用影骨盗贼遗产测试坐标(context);
  return context;
}

function 清理影骨测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const heroSnapshot = 影骨测试玩家英雄快照表[pid];
  if (heroSnapshot != null && Boss测试单位存活(heroSnapshot.单位)) {
    SetUnitPosition(heroSnapshot.单位, heroSnapshot.X, heroSnapshot.Y);
    SetUnitFacing(heroSnapshot.单位, heroSnapshot.朝向);
  }
  const boss = 影骨测试Boss[pid];
  if (boss != null && boss !== 0) 清理影骨莫特斯上下文(boss);
  移除Boss测试单位(影骨测试步兵[pid]);
  移除Boss测试单位(影骨测试山丘之王[pid]);
  移除Boss测试单位(boss);
  影骨测试步兵[pid] = undefined;
  影骨测试山丘之王[pid] = undefined;
  影骨测试Boss[pid] = undefined;
  影骨测试玩家英雄快照表[pid] = undefined;
  影骨2Kill测试表[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function 准备影骨测试阶段(this: void, context: any, phase: 1 | 2 | 3): void {
  const maxLife = GetUnitStateJapi(context.Boss单位, UNIT_STATE_MAX_LIFE);
  const ratio = phase === 1 ? 1 : phase === 2 ? 0.6 : 0.3;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, maxLife * ratio);
  设置影骨莫特斯测试阶段(context, phase);
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
    安排影骨阶段强化测试(_player, context, 2);
  }
}

function on影骨技能2P3测试命令(this: void, _player: any, context: any): void {
  if (context != null) {
    安排影骨阶段强化测试(_player, context, 3);
  }
}

function on影骨技能2Kill延迟击杀(this: void, variable: 影骨2Kill测试变量): void {
  if (variable == null) return;
  const skeletons = variable.召唤组.取单位列表();
  for (let i = 0; i < skeletons.length; i++) {
    const skeleton = skeletons[i];
    if (Boss测试单位存活(skeleton)) KillUnit(skeleton);
  }
  if (影骨2Kill测试表[variable.玩家ID] === variable) 影骨2Kill测试表[variable.玩家ID] = undefined;
}

function on影骨技能2Kill测试命令(this: void, player: any, context: any, phase: 1 | 2 | 3 = 1): void {
  if (context == null || !Boss测试单位存活(context.Boss单位)) return;
  准备影骨测试阶段(context, phase);
  const pid = GetPlayerId(player);
  const previous = 影骨2Kill测试表[pid];
  清理影骨上一次召唤测试(previous);

  const group = 创建影骨召唤组(context, phase, true, 4);
  context.当前召唤组 = group;

  const cfg = 影骨莫特斯数值与表现配置.骸骨召唤;
  const skeletons: any[] = [];
  const skeletonTypeId = stringToFourCC(cfg.骷髅盗贼单位类型);
  for (let i = 0; i < 4; i++) {
    const angle = GetRandomReal(0, 360);
    const distance = GetRandomReal(80, cfg.召唤偏移半径);
    const x = 极坐标X(GetUnitX(context.Boss单位), distance, angle);
    const y = 极坐标Y(GetUnitY(context.Boss单位), distance, angle);
    const instance = 创建影骨召唤物(context, skeletonTypeId, x, y, group);
    if (instance != null && Boss测试单位存活(instance.单位)) skeletons.push(instance.单位);
  }
  group.结束批次();
  if (skeletons.length <= 0) {
    group.销毁();
    return;
  }

  const variable: 影骨2Kill测试变量 = { 玩家ID: pid, 骷髅列表: skeletons, 召唤组: group };
  影骨2Kill测试表[pid] = variable;
  const delayedId = addDelayedCallback(2000, on影骨技能2Kill延迟击杀, variable);
  context.清理.登记延迟回调("影骨测试-2-kill", delayedId);
}

function 清理影骨上一次召唤测试(this: void, previous: 影骨2Kill测试变量 | undefined): void {
  if (previous == null) return;
  const skeletons = previous.召唤组.取单位列表();
  previous.召唤组.销毁();
  for (let i = 0; i < skeletons.length; i++) {
    const skeleton = skeletons[i];
    if (Boss测试单位存活(skeleton)) KillUnit(skeleton);
  }
}

function 安排影骨阶段强化测试(this: void, player: any, context: any, phase: 2 | 3): void {
  if (context == null || !Boss测试单位存活(context.Boss单位)) return;
  准备影骨测试阶段(context, phase);
  const pid = GetPlayerId(player);
  清理影骨上一次召唤测试(影骨2Kill测试表[pid]);
  const group = 释放影骨骸骨召唤(context);
  if (group == null) return;
  const skeletons = group.取单位列表();
  if (skeletons.length <= 0) return;
  const variable: 影骨2Kill测试变量 = {
    玩家ID: pid,
    骷髅列表: skeletons,
    召唤组: group,
  };
  影骨2Kill测试表[pid] = variable;
  const delayedId = addDelayedCallback(3500, on影骨技能2Kill延迟击杀, variable);
  context.清理.登记延迟回调("影骨测试-阶段强化击杀", delayedId);
}

function on影骨技能3测试命令(this: void, player: any, context: any): void {
  const target = 影骨测试步兵[GetPlayerId(player)];
  if (context != null && Boss测试单位存活(target)) {
    SelectUnitForPlayerSingle(target, player);
    释放影骨暗影禁锢(context, target);
  }
}

const 影骨幽影爆发伤害测试模块名 = "影骨-幽影爆发承伤测试";
const 影骨幽影爆发测试单次伤害 = 1000;

function 记录影骨幽影爆发测试伤害(this: void, 标签: string, 变量: 影骨幽影爆发伤害测试变量, 是否普通攻击: boolean, 伤害类型: any): void {
  if (!Boss测试单位存活(变量.来源单位) || !Boss测试单位存活(变量.目标单位)) {
    debugLogForce(影骨幽影爆发伤害测试模块名, 标签, "跳过：来源或目标无效");
    return;
  }
  const 伤害前生命 = GetUnitState(变量.目标单位, UNIT_STATE_LIFE);
  const 调用成功 = UnitDamageTarget(
    变量.来源单位,
    变量.目标单位,
    影骨幽影爆发测试单次伤害,
    是否普通攻击,
    false,
    ATTACK_TYPE_NORMAL,
    伤害类型,
    WEAPON_TYPE_WHOKNOWS,
  );
  const 伤害后生命 = GetUnitState(变量.目标单位, UNIT_STATE_LIFE);
  debugLogForce(
    影骨幽影爆发伤害测试模块名,
    标签,
    "提交值=",
    影骨幽影爆发测试单次伤害,
    "调用成功=",
    调用成功,
    "伤害前生命=",
    伤害前生命,
    "伤害后生命=",
    伤害后生命,
    "实际扣除=",
    伤害前生命 - 伤害后生命,
  );
}

function on影骨技能4_2物理伤害(this: void, 变量: 影骨幽影爆发伤害测试变量): void {
  记录影骨幽影爆发测试伤害("第1秒物理伤害", 变量, true, DAMAGE_TYPE_NORMAL);
}

function on影骨技能4_2魔法伤害(this: void, 变量: 影骨幽影爆发伤害测试变量): void {
  记录影骨幽影爆发测试伤害("第2秒魔法伤害", 变量, false, DAMAGE_TYPE_MAGIC);
}

function on影骨技能4测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放影骨幽影爆发(context);
}

function on影骨技能4_2测试命令(this: void, player: any, context: any): void {
  const 来源单位 = 影骨测试步兵[GetPlayerId(player)];
  if (context == null || !Boss测试单位存活(来源单位) || !Boss测试单位存活(context.Boss单位)) {
    debugLogForce(影骨幽影爆发伤害测试模块名, "命令4-2跳过：测试靶或莫特斯无效");
    return;
  }
  释放影骨幽影爆发(context);
  const 变量: 影骨幽影爆发伤害测试变量 = { 来源单位, 目标单位: context.Boss单位 };
  const 物理伤害回调ID = addDelayedCallback(1000, on影骨技能4_2物理伤害, 变量);
  const 魔法伤害回调ID = addDelayedCallback(2000, on影骨技能4_2魔法伤害, 变量);
  context.清理.登记延迟回调("影骨测试-4-2-物理伤害", 物理伤害回调ID);
  context.清理.登记延迟回调("影骨测试-4-2-魔法伤害", 魔法伤害回调ID);
  debugLogForce(影骨幽影爆发伤害测试模块名, "命令4-2已启动", "第1秒物理1000", "第2秒魔法1000");
}

function on影骨技能5测试命令(this: void, _player: any, context: any): void {
  if (context != null) 释放影骨盗贼遗产(context);
}

const 影骨莫特斯测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "阴影穿梭", 执行: on影骨技能1测试命令 },
  { 序号: 2, 名称: "骸骨召唤（P1基础，死亡后重组）", 执行: on影骨技能2测试命令 },
  { 序号: 2, 命令: "2-2", 名称: "骸骨召唤强化测试（P2，3.5秒后击杀，随后3秒重组）", 执行: on影骨技能2P2测试命令 },
  { 序号: 2, 命令: "2-3", 名称: "骸骨召唤强化测试（P3，攻击+30%，爆发冷却65%，3.5秒后击杀，不重组）", 执行: on影骨技能2P3测试命令 },
  { 序号: 2, 命令: "2-kill", 名称: "骸骨召唤快速击杀（P1）", 执行: on影骨技能2Kill测试命令 },
  { 序号: 3, 名称: "暗影禁锢", 执行: on影骨技能3测试命令 },
  { 序号: 4, 名称: "幽影爆发", 执行: on影骨技能4测试命令 },
  { 序号: 4, 命令: "4-2", 名称: "幽影爆发承伤测试（1秒物理，2秒魔法）", 执行: on影骨技能4_2测试命令 },
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
