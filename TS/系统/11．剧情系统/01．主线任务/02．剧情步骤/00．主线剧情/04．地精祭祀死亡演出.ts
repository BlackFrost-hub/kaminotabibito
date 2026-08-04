/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { YDUserDataGetSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { ModifyGateBJ, ForGroupBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, gateOperation: number, d: any) => void;
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
};
const { SetUnitLifePercentBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitLifePercentBJ: (this: void, whichUnit: any, percent: number) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
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
const { 注册剧情片段清理 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表") as {
  注册剧情片段清理: (this: void, 片段ID: string, 清理函数: (this: void) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 注册剧情运行时单位, 读取剧情运行时单位, 清理剧情运行时单位 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位") as {
  注册剧情运行时单位: (this: void, 语义名: string, unit: any) => void;
  读取剧情运行时单位: (this: void, 语义名: string) => any;
  清理剧情运行时单位: (this: void, 语义名: string) => void;
};

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 尝试播放Boss死亡主线剧情 } from "../06．Boss死亡剧情索引";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (this: void, whichUnit: any, red: number, green: number, blue: number, alpha: number) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN as number;
const 地精死亡残血单位键 = "主线NPC.地精巫师残血";
const 地精死亡神秘人单位键 = "剧情运行时.地精死亡神秘人";
const 地精死亡击杀玩家单位键 = "剧情运行时.地精死亡.击杀玩家";

let 已初始化进度04核心 = false;
let 地精死亡演出传送X = 0;
let 地精死亡演出传送Y = 0;
let 血液特效周期ID = 0;
let 血液特效次数 = 0;
let 神秘人第二黑洞延迟ID = 0;
let 神秘人淡出启动延迟ID = 0;
let 神秘人淡出周期ID = 0;
let 神秘人淡出次数 = 0;
let 地精抹除特效延迟ID = 0;

function 清理地精死亡演出回调(this: void): void {
  if (血液特效周期ID !== 0) {
    removePeriodicCallback(血液特效周期ID);
    血液特效周期ID = 0;
  }
  if (神秘人第二黑洞延迟ID !== 0) {
    removeDelayedCallback(神秘人第二黑洞延迟ID);
    神秘人第二黑洞延迟ID = 0;
  }
  if (神秘人淡出启动延迟ID !== 0) {
    removeDelayedCallback(神秘人淡出启动延迟ID);
    神秘人淡出启动延迟ID = 0;
  }
  if (神秘人淡出周期ID !== 0) {
    removePeriodicCallback(神秘人淡出周期ID);
    神秘人淡出周期ID = 0;
  }
  if (地精抹除特效延迟ID !== 0) {
    removeDelayedCallback(地精抹除特效延迟ID);
    地精抹除特效延迟ID = 0;
  }
  血液特效次数 = 0;
  神秘人淡出次数 = 0;
}

function on地精死亡血液特效(this: void): void {
  const 残血地精 = 读取剧情运行时单位(地精死亡残血单位键);
  if (残血地精 == null || 残血地精 === 0) {
    if (血液特效周期ID !== 0) removePeriodicCallback(血液特效周期ID);
    血液特效周期ID = 0;
    return;
  }
  if (血液特效次数 >= 15) {
    removePeriodicCallback(血液特效周期ID);
    血液特效周期ID = 0;
    return;
  }
  血液特效次数 += 1;
  EC_CreateEffect(
    "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl",
    GetUnitX(残血地精),
    GetUnitY(残血地精),
    0,
    270,
    1.5,
    1,
    2,
  );
}

function 启动地精死亡血液特效(this: void): void {
  if (血液特效周期ID !== 0) removePeriodicCallback(血液特效周期ID);
  血液特效次数 = 0;
  血液特效周期ID = addPeriodicCallback(1500, on地精死亡血液特效);
}

function on神秘人第二黑洞(this: void): void {
  神秘人第二黑洞延迟ID = 0;
  const 神秘人 = 读取剧情运行时单位(地精死亡神秘人单位键);
  if (神秘人 == null || 神秘人 === 0) return;
  EC_CreateEffect("war3mapImported\\blackhole.mdx", GetUnitX(神秘人), GetUnitY(神秘人), 0, 270, 3, 1, 4);
}

function on神秘人淡出(this: void): void {
  const 神秘人 = 读取剧情运行时单位(地精死亡神秘人单位键);
  if (神秘人 == null || 神秘人 === 0) {
    if (神秘人淡出周期ID !== 0) removePeriodicCallback(神秘人淡出周期ID);
    神秘人淡出周期ID = 0;
    return;
  }
  if (神秘人淡出次数 >= 4) {
    removePeriodicCallback(神秘人淡出周期ID);
    神秘人淡出周期ID = 0;
    立即移除单位并取消排泄登记(神秘人);
    清理剧情运行时单位(地精死亡神秘人单位键);
    return;
  }
  神秘人淡出次数 += 1;
  SetUnitVertexColor(神秘人, 255, 255, 255, Math.max(0, 255 - 神秘人淡出次数 * 64));
}

function 启动神秘人淡出(this: void): void {
  神秘人淡出启动延迟ID = 0;
  if (神秘人淡出周期ID !== 0) removePeriodicCallback(神秘人淡出周期ID);
  神秘人淡出次数 = 0;
  神秘人淡出周期ID = addPeriodicCallback(1000, on神秘人淡出);
}

function 播放地精抹除特效(this: void): void {
  地精抹除特效延迟ID = 0;
  const 残血地精 = 读取剧情运行时单位(地精死亡残血单位键);
  if (残血地精 == null || 残血地精 === 0) return;
  EC_CreateEffect("war3mapImported\\Eraser.mdx", GetUnitX(残血地精), GetUnitY(残血地精), 0, 270, 2.2, 1, 2);
}

function on地精死亡演出移动英雄(this: void): void {
  const unit = jass.GetEnumUnit();
  if (unit == null || unit === 0) return;
  SetUnitPosition(unit, 地精死亡演出传送X, 地精死亡演出传送Y);
}

function 创建残血地精巫师(this: void): any {
  const bossRawId = 按名字反查Boss单位ID("地精祭祀|cffff0000（BossLV12）|r");
  const bossTypeId = stringToFourCCSafe(bossRawId);
  if (!(bossTypeId > 0)) return null;
  const 残血地精 = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), bossTypeId, -25996.8, -13787.8, 270);
  if (残血地精 == null || 残血地精 === 0) return null;
  SetUnitInvulnerable(残血地精, true);
  PauseUnit(残血地精, true);
  SetUnitLifePercentBJ(残血地精, 10);
  注册剧情运行时单位(地精死亡残血单位键, 残血地精);
  return 残血地精;
}

function 创建地精死亡神秘人演出(this: void, 残血地精: any): any {
  const 神秘人单位ID = stringToFourCCSafe("n05H");
  if (!(神秘人单位ID > 0)) return null;
  const 神秘人 = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), 神秘人单位ID, -26467.8, -13505.7, 315);
  if (神秘人 == null || 神秘人 === 0) return null;
  注册剧情运行时单位(地精死亡神秘人单位键, 神秘人);
  EC_CreateEffect("war3mapImported\\blackhole.mdx", GetUnitX(神秘人), GetUnitY(神秘人), 0, 270, 3, 1, 4);
  IssuePointOrder(神秘人, "move", -26296.4, -13702.4);
  if (残血地精 != null && 残血地精 !== 0) {
    SetUnitFacing(神秘人, YDWEAngleBetweenUnitsSafe(神秘人, 残血地精));
  }
  SetUnitFacing(神秘人, 270);
  神秘人第二黑洞延迟ID = addDelayedCallback(8000, on神秘人第二黑洞);
  神秘人淡出启动延迟ID = addDelayedCallback(12000, 启动神秘人淡出);
  地精抹除特效延迟ID = addDelayedCallback(20000, 播放地精抹除特效);
  return 神秘人;
}

function 清理地精祭祀死亡演出(this: void): void {
  清理地精死亡演出回调();
  const 残血地精 = 读取剧情运行时单位(地精死亡残血单位键);
  if (残血地精 != null && 残血地精 !== 0) 立即移除单位并取消排泄登记(残血地精);
  清理剧情运行时单位(地精死亡残血单位键);
  const 神秘人 = 读取剧情运行时单位(地精死亡神秘人单位键);
  if (神秘人 != null && 神秘人 !== 0) 立即移除单位并取消排泄登记(神秘人);
  清理剧情运行时单位(地精死亡神秘人单位键);
  清理剧情运行时单位(地精死亡击杀玩家单位键);
}

export function 执行地精祭祀死亡演出前置(this: void): void {
  const gate = jglobals.gg_dest_DTg5_9811;
  if (gate != null && gate !== 0) {
    ModifyGateBJ(bj_GATEOPERATION_OPEN, gate);
  }

  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    地精死亡演出传送X = -26078.9;
    地精死亡演出传送Y = -14330.5;
    ForGroupBJ(玩家英雄组, on地精死亡演出移动英雄);
  }

  const 残血地精 = 创建残血地精巫师();
  启动地精死亡血液特效();
  const bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit");
  const 已缓存击杀者 = 消费保留剧情Boss死亡击杀者(bossUnit);
  const 击杀玩家 = 读取剧情运行时单位(地精死亡击杀玩家单位键) ?? 已缓存击杀者;
  按结算键执行Boss死亡结算("主线_地精祭祀", bossUnit, 击杀玩家);
  创建地精死亡神秘人演出(残血地精);
}

export const 地精祭祀死亡演出剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_地精祭祀死亡演出前置": 执行地精祭祀死亡演出前置,
};

注册剧情片段清理("jlc_goblin_boss_death", 清理地精祭祀死亡演出);

function on地精祭祀死亡(this: void, dyingUnit: any, killingUnit: any): void {
  if (读取剧情进度() !== 3) return;
  const bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit");
  if (bossUnit == null || bossUnit === 0) return;
  if (dyingUnit !== bossUnit) return;
  if (killingUnit != null && killingUnit !== 0) {
    注册剧情运行时单位(地精死亡击杀玩家单位键, killingUnit);
  }
  清理剧情运行时单位("Boss.地精巫师");
  const 已启动剧情 = 尝试播放Boss死亡主线剧情(dyingUnit);
  if (!已启动剧情) 清理剧情运行时单位(地精死亡击杀玩家单位键);
}

export function 初始化进度04_地精祭祀死亡演出核心(this: void): void {
  if (已初始化进度04核心) return;
  已初始化进度04核心 = true;
  registerDeathListener(on地精祭祀死亡);
}
