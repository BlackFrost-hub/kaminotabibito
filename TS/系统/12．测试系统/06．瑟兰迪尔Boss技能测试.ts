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
const { 获取或创建瑟兰迪尔上下文, 注册瑟兰迪尔运行时 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文") as {
  获取或创建瑟兰迪尔上下文: (this: void, boss: any) => any;
  注册瑟兰迪尔运行时: (this: void) => void;
};
const { 刷新瑟兰迪尔秩序领域 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.07．秩序领域") as {
  刷新瑟兰迪尔秩序领域: (this: void, context: any) => void;
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
const { 创建单位坐标跟随特效, 创建循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  创建循环点特效: (this: void, 参数: any) => any;
};
const { 标记测试Boss跳过死亡结算 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};

const 测试命令 = "thtest";
const 瑟兰迪尔单位ID = stringToFourCC("N057");
const 测试步兵单位ID = stringToFourCC("hfoo");
const 中立敌对玩家ID = 12;
const 测试单位最大生命值 = 999999;
const 测试Boss初始距离 = 760;
const 测试命令说明 = "thtest1月光枷锁 2精灵箭阵 3审判之环 4罪与罚 5律法召唤 6月光灌注 7终末审判 8月光枷锁立即打断。";

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (id: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
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

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[瑟兰迪尔测试] " + text);
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

function 获取或创建测试Boss(this: void, player: any, hero: any): any {
  const pid = GetPlayerId(player);
  const cached = 最近测试Boss[pid];
  const x = GetUnitX(hero) + 测试Boss初始距离;
  const y = GetUnitY(hero);
  if (是有效存活单位(cached)) {
    标记测试Boss跳过死亡结算(cached);
    return cached;
  }

  const boss = CreateUnit(Player(中立敌对玩家ID), 瑟兰迪尔单位ID, x, y, 180);
  if (boss != null && boss !== 0) {
    最近测试Boss[pid] = boss;
    标记测试Boss跳过死亡结算(boss);
    SetHeroLevel(boss, 10, false);
    SelectUnitForPlayerSingle(boss, player);
    StarOther_PanCameraToTimedForPlayer(player, x, y, 0.2);
  }
  return boss;
}

function 获取或创建测试步兵(this: void, 缓存表: Record<number, any>, player: any, hero: any, xOffset: number, yOffset: number): any {
  const pid = GetPlayerId(player);
  const cached = 缓存表[pid];
  if (是当前玩家测试靶(cached, player)) {
    设置测试单位满血(cached);
    return cached;
  }

  const unit = CreateUnit(player, 测试步兵单位ID, GetUnitX(hero) + xOffset, GetUnitY(hero) + yOffset, 180);
  if (unit != null && unit !== 0) {
    缓存表[pid] = unit;
    设置测试单位满血(unit);
  }
  return unit;
}

function 准备技能测试场景(this: void, player: any, hero: any): void {
  设置测试单位满血(hero);
  获取或创建测试步兵(最近测试步兵1, player, hero, 180, 160);
  获取或创建测试步兵(最近测试步兵2, player, hero, 180, -160);
}

function on瑟兰迪尔测试命令(this: void, player: any): void {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法创建测试 Boss。");
    return;
  }

  const boss = 获取或创建测试Boss(player, hero);
  if (!是有效存活单位(boss)) {
    提示(player, "瑟兰迪尔创建失败。");
    return;
  }

  准备技能测试场景(player, hero);
  注册瑟兰迪尔运行时();
  const context = 获取或创建瑟兰迪尔上下文(boss);
  if (context != null) {
    刷新瑟兰迪尔秩序领域(context);
  }
  提示(player, "已创建/复用瑟兰迪尔，并把大法师与2个步兵设为999999满血。" + 测试命令说明);
}

function on秩序领域绑定缩放测试命令(this: void, player: any): void {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法测试绑定特效缩放。");
    return;
  }

  const modelPath = 瑟兰迪尔数值与表现配置.秩序领域.特效;
  const effect = 创建单位坐标跟随特效(hero, modelPath, "thranduil-order-aura-scale-test", 1, 50);
  提示(player, "已在大法师脚下创建秩序领域跟随特效，高度50；创建" + (effect == null || effect === 0 ? "失败" : "成功") + "，路径=" + modelPath);
}

function on审判之环法阵特效测试命令(this: void, player: any): void {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法测试审判之环法阵。");
    return;
  }

  const config = 瑟兰迪尔数值与表现配置.审判之环;
  const modelPath = config.特效;
  const x = GetUnitX(hero);
  const y = GetUnitY(hero);
  const handle = 创建循环点特效({
    模型路径: modelPath,
    X: x,
    Y: y,
    缩放: config.法阵缩放,
    顶点颜色: 0xFFFFD060,
    重建间隔秒: config.法阵重建间隔秒,
    单次持续秒: config.法阵单次持续秒,
    总持续秒: config.周期秒,
  });
  提示(player, "已在大法师位置循环创建审判之环法阵" + tostring(config.周期秒) + "秒；句柄=" + tostring(handle.id) + "，缩放=" + tostring(config.法阵缩放) + "，路径=" + modelPath);
}

function 执行瑟兰迪尔技能测试(this: void, player: any, 序号: number): void {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到地图预设玩家1大法师，无法测试技能。");
    return;
  }

  const boss = 获取或创建测试Boss(player, hero);
  if (!是有效存活单位(boss)) {
    提示(player, "瑟兰迪尔创建失败。");
    return;
  }
  准备技能测试场景(player, hero);

  注册瑟兰迪尔运行时();
  const context = 获取或创建瑟兰迪尔上下文(boss);
  if (context == null) {
    提示(player, "瑟兰迪尔上下文创建失败。");
    return;
  }

  if (序号 === 1) {
    释放瑟兰迪尔月光枷锁效果(boss, hero);
    提示(player, "已测试：月光枷锁。");
  } else if (序号 === 2) {
    释放瑟兰迪尔精灵箭阵(context);
    提示(player, "已测试：精灵箭阵。");
  } else if (序号 === 3) {
    释放瑟兰迪尔审判之环(context);
    提示(player, "已测试：审判之环。");
  } else if (序号 === 4) {
    释放瑟兰迪尔罪与罚(context, hero);
    提示(player, "已测试：罪与罚。");
  } else if (序号 === 5) {
    释放瑟兰迪尔律法召唤(context);
    提示(player, "已测试：律法召唤。");
  } else if (序号 === 6) {
    释放瑟兰迪尔月光灌注(context);
    提示(player, "已测试：月光灌注。");
  } else if (序号 === 7) {
    释放瑟兰迪尔终末审判(context);
    提示(player, "已测试：终末审判。");
  } else if (序号 === 8) {
    const success = 立即打断瑟兰迪尔月光枷锁(boss, hero);
    提示(player, success ? "已测试：月光枷锁命中后立即打断，碎片应掉落在大法师脚下。" : "月光枷锁立即打断测试失败。");
  }
}

function on瑟兰迪尔技能1测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 1); }
function on瑟兰迪尔技能2测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 2); }
function on瑟兰迪尔技能3测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 3); }
function on瑟兰迪尔技能4测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 4); }
function on瑟兰迪尔技能5测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 5); }
function on瑟兰迪尔技能6测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 6); }
function on瑟兰迪尔技能7测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 7); }
function on瑟兰迪尔技能8测试命令(this: void, player: any): void { 执行瑟兰迪尔技能测试(player, 8); }

注册聊天命令监听(测试命令, on瑟兰迪尔测试命令);
注册聊天命令监听("9998", on审判之环法阵特效测试命令);
注册聊天命令监听("9999", on秩序领域绑定缩放测试命令);
注册聊天命令监听("thtest1", on瑟兰迪尔技能1测试命令);
注册聊天命令监听("thtest2", on瑟兰迪尔技能2测试命令);
注册聊天命令监听("thtest3", on瑟兰迪尔技能3测试命令);
注册聊天命令监听("thtest4", on瑟兰迪尔技能4测试命令);
注册聊天命令监听("thtest5", on瑟兰迪尔技能5测试命令);
注册聊天命令监听("thtest6", on瑟兰迪尔技能6测试命令);
注册聊天命令监听("thtest7", on瑟兰迪尔技能7测试命令);
注册聊天命令监听("thtest8", on瑟兰迪尔技能8测试命令);

export {};
