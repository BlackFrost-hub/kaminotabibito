/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 通用物品ID } = require("./00．通用物品配置") as {
  通用物品ID: {
    领取技能: number;
  };
};
const { 删除物品 } = require("./00．通用物品工具") as {
  删除物品: (this: void, 物品: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (player: any, x: number, y: number, duration: number, message: string) => void;

export function 处理通用物品领取技能(this: void, 单位: any, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  if (通用物品ID.领取技能 <= 0) return;
  if (GetItemTypeId(物品) !== 通用物品ID.领取技能) return;

  删除物品(物品);
  const 玩家 = GetOwningPlayer(单位);
  const 技能ID = YDUserDataGetSafe("player", 玩家, "FF", "abilcode");
  const 已领取 = YDUserDataGetSafe("player", 玩家, "FF领取", "boolean") === true;
  if (技能ID == null || 技能ID === 0 || 已领取) return;

  DisplayTimedTextToPlayer(玩家, 0, 0, 6, "（领取成功）");
  YDUserDataSetSafe("player", 玩家, "FF领取", "boolean", true);
  UnitAddAbility(单位, 技能ID);
}

export {};
