/** @noSelfInFile */

const jass = require("jass.common") as any;
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
const { 创建瑟兰迪尔月光碎片 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．瑟兰迪尔.14．月光碎片") as {
  创建瑟兰迪尔月光碎片: (this: void, x: number, y: number) => any;
};

const 测试命令 = "thtest";
const 月光碎片测试命令 = "thfrag";
const 瑟兰迪尔单位ID = stringToFourCC("N057");
const 测试靶子单位ID = stringToFourCC("hfoo");
const 中立敌对玩家ID = 12;

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (id: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, text: string) => void;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer as (whichGroup: any, whichPlayer: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

function 提示(this: void, player: any, text: string): void {
  DisplayTimedTextToPlayer(player, 0, 0, 8, "[瑟兰迪尔测试] " + text);
}

function 是有效存活英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 获取玩家测试基准英雄(this: void, player: any): any {
  const registeredHero = getRegisteredPlayerHero(player);
  if (是有效存活英雄(registeredHero)) return registeredHero;

  const presetArchmage = globals.gg_unit_Hamg_0002;
  if (是有效存活英雄(presetArchmage)) return presetArchmage;

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

function on瑟兰迪尔测试命令(this: void, player: any): void {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到注册英雄或预置大法师，无法创建测试 Boss。");
    return;
  }

  const x = GetUnitX(hero) + 420;
  const y = GetUnitY(hero);
  const boss = CreateUnit(player, 瑟兰迪尔单位ID, x, y, 180);
  const target = CreateUnit(Player(中立敌对玩家ID), 测试靶子单位ID, x + 360, y, 180);

  if (boss != null && boss !== 0) {
    SetHeroLevel(boss, 10, false);
    SelectUnitForPlayerSingle(boss, player);
    StarOther_PanCameraToTimedForPlayer(player, x, y, 0.2);
  }

  if (target == null || target === 0) {
    提示(player, "已创建瑟兰迪尔，但测试靶子创建失败。");
    return;
  }

  提示(player, "已创建瑟兰迪尔和敌对靶子。选中 Boss 后对靶子释放 AT05（月光枷锁）。");
}

function on月光碎片测试命令(this: void, player: any): void {
  const hero = 获取玩家测试基准英雄(player);
  if (hero == null || hero === 0) {
    提示(player, "未找到注册英雄或预置大法师，无法创建月光碎片。");
    return;
  }

  创建瑟兰迪尔月光碎片(GetUnitX(hero) + 120, GetUnitY(hero));
  提示(player, "已在英雄旁边创建月光碎片，可直接拾取测试移速 Buff。");
}

注册聊天命令监听(测试命令, on瑟兰迪尔测试命令);
注册聊天命令监听(月光碎片测试命令, on月光碎片测试命令);

export {};
