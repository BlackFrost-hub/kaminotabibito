/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { registerSpellChannelListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellChannelListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { YDWESetEventDamage } = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  YDWESetEventDamage: (this: void, amount: number) => boolean;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
  getServerTime: (this: void) => number;
};
const { YDUserDataClearSafe, YDUserDataClearTableSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  YDUserDataClearTableSafe: (this: void, tableTypeName: string, tableKey: any) => void;
};
const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { TransmissionFromUnitWithNameBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  TransmissionFromUnitWithNameBJ: (
    this: void,
    toForce: any,
    whichUnit: any,
    unitName: string,
    soundHandle: any,
    message: string,
    timeType: number,
    timeVal: number,
    wait: boolean,
  ) => void;
};
const {
  CreateQuestBJ,
  GetLastCreatedQuestBJ,
  QuestMessageBJ,
} = require("lib.扩展函数.BJ函数.06．任务消息") as {
  CreateQuestBJ: (this: void, questType: number, title: string, description: string, icon: string) => any;
  GetLastCreatedQuestBJ: (this: void) => any;
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import type {
  主线剧情技能通道事件配置,
  主线剧情最终伤害事件配置,
  主线剧情支线任务发现配置,
} from "./00．主线剧情入口类型";
import { 主线剧情技能通道事件配置表 } from "./05．主线剧情事件配置表";
import { 蛇人族卫队长血线承接配置 } from "../02．剧情步骤/01．第一章/14．蛇人族卫队长试炼";
import { 读取剧情进度, 写入剧情进度 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 更新主线任务UI, 读取语义单位引用 } from "../00．剧情系统核心工具/06．剧情通用执行工具";
import { 处理技能推进主线剧情 } from "../00．剧情系统核心工具/07．剧情技能事件辅助";

const GetUnitName = jass.GetUnitName as (this: void, whichUnit: any) => string;
const GetUnitState = jass.GetUnitState as (this: void, whichUnit: any, whichState: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const IsUnitInRangeXY = jass.IsUnitInRangeXY as (this: void, whichUnit: any, x: number, y: number, distance: number) => boolean;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const PingMinimap = jass.PingMinimap as (this: void, x: number, y: number, duration: number) => void;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const SetUnitState = jass.SetUnitState as (this: void, whichUnit: any, whichState: any, value: number) => void;
const ShowUnit = jass.ShowUnit as (this: void, whichUnit: any, show: boolean) => void;

const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const bj_QUESTMESSAGE_ALWAYSHINT = jglobals.bj_QUESTMESSAGE_ALWAYSHINT as number;
const bj_QUESTTYPE_OPT_UNDISCOVERED = jglobals.bj_QUESTTYPE_OPT_UNDISCOVERED as number;
const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET as number;

let 已初始化主线剧情特殊事件 = false;
const 延迟显示任务: Array<{ dueTime: number; 配置: 主线剧情最终伤害事件配置 }> = [];
let 延迟显示扫描ID = 0;

function 获取全局句柄(this: void, 变量名: string): any {
  return jglobals[变量名];
}

function 读取攻击者名(this: void, attacker: any): string {
  if (attacker == null || attacker === 0) return "玩家";
  const name = GetUnitName(attacker);
  return name && name.length > 0 ? name : "玩家";
}

function 剧情进度满足技能配置(this: void, 配置: 主线剧情技能通道事件配置): boolean {
  const 当前剧情进度 = 读取剧情进度();
  if (配置.需要剧情进度 != null && 当前剧情进度 !== 配置.需要剧情进度) return false;
  if (配置.最低剧情进度 != null && 当前剧情进度 < 配置.最低剧情进度) return false;
  if (配置.最高剧情进度 != null && 当前剧情进度 > 配置.最高剧情进度) return false;
  return true;
}

function 执行区域音乐切换(this: void, 配置: 主线剧情最终伤害事件配置): void {
  if (配置.区域音乐切换 == null) return;
  for (let i = 0; i < 配置.区域音乐切换.length; i++) {
    const 条目 = 配置.区域音乐切换[i];
    const 声音句柄 = 获取全局句柄(条目.声音变量名);
    const 矩形句柄 = 获取全局句柄(条目.矩形变量名);
    if (声音句柄 == null || 矩形句柄 == null) continue;
    SetStackedSoundBJ(条目.添加, 声音句柄, 矩形句柄);
  }
}

function 执行支线任务发现(this: void, 配置: 主线剧情支线任务发现配置): void {
  const 支线任务数组 = jglobals.udg_RW as any;
  if (支线任务数组 == null) return;
  if (支线任务数组[配置.任务数组索引] != null && 支线任务数组[配置.任务数组索引] !== 0) return;

  CreateQuestBJ(bj_QUESTTYPE_OPT_UNDISCOVERED, 配置.任务名, 配置.任务描述 ?? "", 配置.图标路径);
  支线任务数组[配置.任务数组索引] = GetLastCreatedQuestBJ();
}

function 播放最终伤害对白列表(this: void, 配置: 主线剧情最终伤害事件配置, attacker: any): void {
  const 攻击者名 = 读取攻击者名(attacker);
  for (let i = 0; i < 配置.对白列表.length; i++) {
    const 对白 = 配置.对白列表[i];
    const 说话者 = 对白.使用攻击者名 === true ? 攻击者名 : 对白.说话者;
    TransmissionFromUnitWithNameBJ(GetPlayersAll(), null, 说话者, null, 对白.文本, bj_TIMETYPE_SET, 对白.持续时间, true);
  }
}

function 执行主线剧情延迟显示(this: void, 配置: 主线剧情最终伤害事件配置): void {
  if (配置 == null || 配置.延迟显示 == null) return;

  const 单位 = 读取语义单位引用(配置.延迟显示.语义单位名);
  if (单位 == null || 单位 === 0) return;
  ShowUnit(单位, true);
  SetUnitPosition(单位, 配置.延迟显示.X, 配置.延迟显示.Y);
  SetUnitFacing(单位, 配置.延迟显示.朝向);

  if (配置.支线任务发现 != null) {
    QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_ALWAYSHINT, 配置.支线任务发现.发现提示);
  }
}

function on主线剧情延迟显示扫描(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 延迟显示任务.length; i++) {
    const task = 延迟显示任务[i];
    if (now >= task.dueTime) {
      执行主线剧情延迟显示(task.配置);
      continue;
    }
    延迟显示任务[writeIndex] = task;
    writeIndex++;
  }
  for (let i = 延迟显示任务.length - 1; i >= writeIndex; i--) {
    延迟显示任务.pop();
  }
  if (延迟显示任务.length === 0 && 延迟显示扫描ID !== 0) {
    removePeriodicCallback(延迟显示扫描ID);
    延迟显示扫描ID = 0;
  }
}

function 启动延迟显示(this: void, 配置: 主线剧情最终伤害事件配置): void {
  if (配置.延迟显示 == null) return;
  延迟显示任务.push({
    dueTime: getServerTime() + 配置.延迟显示.延迟秒数 * 1000,
    配置,
  });
  if (延迟显示扫描ID === 0) {
    延迟显示扫描ID = addPeriodicCallback(10, on主线剧情延迟显示扫描);
  }
}

function 命中技能通道事件配置(this: void, 配置: 主线剧情技能通道事件配置, castingUnit: any, spellAbilityId: number): boolean {
  if (castingUnit == null || castingUnit === 0) return false;
  if (spellAbilityId !== stringToFourCCSafe(配置.技能ID)) return false;
  if (!剧情进度满足技能配置(配置)) return false;
  return IsUnitInRangeXY(castingUnit, 配置.检测X, 配置.检测Y, 配置.检测半径) === true;
}

function 命中最终伤害事件配置(this: void, 配置: 主线剧情最终伤害事件配置, target: any, applied: number): boolean {
  if (target == null || target === 0) return false;
  if (读取剧情进度() !== 配置.需要剧情进度) return false;
  if (GetUnitTypeId(target) !== stringToFourCCSafe(配置.单位ID)) return false;

  const currentLife = GetUnitState(target, UNIT_STATE_LIFE);
  const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
  if (!(currentLife > 0) || !(maxLife > 0)) return false;

  const afterHitLife = currentLife - applied;
  return applied >= currentLife || afterHitLife <= maxLife * 配置.血线阈值比例;
}

function 执行技能推进剧情(this: void, 配置: 主线剧情技能通道事件配置, castingUnit: any): void {
  处理技能推进主线剧情({
    片段ID: 配置.剧情片段ID,
    触发配置名: 配置.配置名,
    触发单位: castingUnit,
  });
}

function 执行最终伤害推进剧情(this: void, 配置: 主线剧情最终伤害事件配置, target: any, attacker: any): void {
  const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
  YDWESetEventDamage(0);
  写入剧情进度(配置.目标剧情进度);
  SetUnitState(target, UNIT_STATE_LIFE, maxLife * 配置.保底生命比例);

  if (配置.目标单位无敌 === true) {
    SetUnitInvulnerable(target, true);
  }
  if (配置.切换所属玩家ID != null) {
    SetUnitOwner(target, Player(配置.切换所属玩家ID), true);
  }
  if (配置.暂停目标单位 === true) {
    PauseUnit(target, true);
  }

  执行区域音乐切换(配置);
  播放最终伤害对白列表(配置, attacker);

  if (配置.移除目标单位 === true) {
    RemoveUnit(target);
  }
  if (配置.清理Boss语义键 != null && 配置.清理Boss语义键 !== "") {
    YDUserDataClearSafe("string", "Boss", 配置.清理Boss语义键, "unit");
  }
  if (配置.清理目标YD表 === true) {
    YDUserDataClearTableSafe("unit", target);
  }

  PingMinimap(配置.小地图X, 配置.小地图Y, 配置.小地图持续时间);
  更新主线任务UI(配置.任务描述 ?? "", 配置.任务提示);

  if (配置.支线任务发现 != null) {
    执行支线任务发现(配置.支线任务发现);
  }
  启动延迟显示(配置);
}

function on主线技能通道推进(this: void, castingUnit: any, spellAbilityId: number): void {
  for (let i = 0; i < 主线剧情技能通道事件配置表.length; i++) {
    const 配置 = 主线剧情技能通道事件配置表[i];
    if (!命中技能通道事件配置(配置, castingUnit, spellAbilityId)) continue;
    执行技能推进剧情(配置, castingUnit);
    return;
  }
}

function on主线最终伤害推进(this: void, target: any, attacker: any, applied: number): void {
  const 配置 = 蛇人族卫队长血线承接配置;
  if (!命中最终伤害事件配置(配置, target, applied)) return;
  执行最终伤害推进剧情(配置, target, attacker);
}

export function 初始化主线剧情特殊事件(this: void): void {
  if (已初始化主线剧情特殊事件) return;
  已初始化主线剧情特殊事件 = true;
  registerAppliedFinalDamageListener(on主线最终伤害推进);
  registerSpellChannelListener(on主线技能通道推进);
}
