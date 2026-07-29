/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { 按结算键执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  按结算键执行Boss死亡结算: (this: void, 结算键: string, Boss单位?: any, 击杀者?: any) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
export { 教派最终Boss死亡剧情片段 } from "../01．第一章/17．第一章最终Boss教派死亡";

const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const CreateItem = jass.CreateItem as (this: void, itemTypeId: number, x: number, y: number) => any;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const UnitSuspendDecay = jass.UnitSuspendDecay as (this: void, whichUnit: any, flag: boolean) => void;

export function 执行蒙面人死亡(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  const dyingTypeId = GetUnitTypeId(dyingUnit);
  if (dyingTypeId !== stringToFourCCSafe("N05N") && dyingTypeId !== stringToFourCCSafe("N05M")) return;

  UnitSuspendDecay(dyingUnit, true);
  按结算键执行Boss死亡结算("蒙面人", dyingUnit);

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

export const 第一章最终Boss教派死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_蒙面人死亡": 执行蒙面人死亡,
};
