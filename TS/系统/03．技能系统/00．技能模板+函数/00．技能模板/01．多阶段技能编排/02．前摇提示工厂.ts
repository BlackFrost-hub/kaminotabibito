/** @noSelfInFile */
/**
 * 前摇提示工厂
 *
 * 给 `开始技能前摇(...)` 提供可直接复用的 `创建提示特效 / 销毁提示特效` 回调组。
 * 保持手写显式组合，但减少重复样板。
 */

const jass = require("jass.common") as any;

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

export function 创建圆形前摇提示(半径: number, 持续时间: number, 来源单位?: any): 前摇提示回调组 {
  return {
    创建提示特效: function (单位: any): any {
      return 创建薄圆形提示圈特效(
        GetUnitX(单位),
        GetUnitY(单位),
        半径,
        持续时间 > 0 ? 1 / 持续时间 : 1.0,
        来源单位 ?? 单位
      );
    },
    销毁提示特效: 默认销毁前摇提示特效,
  };
}

export function 创建矩形前摇提示(宽度: number, 长度: number, 持续时间: number): 前摇提示回调组 {
  return {
    创建提示特效: function (单位: any): any {
      return 创建矩形提示圈特效(
        GetUnitX(单位),
        GetUnitY(单位),
        宽度,
        长度,
        GetUnitFacing(单位),
        持续时间 > 0 ? 1 / 持续时间 : 1.0
      );
    },
    销毁提示特效: 默认销毁前摇提示特效,
  };
}

export function 创建冲锋路径前摇提示(路径长度: number, 路径宽度: number, 持续时间: number): 前摇提示回调组 {
  return 创建矩形前摇提示(路径宽度, 路径长度, 持续时间);
}

export function 创建扇形前摇提示(半径: number, 持续时间: number): 前摇提示回调组 {
  return {
    创建提示特效: function (单位: any): any {
      return 创建红色扇形提示圈特效(
        GetUnitX(单位),
        GetUnitY(单位),
        GetUnitFacing(单位),
        取扇形提示圈尺寸(半径),
        持续时间 > 0 ? 1 / 持续时间 : 1.0
      );
    },
    销毁提示特效: 默认销毁前摇提示特效,
  };
}

export {};
