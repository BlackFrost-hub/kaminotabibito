/** @noSelfInFile */
/**
 * 分批点名落点模板
 *
 * 每轮开始时重新取得目标列表，再完成“锁定坐标 -> 提示圈 -> 延迟结算”。
 * 适合追点箭雨、连续陨星、分批投枪等需要玩家持续移动的技能。
 */

import {
  创建点名预警执行器,
  type 点名预警执行结果,
  type 点名预警执行器,
} from '../../04．机制组件/10．复杂战斗通用机制/05．点名预警执行器';
import type { 技能提示圈配置 } from '../../02．通用函数/16．技能提示圈工厂';
import type { 机制清理篮子 } from '../../04．机制组件/06．机制清理/01．机制清理篮子';

const { addDelayedCallback, removeDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export interface 分批点名落点结果 extends 点名预警执行结果 {
  序号: number;
}

export interface 分批点名落点模板参数 {
  名称: string;
  清理?: 机制清理篮子;
  轮数: number;
  轮次间隔秒: number;
  预警秒: number;
  锁定坐标?: boolean;
  取目标列表: (this: void, 序号: number) => any[];
  选择目标?: (this: void, 目标列表: any[], 序号: number) => any;
  提示圈?: 技能提示圈配置 | false | ((this: void, 结果: 分批点名落点结果) => 技能提示圈配置 | false);
  on锁定?: (this: void, 结果: 分批点名落点结果) => void;
  on结算: (this: void, 结果: 分批点名落点结果) => void;
  on跳过?: (this: void, 序号: number) => void;
  on结束?: (this: void) => void;
  on取消?: (this: void) => void;
}

export interface 分批点名落点模板实例 {
  readonly 轮数: number;
  取消(): void;
}

interface 分批点名启动参数 {
  实例: 分批点名落点模板实现;
  序号: number;
}

function 默认选择分批目标(this: void, 目标列表: any[], 序号: number): any {
  if (目标列表.length <= 0) return null;
  return 目标列表[(序号 - 1) % 目标列表.length];
}

function on分批点名轮次开始(this: void, variable?: any): void {
  const 参数 = variable as 分批点名启动参数;
  if (参数 == null || 参数.实例 == null) return;
  参数.实例.开始轮次(参数.序号);
}

class 分批点名落点模板实现 implements 分批点名落点模板实例 {
  readonly 轮数: number;
  private 参数: 分批点名落点模板参数;
  private 启动回调ID列表: number[] = [];
  private 执行器列表: 点名预警执行器[] = [];
  private 已完成轮数 = 0;
  private 已结束 = false;

  constructor(参数: 分批点名落点模板参数) {
    this.参数 = 参数;
    this.轮数 = 参数.轮数 > 0 ? 参数.轮数 : 0;
    for (let i = 0; i < this.轮数; i++) {
      const 序号 = i + 1;
      const callbackId = addDelayedCallback(i * 参数.轮次间隔秒 * 1000, on分批点名轮次开始, {
        实例: this,
        序号,
      } as 分批点名启动参数);
      this.启动回调ID列表.push(callbackId);
    }
    if (this.轮数 <= 0) this.自然结束();
  }

  开始轮次(序号: number): void {
    if (this.已结束) return;
    const 目标列表 = this.参数.取目标列表(序号) ?? [];
    const 选择目标 = this.参数.选择目标 ?? 默认选择分批目标;
    const 目标 = 选择目标(目标列表, 序号);
    if (目标 == null || 目标 === 0) {
      if (this.参数.on跳过 != null) this.参数.on跳过(序号);
      this.完成一轮();
      return;
    }

    const 原提示圈 = this.参数.提示圈;
    const 实例 = this;
    const this参数 = this.参数;
    const 执行器 = 创建点名预警执行器({
      清理: this.参数.清理,
      名称: `${this.参数.名称}·第${序号}轮`,
      目标,
      延迟秒: this.参数.预警秒,
      锁定坐标: this.参数.锁定坐标,
      提示圈: 原提示圈 == null || 原提示圈 === false
        ? 原提示圈
        : function 分批点名提示圈(this: void, 结果: 点名预警执行结果): 技能提示圈配置 | false {
          const 扩展结果: 分批点名落点结果 = { ...结果, 序号 };
          return typeof 原提示圈 === 'function' ? 原提示圈(扩展结果) : 原提示圈;
        },
      on锁定: function 分批点名锁定(this: void, 结果: 点名预警执行结果): void {
        if (this参数.on锁定 != null) this参数.on锁定({ ...结果, 序号 });
      },
      on结算: function 分批点名结算(this: void, 结果: 点名预警执行结果): void {
        if (实例.已结束) return;
        this参数.on结算({ ...结果, 序号 });
        实例.完成一轮();
      },
    });
    this.执行器列表.push(执行器);
  }

  取消(): void {
    if (this.已结束) return;
    this.已结束 = true;
    for (let i = 0; i < this.启动回调ID列表.length; i++) {
      const callbackId = this.启动回调ID列表[i];
      if (callbackId != null && callbackId !== 0) removeDelayedCallback(callbackId);
    }
    for (let i = 0; i < this.执行器列表.length; i++) {
      const 执行器 = this.执行器列表[i];
      if (执行器 != null) 执行器.取消();
    }
    if (this.参数.on取消 != null) this.参数.on取消();
  }

  private 完成一轮(): void {
    if (this.已结束) return;
    this.已完成轮数 += 1;
    if (this.已完成轮数 >= this.轮数) this.自然结束();
  }

  private 自然结束(): void {
    if (this.已结束) return;
    this.已结束 = true;
    if (this.参数.on结束 != null) this.参数.on结束();
  }
}

export function 开始分批点名落点模板(this: void, 参数: 分批点名落点模板参数): 分批点名落点模板实例 {
  const 实例 = new 分批点名落点模板实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 分批点名落点模板清理(this: void): void {
      实例.取消();
    });
  }
  return 实例;
}
