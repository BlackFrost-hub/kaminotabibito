/** @noSelfInFile */

const jass = require("jass.common") as any;
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 通用物品ID, 通用物品配置 } = require("../00．通用物品配置") as {
  通用物品ID: {
    传送门_万浴熔灵: number;
  };
  通用物品配置: {
    万浴熔灵镜头X: number;
    万浴熔灵镜头Y: number;
    万浴熔灵传送X: number;
    万浴熔灵传送Y: number;
  };
};
const { 删除物品 } = require("../00．通用物品工具") as {
  删除物品: (this: void, 物品: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;

export function 处理万浴熔灵传送门(this: void, 单位: any, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  if (通用物品ID.传送门_万浴熔灵 <= 0) return;
  if (GetItemTypeId(物品) !== 通用物品ID.传送门_万浴熔灵) return;

  StarOther_PanCameraToTimedForPlayer(
    GetOwningPlayer(单位),
    通用物品配置.万浴熔灵镜头X,
    通用物品配置.万浴熔灵镜头Y,
    0,
  );
  SetUnitPosition(单位, 通用物品配置.万浴熔灵传送X, 通用物品配置.万浴熔灵传送Y);
  删除物品(物品);
}

export {};
