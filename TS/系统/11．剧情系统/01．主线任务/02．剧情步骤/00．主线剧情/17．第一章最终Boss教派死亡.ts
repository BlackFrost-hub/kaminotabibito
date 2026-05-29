/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按结算键获取Boss死亡结算配置, 执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.05．Boss死亡结算.03．核心逻辑") as {
  按结算键获取Boss死亡结算配置: (this: void, 结算键: string) => any;
  执行Boss死亡结算: (this: void, 配置: any, Boss单位?: any, 击杀者?: any) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 教派最终Boss死亡剧情片段 } from "../01．第一章/17．第一章最终Boss教派死亡";

const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const UnitSuspendDecay = jass.UnitSuspendDecay as (this: void, whichUnit: any, flag: boolean) => void;

export function 执行蒙面人死亡(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  const dyingTypeId = GetUnitTypeId(dyingUnit);
  if (dyingTypeId !== stringToFourCCSafe("N05N") && dyingTypeId !== stringToFourCCSafe("N05M")) return;

  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 18);
  UnitSuspendDecay(dyingUnit, true);
  const 结算配置 = 按结算键获取Boss死亡结算配置("蒙面人");
  if (结算配置 != null) {
    执行Boss死亡结算(结算配置, dyingUnit);
  }

  const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
    YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  };
  const 长老 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (长老 != null && 长老 !== 0) {
    SetUnitPosition(长老, Number(参数.族长新位置X) || 28775.2, Number(参数.族长新位置Y) || -28660.2);
  }
}

function 执行第一章完成任务刷新(this: void): void {}

export const 第一章最终Boss教派死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_蒙面人死亡": 执行蒙面人死亡,
  "JLC精灵村_第一章完成任务刷新": 执行第一章完成任务刷新,
};
