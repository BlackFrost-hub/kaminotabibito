/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { 通用物品ID, 通用物品配置 } = require("../00．通用物品配置") as {
  通用物品ID: {
    传送门_万浴熔灵: number;
  };
  通用物品配置: {
    万浴熔灵镜头矩形: string;
    万浴熔灵传送X: number;
    万浴熔灵传送Y: number;
  };
};
const { 删除物品 } = require("../00．通用物品工具") as {
  删除物品: (this: void, 物品: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;

function 获取万浴熔灵镜头矩形(this: void): any {
  return (jglobals as any)[通用物品配置.万浴熔灵镜头矩形];
}

export function 处理万浴熔灵传送门(this: void, 单位: any, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  if (通用物品ID.传送门_万浴熔灵 <= 0) return;
  if (GetItemTypeId(物品) !== 通用物品ID.传送门_万浴熔灵) return;

  const 镜头矩形 = 获取万浴熔灵镜头矩形();
  if (镜头矩形 != null && 镜头矩形 !== 0) {
    StarOther_PanCameraToTimedForPlayer(GetOwningPlayer(单位), GetRectCenterX(镜头矩形), GetRectCenterY(镜头矩形), 0);
  }
  SetUnitPosition(单位, 通用物品配置.万浴熔灵传送X, 通用物品配置.万浴熔灵传送Y);
  删除物品(物品);
}

export {};
