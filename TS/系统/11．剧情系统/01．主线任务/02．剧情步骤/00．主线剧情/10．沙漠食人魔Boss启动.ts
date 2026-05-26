/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { PlaySoundBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundBJ: (this: void, soundHandle: any) => void;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, bossUnit: any) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 沙漠食人魔Boss启动剧情片段 } from "../01．第一章/10．沙漠食人魔Boss启动";

const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

export function 执行沙漠食人魔Boss启动(this: void, 参数: 剧情动作参数表): void {
  const bossUnit = YDUserDataGetSafe("string", "Boss", "沙漠食人魔", "unit");
  if (bossUnit == null || bossUnit === 0 || !IsUnitAliveBJ(bossUnit)) return;
  if (GetOwningPlayer(bossUnit) !== Player(PLAYER_NEUTRAL_PASSIVE)) return;

  const 血条Boss组 = YDUserDataGetSafe("string", "血条Boss", "单位组", "group");
  if (血条Boss组 != null && 血条Boss组 !== 0) {
    GroupAddUnit(血条Boss组, bossUnit);
  }

  SetUnitOwner(bossUnit, Player(PLAYER_NEUTRAL_AGGRESSIVE), true);
  PauseUnit(bossUnit, false);
  SetUnitInvulnerable(bossUnit, false);

  const 上下文 = 读取当前剧情动作上下文();
  YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", bossUnit);
  if (上下文.触发单位 != null && 上下文.触发单位 !== 0) {
    YDUserDataSetSafe("string", "Boss战", "触发玩家", "unit", 上下文.触发单位);
  }

  const 音效变量名 = String(参数.播放音效 ?? "");
  if (音效变量名 !== "") {
    const soundHandle = jglobals[音效变量名];
    if (soundHandle != null && soundHandle !== 0) {
      PlaySoundBJ(soundHandle);
    }
  }

  启动Boss战运行(bossUnit);
}

export const 沙漠食人魔Boss启动剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_沙漠食人魔Boss启动": 执行沙漠食人魔Boss启动,
};
