/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
};
const 沙漠食人魔待战暂停来源 = "剧情系统:沙漠食人魔待战";

const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { TriggerRegisterUnitInRangeSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterUnitInRangeSimple: (this: void, trig: any, range: number, whichUnit: any) => any;
};
const { GS_PolarProjectionBJ } = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影") as {
  GS_PolarProjectionBJ: (this: void, source: any, dist: number, angle: number) => any;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 注册剧情Boss范围预置触发器 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
export { 蛇人族接受食人魔任务剧情片段 } from "../01．第一章/09．狩猎食人魔任务接取";

const CreatePermanentCorpseLocBJ = jass.CreatePermanentCorpseLocBJ as (this: void, style: number, unitid: number, whichPlayer: any, loc: any, facing: number) => void;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetUnitLoc = jass.GetUnitLoc as (this: void, whichUnit: any) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveLocation = jass.RemoveLocation as (this: void, whichLocation: any) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const bj_CORPSETYPE_BONE = (require("jass.globals") as any).bj_CORPSETYPE_BONE as number;

function 创建沙漠食人魔尸骨圈(this: void, bossUnit: any): void {
  if (bossUnit == null || bossUnit === 0) return;
  const 步兵单位ID = stringToFourCCSafe("hfoo");
  if (!(步兵单位ID > 0)) return;

  for (let i = 1; i <= 6; i++) {
    const sourceLoc = GetUnitLoc(bossUnit);
    const corpseLoc = GS_PolarProjectionBJ(sourceLoc, 150, 60 * i);
    if (corpseLoc != null && corpseLoc !== 0) {
      CreatePermanentCorpseLocBJ(bj_CORPSETYPE_BONE, 步兵单位ID, Player(PLAYER_NEUTRAL_PASSIVE), corpseLoc, GetRandomDirectionDeg());
      RemoveLocation(corpseLoc);
    }
  }
}

export function 执行蛇人族接受食人魔任务(this: void, 参数: 剧情动作参数表): void {
  const 次元裂缝单位ID = stringToFourCCSafe("e08L");
  if (次元裂缝单位ID > 0) {
    const 裂缝单位 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 次元裂缝单位ID, -20606.8, 2780.5, 0);
    if (裂缝单位 != null && 裂缝单位 !== 0) {
      YDUserDataSetSafe("string", "剧情", "沙漠次元裂缝", "unit", 裂缝单位);
    }
  }

  const bossRawId = 按名字反查Boss单位ID("沙漠食人魔");
  const bossTypeId = stringToFourCCSafe(bossRawId);
  if (!(bossTypeId > 0)) return;
  const bossUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), bossTypeId, 28354.9, 13678.3, 270);
  if (bossUnit == null || bossUnit === 0) return;

  YDUserDataSetSafe("string", "Boss", "沙漠食人魔", "unit", bossUnit);
  SetUnitInvulnerable(bossUnit, true);
  添加单位暂停(bossUnit, 沙漠食人魔待战暂停来源);
  注册剧情Boss范围预置触发器(
    bossUnit,
    Number(参数.注册范围) || 850,
    "沙漠食人魔Boss启动",
    "jlc_desert_ogre_boss_start",
    "Boss.沙漠食人魔",
    10,
  );
  创建沙漠食人魔尸骨圈(bossUnit);
}

export const 狩猎食人魔任务接取剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_接受食人魔任务": 执行蛇人族接受食人魔任务,
};
