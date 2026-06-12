/** @noSelfInFile */

const jass = require("jass.common") as any;

import { KEY_F, registerKeyUpSync } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { 切换首领奖励选择界面 } from "./05．奖励选择界面";
import { 获取首领奖励待选择记录 } from "./09．待选择奖励";

let 热键已注册 = false;

const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (玩家: any, x: number, y: number, 持续时间: number, 文本: string) => void;

function 提示玩家(this: void, 玩家: any, 文本: string): void {
  if (玩家 == null || 玩家 === 0) return;
  DisplayTimedTextToPlayer(玩家, 0, 0, 6, "|cffffcc00[首领奖励]|r " + 文本);
}

function F7打开待选择首领奖励(this: any, 玩家: any, _key: number): void {
  const 记录 = 获取首领奖励待选择记录(玩家);
  if (记录 == null) {
    提示玩家(玩家, "当前没有待选择的首领奖励。");
    return;
  }
  切换首领奖励选择界面(记录.奖励池ID, 玩家);
}

export function 注册首领奖励待选择热键(this: void): void {
  if (热键已注册) return;
  热键已注册 = true;
  registerKeyUpSync(KEY_F.F7, F7打开待选择首领奖励);
}
