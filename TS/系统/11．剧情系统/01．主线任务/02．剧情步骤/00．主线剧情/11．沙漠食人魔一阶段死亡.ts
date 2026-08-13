/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};
const { 添加单位暂停, 释放单位暂停来源全部 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  释放单位暂停来源全部: (this: void, unit: any, source: string) => boolean;
};
const { 暂停并设置无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
};
const 沙漠食人魔二阶段待战暂停来源 = "剧情系统:沙漠食人魔二阶段待战";

const { YDUserDataGetSafe, YDUserDataSetSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按结算键执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  按结算键执行Boss死亡结算: (this: void, 结算键: string, Boss单位?: any, 击杀者?: any) => boolean;
};
const { 消费保留剧情Boss死亡击杀者 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接") as {
  消费保留剧情Boss死亡击杀者: (this: void, bossUnit: any) => any;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { StarOther_PanCameraToTimedUnitForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedUnitForPlayer: (this: void, whichPlayer: any, unit: any, duration: number) => void;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { 卸载区域背景音乐句柄 } = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时") as {
  卸载区域背景音乐句柄: (this: void, soundHandle: any, rectHandle: any) => boolean;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { 注册剧情片段清理 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表") as {
  注册剧情片段清理: (this: void, 片段ID: string, 清理函数: (this: void) => void) => void;
};
const { 注册剧情运行时单位, 读取剧情运行时单位, 清理剧情运行时单位 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位") as {
  注册剧情运行时单位: (this: void, 语义名: string, unit: any) => void;
  读取剧情运行时单位: (this: void, 语义名: string) => any;
  清理剧情运行时单位: (this: void, 语义名: string) => void;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; Z?: number; 面向角度?: number; 缩放?: number; 动画速度?: number; 持续秒?: number }) => any;
};
import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 写入当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";
export { 沙漠食人魔一阶段死亡剧情片段 } from "../01．第一章/11．沙漠食人魔一阶段死亡";

const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, whichUnit: any, order: string, targetWidget: any) => boolean;
const UnitSuspendDecay = jass.UnitSuspendDecay as (this: void, whichUnit: any, flag: boolean) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetUnitName = jass.GetUnitName as (this: void, whichUnit: any) => string;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => boolean;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

let 待开战杀戮食人魔: any = null;
let 待开战目标单位: any = null;
let 待处理一阶段死亡单位: any = null;
let 玩家英雄延迟恢复ID = 0;
let 玩家英雄暂停组: any = null;
const 沙漠食人魔一阶段死亡玩家暂停来源 = "剧情系统:沙漠食人魔一阶段死亡现场";
let 二阶段显现周期ID = 0;
let 二阶段显现次数 = 0;
let 一阶段死亡X = 0;
let 一阶段死亡Y = 0;

const 裂隙运行时键 = "剧情运行时.沙漠食人魔裂隙";
const 蜥蜴人运行时键 = "主线NPC.裂隙蜥蜴人";

function 清理沙漠食人魔一阶段演出(this: void): void {
  if (玩家英雄延迟恢复ID !== 0) {
    removeDelayedCallback(玩家英雄延迟恢复ID);
    玩家英雄延迟恢复ID = 0;
  }
  if (二阶段显现周期ID !== 0) {
    removePeriodicCallback(二阶段显现周期ID);
    二阶段显现周期ID = 0;
  }
  恢复玩家英雄控制();
  const 裂隙 = 读取剧情运行时单位(裂隙运行时键);
  if (裂隙 != null && 裂隙 !== 0) 立即移除单位并取消排泄登记(裂隙);
  清理剧情运行时单位(裂隙运行时键);
  const 蜥蜴人 = 读取剧情运行时单位(蜥蜴人运行时键);
  if (蜥蜴人 != null && 蜥蜴人 !== 0) 立即移除单位并取消排泄登记(蜥蜴人);
  清理剧情运行时单位(蜥蜴人运行时键);
  if (待处理一阶段死亡单位 != null && 待处理一阶段死亡单位 !== 0) {
    UnitSuspendDecay(待处理一阶段死亡单位, false);
    RemoveUnit(待处理一阶段死亡单位);
    待处理一阶段死亡单位 = null;
  }
}

function 暂停死亡点附近玩家英雄并看向裂隙(this: void, 裂隙: any, x: number, y: number): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0 || 裂隙 == null || 裂隙 === 0) return;

  恢复玩家英雄控制();
  玩家英雄暂停组 = CreateGroup();
  const 范围单位组 = CreateGroup();
  GroupEnumUnitsInRange(范围单位组, x, y, 3000, null);
  while (true) {
    const unit = FirstOfGroup(范围单位组);
    if (unit == null || unit === 0) break;
    GroupRemoveUnit(范围单位组, unit);
    if (!IsUnitInGroup(unit, 玩家英雄组)) continue;
    添加单位暂停(unit, 沙漠食人魔一阶段死亡玩家暂停来源);
    GroupAddUnit(玩家英雄暂停组, unit);
    SetUnitFacing(unit, YDWEAngleBetweenUnitsSafe(unit, 裂隙));
    StarOther_PanCameraToTimedUnitForPlayer(GetOwningPlayer(unit), 裂隙, 0.75);
  }
  DestroyGroup(范围单位组);
}

function 恢复玩家英雄控制(this: void): void {
  玩家英雄延迟恢复ID = 0;
  if (玩家英雄暂停组 == null || 玩家英雄暂停组 === 0) return;
  while (true) {
    const unit = FirstOfGroup(玩家英雄暂停组);
    if (unit == null || unit === 0) break;
    GroupRemoveUnit(玩家英雄暂停组, unit);
    释放单位暂停来源全部(unit, 沙漠食人魔一阶段死亡玩家暂停来源);
  }
  DestroyGroup(玩家英雄暂停组);
  玩家英雄暂停组 = null;
}

export function 执行沙漠食人魔一阶段死亡前置(this: void, 参数: 剧情动作参数表): void {
  const 上下文触发单位 = 读取当前剧情动作上下文().触发单位;
  const 事件死亡单位 = GetDyingUnit();
  const dyingUnit = 事件死亡单位 != null && 事件死亡单位 !== 0 ? 事件死亡单位 : 上下文触发单位;
  if (dyingUnit == null || dyingUnit === 0) return;
  const killingUnit = 消费保留剧情Boss死亡击杀者(dyingUnit);
  待处理一阶段死亡单位 = dyingUnit;
  待开战目标单位 = killingUnit != null && killingUnit !== 0 ? killingUnit : null;
  if (待开战目标单位 != null) {
    const 上下文 = 读取当前剧情动作上下文();
    写入当前剧情动作上下文({ ...上下文, 触发单位: 待开战目标单位 });
  }
  UnitSuspendDecay(dyingUnit, true);
  按结算键执行Boss死亡结算("沙漠食人魔", dyingUnit, 待开战目标单位);

  一阶段死亡X = GetUnitX(dyingUnit);
  一阶段死亡Y = GetUnitY(dyingUnit);
  const 胜利音效 = jglobals.gg_snd_shengliBgm;
  const 战斗区域 = 获取矩形区域("沙漠区域.Boss战区域");
  卸载区域背景音乐句柄(胜利音效, 战斗区域);

  const riftTypeId = stringToFourCCSafe("e08M");
  let riftUnit: any = null;
  if (riftTypeId > 0) {
    riftUnit = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), riftTypeId, 27531.2, 13562.4, 0);
    注册剧情运行时单位(裂隙运行时键, riftUnit);
    创建点特效({ 模型路径: "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", X: 27531.2, Y: 13562.4, 面向角度: 270, 缩放: 2, 动画速度: 1, 持续秒: 1.5 });
  }
  暂停死亡点附近玩家英雄并看向裂隙(riftUnit, 一阶段死亡X, 一阶段死亡Y);
  if (玩家英雄延迟恢复ID !== 0) removeDelayedCallback(玩家英雄延迟恢复ID);
  玩家英雄延迟恢复ID = addDelayedCallback(1250, 恢复玩家英雄控制);
}

export function 执行沙漠食人魔裂隙来客入场(this: void): void {
  const riftUnit = 读取剧情运行时单位(裂隙运行时键);
  if (riftUnit == null || riftUnit === 0) return;
  创建点特效({ 模型路径: "war3mapImported\\blackhole.mdx", X: GetUnitX(riftUnit), Y: GetUnitY(riftUnit), 面向角度: 270, 缩放: 2, 动画速度: 1, 持续秒: 1.5 });
  const lizardTypeId = stringToFourCCSafe("h01I");
  if (lizardTypeId > 0) {
    const angle = Math.atan2(一阶段死亡Y - GetUnitY(riftUnit), 一阶段死亡X - GetUnitX(riftUnit)) * 180 / Math.PI;
    const lizardUnit = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), lizardTypeId, 27531.2, 13562.4, angle);
    if (lizardUnit != null && lizardUnit !== 0) {
      注册剧情运行时单位(蜥蜴人运行时键, lizardUnit);
      const radians = angle * Math.PI / 180;
      IssuePointOrder(lizardUnit, "move", GetUnitX(riftUnit) + Math.cos(radians) * 150, GetUnitY(riftUnit) + Math.sin(radians) * 150);
    }
  }
}

export function 执行沙漠食人魔裂隙来客对峙(this: void): void {
  const lizardUnit = 读取剧情运行时单位(蜥蜴人运行时键);
  if (lizardUnit == null || lizardUnit === 0) return;
  IssueImmediateOrder(lizardUnit, "holdposition");
  if (待开战目标单位 != null && 待开战目标单位 !== 0) {
    SetUnitFacing(lizardUnit, YDWEAngleBetweenUnitsSafe(lizardUnit, 待开战目标单位));
  }
}

function on沙漠食人魔二阶段显现脉冲(this: void): void {
  if (二阶段显现次数 >= 12) {
    创建点特效({ 模型路径: "war3mapImported\\blood2022720203813.mdl", X: 一阶段死亡X, Y: 一阶段死亡Y, 面向角度: 270, 缩放: 2.5, 动画速度: 1, 持续秒: 1.5 });
    if (二阶段显现周期ID !== 0) removePeriodicCallback(二阶段显现周期ID);
    二阶段显现周期ID = 0;
    return;
  }
  二阶段显现次数 += 1;
  创建点特效({ 模型路径: "war3mapImported\\desecrate.mdl", X: 一阶段死亡X, Y: 一阶段死亡Y, 面向角度: 270, 缩放: 2, 动画速度: 1, 持续秒: 1.5 });
}

export function 执行沙漠食人魔裂隙来客施法(this: void): void {
  const lizardUnit = 读取剧情运行时单位(蜥蜴人运行时键);
  const riftUnit = 读取剧情运行时单位(裂隙运行时键);
  if (lizardUnit != null && lizardUnit !== 0) {
    if (riftUnit != null && riftUnit !== 0) {
      SetUnitFacing(lizardUnit, YDWEAngleBetweenUnitsSafe(lizardUnit, riftUnit));
    }
    jass.SetUnitAnimationByIndex(lizardUnit, 11);
  }
  if (二阶段显现周期ID !== 0) removePeriodicCallback(二阶段显现周期ID);
  二阶段显现次数 = 0;
  二阶段显现周期ID = addPeriodicCallback(400, on沙漠食人魔二阶段显现脉冲);
}

function 完成沙漠食人魔二阶段显现脉冲(this: void): void {
  if (二阶段显现周期ID === 0) return;
  removePeriodicCallback(二阶段显现周期ID);
  二阶段显现周期ID = 0;
    创建点特效({ 模型路径: "war3mapImported\\blood2022720203813.mdl", X: 一阶段死亡X, Y: 一阶段死亡Y, 面向角度: 270, 缩放: 2.5, 动画速度: 1, 持续秒: 1.5 });
}

export function 执行杀戮食人魔显现(this: void, 参数: 剧情动作参数表): void {
  完成沙漠食人魔二阶段显现脉冲();

  const bossRawId = 按名字反查Boss单位ID(String(参数.二阶段Boss名 ?? "杀戮食人魔"));
  const bossTypeId = stringToFourCCSafe(bossRawId);
  if (!(bossTypeId > 0)) return;

  const bossUnit = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_AGGRESSIVE), bossTypeId, 一阶段死亡X, 一阶段死亡Y, 270);
  if (bossUnit == null || bossUnit === 0) return;
  YDUserDataSetSafe("string", "Boss", "杀戮食人魔", "unit", bossUnit);
  暂停并设置无敌安全(bossUnit, 沙漠食人魔二阶段待战暂停来源);
  jass.SetUnitAnimationByIndex(bossUnit, 11);
  创建点特效({ 模型路径: "war3mapImported\\desecrate.mdl", X: 一阶段死亡X, Y: 一阶段死亡Y, 面向角度: 270, 缩放: 4, 动画速度: 1, 持续秒: 1.5 });
  创建点特效({ 模型路径: "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", X: 一阶段死亡X, Y: 一阶段死亡Y, 面向角度: 270, 缩放: 2, 动画速度: 1, 持续秒: 1.5 });
  QuestMessageBJ(GetPlayersAll(), jglobals.bj_QUESTMESSAGE_WARNING, `？？：${GetUnitName(bossUnit)}`);
  const 显现音效 = jglobals.gg_snd_GWSY07;
  if (显现音效 != null && 显现音效 !== 0) PlaySoundBJ(显现音效);
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    const 临时组 = CreateGroup();
    GroupEnumUnitsInRange(临时组, 一阶段死亡X, 一阶段死亡Y, 99999, null);
    while (true) {
      const unit = FirstOfGroup(临时组);
      if (unit == null || unit === 0) break;
      GroupRemoveUnit(临时组, unit);
      if (IsUnitInGroup(unit, 玩家英雄组)) {
        释放单位暂停来源全部(unit, 沙漠食人魔一阶段死亡玩家暂停来源);
        StarOther_PanCameraToTimedUnitForPlayer(GetOwningPlayer(unit), bossUnit, 0.5);
      }
    }
    DestroyGroup(临时组);
  }
  待开战杀戮食人魔 = bossUnit;
}

export function 执行沙漠食人魔二阶段演出收束(this: void): void {
  const bossUnit = 待开战杀戮食人魔 ?? YDUserDataGetSafe("string", "Boss", "杀戮食人魔", "unit");
  恢复玩家英雄控制();
  const 蜥蜴人 = 读取剧情运行时单位(蜥蜴人运行时键);
  if (蜥蜴人 != null && 蜥蜴人 !== 0 && 待开战目标单位 != null && 待开战目标单位 !== 0) {
    SetUnitFacing(蜥蜴人, YDWEAngleBetweenUnitsSafe(蜥蜴人, 待开战目标单位));
  }
  if (蜥蜴人 != null && 蜥蜴人 !== 0) 立即移除单位并取消排泄登记(蜥蜴人);
  清理剧情运行时单位(蜥蜴人运行时键);

  const 裂隙 = 读取剧情运行时单位(裂隙运行时键);
  if (裂隙 != null && 裂隙 !== 0) {
    创建点特效({ 模型路径: "war3mapImported\\blackhole.mdx", X: GetUnitX(裂隙), Y: GetUnitY(裂隙), 面向角度: 270, 缩放: 2, 动画速度: 1, 持续秒: 1.5 });
    立即移除单位并取消排泄登记(裂隙);
  }
  清理剧情运行时单位(裂隙运行时键);

  if (bossUnit != null && bossUnit !== 0) {
    const 台词音效 = jglobals.gg_snd_GWSY04;
    if (台词音效 != null && 台词音效 !== 0) PlaySoundBJ(台词音效);
    创建点特效({ 模型路径: "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl", X: GetUnitX(bossUnit), Y: GetUnitY(bossUnit), 面向角度: 270, 缩放: 2, 动画速度: 1, 持续秒: 1.5 });
  }
}

export function 执行沙漠食人魔二阶段开战(this: void): void {
  const bossUnit = 待开战杀戮食人魔 ?? YDUserDataGetSafe("string", "Boss", "杀戮食人魔", "unit");
  if (bossUnit == null || bossUnit === 0) return;
  if (待开战目标单位 != null && 待开战目标单位 !== 0) {
    IssueTargetOrder(bossUnit, "attack", 待开战目标单位);
  }
  清理沙漠食人魔一阶段演出();
  启动剧情Boss战(bossUnit, {
    触发单位: 待开战目标单位,
    暂停来源: 沙漠食人魔二阶段待战暂停来源,
  });
  待开战杀戮食人魔 = null;
  待开战目标单位 = null;
}

export const 沙漠食人魔一阶段死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_沙漠食人魔一阶段死亡前置": 执行沙漠食人魔一阶段死亡前置,
  "SW01死亡事件_裂隙来客入场": 执行沙漠食人魔裂隙来客入场,
  "SW01死亡事件_裂隙来客对峙": 执行沙漠食人魔裂隙来客对峙,
  "SW01死亡事件_裂隙来客施法": 执行沙漠食人魔裂隙来客施法,
  "SW01死亡事件_杀戮食人魔显现": 执行杀戮食人魔显现,
  "SW01死亡事件_沙漠食人魔二阶段演出收束": 执行沙漠食人魔二阶段演出收束,
  "SW01死亡事件_沙漠食人魔二阶段开战": 执行沙漠食人魔二阶段开战,
};

注册剧情片段清理("jlc_desert_ogre_first_death", 清理沙漠食人魔一阶段演出);
