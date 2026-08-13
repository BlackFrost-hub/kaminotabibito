/** @noSelfInFile */

const jglobals = require("jass.globals") as any;
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};
const { SetUnitFacingToFaceUnitTimed, ModifyHeroStat } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitFacingToFaceUnitTimed: (this: void, whichUnit: any, target: any, duration: number) => void;
  ModifyHeroStat: (this: void, whichStat: number, whichHero: any, modifyMethod: number, value: number) => void;
};
const { ForGroupBJ, GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
  GetPlayersAll: (this: void) => any;
};
const { RectContainsUnit } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, rectHandle: any, whichUnit: any) => boolean;
};
const { registerOneShotUnitRangeListener } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerOneShotUnitRangeListener: (this: void, unit: any, range: number, callback: (this: void, enteringUnit: any) => boolean, predicate?: (this: void, enteringUnit: any) => boolean) => () => void;
};
const { YDUserDataGetSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const {
  AddSpecialEffect,
  Condition,
  CreateFogModifierRect,
  CreateItem,
  DestroyGroup,
  FirstOfGroup,
  FogModifierStart,
  FOG_OF_WAR_VISIBLE,
  GetEnumUnit,
  GetFilterUnit,
  GetRandomReal,
  GetUnitTypeId,
  GetUnitX,
  GetUnitY,
  GetUnitsInRectMatching,
  GroupRemoveUnit,
  IssueImmediateOrder,
  Player,
  RemoveRect,
  SetUnitFacing,
  SetUnitFacingTimed,
  SetUnitOwner,
  StopMusic,
} = require("lib.扩展函数.封装函数.01．通用工具.12．JASS原生别名") as {
  AddSpecialEffect: (this: void, modelName: string, x: number, y: number) => any;
  Condition: (this: void, func: (this: void) => boolean) => any;
  CreateFogModifierRect: (this: void, whichPlayer: any, whichState: any, where: any, useSharedVision: boolean, afterUnits: boolean) => any;
  CreateItem: (this: void, itemId: number, x: number, y: number) => any;
  DestroyGroup: (this: void, whichGroup: any) => void;
  FirstOfGroup: (this: void, whichGroup: any) => any;
  FogModifierStart: (this: void, whichFog: any) => void;
  FOG_OF_WAR_VISIBLE: number;
  GetEnumUnit: (this: void) => any;
  GetFilterUnit: (this: void) => any;
  GetRandomReal: (this: void, lowBound: number, highBound: number) => number;
  GetUnitTypeId: (this: void, whichUnit: any) => number;
  GetUnitX: (this: void, whichUnit: any) => number;
  GetUnitY: (this: void, whichUnit: any) => number;
  GetUnitsInRectMatching: (this: void, whichRect: any, filter: any) => any;
  GroupRemoveUnit: (this: void, whichGroup: any, whichUnit: any) => void;
  IssueImmediateOrder: (this: void, whichUnit: any, order: string) => boolean;
  Player: (this: void, whichPlayer: number) => any;
  RemoveRect: (this: void, whichRect: any) => void;
  SetUnitFacing: (this: void, whichUnit: any, facing: number) => void;
  SetUnitFacingTimed: (this: void, whichUnit: any, facing: number, duration: number) => void;
  SetUnitOwner: (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
  StopMusic: (this: void, fadeOut: boolean) => void;
};
const { 触发单位增加基础全属性 } = require("../../00．剧情系统核心工具/06．剧情通用执行工具") as {
  触发单位增加基础全属性: (this: void, value: number, template: string) => void;
};
import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";

import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 创建并冻结剧情Boss预置 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";

type 播放主线剧情片段函数 = (this: void, 片段ID: string, 上下文?: any) => boolean;
let 播放主线剧情片段实现: 播放主线剧情片段函数 | undefined;

function 播放主线剧情片段(this: void, 片段ID: string, 上下文?: any): boolean {
  if (播放主线剧情片段实现 == null) {
    const 播放器模块 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
      播放主线剧情片段: 播放主线剧情片段函数;
    };
    播放主线剧情片段实现 = 播放器模块.播放主线剧情片段;
  }
  return 播放主线剧情片段实现(片段ID, 上下文);
}

const bj_HEROSTAT_STR = jglobals.bj_HEROSTAT_STR as number;
const bj_HEROSTAT_AGI = jglobals.bj_HEROSTAT_AGI as number;
const bj_HEROSTAT_INT = jglobals.bj_HEROSTAT_INT as number;
const bj_MODIFYMETHOD_ADD = jglobals.bj_MODIFYMETHOD_ADD as number;

let 已初始化进度01核心 = false;
let 已触发村口放行 = false;
let 村口放行玩家面向角度 = 0;

function 读取长老单位(this: void): any {
  return YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
}

function 是自然守护者(this: void): boolean {
  const unit = GetFilterUnit();
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === stringToFourCCSafe("etrp");
}

function on村口放行玩家停下并转向(this: void): void {
  const unit = GetEnumUnit();
  if (unit == null || unit === 0) return;
  IssueImmediateOrder(unit, "stop");
  SetUnitFacing(unit, 村口放行玩家面向角度);
}

function 分割名称列表(this: void, value: string | undefined): string[] {
  if (value == null || value === "") return [];
  return value.split(",").map((item) => item.trim()).filter((item) => item.length > 0);
}

function 对所有玩家添加区域视野(this: void, rectVarName: string): void {
  const rectHandle = 获取矩形区域(rectVarName);
  if (rectHandle == null || rectHandle === 0) return;
  for (let playerId = 0; playerId < 8; playerId++) {
    const fogModifier = CreateFogModifierRect(Player(playerId), FOG_OF_WAR_VISIBLE, rectHandle, true, false);
    if (fogModifier == null || fogModifier === 0) continue;
    FogModifierStart(fogModifier);
  }
}

function 创建随机金光戒指(this: void): void {
  const rawId = 按名字反查物品ID("金光戒指");
  const itemTypeId = stringToFourCCSafe(rawId);
  if (!(itemTypeId > 0)) return;
  CreateItem(itemTypeId, -10112.9 + GetRandomReal(-1800, 1800), -26327.3 + GetRandomReal(-1800, 1800));
}

export function 执行村口放行前置(this: void, 参数: 剧情动作参数表): void {
  const 门禁矩形 = String(参数.门禁矩形 ?? "");
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (门禁矩形 === "") return;
  const rectHandle = 获取矩形区域(门禁矩形);
  const 门卫组 = GetUnitsInRectMatching(rectHandle, Condition(是自然守护者));
  if (门卫组 != null && 门卫组 !== 0) {
    let unit = FirstOfGroup(门卫组);
    while (unit != null && unit !== 0) {
      IssueImmediateOrder(unit, "stop");
      SetUnitFacing(unit, 210);
      if (触发单位 != null && 触发单位 !== 0 && 玩家英雄组 != null && 玩家英雄组 !== 0) {
        村口放行玩家面向角度 = YDWEAngleBetweenUnitsSafe(触发单位, unit);
        ForGroupBJ(玩家英雄组, on村口放行玩家停下并转向);
      }
      GroupRemoveUnit(门卫组, unit);
      unit = FirstOfGroup(门卫组);
    }
    DestroyGroup(门卫组);
  }
  if (rectHandle != null && rectHandle !== 0) RemoveRect(rectHandle);
}

export function 执行长老对话前置(this: void, 参数: 剧情动作参数表): void {
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  const 长老单位 = 读取长老单位();
  const 自然传送门 = jglobals.gg_unit_n025_0372;
  对所有玩家添加区域视野("精灵村");
  if (自然传送门 != null && 自然传送门 !== 0) SetUnitOwner(自然传送门, Player(6), true);
  创建随机金光戒指();
  StopMusic(false);

  if (触发单位 != null && 触发单位 !== 0 && 参数.触发单位发布命令 != null) {
    IssueImmediateOrder(触发单位, String(参数.触发单位发布命令));
  }
  if (触发单位 != null && 触发单位 !== 0 && 长老单位 != null && 长老单位 !== 0) {
    SetUnitFacingToFaceUnitTimed(触发单位, 长老单位, Number(参数.触发单位转向耗时) || 0);
    SetUnitFacingTimed(长老单位, YDWEAngleBetweenUnitsSafe(长老单位, 触发单位), Number(参数.长老转向耗时) || 0);
  }
  if (长老单位 != null && 长老单位 !== 0 && typeof 参数.长老归属玩家 === "number") {
    SetUnitOwner(长老单位, Player(参数.长老归属玩家), true);
  }
}

export function 执行长老任务物品生成(this: void, 参数: 剧情动作参数表): void {
  const 长老单位 = 读取长老单位();
  if (长老单位 == null || 长老单位 === 0) return;
  const 物品名列表 = 分割名称列表(String(参数.物品名列表 ?? ""));
  for (let i = 0; i < 物品名列表.length; i++) {
    const itemTypeId = stringToFourCCSafe(按名字反查物品ID(物品名列表[i]));
    if (itemTypeId > 0) CreateItem(itemTypeId, GetUnitX(长老单位), GetUnitY(长老单位));
  }
}

export function 执行地精区域显视野(this: void, 参数: 剧情动作参数表): void {
  对所有玩家添加区域视野(String(参数.可见区域1 ?? ""));
  对所有玩家添加区域视野(String(参数.可见区域2 ?? ""));
}

export function 执行地精祭祀Boss预备(this: void, 参数: 剧情动作参数表): void {
  // 创建、暂停、无敌、运行时登记和范围事件统一由通用 Boss 预置桥接处理。
  // 这里保留原动作 ID 作为兼容入口，避免旧配置绕过统一生命周期。
  创建并冻结剧情Boss预置({
    Boss键: String(参数.Boss键 ?? "Boss.地精巫师"),
    Boss名: String(参数.Boss名 ?? "地精祭祀|cffff0000（BossLV12）|r"),
    X: Number(参数.X) || -26032.4,
    Y: Number(参数.Y) || -13789.5,
    朝向: Number(参数.朝向) || 270,
    注册范围: Number(参数.注册范围) || 0,
    预创建后暂停: 参数.预创建后暂停 === true,
    预创建后无敌: 参数.预创建后无敌 === true,
    范围触发配置名: String(参数.范围触发配置名 ?? "") || undefined,
    范围触发剧情片段ID: String(参数.范围触发剧情片段ID ?? "") || undefined,
    需要剧情进度: Number(参数.触发进度) || undefined,
  });
}

export function 执行远古波动奖励(this: void, 参数: 剧情动作参数表): void {
  const 奖励值 = Number(参数.力量) || Number(参数.全属性) || 3;
  触发单位增加基础全属性(奖励值, String(参数.任务消息模板 ?? "{英雄名}受到了远古波动！（|cffff99cc全属性+{value}|r）"));
}

export const 精灵村长老发布任务剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_村口放行前置": 执行村口放行前置,
  "JLC精灵村_长老对话前置": 执行长老对话前置,
  "JLC精灵村_长老任务物品生成": 执行长老任务物品生成,
  "JLC精灵村_地精区域显视野": 执行地精区域显视野,
  "JLC精灵村_创建地精祭祀Boss预备": 执行地精祭祀Boss预备,
  "JLC精灵村_远古波动奖励": 执行远古波动奖励,
};

function 写入并播放剧情(this: void, 片段ID: string, 触发配置名: string, 触发单位: any): boolean {
  return 播放主线剧情片段(片段ID, { 片段ID, 触发配置名, 触发单位 });
}

function 触发单位在村口放行矩形内(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const rect = 获取矩形区域("精灵村.门禁区域");
  if (rect == null || rect === 0) return false;
  return RectContainsUnit(rect, unit);
}

function on精灵村村口放行触发(this: void, 触发单位: any): boolean {
  if (已触发村口放行) return true;
  if (读取剧情进度() > 0) return true;
  if (!触发单位在村口放行矩形内(触发单位)) return false;
  if (写入并播放剧情("jlc_elven_village_gate_release", "精灵村村口放行核心", 触发单位)) {
    已触发村口放行 = true;
    return true;
  }
  return false;
}

function on精灵村长老发布任务触发(this: void, 触发单位: any): boolean {
  if (读取剧情进度() >= 1) return true;
  return 写入并播放剧情("jlc_elven_village_elder_quest", "精灵村长老发布任务核心", 触发单位);
}

export function 初始化进度01_精灵村长老发布任务核心(this: void): void {
  if (已初始化进度01核心) return;
  已初始化进度01核心 = true;

  registerOneShotUnitRangeListener(
    YDUserDataGetSafe("string", "主线NPC", "自然守护者", "unit"),
    500,
    on精灵村村口放行触发,
    是玩家英雄组单位,
  );
  registerOneShotUnitRangeListener(
    YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit"),
    800,
    on精灵村长老发布任务触发,
    是玩家英雄组单位,
  );
}
