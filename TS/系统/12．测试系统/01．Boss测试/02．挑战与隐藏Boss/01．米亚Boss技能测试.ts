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
const { 获取或创建米亚上下文, 清理米亚上下文, 注册米亚运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文") as {
  获取或创建米亚上下文: (this: void, boss: any) => any;
  清理米亚上下文: (this: void, boss: any) => void;
  注册米亚运行时: (this: void) => void;
};
const { 给单位添加米亚腐化层数 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文") as {
  给单位添加米亚腐化层数: (this: void, context: any, 单位: any, 层数: number, 原因: string) => number;
};
const { 注册米亚技能结构 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.16．技能入口") as {
  注册米亚技能结构: (this: void) => void;
};
const { 释放米亚腐化爪击 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.05．腐化爪击") as {
  释放米亚腐化爪击: (this: void, context: any, target?: any) => void;
};
const { 释放米亚污水喷吐 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.06．污水喷吐") as {
  释放米亚污水喷吐: (this: void, context: any) => void;
};
const { 触发米亚灵猫分身 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.07．灵猫分身") as {
  触发米亚灵猫分身: (this: void, context: any) => boolean;
};
const { 刷新米亚污染标记 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记") as {
  刷新米亚污染标记: (this: void, context: any, nowMs: number) => void;
};
const { 释放米亚污染脉冲 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.09．污染脉冲") as {
  释放米亚污染脉冲: (this: void, context: any) => boolean;
};
const { 释放米亚污水柱爆发 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.10．污水柱爆发") as {
  释放米亚污水柱爆发: (this: void, context: any) => boolean;
};
const { 释放米亚腐化转移 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.11．腐化转移") as {
  释放米亚腐化转移: (this: void, context: any, nowMs: number) => boolean;
};
const { 刷新米亚平台超载惩罚 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚") as {
  刷新米亚平台超载惩罚: (this: void, context: any, nowMs: number) => void;
};
const { 刷新米亚腐化黏液涂层被动状态, 释放米亚全场腐化黏液 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.13．腐化黏液涂层") as {
  刷新米亚腐化黏液涂层被动状态: (this: void, context: any) => void;
  释放米亚全场腐化黏液: (this: void, context: any) => boolean;
};
const { 触发米亚终极污染 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.14．终极污染") as {
  触发米亚终极污染: (this: void, context: any, 阈值序号: 0 | 1) => boolean;
};
const {
  米亚默认平台中心配置,
  米亚默认安全域配置表,
  设置米亚场地配置,
  重置米亚场地配置,
  清理米亚安全域矩形组,
} = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置") as {
  米亚默认平台中心配置: any;
  米亚默认安全域配置表: any[];
  设置米亚场地配置: (this: void, 安全域配置表: any[], 平台中心配置: any) => void;
  重置米亚场地配置: (this: void) => void;
  清理米亚安全域矩形组: (this: void, 区域组: any) => void;
};
const { 创建米亚安全域矩形组 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置") as {
  创建米亚安全域矩形组: (this: void) => any;
};
const { 创建测试中心平移映射, 按测试映射平移矩形, 复制平移测试矩形数组, 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  创建测试中心平移映射: (this: void, 正式中心X: number, 正式中心Y: number, 测试中心X: number, 测试中心Y: number) => any;
  按测试映射平移矩形: (this: void, 矩形: any, 映射: any) => any;
  复制平移测试矩形数组: (this: void, 矩形列表: any[], 映射: any) => any[];
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { Boss测试单位存活, 设置Boss测试单位满血, 获取Boss测试玩家基准英雄, 准备Boss测试固定步兵, 移除Boss测试单位, 注册Boss测试命令组 } = require("系统.12．测试系统.00．Boss测试系统.index") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};

const 米亚单位ID = stringToFourCC("N00V");
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家X = -540.6;
const 临时测试玩家Y = -3055.2;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵1: Record<number, any> = {};
const 最近测试步兵2: Record<number, any> = {};

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

  const boss = CreateUnit(player, 米亚单位ID, 临时测试场地中心X, 临时测试场地中心Y, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 40, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 应用米亚测试场地配置(this: void, context: any): void {
  const 正式中心X = (米亚默认平台中心配置.左 + 米亚默认平台中心配置.右) / 2;
  const 正式中心Y = (米亚默认平台中心配置.下 + 米亚默认平台中心配置.上) / 2;
  const 映射 = 创建测试中心平移映射(正式中心X, 正式中心Y, 临时测试场地中心X, 临时测试场地中心Y);
  const 测试平台中心配置 = 按测试映射平移矩形(米亚默认平台中心配置, 映射);
  const 测试安全域配置表 = 复制平移测试矩形数组(米亚默认安全域配置表, 映射);

  设置米亚场地配置(测试安全域配置表, 测试平台中心配置);
  if (context != null) {
    清理米亚安全域矩形组(context.安全域区域组);
    context.安全域区域组 = 创建米亚安全域矩形组();
  }
}

function 准备米亚测试场景(this: void, player: any, hero: any, boss: any): any {
  const pid = GetPlayerId(player);
  SetUnitPosition(hero, 临时测试玩家X, 临时测试玩家Y);
  SetUnitFacing(hero, 90);
  设置Boss测试单位满血(hero);
  最近测试步兵1[pid] = 准备Boss测试固定步兵(最近测试步兵1[pid], 临时测试玩家X - 220, 临时测试玩家Y + 220, 90);
  最近测试步兵2[pid] = 准备Boss测试固定步兵(最近测试步兵2[pid], 临时测试玩家X + 220, 临时测试玩家Y + 220, 90);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
  应用米亚测试场地配置(null);
  const context = 获取或创建米亚上下文(boss);
  应用米亚测试场地配置(context);
  return context;
}

function 初始化米亚测试上下文(this: void, context: any): void {
  注册米亚运行时();
  注册米亚技能结构();
  应用Boss战启动属性配置(context.Boss单位);
}

function 创建并初始化米亚测试(this: void, player: any): any {
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) return undefined;

  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;

  const context = 准备米亚测试场景(player, hero, boss);
  if (context == null) return undefined;
  初始化米亚测试上下文(context);
  return context;
}

function 清理米亚测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const boss = 最近测试Boss[pid];
  if (boss != null && boss !== 0) 清理米亚上下文(boss);
  重置米亚场地配置();
  移除Boss测试单位(最近测试步兵1[pid]);
  移除Boss测试单位(最近测试步兵2[pid]);
  移除Boss测试单位(boss);
  最近测试步兵1[pid] = undefined;
  最近测试步兵2[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on米亚技能1测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵1[GetPlayerId(player)];
  if (Boss测试单位存活(target)) 释放米亚腐化爪击(context, target);
}

function on米亚技能2测试命令(this: void, _player: any, context: any): void {
  释放米亚污水喷吐(context);
}

function on米亚技能3测试命令(this: void, _player: any, context: any): void {
  context.阶段 = 1;
  context.已触发分身80 = false;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE) * 0.75);
  触发米亚灵猫分身(context);
}

function on米亚技能4测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵1[GetPlayerId(player)];
  if (!Boss测试单位存活(target)) return;
  const nowMs = getServerTime();
  context.阶段 = 1;
  context.上次污染标记Ms = 0;
  给单位添加米亚腐化层数(context, target, 5, "米亚测试污染标记");
  刷新米亚污染标记(context, nowMs);
}

function on米亚技能5测试命令(this: void, _player: any, context: any): void {
  context.阶段 = 2;
  释放米亚污染脉冲(context);
}

function on米亚技能6测试命令(this: void, _player: any, context: any): void {
  context.阶段 = 2;
  释放米亚污水柱爆发(context);
}

function on米亚技能7测试命令(this: void, _player: any, context: any): void {
  context.阶段 = 2;
  context.腐化转移污染平台ID = "";
  释放米亚腐化转移(context, getServerTime());
}

function on米亚技能8测试命令(this: void, player: any, context: any): void {
  const pid = GetPlayerId(player);
  context.阶段 = 2;
  context.上次平台超载检测Ms = 0;
  const 区域 = context.安全域区域组.区域列表[1];
  if (区域 != null) {
    SetUnitPosition(最近测试步兵1[pid], 区域.中心X - 45, 区域.中心Y);
    SetUnitPosition(最近测试步兵2[pid], 区域.中心X + 45, 区域.中心Y);
  }
  刷新米亚平台超载惩罚(context, getServerTime());
}

function on米亚技能9测试命令(this: void, _player: any, context: any): void {
  context.阶段 = 3;
  刷新米亚腐化黏液涂层被动状态(context);
  释放米亚全场腐化黏液(context);
}

function on米亚技能10测试命令(this: void, _player: any, context: any): void {
  context.阶段 = 3;
  context.终极污染引导中 = false;
  context.已触发终极污染30 = false;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE) * 0.25);
  触发米亚终极污染(context, 0);
}

const 米亚测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "腐化爪击", 执行: on米亚技能1测试命令 },
  { 序号: 2, 名称: "污水喷吐", 执行: on米亚技能2测试命令 },
  { 序号: 3, 名称: "灵猫分身", 执行: on米亚技能3测试命令 },
  { 序号: 4, 名称: "污染标记", 执行: on米亚技能4测试命令 },
  { 序号: 5, 名称: "污染脉冲", 执行: on米亚技能5测试命令 },
  { 序号: 6, 名称: "污水柱爆发", 执行: on米亚技能6测试命令 },
  { 序号: 7, 名称: "腐化转移", 执行: on米亚技能7测试命令 },
  { 序号: 8, 名称: "平台超载", 执行: on米亚技能8测试命令 },
  { 序号: 9, 名称: "腐化黏液涂层", 执行: on米亚技能9测试命令 },
  { 序号: 10, 名称: "终极污染", 执行: on米亚技能10测试命令 },
];

注册Boss测试命令组({
  命令单位名: "米亚",
  Boss名称: "米亚",
  创建或获取上下文: 创建并初始化米亚测试,
  清理上下文: 清理米亚测试,
  技能命令列表: 米亚测试技能列表,
});

export {};
