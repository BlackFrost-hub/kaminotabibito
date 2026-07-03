/** @noSelfInFile */

import {
  创建机制单位生命周期,
  type 机制单位生命周期参数,
  type 机制单位生命周期实例,
  type 机制单位生命周期结束原因,
} from "./02．机制单位生命周期模板";
import { 创建召唤物组状态, type 召唤物组状态 } from "./03．召唤物组状态管理";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, targetWidget: any) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (whichUnit: any, order: string, x: number, y: number) => boolean;

export interface Boss召唤单位参数 extends 机制单位生命周期参数 {
  攻击目标?: any;
  命令?: string;
  命令X?: number;
  命令Y?: number;
}

export interface Boss召唤组模板参数 {
  清理?: 机制清理篮子;
  名称: string;
  单位列表: Boss召唤单位参数[];
  全灭延迟秒?: number;
  on单位创建?: (this: void, 实例: 机制单位生命周期实例, index: number) => void;
  on单位结束?: (this: void, 实例: 机制单位生命周期实例, 原因: 机制单位生命周期结束原因, index: number) => void;
  on全部死亡?: (this: void, 组: 召唤物组状态) => void;
}

export interface Boss召唤组实例 {
  readonly 组状态: 召唤物组状态;
  取实例列表(): 机制单位生命周期实例[];
  创建全部(): void;
  销毁(): void;
}

class Boss召唤组实现 implements Boss召唤组实例 {
  readonly 组状态: 召唤物组状态;
  private 参数: Boss召唤组模板参数;
  private 实例列表: 机制单位生命周期实例[] = [];
  private 已创建 = false;

  constructor(参数: Boss召唤组模板参数) {
    this.参数 = 参数;
    this.组状态 = 创建召唤物组状态({
      清理: 参数.清理,
      名称: 参数.名称,
      全灭延迟秒: 参数.全灭延迟秒,
      on全部死亡: 参数.on全部死亡,
    });
  }

  取实例列表(): 机制单位生命周期实例[] {
    const result: 机制单位生命周期实例[] = [];
    for (let i = 0; i < this.实例列表.length; i++) result.push(this.实例列表[i]);
    return result;
  }

  创建全部(): void {
    if (this.已创建) return;
    this.已创建 = true;
    for (let i = 0; i < this.参数.单位列表.length; i++) {
      this.创建单个(i, this.参数.单位列表[i]);
    }
  }

  销毁(): void {
    for (let i = 0; i < this.实例列表.length; i++) {
      const 实例 = this.实例列表[i];
      if (实例 != null) 实例.销毁("手动销毁");
    }
    this.实例列表 = [];
    this.组状态.销毁();
  }

  private 创建单个(index: number, 单位参数: Boss召唤单位参数): void {
    const self = this;
    const 实例 = 创建机制单位生命周期({
      ...单位参数,
      清理: 单位参数.清理 ?? this.参数.清理,
      on创建: function Boss召唤组单位创建(this: void, created: 机制单位生命周期实例): void {
        self.组状态.登记(created.单位);
        self.下达命令(created, 单位参数);
        if (单位参数.on创建 != null) 单位参数.on创建(created);
        if (self.参数.on单位创建 != null) self.参数.on单位创建(created, index);
      },
      on结束: function Boss召唤组单位结束(this: void, ended: 机制单位生命周期实例, 原因: 机制单位生命周期结束原因): void {
        if (单位参数.on结束 != null) 单位参数.on结束(ended, 原因);
        if (self.参数.on单位结束 != null) self.参数.on单位结束(ended, 原因, index);
      },
    });
    if (实例 != null) this.实例列表.push(实例);
  }

  private 下达命令(实例: 机制单位生命周期实例, 单位参数: Boss召唤单位参数): void {
    const order = 单位参数.命令 ?? "attack";
    if (单位参数.攻击目标 != null && 单位参数.攻击目标 !== 0) {
      IssueTargetOrder(实例.单位, order, 单位参数.攻击目标);
      return;
    }
    if (单位参数.命令X != null && 单位参数.命令Y != null) {
      IssuePointOrder(实例.单位, order, 单位参数.命令X, 单位参数.命令Y);
    }
  }
}

export function 创建Boss召唤组(this: void, 参数: Boss召唤组模板参数): Boss召唤组实例 {
  const 实例 = new Boss召唤组实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function Boss召唤组清理(this: void): void {
      实例.销毁();
    });
  }
  实例.创建全部();
  return 实例;
}

export {};
