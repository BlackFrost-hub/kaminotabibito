/** @noSelfInFile */

import { 创建Boss层数状态集, Boss层数状态定义, Boss层数状态集 } from "../01．层数状态/02．Boss层数状态集";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

export interface 单位状态表参数 {
  清理?: 机制清理篮子;
  名称: string;
  单位列表?: any[];
  层数状态列表: Boss层数状态定义[];
}

export interface 单位状态表 {
  readonly 层数状态: Boss层数状态集;
  设置单位列表(单位列表: any[]): void;
  取单位列表(): any[];
  增加(状态ID: string, 单位: any, 层数?: number, 原因?: string): number;
  设置(状态ID: string, 单位: any, 层数: number, 原因?: string): number;
  减少(状态ID: string, 单位: any, 层数?: number, 原因?: string): number;
  取层数(状态ID: string, 单位: any): number;
  清空单位(单位: any, 原因?: string): void;
  清空全部单位(原因?: string): void;
  销毁(): void;
}

class 单位状态表实现 implements 单位状态表 {
  readonly 层数状态: Boss层数状态集;
  private 单位列表: any[] = [];

  constructor(参数: 单位状态表参数) {
    this.层数状态 = 创建Boss层数状态集(参数.层数状态列表);
    this.设置单位列表(参数.单位列表 ?? []);
  }

  设置单位列表(单位列表: any[]): void {
    this.单位列表 = [];
    for (let i = 0; i < 单位列表.length; i++) this.单位列表.push(单位列表[i]);
  }

  取单位列表(): any[] {
    const result: any[] = [];
    for (let i = 0; i < this.单位列表.length; i++) result.push(this.单位列表[i]);
    return result;
  }

  增加(状态ID: string, 单位: any, 层数: number = 1, 原因: string = "单位状态增加"): number {
    return this.层数状态.增加(状态ID, 单位, 层数, 原因);
  }

  设置(状态ID: string, 单位: any, 层数: number, 原因: string = "单位状态设置"): number {
    return this.层数状态.设置(状态ID, 单位, 层数, 原因);
  }

  减少(状态ID: string, 单位: any, 层数: number = 1, 原因: string = "单位状态减少"): number {
    return this.层数状态.减少(状态ID, 单位, 层数, 原因);
  }

  取层数(状态ID: string, 单位: any): number {
    return this.层数状态.取层数(状态ID, 单位);
  }

  清空单位(单位: any, 原因: string = "单位状态清空"): void {
    this.层数状态.清空单位全部(单位, 原因);
  }

  清空全部单位(原因: string = "单位状态清空全部"): void {
    for (let i = 0; i < this.单位列表.length; i++) this.清空单位(this.单位列表[i], 原因);
  }

  销毁(): void {
    this.清空全部单位("单位状态销毁");
    this.层数状态.销毁();
  }
}

export function 创建单位状态表(this: void, 参数: 单位状态表参数): 单位状态表 {
  const 表 = new 单位状态表实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 单位状态表清理(this: void): void {
      表.销毁();
    });
  }
  return 表;
}
