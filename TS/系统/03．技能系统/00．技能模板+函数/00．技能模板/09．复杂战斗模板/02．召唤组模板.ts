/** @noSelfInFile */

import {
  创建机制单位生命周期,
  type 机制单位生命周期参数,
  type 机制单位生命周期实例,
  type 机制单位生命周期结束原因,
} from "./00．机制单位生命周期模板";
import { 创建召唤物组状态, type 召唤物组状态 } from "../../04．机制组件/10．复杂战斗通用机制/03．召唤物组状态管理";
import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, targetWidget: any) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (whichUnit: any, order: string, x: number, y: number) => boolean;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

/** 主人死亡清理登记（主人 handleId → 清理函数数组）；策略="清理" 时登记 */
const 主人死亡清理表: Record<number, (() => void)[] | undefined> = {};
let 主人死亡监听已注册 = false;

function 召唤组主人死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  const id = GetHandleId(dyingUnit);
  const 列表 = 主人死亡清理表[id];
  if (列表 == null) return;
  delete 主人死亡清理表[id];
  for (let i = 0; i < 列表.length; i++) {
    if (列表[i] != null) 列表[i]();
  }
}

function 确保主人死亡监听(this: void): void {
  if (主人死亡监听已注册) return;
  主人死亡监听已注册 = true;
  registerDeathListener(召唤组主人死亡清理);
}

export interface 召唤单位参数 extends 机制单位生命周期参数 {
  攻击目标?: any;
  /** 命令；null / 空串 = 不下令（仅站桩） */
  命令?: string | null;
  命令X?: number;
  命令Y?: number;
}

export interface 召唤组模板参数 {
  清理?: 机制清理篮子;
  名称: string;
  单位列表: 召唤单位参数[];
  全灭延迟秒?: number;
  /** 组主人：用于主人死亡清理策略 */
  主人?: any;
  /** 主人死亡策略："清理"=主人死亡时销毁整个组；"保留"（默认）=不监听 */
  主人死亡策略?: "清理" | "保留";
  /** 按索引生成位置：单位参数未提供位置时按索引/数量生成 */
  按索引位置?: (this: void, index: number, 数量: number) => { X: number; Y: number };
  on单位创建?: (this: void, 实例: 机制单位生命周期实例, index: number) => void;
  on单位结束?: (this: void, 实例: 机制单位生命周期实例, 原因: 机制单位生命周期结束原因, index: number) => void;
  on全部死亡?: (this: void, 组: 召唤物组状态) => void;
}

export interface 召唤组实例 {
  readonly 组状态: 召唤物组状态;
  取实例列表(): 机制单位生命周期实例[];
  创建全部(): void;
  销毁(): void;
}

class 召唤组实现 implements 召唤组实例 {
  readonly 组状态: 召唤物组状态;
  private 参数: 召唤组模板参数;
  private 实例列表: 机制单位生命周期实例[] = [];
  private 已创建 = false;
  private 主人清理已登记 = false;
  private 主人清理函数?: () => void;

  constructor(参数: 召唤组模板参数) {
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
    const 数量 = this.参数.单位列表.length;
    for (let i = 0; i < 数量; i++) {
      const 单位参数 = { ...this.参数.单位列表[i] } as 召唤单位参数;
      // 按索引生成位置：单位参数未提供位置且调用方给出生成器时填充
      if (this.参数.按索引位置 != null) {
        const 位置 = this.参数.按索引位置(i, 数量);
        if ((单位参数.X == null || 单位参数.X === 0) && (单位参数.Y == null || 单位参数.Y === 0)) {
          单位参数.X = 位置.X;
          单位参数.Y = 位置.Y;
        }
      }
      this.创建单个(i, 单位参数);
    }
    this.登记主人死亡清理();
  }

  销毁(): void {
    for (let i = 0; i < this.实例列表.length; i++) {
      const 实例 = this.实例列表[i];
      if (实例 != null) 实例.销毁("手动销毁");
    }
    this.实例列表 = [];
    this.组状态.销毁();
    this.注销主人死亡清理();
  }

  private 登记主人死亡清理(): void {
    if (this.主人清理已登记) return;
    const 主人 = this.参数.主人;
    if (主人 == null || 主人 === 0) return;
    if (this.参数.主人死亡策略 !== "清理") return;
    const id = GetHandleId(主人);
    const self = this;
    const 清理函数 = function 召唤组主人死亡销毁(this: void): void {
      self.销毁();
    };
    let 列表 = 主人死亡清理表[id];
    if (列表 == null) {
      列表 = [];
      主人死亡清理表[id] = 列表;
    }
    列表.push(清理函数);
    this.主人清理函数 = 清理函数;
    this.主人清理已登记 = true;
    确保主人死亡监听();
  }

  private 注销主人死亡清理(): void {
    if (!this.主人清理已登记) return;
    this.主人清理已登记 = false;
    const 主人 = this.参数.主人;
    if (主人 == null || 主人 === 0) return;
    const id = GetHandleId(主人);
    const 列表 = 主人死亡清理表[id];
    if (列表 != null) {
      const 清理函数 = this.主人清理函数;
      if (清理函数 != null) {
        const index = 列表.indexOf(清理函数);
        if (index >= 0) 列表.splice(index, 1);
      }
      if (列表.length <= 0) delete 主人死亡清理表[id];
    }
    this.主人清理函数 = undefined;
  }

  private 创建单个(index: number, 单位参数: 召唤单位参数): void {
    const self = this;
    const 实例 = 创建机制单位生命周期({
      ...单位参数,
      清理: 单位参数.清理 ?? this.参数.清理,
      on创建: function 召唤组单位创建(this: void, created: 机制单位生命周期实例): void {
        self.组状态.登记(created.单位);
        self.下达命令(created, 单位参数);
        if (单位参数.on创建 != null) 单位参数.on创建(created);
        if (self.参数.on单位创建 != null) self.参数.on单位创建(created, index);
      },
      on结束: function 召唤组单位结束(this: void, ended: 机制单位生命周期实例, 原因: 机制单位生命周期结束原因): void {
        if (单位参数.on结束 != null) 单位参数.on结束(ended, 原因);
        if (self.参数.on单位结束 != null) self.参数.on单位结束(ended, 原因, index);
      },
    });
    if (实例 != null) this.实例列表.push(实例);
  }

  private 下达命令(实例: 机制单位生命周期实例, 单位参数: 召唤单位参数): void {
    // 兼容：不传/null → "attack"（原行为）；显式空串 "" → 不下令（仅站桩）
    const order = 单位参数.命令 == null ? "attack" : 单位参数.命令;
    if (order === "") return;
    if (单位参数.攻击目标 != null && 单位参数.攻击目标 !== 0) {
      IssueTargetOrder(实例.单位, order, 单位参数.攻击目标);
      return;
    }
    if (单位参数.命令X != null && 单位参数.命令Y != null) {
      IssuePointOrder(实例.单位, order, 单位参数.命令X, 单位参数.命令Y);
    }
  }
}

export function 创建召唤组(this: void, 参数: 召唤组模板参数): 召唤组实例 {
  const 实例 = new 召唤组实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 召唤组清理(this: void): void {
      实例.销毁();
    });
  }
  实例.创建全部();
  return 实例;
}

export {};
