/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, 来源: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, 来源: string) => boolean;
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
const { 获取玩家英雄单位组, 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 注册剧情配置传送, 读取剧情传送配置 } = require("系统.07．地形系统.03．区域传送") as {
  注册剧情配置传送: (this: void, 配置ID: string, 覆盖: {
    读取玩家英雄组: (this: void) => any;
    允许进入单位?: (this: void, unit: any) => boolean;
    完成?: (this: void, 触发单位?: any) => void;
  }) => (this: void) => void;
  读取剧情传送配置: (this: void, 配置ID: string) => {
    入口中心X: number;
    入口中心Y: number;
  } | undefined;
};
const { YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { 缓存并移除亚伦柯斯安兹封锁墙 } = require("系统.07．地形系统.06．可破坏物数据.02．亚伦柯斯与安兹乌尔恭封锁墙") as {
  缓存并移除亚伦柯斯安兹封锁墙: (this: void) => boolean;
};
const { 按步长调整玩家镜头高度 } = require("系统.09．表现系统.14．镜头高度控制.index") as {
  按步长调整玩家镜头高度: (this: void, 玩家: any, 步数: number) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 创建并冻结剧情Boss预置 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 进入主线节点 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 开始监听封印核心入口 } from "./48．封印核心场景";
import { 创建安兹隐藏挑战 } from "./50．异界隐藏挑战入口";
const { 清理菲尼克斯尔战后地形装饰 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43A．菲尼克斯尔战后地形装饰") as {
  清理菲尼克斯尔战后地形装饰: (this: void) => void;
};

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const DestroyEffect = jass.DestroyEffect as (this: void, whichEffect: any) => void;
const RemoveDestructable = jass.RemoveDestructable as (this: void, whichDestructable: any) => void;

export const 亚伦柯斯Boss键 = "Boss.沉睡英魂·亚伦柯斯";
export const 亚伦柯斯待战暂停来源 = "剧情系统:亚伦柯斯待战";

const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 亚伦柯斯Boss名 = "沉睡英魂·亚伦柯斯";
const 亚伦柯斯正式预置 = { X: 8322.9, Y: -14452.7, 朝向: 270 };
const 亚伦柯斯进入范围 = 1400;
const 亚伦柯斯战后传送配置ID = "jlc_aronkos_aftermath";
const 亚伦柯斯战后传送模型 = "Common\\Effect\\Form\\Portal\\RicketSecretRoomShift.mdx";

interface 亚伦柯斯前导状态 {
  Boss单位: any;
  已触发对白: boolean;
  范围触发器?: any;
  取消范围监听?: () => void;
  已注册死亡监听: boolean;
}

interface 亚伦柯斯战后传送状态 {
  传送门特效?: any;
  取消传送注册?: (this: void) => void;
  已传送: boolean;
}

let 当前亚伦柯斯前导状态: 亚伦柯斯前导状态 | undefined;
let 当前亚伦柯斯战后传送状态: 亚伦柯斯战后传送状态 | undefined;
let 已播放封印核心抵达对白 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

function 清理亚伦柯斯范围监听(this: void, 状态: 亚伦柯斯前导状态): void {
  const 取消范围监听 = 状态.取消范围监听;
  if (取消范围监听 != null) 取消范围监听();
  if (状态.范围触发器 != null && 状态.范围触发器 !== 0) safeDestroyTrigger(状态.范围触发器);
  状态.取消范围监听 = undefined;
  状态.范围触发器 = undefined;
}

function 清理亚伦柯斯前导状态(this: void, 状态: 亚伦柯斯前导状态): void {
  清理亚伦柯斯范围监听(状态);
  if (状态.已注册死亡监听) {
    unregisterDeathListener(on亚伦柯斯死亡);
    状态.已注册死亡监听 = false;
  }
  解除暂停并取消无敌安全(状态.Boss单位, 亚伦柯斯待战暂停来源);
  清理剧情运行时单位("剧情运行时.亚伦柯斯");
  清理剧情运行时单位("剧情运行时.亚伦柯斯玩家");
  if (当前亚伦柯斯前导状态 === 状态) 当前亚伦柯斯前导状态 = undefined;
}

function 清理亚伦柯斯战后传送(this: void): void {
  const 状态 = 当前亚伦柯斯战后传送状态;
  if (状态 == null) return;
  if (状态.取消传送注册 != null) 状态.取消传送注册();
  if (状态.传送门特效 != null && 状态.传送门特效 !== 0) DestroyEffect(状态.传送门特效);
  状态.取消传送注册 = undefined;
  状态.传送门特效 = undefined;
  当前亚伦柯斯战后传送状态 = undefined;
}

function 读取亚伦柯斯战后玩家英雄组(this: void): any {
  return 获取玩家英雄单位组();
}

function 亚伦柯斯战后允许进入(this: void, unit: any): boolean {
  return 是玩家英雄组单位(unit);
}

function 播放封印核心抵达对白(this: void, 触发单位?: any): void {
  if (已播放封印核心抵达对白) return;
  const 玩家单位 = 触发单位;
  if (!单位存活(玩家单位)) return;

  注册剧情运行时单位("剧情运行时.封印核心抵达玩家", 玩家单位);
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  const 已播放 = 播放主线剧情片段("molten_realm_seal_core_arrival", {
    片段ID: "molten_realm_seal_core_arrival",
    触发配置名: "亚伦柯斯战后传送落点",
    触发单位: 玩家单位,
  });
  if (已播放) {
    已播放封印核心抵达对白 = true;
  } else {
    清理剧情运行时单位("剧情运行时.封印核心抵达玩家");
  }
}

function 完成亚伦柯斯战后传送(this: void, 触发单位?: any): void {
  const 状态 = 当前亚伦柯斯战后传送状态;
  if (状态 == null || 状态.已传送) return;
  状态.已传送 = true;
  清理亚伦柯斯战后传送();
  if (触发单位 != null && 触发单位 !== 0) {
    按步长调整玩家镜头高度(GetOwningPlayer(触发单位), -6);
  }
  开始监听封印核心入口();
  播放封印核心抵达对白(触发单位);
}

function 创建亚伦柯斯战后传送门(this: void): void {
  const 传送配置 = 读取剧情传送配置(亚伦柯斯战后传送配置ID);
  if (传送配置 == null) return;

  const 状态 = 当前亚伦柯斯战后传送状态 ?? { 已传送: false };
  当前亚伦柯斯战后传送状态 = 状态;
  if (状态.已传送) return;
  if (状态.传送门特效 == null || 状态.传送门特效 === 0) {
    状态.传送门特效 = 创建点特效({
      模型路径: 亚伦柯斯战后传送模型,
      X: 传送配置.入口中心X,
      Y: 传送配置.入口中心Y,
      Z: 0,
      缩放: 1,
    });
  }
  if (状态.取消传送注册 != null) return;
  状态.取消传送注册 = 注册剧情配置传送(亚伦柯斯战后传送配置ID, {
    读取玩家英雄组: 读取亚伦柯斯战后玩家英雄组,
    允许进入单位: 亚伦柯斯战后允许进入,
    完成: 完成亚伦柯斯战后传送,
  });
}

function on亚伦柯斯死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 状态 = 当前亚伦柯斯前导状态;
  if (状态 == null || 状态.Boss单位 !== dyingUnit) return;
  清理亚伦柯斯前导状态(状态);
  清理菲尼克斯尔战后地形装饰();
  const 墓地阻挡 = jglobals.gg_dest_Dofw_10481;
  if (墓地阻挡 != null && 墓地阻挡 !== 0) RemoveDestructable(墓地阻挡);
  进入主线节点(48);
  创建亚伦柯斯战后传送门();
  创建安兹隐藏挑战();
}

function 播放亚伦柯斯前导(this: void, 触发单位: any): void {
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  播放主线剧情片段("molten_realm_aronkos_intro", {
    片段ID: "molten_realm_aronkos_intro",
    触发配置名: "沉睡英魂亚伦柯斯前导范围入口",
    触发单位,
  });
}

function on亚伦柯斯范围触发(this: void): void {
  const 状态 = 当前亚伦柯斯前导状态;
  if (状态 == null || 状态.已触发对白) return;
  const 当前进度 = 读取剧情进度();
  if (当前进度 !== 45 && 当前进度 !== 46) return;

  const 触发单位 = GetTriggerUnit();
  if (!单位存活(触发单位) || !是玩家英雄组单位(触发单位)) return;

  状态.已触发对白 = true;
  清理亚伦柯斯范围监听(状态);
  注册剧情运行时单位("剧情运行时.亚伦柯斯玩家", 触发单位);
  SetUnitFacing(状态.Boss单位, YDWEAngleBetweenUnitsSafe(状态.Boss单位, 触发单位));
  SetUnitFacing(触发单位, YDWEAngleBetweenUnitsSafe(触发单位, 状态.Boss单位));
  进入主线节点(46);
  播放亚伦柯斯前导(触发单位);
}

function 注册亚伦柯斯范围监听(this: void, 状态: 亚伦柯斯前导状态): void {
  const trigger = CreateTrigger();
  if (trigger == null || trigger === 0) return;
  if (safeTriggerAddAction(trigger, on亚伦柯斯范围触发) == null) {
    safeDestroyTrigger(trigger);
    return;
  }
  状态.范围触发器 = trigger;
  状态.取消范围监听 = registerUnitInRangeTrigger(trigger, 状态.Boss单位, 亚伦柯斯进入范围, null, false);
}

function 确保亚伦柯斯待战单位(this: void): any {
  let bossUnit = 读取语义单位引用(亚伦柯斯Boss键);
  let 复用已有单位 = true;
  if (!单位存活(bossUnit)) {
    复用已有单位 = false;
    bossUnit = 创建并冻结剧情Boss预置({
      Boss键: 亚伦柯斯Boss键,
      Boss名: 亚伦柯斯Boss名,
      X: 亚伦柯斯正式预置.X,
      Y: 亚伦柯斯正式预置.Y,
      朝向: 亚伦柯斯正式预置.朝向,
      预创建后暂停: true,
      预创建后无敌: true,
    });
  }
  if (!单位存活(bossUnit)) return null;

  SetUnitOwner(bossUnit, Player(中立敌对玩家ID), true);
  SetUnitPosition(bossUnit, 亚伦柯斯正式预置.X, 亚伦柯斯正式预置.Y);
  SetUnitFacing(bossUnit, 亚伦柯斯正式预置.朝向);
  IssueImmediateOrder(bossUnit, "stop");
  if (复用已有单位) 暂停并设置无敌安全(bossUnit, 亚伦柯斯待战暂停来源);
  注册剧情运行时单位("剧情运行时.亚伦柯斯", bossUnit);
  return bossUnit;
}

export function 执行准备亚伦柯斯前导(this: void): void {
  const 当前进度 = 读取剧情进度();
  if (当前进度 !== 45 && 当前进度 !== 46) return;
  缓存并移除亚伦柯斯安兹封锁墙();
  if (当前亚伦柯斯前导状态 != null && 单位存活(当前亚伦柯斯前导状态.Boss单位)) return;
  if (当前亚伦柯斯前导状态 != null) 清理亚伦柯斯前导状态(当前亚伦柯斯前导状态);

  const bossUnit = 确保亚伦柯斯待战单位();
  if (!单位存活(bossUnit)) return;

  当前亚伦柯斯前导状态 = {
    Boss单位: bossUnit,
    已触发对白: false,
    已注册死亡监听: true,
  };
  registerDeathListener(on亚伦柯斯死亡);
  注册亚伦柯斯范围监听(当前亚伦柯斯前导状态);
}

export function 执行准备亚伦柯斯前导动作(this: void, _参数?: any): void {
  执行准备亚伦柯斯前导();
}

export function 执行开启亚伦柯斯战后传送门(this: void, _参数?: any): void {
  创建亚伦柯斯战后传送门();
}

export function 执行清理亚伦柯斯战后传送门(this: void, _参数?: any): void {
  清理亚伦柯斯战后传送();
}

export function 执行清理封印核心抵达对白玩家(this: void, _参数: 剧情动作参数表): void {
  清理剧情运行时单位("剧情运行时.封印核心抵达玩家");
}

export const 沉睡英魂亚伦柯斯前导剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_准备亚伦柯斯前导": 执行准备亚伦柯斯前导动作,
  "第三章_开启亚伦柯斯战后传送门": 执行开启亚伦柯斯战后传送门,
  "第三章_清理亚伦柯斯战后传送门": 执行清理亚伦柯斯战后传送门,
  "第三章_清理封印核心抵达对白玩家": 执行清理封印核心抵达对白玩家,
};
