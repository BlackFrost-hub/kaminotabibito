/** @noSelfInFile */

import { 创建血量节点触发器, 血量节点触发器 } from "../08．机制触发/01．血量节点触发器";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

export interface 阶段定义 {
  ID: string;
  /** 低于等于该血量百分比时进入此阶段；初始阶段不用填。 */
  血量百分比?: number;
  on进入?: (this: void, 上下文: 阶段上下文, 当前百分比: number) => void;
}

export interface 阶段上下文参数 {
  清理?: 机制清理篮子;
  名称: string;
  单位: any;
  初始阶段ID: string;
  阶段列表: 阶段定义[];
  Tick间隔毫秒?: number;
  on阶段变化?: (this: void, 阶段ID: string, 旧阶段ID: string, 当前百分比: number) => void;
}

export interface 阶段上下文 {
  readonly 单位: any;
  取阶段ID(): string;
  是阶段(阶段ID: string): boolean;
  手动进入阶段(阶段ID: string, 当前百分比?: number): boolean;
  销毁(): void;
}

class 阶段上下文实现 implements 阶段上下文 {
  readonly 单位: any;
  private 参数: 阶段上下文参数;
  private 当前阶段ID: string;
  private 阶段表: Record<string, 阶段定义 | undefined> = {};
  private 触发器?: 血量节点触发器;
  private 已销毁 = false;

  constructor(参数: 阶段上下文参数) {
    this.参数 = 参数;
    this.单位 = 参数.单位;
    this.当前阶段ID = 参数.初始阶段ID;
    for (let i = 0; i < 参数.阶段列表.length; i++) {
      const 阶段 = 参数.阶段列表[i];
      this.阶段表[阶段.ID] = 阶段;
    }
    this.创建血量触发器();
  }

  取阶段ID(): string {
    return this.当前阶段ID;
  }

  是阶段(阶段ID: string): boolean {
    return this.当前阶段ID === 阶段ID;
  }

  手动进入阶段(阶段ID: string, 当前百分比: number = 1): boolean {
    if (this.已销毁 || 阶段ID === "" || 阶段ID === this.当前阶段ID) return false;
    const 阶段 = this.阶段表[阶段ID];
    if (阶段 == null) return false;
    const 旧阶段ID = this.当前阶段ID;
    this.当前阶段ID = 阶段ID;
    if (this.参数.on阶段变化 != null) this.参数.on阶段变化(阶段ID, 旧阶段ID, 当前百分比);
    if (阶段.on进入 != null) 阶段.on进入(this, 当前百分比);
    return true;
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    if (this.触发器 != null) this.触发器.停止();
  }

  private 创建血量触发器(): void {
    const 节点列表: Array<{ ID: string; 百分比: number; on触发: (this: void, 单位: any, 当前百分比: number) => void }> = [];
    for (let i = 0; i < this.参数.阶段列表.length; i++) {
      const 阶段 = this.参数.阶段列表[i];
      if (阶段.血量百分比 == null) continue;
      const self = this;
      节点列表.push({
        ID: 阶段.ID,
        百分比: 阶段.血量百分比,
        on触发: function 阶段血量节点触发(this: void, _单位: any, 当前百分比: number): void {
          self.手动进入阶段(阶段.ID, 当前百分比);
        },
      });
    }
    if (节点列表.length <= 0) return;
    this.触发器 = 创建血量节点触发器({
      清理: this.参数.清理,
      名称: this.参数.名称 + "-阶段节点",
      单位: this.参数.单位,
      节点列表,
      Tick间隔毫秒: this.参数.Tick间隔毫秒,
    });
  }
}

export function 创建阶段上下文(this: void, 参数: 阶段上下文参数): 阶段上下文 {
  const 上下文 = new 阶段上下文实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 + "-阶段上下文", function 阶段上下文清理(this: void): void {
      上下文.销毁();
    });
  }
  return 上下文;
}
