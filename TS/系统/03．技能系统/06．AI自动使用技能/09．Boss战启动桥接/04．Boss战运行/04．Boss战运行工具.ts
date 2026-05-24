/** @noSelfInFile */

import { getServerTime } from "../../../../00．核心系统/05．中心计时器";
import { Boss战单位字段, Boss战表名 } from "../00．常量定义";
import {
  Boss战可见度玩家槽位数,
  Boss战地点字段,
  Boss战开始提示文本,
  Boss战箭头特效字段,
  Boss战战斗音乐字段,
  Boss战转场后提示文本,
  Boss战兜底搜敌间隔毫秒,
  Boss战最大追击距离,
  Boss战最大追击距离平方,
  Boss战胜利提示文本,
  Boss战胜利音乐字段,
  Boss战运行模块名,
} from "./00．常量定义";
import {
  type Boss战运行上下文,
  读取Boss战运行上下文,
  读取矩形玩家可见度修整器,
  记录矩形玩家可见度修整器,
} from "./01．Boss战运行上下文";
import { 接管Boss战区域音频 } from "./02．Boss战区域音频";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, forceHandle: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { RectContainsUnit } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, rectHandle: any, whichUnit: any) => boolean;
};
const { TransmissionFromUnitWithNameBJ, CinematicFilterGenericBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  TransmissionFromUnitWithNameBJ: (
    this: void,
    toForce: any,
    whichUnit: any,
    unitName: string,
    soundHandle: any,
    message: string,
    timeType: number,
    timeVal: number,
    wait: boolean
  ) => void;
  CinematicFilterGenericBJ: (
    this: void,
    duration: number,
    bmode: any,
    tex: string,
    red0: number,
    green0: number,
    blue0: number,
    trans0: number,
    red1: number,
    green1: number,
    blue1: number,
    trans1: number
  ) => void;
};
const { IsUnitPausedBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as {
  IsUnitPausedBJ: (this: void, unit: any) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { YDUserDataClearTable } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
};
const { getEnemyThreats } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  getEnemyThreats: (this: void, enemy: any) => Array<{ targetHid: number; targetRef: any; threat: number }>;
};
const { Sound3DII_Mp3Play } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_Mp3Play: (this: void, path: string, player?: any) => any;
};
const { StarOther_PanCameraToTimedUnitForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedUnitForPlayer: (this: void, whichPlayer: any, unit: any, duration: number) => void;
};
const { YDWEAngleBetweenUnits } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWEAngleBetweenUnits: (this: void, fromUnit: any, toUnit: any) => number;
};
const { isValidCombatEnemyUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidCombatEnemyUnit: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, moduleName: string, ...args: any[]) => void;
};

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetRectCenterX = jass.GetRectCenterX as (whichRect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (whichRect: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichType: number) => boolean;
const IsUnitInvulnerable = jass.IsUnitInvulnerable as (whichUnit: any) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (whichUnit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (whichUnit: any, flag: boolean) => void;
const PingMinimap = jass.PingMinimap as (x: number, y: number, duration: number) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, target: any) => boolean;
const IssueImmediateOrder = jass.IssueImmediateOrder as (whichUnit: any, order: string) => boolean;
const GetUnitCurrentOrder = jass.GetUnitCurrentOrder as (whichUnit: any) => number;
const OrderId = jass.OrderId as (orderString: string) => number;
const Player = jass.Player as (playerId: number) => any;
const IsPlayerInForce = jass.IsPlayerInForce as (whichPlayer: any, whichForce: any) => boolean;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const ForGroup = jass.ForGroup as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass.GetEnumUnit as () => any;
const SetUnitPosition = jass.SetUnitPosition as (whichUnit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (whichUnit: any, angle: number) => void;
const IsTerrainPathable = jass.IsTerrainPathable as (x: number, y: number, pathingType: number) => boolean;
const CreateFogModifierRect = jass.CreateFogModifierRect as (whichPlayer: any, whichState: any, where: any, useSharedVision: boolean, afterUnits: boolean) => any;
const FogModifierStart = jass.FogModifierStart as (whichFog: any) => void;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const DisplayCineFilter = jass.DisplayCineFilter as (flag: boolean) => void;

const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as number;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as number;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as number;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as number;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as number;
const FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE as number;
const BLEND_MODE_BLEND = jass.BLEND_MODE_BLEND as number;

const Quest消息警告 = jglobals.bj_QUESTMESSAGE_WARNING as number;
const Quest消息完成 = jglobals.bj_QUESTMESSAGE_COMPLETED as number;
const Quest消息秘密 = jglobals.bj_QUESTMESSAGE_SECRET as number;
const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET as number;

const 攻击命令ID = OrderId("attack");
const 攻击一次命令ID = OrderId("attackonce");
const 停止命令ID = OrderId("stop");
const 保持命令ID = OrderId("holdposition");
const Boss死亡后YD清表延迟毫秒 = 10000;

interface 待清理BossYD任务 {
  bossUnit: any;
  bossHandleId: number;
  运行代次: number;
  截止时间: number;
}

let 最近敌人枚举Boss: any = null;
let 最近敌人枚举矩形: any = null;
let 最近敌人枚举最大距离平方 = 0;
let 最近敌人枚举结果: any = null;
let 最近敌人枚举最短距离平方 = 0;
let 最近敌人枚举最小句柄ID = 0;

let 玩家英雄纠偏矩形: any = null;
let 玩家英雄纠偏中心X = 0;
let 玩家英雄纠偏中心Y = 0;
const 玩家地形纠偏步长 = 150;
const 玩家地形纠偏最大步数 = 24;

const 待清理BossYD任务列表: 待清理BossYD任务[] = [];

function 获取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 当前命令允许兜底下令(this: void, boss: any): boolean {
  if (boss == null || boss === 0) return false;
  if (IsUnitPausedBJ(boss)) return false;

  const 当前命令ID = GetUnitCurrentOrder(boss) || 0;
  if (当前命令ID === 0) return true;
  if (当前命令ID === 攻击命令ID) return true;
  if (当前命令ID === 攻击一次命令ID) return true;
  if (当前命令ID === 停止命令ID) return true;
  if (当前命令ID === 保持命令ID) return true;
  return false;
}

function 单位在Boss战范围内有效(this: void, boss: any, rectHandle: any, target: any, maxDistanceSq: number): boolean {
  if (target == null || target === 0) return false;
  if (!isValidCombatEnemyUnit(target, boss)) return false;
  if (rectHandle != null && rectHandle !== 0 && !RectContainsUnit(rectHandle, target)) return false;

  const dx = GetUnitX(target) - GetUnitX(boss);
  const dy = GetUnitY(target) - GetUnitY(boss);
  return dx * dx + dy * dy <= maxDistanceSq;
}

function 记录最近枚举目标(this: void, target: any): void {
  const handleId = 获取句柄ID(target);
  if (handleId === 0) return;

  const dx = GetUnitX(target) - GetUnitX(最近敌人枚举Boss);
  const dy = GetUnitY(target) - GetUnitY(最近敌人枚举Boss);
  const distanceSq = dx * dx + dy * dy;
  if (distanceSq > 最近敌人枚举最大距离平方) return;

  if (最近敌人枚举结果 == null) {
    最近敌人枚举结果 = target;
    最近敌人枚举最短距离平方 = distanceSq;
    最近敌人枚举最小句柄ID = handleId;
    return;
  }

  if (distanceSq < 最近敌人枚举最短距离平方) {
    最近敌人枚举结果 = target;
    最近敌人枚举最短距离平方 = distanceSq;
    最近敌人枚举最小句柄ID = handleId;
    return;
  }

  if (distanceSq === 最近敌人枚举最短距离平方 && handleId < 最近敌人枚举最小句柄ID) {
    最近敌人枚举结果 = target;
    最近敌人枚举最小句柄ID = handleId;
  }
}

function on枚举玩家英雄组单位(this: void): void {
  const target = GetEnumUnit();
  if (!单位在Boss战范围内有效(最近敌人枚举Boss, 最近敌人枚举矩形, target, 最近敌人枚举最大距离平方)) return;
  记录最近枚举目标(target);
}

function on玩家英雄纠偏单位(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  if (IsUnitPausedBJ(unit)) return;
  if (玩家英雄纠偏矩形 != null && 玩家英雄纠偏矩形 !== 0 && !RectContainsUnit(玩家英雄纠偏矩形, unit)) return;
  if (!IsTerrainPathable(GetUnitX(unit), GetUnitY(unit), PATHING_TYPE_WALKABILITY)) return;
  SetUnitPosition(unit, 玩家英雄纠偏中心X, 玩家英雄纠偏中心Y);
}

function on玩家英雄转场搬运单位(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  SetUnitPosition(unit, 玩家英雄纠偏中心X, 玩家英雄纠偏中心Y);
}

function 读取玩家组(this: void): any {
  return YDUserDataGetSafe("string", "玩家", "玩家组", "force") ?? GetPlayersAll();
}

function 读取玩家英雄组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function 读取当前有效仇恨目标(this: void, context: Boss战运行上下文): any {
  const entries = getEnemyThreats(context.Boss单位);
  let bestTarget: any = null;
  let bestThreat = 0;
  let bestHandleId = 0;

  for (let i = 0; i < entries.length; i++) {
    const entry = entries[i];
    const target = entry.targetRef;
    if (!单位在Boss战范围内有效(context.Boss单位, context.地点矩形, target, Boss战最大追击距离平方)) continue;

    const targetHandleId = 获取句柄ID(target);
    if (bestTarget == null || entry.threat > bestThreat || (entry.threat === bestThreat && targetHandleId < bestHandleId)) {
      bestTarget = target;
      bestThreat = entry.threat;
      bestHandleId = targetHandleId;
    }
  }

  return bestTarget;
}

function 从玩家英雄组查找最近敌人(this: void, context: Boss战运行上下文): any {
  const 玩家英雄组 = 读取玩家英雄组();
  if (玩家英雄组 == null || 玩家英雄组 === 0) return null;

  最近敌人枚举Boss = context.Boss单位;
  最近敌人枚举矩形 = context.地点矩形;
  最近敌人枚举最大距离平方 = Boss战最大追击距离平方;
  最近敌人枚举结果 = null;
  最近敌人枚举最短距离平方 = 0;
  最近敌人枚举最小句柄ID = 0;
  ForGroup(玩家英雄组, on枚举玩家英雄组单位);
  return 最近敌人枚举结果;
}

function 从附近单位查找最近敌人(this: void, context: Boss战运行上下文): any {
  const boss = context.Boss单位;
  const group = CreateGroup();
  if (group == null || group === 0) return null;

  let result: any = null;
  let bestDistanceSq = 0;
  let bestHandleId = 0;

  GroupEnumUnitsInRange(group, GetUnitX(boss), GetUnitY(boss), Boss战最大追击距离, null);
  while (true) {
    const target = FirstOfGroup(group);
    if (target == null || target === 0) break;
    GroupRemoveUnit(group, target);

    if (!单位在Boss战范围内有效(boss, context.地点矩形, target, Boss战最大追击距离平方)) continue;
    const handleId = 获取句柄ID(target);
    const dx = GetUnitX(target) - GetUnitX(boss);
    const dy = GetUnitY(target) - GetUnitY(boss);
    const distanceSq = dx * dx + dy * dy;

    if (result == null || distanceSq < bestDistanceSq || (distanceSq === bestDistanceSq && handleId < bestHandleId)) {
      result = target;
      bestDistanceSq = distanceSq;
      bestHandleId = handleId;
    }
  }

  DestroyGroup(group);
  return result;
}

export function 单位是否死亡(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return true;
  return IsUnitType(unit, UNIT_TYPE_DEAD);
}

export function 读取Boss战矩形(this: void): any {
  return YDUserDataGetSafe("string", Boss战表名, Boss战地点字段, "rect");
}

export function 读取Boss战音频(this: void, 字段名: string): any {
  return YDUserDataGetSafe("string", Boss战表名, 字段名, "sound");
}

export function 读取Boss战实数(this: void, 字段名: string): number {
  return Number(YDUserDataGetSafe("string", Boss战表名, 字段名, "real")) || 0;
}

export function 读取Boss战单位布尔(this: void, bossUnit: any, 字段名: string): boolean {
  return YDUserDataGetSafe("unit", bossUnit, 字段名, "boolean") === true;
}

export function 读取Boss战单位(this: void, 字段名: string): any {
  return YDUserDataGetSafe("string", Boss战表名, 字段名, "unit");
}

export function 确保Boss战区域视野(this: void, rectHandle: any): void {
  const rectHandleId = 获取句柄ID(rectHandle);
  if (rectHandleId === 0) return;

  const 玩家组 = 读取玩家组();
  for (let playerId = 0; playerId < Boss战可见度玩家槽位数; playerId++) {
    const whichPlayer = Player(playerId);
    if (whichPlayer == null || whichPlayer === 0) continue;
    if (玩家组 != null && 玩家组 !== 0 && !IsPlayerInForce(whichPlayer, 玩家组)) continue;
    if (读取矩形玩家可见度修整器(rectHandleId, playerId) != null) continue;

    const fogModifier = CreateFogModifierRect(whichPlayer, FOG_OF_WAR_VISIBLE, rectHandle, true, false);
    if (fogModifier == null || fogModifier === 0) continue;
    FogModifierStart(fogModifier);
    记录矩形玩家可见度修整器(rectHandleId, playerId, fogModifier);
  }
}

export function 执行Boss战转场动画(this: void): void {
  Sound3DII_Mp3Play("XT\\YX-battle.mp3");
  CinematicFilterGenericBJ(0.5, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 15, 15, 15, 15, 0, 0, 0, 0);
  TransmissionFromUnitWithNameBJ(GetPlayersAll(), null, "", null, "", bj_TIMETYPE_SET, 2.0, true);
}

export function 完成Boss战转场搬运(this: void, context: Boss战运行上下文): void {
  const boss = context.Boss单位;
  const 触发玩家单位 = 读取Boss战单位("触发玩家");
  const bossX = 读取Boss战实数("BS移动X轴");
  const bossY = 读取Boss战实数("BS移动Y轴");
  const playerX = 读取Boss战实数("玩家移动X轴");
  const playerY = 读取Boss战实数("玩家移动Y轴");
  const 玩家英雄组 = 读取玩家英雄组();

  DisplayCineFilter(false);

  if (bossX !== 0 || bossY !== 0) {
    SetUnitPosition(boss, bossX, bossY);
    IssueImmediateOrder(boss, "holdposition");
  }

  if (触发玩家单位 == null || 触发玩家单位 === 0) return;

  SetUnitPosition(触发玩家单位, playerX, playerY);
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    玩家英雄纠偏矩形 = null;
    玩家英雄纠偏中心X = playerX;
    玩家英雄纠偏中心Y = playerY;
    ForGroup(玩家英雄组, on玩家英雄转场搬运单位);
  }

  SetUnitFacing(触发玩家单位, YDWEAngleBetweenUnits(触发玩家单位, boss));
  StarOther_PanCameraToTimedUnitForPlayer(GetOwningPlayer(触发玩家单位), 触发玩家单位, 0.1);
}

export function 完成Boss战启动(this: void, context: Boss战运行上下文): void {
  接管Boss战区域音频(context);
  确保Boss战区域视野(context.地点矩形);

  SetUnitInvulnerable(context.Boss单位, false);
  PauseUnit(context.Boss单位, false);

  if (context.地点矩形 != null && context.地点矩形 !== 0) {
    PingMinimap(GetRectCenterX(context.地点矩形), GetRectCenterY(context.地点矩形), 15);
  } else {
    PingMinimap(GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 15);
  }

  QuestMessageBJ(GetPlayersAll(), Quest消息警告, Boss战开始提示文本);
  context.是否已激活 = true;
  尝试兜底搜敌并下令(context, getServerTime());

  debugLogForce(Boss战运行模块名, "Boss战正式激活", "boss=", context.Boss句柄ID, "generation=", context.运行代次);
}

export function 尝试兜底搜敌并下令(this: void, context: Boss战运行上下文, nowMs: number): void {
  if (nowMs < context.下次兜底搜敌时间) return;
  context.下次兜底搜敌时间 = nowMs + Boss战兜底搜敌间隔毫秒;

  if (!当前命令允许兜底下令(context.Boss单位)) return;

  const threatTarget = 读取当前有效仇恨目标(context);
  if (threatTarget != null && threatTarget !== 0) {
    context.最近兜底目标ID = 0;
    return;
  }

  const fallbackTarget = 从玩家英雄组查找最近敌人(context) ?? 从附近单位查找最近敌人(context);
  if (fallbackTarget == null || fallbackTarget === 0) return;

  const fallbackTargetId = 获取句柄ID(fallbackTarget);
  const currentOrderId = GetUnitCurrentOrder(context.Boss单位) || 0;
  if (context.最近兜底目标ID === fallbackTargetId && (currentOrderId === 攻击命令ID || currentOrderId === 攻击一次命令ID)) {
    return;
  }

  IssueTargetOrder(context.Boss单位, "attack", fallbackTarget);
  context.最近兜底目标ID = fallbackTargetId;

  debugLogForce(Boss战运行模块名, "兜底搜敌下令", "boss=", context.Boss句柄ID, "target=", fallbackTargetId);
}

export function 纠偏Boss位置(this: void, context: Boss战运行上下文): void {
  if (context.地点矩形 == null || context.地点矩形 === 0) return;
  if (IsUnitPausedBJ(context.Boss单位)) return;
  if (!IsTerrainPathable(GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), PATHING_TYPE_WALKABILITY)) return;
  SetUnitPosition(context.Boss单位, GetRectCenterX(context.地点矩形), GetRectCenterY(context.地点矩形));
}

export function 纠偏玩家英雄位置(this: void, rectHandle: any): void {
  const 玩家英雄组 = 读取玩家英雄组();
  if (玩家英雄组 == null || 玩家英雄组 === 0) return;
  if (rectHandle == null || rectHandle === 0) return;

  玩家英雄纠偏矩形 = rectHandle;
  玩家英雄纠偏中心X = GetRectCenterX(rectHandle);
  玩家英雄纠偏中心Y = GetRectCenterY(rectHandle);
  ForGroup(玩家英雄组, on玩家英雄纠偏单位);
}

export function 清理Boss战单位字段(this: void, bossUnit: any): void {
  const 当前Boss战单位 = YDUserDataGetSafe("string", Boss战表名, Boss战单位字段, "unit");
  if (当前Boss战单位 == null || 当前Boss战单位 === 0) return;
  if (获取句柄ID(当前Boss战单位) !== 获取句柄ID(bossUnit)) return;

  YDUserDataSetSafe("string", Boss战表名, Boss战单位字段, "unit", null);
  YDUserDataClearSafe("string", Boss战表名, Boss战单位字段, "unit");
}

export function 清理Boss箭头特效(this: void, bossUnit: any): void {
  const arrowEffect = YDUserDataGetSafe("unit", bossUnit, Boss战箭头特效字段, "effect");
  if (arrowEffect == null || arrowEffect === 0) return;
  DestroyEffect(arrowEffect);
}

export function 登记Boss死亡延迟清理YD数据(this: void, context: Boss战运行上下文, nowMs: number): void {
  待清理BossYD任务列表.push({
    bossUnit: context.Boss单位,
    bossHandleId: context.Boss句柄ID,
    运行代次: context.运行代次,
    截止时间: nowMs + Boss死亡后YD清表延迟毫秒,
  });
}

export function 处理待清理Boss单位YD数据(this: void, nowMs: number): void {
  for (let i = 待清理BossYD任务列表.length - 1; i >= 0; i--) {
    const task = 待清理BossYD任务列表[i];
    if (nowMs < task.截止时间) continue;

    const currentContext = 读取Boss战运行上下文(task.bossUnit);
    if (currentContext == null || currentContext.运行代次 === task.运行代次) {
      YDUserDataClearTable("unit", task.bossUnit);
      debugLogForce(Boss战运行模块名, "延迟清理Boss单位YDUserData", "boss=", task.bossHandleId, "generation=", task.运行代次);
    }

    待清理BossYD任务列表.splice(i, 1);
  }
}

export function 当前是否存在待清理BossYD任务(this: void): boolean {
  return 待清理BossYD任务列表.length > 0;
}

export function 获取Boss战转场后提示文本(this: void): string {
  return Boss战转场后提示文本;
}

export function 获取Boss战胜利提示文本(this: void): string {
  return Boss战胜利提示文本;
}

export function 获取Quest消息完成(this: void): number {
  return Quest消息完成;
}

export function 获取Quest消息秘密(this: void): number {
  return Quest消息秘密;
}
