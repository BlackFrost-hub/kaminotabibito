/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 创建并冻结剧情Boss预置 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接") as {
  创建并冻结剧情Boss预置: (this: void, 参数: any) => any;
};
const { 暂停并设置无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, 来源: string) => boolean;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { registerOneShotUnitRangeListener } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerOneShotUnitRangeListener: (this: void, unit: any, range: number, callback: (this: void, enteringUnit: any) => boolean, predicate?: (this: void, enteringUnit: any) => boolean) => () => void;
};
const { registerDeathListener, unregisterDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
  unregisterDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 获取玩家英雄单位组 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
};
const { YDWEAngleBetweenUnitsSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建菲尼克斯尔战后地形装饰 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43A．菲尼克斯尔战后地形装饰") as {
  创建菲尼克斯尔战后地形装饰: (this: void) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.index") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};

import { 菲尼克斯尔场地配置 } from "../../../../03．技能系统/05．单位技能/03．Boss技能/01．主线Boss/04．双重凤凰菲尼克斯尔/01．场地配置";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 应用第三章电影镜头 } from "./40-50．第三章电影镜头";
import { 清理剧情运行时单位, 注册剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 尝试播放Boss死亡主线剧情 } from "../06．Boss死亡剧情索引";

const ForGroup = jass.ForGroup as (this: void, whichGroup: any, callback: (this: void) => void) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;

export const 菲尼克斯尔Boss键 = "Boss.双重凤凰·菲尼克斯尔";
export const 菲尼克斯尔待战暂停来源 = "剧情系统:菲尼克斯尔待战";

const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 菲尼克斯尔Boss名 = "双重凤凰·菲尼克斯尔";
const 菲尼克斯尔进入范围 = 1400;
const 菲尼克斯尔触发区域 = { X: 15429.9, Y: -4014.9, 朝向: 0 };

interface 菲尼克斯尔现身状态 {
  Boss单位: any;
  已触发现身: boolean;
  取消范围监听?: (this: void) => void;
  已注册死亡监听: boolean;
  已创建神殿入口表现: boolean;
}

let 当前菲尼克斯尔现身状态: 菲尼克斯尔现身状态 | undefined;
let 已正式击败菲尼克斯尔 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

function on返回菲尼克斯尔触发区域(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  SetUnitPosition(unit, 菲尼克斯尔触发区域.X, 菲尼克斯尔触发区域.Y);
  SetUnitFacing(unit, 菲尼克斯尔触发区域.朝向);
  IssueImmediateOrder(unit, "stop");
  StarOther_PanCameraToTimedForPlayer(GetOwningPlayer(unit), 菲尼克斯尔触发区域.X, 菲尼克斯尔触发区域.Y, 0.1);
}

function 返回菲尼克斯尔触发区域(this: void): void {
  const 玩家英雄组 = 获取玩家英雄单位组();
  if (玩家英雄组 == null || 玩家英雄组 === 0) return;
  ForGroup(玩家英雄组, on返回菲尼克斯尔触发区域);
}

function 清理菲尼克斯尔范围监听(this: void, 状态: 菲尼克斯尔现身状态): void {
  if (状态.取消范围监听 != null) 状态.取消范围监听();
  状态.取消范围监听 = undefined;
}

function 创建神殿入口表现(this: void, 状态: 菲尼克斯尔现身状态): void {
  if (状态.已创建神殿入口表现) return;
  状态.已创建神殿入口表现 = true;
  创建点特效({
    模型路径: "Common\\Effect\\Form\\Portal\\FeliceSiegeBluePortal.mdx",
    X: 菲尼克斯尔场地配置.Boss初始点.x,
    Y: 菲尼克斯尔场地配置.Boss初始点.y,
    持续秒: 8,
    缩放: 2.2,
  });
}

function 播放菲尼克斯尔现身(this: void, 触发单位: any): void {
  应用第三章电影镜头(43);
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  播放主线剧情片段("molten_realm_phoenixel_reveal", {
    片段ID: "molten_realm_phoenixel_reveal",
    触发配置名: "火焰神殿菲尼克斯尔现身",
    触发单位,
  });
}

function on菲尼克斯尔范围触发(this: void, 触发单位: any): boolean {
  const 状态 = 当前菲尼克斯尔现身状态;
  if (状态 == null || 状态.已触发现身 || 读取剧情进度() !== 43) return false;
  if (!单位存活(触发单位)) return false;

  状态.已触发现身 = true;
  清理菲尼克斯尔范围监听(状态);
  注册剧情运行时单位("剧情运行时.菲尼克斯尔玩家", 触发单位);
  SetUnitFacing(状态.Boss单位, YDWEAngleBetweenUnitsSafe(状态.Boss单位, 触发单位));
  SetUnitFacing(触发单位, YDWEAngleBetweenUnitsSafe(触发单位, 状态.Boss单位));
  播放菲尼克斯尔现身(触发单位);
  return true;
}

function 注册菲尼克斯尔范围监听(this: void, 状态: 菲尼克斯尔现身状态): void {
  状态.取消范围监听 = registerOneShotUnitRangeListener(
    状态.Boss单位,
    菲尼克斯尔进入范围,
    on菲尼克斯尔范围触发,
    是玩家英雄组单位,
  );
}

function on菲尼克斯尔死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 状态 = 当前菲尼克斯尔现身状态;
  if (状态 == null || 状态.Boss单位 !== dyingUnit) return;
  已正式击败菲尼克斯尔 = true;

  const 战后玩家 = 读取剧情运行时单位("剧情运行时.菲尼克斯尔玩家");
  if (战后玩家 != null && 战后玩家 !== 0) {
    注册剧情运行时单位("剧情运行时.菲尼克斯尔战后玩家", 战后玩家);
  }
  返回菲尼克斯尔触发区域();
  创建菲尼克斯尔战后地形装饰();
  SetUnitPosition(dyingUnit, 菲尼克斯尔触发区域.X, 菲尼克斯尔触发区域.Y);
  SetUnitFacing(dyingUnit, 菲尼克斯尔触发区域.朝向);
  注册剧情运行时单位("主线NPC.菲尼克斯尔残响", dyingUnit);

  清理菲尼克斯尔范围监听(状态);
  if (状态.已注册死亡监听) {
    unregisterDeathListener(on菲尼克斯尔死亡);
    状态.已注册死亡监听 = false;
  }
  清理剧情运行时单位("剧情运行时.菲尼克斯尔");
  清理剧情运行时单位("剧情运行时.菲尼克斯尔玩家");
  YDUserDataClearSafe("string", "Boss", "双重凤凰·菲尼克斯尔", "unit");
  当前菲尼克斯尔现身状态 = undefined;
  尝试播放Boss死亡主线剧情(dyingUnit);
}

export function 获取菲尼克斯尔Boss(this: void): any {
  return 当前菲尼克斯尔现身状态?.Boss单位 ?? 读取剧情运行时单位("剧情运行时.菲尼克斯尔") ?? 读取语义单位引用(菲尼克斯尔Boss键);
}

export function 是否已正式击败菲尼克斯尔(this: void): boolean {
  return 已正式击败菲尼克斯尔;
}

export function 执行准备菲尼克斯尔现身(this: void): void {
  if (读取剧情进度() !== 43) return;
  const 当前Boss = 获取菲尼克斯尔Boss();
  if (单位存活(当前Boss)) return;

  const 初始点 = 菲尼克斯尔场地配置.Boss初始点;
  const bossUnit = 创建并冻结剧情Boss预置({
    Boss键: 菲尼克斯尔Boss键,
    Boss名: 菲尼克斯尔Boss名,
    X: 初始点.x,
    Y: 初始点.y,
    朝向: 0,
    预创建后暂停: false,
    预创建后无敌: false,
  });
  if (!单位存活(bossUnit)) return;

  SetUnitOwner(bossUnit, Player(中立敌对玩家ID), true);
  SetUnitPosition(bossUnit, 初始点.x, 初始点.y);
  SetUnitFacing(bossUnit, 0);
  IssueImmediateOrder(bossUnit, "stop");
  暂停并设置无敌安全(bossUnit, 菲尼克斯尔待战暂停来源);
  注册剧情运行时单位("剧情运行时.菲尼克斯尔", bossUnit);

  当前菲尼克斯尔现身状态 = {
    Boss单位: bossUnit,
    已触发现身: false,
    已注册死亡监听: true,
    已创建神殿入口表现: false,
  };
  registerDeathListener(on菲尼克斯尔死亡);
  创建神殿入口表现(当前菲尼克斯尔现身状态);
  注册菲尼克斯尔范围监听(当前菲尼克斯尔现身状态);
}

export function 执行菲尼克斯尔现身准备动作(this: void): void {
  执行准备菲尼克斯尔现身();
}

export const 菲尼克斯尔现身剧情动作注册表: Record<string, (this: void, 参数?: any) => void> = {
  "第三章_准备菲尼克斯尔现身": 执行菲尼克斯尔现身准备动作,
};
