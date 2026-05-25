/** @noSelfInFile */

const jass = require("jass.common") as any;

const { SetUnitFacingToFaceUnitTimed } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitFacingToFaceUnitTimed: (this: void, whichUnit: any, target: any, duration: number) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe, YDUserDataClearSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09－YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { YDUserDataClearTable } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
};
const { DzDoodadCreate } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadCreate: (id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { GS_PolarProjectionBJ } = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影") as {
  GS_PolarProjectionBJ: (this: void, source: any, dist: number, angle: number) => any;
};
const { GetRandomDirectionDeg, ForGroupBJ, ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
  ModifyGateBJ: (this: void, gateOperation: number, d: any) => void;
};
const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};
const { SetUnitLifePercentBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitLifePercentBJ: (this: void, whichUnit: any, percent: number) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "./00．剧情动作类型";
import { 读取当前剧情动作上下文, 写入剧情进度 } from "./01．剧情动作上下文";
import {
  发送剧情任务消息,
  发送剧情小地图信号,
  在触发单位脚下创建剧情物品,
} from "./02．剧情动作桥接";
import { 创建并冻结剧情Boss预置, 注册剧情Boss范围预置触发器 } from "./03．剧情Boss预置桥接";
import { 执行通用剧情动作, 触发单位增加基础全属性 } from "./06．剧情通用执行工具";
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.04．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, bossUnit: any) => void;
};

const CreateFogModifierRect = jass.CreateFogModifierRect as (this: void, whichPlayer: any, whichState: any, where: any, useSharedVision: boolean, afterUnits: boolean) => any;
const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const CreateTimer = jass.CreateTimer as (this: void) => any;
const CreatePermanentCorpseLocBJ = jass.CreatePermanentCorpseLocBJ as (this: void, style: number, unitid: number, whichPlayer: any, loc: any, facing: number) => void;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const DestroyTimer = jass.DestroyTimer as (this: void, whichTimer: any) => void;
const FogModifierStart = jass.FogModifierStart as (this: void, whichFog: any) => void;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const Condition = jass.Condition as (this: void, func: () => boolean) => any;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const GetPlayersAll = jass.GetPlayersAll as (this: void) => any;
const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetKillingUnitBJ = jass.GetKillingUnitBJ as (this: void) => any;
const GetUnitFacing = jass.GetUnitFacing as (this: void, whichUnit: any) => number;
const GetFilterUnit = jass.GetFilterUnit as (this: void) => any;
const GetUnitLoc = jass.GetUnitLoc as (this: void, whichUnit: any) => any;
const GetUnitsInRectMatching = jass.GetUnitsInRectMatching as (this: void, whichRect: any, filter: any) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const QuestMessageBJ = jass.QuestMessageBJ as (this: void, whichForce: any, messageType: number, message: string) => void;
const QuestSetDiscovered = jass.QuestSetDiscovered as (this: void, whichQuest: any, flag: boolean) => void;
const RemoveLocation = jass.RemoveLocation as (this: void, whichLocation: any) => void;
const RemoveRect = jass.RemoveRect as (this: void, whichRect: any) => void;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;
const CinematicModeBJ = jass.CinematicModeBJ as (this: void, flag: boolean, whichForce: any) => void;
const CinematicFilterGenericBJ = jass.CinematicFilterGenericBJ as (
  this: void,
  duration: number,
  blendMode: number,
  tex: string,
  red: number,
  green: number,
  blue: number,
  alpha: number,
  x1: number,
  y1: number,
  x2: number,
  y2: number,
) => void;
const ShowDestructable = jass.ShowDestructable as (this: void, whichDestructable: any, flag: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitFacingTimed = jass.SetUnitFacingTimed as (this: void, whichUnit: any, facing: number, duration: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetTimeOfDay = jass.SetTimeOfDay as (this: void, time: number) => void;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const UnitSuspendDecay = jass.UnitSuspendDecay as (this: void, whichUnit: any, flag: boolean) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const TimerStart = jass.TimerStart as (this: void, timer: any, timeout: number, periodic: boolean, callback: () => void) => void;

const FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE as number;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const bj_GATEOPERATION_OPEN = (require("jass.globals") as any).bj_GATEOPERATION_OPEN as number;
const bj_CORPSETYPE_BONE = (require("jass.globals") as any).bj_CORPSETYPE_BONE as number;
const bj_QUESTMESSAGE_ITEMACQUIRED = (require("jass.globals") as any).bj_QUESTMESSAGE_ITEMACQUIRED as number;
const bj_QUESTMESSAGE_UPDATED = (require("jass.globals") as any).bj_QUESTMESSAGE_UPDATED as number;

let 地精死亡演出传送X = 0;
let 地精死亡演出传送Y = 0;

function 读取长老单位(this: void): any {
  return YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
}

function on地精死亡演出移动英雄(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  SetUnitPosition(unit, 地精死亡演出传送X, 地精死亡演出传送Y);
}

function 是自然守护者(this: void): boolean {
  const unit = GetFilterUnit();
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === stringToFourCCSafe("etrp");
}

function 分割名称列表(this: void, value: string | undefined): string[] {
  if (value == null || value === "") return [];
  return value.split(",").map((item) => item.trim()).filter((item) => item.length > 0);
}

function 对所有玩家添加区域视野(this: void, rectVarName: string): void {
  const rectHandle = (require("jass.globals") as any)[rectVarName];
  if (rectHandle == null || rectHandle === 0) return;
  for (let playerId = 0; playerId < 8; playerId++) {
    const fogModifier = CreateFogModifierRect(Player(playerId), FOG_OF_WAR_VISIBLE, rectHandle, true, false);
    if (fogModifier == null || fogModifier === 0) continue;
    FogModifierStart(fogModifier);
  }
}

function 执行长老任务物品生成(this: void, 参数: 剧情动作参数表): void {
  const 长老单位 = 读取长老单位();
  if (长老单位 == null || 长老单位 === 0) return;

  const 物品名列表 = 分割名称列表(String(参数.物品名列表 ?? ""));
  const x = GetUnitX(长老单位);
  const y = GetUnitY(长老单位);
  for (let i = 0; i < 物品名列表.length; i++) {
    const rawId = 按名字反查物品ID(物品名列表[i]);
    const itemTypeId = stringToFourCCSafe(rawId);
    if (!(itemTypeId > 0)) continue;
    CreateItem(itemTypeId, x, y);
  }
}

function 执行长老任务更新(this: void, 参数: 剧情动作参数表): void {
  发送剧情小地图信号({
    X: Number(参数.小地图X) || 0,
    Y: Number(参数.小地图Y) || 0,
    持续时间: Number(参数.小地图持续时间) || 0,
  });
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_UPDATED,
    文本: String(参数.任务更新提示 ?? ""),
  });
}

function 执行地精区域显视野(this: void, 参数: 剧情动作参数表): void {
  对所有玩家添加区域视野(String(参数.可见区域1 ?? ""));
  对所有玩家添加区域视野(String(参数.可见区域2 ?? ""));
}

function 执行地精祭祀Boss预备(this: void, 参数: 剧情动作参数表): void {
  创建并冻结剧情Boss预置({
    Boss键: String(参数.Boss键 ?? ""),
    Boss名: String(参数.Boss名 ?? ""),
    X: Number(参数.X) || 0,
    Y: Number(参数.Y) || 0,
    朝向: Number(参数.朝向) || 0,
    注册范围: Number(参数.注册范围) || 0,
    预创建后暂停: 参数.预创建后暂停 === true,
    预创建后无敌: 参数.预创建后无敌 === true,
    范围触发配置名: String(参数.范围触发配置名 ?? "地精祭祀范围预置触发"),
    范围触发剧情片段ID: typeof 参数.范围触发剧情片段ID === "string" ? 参数.范围触发剧情片段ID : undefined,
  });
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

function 执行地精祭祀死亡演出前置(this: void, 参数: 剧情动作参数表): void {
  写入剧情进度(Number(参数.设置剧情进度) || 4);
  const gate = (require("jass.globals") as any).gg_dest_DTg5_9811;
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
  YDUserDataClearSafe("string", "Boss", "地精巫师", "unit");
  if (bossUnit != null && bossUnit !== 0) {
    YDUserDataClearTable("unit", bossUnit);
  }

  创建地精死亡神秘人演出(残血地精);
}

function 执行教派Boss随机姿态(this: void, 参数: 剧情动作参数表): void {
  const roll = GetRandomInt(1, 2);
  const boss名 = roll === 1 ? String(参数.剑士姿态Boss名 ?? "教派剑士") : String(参数.学者姿态Boss名 ?? "教派学者");
  创建并冻结剧情Boss预置({
    Boss键: String(参数.Boss键 ?? "Boss.蒙面人"),
    Boss名: boss名,
    X: Number(参数.出生X) || 0,
    Y: Number(参数.出生Y) || 0,
    朝向: Number(参数.朝向) || 0,
    预创建后暂停: true,
    预创建后无敌: true,
  });
}

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

function 执行蛇人族接受食人魔任务(this: void, 参数: 剧情动作参数表): void {
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
  PauseUnit(bossUnit, true);
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

function 执行长老对话前置(this: void, 参数: 剧情动作参数表): void {
  const 上下文 = 读取当前剧情动作上下文();
  const 触发单位 = 上下文.触发单位;
  const 长老单位 = 读取长老单位();

  if (typeof 参数.设置剧情进度 === "number") {
    写入剧情进度(参数.设置剧情进度);
  }

  if (触发单位 != null && 触发单位 !== 0 && 参数.触发单位发布命令 != null) {
    IssueImmediateOrder(触发单位, String(参数.触发单位发布命令));
  }
  if (触发单位 != null && 触发单位 !== 0 && 长老单位 != null && 长老单位 !== 0) {
    SetUnitFacingToFaceUnitTimed(触发单位, 长老单位, Number(参数.触发单位转向耗时) || 0);
  }

  if (长老单位 != null && 长老单位 !== 0) {
    if (typeof 参数.长老归属玩家 === "number") {
      SetUnitOwner(长老单位, Player(参数.长老归属玩家), true);
    }
    if (触发单位 != null && 触发单位 !== 0) {
      const angle = YDWEAngleBetweenUnitsSafe(长老单位, 触发单位);
      SetUnitFacingTimed(长老单位, angle, Number(参数.长老转向耗时) || 0);
    }
  }
}

function 执行远古波动奖励(this: void, 参数: 剧情动作参数表): void {
  const 奖励值 = Number(参数.力量) || Number(参数.全属性) || 3;
  触发单位增加基础全属性(奖励值, String(参数.任务消息模板 ?? "{英雄名}受到了远古波动！（|cffff99cc全属性+{value}|r）"));
}

function 移除并清理语义单位引用(this: void, 引用: string): void {
  if (引用 === "") return;
  const unit = YDUserDataGetSafe("string", 引用.includes(".") ? 引用.split(".")[0] : "剧情", 引用.includes(".") ? 引用.split(".")[1] ?? "" : 引用, "unit");
  if (unit != null && unit !== 0) {
    RemoveUnit(unit);
  }
  const dot = 引用.indexOf(".");
  if (dot >= 0) {
    YDUserDataClearTable("string", 引用.substring(0, dot));
  }
}

function 清理逗号分隔语义单位(this: void, refs: string): void {
  if (refs === "") return;
  const 列表 = refs.split(",").map((item) => item.trim()).filter((item) => item.length > 0);
  for (let i = 0; i < 列表.length; i++) {
    移除并清理语义单位引用(列表[i]);
  }
}

function 执行沙漠情报商人回收夜光翡翠(this: void, 参数: 剧情动作参数表): void {
  const oldGuardRefs = String(参数.移除临时单位 ?? "");
  清理逗号分隔语义单位(oldGuardRefs);

  const riftRawId = stringToFourCCSafe("e06W");
  if (riftRawId > 0) {
    const riftA = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), riftRawId, -27182.1, -25485.2, 0);
    const riftB = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), riftRawId, -24123.4, -26338.8, 0);
    if (riftA != null && riftA !== 0) YDUserDataSetSafe("string", "ZXCS", "DW", "unit", riftA);
    if (riftB != null && riftB !== 0) YDUserDataSetSafe("string", "ZXCS2", "DW", "unit", riftB);
  }
}

function 执行蛇人族交还食人魔凭证(this: void, 参数: 剧情动作参数表): void {
  const rawId = stringToFourCCSafe("h01D");
  if (!(rawId > 0)) return;
  const 队长 = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), rawId, -22935.9, 3154.3, 0);
  if (队长 == null || 队长 === 0) return;
  YDUserDataSetSafe("string", "主线NPC", "蛇人族卫队长", "unit", 队长);
  IssuePointOrder(队长, "move", -21023.4, 3259.5);
}

function 执行克林姆德王接见(this: void, 参数: 剧情动作参数表): void {
  const rawId = stringToFourCCSafe("ohun");
  if (!(rawId > 0)) return;
  const 猎魂 = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), rawId, -2823.1, -14119.8, 180);
  if (猎魂 == null || 猎魂 === 0) return;
  YDUserDataSetSafe("string", "jq", "npc", "unit", 猎魂);
}

function 执行精灵村教派袭击预置(this: void, 参数: 剧情动作参数表): void {
  const 神秘人ID = stringToFourCCSafe("n05H");
  const 精灵护卫ID = stringToFourCCSafe("nhef");
  const 精灵守卫ID = stringToFourCCSafe("n01H");
  if (!(神秘人ID > 0) || !(精灵护卫ID > 0) || !(精灵守卫ID > 0)) return;

  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 神秘人ID, -26755.1, -28618.6, 0);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵护卫ID, -25907.1, -28413.0, 178);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵护卫ID, -25888.1, -28937.1, 185.47);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵守卫ID, -26119.9, -28926.5, 123.7);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵守卫ID, -25965.7, -29021.4, 180);
  CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 精灵守卫ID, -26065.8, -28460.5, 180);

  const 树木坐标: Array<[number, number]> = [
    [-27676.5, -26406.0], [-27008.7, -26384.5], [-26437.1, -27038.1], [-27524.2, -27604.2], [-27404.8, -28326.7],
    [-26557.1, -28108.3], [-24975.3, -28808.4], [-25385.3, -27834.4], [-23911.9, -29142.2], [-22237.8, -28776.7],
    [-22255.9, -28312.7], [-24574.1, -27746.7], [-23911.9, -29142.2], [-23963.1, -27718.0], [-23632.0, -27698.7],
    [-25487.6, -26993.6], [-24839.6, -26980.8], [-23963.1, -27718.0], [-24464.3, -26590.1], [-23681.3, -26604.5],
    [-23665.1, -27128.5],
  ];
  for (let i = 0; i < 树木坐标.length; i++) {
    const point = 树木坐标[i];
    DzDoodadCreate(stringToFourCCSafe("YOtf"), 1, point[0], point[1], 0, GetRandomDirectionDeg(), 1);
  }
}

function 执行沙漠食人魔一阶段死亡(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  UnitSuspendDecay(dyingUnit, true);

  const x = GetUnitX(dyingUnit);
  const y = GetUnitY(dyingUnit);
  const riftRawId = stringToFourCCSafe("e08M");
  let riftUnit: any = null;
  if (riftRawId > 0) {
    riftUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), riftRawId, 27531.2, 13562.4, 0);
  }

  const lizardRawId = stringToFourCCSafe("h01I");
  if (lizardRawId > 0 && riftUnit != null && riftUnit !== 0) {
    const angle = YDWEAngleBetweenUnitsSafe(riftUnit, dyingUnit);
    const lizard = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), lizardRawId, 27531.2, 13562.4, angle);
    if (lizard != null && lizard !== 0) {
      IssuePointOrder(lizard, "move", GetUnitX(riftUnit) + 150, GetUnitY(riftUnit));
      IssueImmediateOrder(lizard, "holdposition");
    }
  }

  const bossRawId = 按名字反查Boss单位ID("杀戮食人魔");
  const bossTypeId = stringToFourCCSafe(bossRawId);
  if (!(bossTypeId > 0)) return;
  const bossUnit = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), bossTypeId, x, y, 270);
  if (bossUnit == null || bossUnit === 0) return;
  YDUserDataSetSafe("string", "Boss", "杀戮食人魔", "unit", bossUnit);
  YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", bossUnit);
  PauseUnit(bossUnit, true);
  SetUnitInvulnerable(bossUnit, true);
  启动Boss战运行(bossUnit);
}

function 执行蒙面人死亡(this: void, 参数: 剧情动作参数表): void {
  delete 参数.奖励物品名;
  delete 参数.停止区域音乐;
  delete 参数.恢复环境音乐;
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  const dyingTypeId = GetUnitTypeId(dyingUnit);
  if (dyingTypeId !== stringToFourCCSafe("N05N") && dyingTypeId !== stringToFourCCSafe("N05M")) return;

  const 父类进度 = Number(参数.设置剧情进度) || Number(参数.目标进度) || 18;
  写入剧情进度(父类进度);
  UnitSuspendDecay(dyingUnit, true);

  const bossUnit = dyingUnit;
  YDUserDataClearSafe("string", "Boss", dyingTypeId === stringToFourCCSafe("N05M") ? "教派学者" : "教派剑士", "unit");
  YDUserDataClearTable("unit", bossUnit);

  const 族长 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (族长 != null && 族长 !== 0) {
    SetUnitPosition(族长, Number(参数.族长新位置X) || 28775.2, Number(参数.族长新位置Y) || -28660.2);
  }
}

function 执行村口放行前置(this: void, 参数: 剧情动作参数表): void {
  const 门禁矩形 = String(参数.门禁矩形 ?? "");
  if (门禁矩形 !== "") {
    const rectHandle = (require("jass.globals") as any)[门禁矩形];
    const 门卫组 = GetUnitsInRectMatching(rectHandle, Condition(是自然守护者));
    if (门卫组 != null && 门卫组 !== 0) {
      let unit = FirstOfGroup(门卫组);
      while (unit != null && unit !== 0) {
        IssueImmediateOrder(unit, "stop");
        GroupRemoveUnit(门卫组, unit);
        unit = FirstOfGroup(门卫组);
      }
      DestroyGroup(门卫组);
    }
    if (rectHandle != null && rectHandle !== 0) RemoveRect(rectHandle);
  }
}

function 执行地精洞窟演出前置(this: void, 参数: 剧情动作参数表): void {
  写入剧情进度(Number(参数.设置剧情进度) || 2);
  CinematicModeBJ(true, GetPlayersAll());
  SetTimeOfDay(0);
  CinematicFilterGenericBJ(2, 1, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 50, 50, 50, 50, 0, 0, 0, 0);
}

function 执行地精祭祀Boss战正式注册(this: void, 参数: 剧情动作参数表): void {
  创建并冻结剧情Boss预置({
    Boss键: String(参数.Boss键 ?? ""),
    Boss名: String(参数.Boss名 ?? "地精巫师"),
    X: Number(参数.X) || -26032.4,
    Y: Number(参数.Y) || -13789.5,
    朝向: Number(参数.朝向) || 270,
    注册范围: Number(参数.注册范围) || 750,
    预创建后暂停: true,
    预创建后无敌: true,
  });
}

function 执行击败地精回村前置(this: void, 参数: 剧情动作参数表): void {
  const 上下文 = 读取当前剧情动作上下文();
  const 触发单位 = 上下文.触发单位;
  const 长老单位 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (触发单位 != null && 触发单位 !== 0) IssueImmediateOrder(触发单位, "stop");
  if (触发单位 != null && 触发单位 !== 0 && 长老单位 != null && 长老单位 !== 0) {
    SetUnitFacingToFaceUnitTimed(触发单位, 长老单位, Number(参数.触发单位转向耗时) || 1);
    SetUnitFacingTimed(长老单位, YDWEAngleBetweenUnitsSafe(长老单位, 触发单位), Number(参数.长老转向耗时) || 1);
  }
}

function 执行王城门禁开启(this: void, 参数: 剧情动作参数表): void {
  const 延迟秒数 = Number(参数.延迟开门秒) || 0;
  const 开门对象 = String(参数.开门对象 ?? "");
  const 隐藏阻挡 = String(参数.隐藏阻挡 ?? "");
  const 执行开门 = (): void => {
    if (开门对象 !== "") {
      const destructable = (require("jass.globals") as any)[开门对象];
      if (destructable != null && destructable !== 0) ModifyGateBJ(bj_GATEOPERATION_OPEN, destructable);
    }
    if (隐藏阻挡 !== "") {
      const hidden = (require("jass.globals") as any)[隐藏阻挡];
      if (hidden != null && hidden !== 0) ShowDestructable(hidden, false);
    }
  };
  if (延迟秒数 > 0) {
    const timer = CreateTimer();
    TimerStart(timer, 延迟秒数, false, function (): void {
      执行开门();
      DestroyTimer(GetExpiredTimer());
    });
    return;
  }
  执行开门();
}

function 执行王宫门卫支线发现(this: void): void {
  const quest = (require("jass.globals") as any).udg_RW?.[8];
  if (quest != null && quest !== 0) QuestSetDiscovered(quest, true);
}

function 执行猎魂试探(this: void): void {
  const npc = YDUserDataGetSafe("string", "jq", "npc", "unit");
  if (npc != null && npc !== 0) {
    SetUnitInvulnerable(npc, false);
    PauseUnit(npc, false);
  }
  YDUserDataClearSafe("string", "jq", "npc", "unit");
}

function 执行树魔首领死亡(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  YDUserDataClearSafe("string", "Boss", "树魔首领", "unit");
  YDUserDataClearTable("unit", dyingUnit);
  写入剧情进度(Number(参数.设置剧情进度) || 28);
}

const 主线剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_长老对话前置": 执行长老对话前置,
  "JLC精灵村_长老任务物品生成": 执行长老任务物品生成,
  "JLC精灵村_发布地精任务": 执行长老任务更新,
  "JLC精灵村_地精区域显视野": 执行地精区域显视野,
  "JLC精灵村_创建地精祭祀Boss预备": 执行地精祭祀Boss预备,
  "JLC精灵村_地精祭祀死亡演出前置": 执行地精祭祀死亡演出前置,
  "JLC精灵村_教派袭击预置": 执行精灵村教派袭击预置,
  "JLC精灵村_教派Boss随机姿态": 执行教派Boss随机姿态,
  "JLC精灵村_远古波动奖励": 执行远古波动奖励,
  "JLC沙漠_情报商人回收夜光翡翠": 执行沙漠情报商人回收夜光翡翠,
  "SRZ蛇人族_交还食人魔凭证": 执行蛇人族交还食人魔凭证,
  "SRZ蛇人族_接受食人魔任务": 执行蛇人族接受食人魔任务,
  "JLC精灵城_克林姆德王接见": 执行克林姆德王接见,
  "SW01死亡事件_沙漠食人魔一阶段死亡": 执行沙漠食人魔一阶段死亡,
  "SW01死亡事件_蒙面人死亡": 执行蒙面人死亡,
};

export function 查找主线剧情动作处理器(this: void, 动作ID: string): 剧情动作处理器 | undefined {
  return 主线剧情动作注册表[动作ID];
}

export function 执行主线剧情动作(this: void, 动作ID: string, 参数: 剧情动作参数表): void {
  const handler = 查找主线剧情动作处理器(动作ID);
  if (handler == null) {
    执行通用剧情动作(参数);
    return;
  }
  handler(参数);
  执行通用剧情动作(参数);
}

Object.assign(主线剧情动作注册表, {
  "JLC精灵村_村口放行前置": 执行村口放行前置,
  "JLC精灵村_地精洞窟演出前置": 执行地精洞窟演出前置,
  "JLC精灵村_地精祭祀Boss战正式注册": 执行地精祭祀Boss战正式注册,
  "JLC精灵村_击败地精回村前置": 执行击败地精回村前置,
  "JLC精灵城_王城门禁开启": 执行王城门禁开启,
  "JLC精灵城_王宫门卫2支线发现": 执行王宫门卫支线发现,
  "JLC精灵城_猎魂试探": 执行猎魂试探,
  "SW01死亡事件_树魔首领死亡": 执行树魔首领死亡,
});
