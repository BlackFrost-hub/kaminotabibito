/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDUserDataGetSafe, YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};
const { 添加单位暂停, 释放单位暂停来源全部 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  释放单位暂停来源全部: (this: void, unit: any, source: string) => boolean;
};
const { GetPlayersAll, ForGroupBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
  ForGroupBJ: (this: void, whichGroup: any, callback: (this: void) => void) => void;
};
const { 切换区域背景音乐表达式 } = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时") as {
  切换区域背景音乐表达式: (this: void, expr: string | undefined, add: boolean) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; 面向角度?: number; 缩放?: number; 动画速度?: number; 持续秒?: number }) => any;
};
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, modelName: string, targetWidget: any, attachPointName: string) => any;
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (this: void, duration: number, effect: any) => void;
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
const { 进入剧情电影模式, 退出剧情电影模式并恢复镜头, 应用剧情电影镜头 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.12．剧情电影镜头") as {
  进入剧情电影模式: (this: void) => void;
  退出剧情电影模式并恢复镜头: (this: void) => void;
  应用剧情电影镜头: (this: void, 预设: 剧情镜头预设参数, duration: number) => void;
};
import type { 剧情镜头预设参数 } from "../../00．剧情系统核心工具/12．剧情电影镜头";
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
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
import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";
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
const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const SetUnitX = jass.SetUnitX as (this: void, whichUnit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, whichUnit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, whichUnit: any, animation: string) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (this: void, whichUnit: any, red: number, green: number, blue: number, alpha: number) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const Player = jass.Player as (this: void, playerId: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const bj_QUESTMESSAGE_HINT = (require("jass.globals") as any).bj_QUESTMESSAGE_HINT as number;
const bj_QUESTMESSAGE_UPDATED = (require("jass.globals") as any).bj_QUESTMESSAGE_UPDATED as number;

const 蒙面人死亡现场残影键 = "剧情运行时.蒙面人死亡.残影";
const 蒙面人死亡击杀玩家键 = "剧情运行时.蒙面人死亡.击杀玩家";
const 蒙面人死亡现场玩家暂停来源 = "剧情系统:蒙面人死亡现场";
let 蒙面人死亡环境音乐延迟ID = 0;
let 蒙面人死亡音乐已启动 = false;
let 蒙面人死亡残影渐隐周期ID = 0;
let 蒙面人死亡残影渐隐次数 = 0;
let 蒙面人死亡枚举残影: any = null;
let 蒙面人死亡枚举击杀候选: any = null;

const 蒙面人死亡镜头预设: 剧情镜头预设参数 = {
  X: -26699.6,
  Y: -28368.4,
  高度偏移: 0,
  旋转角度: 270,
  攻角: 320,
  距离到目标: 2800,
  滚动角度: 0,
  观察区域: 50,
  远景剪裁: 5000,
};

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

function 选取蒙面人死亡击杀候选(this: void): void {
  if (蒙面人死亡枚举击杀候选 != null) return;
  const unit = GetEnumUnit();
  if (单位存活(unit)) 蒙面人死亡枚举击杀候选 = unit;
}

function 读取蒙面人死亡击杀玩家(this: void, Boss单位: any): any {
  const 已保留击杀者 = 消费保留剧情Boss死亡击杀者(Boss单位);
  if (单位存活(已保留击杀者)) return 已保留击杀者;

  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0) return null;
  蒙面人死亡枚举击杀候选 = null;
  ForGroupBJ(玩家英雄组, 选取蒙面人死亡击杀候选);
  const 候选英雄 = 蒙面人死亡枚举击杀候选;
  蒙面人死亡枚举击杀候选 = null;
  return 候选英雄;
}

function 切换蒙面人死亡区域音乐(this: void, add: boolean, soundName: string, rectName: string): void {
  切换区域背景音乐表达式(`${soundName} @ ${rectName}`, add);
}

function 停止蒙面人死亡区域音乐(this: void): void {
  const rects = [
    "沙漠区域.区域1", "沙漠绿洲", "悲风山谷", "沙漠区域.区域3",
    "巨石峡谷", "奇幻湖", "史莱姆草原", "精灵森",
  ];
  for (let i = 0; i < rects.length; i++) 切换蒙面人死亡区域音乐(false, "gg_snd_JQBGM03", rects[i]);
}

function 播放蒙面人死亡胜利音乐(this: void): void {
  切换蒙面人死亡区域音乐(false, "gg_snd_shengliBgm2", "精灵村");
  切换蒙面人死亡区域音乐(true, "gg_snd_shengliBgm2", "精灵村");
}

function 添加蒙面人死亡环境音乐(this: void): void {
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM006", "史莱姆草原");
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM007", "精灵森");
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM006", "奇幻湖");
  切换蒙面人死亡区域音乐(true, "gg_snd_BGM008", "巨石峡谷");
  切换蒙面人死亡区域音乐(true, "gg_snd_bgm003", "沙漠绿洲");
  const 背景音乐 = GetRandomInt(1, 2) === 1 ? "gg_snd_BGM016" : "gg_snd_BGM017";
  切换蒙面人死亡区域音乐(true, 背景音乐, "沙漠区域.区域1");
  切换蒙面人死亡区域音乐(true, 背景音乐, "悲风山谷");
  切换蒙面人死亡区域音乐(true, 背景音乐, "沙漠区域.区域3");
}

function 恢复蒙面人死亡区域音乐(this: void): void {
  蒙面人死亡环境音乐延迟ID = 0;
  切换蒙面人死亡区域音乐(false, "gg_snd_shengliBgm2", "精灵村");
  切换蒙面人死亡区域音乐(false, "gg_snd_zhuchengBGM01", "精灵村");
  切换蒙面人死亡区域音乐(true, "gg_snd_zhuchengBGM01", "精灵村");
}

function 启动蒙面人死亡胜利音乐(this: void): void {
  if (蒙面人死亡音乐已启动) return;
  蒙面人死亡音乐已启动 = true;
  播放蒙面人死亡胜利音乐();
  添加蒙面人死亡环境音乐();
  if (蒙面人死亡环境音乐延迟ID !== 0) removeDelayedCallback(蒙面人死亡环境音乐延迟ID);
  蒙面人死亡环境音乐延迟ID = addDelayedCallback(60000, 恢复蒙面人死亡区域音乐);
}

function 恢复蒙面人死亡玩家控制(this: void): void {
  const unit = GetEnumUnit();
  if (!句柄有效(unit)) return;
  释放单位暂停来源全部(unit, 蒙面人死亡现场玩家暂停来源);
}

function 清理蒙面人死亡现场(this: void): void {
  if (蒙面人死亡环境音乐延迟ID !== 0) {
    removeDelayedCallback(蒙面人死亡环境音乐延迟ID);
    蒙面人死亡环境音乐延迟ID = 0;
    恢复蒙面人死亡区域音乐();
  }
  if (蒙面人死亡残影渐隐周期ID !== 0) {
    removePeriodicCallback(蒙面人死亡残影渐隐周期ID);
    蒙面人死亡残影渐隐周期ID = 0;
  }
  蒙面人死亡残影渐隐次数 = 0;
  const 残影 = 读取剧情运行时单位(蒙面人死亡现场残影键);
  if (残影 != null && 残影 !== 0) 立即移除单位并取消排泄登记(残影);
  清理剧情运行时单位(蒙面人死亡现场残影键);
  清理剧情运行时单位(蒙面人死亡击杀玩家键);
  蒙面人死亡音乐已启动 = false;
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) ForGroupBJ(玩家英雄组, 恢复蒙面人死亡玩家控制);
  退出剧情电影模式并恢复镜头();
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

function 布置蒙面人死亡现场英雄(this: void): void {
  const unit = GetEnumUnit();
  if (!句柄有效(unit) || !句柄有效(蒙面人死亡枚举残影)) return;
  SetUnitX(unit, -26846.7);
  SetUnitY(unit, -27820.8);
  SetUnitFacing(unit, YDWEAngleBetweenUnitsSafe(unit, 蒙面人死亡枚举残影));
  SetUnitAnimation(unit, "Attack");
  添加单位暂停(unit, 蒙面人死亡现场玩家暂停来源);
}

function 玩家英雄进入蒙面人死亡现场(this: void, 残影: any): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0 || !句柄有效(残影)) return;
  蒙面人死亡枚举残影 = 残影;
  ForGroupBJ(玩家英雄组, 布置蒙面人死亡现场英雄);
  蒙面人死亡枚举残影 = null;
}

function 释放蒙面人死亡现场英雄(this: void): void {
  const unit = GetEnumUnit();
  if (!句柄有效(unit)) return;
  释放单位暂停来源全部(unit, 蒙面人死亡现场玩家暂停来源);
  const radians = GetUnitFacing(unit) * bj_DEGTORAD;
  IssuePointOrder(unit, "move", GetUnitX(unit) + Cos(radians) * 150, GetUnitY(unit) + Sin(radians) * 150);
}

function 释放蒙面人死亡现场玩家(this: void): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) ForGroupBJ(玩家英雄组, 释放蒙面人死亡现场英雄);
}

function 更新蒙面人死亡残影渐隐(this: void): void {
  const 残影 = 读取剧情运行时单位(蒙面人死亡现场残影键);
  if (!句柄有效(残影) || 蒙面人死亡残影渐隐次数 >= 20) {
    if (句柄有效(残影)) 立即移除单位并取消排泄登记(残影);
    清理剧情运行时单位(蒙面人死亡现场残影键);
    if (蒙面人死亡残影渐隐周期ID !== 0) removePeriodicCallback(蒙面人死亡残影渐隐周期ID);
    蒙面人死亡残影渐隐周期ID = 0;
    return;
  }
  蒙面人死亡残影渐隐次数++;
  SetUnitVertexColor(残影, 255, 255, 255, 255 - 蒙面人死亡残影渐隐次数 * 12.75);
}

export function 执行蒙面人死亡(this: void, _参数: 剧情动作参数表): void {
  const dyingUnit = 读取蒙面人死亡单位();
  if (dyingUnit == null || dyingUnit === 0) return;
  const dyingTypeId = GetUnitTypeId(dyingUnit);
  if (dyingTypeId !== stringToFourCCSafe("N05N") && dyingTypeId !== stringToFourCCSafe("N05M")) return;

  清理蒙面人死亡现场();
  停止蒙面人死亡区域音乐();
  进入剧情电影模式();
  发送剧情任务消息({ 消息类型: bj_QUESTMESSAGE_HINT, 文本: "|cffffff00『系统提示』：|r这段剧情无法跳过" });
  应用剧情电影镜头(蒙面人死亡镜头预设, 0);
  清理现场中立机械单位();
  const 残影 = 创建单位并登记排泄安全(Player(jass.PLAYER_NEUTRAL_PASSIVE as number), stringToFourCCSafe("n05H"), -26755.1, -28618.6, 90);
  注册剧情运行时单位(蒙面人死亡现场残影键, 残影);
  const 击杀玩家 = 读取蒙面人死亡击杀玩家(dyingUnit);
  注册剧情运行时单位(蒙面人死亡击杀玩家键, 击杀玩家);
  if (残影 != null && 残影 !== 0) {
    创建点特效({ 模型路径: "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", X: GetUnitX(残影), Y: GetUnitY(残影), 面向角度: 270, 缩放: 2, 动画速度: 1, 持续秒: 3 });
    const 残影流血特效 = AddSpecialEffectTarget("Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl", 残影, "origin");
    if (残影流血特效 != null && 残影流血特效 !== 0) YDWETimerDestroyEffect(4, 残影流血特效);
  }
  创建点特效({ 模型路径: "Abilities\\Spells\\Human\\Resurrect\\ResurrectCaster.mdl", X: -26846.7, Y: -27820.8, 面向角度: 270, 缩放: 1.65, 动画速度: 1, 持续秒: 3 });
  玩家英雄进入蒙面人死亡现场(残影);

  按结算键执行Boss死亡结算("蒙面人", dyingUnit, 击杀玩家);
}

export function 执行蒙面人死亡残影遁走(this: void): void {
  const 残影 = 读取剧情运行时单位(蒙面人死亡现场残影键);
  if (!句柄有效(残影)) return;
  创建点特效({ 模型路径: "war3mapImported\\[AKE]war3AKE.com - 8853914802857115659031497.mdl", X: GetUnitX(残影), Y: GetUnitY(残影), 面向角度: 270, 缩放: 1.25, 动画速度: 1, 持续秒: 5 });
  if (蒙面人死亡残影渐隐周期ID !== 0) removePeriodicCallback(蒙面人死亡残影渐隐周期ID);
  蒙面人死亡残影渐隐次数 = 0;
  蒙面人死亡残影渐隐周期ID = addPeriodicCallback(250, 更新蒙面人死亡残影渐隐);
}

export function 执行蒙面人死亡胜利音乐(this: void): void {
  启动蒙面人死亡胜利音乐();
  发送剧情任务消息({ 消息类型: bj_QUESTMESSAGE_UPDATED, 文本: "|cffffff00『主线目标』：|r成功击退神秘蒙面人！" });
}

export function 执行蒙面人死亡释放玩家(this: void): void {
  释放蒙面人死亡现场玩家();
}

export function 执行蒙面人死亡关闭电影模式(this: void): void {
  退出剧情电影模式并恢复镜头();
}

export function 执行蒙面人死亡收尾(this: void, 参数: 剧情动作参数表): void {
  const 固定掉落物品名 = String(参数.固定掉落物品名 ?? "");
  const 固定掉落物品ID = stringToFourCCSafe(按名字反查物品ID(固定掉落物品名));
  if (固定掉落物品ID > 0) {
    CreateItem(固定掉落物品ID, Number(参数.固定掉落X) || 15678.8, Number(参数.固定掉落Y) || -29965.6);
  }

  const 长老 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (!句柄有效(长老)) return;
  SetUnitX(长老, Number(参数.族长新位置X) || 28775.2);
  SetUnitY(长老, Number(参数.族长新位置Y) || -28660.2);
}

export const 第一章最终Boss教派死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_蒙面人死亡": 执行蒙面人死亡,
  "SW01死亡事件_蒙面人死亡残影遁走": 执行蒙面人死亡残影遁走,
  "SW01死亡事件_蒙面人死亡胜利音乐": 执行蒙面人死亡胜利音乐,
  "SW01死亡事件_蒙面人死亡释放玩家": 执行蒙面人死亡释放玩家,
  "SW01死亡事件_蒙面人死亡关闭电影模式": 执行蒙面人死亡关闭电影模式,
  "SW01死亡事件_蒙面人死亡收尾": 执行蒙面人死亡收尾,
};

注册剧情片段清理("jlc_cult_final_boss_death", 清理蒙面人死亡现场);
