/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import { 创建技能提示圈 } from "../../02．通用函数/16．技能提示圈工厂";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;

export interface 圆形安全区配置 {
  ID: string;
  X: number;
  Y: number;
  半径: number;
  名称?: string;
}

export interface 圆形安全区组参数 {
  清理?: 机制清理篮子;
  名称: string;
  安全区列表: 圆形安全区配置[];
  默认显示提示?: boolean;
  提示持续秒?: number;
}

export interface 圆形安全区组 {
  readonly 名称: string;
  取列表(): 圆形安全区配置[];
  取安全区(ID: string): 圆形安全区配置 | undefined;
  点是否安全(x: number, y: number): boolean;
  单位是否安全(单位: any): boolean;
  显示提示(持续秒?: number): void;
  销毁(): void;
}

function 距离平方(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return dx * dx + dy * dy;
}

class 圆形安全区组实现 implements 圆形安全区组 {
  readonly 名称: string;
  private 参数: 圆形安全区组参数;
  private 已销毁 = false;

  constructor(参数: 圆形安全区组参数) {
    this.名称 = 参数.名称;
    this.参数 = 参数;
    if (参数.默认显示提示) this.显示提示(参数.提示持续秒);
  }

  取列表(): 圆形安全区配置[] {
    return this.参数.安全区列表;
  }

  取安全区(ID: string): 圆形安全区配置 | undefined {
    const 列表 = this.参数.安全区列表;
    for (let i = 0; i < 列表.length; i++) {
      if (列表[i].ID === ID) return 列表[i];
    }
    return undefined;
  }

  点是否安全(x: number, y: number): boolean {
    const 列表 = this.参数.安全区列表;
    for (let i = 0; i < 列表.length; i++) {
      const 区 = 列表[i];
      if (距离平方(x, y, 区.X, 区.Y) <= 区.半径 * 区.半径) return true;
    }
    return false;
  }

  单位是否安全(单位: any): boolean {
    if (单位 == null || 单位 === 0) return false;
    return this.点是否安全(GetUnitX(单位), GetUnitY(单位));
  }

  显示提示(持续秒?: number): void {
    const 列表 = this.参数.安全区列表;
    for (let i = 0; i < 列表.length; i++) {
      const 区 = 列表[i];
      创建技能提示圈({
        类型: "白色安全圆",
        X: 区.X,
        Y: 区.Y,
        半径: 区.半径,
        持续时间: 持续秒 ?? this.参数.提示持续秒 ?? 3,
      });
    }
  }

  销毁(): void {
    this.已销毁 = true;
  }
}

export function 创建圆形安全区组(this: void, 参数: 圆形安全区组参数): 圆形安全区组 {
  const 实例 = new 圆形安全区组实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 圆形安全区组清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}
