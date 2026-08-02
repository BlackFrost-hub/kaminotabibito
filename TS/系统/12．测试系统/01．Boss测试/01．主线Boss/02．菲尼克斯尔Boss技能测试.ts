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
const { 获取或创建菲尼克斯尔上下文, 清理菲尼克斯尔上下文, 注册菲尼克斯尔运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.03．运行时上下文") as {
  获取或创建菲尼克斯尔上下文: (this: void, boss: any) => any;
  清理菲尼克斯尔上下文: (this: void, boss: any) => void;
  注册菲尼克斯尔运行时: (this: void) => void;
};
const { 注册菲尼克斯尔技能结构 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.18．技能入口") as {
  注册菲尼克斯尔技能结构: (this: void) => void;
};
const { 初始化菲尼克斯尔永恒冰核与导管 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.05．永恒冰核与导管") as {
  初始化菲尼克斯尔永恒冰核与导管: (this: void, context: any) => void;
};
const { 释放菲尼克斯尔炽羽散射 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.06．炽羽散射") as {
  释放菲尼克斯尔炽羽散射: (this: void, context: any, target?: any) => void;
};
const { 释放菲尼克斯尔熔岩吐息 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.07．熔岩吐息") as {
  释放菲尼克斯尔熔岩吐息: (this: void, context: any, target?: any) => void;
};
const { 释放菲尼克斯尔凤凰漩涡 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.08．凤凰漩涡") as {
  释放菲尼克斯尔凤凰漩涡: (this: void, context: any, target?: any) => void;
};
const { 触发菲尼克斯尔P1转场 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.09．浴火重生准备") as {
  触发菲尼克斯尔P1转场: (this: void, context: any) => void;
};
const { 切换菲尼克斯尔第二形态 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.04．双形态转换") as {
  切换菲尼克斯尔第二形态: (this: void, context: any) => void;
};
const { 释放菲尼克斯尔骸骨弹幕 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.11．骸骨弹幕") as {
  释放菲尼克斯尔骸骨弹幕: (this: void, context: any) => void;
};
const { 释放菲尼克斯尔怨火链接 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.12．怨火链接") as {
  释放菲尼克斯尔怨火链接: (this: void, context: any) => void;
};
const { 释放菲尼克斯尔凤凰挽歌 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.13．凤凰挽歌") as {
  释放菲尼克斯尔凤凰挽歌: (this: void, context: any) => void;
};
const { 结算菲尼克斯尔元素爆发 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.14．元素爆发") as {
  结算菲尼克斯尔元素爆发: (this: void, context: any) => void;
};
const { 触发菲尼克斯尔怨火核心暴露 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.15．怨火核心暴露") as {
  触发菲尼克斯尔怨火核心暴露: (this: void, context: any) => void;
};
const { 触发菲尼克斯尔永恒轮回 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.16．永恒轮回") as {
  触发菲尼克斯尔永恒轮回: (this: void, context: any) => void;
};
const { 延迟, 添加元素层数, 减少元素层数 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具") as {
  延迟: (this: void, delayMs: number, callback: (this: void) => void) => any;
  添加元素层数: (this: void, unit: any, 元素: "火" | "冰" | "毒" | "暗", count: number, duration?: number) => number;
  减少元素层数: (this: void, unit: any, 元素: "火" | "冰" | "毒" | "暗", count: number) => void;
};
const { 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 菲尼克斯尔场地配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.01．场地配置") as {
  菲尼克斯尔场地配置: any;
};
const { 创建测试中心平移映射, 按测试映射平移坐标, 按测试映射平移矩形, 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  创建测试中心平移映射: (this: void, 正式中心X: number, 正式中心Y: number, 测试中心X: number, 测试中心Y: number) => any;
  按测试映射平移坐标: (this: void, 点: any, 映射: any) => any;
  按测试映射平移矩形: (this: void, 矩形: any, 映射: any) => any;
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

const 菲尼克斯尔单位ID = stringToFourCC("N00U");
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试BossX = -540.6;
const 临时测试BossY = -2495.2;
const 临时测试玩家X = -540.6;
const 临时测试玩家Y = -3055.2;

const 菲尼克斯尔正式测试场地快照 = {
  战斗矩形: { 左: -928, 右: 2816, 下: -11744, 上: -7968 },
  中心点: { x: 944, y: -9856 },
  Boss初始点: { x: 15429.9, y: -4014.9 },
  永恒冰核点: { x: 944, y: -9856 },
  导管点位: [
    { x: 44, y: -10756 },
    { x: 1844, y: -10756 },
    { x: 44, y: -8956 },
    { x: 1844, y: -8956 },
  ],
  怨火核心点: { x: 944, y: -9856 },
  凤凰蛋点位: [
    { x: 44, y: -10756 },
    { x: 1844, y: -10756 },
    { x: 44, y: -8956 },
    { x: 1844, y: -8956 },
  ],
  挽歌安全区点位: [
    { x: 44, y: -10756, 元素: "火" },
    { x: 1844, y: -10756, 元素: "冰" },
    { x: 44, y: -8956, 元素: "毒" },
    { x: 1844, y: -8956, 元素: "暗" },
  ],
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const KillUnit = jass.KillUnit as (whichUnit: any) => void;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};
function 复制映射菲尼克斯尔点位数组(this: void, 点位: any[], 映射: any): any[] {
  const result: any[] = [];
  for (let i = 0; i < 点位.length; i++) {
    const mapped = 按测试映射平移坐标(点位[i], 映射);
    if (点位[i].元素 != null) {
      result.push({ x: mapped.x, y: mapped.y, 元素: 点位[i].元素 });
    } else {
      result.push(mapped);
    }
  }
  return result;
}

function 应用菲尼克斯尔测试场地(this: void): void {
  const 映射 = 创建测试中心平移映射(
    菲尼克斯尔正式测试场地快照.中心点.x,
    菲尼克斯尔正式测试场地快照.中心点.y,
    临时测试场地中心X,
    临时测试场地中心Y,
  );
  菲尼克斯尔场地配置.战斗矩形 = 按测试映射平移矩形(菲尼克斯尔正式测试场地快照.战斗矩形, 映射);
  菲尼克斯尔场地配置.中心点 = 按测试映射平移坐标(菲尼克斯尔正式测试场地快照.中心点, 映射);
  菲尼克斯尔场地配置.Boss初始点 = 按测试映射平移坐标(菲尼克斯尔正式测试场地快照.Boss初始点, 映射);
  菲尼克斯尔场地配置.永恒冰核点 = 按测试映射平移坐标(菲尼克斯尔正式测试场地快照.永恒冰核点, 映射);
  菲尼克斯尔场地配置.导管点位 = 复制映射菲尼克斯尔点位数组(菲尼克斯尔正式测试场地快照.导管点位, 映射);
  菲尼克斯尔场地配置.怨火核心点 = 按测试映射平移坐标(菲尼克斯尔正式测试场地快照.怨火核心点, 映射);
  菲尼克斯尔场地配置.凤凰蛋点位 = 复制映射菲尼克斯尔点位数组(菲尼克斯尔正式测试场地快照.凤凰蛋点位, 映射);
  菲尼克斯尔场地配置.挽歌安全区点位 = 复制映射菲尼克斯尔点位数组(菲尼克斯尔正式测试场地快照.挽歌安全区点位, 映射);
}

function 复制菲尼克斯尔正式点位数组(this: void, 点位: any[]): any[] {
  const result: any[] = [];
  for (let i = 0; i < 点位.length; i++) {
    const item = 点位[i];
    if (item.元素 != null) {
      result.push({ x: item.x, y: item.y, 元素: item.元素 });
    } else {
      result.push({ x: item.x, y: item.y });
    }
  }
  return result;
}

function 恢复菲尼克斯尔正式场地(this: void): void {
  const snapshot = 菲尼克斯尔正式测试场地快照;
  菲尼克斯尔场地配置.战斗矩形 = {
    左: snapshot.战斗矩形.左,
    右: snapshot.战斗矩形.右,
    下: snapshot.战斗矩形.下,
    上: snapshot.战斗矩形.上,
  };
  菲尼克斯尔场地配置.中心点 = { x: snapshot.中心点.x, y: snapshot.中心点.y };
  菲尼克斯尔场地配置.Boss初始点 = { x: snapshot.Boss初始点.x, y: snapshot.Boss初始点.y };
  菲尼克斯尔场地配置.永恒冰核点 = { x: snapshot.永恒冰核点.x, y: snapshot.永恒冰核点.y };
  菲尼克斯尔场地配置.导管点位 = 复制菲尼克斯尔正式点位数组(snapshot.导管点位);
  菲尼克斯尔场地配置.怨火核心点 = { x: snapshot.怨火核心点.x, y: snapshot.怨火核心点.y };
  菲尼克斯尔场地配置.凤凰蛋点位 = 复制菲尼克斯尔正式点位数组(snapshot.凤凰蛋点位);
  菲尼克斯尔场地配置.挽歌安全区点位 = 复制菲尼克斯尔正式点位数组(snapshot.挽歌安全区点位);
}

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 获取或创建测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  const cached = 最近测试Boss[pid];
  if (Boss测试单位存活(cached)) {
    SetUnitPosition(cached, 临时测试BossX, 临时测试BossY);
    SetUnitFacing(cached, 270);
    设置Boss测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    globals.udg_Boss = cached;
    return cached;
  }

  const boss = CreateUnit(player, 菲尼克斯尔单位ID, 临时测试BossX, 临时测试BossY, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 40, false);
    设置Boss测试单位满血(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 准备菲尼克斯尔测试场景(this: void, player: any, hero: any, boss: any): any {
  const pid = GetPlayerId(player);
  设置Boss测试单位满血(hero);
  最近测试步兵[pid] = 准备Boss测试固定步兵(最近测试步兵[pid], 临时测试玩家X - 260, 临时测试玩家Y + 180, 90);
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 临时测试玩家X + 260, 临时测试玩家Y + 180, 90);
  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 临时测试场地中心X, 临时测试场地中心Y, 0.2);
  return 获取或创建菲尼克斯尔上下文(boss);
}

function 初始化菲尼克斯尔测试上下文(this: void, context: any): void {
  注册菲尼克斯尔运行时();
  注册菲尼克斯尔技能结构();
  应用菲尼克斯尔测试场地();
  初始化菲尼克斯尔永恒冰核与导管(context);
  应用Boss战启动属性配置(context.Boss);
}

function 创建并初始化菲尼克斯尔测试(this: void, player: any): any {
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) return undefined;

  const boss = 获取或创建测试Boss(player);
  if (!Boss测试单位存活(boss)) return undefined;

  const context = 准备菲尼克斯尔测试场景(player, hero, boss);
  if (context == null) return undefined;
  初始化菲尼克斯尔测试上下文(context);
  return context;
}

function 确保菲尼克斯尔第二形态(this: void, context: any): void {
  if (context.当前形态 === "第一形态") {
    切换菲尼克斯尔第二形态(context);
  }
}

function 清理菲尼克斯尔测试(this: void, player: any, _context: any): void {
  const pid = GetPlayerId(player);
  const boss = 最近测试Boss[pid];
  if (boss != null && boss !== 0) 清理菲尼克斯尔上下文(boss);
  恢复菲尼克斯尔正式场地();
  移除Boss测试单位(最近测试步兵[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(boss);
  最近测试步兵[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on菲尼克斯尔技能1测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵[GetPlayerId(player)];
  if (Boss测试单位存活(target)) 释放菲尼克斯尔炽羽散射(context, target);
}

function on菲尼克斯尔技能2测试命令(this: void, player: any, context: any): void {
  const target = 获取Boss测试玩家基准英雄(player);
  if (Boss测试单位存活(target)) 释放菲尼克斯尔熔岩吐息(context, target);
}

function on菲尼克斯尔技能3测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵[GetPlayerId(player)];
  if (Boss测试单位存活(target)) 释放菲尼克斯尔凤凰漩涡(context, target);
}

function on菲尼克斯尔技能4测试命令(this: void, _player: any, context: any): void {
  触发菲尼克斯尔P1转场(context);
}

function on菲尼克斯尔技能5测试命令(this: void, _player: any, context: any): void {
  确保菲尼克斯尔第二形态(context);
  释放菲尼克斯尔骸骨弹幕(context);
}

function on菲尼克斯尔技能6测试命令(this: void, _player: any, context: any): void {
  确保菲尼克斯尔第二形态(context);
  释放菲尼克斯尔怨火链接(context);
}

function on菲尼克斯尔技能7测试命令(this: void, _player: any, context: any): void {
  确保菲尼克斯尔第二形态(context);
  释放菲尼克斯尔凤凰挽歌(context);
}

function on菲尼克斯尔凤凰挽歌安全区测试命令(this: void, player: any, context: any, 安全区索引: number): void {
  const target = 最近测试步兵[GetPlayerId(player)];
  if (!Boss测试单位存活(target)) {
    return;
  }
  确保菲尼克斯尔第二形态(context);
  const point = 菲尼克斯尔场地配置.挽歌安全区点位[安全区索引 + 1];
  if (point == null) {
    return;
  }
  SetUnitPosition(target, point.x, point.y);
  释放菲尼克斯尔凤凰挽歌(context);
}

function on菲尼克斯尔凤凰挽歌火安全区测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔凤凰挽歌安全区测试命令(player, context, 0);
}

function on菲尼克斯尔凤凰挽歌冰安全区测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔凤凰挽歌安全区测试命令(player, context, 1);
}

function on菲尼克斯尔凤凰挽歌毒安全区测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔凤凰挽歌安全区测试命令(player, context, 2);
}

function on菲尼克斯尔凤凰挽歌暗安全区测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔凤凰挽歌安全区测试命令(player, context, 3);
}

function 清空菲尼克斯尔测试元素层数(this: void, target: any): void {
  减少元素层数(target, "火", 999);
  减少元素层数(target, "冰", 999);
  减少元素层数(target, "毒", 999);
  减少元素层数(target, "暗", 999);
  移除单位指定Buff(target, "BPH8");
  移除单位指定Buff(target, "BPH9");
}

function on菲尼克斯尔技能8测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵[GetPlayerId(player)];
  if (!Boss测试单位存活(target)) return;
  确保菲尼克斯尔第二形态(context);
  清空菲尼克斯尔测试元素层数(target);
  const 元素列表: ("火" | "冰" | "毒" | "暗")[] = ["火", "冰", "毒", "暗"];
  const 随机元素 = 元素列表[GetRandomInt(0, 元素列表.length - 1)];
  添加元素层数(target, 随机元素, 5, 30);
  结算菲尼克斯尔元素爆发(context);
}

function on菲尼克斯尔技能8火测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔元素爆发指定元素测试(player, context, "火");
}

function on菲尼克斯尔元素爆发指定元素测试(this: void, player: any, context: any, 元素: "火" | "冰" | "毒" | "暗"): void {
  const target = 最近测试步兵[GetPlayerId(player)];
  if (!Boss测试单位存活(target)) return;
  确保菲尼克斯尔第二形态(context);
  清空菲尼克斯尔测试元素层数(target);
  添加元素层数(target, 元素, 5, 30);
  结算菲尼克斯尔元素爆发(context);
}

function on菲尼克斯尔技能8冰测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔元素爆发指定元素测试(player, context, "冰");
}

function on菲尼克斯尔技能8毒测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔元素爆发指定元素测试(player, context, "毒");
}

function 创建菲尼克斯尔毒火枯竭治疗测试回调(this: void, target: any): (this: void) => void {
  return function 菲尼克斯尔毒火枯竭治疗测试(this: void): void {
    if (!Boss测试单位存活(target)) return;
    const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
    const requested = maxLife * 0.5;
    doHeal({
      HealSource: target,
      HealTarget: target,
      HealAmount: requested,
      ItemHeal: false,
      HealEffect: true,
    });
  };
}

function on菲尼克斯尔技能8毒治疗测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵[GetPlayerId(player)];
  if (!Boss测试单位存活(target)) return;
  const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
  SetUnitState(target, UNIT_STATE_LIFE, maxLife * 0.2);
  on菲尼克斯尔元素爆发指定元素测试(player, context, "毒");
  const callbackId = 延迟(3200, 创建菲尼克斯尔毒火枯竭治疗测试回调(target));
  context.清理.登记延迟回调("菲尼克斯尔测试-毒火枯竭治疗", callbackId);
}

function on菲尼克斯尔技能8暗测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔元素爆发指定元素测试(player, context, "暗");
}

function 创建菲尼克斯尔暗火增幅后续测试回调(this: void, context: any): (this: void) => void {
  return function 菲尼克斯尔暗火增幅后续测试(this: void): void {
    释放菲尼克斯尔骸骨弹幕(context);
  };
}

function on菲尼克斯尔技能8暗后续测试命令(this: void, player: any, context: any): void {
  on菲尼克斯尔元素爆发指定元素测试(player, context, "暗");
  const callbackId = 延迟(3200, 创建菲尼克斯尔暗火增幅后续测试回调(context));
  context.清理.登记延迟回调("菲尼克斯尔测试-暗火增幅后续技能", callbackId);
}

function on菲尼克斯尔技能9测试命令(this: void, _player: any, context: any): void {
  确保菲尼克斯尔第二形态(context);
  触发菲尼克斯尔怨火核心暴露(context);
}

function 创建菲尼克斯尔技能9击杀核心回调(this: void, context: any, source: any): (this: void) => void {
  return function 菲尼克斯尔技能9延迟击杀核心(this: void): void {
    if (!Boss测试单位存活(context.怨火核心)) return;
    if (Boss测试单位存活(source)) {
      const 剩余生命 = GetUnitState(context.怨火核心, jass.UNIT_STATE_LIFE);
      UnitDamageTarget(source, context.怨火核心, 剩余生命 + 1, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_MIND, jass.WEAPON_TYPE_WHOKNOWS);
    } else {
      KillUnit(context.怨火核心);
    }
  };
}

function on菲尼克斯尔技能9击杀测试命令(this: void, player: any, context: any): void {
  确保菲尼克斯尔第二形态(context);
  触发菲尼克斯尔怨火核心暴露(context);
  const source = 最近测试步兵[GetPlayerId(player)];
  延迟(1000, 创建菲尼克斯尔技能9击杀核心回调(context, source));
}

function on菲尼克斯尔技能10测试命令(this: void, _player: any, context: any): void {
  确保菲尼克斯尔第二形态(context);
  触发菲尼克斯尔永恒轮回(context);
}

function 创建菲尼克斯尔永恒轮回成功回调(this: void, context: any): (this: void) => void {
  return function 菲尼克斯尔永恒轮回成功结算(this: void): void {
    on菲尼克斯尔永恒轮回成功结算(context);
  };
}

function on菲尼克斯尔永恒轮回成功结算(this: void, context: any): void {
  if (context == null || context.凤凰蛋列表 == null) return;
  for (let i = 0; i < context.凤凰蛋列表.length; i++) {
    const egg = context.凤凰蛋列表[i].单位;
    if (Boss测试单位存活(egg)) KillUnit(egg);
  }
}

function on菲尼克斯尔技能10成功测试命令(this: void, _player: any, context: any): void {
  确保菲尼克斯尔第二形态(context);
  触发菲尼克斯尔永恒轮回(context);
  const callbackId = 延迟(1000, 创建菲尼克斯尔永恒轮回成功回调(context));
  context.清理.登记延迟回调("菲尼克斯尔测试-永恒轮回成功", callbackId);
}

const 菲尼克斯尔测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "炽羽散射", 执行: on菲尼克斯尔技能1测试命令 },
  { 序号: 2, 名称: "熔岩吐息", 执行: on菲尼克斯尔技能2测试命令 },
  { 序号: 3, 名称: "凤凰漩涡", 执行: on菲尼克斯尔技能3测试命令 },
  { 序号: 4, 名称: "P1转场", 执行: on菲尼克斯尔技能4测试命令 },
  { 序号: 5, 名称: "骸骨弹幕", 执行: on菲尼克斯尔技能5测试命令 },
  { 序号: 6, 名称: "怨火链接", 执行: on菲尼克斯尔技能6测试命令 },
  { 序号: 7, 名称: "凤凰挽歌", 执行: on菲尼克斯尔技能7测试命令 },
  { 序号: 72, 命令: "7-2", 名称: "凤凰挽歌(站在火安全区)", 执行: on菲尼克斯尔凤凰挽歌火安全区测试命令 },
  { 序号: 73, 命令: "7-3", 名称: "凤凰挽歌(站在冰安全区)", 执行: on菲尼克斯尔凤凰挽歌冰安全区测试命令 },
  { 序号: 74, 命令: "7-4", 名称: "凤凰挽歌(站在毒安全区)", 执行: on菲尼克斯尔凤凰挽歌毒安全区测试命令 },
  { 序号: 75, 命令: "7-5", 名称: "凤凰挽歌(站在暗安全区)", 执行: on菲尼克斯尔凤凰挽歌暗安全区测试命令 },
  { 序号: 8, 名称: "元素爆发(随机)", 执行: on菲尼克斯尔技能8测试命令 },
  { 序号: 82, 命令: "8-2", 名称: "元素爆发(火)", 执行: on菲尼克斯尔技能8火测试命令 },
  { 序号: 83, 命令: "8-3", 名称: "元素爆发(冰)", 执行: on菲尼克斯尔技能8冰测试命令 },
  { 序号: 84, 命令: "8-4", 名称: "元素爆发(毒)", 执行: on菲尼克斯尔技能8毒测试命令 },
  { 序号: 842, 命令: "8-4-2", 名称: "元素爆发(毒后验证治疗降低)", 执行: on菲尼克斯尔技能8毒治疗测试命令 },
  { 序号: 85, 命令: "8-5", 名称: "元素爆发(暗)", 执行: on菲尼克斯尔技能8暗测试命令 },
  { 序号: 856, 命令: "8-5-2", 名称: "元素爆发(暗后接骸骨弹幕)", 执行: on菲尼克斯尔技能8暗后续测试命令 },
  { 序号: 9, 名称: "怨火核心暴露", 执行: on菲尼克斯尔技能9测试命令 },
  { 序号: 91, 命令: "9-1", 名称: "怨火核心暴露(1秒后击杀)", 执行: on菲尼克斯尔技能9击杀测试命令 },
  { 序号: 10, 名称: "永恒轮回(凤凰蛋存活失败)", 执行: on菲尼克斯尔技能10测试命令 },
  { 序号: 10, 命令: "10-2", 名称: "永恒轮回(1秒内摧毁全部凤凰蛋)", 执行: on菲尼克斯尔技能10成功测试命令 },
];

注册Boss测试命令组({
  命令单位名: "菲尼克斯尔",
  Boss名称: "菲尼克斯尔",
  创建或获取上下文: 创建并初始化菲尼克斯尔测试,
  清理上下文: 清理菲尼克斯尔测试,
  技能命令列表: 菲尼克斯尔测试技能列表,
});

export {};
