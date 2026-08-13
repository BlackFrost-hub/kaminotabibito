import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import {
  定位并登记王宫密室剧情单位,
  读取或创建并定位王宫密室剧情单位,
  王宫密室对峙镜头预设,
  王宫密室场景站位表,
  播放王宫密室演出特效,
} from "./33A．王宫密室场景单位";
import { 归位内务总管语维 } from "./31．王城紧急会议";
import { 应用剧情电影镜头 } from "../../00．剧情系统核心工具/12．剧情电影镜头";
export { 章节末最终收束剧情片段 } from "../02．第二章/34．第二章后续承接";

const jass = require("jass.common") as any;
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 打开Boss死亡首领奖励UI } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  打开Boss死亡首领奖励UI: (this: void, 奖励池ID: string | undefined) => void;
};
const { 里科特奖励池ID } = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.15．主线_里科特战利品") as {
  里科特奖励池ID: string;
};

const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;
const Player = jass.Player as (this: void, playerId: number) => any;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;

const 第二章战后对白玩家引用 = "剧情运行时.第二章战后对白玩家";

function 登记第二章战后对白玩家(this: void): void {
  const 玩家单位 = getRegisteredPlayerHero(Player(0));
  if (玩家单位 != null && 玩家单位 !== 0) 注册剧情运行时单位(第二章战后对白玩家引用, 玩家单位);
}

export function 执行章节末最终收束(this: void, 参数: 剧情动作参数表): void {
  登记第二章战后对白玩家();
  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 35);
}

export function 执行语维章节末归位(this: void): void {
  归位内务总管语维();
}

export function 执行布置王宫密室受伤现场(this: void): void {
  const 旧里科特 = 读取语义单位引用("Boss.里科特");
  if (旧里科特 != null && 旧里科特 !== 0) RemoveUnit(旧里科特);
  YDUserDataClearSafe("string", "Boss", "里科特", "unit");
  清理剧情运行时单位("Boss.里科特");

  const 里科特剧情壳 = 读取或创建并定位王宫密室剧情单位(
    "Boss.里科特",
    "里科特",
    王宫密室场景站位表.里科特密室,
  );
  if (里科特剧情壳 != null && 里科特剧情壳 !== 0) {
    PauseUnit(里科特剧情壳, true);
    SetUnitInvulnerable(里科特剧情壳, true);
  }
  定位并登记王宫密室剧情单位("ZX.克林姆德王", "主线NPC.克林姆德王", 王宫密室场景站位表.克林姆德王受伤);
  定位并登记王宫密室剧情单位("ZX.赫克提尔", "主线NPC.赫克提尔", 王宫密室场景站位表.赫克提尔受伤);
  应用剧情电影镜头(王宫密室对峙镜头预设, 0);
}

export function 执行里科特战后撤离(this: void): void {
  播放王宫密室演出特效("里科特战后撤离", 王宫密室场景站位表.里科特密室);
  const 里科特 = 读取语义单位引用("Boss.里科特");
  if (里科特 != null && 里科特 !== 0) RemoveUnit(里科特);
  YDUserDataClearSafe("string", "Boss", "里科特", "unit");
  清理剧情运行时单位("Boss.里科特");
}

export function 执行打开里科特首领奖励(this: void): void {
  addDelayedCallback(100, function on里科特承接对白结束(): void {
    打开Boss死亡首领奖励UI(里科特奖励池ID);
  });
}

export const 第二章后续承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_章节末最终收束": 执行章节末最终收束,
  "JLC精灵城_语维章节末归位": 执行语维章节末归位,
  "JLC精灵城_布置王宫密室受伤现场": 执行布置王宫密室受伤现场,
  "JLC精灵城_里科特战后撤离": 执行里科特战后撤离,
  "主线.打开里科特首领奖励": 执行打开里科特首领奖励,
};
