/** @noSelfInFile */

export interface 控制Debuff联动事件 {
  来源单位: any;
  目标单位: any;
  类型: string;
  持续时间?: number;
  BuffID?: string;
  是否控制?: boolean;
  原始参数?: any;
}

export interface 控制Debuff联动参数 {
  名称?: string;
  单位?: any;
  监听方向?: "自己施加" | "自己受到" | "双向";
  只监听控制?: boolean;
  过滤事件?: (this: void, event: 控制Debuff联动事件) => boolean;
  on触发: (this: void, event: 控制Debuff联动事件) => void;
}

export interface 控制Debuff联动控制器 {
  readonly 名称: string;
  停止(): void;
}

const 控制Debuff联动表: Record<number, 控制Debuff联动实现> = {};
let 控制Debuff联动计数 = 0;

class 控制Debuff联动实现 implements 控制Debuff联动控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 控制Debuff联动参数;
  private 已停止 = false;

  constructor(名称: string, 参数: 控制Debuff联动参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.控制器ID = ++控制Debuff联动计数;
    控制Debuff联动表[this.控制器ID] = this;
  }

  处理(event: 控制Debuff联动事件): void {
    if (this.已停止) return;
    if (this.参数.只监听控制 === true && event.是否控制 !== true) return;
    if (!this.匹配单位(event)) return;
    if (this.参数.过滤事件 != null && !this.参数.过滤事件(event)) return;
    this.参数.on触发(event);
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 控制Debuff联动表[this.控制器ID];
  }

  private 匹配单位(event: 控制Debuff联动事件): boolean {
    if (this.参数.单位 == null) return true;
    const 方向 = this.参数.监听方向 ?? "自己施加";
    if (方向 === "自己施加") return event.来源单位 === this.参数.单位;
    if (方向 === "自己受到") return event.目标单位 === this.参数.单位;
    return event.来源单位 === this.参数.单位 || event.目标单位 === this.参数.单位;
  }
}

export function 创建控制Debuff联动(this: void, 参数: 控制Debuff联动参数): 控制Debuff联动控制器 {
  return new 控制Debuff联动实现(参数.名称 ?? "控制Debuff联动", 参数);
}

export function 通知控制Debuff事件(this: void, event: 控制Debuff联动事件): void {
  for (const key in 控制Debuff联动表) {
    const 控制器 = 控制Debuff联动表[key];
    if (控制器 != null) 控制器.处理(event);
  }
}
