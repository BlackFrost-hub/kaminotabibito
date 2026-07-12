/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

export type 联合战斗成员角色 = "主目标" | "护卫" | "搭档" | "机制单位" | (string & {});
export type 联合战斗成员状态 = "未加入" | "活跃" | "失衡" | "锁血" | "崩解" | "倒地" | "离场" | (string & {});

export interface 联合战斗成员定义<TData = Record<string, any>> {
  key: string;
  单位?: any;
  角色: 联合战斗成员角色;
  初始状态?: 联合战斗成员状态;
  数据?: TData;
  参与最终结算: boolean;
  最终状态列表?: 联合战斗成员状态[];
}

export interface 联合战斗成员<TData = Record<string, any>> {
  key: string;
  单位?: any;
  角色: 联合战斗成员角色;
  状态: 联合战斗成员状态;
  数据?: TData;
  参与最终结算: boolean;
  最终状态列表: 联合战斗成员状态[];
}

export interface 联合战斗成员状态变化事件<TData = Record<string, any>> {
  成员: 联合战斗成员<TData>;
  旧状态: 联合战斗成员状态;
  新状态: 联合战斗成员状态;
  原因: string;
}

export interface 联合战斗成员生命周期参数<TData = Record<string, any>> {
  名称: string;
  清理?: 机制清理篮子;
  成员列表?: 联合战斗成员定义<TData>[];
  默认最终状态列表?: 联合战斗成员状态[];
  on状态变化?: (this: void, event: 联合战斗成员状态变化事件<TData>) => void;
  on满足最终结算?: (this: void, 成员列表: 联合战斗成员<TData>[]) => void;
}

export interface 联合战斗成员生命周期<TData = Record<string, any>> {
  readonly 名称: string;
  登记成员(定义: 联合战斗成员定义<TData>): boolean;
  移除成员(key: string): boolean;
  更新单位(key: string, 单位?: any): boolean;
  设置状态(key: string, 状态: 联合战斗成员状态, 原因?: string): boolean;
  写入数据(key: string, 数据?: TData): boolean;
  取成员(key: string): 联合战斗成员<TData> | undefined;
  按单位取成员(单位: any): 联合战斗成员<TData> | undefined;
  取成员列表(): 联合战斗成员<TData>[];
  按角色取成员(角色: 联合战斗成员角色): 联合战斗成员<TData>[];
  按状态取成员(状态: 联合战斗成员状态): 联合战斗成员<TData>[];
  任一满足(判断: (this: void, 成员: 联合战斗成员<TData>) => boolean): boolean;
  全部满足(判断: (this: void, 成员: 联合战斗成员<TData>) => boolean, 只看最终结算成员?: boolean): boolean;
  是否满足最终结算(): boolean;
  已触发最终结算(): boolean;
  销毁(): void;
}

function 复制状态列表(this: void, 列表: 联合战斗成员状态[]): 联合战斗成员状态[] {
  const result: 联合战斗成员状态[] = [];
  for (let i = 0; i < 列表.length; i++) result.push(列表[i]);
  return result;
}

function 状态在列表中(this: void, 状态: 联合战斗成员状态, 列表: 联合战斗成员状态[]): boolean {
  for (let i = 0; i < 列表.length; i++) {
    if (列表[i] === 状态) return true;
  }
  return false;
}

function 取单位句柄ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

class 联合战斗成员生命周期实现<TData> implements 联合战斗成员生命周期<TData> {
  readonly 名称: string;
  private 参数: 联合战斗成员生命周期参数<TData>;
  private 默认最终状态列表: 联合战斗成员状态[];
  private 成员表: Record<string, 联合战斗成员<TData> | undefined> = {};
  private 成员Key列表: string[] = [];
  private 单位到成员Key: Record<number, string | undefined> = {};
  private 最终结算已触发 = false;
  private 已销毁 = false;

  constructor(参数: 联合战斗成员生命周期参数<TData>) {
    this.参数 = 参数;
    this.名称 = 参数.名称;
    this.默认最终状态列表 = 复制状态列表(参数.默认最终状态列表 ?? ["崩解", "倒地", "离场"]);
    const 成员列表 = 参数.成员列表 ?? [];
    for (let i = 0; i < 成员列表.length; i++) this.登记成员(成员列表[i]);
  }

  登记成员(定义: 联合战斗成员定义<TData>): boolean {
    if (this.已销毁 || 定义.key === "" || this.成员表[定义.key] != null) return false;
    const 成员: 联合战斗成员<TData> = {
      key: 定义.key,
      单位: 定义.单位,
      角色: 定义.角色,
      状态: 定义.初始状态 ?? "未加入",
      数据: 定义.数据,
      参与最终结算: 定义.参与最终结算,
      最终状态列表: 复制状态列表(定义.最终状态列表 ?? this.默认最终状态列表),
    };
    this.成员表[定义.key] = 成员;
    this.成员Key列表.push(定义.key);
    this.登记单位映射(成员);
    return true;
  }

  移除成员(key: string): boolean {
    if (this.已销毁) return false;
    const 成员 = this.成员表[key];
    if (成员 == null) return false;
    this.移除单位映射(成员);
    delete this.成员表[key];
    for (let i = 0; i < this.成员Key列表.length; i++) {
      if (this.成员Key列表[i] !== key) continue;
      this.成员Key列表.splice(i, 1);
      break;
    }
    return true;
  }

  更新单位(key: string, 单位?: any): boolean {
    if (this.已销毁) return false;
    const 成员 = this.成员表[key];
    if (成员 == null) return false;
    this.移除单位映射(成员);
    成员.单位 = 单位;
    this.登记单位映射(成员);
    return true;
  }

  设置状态(key: string, 状态: 联合战斗成员状态, 原因: string = "成员状态变化"): boolean {
    if (this.已销毁) return false;
    const 成员 = this.成员表[key];
    if (成员 == null || 状态 === "" || 成员.状态 === 状态) return false;
    const 旧状态 = 成员.状态;
    成员.状态 = 状态;
    if (this.参数.on状态变化 != null) this.参数.on状态变化({ 成员, 旧状态, 新状态: 状态, 原因 });
    this.检查最终结算();
    return true;
  }

  写入数据(key: string, 数据?: TData): boolean {
    if (this.已销毁) return false;
    const 成员 = this.成员表[key];
    if (成员 == null) return false;
    成员.数据 = 数据;
    return true;
  }

  取成员(key: string): 联合战斗成员<TData> | undefined {
    return this.成员表[key];
  }

  按单位取成员(单位: any): 联合战斗成员<TData> | undefined {
    const id = 取单位句柄ID(单位);
    if (id === 0) return undefined;
    const key = this.单位到成员Key[id];
    return key == null ? undefined : this.成员表[key];
  }

  取成员列表(): 联合战斗成员<TData>[] {
    const result: 联合战斗成员<TData>[] = [];
    for (let i = 0; i < this.成员Key列表.length; i++) {
      const 成员 = this.成员表[this.成员Key列表[i]];
      if (成员 != null) result.push(成员);
    }
    return result;
  }

  按角色取成员(角色: 联合战斗成员角色): 联合战斗成员<TData>[] {
    const result: 联合战斗成员<TData>[] = [];
    const 成员列表 = this.取成员列表();
    for (let i = 0; i < 成员列表.length; i++) {
      if (成员列表[i].角色 === 角色) result.push(成员列表[i]);
    }
    return result;
  }

  按状态取成员(状态: 联合战斗成员状态): 联合战斗成员<TData>[] {
    const result: 联合战斗成员<TData>[] = [];
    const 成员列表 = this.取成员列表();
    for (let i = 0; i < 成员列表.length; i++) {
      if (成员列表[i].状态 === 状态) result.push(成员列表[i]);
    }
    return result;
  }

  任一满足(判断: (this: void, 成员: 联合战斗成员<TData>) => boolean): boolean {
    const 成员列表 = this.取成员列表();
    for (let i = 0; i < 成员列表.length; i++) {
      if (判断(成员列表[i])) return true;
    }
    return false;
  }

  全部满足(
    判断: (this: void, 成员: 联合战斗成员<TData>) => boolean,
    只看最终结算成员: boolean = false,
  ): boolean {
    const 成员列表 = this.取成员列表();
    let 已检查数量 = 0;
    for (let i = 0; i < 成员列表.length; i++) {
      const 成员 = 成员列表[i];
      if (只看最终结算成员 && !成员.参与最终结算) continue;
      已检查数量 += 1;
      if (!判断(成员)) return false;
    }
    return 已检查数量 > 0;
  }

  是否满足最终结算(): boolean {
    return this.全部满足(function 联合战斗最终状态判断(this: void, 成员: 联合战斗成员<TData>): boolean {
      return 状态在列表中(成员.状态, 成员.最终状态列表);
    }, true);
  }

  已触发最终结算(): boolean {
    return this.最终结算已触发;
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    this.成员表 = {};
    this.成员Key列表 = [];
    this.单位到成员Key = {};
  }

  private 检查最终结算(): void {
    if (this.最终结算已触发 || !this.是否满足最终结算()) return;
    this.最终结算已触发 = true;
    if (this.参数.on满足最终结算 != null) this.参数.on满足最终结算(this.取成员列表());
  }

  private 登记单位映射(成员: 联合战斗成员<TData>): void {
    const id = 取单位句柄ID(成员.单位);
    if (id !== 0) this.单位到成员Key[id] = 成员.key;
  }

  private 移除单位映射(成员: 联合战斗成员<TData>): void {
    const id = 取单位句柄ID(成员.单位);
    if (id !== 0 && this.单位到成员Key[id] === 成员.key) delete this.单位到成员Key[id];
  }
}

export function 创建联合战斗成员生命周期<TData = Record<string, any>>(
  this: void,
  参数: 联合战斗成员生命周期参数<TData>,
): 联合战斗成员生命周期<TData> {
  const 实例 = new 联合战斗成员生命周期实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 + "-联合成员生命周期", function 联合战斗成员生命周期清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}
