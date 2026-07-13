/** @noSelfInFile */

import type { Boss血条弱点韧性运行状态 } from "../03．技能系统/06．AI自动使用技能/03．Boss战启动桥接/03．Boss血条弱点韧性/00．类型";

const jass = require("jass.common") as any;
const globals = require("jass.globals") as {
  gg_unit_Hamg_0002?: any;
  gg_unit_Udre_0014?: any;
  [key: string]: any;
};

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, player: any, command: string) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 创建Boss战运行上下文 } = require(
  "系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文",
) as {
  创建Boss战运行上下文: (this: void, Boss单位: any, 地点矩形: any, 战斗音乐: any, 胜利音乐: any) => any;
};
const {
  创建Boss血条弱点韧性运行状态,
  读取Boss血条弱点韧性运行状态,
  清理Boss血条弱点韧性运行状态,
} = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.05．Boss弱点运行状态") as {
  创建Boss血条弱点韧性运行状态: (this: void, context: any, config: undefined) => Boss血条弱点韧性运行状态;
  读取Boss血条弱点韧性运行状态: (this: void, Boss句柄ID: number) => Boss血条弱点韧性运行状态 | undefined;
  清理Boss血条弱点韧性运行状态: (this: void, Boss句柄ID: number) => void;
};
const { 注册Boss血条UI, 注销Boss血条UI, 重新排列Boss血条槽位 } = require(
  "系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.03．Boss血条UI",
) as {
  注册Boss血条UI: (this: void, state: Boss血条弱点韧性运行状态) => void;
  注销Boss血条UI: (this: void, state: Boss血条弱点韧性运行状态) => void;
  重新排列Boss血条槽位: (this: void) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const Player = jass.Player as (playerId: number) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (group: any) => void;
const GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer as (group: any, player: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (group: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (group: any, unit: any) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  player: any,
  x: number,
  y: number,
  duration: number,
  text: string,
) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

function stringToFourCC(this: void, value: string): number {
  return value.charCodeAt(0) * 0x1000000
    + value.charCodeAt(1) * 0x10000
    + value.charCodeAt(2) * 0x100
    + value.charCodeAt(3);
}

const 测试命令 = "hp";
const 清理命令 = "hpclear";
const 死亡骑士单位ID = stringToFourCC("Udre");
const 死亡骑士原始X = -2048.1;
const 死亡骑士原始Y = -1335.6;
const 测试血条句柄表: Record<number, boolean | undefined> = {};
let 缓存死亡骑士单位: any = null;
let 已初始化 = false;

function 单位可用于血条测试(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 读取预设死亡骑士(this: void): any {
  const presetUnit = globals.gg_unit_Udre_0014;
  if (单位可用于血条测试(presetUnit)) return presetUnit;
  if (单位可用于血条测试(缓存死亡骑士单位)) return 缓存死亡骑士单位;

  const group = CreateGroup();
  GroupEnumUnitsOfPlayer(group, Player(0), null);
  let nearestUnit: any = null;
  let nearestDistanceSquared = 0;
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (单位可用于血条测试(unit) && GetUnitTypeId(unit) === 死亡骑士单位ID) {
      const dx = GetUnitX(unit) - 死亡骑士原始X;
      const dy = GetUnitY(unit) - 死亡骑士原始Y;
      const distanceSquared = dx * dx + dy * dy;
      if (nearestUnit == null || distanceSquared < nearestDistanceSquared) {
        nearestUnit = unit;
        nearestDistanceSquared = distanceSquared;
      }
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  缓存死亡骑士单位 = nearestUnit;
  return nearestUnit;
}

function 创建或复用测试血条(this: void, unit: any): boolean {
  if (!单位可用于血条测试(unit)) return false;
  const handleId = GetHandleId(unit);
  if (handleId === 0) return false;

  let state = 读取Boss血条弱点韧性运行状态(handleId);
  if (state == null || state.是否已结束) {
    const context = 创建Boss战运行上下文(unit, null, null, null);
    if (context == null) return false;
    state = 创建Boss血条弱点韧性运行状态(context, undefined);
  }

  测试血条句柄表[handleId] = true;
  注册Boss血条UI(state);
  重新排列Boss血条槽位();
  return true;
}

function 清理测试血条(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const handleId = GetHandleId(unit);
  if (handleId === 0 || 测试血条句柄表[handleId] !== true) return false;

  const state = 读取Boss血条弱点韧性运行状态(handleId);
  if (state != null) {
    state.是否已结束 = true;
    注销Boss血条UI(state);
    清理Boss血条弱点韧性运行状态(handleId);
  }
  测试血条句柄表[handleId] = undefined;
  return true;
}

function on双血条测试命令(this: void, player: any, _command: string): void {
  const archmage = globals.gg_unit_Hamg_0002;
  const deathKnight = 读取预设死亡骑士();
  const archmageReady = 创建或复用测试血条(archmage);
  const deathKnightReady = 创建或复用测试血条(deathKnight);

  if (archmageReady && deathKnightReady) {
    DisplayTimedTextToPlayer(player, 0, 0, 8, "[双Boss血条测试] 已显示大法师与死亡骑士血条。杀死任意一只可测试自动上移；输入 hpclear 清理。 ");
    return;
  }

  DisplayTimedTextToPlayer(
    player,
    0,
    0,
    8,
    "[双Boss血条测试] 预设单位读取失败：Hamg=" + (archmageReady ? "正常" : "无效") + "，Udre=" + (deathKnightReady ? "正常" : "无效") + "。",
  );
}

function on双血条清理命令(this: void, player: any, _command: string): void {
  清理测试血条(globals.gg_unit_Hamg_0002);
  清理测试血条(读取预设死亡骑士());
  DisplayTimedTextToPlayer(player, 0, 0, 5, "[双Boss血条测试] 已清理测试血条。");
}

function on测试单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  const handleId = GetHandleId(dyingUnit);
  if (测试血条句柄表[handleId] !== true) return;
  清理测试血条(dyingUnit);
}

function 初始化Boss双血条测试(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  注册聊天命令监听(测试命令, on双血条测试命令);
  注册聊天命令监听(清理命令, on双血条清理命令);
  registerDeathListener(on测试单位死亡);
}

初始化Boss双血条测试();

export {};
