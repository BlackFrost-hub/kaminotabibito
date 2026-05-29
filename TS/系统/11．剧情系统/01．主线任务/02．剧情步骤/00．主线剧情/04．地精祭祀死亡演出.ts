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
const { 按结算键获取Boss死亡结算配置, 执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.05．Boss死亡结算.03．核心逻辑") as {
  按结算键获取Boss死亡结算配置: (this: void, 结算键: string) => any;
  执行Boss死亡结算: (this: void, 配置: any, Boss单位?: any, 击杀者?: any) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 尝试播放Boss死亡主线剧情 } from "../06．Boss死亡剧情索引";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN as number;

let 已初始化进度04核心 = false;
let 地精死亡演出传送X = 0;
let 地精死亡演出传送Y = 0;

function on地精死亡演出移动英雄(this: void): void {
  const unit = jass.GetEnumUnit();
  if (unit == null || unit === 0) return;
  SetUnitPosition(unit, 地精死亡演出传送X, 地精死亡演出传送Y);
}

function 创建残血地精巫师(this: void): any {
  const bossRawId = 按名字反查Boss单位ID("地精祭祀|cffff0000（BossLV12）|r");
  const bossTypeId = stringToFourCCSafe(bossRawId);
  if (!(bossTypeId > 0)) return null;
  const 残血地精 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), bossTypeId, -25996.8, -13787.8, 270);
  if (残血地精 == null || 残血地精 === 0) return null;
  SetUnitInvulnerable(残血地精, true);
  SetUnitLifePercentBJ(残血地精, 10);
  return 残血地精;
}

function 创建地精死亡神秘人演出(this: void, 残血地精: any): void {
  const 神秘人单位ID = stringToFourCCSafe("n05H");
  if (!(神秘人单位ID > 0)) return;
  const 神秘人 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 神秘人单位ID, -26467.8, -13505.7, 315);
  if (神秘人 == null || 神秘人 === 0) return;
  EC_CreateEffect("war3mapImported\\blackhole.mdx", GetUnitX(神秘人), GetUnitY(神秘人), 0, 270, 3, 1, 4);
  IssuePointOrder(神秘人, "move", -26296.4, -13702.4);
  if (残血地精 != null && 残血地精 !== 0) {
    SetUnitFacing(神秘人, YDWEAngleBetweenUnitsSafe(神秘人, 残血地精));
    EC_CreateEffect("war3mapImported\\Eraser.mdx", GetUnitX(残血地精), GetUnitY(残血地精), 0, 270, 2.2, 1, 2);
  }
  EC_CreateEffect("war3mapImported\\blackhole.mdx", GetUnitX(神秘人), GetUnitY(神秘人), 0, 270, 3, 1, 4);
  SetUnitFacing(神秘人, 270);
}

export function 执行地精祭祀死亡演出前置(this: void, 参数: 剧情动作参数表): void {
  写入剧情进度(Number(参数.设置剧情进度) || 4);
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
  const bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit");
  const 结算配置 = 按结算键获取Boss死亡结算配置("主线_地精祭祀");
  if (结算配置 != null) {
    执行Boss死亡结算(结算配置, bossUnit);
  }
  创建地精死亡神秘人演出(残血地精);
}

export const 地精祭祀死亡演出剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_地精祭祀死亡演出前置": 执行地精祭祀死亡演出前置,
};

function on地精祭祀死亡(this: void, dyingUnit: any): void {
  if (读取剧情进度() !== 3) return;
  const bossUnit = YDUserDataGetSafe("string", "Boss", "地精巫师", "unit");
  if (bossUnit == null || bossUnit === 0) return;
  if (dyingUnit !== bossUnit) return;
  尝试播放Boss死亡主线剧情(dyingUnit);
}

export function 初始化进度04_地精祭祀死亡演出核心(this: void): void {
  if (已初始化进度04核心) return;
  已初始化进度04核心 = true;
  registerDeathListener(on地精祭祀死亡);
}
