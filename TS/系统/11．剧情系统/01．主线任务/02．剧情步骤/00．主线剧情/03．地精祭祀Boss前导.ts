/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: (this: void) => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { TriggerRegisterUnitInRangeSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterUnitInRangeSimple: (this: void, trig: any, range: number, whichUnit: any) => any;
};

import type { 剧情动作参数表 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度, 写入当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 播放主线剧情片段 } from "../02．剧情步骤播放器";

const CreateTimer = jass.CreateTimer as (this: void) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
const TriggerRegisterUnitEvent = jass.TriggerRegisterUnitEvent as (this: void, trig: any, whichUnit: any, whichEvent: any) => any;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const EVENT_UNIT_SPELL_EFFECT = jass.EVENT_UNIT_SPELL_EFFECT as any;

let 已初始化进度03核心 = false;
let 已注册地精祭祀Boss范围 = false;

function 读取地精巫师Boss(this: void): any {
  return YDUserDataGetSafe("string", "Boss", "地精巫师", "unit");
}

function 触发单位是玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  return 玩家英雄组 != null && 玩家英雄组 !== 0 && IsUnitInGroup(unit, 玩家英雄组);
}

function Boss仍是前导状态(this: void, bossUnit: any): boolean {
  if (bossUnit == null || bossUnit === 0 || !IsUnitAliveBJ(bossUnit)) return false;
  return GetOwningPlayer(bossUnit) === Player(PLAYER_NEUTRAL_PASSIVE);
}

export function 执行地精祭祀Boss前导激活(this: void, 参数: 剧情动作参数表): void {
  const bossUnit = 读取地精巫师Boss();
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (读取剧情进度() !== 2 || !Boss仍是前导状态(bossUnit) || !触发单位是玩家英雄(触发单位)) return;
  const { 写入剧情进度 } = require("../../00．剧情系统核心工具/01．剧情动作上下文") as {
    写入剧情进度: (this: void, value: number) => void;
  };
  写入剧情进度(Number(参数.设置剧情进度) || 3);
  const 血条Boss组 = YDUserDataGetSafe("string", "血条Boss", "单位组", "group");
  if (血条Boss组 != null && 血条Boss组 !== 0) {
    const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => boolean;
    GroupAddUnit(血条Boss组, bossUnit);
  }
  const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
  const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
  const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
  SetUnitOwner(bossUnit, Player(PLAYER_NEUTRAL_AGGRESSIVE), true);
  PauseUnit(bossUnit, true);
  SetUnitInvulnerable(bossUnit, true);
}

export function 执行地精祭祀Boss战正式注册(this: void, 参数: 剧情动作参数表): void {
  const bossUnit = 读取地精巫师Boss();
  if (bossUnit == null || bossUnit === 0 || !IsUnitAliveBJ(bossUnit)) return;
  const 技能触发器名 = String(参数.注册Boss技能事件 ?? "");
  const 技能触发器 = 技能触发器名 !== "" ? jglobals[技能触发器名] : null;
  if (技能触发器 != null && 技能触发器 !== 0) {
    TriggerRegisterUnitEvent(技能触发器, bossUnit, EVENT_UNIT_SPELL_EFFECT);
  }
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", bossUnit);
  if (触发单位 != null && 触发单位 !== 0) {
    YDUserDataSetSafe("string", "Boss战", "触发玩家", "unit", 触发单位);
  }
}

function on地精祭祀Boss前导范围触发(this: void): void {
  const bossUnit = 读取地精巫师Boss();
  const 触发单位 = GetTriggerUnit();
  if (读取剧情进度() !== 2) return;
  if (!Boss仍是前导状态(bossUnit)) return;
  if (!触发单位是玩家英雄(触发单位)) return;

  const 片段ID = "jlc_goblin_boss_intro";
  写入当前剧情动作上下文({ 片段ID, 触发配置名: "地精祭祀Boss前导核心", 触发单位 });
  播放主线剧情片段(片段ID, { 片段ID, 触发配置名: "地精祭祀Boss前导核心", 触发单位 });
}

function 注册地精祭祀Boss范围(this: void, bossUnit: any): void {
  if (已注册地精祭祀Boss范围) return;
  if (bossUnit == null || bossUnit === 0) return;
  const trigger = CreateTrigger();
  TriggerRegisterUnitInRangeSimple(trigger, 750, bossUnit);
  TriggerAddAction(trigger, on地精祭祀Boss前导范围触发);
  已注册地精祭祀Boss范围 = true;
}

function on检查并注册地精祭祀Boss范围(this: void): void {
  const bossUnit = 读取地精巫师Boss();
  if (bossUnit != null && bossUnit !== 0) {
    注册地精祭祀Boss范围(bossUnit);
    safeDestroyTimer(GetExpiredTimer());
  }
}

export const 地精祭祀Boss前导剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_创建地精祭祀Boss预备": 执行地精祭祀Boss前导激活,
  "JLC精灵村_地精祭祀Boss战正式注册": 执行地精祭祀Boss战正式注册,
};

export function 初始化进度03_地精祭祀Boss前导核心(this: void): void {
  if (已初始化进度03核心) return;
  已初始化进度03核心 = true;

  const bossUnit = 读取地精巫师Boss();
  if (bossUnit != null && bossUnit !== 0) {
    注册地精祭祀Boss范围(bossUnit);
    return;
  }

  const timer = CreateTimer();
  safeTimerStart(timer, 0.5, true, on检查并注册地精祭祀Boss范围);
}
