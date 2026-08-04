/** @noSelfInFile */

const jass = require("jass.common") as any;
const jassGlobals = require("jass.globals") as any;

const { YDUserDataGetSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { DzDoodadCreate } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadCreate: (this: void, id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};
const { GetPlayersAll, ForGroupBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
};
const { CinematicModeBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  CinematicModeBJ: (this: void, flag: boolean, whichForce: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { safeForForce } = require("系统.00．核心系统.07．联机安全工具") as {
  safeForForce: (this: void, whichForce: any, callback: (this: void) => void) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, scale: number, speed: number, duration: number) => any;
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
const { 注册剧情运行时单位, 读取剧情运行时单位, 清理剧情运行时单位 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位") as {
  注册剧情运行时单位: (this: void, 语义名: string, unit: any) => void;
  读取剧情运行时单位: (this: void, 语义名: string) => any;
  清理剧情运行时单位: (this: void, 语义名: string) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { DzDoodadRemove } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadRemove: (this: void, doodad: number) => void;
};
const { 卸载区域背景音乐句柄 } = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时") as {
  卸载区域背景音乐句柄: (this: void, soundHandle: any, rectHandle: any) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 创建并冻结剧情Boss预置 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
import { 进入剧情电影模式, 退出剧情电影模式并恢复镜头 } from "../../00．剧情系统核心工具/12．剧情电影镜头";
export { 护卫试炼后回村剧情片段, 教派最终Boss启动剧情片段 } from "../01．第一章/16．第一章最终Boss教派前置";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Condition = jass.Condition as (this: void, func: (this: void) => boolean) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const GetFilterUnit = jass.GetFilterUnit as (this: void) => any;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => boolean;
const GetUnitsInRectMatching = jass.GetUnitsInRectMatching as (this: void, whichRect: any, filter: any) => any;
const IsPlayerInForce = jass.IsPlayerInForce as (this: void, whichPlayer: any, whichForce: any) => boolean;
const ShowUnit = jass.ShowUnit as (this: void, whichUnit: any, show: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, whichUnit: any, animation: string) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, whichUnit: any, order: string, target: any) => boolean;
const CameraSetupApplyForPlayer = jass.CameraSetupApplyForPlayer as (this: void, doPan: boolean, whichSetup: any, whichPlayer: any, duration: number) => void;
const GetEnumPlayer = jass.GetEnumPlayer as (this: void) => any;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const SetCameraFieldForPlayer = jass.SetCameraFieldForPlayer as (this: void, whichPlayer: any, whichField: number, value: number, duration: number) => void;
const ResetToGameCameraForPlayer = jass.ResetToGameCameraForPlayer as (this: void, whichPlayer: any, duration: number) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;

const 教派现场单位键前缀 = "剧情运行时.教派袭击现场.";
const 教派现场树木: number[] = [];
let 教派镜头切换延迟ID = 0;

function 清理教派袭击现场对象(this: void): void {
  if (教派镜头切换延迟ID !== 0) {
    removeDelayedCallback(教派镜头切换延迟ID);
    教派镜头切换延迟ID = 0;
  }
  for (let i = 1; i <= 6; i++) {
    const unit = 读取剧情运行时单位(`${教派现场单位键前缀}${i}`);
    if (unit != null && unit !== 0) 立即移除单位并取消排泄登记(unit);
    清理剧情运行时单位(`${教派现场单位键前缀}${i}`);
  }
  for (let i = 教派现场树木.length - 1; i >= 0; i--) {
    const doodad = 教派现场树木[i];
    if (doodad != null && doodad !== 0) DzDoodadRemove(doodad);
  }
  教派现场树木.length = 0;
}

function 清理教派袭击现场(this: void): void {
  清理教派袭击现场对象();
  const 玩家英雄组 = 教派现场玩家英雄组();
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    ForGroupBJ(玩家英雄组, () => {
      const unit = GetEnumUnit();
      if (unit == null || unit === 0) return;
      PauseUnit(unit, false);
      SetUnitInvulnerable(unit, false);
    });
  }
  退出剧情电影模式并恢复镜头();
  const localPlayer = GetLocalPlayer();
  SetCameraFieldForPlayer(localPlayer, jass.CAMERA_FIELD_TARGET_DISTANCE as number, 3000, 0);
  ResetToGameCameraForPlayer(localPlayer, 0);
}

function 读取教派现场单位类型(this: void, rawId: string): number {
  return Number((require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
    stringToFourCCSafe: (this: void, s: string) => number;
  }).stringToFourCCSafe(rawId));
}

function 清理语义单位(this: void, 表: string, 键: string): void {
  const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
    YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  };
  const { YDUserDataClearTable } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
    YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
  };
  const unit = YDUserDataGetSafe("string", 表, 键, "unit");
  if (unit != null && unit !== 0) 立即移除单位并取消排泄登记(unit);
  YDUserDataClearTable("string", 表);
}

function 是应隐藏的村内中立单位(this: void): boolean {
  const unit = GetFilterUnit();
  if (unit == null || unit === 0) return false;
  const 玩家组 = YDUserDataGetSafe("string", "玩家", "玩家组", "force");
  return 玩家组 != null && 玩家组 !== 0
    && GetOwningPlayer(unit) === Player(PLAYER_NEUTRAL_PASSIVE)
    && !IsPlayerInForce(GetOwningPlayer(unit), 玩家组);
}

function 隐藏村内中立单位(this: void): void {
  const 矩形 = jassGlobals.gg_rct________________QY;
  if (矩形 == null || 矩形 === 0) return;
  const 单位组 = GetUnitsInRectMatching(矩形, Condition(是应隐藏的村内中立单位));
  if (单位组 == null || 单位组 === 0) return;
  let unit = FirstOfGroup(单位组);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(单位组, unit);
    ShowUnit(unit, false);
    unit = FirstOfGroup(单位组);
  }
  DestroyGroup(单位组);
}

export function 执行护卫试炼后回村(this: void, 参数: 剧情动作参数表): void {
  // 预置阶段只消费上一次现场对象，不能恢复玩家控制或退出本次电影模式。
  清理教派袭击现场对象();
  清理语义单位("ZXCS", "DW");
  清理语义单位("ZXCS2", "DW");
  隐藏村内中立单位();
  const 玩家英雄组 = 教派现场玩家英雄组();
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    ForGroupBJ(玩家英雄组, () => {
      const unit = GetEnumUnit();
      if (unit == null || unit === 0) return;
      PauseUnit(unit, true);
      SetUnitInvulnerable(unit, true);
    });
  }
  进入剧情电影模式();

  const 长老 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (长老 != null && 长老 !== 0) {
    SetUnitPosition(长老, Number(参数.族长位置X) || -26114.4, Number(参数.族长位置Y) || -28671.3);
    SetUnitFacing(长老, 180);
  }
}

export function 执行教派袭击预置(this: void): void {
  清理教派袭击现场对象();
  const 神秘人ID = stringToFourCCSafe("n05H");
  const 精灵护卫ID = stringToFourCCSafe("nhef");
  const 精灵守卫ID = stringToFourCCSafe("n01H");
  if (!(神秘人ID > 0) || !(精灵护卫ID > 0) || !(精灵守卫ID > 0)) return;
  const 现场单位列表: Array<[number, number, number, number]> = [
    [神秘人ID, -26755.1, -28618.6, 0],
    [精灵护卫ID, -25907.1, -28413.0, 178],
    [精灵护卫ID, -25888.1, -28937.1, 185.47],
    [精灵守卫ID, -26119.9, -28926.5, 123.7],
    [精灵守卫ID, -25965.7, -29021.4, 180],
    [精灵守卫ID, -26065.8, -28460.5, 180],
  ];
  for (let i = 0; i < 现场单位列表.length; i++) {
    const 预置 = 现场单位列表[i];
    const unit = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), 预置[0], 预置[1], 预置[2], 预置[3]);
    注册剧情运行时单位(`${教派现场单位键前缀}${i + 1}`, unit);
  }

  const 树木坐标: Array<[number, number]> = [
    [-27676.5, -26406.0], [-27008.7, -26384.5], [-26437.1, -27038.1], [-27524.2, -27604.2], [-27404.8, -28326.7],
    [-26557.1, -28108.3], [-24975.3, -28808.4], [-25385.3, -27834.4], [-23911.9, -29142.2], [-22237.8, -28776.7],
    [-22255.9, -28312.7], [-24574.1, -27746.7], [-23911.9, -29142.2], [-23963.1, -27718.0], [-23632.0, -27698.7],
    [-25487.6, -26993.6], [-24839.6, -26980.8], [-23963.1, -27718.0], [-24464.3, -26590.1], [-23681.3, -26604.5],
    [-23665.1, -27128.5],
  ];
  for (let i = 0; i < 树木坐标.length; i++) {
    const point = 树木坐标[i];
    教派现场树木.push(DzDoodadCreate(stringToFourCCSafe("YOtf"), 1, point[0], point[1], 0, GetRandomDirectionDeg(), 1));
  }

  const 玩家组 = GetPlayersAll();
  const 镜头A = jassGlobalsCamera("gg_cam_Camera_014_______u");
  if (镜头A != null && 镜头A !== 0) {
    safeForForce(玩家组, () => {
      const player = GetEnumPlayer();
      CameraSetupApplyForPlayer(true, 镜头A, player, 0);
      StarOther_PanCameraToTimedForPlayer(player, -26236.2, -28701.7, 5);
    });
  }
  if (教派镜头切换延迟ID !== 0) removeDelayedCallback(教派镜头切换延迟ID);
  教派镜头切换延迟ID = addDelayedCallback(5000, () => {
    教派镜头切换延迟ID = 0;
    const 镜头B = jassGlobalsCamera("gg_cam_Camera_014");
    if (镜头B == null || 镜头B === 0) return;
    safeForForce(GetPlayersAll(), () => CameraSetupApplyForPlayer(true, 镜头B, GetEnumPlayer(), 0));
  });
}

function 教派现场玩家英雄组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function 执行教派现场玩家入场(this: void): void {
  const 神秘人 = 读取剧情运行时单位(`${教派现场单位键前缀}1`);
  const 玩家英雄组 = 教派现场玩家英雄组();
  if (神秘人 == null || 神秘人 === 0 || 玩家英雄组 == null || 玩家英雄组 === 0) return;
  ForGroupBJ(玩家英雄组, () => {
    const unit = GetEnumUnit();
    if (unit == null || unit === 0) return;
    SetUnitPosition(unit, -26846.7, -27820.8);
    SetUnitFacing(unit, YDWEAngleBetweenUnitsSafe(unit, 神秘人));
    SetUnitAnimation(unit, "Attack");
    PauseUnit(unit, true);
  });
}

function 执行教派现场玩家恢复(this: void): void {
  const 神秘人 = 读取剧情运行时单位(`${教派现场单位键前缀}1`);
  const 玩家英雄组 = 教派现场玩家英雄组();
  if (玩家英雄组 == null || 玩家英雄组 === 0) return;
  ForGroupBJ(玩家英雄组, () => {
    const unit = GetEnumUnit();
    if (unit == null || unit === 0) return;
    PauseUnit(unit, false);
    SetUnitInvulnerable(unit, false);
    if (神秘人 != null && 神秘人 !== 0) IssueTargetOrder(unit, "attack", 神秘人);
  });
  if (神秘人 != null && 神秘人 !== 0) {
    SetUnitFacing(神秘人, 90);
    EC_CreateEffect(
      "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl",
      GetUnitX(神秘人),
      GetUnitY(神秘人),
      0,
      270,
      1.5,
      1,
      1,
    );
  }
}

function jassGlobalsCamera(this: void, name: string): any {
  return (require("jass.globals") as any)[name];
}

function 执行教派战斗收束(this: void): void {
  退出剧情电影模式并恢复镜头();
  const sound = jassGlobalsCamera("gg_snd_JQBGM04");
  const rect = jassGlobalsCamera("gg_rct________________QY");
  卸载区域背景音乐句柄(sound, rect);
}

export function 执行教派Boss随机姿态(this: void, 参数: 剧情动作参数表): void {
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

export const 第一章最终Boss教派前置剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_护卫试炼后回村": 执行护卫试炼后回村,
  "JLC精灵村_教派袭击预置": 执行教派袭击预置,
  "JLC精灵村_教派Boss随机姿态": 执行教派Boss随机姿态,
  "JLC精灵村_教派玩家入场": 执行教派现场玩家入场,
  "JLC精灵村_教派玩家恢复": 执行教派现场玩家恢复,
  "JLC精灵村_教派战斗收束": 执行教派战斗收束,
};

注册剧情片段清理("jlc_return_village_after_guard_duel", 清理教派袭击现场);
