/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

export interface 延迟去重批处理队列<T> {
  readonly 名称: string;
  加入(this: void, key: number | string, 上下文: T): void;
  清空(this: void): void;
}

export interface 延迟去重批处理队列选项<T> {
  延迟毫秒: number;
  处理: (this: void, 上下文: T, key: string) => void;
}

export function 创建延迟去重批处理队列<T>(this: void, 名称: string, 选项: 延迟去重批处理队列选项<T>): 延迟去重批处理队列<T> {
  const 队列表: Record<string, T | undefined> = {};
  let 已安排处理 = false;
  const 延迟毫秒 = 选项.延迟毫秒 > 0 ? 选项.延迟毫秒 : 0;

  function 清空队列表(this: void): void {
    for (const key in 队列表) {
      delete 队列表[key];
    }
  }

  function 执行批处理(this: void): void {
    已安排处理 = false;
    for (const key in 队列表) {
      const 上下文 = 队列表[key];
      if (上下文 == null) continue;
      选项.处理(上下文, key);
    }
    清空队列表();
  }

  return {
    名称,
    加入: function 加入(this: void, key: number | string, 上下文: T): void {
      const keyText = String(key);
      if (keyText === "") return;
      队列表[keyText] = 上下文;
      if (已安排处理) return;
      已安排处理 = true;
      addDelayedCallback(延迟毫秒, 执行批处理);
    },
    清空: function 清空(this: void): void {
      清空队列表();
      已安排处理 = false;
    },
  };
}

export {};
