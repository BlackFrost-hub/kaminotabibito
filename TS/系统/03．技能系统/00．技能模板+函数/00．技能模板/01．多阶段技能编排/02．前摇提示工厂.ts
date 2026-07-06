/** @noSelfInFile */
/**
 * 前摇提示工厂
 *
 * 给 `开始技能前摇(...)` 提供可直接复用的 `创建提示特效 / 销毁提示特效` 回调组。
 * 保持手写显式组合，但减少重复样板。
 */

const jass = require("jass.common") as any;
import type { 技能距离修正用途, 英雄技能距离修正上下文 } from "../../04．机制组件/11．技能属性修正";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;

const {
  创建矩形提示圈特效,
  创建红色扇形提示圈特效,
  创建薄圆形提示圈特效,
  立即销毁提示圈特效,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建矩形提示圈特效: (this: void, x: number, y: number, width: number, long: number, fac: number, speed?: number) => any;
  创建红色扇形提示圈特效: (this: void, x: number, y: number, fac: number, size: number, speed?: number) => any;
  创建薄圆形提示圈特效: (this: void, x: number, y: number, r: number, speed?: number, 来源单位?: any) => any;
  立即销毁提示圈特效: (this: void, e: any) => void;
};
const { 按英雄技能距离修正上下文修正距离 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index") as {
  按英雄技能距离修正上下文修正距离: (this: void, 基础距离: number, 上下文: any, 默认用途?: string) => number;
};

export interface 前摇提示回调组 {
  创建提示特效: (this: void, 单位: any, 前摇ID: number) => any;
  销毁提示特效: (this: void, 特效句柄: any, 单位: any, 前摇ID: number, 原因: string) => void;
}

function 默认销毁前摇提示特效(特效句柄: any): void {
  立即销毁提示圈特效(特效句柄);
}

function 取扇形提示圈尺寸(半径: number): number {
  if (半径 <= 0) {
    return 0.01;
  }
  return 半径 / 512;
}

function 修正前摇距离(this: void, 基础距离: number, 上下文: 英雄技能距离修正上下文 | undefined, 默认用途: 技能距离修正用途): number {
  return 按英雄技能距离修正上下文修正距离(基础距离, 上下文, 默认用途);
}

export function 创建圆形前摇提示(半径: number, 持续时间: number, 来源单位?: any, 英雄技能距离修正?: 英雄技能距离修正上下文): 前摇提示回调组 {
  return {
    创建提示特效: function (单位: any): any {
      const 修正半径 = 修正前摇距离(半径, 英雄技能距离修正, "效果半径");
      return 创建薄圆形提示圈特效(
        GetUnitX(单位),
        GetUnitY(单位),
        修正半径,
        持续时间 > 0 ? 1 / 持续时间 : 1.0,
        来源单位 ?? 单位
      );
    },
    销毁提示特效: 默认销毁前摇提示特效,
  };
}

export function 创建矩形前摇提示(宽度: number, 长度: number, 持续时间: number, 英雄技能距离修正?: 英雄技能距离修正上下文): 前摇提示回调组 {
  return {
    创建提示特效: function (单位: any): any {
      const 修正长度 = 修正前摇距离(长度, 英雄技能距离修正, "矩形长度");
      return 创建矩形提示圈特效(
        GetUnitX(单位),
        GetUnitY(单位),
        宽度,
        修正长度,
        GetUnitFacing(单位),
        持续时间 > 0 ? 1 / 持续时间 : 1.0
      );
    },
    销毁提示特效: 默认销毁前摇提示特效,
  };
}

export function 创建冲锋路径前摇提示(路径长度: number, 路径宽度: number, 持续时间: number, 英雄技能距离修正?: 英雄技能距离修正上下文): 前摇提示回调组 {
  return 创建矩形前摇提示(路径宽度, 路径长度, 持续时间, 英雄技能距离修正);
}

export function 创建扇形前摇提示(半径: number, 持续时间: number, 英雄技能距离修正?: 英雄技能距离修正上下文): 前摇提示回调组 {
  return {
    创建提示特效: function (单位: any): any {
      const 修正半径 = 修正前摇距离(半径, 英雄技能距离修正, "扇形半径");
      return 创建红色扇形提示圈特效(
        GetUnitX(单位),
        GetUnitY(单位),
        GetUnitFacing(单位),
        取扇形提示圈尺寸(修正半径),
        持续时间 > 0 ? 1 / 持续时间 : 1.0
      );
    },
    销毁提示特效: 默认销毁前摇提示特效,
  };
}

export {};
