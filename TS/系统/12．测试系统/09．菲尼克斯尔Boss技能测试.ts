/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

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
const { 记录Boss自动技能启动 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位") => any;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 获取或创建菲尼克斯尔上下文, 注册菲尼克斯尔运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.03．运行时上下文") as {
  获取或创建菲尼克斯尔上下文: (this: void, boss: any) => any;
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
const { 添加元素层数 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具") as {
  添加元素层数: (this: void, unit: any, 元素: "火" | "冰" | "毒" | "暗", count: number, duration?: number) => number;
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

const 测试命令 = "phtest";
const 菲尼克斯尔单位ID = stringToFourCC("N00U");
const 测试步兵单位ID = stringToFourCC("hfoo");
const 中立敌对玩家ID = 12;
const 测试单位最大生命值 = 999999;
// 只给 phtest 使用的临时测试场地；不影响正式 Boss 战场地配置。
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试BossX = -540.6;
const 临时测试BossY = -2495.2;
const 临时测试玩家X = -540.6;
const 临时测试玩家Y = -3055.2;
const 测试命令说明 = "phtest1炽羽散射 2熔岩吐息 3凤凰漩涡 4转场 5骸骨弹幕 6怨火链接 7凤凰挽歌 8元素爆发 9核心暴露 10永恒轮回。";

const 菲尼克斯尔正式测试场地快照 = {
  战斗矩形: { 左: -928, 右: 2816, 下: -11744, 上: -7968 },
  中心点: { x: 944, y: -9856 },
  Boss初始点: { x: -244.6, y: -9805.3 },
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
const Player = jass.Player as (id: number) => any;
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
const 最近测试步兵1: Record<number, any> = {};
const 最近测试步兵2: Record<number, any> = {};

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

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[菲尼克斯尔测试] " + text);
}

function 是有效存活英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是有效存活单位(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是当前玩家测试靶(this: void, unit: any, player: any): boolean {
  return 是有效存活单位(unit) && GetPlayerId(GetOwningPlayer(unit)) === GetPlayerId(player);
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
    SetUnitPosition(cached, 临时测试BossX, 临时测试BossY);
    SetUnitFacing(cached, 270);
    设置测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    return cached;
  }

  const boss = CreateUnit(Player(中立敌对玩家ID), 菲尼克斯尔单位ID, 临时测试BossX, 临时测试BossY, 270);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 40, false);
    设置测试单位满血(boss);
  }
  return boss;
}

function 获取或创建测试步兵(this: void, 缓存表: Record<number, any>, player: any, x: number, y: number): any {
  const pid = GetPlayerId(player);
  const cached = 缓存表[pid];
  if (是当前玩家测试靶(cached, player)) {
    SetUnitPosition(cached, x, y);
    设置测试单位满血(cached);
    return cached;
  }

  const unit = CreateUnit(player, 测试步兵单位ID, x, y, 180);
  if (unit != null && unit !== 0) {
    缓存表[pid] = unit;
    设置测试单位满血(unit);
  }
  return unit;
}

function 准备菲尼克斯尔测试场景(this: void, player: any, hero: any, boss: any): any {
  SetUnitPosition(hero, 临时测试玩家X, 临时测试玩家Y);
  SetUnitFacing(hero, 90);
  设置测试单位满血(hero);
  获取或创建测试步兵(最近测试步兵1, player, 临时测试玩家X - 260, 临时测试玩家Y + 180);
  获取或创建测试步兵(最近测试步兵2, player, 临时测试玩家X + 260, 临时测试玩家Y + 180);
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
  记录Boss自动技能启动(context.Boss, "Boss战.单位");
}

function 创建并初始化菲尼克斯尔测试(this: void, player: any): any {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。");
    return undefined;
  }

  const boss = 获取或创建测试Boss(player);
  if (!是有效存活单位(boss)) {
    提示(player, "菲尼克斯尔创建失败。");
    return undefined;
  }

  const context = 准备菲尼克斯尔测试场景(player, hero, boss);
  if (context == null) {
    提示(player, "菲尼克斯尔上下文创建失败。");
    return undefined;
  }
  初始化菲尼克斯尔测试上下文(context);
  return context;
}

function 确保菲尼克斯尔第二形态(this: void, context: any): void {
  if (context.当前形态 === "第一形态") {
    切换菲尼克斯尔第二形态(context);
  }
}

function on菲尼克斯尔测试命令(this: void, player: any): void {
  const context = 创建并初始化菲尼克斯尔测试(player);
  if (context == null) return;
  提示(player, "已创建/复用菲尼克斯尔测试场景，并登记 Boss 自动技能。" + 测试命令说明);
}

function 执行菲尼克斯尔技能测试(this: void, player: any, 序号: number): void {
  const context = 创建并初始化菲尼克斯尔测试(player);
  if (context == null) return;
  const hero = 获取玩家测试基准英雄(player);

  if (序号 === 1) {
    释放菲尼克斯尔炽羽散射(context, hero);
    提示(player, "已测试：炽羽散射。");
  } else if (序号 === 2) {
    释放菲尼克斯尔熔岩吐息(context, hero);
    提示(player, "已测试：熔岩吐息。");
  } else if (序号 === 3) {
    释放菲尼克斯尔凤凰漩涡(context, hero);
    提示(player, "已测试：凤凰漩涡。");
  } else if (序号 === 4) {
    触发菲尼克斯尔P1转场(context);
    提示(player, "已测试：P1转场。");
  } else if (序号 === 5) {
    确保菲尼克斯尔第二形态(context);
    释放菲尼克斯尔骸骨弹幕(context);
    提示(player, "已测试：骸骨弹幕。");
  } else if (序号 === 6) {
    确保菲尼克斯尔第二形态(context);
    释放菲尼克斯尔怨火链接(context);
    提示(player, "已测试：怨火链接。");
  } else if (序号 === 7) {
    确保菲尼克斯尔第二形态(context);
    释放菲尼克斯尔凤凰挽歌(context);
    提示(player, "已测试：凤凰挽歌。");
  } else if (序号 === 8) {
    确保菲尼克斯尔第二形态(context);
    添加元素层数(hero, "火", 3, 30);
    添加元素层数(hero, "暗", 5, 30);
    结算菲尼克斯尔元素爆发(context);
    提示(player, "已测试：元素爆发，已给大法师预置火3/暗5。");
  } else if (序号 === 9) {
    确保菲尼克斯尔第二形态(context);
    触发菲尼克斯尔怨火核心暴露(context);
    提示(player, "已测试：怨火核心暴露。");
  } else if (序号 === 10) {
    确保菲尼克斯尔第二形态(context);
    触发菲尼克斯尔永恒轮回(context);
    提示(player, "已测试：永恒轮回。");
  }
}

function on菲尼克斯尔技能1测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 1); }
function on菲尼克斯尔技能2测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 2); }
function on菲尼克斯尔技能3测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 3); }
function on菲尼克斯尔技能4测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 4); }
function on菲尼克斯尔技能5测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 5); }
function on菲尼克斯尔技能6测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 6); }
function on菲尼克斯尔技能7测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 7); }
function on菲尼克斯尔技能8测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 8); }
function on菲尼克斯尔技能9测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 9); }
function on菲尼克斯尔技能10测试命令(this: void, player: any): void { 执行菲尼克斯尔技能测试(player, 10); }

注册聊天命令监听(测试命令, on菲尼克斯尔测试命令);
注册聊天命令监听("phtest1", on菲尼克斯尔技能1测试命令);
注册聊天命令监听("phtest2", on菲尼克斯尔技能2测试命令);
注册聊天命令监听("phtest3", on菲尼克斯尔技能3测试命令);
注册聊天命令监听("phtest4", on菲尼克斯尔技能4测试命令);
注册聊天命令监听("phtest5", on菲尼克斯尔技能5测试命令);
注册聊天命令监听("phtest6", on菲尼克斯尔技能6测试命令);
注册聊天命令监听("phtest7", on菲尼克斯尔技能7测试命令);
注册聊天命令监听("phtest8", on菲尼克斯尔技能8测试命令);
注册聊天命令监听("phtest9", on菲尼克斯尔技能9测试命令);
注册聊天命令监听("phtest10", on菲尼克斯尔技能10测试命令);

export {};
