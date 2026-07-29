/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
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
import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";
export { 沙漠食人魔一阶段死亡剧情片段 } from "../01．第一章/11．沙漠食人魔一阶段死亡";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, whichUnit: any, order: string, targetWidget: any) => boolean;
const UnitSuspendDecay = jass.UnitSuspendDecay as (this: void, whichUnit: any, flag: boolean) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

let 待开战杀戮食人魔: any = null;
let 待开战目标单位: any = null;
let 待处理一阶段死亡单位: any = null;

export function 执行沙漠食人魔一阶段死亡前置(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  待处理一阶段死亡单位 = dyingUnit;
  UnitSuspendDecay(dyingUnit, true);
  按结算键执行Boss死亡结算("沙漠食人魔", dyingUnit);

  const x = GetUnitX(dyingUnit);
  const y = GetUnitY(dyingUnit);
  const riftTypeId = stringToFourCCSafe("e08M");
  let riftUnit: any = null;
  if (riftTypeId > 0) {
    riftUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), riftTypeId, 27531.2, 13562.4, 0);
  }

  const lizardTypeId = stringToFourCCSafe("h01I");
  if (lizardTypeId > 0 && riftUnit != null && riftUnit !== 0) {
    const angle = YDWEAngleBetweenUnitsSafe(riftUnit, dyingUnit);
    const lizardUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), lizardTypeId, 27531.2, 13562.4, angle);
    if (lizardUnit != null && lizardUnit !== 0) {
      IssuePointOrder(lizardUnit, "move", GetUnitX(riftUnit) + 150, GetUnitY(riftUnit));
      IssueImmediateOrder(lizardUnit, "holdposition");
    }
  }

  const bossRawId = 按名字反查Boss单位ID(String(参数.二阶段Boss名 ?? "杀戮食人魔"));
  const bossTypeId = stringToFourCCSafe(bossRawId);
  if (!(bossTypeId > 0)) return;

  const bossUnit = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), bossTypeId, x, y, 270);
  if (bossUnit == null || bossUnit === 0) return;
  YDUserDataSetSafe("string", "Boss", "杀戮食人魔", "unit", bossUnit);
  添加单位暂停(bossUnit, 沙漠食人魔二阶段待战暂停来源);
  SetUnitInvulnerable(bossUnit, true);
  待开战杀戮食人魔 = bossUnit;
  待开战目标单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
}

export function 执行沙漠食人魔二阶段开战(this: void): void {
  const bossUnit = 待开战杀戮食人魔 ?? YDUserDataGetSafe("string", "Boss", "杀戮食人魔", "unit");
  if (bossUnit == null || bossUnit === 0) return;
  if (待开战目标单位 != null && 待开战目标单位 !== 0) {
    IssueTargetOrder(bossUnit, "attack", 待开战目标单位);
  }
  启动剧情Boss战(bossUnit, {
    触发单位: 待开战目标单位,
    暂停来源: 沙漠食人魔二阶段待战暂停来源,
  });
  待处理一阶段死亡单位 = null;
  待开战杀戮食人魔 = null;
  待开战目标单位 = null;
}

export const 沙漠食人魔一阶段死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_沙漠食人魔一阶段死亡前置": 执行沙漠食人魔一阶段死亡前置,
  "SW01死亡事件_沙漠食人魔二阶段开战": 执行沙漠食人魔二阶段开战,
};
