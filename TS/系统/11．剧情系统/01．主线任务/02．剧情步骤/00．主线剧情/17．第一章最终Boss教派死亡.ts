/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDUserDataGetSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { GetPlayersAll, ForGroupBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
};
const { 切换区域背景音乐表达式 } = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时") as {
  切换区域背景音乐表达式: (this: void, expr: string | undefined, add: boolean) => number;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, scale: number, speed: number, duration: number) => any;
};
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, modelName: string, targetWidget: any, attachPointName: string) => any;
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (this: void, duration: number, effect: any) => void;
};
const { safeForForce } = require("系统.00．核心系统.07．联机安全工具") as {
  safeForForce: (this: void, whichForce: any, callback: (this: void) => void) => void;
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
const { 进入剧情电影模式, 退出剧情电影模式并恢复镜头 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头") as {
  进入剧情电影模式: (this: void) => void;
  退出剧情电影模式并恢复镜头: (this: void) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { 按结算键执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  按结算键执行Boss死亡结算: (this: void, 结算键: string, Boss单位?: any, 击杀者?: any) => boolean;
};
const { 消费保留剧情Boss死亡击杀者 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接") as {
  消费保留剧情Boss死亡击杀者: (this: void, bossUnit: any) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 教派最终Boss死亡剧情片段 } from "../01．第一章/17．第一章最终Boss教派死亡";

const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const CreateItem = jass.CreateItem as (this: void, itemTypeId: number, x: number, y: number) => any;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, unitType: number) => boolean;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer as (this: void, whichUnit: any, whichPlayer: any) => boolean;
const KillUnit = jass.KillUnit as (this: void, whichUnit: any) => void;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, whichUnit: any) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, whichUnit: any, animation: string) => void;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetCameraFieldForPlayer = jass.SetCameraFieldForPlayer as (this: void, whichPlayer: any, whichField: number, value: number, duration: number) => void;
const ResetToGameCameraForPlayer = jass.ResetToGameCameraForPlayer as (this: void, whichPlayer: any, duration: number) => void;
const CameraSetupApplyForPlayer = jass.CameraSetupApplyForPlayer as (this: void, doPan: boolean, whichSetup: any, whichPlayer: any, duration: number) => void;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const GetEnumPlayer = jass.GetEnumPlayer as (this: void) => any;
const Player = jass.Player as (this: void, playerId: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;

const 蒙面人死亡现场残影键 = "剧情运行时.蒙面人死亡.残影";
const 蒙面人死亡击杀玩家键 = "剧情运行时.蒙面人死亡.击杀玩家";
let 蒙面人死亡环境音乐延迟ID = 0;
let 蒙面人死亡音乐已启动 = false;

function 句柄有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 单位存活(this: void, unit: any): boolean {
  return 句柄有效(unit) && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 读取蒙面人死亡单位(this: void): any {
  const 上下文单位 = 读取当前剧情动作上下文().触发单位;
  if (句柄有效(上下文单位)) return 上下文单位;

  const 已绑定Boss = YDUserDataGetSafe("string", "Boss", "蒙面人", "unit");
  if (句柄有效(已绑定Boss)) return 已绑定Boss;

  return GetDyingUnit();
}

function 读取蒙面人死亡击杀玩家(this: void, Boss单位: any): any {
  const 已保留击杀者 = 消费保留剧情Boss死亡击杀者(Boss单位);
  if (单位存活(已保留击杀者)) return 已保留击杀者;

  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0) return null;
  let 候选英雄: any = null;
  ForGroupBJ(玩家英雄组, () => {
    const unit = GetEnumUnit();
    if (候选英雄 == null && 单位存活(unit)) 候选英雄 = unit;
  });
  return 候选英雄;
}

function 读取Jass全局句柄(this: void, name: string): any {
  return (require("jass.globals") as any)[name];
}

function 切换蒙面人死亡区域音乐(this: void, add: boolean, soundName: string, rectName: string): void {
  切换区域背景音乐表达式(`${soundName} @ ${rectName}`, add);
}

function 停止蒙面人死亡区域音乐(this: void): void {
  const rects = [
    "gg_rct______________055", "gg_rct_____________001", "gg_rct______________086", "gg_rct______________083",
    "gg_rct______________081", "gg_rct_007____________u", "gg_rct________________00X", "gg_rct______________084",
  ];
  for (let i = 0; i < rects.length; i++) 切换蒙面人死亡区域音乐(false, "gg_snd_JQBGM03", rects[i]);
}

function 播放蒙面人死亡胜利音乐(this: void): void {
  切换蒙面人死亡区域音乐(false, "gg_snd_shengliBgm2", "gg_rct________________QY");
  切换蒙面人死亡区域音乐(true, "gg_snd_shengliBgm2", "gg_rct________________QY");
}

function 添加蒙面人死亡环境音乐(this: void): void {
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM006", "gg_rct________________00X");
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM007", "gg_rct______________084");
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM006", "gg_rct_007____________u");
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM008", "gg_rct______________081");
  切换蒙面人死亡区域音乐(true, "gg_snd_bgm003", "gg_rct_____________001");
  const 背景音乐 = jass.GetRandomInt(1, 2) === 1 ? "gg_snd_BGM016" : "gg_snd_BGM017";
  切换蒙面人死亡区域音乐(true, 背景音乐, "gg_rct______________055");
  切换蒙面人死亡区域音乐(true, 背景音乐, "gg_rct______________086");
  切换蒙面人死亡区域音乐(true, 背景音乐, "gg_rct______________083");
}

function 恢复蒙面人死亡区域音乐(this: void): void {
  蒙面人死亡环境音乐延迟ID = 0;
  切换蒙面人死亡区域音乐(false, "gg_snd_shengliBgm2", "gg_rct________________QY");
  切换蒙面人死亡区域音乐(false, "gg_snd_zhuchengBGM01", "gg_rct________________QY");
  切换蒙面人死亡区域音乐(true, "gg_snd_zhuchengBGM01", "gg_rct________________QY");
}

function 启动蒙面人死亡胜利音乐(this: void): void {
  if (蒙面人死亡音乐已启动) return;
  蒙面人死亡音乐已启动 = true;
  播放蒙面人死亡胜利音乐();
  添加蒙面人死亡环境音乐();
  if (蒙面人死亡环境音乐延迟ID !== 0) removeDelayedCallback(蒙面人死亡环境音乐延迟ID);
  蒙面人死亡环境音乐延迟ID = addDelayedCallback(60000, 恢复蒙面人死亡区域音乐);
}

function 清理蒙面人死亡现场(this: void): void {
  if (蒙面人死亡环境音乐延迟ID !== 0) {
    removeDelayedCallback(蒙面人死亡环境音乐延迟ID);
    蒙面人死亡环境音乐延迟ID = 0;
    恢复蒙面人死亡区域音乐();
  }
  const 残影 = 读取剧情运行时单位(蒙面人死亡现场残影键);
  if (残影 != null && 残影 !== 0) 立即移除单位并取消排泄登记(残影);
  清理剧情运行时单位(蒙面人死亡现场残影键);
  清理剧情运行时单位(蒙面人死亡击杀玩家键);
  蒙面人死亡音乐已启动 = false;
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) {
    ForGroupBJ(玩家英雄组, () => {
      const unit = GetEnumUnit();
      if (unit != null && unit !== 0) {
        PauseUnit(unit, false);
        SetUnitInvulnerable(unit, false);
      }
    });
  }
  退出剧情电影模式并恢复镜头();
  const localPlayer = GetLocalPlayer();
  SetCameraFieldForPlayer(localPlayer, jass.CAMERA_FIELD_TARGET_DISTANCE as number, 3000, 0);
  ResetToGameCameraForPlayer(localPlayer, 0);
}

function 清理现场中立机械单位(this: void): void {
  const group = CreateGroup();
  if (group == null || group === 0) return;
  GroupEnumUnitsInRange(group, 26498.2, 18955.1, 3000, null);
  const neutralAggressive = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE as number);
  const mechanicalType = jass.UNIT_TYPE_MECHANICAL as number;
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (IsUnitType(unit, mechanicalType) && IsUnitOwnedByPlayer(unit, neutralAggressive)) KillUnit(unit);
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
}

function 玩家英雄进入蒙面人死亡现场(this: void, 残影: any): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0 || 残影 == null || 残影 === 0) return;
  ForGroupBJ(玩家英雄组, () => {
    const unit = GetEnumUnit();
    if (unit == null || unit === 0) return;
    SetUnitPosition(unit, -26846.7, -27820.8);
    SetUnitFacing(unit, YDWEAngleBetweenUnitsSafe(unit, 残影));
    SetUnitAnimation(unit, "Attack");
    PauseUnit(unit, true);
  });
}

function 释放蒙面人死亡现场玩家(this: void): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0) return;
  ForGroupBJ(玩家英雄组, () => {
    const unit = GetEnumUnit();
    if (unit == null || unit === 0) return;
    PauseUnit(unit, false);
    const radians = GetUnitFacing(unit) * bj_DEGTORAD;
    IssuePointOrder(unit, "move", GetUnitX(unit) + Cos(radians) * 150, GetUnitY(unit) + Sin(radians) * 150);
  });
}

function 应用蒙面人死亡镜头(this: void): void {
  const camera = 读取Jass全局句柄("gg_cam_Camera_014");
  if (camera == null || camera === 0) return;
  safeForForce(GetPlayersAll(), () => CameraSetupApplyForPlayer(true, camera, GetEnumPlayer(), 0));
}

export function 执行蒙面人死亡(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = 读取蒙面人死亡单位();
  if (dyingUnit == null || dyingUnit === 0) return;
  const dyingTypeId = GetUnitTypeId(dyingUnit);
  if (dyingTypeId !== stringToFourCCSafe("N05N") && dyingTypeId !== stringToFourCCSafe("N05M")) return;

  清理蒙面人死亡现场();
  停止蒙面人死亡区域音乐();
  进入剧情电影模式();
  应用蒙面人死亡镜头();
  清理现场中立机械单位();
  const 残影 = 创建单位并登记排泄安全(Player(jass.PLAYER_NEUTRAL_PASSIVE as number), stringToFourCCSafe("n05H"), -26755.1, -28618.6, 90);
  注册剧情运行时单位(蒙面人死亡现场残影键, 残影);
  const 击杀玩家 = 读取蒙面人死亡击杀玩家(dyingUnit);
  注册剧情运行时单位(蒙面人死亡击杀玩家键, 击杀玩家);
  if (残影 != null && 残影 !== 0) {
    EC_CreateEffect("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", GetUnitX(残影), GetUnitY(残影), 0, 270, 2, 1, 3);
    const 残影流血特效 = AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl", 残影, "origin");
    if (残影流血特效 != null && 残影流血特效 !== 0) YDWETimerDestroyEffect(4, 残影流血特效);
    EC_CreateEffect("war3mapImported\\[AKE]war3AKE.com - 8853914802857115659031497.mdl", GetUnitX(残影), GetUnitY(残影), 0, 270, 1.25, 1, 5);
  }
  EC_CreateEffect("Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", -26846.7, -27820.8, 0, 270, 1.65, 1, 3);
  玩家英雄进入蒙面人死亡现场(残影);

  按结算键执行Boss死亡结算("蒙面人", dyingUnit, 击杀玩家);

  const 固定掉落物品名 = String(参数.固定掉落物品名 ?? "");
  const 固定掉落物品ID = stringToFourCCSafe(按名字反查物品ID(固定掉落物品名));
  if (固定掉落物品ID > 0) {
    CreateItem(固定掉落物品ID, Number(参数.固定掉落X) || 15678.8, Number(参数.固定掉落Y) || -29965.6);
  }

  const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
    YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  };
  const 长老 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (长老 != null && 长老 !== 0) {
    SetUnitPosition(长老, Number(参数.族长新位置X) || 28775.2, Number(参数.族长新位置Y) || -28660.2);
  }
}

export function 执行蒙面人死亡胜利音乐(this: void): void {
  启动蒙面人死亡胜利音乐();
}

export function 执行蒙面人死亡释放玩家(this: void): void {
  释放蒙面人死亡现场玩家();
}

export const 第一章最终Boss教派死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_蒙面人死亡": 执行蒙面人死亡,
  "SW01死亡事件_蒙面人死亡胜利音乐": 执行蒙面人死亡胜利音乐,
  "SW01死亡事件_蒙面人死亡释放玩家": 执行蒙面人死亡释放玩家,
};

注册剧情片段清理("jlc_cult_final_boss_death", 清理蒙面人死亡现场);
