/** @noSelfInFile */

const jass = require("jass.common") as any;

const {
  YDUserDataClearSafe,
  YDWEAngleBetweenUnitsSafe,
} = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { 创建并冻结剧情Boss预置 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接") as {
  创建并冻结剧情Boss预置: (this: void, 参数: any) => any;
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, 来源: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, 来源: string) => boolean;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => (this: void) => void;
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
const { 获取玩家英雄单位组 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 注册剧情玩家组传送 } = require("系统.07．地形系统.03．区域传送") as {
  注册剧情玩家组传送: (this: void, 配置: {
    入口中心X: number;
    入口中心Y: number;
    入口半径: number;
    目标X: number;
    目标Y: number;
    条件: (this: void) => boolean;
    读取玩家英雄组: (this: void) => any;
    允许进入单位?: (this: void, unit: any) => boolean;
    完成?: (this: void, 触发单位?: any) => void;
  }) => (this: void) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.index") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 按步长调整玩家镜头高度 } = require("系统.09．表现系统.14．镜头高度控制.index") as {
  按步长调整玩家镜头高度: (this: void, 玩家: any, 步数: number) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 注册剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 进入主线节点 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";
import { 执行准备菲尼克斯尔现身 } from "./43．菲尼克斯尔现身";

const { 启用第三章亚伦柯斯前导区域背景音乐 } = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  启用第三章亚伦柯斯前导区域背景音乐: (this: void) => boolean;
};

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const ForGroup = jass.ForGroup as (this: void, whichGroup: any, callback: (this: void) => void) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const ShowUnit = jass.ShowUnit as (this: void, whichUnit: any, show: boolean) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;

const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const Boss键 = "Boss.熔岩恶魔王";
const Boss名 = "熔岩恶魔王·巴尔扎罗斯";
const Boss待战暂停来源 = "剧情系统:巴尔扎罗斯待战";
const Boss位置 = { X: 28640.0, Y: -3734.5, 朝向: 270.0 };
const Boss进入范围 = 1600;
const 战后返回面向 = 90;
const 战后传送门位置 = { X: 28656.0, Y: -3248.0 };
const 火焰神殿入口位置 = { X: 7272.6, Y: -7320.4 };
const 战后传送门半径 = 210;
const 战后传送门模型 = "Common\\Effect\\Form\\Portal\\7sr_suramarcity_pylonfx.mdx";

interface 巴尔扎罗斯前导状态 {
  世代: number;
  Boss单位: any;
  已触发前导: boolean;
  范围触发器?: any;
  取消范围监听?: (this: void) => void;
}

let 下一代巴尔扎罗斯前导世代 = 0;
let 当前巴尔扎罗斯前导状态: 巴尔扎罗斯前导状态 | undefined;
let 已注册巴尔扎罗斯死亡监听 = false;

interface 巴尔扎罗斯战后传送状态 {
  传送门特效?: any;
  取消剧情传送注册?: (this: void) => void;
  已传送: boolean;
}

let 当前巴尔扎罗斯战后传送状态: 巴尔扎罗斯战后传送状态 | undefined;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function on返回巴尔扎罗斯触发区域(this: void): void {
  const unit = GetEnumUnit();
  if (!句柄有效(unit)) return;
  SetUnitPosition(unit, Boss位置.X, Boss位置.Y);
  SetUnitFacing(unit, 战后返回面向);
  IssueImmediateOrder(unit, "stop");
  StarOther_PanCameraToTimedForPlayer(GetOwningPlayer(unit), Boss位置.X, Boss位置.Y, 0.1);
}

function 返回巴尔扎罗斯触发区域(this: void): void {
  const 玩家英雄组 = 获取玩家英雄单位组();
  if (!句柄有效(玩家英雄组)) return;
  ForGroup(玩家英雄组, on返回巴尔扎罗斯触发区域);
}

function 清理巴尔扎罗斯战后传送(this: void, 状态: 巴尔扎罗斯战后传送状态): void {
  if (状态.取消剧情传送注册 != null) 状态.取消剧情传送注册();
  if (句柄有效(状态.传送门特效)) DestroyEffect(状态.传送门特效);
  状态.取消剧情传送注册 = undefined;
  状态.传送门特效 = undefined;
}

function 巴尔扎罗斯战后允许进入(this: void, unit: any): boolean {
  return 是玩家英雄组单位(unit);
}

function 巴尔扎罗斯战后传送条件(this: void): boolean {
  return 读取剧情进度() === 43;
}

function 完成巴尔扎罗斯战后传送(this: void, 触发单位?: any): void {
  const 状态 = 当前巴尔扎罗斯战后传送状态;
  if (状态 == null || 状态.已传送) return;
  状态.已传送 = true;
  清理巴尔扎罗斯战后传送(状态);
  if (触发单位 != null && 触发单位 !== 0) {
    按步长调整玩家镜头高度(GetOwningPlayer(触发单位), 6);
  }
  清理剧情运行时单位("剧情运行时.巴尔扎罗斯玩家");
  当前巴尔扎罗斯战后传送状态 = undefined;
}

function 创建巴尔扎罗斯战后传送门(this: void): void {
  const 状态 = 当前巴尔扎罗斯战后传送状态 ?? { 已传送: false };
  当前巴尔扎罗斯战后传送状态 = 状态;
  if (状态.已传送) return;
  if (!句柄有效(状态.传送门特效)) {
    状态.传送门特效 = 创建点特效({
      模型路径: 战后传送门模型,
      X: 战后传送门位置.X,
      Y: 战后传送门位置.Y,
      缩放: 2.2,
    });
  }
  if (状态.取消剧情传送注册 != null) return;
  状态.取消剧情传送注册 = 注册剧情玩家组传送({
    入口中心X: 战后传送门位置.X,
    入口中心Y: 战后传送门位置.Y,
    入口半径: 战后传送门半径,
    目标X: 火焰神殿入口位置.X,
    目标Y: 火焰神殿入口位置.Y,
    条件: 巴尔扎罗斯战后传送条件,
    读取玩家英雄组: 获取玩家英雄单位组,
    允许进入单位: 巴尔扎罗斯战后允许进入,
    完成: 完成巴尔扎罗斯战后传送,
  });
}

function 播放巴尔扎罗斯前导(this: void, 触发单位: any): void {
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  播放主线剧情片段("molten_realm_balzaroth_intro", {
    片段ID: "molten_realm_balzaroth_intro",
    触发配置名: "巴尔扎罗斯旧熔炉门入口",
    触发单位,
  });
}

function 清理巴尔扎罗斯范围监听(this: void, 状态: 巴尔扎罗斯前导状态): void {
  if (状态.取消范围监听 != null) 状态.取消范围监听();
  if (状态.范围触发器 != null && 状态.范围触发器 !== 0) safeDestroyTrigger(状态.范围触发器);
  状态.取消范围监听 = undefined;
  状态.范围触发器 = undefined;
}

function on巴尔扎罗斯范围触发(this: void): void {
  const 状态 = 当前巴尔扎罗斯前导状态;
  if (状态 == null || 状态.已触发前导 || 读取剧情进度() !== 42) return;

  const 触发单位 = GetTriggerUnit();
  if (!单位存活(触发单位) || !是玩家英雄组单位(触发单位)) return;

  状态.已触发前导 = true;
  清理巴尔扎罗斯范围监听(状态);
  注册剧情运行时单位("剧情运行时.巴尔扎罗斯玩家", 触发单位);

  SetUnitFacing(状态.Boss单位, YDWEAngleBetweenUnitsSafe(状态.Boss单位, 触发单位));
  SetUnitFacing(触发单位, YDWEAngleBetweenUnitsSafe(触发单位, 状态.Boss单位));
  播放巴尔扎罗斯前导(触发单位);
}

function 注册巴尔扎罗斯范围监听(this: void, 状态: 巴尔扎罗斯前导状态): void {
  const trigger = CreateTrigger();
  if (trigger == null || trigger === 0) return;
  if (safeTriggerAddAction(trigger, on巴尔扎罗斯范围触发) == null) {
    safeDestroyTrigger(trigger);
    return;
  }
  状态.范围触发器 = trigger;
  状态.取消范围监听 = registerUnitInRangeTrigger(trigger, 状态.Boss单位, Boss进入范围, null, false);
}

function 准备巴尔扎罗斯Boss(this: void): any {
  let bossUnit = 读取语义单位引用(Boss键);
  if (!单位存活(bossUnit)) {
    bossUnit = 创建并冻结剧情Boss预置({
      Boss键,
      Boss名,
      X: Boss位置.X,
      Y: Boss位置.Y,
      朝向: Boss位置.朝向,
      预创建后暂停: false,
      预创建后无敌: false,
    });
  }
  if (!单位存活(bossUnit)) return null;

  ShowUnit(bossUnit, true);
  SetUnitOwner(bossUnit, Player(中立敌对玩家ID), true);
  SetUnitPosition(bossUnit, Boss位置.X, Boss位置.Y);
  SetUnitFacing(bossUnit, Boss位置.朝向);
  IssueImmediateOrder(bossUnit, "stop");
  暂停并设置无敌安全(bossUnit, Boss待战暂停来源);
  注册剧情运行时单位("剧情运行时.巴尔扎罗斯", bossUnit);
  return bossUnit;
}

export function 执行准备巴尔扎罗斯前导(this: void): void {
  if (读取剧情进度() !== 42) return;
  if (当前巴尔扎罗斯前导状态 != null && 单位存活(当前巴尔扎罗斯前导状态.Boss单位)) return;

  const bossUnit = 准备巴尔扎罗斯Boss();
  if (bossUnit == null || bossUnit === 0) return;

  下一代巴尔扎罗斯前导世代++;
  当前巴尔扎罗斯前导状态 = {
    世代: 下一代巴尔扎罗斯前导世代,
    Boss单位: bossUnit,
    已触发前导: false,
  };
  if (!已注册巴尔扎罗斯死亡监听) {
    registerDeathListener(on巴尔扎罗斯死亡);
    已注册巴尔扎罗斯死亡监听 = true;
  }
  注册巴尔扎罗斯范围监听(当前巴尔扎罗斯前导状态);
}

export function 执行启动巴尔扎罗斯Boss战(this: void, _参数: 剧情动作参数表): void {
  const bossUnit = 读取剧情运行时单位("剧情运行时.巴尔扎罗斯") ?? 读取语义单位引用(Boss键);
  if (!单位存活(bossUnit)) return;

  const 玩家单位 = 读取剧情运行时单位("剧情运行时.巴尔扎罗斯玩家") ?? 读取当前剧情动作上下文().触发单位;
  解除暂停并取消无敌安全(bossUnit, Boss待战暂停来源);
  启动剧情Boss战(bossUnit, {
    触发单位: 玩家单位,
    暂停来源: Boss待战暂停来源,
  });
}

function 执行准备巴尔扎罗斯前导动作(this: void, _参数: 剧情动作参数表): void {
  执行准备巴尔扎罗斯前导();
}

function 播放巴尔扎罗斯战后承接(this: void, 触发单位: any): boolean {
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  return 播放主线剧情片段("molten_realm_balzaroth_aftermath", {
    片段ID: "molten_realm_balzaroth_aftermath",
    触发配置名: "巴尔扎罗斯死亡后的火焰神殿承接",
    触发单位,
  });
}

function on巴尔扎罗斯死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 状态 = 当前巴尔扎罗斯前导状态;
  if (状态 == null || 状态.Boss单位 !== dyingUnit) return;

  const 玩家单位 = 读取剧情运行时单位("剧情运行时.巴尔扎罗斯玩家");

  清理巴尔扎罗斯范围监听(状态);
  if (已注册巴尔扎罗斯死亡监听) {
    unregisterDeathListener(on巴尔扎罗斯死亡);
    已注册巴尔扎罗斯死亡监听 = false;
  }
  清理剧情运行时单位("剧情运行时.巴尔扎罗斯");
  YDUserDataClearSafe("string", "Boss", "熔岩恶魔王", "unit");
  当前巴尔扎罗斯前导状态 = undefined;

  if (读取剧情进度() !== 42) return;
  返回巴尔扎罗斯触发区域();
  进入主线节点(43);
  启用第三章亚伦柯斯前导区域背景音乐();
  if (!播放巴尔扎罗斯战后承接(玩家单位)) {
    创建巴尔扎罗斯战后传送门();
    执行准备菲尼克斯尔现身();
  }
}

export function 执行开启巴尔扎罗斯战后传送门(this: void, _参数: 剧情动作参数表): void {
  创建巴尔扎罗斯战后传送门();
}

export const 巴尔扎罗斯前导剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_准备巴尔扎罗斯前导": 执行准备巴尔扎罗斯前导动作,
  "第三章_启动巴尔扎罗斯Boss战": 执行启动巴尔扎罗斯Boss战,
  "第三章_开启巴尔扎罗斯战后传送门": 执行开启巴尔扎罗斯战后传送门,
};
