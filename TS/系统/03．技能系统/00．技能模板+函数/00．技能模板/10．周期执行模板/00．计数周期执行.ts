/** @noSelfInFile */

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

export interface 计数周期执行事件 {
  当前次数: number;
  最大次数: number;
  控制器: 计数周期执行控制器;
}

export interface 计数周期执行参数 {
  间隔毫秒: number;
  最大次数: number;
  on周期: (this: void, event: 计数周期执行事件) => boolean | void;
  on完成?: (this: void) => void;
  on取消?: (this: void) => void;
}

export interface 计数周期执行控制器 {
  readonly 最大次数: number;
  取消(this: void): void;
}

export function 启动计数周期执行(this: void, 参数: 计数周期执行参数): 计数周期执行控制器 | null {
  if (参数 == null || 参数.间隔毫秒 <= 0 || 参数.最大次数 <= 0 || 参数.on周期 == null) return null;

  let 当前次数 = 0;
  let timerID = 0;
  let 已结束 = false;
  const 控制器: 计数周期执行控制器 = {
    最大次数: 参数.最大次数,
    取消: function 取消计数周期执行(this: void): void {
      if (已结束) return;
      已结束 = true;
      if (timerID > 0) {
        removePeriodicCallback(timerID);
        timerID = 0;
      }
      参数.on取消?.();
    },
  };

  function 结束(this: void): void {
    if (已结束) return;
    已结束 = true;
    if (timerID > 0) {
      removePeriodicCallback(timerID);
      timerID = 0;
    }
    参数.on完成?.();
  }

  function on计数周期执行Tick(this: void): void {
    if (已结束) return;
    当前次数 += 1;
    const result = 参数.on周期({
      当前次数,
      最大次数: 参数.最大次数,
      控制器,
    });
    if (result === false) {
      控制器.取消();
      return;
    }
    if (当前次数 >= 参数.最大次数) {
      结束();
    }
  }

  timerID = addPeriodicCallback(参数.间隔毫秒, on计数周期执行Tick);
  return 控制器;
}

export {};
