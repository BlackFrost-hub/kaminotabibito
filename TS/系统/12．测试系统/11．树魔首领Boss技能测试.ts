/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; udg_Boss?: any; [key: string]: any };

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { SelectUnitForPlayerSingle } = require("lib.扩展函数.BJ函数.index") as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 记录Boss自动技能启动 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位") => any;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 获取或创建树魔首领上下文 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.01．运行时上下文") as {
  获取或创建树魔首领上下文: (this: void, boss: any) => any;
};
const { 注册树魔首领被动效果 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.10．被动效果") as {
  注册树魔首领被动效果: (this: void) => void;
};
const { 释放树魔首领扩散冲击波 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.04．扩散冲击波") as {
  释放树魔首领扩散冲击波: (this: void, context: any) => void;
};
const { 释放树魔首领消耗反击 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.05．消耗反击") as {
  释放树魔首领消耗反击: (this: void, context: any) => void;
};
const { 释放树魔首领远古诅咒 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.06．远古诅咒") as {
  释放树魔首领远古诅咒: (this: void, context: any) => void;
};
const { 释放树魔首领树魔图腾 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.07．树魔图腾") as {
  释放树魔首领树魔图腾: (this: void, context: any) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const 测试命令 = "smltest";
const 树魔首领单位ID = stringToFourCC("N05S");
const 测试辅助英雄ID = stringToFourCC("Hpal");
const 中立敌对玩家ID = 12;
const 测试单位最大生命值 = 999999;
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家Y = -3055.2;
const 测试命令说明 = "smltest1扩散冲击波 2消耗反击 3远古诅咒 4树魔图腾 5立即召唤随从。";

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (id: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer as (whichGroup: any, whichPlayer: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;

const 最近测试Boss: Record<number, any> = {};
const 最近测试辅助英雄1: Record<number, any> = {};
const 最近测试辅助英雄2: Record<number, any> = {};

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[树魔首领测试] " + text);
}

function 是有效存活英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是有效存活单位(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 设置测试单位满血(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, 测试单位最大生命值);
  SetUnitState(unit, UNIT_STATE_LIFE, 测试单位最大生命值);
}

function 获取玩家测试基准英雄(this: void, player: any): any {
  const presetArchmage = globals.gg_unit_Hamg_0002;
  if (是有效存活英雄(presetArchmage)) return presetArchmage;

  const registeredHero = getRegisteredPlayerHero(player);
  if (是有效存活英雄(registeredHero)) return registeredHero;

  const group = CreateGroup();
  GroupEnumUnitsOfPlayer(group, player, null);
  let result: any = null;
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (是有效存活英雄(unit)) {
      result = unit;
      break;
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  return result;
}

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 最近测试Boss[pid];
  if (是有效存活单位(cached)) {
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置测试单位满血(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(Player(中立敌对玩家ID), 树魔首领单位ID, 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    SetHeroLevel(boss, 35, false);
    设置测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 获取或创建辅助英雄(this: void, 缓存表: Record<number, any>, ownerId: number, x: number, y: number): any {
  const cached = 缓存表[ownerId];
  if (是有效存活英雄(cached)) {
    SetUnitPosition(cached, x, y);
    设置测试单位满血(cached);
    return cached;
  }

  const unit = CreateUnit(Player(ownerId), 测试辅助英雄ID, x, y, 90);
  if (unit != null && unit !== 0) {
    缓存表[ownerId] = unit;
    SetHeroLevel(unit, 10, false);
    设置测试单位满血(unit);
  }
  return unit;
}

function 准备树魔首领测试场景(this: void, player: any, hero: any, boss: any): any {
  SetUnitPosition(hero, 临时测试场地中心X, 临时测试玩家Y);
  SetUnitFacing(hero, 90);
  设置测试单位满血(hero);
  获取或创建辅助英雄(最近测试辅助英雄1, 1, 临时测试场地中心X - 180, 临时测试玩家Y + 90);
  获取或创建辅助英雄(最近测试辅助英雄2, 2, 临时测试场地中心X + 180, 临时测试玩家Y + 90);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
  return 获取或创建树魔首领上下文(boss);
}

function 创建并初始化树魔首领测试(this: void, player: any): any {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。");
    return undefined;
  }

  const boss = 获取或创建测试Boss(player);
  if (!是有效存活单位(boss)) {
    提示(player, "树魔首领创建失败。");
    return undefined;
  }

  注册树魔首领被动效果();
  应用Boss战启动属性配置(boss);
  记录Boss自动技能启动(boss, "Boss战.单位");
  const context = 准备树魔首领测试场景(player, hero, boss);
  if (context == null) 提示(player, "树魔首领上下文创建失败。");
  return context;
}

function on树魔首领测试命令(this: void, player: any): void {
  const context = 创建并初始化树魔首领测试(player);
  if (context == null) return;
  提示(player, "已创建/复用树魔首领测试场景，并登记 Boss 自动技能。" + 测试命令说明);
}

function 执行树魔首领技能测试(this: void, player: any, 序号: number): void {
  const context = 创建并初始化树魔首领测试(player);
  if (context == null) return;

  if (序号 === 1) {
    释放树魔首领扩散冲击波(context);
    提示(player, "已测试：扩散冲击波。");
  } else if (序号 === 2) {
    释放树魔首领消耗反击(context);
    提示(player, "已测试：消耗反击。请从正面/背后攻击 Boss 验证反击与破招。");
  } else if (序号 === 3) {
    释放树魔首领远古诅咒(context);
    提示(player, "已测试：远古诅咒。三个测试英雄已聚在 400 码附近，便于观察分摊。");
  } else if (序号 === 4) {
    释放树魔首领树魔图腾(context);
    提示(player, "已测试：树魔图腾。");
  } else if (序号 === 5) {
    context.随从特性已初始化 = true;
    context.下一次召唤Ms = getServerTime();
    提示(player, "已把下一次随从召唤推进到立刻，等待 1 秒左右观察随从与 Buff 切换。");
  }
}

function on树魔首领技能1测试命令(this: void, player: any): void { 执行树魔首领技能测试(player, 1); }
function on树魔首领技能2测试命令(this: void, player: any): void { 执行树魔首领技能测试(player, 2); }
function on树魔首领技能3测试命令(this: void, player: any): void { 执行树魔首领技能测试(player, 3); }
function on树魔首领技能4测试命令(this: void, player: any): void { 执行树魔首领技能测试(player, 4); }
function on树魔首领技能5测试命令(this: void, player: any): void { 执行树魔首领技能测试(player, 5); }

注册聊天命令监听(测试命令, on树魔首领测试命令);
注册聊天命令监听("smltest1", on树魔首领技能1测试命令);
注册聊天命令监听("smltest2", on树魔首领技能2测试命令);
注册聊天命令监听("smltest3", on树魔首领技能3测试命令);
注册聊天命令监听("smltest4", on树魔首领技能4测试命令);
注册聊天命令监听("smltest5", on树魔首领技能5测试命令);

export {};
