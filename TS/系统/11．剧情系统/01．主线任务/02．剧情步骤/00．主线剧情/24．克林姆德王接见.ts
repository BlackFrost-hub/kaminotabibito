/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => () => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度, 写入当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";
import { 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
export { 克林姆德国王委托剧情片段 } from "../02．第二章/24．克林姆德王接见";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const TriggerAddAction = jass.TriggerAddAction as (this: void, whichTrigger: any, action: (this: void) => void) => any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

const bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED as number;

function on猎魂范围触发(this: void): void {
  if (读取剧情进度() !== 25) return;
  const 触发单位 = GetTriggerUnit();
  写入当前剧情动作上下文({
    片段ID: "elven_city_hunter_start",
    触发配置名: "猎魂范围入口",
    触发单位,
  });
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string) => boolean;
  };
  播放主线剧情片段("elven_city_hunter_start");
}

export function 执行克林姆德王接见(this: void): void {}

function 执行创建猎魂入口(this: void, 参数: 剧情动作参数表): void {
  const 猎魂类型ID = stringToFourCCSafe("ohun");
  if (!(猎魂类型ID > 0)) return;
  const 猎魂 = CreateUnit(
    Player(PLAYER_NEUTRAL_AGGRESSIVE),
    猎魂类型ID,
    Number(参数.猎魂位置X) || -2823.1,
    Number(参数.猎魂位置Y) || -14119.8,
    180,
  );
  if (猎魂 == null || 猎魂 === 0) return;
  注册剧情运行时单位("剧情运行时.猎魂", 猎魂);
  const trigger = CreateTrigger();
  TriggerAddAction(trigger, on猎魂范围触发);
  registerUnitInRangeTrigger(trigger, 猎魂, 400, null, false);
}

export function 执行接见金币提示(this: void, 参数: 剧情动作参数表): void {
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_ITEMACQUIRED,
    文本: String(参数.提示文本 ?? "|cffffff00『系统提示』：|r所有英雄收到了|cffffff0015000金币！|r"),
  });
}

export const 克林姆德王接见剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_克林姆德王接见": 执行克林姆德王接见,
  "JLC精灵城_接见金币提示": 执行接见金币提示,
  "JLC精灵城_创建猎魂入口": 执行创建猎魂入口,
};
