/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
};
const 沙漠食人魔待战暂停来源 = "剧情系统:沙漠食人魔待战";

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { StarOther_PanCameraToTimedUnitForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedUnitForPlayer: (this: void, whichPlayer: any, unit: any, duration: number) => void;
};
import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";
export { 沙漠食人魔Boss启动剧情片段 } from "../01．第一章/10．沙漠食人魔Boss启动";

const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

function 播放沙漠食人魔开战特效(this: void, bossUnit: any): void {
  const x = GetUnitX(bossUnit);
  const y = GetUnitY(bossUnit);
  EC_CreateEffect("Abilities\\Spells\\NightElf\\BattleRoar\\RoarCaster.mdl", x, y, 0, 270, 2.5, 1, 1);
  for (let i = 1; i <= 6; i++) {
    const angle = (60 * i) * Math.PI / 180;
    EC_CreateEffect(
      "war3mapImported\\blood2022720203813.mdl",
      x + Math.cos(angle) * 150,
      y + Math.sin(angle) * 150,
      0,
      270,
      2,
      1,
      1,
    );
  }
}

export function 执行沙漠食人魔Boss前置(this: void): void {
  const bossUnit = YDUserDataGetSafe("string", "Boss", "沙漠食人魔", "unit");
  if (bossUnit == null || bossUnit === 0 || !IsUnitAliveBJ(bossUnit)) return;
  if (GetOwningPlayer(bossUnit) !== Player(PLAYER_NEUTRAL_PASSIVE)) return;

  const 血条Boss组 = YDUserDataGetSafe("string", "血条Boss", "单位组", "group");
  if (血条Boss组 != null && 血条Boss组 !== 0) {
    GroupAddUnit(血条Boss组, bossUnit);
  }

  SetUnitOwner(bossUnit, Player(PLAYER_NEUTRAL_AGGRESSIVE), true);
  添加单位暂停(bossUnit, 沙漠食人魔待战暂停来源);
  SetUnitInvulnerable(bossUnit, true);

  const 上下文 = 读取当前剧情动作上下文();
  if (上下文.触发单位 != null && 上下文.触发单位 !== 0) {
    StarOther_PanCameraToTimedUnitForPlayer(GetOwningPlayer(上下文.触发单位), bossUnit, 0.75);
    SetUnitFacing(bossUnit, YDWEAngleBetweenUnitsSafe(bossUnit, 上下文.触发单位));
  }
}

export function 执行沙漠食人魔Boss开战(this: void, 参数: 剧情动作参数表): void {
  const bossUnit = YDUserDataGetSafe("string", "Boss", "沙漠食人魔", "unit");
  if (bossUnit == null || bossUnit === 0 || !IsUnitAliveBJ(bossUnit)) return;
  const 音效变量名 = String(参数.播放音效 ?? "");
  播放沙漠食人魔开战特效(bossUnit);
  if (音效变量名 !== "") {
    const soundHandle = jglobals[音效变量名];
    if (soundHandle != null && soundHandle !== 0) {
      PlaySoundBJ(soundHandle);
    }
  }

  启动剧情Boss战(bossUnit, {
    触发单位: 读取当前剧情动作上下文().触发单位,
    暂停来源: 沙漠食人魔待战暂停来源,
  });
}

export const 沙漠食人魔Boss启动剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_沙漠食人魔Boss前置": 执行沙漠食人魔Boss前置,
  "SRZ蛇人族_沙漠食人魔Boss开战": 执行沙漠食人魔Boss开战,
};
