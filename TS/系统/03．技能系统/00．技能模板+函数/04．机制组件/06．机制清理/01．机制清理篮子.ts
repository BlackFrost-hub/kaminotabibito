/** @noSelfInFile */

const jass = require("jass.common") as any;

const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => boolean;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;
const DestroyLightning = jass.DestroyLightning as (whichLightning: any) => boolean;
const RemoveRect = jass.RemoveRect as (whichRect: any) => void;
const RemoveRegion = jass.RemoveRegion as (whichRegion: any) => void;
const DestroyUbersplat = jass.DestroyUbersplat as (whichUbersplat: any) => void;

const { addDelayedCallback, removePeriodicCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  removeDelayedCallback: (this: void, id: number) => void;
};

export type 机制清理函数 = (this: void, 变量?: any) => void;

interface 清理项 {
  名称: string;
  清理: 机制清理函数;
  变量?: any;
}

export interface 机制清理篮子 {
  readonly 名称: string;
  已清理(): boolean;
  登记清理(名称: string, 清理: 机制清理函数, 变量?: any): void;
  登记周期回调(名称: string, 回调ID: number): void;
  登记延迟回调(名称: string, 回调ID: number): void;
  登记特效(名称: string, 特效: any): void;
  登记限时特效(名称: string, 特效: any, 持续毫秒: number): void;
  登记单位(名称: string, 单位: any): void;
  登记闪电(名称: string, 闪电: any): void;
  登记矩形(名称: string, 矩形: any): void;
  登记区域(名称: string, 区域: any): void;
  登记贴图(名称: string, 贴图: any): void;
  清理全部(): void;
}

class 机制清理篮子实现 implements 机制清理篮子 {
  readonly 名称: string;
  private 清理项列表: 清理项[] = [];
  private 已经清理 = false;

  constructor(名称: string) {
    this.名称 = 名称;
  }

  已清理(): boolean {
    return this.已经清理;
  }

  登记清理(名称: string, 清理: 机制清理函数, 变量?: any): void {
    if (this.已经清理 || 清理 == null) return;
    this.清理项列表.push({ 名称, 清理, 变量 });
  }

  登记周期回调(名称: string, 回调ID: number): void {
    if (回调ID == null || 回调ID === 0) return;
    this.登记清理(名称, function 机制清理篮子移除周期回调(this: void): void {
      removePeriodicCallback(回调ID);
    });
  }

  登记延迟回调(名称: string, 回调ID: number): void {
    if (回调ID == null || 回调ID === 0) return;
    this.登记清理(名称, function 机制清理篮子移除延迟回调(this: void): void {
      removeDelayedCallback(回调ID);
    });
  }

  登记特效(名称: string, 特效: any): void {
    if (特效 == null || 特效 === 0) return;
    this.登记清理(名称, function 机制清理篮子销毁特效(this: void): void {
      DestroyEffect(特效);
    });
  }

  登记限时特效(名称: string, 特效: any, 持续毫秒: number): void {
    if (特效 == null || 特效 === 0) return;
    if (!(持续毫秒 > 0)) {
      this.登记特效(名称, 特效);
      return;
    }
    let 等待销毁 = true;
    const 回调ID = addDelayedCallback(持续毫秒, function 机制清理篮子限时特效自然销毁(this: void): void {
      if (!等待销毁) return;
      等待销毁 = false;
      DestroyEffect(特效);
    });
    this.登记清理(名称, function 机制清理篮子限时特效提前销毁(this: void): void {
      if (!等待销毁) return;
      等待销毁 = false;
      removeDelayedCallback(回调ID);
      DestroyEffect(特效);
    });
  }

  登记单位(名称: string, 单位: any): void {
    if (单位 == null || 单位 === 0) return;
    this.登记清理(名称, function 机制清理篮子移除单位(this: void): void {
      RemoveUnit(单位);
    });
  }

  登记闪电(名称: string, 闪电: any): void {
    if (闪电 == null || 闪电 === 0) return;
    this.登记清理(名称, function 机制清理篮子销毁闪电(this: void): void {
      DestroyLightning(闪电);
    });
  }

  登记矩形(名称: string, 矩形: any): void {
    if (矩形 == null || 矩形 === 0) return;
    this.登记清理(名称, function 机制清理篮子移除矩形(this: void): void {
      RemoveRect(矩形);
    });
  }

  登记区域(名称: string, 区域: any): void {
    if (区域 == null || 区域 === 0) return;
    this.登记清理(名称, function 机制清理篮子移除区域(this: void): void {
      RemoveRegion(区域);
    });
  }

  登记贴图(名称: string, 贴图: any): void {
    if (贴图 == null || 贴图 === 0) return;
    this.登记清理(名称, function 机制清理篮子销毁贴图(this: void): void {
      DestroyUbersplat(贴图);
    });
  }

  清理全部(): void {
    if (this.已经清理) return;
    this.已经清理 = true;
    for (let i = this.清理项列表.length - 1; i >= 0; i--) {
      const 项 = this.清理项列表[i];
      if (项 != null && 项.清理 != null) {
        项.清理(项.变量);
      }
    }
    this.清理项列表 = [];
  }
}

export function 创建机制清理篮子(this: void, 名称: string): 机制清理篮子 {
  return new 机制清理篮子实现(名称);
}
