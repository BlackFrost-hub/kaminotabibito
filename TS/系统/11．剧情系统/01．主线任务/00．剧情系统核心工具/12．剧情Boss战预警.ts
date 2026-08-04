/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
import { 读取剧情进度 } from "./01．剧情动作上下文";

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitName = jass.GetUnitName as (this: void, whichUnit: any) => string;

/** 从该进度起，Boss 预置完成后提前向全队发出战前提示。 */
const 主线Boss战前提示最低进度 = 22;
const 已发布主线Boss战前提示: Record<number, boolean> = {};

export function 发布主线Boss战前提示(this: void, bossUnit: any): void {
  if (bossUnit == null || bossUnit === 0) return;
  if (读取剧情进度() < 主线Boss战前提示最低进度) return;

  const handleId = GetHandleId(bossUnit);
  if (!(handleId > 0) || 已发布主线Boss战前提示[handleId] === true) return;
  已发布主线Boss战前提示[handleId] = true;

  const bossName = GetUnitName(bossUnit) || "未知Boss";
  QuestMessageBJ(
    GetPlayersAll(),
    jglobals.bj_QUESTMESSAGE_ALWAYSHINT,
    `|cffffff00『系统消息』：|r|cffff0000接下来将挑战 Boss：${bossName}，请做好战斗准备。|r`,
  );
}
