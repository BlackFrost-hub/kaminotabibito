/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const globals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};

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
const { 米亚阶段阈值 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置") as {
  米亚阶段阈值: { 第二阶段生命比例: number; 第三阶段生命比例: number };
};
const { 米亚单位技能配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置") as {
  米亚单位技能配置: { BuffID: { 腐化感染: string } };
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
  释放米亚腐化转移: (this: void, context: any, nowMs: number, 指定区域?: any) => boolean;
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
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => any;
};
const {
  Boss测试单位存活,
  设置Boss测试单位满血,
  获取Boss测试玩家基准英雄,
  创建Boss测试临时步兵,
  Boss测试固定步兵最大生命值,
  准备Boss测试固定步兵,
  准备Boss测试固定山丘之王,
  移除Boss测试单位,
  注册Boss测试命令组,
} = require("系统.12．测试系统.00．Boss测试系统.index") as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  创建Boss测试临时步兵: (this: void, x: number, y: number, facing?: number) => any;
  Boss测试固定步兵最大生命值: number;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
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
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};
const 最近腐化转移测试步兵: Record<number, any> = {};
const 最近平台超载测试步兵: Record<number, any[] | undefined> = {};
const 最近腐化黏液测试步兵: Record<number, any> = {};

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
  设置Boss测试单位满血(hero);
  最近测试步兵[pid] = 准备Boss测试固定步兵(最近测试步兵[pid], 临时测试玩家X - 220, 临时测试玩家Y + 220, 90);
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 临时测试玩家X + 220, 临时测试玩家Y + 220, 90);
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

type 米亚测试阶段 = 1 | 2 | 3;

function 取米亚测试最大生命(this: void, boss: any): number {
  const 最大生命值 = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE);
  return 最大生命值 ?? 0;
}

function 设置米亚测试阶段(this: void, context: any, 阶段: 米亚测试阶段): boolean {
  const boss = context != null ? context.Boss单位 : null;
  if (context == null || !Boss测试单位存活(boss)) return false;
  const 最大生命值 = 取米亚测试最大生命(boss);
  if (!(最大生命值 > 0)) return false;

  const 生命比例 = 阶段 === 1
    ? 1
    : 阶段 === 2
      ? (米亚阶段阈值.第二阶段生命比例 + 米亚阶段阈值.第三阶段生命比例) * 0.5
      : 米亚阶段阈值.第三阶段生命比例 * 0.5;
  SetUnitState(boss, UNIT_STATE_LIFE, 最大生命值 * 生命比例);

  const 阶段ID = 阶段 === 1 ? "P1" : 阶段 === 2 ? "P2" : "P3";
  const 阶段上下文 = context.阶段上下文;
  if (阶段上下文 == null) return false;
  let 手动进入阶段结果 = true;
  if (阶段上下文.取阶段ID() !== 阶段ID) {
    手动进入阶段结果 = 阶段上下文.手动进入阶段(阶段ID, 生命比例);
    if (!手动进入阶段结果 && 阶段上下文.取阶段ID() !== 阶段ID) return false;
  }
  context.阶段 = 阶段;
  const 实际阶段ID = 阶段上下文.取阶段ID();
  return 实际阶段ID === 阶段ID;
}

function 取米亚腐化转移测试平台(this: void, context: any): any {
  const 区域列表 = context != null && context.安全域区域组 != null
    ? context.安全域区域组.区域列表
    : undefined;
  if (区域列表 == null) return undefined;
  return 区域列表[1];
}

function 准备米亚腐化转移测试步兵(this: void, playerId: number, 区域: any): any {
  const x = 区域.中心X;
  const y = 区域.中心Y;
  let target = 最近腐化转移测试步兵[playerId];
  if (!Boss测试单位存活(target)) {
    target = 创建Boss测试临时步兵(x, y, 90);
    最近腐化转移测试步兵[playerId] = target;
  } else {
    SetUnitPosition(target, x, y);
    SetUnitFacing(target, 90);
    设置Boss测试单位满血(target, Boss测试固定步兵最大生命值);
    X_FixUnitStandingSafe(target);
  }
  if (Boss测试单位存活(target)) X_FixUnitStandingSafe(target);
  return target;
}

function 准备米亚平台超载测试步兵(this: void, playerId: number, 区域: any, 目标数量: number): any[] {
  const 结果: any[] = [];
  const 缓存 = 最近平台超载测试步兵[playerId] ?? [];
  const 偏移X列表 = [-45, 0, 45];
  const 暂存X = 临时测试玩家X;
  const 暂存Y = 临时测试玩家Y - 220;

  for (let i = 目标数量; i < 缓存.length; i++) {
    const 暂存步兵 = 缓存[i];
    if (!Boss测试单位存活(暂存步兵)) continue;
    SetUnitPosition(暂存步兵, 暂存X + i * 80, 暂存Y);
    SetUnitFacing(暂存步兵, 90);
    设置Boss测试单位满血(暂存步兵, Boss测试固定步兵最大生命值);
    X_FixUnitStandingSafe(暂存步兵);
  }

  for (let i = 0; i < 目标数量; i++) {
    const x = 区域.中心X + 偏移X列表[i];
    const y = 区域.中心Y;
    let 步兵 = 缓存[i];
    const 新创建 = !Boss测试单位存活(步兵);
    if (新创建) {
      步兵 = 创建Boss测试临时步兵(x, y, 90);
      缓存[i] = 步兵;
    } else {
      SetUnitPosition(步兵, x, y);
      SetUnitFacing(步兵, 90);
      设置Boss测试单位满血(步兵, Boss测试固定步兵最大生命值);
    }
    if (!Boss测试单位存活(步兵)) continue;
    X_FixUnitStandingSafe(步兵);
    结果.push(步兵);
  }
  最近平台超载测试步兵[playerId] = 缓存;
  return 结果;
}

function 准备米亚腐化黏液测试步兵(this: void, playerId: number, boss: any): any {
  const x = GetUnitX(boss) + 120;
  const y = GetUnitY(boss);
  let target = 最近腐化黏液测试步兵[playerId];
  if (!Boss测试单位存活(target)) {
    target = 创建Boss测试临时步兵(x, y, 180);
    最近腐化黏液测试步兵[playerId] = target;
  } else {
    SetUnitPosition(target, x, y);
    SetUnitFacing(target, 180);
    设置Boss测试单位满血(target, Boss测试固定步兵最大生命值);
  }
  if (Boss测试单位存活(target)) X_FixUnitStandingSafe(target);
  return target;
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
  移除Boss测试单位(最近测试步兵[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(最近腐化黏液测试步兵[pid]);
  移除Boss测试单位(boss);
  最近测试步兵[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近测试Boss[pid] = undefined;
  最近腐化转移测试步兵[pid] = undefined;
  最近平台超载测试步兵[pid] = undefined;
  最近腐化黏液测试步兵[pid] = undefined;
  if (globals.udg_Boss === boss) globals.udg_Boss = null;
}

function on米亚技能1测试命令(this: void, player: any, context: any): void {
  const target = 最近测试步兵[GetPlayerId(player)];
  const 阶段设置成功 = 设置米亚测试阶段(context, 1);
  if (!阶段设置成功) return;
  if (!Boss测试单位存活(target)) return;
  释放米亚腐化爪击(context, target);
}

function on米亚技能2测试命令(this: void, _player: any, context: any): void {
  if (!设置米亚测试阶段(context, 1)) return;
  释放米亚污水喷吐(context);
}

function on米亚技能3测试命令(this: void, _player: any, context: any): void {
  if (!设置米亚测试阶段(context, 1)) return;
  context.已触发分身80 = false;
  const 最大生命值 = 取米亚测试最大生命(context.Boss单位);
  if (!(最大生命值 > 0)) return;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, 最大生命值 * 0.75);
  触发米亚灵猫分身(context);
}

function on米亚技能4测试命令(this: void, player: any, context: any): void {
  const 阶段设置成功 = 设置米亚测试阶段(context, 1);
  if (!阶段设置成功) return;
  const target = 最近测试步兵[GetPlayerId(player)];
  if (!Boss测试单位存活(target)) return;
  const nowMs = getServerTime();
  context.上次污染标记Ms = 0;
  给单位添加米亚腐化层数(context, target, 5, "米亚测试污染标记");
  刷新米亚污染标记(context, nowMs);
}

function on米亚技能5测试命令(this: void, _player: any, context: any): void {
  if (!设置米亚测试阶段(context, 2)) return;
  释放米亚污染脉冲(context);
}

function 米亚技能6目标观察回调(this: void, data: any): void {
  if (data == null || data.玩家 == null) return;
  const 步兵 = data.步兵;
  const 山丘之王 = data.山丘之王;
  const buffID = 米亚单位技能配置.BuffID.腐化感染;
  const 目标 = Boss测试单位存活(步兵) && getBuffRuntime(步兵, buffID) != null
    ? 步兵
    : Boss测试单位存活(山丘之王) && getBuffRuntime(山丘之王, buffID) != null
      ? 山丘之王
      : Boss测试单位存活(步兵)
        ? 步兵
        : 山丘之王;
  if (Boss测试单位存活(目标)) SelectUnitForPlayerSingle(目标, data.玩家);
}

function on米亚技能6测试命令(this: void, player: any, context: any): void {
  if (!设置米亚测试阶段(context, 2)) return;
  const pid = GetPlayerId(player);
  const 步兵 = 最近测试步兵[pid];
  const 山丘之王 = 最近测试山丘之王[pid];
  if (Boss测试单位存活(步兵)) SelectUnitForPlayerSingle(步兵, player);
  const 释放成功 = 释放米亚污水柱爆发(context);
  if (!释放成功) return;
  const 观察回调ID = addDelayedCallback(2200, 米亚技能6目标观察回调, {
    玩家: player,
    步兵,
    山丘之王,
  });
  context.清理.登记延迟回调("米亚测试-污水柱爆发目标观察", 观察回调ID);
}

function on米亚技能7测试命令(this: void, _player: any, context: any): void {
  if (!设置米亚测试阶段(context, 2)) return;
  context.腐化转移污染平台ID = "";
  释放米亚腐化转移(context, getServerTime());
}

function on米亚技能7Test测试命令(this: void, player: any, context: any): void {
  if (!设置米亚测试阶段(context, 2)) return;
  const pid = GetPlayerId(player);
  context.腐化转移污染平台ID = "";
  const 区域 = 取米亚腐化转移测试平台(context);
  if (区域 == null) return;
  const 目标 = 准备米亚腐化转移测试步兵(pid, 区域);
  if (!Boss测试单位存活(目标)) return;
  SelectUnitForPlayerSingle(目标, player);
  const nowMs = getServerTime();
  释放米亚腐化转移(context, nowMs, 区域);
}

function on米亚技能8测试命令(this: void, player: any, context: any): void {
  if (!设置米亚测试阶段(context, 2)) return;
  const pid = GetPlayerId(player);
  (context as any).平台超载测试容量覆盖 = undefined;
  context.上次平台超载检测Ms = 0;
  const 区域 = context.安全域区域组.区域列表[1];
  if (区域 != null) {
    SetUnitPosition(最近测试步兵[pid], 区域.中心X - 45, 区域.中心Y);
    SetUnitPosition(最近测试山丘之王[pid], 区域.中心X + 45, 区域.中心Y);
  }
  刷新米亚平台超载惩罚(context, getServerTime());
}

function 米亚平台超载完整测试观察回调(this: void, data: any): void {
  if (data == null || data.玩家 == null) return;
  const targets = data.目标列表 as any[];
  if (Boss测试单位存活(targets[0])) SelectUnitForPlayerSingle(targets[0], data.玩家);
}

function 执行米亚平台超载完整测试(this: void, player: any, context: any, 测试容量: number): void {
  if (!设置米亚测试阶段(context, 2)) return;
  const pid = GetPlayerId(player);
  const 区域 = 取米亚腐化转移测试平台(context);
  if (区域 == null) return;

  const 目标数量 = 测试容量 + 1;
  const 目标列表 = 准备米亚平台超载测试步兵(pid, 区域, 目标数量);
  if (目标列表.length < 目标数量) return;

  (context as any).平台超载测试容量覆盖 = 测试容量;
  context.上次平台超载检测Ms = 0;
  SelectUnitForPlayerSingle(目标列表[0], player);
  const nowMs = getServerTime();
  刷新米亚平台超载惩罚(context, nowMs);
  const 观察回调ID = addDelayedCallback(1200, 米亚平台超载完整测试观察回调, {
    玩家: player,
    目标列表,
  });
  context.清理.登记延迟回调("米亚测试-平台超载完整观察", 观察回调ID);
}

function on米亚技能8单双人完整测试命令(this: void, player: any, context: any): void {
  执行米亚平台超载完整测试(player, context, 1);
}

function on米亚技能8三四人完整测试命令(this: void, player: any, context: any): void {
  执行米亚平台超载完整测试(player, context, 2);
}

function on米亚技能9测试命令(this: void, player: any, context: any): void {
  if (!设置米亚测试阶段(context, 3)) return;
  刷新米亚腐化黏液涂层被动状态(context);
  释放米亚全场腐化黏液(context);
}

function on米亚技能9近战反噬测试命令(this: void, player: any, context: any): void {
  if (!设置米亚测试阶段(context, 3)) return;
  const boss = context.Boss单位;
  if (!Boss测试单位存活(boss)) return;
  刷新米亚腐化黏液涂层被动状态(context);

  const target = 准备米亚腐化黏液测试步兵(GetPlayerId(player), boss);
  if (!Boss测试单位存活(target)) return;
  IssueTargetOrder(target, "attack", boss);
  SelectUnitForPlayerSingle(target, player);
}

function on米亚技能10测试命令(this: void, _player: any, context: any): void {
  if (!设置米亚测试阶段(context, 3)) return;
  context.终极污染引导中 = false;
  context.已触发终极污染30 = false;
  const 最大生命值 = 取米亚测试最大生命(context.Boss单位);
  if (!(最大生命值 > 0)) return;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, 最大生命值 * 0.25);
  触发米亚终极污染(context, 0);
}

const 米亚测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: "腐化爪击（P1基础）", 执行: on米亚技能1测试命令 },
  { 序号: 2, 名称: "污水喷吐（P1基础）", 执行: on米亚技能2测试命令 },
  { 序号: 3, 名称: "灵猫分身（P1阶段阈值）", 执行: on米亚技能3测试命令 },
  { 序号: 4, 名称: "污染标记（P1被动）", 执行: on米亚技能4测试命令 },
  { 序号: 5, 名称: "污染脉冲（P2阶段）", 执行: on米亚技能5测试命令 },
  { 序号: 6, 名称: "污水柱爆发（P2阶段）", 执行: on米亚技能6测试命令 },
  { 序号: 7, 名称: "腐化转移（P2阶段）", 执行: on米亚技能7测试命令 },
  { 序号: 7, 命令: "7-test", 名称: "腐化转移（目标平台站桩步兵测试）", 执行: on米亚技能7Test测试命令 },
  { 序号: 8, 名称: "平台超载（P2阶段）", 执行: on米亚技能8测试命令 },
  { 序号: 8, 命令: "8-1-2", 名称: "平台超载（1-2人容量完整测试）", 执行: on米亚技能8单双人完整测试命令 },
  { 序号: 8, 命令: "8-3-4", 名称: "平台超载（3-4人容量完整测试）", 执行: on米亚技能8三四人完整测试命令 },
  { 序号: 9, 名称: "腐化黏液涂层（P3强化）", 执行: on米亚技能9测试命令 },
  { 序号: 9, 命令: "9-1", 名称: "腐化黏液涂层（近战反噬测试）", 执行: on米亚技能9近战反噬测试命令 },
  { 序号: 10, 名称: "终极污染（P3阶段）", 执行: on米亚技能10测试命令 },
];

注册Boss测试命令组({
  命令单位名: "米亚",
  Boss名称: "米亚",
  创建或获取上下文: 创建并初始化米亚测试,
  清理上下文: 清理米亚测试,
  技能命令列表: 米亚测试技能列表,
});

export {};
