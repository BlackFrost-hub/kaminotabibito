/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, unit: any, whichGroup: any) => boolean;

export function 是玩家英雄组单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;

  const 玩家英雄单位组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄单位组 != null && 玩家英雄单位组 !== 0) {
    return IsUnitInGroup(unit, 玩家英雄单位组) === true;
  }

  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  return getRegisteredPlayerHero(owner) === unit;
}

export {};
