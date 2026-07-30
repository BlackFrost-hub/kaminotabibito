/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import { 创建技能提示圈 } from "../../02．通用函数/16．技能提示圈工厂";
import { stringToFourCC, 距离平方XY } from "../../02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (min: number, max: number) => number;

const { DzDoodadCreate, DzDoodadSetModel, DzDoodadSetVisible, DzDoodadRemove } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadCreate: (this: void, id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number;
  DzDoodadSetModel: (this: void, doodad: number, modelFile: string) => void;
  DzDoodadSetVisible: (this: void, doodad: number, enable: boolean) => void;
  DzDoodadRemove: (this: void, doodad: number) => void;
};

export interface 动态装饰物安全区点位 {
  ID?: string;
  X: number;
  Y: number;
  半径: number;
  朝向?: number;
  模型路径?: string;
}

export interface 动态装饰物安全区 {
  ID: string;
  X: number;
  Y: number;
  半径: number;
  装饰物: number;
}

export interface 动态装饰物安全区组参数 {
  清理?: 机制清理篮子;
  名称: string;
  装饰物ID: string | number;
  点位列表: 动态装饰物安全区点位[];
  默认模型路径?: string;
  变量ID?: number;
  随机样式最小ID?: number;
  随机样式最大ID?: number;
  Z?: number;
  缩放?: number;
  默认显示提示?: boolean;
  提示持续秒?: number;
  来源单位?: any;
}

export interface 动态装饰物安全区组 {
  readonly 名称: string;
  取列表(): 动态装饰物安全区[];
  点是否安全(x: number, y: number): boolean;
  单位是否安全(unit: any): boolean;
  显示提示(持续秒?: number): void;
  隐藏(): void;
  销毁(): void;
}

function 转装饰物ID(this: void, id: string | number): number {
  return typeof id === "number" ? id : stringToFourCC(id);
}

class 动态装饰物安全区组实现 implements 动态装饰物安全区组 {
  readonly 名称: string;
  private 参数: 动态装饰物安全区组参数;
  private 列表: 动态装饰物安全区[] = [];
  private 已销毁 = false;

  constructor(参数: 动态装饰物安全区组参数) {
    this.名称 = 参数.名称;
    this.参数 = 参数;
    this.创建全部();
    if (参数.默认显示提示) this.显示提示(参数.提示持续秒);
  }

  取列表(): 动态装饰物安全区[] {
    const result: 动态装饰物安全区[] = [];
    for (let i = 0; i < this.列表.length; i++) result.push(this.列表[i]);
    return result;
  }

  点是否安全(x: number, y: number): boolean {
    for (let i = 0; i < this.列表.length; i++) {
      const 区 = this.列表[i];
      if (距离平方XY(x, y, 区.X, 区.Y) <= 区.半径 * 区.半径) return true;
    }
    return false;
  }

  单位是否安全(unit: any): boolean {
    if (unit == null || unit === 0) return false;
    return this.点是否安全(GetUnitX(unit), GetUnitY(unit));
  }

  显示提示(持续秒?: number): void {
    const duration = 持续秒 ?? this.参数.提示持续秒 ?? 3;
    for (let i = 0; i < this.列表.length; i++) {
      const 区 = this.列表[i];
      创建技能提示圈({
        类型: "白色安全圆",
        X: 区.X,
        Y: 区.Y,
        半径: 区.半径,
        持续时间: duration,
        来源单位: this.参数.来源单位,
      });
    }
  }

  隐藏(): void {
    for (let i = 0; i < this.列表.length; i++) {
      const 区 = this.列表[i];
      if (区.装饰物 != null && 区.装饰物 !== 0) DzDoodadSetVisible(区.装饰物, false);
    }
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    for (let i = 0; i < this.列表.length; i++) {
      const 区 = this.列表[i];
      if (区.装饰物 != null && 区.装饰物 !== 0) DzDoodadRemove(区.装饰物);
    }
    this.列表 = [];
  }

  private 创建全部(): void {
    const doodadId = 转装饰物ID(this.参数.装饰物ID);
    const z = this.参数.Z ?? 0;
    const scale = this.参数.缩放 ?? 1;
    for (let i = 0; i < this.参数.点位列表.length; i++) {
      const 点 = this.参数.点位列表[i];
      let varId = this.参数.变量ID ?? 0;
      const minVarId = this.参数.随机样式最小ID;
      const maxVarId = this.参数.随机样式最大ID;
      if (minVarId != null && maxVarId != null && maxVarId >= minVarId) varId = GetRandomInt(minVarId, maxVarId);
      const doodad = DzDoodadCreate(doodadId, varId, 点.X, 点.Y, z, 点.朝向 ?? 0, scale);
      const model = 点.模型路径 ?? this.参数.默认模型路径;
      if (model != null && model !== "") DzDoodadSetModel(doodad, model);
      this.列表.push({
        ID: 点.ID ?? ("安全区" + (i + 1)),
        X: 点.X,
        Y: 点.Y,
        半径: 点.半径,
        装饰物: doodad,
      });
    }
  }
}

export function 创建动态装饰物安全区组(this: void, 参数: 动态装饰物安全区组参数): 动态装饰物安全区组 {
  const 实例 = new 动态装饰物安全区组实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 动态装饰物安全区组清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}

export {};
