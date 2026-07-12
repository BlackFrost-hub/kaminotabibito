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
const { 记录Boss自动技能启动 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位") => any;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.03．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 获取或创建米亚上下文, 注册米亚运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文") as {
  获取或创建米亚上下文: (this: void, boss: any) => any;
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
const { 尝试触发米亚灵猫分身 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.07．灵猫分身") as {
  尝试触发米亚灵猫分身: (this: void, context: any) => void;
};
const { 刷新米亚污染标记 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.08．污染标记") as {
  刷新米亚污染标记: (this: void, context: any, nowMs: number) => void;
};
const { 尝试触发米亚污染脉冲 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.09．污染脉冲") as {
  尝试触发米亚污染脉冲: (this: void, context: any, nowMs: number) => void;
};
const { 尝试触发米亚污水柱爆发 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.10．污水柱爆发") as {
  尝试触发米亚污水柱爆发: (this: void, context: any, nowMs: number) => void;
};
const { 尝试触发米亚腐化转移 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.11．腐化转移") as {
  尝试触发米亚腐化转移: (this: void, context: any, nowMs: number) => void;
};
const { 刷新米亚平台超载惩罚 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.12．平台超载惩罚") as {
  刷新米亚平台超载惩罚: (this: void, context: any, nowMs: number) => void;
};
const { 刷新米亚腐化黏液涂层 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.13．腐化黏液涂层") as {
  刷新米亚腐化黏液涂层: (this: void, context: any, nowMs: number) => void;
};
const { 尝试触发米亚终极污染 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.14．终极污染") as {
  尝试触发米亚终极污染: (this: void, context: any) => void;
};
const {
  米亚默认平台中心配置,
  米亚默认安全域配置表,
  设置米亚场地配置,
  清理米亚安全域矩形组,
} = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.01．场地配置") as {
  米亚默认平台中心配置: any;
  米亚默认安全域配置表: any[];
  设置米亚场地配置: (this: void, 安全域配置表: any[], 平台中心配置: any) => void;
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

const 测试命令 = "miatest";
const 米亚单位ID = stringToFourCC("N00V");
const 测试步兵单位ID = stringToFourCC("hfoo");
const 测试副英雄单位ID = stringToFourCC("Hpal");
const 中立敌对玩家ID = 12;
const 测试单位最大生命值 = 999999;
const 临时测试场地中心X = -540.6;
const 临时测试场地中心Y = -2495.2;
const 临时测试玩家X = -540.6;
const 临时测试玩家Y = -3055.2;
const 测试命令说明 = "miatest1腐化爪击 2污水喷吐 3灵猫分身 4污染标记 5污染脉冲 6污水柱爆发 7腐化转移 8平台超载 9腐化黏液涂层 10终极污染。";

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
const 最近测试步兵1: Record<number, any> = {};
const 最近测试步兵2: Record<number, any> = {};
const 最近测试副英雄: Record<number, any> = {};

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[米亚测试] " + text);
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
    SetUnitPosition(cached, 临时测试场地中心X, 临时测试场地中心Y);
    SetUnitFacing(cached, 270);
    设置测试单位满血(cached);
    标记测试Boss跳过死亡结算(cached);
    return cached;
  }

  const boss = CreateUnit(Player(中立敌对玩家ID), 米亚单位ID, 临时测试场地中心X, 临时测试场地中心Y, 270);
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

function 获取或创建测试副英雄(this: void, player: any, x: number, y: number): any {
  const pid = GetPlayerId(player);
  const cached = 最近测试副英雄[pid];
  if (是当前玩家测试靶(cached, player) && IsUnitType(cached, UNIT_TYPE_HERO) === true) {
    SetUnitPosition(cached, x, y);
    设置测试单位满血(cached);
    return cached;
  }

  const unit = CreateUnit(player, 测试副英雄单位ID, x, y, 180);
  if (unit != null && unit !== 0) {
    最近测试副英雄[pid] = unit;
    SetHeroLevel(unit, 40, false);
    设置测试单位满血(unit);
  }
  return unit;
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
  SetUnitPosition(hero, 临时测试玩家X, 临时测试玩家Y);
  SetUnitFacing(hero, 90);
  设置测试单位满血(hero);
  获取或创建测试步兵(最近测试步兵1, player, 临时测试玩家X - 220, 临时测试玩家Y + 220);
  获取或创建测试步兵(最近测试步兵2, player, 临时测试玩家X + 220, 临时测试玩家Y + 220);
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
  记录Boss自动技能启动(context.Boss单位, "Boss战.单位");
}

function 创建并初始化米亚测试(this: void, player: any): any {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。");
    return undefined;
  }

  const boss = 获取或创建测试Boss(player);
  if (!是有效存活单位(boss)) {
    提示(player, "米亚创建失败。");
    return undefined;
  }

  const context = 准备米亚测试场景(player, hero, boss);
  if (context == null) {
    提示(player, "米亚上下文创建失败。");
    return undefined;
  }
  初始化米亚测试上下文(context);
  return context;
}

function on米亚测试命令(this: void, player: any): void {
  const context = 创建并初始化米亚测试(player);
  if (context == null) return;
  提示(player, "已创建/复用米亚测试场景，并登记 Boss 自动技能。" + 测试命令说明);
}

function 执行米亚技能测试(this: void, player: any, 序号: number): void {
  const context = 创建并初始化米亚测试(player);
  if (context == null) return;
  const hero = 获取玩家测试基准英雄(player);
  const nowMs = getServerTime();

  if (序号 === 1) {
    释放米亚腐化爪击(context, hero);
    提示(player, "已测试：腐化爪击。");
  } else if (序号 === 2) {
    释放米亚污水喷吐(context);
    提示(player, "已测试：污水喷吐。");
  } else if (序号 === 3) {
    context.阶段 = 1;
    context.已触发分身80 = false;
    SetUnitState(context.Boss单位, UNIT_STATE_LIFE, 测试单位最大生命值 * 0.75);
    尝试触发米亚灵猫分身(context);
    提示(player, "已测试：灵猫分身。");
  } else if (序号 === 4) {
    context.阶段 = 1;
    context.上次污染标记Ms = 0;
    给单位添加米亚腐化层数(context, hero, 5, "米亚测试污染标记");
    刷新米亚污染标记(context, nowMs);
    提示(player, "已测试：污染标记。");
  } else if (序号 === 5) {
    context.阶段 = 2;
    context.上次污染脉冲Ms = 0;
    尝试触发米亚污染脉冲(context, nowMs);
    提示(player, "已测试：污染脉冲。");
  } else if (序号 === 6) {
    context.阶段 = 2;
    context.上次污水柱爆发Ms = 0;
    尝试触发米亚污水柱爆发(context, nowMs);
    提示(player, "已测试：污水柱爆发。");
  } else if (序号 === 7) {
    context.阶段 = 2;
    context.上次腐化转移Ms = 0;
    context.腐化转移污染平台ID = "";
    尝试触发米亚腐化转移(context, nowMs);
    提示(player, "已测试：腐化转移。");
  } else if (序号 === 8) {
    context.阶段 = 2;
    context.上次平台超载检测Ms = 0;
    const 区域 = context.安全域区域组.区域列表[0];
    if (区域 != null) {
      SetUnitPosition(hero, 区域.中心X - 45, 区域.中心Y);
      获取或创建测试副英雄(player, 区域.中心X + 45, 区域.中心Y);
    }
    刷新米亚平台超载惩罚(context, nowMs);
    提示(player, "已测试：平台超载。");
  } else if (序号 === 9) {
    context.阶段 = 3;
    context.上次全场甩黏液Ms = 0;
    刷新米亚腐化黏液涂层(context, nowMs);
    提示(player, "已测试：腐化黏液涂层。");
  } else if (序号 === 10) {
    context.阶段 = 3;
    context.终极污染引导中 = false;
    context.已触发终极污染30 = false;
    SetUnitState(context.Boss单位, UNIT_STATE_LIFE, 测试单位最大生命值 * 0.25);
    尝试触发米亚终极污染(context);
    提示(player, "已测试：终极污染。");
  }
}

function on米亚技能1测试命令(this: void, player: any): void { 执行米亚技能测试(player, 1); }
function on米亚技能2测试命令(this: void, player: any): void { 执行米亚技能测试(player, 2); }
function on米亚技能3测试命令(this: void, player: any): void { 执行米亚技能测试(player, 3); }
function on米亚技能4测试命令(this: void, player: any): void { 执行米亚技能测试(player, 4); }
function on米亚技能5测试命令(this: void, player: any): void { 执行米亚技能测试(player, 5); }
function on米亚技能6测试命令(this: void, player: any): void { 执行米亚技能测试(player, 6); }
function on米亚技能7测试命令(this: void, player: any): void { 执行米亚技能测试(player, 7); }
function on米亚技能8测试命令(this: void, player: any): void { 执行米亚技能测试(player, 8); }
function on米亚技能9测试命令(this: void, player: any): void { 执行米亚技能测试(player, 9); }
function on米亚技能10测试命令(this: void, player: any): void { 执行米亚技能测试(player, 10); }

注册聊天命令监听(测试命令, on米亚测试命令);
注册聊天命令监听("miatest1", on米亚技能1测试命令);
注册聊天命令监听("miatest2", on米亚技能2测试命令);
注册聊天命令监听("miatest3", on米亚技能3测试命令);
注册聊天命令监听("miatest4", on米亚技能4测试命令);
注册聊天命令监听("miatest5", on米亚技能5测试命令);
注册聊天命令监听("miatest6", on米亚技能6测试命令);
注册聊天命令监听("miatest7", on米亚技能7测试命令);
注册聊天命令监听("miatest8", on米亚技能8测试命令);
注册聊天命令监听("miatest9", on米亚技能9测试命令);
注册聊天命令监听("miatest10", on米亚技能10测试命令);

export {};
