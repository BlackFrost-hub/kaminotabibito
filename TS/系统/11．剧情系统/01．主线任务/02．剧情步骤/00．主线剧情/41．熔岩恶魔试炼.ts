/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataSetSafe, YDUserDataClearSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { 创建并冻结剧情Boss预置 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接") as {
  创建并冻结剧情Boss预置: (this: void, 参数: any) => any;
};
const { 暂停并设置无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, 来源: string) => boolean;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => () => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 读取剧情进度, 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 注册剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 发布主线节点目标 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";
import { 执行准备巴尔扎罗斯前导 } from "./42．巴尔扎罗斯前导";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;

const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const Boss键 = "Boss.熔岩恶魔";
const Boss名 = "熔岩恶魔";
const BossA = { X: 19616.6, Y: -6856.6, 朝向: 270 };
const 玩家B = { X: 19918.3, Y: -8256.0 };
const 火灵核心交付点C = { X: 19266.9, Y: -7532.9 };
const 火山试炼范围 = 1600;
const Boss待战暂停来源 = "剧情系统:熔岩恶魔待战";

interface 火山试炼状态 {
  世代: number;
  Boss单位: any;
  玩家单位?: any;
  范围触发器?: any;
  取消范围监听?: () => void;
  已进入战斗: boolean;
}

let 下一代火山试炼世代 = 0;
let 当前火山试炼状态: 火山试炼状态 | undefined;
let 已注册死亡监听 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

function 播放主线剧情(this: void, 片段ID: string, 触发单位: any, 触发配置名: string): void {
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  播放主线剧情片段(片段ID, { 片段ID, 触发配置名, 触发单位 });
}

function 清理火山试炼范围监听(this: void, 状态: 火山试炼状态): void {
  if (状态.取消范围监听 != null) 状态.取消范围监听();
  if (状态.范围触发器 != null && 状态.范围触发器 !== 0) safeDestroyTrigger(状态.范围触发器);
  状态.取消范围监听 = undefined;
  状态.范围触发器 = undefined;
}

function on火山试炼范围触发(this: void): void {
  const 状态 = 当前火山试炼状态;
  if (状态 == null || 状态.已进入战斗 || 读取剧情进度() !== 41) return;

  const 触发单位 = GetTriggerUnit();
  if (!单位存活(触发单位) || !是玩家英雄组单位(触发单位)) return;

  状态.已进入战斗 = true;
  状态.玩家单位 = 触发单位;
  清理火山试炼范围监听(状态);
  注册剧情运行时单位("剧情运行时.火山试炼玩家", 触发单位);

  SetUnitPosition(触发单位, 玩家B.X, 玩家B.Y);
  SetUnitFacing(状态.Boss单位, YDWEAngleBetweenUnitsSafe(状态.Boss单位, 触发单位));
  SetUnitFacing(触发单位, YDWEAngleBetweenUnitsSafe(触发单位, 状态.Boss单位));
  播放主线剧情("molten_realm_fire_trial", 触发单位, "熔岩恶魔试炼入口");
}

function 注册火山试炼范围监听(this: void, 状态: 火山试炼状态): void {
  const trigger = CreateTrigger();
  if (trigger == null || trigger === 0) return;
  if (safeTriggerAddAction(trigger, on火山试炼范围触发) == null) {
    safeDestroyTrigger(trigger);
    return;
  }
  状态.范围触发器 = trigger;
  状态.取消范围监听 = registerUnitInRangeTrigger(trigger, 状态.Boss单位, 火山试炼范围, null, false);
}

function 准备火山试炼Boss(this: void): any {
  let bossUnit = 读取语义单位引用(Boss键);
  if (!单位存活(bossUnit)) {
    bossUnit = 创建并冻结剧情Boss预置({
      Boss键,
      Boss名,
      X: BossA.X,
      Y: BossA.Y,
      朝向: BossA.朝向,
      预创建后暂停: true,
      预创建后无敌: true,
    });
  }
  if (!单位存活(bossUnit)) return null;

  YDUserDataSetSafe("string", "Boss", "熔岩恶魔", "unit", bossUnit);
  SetUnitOwner(bossUnit, Player(中立敌对玩家ID), true);
  SetUnitPosition(bossUnit, BossA.X, BossA.Y);
  SetUnitFacing(bossUnit, BossA.朝向);
  IssueImmediateOrder(bossUnit, "stop");
  暂停并设置无敌安全(bossUnit, Boss待战暂停来源);
  注册剧情运行时单位("剧情运行时.熔岩恶魔", bossUnit);
  return bossUnit;
}

export function 执行准备火山之灵试炼(this: void): void {
  const 进度 = 读取剧情进度();
  if (进度 !== 40 && 进度 !== 41) return;
  if (当前火山试炼状态 != null && 单位存活(当前火山试炼状态.Boss单位)) return;

  const bossUnit = 准备火山试炼Boss();
  if (bossUnit == null || bossUnit === 0) return;

  下一代火山试炼世代++;
  当前火山试炼状态 = {
    世代: 下一代火山试炼世代,
    Boss单位: bossUnit,
    已进入战斗: false,
  };
  if (!已注册死亡监听) {
    registerDeathListener(on熔岩恶魔死亡);
    已注册死亡监听 = true;
  }
  注册火山试炼范围监听(当前火山试炼状态);
}

function on播放火灵核心交付(预期世代?: any): void {
  if (Number(预期世代) !== 下一代火山试炼世代) return;
  const 玩家单位 = 读取剧情运行时单位("剧情运行时.火山试炼玩家");
  if (单位存活(玩家单位)) {
    播放主线剧情("molten_realm_fire_core_handover", 玩家单位, "熔岩恶魔死亡后火灵核心交付");
  }
}

function on熔岩恶魔死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 状态 = 当前火山试炼状态;
  if (状态 == null || 状态.Boss单位 !== dyingUnit) return;

  清理火山试炼范围监听(状态);
  if (已注册死亡监听) {
    unregisterDeathListener(on熔岩恶魔死亡);
    已注册死亡监听 = false;
  }
  清理剧情运行时单位("剧情运行时.熔岩恶魔");
  YDUserDataClearSafe("string", "Boss", "熔岩恶魔", "unit");

  const 玩家单位 = 状态.玩家单位;
  当前火山试炼状态 = undefined;

  if (单位存活(玩家单位) && 是玩家英雄组单位(玩家单位)) {
    注册剧情运行时单位("剧情运行时.火山试炼玩家", 玩家单位);
    SetUnitPosition(玩家单位, 火灵核心交付点C.X, 火灵核心交付点C.Y);
    IssueImmediateOrder(玩家单位, "stop");
    addDelayedCallback(500, on播放火灵核心交付, 下一代火山试炼世代);
  }
}

export function 执行清理火灵核心交付(this: void, _参数: 剧情动作参数表): void {
  清理剧情运行时单位("剧情运行时.火山试炼玩家");
}

export function 执行完成火灵核心交付(this: void, _参数: 剧情动作参数表): void {
  写入剧情进度(42);
  发布主线节点目标(42);
  执行准备巴尔扎罗斯前导();
}

export function 执行启动火山之灵试炼(this: void, _参数: 剧情动作参数表): void {
  const bossUnit = 读取语义单位引用(Boss键);
  if (!单位存活(bossUnit)) return;
  const 状态 = 当前火山试炼状态;
  启动剧情Boss战(bossUnit, {
    触发单位: 状态?.玩家单位 ?? 读取当前剧情动作上下文().触发单位,
    暂停来源: Boss待战暂停来源,
  });
}

export const 熔岩恶魔试炼剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_准备火山之灵试炼": 执行准备火山之灵试炼,
  "第三章_启动火山之灵试炼": 执行启动火山之灵试炼,
  "第三章_完成火灵核心交付": 执行完成火灵核心交付,
  "第三章_清理火灵核心交付": 执行清理火灵核心交付,
};
