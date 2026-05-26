/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;

function 读取卫队长(this: void): any {
  return YDUserDataGetSafe("string", "主线NPC", "蛇人族卫队长", "unit");
}

export function 执行蛇人族卫队长入场(this: void, 参数: 剧情动作参数表): void {
  let 队长 = 读取卫队长();
  if (队长 == null || 队长 === 0) {
    const 队长类型ID = stringToFourCCSafe("h01D");
    if (!(队长类型ID > 0)) return;
    队长 = CreateUnit(Player(6), 队长类型ID, Number(参数.出生X) || -22935.9, Number(参数.出生Y) || 3154.3, 0);
    if (队长 != null && 队长 !== 0) {
      YDUserDataSetSafe("string", "主线NPC", "蛇人族卫队长", "unit", 队长);
    }
  }
  if (队长 == null || 队长 === 0) return;
  IssuePointOrder(队长, "move", Number(参数.目标X) || -21023.4, Number(参数.目标Y) || 3259.5);
}

export function 执行蛇人族护卫对战目标刷新(this: void, 参数: 剧情动作参数表): void {
  const 队长 = 读取卫队长();
  if (队长 == null || 队长 === 0) return;
  SetUnitOwner(队长, Player(PLAYER_NEUTRAL_PASSIVE), true);
  SetUnitPosition(队长, Number(参数.目标X) || -21023.4, Number(参数.目标Y) || 3259.5);
}

export const 蛇人族卫队长试炼剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_卫队长入场": 执行蛇人族卫队长入场,
  "SRZ蛇人族_护卫对战目标刷新": 执行蛇人族护卫对战目标刷新,
};
