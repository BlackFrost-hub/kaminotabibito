/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import { 创建次数型伤害免疫 } from "./08．次数型伤害免疫";
import type { 次数型伤害免疫控制器, 次数型伤害免疫事件 } from "./08．次数型伤害免疫";
import { 创建伤害生命下限保护 } from "./09．伤害生命下限保护";
import type { 伤害生命下限保护控制器 } from "./09．伤害生命下限保护";

const { addDelayedCallback, removeDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

export interface 致命伤害保命事件 {
  单位: any;
  攻击者: any;
  触发前生命: number;
  保留生命: number;
  被免疫致命伤害: number;
  免疫持续秒: number;
  上下文: any;
  控制器: 致命伤害保命与限时免疫控制器;
}

export interface 致命伤害保命与限时免疫参数 {
  名称?: string;
  单位: any;
  固定生命下限?: number;
  最大生命比例下限?: number;
  免疫持续秒: number;
  生命下限修正优先级?: number;
  免疫修正优先级?: number;
  清理?: 机制清理篮子;
  过滤致命伤害?: (this: void, context: any) => boolean;
  过滤免疫伤害?: (this: void, context: any) => boolean;
  取生命下限?: (this: void, 单位: any, context?: any) => number;
  on触发?: (this: void, event: 致命伤害保命事件) => void;
  on免疫抵挡?: (this: void, event: 次数型伤害免疫事件) => void;
  on免疫结束?: (this: void, 单位: any) => void;
}

export interface 致命伤害保命与限时免疫控制器 {
  readonly 名称: string;
  是否生效(): boolean;
  是否免疫中(): boolean;
  读取生命下限(): number;
  读取免疫剩余毫秒(): number;
  停止(): void;
}

interface 致命伤害免疫到期参数 {
  控制器: 致命伤害保命与限时免疫实现;
  截止时间Ms: number;
}

class 致命伤害保命与限时免疫实现 implements 致命伤害保命与限时免疫控制器 {
  readonly 名称: string;
  private readonly 参数: 致命伤害保命与限时免疫参数;
  private readonly 生命下限保护: 伤害生命下限保护控制器;
  private readonly 伤害免疫: 次数型伤害免疫控制器;
  private 免疫截止时间Ms = 0;
  private 免疫结束回调ID = 0;
  private 已停止 = false;

  constructor(参数: 致命伤害保命与限时免疫参数) {
    this.参数 = 参数;
    this.名称 = 参数.名称 ?? "致命伤害保命与限时免疫";
    const self = this;
    const 生命下限优先级 = 参数.生命下限修正优先级 ?? -100;
    this.伤害免疫 = 创建次数型伤害免疫({
      名称: `${this.名称}-限时免疫`,
      单位: 参数.单位,
      免疫类型: "任意伤害",
      无限次数: true,
      永久: true,
      修正优先级: 参数.免疫修正优先级 ?? (生命下限优先级 + 1),
      过滤伤害: function 致命保命限时免疫过滤(this: void, context: any): boolean {
        if (!self.是否免疫中()) return false;
        return 参数.过滤免疫伤害 == null || 参数.过滤免疫伤害(context);
      },
      on抵挡: function 致命保命限时免疫抵挡(this: void, event: 次数型伤害免疫事件): void {
        if (参数.on免疫抵挡 != null) 参数.on免疫抵挡(event);
      },
    });
    const 默认固定下限 = 参数.固定生命下限 == null
      && 参数.最大生命比例下限 == null
      && 参数.取生命下限 == null
      ? 1
      : 参数.固定生命下限;
    this.生命下限保护 = 创建伤害生命下限保护({
      名称: `${this.名称}-生命下限`,
      单位: 参数.单位,
      固定生命下限: 默认固定下限,
      最大生命比例下限: 参数.最大生命比例下限,
      修正优先级: 生命下限优先级,
      离开下限后重置触底: true,
      过滤伤害: 参数.过滤致命伤害,
      取生命下限: 参数.取生命下限,
      伤害预处理: function 致命保命伤害预处理(this: void, context: any, 当前伤害: number): number {
        return self.处理致命伤害(context, 当前伤害);
      },
    });
    if (参数.清理 != null) {
      参数.清理.登记清理(`${this.名称}-清理`, function 致命保命组合清理(this: void): void {
        self.停止();
      });
    }
  }

  是否生效(): boolean {
    return !this.已停止;
  }

  是否免疫中(): boolean {
    return !this.已停止 && this.免疫截止时间Ms > getServerTime();
  }

  读取生命下限(): number {
    return this.生命下限保护.读取生命下限();
  }

  读取免疫剩余毫秒(): number {
    if (!this.是否免疫中()) return 0;
    const 剩余 = this.免疫截止时间Ms - getServerTime();
    return 剩余 > 0 ? 剩余 : 0;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.清除免疫结束回调();
    this.免疫截止时间Ms = 0;
    this.生命下限保护.停止();
    this.伤害免疫.取消("清理");
  }

  处理免疫到期(截止时间Ms: number): void {
    if (this.已停止 || this.免疫截止时间Ms !== 截止时间Ms) return;
    this.免疫结束回调ID = 0;
    this.免疫截止时间Ms = 0;
    if (this.参数.on免疫结束 != null) this.参数.on免疫结束(this.参数.单位);
  }

  private 处理致命伤害(context: any, 当前伤害: number): number {
    if (this.已停止 || !(当前伤害 > 0)) return 当前伤害;
    const 当前生命 = GetUnitState(this.参数.单位, UNIT_STATE_LIFE);
    if (!(当前生命 > 0) || 当前伤害 < 当前生命) return 当前伤害;

    let 保留生命 = this.生命下限保护.读取生命下限();
    if (保留生命 < 0) 保留生命 = 0;
    if (保留生命 > 当前生命) 保留生命 = 当前生命;
    SetUnitState(this.参数.单位, UNIT_STATE_LIFE, 保留生命);
    this.启动限时免疫();
    if (this.参数.on触发 != null) {
      this.参数.on触发({
        单位: this.参数.单位,
        攻击者: context.attacker,
        触发前生命: 当前生命,
        保留生命,
        被免疫致命伤害: 当前伤害,
        免疫持续秒: this.参数.免疫持续秒,
        上下文: context,
        控制器: this,
      });
    }
    return 0;
  }

  private 启动限时免疫(): void {
    const 持续秒 = this.参数.免疫持续秒;
    if (!(持续秒 > 0)) {
      this.免疫截止时间Ms = 0;
      return;
    }
    this.清除免疫结束回调();
    const 截止时间Ms = getServerTime() + 持续秒 * 1000;
    this.免疫截止时间Ms = 截止时间Ms;
    const 到期参数: 致命伤害免疫到期参数 = { 控制器: this, 截止时间Ms };
    this.免疫结束回调ID = addDelayedCallback(持续秒 * 1000, on致命伤害免疫到期, 到期参数);
  }

  private 清除免疫结束回调(): void {
    if (this.免疫结束回调ID === 0) return;
    removeDelayedCallback(this.免疫结束回调ID);
    this.免疫结束回调ID = 0;
  }
}

function on致命伤害免疫到期(this: void, variable?: any): void {
  const 参数 = variable as 致命伤害免疫到期参数;
  if (参数 == null || 参数.控制器 == null) return;
  参数.控制器.处理免疫到期(参数.截止时间Ms);
}

export function 创建致命伤害保命与限时免疫(
  this: void,
  参数: 致命伤害保命与限时免疫参数,
): 致命伤害保命与限时免疫控制器 {
  return new 致命伤害保命与限时免疫实现(参数);
}

export {};
