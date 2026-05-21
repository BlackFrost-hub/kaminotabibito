/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;

const 暴击率属性名 = "暴击率";
const 暴击伤害属性名 = "暴击伤害";

function 读取玩家实数属性(this: void, unit: any, 属性名: string): number {
  if (unit == null || unit === 0) return 0;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return 0;
  return Number(YDUserDataGetSafe("player", owner, 属性名, "real")) || 0;
}

export function 读取玩家暴击率(this: void, unit: any): number {
  return 读取玩家实数属性(unit, 暴击率属性名);
}

export function 读取玩家暴击伤害(this: void, unit: any): number {
  return 读取玩家实数属性(unit, 暴击伤害属性名);
}
