/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
};
const 猎魂接见暂停来源 = "剧情系统:猎魂接见";

const { YDUserDataClearSafe, YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";
export { 克林姆德国王委托剧情片段 } from "../02．第二章/24．克林姆德王接见";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;

const bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED as number;

export function 执行克林姆德王接见(this: void, 参数: 剧情动作参数表): void {
  YDUserDataClearSafe("string", "主线NPC", "jl禁军门卫", "unit");
  YDUserDataClearSafe("string", "主线NPC", "jl禁军门卫2", "unit");

  const 猎魂引用 = YDUserDataGetSafe("string", "jq", "npc", "unit");
  if (猎魂引用 != null && 猎魂引用 !== 0) {
    SetUnitInvulnerable(猎魂引用, true);
    添加单位暂停(猎魂引用, 猎魂接见暂停来源);
  }

  const 卫队单位 = YDUserDataGetSafe("string", "主线NPC", "jlw", "unit");
  if (卫队单位 != null && 卫队单位 !== 0) {
    SetUnitOwner(卫队单位, Player(6), true);
  }

  const 猎魂类型ID = stringToFourCCSafe("ohun");
  if (!(猎魂类型ID > 0)) return;
  const 猎魂 = CreateUnit(
    Player(jass.PLAYER_NEUTRAL_AGGRESSIVE as number),
    猎魂类型ID,
    Number(参数.猎魂位置X) || -2823.1,
    Number(参数.猎魂位置Y) || -14119.8,
    180,
  );
  if (猎魂 == null || 猎魂 === 0) return;
  YDUserDataSetSafe("string", "jq", "npc", "unit", 猎魂);
}

function 执行发布巨魔线任务(this: void): void {}

export function 执行接见金币提示(this: void, 参数: 剧情动作参数表): void {
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_ITEMACQUIRED,
    文本: String(参数.提示文本 ?? "|cffffff00『系统提示』：|r所有英雄收到了|cffffff0015000金币！|r"),
  });
}

export const 克林姆德王接见剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_克林姆德王接见": 执行克林姆德王接见,
  "JLC精灵城_接见金币提示": 执行接见金币提示,
  "JLC精灵城_发布巨魔线任务": 执行发布巨魔线任务,
};
