/** @noSelfInFile */

const jass = require("jass.common") as any;
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { 通用物品ID, 通用物品配置 } = require("./00．通用物品配置") as {
  通用物品ID: {
    获取特效: number;
  };
  通用物品配置: {
    获取特效路径: string;
    获取特效持续时间: number;
    获取特效角度: number;
    获取特效尺寸: number;
  };
};
const { 删除物品 } = require("./00．通用物品工具") as {
  删除物品: (this: void, 物品: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

export function 处理通用物品获取特效(this: void, 单位: any, 物品: any): void {
  if (物品 == null || 物品 === 0) return;
  if (通用物品ID.获取特效 <= 0) return;
  if (GetItemTypeId(物品) !== 通用物品ID.获取特效) return;
  删除物品(物品);
  EC_CreateEffect(
    通用物品配置.获取特效路径,
    GetUnitX(单位),
    GetUnitY(单位),
    0,
    通用物品配置.获取特效角度,
    通用物品配置.获取特效尺寸,
    1,
    通用物品配置.获取特效持续时间,
  );
}

export {};
